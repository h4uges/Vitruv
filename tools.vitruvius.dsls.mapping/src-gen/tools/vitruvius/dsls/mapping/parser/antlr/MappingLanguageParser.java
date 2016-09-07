/*
 * generated by Xtext 2.9.2
 */
package tools.vitruvius.dsls.mapping.parser.antlr;

import com.google.inject.Inject;
import tools.vitruvius.dsls.mapping.parser.antlr.internal.InternalMappingLanguageParser;
import tools.vitruvius.dsls.mapping.services.MappingLanguageGrammarAccess;
import org.eclipse.xtext.parser.antlr.AbstractAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;

public class MappingLanguageParser extends AbstractAntlrParser {

	@Inject
	private MappingLanguageGrammarAccess grammarAccess;

	@Override
	protected void setInitialHiddenTokens(XtextTokenStream tokenStream) {
		tokenStream.setInitialHiddenTokens("RULE_WS", "RULE_SL_COMMENT");
	}
	

	@Override
	protected InternalMappingLanguageParser createParser(XtextTokenStream stream) {
		return new InternalMappingLanguageParser(stream, getGrammarAccess());
	}

	@Override 
	protected String getDefaultRuleName() {
		return "MappingFile";
	}

	public MappingLanguageGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}

	public void setGrammarAccess(MappingLanguageGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
}
