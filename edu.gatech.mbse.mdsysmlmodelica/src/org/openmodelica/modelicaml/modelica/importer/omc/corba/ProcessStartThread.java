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

import java.io.File;

// TODO: Auto-generated Javadoc
/**
 * The Class ProcessStartThread.
 */
public class ProcessStartThread extends Thread
{
	
	/** The command. */
	String[] command;
	
	/** The working directory. */
	File workingDirectory;

	/**
	 * Instantiates a new process start thread.
	 *
	 * @param command the command
	 * @param workingDirectory the working directory
	 */
	public ProcessStartThread(String[] command, File workingDirectory)
	{
		this.command = command;
		this.workingDirectory = workingDirectory;
	}

	/* (non-Javadoc)
	 * @see java.lang.Thread#run()
	 */
	public void run()
	{
		try
		{
			int result;
			//prepare buffers for process output and error streams
			//StringBuffer err=new StringBuffer();
			//StringBuffer out=new StringBuffer();		    	
			Process proc=Runtime.getRuntime().exec(command, null, workingDirectory);
			//create thread for reading inputStream (process' stdout)
			StreamReaderThread outThread= new StreamReaderThread(proc.getInputStream(),System.out);
			//create thread for reading errorStream (process' stderr)
			StreamReaderThread errThread= new StreamReaderThread(proc.getErrorStream(),System.err);
			//start both threads
			outThread.start();
			errThread.start();
			//wait for process to end
			result=proc.waitFor();
			OMCProxy.logOMCStatus("The OMC process exited with code:" + result);
			OMCProxy.setHasInitialized(false);
			OMCProxy.setExistingCorbaFileIsNew(false);
			//finish reading whatever's left in the buffers
			outThread.join();
			errThread.join();
		}
		catch(Exception e)
		{
			e.printStackTrace();
			OMCProxy.logOMCStatus("Error running command " + e.getMessage());
			OMCProxy.logOMCStatus("Unable to start OMC, giving up."); 
		}	    
	}
}
