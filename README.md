#MagicDraw SysML plugin for Modelica
===============================

Java-based implementation of the OMG SysML-Modelica Transformation (SyM) using MagicDraw SysML v18.v2 or more recent version


##Instructions to install and execute the roundtrip SysML-Modelica transformation

By Axel Reichwein, February 22, 2016

Overview: There are two usage modes to run the bidirectional SysML-Modelica transformations: **user mode** and **developer mode**. 
- User mode allows to open MagicDraw and run the bidirectional SysML-Modelica transformations. 
- Developer mode allows to launch MagicDraw and run the MagicDraw plugins from the Eclipse IDE. This is helpful to review, debug, and extend the source code of the MagicDraw plugins.

Requirements: 
•	SysML-Modelica Transformation May-31-2012.zip 
•	org.gt.mbse.mdsysml2modelica.zip 
•	org.gt.mbse.modelica2mdsysml.zip 


###Installing OpenModelica

1. Install the OpenModelicaCompiler 1.9.3 at: https://build.openmodelica.org/omc/builds/windows/releases/1.9.3/. Install it under C:\ since there may be some problems if you install it somewhere else.
2. Create the OPENMODELICA Environment variable if it has not been created through the installation of the OpenModelicaCompiler. On Windows 7, Start->Control Panel->System and Security-> Advanced System Settings->Environment Variables. Define OPENMODELICAHOME to point to drive:\path\to\your\OpenModelica-X.Y.Z\ (e.g. C:\OpenModelica1.9.3\). 
3. Restart your computer.


###User Mode

#### Launching MagicDraw with Modelica plugins 

1. Unzip the org.gt.mbse.mdsysml2modelica.zip and org.gt.mbse.modelica2mdsysml.zip files. Place the unzipped folders in the plugins folder of your MagicDraw installation directory (e.g. C:\Program Files\MagicDraw UML\plugins).
2. Launch the MagicDraw application. 
	
#### Importing Modelica models into MagicDraw SysML 

3. Download  [ModelicaImportTest.mdzip](/edu.gatech.mbse.mdsysml2modelica/MagicDraw%20Projects/ModelicaImportTest.mdzip). Click on Raw to download the file.
4. Also download the associated SysML4Modelica profile. Download  [sysml4modelicaprofile.mdzip](/edu.gatech.mbse.mdsysml2modelica/MagicDraw%20Projects/sysml4modelicaprofile.mdzip). Click on Raw to download the file. 
5. 2 Options to import Modelica models into SysML
	1. Option A: Place the sysml4modelicaprofile.mdzip file in the same folder as the ModelicaImportTest.mdzip file. This is necessary as the ModelicaImportTest model refers to the sysml4modelicaprofile profile. Open the empty ModelicaImportTest.mdzip model. 
	2. Option B: Create a new SysML project in MagicDraw with File->New Project-> Create SysML project. Click on the Options menu. Select “use Module”. Choose the SysML4Modelica profile. Click Next. In the field “Module Packages”, the SysML4Modelica package should be displayed. If yes, make sure that it is marked and click on “Finish”. This new empty SysML project with the SysML4Modelica profile as module should be saved. It can then be reused on future occasions as a MagicDraw project that is ready to directly import a Modelica model.
6. You are now ready to import a Modelica model into the MagicDraw SysML project. Go on Data (right click)->Modelica to SysML->Import Modelica. Select the Modelica .mo file. Sample Modelica files such as TwoTankExample.mo, InverseModel.mo and fullRobot.mo can be found [here](/edu.gatech.mbse.mdsysml2modelica/Modelica%20models)
7. After having imported a Modelica model into SysML, it is possible to automatically create the IBD. Select the Modelica class which contains connectors and then Right mouse->New Diagram->SysML Internal Block Diagram and then choose your favorite layout. Some manual refactoring will most likely still be necessary to make it look nice

#### Exporting MagicDraw SysML models into  Modelica

**After having imported a Modelica model into SysML, or once a SysML4Modelica model is available in MagicDraw, it can be exported into Modelica**. Select “Data” or a Modelica package that should be exported and right click and select SysML to Modelica->Generate Modelica. The generated Modelica model will be located in the MagicDraw installation directory and be named “generated_Modelica.mo”. If the generated Modelica model is not visible in the MagicDraw installation directory, it couldn’t be created because of user rights. Make sure to launch MagicDraw with administrator rights. 




###Developer mode 

