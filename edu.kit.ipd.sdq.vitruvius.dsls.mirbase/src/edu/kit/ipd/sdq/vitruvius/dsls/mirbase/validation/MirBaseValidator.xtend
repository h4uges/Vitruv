/*
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package edu.kit.ipd.sdq.vitruvius.dsls.mirbase.validation

import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MetamodelImport
import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MirBaseFile
import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MirBasePackage
import edu.kit.ipd.sdq.vitruvius.framework.util.bridges.EclipseBridge
import org.eclipse.osgi.container.namespaces.EclipsePlatformNamespace
import org.eclipse.xtext.validation.Check

import static edu.kit.ipd.sdq.vitruvius.dsls.mirbase.validation.EclipsePluginHelper.*
import edu.kit.ipd.sdq.vitruvius.dsls.common.VitruviusDslsCommonConstants

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class MirBaseValidator extends AbstractMirBaseValidator {
	public static val METAMODEL_IMPORT_DEPENDENCY_MISSING = "metamodelImportDependencyMissing"
	public static val VITRUVIUS_DEPENDENCY_MISSING = "vitruviusDependencyMissing"
	
	@Check
	def checkMetamodelImportDependencyMissing(MetamodelImport metamodelImport) {
		val contributorName = EclipseBridge.getNameOfContributorOfExtension(
					"org.eclipse.emf.ecore.generated_package",
					"uri", metamodelImport.package.nsURI)
					
		val project = getProject(metamodelImport.eResource)
		if (!hasDependency(project, contributorName)) {
			warning('''Dependency to plug-in '«contributorName»' missing.''', metamodelImport, MirBasePackage.Literals.METAMODEL_IMPORT__PACKAGE, METAMODEL_IMPORT_DEPENDENCY_MISSING)
		}
	}
	
	@Check
	def checkMirBaseFile(MirBaseFile mirBaseFile) {
		val project = getProject(mirBaseFile?.eResource)
		
		if (!isPluginProject(project)) {
			warning('''The resource should be contained in a plug-in project.''', mirBaseFile, null)
		}
	}
	
	// TODO DW: move to appropriate plugin

	
	@Check
	def checkVitruviusDependencies(MirBaseFile mirBaseFile) {
		val project = getProject(mirBaseFile.eResource)
		
		for (String dependency : VitruviusDslsCommonConstants.VITRUVIUS_DEPENDENCIES) {
			if (!hasDependency(project, dependency)) {
				warning('''Plug-in does not declare all needed dependencies for Vitruvius (missing: «dependency»).''', mirBaseFile, null, VITRUVIUS_DEPENDENCY_MISSING)
				return
			}
		}
	}
}
