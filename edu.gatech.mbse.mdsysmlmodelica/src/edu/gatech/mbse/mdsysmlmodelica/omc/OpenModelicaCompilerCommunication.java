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

package edu.gatech.mbse.mdsysmlmodelica.omc;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import org.eclipse.emf.common.util.BasicEList;
import org.eclipse.emf.common.util.EList;
import org.openmodelica.modelicaml.modelica.importer.omc.corba.ConnectException;
import org.openmodelica.modelicaml.modelica.importer.omc.corba.OMCProxy;

import edu.gatech.mbse.mdsysmlmodelica.helper.StringHandler;
import edu.gatech.mbse.mdsysmlmodelica.mo2SysML.ModelicaComponentData;


public class OpenModelicaCompilerCommunication {

	private OMCProxy omc;
	private ArrayList<String> history;
	
	public OpenModelicaCompilerCommunication(){
		super();
		this.omc = new OMCProxy();
		history = new ArrayList<String>();
	}
			
	/**
	 * Execute command.
	 *
	 * @param command A command to OMC e.g. loadModel(Modelica), simulate(...), ...
	 * @return the string
	 */
	public String executeCommand(String command) {
//		System.err.println("Expression:" + command);

		/**
		 * Reply from OMC
		 */
		String reply = "no reply";

		if (command != null && command.length() > 0) {
			history.add(command);
			try {
//				String countX = omc.sendExpression("getEquationItemsCount(TwoTankExample.BaseController)");
				reply = omc.sendExpression(command);
			} catch (Exception ex) {
				reply = "\nError while sending expression: " + command + "\n"
						+ ex.getMessage();
			}
		} else {
			reply = ("\nNo expression sent because is empty");
		}

		return reply;
	}
	
	/**
	 * Change directory to the directory given as a string.
	 * 
	 * @param dir
	 *            a directory given as a string. NOTE: USE slash "/" instead of "\\"
	 * @return Reply from OMC
	 */
	public String cd(String dir) {
		return executeCommand("cd(\"" + dir + "\")");
	}
	
	/**
	 * Request actual OMC working directory.
	 * 
	 * @return Reply from OMC, path to omc working directory
	 */
	public String cd() {
		return executeCommand("cd()");
	}
	
	/**
	 * Clear everything.
	 * @return Reply from OMC
	 */
	public String clear(){
		return executeCommand("clear()");
	}
	
	/**
	 * Instantiates a model/class and returns a string containing the flat class definition.
	 * Ex: instantiateModel(dcmotor)
	 *
	 * @param modelname the modelname
	 * @return Reply from OMC
	 */
	public String instantiateModel(String modelname){
		return executeCommand("instantiateModel("+ modelname + ")");
	}
	
	
	/**
	 * Clear the variables.
	 * @return Reply from OMC
	 */
	public String clearVariables(){
		return executeCommand("clearVariables()");
	}
	
	/**
	 * Return a string containing all class definitions.
	 * 
	 * @return Reply from OMC
	 */
	public String list() {
		return executeCommand("list()");
	}

	/**
	 * Return a string containing the class definition of the named class. Ex:
	 * list(dcmotor)
	 *
	 * @param modelname the modelname
	 * @return Reply from OMC
	 */
	public String list(String modelname) {
		return executeCommand("list(" + modelname + ")");
	}

	/**
	 * 
	 Return a vector of the currently defined variable names.
	 * 
	 * @return Reply from OMC
	 */
	public String listVariables() {
		return executeCommand(listVariables());
	}

	/**
	 * Load modelica file given as string argument. Ex:
	 * loadFile("../myLibrary/myModels.mo")
	 *
	 * @param strFile the str file
	 * @return Reply from OMC
	 */
	public String loadFile(String strFile) {
		return executeCommand("loadFile(\"" + strFile + "\")");
	}	
	
