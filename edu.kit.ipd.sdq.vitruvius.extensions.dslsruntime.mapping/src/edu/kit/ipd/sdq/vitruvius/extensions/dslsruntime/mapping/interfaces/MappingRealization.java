package edu.kit.ipd.sdq.vitruvius.extensions.dslsruntime.mapping.interfaces;

import edu.kit.ipd.sdq.vitruvius.extensions.dslsruntime.mapping.MappingExecutionState;
import edu.kit.ipd.sdq.vitruvius.framework.change.echange.EChange;
import edu.kit.ipd.sdq.vitruvius.framework.modelsynchronization.blackboard.Blackboard;

/**
 * Represents a MIR mapping. Concrete implementations are generated by
 * {@link MIRCodeGenerator}.
 * @author Dominik Werle
 *
 */
public interface MappingRealization {
	/**
	 * Applies the mapping.
	 * @param eChange
	 * @param correspondenceModel
	 */
	@Deprecated
	public default void applyEChange(EChange eChange, Blackboard blackboard, MappingExecutionState state) {
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Returns an ID that is unique for all mapping realizations.
	 * @return
	 */
	public String getMappingID();
}