The code of the MagicDraw plugin for the bidirectional SysML-Modelica transformation is within an Eclipse java project. A Java launch configuration will launch Magicdraw with the SysML-> Modelica and Modelica->SysML transformation plugins. All steps of the transformation can then be followed in the debug perspective of the Eclipse environment. 

#### Installing Eclipse

Install [Eclipse](http://www.eclipse.org/downloads/). For example the Eclipse IDE for Java Developers package or the 
Eclipse IDE for Java EE Developers package).


#### 4.	Downloading edu.gatech.mbse.mdsysmlmodelica repository 

1.	Open the Git Repositories View (Window -> Show View -> type “Git Repositories” in the search field)
2.	Click on the Clone Repository icon  
3.	In the URI field, paste the following URL: https://github.com/SysMLModelicaIntegration/edu.gatech.mbse.mdsysmlmodelica.git 
4.	The Host and Repository fields will autofill. 
5.	Click Next, only select the master branch
6.	Click Next until Finish.


### 5.	Importing projects into the Eclipse workspace

1.	In the Git repositories view, right-click edu.gatech.mbse.mdsysmlmodelica and select “Import Projects”. Click Next until Finish
2.	The 2 projects are in the Eclipse workspace

### 5.	Configuring projects 

1. It is necessary to specify the location of the MagicDraw jars. In Eclipse, open the Project Explorer view. (Window → Show View → Project Explorer). For both the edu.gatech.mbse.modelica2sysml and the edu.gatech.mbse.mdsysml2modelica projects, do the following:
	1. Expand the project
	2. Right-click on the resource named *MAGIC_DRAW_INSTALL_DIRECTORY*
	3. Edit the location of the linked resources to point to your MagicDraw installation directory (for example C:\Program Files\MagicDraw18-2)

### 5.	Configuring the launch configuration 

1. In Eclipse, open the Project Explorer view. (Window → Show View → Project Explorer). Expand the project edu.gatech.mbse.modelica2sysml
2. Double-click on the resource named *mdsysmlmodelica.launch*
3. Edit the before last line (line 19) to edit the md.plugins.dir Java system property (at the end of the long line) to refer to the location of your local edu.gatech.mbse.mdsysmlmodelica Git repository. (For example, if the Git repo is located on your file system at
 ```text 
C:\Users\Axel\git\edu.gatech.mbse.mdsysmlmodelica-feb19-2016
```
, then edit the md.plugins.dir Java system property to refer to 
 ```text 
C:\\Users\\Axel\\git\\edu.gatech.mbse.mdsysmlmodelica-feb19-2016
```
. Make sure to carefully replace the default path location with your location while considering these rules:
	1. Make sure to include a double backslash for every slash in the path location (Example: "gitrepos\myrepo" -> "gitrepos\\\\myrepo")
	2. Make sure to include a semicolon (;) to separate your path entry from others and to include the following character sequence to end the path entry: 
 ```text
&quot;"/>
```

### 6.	Running MagicDraw with Modelica plugins 

1. Select the *mdsysmlmodelica.launch* launch configuration (Run -> Run Configurations… and select in the Java application category the launch configuration named *mdsysmlmodelica.launch*) and click Run. 
2. Next it is necessary to import the SysML4Modelica profile as a module within a new and empty MagicDraw SysML project. The SysML4Modelica profile is located in the org.gt.mbse.mdsysmlmodelica project under \MagicDraw Projects. It can be copied into a more appropriate folder like the \Documents\MagicDraw Projects folder.


9.	Create a new SysML project in MagicDraw (if possible with MagicDraw 17.0) with File->New Project-> Create SysML project. Click on the Options menu. Select “use Module”. Choose the SysML4Modelica profile. Click Next. In the field “Module Packages”, the SysML4Modelica package should be displayed. If yes, make sure that it is marked and click on “Finish”. This new empty SysML project with the SysML4Modelica profile as module should be saved. It can then be reused on future occasions as a MagicDraw project that is ready to directly import a Modelica model.
 	 	 

10.	You are now ready to import a Modelica model into the MagicDraw SysML project. Go on Data (right click)->Modelica to SysML->Import Modelica. Select the Modelica .mo file. 

 	 	 


11.	After having imported a Modelica model into SysML, or once a SysML4Modelica model is available in MagicDraw, it can be exported into Modelica. Select “Data” or a Modelica package that should be exported and right click and select SysML to Modelica->Generate Modelica. The generated Modelica model will be located in the Eclipse workspace in the org.gt.mbse.mdsysmlmodelica project and be named “generated_Modelica.mo”
 


