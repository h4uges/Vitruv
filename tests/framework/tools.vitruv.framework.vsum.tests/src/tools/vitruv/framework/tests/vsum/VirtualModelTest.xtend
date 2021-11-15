package tools.vitruv.framework.tests.vsum

import java.nio.file.Path
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import tools.vitruv.framework.change.echange.eobject.CreateEObject
import tools.vitruv.framework.change.echange.feature.attribute.ReplaceSingleValuedEAttribute
import tools.vitruv.framework.change.echange.feature.reference.ReplaceSingleValuedEReference
import tools.vitruv.framework.change.echange.root.InsertRootEObject
import tools.vitruv.framework.change.recording.ChangeRecorder
import tools.vitruv.framework.tests.vsum.VirtualModelTestUtil.RedundancyChangePropagationSpecification
import tools.vitruv.testutils.TestProject
import tools.vitruv.testutils.TestProjectManager

import static org.hamcrest.MatcherAssert.assertThat
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertNotEquals
import static org.junit.jupiter.api.Assertions.assertNull
import static tools.vitruv.framework.tests.vsum.VirtualModelTestUtil.*
import static tools.vitruv.testutils.matchers.ModelMatchers.containsModelOf
import static tools.vitruv.testutils.metamodels.AllElementTypesCreators.aet

import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource.ResourceSetUtil.withGlobalFactories
import static extension tools.vitruv.framework.correspondence.CorrespondenceModelUtil.getCorrespondingEObjects
import static extension tools.vitruv.framework.tests.vsum.VirtualModelTestUtil.createTestModelResourceUri

@ExtendWith(TestProjectManager)
class VirtualModelTest {
	var Path projectFolder

	@BeforeEach
	def void initializeProjectFolder(@TestProject Path projectFolder) {
		this.projectFolder = projectFolder
	}

	@Test
	@DisplayName("propagate a simple change into a virtual model")
	def void propagateIntoVirtualModel() {
		val virtualModel = createAndLoadTestVirtualModel(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val monitoredResource = resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += aet.Root => [
				id = 'root'
			]
		]
		val recordedChange = changeRecorder.endRecording
		virtualModel.propagateChange(recordedChange)
		val vsumModel = virtualModel.getModelInstance(projectFolder.createTestModelResourceUri(""))
		assertThat(vsumModel.resource, containsModelOf(monitoredResource))
	}

	@Test
	@DisplayName("propagate a simple change into a virtual model and preserve consistency")
	def void propagateIntoVirtualModelWithConsistency() {
		val virtualModel = createAndLoadTestVirtualModelWithConsistencyPreservation(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val monitoredResource = resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += aet.Root => [
				id = 'root'
			]
		]
		val recordedChange = changeRecorder.endRecording
		virtualModel.propagateChange(recordedChange)
		val sorceModel = virtualModel.getModelInstance(projectFolder.createTestModelResourceUri(""))
		val targetModel = virtualModel.getModelInstance(
			RedundancyChangePropagationSpecification.getTargetResourceUri(projectFolder.createTestModelResourceUri("")))
		assertThat(targetModel.resource, containsModelOf(monitoredResource))
		assertEquals(1,
			virtualModel.correspondenceModel.getCorrespondingEObjects(sorceModel.resource.contents.get(0)).size)
	}

	@Test
	@DisplayName("persist element as resource root also contained in other persisted element")
	def void singleChangeForRootElementInMultipleResource() {
		val virtualModel = createAndLoadTestVirtualModelWithConsistencyPreservation(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val containedRoot = aet.Root
		resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += aet.Root => [
				id = 'root'
				recursiveRoot = containedRoot => [
					id = 'containedRoot'
				]
			]
		]
		resourceSet.createResource(projectFolder.createTestModelResourceUri("Contained")) => [
			contents += containedRoot
		]
		val recordedChange = changeRecorder.endRecording
		val propagatedChanges = virtualModel.propagateChange(recordedChange)
		val consequentialChanges = propagatedChanges.map[consequentialChanges.EChanges].flatten
		assertEquals(2, consequentialChanges.filter(CreateEObject).size)
		assertEquals(2, consequentialChanges.filter(InsertRootEObject).size)
		assertEquals(1, consequentialChanges.filter(ReplaceSingleValuedEReference).size)
		assertEquals(2, consequentialChanges.filter(ReplaceSingleValuedEAttribute).size)
		assertEquals(7, consequentialChanges.size)
	}

	@Test
	@DisplayName("add element to containment of element persisted in two resources")
	def void singleChangeForElementContainedInRootElementInMultipleResource() {
		val virtualModel = createAndLoadTestVirtualModelWithConsistencyPreservation(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val containedRoot = aet.Root
		val containedInContainedRoot = aet.Root
		resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += aet.Root => [
				id = 'root'
				recursiveRoot = containedRoot => [
					id = 'containedRoot'
					recursiveRoot = containedInContainedRoot => [
						id = 'containedInContained'
					]
				]
			]
		]
		resourceSet.createResource(projectFolder.createTestModelResourceUri("Contained")) => [
			contents += containedRoot
		]
		resourceSet.createResource(projectFolder.createTestModelResourceUri("ContainedInContained")) => [
			contents += containedInContainedRoot
		]
		val recordedChange = changeRecorder.endRecording
		val propagatedChanges = virtualModel.propagateChange(recordedChange)
		val consequentialChanges = propagatedChanges.map[consequentialChanges.EChanges].flatten
		assertEquals(3, consequentialChanges.filter(CreateEObject).size)
		assertEquals(3, consequentialChanges.filter(InsertRootEObject).size)
		assertEquals(2, consequentialChanges.filter(ReplaceSingleValuedEReference).size)
		assertEquals(3, consequentialChanges.filter(ReplaceSingleValuedEAttribute).size)
		assertEquals(11, consequentialChanges.size)
	}

