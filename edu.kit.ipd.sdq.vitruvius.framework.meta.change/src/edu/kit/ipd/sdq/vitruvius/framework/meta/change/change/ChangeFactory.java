/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.meta.change.change;

import org.eclipse.emf.ecore.EFactory;
import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * The <b>Factory</b> for the model.
 * It provides a create method for each non-abstract class of the model.
 * <!-- end-user-doc -->
 * @see edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.ChangePackage
 * @generated
 */
public interface ChangeFactory extends EFactory {
    /**
     * The singleton instance of the factory.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    ChangeFactory eINSTANCE = edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.impl.ChangeFactoryImpl.init();

    /**
     * Returns a new object of class '<em>Create Non Root EObject</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Create Non Root EObject</em>'.
     * @generated
     */
    <T extends EObject> CreateNonRootEObject<T> createCreateNonRootEObject();

    /**
     * Returns a new object of class '<em>Create Root EObject</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Create Root EObject</em>'.
     * @generated
     */
    CreateRootEObject createCreateRootEObject();

    /**
     * Returns a new object of class '<em>Unset EFeature</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Unset EFeature</em>'.
     * @generated
     */
    UnsetEFeature createUnsetEFeature();

    /**
     * Returns a new object of class '<em>Update EAttribute</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Update EAttribute</em>'.
     * @generated
     */
    <T extends Object> UpdateEAttribute<T> createUpdateEAttribute();

    /**
     * Returns a new object of class '<em>Update EReference</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Update EReference</em>'.
     * @generated
     */
    <T extends EObject> UpdateEReference<T> createUpdateEReference();

    /**
     * Returns a new object of class '<em>Update EContainment Reference</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Update EContainment Reference</em>'.
     * @generated
     */
    <T extends EObject> UpdateEContainmentReference<T> createUpdateEContainmentReference();

    /**
     * Returns a new object of class '<em>Delete Non Root EObject</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Delete Non Root EObject</em>'.
     * @generated
     */
    <T extends EObject> DeleteNonRootEObject<T> createDeleteNonRootEObject();

    /**
     * Returns a new object of class '<em>Delete Root EObject</em>'.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return a new object of class '<em>Delete Root EObject</em>'.
     * @generated
     */
    DeleteRootEObject createDeleteRootEObject();

    /**
     * Returns the package supported by this factory.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @return the package supported by this factory.
     * @generated
     */
    ChangePackage getChangePackage();

} //ChangeFactory
