package tools.vitruvius.applications.pcmjava.linkingintegration.change2command

import tools.vitruvius.framework.change.processing.impl.AbstractChangeProcessor
import tools.vitruvius.framework.userinteraction.UserInteracting
import tools.vitruvius.framework.change.description.ConcreteChange
import tools.vitruvius.framework.correspondence.CorrespondenceModel
import java.util.ArrayList
import tools.vitruvius.framework.change.echange.EChange
import tools.vitruvius.framework.change.description.VitruviusChangeFactory
import tools.vitruvius.framework.change.processing.ChangeProcessorResult
import tools.vitruvius.applications.pcmjava.linkingintegration.change2command.internal.IntegrationChange2CommandTransformer
import tools.vitruvius.framework.util.command.VitruviusRecordingCommand

class CodeIntegrationChangeProcessor extends AbstractChangeProcessor {
	private val IntegrationChange2CommandTransformer integrationTransformer;
	
	new(UserInteracting userInteracting) {
		super(userInteracting);
		this.integrationTransformer = new IntegrationChange2CommandTransformer(getUserInteracting());
	}
	
	override transformChange(ConcreteChange change, CorrespondenceModel correspondenceModel) {
		val nonIntegratedEChanges = new ArrayList<EChange>();
		val commands = new ArrayList<VitruviusRecordingCommand>();
		for (eChange : change.getEChanges) {
			// Special behavior for changes to integrated elements
			val integrationTransformResult = integrationTransformer.compute(eChange, correspondenceModel);
        	if (integrationTransformResult.isIntegrationChange()) {
        		commands += integrationTransformResult.getCommands();
			} else {
				nonIntegratedEChanges += eChange;
			}
		}
		val resultingChange = if (nonIntegratedEChanges.isEmpty) {
			VitruviusChangeFactory.instance.createEmptyChange(change.getURI);
		} else {
			VitruviusChangeFactory.instance.createGeneralChange(nonIntegratedEChanges, change.getURI);
		}
		
		return new ChangeProcessorResult(resultingChange, commands);
	}
	
}