	@Test
	@DisplayName("load resource that should have been saved after propagating a change into a virtual model")
	def void savedVirtualModel() {
		val virtualModel = createAndLoadTestVirtualModel(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val monitoredResource = resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += aet.Root => [
				id = 'root'
			]
		]
		val recordedChange = changeRecorder.endRecording
		virtualModel.propagateChange(recordedChange)
		val reloadedResource = new ResourceSetImpl().withGlobalFactories.getResource(projectFolder.createTestModelResourceUri(""),
			true)
		assertThat(reloadedResource, containsModelOf(monitoredResource))
	}

	@Test
	@DisplayName("reload a virtual model to which a simple change was propagated")
	def void reloadVirtualModel() {
		val virtualModel = createAndLoadTestVirtualModel(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val root = aet.Root
		val monitoredResource = resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += root => [
				id = 'root'
			]
		]
		val recordedChange = changeRecorder.endRecording
		virtualModel.propagateChange(recordedChange)
		val originalModel = virtualModel.getModelInstance(projectFolder.createTestModelResourceUri(""))
		val reloadedVirtualModel = createAndLoadTestVirtualModel(projectFolder.resolve("vsum"))
		val reloadedModel = reloadedVirtualModel.getModelInstance(projectFolder.createTestModelResourceUri(""))
		assertThat(reloadedModel.resource, containsModelOf(monitoredResource))
		assertNotEquals(originalModel, reloadedModel)
		// Propagate another change to reloaded virtual model to ensure that everything is loaded correctly
		changeRecorder.beginRecording
		root.singleValuedEAttribute = 1
		val secondRecordedChange = changeRecorder.endRecording
		val propagatedChange = reloadedVirtualModel.propagateChange(secondRecordedChange)
		assertEquals(1, propagatedChange.size)
	}

	@Test
	@DisplayName("reload a virtual model with consistency preservation to which a simple change was propagated")
	def void reloadVirtualModelWithConsistency() {
		val virtualModel = createAndLoadTestVirtualModelWithConsistencyPreservation(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val root = aet.Root
		val monitoredResource = resourceSet.createResource(projectFolder.createTestModelResourceUri("")) => [
			contents += root => [
				id = 'root'
			]
		]
		val recordedChange = changeRecorder.endRecording
		virtualModel.propagateChange(recordedChange)
		val originalModel = virtualModel.getModelInstance(projectFolder.createTestModelResourceUri(""))
		val reloadedVirtualModel = createAndLoadTestVirtualModel(projectFolder.resolve("vsum"))
		val reloadedModel = reloadedVirtualModel.getModelInstance(projectFolder.createTestModelResourceUri(""))
		assertThat(reloadedModel.resource, containsModelOf(monitoredResource))
		assertNotEquals(originalModel, reloadedModel)
		val reloadedTargetModel = reloadedVirtualModel.getModelInstance(
			RedundancyChangePropagationSpecification.getTargetResourceUri(projectFolder.createTestModelResourceUri("")))
		assertThat(reloadedTargetModel.resource, containsModelOf(monitoredResource))
		assertEquals(1, reloadedVirtualModel.correspondenceModel.getCorrespondingEObjects(reloadedModel.resource.contents.get(0)).size)
	}

	@Test
	@DisplayName("move element such that corresponding element is moved from one resource to another and back")
	def void moveCorrespondingToOtherResourceAndBack() {
		val virtualModel = createAndLoadTestVirtualModelWithConsistencyPreservation(projectFolder.resolve("vsum"))
		val resourceSet = new ResourceSetImpl().withGlobalFactories
		val changeRecorder = new ChangeRecorder(resourceSet)
		changeRecorder.addToRecording(resourceSet)
		changeRecorder.beginRecording
		val root = aet.Root
		val testUri = projectFolder.createTestModelResourceUri("")
		val monitoredResource = resourceSet.createResource(testUri) => [
			contents += root => [
				id = 'root'
			]
		]
		virtualModel.propagateChange(changeRecorder.endRecording)
		changeRecorder.beginRecording
		val testIntermediateUri = projectFolder.createTestModelResourceUri("intermediate")
		resourceSet.createResource(testIntermediateUri) => [
			contents += root
		]
		virtualModel.propagateChange(changeRecorder.endRecording)
		// There must not be the old and the old corresponding model
		assertNull(virtualModel.getModelInstance(testUri))
		assertNull(virtualModel.getModelInstance(RedundancyChangePropagationSpecification.getTargetResourceUri(testUri)))
		changeRecorder.beginRecording
		monitoredResource => [
			contents += root
		]
		virtualModel.propagateChange(changeRecorder.endRecording)
		assertNull(virtualModel.getModelInstance(testIntermediateUri))
		assertNull(virtualModel.getModelInstance(RedundancyChangePropagationSpecification.getTargetResourceUri(testIntermediateUri)))
	}

}
