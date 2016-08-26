/**
 * generated by Xtext 2.10.0
 */
package edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage;

import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.ModelElement;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Retrieve Model Element</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#isRequired <em>Required</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#isOptional <em>Optional</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#isAbscence <em>Abscence</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#getElement <em>Element</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#getCorrespondenceSource <em>Correspondence Source</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#getPrecondition <em>Precondition</em>}</li>
 * </ul>
 *
 * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement()
 * @model
 * @generated
 */
public interface RetrieveModelElement extends Taggable
{
  /**
   * Returns the value of the '<em><b>Required</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Required</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Required</em>' attribute.
   * @see #setRequired(boolean)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement_Required()
   * @model
   * @generated
   */
  boolean isRequired();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#isRequired <em>Required</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Required</em>' attribute.
   * @see #isRequired()
   * @generated
   */
  void setRequired(boolean value);

  /**
   * Returns the value of the '<em><b>Optional</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Optional</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Optional</em>' attribute.
   * @see #setOptional(boolean)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement_Optional()
   * @model
   * @generated
   */
  boolean isOptional();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#isOptional <em>Optional</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Optional</em>' attribute.
   * @see #isOptional()
   * @generated
   */
  void setOptional(boolean value);

  /**
   * Returns the value of the '<em><b>Abscence</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Abscence</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Abscence</em>' attribute.
   * @see #setAbscence(boolean)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement_Abscence()
   * @model
   * @generated
   */
  boolean isAbscence();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#isAbscence <em>Abscence</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Abscence</em>' attribute.
   * @see #isAbscence()
   * @generated
   */
  void setAbscence(boolean value);

  /**
   * Returns the value of the '<em><b>Element</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Element</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Element</em>' containment reference.
   * @see #setElement(ModelElement)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement_Element()
   * @model containment="true"
   * @generated
   */
  ModelElement getElement();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#getElement <em>Element</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Element</em>' containment reference.
   * @see #getElement()
   * @generated
   */
  void setElement(ModelElement value);

  /**
   * Returns the value of the '<em><b>Correspondence Source</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Correspondence Source</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Correspondence Source</em>' containment reference.
   * @see #setCorrespondenceSource(CorrespondingObjectCodeBlock)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement_CorrespondenceSource()
   * @model containment="true"
   * @generated
   */
  CorrespondingObjectCodeBlock getCorrespondenceSource();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#getCorrespondenceSource <em>Correspondence Source</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Correspondence Source</em>' containment reference.
   * @see #getCorrespondenceSource()
   * @generated
   */
  void setCorrespondenceSource(CorrespondingObjectCodeBlock value);

  /**
   * Returns the value of the '<em><b>Precondition</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Precondition</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Precondition</em>' containment reference.
   * @see #setPrecondition(PreconditionCodeBlock)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getRetrieveModelElement_Precondition()
   * @model containment="true"
   * @generated
   */
  PreconditionCodeBlock getPrecondition();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.RetrieveModelElement#getPrecondition <em>Precondition</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Precondition</em>' containment reference.
   * @see #getPrecondition()
   * @generated
   */
  void setPrecondition(PreconditionCodeBlock value);

} // RetrieveModelElement