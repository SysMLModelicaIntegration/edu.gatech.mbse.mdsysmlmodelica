/*
 * The following is a BSD 3-Clause License
 * 
 * Copyright (c) 2013, Georgia Institute of Technology
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following 
 * conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
 * in the documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the Georgia Institute of Technology nor the names of its contributors may be used to endorse or promote 
 * products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, 
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */

package edu.gatech.mbse.mdsysmlmodelica.mo2SysML;

import java.awt.event.ActionEvent;

import java.io.FileWriter;
import java.io.IOException;

import java.util.ArrayList;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;

import java.util.LinkedHashMap;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.jmi.reflect.RefClass;

import javax.swing.JFileChooser;

import org.eclipse.emf.ecore.EClass;

import com.nomagic.magicdraw.core.Application;
import com.nomagic.magicdraw.core.Project;
import com.nomagic.magicdraw.openapi.uml.SessionManager;
import com.nomagic.magicdraw.properties.BooleanProperty;
import com.nomagic.magicdraw.properties.PropertyID;
import com.nomagic.magicdraw.properties.PropertyManager;

import com.nomagic.magicdraw.ui.browser.actions.DefaultBrowserAction;

import com.nomagic.uml2.ext.jmi.helpers.StereotypesHelper;
import com.nomagic.uml2.ext.magicdraw.auxiliaryconstructs.mdmodels.Model;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Classifier;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Comment;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.DataType;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Element;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Enumeration;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.EnumerationLiteral;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Generalization;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.NamedElement;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Package;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.PackageableElement;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Parameter;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Property;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Type;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.TypedElement;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.ValueSpecification;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.VisibilityKind;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.VisibilityKindEnum;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.Behavior;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.OpaqueBehavior;
import com.nomagic.uml2.ext.magicdraw.components.mdbasiccomponents.ConnectorKindEnum;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdinternalstructures.Connector;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdinternalstructures.ConnectorEnd;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdports.Port;
import com.nomagic.uml2.ext.magicdraw.mdprofiles.Profile;
import com.nomagic.uml2.ext.magicdraw.mdprofiles.Stereotype;
import com.nomagic.uml2.impl.ElementsFactory;

import edu.gatech.mbse.mdsysmlmodelica.helper.StringHandler;
import edu.gatech.mbse.mdsysmlmodelica.omc.OpenModelicaCompilerCommunication;

/**
 * ImportModelicaAction is responsible for transforming a Modelica model into a
 * SysML model. The user selects through a dialog the Modelica model to
 * transform into SysML. The transformation is based on the OpenModelicaCompiler to
 * parse the Modelica model and on the MagicDraw API to a corresponding SysML model.
 * 
 * @author Axel Reichwein
 */
