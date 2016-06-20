package mir.routines.pcm2java;

import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.AbstractEffectRealization;
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.ResponseExecutionState;
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.structure.CallHierarchyHaving;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.containment.DeleteNonRootEObjectInList;
import java.io.IOException;
import mir.routines.pcm2java.RoutinesFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.members.ClassMethod;
import org.palladiosimulator.pcm.seff.ResourceDemandingInternalBehaviour;

@SuppressWarnings("all")
public class RemovedResourceDemandingInternalBehaviorEffect extends AbstractEffectRealization {
  public RemovedResourceDemandingInternalBehaviorEffect(final ResponseExecutionState responseExecutionState, final CallHierarchyHaving calledBy) {
    super(responseExecutionState, calledBy);
  }
  
  private DeleteNonRootEObjectInList<ResourceDemandingInternalBehaviour> change;
  
  private boolean isChangeSet;
  
  public void setChange(final DeleteNonRootEObjectInList<ResourceDemandingInternalBehaviour> change) {
    this.change = change;
    this.isChangeSet = true;
  }
  
  private EObject getElement0(final DeleteNonRootEObjectInList<ResourceDemandingInternalBehaviour> change, final ClassMethod javaMethod) {
    return javaMethod;
  }
  
  public boolean allParametersSet() {
    return isChangeSet;
  }
  
  private EObject getCorrepondenceSourceJavaMethod(final DeleteNonRootEObjectInList<ResourceDemandingInternalBehaviour> change) {
    ResourceDemandingInternalBehaviour _oldValue = change.getOldValue();
    return _oldValue;
  }
  
  protected void executeEffect() throws IOException {
    getLogger().debug("Called routine RemovedResourceDemandingInternalBehaviorEffect with input:");
    getLogger().debug("   DeleteNonRootEObjectInList: " + this.change);
    
    ClassMethod javaMethod = initializeRetrieveElementState(
    	() -> getCorrepondenceSourceJavaMethod(change), // correspondence source supplier
    	(ClassMethod _element) -> true, // correspondence precondition checker
    	() -> null, // tag supplier
    	ClassMethod.class,
    	false, true, false);
    if (isAborted()) {
    	return;
    }
    markObjectDelete(getElement0(change, javaMethod));
    
    preProcessElements();
    postProcessElements();
  }
  
  private static class EffectUserExecution extends AbstractEffectRealization.UserExecution {
    @Extension
    private RoutinesFacade effectFacade;
    
    public EffectUserExecution(final ResponseExecutionState responseExecutionState, final CallHierarchyHaving calledBy) {
      super(responseExecutionState);
      this.effectFacade = new RoutinesFacade(responseExecutionState, calledBy);
    }
  }
}