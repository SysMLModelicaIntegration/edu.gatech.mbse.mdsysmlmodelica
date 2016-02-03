package edu.gatech.mbse.mdsysmlmodelica.helper;

public class ReplaceableComponent {
	String componentName;
	String componentOwnerQualifiedName;
	public String getComponentName() {
		return componentName;
	}
	public void setComponentName(String componentName) {
		this.componentName = componentName;
	}
	public String getComponentOwnerQualifiedName() {
		return componentOwnerQualifiedName;
	}
	public ReplaceableComponent(String componentName, String componentOwnerQualifiedName) {
		super();
		this.componentName = componentName;
		this.componentOwnerQualifiedName = componentOwnerQualifiedName;
	}
	public void setComponentOwnerQualifiedName(String componentOwnerQualifiedName) {
		this.componentOwnerQualifiedName = componentOwnerQualifiedName;
	}

}
