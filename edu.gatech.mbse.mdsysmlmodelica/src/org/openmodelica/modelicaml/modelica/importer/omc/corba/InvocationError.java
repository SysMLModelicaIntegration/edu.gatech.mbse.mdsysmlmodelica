/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR 
 * THIS OSMC PUBLIC LICENSE (OSMC-PL). 
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S ACCEPTANCE
 * OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3, ACCORDING TO RECIPIENTS CHOICE. 
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or  
 * http://www.openmodelica.org, and in the OpenModelica distribution. 
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 * Main author: Wladimir Schamai, EADS Innovation Works / Linköping University, 2009-now
 *
 * Contributors: 
 *   Uwe Pohlmann, University of Paderborn 2009-2010, contribution to the Modelica code generation for state machine behavior, contribution to Papyrus GUI adoptations
 *   Parham Vasaiely, EADS Innovation Works / Hamburg University of Applied Sciences 2009-2011, implementation of simulation plugins
 */

package org.openmodelica.modelicaml.modelica.importer.omc.corba;

// TODO: Auto-generated Javadoc
/**
 * Thrown when compiler reports an unexpected error while invoking
 * some command via the 'interactive api' interface. That is when
 * compiler replys 'error' instead of returning the results in a situation
 * where no error are expected.
 * 
 * @author Elmir Jagudin
 */
public class InvocationError extends CompilerException
{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1437868457853593664L;
	
	/** The action. */
	private String action;
	
	/** The expression. */
	private String expression;
	
	/**
	 * Instantiates a new invocation error.
	 *
	 * @param action human readable decscription of what action failed
	 * @param expression the expression what was send to OMC that failed
	 * @see InvocationError#getAction()
	 * @see InvocationError#getExpression()
	 */
	public InvocationError(String action, String expression)
	{
		super("OMC replyed 'error' to '" + expression + "'");
		this.action = action;
		this.expression = expression;
	}
	
	/**
	 * Get the human readable description of the action that triggered this
	 * error. E.g. 'fetching contents of class foo.bar'
	 * 
	 * The description should be phrased so that
	 *
	 * @return the action
	 */
	public String getAction()
	{
		return action;
	}
	
	/**
	 * Gets the expression.
	 *
	 * @return the expression
	 */
	public String getExpression()
	{
		return expression;
	}
}
