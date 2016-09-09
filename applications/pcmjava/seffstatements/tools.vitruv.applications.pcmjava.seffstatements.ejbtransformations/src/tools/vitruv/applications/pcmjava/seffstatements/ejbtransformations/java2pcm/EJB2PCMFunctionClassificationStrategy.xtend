package tools.vitruv.applications.pcmjava.seffstatements.ejbtransformations.java2pcm

import tools.vitruv.applications.pcmjava.seffstatements.code2seff.BasicComponentFinding
import tools.vitruv.framework.correspondence.CorrespondenceModelUtil
import java.util.Set
import org.apache.log4j.Logger
import org.emftext.language.java.members.ClassMethod
import org.emftext.language.java.members.Method
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.OperationSignature
import org.somox.gast2seff.visitors.AbstractFunctionClassificationStrategy
import org.somox.gast2seff.visitors.MethodCallFinder
import tools.vitruv.applications.pcmjava.util.java2pcm.JaMoPP2PCMUtils
import tools.vitruv.framework.correspondence.CorrespondenceModel

class EJB2PCMFunctionClassificationStrategy extends AbstractFunctionClassificationStrategy {
	
	private static val Logger logger = Logger.getLogger(EJB2PCMFunctionClassificationStrategy.name)
	
	private final BasicComponentFinding basicComponentFinding
	private final CorrespondenceModel correspondenceModel
	private final BasicComponent basicComponent

	new(BasicComponentFinding basicComponentFinding, CorrespondenceModel correspondenceModel,
		BasicComponent basicComponent) {
		super(new MethodCallFinder())
		this.basicComponentFinding = basicComponentFinding
		this.correspondenceModel = correspondenceModel
		this.basicComponent = basicComponent
	}

    //copied from  FunctionClassificationStrategyForPackageMapping
	override protected boolean isExternalCall(Method method) {
		if (!JaMoPP2PCMUtils.normalizeURI(method)) {
            logger.info("Could not normalize URI for method " + method
                    + ". Method call is not considered as as external call");
            return false;
        }
        if (!JaMoPP2PCMUtils.normalizeURI(method)) {
            logger.info("Could not normalize URI for method " + method
                    + ". Method call is not considered as as external call");
            return false;
        }
        val Set<OperationSignature> correspondingSignatures = CorrespondenceModelUtil
                .getCorrespondingEObjectsByType(this.correspondenceModel, method, OperationSignature);
        if (null != correspondingSignatures && !correspondingSignatures.isEmpty()) {
            return true;
        }
        if (method instanceof ClassMethod) {
            val BasicComponent basicComponent = this.basicComponentFinding.findBasicComponentForMethod(method,
                    this.correspondenceModel);
            if (null == basicComponent || basicComponent.getId().equals(this.basicComponent.getId())) {
                return false;
            }
            return true;
        }
        return false;
	}

	//copied from  FunctionClassificationStrategyForPackageMapping
	override protected boolean isLibraryCall(Method method) {
		 val basicComponentOfMethod = this.basicComponentFinding.findBasicComponentForMethod(method,
                this.correspondenceModel);
        if (null == basicComponentOfMethod) {
            return true;
        }
        if (basicComponentOfMethod.getId().equals(this.basicComponent.getId())) {
            return false;
        }
        logger.warn("The destination of a call to the method " + method
                + " is another component than the source component. This should not happen in isLibraryCall.");
        return true;
	}
}