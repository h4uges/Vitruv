package edu.kit.ipd.sdq.vitruvius.casestudies.jmljava.correspondences

import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.ClassifierDeclarationWithModifier
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.DeclaredException
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.FormalParameterDecl
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.ImportDeclaration
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.JMLSpecifiedElement
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.MemberDeclaration
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.Modifiable
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.Modifier
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.NormalClassDeclaration
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.NormalInterfaceDeclaration
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CorrespondenceInstance
import edu.kit.ipd.sdq.vitruvius.framework.meta.correspondence.Correspondence
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.emftext.language.java.classifiers.Class
import org.emftext.language.java.classifiers.ConcreteClassifier
import org.emftext.language.java.classifiers.Interface
import org.emftext.language.java.commons.NamedElement
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.imports.Import
import org.emftext.language.java.members.Constructor
import org.emftext.language.java.members.Field
import org.emftext.language.java.members.Method
import org.emftext.language.java.modifiers.AnnotableAndModifiable
import org.emftext.language.java.parameters.Parameter
import org.emftext.language.java.types.NamespaceClassifierReference
import edu.kit.ipd.sdq.vitruvius.casestudies.jmljava.helper.StringOperationsJaMoPP
import edu.kit.ipd.sdq.vitruvius.casestudies.jmljava.helper.JaMoPPConcreteSyntax
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.GenericMethodOrConstructorDecl
import edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.MethodDeclaration

class Java2JMLCorrespondenceAdder {
	
	private static val LOGGER = Logger.getLogger(Java2JMLCorrespondenceAdder)

	static def addCorrespondences(CompilationUnit javaRoot, edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.CompilationUnit jmlRoot, CorrespondenceInstance ci) {
		val cuCorrespondence = ci.createAndAddEObjectCorrespondence(javaRoot, jmlRoot)
		
		LOGGER.debug(
			"Adding root element correspondence between " + javaRoot.name + " and " +
				jmlRoot.name)

		for (javaImport : javaRoot.imports) {
			val jmlImport = MatchingModelElementsFinder.findMatchingImport(javaImport, jmlRoot.importdeclaration)
			if (jmlImport != null) {
				addCorrespondences(javaImport, jmlImport, ci, cuCorrespondence)
			} else {
				LOGGER.warn("No matching JML import for Java import (" + StringOperationsJaMoPP.getStringRepresentation(javaImport) + ") found.")
			}
		}
		
		for (javaClassifier : javaRoot.classifiers.filter(ConcreteClassifier)) {
			val jmlClass = MatchingModelElementsFinder.findMatchingClassifier(javaClassifier, jmlRoot.typedeclaration)
			if (jmlClass != null) {
				addCorrespondences(javaClassifier, jmlClass, ci, cuCorrespondence)
			} else {
				LOGGER.warn("No matching JML classifier for Java classifier (" + StringOperationsJaMoPP.getQualifiedName(javaClassifier) + ") found.")
			}
		}
	}

	static def dispatch Void addCorrespondences(Interface javaInterface, ClassifierDeclarationWithModifier cdwm, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		// class declaration with modifier
		val cdwmCorr = ci.createAndAddEObjectCorrespondence(javaInterface, cdwm, parentCorrespondence)
		
		// modifiers
		addCorrespondencesForModifier(javaInterface, cdwm, ci, cdwmCorr)
		
		// class declaration
		val nid = cdwm.classOrInterfaceDeclaration as NormalInterfaceDeclaration
		val nidCorr = ci.createAndAddEObjectCorrespondence(javaInterface, nid, cdwmCorr)
		
		// implements
		for (implementedType : javaInterface.extends) {
			val jmlImplementedType = MatchingModelElementsFinder.findMatchingType(implementedType, 0, nid.implementedTypes)
			if (jmlImplementedType != null) {
				ci.createAndAddEObjectCorrespondence(implementedType, jmlImplementedType, nidCorr)
			} else {
				LOGGER.warn("No matching JML implemented type for Java implemented type (" + JaMoPPConcreteSyntax.convertToConcreteSyntax(implementedType) + ") found.")
			}
		}
		
		//TODO type parameters (if needed)
		// For types of fields, parameter, methods and so on this is not important since a change of a type parameter
		// (e.g. List<String> -> List<Integer>) can be represented as change of the whole value.
		
		val relevantElements = nid.bodyDeclarations.filter(JMLSpecifiedElement).filter[element != null]
			
		javaInterface.fields.forEach[javaField | addCorrespondencesNullableJMLElement(javaField, MatchingModelElementsFinder.findMatchingField(javaField, relevantElements), ci, nidCorr)]
		javaInterface.methods.forEach[javaMethod | addCorrespondencesNullableJMLElement(javaMethod, MatchingModelElementsFinder.findMatchingMethod(javaMethod, relevantElements), ci, nidCorr)]
		
		return null
	}

