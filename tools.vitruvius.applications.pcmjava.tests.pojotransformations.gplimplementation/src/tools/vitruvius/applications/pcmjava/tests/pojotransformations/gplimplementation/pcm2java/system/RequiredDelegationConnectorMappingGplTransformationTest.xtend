package tools.vitruvius.applications.pcmjava.tests.pojotransformations.gplimplementation.pcm2java.system

import tools.vitruvius.applications.pcmjava.tests.pojotransformations.pcm2java.system.RequiredDelegationConnectorMappingTransformationTest

class RequiredDelegationConnectorMappingGplTransformationTest extends RequiredDelegationConnectorMappingTransformationTest {
	override protected createChange2CommandTransformingProviding() {
		Change2CommandTransformingProvidingFactory.createPcm2JavaGplImplementationTransformingProviding();
	}
}