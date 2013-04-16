Notes from Axel Reichwein, May 30, 2012

disable plugin "Caliber Integration" since it comes with its own ORB implementation in vbjorb.jar. (Options->Emvironment->Plugins)

run RunMagicDraw with following JVM arguments: -Xmx1000M -XX:PermSize=40M -XX:MaxPermSize=300M -Duser.language\=en -DLOCALCONFIG\=false 

Modelica files must be UTF-8 encoded!! 
Errors in loading Modelica files can be detected through OMC.getErrorString()

TODO list
TODO: implement the ModelicaDer and ModelicaConstrainedBy stereotypes 
TODO: implement the ModelicaExternalObject type 
TODO: implement the ModelicaAnnotation stereotype


Improvements to the SysML-Modelica specification
Improvement to the spec: the ModelicaExtends stereotype needs to have a flowFlag property in order to also capture the input/output direction prefix in a short class definition.
Improvement to the spec: SysML4Modelica does not indicate where the name of the external function should be stored
Improvement to the spec: issue with connector ControlBus that is "empty" (expandable connectors)
Improvement to the spec: a <<modelicaPort>> can have a declaration equation
Improvement to the spec: DataType owning FunctionBehavior not possible in UML/SysML - but a type containing a function is possible in Modelica (see fullRobot example)

Note: nested functions need to appear before equation section. Otherwise, the functions are not loaded in Dymola

Note: Generated Modelica files can be opened seamlessly with Dymola but not with OpenModelica