	static def dispatch Void addCorrespondences(Class javaClass, ClassifierDeclarationWithModifier cdwm, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		// class declaration with modifier
		val cdwmCorr = ci.createAndAddEObjectCorrespondence(javaClass, cdwm, parentCorrespondence)
		
		// modifiers
		addCorrespondencesForModifier(javaClass, cdwm, ci, cdwmCorr)
		
		// class declaration
		val ncd = cdwm.classOrInterfaceDeclaration as NormalClassDeclaration
		val ncdCorr = ci.createAndAddEObjectCorrespondence(javaClass, ncd, cdwmCorr)
		
		// implements
		
		for (implementedType : javaClass.implements) {
			val jmlImplementedType = MatchingModelElementsFinder.findMatchingType(implementedType, 0, ncd.implementedTypes)
			if (jmlImplementedType != null) {
				ci.createAndAddEObjectCorrespondence(implementedType, jmlImplementedType, ncdCorr)
			} else {
				LOGGER.warn("No matching JML implemented type for Java implemented type (" + JaMoPPConcreteSyntax.convertToConcreteSyntax(implementedType) + ") found.")
			}
		}
		
		// extends
		if (javaClass.extends != null && ncd.superType != null) {
			ci.createAndAddEObjectCorrespondence(javaClass.extends, ncd.superType, ncdCorr)
		}
		
		//TODO type parameters (if needed)
		// For types of fields, parameter, methods and so on this is not important since a change of a type parameter
		// (e.g. List<String> -> List<Integer>) can be represented as change of the whole value.
		
		val relevantElements = ncd.bodyDeclarations.filter(JMLSpecifiedElement).filter[element != null]
			
		javaClass.fields.forEach[javaField | addCorrespondencesNullableJMLElement(javaField, MatchingModelElementsFinder.findMatchingField(javaField, relevantElements), ci, ncdCorr)]
		javaClass.methods.filter[!javaClass.members.filter(Constructor).toList.contains(it)].forEach[javaMethod | addCorrespondencesNullableJMLElement(javaMethod, MatchingModelElementsFinder.findMatchingMethod(javaMethod, relevantElements), ci, ncdCorr)]
		javaClass.members.filter(Constructor).forEach[javaConstructor | addCorrespondencesNullableJMLElement(javaConstructor, MatchingModelElementsFinder.findMatchingConstructor(javaConstructor, relevantElements), ci, ncdCorr)]
		
		return null
	}
	
	static def Void addCorrespondencesNullableJMLElement(NamedElement javaObject, EObject jmlObject, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		if (jmlObject == null) {
			LOGGER.warn("No matching JML element for Java element (" + StringOperationsJaMoPP.getQualifiedName(javaObject.containingConcreteClassifier) + "." + javaObject.name + ") found.")
			return null
		}
		return addCorrespondences(javaObject, jmlObject, ci, parentCorrespondence)
	}
	
