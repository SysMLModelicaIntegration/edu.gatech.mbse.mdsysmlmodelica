package edu.gatech.mbse.mdsysmlmodelica.helper;

public class RedeclareStatement {
	
	String className;
	String inheritedClassName;
	String newComponentTypeName;
	String componentName;
	public RedeclareStatement(String className, String inheritedClassName, String newComponentTypeName,
			String componentName) {
		this.className = className;
		this.inheritedClassName = inheritedClassName;
		this.newComponentTypeName = newComponentTypeName;
		this.componentName = componentName;
	}
	public String getClassName() {
		return className;
	}
	public void setClassName(String className) {
		this.className = className;
	}
	public String getInheritedClassName() {
		return inheritedClassName;
	}
	public void setInheritedClassName(String inheritedClassName) {
		this.inheritedClassName = inheritedClassName;
	}
	public String getNewComponentTypeName() {
		return newComponentTypeName;
	}
	public void setNewComponentTypeName(String newComponentTypeName) {
		this.newComponentTypeName = newComponentTypeName;
	}
	public String getComponentName() {
		return componentName;
	}
	public void setComponentName(String componentName) {
		this.componentName = componentName;
	}

}