	/**
	 * Load model, function, or package relative to $OPENMODELICALIBRARY.
	 * Ex: loadModel(Modelica.Electrical) Note: if e.g. loadModel(Modelica) fails,
	 * you may have OPENMODELICALIBRARY pointing at the wrong location.
	 *
	 * @param name the name
	 * @return Reply from OMC
	 */
	public String loadModel(String name) {
		return executeCommand("loadModel(" + name + ")");
	}
	
	/**
	 * Define a model from "model Name" ... to ... "end Name"
	 * @param modelCode Full Modelica model code
	 * @return Reply from OMC
	 */
	public String defineModel(String modelCode) {
		return executeCommand(modelCode);
	}
	
	/**
	 * Translates a model but does not simulate it automatically.
	 *
	 * @param MainClass name of the main class
	 * @param outputFormat for the results. For now just the "plt" format will be supported.
	 * @return Reply from OMC
	 */
	public String buildModel(String MainClass, String outputFormat){
		return executeCommand("buildModel("+MainClass+ ", outputFormat=\""+ outputFormat +"\")");
	}
	
	/**
	 * Translates a model but does not simulate it automatically.
	 *
	 * @param MainClass name of the main class
	 * @param outputFormat for the results. For now just the "plt" format will be supported.
	 * @return Reply from OMC
	 */
	public String buildModel(String MainClass, String startTime, String stopTime, String numberOfIntervals, String tolerance, String method, String outputFormat){
		return executeCommand("buildModel("+MainClass+ ", startTime=" +startTime+ ", stopTime=" +stopTime+ ", numberOfIntervals="+numberOfIntervals+ ", tolerance="+tolerance+ ", method=\""+method + "\", outputFormat=\"" + outputFormat +"\")");
	}
	
	/**
	 * Translates a model and simulates it automatically.
	 *
	 * @param MainClass name of the main class
	 * @param outputFormat for the results. For now just the "plt" format will be supported.
	 * @return Reply from OMC
	 */
	public String simulate(String MainClass, String startTime, String stopTime, String numberOfIntervals, String tolerance, String method, String outputFormat){
		return executeCommand("simulate("+MainClass+ ", startTime=" +startTime+ ", stopTime=" +stopTime+ ", numberOfIntervals="+numberOfIntervals+ ", tolerance="+tolerance+ ", method=\""+method + "\", outputFormat=\"" + outputFormat +"\")");
	}
	
	/**
	 * Check a model.
	 *
	 * @param MainClass name of the main class
	 * @return Reply from OMC
	 */
	public String checkModel(String MainClass){
		return executeCommand("checkModel("+MainClass+")");
	}
	
	
	/**
	 * Leave OpenModelica and kill the process.
	 * 
	 * @return Reply from OMC
	 */
	public String quit() {
		return executeCommand("quit()");
	}
	
	/**
	 * Get a possible error String from omc after executing a command.
	 *
	 * @return error string as reply from omc
	 */
	public String getErrorString(){
		return executeCommand("getErrorString()");
	}
	
	public String getInstallationDirectoryPath(){
		return executeCommand("getInstallationDirectoryPath()");
	}
	
	public String getTempDirectoryPath(){
		return executeCommand("getTempDirectoryPath()");
	}
	
	public String getModelicaPath(){
		return executeCommand("getModelicaPath()");
	}
	
	public String getVersion(){
		return executeCommand("getVersion()");
	}
	
	public String getNamedAnnotation(String className, String annotationName ){
		return executeCommand("getNamedAnnotation(" + className + "," + annotationName+")");
	}
	
	public String getClassNames(String parentClassQName){
		return executeCommand("getClassNames("+parentClassQName+")");
	}
	
	public String getClassNamesWithProtected(String parentClassQName){
		return executeCommand("getClassNames("+parentClassQName+", showProtected = true)");
	}
	
	public String getClassNamesRecursive(String ownerName){
		return executeCommand("getClassNamesRecursive(" + ownerName + ")");
	}
	
	public String getClassInformation(String className){
		return executeCommand("getClassInformation(" + className + ")");
	}
	
