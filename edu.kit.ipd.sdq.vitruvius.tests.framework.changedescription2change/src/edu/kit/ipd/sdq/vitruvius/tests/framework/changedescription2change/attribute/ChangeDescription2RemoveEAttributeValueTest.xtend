package edu.kit.ipd.sdq.vitruvius.tests.framework.changedescription2change.attribute

import edu.kit.ipd.sdq.vitruvius.tests.framework.changedescription2change.ChangeDescription2ChangeTransformationTest
import org.junit.Test

import static extension edu.kit.ipd.sdq.vitruvius.tests.framework.changedescription2change.util.ChangeAssertHelper.*

class ChangeDescription2RemoveEAttributeValueTest extends ChangeDescription2ChangeTransformationTest {

	@Test
	def public testUnsetRemoveEAttributeValue() {
		this.rootElement.multiValuedEAttribute.add(42)
		// test
		startRecording

		// unset 
		this.rootElement.eUnset(this.rootElement.getFeautreByName(MULTI_VALUE_E_ATTRIBUTE_NAME))

		val changes = getChanges()
		val subtractiveChanges = changes.assertExplicitUnset
		subtractiveChanges.assertRemoveEAttribute(this.rootElement, MULTI_VALUE_E_ATTRIBUTE_NAME, 42, 0)
	}

	@Test
	def public testRemoveEAttributeValue() {
		this.rootElement.multiValuedEAttribute.add(42)
		// test
		startRecording

		// set to default/clear
		this.rootElement.multiValuedEAttribute.remove(0)

		val changes = getChanges()
		changes.assertRemoveEAttribute(this.rootElement, MULTI_VALUE_E_ATTRIBUTE_NAME, 42, 0)
	}
	
	@Test
	def public testClearEAttributeValue() {
		this.rootElement.multiValuedEAttribute.add(42)
		// test
		startRecording

		// set to default/clear
		this.rootElement.multiValuedEAttribute.clear

		val changes = getChanges()
		changes.assertRemoveEAttribute(this.rootElement, MULTI_VALUE_E_ATTRIBUTE_NAME, 42, 0)
	}

}
