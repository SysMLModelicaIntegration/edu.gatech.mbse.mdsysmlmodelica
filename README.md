#MagicDraw SysML plugin for Modelica
===============================

Java-based implementation of the OMG SysML-Modelica Transformation (SyM) using MagicDraw SysML


##Instructions to install and execute the roundtrip SysML-Modelica transformation

By Axel Reichwein, February 2, 2016

Overview: There are two usage modes to run the bidirectional SysML-Modelica transformations: user mode and debugger mode. 
- The user mode allows to open MagicDraw and run the bidirectional SysML-Modelica transformations. 
- The debugger mode allows to launch MagicDraw and run the transformations by seeing the single steps of the transformation in the source code. The debugger mode is helpful to understand, extend and debug the source code.

Requirements: 
•	SysML-Modelica Transformation May-31-2012.zip 
•	org.gt.mbse.mdsysml2modelica.zip 
•	org.gt.mbse.modelica2mdsysml.zip 

###User Mode

1.	Install the OpenModelicaCompiler 1.9.3 at: https://build.openmodelica.org/omc/builds/windows/releases/1.9.3/. Install it under C:\ since there may be some problems if you install it somewhere else.
2.	Create the OPENMODELICA Environment variable if it has not been created through the installation of the OpenModelicaCompiler. On Windows 7, Start->Control Panel->System and Security-> Advanced System Settings->Environment Variables. Define OPENMODELICAHOME to point to drive:\path\to\your\OpenModelica-X.Y.Z\ (e.g. C:\OpenModelica1.9.3\). Restart your computer.
3.	Unzip the org.gt.mbse.mdsysml2modelica.zip and org.gt.mbse.modelica2mdsysml.zip files. Place the unzipped folders in the plugins folder of your MagicDraw installation directory (e.g. C:\Program Files\MagicDraw UML\plugins).
4.	Launch the MagicDraw application. Disable plugin "Caliber Integration" if available through Options->Environment->Plugins. Otherwise, there will be a problem with the Corba connection that OMC needs to set up. Restart MagicDraw after disabling the "Caliber Integration" plugin.
5.	Next it is necessary to import the SysML4Modelica profile as a module within a new and empty MagicDraw SysML project. 

Download ModelicaImportTest.mdzip available on GitHub at https://github.com/SysMLModelicaIntegration/edu.gatech.mbse.mdsysmlmodelica/blob/master/edu.gatech.mbse.mdsysmlmodelica/MagicDraw%20Projects/ModelicaImportTest.mdzip  Click on Raw to download the file.

Download sysml4modelicaprofile.mdzip available on GitHub at https://github.com/SysMLModelicaIntegration/edu.gatech.mbse.mdsysmlmodelica/blob/master/edu.gatech.mbse.mdsysmlmodelica/MagicDraw%20Projects/sysml4modelicaprofile.mdzip    Click on Raw to download the file.

Option A: 
Place the sysml4modelicaprofile.mdzip file in the same folder as the ModelicaImportTest.mdzip file. This is necessary as the ModelicaImportTest model refers to the sysml4modelicaprofile profile. Open the empty ModelicaImportTest.mdzip model. 

Option B: Create a new SysML project in MagicDraw (if possible with MagicDraw 17.0) with File->New Project-> Create SysML project. Click on the Options menu. Select “use Module”. Choose the SysML4Modelica profile. Click Next. In the field “Module Packages”, the SysML4Modelica package should be displayed. If yes, make sure that it is marked and click on “Finish”. This new empty SysML project with the SysML4Modelica profile as module should be saved. It can then be reused on future occasions as a MagicDraw project that is ready to directly import a Modelica model.

 	 	 

6.	You are now ready to import a Modelica model into the MagicDraw SysML project. Go on Data (right click)->Modelica to SysML->Import Modelica. Select the Modelica .mo file. Sample Modelica files such as TwoTankExample.mo, InverseModel.mo and fullRobot.mo can be found in the Roundtrip-SysML-Modelica-June 21 2012.zip\org.gt.mbse.mdsysmlmodelica\ Modelica models folder. 

 	 	 


7.	After having imported a Modelica model into SysML, it is possible to automatically create the IBD. Select the Modelica class which contains connectors and then Right mouse->New Diagram->SysML Internal Block Diagram and then choose your favorite layout. Some manual refactoring will most likely still be necessary to make it look nice

8.	After having imported a Modelica model into SysML, or once a SysML4Modelica model is available in MagicDraw, it can be exported into Modelica. Select “Data” or a Modelica package that should be exported and right click and select SysML to Modelica->Generate Modelica. The generated Modelica model will be located in the MagicDraw installation directory and be named “generated_Modelica.mo”. If the generated Modelica model is not visible in the MagicDraw installation directory, it couldn’t be created because of user rights. Make sure to launch MagicDraw with administrator rights. 


 


