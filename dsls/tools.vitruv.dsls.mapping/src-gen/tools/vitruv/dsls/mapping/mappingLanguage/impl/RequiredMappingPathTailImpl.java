/**
 * generated by Xtext 2.9.2
 */
package tools.vitruv.dsls.mapping.mappingLanguage.impl;

import tools.vitruv.dsls.mapping.mappingLanguage.MappingLanguagePackage;
import tools.vitruv.dsls.mapping.mappingLanguage.RequiredMapping;
import tools.vitruv.dsls.mapping.mappingLanguage.RequiredMappingPathTail;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Required Mapping Path Tail</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link tools.vitruv.dsls.mapping.mappingLanguage.impl.RequiredMappingPathTailImpl#getRequiredMapping <em>Required Mapping</em>}</li>
 *   <li>{@link tools.vitruv.dsls.mapping.mappingLanguage.impl.RequiredMappingPathTailImpl#getTail <em>Tail</em>}</li>
 * </ul>
 *
 * @generated
 */
public class RequiredMappingPathTailImpl extends MinimalEObjectImpl.Container implements RequiredMappingPathTail
{
  /**
   * The cached value of the '{@link #getRequiredMapping() <em>Required Mapping</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getRequiredMapping()
   * @generated
   * @ordered
   */
  protected RequiredMapping requiredMapping;

  /**
   * The cached value of the '{@link #getTail() <em>Tail</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getTail()
   * @generated
   * @ordered
   */
  protected RequiredMappingPathTail tail;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected RequiredMappingPathTailImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  protected EClass eStaticClass()
  {
    return MappingLanguagePackage.Literals.REQUIRED_MAPPING_PATH_TAIL;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public RequiredMapping getRequiredMapping()
  {
    if (requiredMapping != null && requiredMapping.eIsProxy())
    {
      InternalEObject oldRequiredMapping = (InternalEObject)requiredMapping;
      requiredMapping = (RequiredMapping)eResolveProxy(oldRequiredMapping);
      if (requiredMapping != oldRequiredMapping)
      {
        if (eNotificationRequired())
          eNotify(new ENotificationImpl(this, Notification.RESOLVE, MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__REQUIRED_MAPPING, oldRequiredMapping, requiredMapping));
      }
    }
    return requiredMapping;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public RequiredMapping basicGetRequiredMapping()
  {
    return requiredMapping;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setRequiredMapping(RequiredMapping newRequiredMapping)
  {
    RequiredMapping oldRequiredMapping = requiredMapping;
    requiredMapping = newRequiredMapping;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__REQUIRED_MAPPING, oldRequiredMapping, requiredMapping));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public RequiredMappingPathTail getTail()
  {
    return tail;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public NotificationChain basicSetTail(RequiredMappingPathTail newTail, NotificationChain msgs)
  {
    RequiredMappingPathTail oldTail = tail;
    tail = newTail;
    if (eNotificationRequired())
    {
      ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL, oldTail, newTail);
      if (msgs == null) msgs = notification; else msgs.add(notification);
    }
    return msgs;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setTail(RequiredMappingPathTail newTail)
  {
    if (newTail != tail)
    {
      NotificationChain msgs = null;
      if (tail != null)
        msgs = ((InternalEObject)tail).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL, null, msgs);
      if (newTail != null)
        msgs = ((InternalEObject)newTail).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL, null, msgs);
      msgs = basicSetTail(newTail, msgs);
      if (msgs != null) msgs.dispatch();
    }
    else if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL, newTail, newTail));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL:
        return basicSetTail(null, msgs);
    }
    return super.eInverseRemove(otherEnd, featureID, msgs);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Object eGet(int featureID, boolean resolve, boolean coreType)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__REQUIRED_MAPPING:
        if (resolve) return getRequiredMapping();
        return basicGetRequiredMapping();
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL:
        return getTail();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__REQUIRED_MAPPING:
        setRequiredMapping((RequiredMapping)newValue);
        return;
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL:
        setTail((RequiredMappingPathTail)newValue);
        return;
    }
    super.eSet(featureID, newValue);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eUnset(int featureID)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__REQUIRED_MAPPING:
        setRequiredMapping((RequiredMapping)null);
        return;
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL:
        setTail((RequiredMappingPathTail)null);
        return;
    }
    super.eUnset(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public boolean eIsSet(int featureID)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__REQUIRED_MAPPING:
        return requiredMapping != null;
      case MappingLanguagePackage.REQUIRED_MAPPING_PATH_TAIL__TAIL:
        return tail != null;
    }
    return super.eIsSet(featureID);
  }

} //RequiredMappingPathTailImpl