public class ImportModelicaAction extends DefaultBrowserAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4501968202702572083L;
	/**
	 * 
	 */
	static HashMap<String, RefClass> refClassesMap;
	static HashMap<String, EClass> eClassesMap;
	static ElementsFactory magicDrawFactory;
	static Package rootPackage;
	static Set<Type> traverseableTypes = new HashSet<Type>();

	private PropertyManager properties = null;

	private static Profile sysML4ModelicaProfile;

	private static Stereotype modelicaClassStereotype;
	private static Stereotype modelicaPackageStereotype;
	private static Stereotype modelicaConnectorStereotype;
	private static Stereotype modelicaModelStereotype;
	private static Stereotype modelicaFunctionStereotype;
	private static Stereotype modelicaBlockStereotype;
	private static Stereotype modelicaRecordStereotype;
	private static Stereotype modelicaTypeStereotype;

	private static Stereotype modelicaPortStereotype;
	private static Stereotype modelicaPartStereotype;
	private static Stereotype modelicaValuePropertyStereotype;
	private static Stereotype modelicaFunctionParameterStereotype;

	private static Stereotype modelicaEquationStereotype;
	private static Stereotype modelicaAlgorithmStereotype;

	private static Stereotype modelicaExtendsStereotype;
	private static Stereotype modelicaShortExtendsStereotype;

	private static Stereotype modelicaConnectionStereotype;

	private static Stereotype nestedConnectorEndStereotype;

	private static Type modelicaRealType;
	private static Type modelicaIntegerType;
	private static Type modelicaStringType;
	private static Type modelicaBooleanType;

	private static Enumeration modelicaVariabilityKind;
	private static EnumerationLiteral modelicaConstantKind;
	private static EnumerationLiteral modelicaParameterKind;
	private static EnumerationLiteral modelicaContinuousKind;
	private static EnumerationLiteral modelicaDiscreteKind;

	private static Enumeration modelicaCausalityKind;
	private static EnumerationLiteral modelicaInputKind;
	private static EnumerationLiteral modelicaOutputKind;

	private static Enumeration modelicaFlowFlagKind;
	private static EnumerationLiteral modelicaFlowKind;
	private static EnumerationLiteral modelicaStreamKind;

	private static Enumeration modelicaScopeKind;
	private static EnumerationLiteral modelicaInnerKind;
	private static EnumerationLiteral modelicaOuterKind;

	private static Enumeration modelicaStateSelectKind;
	private static EnumerationLiteral modelicaDefaultKind;
	private static EnumerationLiteral modelicaAlwaysKind;
	private static EnumerationLiteral modelicaNeverKind;
	private static EnumerationLiteral modelicaPreferKind;
	private static EnumerationLiteral modelicaAvoidKind;

	private static boolean isLastTraversal = false;

	private static OpenModelicaCompilerCommunication omc = new OpenModelicaCompilerCommunication();

	private static String classQualifiedName = null;

	private static Map<ModelicaComponentData, Classifier> unresolvedComponents = new LinkedHashMap<ModelicaComponentData, Classifier>();
	private static Map<ModelicaComponentData, Classifier> resolvedComponents = new LinkedHashMap<ModelicaComponentData, Classifier>();
	private static Set<ModelicaConnectionData> unresolvedConnections = new HashSet<ModelicaConnectionData>();
	private static Set<ModelicaConnectionData> resolvedConnections = new HashSet<ModelicaConnectionData>();
	private static Set<Classifier> unresolvedGeneralizations = new HashSet<Classifier>();
	private static Set<Classifier> resolvedGeneralizations = new HashSet<Classifier>();

	private static Map<String, String> importMappings = new HashMap<String, String>();

	static Properties prop = System.getProperties();

	public ImportModelicaAction() {
		super("", "Import Modelica", null, null);
		properties = new PropertyManager();
		properties.addProperty(new BooleanProperty(
				PropertyID.SHOW_DIAGRAM_INFO, true));

	}

	public void actionPerformed(ActionEvent e) {
		traverseableTypes.clear();
		unresolvedComponents.clear();
		resolvedComponents.clear();
		unresolvedConnections.clear();
		resolvedConnections.clear();
		unresolvedGeneralizations.clear();
		resolvedGeneralizations.clear();

		// load input Modelica model
		String modelicaASTFile = "";
		String modelicaFile = "";
		final JFileChooser fc = new JFileChooser();
		fc.setDialogTitle("Modelica file to import");
		int returnVal = fc.showOpenDialog(null);

		if (returnVal == JFileChooser.APPROVE_OPTION) {
			modelicaFile = fc.getSelectedFile().getAbsolutePath();
		} else {
			return;
		}

		try {
			// load .mo modelica file
			modelicaASTFile = modelicaFile.replace(".mo", ".moast");
			modelicaASTFile = modelicaASTFile.replace("\\", "\\\\");
			modelicaFile = modelicaFile.replace("\\", "\\\\");
			omc.clear();
			String loadFileOKString = omc.loadFile(modelicaFile);
			if (loadFileOKString.equals("false")) {
				// cancel import and print error message
				// TODO
			}
			String error = omc.getErrorString();

			// load ModelicaServices
			// String modelicaServicesFileOKString =
			// omc.loadModel("ModelicaServices");
			// String error2 = omc.getErrorString();

			SessionManager.getInstance().createSession("modelicaSession");
			Project project = Application.getInstance().getProject();

			Model model = project.getModel();

			// select user-defined magicDraw package
			// Package rootPackage = (Package) getTree().getSelectedNode()
			// .getUserObject();
			// TODO

			rootPackage = model;

			// load factory
			magicDrawFactory = Application.getInstance().getProject()
					.getElementsFactory();

			// load SysML4Modelica profile
			sysML4ModelicaProfile = getSysML4ModelicaProfile(project);

			// if SysML4Modelica profile not in project, cancel import and print
			// error message
			if (sysML4ModelicaProfile == null) {
				// TODO
			}

			// load SysML4Modelica stereotypes and predefined types
			loadSysML4ModelicaStereotypesAndTypes(project);

			// begin Modelica to SysML transformation
			classQualifiedName = null;
			isLastTraversal = false;

			// get Modelica classes from Modelica model
			String classNames = omc.getClassNames("");
			classNames = classNames.replace("{", "");
			classNames = classNames.replace("}", "");
			String[] classNamesArray = classNames.split(",");

			// map each class and its contents into corresponding SysML elements
			for (int i = 0; i < classNamesArray.length; i++) {
				String className = classNamesArray[i];
				classQualifiedName = null;

				// recursively import every Modelica class with all its contents
				importClass(className, rootPackage);
			}

			// relationships between Modelica constructs have not all been
			// mapped to corresponding SysML relationships after the first
			// transformation run. Missing relationships are mapped.
			isLastTraversal = true;
			setUnresolvedGeneralizations();
			setUnresolvedComponents();
			setUnresolvedConnections();

			// logging transformation errors
			logErrors();

			traverseableTypes.clear();

			SessionManager.getInstance().closeSession();
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

	}

	private void logErrors() {

		StringBuffer logBuffer = new StringBuffer();

		logBuffer.append("\n\n\n\nUNRESOLVED GENERALIZATIONS\n");
		for (Classifier classifier : unresolvedGeneralizations) {
			if (!resolvedGeneralizations.contains(classifier)) {
				String classifierQualifiedName = classifier.getQualifiedName()
						.replaceAll("::", ".");
				logBuffer.append(classifierQualifiedName + "\n");
			}
		}

		logBuffer.append("\n\n\nUNRESOLVED COMPONENTS\n");
		for (ModelicaComponentData modelicaComponentData : unresolvedComponents
				.keySet()) {

			if (!resolvedComponents.containsKey(modelicaComponentData)) {
				Classifier classifier = unresolvedComponents
						.get(modelicaComponentData);

				// get property name and possible value
				System.out.println("propertyName: "
						+ modelicaComponentData.getName());
				logBuffer.append(modelicaComponentData.getName() + "\t\t\t\t");

				// get property type qualified name
				System.out.println("propertyType qualifiedName: "
						+ modelicaComponentData.getTypeQName());
				logBuffer.append(modelicaComponentData.getTypeQName()
						+ "\t\t\t\t");
				logBuffer.append(classifier.getQualifiedName());
				logBuffer.append("\n");
			}
		}

		logBuffer.append("\n\n\n\nUNRESOLVED CONNECTIONS\n");
		for (ModelicaConnectionData modelicaConnectionData : unresolvedConnections) {
			if (!resolvedConnections.contains(modelicaConnectionData)) {
				String connection = modelicaConnectionData.getConnection();
				Classifier classifier = modelicaConnectionData.getClassifier();
				logBuffer.append(connection + "\t\t\t");
				logBuffer.append(classifier.getQualifiedName() + "\n");
			}
		}

		logBuffer.append("\n\n\nTRAVERSEABLE TYPES");
		for (Type type : traverseableTypes) {
			logBuffer.append(type.getQualifiedName() + "\n");
		}

		printBufferToFile(logBuffer, "modelica-import-log.txt");

	}

	private void loadSysML4ModelicaStereotypesAndTypes(Project project) {
		// load SysML4Modelica datatypes and enumerations
		modelicaRealType = getTypeFromProfile(project, "ModelicaReal");
		modelicaIntegerType = getTypeFromProfile(project, "ModelicaInteger");
		modelicaStringType = getTypeFromProfile(project, "ModelicaString");
		modelicaBooleanType = getTypeFromProfile(project, "ModelicaBoolean");

		// load SysML4Modelica Stereotypes
		modelicaClassStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaClass");
		modelicaPackageStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaPackage");
		modelicaConnectorStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaConnector");
		modelicaModelStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaModel");
		modelicaBlockStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaBlock");
		modelicaFunctionStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaFunction");
		modelicaRecordStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaRecord");
		modelicaTypeStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaType");

		modelicaPortStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaPort");
		modelicaPartStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaPart");
		modelicaValuePropertyStereotype = StereotypesHelper.getStereotype(
				project, "ModelicaValueProperty");
		modelicaFunctionParameterStereotype = StereotypesHelper.getStereotype(
				project, "ModelicaFunctionParameter");

		modelicaEquationStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaEquation");
		modelicaAlgorithmStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaAlgorithm");

		modelicaExtendsStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaExtends");
		modelicaShortExtendsStereotype = StereotypesHelper.getStereotype(
				project, "ModelicaShortExtends");

		modelicaConnectionStereotype = StereotypesHelper.getStereotype(project,
				"ModelicaConnection");

		// load NestedConnectorEnd SysML stereotype
		nestedConnectorEndStereotype = StereotypesHelper.getStereotype(project,
				"NestedConnectorEnd");

		// load enumeration kinds
		modelicaVariabilityKind = (Enumeration) getEnumeration(project,
				"ModelicaVariabilityKind");
		for (EnumerationLiteral enumerationLiteral : modelicaVariabilityKind
				.getOwnedLiteral()) {
			if (enumerationLiteral.getName().equals("constant")) {
				modelicaConstantKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("discrete")) {
				modelicaDiscreteKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("continuous")) {
				modelicaContinuousKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("parameter")) {
				modelicaParameterKind = enumerationLiteral;
				continue;
			}
		}

		modelicaCausalityKind = (Enumeration) getEnumeration(project,
				"ModelicaCausalityKind");
		for (EnumerationLiteral enumerationLiteral : modelicaCausalityKind
				.getOwnedLiteral()) {
			if (enumerationLiteral.getName().equals("input")) {
				modelicaInputKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("output")) {
				modelicaOutputKind = enumerationLiteral;
				continue;
			}
		}

		modelicaFlowFlagKind = (Enumeration) getEnumeration(project,
				"ModelicaFlowFlagKind");
		for (EnumerationLiteral enumerationLiteral : modelicaFlowFlagKind
				.getOwnedLiteral()) {
			if (enumerationLiteral.getName().equals("flow")) {
				modelicaFlowKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("stream")) {
				modelicaStreamKind = enumerationLiteral;
				continue;
			}
		}

		modelicaScopeKind = (Enumeration) getEnumeration(project,
				"ModelicaScopeKind");
		for (EnumerationLiteral enumerationLiteral : modelicaScopeKind
				.getOwnedLiteral()) {
			if (enumerationLiteral.getName().equals("inner")) {
				modelicaInnerKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("outer")) {
				modelicaOuterKind = enumerationLiteral;
				continue;
			}
		}

		modelicaStateSelectKind = (Enumeration) getTypeFromProfile(project,
				"ModelicaStateSelect");
		for (EnumerationLiteral enumerationLiteral : modelicaStateSelectKind
				.getOwnedLiteral()) {
			if (enumerationLiteral.getName().equals("default")) {
				modelicaDefaultKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("always")) {
				modelicaAlwaysKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("never")) {
				modelicaNeverKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("prefer")) {
				modelicaPreferKind = enumerationLiteral;
				continue;
			}
			if (enumerationLiteral.getName().equals("avoid")) {
				modelicaAvoidKind = enumerationLiteral;
				continue;
			}
		}

	}

	private void setUnresolvedGeneralizations() {
		for (Classifier owner : unresolvedGeneralizations) {
			importInheritedClasses(owner);
		}
	}

	public static void importClass(String className, Element ownerElement) {
		className = className.replaceAll("\n", "");
		if (classQualifiedName == null) {
			classQualifiedName = className;
		} else {
			classQualifiedName = classQualifiedName + "." + className;
		}

		// create UML class
		Classifier class_ = null;

		String restriction = omc.getClassRestriction(classQualifiedName);
		restriction = restriction.replaceAll("\\n", "");
		restriction = restriction.replaceAll("\"", "");
		if (restriction.equals("block")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper.addStereotype(class_, modelicaBlockStereotype);
		} else if (restriction.equals("class")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper.addStereotype(class_, modelicaClassStereotype);
		} else if (restriction.equals("connector")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper
					.addStereotype(class_, modelicaConnectorStereotype);
		} else if (restriction.equals("enumeration")) {
			// TODO
		} else if (restriction.equals("expandable connector")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper
					.addStereotype(class_, modelicaConnectorStereotype);
			StereotypesHelper.setStereotypePropertyValue(class_,
					(Stereotype) class_.getAppliedStereotypeInstance()
							.getClassifier().get(0), "isExpandable", true);
		} else if (restriction.equals("function")) {
			class_ = magicDrawFactory.createFunctionBehaviorInstance();
			StereotypesHelper.addStereotype(class_, modelicaFunctionStereotype);

			// TODO set externalLibrary attribute
			// TODO set externalInclude attribute

		} else if (restriction.equals("model")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper.addStereotype(class_, modelicaModelStereotype);
		} else if (restriction.equals("package")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper.addStereotype(class_, modelicaPackageStereotype);
		} else if (restriction.equals("record")) {
			class_ = magicDrawFactory.createClassInstance();
			StereotypesHelper.addStereotype(class_, modelicaRecordStereotype);
		} else if (restriction.equals("type")) {
			if (hasEnumerationLiterals(classQualifiedName)) {
				class_ = magicDrawFactory.createEnumerationInstance();
			} else {
				// class_ = magicDrawFactory.createDataTypeInstance();
				class_ = magicDrawFactory.createClassInstance();
			}
			StereotypesHelper.addStereotype(class_, modelicaTypeStereotype);
		}

		class_.setName(className);
		traverseableTypes.add(class_);

		// add the class to its owner element
		if (ownerElement instanceof Package) {
			Package package_ = (Package) ownerElement;
			package_.getPackagedElement().add(class_);
		} else if (ownerElement instanceof Class) {
			Class ownerClass = (Class) ownerElement;
			ownerClass.getOwnedElement().add(class_);
		} else if (ownerElement instanceof DataType) {
			DataType dataType = (DataType) ownerElement;
			dataType.getOwnedElement().add(class_);
		} else {
			// throw exception
			// TODO
		}

		// import the class definition attributes
		importClassDefinitionAttributes(class_);

		// import import statements
		importImportStatements(class_);

		// import inheritedClasses
		importInheritedClasses(class_);

		// import components
		importClassComponents(class_);

		// import enumeration literals if enumeration
		importEnumerationLiterals(class_);

		// import external functions if functionBehavior
		importExternalFuntion(class_);

		// import nested classes
		importNestedClasses(class_);

		// import initial equations
		importClassInitialEquations(class_);

		// import equations
		importClassEquations(class_);

		// import connections
		importClassConnections(class_);

		// import algorithms if classifier is a class or a functionBehavior
		if (class_ instanceof Class) {
			if (StereotypesHelper.getFirstVisibleStereotype(class_) != modelicaFunctionStereotype) {
				Class class2 = (Class) class_;
				importClassInitialAlgorithms(class2);
				importClassAlgorithms(class2);
			} else {
				FunctionBehavior functionBehavior = (FunctionBehavior) class_;
				importClassInitialAlgorithms(functionBehavior);
				importClassAlgorithms(functionBehavior);
			}
		}

		classQualifiedName = classQualifiedName.replace("." + className, "");

	}

	private static void importExternalFuntion(Classifier class_) {
		if (class_ instanceof FunctionBehavior) {

			String classifierQualidfiedName = class_.getQualifiedName()
					.replaceAll("::", ".");
			String externalFunctionInformation = omc
					.getExternalFunctionSpecification(classifierQualidfiedName);
			ArrayList<String> classInformationList = StringHandler
					.unparseStrings(externalFunctionInformation);

			if (classInformationList.size() > 5) {
				String language = classInformationList.get(0);
				language = language.replaceAll("\"", "");
				String function = classInformationList.get(2);
				function = function.replaceAll("\"", "");

				FunctionBehavior functionBehavior = (FunctionBehavior) class_;
				functionBehavior.getLanguage().add(language);
				functionBehavior.getBody().add(function);

				String externalLibraries = omc.getNamedAnnotation(class_
						.getQualifiedName().replaceAll("::", "."), "Library");
				externalLibraries = externalLibraries.replace("{", "");
				externalLibraries = externalLibraries.replace("}", "");
				String[] externalLibrariesArray = externalLibraries.split(",");
				for (int i = 0; i < externalLibrariesArray.length; i++) {
					String string = externalLibrariesArray[i];
					string = string.replaceAll("\"", "");
					string = string.replace("\n", "");
					StereotypesHelper.setStereotypePropertyValue(class_,
							(Stereotype) class_.getAppliedStereotypeInstance()
									.getClassifier().get(0), "externalLibrary",
							string, true);

				}
			}
		}
	}

	private static void importInheritedClasses(Classifier owner) {
		String ownerQualifiedName = owner.getQualifiedName().replaceAll("::",
				".");

		List<String> inheritedClasses = omc
				.getInheritedClasses(ownerQualifiedName);
		boolean allGeneralizationsResolved = true;
		for (String inheritedClass : inheritedClasses) {

			if (inheritedClass
					.equals("SysML4Modelica.Types.ModelicaPredefinedTypes.ModelicaReal")) {
				inheritedClass = "Real";
			}

			String inheritedClassMDQFT = inheritedClass.replaceAll("\\.", "::");

			Classifier generalizedClass = (Classifier) getType(inheritedClassMDQFT);

			if (generalizedClass != null) {
				Generalization generalization = magicDrawFactory
						.createGeneralizationInstance();
				generalization.setGeneral(generalizedClass);
				generalization.setSpecific(owner);
				owner.getGeneralization().add(generalization);

				Stereotype extendsStereotype;
				if (omc.isShortDefinition(ownerQualifiedName)) {
					StereotypesHelper.addStereotype(generalization,
							modelicaShortExtendsStereotype);
					extendsStereotype = modelicaShortExtendsStereotype;
				} else {
					StereotypesHelper.addStereotype(generalization,
							modelicaExtendsStereotype);
					extendsStereotype = modelicaExtendsStereotype;
				}

				// modifications
				String extendsModificationName = omc.getExtendsModifierNames(
						ownerQualifiedName, inheritedClass);
				if (extendsModificationName.contains("{")) {
					extendsModificationName = extendsModificationName.replace(
							"{", "");
					extendsModificationName = extendsModificationName.replace(
							"}", "");
					extendsModificationName = extendsModificationName
							.replaceAll(" ", "");
					String[] modificationNamesArray = extendsModificationName
							.split(",");

					for (String modificationName : modificationNamesArray) {
						if (!modificationName.equals("\n")) {
							String modificationValue = omc
									.getExtendsModifierValue(
											ownerQualifiedName, inheritedClass,
											modificationName);
							modificationValue = modificationValue.replace("\n",
									"");
							modificationName = modificationName.replace("\n",
									"");
							if (!modificationName.equals("")
									& !modificationValue.contains("Error")) {
								StereotypesHelper.setStereotypePropertyValue(
										generalization, extendsStereotype,
										"modification", modificationName
												+ modificationValue, true);
							}
						}

					}
				}

				// causality
				if (extendsStereotype == modelicaShortExtendsStereotype) {
					String shortClassInformation = omc
							.getShortDefinitionBaseClassInformation(ownerQualifiedName);
					ArrayList<String> classInformationList = StringHandler
							.unparseStrings(shortClassInformation);
					if (classInformationList.size() == 6) {
						String causality = classInformationList.get(4);
						causality = causality.replace("{", "");
						causality = causality.replace("}", "");
						causality = causality.replaceAll("\"", "");
						if (!causality.equals("")) {
							if (causality.equals("input")) {
								StereotypesHelper.setStereotypePropertyValue(
										generalization,
										modelicaShortExtendsStereotype,
										"causality", modelicaInputKind);
							} else if (causality.equals("output")) {
								StereotypesHelper.setStereotypePropertyValue(
										generalization,
										modelicaShortExtendsStereotype,
										"causality", modelicaOutputKind);
							}
						}

					}
				}

				// TODO: visibility

				// arraysize
				String classInformation = omc.getClassInformation(owner
						.getQualifiedName().replace("::", "."));
				if (!classInformation.equals("error\n")) {

					int lastCommaIndex = classInformation.lastIndexOf("{");
					classInformation = classInformation.substring(
							lastCommaIndex + 1, classInformation.length());
					String newClassInformation = classInformation.replaceAll(
							"\n", "");
					// newClassInformation = newClassInformation.replaceAll("{",
					// "");
					newClassInformation = newClassInformation.replaceAll("}",
							"");

					String[] arraySizes = newClassInformation.split(",");

					// int lastCommaIndex = classInformation.lastIndexOf(",");

					// int lastBracketIndex = classInformation.lastIndexOf("}");
					// classInformation = classInformation.substring(0,
					// lastBracketIndex);
					// String arraySize = classInformation;
					// arraySize = arraySize.replace("{", "");
					// arraySize = arraySize.replace("}", "");
					// if (!arraySize.equals("")) {
					// StereotypesHelper.setStereotypePropertyValue(
					// generalization, extendsStereotype, "arraySize",
					// arraySize);
					// }

					// List<String> arraySizes = new ArrayList<String>();
					for (String string : arraySizes) {
						// check if string matches an Integer, otherwise warning
						try {
							if (!string.contains("none")
									& !string.contains("parameter")
									& !string.equals("")) {
								// if (Integer.valueOf(string) != null) {
								StereotypesHelper.setStereotypePropertyValue(
										generalization, extendsStereotype,
										"arraySize", string, true);
							}
							// else {
							// System.err
							// .println("WARNING: Component ArraySize Dimension not an Integer!");
							// }
						} catch (Exception e) {
						}
					}
				}
			} else {
				unresolvedGeneralizations.add(owner);
				allGeneralizationsResolved = false;
			}
		}
		if (allGeneralizationsResolved) {
			if (unresolvedGeneralizations.contains(owner)) {
				resolvedGeneralizations.add(owner);
			}
		}
	}

	private static void importNestedClasses(Classifier class_) {

		String classQualifiedName = class_.getQualifiedName().replaceAll("::",
				".");
		String classNames = omc.getClassNamesWithProtected(classQualifiedName);
		classNames = classNames.replace("{", "");
		classNames = classNames.replace("}", "");
		String[] classNamesArray = classNames.split(",");

		for (int i = 0; i < classNamesArray.length; i++) {
			String className = classNamesArray[i];
			classQualifiedName = null;
			if (!className.equals("\n")) {
				importClass(className, class_);
			}

		}

	}

	private static void importClassComponents(Classifier class_) {
		String classQualifiedName2 = class_.getQualifiedName().replaceAll("::",
				".");
		ArrayList<ModelicaComponentData> componentDataList = omc
				.getComponentData(classQualifiedName2);
		for (ModelicaComponentData modelicaComponentData : componentDataList) {
			importClassComponent(modelicaComponentData, class_);
		}
	}

	private static void importEnumerationLiterals(Classifier class_) {
		if (class_ instanceof Enumeration) {
			Enumeration enumeration = (Enumeration) class_;
			String enumerationLiterals = omc.getEnumerationLiterals(class_
					.getQualifiedName().replaceAll("::", "."));
			enumerationLiterals = enumerationLiterals.replace("{", "");
			enumerationLiterals = enumerationLiterals.replace("}", "");
			String[] enumerationLiteralsArray = enumerationLiterals.split(",");
			for (String enumLiteral : enumerationLiteralsArray) {
				enumLiteral = enumLiteral.replace("\"", "");
				if (!enumLiteral.equals("\n")) {
					EnumerationLiteral enumerationLiteral = magicDrawFactory
							.createEnumerationLiteralInstance();
					enumerationLiteral.setName(enumLiteral);
					enumeration.getOwnedLiteral().add(enumerationLiteral);
				}
			}
		}
	}

	private static boolean hasEnumerationLiterals(String classQualifiedName) {
		String enumerationLiterals = omc
				.getEnumerationLiterals(classQualifiedName);
		if (enumerationLiterals != null) {
			enumerationLiterals = enumerationLiterals.replace("{", "");
			enumerationLiterals = enumerationLiterals.replace("}", "");
			if (!enumerationLiterals.equals("\n")) {
				return true;
			}
		}
		return false;
	}

	private static void importImportStatements(Classifier class_) {
		String classifierQualifiedName = class_.getQualifiedName().replaceAll(
				"::", ".");
		int importStatementsCount = omc.getImportCount(classifierQualifiedName);

		for (int i = 1; i < importStatementsCount + 1; i++) {
			String importStatement = omc.getNthImport(classifierQualifiedName,
					i);
			importStatement = importStatement.replace("{", "");
			importStatement = importStatement.replace("}", "");
			if (importStatement.equals("\n") & i == 1
					& importStatementsCount == 1) {
				importStatement = omc.getNthImport(classifierQualifiedName, 2);
				importStatement = importStatement.replace("{", "");
				importStatement = importStatement.replace("}", "");
			}
			if (!importStatement.equals("\n")) {
				String[] importStatementArray = importStatement.split(",");
				String importedNamespace = importStatementArray[0].replaceAll(
						"\"", "");
				String newNamespace = importStatementArray[1].replaceAll("\"",
						"");
				String importStatementType = importStatementArray[2]
						.replaceAll("\"", "");

				if (importStatementType.contains("named")) {
					importMappings.put(newNamespace, importedNamespace);
					Comment comment = magicDrawFactory.createCommentInstance();
					String namedImport = "import "
							+ newNamespace.replaceAll("\"", "") + " = "
							+ importedNamespace.replaceAll("\"", "");
					comment.setBody(namedImport);
					class_.getOwnedComment().add(comment);
				} else if (importStatementType.contains("qualified")) {
					Comment comment = magicDrawFactory.createCommentInstance();
					String qualifiedImport = "import "
							+ importedNamespace.replaceAll("\"", "");
					comment.setBody(qualifiedImport);
					class_.getOwnedComment().add(comment);
				}
			}
		}
	}

	private static void importClassInitialAlgorithms(Class class_) {
		for (String algorithm : omc.getInitialAlgorithms(classQualifiedName)) {
			OpaqueBehavior opaqueBehavior = magicDrawFactory
					.createOpaqueBehaviorInstance();
			algorithm = algorithm.substring(0, algorithm.lastIndexOf("\n"));
			opaqueBehavior.getBody().add(algorithm);
			opaqueBehavior.getLanguage().add(new String("Modelica"));
			StereotypesHelper.addStereotype(opaqueBehavior,
					modelicaAlgorithmStereotype);
			class_.getOwnedBehavior().add(opaqueBehavior);
			StereotypesHelper.setStereotypePropertyValue(opaqueBehavior,
					modelicaAlgorithmStereotype, "isInitial", true);
		}
	}

	private static void importClassInitialEquations(Classifier class_) {

		for (String equation : omc.getInitialEquations(classQualifiedName)) {
			System.out.println(equation);

			// create SysML connector
			if (equation.startsWith("connect(")) {
				// additional processing for connect equations
				continue;
			}

			// create SysML constraint
			Constraint constraint = magicDrawFactory.createConstraintInstance();
			OpaqueExpression opaqueExpression = magicDrawFactory
					.createOpaqueExpressionInstance();
			// equation = equation.replaceFirst(";", "");
			equation = equation.substring(0, equation.lastIndexOf("\n"));
			opaqueExpression.getBody().add(equation);
			opaqueExpression.getLanguage().add(new String("Modelica"));
			constraint.setSpecification(opaqueExpression);
			StereotypesHelper.addStereotype(constraint,
					modelicaEquationStereotype);
			class_.getOwnedRule().add(constraint);

			StereotypesHelper.setStereotypePropertyValue(constraint,
					modelicaEquationStereotype, "isInitial", true);
		}
	}

	private static void importClassDefinitionAttributes(Classifier class_) {

		String className = class_.getName();
		String classInformation = omc.getClassInformation(classQualifiedName);
		ArrayList<String> classInformationList = StringHandler
				.unparseStrings(classInformation);
		boolean isFinal = false;
		boolean isPartial = false;
		boolean isEncapsulated = false;
		if (classInformationList.size() == 10) {
			String classDefinitionAttributes = classInformationList.get(3);
			classDefinitionAttributes = classDefinitionAttributes.replace("{",
					"");
			classDefinitionAttributes = classDefinitionAttributes.replace("}",
					"");
			String[] classDefinitionAttributesArray = classDefinitionAttributes
					.split(",");

			String isFinalString = classDefinitionAttributesArray[1];
			isFinal = Boolean.valueOf(isFinalString);
			String isPartialString = classDefinitionAttributesArray[0];
			isPartial = Boolean.valueOf(isPartialString);
			String isEncapsulatedString = classDefinitionAttributesArray[2];
			isEncapsulated = Boolean.valueOf(isEncapsulatedString);
		}

		StereotypesHelper.setStereotypePropertyValue(class_,
				(Stereotype) class_.getAppliedStereotypeInstance()
						.getClassifier().get(0), "isFinal", isFinal);

		StereotypesHelper.setStereotypePropertyValue(class_,
				(Stereotype) class_.getAppliedStereotypeInstance()
						.getClassifier().get(0), "isPartial", isPartial);

		StereotypesHelper.setStereotypePropertyValue(class_,
				(Stereotype) class_.getAppliedStereotypeInstance()
						.getClassifier().get(0), "isModelicaEncapsulated",
				isEncapsulated);

		NamedElement ownerNamedElement = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.NamedElement) class_
				.getOwner();
		String ownerQualifiedName = ownerNamedElement.getQualifiedName()
				.replaceAll("::", ".");
		boolean isReplaceable = omc
				.isReplaceable(ownerQualifiedName, className);

		if (isReplaceable) {
			StereotypesHelper.setStereotypePropertyValue(class_,
					(Stereotype) class_.getAppliedStereotypeInstance()
							.getClassifier().get(0), "isReplaceable",
					isReplaceable);
		}
	}

	private static void importClassAlgorithms(Class class_) {

		for (String algorithm : omc.getAlgorithms(classQualifiedName)) {
			OpaqueBehavior opaqueBehavior = magicDrawFactory
					.createOpaqueBehaviorInstance();
			opaqueBehavior.getBody().add(algorithm);
			opaqueBehavior.getLanguage().add(new String("Modelica"));
			StereotypesHelper.addStereotype(opaqueBehavior,
					modelicaAlgorithmStereotype);
			class_.getOwnedBehavior().add(opaqueBehavior);
		}
	}

	private static void importClassEquations(Classifier class_) {
		for (String equation : omc.getEquations(classQualifiedName)) {
			System.out.println(equation);

			// create SysML connector
			if (equation.startsWith("connect(")) {
				if (equation.contains("[")) {
					// equation example from RobotExample:
					// motion_ref_axisUsed.u,moving[axisUsed] in
					// Modelica2::Mechanics::MultiBody::Examples::Systems::RobotR3::Components::PathToAxisControlBus
				} else {
					// additional processing for connect equations
					continue;
				}
			}

			// create SysML constraint
			Constraint constraint = magicDrawFactory.createConstraintInstance();
			OpaqueExpression opaqueExpression = magicDrawFactory
					.createOpaqueExpressionInstance();
			opaqueExpression.getBody().add(equation);
			opaqueExpression.getLanguage().add(new String("Modelica"));
			constraint.setSpecification(opaqueExpression);
			StereotypesHelper.addStereotype(constraint,
					modelicaEquationStereotype);
			class_.getOwnedRule().add(constraint);
		}
	}

	public static void importClassConnections(Classifier class_) {
		for (String connection : omc.getConnections(class_.getQualifiedName()
				.replaceAll("::", "."))) {
			connection = connection.replaceAll("\\{", "");
			connection = connection.replaceAll("\\}", "");
			connection = connection.replaceAll(String.valueOf('"'), "");

			if (connection.contains("[")) {
				continue;
			}

			ModelicaConnectionData modelicaConnectionData = new ModelicaConnectionData(
					connection, class_);

			String[] connectorEnds = connection.split(",");
			String[] connectorEnd1Str = connectorEnds[0].split("\\.");

			String connectorEnd1PartName = null;
			String connectorEnd1PortName = null;
			String connectorEnd2PartName = null;
			String connectorEnd2PortName = null;

			boolean isEnd1Single = false;
			boolean isEnd2Single = false;

			if (connectorEnd1Str.length == 1) {
				// it is a port
				connectorEnd1PortName = connectorEnd1Str[0];
				isEnd1Single = true;
			} else {
				connectorEnd1PartName = connectorEnd1Str[0];
				connectorEnd1PortName = connectorEnd1Str[1];
			}

			String[] connectorEnd2Str = connectorEnds[1].split("\\.");
			if (connectorEnd2Str.length == 1) {
				// it is a port
				connectorEnd2PortName = connectorEnd2Str[0];
				isEnd2Single = true;
			} else {
				connectorEnd2PartName = connectorEnd2Str[0];
				connectorEnd2PortName = connectorEnd2Str[1];
			}

			Property part1 = getProperty(class_, connectorEnd1PartName);
			Property part2 = getProperty(class_, connectorEnd2PartName);
			Property port1 = null;
			Property port2 = null;

			// the part property may not yet be found because the part type may
			// not yet have been mapped into SysML
			if (!isEnd1Single & !isEnd2Single) {
				if (part1 != null & part2 != null) {
					Type part1Type = part1.getType();
					Type part2Type = part2.getType();

					port1 = getProperty((Class) part1Type,
							connectorEnd1PortName);
					port2 = getProperty((Class) part2Type,
							connectorEnd2PortName);

					if ((port1 != null) & (port2 != null)) {

						// create SysML connector
						Connector connector = magicDrawFactory
								.createConnectorInstance();

						ConnectorEnd connectorEnd1 = connector.getEnd().get(0);
						ConnectorEnd connectorEnd2 = connector.getEnd().get(1);

						connectorEnd1.setPartWithPort(part1);
						connectorEnd1.setRole(port1);
						StereotypesHelper.addStereotype(connectorEnd1,
								nestedConnectorEndStereotype);
						StereotypesHelper.setStereotypePropertyValue(
								connectorEnd1, nestedConnectorEndStereotype,
								"propertyPath", part1);

						connectorEnd2.setPartWithPort(part2);
						connectorEnd2.setRole(port2);
						StereotypesHelper.addStereotype(connectorEnd2,
								nestedConnectorEndStereotype);
						StereotypesHelper.setStereotypePropertyValue(
								connectorEnd2, nestedConnectorEndStereotype,
								"propertyPath", part2);

						connector.setName(connection);
						// connector.
						// .setKind(ConnectorKindEnum.ASSEMBLY);
						if (class_ instanceof Class) {
							Class class2 = (Class) class_;
							class2.getOwnedConnector().add(connector);
							StereotypesHelper.addStereotype(connector,
									modelicaConnectionStereotype);
						}
					} else {
						// resolve connections at second traversal
						if (class_ instanceof Class) {
							unresolvedConnections.add(modelicaConnectionData);
						}
					}
				} else {
					// resolve connections at second traversal
					if (class_ instanceof Class) {
						unresolvedConnections.add(modelicaConnectionData);
					}
				}
			} else if (!isEnd1Single & isEnd2Single) {
				if (part1 != null) {
					Type part1Type = part1.getType();

					port1 = getProperty((Class) part1Type,
							connectorEnd1PortName);
					port2 = getProperty(class_, connectorEnd2PortName);

					if ((port1 != null) & (port2 != null)) {

						// create SysML connector
						Connector connector = magicDrawFactory
								.createConnectorInstance();

						ConnectorEnd connectorEnd1 = connector.getEnd().get(0);
						ConnectorEnd connectorEnd2 = connector.getEnd().get(1);

						connectorEnd1.setPartWithPort(part1);
						connectorEnd1.setRole(port1);
						connectorEnd2.setRole(port2);

						connector.setName(connection);
						// connector.
						// .setKind(ConnectorKindEnum.ASSEMBLY);
						if (class_ instanceof Class) {
							Class class2 = (Class) class_;
							class2.getOwnedConnector().add(connector);

							StereotypesHelper.addStereotype(connector,
									modelicaConnectionStereotype);
						}

					} else {
						// resolve connections at second traversal
						if (class_ instanceof Class) {
							unresolvedConnections.add(modelicaConnectionData);
						}

					}
				} else {
					// resolve connections at second traversal
					if (class_ instanceof Class) {
						unresolvedConnections.add(modelicaConnectionData);
					}
				}
			} else if (isEnd1Single & !isEnd2Single) {
				if (part2 != null) {
					Type part2Type = part2.getType();

					port2 = getProperty((Class) part2Type,
							connectorEnd2PortName);
					port1 = getProperty(class_, connectorEnd1PortName);

					if ((port1 != null) & (port2 != null)) {

						// create SysML connector
						Connector connector = magicDrawFactory
								.createConnectorInstance();

						ConnectorEnd connectorEnd1 = connector.getEnd().get(0);
						ConnectorEnd connectorEnd2 = connector.getEnd().get(1);

						connectorEnd1.setRole(port1);
						connectorEnd2.setPartWithPort(part2);
						connectorEnd2.setRole(port2);

						connector.setName(connection);
						// connector.
						// .setKind(ConnectorKindEnum.ASSEMBLY);
						if (class_ instanceof Class) {
							Class class2 = (Class) class_;
							class2.getOwnedConnector().add(connector);

							StereotypesHelper.addStereotype(connector,
									modelicaConnectionStereotype);
						}
					} else {
						// resolve connections at second traversal
						if (class_ instanceof Class) {
							unresolvedConnections.add(modelicaConnectionData);
						}
					}
				} else {
					// resolve connections at second traversal
					if (class_ instanceof Class) {
						unresolvedConnections.add(modelicaConnectionData);
					}
				}
			} else if (isEnd1Single & isEnd2Single) {

				port2 = getProperty(class_, connectorEnd2PortName);
				port1 = getProperty(class_, connectorEnd1PortName);

				if ((port1 != null) & (port2 != null)) {

					// create SysML connector
					Connector connector = magicDrawFactory
							.createConnectorInstance();

					ConnectorEnd connectorEnd1 = connector.getEnd().get(0);
					ConnectorEnd connectorEnd2 = connector.getEnd().get(1);

					connectorEnd1.setRole(port1);
					connectorEnd2.setRole(port2);

					connector.setName(connection);
					// connector.
					// .setKind(ConnectorKindEnum.ASSEMBLY);
					if (class_ instanceof Class) {
						Class class2 = (Class) class_;
						class2.getOwnedConnector().add(connector);

						StereotypesHelper.addStereotype(connector,
								modelicaConnectionStereotype);
					}
				} else {
					// resolve connections at second traversal
					if (class_ instanceof Class) {
						unresolvedConnections.add(modelicaConnectionData);
					}
				}

			}
		}
	}

	public static void importClassConnection(
			ModelicaConnectionData modelicaConnectionData) {
		String specificConnection = modelicaConnectionData.getConnection();
		Class class_ = (Class) modelicaConnectionData.getClassifier();
		for (String connection : omc.getConnections(class_.getQualifiedName()
				.replaceAll("::", "."))) {
			connection = connection.replaceAll("\\{", "");
			connection = connection.replaceAll("\\}", "");
			connection = connection.replaceAll(String.valueOf('"'), "");
			if (connection.equals(specificConnection)) {
				connection = connection.replaceAll("\\{", "");
				connection = connection.replaceAll("\\}", "");
				connection = connection.replaceAll(String.valueOf('"'), "");

				String[] connectorEnds = connection.split(",");
				String[] connectorEnd1Str = connectorEnds[0].split("\\.");

				String connectorEnd1PartName = null;
				String connectorEnd1PortName = null;
				String connectorEnd2PartName = null;
				String connectorEnd2PortName = null;

				boolean isEnd1Single = false;
				boolean isEnd2Single = false;

				if (connectorEnd1Str.length == 1) {
					// it is a port
					connectorEnd1PortName = connectorEnd1Str[0];
					isEnd1Single = true;
				} else {
					connectorEnd1PartName = connectorEnd1Str[0];
					connectorEnd1PortName = connectorEnd1Str[1];
				}

				String[] connectorEnd2Str = connectorEnds[1].split("\\.");
				if (connectorEnd2Str.length == 1) {
					// it is a port
					connectorEnd2PortName = connectorEnd2Str[0];
					isEnd2Single = true;
				} else {
					connectorEnd2PartName = connectorEnd2Str[0];
					connectorEnd2PortName = connectorEnd2Str[1];
				}

				Property part1 = getProperty(class_, connectorEnd1PartName);
				Property part2 = getProperty(class_, connectorEnd2PartName);
				Property port1 = null;
				Property port2 = null;

				// the part property may not yet be found because the part type
				// may not yet have been mapped into SysML
				if (!isEnd1Single & !isEnd2Single) {
					if (part1 != null & part2 != null) {
						Type part1Type = part1.getType();
						Type part2Type = part2.getType();

						port1 = getProperty((Class) part1Type,
								connectorEnd1PortName);
						port2 = getProperty((Class) part2Type,
								connectorEnd2PortName);

						if ((port1 != null) & (port2 != null)) {
							// create SysML connector
							Connector connector = magicDrawFactory
									.createConnectorInstance();
							ConnectorEnd connectorEnd1 = connector.getEnd()
									.get(0);
							ConnectorEnd connectorEnd2 = connector.getEnd()
									.get(1);
							connectorEnd1.setPartWithPort(part1);
							connectorEnd1.setRole(port1);
							StereotypesHelper.addStereotype(connectorEnd1,
									nestedConnectorEndStereotype);
							StereotypesHelper.setStereotypePropertyValue(
									connectorEnd1,
									nestedConnectorEndStereotype,
									"propertyPath", part1);
							connectorEnd2.setPartWithPort(part2);
							connectorEnd2.setRole(port2);
							StereotypesHelper.addStereotype(connectorEnd2,
									nestedConnectorEndStereotype);
							StereotypesHelper.setStereotypePropertyValue(
									connectorEnd2,
									nestedConnectorEndStereotype,
									"propertyPath", part2);
							connector.setName(connection);
							// connector.
							// .setKind(ConnectorKindEnum.ASSEMBLY);
							if (class_ instanceof Class) {
								Class class2 = (Class) class_;
								class2.getOwnedConnector().add(connector);
								StereotypesHelper.addStereotype(connector,
										modelicaConnectionStereotype);
							}
							if (unresolvedConnections
									.contains(modelicaConnectionData)) {
								if (class_ instanceof Class) {
									Class class2 = (Class) class_;
									resolvedConnections
											.add(modelicaConnectionData);
								}
							}
						} else {
							// ControlBus and AxisControlBus are empty
							// connectors that need to be handled specially
							if (part1Type.getName().equals("ControlBus")
									| part1Type.getName().equals(
											"AxisControlBus")) {
								port2 = getProperty((Class) part2Type,
										connectorEnd2PortName);
								// create SysML connector
								Connector connector = magicDrawFactory
										.createConnectorInstance();
								ConnectorEnd connectorEnd1 = connector.getEnd()
										.get(0);
								ConnectorEnd connectorEnd2 = connector.getEnd()
										.get(1);
								connectorEnd1.setPartWithPort(part1);
								connectorEnd2.setPartWithPort(part2);
								connectorEnd2.setRole(port2);
								StereotypesHelper.addStereotype(connectorEnd2,
										nestedConnectorEndStereotype);
								StereotypesHelper.setStereotypePropertyValue(
										connectorEnd2,
										nestedConnectorEndStereotype,
										"propertyPath", part2);
								connector.setName(connection);
								if (class_ instanceof Class) {
									Class class2 = (Class) class_;
									class2.getOwnedConnector().add(connector);
									StereotypesHelper.addStereotype(connector,
											modelicaConnectionStereotype);
								}
								if (unresolvedConnections
										.contains(modelicaConnectionData)) {
									if (class_ instanceof Class) {
										resolvedConnections
												.add(modelicaConnectionData);
									}
								}
							} else if (part2Type.getName().equals("ControlBus")
									| part2Type.getName().equals(
											"AxisControlBus")) {
								port1 = getProperty((Class) part1Type,
										connectorEnd1PortName);
								// create SysML connector
								Connector connector = magicDrawFactory
										.createConnectorInstance();
								ConnectorEnd connectorEnd1 = connector.getEnd()
										.get(0);
								ConnectorEnd connectorEnd2 = connector.getEnd()
										.get(1);
								connectorEnd1.setPartWithPort(part1);
								connectorEnd1.setRole(port1);
								StereotypesHelper.addStereotype(connectorEnd1,
										nestedConnectorEndStereotype);
								StereotypesHelper.setStereotypePropertyValue(
										connectorEnd1,
										nestedConnectorEndStereotype,
										"propertyPath", part1);
								connectorEnd2.setPartWithPort(part2);
								connector.setName(connection);
								if (class_ instanceof Class) {
									Class class2 = (Class) class_;
									class2.getOwnedConnector().add(connector);
									StereotypesHelper.addStereotype(connector,
											modelicaConnectionStereotype);
								}
								if (unresolvedConnections
										.contains(modelicaConnectionData)) {
									if (class_ instanceof Class) {
										resolvedConnections
												.add(modelicaConnectionData);
									}
								}
							} else {
								// resolve connections at second traversal
								if (class_ instanceof Class) {
									unresolvedConnections
											.add(modelicaConnectionData);
								}
							}

						}
					} else {
						// resolve connections at second traversal
						if (class_ instanceof Class) {
							unresolvedConnections.add(modelicaConnectionData);
						}

					}
				} else if (!isEnd1Single & isEnd2Single) {
					if (part1 != null) {
						Type part1Type = part1.getType();

						port1 = getProperty((Class) part1Type,
								connectorEnd1PortName);
						port2 = getProperty(class_, connectorEnd2PortName);

						if ((port1 != null) & (port2 != null)) {

							// create SysML connector
							Connector connector = magicDrawFactory
									.createConnectorInstance();

							ConnectorEnd connectorEnd1 = connector.getEnd()
									.get(0);
							ConnectorEnd connectorEnd2 = connector.getEnd()
									.get(1);

							connectorEnd1.setPartWithPort(part1);
							connectorEnd1.setRole(port1);
							StereotypesHelper.addStereotype(connectorEnd1,
									nestedConnectorEndStereotype);
							StereotypesHelper.setStereotypePropertyValue(
									connectorEnd1,
									nestedConnectorEndStereotype,
									"propertyPath", part1);
							connectorEnd2.setRole(port2);

							connector.setName(connection);
							// connector.
							// .setKind(ConnectorKindEnum.ASSEMBLY);
							if (class_ instanceof Class) {
								Class class2 = (Class) class_;
								class2.getOwnedConnector().add(connector);
								StereotypesHelper.addStereotype(connector,
										modelicaConnectionStereotype);
							}
							if (unresolvedConnections
									.contains(modelicaConnectionData)) {
								if (class_ instanceof Class) {
									resolvedConnections
											.add(modelicaConnectionData);
								}
							}
						} else {
							// resolve connections at second traversal
							if (class_ instanceof Class) {
								unresolvedConnections
										.add(modelicaConnectionData);
							}
						}
					}
				} else if (isEnd1Single & !isEnd2Single) {
					if (part2 != null) {
						Type part2Type = part2.getType();
						// Type part2Type = part2.getType();

						port2 = getProperty((Class) part2Type,
								connectorEnd2PortName);
						port1 = getProperty(class_, connectorEnd1PortName);

						if ((port1 != null) & (port2 != null)) {

							// create SysML connector
							Connector connector = magicDrawFactory
									.createConnectorInstance();

							ConnectorEnd connectorEnd1 = connector.getEnd()
									.get(0);
							ConnectorEnd connectorEnd2 = connector.getEnd()
									.get(1);

							// connectorEnd1.setPartWithPort(part1);
							connectorEnd1.setRole(port1);
							connectorEnd2.setPartWithPort(part2);
							connectorEnd2.setRole(port2);
							StereotypesHelper.addStereotype(connectorEnd2,
									nestedConnectorEndStereotype);
							StereotypesHelper.setStereotypePropertyValue(
									connectorEnd2,
									nestedConnectorEndStereotype,
									"propertyPath", part2);
							connector.setName(connection);
							// connector.
							// .setKind(ConnectorKindEnum.ASSEMBLY);
							if (class_ instanceof Class) {
								Class class2 = (Class) class_;
								class2.getOwnedConnector().add(connector);

								StereotypesHelper.addStereotype(connector,
										modelicaConnectionStereotype);
							}

							if (unresolvedConnections
									.contains(modelicaConnectionData)) {
								if (class_ instanceof Class) {
									resolvedConnections
											.add(modelicaConnectionData);
								}
							}
						} else {
							// resolve connections at second traversal
							if (class_ instanceof Class) {
								unresolvedConnections
										.add(modelicaConnectionData);
							}

						}
					}
				} else if (isEnd1Single & isEnd2Single) {

					port2 = getProperty(class_, connectorEnd2PortName);
					port1 = getProperty(class_, connectorEnd1PortName);

					if ((port1 != null) & (port2 != null)) {

						// create SysML connector
						Connector connector = magicDrawFactory
								.createConnectorInstance();

						ConnectorEnd connectorEnd1 = connector.getEnd().get(0);
						ConnectorEnd connectorEnd2 = connector.getEnd().get(1);

						connectorEnd1.setRole(port1);
						connectorEnd2.setRole(port2);

						connector.setName(connection);
						// connector.
						// .setKind(ConnectorKindEnum.ASSEMBLY);
						if (class_ instanceof Class) {
							Class class2 = (Class) class_;
							class2.getOwnedConnector().add(connector);

							StereotypesHelper.addStereotype(connector,
									modelicaConnectionStereotype);
						}

						if (unresolvedConnections.contains(specificConnection)) {
							if (class_ instanceof Class) {
								resolvedConnections.add(modelicaConnectionData);
							}
						}
					} else {
						// resolve connections at second traversal
						if (class_ instanceof Class) {
							unresolvedConnections.add(modelicaConnectionData);
						}
					}
				}
			}
		}
	}

	public static Type getType(String qualifiedTypeName) {

		if (qualifiedTypeName.equals("Real")) {
			return modelicaRealType;
		} else if (qualifiedTypeName.equals("Integer")) {
			return modelicaIntegerType;
		} else if (qualifiedTypeName.equals("Boolean")) {
			return modelicaBooleanType;
		} else if (qualifiedTypeName.equals("String")) {
			return modelicaStringType;
		} else if (qualifiedTypeName.equals("StateSelect")) {
			return modelicaStateSelectKind;
		}

		// need to find the correct segment comparison
		for (PackageableElement packageableElement : traverseableTypes) {
			if (packageableElement instanceof Type) {
				if (packageableElement.getQualifiedName().contains(
						qualifiedTypeName)) {
					String[] traverseableTypeQNSegments = packageableElement
							.getQualifiedName().split("::");
					String[] qualifiedTypeQNSegments = qualifiedTypeName
							.split("::");
					// go from right to left to check for identity until size of
					// qualifiedTypeQNSegments is full
					boolean isMatch = false;
					for (int i = 0; i < qualifiedTypeQNSegments.length; i++) {
						String qualifiedTypeQNSegment = qualifiedTypeQNSegments[qualifiedTypeQNSegments.length
								- i - 1];
						String traverseableTypeQNSegment = traverseableTypeQNSegments[traverseableTypeQNSegments.length
								- i - 1];
						if (qualifiedTypeQNSegment
								.equals(traverseableTypeQNSegment)) {
							isMatch = true;
						} else {
							isMatch = false;
							break;
						}
					}
					if (isMatch) {
						return (Type) packageableElement;
					}
				}
			}
		}

		// check if a new namespace is used
		for (String newNamespace : importMappings.keySet()) {
			if (qualifiedTypeName.contains(newNamespace + "::")) {
				String importedNamespace = importMappings.get(newNamespace)
						.replaceAll("\\.", "::");
				qualifiedTypeName = qualifiedTypeName.replaceFirst(newNamespace
						+ "::", importedNamespace + "::");

				for (PackageableElement packageableElement : traverseableTypes) {
					if (packageableElement instanceof Type) {
						if (packageableElement.getQualifiedName().contains(
								qualifiedTypeName)) {
							String[] traverseableTypeQNSegments = packageableElement
									.getQualifiedName().split("::");
							String[] qualifiedTypeQNSegments = qualifiedTypeName
									.split("::");
							// go from right to left to check for identity until
							// size of qualifiedTypeQNSegments is full
							boolean isMatch = false;
							for (int i = 0; i < qualifiedTypeQNSegments.length; i++) {
								String qualifiedTypeQNSegment = qualifiedTypeQNSegments[qualifiedTypeQNSegments.length
										- i - 1];
								String traverseableTypeQNSegment = traverseableTypeQNSegments[traverseableTypeQNSegments.length
										- i - 1];
								if (qualifiedTypeQNSegment
										.equals(traverseableTypeQNSegment)) {
									isMatch = true;
								} else {
									isMatch = false;
									break;
								}
							}
							if (isMatch) {
								return (Type) packageableElement;
							}
						}
					}
				}
			}
		}
		return null;
	}

	private Type getTypeFromProfile(Project project, String typeName) {
		for (PackageableElement sysmopackageableElement : sysML4ModelicaProfile
				.getPackagedElement()) {
			if (sysmopackageableElement.getName().equals("Types")) {
				Package realtypesPack = (Package) sysmopackageableElement;
				for (Type type2 : realtypesPack.getOwnedType()) {
					if (type2.getName().contains("ModelicaPredefinedTypes")) {
						for (Element moElement : type2.getOwnedElement()) {
							if (moElement instanceof DataType) {
								DataType realClass = (DataType) moElement;
								if (realClass.getName().equals(typeName)) {
									return realClass;
								}
							} else if (moElement instanceof Enumeration) {
								Enumeration realClass = (Enumeration) moElement;
								if (realClass.getName().equals(typeName)) {
									return realClass;
								}
							}
						}
						return type2;
					}
				}
			}
		}
		return null;
	}

	private Enumeration getEnumeration(Project project, String typeName) {
		for (PackageableElement packageableElement : project.getModel()
				.getPackagedElement()) {
			if (packageableElement instanceof Package) {
				if (packageableElement.getName().equals("SysML4Modelica")) {
					Package sysml4mopack = (Package) packageableElement;
					for (PackageableElement sysmopackageableElement : sysml4mopack
							.getPackagedElement()) {
						if (sysmopackageableElement.getName().equals("Types")) {
							Package realtypesPack = (Package) sysmopackageableElement;
							for (Type type2 : realtypesPack.getOwnedType()) {
								if (type2 instanceof Enumeration) {
									Enumeration realClass = (Enumeration) type2;
									if (realClass.getName().equals(typeName)) {
										return realClass;
									}
								}
							}
						}
					}
				}
			}
		}
		return null;
	}

	public static Profile getSysML4ModelicaProfile(Project project) {
		for (PackageableElement packageableElement : project.getModel()
				.getPackagedElement()) {
			if (packageableElement instanceof Profile) {
				if (packageableElement.getName().equals("SysML4Modelica")) {
					return (Profile) packageableElement;
				}
			}
		}
		return null;
	}

	public static void setUnresolvedComponents() {
		for (ModelicaComponentData modelicaComponentData : unresolvedComponents
				.keySet()) {
			Classifier classifier = unresolvedComponents
					.get(modelicaComponentData);
			importClassComponent(modelicaComponentData, classifier);
		}
	}

	public static void setUnresolvedConnections() {
		for (ModelicaConnectionData modelicaConnectionData : unresolvedConnections) {
			importClassConnection(modelicaConnectionData);
		}
	}

	private static void importClassComponent(
			ModelicaComponentData modelicaComponentData, Classifier classifier) {
		String propertyName = modelicaComponentData.getName();
		String propertyTypeQFName = modelicaComponentData.getTypeQName();
		String propertyTypeQFName2 = propertyTypeQFName.replaceAll("\\.", "::");

		// get property type qualified name
		Type propertyType = null;
		propertyType = getType(propertyTypeQFName2);

		Stereotype classStereotype = (Stereotype) classifier
				.getAppliedStereotypeInstance().getClassifier().get(0);

		if (!isLastTraversal) {
			// all components will be resolved at last
			// traversal in order to maintain their
			// order
			propertyType = null;
		}

		// create UML property or port or function parameter
		if (propertyType != null) {
			Stereotype appliedStereotype = (Stereotype) propertyType
					.getAppliedStereotypeInstance().getClassifier().get(0);
			if (classStereotype != modelicaFunctionStereotype) {
				if (appliedStereotype == modelicaRecordStereotype
						| appliedStereotype == modelicaTypeStereotype) {
					Property property = magicDrawFactory
							.createPropertyInstance();
					property.setName(propertyName);
					property.setType(propertyType);
					StereotypesHelper.addStereotype(property,
							modelicaValuePropertyStereotype);
					classifier.getAttribute().add(property);

					importClassComponentAttributes(modelicaComponentData,
							property, classifier);

				} else if (appliedStereotype == modelicaClassStereotype
						| appliedStereotype == modelicaModelStereotype
						| appliedStereotype == modelicaBlockStereotype) {
					Property property = magicDrawFactory
							.createPropertyInstance();
					property.setName(propertyName);
					property.setType(propertyType);
					StereotypesHelper.addStereotype(property,
							modelicaPartStereotype);
					classifier.getAttribute().add(property);

					importClassComponentAttributes(modelicaComponentData,
							property, classifier);

				} else if (appliedStereotype == modelicaConnectorStereotype) {
					Port port = magicDrawFactory.createPortInstance();
					port.setName(propertyName);
					port.setType(propertyType);
					StereotypesHelper.addStereotype(port,
							modelicaPortStereotype);
					classifier.getAttribute().add(port);

					importClassComponentAttributes(modelicaComponentData, port,
							classifier);

				}
			} else if (classStereotype == modelicaFunctionStereotype) {
				Parameter parameter = magicDrawFactory
						.createParameterInstance();
				parameter.setName(modelicaComponentData.getName());
				parameter.setType(propertyType);
				StereotypesHelper.addStereotype(parameter,
						modelicaFunctionParameterStereotype);
				FunctionBehavior functionBehavior = (FunctionBehavior) classifier;
				functionBehavior.getOwnedParameter().add(parameter);

				importClassComponentAttributes(modelicaComponentData,
						parameter, classifier);
			}

			if (unresolvedComponents.containsKey(modelicaComponentData)) {
				resolvedComponents.put(modelicaComponentData, classifier);
			}
		} else {
			if (!isLastTraversal) {
				unresolvedComponents.put(modelicaComponentData, classifier);
			}
		}

	}

	private static void importFinalPrefix(boolean isFinal, TypedElement property) {
		if (isFinal) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "isFinal", isFinal);
		}
	}

	private static void importScope(String innerOuter_UT, TypedElement property) {
		if (innerOuter_UT.contains("inner")) {
			StereotypesHelper
					.setStereotypePropertyValue(property, (Stereotype) property
							.getAppliedStereotypeInstance().getClassifier()
							.get(0), "scope", modelicaInnerKind);
		} else if (innerOuter_UT.contains("outer")) {
			StereotypesHelper
					.setStereotypePropertyValue(property, (Stereotype) property
							.getAppliedStereotypeInstance().getClassifier()
							.get(0), "scope", modelicaOuterKind);
		}
	}

	private static void importArraySize(List<String> arraySize,
			TypedElement property) {
		if (arraySize != null) {
			for (String string : arraySize) {
				// check if string matches an Integer, otherwise warning
				try {
					if (!string.contains("none")
							& !string.contains("parameter")) {
						// if (Integer.valueOf(string) != null) {
						StereotypesHelper.setStereotypePropertyValue(property,
								(Stereotype) property
										.getAppliedStereotypeInstance()
										.getClassifier().get(0), "arraySize",
								string, true);
					}
					// else {
					// System.err
					// .println("WARNING: Component ArraySize Dimension not an Integer!");
					// }
				} catch (Exception e) {

				}

			}
		}
	}

	private static void importFlow(ModelicaComponentData modelicaComponentData,
			TypedElement property) {
		if (modelicaComponentData.isFlow()) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "flowFlag",
					modelicaFlowKind);
		}
		if (modelicaComponentData.isStream()) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "flowFlag",
					modelicaStreamKind);
		}
	}

	private static void importDeclarationEquation(TypedElement property,
			Classifier classifier) {
		String propertyName = property.getName();
		// get component declaration equation
		String declarationEquation = omc.getDeclarationEquation(classifier
				.getQualifiedName().replaceAll("::", "."), propertyName);
		declarationEquation = declarationEquation.replaceAll("\n", "");
		if (declarationEquation != null) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "declarationEquation",
					declarationEquation);
		}

	}

	private static void importConditionalExpression(
			String classifierQualifiedName, int componentIndex,
			TypedElement property) {
		if (componentIndex > 1) {
			String conditionalExpression = omc.getNthComponentCondition(
					classifierQualifiedName, componentIndex);
			conditionalExpression = conditionalExpression.replace("\"", "");
			if (conditionalExpression != null) {
				if (!conditionalExpression.equals("\n")) {
					StereotypesHelper.setStereotypePropertyValue(property,
							(Stereotype) property
									.getAppliedStereotypeInstance()
									.getClassifier().get(0),
							"conditionalExpression", conditionalExpression);
				}
			}
		}
	}

	private static void importVisibility(String visibility,
			TypedElement property) {
		visibility = visibility.replaceAll("\"", "");
		if (visibility != null) {
			if (visibility.contains("public")) {
				property.setVisibility(VisibilityKindEnum.PUBLIC);
			} else if (visibility.contains("protected")) {
				property.setVisibility(VisibilityKindEnum.PROTECTED);
			}
		}
	}

	private static void importVariability(String variability,
			TypedElement property) {
		if (variability.contains("const")) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "variability",
					modelicaConstantKind);
		} else if (variability.contains("discrete")) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "variability",
					modelicaDiscreteKind);
		} else if (variability.contains("param")) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "variability",
					modelicaParameterKind);
		} else if (variability.contains("var")) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "variability",
					modelicaContinuousKind);
		}
	}

	private static void importModifications(TypedElement property,
			Classifier classifier) {
		String propertyName = property.getName();
		String componentModificationsName = omc.getComponentModifierNames(
				classifier.getQualifiedName().replaceAll("::", "."),
				propertyName);
		if (componentModificationsName.contains("{")) {
			componentModificationsName = componentModificationsName.replace(
					"{", "");
			componentModificationsName = componentModificationsName.replace(
					"}", "");
			componentModificationsName = componentModificationsName.replace(
					"\n", "");
			componentModificationsName = componentModificationsName.replaceAll(
					" ", "");
			String[] componentModificationsArray = componentModificationsName
					.split(",");

			if (!componentModificationsArray[0].isEmpty()) {
				for (String modificationName : componentModificationsArray) {
					String modificationValue = omc
							.getComponentModifierValue(classifier
									.getQualifiedName().replaceAll("::", "."),
									propertyName + "." + modificationName);
					modificationValue = modificationValue.replace("\\n", "");
					StereotypesHelper.setStereotypePropertyValue(property,
							(Stereotype) property
									.getAppliedStereotypeInstance()
									.getClassifier().get(0), "modification",
							modificationName + modificationValue, true);
				}
			}
		}
	}

	private static Property getProperty(Classifier class_, String propertyName) {
		Collection<Property> propertyList = new ArrayList<Property>();
		// propertyList = addInheritedPropertiesProperty(class_, propertyList);
		for (NamedElement inheritedMember : class_.getInheritedMember()) {
			if (inheritedMember instanceof Property) {
				propertyList.add((Property) inheritedMember);
			}
		}
		propertyList.addAll(class_.getAttribute());
		for (Property property : propertyList) {
			if (property.getName().equals(propertyName)) {
				return property;
			}
		}

		return null;
	}

	static String getClassPath() {
		return prop.getProperty("java.class.path", null);
	}

	public static void printBufferToFile(StringBuffer buffer, String logFileName) {
		try {
			FileWriter fileWriter = new FileWriter(logFileName);
			fileWriter.append(buffer);

			fileWriter.close();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	private static void importCausality(String causality, TypedElement property) {
		causality = causality.replaceAll("\"", "");
		if (causality.equals("input")) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "causality",
					modelicaInputKind);
		} else if (causality.equals("output")) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "causality",
					modelicaOutputKind);
		}
	}

	private static void importReplaceablePrefix(boolean isreplaceable,
			TypedElement property) {
		if (isreplaceable) {
			StereotypesHelper.setStereotypePropertyValue(property,
					(Stereotype) property.getAppliedStereotypeInstance()
							.getClassifier().get(0), "isReplaceable", true);
		}
	}

	private static void importClassComponentAttributes(
			ModelicaComponentData modelicaComponentData, TypedElement property,
			Classifier classifier) {
		String propertyName = property.getName();

		// get component index
		int componentIndex = -1;
		String classQualifiedName2 = classifier.getQualifiedName().replaceAll(
				"::", ".");
		ArrayList<ModelicaComponentData> componentDataList = omc
				.getComponentData(classQualifiedName2);
		int i = 1;
		for (ModelicaComponentData modelicaComponentData2 : componentDataList) {
			if (modelicaComponentData2.getName().equals(propertyName)) {
				componentIndex = i;
				break;
			}
			i++;
		}

		// visibility
		importVisibility(modelicaComponentData.getVisibility(), property);

		// causality
		importCausality(modelicaComponentData.getCausality(), property);

		// variability
		importVariability(modelicaComponentData.getVariability(), property);

		// flowFlag
		importFlow(modelicaComponentData, property);

		// scope
		importScope(modelicaComponentData.getInnerouter(), property);

		// conditionalExpression
		importConditionalExpression(
				classifier.getQualifiedName().replaceAll("::", "."),
				componentIndex, property);

		// isFinal
		importFinalPrefix(modelicaComponentData.isFinal(), property);

		// modification
		importModifications(property, classifier);

		// isReplaceable
		importReplaceablePrefix(modelicaComponentData.isReplaceable(), property);

		// declarationEquation
		importDeclarationEquation(property, classifier);

		// arraySize
		importArraySize(modelicaComponentData.getArraySize(), property);
	}

}
