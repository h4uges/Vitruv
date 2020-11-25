package tools.vitruv.dsls.mappings.addressesXrecipients.tests

import edu.kit.ipd.sdq.metamodels.addresses.Addresses
import edu.kit.ipd.sdq.metamodels.recipients.Recipients
import mir.reactions.adXre_R2L.AdXre_R2LChangePropagationSpecification
import org.junit.jupiter.api.Test
import tools.vitruv.testutils.VitruvApplicationTest

import static org.hamcrest.MatcherAssert.assertThat
import static tools.vitruv.dsls.mappings.addressesXrecipients.tests.AddressesCreators.*
import static tools.vitruv.dsls.mappings.addressesXrecipients.tests.AddressesXRecipientsTestConstants.*
import static tools.vitruv.dsls.mappings.addressesXrecipients.tests.RecipientsCreators.*
import static tools.vitruv.testutils.matchers.ModelMatchers.contains
import static tools.vitruv.testutils.matchers.ModelMatchers.doesNotExist
import static tools.vitruv.testutils.matchers.ModelMatchers.equalsDeeply
import static tools.vitruv.testutils.matchers.ModelMatchers.ignoringFeatures

import static extension org.eclipse.emf.ecore.util.EcoreUtil.remove
import static extension tools.vitruv.testutils.matchers.CorrespondenceMatchers.hasNoCorrespondences
import static extension tools.vitruv.testutils.matchers.CorrespondenceMatchers.hasOneCorrespondence

class AddressesXRecipientsR2LTest extends VitruvApplicationTest {
	override protected getChangePropagationSpecifications() {
		#[new AdXre_R2LChangePropagationSpecification()]
	}

	@Test
	def void createRoot() {
		createAndSynchronizeModel(RECIPIENTS_MODEL, newRecipients)
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses, ignoringFeatures('id')))
		assertThat(Recipients.from(RECIPIENTS_MODEL),
			hasOneCorrespondence(equalsDeeply(Addresses.from(ADDRESSES_MODEL))))
	}

	@Test
	def void createAndDeleteRoot() {
		createRoot()
		Recipients.from(RECIPIENTS_MODEL).record[remove()]
		saveAndSynchronizeChanges(RECIPIENTS_MODEL)
		assertThat(resourceAt(RECIPIENTS_MODEL), doesNotExist)
		assertThat(resourceAt(ADDRESSES_MODEL), doesNotExist)
	}

	@Test
	def void createChild() {
		createRoot()

		val recipient = newRecipient => [business = true]
		saveAndSynchronizeChanges(Recipients.from(RECIPIENTS_MODEL).record[recipients += recipient])
		assertThat(recipient, hasNoCorrespondences)

		// "initial recipient model" (see Table 7.5 in dx.doi.org/10.5445/IR/1000069284)
		val location = newLocation
		saveAndSynchronizeChanges(recipient.record[locatedAt = location])
		assertThat(recipient, hasNoCorrespondences)
		assertThat(location, hasNoCorrespondences)
		saveAndSynchronizeChanges(location.record[number = TEST_NUMBER])
		assertThat(recipient, hasNoCorrespondences)
		assertThat(location, hasNoCorrespondences)
		saveAndSynchronizeChanges(location.record[street = TEST_STREET])
		assertThat(recipient, hasNoCorrespondences)
		assertThat(location, hasNoCorrespondences)

		// "recipient model after 2nd change" (Table 7.5)
		val city = newCity
		saveAndSynchronizeChanges(recipient.record[locatedIn = city])
		assertThat(recipient, hasNoCorrespondences)
		assertThat(city, hasNoCorrespondences)

		// "recipient model after 3rd change" (Table 7.5)
		saveAndSynchronizeChanges(city.record[zipCode = TEST_ZIP_CODE])
		val expectedAddress = newAddress => [
			street = TEST_STREET
			number = TEST_NUMBER
			zipCode = TEST_ZIP_CODE
		]
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses => [addresses += expectedAddress]))
		assertThat(recipient, hasOneCorrespondence(equalsDeeply(expectedAddress)))
		assertThat(location, hasOneCorrespondence(equalsDeeply(expectedAddress)))
		assertThat(city, hasOneCorrespondence(equalsDeeply(expectedAddress)))
	}

	@Test
	def void createAndDeleteChild() {
		createChild()
		saveAndSynchronizeChanges(Recipients.from(RECIPIENTS_MODEL).record [
			recipients.get(0).remove()
		])
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses))
	}

	@Test
	def void createAndDeleteGrandChild1() {
		createChild()
		saveAndSynchronizeChanges(Recipients.from(RECIPIENTS_MODEL).record [
			recipients.get(0).locatedAt.remove()
		])
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses))
	}

	@Test
	def void createAndDeleteGrandChild2() {
		createChild()
		saveAndSynchronizeChanges(Recipients.from(RECIPIENTS_MODEL).record [
			recipients.get(0).locatedIn.remove()
		])
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses))
	}

	@Test
	def void createAndModifyChildNumber() {
		createChild()
		val recipient = Recipients.from(RECIPIENTS_MODEL).recipients.get(0)
		saveAndSynchronizeChanges(recipient.record [
			locatedAt.number = TEST_NUMBER * 2
		])
		assertThat(recipient, hasOneCorrespondence(equalsDeeply(newAddress => [
			street = TEST_STREET
			number = TEST_NUMBER * 2
			zipCode = TEST_ZIP_CODE
		], ignoringFeatures('parent'))))

		saveAndSynchronizeChanges(recipient.record [
			locatedAt.number = -TEST_NUMBER
		])
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses))
	}

	@Test
	def void createAndModifyChildZipCode() {
		createChild()
		val recipient = Recipients.from(RECIPIENTS_MODEL).recipients.get(0)
		saveAndSynchronizeChanges(recipient.record [
			locatedIn.zipCode = TEST_ZIP_CODE + TEST_ZIP_CODE
		])
		assertThat(recipient, hasOneCorrespondence(equalsDeeply(newAddress => [
			street = TEST_STREET
			number = TEST_NUMBER
			zipCode = TEST_ZIP_CODE + TEST_ZIP_CODE
		], ignoringFeatures('parent'))))

		saveAndSynchronizeChanges(recipient.record [
			locatedAt.number = -TEST_NUMBER
		])
		assertThat(resourceAt(ADDRESSES_MODEL), contains(newAddresses))
	}
}
