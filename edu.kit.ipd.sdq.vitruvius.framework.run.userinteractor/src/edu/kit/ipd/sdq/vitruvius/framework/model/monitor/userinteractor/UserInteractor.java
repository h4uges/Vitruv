package edu.kit.ipd.sdq.vitruvius.framework.model.monitor.userinteractor;

import javax.swing.JOptionPane;

import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.PlatformUI;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.ModelInstance;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.UserInteractionType;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.UserInteracting;

/**
 * @author messinger
 *
 *         Implements {@link UserInteracting} and decouples {@link UserInteractorDialog} from
 *         Platform.
 *
 */
public class UserInteractor implements UserInteracting {

    private static final String VITRUVIUS_TEXT_INPUT_DIALOG = "Vitruvius Text Input Dialog";
    protected Display display;
    protected Shell shell;

    public UserInteractor() {
        this.init();
    }

    public void init() {
        this.display = PlatformUI.getWorkbench().getDisplay();
        this.shell = null;
    }

    @Override
    public void showMessage(final UserInteractionType type, final String message) {
        this.display.syncExec(new Runnable() {
            @Override
            public void run() {
                switch (type) {
                case MODAL:
                case MODAL_POSTPONABLE:
                    // showMessage is not postponable
                    UserInteractorDialog.showMessage(UserInteractor.this.shell, true, message);
                    break;
                case MODELESS:
                    UserInteractorDialog.showMessage(UserInteractor.this.shell, false, message);
                    break;
                default:
                    break;
                }
            }
        });
    }

    @Override
    public int selectFromMessage(final UserInteractionType type, final String message,
            final String... selectionDescriptions) {
        final int[] result = new int[1];
        this.display.syncExec(new Runnable() {

            @Override
            public void run() {
                switch (type) {
                case MODAL:
                    result[0] = UserInteractorDialog.selectFromMessage(UserInteractor.this.shell, true, false, message,
                            selectionDescriptions);
                    break;
                case MODAL_POSTPONABLE:
                    result[0] = UserInteractorDialog.selectFromMessage(UserInteractor.this.shell, true, true, message,
                            selectionDescriptions);
                    break;
                case MODELESS:
                    result[0] = UserInteractorDialog.selectFromMessage(UserInteractor.this.shell, false, false, message,
                            selectionDescriptions);
                    break;
                default:
                    result[0] = -1;
                    break;
                }
            }
        });
        return result[0];
    }

    @Override
    public String getTextInput(final String msg) {
        final String textInput = JOptionPane.showInputDialog(null, msg, VITRUVIUS_TEXT_INPUT_DIALOG,
                JOptionPane.OK_OPTION);
        return textInput;
    }

    @Override
    public int selectFromModel(final UserInteractionType type, final String message,
            final ModelInstance... modelInstances) {
        // TODO Auto-generated method stub
        return 0;
    }

}
