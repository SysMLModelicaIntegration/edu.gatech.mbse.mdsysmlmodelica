package edu.gatech.mbse.mdsysmlmodelica.helper;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Deque;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ReadAndParseFile {

	public static void main(String[] args) {
		
		String filePath = "C:\\Users\\Axel\\Documents\\Modelica Models\\HEV.mo";
		List<RedeclareStatement> replaceableStatements = getRedeclareStatements(filePath);
		for (RedeclareStatement redeclareStatement : replaceableStatements) {
			System.out.println("***");
			System.out.println("classQualifiedName: " + redeclareStatement.getClassName());
			System.out.println("inheritedClassName: " + redeclareStatement.getInheritedClassName());
			System.out.println("newComponentTypeName: " + redeclareStatement.getNewComponentTypeName());
			System.out.println("componentName: " + redeclareStatement.getComponentName());
			
		}
		
//		String filePath = "C:\\Users\\Axel\\Documents\\Modelica Models\\HEV.mo";
//		List<ReplaceableComponent> replaceableComponents =getReplaceableComponents(filePath);
//		for (ReplaceableComponent replaceableComponent : replaceableComponents) {
//			System.out.println("***");
//			System.out.println("componentName: " + replaceableComponent.getComponentName());
//			System.out.println("ComponentOwnerQualifiedName: " + replaceableComponent.getComponentOwnerQualifiedName());
//		}
		

	}

	public static List getReplaceableComponents(String filePath) {
		List<ReplaceableComponent> replaceableClassList =  new ArrayList<ReplaceableComponent>();
		
		
		Pattern regexp = Pattern.compile("\\A[\\s|\\t]*replaceable");
		Matcher matcher = regexp.matcher("");

//		
//		[ encapsulated ]
//				 [ partial ]
//				 ( class | model | record | block | [ expandable ] connector | type |
//				 package | function ) 
		
		Pattern startregexp = Pattern.compile("package\\s|model\\s|connector\\s|class\\s|record\\s|type\\s|function\\s");
		Matcher startmatcher = startregexp.matcher("");

		Pattern endregexp = Pattern.compile("\\A[\\s|\\t]*end\\s[^if;]");
		Matcher endmatcher = endregexp.matcher("");

		Path path = Paths.get(filePath);
		try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8);
				LineNumberReader lineReader = new LineNumberReader(reader);) {
			String line = null;
			String containerQualifiedName = null;

			Deque<String> stack = new ArrayDeque<String>();

			while ((line = lineReader.readLine()) != null) {

				matcher.reset(line); // reset the input
				startmatcher.reset(line);
				endmatcher.reset(line);

				if (endmatcher.find()) {
//					System.out.println("Container ends on line: " + lineReader.getLineNumber() + " -> " + line);
				stack.pop();

				} else if (startmatcher.find()) {
//					System.out.println("New Container on line: " + lineReader.getLineNumber() + " -> " + line);
					String[] strings = line.split("\\s");

					String containerName;
					int i = 0;
//					package\\s|model\\s|connector\\s|class\\s|record\\s|type\\s|function
					while (true) {
						if (strings[i].contains("model") | strings[i].contains("package") | strings[i].contains("connector") | strings[i].contains("class") | strings[i].contains("record") | strings[i].contains("type") | strings[i].contains("function")) {
							containerName = strings[i + 1];
							break;
						} else {
							// check next string separated by white space
							i++;
						}
					}

					stack.push(containerName);

				}

				if (matcher.find()) {
//					String msg = "Line " + lineReader.getLineNumber() + " contains replaceable: " + line;
//					System.out.println(msg);

					// get component name
					String[] stringArray = line.split("\\s");
					String componentName = null;					
					for (int k = 0; k < stringArray.length; k++) {
						if(stringArray[k].equals("replaceable")){
							componentName = stringArray[k + 2].replace(";", "");
						}						
					}
//					System.out.println(componentName);	
					
					// get complete qualifiedName
					int j = 0;
					containerQualifiedName = "";
					Iterator it = stack.descendingIterator();
					while (it.hasNext()) {
						if (j == 0) {
							containerQualifiedName = (String) it.next();
							j++;
						} else {
							containerQualifiedName = containerQualifiedName + "." + it.next();
						}
					}
					
					String[] strings = line.split("\\s");
					String replaceableClassName;
					int i = 0;
//					package\\s|model\\s|connector\\s|class\\s|record\\s|type\\s|function
					while (true) {
						if (strings[i].contains("replaceable") ) {
							replaceableClassName = strings[i + 1];
							break;
						} else {
							// check next string separated by white space
							i++;
						}
					}
					
					
					
					System.out.println(containerQualifiedName + "." + replaceableClassName);
					
					if(containerQualifiedName != null & componentName != null){
						ReplaceableComponent replaceableComponent = new ReplaceableComponent(componentName, containerQualifiedName);
						replaceableClassList.add(replaceableComponent);
					}
					
				}

				
			}

		} catch (IOException ex) {
			ex.printStackTrace();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return replaceableClassList;
	}

	public static List<RedeclareStatement> getRedeclareStatements(String modelicaFile) {
List<RedeclareStatement> redeclareStatementList =  new ArrayList<RedeclareStatement>();
		
		
		Pattern regexp = Pattern.compile("redeclare");
		Matcher matcher = regexp.matcher("");

//		
//		[ encapsulated ]
//				 [ partial ]
//				 ( class | model | record | block | [ expandable ] connector | type |
//				 package | function ) 
		
		Pattern startregexp = Pattern.compile("package\\s|model\\s|connector\\s|class\\s|record\\s|type\\s|function\\s|block\\s");
		Matcher startmatcher = startregexp.matcher("");

		Pattern endregexp = Pattern.compile("\\A[\\s|\\t]*end\\s[^if;]");
		Matcher endmatcher = endregexp.matcher("");

		Path path = Paths.get(modelicaFile);
		String lastLine = "";
		try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8);
				LineNumberReader lineReader = new LineNumberReader(reader);) {
			String line = null;
			String containerQualifiedName = null;

			Deque<String> stack = new ArrayDeque<String>();

			while ((line = lineReader.readLine()) != null) {

				matcher.reset(line); // reset the input
				
				
				startmatcher.reset(line);
				endmatcher.reset(line);

				if (endmatcher.find()) {
//					System.out.println("Container ends on line: " + lineReader.getLineNumber() + " -> " + line);
				stack.pop();

				} else if (startmatcher.find()) {
//					System.out.println("New Container on line: " + lineReader.getLineNumber() + " -> " + line);
					String[] strings = line.split("\\s");

					String containerName;
					int i = 0;
//					package\\s|model\\s|connector\\s|class\\s|record\\s|type\\s|function
					boolean isShortClassDef = false; 
					
					while (i < strings.length) {
						if (strings[i].contains("model") | strings[i].contains("package") | strings[i].contains("connector") | strings[i].contains("class") | strings[i].contains("record") | strings[i].contains("type") | strings[i].contains("function") | strings[i].contains("block")) {
							containerName = strings[i + 1];
							// check if short class def
							if(i + 2 < strings.length){
								if(strings[i + 2].equals("=")){
									// short class definition
									isShortClassDef = true;
								}
							}
							// check if class def in one line!
							if(strings[strings.length - 2].equals("end")){
								isShortClassDef = true;
							}
							if(!isShortClassDef){
								stack.push(containerName);
							}
							// get out of the loop
							i = strings.length;
						} else {
							// check next string separated by white space
							i++;
						}
					}
					
					
					

				}

				if (matcher.find()) {
					String msg = "Line " + lineReader.getLineNumber() + " contains redeclare: " + line;
//					System.out.println(lastLine);
//					System.out.println(msg);
					
					// create new line
					String newline = lastLine + line;
					
					// get complete container class qualified name
					int j = 0;
					containerQualifiedName = "";
					Iterator it = stack.descendingIterator();
					while (it.hasNext()) {
						if (j == 0) {
							containerQualifiedName = (String) it.next();
							j++;
						} else {
							containerQualifiedName = containerQualifiedName + "." + it.next();
						}
					}
					
//					System.out.println(containerQualifiedName);
					
					// get inheritedClass name
					String[] stringArray = newline.split("[\\s|(|)]");
					String inheritedClassName = null;					
					for (int k = 0; k < stringArray.length; k++) {
						if(stringArray[k].equals("extends")){
							inheritedClassName = stringArray[k + 1].replace(";", "");
						}						
					}
//					System.out.println(inheritedClassName);	
					
					// get list of redeclare statements									
					for (int k = 0; k < stringArray.length; k++) {
						if(stringArray[k].equals("redeclare")){
							String redeclareClassName = stringArray[k + 1].replace(",", "");
							String redeclareComponentName = stringArray[k + 2].replace(",", "");
//							System.out.println(redeclareClassName);
//							System.out.println(redeclareComponentName);
							redeclareStatementList.add(new RedeclareStatement(containerQualifiedName, inheritedClassName, redeclareClassName,
									redeclareComponentName));
						}						
					}
					
					
//					// get component name
//					String[] stringArray = line.split("\\s");
//					String componentName = null;					
//					for (int k = 0; k < stringArray.length; k++) {
//						if(stringArray[k].equals("replaceable")){
//							componentName = stringArray[k + 2].replace(";", "");
//						}						
//					}
//					System.out.println(componentName);	
//					
//					// get complete qualifiedName
//					int j = 0;
//					containerQualifiedName = "";
//					Iterator it = stack.descendingIterator();
//					while (it.hasNext()) {
//						if (j == 0) {
//							containerQualifiedName = (String) it.next();
//							j++;
//						} else {
//							containerQualifiedName = containerQualifiedName + "." + it.next();
//						}
//					}
//					
//					String[] strings = line.split("\\s");
//					String replaceableClassName;
//					int i = 0;
////					package\\s|model\\s|connector\\s|class\\s|record\\s|type\\s|function
//					while (true) {
//						if (strings[i].contains("replaceable") ) {
//							replaceableClassName = strings[i + 1];
//							break;
//						} else {
//							// check next string separated by white space
//							i++;
//						}
//					}
//					
//					
//					
//					System.out.println(containerQualifiedName + "." + replaceableClassName);
//					
//					if(containerQualifiedName != null & componentName != null){
//						ReplaceableComponent replaceableComponent = new ReplaceableComponent(componentName, containerQualifiedName);
//						replaceableClassList.add(replaceableComponent);
//					}
//					
				}
				
				lastLine = line;
				
			}

		} catch (IOException ex) {
			ex.printStackTrace();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return redeclareStatementList;
	}

}
