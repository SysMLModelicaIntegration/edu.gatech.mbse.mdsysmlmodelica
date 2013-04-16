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
 * This exception is thrown when there was error instantiating the
 * compiler object. Use getProblemType() to get details of the
 * instantiation problem.
 */
public class CompilerInstantiationException extends CompilerException
{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -1432532276931215491L;

	/**
	 * The Enum ProblemType.
	 */
	public enum ProblemType 
	{
		
		/** The N o_ compiler s_ found. */
		NO_COMPILERS_FOUND,
		
		/** The MULTIPL e_ compiler s_ found. */
		MULTIPLE_COMPILERS_FOUND,
		
		/** The ERRO r_ creatin g_ compiler. */
		ERROR_CREATING_COMPILER
	}
	
	/** The type. */
	private ProblemType type;
	
	/**
	 * Instantiates a new compiler instantiation exception.
	 *
	 * @param type the type
	 */
	public CompilerInstantiationException(ProblemType type)
	{
		super();
		this.type = type;
	}

	/**
	 * Instantiates a new compiler instantiation exception.
	 */
	public CompilerInstantiationException()
	{
		this(ProblemType.MULTIPLE_COMPILERS_FOUND);
	}

	/**
	 * Instantiates a new compiler instantiation exception.
	 *
	 * @param e the e
	 */
	public CompilerInstantiationException(Exception e)
	{
		super(e);
		type = ProblemType.ERROR_CREATING_COMPILER;
	}

	/**
	 * Gets the problem type.
	 *
	 * @return the problem type
	 */
	public ProblemType getProblemType()
	{
		return type;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Throwable#getMessage()
	 */
	public String getMessage()
	{
		String message = "";
		
		switch (type)
		{
		case NO_COMPILERS_FOUND:
			message = "No compilers found ";
			break;
		case MULTIPLE_COMPILERS_FOUND:
			message = "Multiple compilers found ";
			break;
		case ERROR_CREATING_COMPILER:
			message = "Error while connecting to the compiler " + getCause().getMessage();
			break;
		}
		
		return message;
	}
}
