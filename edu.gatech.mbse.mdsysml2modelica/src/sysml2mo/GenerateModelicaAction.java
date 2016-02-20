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

package sysml2mo;

import java.awt.event.ActionEvent;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.filechooser.FileFilter;
import javax.swing.filechooser.FileNameExtensionFilter;

//import b.a.b;

import com.nomagic.magicdraw.core.Application;
import com.nomagic.magicdraw.core.Project;
import com.nomagic.magicdraw.properties.BooleanProperty;
import com.nomagic.magicdraw.properties.PropertyID;
import com.nomagic.magicdraw.properties.PropertyManager;
import com.nomagic.magicdraw.properties.ValueSpecificationProperty;
import com.nomagic.magicdraw.ui.browser.Node;
import com.nomagic.magicdraw.ui.browser.Tree;
import com.nomagic.magicdraw.ui.browser.actions.DefaultBrowserAction;
import com.nomagic.magicdraw.ui.dialogs.MDDialogParentProvider;

import com.nomagic.task.ProgressStatus;
import com.nomagic.uml2.ext.jmi.helpers.StereotypesHelper;
import com.nomagic.uml2.ext.magicdraw.auxiliaryconstructs.mdmodels.Model;
import com.nomagic.uml2.ext.magicdraw.classes.mddependencies.Dependency;
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
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Namespace;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Package;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Parameter;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Property;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.ValueSpecification;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.Behavior;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.FunctionBehavior;
import com.nomagic.uml2.ext.magicdraw.commonbehaviors.mdbasicbehaviors.OpaqueBehavior;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdinternalstructures.Connector;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdinternalstructures.ConnectorEnd;
import com.nomagic.uml2.ext.magicdraw.compositestructures.mdports.Port;
import com.nomagic.uml2.ext.magicdraw.mdprofiles.Profile;
import com.nomagic.uml2.ext.magicdraw.mdprofiles.Stereotype;

/**
 * GenerateModelicaAction is responsible for transforming a SysML element (model, package, etc...)
 * into a Modelica model. The user selects in the MagicDraw project tree structure view
 * the SysML model element to transform to Modelica.
 * 
 * @author Axel Reichwein
 */
public class GenerateModelicaAction extends
		DefaultBrowserAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4501968202702572083L;
	/**
	 * 
	 */

	private PropertyManager properties = null;


	public GenerateModelicaAction() {
		super("", "Generate Modelica", null, null);
		properties = new PropertyManager();
		properties.addProperty(new BooleanProperty(
				PropertyID.SHOW_DIAGRAM_INFO, true));

	}

	private void displayWarning(String text) {
		JOptionPane.showMessageDialog(MDDialogParentProvider.getProvider()
				.getDialogParent(), text);

	}

	public void actionPerformed(ActionEvent e) {
		// load the SysML4Modleica Stereotypes		
		Project project = Application.getInstance().getProject();
		SysML2Modelica.loadModelicaStereotypes(project);
		
		// no MagicDraw graphical layout in generated Modelica code
		SysML2Modelica.isWithMagicDrawLayout = false;
		
		SysML2Modelica.tabs = new String();
		
		// transform SysML into a StringBuffer containing Modelica code
		Object userObject = getTree().getSelectedNode().getUserObject();
		StringBuffer buffer = new StringBuffer();
		if (userObject instanceof Element
				&& StereotypesHelper.hasStereotype(((Element) userObject),
						"ModelicaBlock")) {
			Class class_ = (Class) userObject;
			SysML2Modelica.printModelicaBlock(class_, buffer);
		} else if (userObject instanceof Element
				&& StereotypesHelper.hasStereotype(((Element) userObject),
						"ModelicaPackage")) {
			Class class_ = (Class) userObject;
			SysML2Modelica.printModelicaPackage(class_, buffer);
		} else if (userObject instanceof Element
				&& StereotypesHelper.hasStereotype(((Element) userObject),
						"ModelicaModel")) {
			Class class_ = (Class) userObject;
			SysML2Modelica.printModelicaModel(class_, buffer);
		}  else if (userObject instanceof Element
				&& StereotypesHelper.hasStereotype(((Element) userObject),
						"ModelicaConnector")) {
			Class class_ = (Class) userObject;
			SysML2Modelica.printModelicaConnector(class_, buffer);
		} else if (userObject instanceof Model) {
			buffer = SysML2Modelica.printMagicDrawModel();
		}

		// print buffer with Modelica code to a file
		SysML2Modelica.printBufferToFile(buffer);		
	}

	
}
