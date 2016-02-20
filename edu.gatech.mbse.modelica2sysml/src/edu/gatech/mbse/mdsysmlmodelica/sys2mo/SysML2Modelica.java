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

package edu.gatech.mbse.mdsysmlmodelica.sys2mo;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.swing.JFileChooser;
import javax.swing.JOptionPane;

import org.omg.mof.model.VisibilityKind;

import com.nomagic.magicdraw.core.Application;
import com.nomagic.magicdraw.core.Project;
import com.nomagic.magicdraw.properties.BooleanProperty;
import com.nomagic.magicdraw.properties.PropertyID;
import com.nomagic.magicdraw.properties.PropertyManager;
import com.nomagic.magicdraw.ui.dialogs.MDDialogParentProvider;
import com.nomagic.magicdraw.uml.DiagramTypeConstants;
import com.nomagic.magicdraw.uml.symbols.DiagramPresentationElement;
import com.nomagic.magicdraw.uml.symbols.PresentationElement;
import com.nomagic.magicdraw.uml.symbols.paths.PathElement;
import com.nomagic.uml2.ext.jmi.helpers.StereotypesHelper;
import com.nomagic.uml2.ext.magicdraw.auxiliaryconstructs.mdmodels.Model;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Classifier;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Comment;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.DataType;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Diagram;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Element;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Enumeration;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.EnumerationLiteral;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Generalization;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.NamedElement;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Namespace;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Parameter;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Property;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Type;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.TypedElement;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.ValueSpecification;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.VisibilityKindEnum;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.Behavior;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.OpaqueBehavior;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdinternalstructures.Connector;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdinternalstructures.ConnectorEnd;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdports.Port;
import com.nomagic.uml2.ext.magicdraw.mdprofiles.Profile;
import com.nomagic.uml2.ext.magicdraw.mdprofiles.Stereotype;

/**
 * SysML2Modelica is responsible for transforming a SysML model into a
 * Modelica model, in other words pretty-printing the SysML model in a .mo text file. 
 * 
 * @author Axel Reichwein
 */
public class SysML2Modelica {

	private static Stereotype modelicaAnnotationST;
	private static Stereotype modelicaExtendsST;
	private static Stereotype modelicaShortExtendsST;
	private static Stereotype modelicaPackageST;
	private static Stereotype modelicaConnectorST;
	private static Stereotype modelicaClassST;
	private static Stereotype modelicaValuePropertyST;
	private static Stereotype modelicaPortST;
	private static Stereotype modelicaBlockST;
	private static Stereotype modelicaModelST;
	private static Stereotype modelicaEquationST;
	private static Stereotype modelicaFunctionST;
	private static Stereotype modelicaFunctionParameterST;
	private static Stereotype modelicaTypeST;
	private static Stereotype modelicaPartST;
	private static Stereotype modelicaConnectionST;
	private static Stereotype modelicaConstrainedByST;
	private static Stereotype modelicaAlgorithmST;
	private static Stereotype modelicaClassDefinitionST;
	private static Stereotype modelicaRecordST;
	public static String tabs = new String();

	public static boolean isWithMagicDrawLayout = false;
	public static ArrayList<Property> partsInIBDs = new ArrayList<Property>();
	public static ArrayList<ConnectorEnd> connectorEndsInIBDs = new ArrayList<ConnectorEnd>();

	public static StringBuffer printMagicDrawModel() {		
		Model rootModel = Application.getInstance().getProject().getModel();
		Collection<com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Package> ownedPackages = rootModel
				.getNestedPackage();

		StringBuffer mainBuffer = new StringBuffer();
		for (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Package package_ : ownedPackages) {
			if (package_ instanceof Profile
					| package_.getName().equals("UML Standard Profile")) {
				continue;
			}	
			for (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Type type : package_
					.getOwnedType()) {
				StringBuffer nestedBuffer = new StringBuffer();
				nestedBuffer = printType(type);
				if (nestedBuffer != null) {
					mainBuffer.append(nestedBuffer);
				}
			}
		}
		
		Collection<com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Type> ownedTypes = rootModel
				.getOwnedType();

		for (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Type type : ownedTypes) {
			StringBuffer nestedBuffer = new StringBuffer();
			nestedBuffer = printType(type);
			if (nestedBuffer != null) {
				mainBuffer.append(nestedBuffer);
			}
		}
		return mainBuffer;
	}

	public static void loadModelicaStereotypes(Project project) {
		modelicaExtendsST = StereotypesHelper.getStereotype(project,
				"ModelicaExtends");
		modelicaShortExtendsST = StereotypesHelper.getStereotype(project,
				"ModelicaShortExtends");
		modelicaPackageST = StereotypesHelper.getStereotype(project,
				"ModelicaPackage");
		modelicaClassST = StereotypesHelper.getStereotype(project,
				"ModelicaClass");
		modelicaAnnotationST = StereotypesHelper.getStereotype(project,
				"ModelicaAnnotation");
		modelicaConnectorST = StereotypesHelper.getStereotype(project,
				"ModelicaConnector");
		modelicaValuePropertyST = StereotypesHelper.getStereotype(project,
				"ModelicaValueProperty");
		modelicaPortST = StereotypesHelper.getStereotype(project,
				"ModelicaPort");
		modelicaBlockST = StereotypesHelper.getStereotype(project,
				"ModelicaBlock");
		modelicaModelST = StereotypesHelper.getStereotype(project,
				"ModelicaModel");
		modelicaEquationST = StereotypesHelper.getStereotype(project,
				"ModelicaEquation");
		modelicaFunctionST = StereotypesHelper.getStereotype(project,
				"ModelicaFunction");
		modelicaFunctionParameterST = StereotypesHelper.getStereotype(project,
				"ModelicaFunctionParameter");
		modelicaTypeST = StereotypesHelper.getStereotype(project,
				"ModelicaType");
		modelicaPartST = StereotypesHelper.getStereotype(project,
				"ModelicaPart");
		modelicaConnectionST = StereotypesHelper.getStereotype(project,
				"ModelicaConnection");
		modelicaConstrainedByST = StereotypesHelper.getStereotype(project,
				"ModelicaConstrainedBy");
		modelicaAlgorithmST = StereotypesHelper.getStereotype(project,
				"ModelicaAlgorithm");
		modelicaClassDefinitionST = StereotypesHelper.getStereotype(project,
				"ModelicaClassDefinition");
		modelicaRecordST = StereotypesHelper.getStereotype(project,
				"ModelicaRecord");
	}

	public static StringBuffer printAnnotation(
			Collection<Comment> nestedComments, StringBuffer buffer) {

		boolean first = true;
		for (Iterator<Comment> iterator = nestedComments.iterator(); iterator
				.hasNext();) {
			Comment comment = (Comment) iterator.next();

			if (StereotypesHelper.hasStereotype(comment, modelicaAnnotationST)) {
				if (first) {
					buffer.append(tabs + "annotation (" + comment.getBody());
					first = false;
				} else {
					buffer.append(", " + comment.getBody());
				}
				buffer.append(")");
			}			
			first = false;
		}
		return buffer;
	}

	public static StringBuffer printType(
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Type type) {
		StringBuffer buffer = new StringBuffer();

		if (type instanceof com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class) {
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class class_ = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class) type;

			// print Packages
			if (StereotypesHelper.hasStereotype(class_, modelicaPackageST)) {
				printModelicaPackage(class_, buffer);
			}

			// print Blocks
			if (StereotypesHelper.hasStereotype(class_, modelicaBlockST)) {
				printModelicaBlock(class_, buffer);
			}

			// print connectors
			if (StereotypesHelper.hasStereotype(class_, modelicaConnectorST)) {
				printModelicaConnector(class_, buffer);

			}
			// print Models
			if (StereotypesHelper.hasStereotype(class_, modelicaModelST)) {
				printModelicaModel(class_, buffer);
			}
			// print Classes
			if (StereotypesHelper.hasStereotype(class_, modelicaClassST)) {
				printModelicaClass(class_, buffer);
			}
			// print Types
			if (StereotypesHelper.hasStereotype(class_, modelicaTypeST)) {
				printModelicaType(class_, buffer);
			}
			// print Records
			if (StereotypesHelper.hasStereotype(class_, modelicaRecordST)) {
				printModelicaRecord(class_, buffer);
			}			
			
			return buffer.append(tabs + "  \r\n");
		}

