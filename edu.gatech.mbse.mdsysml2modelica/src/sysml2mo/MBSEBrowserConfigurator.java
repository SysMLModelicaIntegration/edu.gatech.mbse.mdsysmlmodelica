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

import com.nomagic.actions.AMConfigurator;

import com.nomagic.actions.*;
import javax.swing.JOptionPane;
import java.awt.event.ActionEvent;

//import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Element;
import com.nomagic.uml2.ext.jmi.helpers.StereotypesHelper;
import com.nomagic.uml2.ext.magicdraw.auxiliaryconstructs.mdmodels.Model;
import com.nomagic.uml2.ext.magicdraw.classes.mdkernel.Element;
import com.nomagic.magicdraw.actions.BrowserContextAMConfigurator;
import com.nomagic.magicdraw.actions.MDActionsCategory;
import com.nomagic.magicdraw.core.Application;
import com.nomagic.magicdraw.ui.browser.Tree;
import com.nomagic.magicdraw.ui.browser.actions.DefaultBrowserAction;


public class MBSEBrowserConfigurator implements BrowserContextAMConfigurator, AMConfigurator
{

	/**
	 * Action which should be added to the tree.
	 */
	private MDActionsCategory cat = null;
	
  
    private DefaultBrowserAction generateModelicaFromMagicDrawModelAction     = new GenerateModelicaAction();
    private DefaultBrowserAction generateModelicaWithGraphicalLayoutFromMagicDrawModelAction     = new GenerateModelicaWithGraphicalLayoutAction();
    
   
	
	/**
	 * Creates configurator for adding given action.
	 * @param action action to be added to manager.
	 */
	public MBSEBrowserConfigurator()	{
		//this.ac = ac;
	       
        // ADDING ACTION TO CONTAINMENT BROWSER
		
 
	}

	/**
	 * @see com.nomagic.magicdraw.actions.BrowserContextAMConfigurator#configure(com.nomagic.actions.ActionsManager, com.nomagic.magicdraw.ui.browser.Tree)
	 */
	public void configure(ActionsManager mngr, Tree tree) 	{
		if(tree.getSelectedNode() == null) { 
			return;
		}
		ActionsCategory  cat = new ActionsCategory(null,null);

		if(Application.getInstance().getProject() == null) { 
			return;
		}
		
     
        cat = new MDActionsCategory("SysML to Modelica","SysML to Modelica");
		cat.setNested(true);

		Object userObject = tree.getSelectedNode().getUserObject();		
		
		// for a Package we add the action to create a book
		// plus the getTemplate facility.
		//

		

		
		// for a Block we do the things which we can do with a Block !
		if ((userObject instanceof Element && StereotypesHelper.hasStereotype(((Element) userObject), "ModelicaBlock")) 
				|(userObject instanceof Element && StereotypesHelper.hasStereotype(((Element) userObject), "ModelicaPackage"))
				|(userObject instanceof Element && StereotypesHelper.hasStereotype(((Element) userObject), "ModelicaModel"))
				|(userObject instanceof Element && StereotypesHelper.hasStereotype(((Element) userObject), "ModelicaConnector"))) {      
			cat.addAction(generateModelicaFromMagicDrawModelAction);
			cat.addAction(generateModelicaWithGraphicalLayoutFromMagicDrawModelAction);
			mngr.addCategory(cat);
		} 
		
		if (userObject instanceof Model) {      
			cat.addAction(generateModelicaFromMagicDrawModelAction);
			cat.addAction(generateModelicaWithGraphicalLayoutFromMagicDrawModelAction);
			mngr.addCategory(cat);
		} 
		

	}

	/**
	 * @see com.nomagic.actions.AMConfigurator#configure(com.nomagic.actions.ActionsManager)
	 */
	public void configure(ActionsManager mngr)	{
		// adding action separator
		mngr.addCategory(cat);
	}

	public int getPriority()
	{
		return AMConfigurator.MEDIUM_PRIORITY;
	}
}