	static def dispatch Void addCorrespondences(Method javaMethod, JMLSpecifiedElement jmlSpecifiedElement, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		var topLevelCorr = ci.createAndAddEObjectCorrespondence(javaMethod, jmlSpecifiedElement, parentCorrespondence)
		val jmlMemberDeclWithModifier = jmlSpecifiedElement.element
		
		// member declaration with modifier
		val jmlMemberDeclWithModifierCorrespondence = ci.createAndAddEObjectCorrespondence(javaMethod, jmlMemberDeclWithModifier, topLevelCorr)

		// modifiers
		addCorrespondencesForModifier(javaMethod, jmlMemberDeclWithModifier, ci, jmlMemberDeclWithModifierCorrespondence)
		
		var MethodDeclaration jmlMethodDeclaration = null
		var Correspondence memberDeclarationCorrespondence = null
		if (jmlMemberDeclWithModifier.memberdecl instanceof MemberDeclaration) {
			// member declaration
			val jmlMemberDecl = jmlMemberDeclWithModifier.memberdecl as MemberDeclaration
			memberDeclarationCorrespondence = ci.createAndAddEObjectCorrespondence(javaMethod, jmlMemberDecl, jmlMemberDeclWithModifierCorrespondence)
			
			// return type
			if (javaMethod.typeReference != null && jmlMemberDecl.type != null) {
				ci.createAndAddEObjectCorrespondence(javaMethod.typeReference, jmlMemberDecl.type, memberDeclarationCorrespondence)
			}
			
			jmlMethodDeclaration = jmlMemberDecl.method
		} else if (jmlMemberDeclWithModifier.memberdecl instanceof GenericMethodOrConstructorDecl) {
			// member declaration
			val jmlMemberDecl = jmlMemberDeclWithModifier.memberdecl as GenericMethodOrConstructorDecl
			memberDeclarationCorrespondence = ci.createAndAddEObjectCorrespondence(javaMethod, jmlMemberDecl, jmlMemberDeclWithModifierCorrespondence)
			
			// return type
			if (javaMethod.typeReference != null && jmlMemberDecl.type != null) {
				ci.createAndAddEObjectCorrespondence(javaMethod.typeReference, jmlMemberDecl.type, memberDeclarationCorrespondence)
			}
			
			jmlMethodDeclaration = jmlMemberDecl.method
		}

		
		// method declaration
		val methodDeclarationCorrespondence = ci.createAndAddEObjectCorrespondence(javaMethod, jmlMethodDeclaration, memberDeclarationCorrespondence)

		// exceptions
		for (javaException : javaMethod.exceptions) {
			val jmlException = MatchingModelElementsFinder.findMatchingException(javaException, jmlMethodDeclaration.exceptions)
			if (jmlException != null) {
				ci.createAndAddEObjectCorrespondence(javaException, jmlException, methodDeclarationCorrespondence)
			} else {
				LOGGER.warn("No matching JML exception for Java exception (" + StringOperationsJaMoPP.getStringRepresentation(javaException, 0) + ") found.")
			}
		}
		
		// parameters
		for (var i = 0; i < javaMethod.parameters.size; i++) {
			addCorrespondences(javaMethod.parameters.get(i), jmlMethodDeclaration.parameters.get(i), ci, methodDeclarationCorrespondence)
		}
		
		return null
	}
	
	static def dispatch Void addCorrespondences(Constructor javaConstructor, JMLSpecifiedElement jmlSpecifiedElement, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		var topLevelCorr = ci.createAndAddEObjectCorrespondence(javaConstructor, jmlSpecifiedElement, parentCorrespondence)
		val jmlMemberDeclWithModifier = jmlSpecifiedElement.element
		
		// member declaration with modifier
		val jmlMemberDeclWithModifierCorrespondence = ci.createAndAddEObjectCorrespondence(javaConstructor, jmlMemberDeclWithModifier, topLevelCorr)

		// modifiers
		addCorrespondencesForModifier(javaConstructor, jmlMemberDeclWithModifier, ci, jmlMemberDeclWithModifierCorrespondence)
		
		// member declaration
		val jmlMemberDecl = jmlMemberDeclWithModifier.memberdecl as edu.kit.ipd.sdq.vitruvius.casestudies.jml.language.jML.Constructor
		val memberDeclarationCorrespondence = ci.createAndAddEObjectCorrespondence(javaConstructor, jmlMemberDecl, jmlMemberDeclWithModifierCorrespondence)
		
		// exceptions
		for (javaException : javaConstructor.exceptions) {
			val jmlException = MatchingModelElementsFinder.findMatchingException(javaException, jmlMemberDecl.exceptions)
			if (jmlException != null) {
				ci.createAndAddEObjectCorrespondence(javaException, jmlException, memberDeclarationCorrespondence)
			} else {
				LOGGER.warn("No matching JML exception for Java exception (" + StringOperationsJaMoPP.getStringRepresentation(javaException, 0) + ") found.")
			}
		}
		
		// parameters
		for (var i = 0; i < javaConstructor.parameters.size; i++) {
			addCorrespondences(javaConstructor.parameters.get(i), jmlMemberDecl.parameters.get(i), ci, memberDeclarationCorrespondence)
		}
		
		return null
	}
	
