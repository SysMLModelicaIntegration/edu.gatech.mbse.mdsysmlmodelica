  
  
  
  
  
  
  
model Modelica_Blocks_Examples_InverseModel
	extends Modelica.Blocks.Examples.InverseModel;  
end Modelica_Blocks_Examples_InverseModel;
  
package Modelica
	extends Modelica.Icons.Library;  
	package Blocks
		import SI = Modelica.SIunits;
		extends Modelica.Icons.Library2;  
		package Examples
			extends Modelica.Icons.Library;  
			model InverseModel
				extends Modelica.Icons.Example;  
				Modelica.Blocks.Continuous.FirstOrder firstOrder1 (k = 1, T = 0.3, initType = Modelica.Blocks.Types.Init.SteadyState);
				Modelica.Blocks.Sources.Sine sine (freqHz = 2, offset = 1, startTime = 0.2);
				Modelica.Blocks.Math.InverseBlockConstraints inverseBlockConstraints;
				Modelica.Blocks.Continuous.FirstOrder firstOrder2 (k = 1, T = 0.3, initType = Modelica.Blocks.Types.Init.SteadyState);
				Modelica.Blocks.Math.Feedback feedback;
				Modelica.Blocks.Continuous.CriticalDamping criticalDamping (n = 1, f = 50 * sine.freqHz);
				equation  
				connect (sine.y, feedback.u2);
				connect (sine.y, criticalDamping.u);
				connect (firstOrder2.y, feedback.u1);
				connect (inverseBlockConstraints.y1, firstOrder2.u);
				connect (firstOrder1.y, inverseBlockConstraints.u2);
				connect (criticalDamping.y, inverseBlockConstraints.u1);
				connect (inverseBlockConstraints.y2, firstOrder1.u);
			end InverseModel;
			  
		end Examples;
		  
		package Continuous
			import Modelica.Blocks.Interfaces;
			import Modelica.SIunits;
			extends Modelica.Icons.Library;  
			block FirstOrder
				import Modelica.Blocks.Types.Init;
				extends Modelica.Blocks.Interfaces.SISO (y.start = y_start);  
				parameter Real k=1;
				parameter Modelica.SIunits.Time T (start = 1);
				parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit;
				parameter Real y_start=0;
				initial equation  
				if initType == Init.SteadyState then
				  der(y) = 0;
				elseif initType == Init.InitialState or initType == Init.InitialOutput then
				  y = y_start;
				else
				end if;
				equation  
				der(y) = (k * u - y) / T;
			end FirstOrder;
			  
			block CriticalDamping
				import Modelica.Blocks.Types.Init;
				extends Modelica.Blocks.Interfaces.SISO;  
				parameter Integer n=2;
				parameter Modelica.SIunits.Frequency f (start = 1);
				parameter Boolean normalized=true;
				parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit;
				parameter Real x_start[n]=zeros(n);
				parameter Real y_start=0.0;
				output Real x[n] (start = x_start);
				protected
				parameter Real alpha=if normalized then sqrt(2 ^ (1 / n) - 1) else 1.0;
				parameter Real w=(2 * Modelica.Constants.pi * f) / alpha;
				initial equation  
				if initType == Init.SteadyState then
				  der(x) = zeros(n);
				elseif initType == Init.InitialState then
				  x = x_start;
				elseif initType == Init.InitialOutput then
				  y = y_start;
				  der(x[1:n - 1]) = zeros(n - 1);
				else
				end if;
				equation  
				der(x[1]) = (u - x[1]) * w;
				for i in 2:n loop
				der(x[i]) = (x[i - 1] - x[i]) * w;
				
				end for;
				y = x[n];
			end CriticalDamping;
			  
		end Continuous;
		  
		package Interfaces
			import Modelica.SIunits;
			extends Modelica.Icons.Library;  
			connector RealInput
				= input Real;  
			  
			connector RealOutput
				= output Real;  
			  
			partial block BlockIcon
			end BlockIcon;
			  
			partial block SO
				extends Modelica.Blocks.Interfaces.BlockIcon;  
				Modelica.Blocks.Interfaces.RealOutput y;
			end SO;
			  
			partial block SISO
				extends Modelica.Blocks.Interfaces.BlockIcon;  
				Modelica.Blocks.Interfaces.RealInput u;
				Modelica.Blocks.Interfaces.RealOutput y;
			end SISO;
			  
		end Interfaces;
		  
		package Math
			import Modelica.SIunits;
			import Modelica.Blocks.Interfaces;
			extends Modelica.Icons.Library;  
			block InverseBlockConstraints
				Modelica.Blocks.Interfaces.RealInput u1;
				Modelica.Blocks.Interfaces.RealInput u2;
				Modelica.Blocks.Interfaces.RealOutput y1;
				Modelica.Blocks.Interfaces.RealOutput y2;
				equation  
				u1 = u2;
				y1 = y2;
			end InverseBlockConstraints;
			  
			block Feedback
				input Modelica.Blocks.Interfaces.RealInput u1;
				input Modelica.Blocks.Interfaces.RealInput u2;
				output Modelica.Blocks.Interfaces.RealOutput y;
				equation  
				y = u1 - u2;
			end Feedback;
			  
		end Math;
		  
		package Sources
			import Modelica.Blocks.Interfaces;
			import Modelica.SIunits;
			extends Modelica.Icons.Library;  
			block Sine
				extends Modelica.Blocks.Interfaces.SO;  
				parameter Real amplitude=1;
				parameter Modelica.SIunits.Frequency freqHz (start = 1);
				parameter Modelica.SIunits.Angle phase=0;
				parameter Real offset=0;
				parameter Modelica.SIunits.Time startTime=0;
				protected
				constant Real pi=Modelica.Constants.pi;
				equation  
				y = offset + (if time < startTime then 0 else amplitude * Modelica.Math.sin(2 * pi * freqHz * (time - startTime) + phase));
			end Sine;
			  
		end Sources;
		  
		package Types
			extends Modelica.Icons.Library;  
			type Init = enumeration(
				NoInit,
				SteadyState,
				InitialState,
				InitialOutput
			);
			  
		end Types;
		  
	end Blocks;
	  
	package Math
		import SI = Modelica.SIunits;
		extends Modelica.Icons.Library2;  
		function sin
			extends Modelica.Math.baseIcon1;  
			input Modelica.SIunits.Angle u; 
			output Real y; 
			external "C" y = sin(u);
			annotation(Library="ModelicaExternalC");
		end sin;
		function asin
			extends Modelica.Math.baseIcon2;  
			input Real u; 
			output Modelica.SIunits.Angle y; 
			external "C" y = asin(u);
			annotation(Library="ModelicaExternalC");
		end asin;
		partial function baseIcon1
		end baseIcon1;
		partial function baseIcon2
		end baseIcon2;
		  
		  
		  
		  
	end Math;
	  
	package Constants
		import SI = Modelica.SIunits;
		import NonSI = Modelica.SIunits.Conversions.NonSIunits;
		extends Modelica.Icons.Library2;  
		constant Real pi=2 * Modelica.Math.asin(1.0);
	end Constants;
	  
	package Icons
		partial package Library
		end Library;
		  
		partial package Library2
		end Library2;
		  
		partial model Example
		end Example;
		  
	end Icons;
	  
	package SIunits
		extends Modelica.Icons.Library2;  
		package Conversions
			extends Modelica.Icons.Library2;  
			package NonSIunits
				extends Modelica.Icons.Library2;  
			end NonSIunits;
			  
		end Conversions;
		  
		class Angle
			= Real (quantity = "Angle", unit = "rad", displayUnit = "deg");  
		  
		class Time
			= Real (quantity = "Time", unit = "s");  
		  
		class Frequency
			= Real (quantity = "Frequency", unit = "Hz");  
		  
	end SIunits;
	  
end Modelica;
  
