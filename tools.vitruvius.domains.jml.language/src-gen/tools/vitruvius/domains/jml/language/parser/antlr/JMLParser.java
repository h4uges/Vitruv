/*
 * generated by Xtext
 */
package tools.vitruvius.domains.jml.language.parser.antlr;

import com.google.inject.Inject;

import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import tools.vitruvius.domains.jml.language.services.JMLGrammarAccess;

public class JMLParser extends org.eclipse.xtext.parser.antlr.AbstractAntlrParser {
	
	@Inject
	private JMLGrammarAccess grammarAccess;
	
	@Override
	protected void setInitialHiddenTokens(XtextTokenStream tokenStream) {
		tokenStream.setInitialHiddenTokens("RULE_WS", "RULE_ML_COMMENT", "RULE_SL_COMMENT");
	}
	
	@Override
	protected tools.vitruvius.domains.jml.language.parser.antlr.internal.InternalJMLParser createParser(XtextTokenStream stream) {
		return new tools.vitruvius.domains.jml.language.parser.antlr.internal.InternalJMLParser(stream, getGrammarAccess());
	}
	
	@Override 
	protected String getDefaultRuleName() {
		return "CompilationUnit";
	}
	
	public JMLGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}
	
	public void setGrammarAccess(JMLGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
	
}
