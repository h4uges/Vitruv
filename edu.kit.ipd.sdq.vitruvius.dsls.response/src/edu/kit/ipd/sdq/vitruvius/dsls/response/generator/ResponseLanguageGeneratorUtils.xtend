package edu.kit.ipd.sdq.vitruvius.dsls.response.generator

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.Pair
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.Response
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.Trigger
import edu.kit.ipd.sdq.vitruvius.dsls.response.helper.XtendImportHelper
import org.eclipse.emf.ecore.EPackage
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ArbitraryModelElementChange
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ConcreteTargetModelRootChange
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ArbitraryTargetMetamodelInstanceUpdate
import static extension edu.kit.ipd.sdq.vitruvius.dsls.response.helper.ResponseLanguageHelper.*;
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.AtomicFeatureChange
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.AtomicRootObjectChange
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ConcreteTargetModelRootCreate
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.AtomicConcreteModelElementChange
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguageFactory
import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MirBaseFactory
import edu.kit.ipd.sdq.vitruvius.dsls.response.generator.impl.SimpleTextXBlockExpression
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.MultiValuedFeatureInsertChange
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.InsertRootChange

final class ResponseLanguageGeneratorUtils {
	private static val FSA_SEPARATOR = "/";
	private static val XTEND_FILE_EXTENSION = ".xtend";
	private static val RESPONSES_PACKAGE = "responses";
	
	private new() {}
	
	private static def getFilePath(String qualifiedClassName) '''
		«qualifiedClassName.replace('.', FSA_SEPARATOR)»«XTEND_FILE_EXTENSION»'''
	
	static def String getBasicResponsesPackageQualifiedName() '''
		«RESPONSES_PACKAGE»'''
	
	static def String getMetamodelPairName(Response response) {
		return response.sourceTargetPair?.metamodelPairName;
	}
	
	static def String getMetamodelPairName(Pair<VURI, VURI> modelPair) '''
		«IF modelPair.first.lastSegment.nullOrEmpty»«modelPair.first.EMFUri.toString.split("\\.").last.toFirstUpper»«ELSE»«modelPair.first.lastSegment.split("\\.").get(0).toFirstUpper»«ENDIF»To«
		IF modelPair.second.lastSegment.nullOrEmpty»«modelPair.second.EMFUri.toString.split("\\.").last.toFirstUpper»«ELSE»«modelPair.second.lastSegment.split("\\.").get(0).toFirstUpper»«ENDIF»'''
	
	static def String getPackageName(Pair<VURI, VURI> modelPair) '''
		responses«modelPair.metamodelPairName»'''
	
	static def String getPackageQualifiedName(Pair<VURI, VURI> modelPair) '''
		«RESPONSES_PACKAGE».«modelPair.packageName»'''
		
	static def String getChange2CommandTransformingProvidingName() '''
		ResponseChange2CommandTransformingProviding'''
		
	static def String getChange2CommandTransformingProvidingQualifiedName() '''
		«RESPONSES_PACKAGE».«change2CommandTransformingProvidingName»'''
		
	static def String getChange2CommandTransformingProvidingFilePath() '''
		«change2CommandTransformingProvidingQualifiedName.filePath»'''
			
	static def String getExecutorName(Pair<VURI, VURI> modelPair) '''
		Response«modelPair.metamodelPairName»Executor'''
		
	static def String getExecutorQualifiedName(Pair<VURI, VURI> modelPair) '''
		«modelPair.packageQualifiedName».«modelPair.executorName»'''
	
	static def String getExecutorFilePath(Pair<VURI, VURI> modelPair) '''
		«modelPair.executorQualifiedName.filePath»'''
	
	static def String getChange2CommandTransformingName(Pair<VURI, VURI> modelPair) '''
		Response«modelPair.metamodelPairName»Change2CommandTransforming'''
		
	static def String getChange2CommandTransformingQualifiedName(Pair<VURI, VURI> modelPair) '''
		«modelPair.packageQualifiedName».«modelPair.change2CommandTransformingName»'''
	
	static def String getChange2CommandTransformingFilePath(Pair<VURI, VURI> modelPair) '''
		«modelPair.change2CommandTransformingQualifiedName.filePath»'''
	
	static def String getResponseQualifiedName(Response response) '''
		«response.sourceTargetPair?.packageQualifiedName».«response.responseName»'''
	
	static def String getResponseFilePath(Response response) '''
		«response.getResponseQualifiedName().filePath»'''
	
	static def generateClass(String packageName, XtendImportHelper importHelper, CharSequence classImplementation) '''
		package «packageName»;
		
		«importHelper.generateImportCode»
		
		«classImplementation»
		'''

