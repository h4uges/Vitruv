package tools.vitruv.framework.vsum.modelsynchronization

import java.util.ArrayList
import java.util.Collections
import java.util.List
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.change.processing.ChangePropagationSpecification
import tools.vitruv.framework.change.processing.ChangePropagationSpecificationProvider
import tools.vitruv.framework.domains.repository.VitruvDomainRepository
import tools.vitruv.framework.change.processing.ChangePropagationObserver
import tools.vitruv.framework.change.description.PropagatedChange
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.vsum.repositories.ModelRepositoryImpl
import tools.vitruv.framework.vsum.ModelRepository
import tools.vitruv.framework.uuid.UuidResolver
import tools.vitruv.framework.change.description.CompositeChange

import tools.vitruv.framework.change.description.CompositeTransactionalChange
import tools.vitruv.framework.correspondence.CorrespondencePackage
import tools.vitruv.framework.change.description.ConcreteChange
import tools.vitruv.framework.userinteraction.InternalUserInteractor
import tools.vitruv.framework.userinteraction.UserInteractionListener
import tools.vitruv.framework.change.interaction.UserInteractionBase
import tools.vitruv.framework.userinteraction.UserInteractionFactory
import static com.google.common.base.Preconditions.checkState
import tools.vitruv.framework.correspondence.CorrespondenceModel

class ChangePropagatorImpl implements ChangePropagationObserver, UserInteractionListener {
	static Logger logger = Logger.getLogger(ChangePropagatorImpl)
	final VitruvDomainRepository metamodelRepository
	final ModelRepository resourceRepository
	final ChangePropagationSpecificationProvider changePropagationProvider
	final ModelRepositoryImpl modelRepository
	final List<EObject> objectsCreatedDuringPropagation
	final CorrespondenceModel correspondenceModel
	final List<UserInteractionBase> userInteractions
	final InternalUserInteractor userInteractor

	new(ModelRepository resourceRepository, ChangePropagationSpecificationProvider changePropagationProvider,
		VitruvDomainRepository metamodelRepository, ModelRepositoryImpl modelRepository,
		CorrespondenceModel correspondenceModel, InternalUserInteractor userInteractor) {
		this.resourceRepository = resourceRepository
		this.modelRepository = modelRepository
		this.changePropagationProvider = changePropagationProvider
		changePropagationProvider.forEach[it.registerObserver(this)]
		this.userInteractions = Collections.synchronizedList(newArrayList)
		this.metamodelRepository = metamodelRepository
		this.objectsCreatedDuringPropagation = newArrayList
		this.correspondenceModel = correspondenceModel
		this.userInteractor = userInteractor
		userInteractor.registerUserInputListener(this)
	}

	def synchronized List<PropagatedChange> propagateChange(VitruviusChange change) {
		val List<PropagatedChange> changePropagationResult = new ArrayList
		val changedResourcesTracker = new ChangedResourcesTracker()
		for (transactionalChange : change.transactionalChangeSequence) {
			changePropagationResult += applyAndPropagateSingleChange(transactionalChange, changedResourcesTracker)
		}
		handleObjectsWithoutResource()
		changedResourcesTracker.markNonSourceResourceAsChanged()
		return changePropagationResult
	}

	private def List<PropagatedChange> applyAndPropagateSingleChange(
		TransactionalChange change,
		ChangedResourcesTracker changedResourcesTracker
	) {
		this.resourceRepository.executeOnUuidResolver [ UuidResolver uuidResolver |
			change.resolveBeforeAndApplyForward(uuidResolver)
			// If change has a URI, add the model to the repository
			if(change.URI !== null) resourceRepository.getModel(change.getURI())
			change.affectedEObjects.forEach[modelRepository.addRootElement(it)]
			return
		]
		modelRepository.cleanupRootElements

		val changedObjects = change.affectedEObjects
		checkState(!changedObjects.nullOrEmpty, "There are no objects affected by the given changes")

		return propagateSingleChange(change, changedResourcesTracker)
	}