	public String getShortDefinitionBaseClassInformation(String className){
		return executeCommand("getShortDefinitionBaseClassInformation(" + className + ")");
	}
	
	public String getExternalFunctionSpecification(String className){
		return executeCommand("getExternalFunctionSpecification(" + className + ")");
	}	
		
	public String getClassRestriction(String className){
		return executeCommand("getClassRestriction(" + className + ")");
	}

	public String isConnector(String className){
		return executeCommand("isConnector(" + className + ")");
	}
	
//	public String getInheritanceCount(String className){
//		return executeCommand("getInheritanceCount(" + className + ")");
//	}
	
	public String getNthInheritedClass(String className, String n){
		return executeCommand("getNthInheritedClass(" + className+ "," + n + ")");
	}
	
	public String getDeclarationEquation(String className, String componentName){
		return executeCommand("getParameterValue(" + className+ "," + componentName + ")");
	}
	
	public String getComponents(String className){
		return executeCommand("getComponents(" + className + ")");
	}
	
	public String getComponents(String className, String useDoubleQuotes){
		return executeCommand("getComponents(" + className + ", " + useDoubleQuotes + ")");
	}
	
	public String getComponentNames(String className){
		return executeCommand("getComponentNames(" + className + ")");
	}
	
	public String getDocumentationAnnotation(String className){
		return executeCommand("getDocumentationAnnotation(" + className + ")");
	}			 
	
	public String getComponentModifierNames(String className, String componentName){
		return executeCommand("getComponentModifierNames(" + className + ", " + componentName+ ")");
	}
	
	public String getComponentModifierValue(String className, String componentName){
		return executeCommand("getComponentModifierValue(" + className + ", " + componentName+ ")");
	}
	
	public String getExtendsModifierNames(String className, String extendedClassName){
		return executeCommand("getExtendsModifierNames(" + className + ", "  + extendedClassName + ")");
	}
	
	public String getExtendsModifierValue(String className, String extendedClassName, String componentName){
		return executeCommand("getExtendsModifierValue(" + className + ", " + extendedClassName+ ", " + componentName+ ")");
	}
	
