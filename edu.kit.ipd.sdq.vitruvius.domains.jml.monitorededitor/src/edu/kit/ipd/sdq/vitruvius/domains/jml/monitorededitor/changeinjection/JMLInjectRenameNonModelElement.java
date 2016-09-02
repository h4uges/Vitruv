package edu.kit.ipd.sdq.vitruvius.domains.jml.monitorededitor.changeinjection;

import java.util.ArrayList;
import java.util.List;

import edu.kit.ipd.sdq.vitruvius.domains.jml.language.jML.CompilationUnit;
import edu.kit.ipd.sdq.vitruvius.domains.jml.language.jML.JMLSpecifiedElement;
import edu.kit.ipd.sdq.vitruvius.domains.jml.language.jML.MemberDeclWithModifier;
import edu.kit.ipd.sdq.vitruvius.domains.jml.language.jML.MemberDeclaration;
import edu.kit.ipd.sdq.vitruvius.domains.jml.monitorededitor.ModelUtilities;
import edu.kit.ipd.sdq.vitruvius.domains.jml.monitorededitor.changeinjection.Choice.EObjectToString;

/**
 * JML change injector for rename operations on non model members.
 */
public class JMLInjectRenameNonModelElement extends JMLInjectRenameMemberBase {

    @Override
    protected MemberDeclWithModifier getMemberToRename(CompilationUnit cu) {
        List<JMLSpecifiedElement> elements = new ArrayList<JMLSpecifiedElement>(ModelUtilities.getChildrenOfType(cu,
                JMLSpecifiedElement.class, true));

        JMLSpecifiedElement element = Choice.chooseFromEObjects(elements, new EObjectToString<JMLSpecifiedElement>() {
            @Override
            public String getTitle(JMLSpecifiedElement obj) {
                MemberDeclaration tmp = ((MemberDeclaration) obj.getElement().getMemberdecl());
                if (tmp.getField() != null) {
                    return tmp.getField().getVariabledeclarator().get(0).getIdentifier();
                } else {
                    return tmp.getMethod().getIdentifier();
                }
            }
        });
        
        if (element == null) {
            return null;
        }
        return element.getElement();
    }

}