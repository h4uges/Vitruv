package tools.vitruv.dsls.commonalities.generator.reactions.condition

import com.google.inject.Inject
import java.util.function.Function
import org.eclipse.xtext.xbase.XExpression
import tools.vitruv.dsls.commonalities.generator.reactions.condition.ParticipationConditionOperatorHelper.ParticipationConditionOperatorContext
import tools.vitruv.dsls.commonalities.generator.reactions.helper.ReactionsGenerationHelper
import tools.vitruv.dsls.commonalities.language.ParticipationCondition
import tools.vitruv.dsls.commonalities.participation.ParticipationContext
import tools.vitruv.dsls.commonalities.participation.ParticipationContext.ContextClass
import tools.vitruv.dsls.reactions.builder.TypeProvider

import static extension tools.vitruv.dsls.commonalities.language.extensions.CommonalitiesLanguageModelExtensions.*

class ParticipationConditionInitializationHelper extends ReactionsGenerationHelper {

	@Inject extension ParticipationConditionOperatorHelper participationConditionOperatorHelper

	package new() {
	}

	def getParticipationConditionsInitializers(ParticipationContext participationContext, ContextClass contextClass) {
		val participation = participationContext.participation
		val participationClass = contextClass.participationClass
		return participation.conditions
			.filter[!isContainment] // containments are handled separately
			.filter[enforced]
			.filter[leftOperand.participationClass == participationClass]
			.filter [
				// Exclude conditions whose operands refer to participation
				// classes that are not involved in the current participation
				// context:
				rightOperands.map[it.participationClass].filterNull.forall [ operandParticipationClass |
					participationContext.classes.exists [
						it.participationClass == operandParticipationClass
					]
				]
			].map[participationConditionInitializer]
	}

	private def Function<TypeProvider, XExpression> getParticipationConditionInitializer(
		ParticipationCondition participationCondition) {
		return [ extension TypeProvider typeProvider |
			val operatorContext = new ParticipationConditionOperatorContext(typeProvider)
			return participationCondition.enforce(operatorContext)
		]
	}
}
