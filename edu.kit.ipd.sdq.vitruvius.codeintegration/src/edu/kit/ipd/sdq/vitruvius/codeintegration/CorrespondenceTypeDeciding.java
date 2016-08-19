package edu.kit.ipd.sdq.vitruvius.codeintegration;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CorrespondenceModel;

public interface CorrespondenceTypeDeciding {

    String ID = "edu.kit.ipd.sdq.vitruvius.codeintegration.correspondencetypedeciding";

    default boolean useIntegratedCorrespondence(final EObject objectA, final EObject objectB,
            final CorrespondenceModel cInstance, final List<Resource> jaMoppResources) {
        return true;
    }
}
