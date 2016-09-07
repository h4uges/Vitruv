package tools.vitruvius.applications.jmljava.tests.plugintests;

import org.junit.Test;

import tools.vitruvius.applications.jmljava.changesynchronizer.ChangeSynchronizerRegistry;
import tools.vitruvius.applications.jmljava.changesynchronizer.ModelUtilities;
import tools.vitruvius.applications.jmljava.changesynchronizer.ChangeBuilder;
import tools.vitruvius.domains.jml.language.jML.IdentifierHaving;
import tools.vitruvius.domains.jml.language.jML.JMLPackage;
import tools.vitruvius.domains.jml.language.jML.VariableDeclarator;
import tools.vitruvius.framework.change.description.VitruviusChange;

public class RenameGhostFieldTest extends FrameworkTestBase {

	@Test
	public void testNameClashWithJML() throws Exception {
		performTest("Checksum.jml", "Checksum", "_initialized", "_algorithm", true);
	}
	
	@Test
	public void testNameClashWithJava() throws Exception {
		performTest("Checksum.jml", "Checksum", "_initialized", "ALG_ISO3309_CRC16", true);
	}
	
	@Test
	public void testUsedInSpec() throws Exception {
		performTest("Checksum.jml", "Checksum", "_initialized", "_initialized2", false);
	}
	
	private void performTest(final String fileName, final String typeName, final String fieldName, final String newName, boolean abortExpected) throws Exception {
		VariableDeclarator vd = projectModelUtils.getField(fileName, typeName, fieldName);
		
        IdentifierHaving oldElement = ModelUtilities.clone(vd);
        IdentifierHaving newElement = ModelUtilities.clone(vd);
        newElement.setIdentifier(newName);
        
        Change change = ChangeBuilder.createUpdateChange(oldElement, newElement,
                JMLPackage.eINSTANCE.getIdentifierHaving_Identifier());
        ChangeSynchronizerRegistry.getInstance().getChangeSynchronizer().synchronizeChange(change);
        
        waitForSynchronisationToFinish();
        
        if (abortExpected) {
        	assertTransformationAborted();
        } else {
        	final String testMethodName = Thread.currentThread().getStackTrace()[2].getMethodName();
        	createAndCompareDiff(testMethodName);
        }
	}
}