		// print Modelica Type
		if (type instanceof DataType) {
//		if (type instanceof Enumeration) {
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.DataType dataType_ = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.DataType) type;
//			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Enumeration dataType_ = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Enumeration) type;
			if (StereotypesHelper.getFirstVisibleStereotype(dataType_) == modelicaTypeST) {
				printModelicaType(buffer, dataType_);
			}
			return buffer.append(tabs + "  \r\n");
		}
		return null;
	}

	private static void printModelicaRecord(Class class_, StringBuffer buffer) {
		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print block name
		printName(class_, buffer, hasLineStartingTabs, "record");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print initial equations
		printModelicaInitialEquation(class_, buffer, true);

		// print Equations
		boolean isFirstEquation = printModelicaEquation(class_, buffer, true);

		// print connections (connect equations)
		printModelicaConnection(class_, buffer, isFirstEquation);

		// print initial modelica algorithms
		printModelicaInitialAlgorithm(class_, buffer);

		// print modelica algorithms
		printModelicaAlgorithm(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print annotations
		buffer = printAnnotation(class_.getOwnedComment(), buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static void printModelicaType(Class class_, StringBuffer buffer) {
		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print model and name
		printName(class_, buffer, hasLineStartingTabs, "type");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print parts
		printModelicaPartPublic(class_, buffer);

		// print ports
		printModelicaPort(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print parts
			printModelicaPartProtected(class_, buffer);
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print initial equations
		printModelicaInitialEquation(class_, buffer, true);

		// print Equations
		boolean isFirstEquation = printModelicaEquation(class_, buffer, true);

		// print connections (connect equations)
		printModelicaConnection(class_, buffer, isFirstEquation);

		// print initial modelica algorithms
		printModelicaInitialAlgorithm(class_, buffer);

		// print modelica algorithms
		printModelicaAlgorithm(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print annotations
		buffer = printAnnotation(class_.getOwnedComment(), buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static void printModelicaClass(Class class_, StringBuffer buffer) {

		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print model and name
		printName(class_, buffer, hasLineStartingTabs, "class");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print parts
		printModelicaPartPublic(class_, buffer);

		// print ports
		printModelicaPort(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print parts
			printModelicaPartProtected(class_, buffer);
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print initial equations
		printModelicaInitialEquation(class_, buffer, true);

		// print Equations
		boolean isFirstEquation = printModelicaEquation(class_, buffer, true);

		// print connections (connect equations)
		printModelicaConnection(class_, buffer, isFirstEquation);

		// print initial modelica algorithms
		printModelicaInitialAlgorithm(class_, buffer);

		// print modelica algorithms
		printModelicaAlgorithm(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print annotations
		buffer = printAnnotation(class_.getOwnedComment(), buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static void printModelicaAlgorithm(Class class_, StringBuffer buffer) {
		boolean first = true;
		Collection<Behavior> opaqueBehaviors = class_.getOwnedBehavior();
		for (Behavior opaqueBehavior : opaqueBehaviors) {

			if (opaqueBehavior instanceof OpaqueBehavior) {
				OpaqueBehavior opqBehav = (OpaqueBehavior) opaqueBehavior;

				if (StereotypesHelper.hasStereotype(opqBehav,
						modelicaAlgorithmST)) {

					Object isInitialObject = StereotypesHelper
							.getStereotypePropertyFirst(
									opqBehav,
									StereotypesHelper
											.getFirstVisibleStereotype(opqBehav),
									"isInitial");
					if (isInitialObject != null) {
						if (isInitialObject instanceof Boolean) {
							boolean isInitial = (Boolean) isInitialObject;
							if (isInitial) {
								continue;
							}
						}
					}

					if (first == true) {
						buffer.append(tabs + "algorithm \r\n");
						first = false;
					}
					if (!opqBehav.getBody().isEmpty()) {
						String opaqueBody = opqBehav.getBody().iterator()
								.next();
						opaqueBody = opaqueBody.replaceAll("\n", "\n" + tabs);
						buffer.append(tabs + opaqueBody + "\r\n");
					}
				}
			}
		}
	}

	private static void printModelicaInitialAlgorithm(Class class_,
			StringBuffer buffer) {
		boolean first = true;
		Collection<Behavior> opaqueBehaviors = class_.getOwnedBehavior();
		for (Behavior opaqueBehavior : opaqueBehaviors) {

			if (opaqueBehavior instanceof OpaqueBehavior) {
				OpaqueBehavior opqBehav = (OpaqueBehavior) opaqueBehavior;

				if (StereotypesHelper.hasStereotype(opqBehav,
						modelicaAlgorithmST)) {
					Object isInitialObject = StereotypesHelper
							.getStereotypePropertyFirst(
									opqBehav,
									StereotypesHelper
											.getFirstVisibleStereotype(opqBehav),
									"isInitial");
					if (isInitialObject != null) {
						if (isInitialObject instanceof Boolean) {
							boolean isInitial = (Boolean) isInitialObject;
							if (!isInitial) {
								continue;
							}
						}
					} else {
						continue;
					}

					if (first == true) {
						buffer.append(tabs + "initial algorithm \r\n");
						first = false;
					}
					if (!opqBehav.getBody().isEmpty()) {
						String opaqueBody = opqBehav.getBody().iterator()
								.next();
						opaqueBody = opaqueBody.replaceAll("\n", "\n" + tabs);
						buffer.append(tabs + opaqueBody + ";\r\n");
					}
				}
			}
		}

	}

	private static void printModelicaType(StringBuffer buffer,
			DataType dataType_) {
//		Class dataType_) {

		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(dataType_,
				buffer);
		if (dataType_ instanceof Enumeration) {
			
			// print name
			buffer.append(tabs + "type " + dataType_.getName());
			tabs = tabs + "\t";			
			buffer.append(" = enumeration(\r\n");
			
			// print enumeration literals
			Enumeration enumeration = (Enumeration) dataType_;			
			List<EnumerationLiteral> enumerationLiterals = enumeration
					.getOwnedLiteral();
			for (Iterator enumerationLiteralsIT = enumerationLiterals
					.iterator(); enumerationLiteralsIT.hasNext();) {
				EnumerationLiteral enumerationLiteral = (EnumerationLiteral) enumerationLiteralsIT
						.next();
				String enumerationLiteralName = enumerationLiteral.getName();
				enumerationLiteralName = enumerationLiteralName.replace("\n",
						"");
				buffer.append(tabs + enumerationLiteralName);
				if (enumerationLiteralsIT.hasNext()) {
					buffer.append(",\r\n");
				} else {

					buffer.append("\r\n");
				}
			}

			// print end statement
			tabs = tabs.replaceFirst("\t", "");			
			buffer.append(tabs + ")" + ";\r\n");

//		} else if (dataType_ instanceof DataType) {
		} else if (dataType_ instanceof Class) {
			printName(dataType_, buffer, hasLineStartingTabs, "type ");

			// print generalizations
			boolean isShortClassDefinition = printModelicaExtends(dataType_,
					buffer);

			// print end statement
			tabs = tabs.replaceFirst("\t", "");
			if (isShortClassDefinition) {
				// TODO? buffer.append(";\r\n");
			} else {
				buffer.append(tabs + "end " + dataType_.getName() + ";\r\n");
			}
		}
	}

	private static void printModelicaFunction(StringBuffer buffer, Class class_) {

		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print function and name
		printName(class_, buffer, hasLineStartingTabs, "function");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// owned Parameters
		printModelicaFunctionParameter(class_, buffer);

		// print external fucntion
		printModelicaExternalFunction(class_, buffer);

		// print initial modelica algorithms
		printModelicaInitialAlgorithm(class_, buffer);

		// print modelica algorithms
		printModelicaAlgorithm(class_, buffer);

		// print annotations
		buffer = printAnnotation(class_.getOwnedComment(), buffer);
		
		// print end statements and tabs
		for (Classifier classifier : class_.getNestedClassifier()) {
			StringBuffer nestedContentBuffer = printType(classifier);
			if (nestedContentBuffer != null) {
				buffer.append(tabs + nestedContentBuffer);
			}
		}

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static void printModelicaExternalFunction(Class class_,
			StringBuffer buffer) {
		if (class_ instanceof com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior) {
			com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior functBehavior = (com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior) class_;

			if (functBehavior.getLanguage().size() > 0) {
				Iterator languagesIT = functBehavior.getLanguage().iterator();
				String language = (String) languagesIT.next();

				if (functBehavior.getBody().size() > 0) {
					Iterator bodiesIT = functBehavior.getBody().iterator();
					String externalFunctionName = (String) bodiesIT.next();

					ArrayList<String> inputVariableNames = new ArrayList<String>();
					String outputVariableName = null;
					Collection<Parameter> ownedParameters = functBehavior
							.getOwnedParameter();
					for (Parameter ownParam : ownedParameters) {
						if (StereotypesHelper
								.getFirstVisibleStereotype(ownParam) == modelicaFunctionParameterST) {
							
							// check if a function parameter has causality 
							// and print causality
							Object causalityObject = StereotypesHelper
									.getStereotypePropertyFirst(ownParam,
											modelicaFunctionParameterST,
											"causality");
							if (causalityObject instanceof EnumerationLiteral) {
								EnumerationLiteral causalityLit = (EnumerationLiteral) causalityObject;
								String enumeration = causalityLit.getName();
								if (!enumeration.equals("none")) {
									if (enumeration.equals("input")) {
										inputVariableNames.add(ownParam
												.getName());
									} else if (enumeration.equals("output")) {
										outputVariableName = ownParam.getName();
									}

								}
							}
						}
					}
					
					buffer.append(tabs + "external " + "\"" + language + "\" ");

					if (outputVariableName != null) {
						buffer.append(outputVariableName + " = ");
					}
					buffer.append(externalFunctionName + "(");

					for (Iterator inputsIT = inputVariableNames.iterator(); inputsIT
							.hasNext();) {
						String inputVariable = (String) inputsIT.next();
						buffer.append(inputVariable);
						if (inputsIT.hasNext()) {
							buffer.append(",");
						}
					}
					
					buffer.append(");\n");

					List externalLibraryObjects = StereotypesHelper
							.getStereotypePropertyValue(functBehavior,
									modelicaFunctionST, "externalLibrary");
					if (externalLibraryObjects != null) {
						if (externalLibraryObjects.size() > 0) {
							if (!externalLibraryObjects.get(0).equals("")) {
								buffer.append(tabs + "annotation(Library=\"");
								for (Iterator externalLibrariesIT = externalLibraryObjects
										.iterator(); externalLibrariesIT
										.hasNext();) {
									String externalLibrary = (String) externalLibrariesIT
											.next();
									buffer.append(externalLibrary);
									if (externalLibrariesIT.hasNext()) {
										buffer.append(",");
									}

								}
								buffer.append("\"");
								buffer.append(");\n");
							}
						}
					}					
				}
			}
		}
	}

	private static void printModelicaFunctionParameter(Class class_,
			StringBuffer buffer) {
		
		if (class_ instanceof com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior) {
			com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior functBehav = (com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior) class_;
			Collection<Parameter> ownedParameters = functBehav
					.getOwnedParameter();
			for (Parameter ownParam : ownedParameters) {
				if (!ownParam.getVisibility().equals(VisibilityKindEnum.PUBLIC)) {
					continue;
				}
				if (StereotypesHelper.getFirstVisibleStereotype(ownParam) == modelicaFunctionParameterST) {
					
					// check if a function parameter has causality and print					
					boolean isTabsPrinted = false;					
					printModelicaFunctionParameterX(ownParam, buffer, isTabsPrinted);					
				}
			}

			boolean hasProtectedSection = false;
			for (Parameter property : ownedParameters) {
				if (property.getVisibility().equals(
						VisibilityKindEnum.PROTECTED)) {
					if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaFunctionParameterST) {
						hasProtectedSection = true;
						buffer.append(tabs + "protected\n");
						break;
					}
				}
			}

			if (hasProtectedSection) {
				for (Parameter property : ownedParameters) {
					if (!property.getVisibility().equals(
							VisibilityKindEnum.PROTECTED)) {
						continue;
					}
					if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaFunctionParameterST) {
						boolean isTabsPrinted = false;
						printModelicaFunctionParameterX(property, buffer, isTabsPrinted);
					}
				}
			}
		}		
	}

	private static void printModelicaFunctionParameterX(TypedElement ownParam,
			StringBuffer buffer, boolean isTabsPrinted) {
		// print isReplaceable
		isTabsPrinted = printModelicaIsReplaceable(ownParam, buffer,
				isTabsPrinted);

		// causality
		isTabsPrinted = printModelicaCausality(buffer,
				ownParam, isTabsPrinted);
		
		// print part type and part name
		if (!isTabsPrinted) {
			buffer.append(tabs);
		}
		String propertyName = ownParam.getName();
		String propertyTypeQualified = ownParam.getType()
				.getQualifiedName().replaceAll("::", ".");

		if (propertyTypeQualified.contains("ModelicaReal")) {
			propertyTypeQualified = "Real";
		} else if (propertyTypeQualified
				.contains("ModelicaBoolean")) {
			propertyTypeQualified = "Boolean";
		} else if (propertyTypeQualified
				.contains("ModelicaInteger")) {
			propertyTypeQualified = "Integer";
		} else if (propertyTypeQualified
				.contains("ModelicaString")) {
			propertyTypeQualified = "String";
		}

		buffer.append(propertyTypeQualified + " "
				+ propertyName);

		// print arraySize
		printArraySize(ownParam, buffer);
		
		// print modifications
		printModelicaModifications(ownParam, buffer);

		// print declaration equation
		printModelicaDeclarationEquation(ownParam, buffer);

		// print Modelica graphical layout
		if (isWithMagicDrawLayout) {
			printModelicaAnnotationForGUIRectangle(ownParam,
					buffer);
		} else {
			// get annotations of part
			buffer = printAnnotation(
					ownParam.getOwnedComment(), buffer);
		}
		
		buffer.append("; \r\n");
		
	}

	private static void printArraySize(TypedElement ownParam,
			StringBuffer buffer) {
		List<String> arraySizeList = StereotypesHelper
				.getStereotypePropertyValueAsString(ownParam,
						StereotypesHelper.getFirstVisibleStereotype(ownParam),
						"arraySize");
		if (!arraySizeList.isEmpty()) {
			buffer.append("[");

			for (Iterator<String> iterator = arraySizeList.iterator(); iterator
					.hasNext();) {
				String modString = (String) iterator.next();

				if (modString instanceof String) {
					if (!modString.equals(" ")) {
						modString = modString.replaceAll("\n", "");
						buffer.append(modString);
					}
					if (iterator.hasNext()) {
						buffer.append(",");
					}
				}
			}
			buffer.append("]");
		}
	}

	private static boolean printModelicaCausality(StringBuffer buffer,
			Parameter ownParam) {
		Object causalityObject = StereotypesHelper.getStereotypePropertyFirst(
				ownParam, modelicaFunctionParameterST, "causality");
		if (causalityObject instanceof EnumerationLiteral) {
			EnumerationLiteral causalityLit = (EnumerationLiteral) causalityObject;
			String enumeration = causalityLit.getName();
			if (!enumeration.equals("none")) {
				buffer.append(tabs + enumeration + " ");
				return true;
			}
		}
		return false;
	}

	private static boolean printModelicaCausality(StringBuffer buffer,
			TypedElement property, boolean isTabsPrinted) {
		Object causalityObject = StereotypesHelper.getStereotypePropertyFirst(
				property,
				StereotypesHelper.getFirstVisibleStereotype(property),
				"causality");
		if (causalityObject instanceof EnumerationLiteral) {
			EnumerationLiteral causalityLit = (EnumerationLiteral) causalityObject;
			String enumeration = causalityLit.getName();

			if (!enumeration.equals("none")) {
				// buffer.append(tabs + enumeration + " ");
				if (isTabsPrinted) {
					buffer.append(enumeration + " ");
				} else {
					buffer.append(tabs + enumeration + " ");
					return true;
				}
			}		
		}
		return isTabsPrinted;
	}

	private static boolean printModelicaEquation(
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class class_,
			StringBuffer buffer, boolean isFirstEquation) {
		Collection<Constraint> equations_ = class_.getOwnedRule();
		for (Constraint constraint : equations_) {
			if (constraint instanceof com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint) {
				com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint equation_ = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint) constraint;
				if (StereotypesHelper.getFirstVisibleStereotype(equation_) == modelicaEquationST) {
					Object isInitialObject = StereotypesHelper
							.getStereotypePropertyFirst(
									equation_,
									StereotypesHelper
											.getFirstVisibleStereotype(equation_),
									"isInitial");
					if (isInitialObject != null) {
						if (isInitialObject instanceof Boolean) {
							boolean isInitial = (Boolean) isInitialObject;
							if (isInitial) {
								continue;
							}
						}
					}

					if (isFirstEquation) {					
						buffer.append(tabs + "equation " + " \r\n");
					}
					ValueSpecification equationSpecification = equation_
							.getSpecification();
					if (equationSpecification instanceof com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression) {
						com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression opaqueExp = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression) equationSpecification;
						if (!opaqueExp.getBody().isEmpty()) {
							String equationBody = opaqueExp.getBody()
									.iterator().next();
							if(equationBody.contains("\\\\")){
								equationBody = equationBody.replace("\\\\", "\\");
							}
							equationBody = equationBody.replaceAll("\n", "\n"
									+ tabs);
							buffer.append(tabs + equationBody + "\r\n");							
						}
					}
					isFirstEquation = false;
				}
			}
		}
		return isFirstEquation;
	}

	private static boolean printModelicaInitialEquation(
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class class_,
			StringBuffer buffer, boolean isFirstEquation) {
		Collection<Constraint> equations_ = class_.getOwnedRule();
		for (Constraint constraint : equations_) {
			if (constraint instanceof com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint) {
				com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint equation_ = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Constraint) constraint;
				if (StereotypesHelper.getFirstVisibleStereotype(equation_) == modelicaEquationST) {
					Object isInitialObject = StereotypesHelper
							.getStereotypePropertyFirst(
									equation_,
									StereotypesHelper
											.getFirstVisibleStereotype(equation_),
									"isInitial");
					if (isInitialObject != null) {
						if (isInitialObject instanceof Boolean) {
							boolean isInitial = (Boolean) isInitialObject;
							if (!isInitial) {
								continue;
							}
						}
					} else {
						continue;
					}

					if (isFirstEquation) {					
						buffer.append(tabs + "initial equation " + " \r\n");
					}
					ValueSpecification equationSpecification = equation_
							.getSpecification();
					if (equationSpecification instanceof com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression) {
						com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression opaqueExp = (com.nomagic.uml2.ext.magicdraw.classes.mdkernel.OpaqueExpression) equationSpecification;
						if (!opaqueExp.getBody().isEmpty()) {
							String equationBody = opaqueExp.getBody()
									.iterator().next();
							equationBody = equationBody.replaceAll("\n", "\n"
									+ tabs);
							if(equationBody.contains("\\\\")){
								equationBody = equationBody.replace("\\\\", "\\");
							}							
							if (equationBody.contains("end if;")
									| equationBody.contains("end for;")) {
								buffer.append(tabs + equationBody + "\r\n");
							} 
							else if (equationBody.endsWith(";")) {
								buffer.append(tabs + equationBody + "\r\n");
							} 							
							else {
								buffer.append(tabs + equationBody + "; \r\n");
							}
						}
					}
					isFirstEquation = false;
				}
			}
		}
		return isFirstEquation;
	}

	private static boolean printModelicaConnection(Class class_,
			StringBuffer buffer, boolean isFirstConnection) {
		Collection<Connector> connectors_ = class_.getOwnedConnector();
		int dynamicConnectionsCounter = 1;
		for (Connector connector : connectors_) {
			if (StereotypesHelper
					.hasStereotype(connector, modelicaConnectionST)) {
				
				// if first equation, append the word "equation"
				if (isFirstConnection) {
					buffer.append(tabs + "equation " + " \r\n");
				}
				String[] connectorEndNames = new String[2];
				String[] connectorEndTypes = new String[2];
				
				// for the connector ends, get the names and the part with the
				// port and append
				for (int i = 0; i < connector.getEnd().size(); i++) {
					if (connector.getEnd().get(i).getRole() != null) {
						connectorEndNames[i] = connector.getEnd().get(i)
								.getRole().getName();
					}
					if (connector.getEnd().get(i).getPartWithPort() != null) {
						connectorEndTypes[i] = connector.getEnd().get(i)
								.getPartWithPort().getName();
					}
				}
				buffer.append(tabs + "connect (");
				if (connectorEndTypes[0] != null) {
					buffer.append(connectorEndTypes[0] + ".");
				}
				if(connectorEndNames[0] == null){
					connectorEndNames[0] = connectorEndNames[1] + dynamicConnectionsCounter;
					dynamicConnectionsCounter++;
				}
				buffer.append(connectorEndNames[0] + ", ");
				if (connectorEndTypes[1] != null) {
					buffer.append(connectorEndTypes[1] + ".");
				}
				if(connectorEndNames[1] == null){
					connectorEndNames[1] = connectorEndNames[0] + dynamicConnectionsCounter;
					dynamicConnectionsCounter++;
				}
				buffer.append(connectorEndNames[1] + ")");

				// print Modelica graphical layout
				if (isWithMagicDrawLayout) {
					printModelicaAnnotationForGUILine(connector, buffer);
				} else {
					// get annotations of port
					buffer = printAnnotation(connector.getOwnedComment(),
							buffer);
				}

				buffer.append(";\r\n");
				isFirstConnection = false;
			}
		}
		return isFirstConnection;
	}

	private static void printModelicaPartPublic(Class class_,
			StringBuffer buffer) {
		Collection<Property> partProperties = class_.getOwnedAttribute();
		for (Property property : partProperties) {
			if (!property.getVisibility().equals(VisibilityKindEnum.PUBLIC)) {
				continue;
			}
			if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
				boolean isTabsPrinted = false;
				printModelicaValuePartX(property, buffer, isTabsPrinted);
			}
		}
	}

	private static void printModelicaPartProtected(Class class_,
			StringBuffer buffer) {
		Collection<Property> partProperties = class_.getOwnedAttribute();
		for (Property property : partProperties) {
			if (!property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				continue;
			}
			if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
				boolean isTabsPrinted = false;
				printModelicaValuePartX(property, buffer, isTabsPrinted);
			}
		}
	}

	private static void printModelicaValuePartX(Property property,
			StringBuffer buffer, boolean isTabsPrinted) {
		
		// print isReplaceable
		isTabsPrinted = printModelicaIsReplaceable(property, buffer,
				isTabsPrinted);

		// print scope
		isTabsPrinted = printModelicaScope(buffer, property, isTabsPrinted);

		// print part type and part name
		if (!isTabsPrinted) {
			buffer.append(tabs);
		}
		String propertyName = property.getName();
		String propertyTypeQualified = property.getType().getQualifiedName()
				.replaceAll("::", ".");
		buffer.append(propertyTypeQualified + " " + propertyName);

		// print arraySize
		printArraySize(property, buffer);

		// print modifications
		printModelicaModifications(property, buffer);

		// print constrained by
		printModelicaConstrainedBy(property, buffer);

		// print conditional expression
		printModelicaConditionalExpression(buffer, property);

		// print Modelica graphical layout
		if (isWithMagicDrawLayout) {
			printModelicaAnnotationForGUIRectangle(property, buffer);
		} else {
			// get annotations of part
			buffer = printAnnotation(property.getOwnedComment(), buffer);
		}

		buffer.append(";\r\n");

	}

	private static void printModelicaConstrainedBy(TypedElement property,
			StringBuffer buffer) {
		if (!property.getClientDependency().isEmpty()) {
			if (StereotypesHelper.hasStereotype(property.getClientDependency()
					.iterator().next(), modelicaConstrainedByST)) {
				NamedElement namedElement = (NamedElement) property
						.getClientDependency().iterator().next().getTarget()
						.iterator().next();
				String elementName = namedElement.getName();
				String elementType = namedElement.getNamespace().getName();
				buffer.append("\r\n" + tabs + "constrainedby " + elementType
						+ "." + elementName + " ");
			}
		}
	}

	private static boolean printModelicaIsReplaceable(TypedElement property,
			StringBuffer buffer, boolean isTabsPrinted) {

		Object replaceableObject = StereotypesHelper
				.getStereotypePropertyFirst(property,
						StereotypesHelper.getFirstVisibleStereotype(property),
						"isReplaceable");
		if (replaceableObject instanceof Boolean) {
			Boolean replaceObj = (Boolean) replaceableObject;

			if (replaceObj.booleanValue()) {
				if (isTabsPrinted) {
					buffer.append("replaceable ");
				} else {
					buffer.append(tabs + "replaceable ");
					return true;
				}
			}
		}
		return isTabsPrinted;
	}

	private static void printModelicaPort(Class class_, StringBuffer buffer) {
		Collection<Port> nestedPortProperties = class_.getOwnedPort();
		for (Port port : nestedPortProperties) {
			if (StereotypesHelper.getFirstVisibleStereotype(port) == modelicaPortST) {
				boolean isTabsPrinted = false;
				
				// print isReplaceable
				isTabsPrinted = printModelicaIsReplaceable(port, buffer,
						isTabsPrinted);

				// print causality
				isTabsPrinted = printModelicaCausality(buffer, port,
						isTabsPrinted);

				// print port type and name
				if (!isTabsPrinted) {
					buffer.append(tabs);
				}
				String portName = port.getName();
				String portTypeQualified = port.getType().getQualifiedName()
						.replaceAll("::", ".");
				buffer.append(portTypeQualified + " " + portName);

				// print arraySize
				printArraySize(port, buffer);

				// print modifications
				printModelicaModifications(port, buffer);

				// print declaration equation
				printModelicaDeclarationEquation(port, buffer);
				
				// print conditional expression
				printModelicaConditionalExpression(buffer, port);

				// print Modelica graphical layout
				if (isWithMagicDrawLayout) {
					printModelicaAnnotationForGUIPortRectangle(class_, port,
							buffer);

				} else {
					// get annotations of port
					buffer = printAnnotation(port.getOwnedComment(), buffer);
				}
				buffer.append(";\r\n");

			}

		}
	}

	private static void printModelicaAnnotationForGUIPortRectangle(
			Class class_, Port port, StringBuffer buffer) {

		Property partWithPort = null;
		Property portOnPart = null;

		for (ConnectorEnd connectorEnd : connectorEndsInIBDs) {
			Property connectorEndPart = connectorEnd.getPartWithPort();
			Port connectorEndPort = (Port) connectorEnd.getRole();
			
			// check property type
			Type partType = connectorEndPart.getType();
			if (partType == class_) {
				if (connectorEndPort == port) {
					if (isPortOnPart(connectorEndPart, connectorEndPort)) {
						partWithPort = connectorEndPart;
						portOnPart = connectorEndPort;
						break;
					}					
				}
			}

			// part property may be inherited from another class
			if (partType instanceof Class) {
				Class propertyClass = (Class) partType;
				if (propertyClass.getGeneral().contains(class_)) {
					if (connectorEndPort == port) {
						if (isPortOnPart(connectorEndPart, connectorEndPort)) {
							partWithPort = connectorEndPart;
							portOnPart = connectorEndPort;
							break;
						}
					}
				}
			}			
		}

		if (partWithPort != null & (portOnPart != null)) {
			RectangleEdge rectangleEdge = getRectangleEdgeOfPort(partWithPort,
					portOnPart);
			if (rectangleEdge != null) {
				switch (rectangleEdge) {
				case TOP:
					buffer.append("\r\n"
							+ tabs
							+ "annotation (Placement(transformation(extent={{-10,80},{10,100}}))");
					System.out.println();
					break;
				case BOTTOM:
					buffer.append("\r\n"
							+ tabs
							+ "annotation (Placement(transformation(extent={{-10,-100},{10,-80}}))");
					break;
				case LEFT:
					buffer.append("\r\n"
							+ tabs
							+ "annotation (Placement(transformation(extent={{-100,-10},{-80,10}}))");
					break;
				case RIGHT:
					buffer.append("\r\n"
							+ tabs
							+ "annotation (Placement(transformation(extent={{80,-10},{100,10}}))");
					break;
				}
			}
		}		
	}

	private static boolean printModelicaExtends(Classifier class_,
			StringBuffer buffer) {
		Collection<Generalization> generalizations = class_.getGeneralization();
		boolean isShortClassDefinition = false;
		for (Generalization generalization : generalizations) {
			if (StereotypesHelper.getFirstVisibleStereotype(generalization) == modelicaExtendsST
					| StereotypesHelper
							.getFirstVisibleStereotype(generalization) == modelicaShortExtendsST) {
				String qualifiedName = generalization.getGeneral()
						.getQualifiedName().replaceAll("::", ".");
				if (qualifiedName.contains("ModelicaReal")) {
					qualifiedName = "Real";
				} else if (qualifiedName.contains("ModelicaBoolean")) {
					qualifiedName = "Boolean";
				} else if (qualifiedName.contains("ModelicaInteger")) {
					qualifiedName = "Integer";
				} else if (qualifiedName.contains("ModelicaString")) {
					qualifiedName = "String";
				}

				// .replaceFirst(package_.getName() + ".", "");
				if (StereotypesHelper.getFirstVisibleStereotype(generalization) == modelicaExtendsST) {
					buffer.append(tabs + "extends ");
				} else if (StereotypesHelper
						.getFirstVisibleStereotype(generalization) == modelicaShortExtendsST) {
					buffer.append(tabs + "= ");
					isShortClassDefinition = true;
				}

				// print causality
				if (StereotypesHelper.getFirstVisibleStereotype(generalization) == modelicaShortExtendsST) {
					Object causalityObject = StereotypesHelper
							.getStereotypePropertyFirst(generalization,
									modelicaShortExtendsST, "causality");
					if (causalityObject instanceof EnumerationLiteral) {
						EnumerationLiteral enumLit = (EnumerationLiteral) causalityObject;
						String enumLitName = enumLit.getName();
						if (enumLitName.equals("input")
								| enumLitName.equals("output")) {
							buffer.append(enumLitName + " ");
						}
					}
				}

				// print name
				buffer.append(qualifiedName);

				// print arraySize
				List<String> arraySizeList = StereotypesHelper
						.getStereotypePropertyValueAsString(
								generalization,
								StereotypesHelper
										.getFirstVisibleStereotype(generalization),
								"arraySize");
				if (!arraySizeList.isEmpty()) {
					buffer.append("[");

					for (Iterator<String> iterator = arraySizeList.iterator(); iterator
							.hasNext();) {
						String modString = (String) iterator.next();

						if (modString instanceof String) {
							if (!modString.equals(" ")) {
								modString = modString.replaceAll("\n", "");
								modString = modString.replaceAll("\"", "");
								buffer.append(modString);
							}
							if (iterator.hasNext()) {
								buffer.append(",");
							}
						}
					}
					buffer.append("]");
				}

				// print modification
				List<String> modificationObject = StereotypesHelper
						.getStereotypePropertyValueAsString(
								generalization,
								StereotypesHelper
										.getFirstVisibleStereotype(generalization),
								"modification");
				if (!modificationObject.isEmpty()) {
					buffer.append(" (");

					for (Iterator<String> iterator = modificationObject
							.iterator(); iterator.hasNext();) {
						String modString = (String) iterator.next();

						if (modString instanceof String) {
							if (!modString.equals(" ")) {
								modString = modString.replaceAll("\n", "");
								buffer.append(modString);
							}
							if (iterator.hasNext()) {
								buffer.append(", ");
							}
						}
					}
					buffer.append(")");
				}
				buffer.append(";  \r\n");
			}
		}
		return isShortClassDefinition;
	}

	public static void printModelicaModel(Class class_, StringBuffer buffer) {

		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print model and name
		printName(class_, buffer, hasLineStartingTabs, "model");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print parts
		printModelicaPartPublic(class_, buffer);

		// print ports
		printModelicaPort(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print parts
			printModelicaPartProtected(class_, buffer);
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print initial equations
		printModelicaInitialEquation(class_, buffer, true);

		// print initial modelica algorithms
		printModelicaInitialAlgorithm(class_, buffer);

		// print Equations
		boolean isFirstEquation = printModelicaEquation(class_, buffer, true);

		// print connections (connect equations)
		printModelicaConnection(class_, buffer, isFirstEquation);

		// print modelica algorithms
		printModelicaAlgorithm(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print annotations
		buffer = printAnnotation(class_.getOwnedComment(), buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static boolean printModelicaClassDefinition(Classifier class_,
			StringBuffer buffer) {

		boolean hasLineStartingTabs = false;

		// print final ?
		Object finalObject = StereotypesHelper.getStereotypePropertyFirst(
				class_, modelicaClassDefinitionST, "isFinal");
		if (finalObject instanceof Boolean) {
			Boolean isFinal = (Boolean) finalObject;
			if (isFinal.booleanValue()) {
				if (hasLineStartingTabs) {
					buffer.append("final ");
				} else {
					buffer.append(tabs + "final ");
					hasLineStartingTabs = true;
				}
			}			
		}

		// print encapsulated ?
		Object encapsulatedObject = StereotypesHelper
				.getStereotypePropertyFirst(class_, modelicaClassDefinitionST,
						"isModelicaEncapsulated");
		if (encapsulatedObject instanceof Boolean) {
			Boolean isEncapsulated = (Boolean) encapsulatedObject;
			if (isEncapsulated) {
				if (hasLineStartingTabs) {
					buffer.append("encapsulated ");
				} else {
					buffer.append(tabs + "encapsulated ");
					hasLineStartingTabs = true;
				}
			}
		}

		// print partial ?
		Object partialObject = StereotypesHelper.getStereotypePropertyFirst(
				class_, modelicaClassDefinitionST, "isPartial");
		if (partialObject instanceof Boolean) {
			Boolean partialObj = (Boolean) partialObject;
			if (partialObj.booleanValue()) {
				if (hasLineStartingTabs) {
					buffer.append("partial ");
				} else {
					buffer.append(tabs + "partial ");
					hasLineStartingTabs = true;
				}
			}
		}

		// print replaceable ?
		Object replaceableObject = StereotypesHelper
				.getStereotypePropertyFirst(class_, modelicaClassDefinitionST,
						"isReplaceable");
		if (replaceableObject instanceof Boolean) {
			Boolean replaceableObj = (Boolean) replaceableObject;
			if (replaceableObj.booleanValue()) {
				if (hasLineStartingTabs) {
					buffer.append("replaceable ");
				} else {
					buffer.append(tabs + "replaceable ");
					hasLineStartingTabs = true;
				}
			}
		}
		return hasLineStartingTabs;
	}

	private static void printModelicaValuePropertyX(Property property,
			StringBuffer buffer, boolean isTabsPrinted) {
		String propertyName = property.getName();
		String propertyTypeName = property.getType().getName();

		// print isReplaceable
		isTabsPrinted = printModelicaIsReplaceable(property, buffer,
				isTabsPrinted);

		// print causality
		isTabsPrinted = printModelicaCausality(buffer, property, isTabsPrinted);

		// print variability
		isTabsPrinted = printModelicaVariability(buffer, property,
				isTabsPrinted);

		// print flow
		isTabsPrinted = printModelicaFlow(buffer, property, isTabsPrinted);

		// print scope
		isTabsPrinted = printModelicaScope(buffer, property, isTabsPrinted);

		// print tabs if necessary
		if (!isTabsPrinted) {
			buffer.append(tabs);
		}

		// print predefined type names if necessary
		if (propertyTypeName.contains("ModelicaBoolean")) {
			buffer.append("Boolean" + " " + propertyName);
		}
		// print modelica integer type
		else if (propertyTypeName.contains("ModelicaInteger")) {
			buffer.append("Integer" + " " + propertyName);
		}
		// print modelica real type
		else if (propertyTypeName.contains("ModelicaReal")) {
			buffer.append("Real" + " " + propertyName);
		}
		// print modelica String type
		else if (propertyTypeName.contains("ModelicaString")) {
			buffer.append("String" + " " + propertyName);
		}
		// print modelica StateSelect
		else if (propertyTypeName.contains("StateSelect")) {
			buffer.append("StateSelect" + " " + propertyName);
		}
		// print modelica other type
		else {
			String valTypeQualified = property.getType().getQualifiedName()
					.replaceAll("::", ".");
			buffer.append(valTypeQualified + " " + propertyName);
		}

		// print arraySize
		printArraySize(property, buffer);

		// print modifications
		printModelicaModifications(property, buffer);

		// print declaration equation
		printModelicaDeclarationEquation(property, buffer);

		// print conditional expression
		printModelicaConditionalExpression(buffer, property);

		// print Modelica graphical layout
		if (isWithMagicDrawLayout) {
			printModelicaAnnotationForGUIRectangle(property, buffer);
		} else {
			// get annotations of part
			buffer = printAnnotation(property.getOwnedComment(), buffer);
		}

		// end of component
		buffer.append(";");
		buffer.append("\n");
	}

	private static void printModelicaValuePropertyPublic(Class class_,
			StringBuffer buffer) {
		for (Property property : class_.getOwnedAttribute()) {
			if (!property.getVisibility().equals(VisibilityKindEnum.PUBLIC)) {
				continue;
			}
			if (StereotypesHelper.hasStereotype(property,
					modelicaValuePropertyST)) {
				boolean isTabsPrinted = false;
				printModelicaValuePropertyX(property, buffer, isTabsPrinted);
			}
		}
	}

	private static void printModelicaValuePropertyProtected(Class class_,
			StringBuffer buffer) {
		Collection<Property> valueProperties = class_.getOwnedAttribute();
		for (Property property : valueProperties) {
			if (!property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				continue;
			}
			if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST) {
				boolean isTabsPrinted = false;
				printModelicaValuePropertyX(property, buffer, isTabsPrinted);
			}
		}

	}

	private static void printModelicaConditionalExpression(StringBuffer buffer,
			TypedElement property) {
		Object decEqnObject = StereotypesHelper.getStereotypePropertyFirst(
				property,
				StereotypesHelper.getFirstVisibleStereotype(property),
				"conditionalExpression");
		if (decEqnObject instanceof String) {
			String decEqnString = (String) decEqnObject;
			
			if (!decEqnString.equals(" ") & !decEqnString.equals("")) {
				decEqnString = decEqnString.replaceAll("\n", "");
				buffer.append(" " + decEqnString);
			}
		}

	}

	private static boolean printModelicaScope(StringBuffer buffer,
			TypedElement property, boolean isTabsPrinted) {
		Object scopeObject = StereotypesHelper.getStereotypePropertyFirst(
				property,
				StereotypesHelper.getFirstVisibleStereotype(property), "scope");
		if (scopeObject instanceof EnumerationLiteral) {
			EnumerationLiteral scopeLit = (EnumerationLiteral) scopeObject;
			String enumeration = scopeLit.getName();
			if (isTabsPrinted) {
				buffer.append(enumeration + " ");
			} else {
				buffer.append(tabs + enumeration + " ");
				return true;
			}			
		}
		return isTabsPrinted;
	}

	private static void printModelicaDeclarationEquation(TypedElement property,
			StringBuffer buffer) {
		Object decEqnObject = StereotypesHelper.getStereotypePropertyFirst(
				property,
				StereotypesHelper.getFirstVisibleStereotype(property),
				"declarationEquation");
		if (decEqnObject instanceof String) {
			String decEqnString = (String) decEqnObject;

			if (!decEqnString.equals(" ") & !decEqnString.equals("")) {
				if(decEqnString.startsWith("\"")){
					decEqnString = decEqnString.substring(1, decEqnString.length());
				}
				if(decEqnString.startsWith("\\")){
					decEqnString = decEqnString.substring(1, decEqnString.length());
				}
				if(decEqnString.endsWith("\"")){
					decEqnString = decEqnString.substring(0, decEqnString.length() - 1);
				}
				if(decEqnString.endsWith("\\\"")){ 
					int lastIndex = decEqnString.lastIndexOf("\\\"");
					decEqnString = decEqnString.substring(0, lastIndex) + "\"";
				}
				buffer.append(" = " + decEqnString);
			}
		}
	}

	private static void printModelicaModifications(TypedElement property,
			StringBuffer buffer) {
		List<String> modificationObject = StereotypesHelper
				.getStereotypePropertyValueAsString(property,
						StereotypesHelper.getFirstVisibleStereotype(property),
						"modification");
		if (!modificationObject.isEmpty()) {
			buffer.append(" (");
			boolean hasNestedModification = false;
			String modifiedVariable = null;
			ArrayList<String> modifications = new ArrayList<String>();
			for (Iterator<String> iterator = modificationObject.iterator(); iterator
					.hasNext();) {
				String modString = (String) iterator.next();
				if (modString instanceof String) {
					if (!modString.equals(" ")) {
						modString = modString.replaceAll("\n", "");						
						if(!hasNestedModification){
							modifications.add(modString);
							if(modString.contains("(")){
								hasNestedModification = true;								
								modifiedVariable = modString.substring(0, modString.indexOf("("));
							}
						}
						// considering modifications one level down																		
						else{
							if(modString.startsWith(modifiedVariable + ".")){
								// do not print nested modification
							}
							else{
								modifications.add(modString);
							}
						}
					}
					
				}
			}
			
			for (Iterator<String> iterator = modifications.iterator(); iterator
					.hasNext();) {
				String modString = (String) iterator.next();
				if (modString instanceof String) {
					if (!modString.equals(" ")) {
						modString = modString.replaceAll("\n", "");
						buffer.append(modString);																	
					}
					if (iterator.hasNext()) {
						buffer.append(", ");
					}
				}
			}
						
			buffer.append(")");
		}

	}

	private static boolean printModelicaFlow(StringBuffer buffer,
			Property property, boolean isTabsPrinted) {
		Object flowObject = StereotypesHelper.getStereotypePropertyFirst(
				property,
				StereotypesHelper.getFirstVisibleStereotype(property),
				"flowFlag");
		if (flowObject instanceof EnumerationLiteral) {
			EnumerationLiteral flowLit = (EnumerationLiteral) flowObject;
			String flowName = flowLit.getName();
			if (!flowName.equals("none")) {
				if (isTabsPrinted) {
					buffer.append(flowName + " ");
				} else {
					buffer.append(tabs + flowName + " ");
					return true;
				}

			}
		}
		return isTabsPrinted;
	}

	private static boolean printModelicaVariability(StringBuffer buffer,
			Property property, boolean isTabsPrinted) {
		String valProp = property.getName();

		// print variability
		Object variabilityObject = StereotypesHelper
				.getStereotypePropertyFirst(property,
						StereotypesHelper.getFirstVisibleStereotype(property),
						"variability");
		if (variabilityObject instanceof EnumerationLiteral) {
			EnumerationLiteral variabilityLit = (EnumerationLiteral) variabilityObject;
			String enumeration = variabilityLit.getName();
			if (!enumeration.equals("none") & !enumeration.equals("continuous")) {
				if (!valProp.equals(("myRealSignal"))) {
					if (!valProp.equals("myBooleanSignal")
							& !valProp.equals("booleanSignal")
							& !valProp.equals("integerSignal")) {
						if (isTabsPrinted) {
							buffer.append(enumeration + " ");
						} else {
							buffer.append(tabs + enumeration + " ");
							return true;
						}

					}
				}
			}
		}
		return isTabsPrinted;
	}

	public static void printModelicaPackage(Class class_, StringBuffer buffer) {

		// do not print the tool-specific ModelicaServices package
		if(class_.getName().equals("ModelicaServices")){
			return;
		}
		
		
		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print block and name
		printName(class_, buffer, hasLineStartingTabs, "package");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static void printNestedTypes(Class class_, StringBuffer buffer) {
		for (Element element : class_.getOwnedElement()) {
			if (element instanceof Classifier) {
				Boolean isModelicaEncapsulatedBoolean = false;
				Classifier classifier = (Classifier) element;
				Object isModelicaEncapsulated = StereotypesHelper
						.getStereotypePropertyFirst(classifier,
								StereotypesHelper
										.getFirstVisibleStereotype(classifier),
								"isModelicaEncapsulated");
				if (isModelicaEncapsulated instanceof Boolean) {
					isModelicaEncapsulatedBoolean = (Boolean) isModelicaEncapsulated;
				}
				if (!isModelicaEncapsulatedBoolean) {

					StringBuffer nestedContentBuffer = printType(classifier);
					if (nestedContentBuffer != null) {
						buffer.append(nestedContentBuffer);
					}
				}
			}			
		}
	}

	private static void printNestedFunctionsAndEncapsulatedClasses(
			Class class_, StringBuffer buffer) {
		for (Element element : class_.getOwnedElement()) {

			// print encapsulated Modelica classes
			if (element instanceof Classifier) {
				Boolean isModelicaEncapsulatedBoolean = false;
				Classifier classifier = (Classifier) element;
				Object isModelicaEncapsulated = StereotypesHelper
						.getStereotypePropertyFirst(classifier,
								StereotypesHelper
										.getFirstVisibleStereotype(classifier),
								"isModelicaEncapsulated");
				if (isModelicaEncapsulated instanceof Boolean) {
					isModelicaEncapsulatedBoolean = (Boolean) isModelicaEncapsulated;
				}
				if (isModelicaEncapsulatedBoolean) {
					StringBuffer nestedContentBuffer = printType(classifier);
					if (nestedContentBuffer != null) {
						buffer.append(nestedContentBuffer);
					}
				}
			}

			// print Modelica Functions
			if (element instanceof FunctionBehavior) {
				FunctionBehavior functionBehavior = (FunctionBehavior) element;
				if (StereotypesHelper.hasStereotype(functionBehavior,
						modelicaFunctionST)) {
					printModelicaFunction(buffer, functionBehavior);
				}
			}
		}
	}

	public static void printModelicaConnector(
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class class_,
			StringBuffer buffer) {

		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// is connector expandable?
		hasLineStartingTabs = printModelicaIsExpandable(class_, buffer,
				hasLineStartingTabs);

		// print name
		printName(class_, buffer, hasLineStartingTabs, "connector");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print annotation
		printAnnotation(class_.getOwnedComment(), buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}
	}

	private static void printName(Classifier class_, StringBuffer buffer,
			boolean hasLineStartingTabs, String modelicaTypeName) {

		// print tabs if not previously printed
		if (!hasLineStartingTabs) {
			buffer.append(tabs);
		}

		// printName
		buffer.append(modelicaTypeName + " " + class_.getName() + "\r\n");
		tabs = tabs + "\t";

	}

	private static boolean printModelicaIsExpandable(Class class_,
			StringBuffer buffer, boolean hasLineStartingTabs) {
		Object expandableConneector = StereotypesHelper
				.getStereotypePropertyFirst(class_, modelicaConnectorST,
						"isExpandable");
		if (expandableConneector instanceof Boolean) {
			Boolean expandCon = (Boolean) expandableConneector;
			if (expandCon.booleanValue()) {
				if (!hasLineStartingTabs) {
					buffer.append(tabs);
				}
				buffer.append("expandable ");
				hasLineStartingTabs = true;
			}
		}
		return hasLineStartingTabs;
	}

	public static void printModelicaBlock(
			com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Class class_,
			StringBuffer buffer) {

		// print class definition attributes
		boolean hasLineStartingTabs = printModelicaClassDefinition(class_,
				buffer);

		// print block name
		printName(class_, buffer, hasLineStartingTabs, "block");

		// print import statements
		printModelicaImports(class_, buffer);

		// print generalizations/extends
		boolean isShortClassDefinition = printModelicaExtends(class_, buffer);

		// print parts
		printModelicaPartPublic(class_, buffer);

		// print ports
		printModelicaPort(class_, buffer);

		// print value properties public
		printModelicaValuePropertyPublic(class_, buffer);

		// print protected properties
		boolean hasProtectedSection = false;
		for (Property property : class_.getOwnedAttribute()) {
			if (property.getVisibility().equals(VisibilityKindEnum.PROTECTED)) {
				if (StereotypesHelper.getFirstVisibleStereotype(property) == modelicaValuePropertyST
						| StereotypesHelper.getFirstVisibleStereotype(property) == modelicaPartST) {
					hasProtectedSection = true;
					buffer.append(tabs + "protected\n");
					break;
				}
			}
		}

		if (hasProtectedSection) {
			// print parts
			printModelicaPartProtected(class_, buffer);
			// print value properties protected
			printModelicaValuePropertyProtected(class_, buffer);
		}

		// print nested functions
		printNestedFunctionsAndEncapsulatedClasses(class_, buffer);

		// print initial equations
		printModelicaInitialEquation(class_, buffer, true);

		// print Equations
		boolean isFirstEquation = printModelicaEquation(class_, buffer, true);

		// print connections (connect equations)
		printModelicaConnection(class_, buffer, isFirstEquation);

		// print initial modelica algorithms
		printModelicaInitialAlgorithm(class_, buffer);

		// print modelica algorithms
		printModelicaAlgorithm(class_, buffer);

		// print nested types
		printNestedTypes(class_, buffer);

		// print annotations
		buffer = printAnnotation(class_.getOwnedComment(), buffer);

		// print end statement
		tabs = tabs.replaceFirst("\t", "");
		if (!isShortClassDefinition) {
			buffer.append(tabs + "end " + class_.getName() + ";\r\n");
		}

	}

	private static void printModelicaImports(Classifier class_,
			StringBuffer buffer) {
		for (Comment comment : class_.getOwnedComment()) {
			String importStatement = comment.getBody();
			if (importStatement.startsWith("import")) {
				buffer.append(tabs + importStatement + ";\n");
			}

		}

	}

	private static void printModelicaAnnotationForGUIRectangle(
			TypedElement property, StringBuffer buffer) {
		Project project = Application.getInstance().getProject();
		PresentationElement presentationElement = project.getSymbolElementMap()
				.getPresentationElement(property);
		if (presentationElement != null) {
			Rectangle rectangle = presentationElement.getBounds();
			int height = rectangle.height;
			int width = rectangle.width;
			int x = presentationElement.getMiddlePointX();
			int y = presentationElement.getMiddlePointY();
			
			int diagramHeight = presentationElement.getDiagramSurface()
					.getVisibleRect().height;
			int diagramWidth = presentationElement.getDiagramSurface()
					.getVisibleRect().width;

			int bottomLeftX = (x - diagramWidth / 2 - width / 2) / 6;
			int topRightX = (x - diagramWidth / 2 + width / 2) / 6;
			int bottomLeftY = (diagramHeight - y - height / 2) / 6;
			int topRightY = (diagramHeight - y + height / 2) / 6;

			if (property instanceof Port) {

				// check on which edge of the part the port is!
				buffer.append("\r\n"
						+ tabs
						+ "annotation (Placement(transformation(extent={{-100,-10},{-80,10}}))");
			} else {
				buffer.append("\r\n" + tabs
						+ "annotation (Placement(transformation(extent={{"
						+ bottomLeftX + "," + bottomLeftY + "},{" + topRightX
						+ "," + topRightY + "}}))");
			}			
		}
	}

	private static void printModelicaAnnotationForGUILine(Connector connector,
			StringBuffer buffer) {
		Project project = Application.getInstance().getProject();
		PresentationElement presentationElement = project.getSymbolElementMap()
				.getPresentationElement(connector);

		if (presentationElement != null) {
			if (presentationElement instanceof PathElement) {
				PathElement pathElement = (PathElement) presentationElement;
				List<Point> points = pathElement.getAllBreakPoints();

				// check if points are in correct order
				// points have to go from minimum x coordinate to maximum x
				// coordinate otherwise the line will be flipped horizontally in
				// Dymola
				if (points.size() > 1) {
					Point point0 = points.get(0);
					int x0 = point0.x;
					for (int i = 1; i < points.size(); i++) {
						Point nextPoint = points.get(i);
						int xN = nextPoint.x;
						if (xN != x0) {
							if (xN < x0) {
								Collections.reverse(points);
							}
							break;
						}
					}
				}

				// check if first point belongs to source part, if yes, no
				// problem, if not, reverse order of points!
				// if (!isFirstPointBelongingToFirstConnectorEnd(connector,
				// points)) {
				// Collections.reverse(points);
				// }

				if (!points.isEmpty()) {
					StringBuffer lineBuffer = new StringBuffer("\r\n" + tabs
							+ "annotation (Line(points={");
					Iterator pointsIT = points.iterator();
					for (Point point : points) {
						int x = point.x;
						int y = point.y;

						int diagramHeight = presentationElement
								.getDiagramSurface().getVisibleRect().height;
						int diagramWidth = presentationElement
								.getDiagramSurface().getVisibleRect().width;
						int modelicaX = (x - diagramWidth / 2) / 6;
						int modelicaY = (diagramHeight - y) / 6;

						lineBuffer.append("{" + modelicaX + "," + modelicaY
								+ "}");
						pointsIT.next();
						if (pointsIT.hasNext()) {
							lineBuffer.append(",");
						}
					}
					lineBuffer
							.append("}, color={0,0,255}, smooth=Smooth.None)");
					buffer.append(lineBuffer);
				}
			}
		}
	}

	public static RectangleEdge getRectangleEdgeOfPort(Property partWithPort,
			Property port) {

		// coordinates of part with port
		Project project = Application.getInstance().getProject();
		PresentationElement partWithPortPresentationElement = project
				.getSymbolElementMap().getPresentationElement(partWithPort);
		if (partWithPortPresentationElement != null) {
			Rectangle partRectangle = partWithPortPresentationElement
					.getBounds();

			double partMaxY = partRectangle.getMaxY();
			double partMinY = partRectangle.getMinY();
			double partMaxX = partRectangle.getMaxX();
			double partMinX = partRectangle.getMinX();

			// coordinates of port
			PresentationElement portPresentationElement = project
					.getSymbolElementMap().getPresentationElement(port);
			if (portPresentationElement != null) {
				Rectangle portRectangle = portPresentationElement.getBounds();

				if (partRectangle.intersects(portRectangle)) {
					if (portRectangle.intersectsLine(partMinX,
					// partMaxY, partMaxX, partMaxY)){
							partMinY, partMaxX, partMinY)) {
						return RectangleEdge.TOP;
					} else if (portRectangle.intersectsLine(partMinX,
					// partMinY, partMaxX, partMinY)){
							partMaxY, partMaxX, partMaxY)) {
						return RectangleEdge.BOTTOM;
					} else if (portRectangle.intersectsLine(partMinX, partMinY,
							partMinX, partMaxY)) {
						return RectangleEdge.LEFT;
					} else if (portRectangle.intersectsLine(partMaxX, partMinY,
							partMaxX, partMaxY)) {
						return RectangleEdge.RIGHT;
					}
				}			
			}
		}
		return null;
	};

	public static boolean isPortOnPart(Property partWithPort, Property port) {

		// coordinates of part with port
		Project project = Application.getInstance().getProject();
		PresentationElement partWithPortPresentationElement = project
				.getSymbolElementMap().getPresentationElement(partWithPort);
		if (partWithPortPresentationElement != null) {
			Rectangle partRectangle = partWithPortPresentationElement
					.getBounds();

			double partMaxY = partRectangle.getMaxY();
			double partMinY = partRectangle.getMinY();
			double partMaxX = partRectangle.getMaxX();
			double partMinX = partRectangle.getMinX();

			// coordinates of port
			PresentationElement portPresentationElement = project
					.getSymbolElementMap().getPresentationElement(port);
			if (portPresentationElement != null) {
				Rectangle portRectangle = portPresentationElement.getBounds();				

				if (partRectangle.intersects(portRectangle)) {
					if (portRectangle.intersectsLine(partMinX, partMaxY,
							partMaxX, partMaxY)) {
						return true;
					} else if (portRectangle.intersectsLine(partMinX, partMinY,
							partMaxX, partMinY)) {
						return true;
					} else if (portRectangle.intersectsLine(partMinX, partMinY,
							partMinX, partMaxY)) {
						return true;
					} else if (portRectangle.intersectsLine(partMaxX, partMinY,
							partMaxX, partMaxY)) {
						return true;
					}
				}
			}
		}
		return false;
	};

	public static void printBufferToFile(StringBuffer buffer) {
		try {
			FileWriter fileWriter = new FileWriter("generated_Modelica.mo");
			fileWriter.append(buffer);

			fileWriter.close();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	public static void preProcessingDiagrams() {
		Project project = Application.getInstance().getProject();
		for (DiagramPresentationElement diagramPresentationElement : project
				.getDiagrams()) {
			if (diagramPresentationElement
					.getDiagramType()
					.getType()
					.equals(DiagramTypeConstants.UML_COMPOSITE_STRUCTURE_DIAGRAM)
					| diagramPresentationElement.getDiagramType().getType()
							.equals("SysML Internal Block Diagram")) {
				
				// the diagram is an ibd
				for (Element element : diagramPresentationElement
						.getUsedModelElements(true)) {
					if (element instanceof Property) {
						if (!(element instanceof Port)) {
							// add to list of parts
							Property part = (Property) element;
							partsInIBDs.add(part);
						}
					}
					if (element instanceof ConnectorEnd) {
						if (!(element instanceof Port)) {
							// add to list of parts
							ConnectorEnd connectorEnd = (ConnectorEnd) element;
							connectorEndsInIBDs.add(connectorEnd);
						}
					}
				}

			}
		}
	}
	
}