	static def dispatch Void addCorrespondences(Field javaField, JMLSpecifiedElement jmlSpecifiedElement, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		var topLevelCorr = ci.createAndAddEObjectCorrespondence(javaField, jmlSpecifiedElement, parentCorrespondence)
		val jmlMemberDeclWithModifier = jmlSpecifiedElement.element
		
		// member declaration with modifier
		val jmlMemberDeclWithModifierCorrespondence = ci.createAndAddEObjectCorrespondence(javaField, jmlMemberDeclWithModifier, topLevelCorr)
		
		// modifiers
		addCorrespondencesForModifier(javaField, jmlMemberDeclWithModifier, ci, jmlMemberDeclWithModifierCorrespondence)
		
		// member declaration
		val jmlMemberDecl = jmlMemberDeclWithModifier.memberdecl as MemberDeclaration
		val memberDeclarationCorrespondence = ci.createAndAddEObjectCorrespondence(javaField, jmlMemberDecl, jmlMemberDeclWithModifierCorrespondence)
		
		// type
		if (javaField.typeReference != null) {
			ci.createAndAddEObjectCorrespondence(javaField.typeReference, jmlMemberDecl.type, memberDeclarationCorrespondence)
		}
		
		// field declaration
		val jmlFieldDeclaration = (jmlMemberDeclWithModifier.memberdecl as MemberDeclaration).field
		ci.createAndAddEObjectCorrespondence(javaField, jmlFieldDeclaration, memberDeclarationCorrespondence)
		
		for (variableDeclarator : jmlFieldDeclaration.variabledeclarator) {
			var EObject javaObject;
			if (javaField.name.equals(variableDeclarator.identifier)) {
				javaObject = javaField
			} else {
				javaObject = javaField.additionalFields.findFirst[name.equals(variableDeclarator.identifier)]
			}
			
			if (javaObject != null) {
				ci.createAndAddEObjectCorrespondence(javaField, variableDeclarator)
			} else {
				LOGGER.warn("No matching JML field for Java field (" + StringOperationsJaMoPP.getQualifiedName(javaField.containingConcreteClassifier) + "." + javaField.name + ") or one of its additional fields found.")
			}
		}
		
		return null
	}
	
	static def dispatch Void addCorrespondences(Parameter javaParameter, FormalParameterDecl jmlParameter, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		val parameterCorrespondence = ci.createAndAddEObjectCorrespondence(javaParameter, jmlParameter, parentCorrespondence)
		
		ci.createAndAddEObjectCorrespondence(javaParameter.typeReference, jmlParameter.type, parameterCorrespondence)
		
		addCorrespondencesForModifier(javaParameter, jmlParameter, ci, parameterCorrespondence)
		
		return null
	}
	
	static def dispatch Void addCorrespondences(NamespaceClassifierReference javaException, DeclaredException jmlException, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		ci.createAndAddEObjectCorrespondence(javaException, jmlException, parentCorrespondence)
		return null
	}
	
	static def dispatch Void addCorrespondences(Import javaImport, ImportDeclaration jmlImport, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		ci.createAndAddEObjectCorrespondence(javaImport, jmlImport, parentCorrespondence)
		return null
	}
	
	static def dispatch Void addCorrespondences(org.emftext.language.java.modifiers.Modifier javaModifier, Modifier jmlModifier, CorrespondenceInstance ci, Correspondence parentCorrespondence) {
		ci.createAndAddEObjectCorrespondence(javaModifier, jmlModifier, parentCorrespondence)
		return null
	}
	
	private static def Void addCorrespondencesForModifier(AnnotableAndModifiable javaAnnotable, Modifiable jmlModifiable, CorrespondenceInstance ci, Correspondence parentCorr) {
		// process modifiers
		for (javaModifier : javaAnnotable.annotationsAndModifiers) {
			val jmlModifier = MatchingModelElementsFinder.findMatchingModifier(javaModifier, jmlModifiable.modifiers)
			if (jmlModifier != null) {
				ci.createAndAddEObjectCorrespondence(javaModifier, jmlModifier, parentCorr)
			} else {
				LOGGER.warn("No matching JML modifier for Java modifier (" + javaModifier + ") found.")
			}
		}
		return null
	}

}