	private def List<PropagatedChange> propagateSingleChange(
		TransactionalChange change,
		ChangedResourcesTracker changedResourcesTracker
	) {
		val consequentialChanges = newArrayList

		// retrieve user inputs from past changes, construct a UserInteractor which tries to reuse them:
		val pastUserInputsFromChange = change.userInteractions

		val AutoCloseable userInteractorChange = if (!pastUserInputsFromChange.nullOrEmpty) {
				userInteractor.replaceUserInteractionResultProvider [ currentProvider |
					UserInteractionFactory.instance.createPredefinedInteractionResultProvider(currentProvider,
						pastUserInputsFromChange)
				]
			} else
				[]

		// modelRepository.startRecording
		resourceRepository.startRecording
		for (propagationSpecification : changePropagationProvider.
			getChangePropagationSpecifications(change.changeDomain)) {
			propagateChangeForChangePropagationSpecification(change, propagationSpecification, changedResourcesTracker)
		}
		// consequentialChanges += modelRepository.endRecording()
		consequentialChanges += resourceRepository.endRecording()
		consequentialChanges.forEach[logger.trace('''Change generated by change propagation:\n «it»''')]

		userInteractorChange.close()
		change.userInteractions = newArrayList(userInteractions)
		userInteractions.clear

		val propagatedChange = new PropagatedChange(change,
			VitruviusChangeFactory.instance.createCompositeChange(consequentialChanges))
		val resultingChanges = new ArrayList()
		resultingChanges += propagatedChange

		val consequentialChangesToRePropagate = propagatedChange.consequentialChanges.transactionalChangeSequence.map [
			rewrapWithoutCorrespondenceChanges
		].filterNull.filter[containsConcreteChange].filter[changeDomain.shouldTransitivelyPropagateChanges]

		for (changeToPropagate : consequentialChangesToRePropagate) {
			resultingChanges += propagateSingleChange(changeToPropagate, changedResourcesTracker)
		}

		return resultingChanges
	}

	private def dispatch TransactionalChange rewrapWithoutCorrespondenceChanges(CompositeTransactionalChange change) {
		val newChange = VitruviusChangeFactory.instance.createCompositeTransactionalChange()
		change.changes.map[rewrapWithoutCorrespondenceChanges].filterNull.forEach[newChange.addChange(it)]
		return newChange
	}

	private def dispatch TransactionalChange rewrapWithoutCorrespondenceChanges(ConcreteChange change) {
		return if(!change.affectedEObjects.exists[isInCorrespondenceModel]) change else null
	}

	private def dispatch TransactionalChange rewrapWithoutCorrespondenceChanges(TransactionalChange change) {
		return change
	}

	private def boolean isInCorrespondenceModel(EObject object) {
		val typeAndSuperTypes = Collections.singletonList(object.eClass) + object.eClass.EAllSuperTypes
		return typeAndSuperTypes.exists[EPackage === CorrespondencePackage.eINSTANCE]
	}

	def private dispatch Iterable<TransactionalChange> getTransactionalChangeSequence(
		CompositeTransactionalChange composite) {
		if (composite.containsConcreteChange) {
			return Collections.singleton(composite)
		} else {
			return Collections.emptyList
		}
	}

	def private dispatch Iterable<TransactionalChange> getTransactionalChangeSequence(CompositeChange<?> composite) {
		composite.changes.flatMap[transactionalChangeSequence]
	}

	def private dispatch Iterable<TransactionalChange> getTransactionalChangeSequence(
		TransactionalChange transactionalChange) {
		if (transactionalChange.containsConcreteChange) {
			return Collections.singleton(transactionalChange)
		} else {
			return Collections.emptyList
		}
	}

	def private getChangeDomain(VitruviusChange change) {
		val resolvedObjects = change.affectedEObjects.filter[!eIsProxy]
		metamodelRepository.getDomain(resolvedObjects.head)
	}

	private def void handleObjectsWithoutResource() {
		modelRepository.cleanupRootElementsWithoutResource
		// Find created objects without resource
		for (createdObjectWithoutResource : objectsCreatedDuringPropagation.filter[eResource === null]) {
			val hasCorrespondence = correspondenceModel.hasCorrespondences(List.of(createdObjectWithoutResource))
			checkState(
				!hasCorrespondence, '''Every object must be contained within a resource: «createdObjectWithoutResource»''')
			logger.warn("Object was created but has no correspondence and is thus lost: " +
				createdObjectWithoutResource)
		}
		objectsCreatedDuringPropagation.clear()
	}

	private def void propagateChangeForChangePropagationSpecification(TransactionalChange change,
		ChangePropagationSpecification propagationSpecification, ChangedResourcesTracker changedResourcesTracker) {

		// TODO HK: Clone the changes for each synchronization! Should even be cloned for
		// each consistency repair routines that uses it,
		// or: make them read only, i.e. give them a read-only interface!
		val changedEObjects = resourceRepository.executeAsCommand [
			propagationSpecification.propagateChange(change, correspondenceModel, resourceRepository)
			modelRepository.cleanupRootElements()
		].affectedObjects.filter(EObject)

		// Store modification information
		changedEObjects.forEach[changedResourcesTracker.addInvolvedModelResource(it.eResource)]
		changedResourcesTracker.addSourceResourceOfChange(change)
	}

	override synchronized objectCreated(EObject createdObject) {
		this.objectsCreatedDuringPropagation += createdObject
		this.modelRepository.addRootElement(createdObject)
	}

	override onUserInteractionReceived(UserInteractionBase interaction) {
		userInteractions.add(interaction)
	}
}