****************************************************************

Debugger mode: The code of the MagicDraw plugin for the bidirectional SysML-Modelica transformation is within an Eclipse java project. A Java application exists that will launch Magicdraw with the transformation plugin. All steps of the transformation can then be followed in the debug perspective of the Eclipse environment. 

Installation steps
1.	Install the OpenModelicaCompiler revision- 12060 (1.8.1). Newer versions of OMC exist but have not been tested. OpenModelicaCompiler revision- 11953 for Windows can be found at: https://build.openmodelica.org/omc/builds/windows/nightly-builds/older/OpenModelica-revision-12060.exe. Install it under C:\ since there may be some problems if you install it somewhere else.

1.	Create the OPENMODELICA Environment variable if it has not been created through the installation of the OpenModelicaCompiler. On Windows 7, Start->Control Panel->System and Security-> Advanced System Settings->Environment Variables. Define OPENMODELICAHOME to point to drive:\path\to\your\OpenModelica-X.Y.Z\ (e.g. C:\OpenModelica1.8.1\). Restart your computer.

2.	Install any Eclipse environment from http://www.eclipse.org/downloads/ (e.g. the Eclipse IDE for Java Developers package or the Eclipse Modeling Tools package)

 

3.	Import the “org.gt.mbse.mdsysmlmodelica” project into the Eclipse workspace by File->Import->Existing Projects into Workspace->Select the button “Select Archive File”, browse to the SysML-Modelica Transformation May-31-2012.zip file, click “open”, select the “org.gt.mbse.mdsysmlmodelica” project and click “Finish”. 

Replace with EGit download instructions!

	 

4.	It is necessary to add the MagicDraw jars to the buildpath in the correct order. First, delete all jars on the buildpath. Right mouse click on project ->Build Path-> Configure Build Path… Then select the menu tab “Libraries” and delete all jars except the JRE System Library bundle. 

 

5.	In the same “Build path” menu, first add patch.jar and then all the other MagicDraw jars to the build path. The patch.jar must be added first, this is critical. All MagicDraw jars can be found in the MagicDraw installation directory (e.g. C:\Program Files\MagicDraw UML) under \lib. Don’t forget to also add the jars under \lib\webservice and under \lib\graphics

 

6.	In the Eclipse environment, go to the Run->Run Configurations… menu. Select the “Java Application” tab and then the “New Launch Configuration” button at the top left with the icon displaying a blank sheet and a plus sign in the corner. Give a unique name to the launch configuration like “RunMagicDraw” at the top. Select as “Main Class” the Java class RunMagicDraw in the edu.gatech.mbse.mdsysmlmodelica.magicdraw package. Next, go to the “Arguments” tab and add in the “VM Arguments” field the following arguments: 

-Xmx1000M -XX:PermSize=40M -XX:MaxPermSize=300M -Duser.language\=en -DLOCALCONFIG\=false

Otherwise, MagicDraw won’t be able to start with enough memory and will crash.
 	   		  
7.	Run the launch configuration. MagicDraw will start as if a user had started it manually. Disable plugin "Caliber Integration" if available through Options->Environment->Plugins. Otherwise, there will be a problem with the Corba connection that OMC needs to set up.
 
8.	Next it is necessary to import the SysML4Modelica profile as a module within a new and empty MagicDraw SysML project. The SysML4Modelica profile is located in the org.gt.mbse.mdsysmlmodelica project under \MagicDraw Projects. It can be copied into a more appropriate folder like the \Documents\MagicDraw Projects folder.


9.	Create a new SysML project in MagicDraw (if possible with MagicDraw 17.0) with File->New Project-> Create SysML project. Click on the Options menu. Select “use Module”. Choose the SysML4Modelica profile. Click Next. In the field “Module Packages”, the SysML4Modelica package should be displayed. If yes, make sure that it is marked and click on “Finish”. This new empty SysML project with the SysML4Modelica profile as module should be saved. It can then be reused on future occasions as a MagicDraw project that is ready to directly import a Modelica model.
 	 	 

10.	You are now ready to import a Modelica model into the MagicDraw SysML project. Go on Data (right click)->Modelica to SysML->Import Modelica. Select the Modelica .mo file. 

 	 	 


11.	After having imported a Modelica model into SysML, or once a SysML4Modelica model is available in MagicDraw, it can be exported into Modelica. Select “Data” or a Modelica package that should be exported and right click and select SysML to Modelica->Generate Modelica. The generated Modelica model will be located in the Eclipse workspace in the org.gt.mbse.mdsysmlmodelica project and be named “generated_Modelica.mo”
 