	public Integer getInheritanceCount(String className){
		String reply = executeCommand("getInheritanceCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror") ) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getInheritanceCount("+className+")");
		}
		return 0;
	}
	
	public List<String> getInheritedClasses(String className){
		int count = getInheritanceCount(className);
		List<String> inheritedClasses = new ArrayList<String>();
		if (count > 0 ) {
			for (int i = 1; i <= count; i++) {
				String reply = getNthInheritedClass(className, String.valueOf(i)).trim();
				if (!reply.equals("") && !reply.equals("Error") && !reply.equals("false")) {
					inheritedClasses.add(reply);
				}
			}
		}
		return inheritedClasses;
	}
	
	public String getNthComponentCondition(String componentName, int number){
		return executeCommand("getNthComponentCondition(" + componentName + ", " + number+ ")");
	}
	
	public String isEnumeration(String className){
		return executeCommand("isEnumeration(" + className + ")");
	}
	
	public String getEnumerationLiterals(String className){
		return executeCommand("getEnumerationLiterals(" + className + ")");
	}
	
	public boolean isReplaceable(String upperClassName, String nestedClassName){		
		String isReplaceableStr = executeCommand("isReplaceable(" + upperClassName + ", \"" + nestedClassName + "\")");	
		return Boolean.parseBoolean(isReplaceableStr);
	}	
	
	public Integer getAnnotationCount(String className){
		String reply = executeCommand("getAnnotationCount(" + className + ")");
		if (reply != null && !(reply.contains("rror")) ) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getAnnotationCount("+className+")");
		}
		return 0;
	}
	
	public List<String> getAnnotations(String className){
		int count = getAnnotationCount(className);
		List<String> annotations = new ArrayList<String>();
		if (count > 0 ) {
			for (int i = 1; i <= count; i++) {
				String reply = getNthAnnotationString(className, String.valueOf(i)).trim();
				if (!reply.equals("") && !reply.equals("Error") && !reply.equals("false")) {
					String stringInBrackets = StringHandler.removeFirstLastDoubleQuotes(reply.trim().replaceFirst("annotation", "").trim());
					String annotationString = StringHandler.removeFirstLastBrackets(stringInBrackets.substring(0, stringInBrackets.length() - 1));
					annotations.add(annotationString);
				}
			}
		}
		return annotations;
	}
	
	public String getNthAnnotationString(String elementName, String number){
		return executeCommand("getNthAnnotationString(" + elementName + ", " + number+ ")");
	}
				
	public int getImportCount(String className){
		String reply = executeCommand("getImportCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !(reply.contains("rror"))) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getImportCount("+className+")");
		}
		return 0;
	}
	
	public String getNthImport(String className, int number){
		return executeCommand("getNthImport(" + className + ", " + number+ ")");
	}
				
	public Integer getInitialAlgorithmCount(String className){
		String reply = executeCommand("getInitialAlgorithmCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror") ) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getInitialAlgorithmCount("+className+")");
		}
		return 0;
	}

	public String getNthInitialAlgorithm(String className, String number){
		return executeCommand("getNthInitialAlgorithm(" + className + ", " + number+ ")");
	}
	
	public List<String> getInitialAlgorithms(String className){
		int count = getInitialAlgorithmCount(className);
		List<String> initialAlgorithms = new ArrayList<String>();
		if (count > 0 ) {
			for (int i = 1; i <= count; i++) {
				String reply = getNthInitialAlgorithm(className, String.valueOf(i)).trim();
				if (!reply.equals("") && !reply.equals("Error") && !reply.equals("false")) {
//					initialAlgorithms.add(StringHandler.removeFirstLastDoubleQuotes(reply.trim()));
					String string = StringHandler.removeFirstLastDoubleQuotes(reply.trim());
					initialAlgorithms.add(replaceSpecChars(string));
				}
			}
		}
		return initialAlgorithms;
	}
				
	public Integer getAlgorithmCount(String className){
		String reply = executeCommand("getAlgorithmItemsCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror")) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getAlgorithmCount("+className+")");
		}
		return 0;
	}

	public String getNthAlgorithm(String className, String number){
		return executeCommand("getNthAlgorithmItem(" + className + ", " + number+ ")");
	}
	
	public List<String> getAlgorithms(String className){
		int count = getAlgorithmCount(className);
		List<String> algorithms = new ArrayList<String>();
		if (count > 0 ) {
			for (int i = 1; i <= count; i++) {
				String reply = getNthAlgorithm(className, String.valueOf(i)).trim();
				if (!reply.equals("") && !reply.equals("Error") && !reply.equals("false")) {
//					algorithms.add(StringHandler.removeFirstLastDoubleQuotes(reply.trim()));
					String string = StringHandler.removeFirstLastDoubleQuotes(reply.trim());
					algorithms.add(replaceSpecChars(string));
				}
			}
		}
		return algorithms;
	}
			
	public Integer getInitialEquationCount(String className){
		String reply = executeCommand("getInitialEquationCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror")) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getInitialEquationCount("+className+")");
		}
		return 0;
	}

	public String getNthInitialEquation(String className, String number){
		return executeCommand("getNthInitialEquation(" + className + ", " + number+ ")");
	}
	
	public List<String> getInitialEquations(String className){
		int count = getInitialEquationCount(className);
		List<String> initialEquations = new ArrayList<String>();
		if (count > 0 ) {
			for (int i = 1; i <= count; i++) {
				String reply = getNthInitialEquation(className, String.valueOf(i)).trim();
				if (!reply.equals("") && !reply.equals("Error") && !reply.equals("false")) {
//					initialEquations.add(StringHandler.removeFirstLastDoubleQuotes(reply.trim()));
					String string = StringHandler.removeFirstLastDoubleQuotes(reply.trim());
					initialEquations.add(replaceSpecChars(string));

				}
			}
		}
		return initialEquations;
	}
	
			
	public Integer getEquationCount(String className){		
		String reply = executeCommand("getEquationItemsCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror") ) {
			Integer count = Integer.valueOf(reply.trim());
			if ( count != null ) {
				return count;
			}
		}
		else {
			System.err.println("Could not complete the operation getEquationCount("+className+")");
		}
		return 0;
	}

	public String getNthEquation(String className, String number){
		return executeCommand("getNthEquationItem(" + className + ", " + number+ ")");
	}
	
	public List<String> getEquations(String className){
		int count = getEquationCount(className);		
		List<String> equations = new ArrayList<String>();
		if (count > 0 ) {
			for (int i = 1; i <= count; i++) {
				String reply = getNthEquation(className, String.valueOf(i)).trim();
				if (!reply.equals("") && !reply.equals("Error") && !reply.equals("false")) {
					String string = StringHandler.removeFirstLastDoubleQuotes(reply.trim());
					equations.add(replaceSpecChars(string));
				}
			}
		}
		return equations;
	}
	
	public List<String> getConnections(String className){
		Integer count = null;
		String reply = executeCommand("getConnectionCount(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror") ) {
			count = Integer.valueOf(reply.trim());			
		}
		else {
			System.err.println("Could not complete the operation getEquationCount("+className+")");
		}
		List<String> connections = new ArrayList<String>();
		if (count != null ) {					
			if (count > 0 ) {
				for (int i = 1; i <= count; i++) {
					String connectEquation = executeCommand("getNthConnection(" + className + ", " + String.valueOf(i) + ")").trim();					
					if (!connectEquation.equals("") && !connectEquation.equals("Error") && !connectEquation.equals("false")) {
						String string = StringHandler.removeFirstLastDoubleQuotes(connectEquation.trim());
						connections.add(replaceSpecChars(string));
					}
				}
			}
		}
		return connections;
	}
	
	
	
	public boolean isShortDefinition(String className){
		Boolean isShortDefinition = null;
		String reply = executeCommand("isShortDefinition(" + className + ")");
		if (reply != null && !reply.trim().equals("") && !reply.contains("rror") ) {
			isShortDefinition = Boolean.valueOf(reply.trim());			
		}
		else {
			System.err.println("Could not complete the operation isShortDefinition("+className+")");
		}
		return isShortDefinition;
	}
	
	public ArrayList<ModelicaComponentData> getComponentData(String className){		
		ArrayList<ModelicaComponentData> list = new ArrayList<ModelicaComponentData>();
		
		String reply = executeCommand("getComponents(" + className + ")");
		for (String stringFromArray : StringHandler.unparseArrays(reply)) {
			
			ArrayList<String> items = StringHandler.unparseComponentStrings(stringFromArray);
			
			if (items.size() > 10 ) {
				
				ModelicaComponentData data = new ModelicaComponentData();

				data.setTypeQName(items.get(0).trim());
//				data.setType(getTypeElement(data.getTypeQName()));
				data.setName(items.get(1).trim());
				
				data.setComment(items.get(2));
				data.setVisibility(items.get(3));
				
				// default values
				boolean isFinal = false;
				boolean isFlow = false;
				boolean isStream = false;
				boolean isReplaceable= false;
				
				if (items.get(4).trim().equals("true")) {
					isFinal = true;
				}
				if (items.get(5).trim().equals("true")) {
					isFlow = true;
				}
				if (items.get(6).trim().equals("true")) {
					isStream = true;
				}
				if (items.get(7).trim().equals("true")) {
					isReplaceable = true;
				}
				
				data.setFinal(isFinal);
				data.setFlow(isFlow);
				data.setStream(isStream);
				data.setReplaceable(isReplaceable);
				
				data.setVariability(items.get(8));
				data.setInnerouter(items.get(9));
				data.setCausality(items.get(10));
				
				String[] arraySizeItems = StringHandler.removeFirstLastCurlBrackets(items.get(11).trim()).split(",");
				if ( arraySizeItems.length > 0 ) {
					EList<String> arraySizeItemsList = new BasicEList<String>();
					for (int i = 0; i < arraySizeItems.length; i++) {
						if(!arraySizeItems[i].equals("")){
							String arraySizeItem = arraySizeItems[i];
							if(!arraySizeItem.equals(":")){
								int colonIndex = arraySizeItem.indexOf(":");
								while(colonIndex > -1){
									String firstArraySizeItem = arraySizeItem.substring(0, colonIndex + 1);
									String RestOfArraySizeItem = arraySizeItem.substring(colonIndex + 1, arraySizeItem.length());
									if(firstArraySizeItem.startsWith(":")){
										arraySizeItemsList.add(firstArraySizeItem);
									}
									else{
										firstArraySizeItem = firstArraySizeItem.replaceAll(":", "");
										arraySizeItemsList.add(firstArraySizeItem);
									}
									arraySizeItem = RestOfArraySizeItem;
									colonIndex = RestOfArraySizeItem.indexOf(":");								
								}
							}							
							arraySizeItemsList.add(arraySizeItem);
						}						
					}
					data.setArraySize(arraySizeItemsList);
				}
				
				list.add(data);
			}
		}
		return list;
	}
	
	
	
	public static ArrayList<String> unparseArrays(String value) {
		
		 ArrayList<String> lst = new ArrayList<String>();
		  int qopen = 0;
		  int qopenindex = 0;
		  int braceopen = 0;
		  int mainbraceopen = 0;
		  int i = 0;
		  int count = 0;
		  value = StringHandler.removeFirstLastCurlBrackets(value);
//		  System.err.println(value);
		  int length = value.length();
		  int subbraceopen = 0;
		  
		  for (i=0; i < length ; i++)
		  {
		    if (value.charAt(i) == ' ' || value.charAt(i) == ',') continue; // ignore any kind of space
		    if (value.charAt(i) == '{' && qopen == 0 && braceopen == 0)
		    {
		    	
		      braceopen = 1;
		      mainbraceopen = i;
		      continue;
		    }
		    if (value.charAt(i) == '{')
		    {
		      subbraceopen = 1;
		    }
		    
		    char temp = value.charAt(i);
		    
		    if (value.charAt(i) == '}' && braceopen == 1 && qopen == 0 && subbraceopen == 0)
		    {
		      //closing of a group
//		      char * tmp = new char [i -mainbraceopen +5];
		      int copylength = i - mainbraceopen + 1;
//		      strncpy (tmp, value.toStdString().data() + mainbraceopen , copylength);
//		      tmp [copylength] = 0;
		      braceopen = 0;
		      //printf("arr[%d]=%s;\n", count, tmp);
//		      lst.append(QString(tmp));
//		      lst.add(value.substring(value.length() + mainbraceopen, copylength));
		      lst.add(value.substring(mainbraceopen, mainbraceopen + copylength));
//		      delete tmp;
		      count ++;
		      continue;
		    }
		    if (value.charAt(i) == '}')
		      subbraceopen = 0;

		    if (value.charAt(i) == '\"')
		    {
		      if (qopen == 0)
		      {
		        qopen = 1;
		        qopenindex = i;
		      }
		      else
		      {
		        // its a closing quote
		        qopen = 0;
		      }
		    }
		  }
		  return lst;
	}
	
	private String replaceSpecChars(String string){
		String newString = string.replaceAll("\\\\" + "\"", "\"");
		return newString;
	}
	
	
	
	/**
	 * Gets the command history.
	 *
	 * @return the command history
	 */
	public ArrayList<String> getCommandHistory() {
//		ArrayList<String> tempHistory = new ArrayList<String>();
//		Collections.copy(tempHistory, history);
//
//		return tempHistory;
		return this.history;
	}
	
	
}
