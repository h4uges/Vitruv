package edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.ModelInstance;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.UserInteractionType;

public interface UserInteracting {
    void showMessage(UserInteractionType type, String message);

    int selectFromMessage(UserInteractionType type, String message, String... selectionDescriptions);

    int selectFromModel(UserInteractionType type, String message, ModelInstance... modelInstances);

    String getTextInput(String msg);
}
