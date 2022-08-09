package tools.vitruv.testutils

import java.nio.file.Path
import org.eclipse.xtend.lib.annotations.Delegate
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.^extension.ExtendWith
import tools.vitruv.change.propagation.ChangePropagationSpecification

import tools.vitruv.testutils.views.UriMode
import tools.vitruv.testutils.views.TestView
import tools.vitruv.testutils.views.ChangePublishingTestView

@ExtendWith(TestLogging, TestProjectManager)
abstract class VitruvApplicationTest implements VirtualModelBasedTestView {
	@Delegate
	VirtualModelBasedTestView testView

	/**
	 * Determines the {@link ChangePropagationSpecification}s to be used in this test.
	 */
	def protected abstract Iterable<? extends ChangePropagationSpecification> getChangePropagationSpecifications()

	/**
	 * Determines which {@link UriMode} should be used for this test.
	 */
	def protected UriMode getUriMode() { UriMode.FILE_URIS }

	@BeforeEach
	def final void initialize(@TestProject Path testProjectPath, @TestProject(variant="vsum") Path vsumPath) {
		testView = new DefaultVirtualModelBasedTestView(testProjectPath, vsumPath,
			changePropagationSpecifications, uriMode)
	}

	def package TestView generateTestView(Path testProjectPath, TestUserInteraction userInteraction) {
		new ChangePublishingTestView(testProjectPath, userInteraction, this.uriMode, virtualModel)
	}

	@AfterEach
	def final void closeAfterTest() {
		testView.close()
	}

}
