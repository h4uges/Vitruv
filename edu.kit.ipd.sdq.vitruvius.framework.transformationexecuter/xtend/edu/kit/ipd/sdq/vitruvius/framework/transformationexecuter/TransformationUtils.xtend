package edu.kit.ipd.sdq.vitruvius.framework.transformationexecuter

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.TransformationChangeResult
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject

class TransformationUtils {
	private new(){
	}
	
	def public static TransformationChangeResult createTransformationChangeResult(EObject[] newRootObjectsToSave, 
			EObject[] objectsToDelete, EObject[] existingObjectsToSave){
		var transformationChangeResult = new TransformationChangeResult()
		if(null != newRootObjectsToSave){
			transformationChangeResult.newRootObjectsToSave.addAll(newRootObjectsToSave)
		}
		if(null != objectsToDelete){
			transformationChangeResult.existingObjectsToDelete.addAll(objectsToDelete)
		}
		if(null != existingObjectsToSave){
			transformationChangeResult.existingObjectsToSave.addAll(existingObjectsToSave)
		}
		transformationChangeResult
	}
	
	def public static TransformationChangeResult createTransformationChangeResultForNewRootEObjects(EObject[] newRootEObjects){
		createTransformationChangeResult(newRootEObjects, null, null)
	}
	
	def public static TransformationChangeResult createTransformationChangeResultForEObjectsToSave(EObject[] eObjectsToSave){
		createTransformationChangeResult(null, null, eObjectsToSave)
	}
	
	def public static TransformationChangeResult createTransformationChangeResultForEObjectsToDelete(EObject[] eObjectsToDelete){
		createTransformationChangeResult(null, eObjectsToDelete, null)
	}
	
	def public static TransformationChangeResult createEmptyTransformationChangeResult(){
		return createTransformationChangeResult(null, null, null)
	}
	
	def public static EAttribute getAttributeByNameFromEObject(String attributeName, EObject eObject) {
		return eObject.eClass.getEAllAttributes.filter[attribute|attribute.name.equalsIgnoreCase(attributeName)].iterator.next
	}
	
}
