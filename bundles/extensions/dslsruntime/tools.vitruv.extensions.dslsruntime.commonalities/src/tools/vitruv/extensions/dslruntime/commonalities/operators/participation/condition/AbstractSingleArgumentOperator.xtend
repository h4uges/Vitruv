package tools.vitruv.extensions.dslruntime.commonalities.operators.participation.condition

import com.google.common.base.Preconditions
import java.util.List

abstract class AbstractSingleArgumentOperator extends AbstractParticipationConditionOperator {

	new(Object leftOperand, List<Object> rightOperands) {
		super(leftOperand, rightOperands)
		Preconditions.checkArgument(!rightOperands.empty, "Missing right operand!")
		Preconditions.checkArgument(rightOperands.size == 1, "Too many right operands!")
	}

	protected def getRightOperand() {
		return rightOperands.head
	}
}