	static def Pair<VURI, VURI> getSourceTargetPair(Response response) {
		val event = response.trigger;
		var EPackage sourceMetamodel = event.sourceMetamodel;
		
		if (sourceMetamodel != null) {
			val sourceURI = sourceMetamodel.nsURI;
			val targetChange = response.effects.targetChange;
			var targetURI = sourceMetamodel.nsURI;
			if (targetChange instanceof ConcreteTargetModelRootChange) {
				targetURI = targetChange.rootModelElement?.element?.EPackage?.nsURI?:sourceMetamodel.nsURI;
			} else if (targetChange instanceof ArbitraryTargetMetamodelInstanceUpdate) {
				targetURI = targetChange.metamodelReference?.model?.package?.nsURI?:sourceMetamodel.nsURI;
			}
			val source = VURI.getInstance(sourceURI);
			var target = VURI.getInstance(targetURI);
			val sourceTargetPair = new Pair<VURI, VURI>(source, target);
			return sourceTargetPair
		}
		return null;		
	}
	
	static def String getResponseName(Response response) {
		if (!response.name.nullOrEmpty) {
			return response.name + "Response";
		} else {
			return '''«response.trigger.responseNameForEvent»Response'''
		}
	}
	
	static def dispatch String getResponseNameForEvent(Trigger trigger) {
		throw new UnsupportedOperationException("Response name fragment is not defined for this event type.")
	}
	
	static def dispatch String getResponseNameForEvent(AtomicRootObjectChange change) {
		return '''«change.class.simpleName»Of«change.changedElement?.element?.name?.toFirstUpper»'''
	}
	
	static def dispatch String getResponseNameForEvent(AtomicFeatureChange change) {
		return '''«change.class.simpleName»Of«IF change.changedFeature?.feature != null»«
			change.changedFeature.feature.name.toFirstUpper»In«ENDIF»«change.changedFeature?.element?.name?.toFirstUpper»'''
	}
	
	static def dispatch String getResponseNameForEvent(ArbitraryModelElementChange event) {
		return '''«event.class.simpleName»In«IF event.changedModel?.model?.name != null»«
			event.changedModel.model.name.toFirstUpper»«ENDIF»'''
	}
	
	static def boolean hasOppositeResponse(Response response) {
		val sourceChange = response.trigger;
		val targetChange = response.effects.targetChange;
		if (targetChange instanceof ConcreteTargetModelRootCreate && 
			sourceChange instanceof AtomicConcreteModelElementChange) {
			val createTargetChange = targetChange as ConcreteTargetModelRootCreate;
			if (createTargetChange.autodelete) {
				return true;
			}
		}
		return false;
	}
	
	static def Response getOppositeResponse(Response response) {
		if (response.hasOppositeResponse) {
			val deleteTrigger = response.trigger.deleteTrigger;
			val createTargetChange = response.effects.targetChange as ConcreteTargetModelRootCreate;
			val deleteResponse = ResponseLanguageFactory.eINSTANCE.createResponse();
			deleteResponse.name = "OppositeResponseForDeleteTo" + response.name;
			deleteResponse.trigger = deleteTrigger;
			val deleteEffects = ResponseLanguageFactory.eINSTANCE.createEffects();
			val deleteTargetChange = ResponseLanguageFactory.eINSTANCE.createConcreteTargetModelRootDelete();
			val targetChangeElement = MirBaseFactory.eINSTANCE.createModelElement();
			targetChangeElement.element = createTargetChange.rootModelElement.element;
			deleteTargetChange.rootModelElement = targetChangeElement;
			deleteTargetChange.correspondenceSource = ResponseLanguageFactory.eINSTANCE.createCorrespondenceSourceDeterminationBlock();
			deleteTargetChange.correspondenceSource.code = new SimpleTextXBlockExpression('''return change.getOldValue();''');
			deleteEffects.targetChange = deleteTargetChange;
			deleteResponse.effects = deleteEffects;
			return deleteResponse;
		}
		return null;
	}
	  
	private static def dispatch Trigger getDeleteTrigger(Trigger change) {
		return null;
	}
	
	private static def dispatch Trigger getDeleteTrigger(MultiValuedFeatureInsertChange change) {
		val deleteTrigger = ResponseLanguageFactory.eINSTANCE.createMultiValuedFeatureRemoveChange();
		val changedElement = MirBaseFactory.eINSTANCE.createFeatureOfElement();
		changedElement.element = change.changedFeature.element;
		changedElement.feature = change.changedFeature.feature;
		deleteTrigger.changedFeature = changedElement;
		return deleteTrigger;
	}
	
	private static def dispatch Trigger getDeleteTrigger(InsertRootChange change) {
		val deleteTrigger = ResponseLanguageFactory.eINSTANCE.createRemoveRootChange();
		val changedElement = MirBaseFactory.eINSTANCE.createModelElement();
		changedElement.element = change.changedElement.element;
		deleteTrigger.changedElement = changedElement;
		return deleteTrigger;
	}
}