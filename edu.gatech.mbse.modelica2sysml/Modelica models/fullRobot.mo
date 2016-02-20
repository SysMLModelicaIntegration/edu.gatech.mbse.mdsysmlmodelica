package ModelicaServices
  "(target = \"Dymola\") Models and functions used in the Modelica Standard Library requiring a tool specific implementation"
  extends Modelica.Icons.Package;

package Animation "Models and functions for 3-dim. animation"
  extends Modelica.Icons.Package;

model Shape
  "Different visual shapes with variable size; all data have to be set as modifiers (see info layer)"
  extends
    Modelica.Utilities.Internal.PartialModelicaServices.Animation.PartialShape;

    import T = Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
    import SI = Modelica.SIunits;
    import Modelica.Mechanics.MultiBody.Frames;
    import Modelica.Mechanics.MultiBody.Types;

protected
  Real abs_n_x(final unit="1") annotation (HideResult=true);
  Real n_z_aux[3](each final unit="1") annotation (HideResult=true);
  Real e_x[3](each final unit="1", start={1,0,0})
    "Unit vector in lengthDirection, resolved in object frame" annotation (HideResult=true);
  Real e_y[3](each final unit="1", start={0,1,0})
    "Unit vector orthogonal to lengthDirection in the plane of lengthDirection and widthDirection, resolved in object frame"
     annotation (HideResult=true);
  output Real Form annotation (HideResult=false);
public
  output Real rxvisobj[3](each final unit="1")
    "x-axis unit vector of shape, resolved in world frame"
    annotation (HideResult=false);
  output Real ryvisobj[3](each final unit="1")
    "y-axis unit vector of shape, resolved in world frame"
    annotation (HideResult=false);
  output SI.Position rvisobj[3]
    "position vector from world frame to shape frame, resolved in world frame"
    annotation (HideResult=false);
protected
  output SI.Length size[3] "{length,width,height} of shape"
    annotation (HideResult=false);
  output Real Material annotation (HideResult=false);
  output Real Extra annotation (HideResult=false);
equation
  abs_n_x = Modelica.Math.Vectors.length(lengthDirection);
  e_x     = noEvent(if abs_n_x < 1.e-10 then {1,0,0} else lengthDirection/abs_n_x);
  n_z_aux = cross(e_x, widthDirection);
  e_y     = noEvent(cross(Modelica.Math.Vectors.normalize(
                   cross(e_x, if n_z_aux*n_z_aux > 1.0e-6 then widthDirection else
                             (if abs(e_x[1]) > 1.0e-6 then {0,1,0} else {1,0,0}))), e_x));

  /* Outputs to file. */
  Form = (987000 + PackShape(shapeType))*1E20;
  /*
  rxry = Frames.TransformationMatrices.to_exy(
    Frames.TransformationMatrices.absoluteRotation(R.T,
    Frames.TransformationMatrices.from_nxy(lengthDirection, widthDirection)));
  rxvisobj = rxry[:, 1];
  ryvisobj = rxry[:, 2];
*/
  rxvisobj = transpose(R.T)*e_x;
  ryvisobj = transpose(R.T)*e_y;
  rvisobj = r + T.resolve1(R.T, r_shape);
  size = {length,width,height};
  Material = PackMaterial(color[1]/255.0, color[2]/255.0, color[3]/255.0,
    specularCoefficient);
  Extra = extra;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<p>
The interface of this model is documented at
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape</a>.
</p>

<p>
This implementation is targeted for Dymola. Here, the following data is stored on the
result file (using Dymola specific functions \"PackShape\" and \"PackMaterial\" to pack data
on a Real number):
</p>

<pre>
  Real Form         // shapeType coded on Real
  Real rxvisobj[3]  // x-axis unit vector of shape, resolved in world frame
  Real ryvisobj[3]  // y-axis unit vector of shape, resolved in world frame
  Real rvisobj [3]  // Position vector from world frame to shape frame, resolved in world frame
  Real size    [3]  // {length,width,height} of shape
  Real Material     // color and specularCoefficient packed on Real
  Real Extra        // \"extra\" variable of shape
</pre>

<p>
It is then assumed that the program reading the result file recognizes that a 3-dim. visualizer
object is defined (via variable \"Form\" and the possible values for Forms) and then visualizes
the shape according to the follow-up data.
</p>

</html>
"));
end Shape;
end Animation;
annotation (__Dymola_Protection(hideFromBrowser=true),
preferredView="info",
version="1.1",
versionDate="2010-07-30",
versionBuild=0,
revisionId="$Id:: package.mo 4159 2010-09-10 19:33:05Z #$",
uses(Modelica(version="3.2")),
conversion(noneFromVersion="1.0"),
Documentation(info="<html>
<p>
This package contains a set of functions and models to be used in the
Modelica Standard Library that requires a tool specific implementation.
These are:
</p>

<ul>
<li> <a href=\"modelica://ModelicaServices.Animation.Shape\">ModelicaServices.Animation.Shape</a>
     provides a 3-dim. visualization of elementary
     mechanical objects. It is used in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.Animation.Surface\">ModelicaServices.Animation.Surface</a>
     provides a 3-dim. visualization of
     moveable parameterized surface. It is used in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface</a>
     via inheritance.</li>
</ul>

<p>
This implementation is targeted for Dymola.
</p>

<p>
<b>Licensed by DLR and Dassault Syst&egrave;mes AB under the Modelica License 2</b><br>
Copyright &copy; 2009-2010, DLR and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>"));
end ModelicaServices;

package Modelica "Modelica Standard Library (Version 3.2)"
extends Modelica.Icons.Package;

  package Blocks
  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

    package Continuous
    "Library of continuous control blocks with internal states"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.Package;

      block PI "Proportional-Integral controller"
        import Modelica.Blocks.Types.Init;
        parameter Real k(unit="1")=1 "Gain";
        parameter SIunits.Time T(start=1,min=Modelica.Constants.small)
        "Time Constant (T>0 required)";
        parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
        "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                                                                  annotation(Evaluate=true,
            Dialog(group="Initialization"));
        parameter Real x_start=0 "Initial or guess value of state"
          annotation (Dialog(group="Initialization"));
        parameter Real y_start=0 "Initial value of output"
          annotation(Dialog(enable=initType == Init.SteadyState or initType == Init.InitialOutput, group=
                "Initialization"));

        extends Interfaces.SISO;
        output Real x(start=x_start) "State of block";

      initial equation
        if initType == Init.SteadyState then
          der(x) = 0;
        elseif initType == Init.InitialState then
          x = x_start;
        elseif initType == Init.InitialOutput then
          y = y_start;
        end if;
      equation
        der(x) = u/T;
        y = k*(x + u);
        annotation (defaultComponentName="PI",
          Documentation(info="
<HTML>
<p>
This blocks defines the transfer function between the input u and
the output y (element-wise) as <i>PI</i> system:
</p>
<pre>
                 1
   y = k * (1 + ---) * u
                T*s
           T*s + 1
     = k * ------- * u
             T*s
</pre>
<p>
If you would like to be able to change easily between different
transfer functions (FirstOrder, SecondOrder, ... ) by changing
parameters, use the general model class <b>TransferFunction</b>
instead and model a PI SISO system with parameters<br>
b = {k*T, k}, a = {T, 0}.
</p>
<pre>
Example:

   parameter: k = 0.3,  T = 0.4

   results in:
               0.4 s + 1
      y = 0.3 ----------- * u
                 0.4 s
</pre>

<p>
It might be difficult to initialize the PI component in steady state
due to the integrator part.
This is discussed in the description of package
<a href=\"modelica://Modelica.Blocks.Continuous#info\">Continuous</a>.
</p>

</HTML>
"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,88},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
              Polygon(
                points={{90,-80},{68,-72},{68,-88},{90,-80}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-80},{-80,-20},{60,80}}, color={0,0,127}),
              Text(
                extent={{0,6},{60,-56}},
                lineColor={192,192,192},
                textString="PI"),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="T=%T")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
              Text(
                extent={{-68,24},{-24,-18}},
                lineColor={0,0,0},
                textString="k"),
              Text(
                extent={{-32,48},{60,0}},
                lineColor={0,0,0},
                textString="T s + 1"),
              Text(
                extent={{-30,-8},{52,-40}},
                lineColor={0,0,0},
                textString="T s"),
              Line(points={{-24,0},{54,0}}, color={0,0,0}),
              Line(points={{-100,0},{-60,0}}, color={0,0,255}),
              Line(points={{62,0},{100,0}}, color={0,0,255})}));
      end PI;
      annotation (
        Documentation(info="<html>
<p>
This package contains basic <b>continuous</b> input/output blocks
described by differential equations.
</p>

<p>
All blocks of this package can be initialized in different
ways controlled by parameter <b>initType</b>. The possible
values of initType are defined in
<a href=\"modelica://Modelica.Blocks.Types.Init\">Modelica.Blocks.Types.Init</a>:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Name</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>

  <tr><td valign=\"top\"><b>Init.NoInit</b></td>
      <td valign=\"top\">no initialization (start values are used as guess values with fixed=false)</td></tr>

  <tr><td valign=\"top\"><b>Init.SteadyState</b></td>
      <td valign=\"top\">steady state initialization (derivatives of states are zero)</td></tr>

  <tr><td valign=\"top\"><b>Init.InitialState</b></td>
      <td valign=\"top\">Initialization with initial states</td></tr>

  <tr><td valign=\"top\"><b>Init.InitialOutput</b></td>
      <td valign=\"top\">Initialization with initial outputs (and steady state of the states if possibles)</td></tr>
</table>

<p>
For backward compatibility reasons the default of all blocks is
<b>Init.NoInit</b>, with the exception of Integrator and LimIntegrator
where the default is <b>Init.InitialState</b> (this was the initialization
defined in version 2.2 of the Modelica standard library).
</p>

<p>
In many cases, the most useful initial condition is
<b>Init.SteadyState</b> because initial transients are then no longer
present. The drawback is that in combination with a non-linear
plant, non-linear algebraic equations occur that might be
difficult to solve if appropriate guess values for the
iteration variables are not provided (i.e., start values with fixed=false).
However, it is often already useful to just initialize
the linear blocks from the Continuous blocks library in SteadyState.
This is uncritical, because only linear algebraic equations occur.
If Init.NoInit is set, then the start values for the states are
interpreted as <b>guess</b> values and are propagated to the
states with fixed=<b>false</b>.
</p>

<p>
Note, initialization with Init.SteadyState is usually difficult
for a block that contains an integrator
(Integrator, LimIntegrator, PI, PID, LimPID).
This is due to the basic equation of an integrator:
</p>

<pre>
  <b>initial equation</b>
     <b>der</b>(y) = 0;   // Init.SteadyState
  <b>equation</b>
     <b>der</b>(y) = k*u;
</pre>

<p>
The steady state equation leads to the condition that the input to the
integrator is zero. If the input u is already (directly or indirectly) defined
by another initial condition, then the initialization problem is <b>singular</b>
(has none or infinitely many solutions). This situation occurs often
for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and
since speed is both a state and a derivative, it is always defined by
Init.InitialState or Init.SteadyState initializtion.
</p>

<p>
In such a case, <b>Init.NoInit</b> has to be selected for the integrator
and an additional initial equation has to be added to the system
to which the integrator is connected. E.g., useful initial conditions
for a 1-dim. rotational inertia controlled by a PI controller are that
<b>angle</b>, <b>speed</b>, and <b>acceleration</b> of the inertia are zero.
</p>

</html>
"));
    end Continuous;

    package Interfaces
    "Library of connectors and partial models for input/output blocks"
      import Modelica.SIunits;
        extends Modelica.Icons.InterfacesPackage;

    connector RealInput = input Real "'input Real' as connector"
      annotation (defaultComponentName="u",
      Icon(graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid)},
           coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
      Diagram(coordinateSystem(
            preserveAspectRatio=true, initialScale=0.2,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{0,50},{100,0},{0,-50},{0,50}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid), Text(
              extent={{-10,85},{-10,60}},
              lineColor={0,0,127},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));

    connector RealOutput = output Real "'output Real' as connector"
      annotation (defaultComponentName="y",
      Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,50},{0,0},{-100,-50},{-100,50}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{30,110},{30,60}},
              lineColor={0,0,127},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));

    connector BooleanInput = input Boolean "'input Boolean' as connector"
      annotation (defaultComponentName="u",
           Icon(graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid)},
                coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=true, initialScale=0.2)),    Diagram(coordinateSystem(
            preserveAspectRatio=true, initialScale=0.2,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{0,50},{100,0},{0,-50},{0,50}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{-10,85},{-10,60}},
              lineColor={255,0,255},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Boolean.
</p>
</html>"));

    connector BooleanOutput = output Boolean "'output Boolean' as connector"
                                      annotation (defaultComponentName="y",
      Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={255,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,50},{0,0},{-100,-50},{-100,50}},
              lineColor={255,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{30,110},{30,60}},
              lineColor={255,0,255},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Boolean.
</p>
</html>"));

        partial block BlockIcon "Basic graphical layout of input/output block"

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output
block (no declarations, no equations). Most blocks
of package Modelica.Blocks inherit directly or indirectly
from this block.
</p>
</html>"));

        end BlockIcon;

        partial block SO "Single Output continuous control block"
          extends BlockIcon;

          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (
            Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
Block has one continuous Real output signal.
</p>
</html>"));

        end SO;

        partial block SISO
      "Single Input Single Output continuous control block"
          extends BlockIcon;

          RealInput u "Connector of Real input signal"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (
          Documentation(info="<html>
<p>
Block has one continuous Real input and one continuous Real output signal.
</p>
</html>"));
        end SISO;

        partial block BooleanBlockIcon
      "Basic graphical layout of Boolean block"

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={255,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output,
Boolean block (no declarations, no equations).
</p>
</html>"));

        end BooleanBlockIcon;
        annotation (
          Documentation(info="<HTML>
<p>
This package contains interface definitions for
<b>continuous</b> input/output blocks with Real,
Integer and Boolean signals. Furthermore, it contains
partial models for continuous and discrete blocks.
</p>

</HTML>
",     revisions="<html>
<ul>
<li><i>Oct. 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Added several new interfaces. <a href=\"modelica://Modelica/Documentation/ChangeNotes1.5.html\">Detailed description</a> available.
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       RealInputSignal renamed to RealInput. RealOutputSignal renamed to
       output RealOutput. GraphBlock renamed to BlockIcon. SISOreal renamed to
       SISO. SOreal renamed to SO. I2SOreal renamed to M2SO.
       SignalGenerator renamed to SignalSource. Introduced the following
       new models: MIMO, MIMOs, SVcontrol, MVcontrol, DiscreteBlockIcon,
       DiscreteBlock, DiscreteSISO, DiscreteMIMO, DiscreteMIMOs,
       BooleanBlockIcon, BooleanSISO, BooleanSignalSource, MI2BooleanMOs.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>
"));
    end Interfaces;

    package Logical
    "Library of components with Boolean input and output signals"
        extends Modelica.Icons.Package;

      block TerminateSimulation
      "Terminate simulation if condition is fullfilled"

        Modelica.Blocks.Interfaces.BooleanOutput condition=false
        "Terminate simulation when condition becomes true"
          annotation (Dialog, Placement(transformation(extent={{200,-10},{220,10}},
                rotation=0)));
        parameter String terminationText = "... End condition reached"
        "Text that will be displayed when simulation is terminated";

      equation
        when condition then
           terminate(terminationText);
        end when;
        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-200,-20},{200,20}},
              grid={2,2},
              initialScale=0.2), graphics={
              Rectangle(
                extent={{-200,20},{200,-20}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-166,15},{194,-15}},
                lineColor={0,0,0},
                textString="%condition"),
              Rectangle(
                extent={{-194,14},{-168,-14}},
                lineColor={0,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-200,46},{200,22}},
                lineColor={0,0,255},
                textString="%name")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-200,-20},{200,20}},
              grid={2,2},
              initialScale=0.2), graphics),
          Documentation(info="<html>
<p>
In the parameter menu, a <b>time varying</b> expression can be defined
via variable <b>condition</b>, for example \"condition = x &lt; 0\",
where \"x\" is a variable that is declared in the model in which the
\"TerminateSimulation\" block is present.
If this expression becomes <b>true</b>,
the simulation is (successfully) terminated. A termination message
explaining the reason for the termination can be given via
parameter \"terminationText\".
</p>

</html>"));
      end TerminateSimulation;
      annotation(Documentation(info="<html>
<p>
This package provides blocks with Boolean input and output signals
to describe logical networks. A typical example for a logical
network built with package Logical is shown in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/Blocks/LogicalNetwork1.png\">

<p>
The actual value of Boolean input and/or output signals is displayed
in the respective block icon as \"circle\", where \"white\" color means
value <b>false</b> and \"green\" color means value <b>true</b>. These
values are visualized in a diagram animation.
</p>
</html>"));
    end Logical;

    package Math
    "Library of Real mathematical functions as input/output blocks"
      import Modelica.SIunits;
      import Modelica.Blocks.Interfaces;
      extends Modelica.Icons.Package;

          block Gain "Output the product of a gain value with the input signal"

            parameter Real k(start=1, unit="1")
        "Gain value multiplied with input signal";
    public
            Interfaces.RealInput u "Input signal connector"
              annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
            Interfaces.RealOutput y "Output signal connector"
              annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          equation
            y = k*u;
            annotation (
              Documentation(info="
<HTML>
<p>
This block computes output <i>y</i> as
<i>product</i> of gain <i>k</i> with the
input <i>u</i>:
</p>
<pre>
    y = k * u;
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Polygon(
                points={{-100,-100},{-100,100},{100,0},{-100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,-140},{150,-100}},
                lineColor={0,0,0},
                textString="k=%k"),
              Text(
                extent={{-150,140},{150,100}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={Polygon(
                points={{-100,-100},{-100,100},{100,0},{-100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-76,38},{0,-34}},
                textString="k",
                lineColor={0,0,255})}));
          end Gain;

          block Feedback
      "Output difference between commanded and feedback input"

            input Interfaces.RealInput u1 annotation (Placement(transformation(
                extent={{-100,-20},{-60,20}}, rotation=0)));
            input Interfaces.RealInput u2
              annotation (Placement(transformation(
              origin={0,-80},
              extent={{-20,-20},{20,20}},
              rotation=90)));
            output Interfaces.RealOutput y annotation (Placement(transformation(
                extent={{80,-10},{100,10}}, rotation=0)));

          equation
            y = u1 - u2;
            annotation (
              Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as <i>difference</i> of the
commanded input <b>u1</b> and the feedback
input <b>u2</b>:
</p>
<pre>
    <b>y</b> = <b>u1</b> - <b>u2</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   n = 2

  results in the following equations:

     y = u1 - u2
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Ellipse(
                extent={{-20,20},{20,-20}},
                lineColor={0,0,127},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid),
              Line(points={{-60,0},{-20,0}}, color={0,0,127}),
              Line(points={{20,0},{80,0}}, color={0,0,127}),
              Line(points={{0,-20},{0,-60}}, color={0,0,127}),
              Text(
                extent={{-14,0},{82,-94}},
                lineColor={0,0,0},
                textString="-"),
              Text(
                extent={{-150,94},{150,44}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Ellipse(
                extent={{-20,20},{20,-20}},
                pattern=LinePattern.Solid,
                lineThickness=0.25,
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}),
              Line(points={{-60,0},{-20,0}}, color={0,0,255}),
              Line(points={{20,0},{80,0}}, color={0,0,255}),
              Line(points={{0,-20},{0,-60}}, color={0,0,255}),
              Text(
                extent={{-12,10},{84,-84}},
                lineColor={0,0,0},
                textString="-")}));
          end Feedback;

          block Add3
      "Output the sum of the three inputs (this is an obsolet block. Use instead MultiSum)"
            extends Interfaces.BlockIcon;

            parameter Real k1=+1 "Gain of upper input";
            parameter Real k2=+1 "Gain of middle input";
            parameter Real k3=+1 "Gain of lower input";
            input Interfaces.RealInput u1 "Connector 1 of Real input signals"
              annotation (Placement(transformation(extent={{-140,60},{-100,100}},
                rotation=0)));
            input Interfaces.RealInput u2 "Connector 2 of Real input signals"
              annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
            input Interfaces.RealInput u3 "Connector 3 of Real input signals"
              annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
                rotation=0)));
            output Interfaces.RealOutput y "Connector of Real output signals"
              annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          equation
            y = k1*u1 + k2*u2 + k3*u3;
            annotation (
              Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as <i>sum</i> of the
three input signals <b>u1</b>, <b>u2</b> and <b>u3</b>:
</p>
<pre>
    <b>y</b> = k1*<b>u1</b> + k2*<b>u2</b> + k3*<b>u3</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3, k3=1;

  results in the following equations:

     y = 2 * u1 - 3 * u2 + u3;
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Text(
                extent={{-100,50},{5,90}},
                lineColor={0,0,0},
                textString="%k1"),
              Text(
                extent={{-100,-20},{5,20}},
                lineColor={0,0,0},
                textString="%k2"),
              Text(
                extent={{-100,-50},{5,-90}},
                lineColor={0,0,0},
                textString="%k3"),
              Text(
                extent={{2,36},{100,-44}},
                lineColor={0,0,0},
                textString="+")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-100,50},{5,90}},
                lineColor={0,0,0},
                textString="%k1"),
              Text(
                extent={{-100,-20},{5,20}},
                lineColor={0,0,0},
                textString="%k2"),
              Text(
                extent={{-100,-50},{5,-90}},
                lineColor={0,0,0},
                textString="%k3"),
              Text(
                extent={{2,36},{100,-44}},
                lineColor={0,0,0},
                textString="+"),
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-100,50},{5,90}},
                lineColor={0,0,0},
                textString="k1"),
              Text(
                extent={{-100,-20},{5,20}},
                lineColor={0,0,0},
                textString="k2"),
              Text(
                extent={{-100,-50},{5,-90}},
                lineColor={0,0,0},
                textString="k3"),
              Text(
                extent={{2,36},{100,-44}},
                lineColor={0,0,0},
                textString="+")}));
          end Add3;
      annotation (
        Documentation(info="
<HTML>
<p>
This package contains basic <b>mathematical operations</b>,
such as summation and multiplication, and basic <b>mathematical
functions</b>, such as <b>sqrt</b> and <b>sin</b>, as
input/output blocks. All blocks of this library can be either
connected with continuous blocks or with sampled-data blocks.
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New blocks added: RealToInteger, IntegerToReal, Max, Min, Edge, BooleanChange, IntegerChange.</li>
<li><i>August 7, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized (partly based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist).
</li>
</ul>
</html>"));
    end Math;

    package Routing "Library of blocks to combine and extract signals"
      extends Modelica.Icons.Package;

      model RealPassThrough "Pass a Real signal through without modification"

        extends Modelica.Blocks.Interfaces.BlockIcon;

        Modelica.Blocks.Interfaces.RealInput u "Input signal"
          annotation (HideResult=true, Placement(transformation(extent={{-140,-20},{-100,
                  20}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y "Output signal"
          annotation (HideResult=true, Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
      equation
        y = u;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Line(points={{-100,0},{100,0}},
                  color={0,0,127})}),
                          Documentation(info="<html>
<p>
Passes a Real signal through without modification.  Enables signals to be read out of one bus, have their name changed and be sent back to a bus.
</p>
</html>"));
      end RealPassThrough;

      model BooleanPassThrough
      "Pass a Boolean signal through without modification"
        extends Modelica.Blocks.Interfaces.BooleanBlockIcon;

        Modelica.Blocks.Interfaces.BooleanInput u "Input signal"
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
        Modelica.Blocks.Interfaces.BooleanOutput y "Output signal"
          annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
      equation
        y = u;
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{
                  -100,-100},{100,100}}),
                            graphics),
                             Documentation(info="<html>
<p>Passes a Boolean signal through without modification.  Enables signals to be read out of one bus, have their name changed and be sent back to a bus.</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={Line(points={{-100,0},{100,0}}, color={255,0,
                    255})}));
      end BooleanPassThrough;
      annotation (Documentation(info="<html>
<p>
This package contains blocks to combine and extract signals.
</p>
</html>"));
    end Routing;

    package Sources
    "Library of signal source blocks generating Real and Boolean signals"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.SourcesPackage;

          block Constant "Generate constant signal of type Real"
            parameter Real k(start=1) "Constant output value";
            extends Interfaces.SO;

          equation
            y = k;
            annotation (defaultComponentName="const",
              Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,0},{80,0}}, color={0,0,0}),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="k=%k")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Polygon(
                points={{-80,90},{-86,68},{-74,68},{-80,90}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
              Line(
                points={{-80,0},{80,0}},
                color={0,0,255},
                thickness=0.5),
              Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
              Polygon(
                points={{90,-70},{68,-64},{68,-76},{90,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-83,92},{-30,74}},
                lineColor={0,0,0},
                textString="y"),
              Text(
                extent={{70,-80},{94,-100}},
                lineColor={0,0,0},
                textString="time"),
              Text(
                extent={{-101,8},{-81,-12}},
                lineColor={0,0,0},
                textString="k")}),
          Documentation(info="<html>
<p>
The Real output y is a constant signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Constant.png\">
</p>
</html>"));
          end Constant;

      block KinematicPTP2
      "Move as fast as possible from start to end position within given kinematic constraints with output signals q, qd=der(q), qdd=der(qd)"
        import SI = Modelica.SIunits;
        parameter Real q_begin[:] = {0} "Start position";
        parameter Real q_end[:] "End position";
        parameter Real qd_max[:](each final min=Modelica.Constants.small)
        "Maximum velocities der(q)";
        parameter Real qdd_max[:](each final min=Modelica.Constants.small)
        "Maximum accelerations der(qd)";
        parameter Modelica.SIunits.Time startTime=0
        "Time instant at which movement starts";

        extends Modelica.Blocks.Interfaces.BlockIcon;
        final parameter Integer nout=max([size(q_begin, 1); size(q_end, 1); size(
            qd_max, 1); size(qdd_max, 1)])
        "Number of output signals (= dimension of q, qd, qdd, moving)";
        output Modelica.SIunits.Time endTime
        "Time instant at which movement stops";

        Modelica.Blocks.Interfaces.RealOutput q[nout]
        "Reference position of path planning"
          annotation (Placement(transformation(extent={{100,70},{120,90}}, rotation=
                 0)));
        Modelica.Blocks.Interfaces.RealOutput qd[nout]
        "Reference speed of path planning"
          annotation (Placement(transformation(extent={{100,20},{120,40}}, rotation=
                 0)));
        Modelica.Blocks.Interfaces.RealOutput qdd[nout]
        "Reference acceleration of path planning"
          annotation (Placement(transformation(extent={{100,-40},{120,-20}},
                rotation=0)));
        Modelica.Blocks.Interfaces.BooleanOutput moving[nout]
        "= true, if end position not yet reached; = false, if end position reached or axis is completely at rest"
          annotation (Placement(transformation(extent={{100,-90},{120,-70}},
                rotation=0)));

    protected
        parameter Real p_q_begin[nout]=(if size(q_begin, 1) == 1 then ones(nout)*
            q_begin[1] else q_begin);
        parameter Real p_q_end[nout]=(if size(q_end, 1) == 1 then ones(nout)*
            q_end[1] else q_end);
        parameter Real p_qd_max[nout]=(if size(qd_max, 1) == 1 then ones(nout)*
            qd_max[1] else qd_max);
        parameter Real p_qdd_max[nout]=(if size(qdd_max, 1) == 1 then ones(nout)*
            qdd_max[1] else qdd_max);
        parameter Real p_deltaq[nout]=p_q_end - p_q_begin;
        constant Real eps=10*Modelica.Constants.eps;
        Boolean motion_ref;
        Real sd_max_inv;
        Real sdd_max_inv;
        Real sd_max;
        Real sdd_max;
        Real sdd;
        Real aux1[nout];
        Real aux2[nout];
        SI.Time Ta1;
        SI.Time Ta2;
        SI.Time Tv;
        SI.Time Te;
        Boolean noWphase;
        SI.Time Ta1s;
        SI.Time Ta2s;
        SI.Time Tvs;
        SI.Time Tes;
        Real sd_max2;
        Real s1;
        Real s2;
        Real s3;
        Real s;
        Real sd;
        Real r_s;
        Real r_sd;
        Real r_sdd;

        function position
           input Real q_qd_qdd[3]
          "Required values for position, speed, acceleration";
           input Real dummy
          "Just to have one input signal that should be differentiated to avoid possible problems in the Modelica tool (is not used)";
           output Real q;
        algorithm
          q :=q_qd_qdd[1];
          annotation (derivative(noDerivative=q_qd_qdd) = position_der,
              __Dymola_InlineAfterIndexReduction=true);
        end position;

        function position_der
           input Real q_qd_qdd[3]
          "Required values for position, speed, acceleration";
           input Real dummy
          "Just to have one input signal that should be differentiated to avoid possible problems in the Modelica tool (is not used)";
           input Real dummy_der;
           output Real qd;
        algorithm
          qd :=q_qd_qdd[2];
          annotation (derivative(noDerivative=q_qd_qdd) = position_der2,
              __Dymola_InlineAfterIndexReduction=true);
        end position_der;

        function position_der2
           input Real q_qd_qdd[3]
          "Required values for position, speed, acceleration";
           input Real dummy
          "Just to have one input signal that should be differentiated to avoid possible problems in the Modelica tool (is not used)";
           input Real dummy_der;
           input Real dummy_der2;
           output Real qdd;
        algorithm
          qdd :=q_qd_qdd[3];
        end position_der2;
      equation
        for i in 1:nout loop
          aux1[i] = p_deltaq[i]/p_qd_max[i];
          aux2[i] = p_deltaq[i]/p_qdd_max[i];
        end for;

        sd_max_inv = max(abs(aux1));
        sdd_max_inv = max(abs(aux2));

        if sd_max_inv <= eps or sdd_max_inv <= eps then
          sd_max = 0;
          sdd_max = 0;
          Ta1 = 0;
          Ta2 = 0;
          noWphase = false;
          Tv = 0;
          Te = 0;
          Ta1s = 0;
          Ta2s = 0;
          Tvs = 0;
          Tes = 0;
          sd_max2 = 0;
          s1 = 0;
          s2 = 0;
          s3 = 0;
          r_sdd = 0;
          r_sd = 0;
          r_s = 0;
        else
          sd_max = 1/max(abs(aux1));
          sdd_max = 1/max(abs(aux2));
          Ta1 = sqrt(1/sdd_max);
          Ta2 = sd_max/sdd_max;
          noWphase = Ta2 >= Ta1;
          Tv = if noWphase then Ta1 else 1/sd_max;
          Te = if noWphase then Ta1 + Ta1 else Tv + Ta2;
          Ta1s = Ta1 + startTime;
          Ta2s = Ta2 + startTime;
          Tvs = Tv + startTime;
          Tes = Te + startTime;
          sd_max2 = sdd_max*Ta1;
          s1 = sdd_max*(if noWphase then Ta1*Ta1 else Ta2*Ta2)/2;
          s2 = s1 + (if noWphase then sd_max2*(Te - Ta1) - (sdd_max/2)*(Te - Ta1)
            ^2 else sd_max*(Tv - Ta2));
          s3 = s2 + sd_max*(Te - Tv) - (sdd_max/2)*(Te - Tv)*(Te - Tv);

          if time < startTime then
            r_sdd = 0;
            r_sd = 0;
            r_s = 0;
          elseif noWphase then
            if time < Ta1s then
              r_sdd = sdd_max;
              r_sd = sdd_max*(time - startTime);
              r_s = (sdd_max/2)*(time - startTime)*(time - startTime);
            elseif time < Tes then
              r_sdd = -sdd_max;
              r_sd = sd_max2 - sdd_max*(time - Ta1s);
              r_s = s1 + sd_max2*(time - Ta1s) - (sdd_max/2)*(time - Ta1s)*(time
                 - Ta1s);
            else
              r_sdd = 0;
              r_sd = 0;
              r_s = s2;
            end if;
          elseif time < Ta2s then
            r_sdd = sdd_max;
            r_sd = sdd_max*(time - startTime);
            r_s = (sdd_max/2)*(time - startTime)*(time - startTime);
          elseif time < Tvs then
            r_sdd = 0;
            r_sd = sd_max;
            r_s = s1 + sd_max*(time - Ta2s);
          elseif time < Tes then
            r_sdd = -sdd_max;
            r_sd = sd_max - sdd_max*(time - Tvs);
            r_s = s2 + sd_max*(time - Tvs) - (sdd_max/2)*(time - Tvs)*(time - Tvs);
          else
            r_sdd = 0;
            r_sd = 0;
            r_s = s3;
          end if;

        end if;

        // acceleration
        qdd = p_deltaq*sdd;
        qd = p_deltaq*sd;
        q = p_q_begin + p_deltaq*s;
        endTime = Tes;

        s = position({r_s, r_sd, r_sdd}, time);
        sd = der(s);
        sdd = der(sd);

        // report when axis is moving
        motion_ref = time <= endTime;
        for i in 1:nout loop
          moving[i] = if abs(q_begin[i] - q_end[i]) > eps then motion_ref else false;
        end for;

        annotation (defaultComponentName="kinematicPTP",
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,78},{-80,-82}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,88},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{17,0}}, color={192,192,192}),
              Line(
                points={{-80,0},{-70,0},{-70,70},{-50,70},{-50,0},{-15,0},{-15,-70},
                    {5,-70},{5,0},{18,0}},
                color={0,0,0},
                thickness=0.25),
              Text(
                extent={{34,96},{94,66}},
                lineColor={0,0,0},
                textString="q"),
              Text(
                extent={{40,44},{96,14}},
                lineColor={0,0,0},
                textString="qd"),
              Text(
                extent={{32,-18},{99,-44}},
                lineColor={0,0,0},
                textString="qdd"),
              Text(
                extent={{-32,-74},{97,-96}},
                lineColor={0,0,0},
                textString="moving")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,78},{-80,-70}}, color={95,95,95}),
              Polygon(
                points={{-80,94},{-86,74},{-74,74},{-80,94},{-80,94}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{82,0}}, color={95,95,95}),
              Polygon(
                points={{90,0},{68,6},{68,-6},{90,0}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-80,0},{-70,0},{-70,70},{-30,70},{-30,0},{20,0},{20,-70},{
                    60,-70},{60,0},{68,0}},
                color={0,0,255},
                thickness=0.5),
              Text(
                extent={{-72,96},{-15,81}},
                lineColor={0,0,0},
                textString="acceleration"),
              Text(
                extent={{69,18},{91,6}},
                lineColor={0,0,0},
                textString="time")}),
          Documentation(info="<html>
<p>
The goal is to move as <b>fast</b> as possible from start position <b>q_begin</b>
to end position <b>q_end</b>
under given <b>kinematical constraints</b>. The positions can be translational or
rotational definitions (i.e., q_begin/q_end is given). In robotics such a movement is called <b>PTP</b> (Point-To-Point).
This source block generates the <b>position</b> q(t), the
<b>speed</b> qd(t) = der(q), and the <b>acceleration</b> qdd = der(qd)
as output. The signals are constructed in such a way that it is not possible
to move faster, given the <b>maximally</b> allowed <b>velocity</b> qd_max and
the <b>maximally</b> allowed <b>acceleration</b> qdd_max:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/KinematicPTP2.png\">
</p>

<p>
If vectors q_begin/q_end have more than 1 element,
the output vectors are constructed such that all signals
are in the same periods in the acceleration, constant velocity
and deceleration phase. This means that only one of the signals
is at its limits whereas the others are sychnronized in such a way
that the end point is reached at the same time instant.
</p>

<p>
This element is useful to generate a reference signal for a controller
which controls, e.g., a drive train, or to drive
a flange according to a given acceleration.
</p>

</html>
",       revisions="<html>
<ul>
<li><i>March 24, 2007</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Non-standard Modelica function \"constrain(..)\" replaced by standard
       Modelica implementation (via internal function position()).<br>
       New output signal \"moving\" added.</li>
<li><i>June 27, 2001</i>
       by Bernhard Bachmann.<br>
       Bug fixed that element is also correct if startTime is not zero.</li>
<li><i>Nov. 3, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Vectorized and moved from Rotational to Blocks.Sources.</li>
<li><i>June 29, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       realized.</li>
</ul>
</html>"));
      end KinematicPTP2;
          annotation (
            Documentation(info="<HTML>
<p>
This package contains <b>source</b> components, i.e., blocks which
have only output signals. These blocks are used as signal generators
for Real, Integer and Boolean signals.
</p>

<p>
All Real source signals (with the exception of the Constant source)
have at least the following two parameters:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>offset</b></td>
      <td valign=\"top\">Value which is added to the signal</td>
  </tr>
  <tr><td valign=\"top\"><b>startTime</b></td>
      <td valign=\"top\">Start time of signal. For time &lt; startTime,
                the output y is set to offset.</td>
  </tr>
</table>

<p>
The <b>offset</b> parameter is especially useful in order to shift
the corresponding source, such that at initial time the system
is stationary. To determine the corresponding value of offset,
usually requires a trimming calculation.
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Integer sources added. Step, TimeTable and BooleanStep slightly changed.</li>
<li><i>Nov. 8, 1999</i>
       by <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       New sources: Exponentials, TimeTable. Trapezoid slightly enhanced
       (nperiod=-1 is an infinite number of periods).</li>
<li><i>Oct. 31, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       All sources vectorized. New sources: ExpSine, Trapezoid,
       BooleanConstant, BooleanStep, BooleanPulse, SampleTrigger.
       Improved documentation, especially detailed description of
       signals in diagram layer.</li>
<li><i>June 29, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
    end Sources;

    package Types
    "Library of constants and types with choices, especially to build menus"
      extends Modelica.Icons.Package;

      type Init = enumeration(
        NoInit
          "No initialization (start values are used as guess values with fixed=false)",

        SteadyState
          "Steady state initialization (derivatives of states are zero)",
        InitialState "Initialization with initial states",
        InitialOutput
          "Initialization with initial outputs (and steady state of the states if possibles)")
      "Enumeration defining initialization of a block"
          annotation (Evaluate=true);
      annotation ( Documentation(info="<HTML>
<p>
In this package <b>types</b> and <b>constants</b> are defined that are used
in library Modelica.Blocks. The types have additional annotation choices
definitions that define the menus to be built up in the graphical
user interface when the type is used as parameter in a declaration.
</p>
</HTML>"));
    end Types;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(extent={{-32,-6},{16,-35}}, lineColor={0,0,0}),
        Rectangle(extent={{-32,-56},{16,-85}}, lineColor={0,0,0}),
        Line(points={{16,-20},{49,-20},{49,-71},{16,-71}}, color={0,0,0}),
        Line(points={{-32,-72},{-64,-72},{-64,-21},{-32,-21}}, color={0,0,0}),
        Polygon(
          points={{16,-71},{29,-67},{29,-74},{16,-71}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-21},{-46,-17},{-46,-25},{-32,-21}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                            Documentation(info="<html>
<p>
This library contains input/output blocks to build up block diagrams.
</p>

<dl>
<dt><b>Main Author:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",   revisions="<html>
<ul>
<li><i>June 23, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Introduced new block connectors and adapated all blocks to the new connectors.
       Included subpackages Continuous, Discrete, Logical, Nonlinear from
       package ModelicaAdditions.Blocks.
       Included subpackage ModelicaAdditions.Table in Modelica.Blocks.Sources
       and in the new package Modelica.Blocks.Tables.
       Added new blocks to Blocks.Sources and Blocks.Logical.
       </li>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New subpackage Examples, additional components.
       </li>
<li><i>June 20, 2000</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
       Michael Tiller:<br>
       Introduced a replaceable signal type into
       Blocks.Interfaces.RealInput/RealOutput:
<pre>
   replaceable type SignalType = Real
</pre>
       in order that the type of the signal of an input/output block
       can be changed to a physical type, for example:
<pre>
   Sine sin1(outPort(redeclare type SignalType=Modelica.SIunits.Torque))
</pre>
      </li>
<li><i>Sept. 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Renamed to Blocks. New subpackages Math, Nonlinear.
       Additional components in subpackages Interfaces, Continuous
       and Sources. </li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
  end Blocks;

  package Electrical
  "Library of electrical models (analog, digital, machines, multi-phase)"
  extends Modelica.Icons.Package;

    package Analog "Library for analog electrical models"
    import SI = Modelica.SIunits;
    extends Modelica.Icons.Package;

      package Basic "Basic electrical components"
        extends Modelica.Icons.Package;

        model Ground "Ground node"

          Interfaces.Pin p annotation (Placement(transformation(
                origin={0,100},
                extent={{10,-10},{-10,10}},
                rotation=270)));
        equation
          p.v = 0;
          annotation (
            Documentation(info="<html>
<p>Ground of an electrical circuit. The potential at the ground node is zero. Every electrical circuit has to contain at least one ground object.</p>
</html>",revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Line(points={{-60,50},{60,50}}, color={0,0,255}),
                Line(points={{-40,30},{40,30}}, color={0,0,255}),
                Line(points={{-20,10},{20,10}}, color={0,0,255}),
                Line(points={{0,90},{0,50}}, color={0,0,255}),
                Text(
                  extent={{-144,-19},{156,-59}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Line(
                  points={{-60,50},{60,50}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(
                  points={{-40,30},{40,30}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(
                  points={{-20,10},{20,10}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(
                  points={{0,96},{0,50}},
                  thickness=0.5,
                  color={0,0,255}),
                Text(
                  extent={{-24,-38},{22,-6}},
                  textString="p.v=0",
                  lineColor={0,0,255})}));
        end Ground;

      model Resistor "Ideal linear electrical resistor"
        parameter Modelica.SIunits.Resistance R(start=1)
          "Resistance at temperature T_ref";
        parameter Modelica.SIunits.Temperature T_ref=300.15
          "Reference temperature";
        parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
          "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";

        extends Modelica.Electrical.Analog.Interfaces.OnePort;
        extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(                    T = T_ref);
        Modelica.SIunits.Resistance R_actual
          "Actual resistance = R*(1 + alpha*(T_heatPort - T_ref))";

      equation
        assert((1 + alpha*(T_heatPort - T_ref)) >= Modelica.Constants.eps, "Temperature outside scope of model!");
        R_actual = R*(1 + alpha*(T_heatPort - T_ref));
        v = R_actual*i;
        LossPower = v*i;
        annotation (
          Documentation(info="<html>
<p>The linear resistor connects the branch voltage <i>v</i> with the branch current <i>i</i> by <i>i*R = v</i>. The Resistance <i>R</i> is allowed to be positive, zero, or negative.</p>
</html>",
       revisions="<html>
<ul>
<li><i> August 07, 2009   </i>
       by Anton Haumer<br> temperature dependency of resistance added<br>
       </li>
<li><i> March 11, 2009   </i>
       by Christoph Clauss<br> conditional heat port added<br>
       </li>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
                Rectangle(
                  extent={{-70,30},{70,-30}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{-90,0},{-70,0}}, color={0,0,255}),
                Line(points={{70,0},{90,0}}, color={0,0,255}),
                Text(
                  extent={{-144,-40},{142,-72}},
                  lineColor={0,0,0},
                  textString="R=%R"),
                Line(
                  visible=useHeatPort,
                  points={{0,-100},{0,-30}},
                  color={127,0,0},
                  smooth=Smooth.None,
                  pattern=LinePattern.Dot),
                Text(
                  extent={{-152,87},{148,47}},
                  textString="%name",
                  lineColor={0,0,255})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
                Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
                Line(points={{-96,0},{-70,0}}, color={0,0,255}),
                Line(points={{70,0},{96,0}}, color={0,0,255})}));
      end Resistor;

        model Capacitor "Ideal linear electrical capacitor"
          extends Interfaces.OnePort;
          parameter SI.Capacitance C(start=1) "Capacitance";

        equation
          i = C*der(v);
          annotation (
            Documentation(info="<html>
<p>The linear capacitor connects the branch voltage <i>v</i> with the branch current <i>i</i> by <i>i = C * dv/dt</i>. The Capacitance <i>C</i> is allowed to be positive, zero, or negative.</p>
</html>",revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Line(
                  points={{-14,28},{-14,-28}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(
                  points={{14,28},{14,-28}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(points={{-90,0},{-14,0}}, color={0,0,255}),
                Line(points={{14,0},{90,0}}, color={0,0,255}),
                Text(
                  extent={{-136,-60},{136,-92}},
                  lineColor={0,0,0},
                  textString="C=%C"),
                Text(
                  extent={{-150,85},{150,45}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Line(
                  points={{-20,40},{-20,-40}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(
                  points={{20,40},{20,-40}},
                  thickness=0.5,
                  color={0,0,255}),
                Line(points={{-96,0},{-20,0}}, color={0,0,255}),
                Line(points={{20,0},{96,0}}, color={0,0,255})}));
        end Capacitor;

        model Inductor "Ideal linear electrical inductor"
          extends Interfaces.OnePort;
          parameter SI.Inductance L(start=1) "Inductance";
        equation
          L*der(i) = v;
          annotation (
            Documentation(info="<html>
<p>The linear inductor connects the branch voltage <i>v</i> with the branch current <i>i</i> by <i>v = L * di/dt</i>. The Inductance <i>L</i> is allowed to be positive, zero, or negative.</p>
</html>",revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Ellipse(extent={{-60,-15},{-30,15}}, lineColor={0,0,255}),
                Ellipse(extent={{-30,-15},{0,15}}, lineColor={0,0,255}),
                Ellipse(extent={{0,-15},{30,15}}, lineColor={0,0,255}),
                Ellipse(extent={{30,-15},{60,15}}, lineColor={0,0,255}),
                Rectangle(
                  extent={{-60,-30},{60,0}},
                  lineColor={255,255,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{60,0},{90,0}}, color={0,0,255}),
                Line(points={{-90,0},{-60,0}}, color={0,0,255}),
                Text(
                  extent={{-138,-60},{144,-94}},
                  lineColor={0,0,0},
                  textString="L=%L"),
                Text(
                  extent={{-152,79},{148,39}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Ellipse(extent={{-60,-15},{-30,15}}, lineColor={0,0,255}),
                Ellipse(extent={{-30,-15},{0,15}}, lineColor={0,0,255}),
                Ellipse(extent={{0,-15},{30,15}}, lineColor={0,0,255}),
                Ellipse(extent={{30,-15},{60,15}}, lineColor={0,0,255}),
                Rectangle(
                  extent={{-60,-30},{60,0}},
                  lineColor={255,255,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{60,0},{96,0}}, color={0,0,255}),
                Line(points={{-96,0},{-60,0}}, color={0,0,255})}));
        end Inductor;

        model EMF "Electromotoric force (electric/mechanic transformer)"
          parameter Boolean useSupport=false
          "= true, if support flange enabled, otherwise implicitly grounded"
              annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
          parameter SI.ElectricalTorqueConstant k(start=1)
          "Transformation coefficient";
          SI.Voltage v "Voltage drop between the two pins";
          SI.Current i "Current flowing from positive to negative pin";
          SI.Angle phi
          "Angle of shaft flange with respect to support (= flange.phi - support.phi)";
          SI.AngularVelocity w "Angular velocity of flange relative to support";
          Interfaces.PositivePin p annotation (Placement(transformation(
                origin={0,100},
                extent={{-10,-10},{10,10}},
                rotation=90)));
          Interfaces.NegativePin n annotation (Placement(transformation(
                origin={0,-100},
                extent={{-10,-10},{10,10}},
                rotation=90)));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange
            annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
          Mechanics.Rotational.Interfaces.Support support if useSupport
          "Support/housing of emf shaft"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
      protected
          Mechanics.Rotational.Components.Fixed fixed if not useSupport
            annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
          Mechanics.Rotational.Interfaces.InternalSupport internalSupport(tau=-flange.tau)
            annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;

          phi = flange.phi - internalSupport.phi;
          w = der(phi);
          k*w = v;
          flange.tau = -k*i;
          connect(internalSupport.flange, support) annotation (Line(
              points={{-80,0},{-100,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(internalSupport.flange,fixed. flange) annotation (Line(
              points={{-80,0},{-80,-10}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (
            defaultComponentName="emf",
            Icon(
                coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-85,10},{-36,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Line(points={{0,90},{0,40}}, color={0,0,255}),
                Rectangle(
                  extent={{35,10},{100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Ellipse(
                  extent={{-40,40},{40,-40}},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  lineColor={0,0,255}),
                Line(points={{0,-90},{0,-40}}, color={0,0,255}),
                Text(
                  extent={{0,-50},{199,-90}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{0,80},{189,46}},
                  lineColor={160,160,164},
                  textString="k=%k"),
                Line(
                  visible=not useSupport,
                  points={{-100,-30},{-40,-30}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-100,-50},{-80,-30}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-80,-50},{-60,-30}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-60,-50},{-40,-30}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-70,-30},{-70,-10}},
                  color={0,0,0})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Polygon(
                  points={{-17,95},{-20,85},{-23,95},{-17,95}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Line(points={{-20,110},{-20,85}}, color={160,160,164}),
                Text(
                  extent={{-40,110},{-30,90}},
                  lineColor={160,160,164},
                  textString="i"),
                Line(points={{9,75},{19,75}}, color={192,192,192}),
                Line(points={{-20,-110},{-20,-85}}, color={160,160,164}),
                Polygon(
                  points={{-17,-100},{-20,-110},{-23,-100},{-17,-100}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-40,-110},{-30,-90}},
                  lineColor={160,160,164},
                  textString="i"),
                Line(points={{8,-79},{18,-79}}, color={192,192,192}),
                Line(points={{14,80},{14,70}}, color={192,192,192})}),
            Documentation(info="<html>
<p>EMF transforms electrical energy into rotational mechanical energy. It is used as basic building block of an electrical motor. The mechanical connector flange can be connected to elements of the Modelica.Mechanics.Rotational library. flange.tau is the cut-torque, flange.phi is the angle at the rotational connection.</p>
</html>",revisions="<html>
<ul>
<li><i> 1998   </i>
       by Martin Otter<br> initially implemented<br>
       </li>
</ul>
</html>"));
        end EMF;
        annotation (
      Documentation(info="<html>
<p>This package contains very basic analog electrical components such as resistor, conductor, condensator, inductor, and the ground (which is needed in each electrical circuit description. Furthermore, controled sources, coupling components, and some improved (but newertheless basic) are in this package.</p>
</html>",revisions="<html>
<dl>
<dt>
<b>Main Authors:</b>
<dd>
Christoph Clau&szlig;
    &lt;<a href=\"mailto:Christoph.Clauss@eas.iis.fraunhofer.de\">Christoph.Clauss@eas.iis.fraunhofer.de</a>&gt;<br>
    Andr&eacute; Schneider
    &lt;<a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>&gt;<br>
    Fraunhofer Institute for Integrated Circuits<br>
    Design Automation Department<br>
    Zeunerstra&szlig;e 38<br>
    D-01069 Dresden<br>
<p>
</dl>
</html>"));
      end Basic;

      package Ideal
      "Ideal electrical elements such as switches, diode, transformer, operational amplifier"
        extends Modelica.Icons.Package;

        model IdealOpAmp "Ideal operational amplifier (norator-nullator pair)"
          SI.Voltage v1 "Voltage drop over the left port";
          SI.Voltage v2 "Voltage drop over the right port";
          SI.Current i1
          "Current flowing from pos. to neg. pin of the left port";
          SI.Current i2
          "Current flowing from pos. to neg. pin of the right port";
          Interfaces.PositivePin p1 "Positive pin of the left port" annotation (Placement(
                transformation(extent={{-110,-60},{-90,-40}}, rotation=0)));
          Interfaces.NegativePin n1 "Negative pin of the left port" annotation (Placement(
                transformation(extent={{-110,40},{-90,60}}, rotation=0)));
          Interfaces.PositivePin p2 "Positive pin of the right port" annotation (Placement(
                transformation(extent={{90,-10},{110,10}}, rotation=0)));
          Interfaces.NegativePin n2 "Negative pin of the right port" annotation (Placement(
                transformation(
                origin={0,-100},
                extent={{10,-10},{-10,10}},
                rotation=270)));
        equation
          v1 = p1.v - n1.v;
          v2 = p2.v - n2.v;
          0 = p1.i + n1.i;
          0 = p2.i + n2.i;
          i1 = p1.i;
          i2 = p2.i;
          v1 = 0;
          i1 = 0;
          annotation (
            Documentation(info="<html>
<P>
The ideal OpAmp is a two-port. The left port is fixed to <i>v1=0</i> and <i>i1=0</i>
(nullator). At the right port both any voltage <i>v2</i> and any current <i>i2</i>
are possible (norator).
</P>
</HTML>
",       revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Polygon(
                  points={{60,0},{-60,70},{-60,-70},{60,0}},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  lineColor={0,0,255}),
                Line(points={{-90,50},{-60,50}}, color={0,0,255}),
                Line(points={{-90,-50},{-60,-50}}, color={0,0,255}),
                Line(points={{60,0},{90,0}}, color={0,0,255}),
                Line(points={{0,-35},{0,-91}}, color={0,0,255}),
                Line(points={{-48,32},{-28,32}}, color={0,0,255}),
                Line(points={{-39,-20},{-39,-41}}, color={0,0,255}),
                Line(points={{-50,-31},{-28,-31}}, color={0,0,255}),
                Text(
                  extent={{-150,126},{150,86}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Polygon(
                  points={{60,0},{-60,70},{-60,-70},{60,0}},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  lineColor={0,0,255}),
                Line(points={{-96,50},{-60,50}}, color={0,0,255}),
                Line(points={{-96,-50},{-60,-50}}, color={0,0,255}),
                Line(points={{60,0},{96,0}}, color={0,0,255}),
                Line(points={{0,-35},{0,-96}}, color={0,0,255}),
                Line(points={{-55,50},{-45,50}}, color={0,0,255}),
                Line(points={{-50,-45},{-50,-55}}, color={0,0,255}),
                Line(points={{-55,-50},{-45,-50}}, color={0,0,255}),
                Text(
                  extent={{-111,-39},{-90,-19}},
                  lineColor={160,160,164},
                  textString="p1.i=0"),
                Polygon(
                  points={{120,3},{110,0},{120,-3},{120,3}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={160,160,164}),
                Line(points={{111,0},{136,0}}, color={0,0,0}),
                Text(
                  extent={{118,2},{135,17}},
                  lineColor={0,0,0},
                  textString="i2"),
                Text(
                  extent={{-111,60},{-90,80}},
                  lineColor={160,160,164},
                  textString="n1.i=0"),
                Line(points={{18,-111},{18,-86}}, color={160,160,164}),
                Polygon(
                  points={{21,-101},{18,-111},{15,-101},{21,-101}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{22,-100},{39,-85}},
                  lineColor={0,0,0},
                  textString="i2")}));
        end IdealOpAmp;
        annotation (Documentation(info="<html>
<p>This package contains electrical components with idealized behaviour. To enable more realistic applications than it is possible with pure realistic behavior some components are improved by additional features. E.g. the switches have resistances for the open or close case which can be parametrized.</p>
</html>",revisions="<html>
<dl>
<dt>
<b>Main Authors:</b>
<dd>
Christoph Clau&szlig;
    &lt;<a href=\"mailto:Christoph.Clauss@eas.iis.fraunhofer.de\">Christoph.Clauss@eas.iis.fraunhofer.de</a>&gt;<br>
    Andr&eacute; Schneider
    &lt;<a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>&gt;<br>
    Fraunhofer Institute for Integrated Circuits<br>
    Design Automation Department<br>
    Zeunerstra&szlig;e 38<br>
    D-01069 Dresden<br>
<p>
<dt>
<b>Copyright:</b>
<dd>
Copyright &copy; 1998-2010, Modelica Association and Fraunhofer-Gesellschaft.<br>
<i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified
under the terms of the <b>Modelica license</b>, see the license conditions
and the accompanying <b>disclaimer</b> in the documentation of package
Modelica in file \"Modelica/package.mo\".</i><br>
<p>
</dl>
</html>"));
      end Ideal;

      package Interfaces
      "Connectors and partial models for Analog electrical components"
        extends Modelica.Icons.InterfacesPackage;

        connector Pin "Pin of an electrical component"
          Modelica.SIunits.Voltage v "Potential at the pin" annotation (
              unassignedMessage="An electrical potential cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
          flow Modelica.SIunits.Current i "Current flowing into the pin" annotation (
              unassignedMessage="An electrical current cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
          annotation (defaultComponentName="pin",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-160,110},{40,50}},
                  lineColor={0,0,255},
                  textString="%name")}),
            Documentation(revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>",       info="<html>
<p>Pin is the basic electric connector. It includes the voltage which consists between the pin and the ground node. The ground node is the node of (any) ground device (Modelica.Electrical.Basic.Ground). Furthermore, the pin includes the current, which is considered to be <b>positive</b> if it is flowing at the pin<b> into the device</b>.</p>
</html>"));
        end Pin;

        connector PositivePin "Positive pin of an electric component"
          Modelica.SIunits.Voltage v "Potential at the pin" annotation (
              unassignedMessage="An electrical potential cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
          flow Modelica.SIunits.Current i "Current flowing into the pin" annotation (
              unassignedMessage="An electrical current cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
          annotation (defaultComponentName="pin_p",
            Documentation(info="<html>
<p>Connectors PositivePin and NegativePin are nearly identical. The only difference is that the icons are different in order to identify more easily the pins of a component. Usually, connector PositivePin is used for the positive and connector NegativePin for the negative pin of an electrical component.</p>
</html>",                     revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-160,110},{40,50}},
                  lineColor={0,0,255},
                  textString="%name")}));
        end PositivePin;

        connector NegativePin "Negative pin of an electric component"
          Modelica.SIunits.Voltage v "Potential at the pin" annotation (
              unassignedMessage="An electrical potential cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
          flow Modelica.SIunits.Current i "Current flowing into the pin" annotation (
              unassignedMessage="An electrical current cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
          annotation (defaultComponentName="pin_n",
            Documentation(info="<html>
<p>Connectors PositivePin and NegativePin are nearly identical. The only difference is that the icons are different in order to identify more easily the pins of a component. Usually, connector PositivePin is used for the positive and connector NegativePin for the negative pin of an electrical component.</p>
</html>",                     revisions="<html>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-40,110},{160,50}},
                  textString="%name",
                  lineColor={0,0,255})}));
        end NegativePin;

        partial model OnePort
        "Component with two electrical pins p and n and current i from p to n"

          SI.Voltage v "Voltage drop between the two pins (= p.v - n.v)";
          SI.Current i "Current flowing from pin p to pin n";
          PositivePin p
          "Positive pin (potential p.v > n.v for positive voltage drop v)"               annotation (Placement(
                transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
          NegativePin n "Negative pin" annotation (Placement(transformation(extent={{
                    110,-10},{90,10}}, rotation=0)));
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          annotation (
            Documentation(info="<html>
<p>Superclass of elements which have <b>two</b> electrical pins: the positive pin connector <i>p</i>, and the negative pin connector <i>n</i>. It is assumed that the current flowing into pin p is identical to the current flowing out of pin n. This current is provided explicitly as current i.</p>
</html>",revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),  Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Line(points={{-110,20},{-85,20}}, color={160,160,164}),
                Polygon(
                  points={{-95,23},{-85,20},{-95,17},{-95,23}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Line(points={{90,20},{115,20}}, color={160,160,164}),
                Line(points={{-125,0},{-115,0}}, color={160,160,164}),
                Line(points={{-120,-5},{-120,5}}, color={160,160,164}),
                Text(
                  extent={{-110,25},{-90,45}},
                  lineColor={160,160,164},
                  textString="i"),
                Polygon(
                  points={{105,23},{115,20},{105,17},{105,23}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Line(points={{115,0},{125,0}}, color={160,160,164}),
                Text(
                  extent={{90,45},{110,25}},
                  lineColor={160,160,164},
                  textString="i")}));
        end OnePort;

        partial model ConditionalHeatPort
        "Partial model to include a conditional HeatPort in order to describe the power loss via a thermal network"

          parameter Boolean useHeatPort = false "=true, if HeatPort is enabled"
          annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
          parameter Modelica.SIunits.Temperature T=293.15
          "Fixed device temperature if useHeatPort = false"   annotation(Dialog(enable=not useHeatPort));
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(T(start=T)=T_heatPort, Q_flow=-LossPower) if useHeatPort
            annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
                iconTransformation(extent={{-10,-110},{10,-90}})));
          Modelica.SIunits.Power LossPower
          "Loss power leaving component via HeatPort";
          Modelica.SIunits.Temperature T_heatPort "Temperature of HeatPort";
        equation
          if not useHeatPort then
             T_heatPort = T;
          end if;

          annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                    -100},{100,100}}),                                                                 graphics),
            Documentation(revisions="<html>
<ul>
<li><i> February 17, 2009   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>",         info="<html>
<p>
This partial model provides a conditional heating port for the connection to a thermal network.
</p>
<ul>
<li> If <b>useHeatPort</b> is set to <b>false</b> (default), no heat port is available, and the thermal
     loss power flows internally to the ground. In this case, the parameter <b>T</b> specifies
     the fixed device temperature (the default for T = 20<sup>o</sup>C).</li>
<li> If <b>useHeatPort</b> is set to <b>true</b>, a heat port is available.</li>
</ul>

<p>
If this model is used, the loss power has to be provided by an equation in the model which inherits from
ConditionalHeatingPort model (<b>lossPower = ...</b>). As device temperature
<b>T_heatPort</b> can be used to describe the influence of the device temperature
on the model behaviour.
</p>
</html>"));
        end ConditionalHeatPort;
        annotation (Documentation(info="<html>
<p>This package contains connectors and interfaces (partial models) for analog electrical components. The partial models contain typical combinations of pins, and internal variables which are often used. Furthermode, the thermal heat port is in this package which can be included by inheritance.</p>
</html>",revisions="<html>
<dl>
<dt>
<b>Main Authors:</b>
<dd>
Christoph Clau&szlig;
    &lt;<a href=\"mailto:Christoph.Clauss@eas.iis.fraunhofer.de\">Christoph.Clauss@eas.iis.fraunhofer.de</a>&gt;<br>
    Andr&eacute; Schneider
    &lt;<a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>&gt;<br>
    Fraunhofer Institute for Integrated Circuits<br>
    Design Automation Department<br>
    Zeunerstra&szlig;e 38<br>
    D-01069 Dresden<br>
<p>
<dt>
</dl>

<b>Copyright:</b>
<dl>
<dd>
Copyright &copy; 1998-2010, Modelica Association and Fraunhofer-Gesellschaft.<br>
<i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified
under the terms of the <b>Modelica license</b>, see the license conditions
and the accompanying <b>disclaimer</b> in the documentation of package
Modelica in file \"Modelica/package.mo\".</i><br>
<p>
</dl>

<ul>
<li><i> 1998</i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"));
      end Interfaces;

      package Sensors "Potential, voltage, current, and power sensors"
        extends Modelica.Icons.SensorsPackage;

        model CurrentSensor "Sensor to measure the current in a branch"
          extends Modelica.Icons.RotationalSensor;

          Interfaces.PositivePin p "positive pin" annotation (Placement(
                transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
          Interfaces.NegativePin n "negative pin" annotation (Placement(
                transformation(extent={{90,-10},{110,10}}, rotation=0)));
          Modelica.Blocks.Interfaces.RealOutput i
          "current in the branch from p to n as output signal"
             annotation (Placement(transformation(
                origin={0,-100},
                extent={{10,-10},{-10,10}},
                rotation=90)));

        equation
          p.v = n.v;
          p.i = i;
          n.i = -i;
          annotation (
            Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Text(
                  extent={{-29,-11},{30,-70}},
                  lineColor={0,0,0},
                  textString="A"),
                Line(points={{-70,0},{-90,0}}, color={0,0,0}),
                Text(
                  extent={{-150,80},{150,120}},
                  textString="%name",
                  lineColor={0,0,255}),
                Line(points={{70,0},{90,0}}, color={0,0,0}),
                Line(points={{0,-90},{0,-70}}, color={0,0,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Text(
                  extent={{-153,79},{147,119}},
                  textString="%name",
                  lineColor={0,0,255}),
                Line(points={{-70,0},{-96,0}}, color={0,0,0}),
                Line(points={{70,0},{96,0}}, color={0,0,0}),
                Line(points={{0,-90},{0,-70}}, color={0,0,255})}),
            Documentation(revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>",       info="<html>
<p>The current  sensor converts the current flowing between the two connectors into a real valued signal. The two connectors are in the sensor connected like a short cut. The sensor has to be placed within an electrical connection in series.  It does not influence the current sum at the connected nodes. Therefore, the electrical behavior is not influenced by the sensor.</p>
</html>"));
        end CurrentSensor;
        annotation (
          Documentation(info="<html>
<p>This package contains potential, voltage, and current sensors. The sensors can be used to convert voltages or currents into real signal values o be connected to components of the Blocks package. The sensors are designed in such a way that they do not influence the electrical behavior.</p>
</html>",revisions="<html>
<dl>
<dt>
<b>Main Authors:</b>
<dd>
Christoph Clau&szlig;
    &lt;<a href=\"mailto:Christoph.Clauss@eas.iis.fraunhofer.de\">Christoph.Clauss@eas.iis.fraunhofer.de</a>&gt;<br>
    Andr&eacute; Schneider
    &lt;<a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>&gt;<br>
    Fraunhofer Institute for Integrated Circuits<br>
    Design Automation Department<br>
    Zeunerstra&szlig;e 38<br>
    D-01069 Dresden<br>
<p>
<dt>
<b>Copyright:</b>
<dd>
Copyright &copy; 1998-2010, Modelica Association and Fraunhofer-Gesellschaft.<br>
<i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified
under the terms of the <b>Modelica license</b>, see the license conditions
and the accompanying <b>disclaimer</b> in the documentation of package
Modelica in file \"Modelica/package.mo\".</i><br>
<p>
</dl>
</html>"));
      end Sensors;

      package Sources
      "Time-dependend and controlled voltage and current sources"
        extends Modelica.Icons.SourcesPackage;

        model SignalVoltage
        "Generic voltage source using the input signal as source voltage"

          Interfaces.PositivePin p annotation (Placement(transformation(extent={{-110,
                    -10},{-90,10}}, rotation=0)));
          Interfaces.NegativePin n annotation (Placement(transformation(extent={{110,
                    -10},{90,10}}, rotation=0)));
          Modelica.Blocks.Interfaces.RealInput v
          "Voltage between pin p and n (= p.v - n.v) as input signal"
             annotation (Placement(transformation(
                origin={0,70},
                extent={{-20,-20},{20,20}},
                rotation=270)));
          SI.Current i "Current flowing from pin p to pin n";
        equation
          v = p.v - n.v;
          0 = p.i + n.i;
          i = p.i;
          annotation (
            Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Ellipse(
                  extent={{-50,50},{50,-50}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{-90,0},{-50,0}}, color={0,0,0}),
                Line(points={{50,0},{90,0}}, color={0,0,0}),
                Line(points={{-50,0},{50,0}}, color={0,0,0}),
                Text(
                  extent={{-150,-104},{150,-64}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-120,50},{-20,0}},
                  lineColor={0,0,255},
                  textString="+"),
                Text(
                  extent={{20,50},{120,0}},
                  lineColor={0,0,255},
                  textString="-")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Ellipse(
                  extent={{-50,50},{50,-50}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{-96,0},{-50,0}}, color={0,0,0}),
                Line(points={{50,0},{96,0}}, color={0,0,0}),
                Line(points={{-50,0},{50,0}}, color={0,0,0}),
                Line(points={{-109,20},{-84,20}}, color={160,160,164}),
                Polygon(
                  points={{-94,23},{-84,20},{-94,17},{-94,23}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Line(points={{91,20},{116,20}}, color={160,160,164}),
                Text(
                  extent={{-109,25},{-89,45}},
                  lineColor={160,160,164},
                  textString="i"),
                Polygon(
                  points={{106,23},{116,20},{106,17},{106,23}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{91,45},{111,25}},
                  lineColor={160,160,164},
                  textString="i"),
                Line(points={{-119,-5},{-119,5}}, color={160,160,164}),
                Line(points={{-124,0},{-114,0}}, color={160,160,164}),
                Line(points={{116,0},{126,0}}, color={160,160,164})}),
            Documentation(revisions="<html>
<ul>
<li><i> 1998   </i>
       by Martin Otter<br> initially implemented<br>
       </li>
</ul>
</html>",       info="<html>
<p>The signall voltage source is a parameterless converter of real valued signals into a the source voltage. No further effects are modeled. The real valued signal has to be provided by components of the blocks library. It can be regarded as the &quot;Opposite&quot; of a voltage sensor.</p>
</html>"));
        end SignalVoltage;
        annotation (
          Documentation(info="<html>
<p>This package contains time-dependend and controlled voltage and current sources. Most of the sources use the behavior modeled in the Modelica.Blocks.Sources package. All sources are ideal in the sense that <b>no</b> internal resistances are included.</p>
</html>",revisions="<html>
<dl>
<dt>
<b>Main Authors:</b>
<dd>
Christoph Clau&szlig;
    &lt;<a href=\"mailto:Christoph.Clauss@eas.iis.fraunhofer.de\">Christoph.Clauss@eas.iis.fraunhofer.de</a>&gt;<br>
    Andr&eacute; Schneider
    &lt;<a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>&gt;<br>
    Fraunhofer Institute for Integrated Circuits<br>
    Design Automation Department<br>
    Zeunerstra&szlig;e 38<br>
    D-01069 Dresden<br>
<p>
<dt>
<b>Copyright:</b>
<dd>
Copyright &copy; 1998-2010, Modelica Association and Fraunhofer-Gesellschaft.<br>
<i>The Modelica package is <b>free</b> software; it can be redistributed and/or modified
under the terms of the <b>Modelica license</b>, see the license conditions
and the accompanying <b>disclaimer</b> in the documentation of package
Modelica in file \"Modelica/package.mo\".</i><br>
<p>
</dl>
</html>"));
      end Sources;
    annotation (
        __Dymola_classOrder={"Examples", "*"},
      Documentation(info="<html>
<p>
This package contains packages for analog electrical components:
<ul>
<li>Basic: basic components (resistor, capacitor, conductor, inductor, transformer, gyrator)</li>
<li>Semiconductors: semiconductor devices (diode, bipolar and MOS transistors)</li>
<li>Lines: transmission lines (lossy and lossless)</li>
<li>Ideal: ideal elements (switches, diode, transformer, idle, short, ...)</li>
<li>Sources: time-dependend and controlled voltage and current sources</li>
<li>Sensors: sensors to measure potential, voltage, and current</li>
</ul>
</p>
<dl>
<dt>
<b>Main Authors:</b></dt>
<dd>
Christoph Clau&szlig;
    &lt;<a href=\"mailto:Christoph.Clauss@eas.iis.fraunhofer.de\">Christoph.Clauss@eas.iis.fraunhofer.de</a>&gt;<br>
    Andr&eacute; Schneider
    &lt;<a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>&gt;<br>
    Fraunhofer Institute for Integrated Circuits<br>
    Design Automation Department<br>
    Zeunerstra&szlig;e 38<br>
    D-01069 Dresden, Germany</dd>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and Fraunhofer-Gesellschaft.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
"));
    end Analog;
  annotation (
    Documentation(info="<html>
<p>
This library contains electrical components to build up analog and digital circuits,
as well as machines to model electrical motors and generators,
especially three phase induction machines such as an asynchronous motor.
</p>

</HTML>
"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(extent={{-29,-13},{3,-27}}, lineColor={0,0,0}),
        Line(points={{37,-58},{62,-58}}, color={0,0,0}),
        Line(points={{36,-49},{61,-49}}, color={0,0,0}),
        Line(points={{-78,-50},{-43,-50}}, color={0,0,0}),
        Line(points={{-67,-55},{-55,-55}}, color={0,0,0}),
        Line(points={{-61,-50},{-61,-20},{-29,-20}}, color={0,0,0}),
        Line(points={{3,-20},{48,-20},{48,-49}}, color={0,0,0}),
        Line(points={{48,-58},{48,-78},{-61,-78},{-61,-55}}, color={0,0,0})}));
  end Electrical;

  package Mechanics
  "Library of 1-dim. and 3-dim. mechanical components (multi-body, rotational, translational)"
  extends Modelica.Icons.Package;

    package MultiBody "Library to model 3-dimensional mechanical systems"
    import SI = Modelica.SIunits;
    extends Modelica.Icons.Package;

    model World
      "World coordinate system + gravity field + default animation definition"

      import SI = Modelica.SIunits;
      import Modelica.Mechanics.MultiBody.Types.GravityTypes;
      import Modelica.Mechanics.MultiBody.Types;

        Interfaces.Frame_b frame_b
        "Coordinate system fixed in the origin of the world frame"
                                   annotation (Placement(transformation(extent={{84,
                -16},{116,16}}, rotation=0)));

      parameter Boolean enableAnimation=true
        "= true, if animation of all components is enabled";
      parameter Boolean animateWorld=true
        "= true, if world coordinate system shall be visualized" annotation(Dialog(enable=enableAnimation));
      parameter Boolean animateGravity=true
        "= true, if gravity field shall be visualized (acceleration vector or field center)"
                                                                                              annotation(Dialog(enable=enableAnimation));
      parameter Types.AxisLabel label1="x" "Label of horizontal axis in icon";
      parameter Types.AxisLabel label2="y" "Label of vertical axis in icon";
      parameter Types.GravityTypes gravityType=GravityTypes.UniformGravity
        "Type of gravity field"                                                                                                     annotation (Evaluate=true);
      parameter SI.Acceleration g=9.81 "Constant gravity acceleration"
        annotation (Dialog(enable=gravityType == Modelica.Mechanics.MultiBody.Types.GravityTypes.UniformGravity));
      parameter Types.Axis n={0,-1,0}
        "Direction of gravity resolved in world frame (gravity = g*n/length(n))"
        annotation (Evaluate=true, Dialog(enable=gravityType == Modelica.Mechanics.
              MultiBody.Types.GravityTypes.UniformGravity));
      parameter Real mue(
        unit="m3/s2",
        min=0) = 3.986e14
        "Gravity field constant (default = field constant of earth)"
        annotation (Dialog(enable=gravityType == Modelica.Mechanics.MultiBody.Types.GravityTypes.PointGravity));
      parameter Boolean driveTrainMechanics3D=true
        "= true, if 3-dim. mechanical effects of Parts.Mounting1D/Rotor1D/BevelGear1D shall be taken into account";

      parameter SI.Distance axisLength=nominalLength/2
        "Length of world axes arrows"
        annotation (Dialog(tab="Animation", group="if animateWorld = true", enable=enableAnimation and animateWorld));
      parameter SI.Distance axisDiameter=axisLength/defaultFrameDiameterFraction
        "Diameter of world axes arrows"
        annotation (Dialog(tab="Animation", group="if animateWorld = true", enable=enableAnimation and animateWorld));
      parameter Boolean axisShowLabels=true "= true, if labels shall be shown"
        annotation (Dialog(tab="Animation", group="if animateWorld = true", enable=enableAnimation and animateWorld));
      input Types.Color axisColor_x=Modelica.Mechanics.MultiBody.Types.Defaults.FrameColor
        "Color of x-arrow"
        annotation (Dialog(tab="Animation", group="if animateWorld = true", enable=enableAnimation and animateWorld));
      input Types.Color axisColor_y=axisColor_x
        annotation (Dialog(tab="Animation", group="if animateWorld = true", enable=enableAnimation and animateWorld));
      input Types.Color axisColor_z=axisColor_x "Color of z-arrow"
        annotation (Dialog(tab="Animation", group="if animateWorld = true", enable=enableAnimation and animateWorld));

      parameter SI.Position gravityArrowTail[3]={0,0,0}
        "Position vector from origin of world frame to arrow tail, resolved in world frame"
        annotation (Dialog(tab="Animation", group=
              "if animateGravity = true and gravityType = UniformGravity",
              enable=enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity));
      parameter SI.Length gravityArrowLength=axisLength/2
        "Length of gravity arrow"
        annotation (Dialog(tab="Animation", group=
              "if animateGravity = true and gravityType = UniformGravity",
              enable=enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity));
      parameter SI.Diameter gravityArrowDiameter=gravityArrowLength/
          defaultWidthFraction "Diameter of gravity arrow" annotation (Dialog(tab=
              "Animation", group=
              "if animateGravity = true and gravityType = UniformGravity",
              enable=enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity));
      input Types.Color gravityArrowColor={0,230,0} "Color of gravity arrow"
        annotation (Dialog(tab="Animation", group=
              "if animateGravity = true and gravityType = UniformGravity",
              enable=enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity));
      parameter SI.Diameter gravitySphereDiameter=12742000
        "Diameter of sphere representing gravity center (default = mean diameter of earth)"
        annotation (Dialog(tab="Animation", group=
              "if animateGravity = true and gravityType = PointGravity",
              enable=enableAnimation and animateGravity and gravityType == GravityTypes.PointGravity));
      input Types.Color gravitySphereColor={0,230,0} "Color of gravity sphere"
        annotation (Dialog(tab="Animation", group=
              "if animateGravity = true and gravityType = PointGravity",
              enable=enableAnimation and animateGravity and gravityType == GravityTypes.PointGravity));

      parameter SI.Length nominalLength=1
        "\"Nominal\" length of multi-body system"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultAxisLength=nominalLength/5
        "Default for length of a frame axis (but not world frame)"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultJointLength=nominalLength/10
        "Default for the fixed length of a shape representing a joint"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultJointWidth=nominalLength/20
        "Default for the fixed width of a shape representing a joint"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultForceLength=nominalLength/10
        "Default for the fixed length of a shape representing a force (e.g., damper)"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultForceWidth=nominalLength/20
        "Default for the fixed width of a shape represening a force (e.g., spring, bushing)"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultBodyDiameter=nominalLength/9
        "Default for diameter of sphere representing the center of mass of a body"
        annotation (Dialog(tab="Defaults"));
      parameter Real defaultWidthFraction=20
        "Default for shape width as a fraction of shape length (e.g., for Parts.FixedTranslation)"
        annotation (Dialog(tab="Defaults"));
      parameter SI.Length defaultArrowDiameter=nominalLength/40
        "Default for arrow diameter (e.g., of forces, torques, sensors)"
        annotation (Dialog(tab="Defaults"));
      parameter Real defaultFrameDiameterFraction=40
        "Default for arrow diameter of a coordinate system as a fraction of axis length"
        annotation (Dialog(tab="Defaults"));
      parameter Real defaultSpecularCoefficient(min=0) = 0.7
        "Default reflection of ambient light (= 0: light is completely absorbed)"
        annotation (Dialog(tab="Defaults"));
      parameter Real defaultN_to_m(unit="N/m", min=0) = 1000
        "Default scaling of force arrows (length = force/defaultN_to_m)"
        annotation (Dialog(tab="Defaults"));
      parameter Real defaultNm_to_m(unit="N.m/m", min=0) = 1000
        "Default scaling of torque arrows (length = torque/defaultNm_to_m)"
        annotation (Dialog(tab="Defaults"));

      replaceable function gravityAcceleration =

          Modelica.Mechanics.MultiBody.Forces.Internal.standardGravityAcceleration
          (    gravityType=gravityType, g=g*Modelica.Math.Vectors.normalize(n,0.0), mue=mue)
           constrainedby
        Modelica.Mechanics.MultiBody.Interfaces.partialGravityAcceleration
        "Function to compute the gravity acceleration, resolved in world frame"
           annotation(__Dymola_choicesAllMatching=true,Dialog(enable=gravityType==
                       Modelica.Mechanics.MultiBody.Types.GravityTypes.NoGravity),
        Documentation(info="<html>
<p>Replaceable function to define the gravity field.
   Default is function
   <a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.Internal.standardGravityAcceleration\">standardGravityAcceleration</a>
   that provides some simple gravity fields (no gravity, constant parallel gravity field,
   point gravity field).
   By redeclaring this function, any type of gravity field can be defined, see example
     <a href=\"modelica://Modelica.Mechanics.MultiBody.Examples.Elementary.UserDefinedGravityField\">Examples.Elementary.UserDefinedGravityField</a>.
</p>
</html>"));

      /* The World object can only use the Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape model, but no
     other models in package Modelica.Mechanics.MultiBody.Visualizers, since the other models access
     data of the "outer Modelica.Mechanics.MultiBody.World world" object, i.e., there are
     mutually dependent classes. For this reason, the higher level visualization
     objects cannot be used.
  */
    protected
      parameter Integer ndim=if enableAnimation and animateWorld then 1 else 0;
      parameter Integer ndim2=if enableAnimation and animateWorld and
          axisShowLabels then 1 else 0;

      // Parameters to define axes
      parameter SI.Length headLength=min(axisLength, axisDiameter*Types.Defaults.
          FrameHeadLengthFraction);
      parameter SI.Length headWidth=axisDiameter*Types.Defaults.
          FrameHeadWidthFraction;
      parameter SI.Length lineLength=max(0, axisLength - headLength);
      parameter SI.Length lineWidth=axisDiameter;

      // Parameters to define axes labels
      parameter SI.Length scaledLabel=Modelica.Mechanics.MultiBody.Types.Defaults.FrameLabelHeightFraction*
          axisDiameter;
      parameter SI.Length labelStart=1.05*axisLength;

      // x-axis
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape x_arrowLine(
        shapeType="cylinder",
        length=lineLength,
        width=lineWidth,
        height=lineWidth,
        lengthDirection={1,0,0},
        widthDirection={0,1,0},
        color=axisColor_x,
        specularCoefficient=0) if enableAnimation and animateWorld;
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape x_arrowHead(
        shapeType="cone",
        length=headLength,
        width=headWidth,
        height=headWidth,
        lengthDirection={1,0,0},
        widthDirection={0,1,0},
        color=axisColor_x,
        r={lineLength,0,0},
        specularCoefficient=0) if enableAnimation and animateWorld;
      Modelica.Mechanics.MultiBody.Visualizers.Internal.Lines x_label(
        lines=scaledLabel*{[0, 0; 1, 1],[0, 1; 1, 0]},
        diameter=axisDiameter,
        color=axisColor_x,
        r_lines={labelStart,0,0},
        n_x={1,0,0},
        n_y={0,1,0},
        specularCoefficient=0) if enableAnimation and animateWorld and axisShowLabels;

      // y-axis
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape y_arrowLine(
        shapeType="cylinder",
        length=lineLength,
        width=lineWidth,
        height=lineWidth,
        lengthDirection={0,1,0},
        widthDirection={1,0,0},
        color=axisColor_y,
        specularCoefficient=0) if enableAnimation and animateWorld;
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape y_arrowHead(
        shapeType="cone",
        length=headLength,
        width=headWidth,
        height=headWidth,
        lengthDirection={0,1,0},
        widthDirection={1,0,0},
        color=axisColor_y,
        r={0,lineLength,0},
        specularCoefficient=0) if enableAnimation and animateWorld;
      Modelica.Mechanics.MultiBody.Visualizers.Internal.Lines y_label(
        lines=scaledLabel*{[0, 0; 1, 1.5],[0, 1.5; 0.5, 0.75]},
        diameter=axisDiameter,
        color=axisColor_y,
        r_lines={0,labelStart,0},
        n_x={0,1,0},
        n_y={-1,0,0},
        specularCoefficient=0) if enableAnimation and animateWorld and axisShowLabels;

      // z-axis
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape z_arrowLine(
        shapeType="cylinder",
        length=lineLength,
        width=lineWidth,
        height=lineWidth,
        lengthDirection={0,0,1},
        widthDirection={0,1,0},
        color=axisColor_z,
        specularCoefficient=0) if enableAnimation and animateWorld;
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape z_arrowHead(
        shapeType="cone",
        length=headLength,
        width=headWidth,
        height=headWidth,
        lengthDirection={0,0,1},
        widthDirection={0,1,0},
        color=axisColor_z,
        r={0,0,lineLength},
        specularCoefficient=0) if enableAnimation and animateWorld;
      Modelica.Mechanics.MultiBody.Visualizers.Internal.Lines z_label(
        lines=scaledLabel*{[0, 0; 1, 0],[0, 1; 1, 1],[0, 1; 1, 0]},
        diameter=axisDiameter,
        color=axisColor_z,
        r_lines={0,0,labelStart},
        n_x={0,0,1},
        n_y={0,1,0},
        specularCoefficient=0) if enableAnimation and animateWorld and axisShowLabels;

      // Uniform gravity visualization
      parameter SI.Length gravityHeadLength=min(gravityArrowLength,
          gravityArrowDiameter*Types.Defaults.ArrowHeadLengthFraction);
      parameter SI.Length gravityHeadWidth=gravityArrowDiameter*Types.Defaults.ArrowHeadWidthFraction;
      parameter SI.Length gravityLineLength=max(0, gravityArrowLength - gravityHeadLength);
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape gravityArrowLine(
        shapeType="cylinder",
        length=gravityLineLength,
        width=gravityArrowDiameter,
        height=gravityArrowDiameter,
        lengthDirection=n,
        widthDirection={0,1,0},
        color=gravityArrowColor,
        r_shape=gravityArrowTail,
        specularCoefficient=0) if enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity;
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape gravityArrowHead(
        shapeType="cone",
        length=gravityHeadLength,
        width=gravityHeadWidth,
        height=gravityHeadWidth,
        lengthDirection=n,
        widthDirection={0,1,0},
        color=gravityArrowColor,
        r_shape=gravityArrowTail + Modelica.Math.Vectors.normalize(
                                                    n)*gravityLineLength,
        specularCoefficient=0) if enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity;

      // Point gravity visualization
      parameter Integer ndim_pointGravity=if enableAnimation and animateGravity
           and gravityType == 2 then 1 else 0;
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape gravitySphere(
        shapeType="sphere",
        r_shape={-gravitySphereDiameter/2,0,0},
        lengthDirection={1,0,0},
        length=gravitySphereDiameter,
        width=gravitySphereDiameter,
        height=gravitySphereDiameter,
        color=gravitySphereColor,
        specularCoefficient=0) if enableAnimation and animateGravity and gravityType == GravityTypes.PointGravity;

    /*
  function gravityAcceleration = gravityAccelerationTypes (
      gravityType=gravityType,
      g=g*Modelica.Math.Vectors.normalize(
                                     n),
      mue=mue);
*/

    equation
      Connections.root(frame_b.R);

      assert(Modelica.Math.Vectors.length(
                           n) > 1.e-10,
        "Parameter n of World object is wrong (lenght(n) > 0 required)");
      frame_b.r_0 = zeros(3);
      frame_b.R = Frames.nullRotation();
      annotation (
        defaultComponentName="world",
        defaultComponentPrefixes="inner",
        missingInnerMessage="No \"world\" component is defined. A default world
component with the default gravity field will be used
(g=9.81 in negative y-axis). If this is not desired,
drag Modelica.Mechanics.MultiBody.World into the top level of your model.",
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-100,-118},{-100,61}},
              color={0,0,0},
              thickness=0.5),
            Polygon(
              points={{-100,100},{-120,60},{-80,60},{-100,100},{-100,100}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-119,-100},{59,-100}},
              color={0,0,0},
              thickness=0.5),
            Polygon(
              points={{99,-100},{59,-80},{59,-120},{99,-100}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,145},{150,105}},
              textString="%name",
              lineColor={0,0,255}),
            Text(
              extent={{95,-113},{144,-162}},
              lineColor={0,0,0},
              textString="%label1"),
            Text(
              extent={{-170,127},{-119,77}},
              lineColor={0,0,0},
              textString="%label2"),
            Line(points={{-56,78},{-56,-26}}, color={0,0,255}),
            Polygon(
              points={{-68,-26},{-56,-66},{-44,-26},{-68,-26}},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}),
            Line(points={{2,78},{2,-26}}, color={0,0,255}),
            Polygon(
              points={{-10,-26},{2,-66},{14,-26},{-10,-26}},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}),
            Line(points={{66,80},{66,-26}}, color={0,0,255}),
            Polygon(
              points={{54,-26},{66,-66},{78,-26},{54,-26}},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255})}),
        Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics),
        Documentation(info="<HTML>
<p>
Model <b>World</b> represents a global coordinate system fixed in
ground. This model serves several purposes:
<ul>
<li> It is used as <b>inertial system</b> in which
     the equations of all elements of the MultiBody library
     are defined.</li>
<li> It is the world frame of an <b>animation window</b> in which
     all elements of the MultiBody library are visualized.</li>
<li> It is used to define the <b>gravity field</b> in which a
     multi-body model is present. Default is a uniform gravity
     field where the gravity acceleration vector g is the
     same at every position. Additionally, a point gravity field or no
     gravity can be selected. Also, function gravityAcceleration can
     be redeclared to a user-defined function that computes the gravity
     acceleration, see example
     <a href=\"modelica://Modelica.Mechanics.MultiBody.Examples.Elementary.UserDefinedGravityField\">Examples.Elementary.UserDefinedGravityField</a>.
     </li>
<li> It is used to define <b>default settings</b> of animation properties
     (e.g., the diameter of a sphere representing by default
     the center of mass of a body, or the diameters of the cylinders
     representing a revolute joint).</li>
<li> It is used to define a <b>visual representation</b> of the
     world model (= 3 coordinate axes with labels) and of the defined
     gravity field.<br>
    <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/world.png\" ALT=\"MultiBodys.World\">
</li>
</ul>
<p>
Since the gravity field function is required from all bodies with mass
and the default settings of animation properties are required
from nearly every component, exactly one instance of model World needs
to be present in every model on the top level. The basic declaration
needs to be:
</p>
<pre>
    <b>inner</b> Modelica.Mechanics.MultiBody.World world
</pre>
<p>
Note, it must be an <b>inner</b> declaration with instance name <b>world</b>
in order that this world object can be accessed from all objects in the
model. When dragging the \"World\" object from the package browser into
the diagram layer, this declaration is automatically generated
(this is defined via annotations in model World).
</p>
<p>
All vectors and tensors of a mechanical system are resolved in a
frame that is local to the corresponding component. Usually,
if all relative joint coordinates vanish, the local frames
of all components are parallel to each other, as well as to the
world frame (this holds as long as a Parts.FixedRotation,
component is <b>not</b> used). In this \"reference configuration\"
it is therefore
alternatively possible to resolve all vectors in the world
frame, since all frames are parallel to each other.
This is often very convenient. In order to give some visual
support in such a situation, in the icon of a World instance
two axes of the world frame are shown and the labels
of these axes can be set via parameters.
</p>
</HTML>
"));
    end World;

      package Examples
      "Examples that demonstrate the usage of the MultiBody library"
      extends Modelica.Icons.ExamplesPackage;

        package Systems
        "Examples of complete system models including 3-dimensional mechanics"
        extends Modelica.Icons.ExamplesPackage;

          package RobotR3
          "Library to demonstrate robot system models based on the Manutec r3 robot"

            model fullRobot
            "6 degree of freedom robot with path planning, controllers, motors, brakes, gears and mechanics"
              extends Modelica.Icons.Example;

              import SI = Modelica.SIunits;

              parameter SI.Mass mLoad(min=0) = 15 "Mass of load";
              parameter SI.Position rLoad[3]={0.1,0.25,0.1}
              "Distance from last flange to load mass";
              parameter SI.Acceleration g=9.81 "Gravity acceleration";
              parameter SI.Time refStartTime=0 "Start time of reference motion";
              parameter SI.Time refSwingTime=0.5
              "Additional time after reference motion is in rest before simulation is stopped";

              parameter Real startAngle1(unit="deg") = -60
              "Start angle of axis 1"
                annotation (Dialog(tab="Reference", group="startAngles"));
              parameter Real startAngle2(unit="deg") = 20
              "Start angle of axis 2"
                annotation (Dialog(tab="Reference", group="startAngles"));
              parameter Real startAngle3(unit="deg") = 90
              "Start angle of axis 3"
                annotation (Dialog(tab="Reference", group="startAngles"));
              parameter Real startAngle4(unit="deg") = 0
              "Start angle of axis 4"
                annotation (Dialog(tab="Reference", group="startAngles"));
              parameter Real startAngle5(unit="deg") = -110
              "Start angle of axis 5"
                annotation (Dialog(tab="Reference", group="startAngles"));
              parameter Real startAngle6(unit="deg") = 0
              "Start angle of axis 6"
                annotation (Dialog(tab="Reference", group="startAngles"));

              parameter Real endAngle1(unit="deg") = 60 "End angle of axis 1"
                annotation (Dialog(tab="Reference", group="endAngles"));
              parameter Real endAngle2(unit="deg") = -70 "End angle of axis 2"
                annotation (Dialog(tab="Reference", group="endAngles"));
              parameter Real endAngle3(unit="deg") = -35 "End angle of axis 3"
                annotation (Dialog(tab="Reference", group="endAngles"));
              parameter Real endAngle4(unit="deg") = 45 "End angle of axis 4"
                annotation (Dialog(tab="Reference", group="endAngles"));
              parameter Real endAngle5(unit="deg") = 110 "End angle of axis 5"
                annotation (Dialog(tab="Reference", group="endAngles"));
              parameter Real endAngle6(unit="deg") = 45 "End angle of axis 6"
                annotation (Dialog(tab="Reference", group="endAngles"));

              parameter SI.AngularVelocity refSpeedMax[6]={3,1.5,5,3.1,3.1,4.1}
              "Maximum reference speeds of all joints"
                annotation (Dialog(tab="Reference", group="Limits"));
              parameter SI.AngularAcceleration refAccMax[6]={15,15,15,60,60,60}
              "Maximum reference accelerations of all joints"
                annotation (Dialog(tab="Reference", group="Limits"));

              parameter Real kp1=5 "Gain of position controller"
                annotation (Dialog(tab="Controller", group="Axis 1"));
              parameter Real ks1=0.5 "Gain of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 1"));
              parameter SI.Time Ts1=0.05
              "Time constant of integrator of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 1"));
              parameter Real kp2=5 "Gain of position controller"
                annotation (Dialog(tab="Controller", group="Axis 2"));
              parameter Real ks2=0.5 "Gain of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 2"));
              parameter SI.Time Ts2=0.05
              "Time constant of integrator of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 2"));
              parameter Real kp3=5 "Gain of position controller"
                annotation (Dialog(tab="Controller", group="Axis 3"));
              parameter Real ks3=0.5 "Gain of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 3"));
              parameter SI.Time Ts3=0.05
              "Time constant of integrator of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 3"));
              parameter Real kp4=5 "Gain of position controller"
                annotation (Dialog(tab="Controller", group="Axis 4"));
              parameter Real ks4=0.5 "Gain of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 4"));
              parameter SI.Time Ts4=0.05
              "Time constant of integrator of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 4"));
              parameter Real kp5=5 "Gain of position controller"
                annotation (Dialog(tab="Controller", group="Axis 5"));
              parameter Real ks5=0.5 "Gain of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 5"));
              parameter SI.Time Ts5=0.05
              "Time constant of integrator of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 5"));
              parameter Real kp6=5 "Gain of position controller"
                annotation (Dialog(tab="Controller", group="Axis 6"));
              parameter Real ks6=0.5 "Gain of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 6"));
              parameter SI.Time Ts6=0.05
              "Time constant of integrator of speed controller"
                annotation (Dialog(tab="Controller", group="Axis 6"));
              Components.MechanicalStructure mechanics(
                mLoad=mLoad,
                rLoad=rLoad,
                g=g) annotation (Placement(transformation(extent={{35,-35},{95,25}},
                      rotation=0)));
              Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathPlanning6
                pathPlanning(
                naxis=6,
                angleBegDeg={startAngle1,startAngle2,startAngle3,startAngle4,startAngle5,
                    startAngle6},
                angleEndDeg={endAngle1,endAngle2,endAngle3,endAngle4,endAngle5,endAngle6},
                speedMax=refSpeedMax,
                accMax=refAccMax,
                startTime=refStartTime,
                swingTime=refSwingTime) annotation (Placement(transformation(extent={{-5,
                        50},{-25,70}}, rotation=0)));

              RobotR3.Components.AxisType1 axis1(
                w=4590,
                ratio=-105,
                c=43,
                cd=0.005,
                Rv0=0.4,
                Rv1=(0.13/160),
                kp=kp1,
                ks=ks1,
                Ts=Ts1) annotation (Placement(transformation(extent={{-25,-75},{-5,-55}},
                      rotation=0)));
              RobotR3.Components.AxisType1 axis2(
                w=5500,
                ratio=210,
                c=8,
                cd=0.01,
                Rv1=(0.1/130),
                Rv0=0.5,
                kp=kp2,
                ks=ks2,
                Ts=Ts2) annotation (Placement(transformation(extent={{-25,-55},{-5,-35}},
                      rotation=0)));

              RobotR3.Components.AxisType1 axis3(
                w=5500,
                ratio=60,
                c=58,
                cd=0.04,
                Rv0=0.7,
                Rv1=(0.2/130),
                kp=kp3,
                ks=ks3,
                Ts=Ts3) annotation (Placement(transformation(extent={{-25,-35},{-5,-15}},
                      rotation=0)));
              RobotR3.Components.AxisType2 axis4(
                k=0.2365,
                w=6250,
                D=0.55,
                J=1.6e-4,
                ratio=-99,
                Rv0=21.8,
                Rv1=9.8,
                peak=26.7/21.8,
                kp=kp4,
                ks=ks4,
                Ts=Ts4) annotation (Placement(transformation(extent={{-25,-15},{-5,5}},
                      rotation=0)));
              RobotR3.Components.AxisType2 axis5(
                k=0.2608,
                w=6250,
                D=0.55,
                J=1.8e-4,
                ratio=79.2,
                Rv0=30.1,
                Rv1=0.03,
                peak=39.6/30.1,
                kp=kp5,
                ks=ks5,
                Ts=Ts5) annotation (Placement(transformation(extent={{-25,5},{-5,25}},
                      rotation=0)));
              RobotR3.Components.AxisType2 axis6(
                k=0.0842,
                w=7400,
                D=0.27,
                J=4.3e-5,
                ratio=-99,
                Rv0=10.9,
                Rv1=3.92,
                peak=16.8/10.9,
                kp=kp6,
                ks=ks6,
                Ts=Ts6) annotation (Placement(transformation(extent={{-25,25},{-5,45}},
                      rotation=0)));
          protected
              Components.ControlBus controlBus
                annotation (Placement(transformation(
                    origin={-80,-10},
                    extent={{-20,-20},{20,20}},
                    rotation=90)));
            equation
              connect(axis2.flange, mechanics.axis2) annotation (Line(points={{-5,-45},{
                      25,-45},{25,-21.5},{33.5,-21.5}}, color={0,0,0}));
              connect(axis1.flange, mechanics.axis1) annotation (Line(points={{-5,-65},{
                      30,-65},{30,-30.5},{33.5,-30.5}}, color={0,0,0}));
              connect(axis3.flange, mechanics.axis3) annotation (Line(points={{-5,-25},{
                      15,-25},{15,-12.5},{33.5,-12.5}}, color={0,0,0}));
              connect(axis4.flange, mechanics.axis4) annotation (Line(points={{-5,-5},{15,
                      -5},{15,-3.5},{33.5,-3.5}}, color={0,0,0}));
              connect(axis5.flange, mechanics.axis5)
                annotation (Line(points={{-5,15},{10,15},{10,5.5},{33.5,5.5}}, color={0,0,
                      0}));
              connect(axis6.flange, mechanics.axis6) annotation (Line(points={{-5,35},{20,
                      35},{20,14.5},{33.5,14.5}}, color={0,0,0}));
              connect(controlBus, pathPlanning.controlBus)
                                                   annotation (Line(
                  points={{-80,-10},{-80,60},{-25,60}},
                  color={255,204,51},
                  thickness=0.5));
              connect(controlBus.axisControlBus1, axis1.axisControlBus) annotation (
                __Dymola_Text(
                  string="%first",
                  index=-1,
                  extent=[-6,3; -6,3]), Line(
                  points={{-80,-10},{-80,-14.5},{-79,-14.5},{-79,-17},{-65,-17},{-65,-65},
                      {-25,-65}},
                  color={255,204,51},
                  thickness=0.5));

              connect(controlBus.axisControlBus2, axis2.axisControlBus) annotation (
                __Dymola_Text(
                  string="%first",
                  index=-1,
                  extent=[-6,3; -6,3]), Line(
                  points={{-80,-10},{-79,-10},{-79,-15},{-62.5,-15},{-62.5,-45},{-25,-45}},
                  color={255,204,51},
                  thickness=0.5));

              connect(controlBus.axisControlBus3, axis3.axisControlBus) annotation (
                __Dymola_Text(
                  string="%first",
                  index=-1,
                  extent=[-6,3; -6,3]), Line(
                  points={{-80,-10},{-77,-10},{-77,-12.5},{-61,-12.5},{-61,-25},{-25,-25}},
                  color={255,204,51},
                  thickness=0.5));

              connect(controlBus.axisControlBus4, axis4.axisControlBus) annotation (
                __Dymola_Text(
                  string="%first",
                  index=-1,
                  extent=[-6,3; -6,3]), Line(
                  points={{-80,-10},{-60.5,-10},{-60.5,-5},{-25,-5}},
                  color={255,204,51},
                  thickness=0.5));
              connect(controlBus.axisControlBus5, axis5.axisControlBus) annotation (
                __Dymola_Text(
                  string="%first",
                  index=-1,
                  extent=[-6,3; -6,3]), Line(
                  points={{-80,-10},{-77,-10},{-77,-7},{-63,-7},{-63,15},{-25,15}},
                  color={255,204,51},
                  thickness=0.5));
              connect(controlBus.axisControlBus6, axis6.axisControlBus) annotation (
                __Dymola_Text(
                  string="%first",
                  index=-1,
                  extent=[-6,3; -6,3]), Line(
                  points={{-80,-10},{-79,-10},{-79,-5},{-65,-5},{-65,35},{-25,35}},
                  color={255,204,51},
                  thickness=0.5));
              annotation (
                Diagram(coordinateSystem(
                    preserveAspectRatio=true,
                    extent={{-100,-100},{100,100}},
                    grid={0.5,0.5}), graphics),
                Icon(coordinateSystem(
                    preserveAspectRatio=true,
                    extent={{-100,-100},{100,100}},
                    grid={0.5,0.5}), graphics),
                experiment(StopTime=2),
                __Dymola_Commands(
                  file="modelica://Modelica/Resources/Scripts/Dymola/Mechanics/MultiBody/Examples/Systems/Run.mos"
                  "Simulate",
                  file="modelica://Modelica/Resources/Scripts/Dymola/Mechanics/MultiBody/Examples/Systems/fullRobotPlot.mos"
                  "Plot result of axis 3 + animate"),
                Documentation(info="<HTML>
<p>
This is a detailed model of the robot. For animation CAD data
is used. Translate and simulate with the default settings
(default simulation time = 3 s). Use command script \"modelica://Modelica/Resources/Scripts/Dymola/Mechanics/MultiBody/Examples/Systems/fullRobotPlot.mos\"
to plot variables.
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Examples/Systems/r3_fullRobot.png\" ALT=\"model Examples.Loops.Systems.RobotR3.fullRobot\">

</HTML>"));
            end fullRobot;
            extends Modelica.Icons.ExamplesPackage;
            import SI = Modelica.SIunits;

            package Components "Library of components of the robot"
              extends Modelica.Icons.Package;

              expandable connector AxisControlBus "Data bus for one robot axis"
                extends Modelica.Icons.SignalSubBus;
                import SI = Modelica.SIunits;

                Boolean motion_ref "= true, if reference motion is not in rest"
                                                                                annotation(HideResult=false);
                SI.Angle angle_ref "Reference angle of axis flange" annotation(HideResult=false);
                SI.Angle angle "Angle of axis flange" annotation(HideResult=false);
                SI.AngularVelocity speed_ref "Reference speed of axis flange" annotation(HideResult=false);
                SI.AngularVelocity speed "Speed of axis flange" annotation(HideResult=false);
                SI.AngularAcceleration acceleration_ref
                "Reference acceleration of axis flange"   annotation(HideResult=false);
                SI.AngularAcceleration acceleration
                "Acceleration of axis flange"                                     annotation(HideResult=false);
                SI.Current current_ref "Reference current of motor" annotation(HideResult=false);
                SI.Current current "Current of motor" annotation(HideResult=false);
                SI.Angle motorAngle "Angle of motor flange" annotation(HideResult=false);
                SI.AngularVelocity motorSpeed "Speed of motor flange" annotation(HideResult=false);

                annotation (defaultComponentPrefixes="protected",
                            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                          -100},{100,100}}), graphics={Rectangle(
                        extent={{-20,2},{22,-2}},
                        lineColor={255,204,51},
                        lineThickness=0.5)}),
                  Documentation(info="<html>
<p>
Signal bus that is used to communicate all signals for <b>one</b> axis.
This is an expandable connector which has a \"default\" set of
signals. Note, the input/output causalities of the signals are
determined from the connections to this bus.
</p>

</html>"));
              end AxisControlBus;

              expandable connector ControlBus "Data bus for all axes of robot"
                extends Modelica.Icons.SignalBus;
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus1 "Bus of axis 1";
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus2 "Bus of axis 2";
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus3 "Bus of axis 3";
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus4 "Bus of axis 4";
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus5 "Bus of axis 5";
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus6 "Bus of axis 6";

                annotation (
                  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                          100,100}}), graphics={Rectangle(
                        extent={{-20,2},{22,-2}},
                        lineColor={255,204,51},
                        lineThickness=0.5)}),
                  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                          {100,100}}),
                          graphics),
                  Documentation(info="<html>
<p>
Signal bus that is used to communicate <b>all signals</b> of the robot.
This is an expandable connector which has a \"default\" set of
signals. Note, the input/output causalities of the signals are
determined from the connections to this bus.
</p>
</html>"));
              end ControlBus;

              model PathPlanning6
              "Generate reference angles for fastest kinematic movement"

                import SI = Modelica.SIunits;
                import Cv = Modelica.SIunits.Conversions;
                parameter Integer naxis=6 "number of driven axis";
                parameter Real angleBegDeg[naxis](unit="deg") = zeros(naxis)
                "Start angles";
                parameter Real angleEndDeg[naxis](unit="deg") = ones(naxis)
                "End angles";
                parameter SI.AngularVelocity speedMax[naxis]=fill(3, naxis)
                "Maximum axis speed";
                parameter SI.AngularAcceleration accMax[naxis]=fill(2.5, naxis)
                "Maximum axis acceleration";
                parameter SI.Time startTime=0 "Start time of movement";
                parameter SI.Time swingTime=0.5
                "Additional time after reference motion is in rest before simulation is stopped";
                final parameter SI.Angle angleBeg[:]=Cv.from_deg(angleBegDeg)
                "Start angles";
                final parameter SI.Angle angleEnd[:]=Cv.from_deg(angleEndDeg)
                "End angles";
                ControlBus controlBus
                  annotation (Placement(transformation(
                      origin={100,0},
                      extent={{-20,-20},{20,20}},
                      rotation=270)));
                Modelica.Blocks.Sources.KinematicPTP2 path(
                  q_end=angleEnd,
                  qd_max=speedMax,
                  qdd_max=accMax,
                  startTime=startTime,
                  q_begin=angleBeg) annotation (Placement(transformation(extent={{-90,-80},
                          {-70,-60}}, rotation=0)));
                PathToAxisControlBus pathToAxis1(nAxis=naxis, axisUsed=1)
                  annotation (Placement(transformation(extent={{-10,70},{10,90}},
                        rotation=0)));
                PathToAxisControlBus pathToAxis2(nAxis=naxis, axisUsed=2)
                  annotation (Placement(transformation(extent={{-10,40},{10,60}},
                        rotation=0)));
                PathToAxisControlBus pathToAxis3(nAxis=naxis, axisUsed=3)
                  annotation (Placement(transformation(extent={{-10,10},{10,30}},
                        rotation=0)));
                PathToAxisControlBus pathToAxis4(nAxis=naxis, axisUsed=4)
                  annotation (Placement(transformation(extent={{-10,-20},{10,0}},
                        rotation=0)));
                PathToAxisControlBus pathToAxis5(nAxis=naxis, axisUsed=5)
                  annotation (Placement(transformation(extent={{-10,-50},{10,-30}},
                        rotation=0)));
                PathToAxisControlBus pathToAxis6(nAxis=naxis, axisUsed=6)
                  annotation (Placement(transformation(extent={{-10,-80},{10,-60}},
                        rotation=0)));

                Blocks.Logical.TerminateSimulation terminateSimulation(condition=time >= path.endTime
                       + swingTime) annotation (Placement(transformation(extent={{-50,
                          -100},{30,-94}}, rotation=0)));
              equation
                connect(path.q, pathToAxis1.q)         annotation (Line(points={{-69,-62},
                        {-60,-62},{-60,88},{-12,88}}, color={0,0,127}));
                connect(path.qd, pathToAxis1.qd)         annotation (Line(points={{-69,
                        -67},{-59,-67},{-59,83},{-12,83}}, color={0,0,127}));
                connect(path.qdd, pathToAxis1.qdd)         annotation (Line(points={{-69,
                        -73},{-58,-73},{-58,77},{-12,77}}, color={0,0,127}));
                connect(path.moving, pathToAxis1.moving)             annotation (Line(
                      points={{-69,-78},{-57,-78},{-57,72},{-12,72}}, color={255,0,255}));
                connect(path.q, pathToAxis2.q)         annotation (Line(points={{-69,-62},
                        {-60,-62},{-60,58},{-12,58}}, color={0,0,127}));
                connect(path.qd, pathToAxis2.qd)         annotation (Line(points={{-69,
                        -67},{-59,-67},{-59,53},{-12,53}}, color={0,0,127}));
                connect(path.qdd, pathToAxis2.qdd)         annotation (Line(points={{-69,
                        -73},{-58,-73},{-58,47},{-12,47}}, color={0,0,127}));
                connect(path.moving, pathToAxis2.moving)             annotation (Line(
                      points={{-69,-78},{-57,-78},{-57,42},{-12,42}}, color={255,0,255}));
                connect(path.q, pathToAxis3.q)         annotation (Line(points={{-69,-62},
                        {-60,-62},{-60,28},{-12,28}}, color={0,0,127}));
                connect(path.qd, pathToAxis3.qd)         annotation (Line(points={{-69,
                        -67},{-59,-67},{-59,23},{-12,23}}, color={0,0,127}));
                connect(path.qdd, pathToAxis3.qdd)         annotation (Line(points={{-69,
                        -73},{-58,-73},{-58,17},{-12,17}}, color={0,0,127}));
                connect(path.moving, pathToAxis3.moving)             annotation (Line(
                      points={{-69,-78},{-57,-78},{-57,12},{-12,12}}, color={255,0,255}));
                connect(path.q, pathToAxis4.q)         annotation (Line(points={{-69,-62},
                        {-60,-62},{-60,-2},{-12,-2}}, color={0,0,127}));
                connect(path.qd, pathToAxis4.qd)         annotation (Line(points={{-69,
                        -67},{-59,-67},{-59,-7},{-12,-7}}, color={0,0,127}));
                connect(path.qdd, pathToAxis4.qdd)         annotation (Line(points={{-69,
                        -73},{-58,-73},{-58,-13},{-12,-13}}, color={0,0,127}));
                connect(path.moving, pathToAxis4.moving)             annotation (Line(
                      points={{-69,-78},{-57,-78},{-57,-18},{-12,-18}}, color={255,0,255}));
                connect(path.q, pathToAxis5.q)         annotation (Line(points={{-69,-62},
                        {-60,-62},{-60,-32},{-12,-32}}, color={0,0,127}));
                connect(path.qd, pathToAxis5.qd)         annotation (Line(points={{-69,
                        -67},{-59,-67},{-59,-37},{-12,-37}}, color={0,0,127}));
                connect(path.qdd, pathToAxis5.qdd)         annotation (Line(points={{-69,
                        -73},{-58,-73},{-58,-43},{-12,-43}}, color={0,0,127}));
                connect(path.moving, pathToAxis5.moving)             annotation (Line(
                      points={{-69,-78},{-57,-78},{-57,-48},{-12,-48}}, color={255,0,255}));
                connect(path.q, pathToAxis6.q)         annotation (Line(points={{-69,-62},
                        {-12,-62}}, color={0,0,127}));
                connect(path.qd, pathToAxis6.qd)         annotation (Line(points={{-69,
                        -67},{-12,-67}}, color={0,0,127}));
                connect(path.qdd, pathToAxis6.qdd)         annotation (Line(points={{-69,
                        -73},{-12,-73}}, color={0,0,127}));
                connect(path.moving, pathToAxis6.moving)             annotation (Line(
                      points={{-69,-78},{-12,-78}}, color={255,0,255}));
                connect(pathToAxis1.axisControlBus, controlBus.axisControlBus1) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(
                    points={{10,80},{80,80},{80,7},{98,7}},
                    color={255,204,51},
                    thickness=0.5));
                connect(pathToAxis2.axisControlBus, controlBus.axisControlBus2) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(
                    points={{10,50},{77,50},{77,5},{97,5}},
                    color={255,204,51},
                    thickness=0.5));
                connect(pathToAxis3.axisControlBus, controlBus.axisControlBus3) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(
                    points={{10,20},{75,20},{75,3},{96,3}},
                    color={255,204,51},
                    thickness=0.5));
                connect(pathToAxis4.axisControlBus, controlBus.axisControlBus4) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(
                    points={{10,-10},{73,-10},{73,0},{100,0}},
                    color={255,204,51},
                    thickness=0.5));
                connect(pathToAxis5.axisControlBus, controlBus.axisControlBus5) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(
                    points={{10,-40},{75,-40},{75,-3},{100,-3},{100,0}},
                    color={255,204,51},
                    thickness=0.5));
                connect(pathToAxis6.axisControlBus, controlBus.axisControlBus6) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(
                    points={{10,-70},{78,-70},{78,-6},{98,-6}},
                    color={255,204,51},
                    thickness=0.5));
                annotation (
                  Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics={
                      Rectangle(
                        extent={{-100,100},{100,-100}},
                        lineColor={0,0,0},
                        fillColor={255,255,255},
                        fillPattern=FillPattern.Solid),
                      Text(
                        extent={{-150,150},{150,110}},
                        textString="%name",
                        lineColor={0,0,255}),
                      Polygon(
                        points={{-80,90},{-88,68},{-72,68},{-80,88},{-80,90}},
                        lineColor={192,192,192},
                        fillColor={192,192,192},
                        fillPattern=FillPattern.Solid),
                      Line(points={{-80,78},{-80,-82}}, color={192,192,192}),
                      Line(points={{-90,0},{82,0}}, color={192,192,192}),
                      Polygon(
                        points={{90,0},{68,8},{68,-8},{90,0}},
                        lineColor={192,192,192},
                        fillColor={192,192,192},
                        fillPattern=FillPattern.Solid),
                      Text(
                        extent={{-42,55},{29,12}},
                        lineColor={192,192,192},
                        textString="w"),
                      Line(points={{-80,0},{-41,69},{26,69},{58,0}}, color={0,0,0}),
                      Text(
                        extent={{-70,-43},{85,-68}},
                        lineColor={0,0,0},
                        textString="6 axes")}),
                  Documentation(info="<html>
<p>
Given
</p>
<ul>
<li> start and end angles of every axis</li>
<li> maximum speed of every axis </li>
<li> maximum acceleration of every axis </li>
</ul>

<p>
this component computes the fastest movement under the
given constraints. This means, that:
</p>

<ol>
<li> Every axis accelerates with the maximum acceleration
     until the maximum speed is reached.</li>
<li> Drives with the maximum speed as long as possible.</li>
<li> Decelerates with the negative of the maximum acceleration
     until rest.</li>
</ol>

<p>
The acceleration, constant velocity and deceleration
phase are determined in such a way that the movement
starts form the start angles and ends at the end angles.
The output of this block are the computed angles, angular velocities
and angular acceleration and this information is stored as reference
motion on the controlBus of the r3 robot.
</p>

</html>"),        Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics));
              end PathPlanning6;

              model PathToAxisControlBus
              "Map path planning to one axis control bus"
                extends Blocks.Interfaces.BlockIcon;

                parameter Integer nAxis=6 "Number of driven axis";
                parameter Integer axisUsed=1
                "Map path planning of axisUsed to axisControlBus";
                Blocks.Interfaces.RealInput q[nAxis]
                  annotation (Placement(transformation(extent={{-140,60},{-100,100}},
                        rotation=0)));
                Blocks.Interfaces.RealInput qd[nAxis]
                  annotation (Placement(transformation(extent={{-140,10},{-100,50}},
                        rotation=0)));
                Blocks.Interfaces.RealInput qdd[nAxis]
                  annotation (Placement(transformation(extent={{-140,-50},{-100,-10}},
                        rotation=0)));
                AxisControlBus axisControlBus
                  annotation (Placement(transformation(
                      origin={100,0},
                      extent={{-20,-20},{20,20}},
                      rotation=270)));
                Blocks.Routing.RealPassThrough q_axisUsed
                  annotation (Placement(transformation(extent={{-40,50},{-20,70}},
                        rotation=0)));
                Blocks.Routing.RealPassThrough qd_axisUsed
                  annotation (Placement(transformation(extent={{-40,10},{-20,30}},
                        rotation=0)));
                Blocks.Routing.RealPassThrough qdd_axisUsed
                  annotation (Placement(transformation(extent={{-40,-30},{-20,-10}},
                        rotation=0)));
                Blocks.Interfaces.BooleanInput moving[nAxis]
                  annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
                        rotation=0)));
                Blocks.Routing.BooleanPassThrough motion_ref_axisUsed
                  annotation (Placement(transformation(extent={{-40,-70},{-20,-50}},
                        rotation=0)));
              equation
                connect(q_axisUsed.u, q[axisUsed]) annotation (Line(points={{-42,60},{-60,
                        60},{-60,80},{-120,80}}, color={0,0,127}));
                connect(qd_axisUsed.u, qd[axisUsed]) annotation (Line(points={{-42,20},{
                        -80,20},{-80,30},{-120,30}}, color={0,0,127}));
                connect(qdd_axisUsed.u, qdd[axisUsed]) annotation (Line(points={{-42,-20},
                        {-80,-20},{-80,-30},{-120,-30}}, color={0,0,127}));
                connect(motion_ref_axisUsed.u, moving[axisUsed])     annotation (Line(
                      points={{-42,-60},{-60,-60},{-60,-80},{-120,-80}}, color={255,0,255}));
                connect(motion_ref_axisUsed.y, axisControlBus.motion_ref) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{-19,-60},{44,-60},{
                        44,-8},{102,-8},{102,0},{100,0}}, color={255,0,255}));
                connect(qdd_axisUsed.y, axisControlBus.acceleration_ref) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{-19,-20},{40,-20},{
                        40,-4},{98,-4},{98,0},{100,0}}, color={0,0,127}));
                connect(qd_axisUsed.y, axisControlBus.speed_ref) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{-19,20},{20,20},{20,
                        0},{100,0}}, color={0,0,127}));
                connect(q_axisUsed.y, axisControlBus.angle_ref) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{-19,60},{40,60},{40,
                        4},{96,4}}, color={0,0,127}));
                annotation (defaultComponentName="pathToAxis1",
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={2,2},
                      initialScale=0.1), graphics),
                  Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={2,2},
                      initialScale=0.1), graphics={
                      Text(
                        extent={{-100,98},{-24,68}},
                        lineColor={0,0,0},
                        textString="q"),
                      Text(
                        extent={{-94,46},{-18,16}},
                        lineColor={0,0,0},
                        textString="qd"),
                      Text(
                        extent={{-96,-16},{-20,-46}},
                        lineColor={0,0,0},
                        textString="qdd"),
                      Text(
                        extent={{-2,20},{80,-18}},
                        lineColor={0,0,0},
                        textString="%axisUsed"),
                      Text(
                        extent={{2,52},{76,28}},
                        lineColor={0,0,0},
                        textString="axis"),
                      Text(
                        extent={{-94,-70},{32,-96}},
                        lineColor={0,0,0},
                        textString="moving")}));
              end PathToAxisControlBus;

              model GearType1
              "Motor inertia and gearbox model for r3 joints 1,2,3 "
                extends
                Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
                parameter Real i=-105 "gear ratio";
                parameter Real c(unit="N.m/rad") = 43 "Spring constant";
                parameter Real d(unit="N.m.s/rad") = 0.005 "Damper constant";
                parameter SI.Torque Rv0=0.4
                "Viscous friction torque at zero velocity";
                parameter Real Rv1(unit="N.m.s/rad") = (0.13/160)
                "Viscous friction coefficient (R=Rv0+Rv1*abs(qd))";
                parameter Real peak=1
                "Maximum static friction torque is peak*Rv0 (peak >= 1)";
                SI.AngularAcceleration a_rel=der(spring.w_rel)
                "Relative angular acceleration of spring";
                constant SI.AngularVelocity unitAngularVelocity = 1;
                constant SI.Torque unitTorque = 1;

                Modelica.Mechanics.Rotational.Components.IdealGear gear(
                                                             ratio=i, useSupport=false)
                  annotation (Placement(transformation(extent={{50,-10},{70,10}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Components.SpringDamper spring(
                                                                  c=c, d=d)
                  annotation (Placement(transformation(extent={{0,-10},{20,10}}, rotation=
                         0)));
                Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction(
                                                                              tau_pos=[0,
                       Rv0/unitTorque; 1, (Rv0 + Rv1*unitAngularVelocity)/unitTorque],
                    useSupport=false)                                                  annotation (Placement(
                      transformation(extent={{-60,-10},{-40,10}}, rotation=0)));
              equation
                connect(spring.flange_b, gear.flange_a)
                  annotation (Line(
                    points={{20,0},{50,0}},
                    color={128,128,128},
                    thickness=0.5));
                connect(bearingFriction.flange_b, spring.flange_a)
                  annotation (Line(
                    points={{-40,0},{0,0}},
                    color={128,128,128},
                    thickness=0.5));
                connect(gear.flange_b, flange_b)
                  annotation (Line(
                    points={{70,0},{100,0}},
                    color={128,128,128},
                    thickness=0.5));
                connect(bearingFriction.flange_a, flange_a)
                  annotation (Line(
                    points={{-60,0},{-100,0}},
                    color={128,128,128},
                    thickness=0.5));
              initial equation
                spring.w_rel = 0;
                a_rel = 0;
                annotation (
                  Documentation(info="<html>
<p>
Models the gearbox used in the first three joints with all its effects,
like elasticity and friction.
Coulomb friction is approximated by a friction element acting
at the \"motor\"-side. In reality, bearing friction should be
also incorporated at the driven side of the gearbox. However,
this would require considerable more effort for the measurement
of the friction parameters.
Default values for all parameters are given for joint 1.
Model relativeStates is used to define the relative angle
and relative angular velocity across the spring (=gear elasticity)
as state variables. The reason is, that a default initial
value of zero of these states makes always sense.
If the absolute angle and the absolute angular velocity of model
Jmotor would be used as states, and the load angle (= joint angle of
robot) is NOT zero, one has always to ensure that the initial values
of the motor angle and of the joint angle are modified correspondingly.
Otherwise, the spring has an unrealistic deflection at initial time.
Since relative quantities are used as state variables, this simplifies
the definition of initial values considerably.
</p>
</html>
"),               Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={2,2}), graphics={
                      Rectangle(
                        extent={{-100,10},{-60,-10}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={192,192,192}),
                      Polygon(
                        points={{-60,10},{-60,20},{-40,40},{-40,-40},{-60,-20},{-60,10}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={128,128,128}),
                      Rectangle(
                        extent={{-40,60},{40,-60}},
                        lineColor={0,0,0},
                        pattern=LinePattern.Solid,
                        lineThickness=0.25,
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={192,192,192}),
                      Polygon(
                        points={{60,20},{40,40},{40,-40},{60,-20},{60,20}},
                        lineColor={128,128,128},
                        fillColor={128,128,128},
                        fillPattern=FillPattern.Solid),
                      Rectangle(
                        extent={{60,10},{100,-10}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={192,192,192}),
                      Polygon(
                        points={{-60,-90},{-50,-90},{-20,-30},{20,-30},{48,-90},{60,-90},
                            {60,-100},{-60,-100},{-60,-90}},
                        lineColor={0,0,0},
                        fillColor={0,0,0},
                        fillPattern=FillPattern.Solid),
                      Text(
                        extent={{0,128},{0,68}},
                        textString="%name",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-36,40},{36,-30}},
                        textString="1",
                        lineColor={0,0,255})}),
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={2,2}), graphics={Text(
                        extent={{72,30},{130,22}},
                        lineColor={0,0,0},
                        textString="flange of joint axis"), Text(
                        extent={{-128,26},{-70,18}},
                        lineColor={0,0,0},
                        textString="flange of motor axis")}));
              end GearType1;

              model GearType2
              "Motor inertia and gearbox model for r3 joints 4,5,6  "
                extends
                Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
                parameter Real i=-99 "Gear ratio";
                parameter SI.Torque Rv0=21.8
                "Viscous friction torque at zero velocity";
                parameter Real Rv1=9.8
                "Viscous friction coefficient in [Nms/rad] (R=Rv0+Rv1*abs(qd))";
                parameter Real peak=(26.7/21.8)
                "Maximum static friction torque is peak*Rv0 (peak >= 1)";

                constant SI.AngularVelocity unitAngularVelocity = 1;
                constant SI.Torque unitTorque = 1;
                Modelica.Mechanics.Rotational.Components.IdealGear gear(
                                                             ratio=i, useSupport=false)
                  annotation (Placement(transformation(extent={{-28,-10},{-8,10}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction(
                                                                              tau_pos=[0,
                       Rv0/unitTorque; 1, (Rv0 + Rv1*unitAngularVelocity)/unitTorque], peak=peak,
                  useSupport=false)
                  annotation (Placement(transformation(extent={{30,-10},{50,10}},
                        rotation=0)));
              equation
                connect(gear.flange_b, bearingFriction.flange_a)
                  annotation (Line(
                    points={{-8,0},{30,0}},
                    color={128,128,128},
                    thickness=0.5));
                connect(bearingFriction.flange_b, flange_b)
                  annotation (Line(
                    points={{50,0},{100,0}},
                    color={128,128,128},
                    thickness=0.5));
                connect(gear.flange_a, flange_a)
                  annotation (Line(
                    points={{-28,0},{-100,0}},
                    color={128,128,128},
                    thickness=0.5));
                annotation (
                  Documentation(info="<html>
<p>
The elasticity and damping in the gearboxes of the outermost
three joints of the robot is neglected.
Default values for all parameters are given for joint 4.
</p>
</html>
"),               Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={2,2}), graphics={
                      Rectangle(
                        extent={{-100,10},{-60,-10}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={192,192,192}),
                      Polygon(
                        points={{-60,10},{-60,20},{-40,40},{-40,-40},{-60,-20},{-60,10}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={128,128,128}),
                      Rectangle(
                        extent={{-40,60},{40,-60}},
                        lineColor={0,0,0},
                        pattern=LinePattern.Solid,
                        lineThickness=0.25,
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={192,192,192}),
                      Polygon(
                        points={{60,20},{40,40},{40,-40},{60,-20},{60,20}},
                        lineColor={128,128,128},
                        fillColor={128,128,128},
                        fillPattern=FillPattern.Solid),
                      Rectangle(
                        extent={{60,10},{100,-10}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={192,192,192}),
                      Polygon(
                        points={{-60,-90},{-50,-90},{-20,-30},{20,-30},{48,-90},{60,-90},
                            {60,-100},{-60,-100},{-60,-90}},
                        lineColor={0,0,0},
                        fillColor={0,0,0},
                        fillPattern=FillPattern.Solid),
                      Text(
                        extent={{0,128},{0,68}},
                        textString="%name",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-36,40},{38,-30}},
                        textString="2",
                        lineColor={0,0,255})}),
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={2,2}), graphics));
              end GearType2;

              model Motor
              "Motor model including current controller of r3 motors "
                extends Modelica.Icons.MotorIcon;
                parameter SI.Inertia J(min=0)=0.0013
                "Moment of inertia of motor";
                parameter Real k=1.1616 "Gain of motor";
                parameter Real w=4590 "Time constant of motor";
                parameter Real D=0.6 "Damping constant of motor";
                parameter SI.AngularVelocity w_max=315 "Maximum speed of motor";
                parameter SI.Current i_max=9 "Maximum current of motor";

                Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_motor
                  annotation (Placement(transformation(extent={{90,-10},{110,10}},
                        rotation=0)));
                Modelica.Electrical.Analog.Sources.SignalVoltage Vs
                  annotation (Placement(transformation(
                      origin={-90,0},
                      extent={{-10,10},{10,-10}},
                      rotation=270)));
                Modelica.Electrical.Analog.Ideal.IdealOpAmp diff
                  annotation (Placement(transformation(extent={{-64,15},{-44,35}},
                        rotation=0)));
                Modelica.Electrical.Analog.Ideal.IdealOpAmp power
                  annotation (Placement(transformation(extent={{16,15},{36,35}}, rotation=
                         0)));
                Electrical.Analog.Basic.EMF emf( k=k, useSupport=false)
                  annotation (Placement(transformation(extent={{46,-10},{66,10}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Inductor La(L=(250/(2*D*w)))
                  annotation (Placement(transformation(
                      origin={56,30},
                      extent={{-10,-10},{10,10}},
                      rotation=270)));
                Modelica.Electrical.Analog.Basic.Resistor Ra(R=250)
                  annotation (Placement(transformation(
                      origin={56,60},
                      extent={{-10,-10},{10,10}},
                      rotation=270)));
                Modelica.Electrical.Analog.Basic.Resistor Rd2(R=100)
                  annotation (Placement(transformation(extent={{-86,22},{-71,38}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Capacitor C(C=0.004*D/w)
                  annotation (Placement(transformation(extent={{-14,36},{6,56}}, rotation=
                         0)));
                Modelica.Electrical.Analog.Ideal.IdealOpAmp OpI
                  annotation (Placement(transformation(extent={{-14,10},{6,30}}, rotation=
                         0)));
                Modelica.Electrical.Analog.Basic.Resistor Rd1(R=100)
                  annotation (Placement(transformation(extent={{-63,37},{-48,53}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Resistor Ri(R=10)
                  annotation (Placement(transformation(extent={{-37,17},{-22,33}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Resistor Rp1(R=200)
                  annotation (Placement(transformation(extent={{17,38},{32,54}}, rotation=
                         0)));
                Modelica.Electrical.Analog.Basic.Resistor Rp2(R=50)
                  annotation (Placement(transformation(
                      origin={11,72},
                      extent={{-8,-7},{8,7}},
                      rotation=90)));
                Modelica.Electrical.Analog.Basic.Resistor Rd4(R=100)
                  annotation (Placement(transformation(extent={{-55,-15},{-40,1}},
                        rotation=0)));
                Modelica.Electrical.Analog.Sources.SignalVoltage hall2
                  annotation (Placement(transformation(
                      origin={-70,-50},
                      extent={{-10,10},{10,-10}},
                      rotation=90)));
                Modelica.Electrical.Analog.Basic.Resistor Rd3(R=100)
                  annotation (Placement(transformation(
                      origin={-70,-22},
                      extent={{-8,-7},{8,7}},
                      rotation=90)));
                Modelica.Electrical.Analog.Basic.Ground g1
                  annotation (Placement(transformation(extent={{-100,-37},{-80,-17}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Ground g2
                  annotation (Placement(transformation(extent={{-80,-91},{-60,-71}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Ground g3
                  annotation (Placement(transformation(extent={{-34,-27},{-14,-7}},
                        rotation=0)));
                Modelica.Electrical.Analog.Sensors.CurrentSensor hall1
                  annotation (Placement(transformation(
                      origin={16,-50},
                      extent={{-10,-10},{10,10}},
                      rotation=270)));
                Modelica.Electrical.Analog.Basic.Ground g4
                  annotation (Placement(transformation(extent={{6,-84},{26,-64}},
                        rotation=0)));
                Modelica.Electrical.Analog.Basic.Ground g5
                  annotation (Placement(transformation(
                      origin={11,93},
                      extent={{-10,-10},{10,10}},
                      rotation=180)));
                Modelica.Mechanics.Rotational.Sensors.AngleSensor phi
                  annotation (Placement(transformation(
                      origin={76,-40},
                      extent={{-10,-10},{10,10}},
                      rotation=270)));
                Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
                  annotation (Placement(transformation(
                      origin={55,-40},
                      extent={{-10,-10},{10,10}},
                      rotation=270)));
                Modelica.Mechanics.Rotational.Components.Inertia Jmotor(
                                                             J=J)
                  annotation (Placement(transformation(extent={{70,-10},{90,10}},
                        rotation=0)));
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus
                  annotation (Placement(transformation(extent={{60,-120},{100,-80}},
                        rotation=0)));
                Blocks.Math.Gain convert1(k=1)
                                          annotation (Placement(transformation(extent={{
                          -30,-56},{-42,-44}}, rotation=0)));
                Blocks.Math.Gain convert2(k=1)
                                          annotation (Placement(transformation(extent={{
                          -30,-101},{-42,-89}}, rotation=0)));
              initial equation
                // initialize motor in steady state
                der(C.v) = 0;
                der(La.i) = 0;

              equation
                connect(La.n, emf.p) annotation (Line(points={{56,20},{56,15},{56,10}}));
                connect(Ra.n, La.p) annotation (Line(points={{56,50},{56,40}}));
                connect(Rd2.n, diff.n1) annotation (Line(points={{-71,30},{-64,30}}));
                connect(C.n, OpI.p2) annotation (Line(points={{6,46},{6,20}}));
                connect(OpI.p2, power.p1) annotation (Line(points={{6,20},{16,20}}));
                connect(Vs.p, Rd2.p) annotation (Line(points={{-90,10},{-90,30},{-86,30}}));
                connect(diff.n1, Rd1.p)
                  annotation (Line(points={{-64,30},{-68,30},{-68,45},{-63,45}}));
                connect(Rd1.n, diff.p2) annotation (Line(points={{-48,45},{-44,45},{-44,
                        25}}));
                connect(diff.p2, Ri.p) annotation (Line(points={{-44,25},{-37,25}}));
                connect(Ri.n, OpI.n1) annotation (Line(points={{-22,25},{-14,25}}));
                connect(OpI.n1, C.p) annotation (Line(points={{-14,25},{-14,46}}));
                connect(power.n1, Rp1.p)
                  annotation (Line(points={{16,30},{11,30},{11,46},{17,46}}));
                connect(power.p2, Rp1.n) annotation (Line(points={{36,25},{36,46},{32,46}}));
                connect(Rp1.p, Rp2.p) annotation (Line(points={{17,46},{11,46},{11,64}}));
                connect(power.p2, Ra.p)
                  annotation (Line(points={{36,25},{42,25},{42,80},{56,80},{56,70}}));
                connect(Rd3.p, hall2.p) annotation (Line(points={{-70,-30},{-70,-60}}));
                connect(Rd3.n, diff.p1) annotation (Line(points={{-70,-14},{-70,20},{-64,
                        20}}));
                connect(Rd3.n, Rd4.p) annotation (Line(points={{-70,-14},{-70,-7},{-55,-7}}));
                connect(Vs.n, g1.p) annotation (Line(points={{-90,-10},{-90,-17}}));
                connect(g2.p, hall2.n) annotation (Line(points={{-70,-71},{-70,-40}}));
                connect(Rd4.n, g3.p) annotation (Line(points={{-40,-7},{-24,-7}}));
                connect(g3.p, OpI.p1) annotation (Line(points={{-24,-7},{-24,15},{-14,15}}));
                connect(g5.p, Rp2.n)
                  annotation (Line(points={{11,83},{11,81.5},{11,81.5},{11,80}}));
                connect(emf.n, hall1.p)
                  annotation (Line(points={{56,-10},{56,-24},{16,-24},{16,-40}}));
                connect(hall1.n, g4.p) annotation (Line(points={{16,-60},{16,-62},{16,-62},
                        {16,-64}}));
                connect(emf.flange, phi.flange)
                  annotation (Line(points={{66,0},{66,-30},{76,-30}}, pattern=LinePattern.Dot));
                connect(emf.flange, speed.flange)
                  annotation (Line(points={{66,0},{66,-30},{55,-30}}, pattern=LinePattern.Dot));
                connect(OpI.n2, power.n2)
                  annotation (Line(points={{-4,10},{-4,4},{26,4},{26,15}}));
                connect(OpI.p1, OpI.n2) annotation (Line(points={{-14,15},{-14,10},{-4,10}}));
                connect(OpI.p1, diff.n2) annotation (Line(points={{-14,15},{-54,15}}));
                connect(Jmotor.flange_b, flange_motor)
                  annotation (Line(
                    points={{90,0},{100,0}},
                    color={128,128,128},
                    thickness=0.5));
                connect(phi.phi, axisControlBus.motorAngle)
                                                 annotation (Line(points={{76,-51},{76,
                        -100},{80,-100}}, color={0,0,127}));
                connect(speed.w, axisControlBus.motorSpeed)
                                                 annotation (Line(points={{55,-51},{55,
                        -95},{80,-95},{80,-100}}, color={0,0,127}));
                connect(hall1.i, axisControlBus.current)
                                              annotation (Line(points={{6,-50},{-10,-50},
                        {-10,-95},{80,-95},{80,-100}}, color={0,0,127}));
                connect(hall1.i, convert1.u) annotation (Line(points={{6,-50},{-28.8,-50}},
                      color={0,0,127}));
                connect(convert1.y, hall2.v) annotation (Line(points={{-42.6,-50},{-63,-50}},
                               color={0,0,127}));
                connect(convert2.u, axisControlBus.current_ref)
                                                     annotation (Line(points={{-28.8,-95},
                        {80,-95},{80,-100}}, color={0,0,127}));
                connect(convert2.y, Vs.v) annotation (Line(points={{-42.6,-95},{-108,-95},
                        {-108,1.28588e-015},{-97,1.28588e-015}}, color={0,0,127}));
                connect(emf.flange, Jmotor.flange_a) annotation (Line(
                    points={{66,0},{70,0}},
                    color={0,0,0},
                    smooth=Smooth.None));
                annotation (
                  Documentation(info="<html>
<p>
Default values are given for the motor of joint 1.
The input of the motor is the desired current
(the actual current is proportional to the torque
produced by the motor).
</p>
</html>
"),               Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics={Text(
                        extent={{0,120},{0,60}},
                        textString="%name",
                        lineColor={0,0,255}), Line(
                        points={{80,-102},{80,-10}},
                        color={255,204,51},
                        thickness=0.5)}),
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics));
              end Motor;

              model Controller "P-PI cascade controller for one axis"
                parameter Real kp=10 "Gain of position controller";
                parameter Real ks=1 "Gain of speed controller";
                parameter SI.Time Ts=0.01
                "Time constant of integrator of speed controller";
                parameter Real ratio=1 "Gear ratio of gearbox";

                Modelica.Blocks.Math.Gain gain1(k=ratio)
                  annotation (Placement(transformation(extent={{-70,0},{-50,20}},
                        rotation=0)));
                Modelica.Blocks.Continuous.PI PI(k=ks, T=Ts)
                  annotation (Placement(transformation(extent={{60,0},{80,20}}, rotation=
                          0)));
                Modelica.Blocks.Math.Feedback feedback1
                  annotation (Placement(transformation(extent={{-46,0},{-26,20}},
                        rotation=0)));
                Modelica.Blocks.Math.Gain P(k=kp) annotation (Placement(transformation(
                        extent={{-16,0},{4,20}}, rotation=0)));
                Modelica.Blocks.Math.Add3 add3(k3=-1) annotation (Placement(
                      transformation(extent={{20,0},{40,20}}, rotation=0)));
                Modelica.Blocks.Math.Gain gain2(k=ratio)
                  annotation (Placement(transformation(extent={{-60,40},{-40,60}},
                        rotation=0)));
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus
                  annotation (Placement(transformation(extent={{-20,-120},{20,-80}},
                        rotation=0)));
              equation
                connect(gain1.y, feedback1.u1)
                  annotation (Line(points={{-49,10},{-44,10}}, color={0,0,127}));
                connect(feedback1.y, P.u)
                  annotation (Line(points={{-27,10},{-18,10}}, color={0,0,127}));
                connect(P.y, add3.u2) annotation (Line(points={{5,10},{18,10}}, color={0,
                        0,127}));
                connect(gain2.y, add3.u1)
                  annotation (Line(points={{-39,50},{10,50},{10,18},{18,18}}, color={0,0,
                        127}));
                connect(add3.y, PI.u)
                  annotation (Line(points={{41,10},{58,10}}, color={0,0,127}));
                connect(gain2.u, axisControlBus.speed_ref)
                                                annotation (Line(points={{-62,50},{-90,50},
                        {-90,-100},{0,-100}}, color={0,0,127}));
                connect(gain1.u, axisControlBus.angle_ref)
                                                annotation (Line(points={{-72,10},{-80,10},
                        {-80,-100},{0,-100}}, color={0,0,127}));
                connect(feedback1.u2, axisControlBus.motorAngle)
                                                      annotation (Line(points={{-36,2},{
                        -36,-100},{0,-100}}, color={0,0,127}));
                connect(add3.u3, axisControlBus.motorSpeed)
                                                 annotation (Line(points={{18,2},{0,2},{0,
                        -100}}, color={0,0,127}));
                connect(PI.y, axisControlBus.current_ref)
                                               annotation (Line(points={{81,10},{90,10},{
                        90,-100},{0,-100}}, color={0,0,127}));
                annotation (
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics),
                  Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics={
                      Rectangle(
                        extent={{-100,-100},{100,100}},
                        lineColor={0,0,0},
                        pattern=LinePattern.Solid,
                        lineThickness=0.25,
                        fillColor={235,235,235},
                        fillPattern=FillPattern.Solid),
                      Rectangle(
                        extent={{-30,54},{30,24}},
                        fillColor={255,255,255},
                        fillPattern=FillPattern.Solid,
                        lineColor={0,0,255}),
                      Polygon(
                        points={{-30,40},{-60,50},{-60,30},{-30,40}},
                        lineColor={0,0,255},
                        fillColor={0,0,255},
                        fillPattern=FillPattern.Solid),
                      Line(points={{-31,-41},{-78,-41},{-78,39},{-30,39}}, color={0,0,255}),
                      Rectangle(
                        extent={{-30,-26},{30,-56}},
                        fillColor={255,255,255},
                        fillPattern=FillPattern.Solid,
                        lineColor={0,0,255}),
                      Polygon(
                        points={{60,-32},{30,-42},{60,-52},{60,-32}},
                        fillColor={0,0,255},
                        fillPattern=FillPattern.Solid,
                        lineColor={0,0,255}),
                      Line(points={{30,39},{76,39},{76,-41},{30,-41}}, color={0,0,255}),
                      Text(
                        extent={{-100,150},{100,110}},
                        textString="%name",
                        lineColor={0,0,255})}),
                  Documentation(info="<html>
<p>
This controller has an inner PI-controller to control the motor speed,
and an outer P-controller to control the motor position of one axis.
The reference signals are with respect to the gear-output, and the
gear ratio is used in the controller to determine the motor
reference signals. All signals are communicated via the
\"axisControlBus\".
</p>
</html>"));
              end Controller;

              model AxisType1 "Axis model of the r3 joints 1,2,3 "
                extends AxisType2(redeclare GearType1 gear(c=c, d=cd));
                parameter Real c(unit="N.m/rad") = 43 "Spring constant"
                  annotation (Dialog(group="Gear"));
                parameter Real cd(unit="N.m.s/rad") = 0.005 "Damper constant"
                  annotation (Dialog(group="Gear"));
              end AxisType1;

              model AxisType2 "Axis model of the r3 joints 4,5,6 "
                parameter Real kp=10 "Gain of position controller"
                  annotation (Dialog(group="Controller"));
                parameter Real ks=1 "Gain of speed controller"
                  annotation (Dialog(group="Controller"));
                parameter SI.Time Ts=0.01
                "Time constant of integrator of speed controller"
                  annotation (Dialog(group="Controller"));
                parameter Real k=1.1616 "Gain of motor"
                  annotation (Dialog(group="Motor"));
                parameter Real w=4590 "Time constant of motor"
                  annotation (Dialog(group="Motor"));
                parameter Real D=0.6 "Damping constant of motor"
                  annotation (Dialog(group="Motor"));
                parameter SI.Inertia J(min=0) = 0.0013
                "Moment of inertia of motor"
                  annotation (Dialog(group="Motor"));
                parameter Real ratio=-105 "Gear ratio"  annotation (Dialog(group="Gear"));
                parameter SI.Torque Rv0=0.4
                "Viscous friction torque at zero velocity in [Nm]"
                  annotation (Dialog(group="Gear"));
                parameter Real Rv1(unit="N.m.s/rad") = (0.13/160)
                "Viscous friction coefficient in [Nms/rad]"
                  annotation (Dialog(group="Gear"));
                parameter Real peak=1
                "Maximum static friction torque is peak*Rv0 (peak >= 1)"
                  annotation (Dialog(group="Gear"));

                Modelica.Mechanics.Rotational.Interfaces.Flange_b flange
                  annotation (Placement(transformation(extent={{90,-10},{110,10}},
                        rotation=0)));
                replaceable GearType2 gear(
                  Rv0=Rv0,
                  Rv1=Rv1,
                  peak=peak,
                  i=ratio) annotation (Placement(transformation(extent={{0,-10},{20,10}},
                        rotation=0)));
                Motor motor(
                  J=J,
                  k=k,
                  w=w,
                  D=D) annotation (Placement(transformation(extent={{-30,-10},{-10,10}},
                        rotation=0)));
                RobotR3.Components.Controller controller(
                  kp=kp,
                  ks=ks,
                  Ts=Ts,
                  ratio=ratio) annotation (Placement(transformation(extent={{-70,-10},{
                          -50,10}}, rotation=0)));
                Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus
                  axisControlBus
                  annotation (Placement(transformation(
                      origin={-100,0},
                      extent={{-20,-20},{20,20}},
                      rotation=270)));
                Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
                  annotation (Placement(transformation(extent={{30,60},{50,80}}, rotation=
                         0)));
                Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor
                  annotation (Placement(transformation(
                      origin={40,50},
                      extent={{10,10},{-10,-10}},
                      rotation=180)));
                Modelica.Mechanics.Rotational.Sensors.AccSensor accSensor
                  annotation (Placement(transformation(extent={{30,20},{50,40}}, rotation=
                         0)));
                Modelica.Mechanics.Rotational.Components.InitializeFlange
                  initializeFlange(                          stateSelect=StateSelect.prefer)
                  annotation (Placement(transformation(extent={{-40,-60},{-20,-40}},
                        rotation=0)));
                Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(
                        extent={{-65,-65},{-55,-55}}, rotation=0)));
              equation
                connect(gear.flange_b, flange)
                  annotation (Line(points={{20,0},{100,0}}, color={0,0,0}));
                connect(gear.flange_b, angleSensor.flange)
                  annotation (Line(points={{20,0},{20,70},{30,70}}, color={0,0,0}));
                connect(gear.flange_b, speedSensor.flange)
                  annotation (Line(points={{20,0},{24,0},{24,50},{30,50}}, color={0,0,0}));
                connect(motor.flange_motor, gear.flange_a)
                  annotation (Line(points={{-10,0},{0,0}}, color={0,0,0}));
                connect(gear.flange_b, accSensor.flange)
                  annotation (Line(points={{20,0},{28,0},{28,30},{30,30}}, color={0,0,0}));
                connect(controller.axisControlBus, axisControlBus) annotation (Line(
                    points={{-60,-10},{-60,-20},{-95,-20},{-95,-4},{-100,-4},{-100,0}},
                    color={255,204,51},
                    thickness=0.5));
                connect(motor.axisControlBus, axisControlBus) annotation (Line(
                    points={{-12,-10},{-12,-20},{-95,-20},{-95,-5},{-100,-5},{-100,0}},
                    color={255,204,51},
                    thickness=0.5));
                connect(angleSensor.phi, axisControlBus.angle) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{51,70},{70,70},{70,
                        84},{-98,84},{-98,9},{-100,9},{-100,0}}, color={0,0,127}));
                connect(speedSensor.w, axisControlBus.speed) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{51,50},{74,50},{74,
                        87},{-100,87},{-100,0}}, color={0,0,127}));
                connect(accSensor.a, axisControlBus.acceleration) annotation (
                  __Dymola_Text(
                    string="%second",
                    index=1,
                    extent=[6,3; 6,3]), Line(points={{51,30},{77,30},{77,
                        90},{-102,90},{-102,0},{-100,0}}, color={0,0,127}));
                connect(axisControlBus.angle_ref, initializeFlange.phi_start) annotation (
                  __Dymola_Text(
                    string="%first",
                    index=-1,
                    extent=[-6,3; -6,3]), Line(points={{-100,0},{-100,-7},{
                        -97,-7},{-97,-42},{-42,-42}}, color={0,0,0}));
                connect(axisControlBus.speed_ref, initializeFlange.w_start) annotation (
                  __Dymola_Text(
                    string="%first",
                    index=-1,
                    extent=[-6,3; -6,3]), Line(points={{-100,0},{-99,0},{-99,
                        -50},{-42,-50}}, color={0,0,127}));
                connect(initializeFlange.flange, flange) annotation (Line(points={{-20,
                        -50},{80,-50},{80,0},{100,0}}, color={0,0,0}));
                connect(const.y, initializeFlange.a_start) annotation (Line(points={{-54.5,
                        -60},{-48,-60},{-48,-58},{-42,-58}},       color={0,0,127}));
                annotation (
                  Documentation(info="<HTML>
<p>
The axis model consists of the <b>controller</b>, the <b>motor</b> including current
controller and the <b>gearbox</b> including gear elasticity and bearing friction.
The only difference to the axis model of joints 4,5,6 (= model axisType2) is
that elasticity and damping in the gear boxes are not neglected.
</p>
<p>
The input signals of this component are the desired angle and desired angular
velocity of the joint. The reference signals have to be \"smooth\" (position
has to be differentiable at least 2 times). Otherwise, the gear elasticity
leads to significant oscillations.
</p>
<p>
Default values of the parameters are given for the axis of joint 1.
</p>
</HTML>
"),               Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics={Rectangle(
                        extent={{-100,50},{100,-50}},
                        lineColor={0,0,0},
                        fillPattern=FillPattern.HorizontalCylinder,
                        fillColor={160,160,164}), Text(
                        extent={{-150,57},{150,97}},
                        textString="%name",
                        lineColor={0,0,255})}),
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}},
                      grid={1,1}), graphics));
              end AxisType2;

              model MechanicalStructure
              "Model of the mechanical part of the r3 robot (without animation)"

                parameter Boolean animation=true
                "= true, if animation shall be enabled";
                parameter SI.Mass mLoad(min=0)=15 "Mass of load";
                parameter SI.Position rLoad[3]={0,0.25,0}
                "Distance from last flange to load mass>";
                parameter SI.Acceleration g=9.81 "Gravity acceleration";
                SI.Angle q[6] "Joint angles";
                SI.AngularVelocity qd[6] "Joint speeds";
                SI.AngularAcceleration qdd[6] "Joint accelerations";
                SI.Torque tau[6] "Joint driving torques";
                //r0={0,0.351,0},

                Modelica.Mechanics.Rotational.Interfaces.Flange_a axis1
                  annotation (Placement(transformation(extent={{-220,-180},{-200,-160}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Interfaces.Flange_a axis2
                  annotation (Placement(transformation(extent={{-220,-120},{-200,-100}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Interfaces.Flange_a axis3
                  annotation (Placement(transformation(extent={{-220,-60},{-200,-40}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Interfaces.Flange_a axis4
                  annotation (Placement(transformation(extent={{-220,0},{-200,20}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Interfaces.Flange_a axis5
                  annotation (Placement(transformation(extent={{-220,60},{-200,80}},
                        rotation=0)));
                Modelica.Mechanics.Rotational.Interfaces.Flange_a axis6
                  annotation (Placement(transformation(extent={{-220,120},{-200,140}},
                        rotation=0)));
                inner Modelica.Mechanics.MultiBody.World world(
                  g=(g)*Modelica.Math.Vectors.length(
                                                ({0,-1,0})),
                  n={0,-1,0},
                  animateWorld=false,
                  animateGravity=false,
                  enableAnimation=animation)
                                        annotation (Placement(transformation(extent={{
                          -100,-200},{-80,-180}}, rotation=0)));
                Modelica.Mechanics.MultiBody.Joints.Revolute r1(n={0,1,0},useAxisFlange=true,
                    animation=animation)
                  annotation (Placement(transformation(
                      origin={-70,-160},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Joints.Revolute r2(n={1,0,0},useAxisFlange=true,
                    animation=animation)
                  annotation (Placement(transformation(extent={{-50,-110},{-30,-90}},
                        rotation=0)));
                Modelica.Mechanics.MultiBody.Joints.Revolute r3(n={1,0,0},useAxisFlange=true,
                    animation=animation)
                  annotation (Placement(transformation(
                      origin={-50,-36},
                      extent={{-10,-10},{10,10}},
                      rotation=180)));
                Modelica.Mechanics.MultiBody.Joints.Revolute r4(n={0,1,0},useAxisFlange=true,
                    animation=animation)
                  annotation (Placement(transformation(
                      origin={-70,10},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Joints.Revolute r5(n={1,0,0},useAxisFlange=true,
                    animation=animation)
                  annotation (Placement(transformation(extent={{-60,70},{-40,90}},
                        rotation=0)));
                Modelica.Mechanics.MultiBody.Joints.Revolute r6(n={0,1,0},useAxisFlange=true,
                    animation=animation)
                  annotation (Placement(transformation(
                      origin={-60,130},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b0(
                  r={0,0.351,0},
                  shapeType="0",
                  r_shape={0,0,0},
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  length=0.225,
                  width=0.3,
                  height=0.3,
                  color={0,0,255},
                  animation=animation,
                  animateSphere=false,
                  r_CM={0,0,0},
                  m=1)
                  annotation (Placement(transformation(
                      origin={-30,-170},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b1(
                  r={0,0.324,0.3},
                  I_22=1.16,
                  shapeType="1",
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  length=0.25,
                  width=0.15,
                  height=0.2,
                  animation=animation,
                  animateSphere=false,
                  color={255,0,0},
                  r_CM={0,0,0},
                  m=1)             annotation (Placement(transformation(
                      origin={-70,-118},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b2(
                  r={0,0.65,0},
                  r_CM={0.172,0.205,0},
                  m=56.5,
                  I_11=2.58,
                  I_22=0.64,
                  I_33=2.73,
                  I_21=-0.46,
                  shapeType="2",
                  r_shape={0,0,0},
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  length=0.5,
                  width=0.2,
                  height=0.15,
                  animation=animation,
                  animateSphere=false,
                  color={255,178,0}) annotation (Placement(transformation(
                      origin={-16,-70},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b3(
                  r={0,0.414,-0.155},
                  r_CM={0.064,-0.034,0},
                  m=26.4,
                  I_11=0.279,
                  I_22=0.245,
                  I_33=0.413,
                  I_21=-0.070,
                  shapeType="3",
                  r_shape={0,0,0},
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  length=0.15,
                  width=0.15,
                  height=0.15,
                  animation=animation,
                  animateSphere=false,
                  color={255,0,0}) annotation (Placement(transformation(
                      origin={-86,-22},
                      extent={{-10,10},{10,-10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b4(
                  r={0,0.186,0},
                  r_CM={0,0,0},
                  m=28.7,
                  I_11=1.67,
                  I_22=0.081,
                  I_33=1.67,
                  shapeType="4",
                  r_shape={0,0,0},
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  length=0.73,
                  width=0.1,
                  height=0.1,
                  animation=animation,
                  animateSphere=false,
                  color={255,178,0}) annotation (Placement(transformation(
                      origin={-70,50},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b5(
                  r={0,0.125,0},
                  r_CM={0,0,0},
                  m=5.2,
                  I_11=1.25,
                  I_22=0.81,
                  I_33=1.53,
                  shapeType="5",
                  r_shape={0,0,0},
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  length=0.225,
                  width=0.075,
                  height=0.1,
                  animation=animation,
                  animateSphere=false,
                  color={0,0,255}) annotation (Placement(transformation(
                      origin={-20,98},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape b6(
                  r={0,0,0},
                  r_CM={0.05,0.05,0.05},
                  m=0.5,
                  shapeType="6",
                  r_shape={0,0,0},
                  lengthDirection={1,0,0},
                  widthDirection={0,1,0},
                  animation=animation,
                  animateSphere=false,
                  color={0,0,255}) annotation (Placement(transformation(
                      origin={-60,160},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
                Modelica.Mechanics.MultiBody.Parts.BodyShape load(
                  r_CM=rLoad,
                  m=mLoad,
                  r_shape={0,0,0},
                  widthDirection={1,0,0},
                  width=0.05,
                  height=0.05,
                  color={255,0,0},
                  lengthDirection=rLoad,
                  length=Modelica.Math.Vectors.length(              rLoad),
                  animation=animation)
                  annotation (Placement(transformation(
                      origin={-60,188},
                      extent={{-10,-10},{10,10}},
                      rotation=90)));
              equation
                connect(r6.frame_b, b6.frame_a)
                  annotation (Line(
                    points={{-60,140},{-60,150}},
                    color={95,95,95},
                    thickness=0.5));
                q = {r1.phi,r2.phi,r3.phi,r4.phi,r5.phi,r6.phi};
                qd = der(q);
                qdd = der(qd);
                tau = {r1.axis.tau,r2.axis.tau,r3.axis.tau,r4.axis.tau,r5.axis.tau,r6.
                  axis.tau};
                connect(load.frame_a, b6.frame_b)
                  annotation (Line(
                    points={{-60,178},{-60,170}},
                    color={95,95,95},
                    thickness=0.5));
                connect(world.frame_b, b0.frame_a) annotation (Line(
                    points={{-80,-190},{-30,-190},{-30,-180}},
                    color={95,95,95},
                    thickness=0.5));
                connect(b0.frame_b, r1.frame_a) annotation (Line(
                    points={{-30,-160},{-30,-146},{-48,-146},{-48,-180},{-70,-180},{-70,
                        -170}},
                    color={95,95,95},
                    thickness=0.5));
                connect(b1.frame_b, r2.frame_a) annotation (Line(
                    points={{-70,-108},{-70,-100},{-50,-100}},
                    color={95,95,95},
                    thickness=0.5));
                connect(r1.frame_b, b1.frame_a) annotation (Line(
                    points={{-70,-150},{-70,-128}},
                    color={95,95,95},
                    thickness=0.5));
                connect(r2.frame_b, b2.frame_a) annotation (Line(
                    points={{-30,-100},{-16,-100},{-16,-80}},
                    color={95,95,95},
                    thickness=0.5));
                connect(b2.frame_b, r3.frame_a) annotation (Line(
                    points={{-16,-60},{-16,-36},{-40,-36}},
                    color={95,95,95},
                    thickness=0.5));
                connect(r2.axis, axis2) annotation (Line(points={{-40,-90},{-42,-90},{-42,
                        -80},{-160,-80},{-160,-110},{-210,-110}}, color={0,0,0}));
                connect(r1.axis, axis1) annotation (Line(points={{-80,-160},{-160,-160},{
                        -160,-170},{-210,-170}}, color={0,0,0}));
                connect(r3.frame_b, b3.frame_a) annotation (Line(
                    points={{-60,-36},{-88,-36},{-86,-32}},
                    color={95,95,95},
                    thickness=0.5));
                connect(b3.frame_b, r4.frame_a) annotation (Line(
                    points={{-86,-12},{-86,-8},{-70,-8},{-70,0}},
                    color={95,95,95},
                    thickness=0.5));
                connect(r3.axis, axis3)
                  annotation (Line(points={{-50,-46},{-50,-50},{-210,-50}}, color={0,0,0}));
                connect(r4.axis, axis4)
                  annotation (Line(points={{-80,10},{-210,10}}, color={0,0,0}));
                connect(r4.frame_b, b4.frame_a)
                  annotation (Line(
                    points={{-70,20},{-70,40}},
                    color={95,95,95},
                    thickness=0.5));
                connect(b4.frame_b, r5.frame_a) annotation (Line(
                    points={{-70,60},{-70,80},{-60,80}},
                    color={95,95,95},
                    thickness=0.5));
                connect(r5.axis, axis5) annotation (Line(points={{-50,90},{-50,94},{-160,
                        94},{-160,70},{-210,70}}, color={0,0,0}));
                connect(r5.frame_b, b5.frame_a) annotation (Line(
                    points={{-40,80},{-20,80},{-20,88}},
                    color={95,95,95},
                    thickness=0.5));
                connect(b5.frame_b, r6.frame_a) annotation (Line(
                    points={{-20,108},{-20,116},{-60,116},{-60,120}},
                    color={95,95,95},
                    thickness=0.5));
                connect(r6.axis, axis6)
                  annotation (Line(points={{-70,130},{-210,130}}, color={0,0,0}));
                annotation (
                  Documentation(info="<HTML>
<p>
This model contains the mechanical components of the r3 robot
(multibody system).
</p>
</HTML>
"),               Icon(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-200,-200},{200,200}},
                      grid={2,2}), graphics={
                      Rectangle(
                        extent={{-200,200},{200,-200}},
                        lineColor={0,0,0},
                        fillColor={192,192,192},
                        fillPattern=FillPattern.Solid),
                      Text(
                        extent={{-200,250},{200,210}},
                        textString="%name",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-200,-150},{-140,-190}},
                        textString="1",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-200,-30},{-140,-70}},
                        textString="3",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-200,-90},{-140,-130}},
                        textString="2",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-200,90},{-140,50}},
                        textString="5",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-200,28},{-140,-12}},
                        textString="4",
                        lineColor={0,0,255}),
                      Text(
                        extent={{-198,150},{-138,110}},
                        textString="6",
                        lineColor={0,0,255}),
                      Bitmap(extent={{-130,195},{195,-195}}, fileName=
                            "modelica://Modelica/Resources/Images/MultiBody/Examples/Systems/robot_kr15.bmp")}),
                  Diagram(coordinateSystem(
                      preserveAspectRatio=true,
                      extent={{-200,-200},{200,200}},
                      grid={2,2}), graphics));
              end MechanicalStructure;
              annotation (Documentation(info="<html>
<p>
This library contains the different components
of the r3 robot. Usually, there is no need to
use this library directly.
</p>
</html>"));
            end Components;
            annotation (
              Documentation(info="<HTML>
<p>
This package contains models of the robot r3 of the company Manutec.
These models are used to demonstrate in which way complex
robot models might be built up by testing first the component
models individually before composing them together.
Furthermore, it is shown how CAD data can be used
for animation.
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Examples/Systems/robot_kr15.bmp\"
ALT=\"model Examples.Systems.RobotR3\">

<p>
The following models are available:
</p>
<pre>
   <b>oneAxis</b>   Test one axis (controller, motor, gearbox).
   <b>fullRobot</b> Test complete robot model.
</pre>
<p>
The r3 robot is no longer manufactured. In fact the company
Manutec does no longer exist.
The parameters of this robot have been determined by measurements
in the laboratory of DLR. The measurement procedure is described in:
</p>
<pre>
   Tuerk S. (1990): Zur Modellierung der Dynamik von Robotern mit
       rotatorischen Gelenken. Fortschrittberichte VDI, Reihe 8, Nr. 211,
       VDI-Verlag 1990.
</pre>
<p>
The robot model is described in detail in
</p>
<pre>
   Otter M. (1995): Objektorientierte Modellierung mechatronischer
       Systeme am Beispiel geregelter Roboter. Dissertation,
       Fortschrittberichte VDI, Reihe 20, Nr. 147, VDI-Verlag 1995.
       This report can be downloaded as compressed postscript file
       from: <a href=\"http://www.robotic.dlr.de/Martin.Otter\">http://www.robotic.dlr.de/Martin.Otter</a>.
</pre>
<p>
The path planning is performed in a simple way by using essentially
the Modelica.Mechanics.Rotational.KinematicPTP block. A user defines
a path by start and end angle of every axis. A path is planned such
that all axes are moving as fast as possible under the given
restrictions of maximum joint speeds and maximum joint accelerations.
The actual r3 robot from Manutec had a different path planning strategy.
Todays path planning algorithms from robot companies are much
more involved.
</p>
<p>
In order to get a nice animation, CAD data from a KUKA robot
is used, since CAD data of the original r3 robot was not available.
The KUKA CAD data was derived from public data of KUKA available at:
<a href=\"http://www.kuka-roboter.de/english/produkte/cad/low_payloads.html\">
http://www.kuka-roboter.de/english/produkte/cad/low_payloads.html</a>.
Since dimensions of the corresponding KUKA robot are similar but not
identical to the r3 robot, the data of the r3 robot (such as arm lengths) have been modified, such that it matches the CAD data.
</p>
<p>
In this model, a simplified P-PI cascade controller for every
axes is used. The parameters have been manually adjusted by
simulations. The original r3 controllers are more complicated.
The reason to use simplified controllers is to have a simpler demo.
</p>
</HTML>
"));
          end RobotR3;
        annotation ( Documentation(info="<html>
<p>
This package contains complete <b>system models</b> where components
from different domains are used, including 3-dimensional mechanics.
</p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Model</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3\">RobotR3</a><br>
<a href=\"modelica://Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.oneAxis\">RobotR3.oneAxis</a><br>
<a href=\"modelica://Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot\">RobotR3.fullRobot</a></td>
      <td valign=\"top\"> 6 degree of freedom robot with path planning,
           controllers, motors, brakes, gears and mechanics.
           \"oneAxis\" models only one drive train. \"fullRobot\" is
           the complete, detailed robot model.<br>
      <img src=\"modelica://Modelica/Resources/Images/MultiBody/Examples/Systems/r3_fullRobot_small.png\">
      </td>
  </tr>
</table>
</html>"));
        end Systems;
      annotation ( Documentation(info="<html>
<p>
This package contains example models to demonstrate the usage of the
MultiBody package. Open the models and
simulate them according to the provided description in the models.
</p>

</HTML>
"));
      end Examples;

      package Forces
      "Components that exert forces and/or torques between frames"
        import SI = Modelica.SIunits;
        extends Modelica.Icons.SourcesPackage;

        package Internal "Internal package, should not be used by user"
          extends Modelica.Icons.Package;

          function standardGravityAcceleration
          "Standard gravity fields (no/parallel/point field)"
            extends
            Modelica.Mechanics.MultiBody.Interfaces.partialGravityAcceleration;
            import Modelica.Mechanics.MultiBody.Types.GravityTypes;
            input GravityTypes gravityType "Type of gravity field" annotation(Dialog);
            input Modelica.SIunits.Acceleration g[3]
            "Constant gravity acceleration, resolved in world frame, if gravityType=UniformGravity"
                                                                                                      annotation(Dialog);
            input Real mue(unit="m3/s2")
            "Field constant of point gravity field, if gravityType=PointGravity"
                                                                                   annotation(Dialog);
          algorithm
          gravity := if gravityType == GravityTypes.UniformGravity then g else
                     if gravityType == GravityTypes.PointGravity then
                        -(mue/(r*r))*(r/Modelica.Math.Vectors.length(r)) else zeros(3);
            annotation(Inline=true, Documentation(info="<html>
<p>
This function defines the standard gravity fields for the World object.
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td><b><i>gravityType</i></b></td>
    <td><b><i>gravity [m/s2]</i></b></td>
    <td><b><i>description</i></b></td></tr>
<tr><td>Types.GravityType.NoGravity</td>
    <td>= {0,0,0}</td>
    <td>No gravity</td></tr>

<tr><td>Types.GravityType.UniformGravity</td>
    <td>= g</td>
    <td> Constant parallel gravity field</td></tr>

<tr><td>Types.GravityType.PointGravity</td>
    <td>= -(mue/(r*r))*r/|r|</td>
    <td> Point gravity field with spherical mass</td></tr>
</table>

</html>"));
          end standardGravityAcceleration;
        end Internal;
        annotation ( Documentation(info="<HTML>
<p>
This package contains components that exert forces and torques
between two frame connectors, e.g., between two parts.
</p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Model</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.WorldForce\">WorldForce</a></td>
      <td valign=\"top\"> External force acting at the frame to which this component
           is connected and defined by 3 input signals,
           that are interpreted as one vector resolved in frame world, frame_b or frame_resolve. <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowForce.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.WorldTorque\">WorldTorque</a></td>
      <td valign=\"top\"> External torque acting at the frame to which this component
           is connected and defined by 3 input signals,
           that are interpreted as one vector resolved in frame world, frame_b or frame_resolve. <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowTorque.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.WorldForceAndTorque\">WorldForceAndTorque</a></td>
      <td valign=\"top\"> External force and external torque acting at the frame
           to which this component
           is connected and defined by 3+3 input signals,
           that are interpreted as a force and as a torque vector
           resolved in frame world, frame_b or frame_resolve. <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowForce.png\"><br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowTorque.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.Force\">Force</a></td>
      <td valign=\"top\"> Force acting between two frames defined by 3 input signals
           resolved in frame world, frame_a, frame_b or in frame_resolve. <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowForce2.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.Torque\">Torque</a></td>
      <td valign=\"top\"> Torque acting between two frames defined by 3 input signals
           resolved in frame world, frame_a, frame_b or in frame_resolve. <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowTorque2.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.ForceAndTorque\">ForceAndTorque</a></td>
      <td valign=\"top\"> Force and torque acting between two frames defined by 3+3 input signals
           resolved in frame world, frame_a, frame_b or in frame_resolve. <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowForce2.png\"><br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/ArrowTorque2.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.LineForceWithMass\">LineForceWithMass</a></td>
      <td valign=\"top\">  General line force component with an optional point mass
            on the connection line. The force law can be defined by a
            component of Modelica.Mechanics.Translational<br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/LineForceWithMass.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.LineForceWithTwoMasses\">LineForceWithTwoMasses</a></td>
      <td valign=\"top\">  General line force component with two optional point masses
            on the connection line. The force law can be defined by a
            component of Modelica.Mechanics.Translational<br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/LineForceWithTwoMasses.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.Spring\">Spring</a></td>
      <td valign=\"top\"> Linear translational spring with optional mass <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/Spring2.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.Damper\">Damper</a></td>
      <td valign=\"top\"> Linear (velocity dependent) damper <br>
           <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Forces/Damper2.png\"></td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.SpringDamperParallel\">SpringDamperParallel</a></td>
      <td valign=\"top\"> Linear spring and damper in parallel connection </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Forces.SpringDamperSeries\">SpringDamperSeries</a></td>
      <td valign=\"top\"> Linear spring and damper in series connection </td>
  </tr>
</table>
</HTML>"));
      end Forces;

      package Frames "Functions to transform rotational frame quantities"
        extends Modelica.Icons.Package;

        record Orientation
        "Orientation object defining rotation from a frame 1 into a frame 2"

          import SI = Modelica.SIunits;
          extends Modelica.Icons.Record;
          Real T[3, 3] "Transformation matrix from world frame to local frame";
          SI.AngularVelocity w[3]
          "Absolute angular velocity of local frame, resolved in local frame";

          encapsulated function equalityConstraint
          "Return the constraint residues to express that two frames have the same orientation"

            import Modelica;
            import Modelica.Mechanics.MultiBody.Frames;
            extends Modelica.Icons.Function;
            input Frames.Orientation R1
            "Orientation object to rotate frame 0 into frame 1";
            input Frames.Orientation R2
            "Orientation object to rotate frame 0 into frame 2";
            output Real residue[3]
            "The rotation angles around x-, y-, and z-axis of frame 1 to rotate frame 1 into frame 2 for a small rotation (should be zero)";
          algorithm
            residue := {
               Modelica.Math.atan2(cross(R1.T[1, :], R1.T[2, :])*R2.T[2, :],R1.T[1,:]*R2.T[1,:]),
               Modelica.Math.atan2(-cross(R1.T[1, :],R1.T[2, :])*R2.T[1, :],R1.T[2,:]*R2.T[2,:]),
               Modelica.Math.atan2(R1.T[2, :]*R2.T[1, :],R1.T[3,:]*R2.T[3,:])};
            annotation(Inline=true);
          end equalityConstraint;

          annotation (Documentation(info="<html>
<p>
This object describes the <b>rotation</b> from a <b>frame 1</b> into a <b>frame 2</b>.
An instance of this type should never be directly accessed but
only with the access functions provided
in package Modelica.Mechanics.MultiBody.Frames. As a consequence, it is not necessary to know
the internal representation of this object as described in the next paragraphs.
</p>
<p>
\"Orientation\" is defined to be a record consisting of two
elements: \"Real T[3,3]\", the transformation matrix to rotate frame 1
into frame 2 and \"Real w[3]\", the angular velocity of frame 2 with
respect to frame 1, resolved in frame 2. Element \"T\"
has the following interpretation:
</p>
<pre>
   Orientation R;
   <b>R.T</b> = [<b>e</b><sub>x</sub>, <b>e</b><sub>y</sub>, <b>e</b><sub>z</sub>];
       e.g., <b>R.T</b> = [1,0,0; 0,1,0; 0,0,1]
</pre>
<p>
where <b>e</b><sub>x</sub>,<b>e</b><sub>y</sub>,<b>e</b><sub>z</sub>
are unit vectors in the direction of the x-axis, y-axis, and z-axis
of frame 1, resolved in frame 2, respectively. Therefore, if <b>v</b><sub>1</sub>
is vector <b>v</b> resolved in frame 1 and <b>v</b><sub>2</sub> is
vector <b>v</b> resolved in frame 2, the following relationship holds:
</p>
<pre>
    <b>v</b><sub>2</sub> = <b>R.T</b> * <b>v</b><sub>1</sub>
</pre>
</p>
The <b>inverse</b> orientation
<b>R_inv.T</b> = <b>R.T</b><sup>T</sup> describes the rotation
from frame 2 into frame 1.
</p>
<p>
Since the orientation is described by 9 variables, there are
6 constraints between these variables. These constraints
are defined in function <b>Frames.orientationConstraint</b>.
</p>
<p>
R.w is the angular velocity of frame 2 with respect to frame 1, resolved
in frame 2. Formally, R.w is defined as:<br>
<b>skew</b>(R.w) = R.T*<b>der</b>(transpose(R.T))
with
</p>
<pre>
             |   0   -w[3]  w[2] |
   <b>skew</b>(w) = |  w[3]   0   -w[1] |
             | -w[2]  w[1]     0 |
</pre>

</html>
"));

        end Orientation;

        function angularVelocity2
        "Return angular velocity resolved in frame 2 from orientation object"

          extends Modelica.Icons.Function;
          input Orientation R
          "Orientation object to rotate frame 1 into frame 2";
          output Modelica.SIunits.AngularVelocity w[3]
          "Angular velocity of frame 2 with respect to frame 1 resolved in frame 2";
        algorithm
          w := R.w;
          annotation(Inline=true);
        end angularVelocity2;

        function resolve1 "Transform vector from frame 2 to frame 1"
          extends Modelica.Icons.Function;
          input Orientation R
          "Orientation object to rotate frame 1 into frame 2";
          input Real v2[3] "Vector in frame 2";
          output Real v1[3] "Vector in frame 1";
        algorithm
          v1 := transpose(R.T)*v2;
          annotation (derivative(noDerivative=R) = Internal.resolve1_der,
              __Dymola_InlineAfterIndexReduction=true);
        end resolve1;

        function resolve2 "Transform vector from frame 1 to frame 2"
          extends Modelica.Icons.Function;
          input Orientation R
          "Orientation object to rotate frame 1 into frame 2";
          input Real v1[3] "Vector in frame 1";
          output Real v2[3] "Vector in frame 2";
        algorithm
          v2 := R.T*v1;
          annotation (derivative(noDerivative=R) = Internal.resolve2_der,
              __Dymola_InlineAfterIndexReduction=true);
        end resolve2;

        function nullRotation
        "Return orientation object that does not rotate a frame"
          extends Modelica.Icons.Function;
          output Orientation R
          "Orientation object such that frame 1 and frame 2 are identical";
        algorithm
          R := Orientation(T=identity(3),w= zeros(3));
          annotation(Inline=true);
        end nullRotation;

        function absoluteRotation
        "Return absolute orientation object from another absolute and a relative orientation object"

          extends Modelica.Icons.Function;
          input Orientation R1
          "Orientation object to rotate frame 0 into frame 1";
          input Orientation R_rel
          "Orientation object to rotate frame 1 into frame 2";
          output Orientation R2
          "Orientation object to rotate frame 0 into frame 2";
        algorithm
          R2 := Orientation(T=R_rel.T*R1.T,w= resolve2(R_rel, R1.w) + R_rel.w);
          annotation(Inline=true);
        end absoluteRotation;

        function planarRotation
        "Return orientation object of a planar rotation"
          import Modelica.Math;
          extends Modelica.Icons.Function;
          input Real e[3](each final unit="1")
          "Normalized axis of rotation (must have length=1)";
          input Modelica.SIunits.Angle angle
          "Rotation angle to rotate frame 1 into frame 2 along axis e";
          input Modelica.SIunits.AngularVelocity der_angle "= der(angle)";
          output Orientation R
          "Orientation object to rotate frame 1 into frame 2";
        algorithm
          R := Orientation(T=[e]*transpose([e]) + (identity(3) - [e]*transpose([e]))*
            Math.cos(angle) - skew(e)*Math.sin(angle),w= e*der_angle);

          annotation(Inline=true);
        end planarRotation;

        function planarRotationAngle
        "Return angle of a planar rotation, given the rotation axis and the representations of a vector in frame 1 and frame 2"

          extends Modelica.Icons.Function;
          input Real e[3](each final unit="1")
          "Normalized axis of rotation to rotate frame 1 around e into frame 2 (must have length=1)";
          input Real v1[3]
          "A vector v resolved in frame 1 (shall not be parallel to e)";
          input Real v2[3]
          "Vector v resolved in frame 2, i.e., v2 = resolve2(planarRotation(e,angle),v1)";
          output Modelica.SIunits.Angle angle
          "Rotation angle to rotate frame 1 into frame 2 along axis e in the range: -pi <= angle <= pi";
        algorithm
          /* Vector v is resolved in frame 1 and frame 2 according to:
        (1)  v2 = (e*transpose(e) + (identity(3) - e*transpose(e))*cos(angle) - skew(e)*sin(angle))*v1;
                = e*(e*v1) + (v1 - e*(e*v1))*cos(angle) - cross(e,v1)*sin(angle)
       Equation (1) is multiplied with "v1" resulting in (note: e*e = 1)
            v1*v2 = (e*v1)*(e*v2) + (v1*v1 - (e*v1)*(e*v1))*cos(angle)
       and therefore:
        (2) cos(angle) = ( v1*v2 - (e*v1)*(e*v2)) / (v1*v1 - (e*v1)*(e*v1))
       Similiarly, equation (1) is multiplied with cross(e,v1), i.e., a
       a vector that is orthogonal to e and to v1:
              cross(e,v1)*v2 = - cross(e,v1)*cross(e,v1)*sin(angle)
       and therefore:
          (3) sin(angle) = -cross(e,v1)*v2/(cross(e,v1)*cross(e,v1));
       We have e*e=1; Therefore:
          (4) v1*v1 - (e*v1)*(e*v1) = |v1|^2 - (|v1|*cos(e,v1))^2
       and
          (5) cross(e,v1)*cross(e,v1) = (|v1|*sin(e,v1))^2
                                      = |v1|^2*(1 - cos(e,v1)^2)
                                      = |v1|^2 - (|v1|*cos(e,v1))^2
       The denominators of (2) and (3) are identical, according to (4) and (5).
       Furthermore, the denominators are always positive according to (5).
       Therefore, in the equation "angle = atan2(sin(angle), cos(angle))" the
       denominators of sin(angle) and cos(angle) can be removed,
       resulting in:
          angle = atan2(-cross(e,v1)*v2, v1*v2 - (e*v1)*(e*v2));
    */
          angle := Modelica.Math.atan2(-cross(e, v1)*v2, v1*v2 - (e*v1)*(e*v2));
          annotation (Inline=true, Documentation(info="<HTML>
<p>
A call to this function of the form
</p>
<pre>
    Real[3]                e, v1, v2;
    Modelica.SIunits.Angle angle;
  <b>equation</b>
    angle = <b>planarRotationAngle</b>(e, v1, v2);
</pre>
<p>
computes the rotation angle \"<b>angle</b>\" of a planar
rotation along unit vector <b>e</b>, rotating frame 1 into frame 2, given
the coordinate representations of a vector \"v\" in frame 1 (<b>v1</b>)
and in frame 2 (<b>v2</b>). Therefore, the result of this function
fulfills the following equation:
</p>
<pre>
    v2 = <b>resolve2</b>(<b>planarRotation</b>(e,angle), v1)
</pre>
<p>
The rotation angle is returned in the range
</p>
<pre>
    -<font face=\"Symbol\">p</font> &lt;= angle &lt;= <font face=\"Symbol\">p</font>
</pre>
<p>
This function makes the following assumptions on the input arguments
</p>
<ul>
<li> Vector <b>e</b> has length 1, i.e., length(e) = 1</li>
<li> Vector \"v\" is not parallel to <b>e</b>, i.e.,
     length(cross(e,v1)) &ne; 0</li>
</ul>
<p>
The function does not check the above assumptions. If these
assumptions are violated, a wrong result will be returned
and/or a division by zero will occur.
</p>
</HTML>"));
        end planarRotationAngle;

        function axesRotations
        "Return fixed rotation object to rotate in sequence around fixed angles along 3 axes"

          import TM =
          Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
          extends Modelica.Icons.Function;
          input Integer sequence[3](
            min={1,1,1},
            max={3,3,3}) = {1,2,3}
          "Sequence of rotations from frame 1 to frame 2 along axis sequence[i]";
          input Modelica.SIunits.Angle angles[3]
          "Rotation angles around the axes defined in 'sequence'";
          input Modelica.SIunits.AngularVelocity der_angles[3] "= der(angles)";
          output Orientation R
          "Orientation object to rotate frame 1 into frame 2";
        algorithm
          /*
  R := absoluteRotation(absoluteRotation(axisRotation(sequence[1], angles[1],
    der_angles[1]), axisRotation(sequence[2], angles[2], der_angles[2])),
    axisRotation(sequence[3], angles[3], der_angles[3]));
*/
          R := Orientation(T=TM.axisRotation(sequence[3], angles[3])*TM.axisRotation(
            sequence[2], angles[2])*TM.axisRotation(sequence[1], angles[1]),w=
            Frames.axis(sequence[3])*der_angles[3] + TM.resolve2(TM.axisRotation(
            sequence[3], angles[3]), Frames.axis(sequence[2])*der_angles[2]) +
            TM.resolve2(TM.axisRotation(sequence[3], angles[3])*TM.axisRotation(
            sequence[2], angles[2]), Frames.axis(sequence[1])*der_angles[1]));
          annotation(Inline=true);
        end axesRotations;

        function axesRotationsAngles
        "Return the 3 angles to rotate in sequence around 3 axes to construct the given orientation object"

          import SI = Modelica.SIunits;

          extends Modelica.Icons.Function;
          input Orientation R
          "Orientation object to rotate frame 1 into frame 2";
          input Integer sequence[3](
            min={1,1,1},
            max={3,3,3}) = {1,2,3}
          "Sequence of rotations from frame 1 to frame 2 along axis sequence[i]";
          input SI.Angle guessAngle1=0
          "Select angles[1] such that |angles[1] - guessAngle1| is a minimum";
          output SI.Angle angles[3]
          "Rotation angles around the axes defined in 'sequence' such that R=Frames.axesRotation(sequence,angles); -pi < angles[i] <= pi";
      protected
          Real e1_1[3](each final unit="1")
          "First rotation axis, resolved in frame 1";
          Real e2_1a[3](each final unit="1")
          "Second rotation axis, resolved in frame 1a";
          Real e3_1[3](each final unit="1")
          "Third rotation axis, resolved in frame 1";
          Real e3_2[3](each final unit="1")
          "Third rotation axis, resolved in frame 2";
          Real A
          "Coefficient A in the equation A*cos(angles[1])+B*sin(angles[1]) = 0";
          Real B
          "Coefficient B in the equation A*cos(angles[1])+B*sin(angles[1]) = 0";
          SI.Angle angle_1a "Solution 1 for angles[1]";
          SI.Angle angle_1b "Solution 2 for angles[1]";
          TransformationMatrices.Orientation T_1a
          "Orientation object to rotate frame 1 into frame 1a";
        algorithm
          /* The rotation object R is constructed by:
     (1) Rotating frame 1 along axis e1 (= axis sequence[1]) with angles[1]
         arriving at frame 1a.
     (2) Rotating frame 1a along axis e2 (= axis sequence[2]) with angles[2]
         arriving at frame 1b.
     (3) Rotating frame 1b along axis e3 (= axis sequence[3]) with angles[3]
         arriving at frame 2.
     The goal is to determine angles[1:3]. This is performed in the following way:
     1. e2 and e3 are perpendicular to each other, i.e., e2*e3 = 0;
        Both vectors are resolved in frame 1 (T_ij is transformation matrix
        from frame j to frame i; e1_1*e2_1a = 0, since the vectors are
        perpendicular to each other):
           e3_1 = T_12*e3_2
                = R[sequence[3],:];
           e2_1 = T_11a*e2_1a
                = ( e1_1*transpose(e1_1) + (identity(3) - e1_1*transpose(e1_1))*cos(angles[1])
                    + skew(e1_1)*sin(angles[1]) )*e2_1a
                = e2_1a*cos(angles[1]) + cross(e1_1, e2_1a)*sin(angles[1]);
        From this follows finally an equation for angles[1]
           e2_1*e3_1 = 0
                     = (e2_1a*cos(angles[1]) + cross(e1_1, e2_1a)*sin(angles[1]))*e3_1
                     = (e2_1a*e3_1)*cos(angles[1]) + cross(e1_1, e2_1a)*e3_1*sin(angles[1])
                     = A*cos(angles[1]) + B*sin(angles[1])
                       with A = e2_1a*e3_1, B = cross(e1_1, e2_1a)*e3_1
        This equation has two solutions in the range -pi < angles[1] <= pi:
           sin(angles[1]) =  k*A/sqrt(A*A + B*B)
           cos(angles[1]) = -k*B/sqrt(A*A + B*B)
                        k = +/-1
           tan(angles[1]) = k*A/(-k*B)
        that is:
           angles[1] = atan2(k*A, -k*B)
        If A and B are both zero at the same time, there is a singular configuration
        resulting in an infinite number of solutions for angles[1] (every value
        is possible).
     2. angles[2] is determined with function Frames.planarRotationAngle.
        This function requires to provide e_3 in frame 1a and in frame 1b:
          e3_1a = Frames.resolve2(planarRotation(e1_1,angles[1]), e3_1);
          e3_1b = e3_2
     3. angles[3] is determined with function Frames.planarRotationAngle.
        This function requires to provide e_2 in frame 1b and in frame 2:
          e2_1b = e2_1a
          e2_2  = Frames.resolve2( R, Frames.resolve1(planarRotation(e1_1,angles[1]), e2_1a));
  */
          assert(sequence[1] <> sequence[2] and sequence[2] <> sequence[3],
            "input argument 'sequence[1:3]' is not valid");
          e1_1 := if sequence[1] == 1 then {1,0,0} else if sequence[1] == 2 then {0,1,
            0} else {0,0,1};
          e2_1a := if sequence[2] == 1 then {1,0,0} else if sequence[2] == 2 then {0,
            1,0} else {0,0,1};
          e3_1 := R.T[sequence[3], :];
          e3_2 := if sequence[3] == 1 then {1,0,0} else if sequence[3] == 2 then {0,1,
            0} else {0,0,1};

          A := e2_1a*e3_1;
          B := cross(e1_1, e2_1a)*e3_1;
          if abs(A) <= 1.e-12 and abs(B) <= 1.e-12 then
            angles[1] := guessAngle1;
          else
            angle_1a := Modelica.Math.atan2(A, -B);
            angle_1b := Modelica.Math.atan2(-A, B);
            angles[1] := if abs(angle_1a - guessAngle1) <= abs(angle_1b - guessAngle1) then
                    angle_1a else angle_1b;
          end if;
          T_1a := TransformationMatrices.planarRotation(e1_1, angles[1]);
          angles[2] := planarRotationAngle(e2_1a, TransformationMatrices.resolve2(
            T_1a, e3_1), e3_2);
          angles[3] := planarRotationAngle(e3_2, e2_1a,
            TransformationMatrices.resolve2(R.T, TransformationMatrices.resolve1(T_1a,
             e2_1a)));

          annotation (Documentation(info="<HTML>
<p>
A call to this function of the form
</p>
<pre>
    Frames.Orientation     R;
    <b>parameter</b> Integer      sequence[3] = {1,2,3};
    Modelica.SIunits.Angle angles[3];
  <b>equation</b>
    angle = <b>axesRotationAngles</b>(R, sequence);
</pre>
<p>
computes the rotation angles \"<b>angles</b>[1:3]\" to rotate frame 1
into frame 2 along axes <b>sequence</b>[1:3], given the orientation
object <b>R</b> from frame 1 to frame 2. Therefore, the result of
this function fulfills the following equation:
</p>
<pre>
    R = <b>axesRotation</b>(sequence, angles)
</pre>
<p>
The rotation angles are returned in the range
</p>
<pre>
    -<font face=\"Symbol\">p</font> &lt;= angles[i] &lt;= <font face=\"Symbol\">p</font>
</pre>
<p>
There are <b>two solutions</b> for \"angles[1]\" in this range.
Via the third argument <b>guessAngle1</b> (default = 0) the
returned solution is selected such that |angles[1] - guessAngle1| is
minimal. The orientation object R may be in a singular configuration, i.e.,
there is an infinite number of angle values leading to the same R. The returned solution is
selected by setting angles[1] = guessAngle1. Then angles[2]
and angles[3] can be uniquely determined in the above range.
</p>
<p>
Note, that input argument <b>sequence</b> has the restriction that
only values 1,2,3 can be used and that sequence[1] &ne; sequence[2]
and sequence[2] &ne; sequence[3]. Often used values are:
</p>
<pre>
  sequence = <b>{1,2,3}</b>  // Cardan angle sequence
           = <b>{3,1,3}</b>  // Euler angle sequence
           = <b>{3,2,1}</b>  // Tait-Bryan angle sequence
</pre>
</HTML>"));
        end axesRotationsAngles;

        function from_Q
        "Return orientation object R from quaternion orientation object Q"

          extends Modelica.Icons.Function;
          input Quaternions.Orientation Q
          "Quaternions orientation object to rotate frame 1 into frame 2";
          input Modelica.SIunits.AngularVelocity w[3]
          "Angular velocity from frame 2 with respect to frame 1, resolved in frame 2";
          output Orientation R
          "Orientation object to rotate frame 1 into frame 2";
        algorithm
          /*
  T := (2*Q[4]*Q[4] - 1)*identity(3) + 2*([Q[1:3]]*transpose([Q[1:3]]) - Q[4]*
    skew(Q[1:3]));
*/
          R := Orientation([2*(Q[1]*Q[1] + Q[4]*Q[4]) - 1, 2*(Q[1]*Q[2] + Q[3]*Q[4]),
             2*(Q[1]*Q[3] - Q[2]*Q[4]); 2*(Q[2]*Q[1] - Q[3]*Q[4]), 2*(Q[2]*Q[2] + Q[4]
            *Q[4]) - 1, 2*(Q[2]*Q[3] + Q[1]*Q[4]); 2*(Q[3]*Q[1] + Q[2]*Q[4]), 2*(Q[3]
            *Q[2] - Q[1]*Q[4]), 2*(Q[3]*Q[3] + Q[4]*Q[4]) - 1],w= w);
          annotation(Inline=true);
        end from_Q;

        function to_Q
        "Return quaternion orientation object Q from orientation object R"

          extends Modelica.Icons.Function;
          input Orientation R
          "Orientation object to rotate frame 1 into frame 2";
          input Quaternions.Orientation Q_guess=Quaternions.nullRotation()
          "Guess value for output Q (there are 2 solutions; the one closer to Q_guess is used";
          output Quaternions.Orientation Q
          "Quaternions orientation object to rotate frame 1 into frame 2";
        algorithm
          Q := Quaternions.from_T(R.T, Q_guess);
          annotation(Inline=true);
        end to_Q;

        function axis "Return unit vector for x-, y-, or z-axis"
          extends Modelica.Icons.Function;
          input Integer axis(min=1, max=3) "Axis vector to be returned";
          output Real e[3](each final unit="1") "Unit axis vector";
        algorithm
          e := if axis == 1 then {1,0,0} else (if axis == 2 then {0,1,0} else {0,0,1});
          annotation(Inline=true);
        end axis;

        package Quaternions
        "Functions to transform rotational frame quantities based on quaternions (also called Euler parameters)"
          extends Modelica.Icons.Package;

          type Orientation
          "Orientation type defining rotation from a frame 1 into a frame 2 with quaternions {p1,p2,p3,p0}"

            extends Internal.QuaternionBase;

            encapsulated function equalityConstraint
            "Return the constraint residues to express that two frames have the same quaternion orientation"

              import Modelica;
              import Modelica.Mechanics.MultiBody.Frames.Quaternions;
              extends Modelica.Icons.Function;
              input Quaternions.Orientation Q1
              "Quaternions orientation object to rotate frame 0 into frame 1";
              input Quaternions.Orientation Q2
              "Quaternions orientation object to rotate frame 0 into frame 2";
              output Real residue[3]
              "The half of the rotation angles around x-, y-, and z-axis of frame 1 to rotate frame 1 into frame 2 for a small rotation (shall be zero)";
            algorithm
              residue := [Q1[4], Q1[3], -Q1[2], -Q1[1]; -Q1[3], Q1[4], Q1[1], -Q1[2];
                 Q1[2], -Q1[1], Q1[4], -Q1[3]]*Q2;
              annotation(Inline=true);
            end equalityConstraint;

            annotation ( Documentation(info="<html>
<p>
This type describes the <b>rotation</b> to rotate a frame 1 into
a frame 2 using quaternions (also called <b>Euler parameters</b>)
according to the following definition:
</p>
<pre>
   Quaternions.Orientation Q;
   Real  n[3];
   Real  phi(unit=\"rad\");
   Q = [ n*sin(phi/2)
           cos(phi/2) ]
</pre>
<p>
where \"n\" is the <b>axis of rotation</b> to rotate frame 1 into
frame 2 and \"phi\" is the <b>rotation angle</b> for this rotation.
Vector \"n\" is either resolved in frame 1 or in frame 2
(the result is the same since the coordinates of \"n\" with respect to
frame 1 are identical to its coordinates with respect to frame 2).
<p>
<p>
The term \"quaternions\" is prefered over the historically
more reasonable \"Euler parameters\" in order to not get
confused with Modelica \"parameters\".
</p>
</html>
"));
          end Orientation;

          type der_Orientation = Real[4] (each unit="1/s")
          "First time derivative of Quaternions.Orientation";

          function orientationConstraint
          "Return residues of orientation constraints (shall be zero)"
            extends Modelica.Icons.Function;
            input Quaternions.Orientation Q
            "Quaternions orientation object to rotate frame 1 into frame 2";
            output Real residue[1] "Residue constraint (shall be zero)";
          algorithm
            residue := {Q*Q - 1};
            annotation(Inline=true);
          end orientationConstraint;

          function angularVelocity2
          "Compute angular velocity resolved in frame 2 from quaternions orientation object and its derivative"

            extends Modelica.Icons.Function;
            input Quaternions.Orientation Q
            "Quaternions orientation object to rotate frame 1 into frame 2";
            input der_Orientation der_Q "Derivative of Q";
            output Modelica.SIunits.AngularVelocity w[3]
            "Angular velocity of frame 2 with respect to frame 1 resolved in frame 2";
          algorithm
            w := 2*([Q[4], Q[3], -Q[2], -Q[1]; -Q[3], Q[4], Q[1], -Q[2]; Q[2], -Q[1],
               Q[4], -Q[3]]*der_Q);
            annotation(Inline=true);
          end angularVelocity2;

          function nullRotation
          "Return quaternion orientation object that does not rotate a frame"

            extends Modelica.Icons.Function;
            output Quaternions.Orientation Q
            "Quaternions orientation object to rotate frame 1 into frame 2";
          algorithm
            Q := {0,0,0,1};
            annotation(Inline=true);
          end nullRotation;

          function from_T
          "Return quaternion orientation object Q from transformation matrix T"

            extends Modelica.Icons.Function;
            input Real T[3, 3]
            "Transformation matrix to transform vector from frame 1 to frame 2 (v2=T*v1)";
            input Quaternions.Orientation Q_guess=nullRotation()
            "Guess value for Q (there are 2 solutions; the one close to Q_guess is used";
            output Quaternions.Orientation Q
            "Quaternions orientation object to rotate frame 1 into frame 2 (Q and -Q have same transformation matrix)";
        protected
            Real paux;
            Real paux4;
            Real c1;
            Real c2;
            Real c3;
            Real c4;
            constant Real p4limit=0.1;
            constant Real c4limit=4*p4limit*p4limit;
          algorithm
            /*
   Note, for quaternions, Q and -Q have the same transformation matrix.
   Calculation of quaternions from transformation matrix T:
   It is guaranteed that c1>=0, c2>=0, c3>=0, c4>=0 and
   that not all of them can be zero at the same time
   (e.g., if 3 of them are zero, the 4th variable is 1).
   Since the sqrt(..) has to be performed on one of these variables,
   it is applied on a variable which is far enough from zero.
   This guarantees that the sqrt(..) is never taken near zero
   and therefore the derivative of sqrt(..) can never be infinity.
   There is an ambiguity for quaternions, since Q and -Q
   lead to the same transformation matrix. The ambiguity
   is resolved here by selecting the Q that is closer to
   the input argument Q_guess.
*/
            c1 := 1 + T[1, 1] - T[2, 2] - T[3, 3];
            c2 := 1 + T[2, 2] - T[1, 1] - T[3, 3];
            c3 := 1 + T[3, 3] - T[1, 1] - T[2, 2];
            c4 := 1 + T[1, 1] + T[2, 2] + T[3, 3];

            if c4 > c4limit or (c4 > c1 and c4 > c2 and c4 > c3) then
              paux := sqrt(c4)/2;
              paux4 := 4*paux;
              Q := {(T[2, 3] - T[3, 2])/paux4,(T[3, 1] - T[1, 3])/paux4,(T[1, 2] - T[
                2, 1])/paux4,paux};

            elseif c1 > c2 and c1 > c3 and c1 > c4 then
              paux := sqrt(c1)/2;
              paux4 := 4*paux;
              Q := {paux,(T[1, 2] + T[2, 1])/paux4,(T[1, 3] + T[3, 1])/paux4,(T[2, 3]
                 - T[3, 2])/paux4};

            elseif c2 > c1 and c2 > c3 and c2 > c4 then
              paux := sqrt(c2)/2;
              paux4 := 4*paux;
              Q := {(T[1, 2] + T[2, 1])/paux4,paux,(T[2, 3] + T[3, 2])/paux4,(T[3, 1]
                 - T[1, 3])/paux4};

            else
              paux := sqrt(c3)/2;
              paux4 := 4*paux;
              Q := {(T[1, 3] + T[3, 1])/paux4,(T[2, 3] + T[3, 2])/paux4,paux,(T[1, 2]
                 - T[2, 1])/paux4};
            end if;

            if Q*Q_guess < 0 then
              Q := -Q;
            end if;
          end from_T;
          annotation ( Documentation(info="<HTML>
<p>
Package <b>Frames.Quaternions</b> contains type definitions and
functions to transform rotational frame quantities with quaternions.
Functions of this package are currently only utilized in
MultiBody.Parts.Body components, when quaternions shall be used
as parts of the body states.
Some functions are also used in a new Modelica package for
B-Spline interpolation that is able to interpolate paths consisting of
position vectors and orientation objects.
</p>
<h4>Content</h4>
<p>In the table below an example is given for every function definition.
The used variables have the following declaration:
</p>
<pre>
   Quaternions.Orientation Q, Q1, Q2, Q_rel, Q_inv;
   Real[3,3]   T, T_inv;
   Real[3]     v1, v2, w1, w2, n_x, n_y, n_z, res_ori, phi;
   Real[6]     res_equal;
   Real        L, angle;
</pre>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function/type</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><b>Orientation Q;</b></td>
      <td valign=\"top\">New type defining a quaternion object that describes<br>
          the rotation of frame 1 into frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\"><b>der_Orientation</b> der_Q;</td>
      <td valign=\"top\">New type defining the first time derivative
         of Frames.Quaternions.Orientation.
      </td>
  </tr>
  <tr><td valign=\"top\">res_ori = <b>orientationConstraint</b>(Q);</td>
      <td valign=\"top\">Return the constraints between the variables of a quaternion object<br>
      (shall be zero).</td>
  </tr>
  <tr><td valign=\"top\">w1 = <b>angularVelocity1</b>(Q, der_Q);</td>
      <td valign=\"top\">Return angular velocity resolved in frame 1 from
          quaternion object Q<br> and its derivative der_Q.
     </td>
  </tr>
  <tr><td valign=\"top\">w2 = <b>angularVelocity2</b>(Q, der_Q);</td>
      <td valign=\"top\">Return angular velocity resolved in frame 2 from
          quaternion object Q<br> and its derivative der_Q.
     </td>
  </tr>
  <tr><td valign=\"top\">v1 = <b>resolve1</b>(Q,v2);</td>
      <td valign=\"top\">Transform vector v2 from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">v2 = <b>resolve2</b>(Q,v1);</td>
      <td valign=\"top\">Transform vector v1 from frame 1 to frame 2.
     </td>
  </tr>
  <tr><td valign=\"top\">[v1,w1] = <b>multipleResolve1</b>(Q, [v2,w2]);</td>
      <td valign=\"top\">Transform several vectors from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">[v2,w2] = <b>multipleResolve2</b>(Q, [v1,w1]);</td>
      <td valign=\"top\">Transform several vectors from frame 1 to frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\">Q = <b>nullRotation</b>()</td>
      <td valign=\"top\">Return quaternion object R that does not rotate a frame.
  </tr>
  <tr><td valign=\"top\">Q_inv = <b>inverseRotation</b>(Q);</td>
      <td valign=\"top\">Return inverse quaternion object.
      </td>
  </tr>
  <tr><td valign=\"top\">Q_rel = <b>relativeRotation</b>(Q1,Q2);</td>
      <td valign=\"top\">Return relative quaternion object from two absolute
          quaternion objects.
      </td>
  </tr>
  <tr><td valign=\"top\">Q2 = <b>absoluteRotation</b>(Q1,Q_rel);</td>
      <td valign=\"top\">Return absolute quaternion object from another
          absolute<br> and a relative quaternion object.
      </td>
  </tr>
  <tr><td valign=\"top\">Q = <b>planarRotation</b>(e, angle);</td>
      <td valign=\"top\">Return quaternion object of a planar rotation.
      </td>
  </tr>
  <tr><td valign=\"top\">phi = <b>smallRotation</b>(Q);</td>
      <td valign=\"top\">Return rotation angles phi valid for a small rotation.
      </td>
  </tr>
  <tr><td valign=\"top\">Q = <b>from_T</b>(T);</td>
      <td valign=\"top\">Return quaternion object Q from transformation matrix T.
      </td>
  </tr>
  <tr><td valign=\"top\">Q = <b>from_T_inv</b>(T_inv);</td>
      <td valign=\"top\">Return quaternion object Q from inverse transformation matrix T_inv.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>to_T</b>(Q);</td>
      <td valign=\"top\">Return transformation matrix T from quaternion object Q.
  </tr>
  <tr><td valign=\"top\">T_inv = <b>to_T_inv</b>(Q);</td>
      <td valign=\"top\">Return inverse transformation matrix T_inv from quaternion object Q.
      </td>
  </tr>
</table>
</HTML>"));
        end Quaternions;

        package TransformationMatrices "Functions for transformation matrices"
          extends Modelica.Icons.Package;

          type Orientation
          "Orientation type defining rotation from a frame 1 into a frame 2 with a transformation matrix"

            extends Internal.TransformationMatrix;

            encapsulated function equalityConstraint
            "Return the constraint residues to express that two frames have the same orientation"

              import Modelica;
              import Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
              extends Modelica.Icons.Function;
              input TransformationMatrices.Orientation T1
              "Orientation object to rotate frame 0 into frame 1";
              input TransformationMatrices.Orientation T2
              "Orientation object to rotate frame 0 into frame 2";
              output Real residue[3]
              "The rotation angles around x-, y-, and z-axis of frame 1 to rotate frame 1 into frame 2 for a small rotation (should be zero)";
            algorithm
              residue := {cross(T1[1, :], T1[2, :])*T2[2, :],-cross(T1[1, :], T1[2, :])
                *T2[1, :],T1[2, :]*T2[1, :]};
              annotation(Inline=true);
            end equalityConstraint;
            annotation (Documentation(info="<html>
<p>
This type describes the <b>rotation</b> from a <b>frame 1</b> into a <b>frame 2</b>.
An instance <b>R</b> of type <b>Orientation</b> has the following interpretation:
</p>
<pre>
   <b>T</b> = [<b>e</b><sub>x</sub>, <b>e</b><sub>y</sub>, <b>e</b><sub>z</sub>];
       e.g., <b>T</b> = [1,0,0; 0,1,0; 0,0,1]
</pre>
<p>
where <b>e</b><sub>x</sub>,<b>e</b><sub>y</sub>,<b>e</b><sub>z</sub>
are unit vectors in the direction of the x-axis, y-axis, and z-axis
of frame 1, resolved in frame 2, respectively. Therefore, if <b>v</b><sub>1</sub>
is vector <b>v</b> resolved in frame 1 and <b>v</b><sub>2</sub> is
vector <b>v</b> resolved in frame 2, the following relationship holds:
</p>
<pre>
    <b>v</b><sub>2</sub> = <b>T</b> * <b>v</b><sub>1</sub>
</pre>
</p>
The <b>inverse</b> orientation
<b>T_inv</b> = <b>T</b><sup>T</sup> describes the rotation
from frame 2 into frame 1.
</p>
<p>
Since the orientation is described by 9 variables, there are
6 constraints between these variables. These constraints
are defined in function <b>TransformationMatrices.orientationConstraint</b>.
</p>
<p>
Note, that in the MultiBody library the rotation object is
never directly accessed but only with the access functions provided
in package TransformationMatrices. As a consequence, other implementations of
Rotation can be defined by adapting this package correspondingly.
</p>
</html>
"));
          end Orientation;

          function resolve1 "Transform vector from frame 2 to frame 1"
            extends Modelica.Icons.Function;
            input TransformationMatrices.Orientation T
            "Orientation object to rotate frame 1 into frame 2";
            input Real v2[3] "Vector in frame 2";
            output Real v1[3] "Vector in frame 1";
          algorithm
            v1 := transpose(T)*v2;
            annotation(Inline=true);
          end resolve1;

          function resolve2 "Transform vector from frame 1 to frame 2"
            extends Modelica.Icons.Function;
            input TransformationMatrices.Orientation T
            "Orientation object to rotate frame 1 into frame 2";
            input Real v1[3] "Vector in frame 1";
            output Real v2[3] "Vector in frame 2";
          algorithm
            v2 := T*v1;
            annotation(Inline=true);
          end resolve2;

          function absoluteRotation
          "Return absolute orientation object from another absolute and a relative orientation object"

            extends Modelica.Icons.Function;
            input TransformationMatrices.Orientation T1
            "Orientation object to rotate frame 0 into frame 1";
            input TransformationMatrices.Orientation T_rel
            "Orientation object to rotate frame 1 into frame 2";
            output TransformationMatrices.Orientation T2
            "Orientation object to rotate frame 0 into frame 2";
          algorithm
            T2 := T_rel*T1;
            annotation(Inline=true);
          end absoluteRotation;

          function planarRotation
          "Return orientation object of a planar rotation"
            import Modelica.Math;
            extends Modelica.Icons.Function;
            input Real e[3](each final unit="1")
            "Normalized axis of rotation (must have length=1)";
            input Modelica.SIunits.Angle angle
            "Rotation angle to rotate frame 1 into frame 2 along axis e";
            output TransformationMatrices.Orientation T
            "Orientation object to rotate frame 1 into frame 2";
          algorithm
            T := [e]*transpose([e]) + (identity(3) - [e]*transpose([e]))*Math.cos(
              angle) - skew(e)*Math.sin(angle);
            annotation(Inline=true);
          end planarRotation;

          function axisRotation
          "Return rotation object to rotate around one frame axis"
            import Modelica.Math.*;
            extends Modelica.Icons.Function;
            input Integer axis(min=1, max=3) "Rotate around 'axis' of frame 1";
            input Modelica.SIunits.Angle angle
            "Rotation angle to rotate frame 1 into frame 2 along 'axis' of frame 1";
            output TransformationMatrices.Orientation T
            "Orientation object to rotate frame 1 into frame 2";
          algorithm
            T := if axis == 1 then [1, 0, 0; 0, cos(angle), sin(angle); 0, -sin(angle),
               cos(angle)] else if axis == 2 then [cos(angle), 0, -sin(angle); 0, 1,
              0; sin(angle), 0, cos(angle)] else [cos(angle), sin(angle), 0; -sin(
              angle), cos(angle), 0; 0, 0, 1];
            annotation(Inline=true);
          end axisRotation;

          function from_nxy
          "Return orientation object from n_x and n_y vectors"
            extends Modelica.Icons.Function;
            input Real n_x[3](each final unit="1")
            "Vector in direction of x-axis of frame 2, resolved in frame 1";
            input Real n_y[3](each final unit="1")
            "Vector in direction of y-axis of frame 2, resolved in frame 1";
            output TransformationMatrices.Orientation T
            "Orientation object to rotate frame 1 into frame 2";
        protected
            Real abs_n_x=sqrt(n_x*n_x);
            Real e_x[3](each final unit="1")=if abs_n_x < 1.e-10 then {1,0,0} else n_x/abs_n_x;
            Real n_z_aux[3](each final unit="1")=cross(e_x, n_y);
            Real n_y_aux[3](each final unit="1")=if n_z_aux*n_z_aux > 1.0e-6 then n_y else (if abs(e_x[1])
                 > 1.0e-6 then {0,1,0} else {1,0,0});
            Real e_z_aux[3](each final unit="1")=cross(e_x, n_y_aux);
            Real e_z[3](each final unit="1")=e_z_aux/sqrt(e_z_aux*e_z_aux);
          algorithm
            T := {e_x,cross(e_z, e_x),e_z};
            annotation (Documentation(info="<html>
<p>
It is assumed that the two input vectors n_x and n_y are
resolved in frame 1 and are directed along the x and y axis
of frame 2 (i.e., n_x and n_y are orthogonal to each other)
The function returns the orientation object T to rotate from
frame 1 to frame 2.
</p>
<p>
The function is robust in the sense that it returns always
an orientation object T, even if n_y is not orthogonal to n_x.
This is performed in the following way:
</p>
<p>
If n_x and n_y are not orthogonal to each other, first a unit
vector e_y is determined that is orthogonal to n_x and is lying
in the plane spanned by n_x and n_y. If n_x and n_y are parallel
or nearly parallel to each other, a vector e_y is selected
arbitrarily such that e_x and e_y are orthogonal to each other.
</p>
</html>"));
          end from_nxy;
          annotation (Documentation(info="<HTML>
<p>
Package <b>Frames.TransformationMatrices</b> contains type definitions and
functions to transform rotational frame quantities using
transformation matrices.
</p>
<h4>Content</h4>
<p>In the table below an example is given for every function definition.
The used variables have the following declaration:
</p>
<pre>
   Orientation T, T1, T2, T_rel, T_inv;
   Real[3]     v1, v2, w1, w2, n_x, n_y, n_z, e, e_x, res_ori, phi;
   Real[6]     res_equal;
   Real        L, angle;
</pre>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function/type</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><b>Orientation T;</b></td>
      <td valign=\"top\">New type defining an orientation object that describes<br>
          the rotation of frame 1 into frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\"><b>der_Orientation</b> der_T;</td>
      <td valign=\"top\">New type defining the first time derivative
         of Frames.Orientation.
      </td>
  </tr>
  <tr><td valign=\"top\">res_ori = <b>orientationConstraint</b>(T);</td>
      <td valign=\"top\">Return the constraints between the variables of an orientation object<br>
      (shall be zero).</td>
  </tr>
  <tr><td valign=\"top\">w1 = <b>angularVelocity1</b>(T, der_T);</td>
      <td valign=\"top\">Return angular velocity resolved in frame 1 from
          orientation object T<br> and its derivative der_T.
     </td>
  </tr>
  <tr><td valign=\"top\">w2 = <b>angularVelocity2</b>(T, der_T);</td>
      <td valign=\"top\">Return angular velocity resolved in frame 2 from
          orientation object T<br> and its derivative der_T.
     </td>
  </tr>
  <tr><td valign=\"top\">v1 = <b>resolve1</b>(T,v2);</td>
      <td valign=\"top\">Transform vector v2 from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">v2 = <b>resolve2</b>(T,v1);</td>
      <td valign=\"top\">Transform vector v1 from frame 1 to frame 2.
     </td>
  </tr>
  <tr><td valign=\"top\">[v1,w1] = <b>multipleResolve1</b>(T, [v2,w2]);</td>
      <td valign=\"top\">Transform several vectors from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">[v2,w2] = <b>multipleResolve2</b>(T, [v1,w1]);</td>
      <td valign=\"top\">Transform several vectors from frame 1 to frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\">D1 = <b>resolveDyade1</b>(T,D2);</td>
      <td valign=\"top\">Transform second order tensor D2 from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">D2 = <b>resolveDyade2</b>(T,D1);</td>
      <td valign=\"top\">Transform second order tensor D1 from frame 1 to frame 2.
     </td>
  </tr>
  <tr><td valign=\"top\">T= <b>nullRotation</b>()</td>
      <td valign=\"top\">Return orientation object T that does not rotate a frame.
  </tr>
  <tr><td valign=\"top\">T_inv = <b>inverseRotation</b>(T);</td>
      <td valign=\"top\">Return inverse orientation object.
      </td>
  </tr>
  <tr><td valign=\"top\">T_rel = <b>relativeRotation</b>(T1,T2);</td>
      <td valign=\"top\">Return relative orientation object from two absolute
          orientation objects.
      </td>
  </tr>
  <tr><td valign=\"top\">T2 = <b>absoluteRotation</b>(T1,T_rel);</td>
      <td valign=\"top\">Return absolute orientation object from another
          absolute<br> and a relative orientation object.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>planarRotation</b>(e, angle);</td>
      <td valign=\"top\">Return orientation object of a planar rotation.
      </td>
  </tr>
  <tr><td valign=\"top\">angle = <b>planarRotationAngle</b>(e, v1, v2);</td>
      <td valign=\"top\">Return angle of a planar rotation, given the rotation axis<br>
        and the representations of a vector in frame 1 and frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>axisRotation</b>(i, angle);</td>
      <td valign=\"top\">Return orientation object T for rotation around axis i of frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>axesRotations</b>(sequence, angles);</td>
      <td valign=\"top\">Return rotation object to rotate in sequence around 3 axes. Example:<br>
          T = axesRotations({1,2,3},{90,45,-90});
      </td>
  </tr>
  <tr><td valign=\"top\">angles = <b>axesRotationsAngles</b>(T, sequence);</td>
      <td valign=\"top\">Return the 3 angles to rotate in sequence around 3 axes to<br>
          construct the given orientation object.
      </td>
  </tr>
  <tr><td valign=\"top\">phi = <b>smallRotation</b>(T);</td>
      <td valign=\"top\">Return rotation angles phi valid for a small rotation.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>from_nxy</b>(n_x, n_y);</td>
      <td valign=\"top\">Return orientation object from n_x and n_y vectors.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>from_nxz</b>(n_x, n_z);</td>
      <td valign=\"top\">Return orientation object from n_x and n_z vectors.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_T</b>(T);</td>
      <td valign=\"top\">Return orientation object R from transformation matrix T.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_T_inv</b>(T_inv);</td>
      <td valign=\"top\">Return orientation object R from inverse transformation matrix T_inv.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>from_Q</b>(Q);</td>
      <td valign=\"top\">Return orientation object T from quaternion orientation object Q.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>to_T</b>(R);</td>
      <td valign=\"top\">Return transformation matrix T from orientation object R.
  </tr>
  <tr><td valign=\"top\">T_inv = <b>to_T_inv</b>(R);</td>
      <td valign=\"top\">Return inverse transformation matrix T_inv from orientation object R.
      </td>
  </tr>
  <tr><td valign=\"top\">Q = <b>to_Q</b>(T);</td>
      <td valign=\"top\">Return quaternion orientation object Q from orientation object T.
      </td>
  </tr>
  <tr><td valign=\"top\">exy = <b>to_exy</b>(T);</td>
      <td valign=\"top\">Return [e_x, e_y] matrix of an orientation object T, <br>
          with e_x and e_y vectors of frame 2, resolved in frame 1.
  </tr>
</table>
</HTML>"));
        end TransformationMatrices;

        package Internal
        "Internal definitions that may be removed or changed (do not use)"
          extends Modelica.Icons.Package;

          type TransformationMatrix = Real[3, 3];

          type QuaternionBase = Real[4];

          function resolve1_der "Derivative of function Frames.resolve1(..)"
            import Modelica.Mechanics.MultiBody.Frames;
            extends Modelica.Icons.Function;
            input Orientation R
            "Orientation object to rotate frame 1 into frame 2";
            input Real v2[3] "Vector resolved in frame 2";
            input Real v2_der[3] "= der(v2)";
            output Real v1_der[3] "Derivative of vector v resolved in frame 1";
          algorithm
            v1_der := Frames.resolve1(R, v2_der + cross(R.w, v2));
            annotation(Inline=true);
          end resolve1_der;

          function resolve2_der "Derivative of function Frames.resolve2(..)"
            import Modelica.Mechanics.MultiBody.Frames;
            extends Modelica.Icons.Function;
            input Orientation R
            "Orientation object to rotate frame 1 into frame 2";
            input Real v1[3] "Vector resolved in frame 1";
            input Real v1_der[3] "= der(v1)";
            output Real v2_der[3] "Derivative of vector v resolved in frame 2";
          algorithm
            v2_der := Frames.resolve2(R, v1_der) - cross(R.w, Frames.resolve2(R, v1));
            annotation(Inline=true);
          end resolve2_der;
        end Internal;
        annotation ( Documentation(info="<HTML>
<p>
Package <b>Frames</b> contains type definitions and
functions to transform rotational frame quantities. The basic idea is to
hide the actual definition of an <b>orientation</b> in this package
by providing essentially type <b>Orientation</b> together with
<b>functions</b> operating on instances of this type.
</p>
<h4>Content</h4>
<p>In the table below an example is given for every function definition.
The used variables have the following declaration:
</p>
<pre>
   Frames.Orientation R, R1, R2, R_rel, R_inv;
   Real[3,3]   T, T_inv;
   Real[3]     v1, v2, w1, w2, n_x, n_y, n_z, e, e_x, res_ori, phi;
   Real[6]     res_equal;
   Real        L, angle;
</pre>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function/type</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><b>Orientation R;</b></td>
      <td valign=\"top\">New type defining an orientation object that describes<br>
          the rotation of frame 1 into frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\">res_ori = <b>orientationConstraint</b>(R);</td>
      <td valign=\"top\">Return the constraints between the variables of an orientation object<br>
      (shall be zero).</td>
  </tr>
  <tr><td valign=\"top\">w1 = <b>angularVelocity1</b>(R);</td>
      <td valign=\"top\">Return angular velocity resolved in frame 1 from
          orientation object R.
     </td>
  </tr>
  <tr><td valign=\"top\">w2 = <b>angularVelocity2</b>(R);</td>
      <td valign=\"top\">Return angular velocity resolved in frame 2 from
          orientation object R.
     </td>
  </tr>
  <tr><td valign=\"top\">v1 = <b>resolve1</b>(R,v2);</td>
      <td valign=\"top\">Transform vector v2 from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">v2 = <b>resolve2</b>(R,v1);</td>
      <td valign=\"top\">Transform vector v1 from frame 1 to frame 2.
     </td>
  </tr>
  <tr><td valign=\"top\">v2 = <b>resolveRelative</b>(v1,R1,R2);</td>
      <td valign=\"top\">Transform vector v1 from frame 1 to frame 2
          using absolute orientation objects R1 of frame 1 and R2 of frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\">D1 = <b>resolveDyade1</b>(R,D2);</td>
      <td valign=\"top\">Transform second order tensor D2 from frame 2 to frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">D2 = <b>resolveDyade2</b>(R,D1);</td>
      <td valign=\"top\">Transform second order tensor D1 from frame 1 to frame 2.
     </td>
  </tr>
  <tr><td valign=\"top\">R = <b>nullRotation</b>()</td>
      <td valign=\"top\">Return orientation object R that does not rotate a frame.
  </tr>
  <tr><td valign=\"top\">R_inv = <b>inverseRotation</b>(R);</td>
      <td valign=\"top\">Return inverse orientation object.
      </td>
  </tr>
  <tr><td valign=\"top\">R_rel = <b>relativeRotation</b>(R1,R2);</td>
      <td valign=\"top\">Return relative orientation object from two absolute
          orientation objects.
      </td>
  </tr>
  <tr><td valign=\"top\">R2 = <b>absoluteRotation</b>(R1,R_rel);</td>
      <td valign=\"top\">Return absolute orientation object from another
          absolute<br> and a relative orientation object.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>planarRotation</b>(e, angle, der_angle);</td>
      <td valign=\"top\">Return orientation object of a planar rotation.
      </td>
  </tr>
  <tr><td valign=\"top\">angle = <b>planarRotationAngle</b>(e, v1, v2);</td>
      <td valign=\"top\">Return angle of a planar rotation, given the rotation axis<br>
        and the representations of a vector in frame 1 and frame 2.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>axisRotation</b>(axis, angle, der_angle);</td>
      <td valign=\"top\">Return orientation object R to rotate around angle along axis of frame 1.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>axesRotations</b>(sequence, angles, der_angles);</td>
      <td valign=\"top\">Return rotation object to rotate in sequence around 3 axes. Example:<br>
          R = axesRotations({1,2,3},{pi/2,pi/4,-pi}, zeros(3));
      </td>
  </tr>
  <tr><td valign=\"top\">angles = <b>axesRotationsAngles</b>(R, sequence);</td>
      <td valign=\"top\">Return the 3 angles to rotate in sequence around 3 axes to<br>
          construct the given orientation object.
      </td>
  </tr>
  <tr><td valign=\"top\">phi = <b>smallRotation</b>(R);</td>
      <td valign=\"top\">Return rotation angles phi valid for a small rotation R.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_nxy</b>(n_x, n_y);</td>
      <td valign=\"top\">Return orientation object from n_x and n_y vectors.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_nxz</b>(n_x, n_z);</td>
      <td valign=\"top\">Return orientation object from n_x and n_z vectors.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_T</b>(T,w);</td>
      <td valign=\"top\">Return orientation object R from transformation matrix T and
          its angular velocity w.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_T2</b>(T,der(T));</td>
      <td valign=\"top\">Return orientation object R from transformation matrix T and
          its derivative der(T).
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_T_inv</b>(T_inv,w);</td>
      <td valign=\"top\">Return orientation object R from inverse transformation matrix T_inv and
          its angular velocity w.
      </td>
  </tr>
  <tr><td valign=\"top\">R = <b>from_Q</b>(Q,w);</td>
      <td valign=\"top\">Return orientation object R from quaternion orientation object Q
          and its angular velocity w.
      </td>
  </tr>
  <tr><td valign=\"top\">T = <b>to_T</b>(R);</td>
      <td valign=\"top\">Return transformation matrix T from orientation object R.
  </tr>
  <tr><td valign=\"top\">T_inv = <b>to_T_inv</b>(R);</td>
      <td valign=\"top\">Return inverse transformation matrix T_inv from orientation object R.
      </td>
  </tr>
  <tr><td valign=\"top\">Q = <b>to_Q</b>(R);</td>
      <td valign=\"top\">Return quaternion orientation object Q from orientation object R.
      </td>
  </tr>
  <tr><td valign=\"top\">exy = <b>to_exy</b>(R);</td>
      <td valign=\"top\">Return [e_x, e_y] matrix of an orientation object R, <br>
          with e_x and e_y vectors of frame 2, resolved in frame 1.
  </tr>
  <tr><td valign=\"top\">L = <b>length</b>(n_x);</td>
      <td valign=\"top\">Return length L of a vector n_x.
      </td>
  </tr>
  <tr><td valign=\"top\">e_x = <b>normalize</b>(n_x);</td>
      <td valign=\"top\">Return normalized vector e_x of n_x such that length of e_x is one.
      </td>
  </tr>
  <tr><td valign=\"top\">e = <b>axis</b>(i);</td>
      <td valign=\"top\">Return unit vector e directed along axis i
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Frames.Quaternions\">Quaternions</a></td>
      <td valign=\"top\"><b>Package</b> with functions to transform rotational frame quantities based
          on quaternions (also called Euler parameters).
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Frames.TransformationMatrices\">TransformationMatrices</a></td>
      <td valign=\"top\"><b>Package</b> with functions to transform rotational frame quantities based
          on transformation matrices.
      </td>
  </tr>
</table>
</HTML>"));
      end Frames;

      package Interfaces
      "Connectors and partial models for 3-dim. mechanical components"
        extends Modelica.Icons.InterfacesPackage;

        connector Frame
        "Coordinate system fixed to the component with one cut-force and cut-torque (no icon)"
          import SI = Modelica.SIunits;
          SI.Position r_0[3]
          "Position vector from world frame to the connector frame origin, resolved in world frame";
          Frames.Orientation R
          "Orientation object to rotate the world frame into the connector frame";
          flow SI.Force f[3] "Cut-force resolved in connector frame" annotation (
              unassignedMessage="All Forces cannot be uniquely calculated.
The reason could be that the mechanism contains
a planar loop or that joints constrain the
same motion. For planar loops, use for one
revolute joint per loop the joint
Joints.RevolutePlanarLoopConstraint instead of
Joints.Revolute.");
          flow SI.Torque t[3] "Cut-torque resolved in connector frame";
          annotation (Documentation(info="<html>
<p>
Basic definition of a coordinate system that is fixed to a mechanical
component. In the origin of the coordinate system the cut-force
and the cut-torque is acting. This component has no icon definition
and is only used by inheritance from frame connectors to define
different icons.
</p>
</html>"));
        end Frame;

        connector Frame_a
        "Coordinate system fixed to the component with one cut-force and cut-torque (filled rectangular icon)"
          extends Frame;

          annotation (defaultComponentName="frame_a",
           Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1},
                initialScale=0.16), graphics={Rectangle(
                  extent={{-10,10},{10,-10}},
                  lineColor={95,95,95},
                  lineThickness=0.5), Rectangle(
                  extent={{-30,100},{30,-100}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid)}),
           Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1},
                initialScale=0.16), graphics={Text(
                  extent={{-140,-50},{140,-88}},
                  lineColor={0,0,0},
                  textString="%name"), Rectangle(
                  extent={{-12,40},{12,-40}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid)}),
            Documentation(info="<html>
<p>
Basic definition of a coordinate system that is fixed to a mechanical
component. In the origin of the coordinate system the cut-force
and the cut-torque is acting.
This component has a filled rectangular icon.
</p>
</html>"));
        end Frame_a;

        connector Frame_b
        "Coordinate system fixed to the component with one cut-force and cut-torque (non-filled rectangular icon)"
          extends Frame;

          annotation (defaultComponentName="frame_b",
           Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1},
                initialScale=0.16), graphics={Rectangle(
                  extent={{-10,10},{10,-10}},
                  lineColor={95,95,95},
                  lineThickness=0.5), Rectangle(
                  extent={{-30,100},{30,-100}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
           Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1},
                initialScale=0.16), graphics={Text(
                  extent={{-140,-50},{140,-88}},
                  lineColor={0,0,0},
                  textString="%name"), Rectangle(
                  extent={{-12,40},{12,-40}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
            Documentation(info="<html>
<p>
Basic definition of a coordinate system that is fixed to a mechanical
component. In the origin of the coordinate system the cut-force
and the cut-torque is acting. This component has a non-filled rectangular icon.
</p>
</html>"));
        end Frame_b;

        partial function partialGravityAcceleration
           input Modelica.SIunits.Position r[3]
          "Position vector from world frame to actual point, resolved in world frame";
           output Modelica.SIunits.Acceleration gravity[3]
          "Gravity acceleration at position r, resolved in world frame";
          annotation (Documentation(info="<html>
<p>
This partial function defines the interface to the gravity function
used in the World object. All gravity field functions must inherit
from this function. The input to the function is the absolute position
vector of a point in the gravity field, whereas the output is the
gravity acceleration at this point, resolved in the world frame.
</p>
</html>"));
        end partialGravityAcceleration;

        partial function partialSurfaceCharacteristic
           input Integer nu "Number of points in u-Dimension";
           input Integer nv "Number of points in v-Dimension";
           input Boolean multiColoredSurface=false
          "= true: Color is defined for each surface point";
           output Modelica.SIunits.Position X[nu,nv]
          "[nu,nv] positions of points in x-Direction resolved in surface frame";
           output Modelica.SIunits.Position Y[nu,nv]
          "[nu,nv] positions of points in y-Direction resolved in surface frame";
           output Modelica.SIunits.Position Z[nu,nv]
          "[nu,nv] positions of points in z-Direction resolved in surface frame";
           output Real C[if multiColoredSurface then nu else 0,
                         if multiColoredSurface then nv else 0,3]
          "[nu,nv,3] Color array, defining the color for each surface point";
        end partialSurfaceCharacteristic;
        annotation ( Documentation(info="<html>
<p>
This package contains connectors and partial models (i.e., models
that are only used to build other models) of the MultiBody library.
</p>
</html>"));
      end Interfaces;

      package Joints "Components that constrain the motion between two frames"
        import SI = Modelica.SIunits;
        extends Modelica.Icons.Package;

        model Revolute
        "Revolute joint (1 rotational degree-of-freedom, 2 potential states, optional axis flange)"

          import SI = Modelica.SIunits;

          Modelica.Mechanics.Rotational.Interfaces.Flange_a axis if useAxisFlange
          "1-dim. rotational flange that drives the joint"
            annotation (Placement(transformation(extent={{10,90},{-10,110}}, rotation=
                   0)));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b support if useAxisFlange
          "1-dim. rotational flange of the drive support (assumed to be fixed in the world frame, NOT in the joint)"
            annotation (Placement(transformation(extent={{-70,90},{-50,110}},
                  rotation=0)));

          Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a
          "Coordinate system fixed to the joint with one cut-force and cut-torque"
            annotation (Placement(transformation(extent={{-116,-16},{-84,16}},
                  rotation=0)));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b
          "Coordinate system fixed to the joint with one cut-force and cut-torque"
            annotation (Placement(transformation(extent={{84,-16},{116,16}},
                  rotation=0)));

          parameter Boolean useAxisFlange=false
          "= true, if axis flange is enabled"
            annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
          parameter Boolean animation=true
          "= true, if animation shall be enabled (show axis as cylinder)";
          parameter Modelica.Mechanics.MultiBody.Types.Axis n={0,0,1}
          "Axis of rotation resolved in frame_a (= same as in frame_b)"
            annotation (Evaluate=true);
          constant SI.Angle phi_offset=0
          "Relative angle offset (angle = phi_offset + phi)";
          parameter SI.Distance cylinderLength=world.defaultJointLength
          "Length of cylinder representing the joint axis"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Distance cylinderDiameter=world.defaultJointWidth
          "Diameter of cylinder representing the joint axis"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor
          "Color of cylinder representing the joint axis"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient
            specularCoefficient =                                                            world.defaultSpecularCoefficient
          "Reflection of ambient light (= 0: light is completely absorbed)"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter StateSelect stateSelect=StateSelect.prefer
          "Priority to use joint angle phi and w=der(phi) as states"   annotation(Dialog(tab="Advanced"));

          SI.Angle phi(start=0, final stateSelect=stateSelect)
          "Relative rotation angle from frame_a to frame_b"
             annotation (unassignedMessage="
The rotation angle phi of a revolute joint cannot be determined.
Possible reasons:
- A non-zero mass might be missing on either side of the parts
  connected to the revolute joint.
- Too many StateSelect.always are defined and the model
  has less degrees of freedom as specified with this setting
  (remove all StateSelect.always settings).
");
          SI.AngularVelocity w(start=0, stateSelect=stateSelect)
          "First derivative of angle phi (relative angular velocity)";
          SI.AngularAcceleration a(start=0)
          "Second derivative of angle phi (relative angular acceleration)";
          SI.Torque tau "Driving torque in direction of axis of rotation";
          SI.Angle angle "= phi_offset + phi";

      protected
          outer Modelica.Mechanics.MultiBody.World world;
          parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(
                                               n,0.0)
          "Unit vector in direction of rotation axis, resolved in frame_a (= same as in frame_b)";
          Frames.Orientation R_rel
          "Relative orientation object from frame_a to frame_b or from frame_b to frame_a";
          Visualizers.Advanced.Shape cylinder(
            shapeType="cylinder",
            color=cylinderColor,
            specularCoefficient=specularCoefficient,
            length=cylinderLength,
            width=cylinderDiameter,
            height=cylinderDiameter,
            lengthDirection=e,
            widthDirection={0,1,0},
            r_shape=-e*(cylinderLength/2),
            r=frame_a.r_0,
            R=frame_a.R) if world.enableAnimation and animation;

      protected
          Modelica.Mechanics.Rotational.Components.Fixed fixed
          "support flange is fixed to ground"
            annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
          Rotational.Interfaces.InternalSupport internalAxis(tau=tau)
            annotation (Placement(transformation(extent={{-10,90},{10,70}})));
          Rotational.Sources.ConstantTorque constantTorque(tau_constant=0) if not useAxisFlange
            annotation (Placement(transformation(extent={{40,70},{20,90}})));
        equation
          Connections.branch(frame_a.R, frame_b.R);

          assert(cardinality(frame_a) > 0,
            "Connector frame_a of revolute joint is not connected");
          assert(cardinality(frame_b) > 0,
            "Connector frame_b of revolute joint is not connected");

          angle = phi_offset + phi;
          w = der(phi);
          a = der(w);

          // relationships between quantities of frame_a and of frame_b
          frame_b.r_0 = frame_a.r_0;

          if rooted(frame_a.R) then
            R_rel = Frames.planarRotation(e, phi_offset + phi, w);
            frame_b.R = Frames.absoluteRotation(frame_a.R, R_rel);
            frame_a.f = -Frames.resolve1(R_rel, frame_b.f);
            frame_a.t = -Frames.resolve1(R_rel, frame_b.t);
          else
            R_rel = Frames.planarRotation(-e, phi_offset + phi, w);
            frame_a.R = Frames.absoluteRotation(frame_b.R, R_rel);
            frame_b.f = -Frames.resolve1(R_rel, frame_a.f);
            frame_b.t = -Frames.resolve1(R_rel, frame_a.t);
          end if;

          // d'Alemberts principle
          tau = -frame_b.t*e;

          // Connection to internal connectors
          phi = internalAxis.phi;

          connect(fixed.flange, support) annotation (Line(
              points={{-60,80},{-60,100}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(internalAxis.flange, axis) annotation (Line(
              points={{0,80},{0,100}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(constantTorque.flange, internalAxis.flange) annotation (Line(
              points={{20,80},{0,80}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (
            Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-100,-60},{-30,60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{30,-60},{100,60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(extent={{-100,59},{-30,-60}}, lineColor={0,0,0}),
                Rectangle(extent={{30,60},{100,-60}}, lineColor={0,0,0}),
                Text(
                  extent={{-90,14},{-54,-11}},
                  lineColor={128,128,128},
                  textString="a"),
                Text(
                  extent={{51,11},{87,-14}},
                  lineColor={128,128,128},
                  textString="b"),
                Line(
                  visible=useAxisFlange,
                  points={{-20,80},{-20,60}},
                  color={0,0,0}),
                Line(
                  visible=useAxisFlange,
                  points={{20,80},{20,60}},
                  color={0,0,0}),
                Rectangle(
                  visible=useAxisFlange,
                  extent={{-10,100},{10,50}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.VerticalCylinder,
                  fillColor={192,192,192}),
                Polygon(
                  visible=useAxisFlange,
                  points={{-10,30},{10,30},{30,50},{-30,50},{-10,30}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-30,11},{30,-10}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  visible=useAxisFlange,
                  points={{10,30},{30,50},{30,-50},{10,-30},{10,30}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-150,-110},{150,-80}},
                  lineColor={0,0,0},
                  textString="n=%n"),
                Text(
                  visible=useAxisFlange,
                  extent={{-150,-155},{150,-115}},
                  textString="%name",
                  lineColor={0,0,255}),
                Line(
                  visible=useAxisFlange,
                  points={{-20,70},{-60,70},{-60,60}},
                  color={0,0,0},
                  smooth=Smooth.None),
                Line(
                  visible=useAxisFlange,
                  points={{20,70},{50,70},{50,60}},
                  color={0,0,0},
                  smooth=Smooth.None),
                Line(
                  visible=useAxisFlange,
                  points={{-90,100},{-30,100}},
                  color={0,0,0}),
                Line(
                  visible=useAxisFlange,
                  points={{-30,100},{-50,80}},
                  color={0,0,0}),
                Line(
                  visible=useAxisFlange,
                  points={{-49,100},{-70,80}},
                  color={0,0,0}),
                Line(
                  visible=useAxisFlange,
                  points={{-70,100},{-90,80}},
                  color={0,0,0}),
                Text(
                  visible=not useAxisFlange,
                  extent={{-150,70},{150,110}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics),
            Documentation(info="<html>

<p>
Joint where frame_b rotates around axis n which is fixed in frame_a.
The two frames coincide when the rotation angle \"phi = 0\".
</p>

<p>
Optionally, two additional 1-dimensional mechanical flanges
(flange \"axis\" represents the driving flange and
flange \"support\" represents the bearing) can be enabled via
parameter <b>useAxisFlange</b>. The enabled axis flange can be
driven with elements of the
<a href=\"modelica://Modelica.Mechanics.Rotational\">Modelica.Mechanics.Rotational</a>
library.

</p>

<p>
In the \"Advanced\" menu it can be defined via parameter <b>stateSelect</b>
that the rotation angle \"phi\" and its derivative shall be definitely
used as states by setting stateSelect=StateSelect.always.
Default is StateSelect.prefer to use the joint angle and its
derivative as preferred states. The states are usually selected automatically.
In certain situations, especially when closed kinematic loops are present,
it might be slightly more efficient, when using the StateSelect.always setting.
</p>
<p>
If a <b>planar loop</b> is present, e.g., consisting of 4 revolute joints
where the joint axes are all parallel to each other, then there is no
longer a unique mathematical solution and the symbolic algorithms will
fail. Usually, an error message will be printed pointing out this
situation. In this case, one revolute joint of the loop has to be replaced
by a Joints.RevolutePlanarLoopConstraint joint. The
effect is that from the 5 constraints of a usual revolute joint,
3 constraints are removed and replaced by appropriate known
variables (e.g., the force in the direction of the axis of rotation is
treated as known with value equal to zero; for standard revolute joints,
this force is an unknown quantity).
</p>

<p>
In the following figure the animation of a revolute
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint. The black arrow is parameter
vector \"n\" defining the translation axis
(here: n = {0,0,1}, phi.start = 45<sup>o</sup>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Revolute.png\">

</html>
"));
        end Revolute;
        annotation ( Documentation(info="<HTML>
<p>
This package contains <b>joint components</b>,
that is, idealized, massless elements that constrain
the motion between frames. In subpackage <b>Assemblies</b>
aggregation joint components are provided to handle
kinematic loops analytically (this means that non-linear systems
of equations occuring in these joint aggregations are analytically
solved, i.e., robustly and efficiently).
</p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Model</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Prismatic\">Prismatic</a>
      <td valign=\"top\">Prismatic joint and actuated prismatic joint
          (1 translational degree-of-freedom, 2 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Prismatic.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Revolute\">Revolute</a>
 </td>
      <td valign=\"top\">Revolute and actuated revolute joint
          (1 rotational degree-of-freedom, 2 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Revolute.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Cylindrical\">Cylindrical</a></td>
      <td valign=\"top\">Cylindrical joint (2 degrees-of-freedom, 4 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Cylindrical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Universal\">Universal</a></td>
      <td valign=\"top\">Universal joint (2 degrees-of-freedom, 4 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Universal.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Planar\">Planar</a></td>
      <td valign=\"top\">Planar joint (3 degrees-of-freedom, 6 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Planar.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Spherical\">Spherical</a></td>
      <td valign=\"top\">Spherical joint (3 constraints and no potential states, or 3 degrees-of-freedom and 3 states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Spherical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.FreeMotion\">FreeMotion</a></td>
      <td valign=\"top\">Free motion joint (6 degrees-of-freedom, 12 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/FreeMotion.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.SphericalSpherical\">SphericalSpherical</a></td>
      <td valign=\"top\">Spherical - spherical joint aggregation (1 constraint,
          no potential states) with an optional point mass in the middle<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/SphericalSpherical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.UniversalSpherical\">UniversalSpherical</a></td>
      <td valign=\"top\">Universal - spherical joint aggregation (1 constraint, no potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/UniversalSpherical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.GearConstraint\">GearConstraint</a></td>
      <td valign=\"top\">Ideal 3-dim. gearbox (arbitrary shaft directions)
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies\">MultiBody.Joints.Assemblies</a></td>
      <td valign=\"top\"><b>Package</b> of joint aggregations for analytic loop handling.
      </td>
  </tr>
</table>
</HTML>"));
      end Joints;

      package Parts
      "Rigid components such as bodies with mass and inertia and massless rods"
        import SI = Modelica.SIunits;
        extends Modelica.Icons.Package;

        model FixedTranslation
        "Fixed translation of frame_b with respect to frame_a"

          import SI = Modelica.SIunits;
          import Modelica.Mechanics.MultiBody.Types;
          Interfaces.Frame_a frame_a
          "Coordinate system fixed to the component with one cut-force and cut-torque"
                                     annotation (Placement(transformation(extent={{
                    -116,-16},{-84,16}}, rotation=0)));
          Interfaces.Frame_b frame_b
          "Coordinate system fixed to the component with one cut-force and cut-torque"
                                     annotation (Placement(transformation(extent={{84,
                    -16},{116,16}}, rotation=0)));

          parameter Boolean animation=true
          "= true, if animation shall be enabled";
          parameter SI.Position r[3](start={0,0,0})
          "Vector from frame_a to frame_b resolved in frame_a";
          parameter Types.ShapeType shapeType="cylinder" " Type of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Position r_shape[3]={0,0,0}
          " Vector from frame_a to shape origin, resolved in frame_a"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter Types.Axis lengthDirection=r - r_shape
          " Vector in length direction of shape, resolved in frame_a"
            annotation (Evaluate=true, Dialog(tab="Animation", group=
                  "if animation = true", enable=animation));
          parameter Types.Axis widthDirection={0,1,0}
          " Vector in width direction of shape, resolved in frame_a"
            annotation (Evaluate=true, Dialog(tab="Animation", group=
                  "if animation = true", enable=animation));
          parameter SI.Length length=Modelica.Math.Vectors.length(
                                                   r - r_shape)
          " Length of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Distance width=length/world.defaultWidthFraction
          " Width of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Distance height=width " Height of shape."
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter Types.ShapeExtra extra=0.0
          " Additional parameter depending on shapeType (see docu of Visualizers.Advanced.Shape)."
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          input Types.Color color=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor
          " Color of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient
          "Reflection of ambient light (= 0: light is completely absorbed)"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));

      protected
          outer Modelica.Mechanics.MultiBody.World world;
          Visualizers.Advanced.Shape shape(
            shapeType=shapeType,
            color=color,
            specularCoefficient=specularCoefficient,
            r_shape=r_shape,
            lengthDirection=lengthDirection,
            widthDirection=widthDirection,
            length=length,
            width=width,
            height=height,
            extra=extra,
            r=frame_a.r_0,
            R=frame_a.R) if world.enableAnimation and animation;
        equation
          Connections.branch(frame_a.R, frame_b.R);
          assert(cardinality(frame_a) > 0 or cardinality(frame_b) > 0,
            "Neither connector frame_a nor frame_b of FixedTranslation object is connected");

          frame_b.r_0 = frame_a.r_0 + Frames.resolve1(frame_a.R, r);
          frame_b.R = frame_a.R;

          /* Force and torque balance */
          zeros(3) = frame_a.f + frame_b.f;
          zeros(3) = frame_a.t + frame_b.t + cross(r, frame_b.f);
          annotation (
            Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-99,5},{101,-5}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-150,85},{150,45}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{150,-50},{-150,-20}},
                  lineColor={0,0,0},
                  textString="%=r"),
                Text(
                  extent={{-89,38},{-53,13}},
                  lineColor={128,128,128},
                  textString="a"),
                Text(
                  extent={{57,39},{93,14}},
                  lineColor={128,128,128},
                  textString="b")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-100,5},{100,-5}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Line(
                  points={{-95,20},{-58,20}},
                  color={128,128,128},
                  arrow={Arrow.None,Arrow.Filled}),
                Line(
                  points={{-94,18},{-94,50}},
                  color={128,128,128},
                  arrow={Arrow.None,Arrow.Filled}),
                Text(
                  extent={{-72,35},{-58,24}},
                  lineColor={128,128,128},
                  textString="x"),
                Text(
                  extent={{-113,57},{-98,45}},
                  lineColor={128,128,128},
                  textString="y"),
                Line(points={{-100,-4},{-100,-69}}, color={128,128,128}),
                Line(points={{-100,-63},{90,-63}}, color={128,128,128}),
                Text(
                  extent={{-22,-39},{16,-63}},
                  lineColor={128,128,128},
                  textString="r"),
                Polygon(
                  points={{88,-59},{88,-68},{100,-63},{88,-59}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Line(points={{100,-3},{100,-68}}, color={128,128,128}),
                Line(
                  points={{69,20},{106,20}},
                  color={128,128,128},
                  arrow={Arrow.None,Arrow.Filled}),
                Line(
                  points={{70,18},{70,50}},
                  color={128,128,128},
                  arrow={Arrow.None,Arrow.Filled}),
                Text(
                  extent={{92,35},{106,24}},
                  lineColor={128,128,128},
                  textString="x"),
                Text(
                  extent={{51,57},{66,45}},
                  lineColor={128,128,128},
                  textString="y")}),
            Documentation(info="<HTML>
<p>
Component for a <b>fixed translation</b> of frame_b with respect
to frame_a, i.e., the relationship between connectors frame_a and frame_b
remains constant and frame_a is always <b>parallel</b> to frame_b.
</p>
<p>
By default, this component is visualized by a cylinder connecting
frame_a and frame_b, as shown in the figure below. Note, that the
two visualized frames are not part of the component animation and that
the animation may be switched off via parameter animation = <b>false</b>.
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedTranslation.png\" ALT=\"Parts.FixedTranslation\">
</HTML>"));
        end FixedTranslation;

        model Body
        "Rigid body with mass, inertia tensor and one frame connector (12 potential states)"

          import SI = Modelica.SIunits;
          import C = Modelica.Constants;
          import Modelica.Math.*;
          import Modelica.Mechanics.MultiBody.Types;
          import Modelica.Mechanics.MultiBody.Frames;
          Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a
          "Coordinate system fixed at body"
            annotation (Placement(transformation(extent={{-116,-16},{-84,16}},
                  rotation=0)));
          parameter Boolean animation=true
          "= true, if animation shall be enabled (show cylinder and sphere)";
          parameter SI.Position r_CM[3](start={0,0,0})
          "Vector from frame_a to center of mass, resolved in frame_a";
          parameter SI.Mass m(min=0, start = 1) "Mass of rigid body";
          parameter SI.Inertia I_11(min=0) = 0.001
          " (1,1) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_22(min=0) = 0.001
          " (2,2) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_33(min=0) = 0.001
          " (3,3) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_21(min=-C.inf)=0
          " (2,1) element of inertia tensor"                                         annotation (
              Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_31(min=-C.inf)=0
          " (3,1) element of inertia tensor"                                         annotation (
              Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_32(min=-C.inf)=0
          " (3,2) element of inertia tensor"                                         annotation (
              Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));

          SI.Position r_0[3](start={0,0,0}, each stateSelect=if enforceStates then
                      StateSelect.always else StateSelect.avoid)
          "Position vector from origin of world frame to origin of frame_a"
            annotation(Dialog(tab="Initialization", showStartAttribute=true));
          SI.Velocity v_0[3](start={0,0,0}, each stateSelect=if enforceStates then StateSelect.always else
                      StateSelect.avoid)
          "Absolute velocity of frame_a, resolved in world frame (= der(r_0))"
            annotation(Dialog(tab="Initialization", showStartAttribute=true));
          SI.Acceleration a_0[3](start={0,0,0})
          "Absolute acceleration of frame_a resolved in world frame (= der(v_0))"
            annotation(Dialog(tab="Initialization", showStartAttribute=true));

          parameter Boolean angles_fixed = false
          "= true, if angles_start are used as initial values, else as guess values"
            annotation(Evaluate=true, choices(__Dymola_checkBox=true), Dialog(tab="Initialization"));
          parameter SI.Angle angles_start[3]={0,0,0}
          "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b"
            annotation (Dialog(tab="Initialization"));
          parameter Types.RotationSequence sequence_start={1,2,3}
          "Sequence of rotations to rotate frame_a into frame_b at initial time"
            annotation (Evaluate=true, Dialog(tab="Initialization"));

          parameter Boolean w_0_fixed = false
          "= true, if w_0_start are used as initial values, else as guess values"
            annotation(Evaluate=true, choices(__Dymola_checkBox=true), Dialog(tab="Initialization"));
          parameter SI.AngularVelocity w_0_start[3]={0,0,0}
          "Initial or guess values of angular velocity of frame_a resolved in world frame"
            annotation (Dialog(tab="Initialization"));

          parameter Boolean z_0_fixed = false
          "= true, if z_0_start are used as initial values, else as guess values"
            annotation(Evaluate=true, choices(__Dymola_checkBox=true), Dialog(tab="Initialization"));
          parameter SI.AngularAcceleration z_0_start[3]={0,0,0}
          "Initial values of angular acceleration z_0 = der(w_0)"
            annotation (Dialog(tab="Initialization"));

          parameter SI.Diameter sphereDiameter=world.defaultBodyDiameter
          "Diameter of sphere"   annotation (Dialog(
              tab="Animation",
              group="if animation = true",
              enable=animation));
          input Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor
          "Color of sphere"   annotation (Dialog(
              tab="Animation",
              group="if animation = true",
              enable=animation));
          parameter SI.Diameter cylinderDiameter=sphereDiameter/Types.Defaults.
              BodyCylinderDiameterFraction "Diameter of cylinder"
            annotation (Dialog(
              tab="Animation",
              group="if animation = true",
              enable=animation));
          input Types.Color cylinderColor=sphereColor "Color of cylinder"
            annotation (Dialog(
              tab="Animation",
              group="if animation = true",
              enable=animation));
          input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient
          "Reflection of ambient light (= 0: light is completely absorbed)"
            annotation (Dialog(
              tab="Animation",
              group="if animation = true",
              enable=animation));
          parameter Boolean enforceStates=false
          " = true, if absolute variables of body object shall be used as states (StateSelect.always)"
            annotation (Evaluate=true,Dialog(tab="Advanced"));
          parameter Boolean useQuaternions=true
          " = true, if quaternions shall be used as potential states otherwise use 3 angles as potential states"
            annotation (Evaluate=true,Dialog(tab="Advanced"));
          parameter Types.RotationSequence sequence_angleStates={1,2,3}
          " Sequence of rotations to rotate world frame into frame_a around the 3 angles used as potential states"
             annotation (Evaluate=true, Dialog(tab="Advanced", enable=not
                  useQuaternions));

          final parameter SI.Inertia I[3, 3]=[I_11, I_21, I_31; I_21, I_22, I_32;
              I_31, I_32, I_33] "inertia tensor";
          final parameter Frames.Orientation R_start=Modelica.Mechanics.MultiBody.Frames.axesRotations(
              sequence_start, angles_start, zeros(3))
          "Orientation object from world frame to frame_a at initial time";
          final parameter SI.AngularAcceleration z_a_start[3]=Frames.resolve2(R_start, z_0_start)
          "Initial values of angular acceleration z_a = der(w_a), i.e., time derivative of angular velocity resolved in frame_a";

          SI.AngularVelocity w_a[3](start=Frames.resolve2(R_start, w_0_start),
                                    fixed=fill(w_0_fixed,3),
                                    each stateSelect=if enforceStates then (if useQuaternions then
                                    StateSelect.always else StateSelect.never) else StateSelect.avoid)
          "Absolute angular velocity of frame_a resolved in frame_a";
          SI.AngularAcceleration z_a[3](start=Frames.resolve2(R_start, z_0_start),fixed=fill(z_0_fixed,3))
          "Absolute angular acceleration of frame_a resolved in frame_a";
          SI.Acceleration g_0[3] "Gravity acceleration resolved in world frame";

      protected
          outer Modelica.Mechanics.MultiBody.World world;

          // Declarations for quaternions (dummies, if quaternions are not used)
          parameter Frames.Quaternions.Orientation Q_start=Frames.to_Q(R_start)
          "Quaternion orientation object from world frame to frame_a at initial time";
          Frames.Quaternions.Orientation Q(start=Q_start, each stateSelect=if
                enforceStates then (if useQuaternions then StateSelect.prefer else
                StateSelect.never) else StateSelect.avoid)
          "Quaternion orientation object from world frame to frame_a (dummy value, if quaternions are not used as states)";

          // Declaration for 3 angles
          parameter SI.Angle phi_start[3]=if sequence_start[1] ==
              sequence_angleStates[1] and sequence_start[2] == sequence_angleStates[2]
               and sequence_start[3] == sequence_angleStates[3] then angles_start else
               Frames.axesRotationsAngles(R_start, sequence_angleStates)
          "Potential angle states at initial time";
          SI.Angle phi[3](start=phi_start, each stateSelect=if enforceStates then (if
                useQuaternions then StateSelect.never else StateSelect.always) else
                StateSelect.avoid)
          "Dummy or 3 angles to rotate world frame into frame_a of body";
          SI.AngularVelocity phi_d[3](each stateSelect=if enforceStates then (if
                useQuaternions then StateSelect.never else StateSelect.always) else
                StateSelect.avoid) "= der(phi)";
          SI.AngularAcceleration phi_dd[3] "= der(phi_d)";

          // Declarations for animation
          Visualizers.Advanced.Shape cylinder(
            shapeType="cylinder",
            color=cylinderColor,
            specularCoefficient=specularCoefficient,
            length=if Modelica.Math.Vectors.length(r_CM) > sphereDiameter/2 then
                      Modelica.Math.Vectors.length(r_CM) - (if cylinderDiameter > 1.1*
                sphereDiameter then sphereDiameter/2 else 0) else 0,
            width=cylinderDiameter,
            height=cylinderDiameter,
            lengthDirection=r_CM,
            widthDirection={0,1,0},
            r=frame_a.r_0,
            R=frame_a.R) if world.enableAnimation and animation;
          Visualizers.Advanced.Shape sphere(
            shapeType="sphere",
            color=sphereColor,
            specularCoefficient=specularCoefficient,
            length=sphereDiameter,
            width=sphereDiameter,
            height=sphereDiameter,
            lengthDirection={1,0,0},
            widthDirection={0,1,0},
            r_shape=r_CM - {1,0,0}*sphereDiameter/2,
            r=frame_a.r_0,
            R=frame_a.R) if world.enableAnimation and animation and sphereDiameter > 0;
        initial equation
          if angles_fixed then
            // Initialize positional variables
            if not Connections.isRoot(frame_a.R) then
              // frame_a.R is computed somewhere else
              zeros(3) = Frames.Orientation.equalityConstraint(frame_a.R, R_start);
            elseif useQuaternions then
              // frame_a.R is computed from quaternions Q
              zeros(3) = Frames.Quaternions.Orientation.equalityConstraint(Q, Q_start);
            else
              // frame_a.R is computed from the 3 angles 'phi'
              phi = phi_start;
            end if;
          end if;

        equation
          if enforceStates then
            Connections.root(frame_a.R);
          else
            Connections.potentialRoot(frame_a.R);
          end if;
          r_0 = frame_a.r_0;

          if not Connections.isRoot(frame_a.R) then
            // Body does not have states
            // Dummies
            Q = {0,0,0,1};
            phi = zeros(3);
            phi_d = zeros(3);
            phi_dd = zeros(3);
          elseif useQuaternions then
            // Use Quaternions as states (with dynamic state selection)
            frame_a.R = Frames.from_Q(Q, Frames.Quaternions.angularVelocity2(Q, der(Q)));
            {0} = Frames.Quaternions.orientationConstraint(Q);

            // Dummies
            phi = zeros(3);
            phi_d = zeros(3);
            phi_dd = zeros(3);
          else
            // Use Cardan angles as states
            phi_d = der(phi);
            phi_dd = der(phi_d);
            frame_a.R = Frames.axesRotations(sequence_angleStates, phi, phi_d);

            // Dummies
            Q = {0,0,0,1};
          end if;

          // gravity acceleration at center of mass resolved in world frame
          g_0 = world.gravityAcceleration(frame_a.r_0 + Frames.resolve1(frame_a.R,
            r_CM));

          // translational kinematic differential equations
          v_0 = der(frame_a.r_0);
          a_0 = der(v_0);

          // rotational kinematic differential equations
          w_a = Frames.angularVelocity2(frame_a.R);
          z_a = der(w_a);

          /* Newton/Euler equations with respect to center of mass
            a_CM = a_a + cross(z_a, r_CM) + cross(w_a, cross(w_a, r_CM));
            f_CM = m*(a_CM - g_a);
            t_CM = I*z_a + cross(w_a, I*w_a);
       frame_a.f = f_CM
       frame_a.t = t_CM + cross(r_CM, f_CM);
    Inserting the first three equations in the last two results in:
  */
          frame_a.f = m*(Frames.resolve2(frame_a.R, a_0 - g_0) + cross(z_a, r_CM) +
            cross(w_a, cross(w_a, r_CM)));
          frame_a.t = I*z_a + cross(w_a, I*w_a) + cross(r_CM, frame_a.f);
          annotation (
            Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-100,30},{-3,-31}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,127,255}),
                Text(
                  extent={{150,-100},{-150,-70}},
                  lineColor={0,0,0},
                  textString="m=%m"),
                Text(
                  extent={{-150,110},{150,70}},
                  textString="%name",
                  lineColor={0,0,255}),
                Ellipse(
                  extent={{-20,60},{100,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={0,127,255})}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics),
            Documentation(info="<HTML>
<p>
<b>Rigid body</b> with mass and inertia tensor.
All parameter vectors have to be resolved in frame_a.
The <b>inertia tensor</b> has to be defined with respect to a
coordinate system that is parallel to frame_a with the
origin at the center of mass of the body.
</p>
<p>
By default, this component is visualized by a <b>cylinder</b> located
between frame_a and the center of mass and by a <b>sphere</b> that has
its center at the center of mass. If the cylinder length is smaller as
the radius of the sphere, e.g., since frame_a is located at the
center of mass, the cylinder is not displayed. Note, that
the animation may be switched off via parameter animation = <b>false</b>.
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Body.png\" ALT=\"Parts.Body\">
<p>
<b>States of Body Components</b>
</p>
<p>
Every body has potential states. If possible a tool will select
the states of joints and not the states of bodies because this is
usually the most efficient choice. In this case the position, orientation,
velocity and angular velocity of frame_a of the body will be computed
by the component that is connected to frame_a. However, if a body is moving
freely in space, variables of the body have to be used as states. The potential
states of the body are:
</p>
<ul>
<li> The <b>position vector</b> frame_a.r_0 from the origin of the
     world frame to the origin of frame_a of the body, resolved in
     the world frame and the <b>absolute velocity</b> v_0 of the origin of
     frame_a, resolved in the world frame (= der(frame_a.r_0)).</li>
</li>
<li> If parameter <b>useQuaternions</b> in the \"Advanced\" menu
     is <b>true</b> (this is the default), then <b>4 quaternions</b>
     are potential states. Additionally, the coordinates of the
     absolute angular velocity vector of the
     body are 3 potential states.<br>
     If <b>useQuaternions</b> in the \"Advanced\" menu
     is <b>false</b>, then <b>3 angles</b> and the derivatives of
     these angles are potential states. The orientation of frame_a
     is computed by rotating the world frame along the axes defined
     in parameter vector \"sequence_angleStates\" (default = {1,2,3}, i.e.,
     the Cardan angle sequence) around the angles used as potential states.
     For example, the default is to rotate the x-axis of the world frame
     around angles[1], the new y-axis around angles[2] and the new z-axis
     around angles[3], arriving at frame_a.
 </li>
</ul>
<p>
The quaternions have the slight disadvantage that there is a
non-linear constraint equation between the 4 quaternions.
Therefore, at least one non-linear equation has to be solved
during simulation. A tool might, however, analytically solve this
simple constraint equation. Using the 3 angles as states has the
disadvantage that there is a singular configuration in which a
division by zero will occur. If it is possible to determine in advance
for an application class that this singular configuration is outside
of the operating region, the 3 angles might be used as potential
states by setting <b>useQuaternions</b> = <b>false</b>.
</p>
<p>
In text books about 3-dimensional mechanics often 3 angles and the
angular velocity are used as states. This is not the case here, since
3 angles and their derivatives are used as potential states
(if useQuaternions = false). The reason
is that for real-time simulation the discretization formula of the
integrator might be \"inlined\" and solved together with the body equations.
By appropriate symbolic transformation the performance is
drastically increased if angles and their
derivatives are used as states, instead of angles and the angular
velocity.
</p>
<p>
Whether or not variables of the body are used as states is usually
automatically selected by the Modelica translator. If parameter
<b>enforceStates</b> is set to <b>true</b> in the \"Advanced\" menu,
then body variables are forced to be used as states according
to the setting of parameters \"useQuaternions\" and
\"sequence_angleStates\".
</p>
</HTML>"));
        end Body;

        model BodyShape
        "Rigid body with mass, inertia tensor, different shapes for animation, and two frame connectors (12 potential states)"

          import SI = Modelica.SIunits;
          import C = Modelica.Constants;
          import Modelica.Mechanics.MultiBody.Types;

          Interfaces.Frame_a frame_a
          "Coordinate system fixed to the component with one cut-force and cut-torque"
                                     annotation (Placement(transformation(extent={{
                    -116,-16},{-84,16}}, rotation=0)));
          Interfaces.Frame_b frame_b
          "Coordinate system fixed to the component with one cut-force and cut-torque"
                                     annotation (Placement(transformation(extent={{84,
                    -16},{116,16}}, rotation=0)));

          parameter Boolean animation=true
          "= true, if animation shall be enabled (show shape between frame_a and frame_b and optionally a sphere at the center of mass)";
          parameter Boolean animateSphere=true
          "= true, if mass shall be animated as sphere provided animation=true";
          parameter SI.Position r[3](start={0,0,0})
          "Vector from frame_a to frame_b resolved in frame_a";
          parameter SI.Position r_CM[3](start={0,0,0})
          "Vector from frame_a to center of mass, resolved in frame_a";
          parameter SI.Mass m(min=0, start = 1) "Mass of rigid body";
          parameter SI.Inertia I_11(min=0) = 0.001
          " (1,1) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_22(min=0) = 0.001
          " (2,2) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_33(min=0) = 0.001
          " (3,3) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_21(min=-C.inf) = 0
          " (2,1) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_31(min=-C.inf) = 0
          " (3,1) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));
          parameter SI.Inertia I_32(min=-C.inf) = 0
          " (3,2) element of inertia tensor"
            annotation (Dialog(group=
                  "Inertia tensor (resolved in center of mass, parallel to frame_a)"));

          SI.Position r_0[3](start={0,0,0}, each stateSelect=if enforceStates then
                      StateSelect.always else StateSelect.avoid)
          "Position vector from origin of world frame to origin of frame_a"
            annotation(Dialog(tab="Initialization", showStartAttribute=true));
          SI.Velocity v_0[3](start={0,0,0}, each stateSelect=if enforceStates then StateSelect.always else
                      StateSelect.avoid)
          "Absolute velocity of frame_a, resolved in world frame (= der(r_0))"
            annotation(Dialog(tab="Initialization", showStartAttribute=true));
          SI.Acceleration a_0[3](start={0,0,0})
          "Absolute acceleration of frame_a resolved in world frame (= der(v_0))"
            annotation(Dialog(tab="Initialization", showStartAttribute=true));

          parameter Boolean angles_fixed = false
          "= true, if angles_start are used as initial values, else as guess values"
            annotation(Evaluate=true, choices(__Dymola_checkBox=true), Dialog(tab="Initialization"));
          parameter SI.Angle angles_start[3]={0,0,0}
          "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b"
            annotation (Dialog(tab="Initialization"));
          parameter Types.RotationSequence sequence_start={1,2,3}
          "Sequence of rotations to rotate frame_a into frame_b at initial time"
            annotation (Evaluate=true, Dialog(tab="Initialization"));

          parameter Boolean w_0_fixed = false
          "= true, if w_0_start are used as initial values, else as guess values"
            annotation(Evaluate=true, choices(__Dymola_checkBox=true), Dialog(tab="Initialization"));
          parameter SI.AngularVelocity w_0_start[3]={0,0,0}
          "Initial or guess values of angular velocity of frame_a resolved in world frame"
            annotation (Dialog(tab="Initialization"));

          parameter Boolean z_0_fixed = false
          "= true, if z_0_start are used as initial values, else as guess values"
            annotation(Evaluate=true, choices(__Dymola_checkBox=true), Dialog(tab="Initialization"));
          parameter SI.AngularAcceleration z_0_start[3]={0,0,0}
          "Initial values of angular acceleration z_0 = der(w_0)"
            annotation (Dialog(tab="Initialization"));

          parameter Types.ShapeType shapeType="cylinder" " Type of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Position r_shape[3]={0,0,0}
          " Vector from frame_a to shape origin, resolved in frame_a"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter Types.Axis lengthDirection=r - r_shape
          " Vector in length direction of shape, resolved in frame_a"
            annotation (Evaluate=true, Dialog(tab="Animation", group=
                  "if animation = true", enable=animation));
          parameter Types.Axis widthDirection={0,1,0}
          " Vector in width direction of shape, resolved in frame_a"
            annotation (Evaluate=true, Dialog(tab="Animation", group=
                  "if animation = true", enable=animation));
          parameter SI.Length length=Modelica.Math.Vectors.length(
                                                   r - r_shape)
          " Length of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Distance width=length/world.defaultWidthFraction
          " Width of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Distance height=width " Height of shape."
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter Types.ShapeExtra extra=0.0
          " Additional parameter depending on shapeType (see docu of Visualizers.Advanced.Shape)."
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          input Types.Color color=Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor
          " Color of shape"
            annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
          parameter SI.Diameter sphereDiameter=2*width " Diameter of sphere"
            annotation (Dialog(tab="Animation", group=
                  "if animation = true and animateSphere = true",
                  enable=animation and animateSphere));
          input Types.Color sphereColor=color " Color of sphere of mass"
            annotation (Dialog(tab="Animation", group=
                  "if animation = true and animateSphere = true", enable=animation and animateSphere));
          input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient
          "Reflection of ambient light (= 0: light is completely absorbed)"
            annotation (Dialog(tab="Animation", group=
                  "if animation = true", enable=animation));
          parameter Boolean enforceStates=false
          " = true, if absolute variables of body object shall be used as states (StateSelect.always)"
            annotation (Dialog(tab="Advanced"));
          parameter Boolean useQuaternions=true
          " = true, if quaternions shall be used as potential states otherwise use 3 angles as potential states"
            annotation (Dialog(tab="Advanced"));
          parameter Types.RotationSequence sequence_angleStates={1,2,3}
          " Sequence of rotations to rotate world frame into frame_a around the 3 angles used as potential states"
             annotation (Evaluate=true, Dialog(tab="Advanced", enable=not
                  useQuaternions));

          FixedTranslation frameTranslation(r=r, animation=false)
            annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=
                   0)));
          Body body(
            r_CM=r_CM,
            m=m,
            I_11=I_11,
            I_22=I_22,
            I_33=I_33,
            I_21=I_21,
            I_31=I_31,
            I_32=I_32,
            animation=false,
            sequence_start=sequence_start,
            angles_fixed=angles_fixed,
            angles_start=angles_start,
            w_0_fixed=w_0_fixed,
            w_0_start=w_0_start,
            z_0_fixed=z_0_fixed,
            z_0_start=z_0_start,
            useQuaternions=useQuaternions,
            sequence_angleStates=sequence_angleStates,
            enforceStates=false)
            annotation (Placement(transformation(extent={{-27.3333,-70.3333},{13,-30}},
                  rotation=0)));
      protected
          outer Modelica.Mechanics.MultiBody.World world;
          Visualizers.Advanced.Shape shape1(
            shapeType=shapeType,
            color=color,
            specularCoefficient=specularCoefficient,
            length=length,
            width=width,
            height=height,
            lengthDirection=lengthDirection,
            widthDirection=widthDirection,
            r_shape=r_shape,
            extra=extra,
            r=frame_a.r_0,
            R=frame_a.R) if world.enableAnimation and animation;
          Visualizers.Advanced.Shape shape2(
            shapeType="sphere",
            color=sphereColor,
            specularCoefficient=specularCoefficient,
            length=sphereDiameter,
            width=sphereDiameter,
            height=sphereDiameter,
            lengthDirection={1,0,0},
            widthDirection={0,1,0},
            r_shape=r_CM - {1,0,0}*sphereDiameter/2,
            r=frame_a.r_0,
            R=frame_a.R) if world.enableAnimation and animation and animateSphere;
        equation
          r_0 = frame_a.r_0;
          v_0 = der(r_0);
          a_0 = der(v_0);
          connect(frame_a, frameTranslation.frame_a)
            annotation (Line(
              points={{-100,0},{-20,0}},
              color={95,95,95},
              thickness=0.5));
          connect(frame_b, frameTranslation.frame_b)
            annotation (Line(
              points={{100,0},{20,0}},
              color={95,95,95},
              thickness=0.5));
          connect(frame_a, body.frame_a) annotation (Line(
              points={{-100,0},{-60,0},{-60,-50.1666},{-27.3333,-50.1666}},
              color={95,95,95},
              thickness=0.5));
          annotation (
            Documentation(info="<HTML>
<p>
<b>Rigid body</b> with mass and inertia tensor and <b>two frame connectors</b>.
All parameter vectors have to be resolved in frame_a.
The <b>inertia tensor</b> has to be defined with respect to a
coordinate system that is parallel to frame_a with the
origin at the center of mass of the body. The coordinate system <b>frame_b</b>
is always parallel to <b>frame_a</b>.
</p>
<p>
By default, this component is visualized by any <b>shape</b> that can be
defined with Modelica.Mechanics.MultiBody.Visualizers.FixedShape. This shape is placed
between frame_a and frame_b (default: length(shape) = Frames.length(r)).
Additionally a <b>sphere</b> may be visualized that has
its center at the center of mass.
Note, that
the animation may be switched off via parameter animation = <b>false</b>.
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/BodyShape.png\" ALT=\"Parts.BodyShape\">
<p>
The following shapes can be defined via parameter <b>shapeType</b>,
e.g., shapeType=\"cone\":
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedShape.png\" ALT=\"Visualizers.FixedShape\">
<p>
A BodyShape component has potential states. For details of these
states and of the \"Advanced\" menu parameters, see model
<a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.Body\">MultiBody.Parts.Body</a>.
</p>
</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Text(
                  extent={{-150,110},{150,70}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-100},{150,-70}},
                  lineColor={0,0,0},
                  textString="%=r"),
                Rectangle(
                  extent={{-100,31},{101,-30}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,127,255}),
                Ellipse(
                  extent={{-60,60},{60,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={0,127,255}),
                Text(
                  extent={{-50,24},{55,-27}},
                  lineColor={0,0,0},
                  textString="%m"),
                Text(
                  extent={{55,12},{91,-13}},
                  lineColor={0,0,0},
                  textString="b"),
                Text(
                  extent={{-92,13},{-56,-12}},
                  lineColor={0,0,0},
                  textString="a")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Line(points={{-100,9},{-100,43}}, color={128,128,128}),
                Line(points={{100,0},{100,44}}, color={128,128,128}),
                Line(points={{-100,40},{90,40}}, color={135,135,135}),
                Polygon(
                  points={{90,44},{90,36},{100,40},{90,44}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-22,68},{20,40}},
                  lineColor={128,128,128},
                  textString="r"),
                Line(points={{-100,-10},{-100,-90}}, color={128,128,128}),
                Line(points={{-100,-84},{-10,-84}}, color={128,128,128}),
                Polygon(
                  points={{-10,-80},{-10,-88},{0,-84},{-10,-80}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-82,-66},{-56,-84}},
                  lineColor={128,128,128},
                  textString="r_CM"),
                Line(points={{0,-46},{0,-90}}, color={128,128,128})}));
        end BodyShape;
        annotation ( Documentation(info="<HTML>
<p>
Package <b>Parts</b> contains <b>rigid components</b> of a
multi-body system. These components may be used to build up
more complicated structures. For example, a part may be built up of
a \"Body\" and of several \"FixedTranslation\" components.
</p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Model</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.Fixed\">Fixed</a></td>
      <td valign=\"top\">Frame fixed in world frame at a given position.
          It is visualized with a shape, see <b>shapeType</b> below
         (the frames on the two
          sides do not belong to the component):<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Fixed.png\" ALT=\"model Parts.Fixed\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.FixedTranslation\">FixedTranslation</a></td>
      <td valign=\"top\">Fixed translation of frame_b with respect to frame_a.
          It is visualized with a shape, see <b>shapeType</b> below
          (the frames on the two sides do not belong to the component):<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedTranslation.png\" ALT=\"model Parts.FixedTranslation\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.FixedRotation\">FixedRotation</a></td>
      <td valign=\"top\">Fixed translation and fixed rotation of frame_b with respect to frame_a
          It is visualized with a shape, see <b>shapeType</b>  below
          (the frames on the two sides do not belong to the component):<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedRotation.png\" ALT=\"model Parts.FixedRotation\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.Body\">Body</a></td>
      <td valign=\"top\">Rigid body with mass, inertia tensor and one frame connector.
          It is visualized with a cylinder and a sphere at the
          center of mass:<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Body.png\" ALT=\"model Parts.Body\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.BodyShape\">BodyShape</a></td>
      <td valign=\"top\">Rigid body with mass, inertia tensor, different shapes
          (see <b>shapeType</b> below)
          for animation, and two frame connectors:<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/BodyShape.png\" ALT=\"model Parts.BodyShape\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.Fixed\">Fixed BodyBox</a></td>
      <td valign=\"top\">Rigid body with box shape (mass and animation properties are computed
          from box data and from density):<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/BodyBox.png\" ALT=\"model Parts.BodyBox\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.BodyCylinder\">BodyCylinder</a></td>
      <td valign=\"top\">Rigid body with cylinder shape (mass and animation properties
          are computed from cylinder data and from density):<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/BodyCylinder.png\" ALT=\"model Parts.BodyCylinder\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.PointMass\">PointMass</a></td>
      <td valign=\"top\">Rigid body where inertia tensor and rotation is neglected:<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Parts/PointMass.png\" ALT=\"model Parts.PointMass\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.Mounting1D\">Mounting1D</a></td>
      <td valign=\"top\"> Propagate 1-dim. support torque to 3-dim. system
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.Rotor1D\">Rotor1D</a></td>
      <td valign=\"top\">1D inertia attachable on 3-dim. bodies (without neglecting dynamic effects)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Parts/Rotor1D.png\" ALT=\"model Parts.Rotor1D\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Parts.BevelGear1D\">BevelGear1D</a></td>
      <td valign=\"top\">1D gearbox with arbitrary shaft directions (3D bearing frame)
      </td>
  </tr>
</table>
<p>
Components <b>Fixed</b>, <b>FixedTranslation</b>, <b>FixedRotation</b>
and <b>BodyShape</b> are visualized according to parameter
<b>shapeType</b>, that may have the following values (e.g., shapeType = \"box\"): <br>&nbsp;<br>
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedShape.png\" ALT=\"model Visualizers.FixedShape\">
<p>
All the details of the visualization shape parameters are
given in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.FixedShape\">Visualizers.FixedShape</a>
</p>
<p>
Colors in all animation parts are defined via parameter <b>color</b>.
This is an Integer vector with 3 elements, {r, g, b}, and specifies the
color of the shape. {r,g,b} are the \"red\", \"green\" and \"blue\" color parts,
given in the ranges 0 .. 255, respectively. The predefined type
<b>MultiBody.Types.Color</b> contains a menu
definition of the colors used in the MultiBody library
(this will be replaced by a color editor).
</p>
</HTML>
"));
      end Parts;

      package Visualizers "3-dimensional visual objects used for animation"
        extends Modelica.Icons.Package;

        package Advanced
        "Visualizers that require basic knowledge about Modelica in order to use them"
          extends Modelica.Icons.Package;

          model Shape
          "Visualizing an elementary object with variable size; all data have to be set as modifiers (see info layer)"

             extends ModelicaServices.Animation.Shape;
             extends
            Modelica.Utilities.Internal.PartialModelicaServices.Animation.PartialShape;

              annotation (
               Icon(coordinateSystem(
                   preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}},
                   grid={2,2}), graphics={
                  Rectangle(
                    extent={{-100,-100},{80,60}},
                    lineColor={0,0,255},
                    fillColor={255,255,255},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{-100,60},{-80,100},{100,100},{80,60},{-100,60}},
                    lineColor={0,0,255},
                    fillColor={192,192,192},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{100,100},{100,-60},{80,-100},{80,60},{100,100}},
                    lineColor={0,0,255},
                    fillColor={160,160,164},
                    fillPattern=FillPattern.Solid),
                  Text(
                    extent={{-100,-54},{80,8}},
                    lineColor={0,0,0},
                    textString="%shapeType"),
                  Text(
                    extent={{-150,150},{150,110}},
                    lineColor={0,0,255},
                    textString="%name")}),
               Documentation(info="<HTML>
<p>
Model <b>Shape</b> defines a visual shape that is
shown at the location of its reference coordinate system, called
'object frame' below. All describing variables such
as size and color can vary dynamically (with the only exception
of parameter shapeType). The default equations in the
declarations should be modified by providing appropriate modifier
quations. Model <b>Shape</b> is usually used as a basic building block to
implement simpler to use graphical components.
</p>
<p>
The following shapes are supported via
parameter <b>shapeType</b> (e.g., shapeType=\"box\"):<br>&nbsp;
</p>

<p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Shape.png\" ALT=\"model Visualizers.FixedShape\">
</p>

<p>&nbsp;<br>
The dark blue arrows in the figure above are directed along
variable <b>lengthDirection</b>. The light blue arrows are directed
along variable <b>widthDirection</b>. The <b>coordinate systems</b>
in the figure represent frame_a of the Shape component.
</p>
<p>
Additionally, external shapes are specified as DXF-files
(only 3-dim. Face is supported). External shapes must be named \"1\", \"2\", ... \"N\".
The corresponding definitions should be in files \"1.dxf\",
\"2.dxf\" etc. Since the DXF-files contain color and dimensions for
the individual faces, the corresponding information in the model
is currently ignored. The DXF-files must be found either in the current
directory or in the directory where the Shape instance is stored
that references the DXF file.
</p>

<p>
Via input variable <b>extra</b> additional sizing data is defined
according to:
</p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>shapeType</b></th><th>Meaning of variable <b>extra</b></th></tr>
<tr>
  <td valign=\"top\">\"cylinder\"</td>
  <td valign=\"top\">if extra &gt; 0, a black line is included in the
      cylinder to show the rotation of it.</td>
</tr>
<tr>
  <td valign=\"top\">\"cone\"</td>
  <td valign=\"top\">extra = diameter-left-side / diameter-right-side, i.e.,<br>
      extra = 1: cylinder<br>
      extra = 0: \"real\" cone.</td>
</tr>
<tr>
  <td valign=\"top\">\"pipe\"</td>
  <td valign=\"top\">extra = outer-diameter / inner-diameter, i.e, <br>
      extra = 1: cylinder that is completely hollow<br>
      extra = 0: cylinder without a hole.</td>
</tr>
<tr>
  <td valign=\"top\">\"gearwheel\"</td>
  <td valign=\"top\">extra is the number of teeth of the (external) gear.
If extra &lt; 0, an internal gear is visualized with |extra| teeth.
The axis of the gearwheel is along \"lengthDirection\", and usually:
width = height = 2*radiusOfGearWheel.</td>
</tr>
<tr>
  <td valign=\"top\">\"spring\"</td>
  <td valign=\"top\">extra is the number of windings of the spring.
      Additionally, \"height\" is <b>not</b> the \"height\" but
      2*coil-width.</td>
</tr>
</table>

<p>
Parameter <b>color</b> is a Real vector with 3 elements,
{r, g, b}, and specifies the color of the shape.
{r,g,b} are the \"red\", \"green\" and \"blue\" color parts.
Note, r g, b are given in the range 0 .. 255.
The predefined type <b>MultiBody.Types.Color</b> contains
a menu definition of the colors used in the MultiBody
library.
</p>

<p>
The variables under heading <b>Parameters</b> below
are declared as (time varying) <b>input</b> variables.
If the default equation is not appropriate, a corresponding
modifier equation has to be provided in the
model where a <b>Shape</b> instance is used, e.g., in the form
</p>
<pre>
    Visualizers.Advanced.Shape shape(length = sin(time));
</pre>
</HTML>
"));
          end Shape;
          annotation ( Documentation(info="<HTML>
<p>
Package <b>Visualizers.Advanced</b> contains components to visualize
3-dimensional shapes with dynamical sizes. None of the components
has a frame connector. The position and orientation is set via
modifiers. Basic knowledge of Modelica
is needed in order to utilize the components of this package.
These components have also to be used for models,
where the forces and torques in the frame connector are set via
equations (in this case, the models of the Visualizers package cannot be used,
since they all have frame connectors).
<p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow\">Arrow</a></td>
      <td valign=\"top\">Visualizing an arrow where all parts of the arrow can vary dynamically:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/Arrow.png\" ALT=\"model Visualizers.Advanced.Arrow\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.DoubleArrow\">DoubleArrow</a></td>
      <td valign=\"top\">Visualizing a double arrow where all parts of the arrow can vary dynamically:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/DoubleArrow.png\" ALT=\"model Visualizers.Advanced.DoubleArrow\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Shape</a></td>
      <td valign=\"top\">Visualizing an elementary object with variable size.
      The following shape types are supported:<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedShape.png\" ALT=\"model Visualizers.Advanced.Shape\">
      </td>
  </tr>

  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface\">Surface</a></td>
      <td valign=\"top\">Visualizing a moveable parameterized surface:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/Surface_small.png\">
      </td>
  </tr>

  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.PipeWithScalarField\">PipeWithScalarField</a></td>
      <td valign=\"top\">Visualizing a pipe with a scalar field represented by a color coding:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/PipeWithScalarFieldIcon.png\">
      </td>
  </tr>
</table>
</HTML>"));
        end Advanced;

        package Internal
        "Visualizers that will be replaced by improved versions in the future (don't use them)"
          extends Modelica.Icons.Package;

          model Lines
          "Visualizing a set of lines as cylinders with variable size, e.g., used to display characters (no Frame connector)"

            import SI = Modelica.SIunits;
            import Modelica.Mechanics.MultiBody;
            import Modelica.Mechanics.MultiBody.Types;
            import Modelica.Mechanics.MultiBody.Frames;
            import T =
            Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
            input Modelica.Mechanics.MultiBody.Frames.Orientation R=Frames.nullRotation()
            "Orientation object to rotate the world frame into the object frame"
                                                                                   annotation(Dialog);
            input SI.Position r[3]={0,0,0}
            "Position vector from origin of world frame to origin of object frame, resolved in world frame"
               annotation(Dialog);
            input SI.Position r_lines[3]={0,0,0}
            "Position vector from origin of object frame to the origin of 'lines' frame, resolved in object frame"
               annotation(Dialog);
            input Real n_x[3](each final unit="1")={1,0,0}
            "Vector in direction of x-axis of 'lines' frame, resolved in object frame"
               annotation(Dialog);
            input Real n_y[3](each final unit="1")={0,1,0}
            "Vector in direction of y-axis of 'lines' frame, resolved in object frame"
             annotation(Dialog);
            input SI.Position lines[:, 2, 2]=zeros(0, 2, 2)
            "List of start and end points of cylinders resolved in an x-y frame defined by n_x, n_y, e.g., {[0,0;1,1], [0,1;1,0], [2,0; 3,1]}"
            annotation(Dialog);
            input SI.Length diameter(min=0) = 0.05
            "Diameter of the cylinders defined by lines"
            annotation(Dialog);
            input Modelica.Mechanics.MultiBody.Types.Color color={0,128,255}
            "Color of cylinders"
            annotation(Dialog(__Dymola_colorSelector=true));
            input Types.SpecularCoefficient specularCoefficient = 0.7
            "Reflection of ambient light (= 0: light is completely absorbed)"
              annotation (Dialog);
        protected
            parameter Integer n=size(lines, 1) "Number of cylinders";
            T.Orientation R_rel=T.from_nxy(n_x, n_y);
            T.Orientation R_lines=T.absoluteRotation(R.T, R_rel);
            Modelica.SIunits.Position r_abs[3]=r + T.resolve1(R.T, r_lines);
            Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape cylinders[n](
              each shapeType="cylinder",
              lengthDirection={T.resolve1(R_rel, vector([lines[i, 2, :] - lines[i, 1,
                   :]; 0])) for i in 1:n},
              length={Modelica.Math.Vectors.length(
                                              lines[i, 2, :] - lines[i, 1, :]) for i in
                      1:n},
              r={r_abs + T.resolve1(R_lines, vector([lines[i, 1, :]; 0])) for i in 1:
                  n},
              each width=diameter,
              each height=diameter,
              each widthDirection={0,1,0},
              each color=color,
              each R=R,
              each specularCoefficient=specularCoefficient);
            annotation (
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                      100,100}}), graphics={
                  Rectangle(
                    extent={{-100,100},{100,-100}},
                    lineColor={128,128,128},
                    fillColor={255,255,255},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{-24,-34},{-82,40},{-72,46},{-14,-26},{-24,-34}},
                    lineColor={0,127,255},
                    fillColor={0,127,255},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{-82,-24},{-20,46},{-10,38},{-72,-32},{-82,-24}},
                    lineColor={0,127,255},
                    fillColor={0,127,255},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{42,-18},{10,40},{20,48},{50,-6},{42,-18}},
                    lineColor={0,127,255},
                    fillColor={0,127,255},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{10,-68},{84,48},{96,42},{24,-72},{10,-68}},
                    lineColor={0,127,255},
                    fillColor={0,127,255},
                    fillPattern=FillPattern.Solid),
                  Text(
                    extent={{-150,145},{150,105}},
                    textString="%name",
                    lineColor={0,0,255})}),
              Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                      {100,100}}),
                      graphics),
              Documentation(info="<HTML>
<p>
With model <b>Lines</b> a set of dynamic lines is defined
that are located relatively to frame_a. Every line
is represented by a cylinder. This allows, e.g., to define simple shaped
3-dimensional characters. Note, if the lines are fixed relatively to frame_a,
it is more convenient to use model <b>Visualizers.FixedLines</b>.
An example for dynamic lines is shown in the following figure:<br>&nbsp;
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedLines.png\" ALT=\"model Visualizers.FixedLines\">
<p>&nbsp;<br>
The two letters \"x\" and \"y\" are constructed with 4 lines
by providing the following data for input variable <b>lines</b>
</p>
<pre>
   lines = {[0, 0; 1, 1],[0, 1; 1, 0],[1.5, -0.5; 2.5, 1],[1.5, 1; 2, 0.25]}
</pre>
<p>
Via vectors <b>n_x</b> and <b>n_y</b> a two-dimensional
coordinate system is defined. The points defined with variable
<b>lines</b> are with respect to this coordinate system. For example
\"[0, 0; 1, 1]\" defines a line that starts at {0,0} and ends at {1,1}.
The diameter and color of all line cylinders are identical
and are defined by parameters.
</p>

</HTML>
"));

          end Lines;
          annotation (Documentation(info="<html>
<p>
This package contains components to construct 3-dim. fonts
with \"cylinder\" elements for the animation window.
This is just a temporary hack until 3-dim. fonts are supported in
Modelica tools. The components are used to construct the \"x\", \"y\",
\"z\" labels of coordinates systems in the animation.
</p>
</html>"));
        end Internal;
        annotation ( Documentation(info="<HTML>
<p>
Package <b>Visualizers</b> contains components to visualize
3-dimensional shapes. These components are the basis for the
animation features of the MultiBody library.
<p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.FixedShape\">FixedShape</a><br>
             <a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.FixedShape2\">FixedShape2</a></td>
      <td valign=\"top\">Visualizing an elementary shape with dynamically varying shape attributes.
      FixedShape has one connector frame_a, whereas FixedShape2 has additionally
          a frame_b for easier connection to further visual objects.
          The following shape types are supported:<br>&nbsp;<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedShape.png\" ALT=\"model Visualizers.FixedShape\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.FixedFrame\">FixedFrame</a></td>
      <td valign=\"top\">Visualizing a coordinate system including axes labels with fixed sizes:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/FixedFrame2.png\"
       ALT=\"model Visualizers.FixedFrame\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.FixedArrow\">FixedArrow</a>,<br>
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.SignalArrow\">SignalArrow</a></td>
      <td valign=\"top\">Visualizing an arrow. Model \"FixedArrow\" provides
      a fixed sized arrow, model \"SignalArrow\" provides
      an arrow with dynamically varying length that is defined
      by an input signal vector:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/Arrow.png\">
      </td>
  </tr>

  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Ground\">Ground</a></td>
      <td valign=\"top\">Visualizing the x-y plane by a box:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/GroundSmall.png\">
      </td>
  </tr>

  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Torus\">Torus</a></td>
      <td valign=\"top\">Visualizing a torus:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/TorusIcon.png\">
      </td>
  </tr>

  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.VoluminousWheel\">VoluminousWheel</a></td>
      <td valign=\"top\">Visualizing a wheel:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/VoluminousWheelIcon.png\">
      </td>
  </tr>

  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.PipeWithScalarField\">PipeWithScalarField</a></td>
      <td valign=\"top\">Visualizing a pipe with a scalar field represented by a color coding:<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/PipeWithScalarFieldIcon.png\">
      </td>
  </tr>

<tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced\">Advanced</a></td>
      <td valign=\"top\"> <b>Package</b> that contains components to visualize
          3-dimensional shapes where all parts of the shape
          can vary dynamically. Basic knowledge of Modelica is
          needed in order to utilize the components of this package.
      </td>
  </tr>
</table>
<p>
The colors of the visualization components are declared with
the predefined type <b>MultiBody.Types.Color</b>.
This is a vector with 3 elements,
{r, g, b}, and specifies the color of the shape.
{r,g,b} are the \"red\", \"green\" and \"blue\" color parts.
Note, r g, b are given as Integer[3] in the ranges 0 .. 255,
respectively.
</p>
</HTML>"));
      end Visualizers;

      package Types
      "Constants and types with choices, especially to build menus"
        extends Modelica.Icons.Package;

        type Axis = Modelica.Icons.TypeReal[3](each final unit="1")
        "Axis vector with choices for menus"                                        annotation (
          preferedView="text",
          Evaluate=true,
          choices(
            choice={1,0,0} "{1,0,0} \"x axis\"",
            choice={0,1,0} "{0,1,0} \"y axis\"",
            choice={0,0,1} "{0,0,1} \"z axis\"",
            choice={-1,0,0} "{-1,0,0} \"negative x axis\"",
            choice={0,-1,0} "{0,-1,0} \"negative y axis\"",
            choice={0,0,-1} "{0,0,-1} \"negative z axis\""),
          Documentation(info="<html>
</html>"));

        type AxisLabel = Modelica.Icons.TypeString
        "Label of axis with choices for menus"                                            annotation (
            preferedView="text", choices(
            choice="x" "x",
            choice="y" "y",
            choice="z" "z"));

        type RotationSequence = Modelica.Icons.TypeInteger[3] (min={1,1,1}, max={3,3,3})
        "Sequence of planar frame rotations with choices for menus"   annotation (
          preferedView="text",
          Evaluate=true,
          choices(
            choice={1,2,3} "{1,2,3} \"Cardan/Tait-Bryan angles\"",
            choice={3,1,3} "{3,1,3} \"Euler angles\"",
            choice={3,2,1} "{3,2,1}"));

        type Color = Modelica.Icons.TypeInteger[3] (each min=0, each max=255)
        "RGB representation of color (will be improved with a color editor)"
          annotation (
            Dialog(colorSelector),
            choices(
              choice={0,0,0} "{0,0,0}       \"black\"",
              choice={155,0,0} "{155,0,0}     \"dark red\"",
              choice={255,0,0} "{255,0,0 }    \"red\"",
              choice={255,65,65} "{255,65,65}   \"light red\"",
              choice={0,128,0} "{0,128,0}     \"dark green\"",
              choice={0,180,0} "{0,180,0}     \"green\"",
              choice={0,230,0} "{0,230,0}     \"light green\"",
              choice={0,0,200} "{0,0,200}     \"dark blue\"",
              choice={0,0,255} "{0,0,255}     \"blue\"",
              choice={0,128,255} "{0,128,255}   \"light blue\"",
              choice={255,255,0} "{255,255,0}   \"yellow\"",
              choice={255,0,255} "{255,0,255}   \"pink\"",
              choice={100,100,100} "{100,100,100} \"dark grey\"",
              choice={155,155,155} "{155,155,155} \"grey\"",
              choice={255,255,255} "{255,255,255} \"white\""),
          Documentation(info="<html>
<p>
Type <b>Color</b> is an Integer vector with 3 elements,
{r, g, b}, and specifies the color of a shape.
{r,g,b} are the \"red\", \"green\" and \"blue\" color parts.
Note, r g, b are given in the range 0 .. 255.
</p>
</html>"));

        type SpecularCoefficient = Modelica.Icons.TypeReal
        "Reflection of ambient light (= 0: light is completely absorbed)"
             annotation ( min=0,
               choices(choice=0 "\"0.0 (dull)\"",choice=0.7 "\"0.7 (medium)\"", choice=1
            "\"1.0 (glossy)\""),
          Documentation(info="<html>
<p>
Type <b>SpecularCoefficient</b> defines the reflection of
ambient light on shape surfaces. If value = 0, the light
is completely absorbed. Often, 0.7 is a reasonable value.
It might be that from some viewing directions, a body is no
longer visible, if the SpecularCoefficient value is too high.
In the following image, the different values of SpecularCoefficient
are shown for a cylinder:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/MultiBody/Visualizers/SpecularCoefficient.png\"
</p>
</html>"));

        type ShapeType = Modelica.Icons.TypeString
        "Type of shape (box, sphere, cylinder, pipecylinder, cone, pipe, beam, gearwheel, spring, dxf-file)"
           annotation ( choices(
            choice="box" "\"box\"",
            choice="sphere" "\"sphere\"",
            choice="cylinder" "\"cylinder\"",
            choice="pipecylinder" "\"pipecylinder\"",
            choice="cone" "\"cone\"",
            choice="pipe" "\"pipe\"",
            choice="beam" "\"beam\"",
            choice="gearwheel" "\"gearwheel\"",
            choice="spring" "\"spring\"",
            choice="1" "File \"1.dxf\" in current directory",
            choice="2" "File \"2.dxf\" in current directory",
            choice="3" "File \"3.dxf\" in current directory",
            choice="4" "File \"4.dxf\" in current directory",
            choice="5" "File \"5.dxf\" in current directory",
            choice="6" "File \"6.dxf\" in current directory",
            choice="7" "File \"7.dxf\" in current directory",
            choice="8" "File \"8.dxf\" in current directory",
            choice="9" "File \"9.dxf\" in current directory"),
          Documentation(info="<html>
<p>
Type <b>ShapeType</b> is used to define the shape of the
visual object as parameter String. Usually, \"shapeType\" is used
as instance name. The following
values for shapeType are possible, e.g., shapeType=\"box\":
</p>
<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Shape.png\" ALT=\"model Visualizers.FixedShape\">
<p>&nbsp;<br>
The dark blue arrows in the figure above are directed along
variable <b>lengthDirection</b>. The light blue arrows are directed
along variable <b>widthDirection</b>. The <b>coordinate systems</b>
in the figure represent frame_a of the Shape component.
</p>
<p>
Additionally, external shapes are specified as DXF-files
(only 3-dim.Face is supported). External shapes must be named \"1\", \"2\"
etc.. The corresponding definitions should be in files \"1.dxf\",
\"2.dxf\" etc.Since the DXF-files contain color and dimensions for
the individual faces, the corresponding information in the model
is currently ignored. The DXF-files must be found either in the current
directory or in the directory where the Shape instance is stored
that references the DXF file.
</p>
</html>"));

        type ShapeExtra = Modelica.Icons.TypeReal
        "Reflection of ambient light (= 0: light is completely absorbed)"
             annotation ( min=0,
          Documentation(info="<html>
<p>
This type is used in shapes of visual objects to define
extra data depending on the shape type. Usually, input
variable <b>extra</b> is used as instance name:
</p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>shapeType</b></th><th>Meaning of variable <b>extra</b></th></tr>
<tr>
  <td valign=\"top\">\"cylinder\"</td>
  <td valign=\"top\">if extra &gt; 0, a black line is included in the
      cylinder to show the rotation of it.</td>
</tr>
<tr>
  <td valign=\"top\">\"cone\"</td>
  <td valign=\"top\">extra = diameter-left-side / diameter-right-side, i.e.,<br>
      extra = 1: cylinder<br>
      extra = 0: \"real\" cone.</td>
</tr>
<tr>
  <td valign=\"top\">\"pipe\"</td>
  <td valign=\"top\">extra = outer-diameter / inner-diameter, i.e, <br>
      extra = 1: cylinder that is completely hollow<br>
      extra = 0: cylinder without a hole.</td>
</tr>
<tr>
  <td valign=\"top\">\"gearwheel\"</td>
  <td valign=\"top\">extra is the number of teeth of the gear.</td>
</tr>
<tr>
  <td valign=\"top\">\"spring\"</td>
  <td valign=\"top\">extra is the number of windings of the spring.
      Additionally, \"height\" is <b>not</b> the \"height\" but
      2*coil-width.</td>
</tr>
</table>
</html>"));

        type GravityTypes = enumeration(
          NoGravity "No gravity field",
          UniformGravity "Uniform gravity field",
          PointGravity "Point gravity field")
        "Enumeration defining the type of the gravity field"
            annotation (Documentation(info="<html>
<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>Types.GravityTypes.</b></th><th><b>Meaning</b></th></tr>
<tr><td valign=\"top\">NoGravity</td>
    <td valign=\"top\">No gravity field</td></tr>

<tr><td valign=\"top\">UniformGravity</td>
    <td valign=\"top\">Gravity field is described by a vector of constant gravity acceleration</td></tr>

<tr><td valign=\"top\">PointGravity</td>
    <td valign=\"top\">Central gravity field. The gravity acceleration vector is directed to
        the field center and the gravity is proportional to 1/r^2, where
        r is the distance to the field center.</td></tr>
</table>
</html>"));

        package Defaults
        "Default settings of the MultiBody library via constants"
          extends Modelica.Icons.Package;

          constant Types.Color BodyColor={0,128,255}
          "Default color for body shapes that have mass (light blue)";

          constant Types.Color RodColor={155,155,155}
          "Default color for massless rod shapes (grey)";

          constant Types.Color JointColor={255,0,0}
          "Default color for elementary joints (red)";

          constant Types.Color FrameColor={0,0,0}
          "Default color for frame axes and labels (black)";

          constant Real FrameHeadLengthFraction=5.0
          "Frame arrow head length / arrow diameter";

          constant Real FrameHeadWidthFraction=3.0
          "Frame arrow head width / arrow diameter";

          constant Real FrameLabelHeightFraction=3.0
          "Height of frame label / arrow diameter";

          constant Real ArrowHeadLengthFraction=4.0
          "Arrow head length / arrow diameter";

          constant Real ArrowHeadWidthFraction=3.0
          "Arrow head width / arrow diameter";

          constant SI.Diameter BodyCylinderDiameterFraction=3
          "Default for body cylinder diameter as a fraction of body sphere diameter";
          annotation ( Documentation(info="<html>
<p>
This package contains constants used as default setting
in the MultiBody library.
</p>
</html>"));
        end Defaults;
        annotation ( Documentation(info="<HTML>
<p>
In this package <b>types</b> and <b>constants</b> are defined that are used in the
MultiBody library. The types have additional annotation choices
definitions that define the menus to be built up in the graphical
user interface when the type is used as parameter in a declaration.
</p>
</HTML>"));
      end Types;
    annotation (
      Documentation(info="<HTML>
<p>
Library <b>MultiBody</b> is a <b>free</b> Modelica package providing
3-dimensional mechanical components to model in a convenient way
<b>mechanical systems</b>, such as robots, mechanisms, vehicles.
Typical animations generated with this library are shown
in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/MultiBody/MultiBody.png\">

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Mechanics.MultiBody.UsersGuide\">MultiBody.UsersGuide</a>
     discusses the most important aspects how to use this library.</li>
<li> <a href=\"modelica://Modelica.Mechanics.MultiBody.Examples\">MultiBody.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>"));
    end MultiBody;

    package Rotational
    "Library to model 1-dimensional, rotational mechanical systems"
      extends Modelica.Icons.Package;
      import SI = Modelica.SIunits;

      package Components "Components for 1D rotational mechanical drive trains"
        extends Modelica.Icons.Package;

        model Fixed "Flange fixed in housing at a given angle"
          parameter SI.Angle phi0=0 "Fixed offset angle of housing";

          Interfaces.Flange_b flange "(right) flange fixed in housing"
            annotation (Placement(transformation(extent={{10,-10},{-10,10}}, rotation=
                   0)));

        equation
          flange.phi = phi0;
          annotation (
            Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Text(
                  extent={{-150,-90},{150,-130}},
                  lineColor={0,0,255},
                  textString="%name"),
                Line(points={{-80,-40},{80,-40}}, color={0,0,0}),
                Line(points={{80,-40},{40,-80}}, color={0,0,0}),
                Line(points={{40,-40},{0,-80}}, color={0,0,0}),
                Line(points={{0,-40},{-40,-80}}, color={0,0,0}),
                Line(points={{-40,-40},{-80,-80}}, color={0,0,0}),
                Line(points={{0,-40},{0,-10}}, color={0,0,0})}),
            Documentation(info="<html>
<p>
The <b>flange</b> of a 1D rotational mechanical system is <b>fixed</b>
at an angle phi0 in the <b>housing</b>. May be used:
</p>
<ul>
<li> to connect a compliant element, such as a spring or a damper,
     between an inertia or gearbox component and the housing.
<li> to fix a rigid element, such as an inertia, with a specific
     angle to the housing.
</ul>

</HTML>
"),         Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Line(points={{-80,-40},{80,-40}}, color={0,0,0}),
                Line(points={{80,-40},{40,-80}}, color={0,0,0}),
                Line(points={{40,-40},{0,-80}}, color={0,0,0}),
                Line(points={{0,-40},{-40,-80}}, color={0,0,0}),
                Line(points={{-40,-40},{-80,-80}}, color={0,0,0}),
                Line(points={{0,-40},{0,-4}}, color={0,0,0})}));
        end Fixed;

        model Inertia "1D-rotational component with inertia"
          import SI = Modelica.SIunits;
          Rotational.Interfaces.Flange_a flange_a "Left flange of shaft"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
          Rotational.Interfaces.Flange_b flange_b "Right flange of shaft"
            annotation (Placement(transformation(extent={{90,-10},{110,10}},
                  rotation=0)));
          parameter SI.Inertia J(min=0, start=1) "Moment of inertia";
          parameter StateSelect stateSelect=StateSelect.default
          "Priority to use phi and w as states"   annotation(HideResult=true,Dialog(tab="Advanced"));
          SI.Angle phi(stateSelect=stateSelect)
          "Absolute rotation angle of component"   annotation(Dialog(group="Initialization", showStartAttribute=true));
          SI.AngularVelocity w(stateSelect=stateSelect)
          "Absolute angular velocity of component (= der(phi))"   annotation(Dialog(group="Initialization", showStartAttribute=true));
          SI.AngularAcceleration a
          "Absolute angular acceleration of component (= der(w))"   annotation(Dialog(group="Initialization", showStartAttribute=true));

        equation
          phi = flange_a.phi;
          phi = flange_b.phi;
          w = der(phi);
          a = der(w);
          J*a = flange_a.tau + flange_b.tau;
          annotation (
            Documentation(info="<html>
<p>
Rotational component with <b>inertia</b> and two rigidly connected flanges.
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-100,10},{-50,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{50,10},{100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Line(points={{-80,-25},{-60,-25}}, color={0,0,0}),
                Line(points={{60,-25},{80,-25}}, color={0,0,0}),
                Line(points={{-70,-25},{-70,-70}}, color={0,0,0}),
                Line(points={{70,-25},{70,-70}}, color={0,0,0}),
                Line(points={{-80,25},{-60,25}}, color={0,0,0}),
                Line(points={{60,25},{80,25}}, color={0,0,0}),
                Line(points={{-70,45},{-70,25}}, color={0,0,0}),
                Line(points={{70,45},{70,25}}, color={0,0,0}),
                Line(points={{-70,-70},{70,-70}}, color={0,0,0}),
                Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Text(
                  extent={{-150,100},{150,60}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-80},{150,-120}},
                  lineColor={0,0,0},
                  textString="J=%J")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end Inertia;

        model SpringDamper "Linear 1D rotational spring and damper in parallel"
          import SI = Modelica.SIunits;
          parameter SI.RotationalSpringConstant c(final min=0, start=1.0e5)
          "Spring constant";
          parameter SI.RotationalDampingConstant d(final min=0, start=0)
          "Damping constant";
          parameter SI.Angle phi_rel0=0 "Unstretched spring angle";
          extends
          Modelica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates;
          extends
          Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;
      protected
          Modelica.SIunits.Torque tau_c "Spring torque";
          Modelica.SIunits.Torque tau_d "Damping torque";
        equation
          tau_c = c*(phi_rel - phi_rel0);
          tau_d = d*w_rel;
          tau = tau_c + tau_d;
          lossPower = tau_d*w_rel;
          annotation (
            Documentation(info="<html>
<p>
A <b>spring</b> and <b>damper</b> element <b>connected in parallel</b>.
The component can be
connected either between two inertias/gears to describe the shaft elasticity
and damping, or between an inertia/gear and the housing (component Fixed),
to describe a coupling of the element with the housing via a spring/damper.
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Line(points={{-80,40},{-60,40},{-45,10},{-15,70},{15,10},{45,70},{
                      60,40},{80,40}}, color={0,0,0}),
                Line(points={{-80,40},{-80,-40}}, color={0,0,0}),
                Line(points={{-80,-40},{-50,-40}}, color={0,0,0}),
                Rectangle(
                  extent={{-50,-10},{40,-70}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Line(points={{-50,-10},{70,-10}}, color={0,0,0}),
                Line(points={{-50,-70},{70,-70}}, color={0,0,0}),
                Line(points={{40,-40},{80,-40}}, color={0,0,0}),
                Line(points={{80,40},{80,-40}}, color={0,0,0}),
                Line(points={{-90,0},{-80,0}}, color={0,0,0}),
                Line(points={{80,0},{90,0}}, color={0,0,0}),
                Text(
                  extent={{-150,-144},{150,-104}},
                  lineColor={0,0,0},
                  textString="d=%d"),
                Text(
                  extent={{-190,110},{190,70}},
                  lineColor={0,0,255},
                  textString="%name"),
                Text(
                  extent={{-150,-108},{150,-68}},
                  lineColor={0,0,0},
                  textString="c=%c"),
                Line(visible=useHeatPort,
                  points={{-100,-100},{-100,-55},{-5,-55}},
                  color={191,0,0},
                  pattern=LinePattern.Dot,
                  smooth=Smooth.None)}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Line(
                  points={{-80,32},{-58,32},{-43,2},{-13,62},{17,2},{47,62},{62,32},
                      {80,32}},
                  color={0,0,0},
                  thickness=0.5),
                Line(points={{-68,32},{-68,97}}, color={128,128,128}),
                Line(points={{72,32},{72,97}}, color={128,128,128}),
                Line(points={{-68,92},{72,92}}, color={128,128,128}),
                Polygon(
                  points={{62,95},{72,92},{62,89},{62,95}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-44,79},{29,91}},
                  lineColor={0,0,255},
                  textString="phi_rel"),
                Rectangle(
                  extent={{-50,-20},{40,-80}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Line(points={{-50,-80},{68,-80}}, color={0,0,0}),
                Line(points={{-50,-20},{68,-20}}, color={0,0,0}),
                Line(points={{40,-50},{80,-50}}, color={0,0,0}),
                Line(points={{-80,-50},{-50,-50}}, color={0,0,0}),
                Line(points={{-80,32},{-80,-50}}, color={0,0,0}),
                Line(points={{80,32},{80,-50}}, color={0,0,0}),
                Line(points={{-96,0},{-80,0}}, color={0,0,0}),
                Line(points={{96,0},{80,0}}, color={0,0,0})}));
        end SpringDamper;

        model BearingFriction "Coulomb friction in bearings "
          extends
          Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2;

          parameter Real tau_pos[:, 2]=[0, 1]
          "[w,tau] Positive sliding friction characteristic (w>=0)";
          parameter Real peak(final min=1) = 1
          "peak*tau_pos[1,2] = Maximum friction torque for w==0";

          extends Rotational.Interfaces.PartialFriction;
          extends
          Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;

          SI.Angle phi
          "Angle between shaft flanges (flange_a, flange_b) and support";
          SI.Torque tau "Friction torque";
          SI.AngularVelocity w
          "Absolute angular velocity of flange_a and flange_b";
          SI.AngularAcceleration a
          "Absolute angular acceleration of flange_a and flange_b";

        equation
          // Constant auxiliary variables
          tau0 = Modelica.Math.tempInterpol1(0, tau_pos, 2);
          tau0_max = peak*tau0;
          free = false;

          phi = flange_a.phi - phi_support;
          flange_b.phi = flange_a.phi;

          // Angular velocity and angular acceleration of flanges
          w = der(phi);
          a = der(w);
          w_relfric = w;
          a_relfric = a;

          // Friction torque
          flange_a.tau + flange_b.tau - tau = 0;

          // Friction torque
          tau = if locked then sa*unitTorque else
               (if startForward then         Modelica.Math.tempInterpol1( w, tau_pos, 2) else
                if startBackward then       -Modelica.Math.tempInterpol1(-w, tau_pos, 2) else
                if pre(mode) == Forward then Modelica.Math.tempInterpol1( w, tau_pos, 2) else
                                            -Modelica.Math.tempInterpol1(-w, tau_pos, 2));
          lossPower = tau*w_relfric;
          annotation (
            Documentation(info="<html>
<p>
This element describes <b>Coulomb friction</b> in <b>bearings</b>,
i.e., a frictional torque acting between a flange and the housing.
The positive sliding friction torque \"tau\" has to be defined
by table \"tau_pos\" as function of the absolute angular velocity \"w\".
E.g.
<p>
<pre>
       w | tau
      ---+-----
       0 |   0
       1 |   2
       2 |   5
       3 |   8
</pre>
<p>
gives the following table:
</p>
<pre>
   tau_pos = [0, 0; 1, 2; 2, 5; 3, 8];
</pre>
<p>
Currently, only linear interpolation in the table is supported.
Outside of the table, extrapolation through the last
two table entries is used. It is assumed that the negative
sliding friction force has the same characteristic with negative
values. Friction is modelled in the following way:
</p>
<p>
When the absolute angular velocity \"w\" is not zero, the friction torque
is a function of w and of a constant normal force. This dependency
is defined via table tau_pos and can be determined by measurements,
e.g., by driving the gear with constant velocity and measuring the
needed motor torque (= friction torque).
</p>
<p>
When the absolute angular velocity becomes zero, the elements
connected by the friction element become stuck, i.e., the absolute
angle remains constant. In this phase the friction torque is
calculated from a torque balance due to the requirement, that
the absolute acceleration shall be zero.  The elements begin
to slide when the friction torque exceeds a threshold value,
called the maximum static friction torque, computed via:
</p>
<pre>
   maximum_static_friction = <b>peak</b> * sliding_friction(w=0)  (<b>peak</b> >= 1)
</pre>
<p>
This procedure is implemented in a \"clean\" way by state events and
leads to continuous/discrete systems of equations if friction elements
are dynamically coupled which have to be solved by appropriate
numerical methods. The method is described in:
</p>
<dl>
<dt>Otter M., Elmqvist H., and Mattsson S.E. (1999):
<dd><b>Hybrid Modeling in Modelica based on the Synchronous
    Data Flow Principle</b>. CACSD'99, Aug. 22.-26, Hawaii.
</dl>
<p>
More precise friction models take into account the elasticity of the
material when the two elements are \"stuck\", as well as other effects,
like hysteresis. This has the advantage that the friction element can
be completely described by a differential equation without events. The
drawback is that the system becomes stiff (about 10-20 times slower
simulation) and that more material constants have to be supplied which
requires more sophisticated identification. For more details, see the
following references, especially (Armstrong and Canudas de Witt 1996):
</p>
<dl>
<dt>Armstrong B. (1991):
<dd><b>Control of Machines with Friction</b>. Kluwer Academic
    Press, Boston MA.<br><br>
<dt>Armstrong B., and Canudas de Wit C. (1996):
<dd><b>Friction Modeling and Compensation.</b>
    The Control Handbook, edited by W.S.Levine, CRC Press,
    pp. 1369-1382.<br><br>
<dt>Canudas de Wit C., Olsson H., Astroem K.J., and Lischinsky P. (1995):
<dd><b>A new model for control of systems with friction.</b>
    IEEE Transactions on Automatic Control, Vol. 40, No. 3, pp. 419-425.<br><br>
</dl>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-100,10},{100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(extent={{-60,-10},{60,-60}}, lineColor={0,0,0}),
                Rectangle(
                  extent={{-60,-10},{60,-25}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-60,-45},{60,-61}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-50,-18},{50,-50}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{60,-60},{60,-70},{75,-70},{75,-80},{-75,-80},{-75,-70},{
                      -60,-70},{-60,-60},{60,-60}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Line(points={{-75,-10},{-75,-70}}, color={0,0,0}),
                Line(points={{75,-10},{75,-70}}, color={0,0,0}),
                Rectangle(extent={{-60,60},{60,10}}, lineColor={0,0,0}),
                Rectangle(
                  extent={{-60,60},{60,45}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-60,25},{60,10}},
                  lineColor={0,0,0},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-50,51},{50,19}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{-75,70},{-75,10}}, color={0,0,0}),
                Polygon(
                  points={{60,60},{60,70},{75,70},{75,80},{-75,80},{-75,70},{-60,70},
                      {-60,60},{60,60}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Line(points={{75,70},{75,10}}, color={0,0,0}),
                Text(
                  extent={{-150,130},{150,90}},
                  textString="%name",
                  lineColor={0,0,255}),
                Line(
                  points={{0,-80},{0,-100}},
                  color={0,0,0},
                  smooth=Smooth.None),
                Line(visible=useHeatPort,
                  points={{-100,-100},{-100,-35},{2,-35}},
                  color={191,0,0},
                  pattern=LinePattern.Dot,
                  smooth=Smooth.None)}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end BearingFriction;

        model IdealGear "Ideal gear without inertia"
          extends Modelica.Mechanics.Rotational.Icons.Gear;
          extends
          Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2;
          parameter Real ratio(start=1)
          "Transmission ratio (flange_a.phi/flange_b.phi)";
          Modelica.SIunits.Angle phi_a
          "Angle between left shaft flange and support";
          Modelica.SIunits.Angle phi_b
          "Angle between right shaft flange and support";

        equation
          phi_a = flange_a.phi - phi_support;
          phi_b = flange_b.phi - phi_support;
          phi_a = ratio*phi_b;
          0 = ratio*flange_a.tau + flange_b.tau;
          annotation (
            Documentation(info="<html>
<p>
This element characterices any type of gear box which is fixed in the
ground and which has one driving shaft and one driven shaft.
The gear is <b>ideal</b>, i.e., it does not have inertia, elasticity, damping
or backlash. If these effects have to be considered, the gear has to be
connected to other elements in an appropriate way.
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Text(
                  extent={{-153,145},{147,105}},
                  lineColor={0,0,255},
                  textString="%name"),
                Text(
                  extent={{-146,-49},{154,-79}},
                  lineColor={0,0,0},
                  textString="ratio=%ratio")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end IdealGear;

        model InitializeFlange
        "Initializes a flange with pre-defined angle, speed and angular acceleration (usually, this is reference data from a control bus)"
          extends Modelica.Blocks.Interfaces.BlockIcon;
          parameter Boolean use_phi_start = true
          "= true, if initial angle is defined by input phi_start, otherwise not initialized";
          parameter Boolean use_w_start = true
          "= true, if initial speed is defined by input w_start, otherwise not initialized";
          parameter Boolean use_a_start = true
          "= true, if initial angular acceleration is defined by input a_start, otherwise not initialized";

          parameter StateSelect stateSelect=StateSelect.default
          "Priority to use flange angle and speed as states";

          Modelica.Blocks.Interfaces.RealInput phi_start if use_phi_start
          "Initial angle of flange"
            annotation (Placement(transformation(extent={{-140,60},{-100,100}},
                  rotation=0), iconTransformation(extent={{-140,60},{-100,100}})));
          Modelica.Blocks.Interfaces.RealInput w_start if use_w_start
          "Initial speed of flange"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                  rotation=0)));
          Modelica.Blocks.Interfaces.RealInput a_start if use_a_start
          "Initial angular acceleration of flange"
            annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
                  rotation=0), iconTransformation(extent={{-140,-100},{-100,-60}})));
          Interfaces.Flange_b flange "Flange that is initialized" annotation (Placement(
                transformation(extent={{90,-10},{110,10}}, rotation=0)));

          Modelica.SIunits.Angle phi_flange(stateSelect=stateSelect)=flange.phi
          "Flange angle";
          Modelica.SIunits.AngularVelocity w_flange(stateSelect=stateSelect)= der(phi_flange)
          "= der(phi_flange)";

      protected
          encapsulated model Set_phi_start "Set phi_start"
            import Modelica;
            extends Modelica.Blocks.Interfaces.BlockIcon;
            Modelica.Blocks.Interfaces.RealInput phi_start "Start angle"
              annotation (HideResult=true, Placement(transformation(extent={{-140,-20},{
                      -100,20}}, rotation=0)));

            Modelica.Mechanics.Rotational.Interfaces.Flange_b flange
                                                  annotation (Placement(
                  transformation(extent={{90,-10},{110,10}}, rotation=0)));
          initial equation
            flange.phi = phi_start;
          equation
            flange.tau = 0;

          end Set_phi_start;

          encapsulated model Set_w_start "Set w_start"
            import Modelica;
            extends Modelica.Blocks.Interfaces.BlockIcon;
            Modelica.Blocks.Interfaces.RealInput w_start
            "Start angular velocity"
              annotation (HideResult=true, Placement(transformation(extent={{-140,-20},{
                      -100,20}}, rotation=0)));

            Modelica.Mechanics.Rotational.Interfaces.Flange_b flange
                                                  annotation (Placement(
                  transformation(extent={{90,-10},{110,10}}, rotation=0)));
          initial equation
            der(flange.phi) = w_start;
          equation
            flange.tau = 0;

          end Set_w_start;

          encapsulated model Set_a_start "Set a_start"
            import Modelica;
            extends Modelica.Blocks.Interfaces.BlockIcon;
            Modelica.Blocks.Interfaces.RealInput a_start
            "Start angular acceleration"
              annotation (HideResult=true, Placement(transformation(extent={{-140,-20},{
                      -100,20}}, rotation=0)));

            Modelica.Mechanics.Rotational.Interfaces.Flange_b flange(phi(stateSelect=StateSelect.avoid))
                                                                                      annotation (Placement(
                  transformation(extent={{90,-10},{110,10}}, rotation=0)));

            Modelica.SIunits.AngularVelocity w = der(flange.phi) annotation(HideResult=true);
          initial equation
            der(w) = a_start;
          equation
            flange.tau = 0;
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent=
                      {{-100,-100},{100,100}}),
                                graphics));
          end Set_a_start;

          encapsulated model Set_flange_tau "Set flange.tau to zero"
            import Modelica;
            extends Modelica.Blocks.Interfaces.BlockIcon;
            Modelica.Mechanics.Rotational.Interfaces.Flange_b flange
                                                  annotation (Placement(
                  transformation(extent={{90,-10},{110,10}}, rotation=0)));
          equation
            flange.tau = 0;
          end Set_flange_tau;
      protected
          Set_phi_start set_phi_start if use_phi_start annotation (Placement(
                transformation(extent={{-20,70},{0,90}}, rotation=0)));
          Set_w_start set_w_start if use_w_start
                                  annotation (Placement(transformation(extent={{-20,
                    -10},{0,10}}, rotation=0)));
          Set_a_start set_a_start if use_a_start
                                  annotation (Placement(transformation(extent={{-20,-90},
                    {0,-70}},      rotation=0)));
          Set_flange_tau set_flange_tau annotation (Placement(transformation(extent={{96,-90},
                    {76,-70}},           rotation=0)));
        equation
          connect(set_phi_start.phi_start, phi_start) annotation (Line(
              points={{-22,80},{-120,80}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(set_phi_start.flange, flange) annotation (Line(
              points={{0,80},{60,80},{60,0},{100,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(set_w_start.flange, flange) annotation (Line(
              points={{0,0},{25,0},{25,1.16573e-015},{50,1.16573e-015},{50,0},{100,
                  0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(set_w_start.w_start, w_start) annotation (Line(
              points={{-22,0},{-46.5,0},{-46.5,1.77636e-015},{-71,1.77636e-015},{
                  -71,0},{-120,0}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(set_a_start.a_start, a_start) annotation (Line(
              points={{-22,-80},{-120,-80}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(set_a_start.flange, flange) annotation (Line(
              points={{0,-80},{60,-80},{60,0},{100,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(set_flange_tau.flange, flange) annotation (Line(
              points={{76,-80},{60,-80},{60,0},{100,0}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                    -100},{100,100}}), graphics={
                Text(
                  extent={{-94,94},{68,66}},
                  lineColor={0,0,0},
                  textString="phi_start"),
                Text(
                  extent={{-94,16},{70,-14}},
                  lineColor={0,0,0},
                  textString="w_start"),
                Text(
                  extent={{-92,-68},{68,-96}},
                  lineColor={0,0,0},
                  textString="a_start")}),
                                    Diagram(coordinateSystem(preserveAspectRatio=true,
                           extent={{-100,-100},{100,100}}),
                                            graphics),
            Documentation(info="<html>
<p>
This component is used to optionally initialize the angle, speed,
and/or angular acceleration of the flange to which this component
is connected. Via parameters use_phi_start, use_w_start, use_a_start
the corresponding input signals phi_start, w_start, a_start are conditionally
activated. If an input is activated, the corresponding flange property
is initialized with the input value at start time.
</p>

<p>
For example, if \"use_phi_start = true\", then flange.phi is initialized
with the value of the input signal \"phi_start\" at the start time.
</p>

<p>
Additionally, it is optionally possible to define the \"StateSelect\"
attribute of the flange angle and the flange speed via paramater
\"stateSelection\".
</p>

<p>
This component is especially useful when the initial values of a flange
shall be set according to reference signals of a controller that are
provided via a signal bus.
</p>

</html>"));
        end InitializeFlange;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-58,8},{42,-92}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-100,-32},{-58,-52}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{42,-32},{80,-52}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192})}),                     Documentation(info="<html>
<p>
This package contains basic components 1D mechanical rotational drive trains.
</p>
</html>"));
      end Components;

      package Sensors
      "Sensors to measure variables in 1D rotational mechanical components"
        extends Modelica.Icons.SensorsPackage;

        model AngleSensor "Ideal sensor to measure the absolute flange angle"

          extends Rotational.Interfaces.PartialAbsoluteSensor;
          Modelica.Blocks.Interfaces.RealOutput phi "Absolute angle of flange"
                                        annotation (Placement(transformation(extent=
                   {{100,-10},{120,10}}, rotation=0)));
        equation
          phi = flange.phi;
          annotation (
            Documentation(info="<html>
<p>
Measures the <b>absolute angle phi</b> of a flange in an ideal
way and provides the result as output signal <b>phi</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={Text(
                  extent={{70,-30},{120,-70}},
                  lineColor={0,0,0},
                  textString="phi")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end AngleSensor;

        model SpeedSensor
        "Ideal sensor to measure the absolute flange angular velocity"

          extends Rotational.Interfaces.PartialAbsoluteSensor;
          Modelica.Blocks.Interfaces.RealOutput w
          "Absolute angular velocity of flange"
                                        annotation (Placement(transformation(extent=
                   {{100,-10},{120,10}}, rotation=0)));

        equation
          w = der(flange.phi);
          annotation (
            Documentation(info="<html>
<p>
Measures the <b>absolute angular velocity w</b> of a flange in an ideal
way and provides the result as output signal <b>w</b>
(to be further processed with blocks of the Modelica.Blocks library).
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={Text(
                  extent={{70,-30},{120,-70}},
                  lineColor={0,0,0},
                  textString="w")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end SpeedSensor;

        model AccSensor
        "Ideal sensor to measure the absolute flange angular acceleration"

          extends Rotational.Interfaces.PartialAbsoluteSensor;
          SI.AngularVelocity w "Absolute angular velocity of flange";
          Modelica.Blocks.Interfaces.RealOutput a
          "Absolute angular acceleration of flange"
                                        annotation (Placement(transformation(extent=
                   {{100,-10},{120,10}}, rotation=0)));

        equation
          w = der(flange.phi);
          a = der(w);
          annotation (
            Documentation(info="<html>
<p>
Measures the <b>absolute angular acceleration a</b> of a flange in an ideal
way and provides the result as output signal <b>a</b> (to be further processed with
blocks of the Modelica.Blocks library).
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={Text(
                  extent={{70,-30},{120,-70}},
                  lineColor={0,0,0},
                  textString="a")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end AccSensor;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),                 Documentation(info="<html>
<p>
This package contains ideal sensor components that provide
the connector variables as signals for further processing with the
Modelica.Blocks library.
</p>
</html>"));
      end Sensors;

      package Sources "Sources to drive 1D rotational mechanical components"
        extends Modelica.Icons.SourcesPackage;

        model ConstantTorque "Constant torque, not dependent on speed"
          extends Rotational.Interfaces.PartialTorque;
          parameter Modelica.SIunits.Torque tau_constant
          "Constant torque (if negative, torque is acting as load)";
          Modelica.SIunits.Torque tau
          "Accelerating torque acting at flange (= -flange.tau)";
        equation
          tau = -flange.tau;
          tau = tau_constant;
          annotation (
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                    {100,100}}),
                    graphics),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Line(points={{-98,0},{100,0}}, color={0,0,
                      255}), Text(
                  extent={{-124,-16},{120,-40}},
                  lineColor={0,0,0},
                  textString="%tau_constant")}),
            Documentation(info="<HTML>
<p>
Model of constant torque, not dependent on angular velocity of flange.<br>
Positive torque acts accelerating.
</p>
</HTML>"));
        end ConstantTorque;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),                 Documentation(info="<html>
<p>
This package contains ideal sources to drive 1D mechanical rotational drive trains.
</p>
</html>"));
      end Sources;

      package Interfaces
      "Connectors and partial models for 1D rotational mechanical components"
        extends Modelica.Icons.InterfacesPackage;

        connector Flange_a
        "1-dim. rotational flange of a shaft (filled square icon)"
          SI.Angle phi "Absolute rotation angle of flange";
          flow SI.Torque tau "Cut torque in the flange";
          annotation(defaultComponentName = "flange_a",
            Documentation(info="<html>
<p>
This is a connector for 1-dim. rotational mechanical systems and models
the mechanical flange of a shaft. The following variables are defined in this connector:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"> <b>phi</b></td>
      <td valign=\"top\"> Absolute rotation angle of theshaft flange in [rad] </td>
  </tr>
  <tr><td valign=\"top\"> <b>tau</b></td>
      <td valign=\"top\"> Cut-torque in the shaft flange in [Nm] </td>
  </tr>
</table>

<p>
There is a second connector for flanges: Flange_b. The connectors
Flange_a and Flange_b are completely identical. There is only a difference
in the icons, in order to easier identify a flange variable in a diagram.
For a discussion on the actual direction of the cut-torque tau and
of the rotation angle, see section
<a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide.SignConventions\">Sign Conventions</a>
in the user's guide of Rotational.
</p>

<p>
If needed, the absolute angular velocity w and the
absolute angular acceleration a of the flange can be determined by
differentiation of the flange angle phi:
</p>
<pre>
     w = der(phi);    a = der(w)
</pre>

</html>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={Ellipse(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={Text(
                  extent={{-160,90},{40,50}},
                  lineColor={0,0,0},
                  textString="%name"), Ellipse(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid)}));
        end Flange_a;

        connector Flange_b
        "1-dim. rotational flange of a shaft (non-filled square icon)"
          SI.Angle phi "Absolute rotation angle of flange";
          flow SI.Torque tau "Cut torque in the flange";
          annotation(defaultComponentName = "flange_b",
            Documentation(info="<html>
<p>
This is a connector for 1-dim. rotational mechanical systems and models
the mechanical flange of a shaft. The following variables are defined in this connector:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"> <b>phi</b></td>
      <td valign=\"top\"> Absolute rotation angle of the shaft flange in [rad] </td>
  </tr>
  <tr><td valign=\"top\"> <b>tau</b></td>
      <td valign=\"top\"> Cut-torque in the shaft flange in [Nm] </td>
  </tr>
</table>

<p>
There is a second connector for flanges: Flange_a. The connectors
Flange_a and Flange_b are completely identical. There is only a difference
in the icons, in order to easier identify a flange variable in a diagram.
For a discussion on the actual direction of the cut-torque tau and
of the rotation angle, see section
<a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide.SignConventions\">Sign Conventions</a>
in the user's guide of Rotational.
</p>

<p>
If needed, the absolute angular velocity w and the
absolute angular acceleration a of the flange can be determined by
differentiation of the flange angle phi:
</p>
<pre>
     w = der(phi);    a = der(w)
</pre>

</html>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={Ellipse(
                  extent={{-98,100},{102,-100}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={Ellipse(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-40,90},{160,50}},
                  lineColor={0,0,0},
                  textString="%name")}));
        end Flange_b;

        connector Support "Support/housing of a 1-dim. rotational shaft"

          SI.Angle phi "Absolute rotation angle of the support/housing";
          flow SI.Torque tau "Reaction torque in the support/housing";

          annotation (Documentation(info="<html>
<p>
This is a connector for 1-dim. rotational mechanical systems and models
the support or housing of a shaft. The following variables are defined in this connector:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"> <b>phi</b></td>
      <td valign=\"top\"> Absolute rotation angle of the support/housing in [rad] </td>
  </tr>
  <tr><td valign=\"top\"> <b>tau</b></td>
      <td valign=\"top\"> Reaction torque in the support/housing in [Nm] </td>
  </tr>
</table>

<p>
The support connector is usually defined as conditional connector.
It is most convenient to utilize it
</p>

<ul>
<li> For models to be build graphically (i.e., the model is build up by drag-and-drop
     from elementary components):<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialOneFlangeAndSupport\">PartialOneFlangeAndSupport</a>,<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlangesAndSupport\">PartialTwoFlangesAndSupport</a>, <br> &nbsp; </li>

<li> For models to be build textually (i.e., elementary models):<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport\">PartialElementaryOneFlangeAndSupport</a>,<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport\">PartialElementaryTwoFlangesAndSupport</a>,<br>
     <a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryRotationalToTranslational\">PartialElementaryRotationalToTranslational</a>.</li>
</ul>

</html>"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2},
                initialScale=0.1), graphics={
                Ellipse(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-150,150},{150,-150}},
                  lineColor={192,192,192},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2},
                initialScale=0.1), graphics={
                Rectangle(
                  extent={{-60,60},{60,-60}},
                  lineColor={192,192,192},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-160,100},{40,60}},
                  lineColor={0,0,0},
                  textString="%name"),
                Ellipse(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid)}));
        end Support;

        model InternalSupport
        "Adapter model to utilize conditional support connector"
          input Modelica.SIunits.Torque tau
          "External support torque (must be computed via torque balance in model where InternalSupport is used; = flange.tau)";
          Modelica.SIunits.Angle phi "External support angle (= flange.phi)";
          Flange_a flange
          "Internal support flange (must be connected to the conditional support connector for useSupport=true and to conditional fixed model for useSupport=false)"
            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
        equation
          flange.tau = tau;
          flange.phi = phi;
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                    -100},{100,100}}), graphics), Icon(coordinateSystem(
                  preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                graphics={Ellipse(
                  extent={{-20,20},{20,-20}},
                  lineColor={135,135,135},
                  fillColor={175,175,175},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-200,80},{200,40}},
                  lineColor={0,0,255},
                  textString="%name")}),
            Documentation(info="<html>
<p>
This is an adapter model to utilize a conditional support connector
in an elementary component, i.e., where the component equations are
defined textually:
</p>

<ul>
<li> If <i>useSupport = true</i>, the flange has to be connected to the conditional
     support connector.</li>
<li> If <i>useSupport = false</i>, the flange has to be connected to the conditional
     fixed model.</li>
</ul>

<p>
Variable <b>tau</b> is defined as <b>input</b> and must be provided when using
this component as a modifier (computed via a torque balance in
the model where InternalSupport is used). Usually, model InternalSupport is
utilized via the partial models:
</p>

<blockquote>
<a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport\">
PartialElementaryOneFlangeAndSupport</a>,<br>
<a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport\">
PartialElementaryTwoFlangesAndSupport</a>,<br>
<a href=\"modelica://Modelica.Mechanics.Rotational.Interfaces.PartialElementaryRotationalToTranslational\">
PartialElementaryRotationalToTranslational</a>.</li>
</blockquote>

<p>
Note, the support angle can always be accessed as internalSupport.phi, and
the support torque can always be accessed as internalSupport.tau.
</p>

</html>"));
        end InternalSupport;

        partial model PartialTwoFlanges
        "Partial model for a component with two rotational 1-dim. shaft flanges"

          Flange_a flange_a "Flange of left shaft"
                            annotation (Placement(transformation(extent={{-110,-10},
                    {-90,10}}, rotation=0)));
          Flange_b flange_b "Flange of right shaft"
                            annotation (Placement(transformation(extent={{90,-10},{
                    110,10}}, rotation=0)));
          annotation (
            Documentation(info="<html>
<p>
This is a 1-dim. rotational component with two flanges.
It is used e.g., to build up parts of a drive train consisting
of several components.
</p>

</html>
"),         Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics));
        end PartialTwoFlanges;

        partial model PartialCompliantWithRelativeStates
        "Partial model for the compliant connection of two rotational 1-dim. shaft flanges where the relative angle and speed are used as preferred states"

          Modelica.SIunits.Angle phi_rel(start=0, stateSelect=stateSelect, nominal=phi_nominal)
          "Relative rotation angle (= flange_b.phi - flange_a.phi)";
          Modelica.SIunits.AngularVelocity w_rel(start=0, stateSelect=stateSelect)
          "Relative angular velocity (= der(phi_rel))";
          Modelica.SIunits.AngularAcceleration a_rel(start=0)
          "Relative angular acceleration (= der(w_rel))";
          Modelica.SIunits.Torque tau "Torque between flanges (= flange_b.tau)";
          Flange_a flange_a
          "Left flange of compliant 1-dim. rotational component"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
          Flange_b flange_b
          "Right flange of compliant 1-dim. rotational component"
            annotation (Placement(transformation(extent={{90,-10},{110,10}},
                  rotation=0)));

          parameter SI.Angle phi_nominal(displayUnit="rad")=1e-4
          "Nominal value of phi_rel (used for scaling)"    annotation(Dialog(tab="Advanced"));
          parameter StateSelect stateSelect=StateSelect.prefer
          "Priority to use phi_rel and w_rel as states"
          annotation(HideResult=true, Dialog(tab="Advanced"));

        equation
          phi_rel = flange_b.phi - flange_a.phi;
          w_rel = der(phi_rel);
          a_rel = der(w_rel);
          flange_b.tau = tau;
          flange_a.tau = -tau;
          annotation (
            Documentation(info="<html>
<p>
This is a 1-dim. rotational component with a compliant connection of two
rotational 1-dim. flanges where inertial effects between the two
flanges are neglected. The basic assumption is that the cut-torques
of the two flanges sum-up to zero, i.e., they have the same absolute value
but opposite sign: flange_a.tau + flange_b.tau = 0. This base class
is used to built up force elements such as springs, dampers, friction.
</p>

<p>
The relative angle and the relative speed are defined as preferred states.
The reason is that for some drive trains, such as drive
trains in vehicles, the absolute angle is quickly increasing during operation.
Numerically, it is better to use relative angles between drive train components
because they remain in a limited size. For this reason, StateSelect.prefer
is set for the relative angle of this component.
</p>

<p>
In order to improve the numerics, a nominal value for the relative angle
can be provided via parameter <b>phi_nominal</b> in the Advanced menu.
The default ist 1e-4 rad since relative angles are usually
in this order and the step size control of an integrator would be
practically switched off, if a default of 1 rad would be used.
This nominal value might also be computed from other values, such
as \"phi_nominal = tau_nominal / c\" for a rotational spring, if tau_nominal
and c are more meaningful for the user.
</p>

</html>
"),         Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics));
        end PartialCompliantWithRelativeStates;

        partial model PartialElementaryOneFlangeAndSupport2
        "Partial model for a component with one rotational 1-dim. shaft flange and a support used for textual modeling, i.e., for elementary models"
          parameter Boolean useSupport=false
          "= true, if support flange enabled, otherwise implicitly grounded"
              annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
          Flange_b flange "Flange of shaft"
            annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
          Support support(phi = phi_support, tau = -flange.tau) if useSupport
          "Support/housing of component"
            annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
      protected
          Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
        equation
          if not useSupport then
             phi_support = 0;
          end if;
          annotation (
            Documentation(info="<html>
<p>
This is a 1-dim. rotational component with one flange and a support/housing.
It is used to build up elementary components of a drive train with
equations in the text layer.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),         Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Line(
                  visible=not useSupport,
                  points={{-50,-120},{-30,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-30,-120},{-10,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-10,-120},{10,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{10,-120},{30,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-30,-100},{30,-100}},
                  color={0,0,0})}));
        end PartialElementaryOneFlangeAndSupport2;

        partial model PartialElementaryTwoFlangesAndSupport2
        "Partial model for a component with two rotational 1-dim. shaft flanges and a support used for textual modeling, i.e., for elementary models"
          parameter Boolean useSupport=false
          "= true, if support flange enabled, otherwise implicitly grounded"
              annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
          Flange_a flange_a "Flange of left shaft"
            annotation (Placement(transformation(extent={{-110,-10}, {-90,10}}, rotation=0)));
          Flange_b flange_b "Flange of right shaft"
            annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
          Support support(phi = phi_support, tau=-flange_a.tau-flange_b.tau) if useSupport
          "Support/housing of component"
            annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
      protected
          Modelica.SIunits.Angle phi_support "Absolute angle of support flange";
        equation
          if not useSupport then
             phi_support = 0;
          end if;

          annotation (
            Documentation(info="<html>
<p>
This is a 1-dim. rotational component with two flanges and a support/housing.
It is used to build up elementary components of a drive train with
equations in the text layer.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>
"),         Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Line(
                  visible=not useSupport,
                  points={{-50,-120},{-30,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-30,-120},{-10,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-10,-120},{10,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{10,-120},{30,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-30,-100},{30,-100}},
                  color={0,0,0})}));
        end PartialElementaryTwoFlangesAndSupport2;

        partial model PartialTorque
        "Partial model of a torque acting at the flange (accelerates the flange)"
          extends
          Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport2;
          Modelica.SIunits.Angle phi
          "Angle of flange with respect to support (= flange.phi - support.phi)";

        equation
          phi = flange.phi - phi_support;
          annotation (
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                    {100,100}}),
                    graphics),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-96,96},{96,-96}},
                  lineColor={255,255,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{0,-62},{0,-100}}, color={0,0,0}),
                Line(points={{-92,0},{-76,36},{-54,62},{-30,80},{-14,88},{10,92},{
                      26,90},{46,80},{64,62}}, color={0,0,0}),
                Text(
                  extent={{-150,140},{150,100}},
                  lineColor={0,0,255},
                  textString="%name"),
                Polygon(
                  points={{94,16},{80,74},{50,52},{94,16}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Line(points={{-58,-82},{-42,-68},{-20,-56},{0,-54},{18,-56},{34,-62},
                      {44,-72},{54,-82},{60,-94}}, color={0,0,0}),
                Polygon(
                  points={{-65,-98},{-46,-80},{-58,-72},{-65,-98}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Line(
                  visible=not useSupport,
                  points={{-50,-120},{-30,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-30,-120},{-10,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-10,-120},{10,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{10,-120},{30,-100}},
                  color={0,0,0}),
                Line(
                  visible=not useSupport,
                  points={{-30,-100},{30,-100}},
                  color={0,0,0})}),
            Documentation(info="<HTML>
<p>
Partial model of torque that accelerates the flange.
</p>

<p>
If <i>useSupport=true</i>, the support connector is conditionally enabled
and needs to be connected.<br>
If <i>useSupport=false</i>, the support connector is conditionally disabled
and instead the component is internally fixed to ground.
</p>

</html>"));
        end PartialTorque;

        partial model PartialAbsoluteSensor
        "Partial model to measure a single absolute flange variable"

          Flange_a flange
          "Flange of shaft from which sensor information shall be measured"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));

        equation
          0 = flange.tau;
          annotation (
            Documentation(info="<html>
<p>
This is a partial model of a 1-dim. rotational component with one flange of a shaft
in order to measure an absolute kinematic quantity in the flange
and to provide the measured signal as output signal for further processing
with the blocks of package Modelica.Blocks.
</p>

</html>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Line(points={{-70,0},{-90,0}}, color={0,0,0}),
                Line(points={{70,0},{100,0}}, color={0,0,127}),
                Text(
                  extent={{150,80},{-150,120}},
                  textString="%name",
                  lineColor={0,0,255}),
                Ellipse(
                  extent={{-70,70},{70,-70}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Line(points={{0,70},{0,40}}, color={0,0,0}),
                Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
                Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
                Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
                Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0}),
                Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
                Polygon(
                  points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-5,5},{5,-5}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end PartialAbsoluteSensor;

        partial model PartialFriction
        "Partial model of Coulomb friction elements"

          // parameter SI.AngularVelocity w_small=1 "Relative angular velocity near to zero (see model info text)";
          parameter SI.AngularVelocity w_small=1.0e10
          "Relative angular velocity near to zero if jumps due to a reinit(..) of the velocity can occur (set to low value only if such impulses can occur)"
             annotation(Dialog(tab="Advanced"));
        // Equations to define the following variables have to be defined in subclasses
          SI.AngularVelocity w_relfric
          "Relative angular velocity between frictional surfaces";
          SI.AngularAcceleration a_relfric
          "Relative angular acceleration between frictional surfaces";
        //SI.Torque tau "Friction torque (positive, if directed in opposite direction of w_rel)";
          SI.Torque tau0 "Friction torque for w=0 and forward sliding";
          SI.Torque tau0_max "Maximum friction torque for w=0 and locked";
          Boolean free "true, if frictional element is not active";
        // Equations to define the following variables are given in this class
          Real sa(final unit="1")
          "Path parameter of friction characteristic tau = f(a_relfric)";
          Boolean startForward(start=false, fixed=true)
          "true, if w_rel=0 and start of forward sliding";
          Boolean startBackward(start=false, fixed=true)
          "true, if w_rel=0 and start of backward sliding";
          Boolean locked(start=false) "true, if w_rel=0 and not sliding";
          constant Integer Unknown=3 "Value of mode is not known";
          constant Integer Free=2 "Element is not active";
          constant Integer Forward=1 "w_rel > 0 (forward sliding)";
          constant Integer Stuck=0
          "w_rel = 0 (forward sliding, locked or backward sliding)";
          constant Integer Backward=-1 "w_rel < 0 (backward sliding)";
          Integer mode(
            final min=Backward,
            final max=Unknown,
            start=Unknown, fixed=true);
      protected
          constant SI.AngularAcceleration unitAngularAcceleration = 1 annotation(HideResult=true);
          constant SI.Torque unitTorque = 1 annotation(HideResult=true);
        equation
        /* Friction characteristic
   locked is introduced to help the Modelica translator determining
   the different structural configurations,
   if for each configuration special code shall be generated)
*/
          startForward = pre(mode) == Stuck and (sa > tau0_max/unitTorque or pre(startForward)
             and sa > tau0/unitTorque) or pre(mode) == Backward and w_relfric > w_small or
            initial() and (w_relfric > 0);
          startBackward = pre(mode) == Stuck and (sa < -tau0_max/unitTorque or pre(
            startBackward) and sa < -tau0/unitTorque) or pre(mode) == Forward and w_relfric <
            -w_small or initial() and (w_relfric < 0);
          locked = not free and not (pre(mode) == Forward or startForward or pre(
            mode) == Backward or startBackward);

          a_relfric/unitAngularAcceleration = if locked then               0 else
                                              if free then                 sa else
                                              if startForward then         sa - tau0_max/unitTorque else
                                              if startBackward then        sa + tau0_max/unitTorque else
                                              if pre(mode) == Forward then sa - tau0_max/unitTorque else
                                                                           sa + tau0_max/unitTorque;

        /* Friction torque has to be defined in a subclass. Example for a clutch:
   tau = if locked then sa else
         if free then   0 else
         cgeo*fn*(if startForward then          Math.tempInterpol1( w_relfric, mue_pos, 2) else
                  if startBackward then        -Math.tempInterpol1(-w_relfric, mue_pos, 2) else
                  if pre(mode) == Forward then  Math.tempInterpol1( w_relfric, mue_pos, 2) else
                                               -Math.tempInterpol1(-w_relfric, mue_pos, 2));
*/
        // finite state machine to determine configuration
          mode = if free then Free else
            (if (pre(mode) == Forward  or pre(mode) == Free or startForward)  and w_relfric > 0 then
               Forward else
             if (pre(mode) == Backward or pre(mode) == Free or startBackward) and w_relfric < 0 then
               Backward else
               Stuck);
          annotation (Documentation(info="<html>
<p>
Basic model for Coulomb friction that models the stuck phase in a reliable way.
</p>
</html>"));
        end PartialFriction;
        annotation ( Documentation(info="<html>
<p>
This package contains connectors and partial models for 1-dim.
rotational mechanical components. The components of this package can
only be used as basic building elements for models.
</p>

</html>
"));
      end Interfaces;

      package Icons "Icons for Rotational package"
        extends Modelica.Icons.Package;

        partial class Gear "Rotational gear icon"

          annotation (             Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={2,2}), graphics={
                Rectangle(
                  extent={{-40,20},{-20,-20}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-40,100},{-20,20}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{20,80},{40,39}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{20,40},{40,-40}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{40,10},{100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-20,70},{20,50}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-100,10},{-40,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Line(points={{-80,20},{-60,20}}, color={0,0,0}),
                Line(points={{-80,-20},{-60,-20}}, color={0,0,0}),
                Line(points={{-70,-20},{-70,-86}}, color={0,0,0}),
                Line(points={{0,40},{0,-86}},  color={0,0,0}),
                Line(points={{-10,40},{10,40}}, color={0,0,0}),
                Line(points={{-10,80},{10,80}}, color={0,0,0}),
                Line(points={{60,-20},{80,-20}}, color={0,0,0}),
                Line(points={{60,20},{80,20}}, color={0,0,0}),
                Line(points={{70,-20},{70,-86}}, color={0,0,0}),
                Line(points={{70,-86},{-70,-86}}, color={0,0,0})}),
            Documentation(info="<html>
<p>
This is the icon of a gear from the rotational package.
</p>
</html>"));
        end Gear;
      end Icons;
      annotation (
        Documentation(info="<html>

<p>
Library <b>Rotational</b> is a <b>free</b> Modelica package providing
1-dimensional, rotational mechanical components to model in a convenient way
drive trains with frictional losses. A typical, simple example is shown
in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/Rotational/driveExample.png\">

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide\">Rotational.UsersGuide</a>
     discusses the most important aspects how to use this library.</li>
<li> <a href=\"modelica://Modelica.Mechanics.Rotational.Examples\">Rotational.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>

<p>
In version 3.0 of the Modelica Standard Library, the basic design of the
library has changed: Previously, bearing connectors could or could not be connected.
In 3.0, the bearing connector is renamed to \"<b>support</b>\" and this connector
is enabled via parameter \"useSupport\". If the support connector is enabled,
it must be connected, and if it is not enabled, it must not be connected.
</p>

<p>
In version 3.2 of the Modelica Standard Library, all <b>dissipative</b> components
of the Rotational library got an optional <b>heatPort</b> connector to which the
dissipated energy is transported in form of heat. This connector is enabled
via parameter \"useHeatPort\". If the heatPort connector is enabled,
it must be connected, and if it is not enabled, it must not be connected.
Independently, whether the heatPort is enabled or not,
the dissipated power is available from the new variable \"<b>lossPower</b>\" (which is
positive if heat is flowing out of the heatPort). For an example, see
<a href=\"modelica://Modelica.Mechanics.Rotational.Examples.HeatLosses\">Examples.HeatLosses</a>.
</p>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>
",     revisions=""),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={
            Line(points={{-83,-66},{-63,-66}}, color={0,0,0}),
            Line(points={{36,-68},{56,-68}}, color={0,0,0}),
            Line(points={{-73,-66},{-73,-91}}, color={0,0,0}),
            Line(points={{46,-68},{46,-91}}, color={0,0,0}),
            Line(points={{-83,-29},{-63,-29}}, color={0,0,0}),
            Line(points={{36,-32},{56,-32}}, color={0,0,0}),
            Line(points={{-73,-9},{-73,-29}}, color={0,0,0}),
            Line(points={{46,-12},{46,-32}}, color={0,0,0}),
            Line(points={{-73,-91},{46,-91}}, color={0,0,0}),
            Rectangle(
              extent={{-47,-17},{27,-80}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={192,192,192}),
            Rectangle(
              extent={{-87,-41},{-47,-54}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={192,192,192}),
            Rectangle(
              extent={{27,-42},{66,-56}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={192,192,192})}));
    end Rotational;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-5,-40},{45,-70}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Ellipse(extent={{-90,-50},{-80,-60}}, lineColor={0,0,0}),
        Line(
          points={{-85,-55},{-60,-21}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(extent={{-65,-16},{-55,-26}}, lineColor={0,0,0}),
        Line(
          points={{-60,-21},{9,-55}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{4,-50},{14,-60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-10,-34},{72,-34},{72,-76},{-10,-76}}, color={0,0,0})}),
    Documentation(info="<HTML>
<p>
This package contains components to model the movement
of 1-dim. rotational, 1-dim. translational, and
3-dim. <b>mechanical systems</b>.
</p>

<p>
Note, all <b>dissipative</b> components of the Modelica.Mechanics library have
an optional <b>heatPort</b> connector to which the
dissipated energy is transported in form of heat. This connector is enabled
via parameter \"useHeatPort\". If the heatPort connector is enabled,
it must be connected, and if it is not enabled, it must not be connected.
Independently, whether the heatPort is enabled or not,
the dissipated power is available from variable \"<b>lossPower</b>\" (which is
positive if heat is flowing out of the heatPort).
</p>
</HTML>
"));
  end Mechanics;

  package Thermal
  "Library of thermal system components to model heat transfer and simple thermo-fluid pipe flow"
    extends Modelica.Icons.Package;

    package HeatTransfer
    "Library of 1-dimensional heat transfer with lumped elements"
      import Modelica.SIunits.Conversions.*;
      extends Modelica.Icons.Package;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        partial connector HeatPort "Thermal port for 1-dim. heat transfer"
          Modelica.SIunits.Temperature T "Port temperature";
          flow Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate (positive if flowing from outside into the component)";
          annotation (Documentation(info="<html>

</html>"));
        end HeatPort;

        connector HeatPort_a
        "Thermal port for 1-dim. heat transfer (filled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_a",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></HTML>
"),         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-120,120},{100,60}},
                  lineColor={191,0,0},
                  textString="%name")}));
        end HeatPort_a;

        partial model PartialElementaryConditionalHeatPortWithoutT
        "Partial model to include a conditional HeatPort in order to dissipate losses, used for textual modeling, i.e., for elementary models"
          parameter Boolean useHeatPort = false "=true, if heatPort is enabled"
            annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
            final Q_flow=-lossPower) if useHeatPort
          "Optional port to which dissipated losses are transported in form of heat"
            annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
             iconTransformation(extent={{-110,-110},{-90,-90}})));
          Modelica.SIunits.Power lossPower
          "Loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
          annotation (Documentation(info="<html>
<p>
This partial model provides a conditional heat port for dissipating losses.
</p>
<ul>
<li>If <b>useHeatPort</b> is set to <b>false</b> (default), no heat port is available, and the thermal loss power is dissipated internally.
In this case, the parameter <b>T</b> specifies the fixed device temperature (the default for T = 20&deg;C) </li>
<li>If <b>useHeatPort</b> is set to <b>true</b>, the heat port is available. </li>
</ul>
<p>
If this model is used, the loss power has to be provided by an equation in the model which inherits from PartialElementaryConditionalHeatPort model
(<b>lossPower = ...</b>). The device temperature <b>TheatPort</b> can be used to describe the influence of the device temperature on the model behaviour.
</p>
</html>"),         Diagram(graphics));
        end PartialElementaryConditionalHeatPortWithoutT;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),
                                   Documentation(info="<html>

</html>"));
      end Interfaces;
      annotation (
         Icon(coordinateSystem(preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-54,-6},{-61,-7},{-75,-15},{-79,-24},{-80,-34},{-78,-42},{-73,
                  -49},{-64,-51},{-57,-51},{-47,-50},{-41,-43},{-38,-35},{-40,-27},
                  {-40,-20},{-42,-13},{-47,-7},{-54,-5},{-54,-6}},
              lineColor={128,128,128},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-75,-15},{-79,-25},{-80,-34},{-78,-42},{-72,-49},{-64,-51},{
                  -57,-51},{-47,-50},{-57,-47},{-65,-45},{-71,-40},{-74,-33},{-76,-23},
                  {-75,-15},{-75,-15}},
              lineColor={0,0,0},
              fillColor={160,160,164},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{39,-6},{32,-7},{18,-15},{14,-24},{13,-34},{15,-42},{20,-49},
                  {29,-51},{36,-51},{46,-50},{52,-43},{55,-35},{53,-27},{53,-20},{
                  51,-13},{46,-7},{39,-5},{39,-6}},
              lineColor={160,160,164},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{18,-15},{14,-25},{13,-34},{15,-42},{21,-49},{29,-51},{36,-51},
                  {46,-50},{36,-47},{28,-45},{22,-40},{19,-33},{17,-23},{18,-15},{
                  18,-15}},
              lineColor={0,0,0},
              fillColor={160,160,164},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-9,-23},{-9,-10},{18,-17},{-9,-23}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-41,-17},{-9,-17}},
              color={191,0,0},
              thickness=0.5),
            Line(
              points={{-17,-40},{15,-40}},
              color={191,0,0},
              thickness=0.5),
            Polygon(
              points={{-17,-46},{-17,-34},{-40,-40},{-17,-46}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<HTML>
<p>
This package contains components to model <b>1-dimensional heat transfer</b>
with lumped elements. This allows especially to model heat transfer in
machines provided the parameters of the lumped elements, such as
the heat capacity of a part, can be determined by measurements
(due to the complex geometries and many materials used in machines,
calculating the lumped element parameters from some basic analytic
formulas is usually not possible).
</p>
<p>
Example models how to use this library are given in subpackage <b>Examples</b>.<br>
For a first simple example, see <b>Examples.TwoMasses</b> where two masses
with different initial temperatures are getting in contact to each
other and arriving after some time at a common temperature.<br>
<b>Examples.ControlledTemperature</b> shows how to hold a temperature
within desired limits by switching on and off an electric resistor.<br>
A more realistic example is provided in <b>Examples.Motor</b> where the
heating of an electrical motor is modelled, see the following screen shot
of this example:
</p>
<img src=\"modelica://Modelica/Resources/Images/Thermal/HeatTransfer/driveWithHeatTransfer.png\" ALT=\"driveWithHeatTransfer\">
<p>
The <b>filled</b> and <b>non-filled red squares</b> at the left and
right side of a component represent <b>thermal ports</b> (connector HeatPort).
Drawing a line between such squares means that they are thermally connected.
The variables of a HeatPort connector are the temperature <b>T</b> at the port
and the heat flow rate <b>Q_flow</b> flowing into the component (if Q_flow is positive,
the heat flows into the element, otherwise it flows out of the element):
</p>
<pre>   Modelica.SIunits.Temperature  T  \"absolute temperature at port in Kelvin\";
   Modelica.SIunits.HeatFlowRate Q_flow  \"flow rate at the port in Watt\";
</pre>
<p>
Note, that all temperatures of this package, including initial conditions,
are given in Kelvin. For convenience, in subpackages <b>HeatTransfer.Celsius</b>,
 <b>HeatTransfer.Fahrenheit</b> and <b>HeatTransfer.Rankine</b> components are provided such that source and
sensor information is available in degree Celsius, degree Fahrenheit, or degree Rankine,
respectively. Additionally, in package <b>SIunits.Conversions</b> conversion
functions between the units Kelvin and Celsius, Fahrenheit, Rankine are
provided. These functions may be used in the following way:
</p>
<pre>  <b>import</b> SI=Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature T = from_degC(25);  // convert 25 degree Celsius to Kelvin
</pre>

<p>
There are several other components available, such as AxialConduction (discretized PDE in
axial direction), which have been temporarily removed from this library. The reason is that
these components reference material properties, such as thermal conductivity, and currently
the Modelica design group is discussing a general scheme to describe material properties.
</p>
<p>
For technical details in the design of this library, see the following reference:<br>
<b>Michael Tiller (2001)</b>: <a href=\"http://www.amazon.de\">
Introduction to Physical Modeling with Modelica</a>.
Kluwer Academic Publishers Boston.
</p>
<p>
<b>Acknowledgements:</b><br>
Several helpful remarks from the following persons are acknowledged:
John Batteh, Ford Motors, Dearborn, U.S.A;
<a href=\"http://www.haumer.at/\">Anton Haumer</a>, Technical Consulting &amp; Electrical Engineering, Austria;
Ludwig Marvan, VA TECH ELIN EBG Elektronik GmbH, Wien, Austria;
Hans Olsson, Dassault Syst&egrave;mes AB, Sweden;
Hubertus Tummescheit, Lund Institute of Technology, Lund, Sweden.
</p>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  </dd>
</dl>
<p><b>Copyright &copy; 2001-2010, Modelica Association, Michael Tiller and DLR.</b></p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>July 15, 2002</i>
       by Michael Tiller, <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Nikolaus.Schuermann/\">Nikolaus Sch&uuml;rmann</a>:<br>
       Implemented.
</li>
<li><i>June 13, 2005</i>
       by <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
       Refined placing of connectors (cosmetic).<br>
       Refined all Examples; removed Examples.FrequencyInverter, introducing Examples.Motor<br>
       Introduced temperature dependent correction (1 + alpha*(T - T_ref)) in Fixed/PrescribedHeatFlow<br>
</li>
  <li> v1.1.1 2007/11/13 Anton Haumer<br>
       componentes moved to sub-packages</li>
  <li> v1.2.0 2009/08/26 Anton Haumer<br>
       added component ThermalCollector</li>

</ul>
</html>"));
    end HeatTransfer;
  annotation (Documentation(info="<html>
<p>
This package contains libraries to model heat transfer
and fluid heat flow.
</p>
</html>"));
  end Thermal;

  package Math
  "Library of mathematical functions (e.g., sin, cos) and of functions operating on vectors and matrices"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

  package Vectors "Library of functions operating on vectors"
    extends Modelica.Icons.Package;

    function length
    "Return length of a vectorReturn length of a vector (better as norm(), if further symbolic processing is performed)"
      extends Modelica.Icons.Function;
      input Real v[:] "Vector";
      output Real result "Length of vector v";
    algorithm
      result := sqrt(v*v);
      annotation (Inline=true, Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Vectors.<b>length</b>(v);
</pre></blockquote>
<h4>Description</h4>
<p>
The function call \"<code>Vectors.<b>length</b>(v)</code>\" returns the
<b>Euclidean length</b> \"<code>sqrt(v*v)</code>\" of vector v.
The function call is equivalent to Vectors.norm(v). The advantage of
length(v) over norm(v)\"is that function length(..) is implemented
in one statement and therefore the function is usually automatically
inlined. Further symbolic processing is therefore possible, which is
not the case with function norm(..).
</p>
<h4>Example</h4>
<blockquote><pre>
  v = {2, -4, -2, -1};
  <b>length</b>(v);  // = 5
</pre></blockquote>
<h4>See also</h4>
<p>
<a href=\"modelica://Modelica.Math.Vectors.norm\">Vectors.norm</a>
</p>
</html>"));
    end length;

    function normalize
    "Return normalized vector such that length = 1 and prevent zero-division for zero vector"
      extends Modelica.Icons.Function;
      input Real v[:] "Vector";
      input Real eps = 100*Modelica.Constants.eps
      "if |v| < eps then result = v/eps";
      output Real result[size(v, 1)] "Input vector v normalized to length=1";

    algorithm
      result := smooth(0,noEvent(if length(v) >= eps then v/length(v) else v/eps));
      annotation (Inline=true, Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Vectors.<b>normalize</b>(v);
Vectors.<b>normalize</b>(v,eps=100*Modelica.Constants.eps);
</pre></blockquote>
<h4>Description</h4>
<p>
The function call \"<code>Vectors.<b>normalize</b>(v)</code>\" returns the
<b>unit vector</b> \"<code>v/length(v)</code>\" of vector v.
If length(v) is close to zero (more precisely, if length(v) &lt; eps),
v/eps is returned in order to avoid
a division by zero. For many applications this is useful, because
often the unit vector <b>e</b> = <b>v</b>/length(<b>v</b>) is used to compute
a vector x*<b>e</b>, where the scalar x is in the order of length(<b>v</b>),
i.e., x*<b>e</b> is small, when length(<b>v</b>) is small and then
it is fine to replace <b>e</b> by <b>v</b> to avoid a division by zero.
</p>
<p>
Since the function is implemented in one statement,
it is usually inlined and therefore symbolic processing is
possible.
</p>
<h4>Example</h4>
<blockquote><pre>
  <b>normalize</b>({1,2,3});  // = {0.267, 0.534, 0.802}
  <b>normalize</b>({0,0,0});  // = {0,0,0}
</pre></blockquote>
<h4>See also</h4>
<p>
<a href=\"modelica://Modelica.Math.Vectors.length\">Vectors.length</a>
</p>
</html>"));
    end normalize;
    annotation (
      preferedView = "info",
      Documentation(info="<HTML>
<h4>Library content</h4>
<p>
This library provides functions operating on vectors:
</p>

<ul>
<li> <a href=\"modelica://Modelica.Math.Vectors.toString\">toString</a>(v)
     - returns the string representation of vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.isEqual\">isEqual</a>(v1, v2)
     - returns true if vectors v1 and v2 have the same size and the same elements.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.norm\">norm</a>(v,p)
     - returns the p-norm of vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.length\">length</a>(v)
     - returns the length of vector v (= norm(v,2), but inlined and therefore usable in
       symbolic manipulations)</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.normalize\">normalize</a>(v)
     - returns vector in direction of v with lenght = 1 and prevents
       zero-division for zero vector.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.reverse\">reverse</a>(v)
     - reverses the vector elements of v. </li>

<li> <a href=\"modelica://Modelica.Math.Vectors.sort\">sort</a>(v)
     - sorts the elements of vector v in ascending or descending order.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.find\">find</a>(e, v)
     - returns the index of the first occurence of scalar e in vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.interpolate\">interpolate</a>(x, y, xi)
     - returns the interpolated value in (x,y) that corresponds to xi.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.relNodePositions\">relNodePositions</a>(nNodes)
     - returns a vector of relative node positions (0..1).</li>
</ul>

<h4>See also</h4>
<a href=\"modelica://Modelica.Math.Matrices\">Matrices</a>
</HTML>"));
  end Vectors;

  function sin "Sine"
    extends baseIcon1;
    input Modelica.SIunits.Angle u;
    output Real y;

  external "builtin" y=  sin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
                {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},
                {-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},
                {29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{
                57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,0}),
          Text(
            extent={{12,84},{84,36}},
            lineColor={192,192,192},
            textString="sin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},{
                -43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},{
                -14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},{
                29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{57.5,
                -61.9},{63.9,-47.2},{72,-24.8},{80,0}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-105,72},{-85,88}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{70,25},{90,5}},
            textString="2*pi",
            lineColor={0,0,255}),
          Text(
            extent={{-103,-72},{-83,-88}},
            textString="-1",
            lineColor={0,0,255}),
          Text(
            extent={{82,-6},{102,-26}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{-80,80},{-28,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-80,-80},{50,-80}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = sin(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/sin.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end sin;

  function cos "Cosine"
    extends baseIcon1;
    input SI.Angle u;
    output Real y;

  external "builtin" y=  cos(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},
                {-48.6,26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},
                {-4.42,-78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},
                {24.5,-45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{69.5,
                73.4},{75.2,78.6},{80,80}}, color={0,0,0}),
          Text(
            extent={{-36,82},{36,34}},
            lineColor={192,192,192},
            textString="cos")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-103,72},{-83,88}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{-103,-72},{-83,-88}},
            textString="-1",
            lineColor={0,0,255}),
          Text(
            extent={{70,25},{90,5}},
            textString="2*pi",
            lineColor={0,0,255}),
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},{-48.6,
                26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},{-4.42,
                -78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},{24.5,
                -45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{69.5,73.4},
                {75.2,78.6},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{78,-6},{98,-26}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{-80,-80},{18,-80}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = cos(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/cos.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end cos;

  function asin "Inverse sine (-1 <= u <= 1)"
    extends baseIcon2;
    input Real u;
    output SI.Angle y;

  external "builtin" y=  asin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,
                -49.8},{-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,
                52.7},{75.2,62.2},{77.6,67.5},{80,80}}, color={0,0,0}),
          Text(
            extent={{-88,78},{-16,30}},
            lineColor={192,192,192},
            textString="asin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-40,-72},{-15,-88}},
            textString="-pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{-38,88},{-13,72}},
            textString=" pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{68,-9},{88,-29}},
            textString="+1",
            lineColor={0,0,255}),
          Text(
            extent={{-90,21},{-70,1}},
            textString="-1",
            lineColor={0,0,255}),
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,-49.8},
                {-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,52.7},{
                75.2,62.2},{77.6,67.5},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{82,24},{102,4}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{86,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,86},{80,-10}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = asin(u), with -1 &le; u &le; +1:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/asin.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end asin;

  function atan2 "Four quadrant inverse tangent"
    extends baseIcon2;
    input Real u1;
    input Real u2;
    output SI.Angle y;

  external "builtin" y=  atan2(u1, u2);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{0,-80},{8.93,-67.2},{17.1,-59.3},{27.3,-53.6},{42.1,-49.4},
                {69.9,-45.8},{80,-45.1}}, color={0,0,0}),
          Line(points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},{-18.3,-21.5},{-10.3,
                -14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{24.3,25},{39,30},{
                62.1,33.5},{80,34.9}}, color={0,0,0}),
          Line(points={{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,
                65.8},{-1.82,77.2},{0,80}}, color={0,0,0}),
          Text(
            extent={{-90,-46},{-18,-94}},
            lineColor={192,192,192},
            textString="atan2")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{96,0},{80,6},{80,-6},{96,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{0,-80},{8.93,-67.2},{17.1,-59.3},{27.3,-53.6},{42.1,-49.4},{
                69.9,-45.8},{80,-45.1}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},{-18.3,-21.5},{-10.3,
                -14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{24.3,25},{39,30},{
                62.1,33.5},{80,34.9}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,65.8},
                {-1.82,77.2},{0,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-32,89},{-10,74}},
            textString="pi",
            lineColor={0,0,255}),
          Text(
            extent={{-32,-72},{-4,-88}},
            textString="-pi",
            lineColor={0,0,255}),
          Text(
            extent={{0,55},{20,42}},
            textString="pi/2",
            lineColor={0,0,255}),
          Line(points={{0,40},{-8,40}}, color={192,192,192}),
          Line(points={{0,-40},{-8,-40}}, color={192,192,192}),
          Text(
            extent={{0,-23},{20,-42}},
            textString="-pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{62,-4},{94,-26}},
            lineColor={95,95,95},
            textString="u1, u2"),
          Line(
            points={{-88,40},{86,40}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-86,-40},{86,-40}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<HTML>
This function returns y = atan2(u1,u2) such that tan(y) = u1/u2 and
y is in the range -pi &lt; y &le; pi. u2 may be zero, provided
u1 is not zero. Usually u1, u2 is provided in such a form that
u1 = sin(y) and u2 = cos(y):
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/atan2.png\">
</p>

</HTML>
"),          Library="ModelicaExternalC");
  end atan2;

  partial function baseIcon1
    "Basic icon for mathematical function with y-axis on left side"

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),                          Diagram(
          coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Line(points={{-80,80},{-88,80}}, color={95,95,95}),
          Line(points={{-80,-80},{-88,-80}}, color={95,95,95}),
          Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
          Text(
            extent={{-75,104},{-55,84}},
            lineColor={95,95,95},
            textString="y"),
          Polygon(
            points={{-80,98},{-86,82},{-74,82},{-80,98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis on the left side.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
  end baseIcon1;

  partial function baseIcon2
    "Basic icon for mathematical function with y-axis in middle"

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{0,-80},{0,68}}, color={192,192,192}),
          Polygon(
            points={{0,90},{-8,68},{8,68},{0,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),                          Diagram(graphics={
          Line(points={{0,80},{-8,80}}, color={95,95,95}),
          Line(points={{0,-80},{-8,-80}}, color={95,95,95}),
          Line(points={{0,-90},{0,84}}, color={95,95,95}),
          Text(
            extent={{5,104},{25,84}},
            lineColor={95,95,95},
            textString="y"),
          Polygon(
            points={{0,98},{-6,82},{6,82},{0,98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis in the middle.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
  end baseIcon2;

  function tempInterpol1
    "Temporary function for linear interpolation (will be removed)"
    input Real u "input value (first column of table)";
    input Real table[:, :] "table to be interpolated";
    input Integer icol "column of table to be interpolated";
    output Real y "interpolated input value (icol column of table)";
  protected
    Integer i;
    Integer n "number of rows of table";
    Real u1;
    Real u2;
    Real y1;
    Real y2;
  algorithm
    n := size(table, 1);

    if n <= 1 then
      y := table[1, icol];

    else
      // Search interval

      if u <= table[1, 1] then
        i := 1;

      else
        i := 2;
        // Supports duplicate table[i, 1] values
        // in the interior to allow discontinuities.
        // Interior means that
        // if table[i, 1] = table[i+1, 1] we require i>1 and i+1<n

        while i < n and u >= table[i, 1] loop
          i := i + 1;

        end while;
        i := i - 1;

      end if;

      // Get interpolation data
      u1 := table[i, 1];
      u2 := table[i + 1, 1];
      y1 := table[i, icol];
      y2 := table[i + 1, icol];

      assert(u2 > u1, "Table index must be increasing");
      // Interpolate
      y := y1 + (y2 - y1)*(u - u1)/(u2 - u1);

    end if;

    annotation (Documentation(info="<html>

</html>"));
  end tempInterpol1;
  annotation (
    Invisible=true,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-59,-9},{42,-56}},
          lineColor={0,0,0},
          textString="f(x)")}),
    Documentation(info="<HTML>
<p>
This package contains <b>basic mathematical functions</b> (such as sin(..)),
as well as functions operating on
<a href=\"modelica://Modelica.Math.Vectors\">vectors</a>,
<a href=\"modelica://Modelica.Math.Matrices\">matrices</a>,
<a href=\"modelica://Modelica.Math.Nonlinear\">nonlinear functions</a>, and
<a href=\"modelica://Modelica.Math.BooleanVectors\">Boolean vectors</a>.
</p>

<dl>
<dt><b>Main Authors:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
    Marcus Baur<br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e.V. (DLR)<br>
    Institut f&uuml;r Robotik und Mechatronik<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",   revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Function tempInterpol2 added.</li>
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Icons for icon and diagram level introduced.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>

</html>"));
  end Math;

  package Utilities
  "Library of utility functions dedicated to scripting (operating on files, streams, strings, system)"
    extends Modelica.Icons.Package;

    package Internal
    "Internal components that a user should usually not directly utilize"
      extends Modelica.Icons.Package;

    partial package PartialModelicaServices
      "Interfaces of components requiring a tool specific implementation"
        extends Modelica.Icons.Package;
      package Animation "Models and functions for 3-dim. animation"
        extends Modelica.Icons.Package;
      partial model PartialShape
          "Interface for 3D animation of elementary shapes"

          import SI = Modelica.SIunits;
          import Modelica.Mechanics.MultiBody.Frames;
          import Modelica.Mechanics.MultiBody.Types;

        parameter Types.ShapeType shapeType="box"
            "Type of shape (box, sphere, cylinder, pipecylinder, cone, pipe, beam, gearwheel, spring)";
        input Frames.Orientation R=Frames.nullRotation()
            "Orientation object to rotate the world frame into the object frame"
                                                                                annotation(Dialog);
        input SI.Position r[3]={0,0,0}
            "Position vector from origin of world frame to origin of object frame, resolved in world frame"
                                                                                                          annotation(Dialog);
        input SI.Position r_shape[3]={0,0,0}
            "Position vector from origin of object frame to shape origin, resolved in object frame"
                                                                                                  annotation(Dialog);
        input Real lengthDirection[3](each final unit="1")={1,0,0}
            "Vector in length direction, resolved in object frame"
                                                                  annotation(Dialog);
        input Real widthDirection[3](each final unit="1")={0,1,0}
            "Vector in width direction, resolved in object frame"
                                                                 annotation(Dialog);
        input SI.Length length=0 "Length of visual object"  annotation(Dialog);
        input SI.Length width=0 "Width of visual object"  annotation(Dialog);
        input SI.Length height=0 "Height of visual object"  annotation(Dialog);
        input Types.ShapeExtra extra=0.0
            "Additional size data for some of the shape types"                               annotation(Dialog);
        input Real color[3]={255,0,0} "Color of shape"               annotation(Dialog(__Dymola_colorSelector=true));
        input Types.SpecularCoefficient specularCoefficient = 0.7
            "Reflection of ambient light (= 0: light is completely absorbed)"
                                                                            annotation(Dialog);
        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>

<p>
This model is documented at
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape</a>.
</p>

</html>
"));

      end PartialShape;

        model PartialSurface "Interface for 3D animation of surfaces"

          import Modelica.Mechanics.MultiBody.Frames;
          import Modelica.Mechanics.MultiBody.Types;

          input Frames.Orientation R=Frames.nullRotation()
            "Orientation object to rotate the world frame into the surface frame"
            annotation(Dialog(group="Surface frame"));
          input Modelica.SIunits.Position r_0[3]={0,0,0}
            "Position vector from origin of world frame to origin of surface frame, resolved in world frame"
            annotation(Dialog(group="Surface frame"));

          parameter Integer nu=2 "Number of points in u-Dimension" annotation(Dialog(group="Surface properties"));
          parameter Integer nv=2 "Number of points in v-Dimension" annotation(Dialog(group="Surface properties"));
          replaceable function surfaceCharacteristic =
             Modelica.Mechanics.MultiBody.Interfaces.partialSurfaceCharacteristic
            "Function defining the surface characteristic"
                  annotation(__Dymola_choicesAllMatching=true,Dialog(group="Surface properties"));

          parameter Boolean wireframe=false
            "= true: 3D model will be displayed without faces"
            annotation (Dialog(group="Material properties"),choices(checkBox=true));
          parameter Boolean multiColoredSurface=false
            "= true: Color is defined for each surface point"
              annotation(Dialog(group="Material properties"),choices(checkBox=true));
          input Real color[3]={255,0,0} "Color of surface" annotation(Dialog(__Dymola_colorSelector=true,group="Material properties", enable=not multiColoredSurface));
          input Types.SpecularCoefficient specularCoefficient = 0.7
            "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group="Material properties"));
          input Real transparency=0
            "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)"
                                       annotation(Dialog(group="Material properties"));
          annotation (Documentation(info="<html>
<p>
This model is documented at
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface</a>.
</p>

</html>"));
        end PartialSurface;
      end Animation;

        annotation (Documentation(info="<html>

<p>
This package contains interfaces of a set of functions and models used in the
Modelica Standard Library that requires a <u>tool specific implementation</u>.
There is an associated package called <u>ModelicaServices</u>. A tool vendor
should provide a proper implementation of this library for the corresponding
tool. The default implementation is \"do nothing\".
In the Modelica Standard Library, the models and functions of ModelicaServices
are used.
</p>

</html>"));
    end PartialModelicaServices;
    end Internal;
      annotation (
  Documentation(info="<html>
<p>
This package contains Modelica <b>functions</b> that are
especially suited for <b>scripting</b>. The functions might
be used to work with strings, read data from file, write data
to file or copy, move and remove files.
</p>
<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.UsersGuide\">Modelica.Utilities.User's Guide</a>
     discusses the most important aspects of this library.</li>
<li> <a href=\"modelica://Modelica.Utilities.Examples\">Modelica.Utilities.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
The following main sublibraries are available:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.Files\">Files</a>
     provides functions to operate on files and directories, e.g.,
     to copy, move, remove files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>
     provides functions to read from files and write to files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Strings\">Strings</a>
     provides functions to operate on strings. E.g.
     substring, find, replace, sort, scanToken.</li>
<li> <a href=\"modelica://Modelica.Utilities.System\">System</a>
     provides functions to interact with the environment.
     E.g., get or set the working directory or environment
     variables and to send a command to the default shell.</li>
</ul>

<p>
Copyright &copy; 1998-2010, Modelica Association, DLR, and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>
"));
  end Utilities;

  package Constants
  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)"
    import SI = Modelica.SIunits;
    import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    extends Modelica.Icons.Package;

    final constant Real pi=2*Modelica.Math.asin(1.0);

    final constant Real eps=1.e-15 "Biggest number such that 1.0 + eps = 1.0";

    final constant Real small=1.e-60
    "Smallest number such that small and -small are representable on the machine";

    final constant Real inf=1.e+60
    "Biggest Real number such that inf and -inf are representable on the machine";
    annotation (
      Documentation(info="<html>
<p>
This package provides often needed constants from mathematics, machine
dependent constants and constants from nature. The latter constants
(name, value, description) are from the following source:
</p>

<dl>
<dt>Peter J. Mohr and Barry N. Taylor (1999):</dt>
<dd><b>CODATA Recommended Values of the Fundamental Physical Constants: 1998</b>.
    Journal of Physical and Chemical Reference Data, Vol. 28, No. 6, 1999 and
    Reviews of Modern Physics, Vol. 72, No. 2, 2000. See also <a href=
\"http://physics.nist.gov/cuu/Constants/\">http://physics.nist.gov/cuu/Constants/</a></dd>
</dl>

<p>CODATA is the Committee on Data for Science and Technology.</p>

<dl>
<dt><b>Main Author:</b></dt>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 11 16<br>
    D-82230 We&szlig;ling<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>
",   revisions="<html>
<ul>
<li><i>Nov 8, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Constants updated according to 2002 CODATA values.</li>
<li><i>Dec 9, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants updated according to 1998 CODATA values. Using names, values
       and description text from this source. Included magnetic and
       electric constant.</li>
<li><i>Sep 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants eps, inf, small introduced.</li>
<li><i>Nov 15, 1997</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>
</html>"),
      Invisible=true,
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Line(
            points={{-34,-38},{12,-38}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-20,-38},{-24,-48},{-28,-56},{-34,-64}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-2,-38},{2,-46},{8,-56},{14,-64}},
            color={0,0,0},
            thickness=0.5)}),
      Diagram(graphics={
          Rectangle(
            extent={{200,162},{380,312}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{200,312},{220,332},{400,332},{380,312},{200,312}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{400,332},{400,182},{380,162},{380,312},{400,332}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Text(
            extent={{210,302},{370,272}},
            lineColor={160,160,164},
            textString="Library"),
          Line(
            points={{266,224},{312,224}},
            color={0,0,0},
            thickness=1),
          Line(
            points={{280,224},{276,214},{272,206},{266,198}},
            color={0,0,0},
            thickness=1),
          Line(
            points={{298,224},{302,216},{308,206},{314,198}},
            color={0,0,0},
            thickness=1),
          Text(
            extent={{152,412},{458,334}},
            lineColor={255,0,0},
            textString="Modelica.Constants")}));
  end Constants;

  package Icons "Library of icons"
    extends Icons.Package;

    partial package ExamplesPackage
    "Icon for packages containing runnable examples"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-58,46},{42,-14},{-58,-74},{-58,46}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates a package that contains executable examples.</p>
</html>"));
    end ExamplesPackage;

    partial model Example "Icon for runnable examples"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Ellipse(extent={{-100,100},{100,-100}},
                lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
                                       Polygon(
              points={{-36,60},{64,0},{-36,-60},{-36,60}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
    end Example;

    partial package Package "Icon for standard packages"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>Standard package icon.</p>
</html>"));
    end Package;

    partial package InterfacesPackage "Icon for packages containing interfaces"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{0,50},{20,50},{50,10},{80,10},{80,-30},{50,-30},{20,-70},{
                  0,-70},{0,50}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-100,10},{-70,10},{-40,50},{-20,50},{-20,-70},{-40,-70},{
                  -70,-30},{-100,-30},{-100,10}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon indicates packages containing interfaces.</p>
</html>"));
    end InterfacesPackage;

    partial package SourcesPackage "Icon for packages containing sources"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-28,12},{-28,-40},{36,-14},{-28,12}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-28,-14},{-68,-14}},
              color={0,0,0},
              smooth=Smooth.None)}),
                                Documentation(info="<html>
<p>This icon indicates a package which contains sources.</p>
</html>"));
    end SourcesPackage;

    partial package SensorsPackage "Icon for packages containing sensors"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-70,20},{50,20}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(points={{-10,-70},{38,54}}, color={0,0,0}),
            Ellipse(
              extent={{-15,-65},{-5,-75}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-70,20},{-70,-8}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{50,20},{50,-8}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-10,20},{-10,-8}},
              color={0,0,0},
              smooth=Smooth.None)}),
                                Documentation(info="<html>
<p>This icon indicates a package containing sensors.</p>
</html>"));
    end SensorsPackage;

    partial class RotationalSensor
    "Icon representing a round measurement device"

      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={
            Ellipse(
              extent={{-70,70},{70,-70}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(points={{0,70},{0,40}}, color={0,0,0}),
            Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
            Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
            Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
            Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0}),
            Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
            Polygon(
              points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-5,5},{5,-5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics),
        Documentation(info="<html>
<p>
This icon is designed for a <b>rotational sensor</b> model.
</p>
</html>"));
    end RotationalSensor;

    partial function Function "Icon for functions"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Text(extent={{-140,162},{136,102}}, textString=
                                                   "%name"),
            Ellipse(
              extent={{-100,100},{100,-100}},
              lineColor={255,127,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-100,100},{100,-100}},
              lineColor={255,127,0},
              textString=
                   "f")}),Documentation(Error, info="<html>
<p>This icon indicates Modelica functions.</p>
</html>"));
    end Function;

    partial record Record "Icon for records"

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={
            Rectangle(
              extent={{-100,50},{100,-100}},
              fillColor={255,255,127},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}),
            Text(
              extent={{-127,115},{127,55}},
              textString="%name",
              lineColor={0,0,255}),
            Line(points={{-100,-50},{100,-50}}, color={0,0,0}),
            Line(points={{-100,0},{100,0}}, color={0,0,0}),
            Line(points={{0,50},{0,-100}}, color={0,0,0})}),
                                                          Documentation(info="<html>
<p>
This icon is indicates a record.
</p>
</html>"));
    end Record;

    type TypeReal "Icon for Real types"
        extends Real;
        annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Text(
              extent={{-94,94},{94,-94}},
              lineColor={0,0,0},
              fillColor={181,181,181},
              fillPattern=FillPattern.Solid,
              textString=
                   "R")}),Documentation(info="<html>
<p>
This icon is designed for a <b>Real</b> type.
</p>
</html>"));
    end TypeReal;

    type TypeInteger "Icon for Integer types"
        extends Integer;
        annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Text(
              extent={{-94,94},{94,-94}},
              lineColor={0,0,0},
              fillColor={181,181,181},
              fillPattern=FillPattern.Solid,
              textString=
                   "I")}),Documentation(info="<html>
<p>
This icon is designed for an <b>Integer</b> type.
</p>
</html>"));
    end TypeInteger;

    type TypeString "Icon for String types"
        extends String;
        annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Text(
              extent={{-94,94},{94,-94}},
              lineColor={0,0,0},
              fillColor={181,181,181},
              fillPattern=FillPattern.Solid,
              textString=
                   "S")}),Documentation(info="<html>
<p>
This icon is designed for a <b>String</b> type.
</p>
</html>"));
    end TypeString;

    connector SignalBus "Icon for signal bus"

      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2},
            initialScale=0.2), graphics={
            Rectangle(
              extent={{-20,2},{20,-2}},
              lineColor={255,204,51},
              lineThickness=0.5),
            Polygon(
              points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,
                  -40},{-100,30},{-80,50}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-65,25},{-55,15}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-5,25},{5,15}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{55,25},{65,15}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-35,-15},{-25,-25}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{25,-15},{35,-25}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2},
            initialScale=0.2), graphics={
            Polygon(
              points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,
                  -20},{-50,15},{-40,25}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-32.5,7.5},{-27.5,12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2.5,12.5},{2.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{27.5,12.5},{32.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-17.5,-7.5},{-12.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{12.5,-7.5},{17.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,70},{150,40}},
              lineColor={0,0,0},
              textString=
                   "%name")}),
        Documentation(Error, info="<html>
This icon is designed for a <b>signal bus</b> connector.
</html>"));
    end SignalBus;

    connector SignalSubBus "Icon for signal sub-bus"

      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2},
            initialScale=0.1), graphics={
            Line(
              points={{-16,2},{16,2}},
              color={255,204,51},
              thickness=0.5),
            Rectangle(
              extent={{-10,8},{8,0}},
              lineColor={255,204,51},
              lineThickness=0.5),
            Polygon(
              points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,
                  -40},{-100,30},{-80,50}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-55,25},{-45,15}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{45,25},{55,15}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-5,-15},{5,-25}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-20,4},{20,0}},
              lineColor={255,204,51},
              lineThickness=0.5)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2},
            initialScale=0.1), graphics={
            Polygon(
              points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,
                  -20},{-50,15},{-40,25}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-22.5,7.5},{-17.5,12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{17.5,12.5},{22.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2.5,-7.5},{2.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,70},{150,40}},
              lineColor={0,0,0},
              textString=
                   "%name")}),
        Documentation(info="<html>
<p>
This icon is designed for a <b>sub-bus</b> in a signal connector.
</p>
</html>"));

    end SignalSubBus;

    partial class MotorIcon
    "This icon will be removed in future Modelica versions."

      annotation (             Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={
            Rectangle(
              extent={{-100,50},{30,-50}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={255,0,0}),
            Polygon(
              points={{-100,-90},{-90,-90},{-60,-20},{-10,-20},{20,-90},{30,-90},
                  {30,-100},{-100,-100},{-100,-90}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{30,10},{90,-10}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={192,192,192})}),
        Documentation(info="<html>
<p>
This icon of an <b>electrical motor</b> model will be removed in future versions of the library. Please use a locally defined icon in your user defined libraries and applications.
</p>
</html>"));
    end MotorIcon;
    annotation(Documentation(__Dymola_DocumentationClass=true, info="<html>
<p>This package contains definitions for the graphical layout of components which may be used in different libraries. The icons can be utilized by inheriting them in the desired class using &quot;extends&quot; or by directly copying the &quot;icon&quot; layer. </p>
<dl>
<dt><b>Main Authors:</b> </dt>
    <dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a></dd><dd>Deutsches Zentrum fuer Luft und Raumfahrt e.V. (DLR)</dd><dd>Oberpfaffenhofen</dd><dd>Postfach 1116</dd><dd>D-82230 Wessling</dd><dd>email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd><br>
    <dd>Christian Kral</dd><dd><a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a></dd><dd>Mobility Department</dd><dd>Giefinggasse 2</dd><dd>1210 Vienna, Austria</dd><dd>email: <a href=\"mailto:christian.kral@ait.ac.at\">christian.kral@ait.ac.at</a></dd><br>
    <dd align=\"justify\">Johan Andreasson</dd><dd align=\"justify\"><a href=\"http://www.modelon.se/\">Modelon AB</a></dd><dd align=\"justify\">Ideon Science Park</dd><dd align=\"justify\">22370 Lund, Sweden</dd><dd align=\"justify\">email: <a href=\"mailto:johan.andreasson@modelon.se\">johan.andreasson@modelon.se</a></dd>
</dl>
<p>Copyright &copy; 1998-2010, Modelica Association, DLR, AIT, and Modelon AB. </p>
<p><i>This Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b> in <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a>.</i> </p>
</html>"));
  end Icons;

  package SIunits
  "Library of type and unit definitions based on SI units according to ISO 31-1992"
    extends Modelica.Icons.Package;

    package Conversions
    "Conversion functions to/from non SI units and type definitions of non SI units"
      extends Modelica.Icons.Package;

      package NonSIunits "Type definitions of non SI units"
        extends Modelica.Icons.Package;

        type Angle_deg = Real (final quantity="Angle", final unit="deg")
        "Angle in degree";
        annotation (Documentation(info="<HTML>
<p>
This package provides predefined types, such as <b>Angle_deg</b> (angle in
degree), <b>AngularVelocity_rpm</b> (angular velocity in revolutions per
minute) or <b>Temperature_degF</b> (temperature in degree Fahrenheit),
which are in common use but are not part of the international standard on
units according to ISO 31-1992 \"General principles concerning quantities,
units and symbols\" and ISO 1000-1992 \"SI units and recommendations for
the use of their multiples and of certain other units\".</p>
<p>If possible, the types in this package should not be used. Use instead
types of package Modelica.SIunits. For more information on units, see also
the book of Francois Cardarelli <b>Scientific Unit Conversion - A
Practical Guide to Metrication</b> (Springer 1997).</p>
<p>Some units, such as <b>Temperature_degC/Temp_C</b> are both defined in
Modelica.SIunits and in Modelica.Conversions.NonSIunits. The reason is that these
definitions have been placed erroneously in Modelica.SIunits although they
are not SIunits. For backward compatibility, these type definitions are
still kept in Modelica.SIunits.</p>
</HTML>
"),   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={Text(
                extent={{-66,-13},{52,-67}},
                lineColor={0,0,0},
                textString="[km/h]")}));
      end NonSIunits;

      function from_deg "Convert from degree to radian"
        extends ConversionIcon;
        input NonSIunits.Angle_deg degree "degree value";
        output Angle radian "radian value";
      algorithm
        radian := (Modelica.Constants.pi/180.0)*degree;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{4,100},{-102,46}},
                lineColor={0,0,0},
                textString="deg"), Text(
                extent={{100,-32},{-18,-100}},
                lineColor={0,0,0},
                textString="rad")}));
      end from_deg;

      partial function ConversionIcon "Base icon for conversion functions"

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={191,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{30,0}}, color={191,0,0}),
              Polygon(
                points={{90,0},{30,20},{30,-20},{90,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-115,155},{115,105}},
                textString="%name",
                lineColor={0,0,255})}));
      end ConversionIcon;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,
                       extent={{-100,-100},{100,100}}), graphics),
                                Documentation(info="<HTML>
<p>This package provides conversion functions from the non SI Units
defined in package Modelica.SIunits.Conversions.NonSIunits to the
corresponding SI Units defined in package Modelica.SIunits and vice
versa. It is recommended to use these functions in the following
way (note, that all functions have one Real input and one Real output
argument):</p>
<pre>
  <b>import</b> SI = Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature     T   = from_degC(25);   // convert 25 degree Celsius to Kelvin
  <b>parameter</b> SI.Angle           phi = from_deg(180);   // convert 180 degree to radian
  <b>parameter</b> SI.AngularVelocity w   = from_rpm(3600);  // convert 3600 revolutions per minutes
                                                      // to radian per seconds
</pre>

</HTML>
"));
    end Conversions;

    type Angle = Real (
        final quantity="Angle",
        final unit="rad",
        displayUnit="deg");

    type Length = Real (final quantity="Length", final unit="m");

    type Position = Length;

    type Distance = Length (min=0);

    type Diameter = Length(min=0);

    type Time = Real (final quantity="Time", final unit="s");

    type AngularVelocity = Real (
        final quantity="AngularVelocity",
        final unit="rad/s");

    type AngularAcceleration = Real (final quantity="AngularAcceleration", final unit=
               "rad/s2");

    type Velocity = Real (final quantity="Velocity", final unit="m/s");

    type Acceleration = Real (final quantity="Acceleration", final unit="m/s2");

    type Mass = Real (
        quantity="Mass",
        final unit="kg",
        min=0);

    type MomentOfInertia = Real (final quantity="MomentOfInertia", final unit=
            "kg.m2");

    type Inertia = MomentOfInertia;

    type Force = Real (final quantity="Force", final unit="N");

    type Torque = Real (final quantity="Torque", final unit="N.m");

    type ElectricalTorqueConstant = Real(final quantity="ElectricalTorqueConstant", final unit= "N.m/A");

    type RotationalSpringConstant=Real(final quantity="RotationalSpringConstant", final unit="N.m/rad");

    type RotationalDampingConstant=Real(final quantity="RotationalDampingConstant", final unit="N.m.s/rad");

    type Power = Real (final quantity="Power", final unit="W");

    type ThermodynamicTemperature = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K",
        min = 0,
        start = 288.15,
        displayUnit="degC")
    "Absolute temperature (use type TemperatureDifference for relative temperatures)"
                                                                                                        annotation(__Dymola_absoluteValue=true);

    type Temperature = ThermodynamicTemperature;

    type LinearTemperatureCoefficient = Real(final quantity = "LinearTemperatureCoefficient", final unit="1/K");

    type HeatFlowRate = Real (final quantity="Power", final unit="W");

    type ElectricCurrent = Real (final quantity="ElectricCurrent", final unit="A");

    type Current = ElectricCurrent;

    type ElectricPotential = Real (final quantity="ElectricPotential", final unit=
           "V");

    type Voltage = ElectricPotential;

    type Capacitance = Real (
        final quantity="Capacitance",
        final unit="F",
        min=0);

    type Inductance = Real (
        final quantity="Inductance",
        final unit="H");

    type Resistance = Real (
        final quantity="Resistance",
        final unit="Ohm");
    annotation (
      Invisible=true,
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={Text(
            extent={{-63,-13},{45,-67}},
            lineColor={0,0,0},
            textString="[kg.m2]")}),
      Documentation(info="<html>
<p>This package provides predefined types, such as <i>Mass</i>,
<i>Angle</i>, <i>Time</i>, based on the international standard
on units, e.g.,
</p>

<pre>   <b>type</b> Angle = Real(<b>final</b> quantity = \"Angle\",
                     <b>final</b> unit     = \"rad\",
                     displayUnit    = \"deg\");
</pre>

<p>
as well as conversion functions from non SI-units to SI-units
and vice versa in subpackage
<a href=\"modelica://Modelica.SIunits.Conversions\">Conversions</a>.
</p>

<p>
For an introduction how units are used in the Modelica standard library
with package SIunits, have a look at:
<a href=\"modelica://Modelica.SIunits.UsersGuide.HowToUseSIunits\">How to use SIunits</a>.
</p>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>Jan. 27, 2010</i> by Christian Kral:<br/>Added complex units.</li>
<li><i>Dec. 14, 2005</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Add User&#39;;s Guide and removed &quot;min&quot; values for Resistance and Conductance.</li>
<li><i>October 21, 2002</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br/>Added new package <b>Conversions</b>. Corrected typo <i>Wavelenght</i>.</li>
<li><i>June 6, 2000</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Introduced the following new types<br/>type Temperature = ThermodynamicTemperature;<br/>types DerDensityByEnthalpy, DerDensityByPressure, DerDensityByTemperature, DerEnthalpyByPressure, DerEnergyByDensity, DerEnergyByPressure<br/>Attribute &quot;final&quot; removed from min and max values in order that these values can still be changed to narrow the allowed range of values.<br/>Quantity=&quot;Stress&quot; removed from type &quot;Stress&quot;, in order that a type &quot;Stress&quot; can be connected to a type &quot;Pressure&quot;.</li>
<li><i>Oct. 27, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>New types due to electrical library: Transconductance, InversePotential, Damping.</li>
<li><i>Sept. 18, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Renamed from SIunit to SIunits. Subpackages expanded, i.e., the SIunits package, does no longer contain subpackages.</li>
<li><i>Aug 12, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Type &quot;Pressure&quot; renamed to &quot;AbsolutePressure&quot; and introduced a new type &quot;Pressure&quot; which does not contain a minimum of zero in order to allow convenient handling of relative pressure. Redefined BulkModulus as an alias to AbsolutePressure instead of Stress, since needed in hydraulics.</li>
<li><i>June 29, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Bug-fix: Double definition of &quot;Compressibility&quot; removed and appropriate &quot;extends Heat&quot; clause introduced in package SolidStatePhysics to incorporate ThermodynamicTemperature.</li>
<li><i>April 8, 1998</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and Astrid Jaschinski:<br/>Complete ISO 31 chapters realized.</li>
<li><i>Nov. 15, 1997</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br/>Some chapters realized.</li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{169,86},{349,236}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{169,236},{189,256},{369,256},{349,236},{169,236}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{369,256},{369,106},{349,86},{349,236},{369,256}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Text(
            extent={{179,226},{339,196}},
            lineColor={160,160,164},
            textString="Library"),
          Text(
            extent={{206,173},{314,119}},
            lineColor={0,0,0},
            textString="[kg.m2]"),
          Text(
            extent={{163,320},{406,264}},
            lineColor={255,0,0},
            textString="Modelica.SIunits")}));
  end SIunits;
annotation (
preferredView="info",
version="3.2",
versionBuild=6,
versionDate="2010-10-25",
dateModified = "2010-11-08 14:38:50Z",
revisionId="$Id:: package.mo 4362 2010-11-08 14:40:58Z #$",
uses(Complex(version="1.0"), ModelicaServices(version="1.1")),
conversion(
 noneFromVersion="3.1",
 noneFromVersion="3.0.1",
 noneFromVersion="3.0",
 from(version="2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos")),
__Dymola_classOrder={"UsersGuide","Blocks","StateGraph","Electrical","Magnetic","Mechanics","Fluid","Media","Thermal",
      "Math","Utilities","Constants", "Icons", "SIunits"},
Settings(NewStateSelection=true),
Documentation(info="<HTML>
<p>
Package <b>Modelica&reg;</b> is a <b>standardized</b> and <b>free</b> package
that is developed together with the Modelica&reg; language from the
Modelica Association, see
<a href=\"http://www.Modelica.org\">http://www.Modelica.org</a>.
It is also called <b>Modelica Standard Library</b>.
It provides model components in many domains that are based on
standardized interface definitions. Some typical examples are shown
in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/UsersGuide/ModelicaLibraries.png\">

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.UsersGuide.Overview\">Overview</a>
  provides an overview of the Modelica Standard Library
  inside the <a href=\"modelica://Modelica.UsersGuide\">User's Guide</a>.</li>
<li><a href=\"modelica://Modelica.UsersGuide.ReleaseNotes\">Release Notes</a>
 summarizes the changes of new versions of this package.</li>
<li> <a href=\"modelica://Modelica.UsersGuide.Contact\">Contact</a>
  lists the contributors of the Modelica Standard Library.</li>
<li> The <b>Examples</b> packages in the various libraries, demonstrate
  how to use the components of the corresponding sublibrary.</li>
</ul>

<p>
This version of the Modelica Standard Library consists of
</p>
<ul>
<li> <b>1280</b> models and blocks, and</li>
<li> <b>910</b> functions
</ul>
<p>
that are directly usable (= number of public, non-partial classes).
</p>

<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 1998-2010, ABB, AIT, T.&nbsp;B&ouml;drich, DLR, Dassault Syst&egrave;mes AB, Fraunhofer, A.Haumer, Modelon,
TU Hamburg-Harburg, Politecnico di Milano.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
"));
end Modelica;
model Modelica_Mechanics_MultiBody_Examples_Systems_RobotR3_fullRobot
 extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot;
  annotation(experiment(StopTime=2),uses(Modelica(version="3.2")));
end Modelica_Mechanics_MultiBody_Examples_Systems_RobotR3_fullRobot;
