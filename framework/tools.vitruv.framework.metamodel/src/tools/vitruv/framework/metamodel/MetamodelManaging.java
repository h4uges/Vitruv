package tools.vitruv.framework.metamodel;

import tools.vitruv.framework.metamodel.Metamodel;
import tools.vitruv.framework.util.datatypes.VURI;

public interface MetamodelManaging {
    void addMetamodel(Metamodel metamodel);

    Metamodel getMetamodel(VURI mmURI);

    Metamodel getMetamodel(String fileExtension);

    Metamodel[] getAllMetamodels();

    // TODO decide whether MetamodelManaging.remove(String uri) is needed
}