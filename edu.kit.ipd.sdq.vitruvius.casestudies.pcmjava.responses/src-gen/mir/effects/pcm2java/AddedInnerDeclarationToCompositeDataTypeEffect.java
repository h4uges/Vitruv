package mir.effects.pcm2java;

import edu.kit.ipd.sdq.vitruvius.casestudies.pcmjava.responses.pcm2java.Pcm2JavaHelper;
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.AbstractEffectRealization;
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.ResponseExecutionState;
import edu.kit.ipd.sdq.vitruvius.dsls.response.runtime.structure.CallHierarchyHaving;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Blackboard;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.TransformationResult;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.UserInteracting;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.containment.CreateNonRootEObjectInList;
import java.io.IOException;
import mir.effects.pcm2java.EffectsFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.types.TypeReference;
import org.palladiosimulator.pcm.repository.CompositeDataType;
import org.palladiosimulator.pcm.repository.DataType;
import org.palladiosimulator.pcm.repository.InnerDeclaration;

@SuppressWarnings("all")
public class AddedInnerDeclarationToCompositeDataTypeEffect extends AbstractEffectRealization {
  public AddedInnerDeclarationToCompositeDataTypeEffect(final ResponseExecutionState responseExecutionState, final CallHierarchyHaving calledBy) {
    super(responseExecutionState, calledBy);
  }
  
  private CreateNonRootEObjectInList<InnerDeclaration> change;
  
  private boolean isChangeSet;
  
  public void setChange(final CreateNonRootEObjectInList<InnerDeclaration> change) {
    this.change = change;
    this.isChangeSet = true;
  }
  
  public boolean allParametersSet() {
    return isChangeSet;
  }
  
  private EObject getCorrepondenceSourceNonPrimitiveInnerDataTypeClass(final CreateNonRootEObjectInList<InnerDeclaration> change) {
    InnerDeclaration _newValue = change.getNewValue();
    DataType _datatype_InnerDeclaration = _newValue.getDatatype_InnerDeclaration();
    return _datatype_InnerDeclaration;
  }
  
  protected void executeEffect() throws IOException {
    getLogger().debug("Called effect AddedInnerDeclarationToCompositeDataTypeEffect with input:");
    getLogger().debug("   CreateNonRootEObjectInList: " + this.change);
    
    org.emftext.language.java.classifiers.Class nonPrimitiveInnerDataTypeClass = initializeRetrieveElementState(
    	() -> getCorrepondenceSourceNonPrimitiveInnerDataTypeClass(change), // correspondence source supplier
    	(org.emftext.language.java.classifiers.Class _element) -> true, // correspondence precondition checker
    	() -> null, // tag supplier
    	org.emftext.language.java.classifiers.Class.class,	true);
    preProcessElements();
    new mir.effects.pcm2java.AddedInnerDeclarationToCompositeDataTypeEffect.EffectUserExecution(getExecutionState(), this).executeUserOperations(
    	change, nonPrimitiveInnerDataTypeClass);
    postProcessElements();
  }
  
  private static class EffectUserExecution {
    private Blackboard blackboard;
    
    private UserInteracting userInteracting;
    
    private TransformationResult transformationResult;
    
    @Extension
    private EffectsFacade effectFacade;
    
    public EffectUserExecution(final ResponseExecutionState responseExecutionState, final CallHierarchyHaving calledBy) {
      this.blackboard = responseExecutionState.getBlackboard();
      this.userInteracting = responseExecutionState.getUserInteracting();
      this.transformationResult = responseExecutionState.getTransformationResult();
      this.effectFacade = new EffectsFacade(responseExecutionState, calledBy);
    }
    
    private void executeUserOperations(final CreateNonRootEObjectInList<InnerDeclaration> change, final org.emftext.language.java.classifiers.Class nonPrimitiveInnerDataTypeClass) {
      InnerDeclaration _newValue = change.getNewValue();
      DataType _datatype_InnerDeclaration = _newValue.getDatatype_InnerDeclaration();
      final TypeReference innerDataTypeReference = Pcm2JavaHelper.createTypeReference(_datatype_InnerDeclaration, nonPrimitiveInnerDataTypeClass);
      EObject _newAffectedEObject = change.getNewAffectedEObject();
      final CompositeDataType compositeDataType = ((CompositeDataType) _newAffectedEObject);
      final InnerDeclaration innerDeclaration = change.getNewValue();
      this.effectFacade.callAddInnerDeclarationToCompositeDataType(compositeDataType, innerDeclaration, innerDataTypeReference);
    }
  }
}
