package tools.vitruv.framework.domains

import org.eclipse.emf.ecore.resource.Resource
import tools.vitruv.framework.change.description.CompositeChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.uuid.UuidGeneratorAndResolver

/** 
 * Strategy for resolving state-based delta changes to individual change sequences.
 */
interface StateChangePropagationStrategy {
	/**
	 * Resolves the state-based delta of two resources and returns the correlating change sequences.
	 * @param newState is the new state of the resource.
	 * @param currentState is the current or old state of the resource.
	 * @return a {@link CompositeChange} that contains the individual change sequences.
	 */
	def CompositeChange<VitruviusChange> getChangeSequences(Resource newState, Resource currentState, UuidGeneratorAndResolver uuidGeneratorAndResolver)
}