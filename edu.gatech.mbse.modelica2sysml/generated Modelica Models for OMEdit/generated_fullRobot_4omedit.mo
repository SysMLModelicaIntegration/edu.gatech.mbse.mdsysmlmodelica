within ; 
package MyPackage
 
package Modelica
	extends Modelica.Icons.Package;  
	package Blocks
		import SI = Modelica.SIunits;
		extends Modelica.Icons.Package;  
		package Continuous
			import Modelica.Blocks.Interfaces;
			import Modelica.SIunits;
			extends Modelica.Icons.Package;  
			block PI
				import Modelica.Blocks.Types.Init;
				extends Modelica.Blocks.Interfaces.SISO;  
				parameter Real k (unit = "1") = 1;
				parameter Modelica.SIunits.Time T (start = 1, min = Modelica.Constants.small);
				parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit;
				parameter Real x_start = 0;
				parameter Real y_start = 0;
				output Real x (start = x_start);
				initial equation  
				if initType == Init.SteadyState then
				  der(x) = 0;
				elseif initType == Init.InitialState then
				  x = x_start;
				elseif initType == Init.InitialOutput then
				  y = y_start;
				end if;
				equation  
				der(x) = u / T;
				y = k * (x + u);
			end PI;
			  
		end Continuous;
		  
		package Interfaces
			import Modelica.SIunits;
			extends Modelica.Icons.InterfacesPackage;  
			connector RealInput
				= input Real;  
			  
			connector RealOutput
				= output Real;  
			  
			connector BooleanInput
				= input Boolean;  
			  
			connector BooleanOutput
				= output Boolean;  
			  
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
			  
			partial block BooleanBlockIcon
			end BooleanBlockIcon;
			  
		end Interfaces;
		  
		package Logical
			extends Modelica.Icons.Package;  
			block TerminateSimulation
				Modelica.Blocks.Interfaces.BooleanOutput condition = false;
				parameter String terminationText = "... End condition reached";
				equation  
				when condition then
				  terminate(terminationText);
				end when;
			end TerminateSimulation;
			  
		end Logical;
		  
		package Math
			import Modelica.SIunits;
			import Modelica.Blocks.Interfaces;
			extends Modelica.Icons.Package;  
			block Gain
				Modelica.Blocks.Interfaces.RealInput u;
				Modelica.Blocks.Interfaces.RealOutput y;
				parameter Real k (start = 1, unit = "1");
				equation  
				y = k * u;
			end Gain;
			  
			block Feedback
				input Modelica.Blocks.Interfaces.RealInput u1;
				input Modelica.Blocks.Interfaces.RealInput u2;
				output Modelica.Blocks.Interfaces.RealOutput y;
				equation  
				y = u1 - u2;
			end Feedback;
			  
			block Add3
				extends Modelica.Blocks.Interfaces.BlockIcon;  
				input Modelica.Blocks.Interfaces.RealInput u1;
				input Modelica.Blocks.Interfaces.RealInput u2;
				input Modelica.Blocks.Interfaces.RealInput u3;
				output Modelica.Blocks.Interfaces.RealOutput y;
				parameter Real k1 = +1;
				parameter Real k2 = +1;
				parameter Real k3 = +1;
				equation  
				y = k1 * u1 + k2 * u2 + k3 * u3;
			end Add3;
			  
		end Math;
		  
		package Routing
			extends Modelica.Icons.Package;  
			model RealPassThrough
				extends Modelica.Blocks.Interfaces.BlockIcon;  
				Modelica.Blocks.Interfaces.RealInput u;
				Modelica.Blocks.Interfaces.RealOutput y;
				equation  
				y = u;
			end RealPassThrough;
			  
			model BooleanPassThrough
				extends Modelica.Blocks.Interfaces.BooleanBlockIcon;  
				Modelica.Blocks.Interfaces.BooleanInput u;
				Modelica.Blocks.Interfaces.BooleanOutput y;
				equation  
				y = u;
			end BooleanPassThrough;
			  
		end Routing;
		  
		package Sources
			import Modelica.Blocks.Interfaces;
			import Modelica.SIunits;
			extends Modelica.Icons.SourcesPackage;  
			block Constant
				extends Modelica.Blocks.Interfaces.SO;  
				parameter Real k (start = 1);
				equation  
				y = k;
			end Constant;
			  
			block KinematicPTP2
				import SI = Modelica.SIunits;
				extends Modelica.Blocks.Interfaces.BlockIcon;  
				Modelica.Blocks.Interfaces.RealOutput q[nout];
				Modelica.Blocks.Interfaces.RealOutput qd[nout];
				Modelica.Blocks.Interfaces.RealOutput qdd[nout];
				Modelica.Blocks.Interfaces.BooleanOutput moving[nout];
				parameter Real q_begin[:] = {0};
				parameter Real q_end[:];
				parameter Real qd_max[:] (min = Modelica.Constants.small);
				parameter Real qdd_max[:] (min = Modelica.Constants.small);
				parameter Modelica.SIunits.Time startTime = 0;
				parameter Integer nout = max([size(q_begin, 1); size(q_end, 1); size(qd_max, 1); size(qdd_max, 1)]);
				output Modelica.SIunits.Time endTime;
				protected
				parameter Real p_q_begin[nout] = if size(q_begin, 1) == 1 then ones(nout) * q_begin[1] else q_begin;
				parameter Real p_q_end[nout] = if size(q_end, 1) == 1 then ones(nout) * q_end[1] else q_end;
				parameter Real p_qd_max[nout] = if size(qd_max, 1) == 1 then ones(nout) * qd_max[1] else qd_max;
				parameter Real p_qdd_max[nout] = if size(qdd_max, 1) == 1 then ones(nout) * qdd_max[1] else qdd_max;
				parameter Real p_deltaq[nout] = p_q_end - p_q_begin;
				constant Real eps = 10 * Modelica.Constants.eps;
				Boolean motion_ref;
				Real sd_max_inv;
				Real sdd_max_inv;
				Real sd_max;
				Real sdd_max;
				Real sdd;
				Real aux1[nout];
				Real aux2[nout];
				Modelica.SIunits.Time Ta1;
				Modelica.SIunits.Time Ta2;
				Modelica.SIunits.Time Tv;
				Modelica.SIunits.Time Te;
				Boolean noWphase;
				Modelica.SIunits.Time Ta1s;
				Modelica.SIunits.Time Ta2s;
				Modelica.SIunits.Time Tvs;
				Modelica.SIunits.Time Tes;
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
					input Real q_qd_qdd[3]; 
					input Real dummy; 
					output Real q; 
					algorithm 
					q := q_qd_qdd[1];
				end position;
				function position_der
					input Real q_qd_qdd[3]; 
					input Real dummy; 
					input Real dummy_der; 
					output Real qd; 
					algorithm 
					qd := q_qd_qdd[2];
				end position_der;
				function position_der2
					input Real q_qd_qdd[3]; 
					input Real dummy; 
					input Real dummy_der; 
					input Real dummy_der2; 
					output Real qdd; 
					algorithm 
					qdd := q_qd_qdd[3];
				end position_der2;
				equation  
				for i in 1:nout loop
				  aux1[i] = p_deltaq[i] / p_qd_max[i];
				  aux2[i] = p_deltaq[i] / p_qdd_max[i];
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
				  sd_max = 1 / max(abs(aux1));
				  sdd_max = 1 / max(abs(aux2));
				  Ta1 = sqrt(1 / sdd_max);
				  Ta2 = sd_max / sdd_max;
				  noWphase = Ta2 >= Ta1;
				  Tv = if noWphase then Ta1 else 1 / sd_max;
				  Te = if noWphase then Ta1 + Ta1 else Tv + Ta2;
				  Ta1s = Ta1 + startTime;
				  Ta2s = Ta2 + startTime;
				  Tvs = Tv + startTime;
				  Tes = Te + startTime;
				  sd_max2 = sdd_max * Ta1;
				  s1 = sdd_max * (if noWphase then Ta1 * Ta1 else Ta2 * Ta2) / 2;
				  s2 = s1 + (if noWphase then sd_max2 * (Te - Ta1) - sdd_max / 2 * (Te - Ta1) ^ 2 else sd_max * (Tv - Ta2));
				  s3 = s2 + sd_max * (Te - Tv) - sdd_max / 2 * (Te - Tv) * (Te - Tv);
				  if time < startTime then
				    r_sdd = 0;
				    r_sd = 0;
				    r_s = 0;
				  elseif noWphase then
				    if time < Ta1s then
				      r_sdd = sdd_max;
				      r_sd = sdd_max * (time - startTime);
				      r_s = sdd_max / 2 * (time - startTime) * (time - startTime);
				    elseif time < Tes then
				      r_sdd = -sdd_max;
				      r_sd = sd_max2 - sdd_max * (time - Ta1s);
				      r_s = s1 + sd_max2 * (time - Ta1s) - sdd_max / 2 * (time - Ta1s) * (time - Ta1s);
				    else
				      r_sdd = 0;
				      r_sd = 0;
				      r_s = s2;
				    end if;
				  elseif time < Ta2s then
				    r_sdd = sdd_max;
				    r_sd = sdd_max * (time - startTime);
				    r_s = sdd_max / 2 * (time - startTime) * (time - startTime);
				  elseif time < Tvs then
				    r_sdd = 0;
				    r_sd = sd_max;
				    r_s = s1 + sd_max * (time - Ta2s);
				  elseif time < Tes then
				    r_sdd = -sdd_max;
				    r_sd = sd_max - sdd_max * (time - Tvs);
				    r_s = s2 + sd_max * (time - Tvs) - sdd_max / 2 * (time - Tvs) * (time - Tvs);
				  else
				    r_sdd = 0;
				    r_sd = 0;
				    r_s = s3;
				  end if;
				end if;
				qdd = p_deltaq * sdd;
				qd = p_deltaq * sd;
				q = p_q_begin + p_deltaq * s;
				endTime = Tes;
				s = position({r_s, r_sd, r_sdd}, time);
				sd = der(s);
				sdd = der(sd);
				  
				  
				  
			end KinematicPTP2;
			  
		end Sources;
		  
		package Types
			extends Modelica.Icons.Package;  
			type Init = enumeration(
				NoInit,
				SteadyState,
				InitialState,
				InitialOutput
			);
			  
		end Types;
		  
	end Blocks;
	  
	package Electrical
		extends Modelica.Icons.Package;  
		package Analog
			import SI = Modelica.SIunits;
			extends Modelica.Icons.Package;  
			package Basic
				extends Modelica.Icons.Package;  
				model Ground
					Modelica.Electrical.Analog.Interfaces.Pin p;
					equation  
					p.v = 0;
				end Ground;
				  
				model Resistor
					extends Modelica.Electrical.Analog.Interfaces.OnePort;  
					extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort (T = T_ref);  
					parameter Modelica.SIunits.Resistance R (start = 1);
					parameter Modelica.SIunits.Temperature T_ref = 300.15;
					parameter Modelica.SIunits.LinearTemperatureCoefficient alpha = 0;
					Modelica.SIunits.Resistance R_actual;
					equation  
					assert(1 + alpha * (T_heatPort - T_ref) >= Modelica.Constants.eps, "Temperature outside scope of model!");
					R_actual = R * (1 + alpha * (T_heatPort - T_ref));
					v = R_actual * i;
					LossPower = v * i;
				end Resistor;
				  
				model Capacitor
					extends Modelica.Electrical.Analog.Interfaces.OnePort;  
					parameter Modelica.SIunits.Capacitance C (start = 1);
					equation  
					i = C * der(v);
				end Capacitor;
				  
				model Inductor
					extends Modelica.Electrical.Analog.Interfaces.OnePort;  
					parameter Modelica.SIunits.Inductance L (start = 1);
					equation  
					L * der(i) = v;
				end Inductor;
				  
				model EMF
					Modelica.Electrical.Analog.Interfaces.PositivePin p;
					Modelica.Electrical.Analog.Interfaces.NegativePin n;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
					Modelica.Mechanics.Rotational.Interfaces.Support support if useSupport;
					parameter Boolean useSupport = false;
					parameter Modelica.SIunits.ElectricalTorqueConstant k (start = 1);
					Modelica.SIunits.Voltage v;
					Modelica.SIunits.Current i;
					Modelica.SIunits.Angle phi;
					Modelica.SIunits.AngularVelocity w;
					protected
					Modelica.Mechanics.Rotational.Components.Fixed fixed if not useSupport;
					Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalSupport (tau = -flange.tau);
					equation  
					v = p.v - n.v;
					0 = p.i + n.i;
					i = p.i;
					phi = flange.phi - internalSupport.phi;
					w = der(phi);
					k * w = v;
					flange.tau = -k * i;
					connect (internalSupport.flange, fixed.flange);
					connect (internalSupport.flange, support);
				end EMF;
				  
			end Basic;
			  
			package Ideal
				extends Modelica.Icons.Package;  
				model IdealOpAmp
					Modelica.Electrical.Analog.Interfaces.PositivePin p1;
					Modelica.Electrical.Analog.Interfaces.NegativePin n1;
					Modelica.Electrical.Analog.Interfaces.PositivePin p2;
					Modelica.Electrical.Analog.Interfaces.NegativePin n2;
					Modelica.SIunits.Voltage v1;
					Modelica.SIunits.Voltage v2;
					Modelica.SIunits.Current i1;
					Modelica.SIunits.Current i2;
					equation  
					v1 = p1.v - n1.v;
					v2 = p2.v - n2.v;
					0 = p1.i + n1.i;
					0 = p2.i + n2.i;
					i1 = p1.i;
					i2 = p2.i;
					v1 = 0;
					i1 = 0;
				end IdealOpAmp;
				  
			end Ideal;
			  
			package Interfaces
				extends Modelica.Icons.InterfacesPackage;  
				connector Pin
					Modelica.SIunits.Voltage v;
					flow Modelica.SIunits.Current i;
				end Pin;
				  
				connector PositivePin
					Modelica.SIunits.Voltage v;
					flow Modelica.SIunits.Current i;
				end PositivePin;
				  
				connector NegativePin
					Modelica.SIunits.Voltage v;
					flow Modelica.SIunits.Current i;
				end NegativePin;
				  
				partial model OnePort
					Modelica.Electrical.Analog.Interfaces.PositivePin p;
					Modelica.Electrical.Analog.Interfaces.NegativePin n;
					Modelica.SIunits.Voltage v;
					Modelica.SIunits.Current i;
					equation  
					v = p.v - n.v;
					0 = p.i + n.i;
					i = p.i;
				end OnePort;
				  
				partial model ConditionalHeatPort
					Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort (T(start = T) = T_heatPort, Q_flow = -LossPower) if useHeatPort;
					parameter Boolean useHeatPort = false;
					parameter Modelica.SIunits.Temperature T = 293.15;
					Modelica.SIunits.Power LossPower;
					Modelica.SIunits.Temperature T_heatPort;
					equation  
					if not useHeatPort then
					  T_heatPort = T;
					end if;
				end ConditionalHeatPort;
				  
			end Interfaces;
			  
			package Sensors
				extends Modelica.Icons.SensorsPackage;  
				model CurrentSensor
					extends Modelica.Icons.RotationalSensor;  
					Modelica.Electrical.Analog.Interfaces.PositivePin p;
					Modelica.Electrical.Analog.Interfaces.NegativePin n;
					Modelica.Blocks.Interfaces.RealOutput i;
					equation  
					p.v = n.v;
					p.i = i;
					n.i = -i;
				end CurrentSensor;
				  
			end Sensors;
			  
			package Sources
				extends Modelica.Icons.SourcesPackage;  
				model SignalVoltage
					Modelica.Electrical.Analog.Interfaces.PositivePin p;
					Modelica.Electrical.Analog.Interfaces.NegativePin n;
					Modelica.Blocks.Interfaces.RealInput v;
					Modelica.SIunits.Current i;
					equation  
					v = p.v - n.v;
					0 = p.i + n.i;
					i = p.i;
				end SignalVoltage;
				  
			end Sources;
			  
		end Analog;
		  
	end Electrical;
	  
	package Mechanics
		extends Modelica.Icons.Package;  
		package MultiBody
			import SI = Modelica.SIunits;
			extends Modelica.Icons.Package;  
			model World
				import SI = Modelica.SIunits;
				import Modelica.Mechanics.MultiBody.Types.GravityTypes;
				import Modelica.Mechanics.MultiBody.Types;
				Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b;
				parameter Boolean enableAnimation = true;
				parameter Boolean animateWorld = true;
				parameter Boolean animateGravity = true;
				parameter Modelica.Mechanics.MultiBody.Types.AxisLabel label1 = "x";
				parameter Modelica.Mechanics.MultiBody.Types.AxisLabel label2 = "y";
				parameter Modelica.Mechanics.MultiBody.Types.GravityTypes gravityType = GravityTypes.UniformGravity;
				parameter Modelica.SIunits.Acceleration g = 9.81;
				parameter Modelica.Mechanics.MultiBody.Types.Axis n = {0, -1, 0};
				parameter Real mue (unit = "m3/s2", min = 0) = 3.986e14;
				parameter Boolean driveTrainMechanics3D = true;
				parameter Modelica.SIunits.Distance axisLength = nominalLength / 2;
				parameter Modelica.SIunits.Distance axisDiameter = axisLength / defaultFrameDiameterFraction;
				parameter Boolean axisShowLabels = true;
				input Modelica.Mechanics.MultiBody.Types.Color axisColor_x = Modelica.Mechanics.MultiBody.Types.Defaults.FrameColor;
				input Modelica.Mechanics.MultiBody.Types.Color axisColor_y = axisColor_x;
				input Modelica.Mechanics.MultiBody.Types.Color axisColor_z = axisColor_x;
				parameter Modelica.SIunits.Position gravityArrowTail[3] = {0, 0, 0};
				parameter Modelica.SIunits.Length gravityArrowLength = axisLength / 2;
				parameter Modelica.SIunits.Diameter gravityArrowDiameter = gravityArrowLength / defaultWidthFraction;
				input Modelica.Mechanics.MultiBody.Types.Color gravityArrowColor = {0, 230, 0};
				parameter Modelica.SIunits.Diameter gravitySphereDiameter = 12742000;
				input Modelica.Mechanics.MultiBody.Types.Color gravitySphereColor = {0, 230, 0};
				parameter Modelica.SIunits.Length nominalLength = 1;
				parameter Modelica.SIunits.Length defaultAxisLength = nominalLength / 5;
				parameter Modelica.SIunits.Length defaultJointLength = nominalLength / 10;
				parameter Modelica.SIunits.Length defaultJointWidth = nominalLength / 20;
				parameter Modelica.SIunits.Length defaultForceLength = nominalLength / 10;
				parameter Modelica.SIunits.Length defaultForceWidth = nominalLength / 20;
				parameter Modelica.SIunits.Length defaultBodyDiameter = nominalLength / 9;
				parameter Real defaultWidthFraction = 20;
				parameter Modelica.SIunits.Length defaultArrowDiameter = nominalLength / 40;
				parameter Real defaultFrameDiameterFraction = 40;
				parameter Real defaultSpecularCoefficient (min = 0) = 0.7;
				parameter Real defaultN_to_m (unit = "N/m", min = 0) = 1000;
				parameter Real defaultNm_to_m (unit = "N.m/m", min = 0) = 1000;
				protected
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape x_arrowLine (shapeType = "cylinder", length = lineLength, width = lineWidth, height = lineWidth, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, color = axisColor_x, specularCoefficient = 0) if enableAnimation and animateWorld;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape x_arrowHead (shapeType = "cone", length = headLength, width = headWidth, height = headWidth, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, color = axisColor_x, r = {lineLength, 0, 0}, specularCoefficient = 0) if enableAnimation and animateWorld;
				Modelica.Mechanics.MultiBody.Visualizers.Internal.Lines x_label (lines = scaledLabel * {[0, 0; 1, 1], [0, 1; 1, 0]}, diameter = axisDiameter, color = axisColor_x, r_lines = {labelStart, 0, 0}, n_x = {1, 0, 0}, n_y = {0, 1, 0}, specularCoefficient = 0) if enableAnimation and animateWorld and axisShowLabels;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape y_arrowLine (shapeType = "cylinder", length = lineLength, width = lineWidth, height = lineWidth, lengthDirection = {0, 1, 0}, widthDirection = {1, 0, 0}, color = axisColor_y, specularCoefficient = 0) if enableAnimation and animateWorld;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape y_arrowHead (shapeType = "cone", length = headLength, width = headWidth, height = headWidth, lengthDirection = {0, 1, 0}, widthDirection = {1, 0, 0}, color = axisColor_y, r = {0, lineLength, 0}, specularCoefficient = 0) if enableAnimation and animateWorld;
				Modelica.Mechanics.MultiBody.Visualizers.Internal.Lines y_label (lines = scaledLabel * {[0, 0; 1, 1.5], [0, 1.5; 0.5, 0.75]}, diameter = axisDiameter, color = axisColor_y, r_lines = {0, labelStart, 0}, n_x = {0, 1, 0}, n_y = {-1, 0, 0}, specularCoefficient = 0) if enableAnimation and animateWorld and axisShowLabels;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape z_arrowLine (shapeType = "cylinder", length = lineLength, width = lineWidth, height = lineWidth, lengthDirection = {0, 0, 1}, widthDirection = {0, 1, 0}, color = axisColor_z, specularCoefficient = 0) if enableAnimation and animateWorld;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape z_arrowHead (shapeType = "cone", length = headLength, width = headWidth, height = headWidth, lengthDirection = {0, 0, 1}, widthDirection = {0, 1, 0}, color = axisColor_z, r = {0, 0, lineLength}, specularCoefficient = 0) if enableAnimation and animateWorld;
				Modelica.Mechanics.MultiBody.Visualizers.Internal.Lines z_label (lines = scaledLabel * {[0, 0; 1, 0], [0, 1; 1, 1], [0, 1; 1, 0]}, diameter = axisDiameter, color = axisColor_z, r_lines = {0, 0, labelStart}, n_x = {0, 0, 1}, n_y = {0, 1, 0}, specularCoefficient = 0) if enableAnimation and animateWorld and axisShowLabels;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape gravityArrowLine (shapeType = "cylinder", length = gravityLineLength, width = gravityArrowDiameter, height = gravityArrowDiameter, lengthDirection = n, widthDirection = {0, 1, 0}, color = gravityArrowColor, r_shape = gravityArrowTail, specularCoefficient = 0) if enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape gravityArrowHead (shapeType = "cone", length = gravityHeadLength, width = gravityHeadWidth, height = gravityHeadWidth, lengthDirection = n, widthDirection = {0, 1, 0}, color = gravityArrowColor, r_shape = gravityArrowTail + Modelica.Math.Vectors.normalize(n) * gravityLineLength, specularCoefficient = 0) if enableAnimation and animateGravity and gravityType == GravityTypes.UniformGravity;
				Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape gravitySphere (shapeType = "sphere", r_shape = {-gravitySphereDiameter / 2, 0, 0}, lengthDirection = {1, 0, 0}, length = gravitySphereDiameter, width = gravitySphereDiameter, height = gravitySphereDiameter, color = gravitySphereColor, specularCoefficient = 0) if enableAnimation and animateGravity and gravityType == GravityTypes.PointGravity;
				parameter Integer ndim = if enableAnimation and animateWorld then 1 else 0;
				parameter Integer ndim2 = if enableAnimation and animateWorld and axisShowLabels then 1 else 0;
				parameter Modelica.SIunits.Length headLength = min(axisLength, axisDiameter * Types.Defaults.FrameHeadLengthFraction);
				parameter Modelica.SIunits.Length headWidth = axisDiameter * Types.Defaults.FrameHeadWidthFraction;
				parameter Modelica.SIunits.Length lineLength = max(0, axisLength - headLength);
				parameter Modelica.SIunits.Length lineWidth = axisDiameter;
				parameter Modelica.SIunits.Length scaledLabel = Modelica.Mechanics.MultiBody.Types.Defaults.FrameLabelHeightFraction * axisDiameter;
				parameter Modelica.SIunits.Length labelStart = 1.05 * axisLength;
				parameter Modelica.SIunits.Length gravityHeadLength = min(gravityArrowLength, gravityArrowDiameter * Types.Defaults.ArrowHeadLengthFraction);
				parameter Modelica.SIunits.Length gravityHeadWidth = gravityArrowDiameter * Types.Defaults.ArrowHeadWidthFraction;
				parameter Modelica.SIunits.Length gravityLineLength = max(0, gravityArrowLength - gravityHeadLength);
				parameter Integer ndim_pointGravity = if enableAnimation and animateGravity and gravityType == 2 then 1 else 0;
				replaceable function gravityAcceleration
					= Modelica.Mechanics.MultiBody.Forces.Internal.standardGravityAcceleration (gravityType = gravityType, g = g * Modelica.Math.Vectors.normalize(n, 0.0), mue = mue);  
				equation  
				Connections.root(frame_b.R);
				assert(Modelica.Math.Vectors.length(n) > 1.e-10, "Parameter n of World object is wrong (lenght(n) > 0 required)");
				frame_b.r_0 = zeros(3);
				frame_b.R = Frames.nullRotation();
				  
			end World;
			  
			package Examples
				extends Modelica.Icons.ExamplesPackage;  
				package Systems
					extends Modelica.Icons.ExamplesPackage;  
					package RobotR3
						import SI = Modelica.SIunits;
						extends Modelica.Icons.ExamplesPackage;  
						model fullRobot
							import SI = Modelica.SIunits;
							extends Modelica.Icons.Example;  
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.MechanicalStructure mechanics (mLoad = mLoad, rLoad = rLoad, g = g);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathPlanning6 pathPlanning (naxis = 6, angleBegDeg = {startAngle1, startAngle2, startAngle3, startAngle4, startAngle5, startAngle6}, angleEndDeg = {endAngle1, endAngle2, endAngle3, endAngle4, endAngle5, endAngle6}, speedMax = refSpeedMax, accMax = refAccMax, startTime = refStartTime, swingTime = refSwingTime);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType1 axis1 (w = 4590, ratio = -105, c = 43, cd = 0.005, Rv0 = 0.4, Rv1 = 0.13 / 160, kp = kp1, ks = ks1, Ts = Ts1);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType1 axis2 (w = 5500, ratio = 210, c = 8, cd = 0.01, Rv1 = 0.1 / 130, Rv0 = 0.5, kp = kp2, ks = ks2, Ts = Ts2);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType1 axis3 (w = 5500, ratio = 60, c = 58, cd = 0.04, Rv0 = 0.7, Rv1 = 0.2 / 130, kp = kp3, ks = ks3, Ts = Ts3);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType2 axis4 (k = 0.2365, w = 6250, D = 0.55, J = 1.6e-4, ratio = -99, Rv0 = 21.8, Rv1 = 9.8, peak = 26.7 / 21.8, kp = kp4, ks = ks4, Ts = Ts4);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType2 axis5 (k = 0.2608, w = 6250, D = 0.55, J = 1.8e-4, ratio = 79.2, Rv0 = 30.1, Rv1 = 0.03, peak = 39.6 / 30.1, kp = kp5, ks = ks5, Ts = Ts5);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType2 axis6 (k = 0.0842, w = 7400, D = 0.27, J = 4.3e-5, ratio = -99, Rv0 = 10.9, Rv1 = 3.92, peak = 16.8 / 10.9, kp = kp6, ks = ks6, Ts = Ts6);
							Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.ControlBus controlBus;
							parameter Modelica.SIunits.Mass mLoad (min = 0) = 15;
							parameter Modelica.SIunits.Position rLoad[3] = {0.1, 0.25, 0.1};
							parameter Modelica.SIunits.Acceleration g = 9.81;
							parameter Modelica.SIunits.Time refStartTime = 0;
							parameter Modelica.SIunits.Time refSwingTime = 0.5;
							parameter Real startAngle1 (unit = "deg") = -60;
							parameter Real startAngle2 (unit = "deg") = 20;
							parameter Real startAngle3 (unit = "deg") = 90;
							parameter Real startAngle4 (unit = "deg") = 0;
							parameter Real startAngle5 (unit = "deg") = -110;
							parameter Real startAngle6 (unit = "deg") = 0;
							parameter Real endAngle1 (unit = "deg") = 60;
							parameter Real endAngle2 (unit = "deg") = -70;
							parameter Real endAngle3 (unit = "deg") = -35;
							parameter Real endAngle4 (unit = "deg") = 45;
							parameter Real endAngle5 (unit = "deg") = 110;
							parameter Real endAngle6 (unit = "deg") = 45;
							parameter Modelica.SIunits.AngularVelocity refSpeedMax[6] = {3, 1.5, 5, 3.1, 3.1, 4.1};
							parameter Modelica.SIunits.AngularAcceleration refAccMax[6] = {15, 15, 15, 60, 60, 60};
							parameter Real kp1 = 5;
							parameter Real ks1 = 0.5;
							parameter Modelica.SIunits.Time Ts1 = 0.05;
							parameter Real kp2 = 5;
							parameter Real ks2 = 0.5;
							parameter Modelica.SIunits.Time Ts2 = 0.05;
							parameter Real kp3 = 5;
							parameter Real ks3 = 0.5;
							parameter Modelica.SIunits.Time Ts3 = 0.05;
							parameter Real kp4 = 5;
							parameter Real ks4 = 0.5;
							parameter Modelica.SIunits.Time Ts4 = 0.05;
							parameter Real kp5 = 5;
							parameter Real ks5 = 0.5;
							parameter Modelica.SIunits.Time Ts5 = 0.05;
							parameter Real kp6 = 5;
							parameter Real ks6 = 0.5;
							parameter Modelica.SIunits.Time Ts6 = 0.05;
							equation  
							connect (axis5.flange, mechanics.axis5);
							connect (controlBus.axisControlBus6, axis6.axisControlBus);
							connect (controlBus, pathPlanning.controlBus);
							connect (axis3.flange, mechanics.axis3);
							connect (axis4.flange, mechanics.axis4);
							connect (controlBus.axisControlBus5, axis5.axisControlBus);
							connect (controlBus.axisControlBus1, axis1.axisControlBus);
							connect (axis2.flange, mechanics.axis2);
							connect (controlBus.axisControlBus2, axis2.axisControlBus);
							connect (controlBus.axisControlBus3, axis3.axisControlBus);
							connect (controlBus.axisControlBus4, axis4.axisControlBus);
							connect (axis1.flange, mechanics.axis1);
							connect (axis6.flange, mechanics.axis6);
						end fullRobot;
						  
						package Components
							extends Modelica.Icons.Package;  
							expandable connector AxisControlBus
								import SI = Modelica.SIunits;
								extends Modelica.Icons.SignalSubBus;  
								Boolean motion_ref;
								Modelica.SIunits.Angle angle_ref;
								Modelica.SIunits.Angle angle;
								Modelica.SIunits.AngularVelocity speed_ref;
								Modelica.SIunits.AngularVelocity speed;
								Modelica.SIunits.AngularAcceleration acceleration_ref;
								Modelica.SIunits.AngularAcceleration acceleration;
								Modelica.SIunits.Current current_ref;
								Modelica.SIunits.Current current;
								Modelica.SIunits.Angle motorAngle;
								Modelica.SIunits.AngularVelocity motorSpeed;
							end AxisControlBus;
							  
							expandable connector ControlBus
								extends Modelica.Icons.SignalBus;  
							end ControlBus;
							  
							model PathPlanning6
								import SI = Modelica.SIunits;
								import Cv = Modelica.SIunits.Conversions;
								Modelica.Blocks.Sources.KinematicPTP2 path (q_end = angleEnd, qd_max = speedMax, qdd_max = accMax, startTime = startTime, q_begin = angleBeg);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathToAxisControlBus pathToAxis1 (nAxis = naxis, axisUsed = 1);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathToAxisControlBus pathToAxis2 (nAxis = naxis, axisUsed = 2);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathToAxisControlBus pathToAxis3 (nAxis = naxis, axisUsed = 3);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathToAxisControlBus pathToAxis4 (nAxis = naxis, axisUsed = 4);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathToAxisControlBus pathToAxis5 (nAxis = naxis, axisUsed = 5);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.PathToAxisControlBus pathToAxis6 (nAxis = naxis, axisUsed = 6);
								Modelica.Blocks.Logical.TerminateSimulation terminateSimulation (condition = time >= path.endTime + swingTime);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.ControlBus controlBus;
								parameter Integer naxis = 6;
								parameter Real angleBegDeg[naxis] (unit = "deg") = zeros(naxis);
								parameter Real angleEndDeg[naxis] (unit = "deg") = ones(naxis);
								parameter Modelica.SIunits.AngularVelocity speedMax[naxis] = fill(3, naxis);
								parameter Modelica.SIunits.AngularAcceleration accMax[naxis] = fill(2.5, naxis);
								parameter Modelica.SIunits.Time startTime = 0;
								parameter Modelica.SIunits.Time swingTime = 0.5;
								parameter Modelica.SIunits.Angle angleBeg[:] = Cv.from_deg(angleBegDeg);
								parameter Modelica.SIunits.Angle angleEnd[:] = Cv.from_deg(angleEndDeg);
								equation  
								connect (path.moving, pathToAxis1.moving);
								connect (path.moving, pathToAxis6.moving);
								connect (path.qdd, pathToAxis4.qdd);
								connect (pathToAxis3.axisControlBus, controlBus.axisControlBus3);
								connect (path.qdd, pathToAxis3.qdd);
								connect (path.qd, pathToAxis5.qd);
								connect (path.qd, pathToAxis3.qd);
								connect (path.moving, pathToAxis3.moving);
								connect (path.q, pathToAxis4.q);
								connect (path.q, pathToAxis3.q);
								connect (path.qd, pathToAxis4.qd);
								connect (path.q, pathToAxis5.q);
								connect (path.q, pathToAxis1.q);
								connect (path.qdd, pathToAxis5.qdd);
								connect (path.q, pathToAxis6.q);
								connect (pathToAxis1.axisControlBus, controlBus.axisControlBus1);
								connect (path.qd, pathToAxis6.qd);
								connect (pathToAxis2.axisControlBus, controlBus.axisControlBus2);
								connect (path.qdd, pathToAxis6.qdd);
								connect (path.qd, pathToAxis1.qd);
								connect (pathToAxis5.axisControlBus, controlBus.axisControlBus5);
								connect (path.moving, pathToAxis5.moving);
								connect (path.qd, pathToAxis2.qd);
								connect (pathToAxis4.axisControlBus, controlBus.axisControlBus4);
								connect (path.moving, pathToAxis2.moving);
								connect (path.qdd, pathToAxis2.qdd);
								connect (path.moving, pathToAxis4.moving);
								connect (path.qdd, pathToAxis1.qdd);
								connect (path.q, pathToAxis2.q);
								connect (pathToAxis6.axisControlBus, controlBus.axisControlBus6);
							end PathPlanning6;
							  
							model PathToAxisControlBus
								extends Modelica.Blocks.Interfaces.BlockIcon;  
								Modelica.Blocks.Routing.RealPassThrough q_axisUsed;
								Modelica.Blocks.Routing.RealPassThrough qd_axisUsed;
								Modelica.Blocks.Routing.RealPassThrough qdd_axisUsed;
								Modelica.Blocks.Routing.BooleanPassThrough motion_ref_axisUsed;
								Modelica.Blocks.Interfaces.RealInput q[nAxis];
								Modelica.Blocks.Interfaces.RealInput qd[nAxis];
								Modelica.Blocks.Interfaces.RealInput qdd[nAxis];
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus axisControlBus;
								Modelica.Blocks.Interfaces.BooleanInput moving[nAxis];
								parameter Integer nAxis = 6;
								parameter Integer axisUsed = 1;
								equation  
								connect(q_axisUsed.u, q[axisUsed]);
								connect(qd_axisUsed.u, qd[axisUsed]);
								connect(qdd_axisUsed.u, qdd[axisUsed]);
								connect(motion_ref_axisUsed.u, moving[axisUsed]);
								connect (qd_axisUsed.y, axisControlBus.speed_ref);
								connect (motion_ref_axisUsed.y, axisControlBus.motion_ref);
								connect (qdd_axisUsed.y, axisControlBus.acceleration_ref);
								connect (q_axisUsed.y, axisControlBus.angle_ref);
							end PathToAxisControlBus;
							  
							model GearType1
								extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;  
								Modelica.Mechanics.Rotational.Components.IdealGear gear (ratio = i, useSupport = false);
								Modelica.Mechanics.Rotational.Components.SpringDamper spring (c = c, d = d);
								Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction (tau_pos = [0, Rv0 / unitTorque; 1, (Rv0 + Rv1 * unitAngularVelocity) / unitTorque], useSupport = false);
								parameter Real i = -105;
								parameter Real c (unit = "N.m/rad") = 43;
								parameter Real d (unit = "N.m.s/rad") = 0.005;
								parameter Modelica.SIunits.Torque Rv0 = 0.4;
								parameter Real Rv1 (unit = "N.m.s/rad") = 0.13 / 160;
								parameter Real peak = 1;
								Modelica.SIunits.AngularAcceleration a_rel = der(spring.w_rel);
								constant Modelica.SIunits.AngularVelocity unitAngularVelocity = 1;
								constant Modelica.SIunits.Torque unitTorque = 1;
								initial equation  
								spring.w_rel = 0;
								a_rel = 0;
								equation  
								connect (bearingFriction.flange_b, spring.flange_a);
								connect (spring.flange_b, gear.flange_a);
								connect (gear.flange_b, flange_b);
								connect (bearingFriction.flange_a, flange_a);
							end GearType1;
							  
							model GearType2
								extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;  
								Modelica.Mechanics.Rotational.Components.IdealGear gear (ratio = i, useSupport = false);
								Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction (tau_pos = [0, Rv0 / unitTorque; 1, (Rv0 + Rv1 * unitAngularVelocity) / unitTorque], peak = peak, useSupport = false);
								parameter Real i = -99;
								parameter Modelica.SIunits.Torque Rv0 = 21.8;
								parameter Real Rv1 = 9.8;
								parameter Real peak = 26.7 / 21.8;
								constant Modelica.SIunits.AngularVelocity unitAngularVelocity = 1;
								constant Modelica.SIunits.Torque unitTorque = 1;
								equation  
								connect (gear.flange_b, bearingFriction.flange_a);
								connect (bearingFriction.flange_b, flange_b);
								connect (gear.flange_a, flange_a);
							end GearType2;
							  
							model Motor
								extends Modelica.Icons.MotorIcon;  
								Modelica.Electrical.Analog.Sources.SignalVoltage Vs;
								Modelica.Electrical.Analog.Ideal.IdealOpAmp diff;
								Modelica.Electrical.Analog.Ideal.IdealOpAmp power;
								Modelica.Electrical.Analog.Basic.EMF emf (k = k, useSupport = false);
								Modelica.Electrical.Analog.Basic.Inductor La (L = 250 / (2 * D * w));
								Modelica.Electrical.Analog.Basic.Resistor Ra (R = 250);
								Modelica.Electrical.Analog.Basic.Resistor Rd2 (R = 100);
								Modelica.Electrical.Analog.Basic.Capacitor C (C = 0.004 * D / w);
								Modelica.Electrical.Analog.Ideal.IdealOpAmp OpI;
								Modelica.Electrical.Analog.Basic.Resistor Rd1 (R = 100);
								Modelica.Electrical.Analog.Basic.Resistor Ri (R = 10);
								Modelica.Electrical.Analog.Basic.Resistor Rp1 (R = 200);
								Modelica.Electrical.Analog.Basic.Resistor Rp2 (R = 50);
								Modelica.Electrical.Analog.Basic.Resistor Rd4 (R = 100);
								Modelica.Electrical.Analog.Sources.SignalVoltage hall2;
								Modelica.Electrical.Analog.Basic.Resistor Rd3 (R = 100);
								Modelica.Electrical.Analog.Basic.Ground g1;
								Modelica.Electrical.Analog.Basic.Ground g2;
								Modelica.Electrical.Analog.Basic.Ground g3;
								Modelica.Electrical.Analog.Sensors.CurrentSensor hall1;
								Modelica.Electrical.Analog.Basic.Ground g4;
								Modelica.Electrical.Analog.Basic.Ground g5;
								Modelica.Mechanics.Rotational.Sensors.AngleSensor phi;
								Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed;
								Modelica.Mechanics.Rotational.Components.Inertia Jmotor (J = J);
								Modelica.Blocks.Math.Gain convert1 (k = 1);
								Modelica.Blocks.Math.Gain convert2 (k = 1);
								Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_motor;
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus axisControlBus;
								parameter Modelica.SIunits.Inertia J (min = 0) = 0.0013;
								parameter Real k = 1.1616;
								parameter Real w = 4590;
								parameter Real D = 0.6;
								parameter Modelica.SIunits.AngularVelocity w_max = 315;
								parameter Modelica.SIunits.Current i_max = 9;
								initial equation  
								// initialize motor in steady state
								der(C.v) = 0;
								der(La.i) = 0;
								equation  
								connect (Rd2.n, diff.n1);
								connect (C.n, OpI.p2);
								connect (emf.n, hall1.p);
								connect (convert2.y, Vs.v);
								connect (Vs.n, g1.p);
								connect (g5.p, Rp2.n);
								connect (Ri.n, OpI.n1);
								connect (Rd4.n, g3.p);
								connect (phi.phi, axisControlBus.motorAngle);
								connect (OpI.n2, power.n2);
								connect (power.p2, Ra.p);
								connect (hall1.n, g4.p);
								connect (Rd3.n, diff.p1);
								connect (Jmotor.flange_b, flange_motor);
								connect (hall1.i, axisControlBus.current);
								connect (Rd3.p, hall2.p);
								connect (speed.w, axisControlBus.motorSpeed);
								connect (emf.flange, phi.flange);
								connect (g2.p, hall2.n);
								connect (emf.flange, Jmotor.flange_a);
								connect (convert2.u, axisControlBus.current_ref);
								connect (Ra.n, La.p);
								connect (diff.p2, Ri.p);
								connect (La.n, emf.p);
								connect (Vs.p, Rd2.p);
								connect (OpI.p2, power.p1);
								connect (g3.p, OpI.p1);
								connect (power.p2, Rp1.n);
								connect (Rd3.n, Rd4.p);
								connect (OpI.p1, diff.n2);
								connect (diff.n1, Rd1.p);
								connect (power.n1, Rp1.p);
								connect (Rd1.n, diff.p2);
								connect (OpI.n1, C.p);
								connect (Rp1.p, Rp2.p);
								connect (hall1.i, convert1.u);
								connect (emf.flange, speed.flange);
								connect (OpI.p1, OpI.n2);
								connect (convert1.y, hall2.v);
							end Motor;
							  
							model Controller
								Modelica.Blocks.Math.Gain gain1 (k = ratio);
								Modelica.Blocks.Continuous.PI PI (k = ks, T = Ts);
								Modelica.Blocks.Math.Feedback feedback1;
								Modelica.Blocks.Math.Gain P (k = kp);
								Modelica.Blocks.Math.Add3 add3 (k3 = -1);
								Modelica.Blocks.Math.Gain gain2 (k = ratio);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus axisControlBus;
								parameter Real kp = 10;
								parameter Real ks = 1;
								parameter Modelica.SIunits.Time Ts = 0.01;
								parameter Real ratio = 1;
								equation  
								connect (PI.y, axisControlBus.current_ref);
								connect (add3.u3, axisControlBus.motorSpeed);
								connect (P.y, add3.u2);
								connect (gain2.u, axisControlBus.speed_ref);
								connect (gain2.y, add3.u1);
								connect (feedback1.u2, axisControlBus.motorAngle);
								connect (gain1.u, axisControlBus.angle_ref);
								connect (add3.y, PI.u);
								connect (gain1.y, feedback1.u1);
								connect (feedback1.y, P.u);
							end Controller;
							  
							model AxisType1
								extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisType2;  
								parameter Real c (unit = "N.m/rad") = 43;
								parameter Real cd (unit = "N.m.s/rad") = 0.005;
							end AxisType1;
							  
							model AxisType2
								replaceable Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.GearType2 gear (Rv0 = Rv0, Rv1 = Rv1, peak = peak, i = ratio);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.Motor motor (J = J, k = k, w = w, D = D);
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.Controller controller (kp = kp, ks = ks, Ts = Ts, ratio = ratio);
								Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor;
								Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor;
								Modelica.Mechanics.Rotational.Sensors.AccSensor accSensor;
								Modelica.Mechanics.Rotational.Components.InitializeFlange initializeFlange (stateSelect = StateSelect.prefer);
								Modelica.Blocks.Sources.Constant const (k = 0);
								Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
								Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.Components.AxisControlBus axisControlBus;
								parameter Real kp = 10;
								parameter Real ks = 1;
								parameter Modelica.SIunits.Time Ts = 0.01;
								parameter Real k = 1.1616;
								parameter Real w = 4590;
								parameter Real D = 0.6;
								parameter Modelica.SIunits.Inertia J (min = 0) = 0.0013;
								parameter Real ratio = -105;
								parameter Modelica.SIunits.Torque Rv0 = 0.4;
								parameter Real Rv1 (unit = "N.m.s/rad") = 0.13 / 160;
								parameter Real peak = 1;
								equation  
								connect (initializeFlange.flange, flange);
								connect (motor.flange_motor, gear.flange_a);
								connect (gear.flange_b, angleSensor.flange);
								connect (const.y, initializeFlange.a_start);
								connect (motor.axisControlBus, axisControlBus);
								connect (axisControlBus.speed_ref, initializeFlange.w_start);
								connect (controller.axisControlBus, axisControlBus);
								connect (speedSensor.w, axisControlBus.speed);
								connect (angleSensor.phi, axisControlBus.angle);
								connect (gear.flange_b, accSensor.flange);
								connect (gear.flange_b, speedSensor.flange);
								connect (accSensor.a, axisControlBus.acceleration);
								connect (gear.flange_b, flange);
								connect (axisControlBus.angle_ref, initializeFlange.phi_start);
							end AxisType2;
							  
							model MechanicalStructure
								inner Modelica.Mechanics.MultiBody.World world (g = g * Modelica.Math.Vectors.length({0, -1, 0}), n = {0, -1, 0}, animateWorld = false, animateGravity = false, enableAnimation = animation);
								Modelica.Mechanics.MultiBody.Joints.Revolute r1 (n = {0, 1, 0}, useAxisFlange = true, animation = animation);
								Modelica.Mechanics.MultiBody.Joints.Revolute r2 (n = {1, 0, 0}, useAxisFlange = true, animation = animation);
								Modelica.Mechanics.MultiBody.Joints.Revolute r3 (n = {1, 0, 0}, useAxisFlange = true, animation = animation);
								Modelica.Mechanics.MultiBody.Joints.Revolute r4 (n = {0, 1, 0}, useAxisFlange = true, animation = animation);
								Modelica.Mechanics.MultiBody.Joints.Revolute r5 (n = {1, 0, 0}, useAxisFlange = true, animation = animation);
								Modelica.Mechanics.MultiBody.Joints.Revolute r6 (n = {0, 1, 0}, useAxisFlange = true, animation = animation);
								Modelica.Mechanics.MultiBody.Parts.BodyShape b0 (r = {0, 0.351, 0}, shapeType = "0", r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = 0.225, width = 0.3, height = 0.3, color = {0, 0, 255}, animation = animation, animateSphere = false, r_CM = {0, 0, 0}, m = 1);
								Modelica.Mechanics.MultiBody.Parts.BodyShape b1 (r = {0, 0.324, 0.3}, I_22 = 1.16, shapeType = "1", lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = 0.25, width = 0.15, height = 0.2, animation = animation, animateSphere = false, color = {255, 0, 0}, r_CM = {0, 0, 0}, m = 1);
								Modelica.Mechanics.MultiBody.Parts.BodyShape b2 (r = {0, 0.65, 0}, r_CM = {0.172, 0.205, 0}, m = 56.5, I_11 = 2.58, I_22 = 0.64, I_33 = 2.73, I_21 = -0.46, shapeType = "2", r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = 0.5, width = 0.2, height = 0.15, animation = animation, animateSphere = false, color = {255, 178, 0});
								Modelica.Mechanics.MultiBody.Parts.BodyShape b3 (r = {0, 0.414, -0.155}, r_CM = {0.064, -0.034, 0}, m = 26.4, I_11 = 0.279, I_22 = 0.245, I_33 = 0.413, I_21 = -0.070, shapeType = "3", r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = 0.15, width = 0.15, height = 0.15, animation = animation, animateSphere = false, color = {255, 0, 0});
								Modelica.Mechanics.MultiBody.Parts.BodyShape b4 (r = {0, 0.186, 0}, r_CM = {0, 0, 0}, m = 28.7, I_11 = 1.67, I_22 = 0.081, I_33 = 1.67, shapeType = "4", r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = 0.73, width = 0.1, height = 0.1, animation = animation, animateSphere = false, color = {255, 178, 0});
								Modelica.Mechanics.MultiBody.Parts.BodyShape b5 (r = {0, 0.125, 0}, r_CM = {0, 0, 0}, m = 5.2, I_11 = 1.25, I_22 = 0.81, I_33 = 1.53, shapeType = "5", r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = 0.225, width = 0.075, height = 0.1, animation = animation, animateSphere = false, color = {0, 0, 255});
								Modelica.Mechanics.MultiBody.Parts.BodyShape b6 (r = {0, 0, 0}, r_CM = {0.05, 0.05, 0.05}, m = 0.5, shapeType = "6", r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, animation = animation, animateSphere = false, color = {0, 0, 255});
								Modelica.Mechanics.MultiBody.Parts.BodyShape load (r_CM = rLoad, m = mLoad, r_shape = {0, 0, 0}, widthDirection = {1, 0, 0}, width = 0.05, height = 0.05, color = {255, 0, 0}, lengthDirection = rLoad, length = Modelica.Math.Vectors.length(rLoad), animation = animation);
								Modelica.Mechanics.Rotational.Interfaces.Flange_a axis1;
								Modelica.Mechanics.Rotational.Interfaces.Flange_a axis2;
								Modelica.Mechanics.Rotational.Interfaces.Flange_a axis3;
								Modelica.Mechanics.Rotational.Interfaces.Flange_a axis4;
								Modelica.Mechanics.Rotational.Interfaces.Flange_a axis5;
								Modelica.Mechanics.Rotational.Interfaces.Flange_a axis6;
								parameter Boolean animation = true;
								parameter Modelica.SIunits.Mass mLoad (min = 0) = 15;
								parameter Modelica.SIunits.Position rLoad[3] = {0, 0.25, 0};
								parameter Modelica.SIunits.Acceleration g = 9.81;
								Modelica.SIunits.Angle q[6];
								Modelica.SIunits.AngularVelocity qd[6];
								Modelica.SIunits.AngularAcceleration qdd[6];
								Modelica.SIunits.Torque tau[6];
								equation  
								q = {r1.phi, r2.phi, r3.phi, r4.phi, r5.phi, r6.phi};
								qd = der(q);
								qdd = der(qd);
								tau = {r1.axis.tau, r2.axis.tau, r3.axis.tau, r4.axis.tau, r5.axis.tau, r6.axis.tau};
								connect (r5.axis, axis5);
								connect (r2.frame_b, b2.frame_a);
								connect (load.frame_a, b6.frame_b);
								connect (b3.frame_b, r4.frame_a);
								connect (r1.axis, axis1);
								connect (r5.frame_b, b5.frame_a);
								connect (r4.axis, axis4);
								connect (b5.frame_b, r6.frame_a);
								connect (b1.frame_b, r2.frame_a);
								connect (r3.axis, axis3);
								connect (world.frame_b, b0.frame_a);
								connect (r1.frame_b, b1.frame_a);
								connect (r6.axis, axis6);
								connect (r2.axis, axis2);
								connect (b0.frame_b, r1.frame_a);
								connect (r6.frame_b, b6.frame_a);
								connect (b2.frame_b, r3.frame_a);
								connect (b4.frame_b, r5.frame_a);
								connect (r4.frame_b, b4.frame_a);
								connect (r3.frame_b, b3.frame_a);
							end MechanicalStructure;
							  
						end Components;
						  
					end RobotR3;
					  
				end Systems;
				  
			end Examples;
			  
			package Forces
				import SI = Modelica.SIunits;
				extends Modelica.Icons.SourcesPackage;  
				package Internal
					extends Modelica.Icons.Package;  
					function standardGravityAcceleration
						import Modelica.Mechanics.MultiBody.Types.GravityTypes;
						extends Modelica.Mechanics.MultiBody.Interfaces.partialGravityAcceleration;  
						input Modelica.Mechanics.MultiBody.Types.GravityTypes gravityType; 
						input Modelica.SIunits.Acceleration g[3]; 
						input Real mue (unit = "m3/s2"); 
						algorithm 
						gravity := if gravityType == GravityTypes.UniformGravity then g else if gravityType == GravityTypes.PointGravity then -mue / (r * r) * (r / Modelica.Math.Vectors.length(r)) else zeros(3);
					end standardGravityAcceleration;
					  
				end Internal;
				  
			end Forces;
			  
			package Frames
				extends Modelica.Icons.Package;  
				function angularVelocity2
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					output Modelica.SIunits.AngularVelocity w[3]; 
					algorithm 
					w := R.w;
				end angularVelocity2;
				function resolve1
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					input Real v2[3]; 
					output Real v1[3]; 
					algorithm 
					v1 := transpose(R.T) * v2;
				end resolve1;
				function resolve2
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					input Real v1[3]; 
					output Real v2[3]; 
					algorithm 
					v2 := R.T * v1;
				end resolve2;
				function nullRotation
					extends Modelica.Icons.Function;  
					output Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					algorithm 
					R := Orientation(T = identity(3), w = zeros(3));
				end nullRotation;
				function absoluteRotation
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Orientation R1; 
					input Modelica.Mechanics.MultiBody.Frames.Orientation R_rel; 
					output Modelica.Mechanics.MultiBody.Frames.Orientation R2; 
					algorithm 
					R2 := Orientation(T = R_rel.T * R1.T, w = resolve2(R_rel, R1.w) + R_rel.w);
				end absoluteRotation;
				function planarRotation
					import Modelica.Math;
					extends Modelica.Icons.Function;  
					input Real e[3] (unit = "1"); 
					input Modelica.SIunits.Angle angle; 
					input Modelica.SIunits.AngularVelocity der_angle; 
					output Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					algorithm 
					R := Orientation(T = [e] * transpose([e]) + (identity(3) - [e] * transpose([e])) * Math.cos(angle) - skew(e) * Math.sin(angle), w = e * der_angle);
				end planarRotation;
				function planarRotationAngle
					extends Modelica.Icons.Function;  
					input Real e[3] (unit = "1"); 
					input Real v1[3]; 
					input Real v2[3]; 
					output Modelica.SIunits.Angle angle; 
					algorithm 
					
				end planarRotationAngle;
				function axesRotations
					import TM = Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
					extends Modelica.Icons.Function;  
					input Integer sequence[3] (min = {1, 1, 1}, max = {3, 3, 3}) = {1, 2, 3}; 
					input Modelica.SIunits.Angle angles[3]; 
					input Modelica.SIunits.AngularVelocity der_angles[3]; 
					output Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					algorithm 
					
				end axesRotations;
				function axesRotationsAngles
					import SI = Modelica.SIunits;
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					input Integer sequence[3] (min = {1, 1, 1}, max = {3, 3, 3}) = {1, 2, 3}; 
					input Modelica.SIunits.Angle guessAngle1 = 0; 
					output Modelica.SIunits.Angle angles[3]; 
					protected
					Real e1_1[3] (unit = "1"); 
					Real e2_1a[3] (unit = "1"); 
					Real e3_1[3] (unit = "1"); 
					Real e3_2[3] (unit = "1"); 
					Real A; 
					Real B; 
					Modelica.SIunits.Angle angle_1a; 
					Modelica.SIunits.Angle angle_1b; 
					Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T_1a; 
					algorithm 
					
					assert(sequence[1] <> sequence[2] and sequence[2] <> sequence[3], "input argument 'sequence[1:3]' is not valid");
					e1_1 := if sequence[1] == 1 then {1, 0, 0} else if sequence[1] == 2 then {0, 1, 0} else {0, 0, 1};
					e2_1a := if sequence[2] == 1 then {1, 0, 0} else if sequence[2] == 2 then {0, 1, 0} else {0, 0, 1};
					e3_1 := R.T[sequence[3], :];
					e3_2 := if sequence[3] == 1 then {1, 0, 0} else if sequence[3] == 2 then {0, 1, 0} else {0, 0, 1};
					A := e2_1a * e3_1;
					B := cross(e1_1, e2_1a) * e3_1;
					if abs(A) <= 1.e-12 and abs(B) <= 1.e-12 then
					  angles[1] := guessAngle1;
					else
					  angle_1a := Modelica.Math.atan2(A, -B);
					  angle_1b := Modelica.Math.atan2(-A, B);
					  angles[1] := if abs(angle_1a - guessAngle1) <= abs(angle_1b - guessAngle1) then angle_1a else angle_1b;
					end if;
					T_1a := TransformationMatrices.planarRotation(e1_1, angles[1]);
					angles[2] := planarRotationAngle(e2_1a, TransformationMatrices.resolve2(T_1a, e3_1), e3_2);
				end axesRotationsAngles;
				function from_Q
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q; 
					input Modelica.SIunits.AngularVelocity w[3]; 
					output Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					algorithm 
					
				end from_Q;
				function to_Q
					extends Modelica.Icons.Function;  
					input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
					input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q_guess = Quaternions.nullRotation(); 
					output Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q; 
					algorithm 
					Q := Quaternions.from_T(R.T, Q_guess);
				end to_Q;
				function axis
					extends Modelica.Icons.Function;  
					input Integer axis (min = 1, max = 3); 
					output Real e[3] (unit = "1"); 
					algorithm 
					e := if axis == 1 then {1, 0, 0} else if axis == 2 then {0, 1, 0} else {0, 0, 1};
				end axis;
				  
				  
				  
				  
				  
				  
				  
				  
				  
				  
				  
				  
				record Orientation
					import SI = Modelica.SIunits;
					extends Modelica.Icons.Record;  
					Real T[3,3];
					Modelica.SIunits.AngularVelocity w[3];
					  
					encapsulated function equalityConstraint
						import Modelica;
						import Modelica.Mechanics.MultiBody.Frames;
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.Orientation R1; 
						input Modelica.Mechanics.MultiBody.Frames.Orientation R2; 
						output Real residue[3]; 
						algorithm 
						residue := {Modelica.Math.atan2(cross(R1.T[1, :], R1.T[2, :]) * R2.T[2, :], R1.T[1, :] * R2.T[1, :]), Modelica.Math.atan2(-cross(R1.T[1, :], R1.T[2, :]) * R2.T[1, :], R1.T[2, :] * R2.T[2, :]), Modelica.Math.atan2(R1.T[2, :] * R2.T[1, :], R1.T[3, :] * R2.T[3, :])};
					end equalityConstraint;
				end Orientation;
				  
				package Quaternions
					extends Modelica.Icons.Package;  
					function orientationConstraint
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q; 
						output Real residue[1]; 
						algorithm 
						residue := {Q * Q - 1};
					end orientationConstraint;
					function angularVelocity2
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q; 
						input Modelica.Mechanics.MultiBody.Frames.Quaternions.der_Orientation der_Q; 
						output Modelica.SIunits.AngularVelocity w[3]; 
						algorithm 
						w := 2 * ([Q[4], Q[3], -Q[2], -Q[1]; -Q[3], Q[4], Q[1], -Q[2]; Q[2], -Q[1], Q[4], -Q[3]] * der_Q);
					end angularVelocity2;
					function nullRotation
						extends Modelica.Icons.Function;  
						output Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q; 
						algorithm 
						Q := {0, 0, 0, 1};
					end nullRotation;
					function from_T
						extends Modelica.Icons.Function;  
						input Real T[3,3]; 
						input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q_guess = nullRotation(); 
						output Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q; 
						protected
						Real paux; 
						Real paux4; 
						Real c1; 
						Real c2; 
						Real c3; 
						Real c4; 
						Real p4limit = 0.1; 
						Real c4limit = 4 * p4limit * p4limit; 
						algorithm 
						
						c1 := 1 + T[1, 1] - T[2, 2] - T[3, 3];
						c2 := 1 + T[2, 2] - T[1, 1] - T[3, 3];
						c3 := 1 + T[3, 3] - T[1, 1] - T[2, 2];
						c4 := 1 + T[1, 1] + T[2, 2] + T[3, 3];
						if c4 > c4limit or c4 > c1 and c4 > c2 and c4 > c3 then
						  paux := sqrt(c4) / 2;
						  paux4 := 4 * paux;
						  Q := {(T[2, 3] - T[3, 2]) / paux4, (T[3, 1] - T[1, 3]) / paux4, (T[1, 2] - T[2, 1]) / paux4, paux};
						elseif c1 > c2 and c1 > c3 and c1 > c4 then
						  paux := sqrt(c1) / 2;
						  paux4 := 4 * paux;
						  Q := {paux, (T[1, 2] + T[2, 1]) / paux4, (T[1, 3] + T[3, 1]) / paux4, (T[2, 3] - T[3, 2]) / paux4};
						elseif c2 > c1 and c2 > c3 and c2 > c4 then
						  paux := sqrt(c2) / 2;
						  paux4 := 4 * paux;
						  Q := {(T[1, 2] + T[2, 1]) / paux4, paux, (T[2, 3] + T[3, 2]) / paux4, (T[3, 1] - T[1, 3]) / paux4};
						else
						  paux := sqrt(c3) / 2;
						  paux4 := 4 * paux;
						  Q := {(T[1, 3] + T[3, 1]) / paux4, (T[2, 3] + T[3, 2]) / paux4, paux, (T[1, 2] - T[2, 1]) / paux4};
						end if;
					end from_T;
					  
					  
					  
					  
					type Orientation
						extends Modelica.Mechanics.MultiBody.Frames.Internal.QuaternionBase;  
						  
						encapsulated function equalityConstraint
							import Modelica;
							import Modelica.Mechanics.MultiBody.Frames.Quaternions;
							extends Modelica.Icons.Function;  
							input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q1; 
							input Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q2; 
							output Real residue[3]; 
							algorithm 
							residue := [Q1[4], Q1[3], -Q1[2], -Q1[1]; -Q1[3], Q1[4], Q1[1], -Q1[2]; Q1[2], -Q1[1], Q1[4], -Q1[3]] * Q2;
						end equalityConstraint;
					end Orientation;
					  
					type der_Orientation
						= Real[4] (unit = "1/s");  
					  
				end Quaternions;
				  
				package TransformationMatrices
					extends Modelica.Icons.Package;  
					function resolve1
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T; 
						input Real v2[3]; 
						output Real v1[3]; 
						algorithm 
						v1 := transpose(T) * v2;
					end resolve1;
					function resolve2
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T; 
						input Real v1[3]; 
						output Real v2[3]; 
						algorithm 
						v2 := T * v1;
					end resolve2;
					function absoluteRotation
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T1; 
						input Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T_rel; 
						output Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T2; 
						algorithm 
						T2 := T_rel * T1;
					end absoluteRotation;
					function planarRotation
						import Modelica.Math;
						extends Modelica.Icons.Function;  
						input Real e[3] (unit = "1"); 
						input Modelica.SIunits.Angle angle; 
						output Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T; 
						algorithm 
						T := [e] * transpose([e]) + (identity(3) - [e] * transpose([e])) * Math.cos(angle) - skew(e) * Math.sin(angle);
					end planarRotation;
					function axisRotation
						import Modelica.Math.*;
						extends Modelica.Icons.Function;  
						input Integer axis (min = 1, max = 3); 
						input Modelica.SIunits.Angle angle; 
						output Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T; 
						algorithm 
						T := if axis == 1 then [1, 0, 0; 0, cos(angle), sin(angle); 0, -sin(angle), cos(angle)] else if axis == 2 then [cos(angle), 0, -sin(angle); 0, 1, 0; sin(angle), 0, cos(angle)] else [cos(angle), sin(angle), 0; -sin(angle), cos(angle), 0; 0, 0, 1];
					end axisRotation;
					function from_nxy
						extends Modelica.Icons.Function;  
						input Real n_x[3] (unit = "1"); 
						input Real n_y[3] (unit = "1"); 
						output Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T; 
						protected
						Real abs_n_x = sqrt(n_x * n_x); 
						Real e_x[3] (unit = "1") = if abs_n_x < 1.e-10 then {1, 0, 0} else n_x / abs_n_x; 
						Real n_z_aux[3] (unit = "1") = cross(e_x, n_y); 
						Real n_y_aux[3] (unit = "1") = if n_z_aux * n_z_aux > 1.0e-6 then n_y else if abs(e_x[1]) > 1.0e-6 then {0, 1, 0} else {1, 0, 0}; 
						Real e_z_aux[3] (unit = "1") = cross(e_x, n_y_aux); 
						Real e_z[3] (unit = "1") = e_z_aux / sqrt(e_z_aux * e_z_aux); 
						algorithm 
						T := {e_x, cross(e_z, e_x), e_z};
					end from_nxy;
					  
					  
					  
					  
					  
					  
					type Orientation
						extends Modelica.Mechanics.MultiBody.Frames.Internal.TransformationMatrix;  
						  
						encapsulated function equalityConstraint
							import Modelica;
							import Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
							extends Modelica.Icons.Function;  
							input Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T1; 
							input Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation T2; 
							output Real residue[3]; 
							algorithm 
							residue := {cross(T1[1, :], T1[2, :]) * T2[2, :], -cross(T1[1, :], T1[2, :]) * T2[1, :], T1[2, :] * T2[1, :]};
						end equalityConstraint;
					end Orientation;
					  
				end TransformationMatrices;
				  
				package Internal
					extends Modelica.Icons.Package;  
					function resolve1_der
						import Modelica.Mechanics.MultiBody.Frames;
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
						input Real v2[3]; 
						input Real v2_der[3]; 
						output Real v1_der[3]; 
						algorithm 
						v1_der := Frames.resolve1(R, v2_der + cross(R.w, v2));
					end resolve1_der;
					function resolve2_der
						import Modelica.Mechanics.MultiBody.Frames;
						extends Modelica.Icons.Function;  
						input Modelica.Mechanics.MultiBody.Frames.Orientation R; 
						input Real v1[3]; 
						input Real v1_der[3]; 
						output Real v2_der[3]; 
						algorithm 
						v2_der := Frames.resolve2(R, v1_der) - cross(R.w, Frames.resolve2(R, v1));
					end resolve2_der;
					  
					  
					type TransformationMatrix
						= Real[3,3];  
					  
					type QuaternionBase
						= Real[4];  
					  
				end Internal;
				  
			end Frames;
			  
			package Interfaces
				extends Modelica.Icons.InterfacesPackage;  
				partial function partialGravityAcceleration
					input Modelica.SIunits.Position r[3]; 
					output Modelica.SIunits.Acceleration gravity[3]; 
				end partialGravityAcceleration;
				partial function partialSurfaceCharacteristic
					input Integer nu; 
					input Integer nv; 
					input Boolean multiColoredSurface = false; 
					output Modelica.SIunits.Position X[nu,nv]; 
					output Modelica.SIunits.Position Y[nu,nv]; 
					output Modelica.SIunits.Position Z[nu,nv]; 
					output Real C[if multiColoredSurface then nu else 0,if multiColoredSurface then nv else 0,3]; 
				end partialSurfaceCharacteristic;
				  
				  
				connector Frame
					import SI = Modelica.SIunits;
					Modelica.SIunits.Position r_0[3];
					Modelica.Mechanics.MultiBody.Frames.Orientation R;
					flow Modelica.SIunits.Force f[3];
					flow Modelica.SIunits.Torque t[3];
				end Frame;
				  
				connector Frame_a
					extends Modelica.Mechanics.MultiBody.Interfaces.Frame;  
				end Frame_a;
				  
				connector Frame_b
					extends Modelica.Mechanics.MultiBody.Interfaces.Frame;  
				end Frame_b;
				  
			end Interfaces;
			  
			package Joints
				import SI = Modelica.SIunits;
				extends Modelica.Icons.Package;  
				model Revolute
					import SI = Modelica.SIunits;
					Modelica.Mechanics.Rotational.Interfaces.Flange_a axis;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b support if useAxisFlange;
					Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a;
					Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b;
					parameter Boolean useAxisFlange = false;
					parameter Boolean animation = true;
					parameter Modelica.Mechanics.MultiBody.Types.Axis n = {0, 0, 1};
					constant Modelica.SIunits.Angle phi_offset = 0;
					parameter Modelica.SIunits.Distance cylinderLength = world.defaultJointLength;
					parameter Modelica.SIunits.Distance cylinderDiameter = world.defaultJointWidth;
					input Modelica.Mechanics.MultiBody.Types.Color cylinderColor = Modelica.Mechanics.MultiBody.Types.Defaults.JointColor;
					input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient;
					parameter StateSelect stateSelect = StateSelect.prefer;
					Modelica.SIunits.Angle phi (start = 0, stateSelect = stateSelect);
					Modelica.SIunits.AngularVelocity w (start = 0, stateSelect = stateSelect);
					Modelica.SIunits.AngularAcceleration a (start = 0);
					Modelica.SIunits.Torque tau;
					Modelica.SIunits.Angle angle;
					protected
					outer Modelica.Mechanics.MultiBody.World world;
					Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape cylinder (shapeType = "cylinder", color = cylinderColor, specularCoefficient = specularCoefficient, length = cylinderLength, width = cylinderDiameter, height = cylinderDiameter, lengthDirection = e, widthDirection = {0, 1, 0}, r_shape = -e * (cylinderLength / 2), r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
					Modelica.Mechanics.Rotational.Components.Fixed fixed;
					Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalAxis (tau = tau);
					Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque (tau_constant = 0) if not useAxisFlange;
					parameter Real e[3] (unit = "1") = Modelica.Math.Vectors.normalize(n, 0.0);
					Modelica.Mechanics.MultiBody.Frames.Orientation R_rel;
					equation  
					Connections.branch(frame_a.R, frame_b.R);
					assert(cardinality(frame_a) > 0, "Connector frame_a of revolute joint is not connected");
					assert(cardinality(frame_b) > 0, "Connector frame_b of revolute joint is not connected");
					angle = phi_offset + phi;
					w = der(phi);
					a = der(w);
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
					tau = -frame_b.t * e;
					phi = internalAxis.phi;
					connect (fixed.flange, support);
					connect (internalAxis.flange, axis);
					connect (constantTorque.flange, internalAxis.flange);
				end Revolute;
				  
			end Joints;
			  
			package Parts
				import SI = Modelica.SIunits;
				extends Modelica.Icons.Package;  
				model FixedTranslation
					import SI = Modelica.SIunits;
					import Modelica.Mechanics.MultiBody.Types;
					Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a;
					Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b;
					parameter Boolean animation = true;
					parameter Modelica.SIunits.Position r[3] (start = {0, 0, 0});
					parameter Modelica.Mechanics.MultiBody.Types.ShapeType shapeType = "cylinder";
					parameter Modelica.SIunits.Position r_shape[3] = {0, 0, 0};
					parameter Modelica.Mechanics.MultiBody.Types.Axis lengthDirection = r - r_shape;
					parameter Modelica.Mechanics.MultiBody.Types.Axis widthDirection = {0, 1, 0};
					parameter Modelica.SIunits.Length length = Modelica.Math.Vectors.length(r - r_shape);
					parameter Modelica.SIunits.Distance width = length / world.defaultWidthFraction;
					parameter Modelica.SIunits.Distance height = width;
					parameter Modelica.Mechanics.MultiBody.Types.ShapeExtra extra = 0.0;
					input Modelica.Mechanics.MultiBody.Types.Color color = Modelica.Mechanics.MultiBody.Types.Defaults.RodColor;
					input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient;
					protected
					outer Modelica.Mechanics.MultiBody.World world;
					Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape (shapeType = shapeType, color = color, specularCoefficient = specularCoefficient, r_shape = r_shape, lengthDirection = lengthDirection, widthDirection = widthDirection, length = length, width = width, height = height, extra = extra, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
					equation  
					Connections.branch(frame_a.R, frame_b.R);
					assert(cardinality(frame_a) > 0 or cardinality(frame_b) > 0, "Neither connector frame_a nor frame_b of FixedTranslation object is connected");
					frame_b.r_0 = frame_a.r_0 + Frames.resolve1(frame_a.R, r);
					frame_b.R = frame_a.R;
					zeros(3) = frame_a.f + frame_b.f;
				end FixedTranslation;
				  
				model Body
					import SI = Modelica.SIunits;
					import C = Modelica.Constants;
					import Modelica.Math.*;
					import Modelica.Mechanics.MultiBody.Types;
					import Modelica.Mechanics.MultiBody.Frames;
					Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a;
					parameter Boolean animation = true;
					parameter Modelica.SIunits.Position r_CM[3] (start = {0, 0, 0});
					parameter Modelica.SIunits.Mass m (min = 0, start = 1);
					parameter Modelica.SIunits.Inertia I_11 (min = 0) = 0.001;
					parameter Modelica.SIunits.Inertia I_22 (min = 0) = 0.001;
					parameter Modelica.SIunits.Inertia I_33 (min = 0) = 0.001;
					parameter Modelica.SIunits.Inertia I_21 (min = -C.inf) = 0;
					parameter Modelica.SIunits.Inertia I_31 (min = -C.inf) = 0;
					parameter Modelica.SIunits.Inertia I_32 (min = -C.inf) = 0;
					Modelica.SIunits.Position r_0[3] (start = {0, 0, 0}, stateSelect = if enforceStates then StateSelect.always else StateSelect.avoid);
					Modelica.SIunits.Velocity v_0[3] (start = {0, 0, 0}, stateSelect = if enforceStates then StateSelect.always else StateSelect.avoid);
					Modelica.SIunits.Acceleration a_0[3] (start = {0, 0, 0});
					parameter Boolean angles_fixed = false;
					parameter Modelica.SIunits.Angle angles_start[3] = {0, 0, 0};
					parameter Modelica.Mechanics.MultiBody.Types.RotationSequence sequence_start = {1, 2, 3};
					parameter Boolean w_0_fixed = false;
					parameter Modelica.SIunits.AngularVelocity w_0_start[3] = {0, 0, 0};
					parameter Boolean z_0_fixed = false;
					parameter Modelica.SIunits.AngularAcceleration z_0_start[3] = {0, 0, 0};
					parameter Modelica.SIunits.Diameter sphereDiameter = world.defaultBodyDiameter;
					input Modelica.Mechanics.MultiBody.Types.Color sphereColor = Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor;
					parameter Modelica.SIunits.Diameter cylinderDiameter = sphereDiameter / Types.Defaults.BodyCylinderDiameterFraction;
					input Modelica.Mechanics.MultiBody.Types.Color cylinderColor = sphereColor;
					input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient;
					parameter Boolean enforceStates = false;
					parameter Boolean useQuaternions = true;
					parameter Modelica.Mechanics.MultiBody.Types.RotationSequence sequence_angleStates = {1, 2, 3};
					parameter Modelica.SIunits.Inertia I[3,3] = [I_11, I_21, I_31; I_21, I_22, I_32; I_31, I_32, I_33];
					parameter Modelica.Mechanics.MultiBody.Frames.Orientation R_start = Modelica.Mechanics.MultiBody.Frames.axesRotations(sequence_start, angles_start, zeros(3));
					parameter Modelica.SIunits.AngularAcceleration z_a_start[3] = Frames.resolve2(R_start, z_0_start);
					Modelica.SIunits.AngularVelocity w_a[3] (start = Frames.resolve2(R_start, w_0_start), fixed = fill(w_0_fixed, 3), stateSelect = if enforceStates then if useQuaternions then StateSelect.always else StateSelect.never else StateSelect.avoid);
					Modelica.SIunits.AngularAcceleration z_a[3] (start = Frames.resolve2(R_start, z_0_start), fixed = fill(z_0_fixed, 3));
					Modelica.SIunits.Acceleration g_0[3];
					protected
					outer Modelica.Mechanics.MultiBody.World world;
					Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape cylinder (shapeType = "cylinder", color = cylinderColor, specularCoefficient = specularCoefficient, length = if Modelica.Math.Vectors.length(r_CM) > sphereDiameter / 2 then Modelica.Math.Vectors.length(r_CM) - (if cylinderDiameter > 1.1 * sphereDiameter then sphereDiameter / 2 else 0) else 0, width = cylinderDiameter, height = cylinderDiameter, lengthDirection = r_CM, widthDirection = {0, 1, 0}, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
					Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape sphere (shapeType = "sphere", color = sphereColor, specularCoefficient = specularCoefficient, length = sphereDiameter, width = sphereDiameter, height = sphereDiameter, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, r_shape = r_CM - {1, 0, 0} * sphereDiameter / 2, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation and sphereDiameter > 0;
					parameter Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q_start = Frames.to_Q(R_start);
					Modelica.Mechanics.MultiBody.Frames.Quaternions.Orientation Q (start = Q_start, stateSelect = if enforceStates then if useQuaternions then StateSelect.prefer else StateSelect.never else StateSelect.avoid);
					parameter Modelica.SIunits.Angle phi_start[3] = if sequence_start[1] == sequence_angleStates[1] and sequence_start[2] == sequence_angleStates[2] and sequence_start[3] == sequence_angleStates[3] then angles_start else Frames.axesRotationsAngles(R_start, sequence_angleStates);
					Modelica.SIunits.Angle phi[3] (start = phi_start, stateSelect = if enforceStates then if useQuaternions then StateSelect.never else StateSelect.always else StateSelect.avoid);
					Modelica.SIunits.AngularVelocity phi_d[3] (stateSelect = if enforceStates then if useQuaternions then StateSelect.never else StateSelect.always else StateSelect.avoid);
					Modelica.SIunits.AngularAcceleration phi_dd[3];
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
					  Q = {0, 0, 0, 1};
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
					  Q = {0, 0, 0, 1};
					end if;
					g_0 = world.gravityAcceleration(frame_a.r_0 + Frames.resolve1(frame_a.R, r_CM));
					v_0 = der(frame_a.r_0);
					a_0 = der(v_0);
					w_a = Frames.angularVelocity2(frame_a.R);
				end Body;
				  
				model BodyShape
					import SI = Modelica.SIunits;
					import C = Modelica.Constants;
					import Modelica.Mechanics.MultiBody.Types;
					Modelica.Mechanics.MultiBody.Parts.FixedTranslation frameTranslation (r = r, animation = false);
					Modelica.Mechanics.MultiBody.Parts.Body body (r_CM = r_CM, m = m, I_11 = I_11, I_22 = I_22, I_33 = I_33, I_21 = I_21, I_31 = I_31, I_32 = I_32, animation = false, sequence_start = sequence_start, angles_fixed = angles_fixed, angles_start = angles_start, w_0_fixed = w_0_fixed, w_0_start = w_0_start, z_0_fixed = z_0_fixed, z_0_start = z_0_start, useQuaternions = useQuaternions, sequence_angleStates = sequence_angleStates, enforceStates = false);
					Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a;
					Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b;
					parameter Boolean animation = true;
					parameter Boolean animateSphere = true;
					parameter Modelica.SIunits.Position r[3] (start = {0, 0, 0});
					parameter Modelica.SIunits.Position r_CM[3] (start = {0, 0, 0});
					parameter Modelica.SIunits.Mass m (min = 0, start = 1);
					parameter Modelica.SIunits.Inertia I_11 (min = 0) = 0.001;
					parameter Modelica.SIunits.Inertia I_22 (min = 0) = 0.001;
					parameter Modelica.SIunits.Inertia I_33 (min = 0) = 0.001;
					parameter Modelica.SIunits.Inertia I_21 (min = -C.inf) = 0;
					parameter Modelica.SIunits.Inertia I_31 (min = -C.inf) = 0;
					parameter Modelica.SIunits.Inertia I_32 (min = -C.inf) = 0;
					Modelica.SIunits.Position r_0[3] (start = {0, 0, 0}, stateSelect = if enforceStates then StateSelect.always else StateSelect.avoid);
					Modelica.SIunits.Velocity v_0[3] (start = {0, 0, 0}, stateSelect = if enforceStates then StateSelect.always else StateSelect.avoid);
					Modelica.SIunits.Acceleration a_0[3] (start = {0, 0, 0});
					parameter Boolean angles_fixed = false;
					parameter Modelica.SIunits.Angle angles_start[3] = {0, 0, 0};
					parameter Modelica.Mechanics.MultiBody.Types.RotationSequence sequence_start = {1, 2, 3};
					parameter Boolean w_0_fixed = false;
					parameter Modelica.SIunits.AngularVelocity w_0_start[3] = {0, 0, 0};
					parameter Boolean z_0_fixed = false;
					parameter Modelica.SIunits.AngularAcceleration z_0_start[3] = {0, 0, 0};
					parameter Modelica.Mechanics.MultiBody.Types.ShapeType shapeType = "cylinder";
					parameter Modelica.SIunits.Position r_shape[3] = {0, 0, 0};
					parameter Modelica.Mechanics.MultiBody.Types.Axis lengthDirection = r - r_shape;
					parameter Modelica.Mechanics.MultiBody.Types.Axis widthDirection = {0, 1, 0};
					parameter Modelica.SIunits.Length length = Modelica.Math.Vectors.length(r - r_shape);
					parameter Modelica.SIunits.Distance width = length / world.defaultWidthFraction;
					parameter Modelica.SIunits.Distance height = width;
					parameter Modelica.Mechanics.MultiBody.Types.ShapeExtra extra = 0.0;
					input Modelica.Mechanics.MultiBody.Types.Color color = Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor;
					parameter Modelica.SIunits.Diameter sphereDiameter = 2 * width;
					input Modelica.Mechanics.MultiBody.Types.Color sphereColor = color;
					input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient;
					parameter Boolean enforceStates = false;
					parameter Boolean useQuaternions = true;
					parameter Modelica.Mechanics.MultiBody.Types.RotationSequence sequence_angleStates = {1, 2, 3};
					protected
					outer Modelica.Mechanics.MultiBody.World world;
					Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape1 (shapeType = shapeType, color = color, specularCoefficient = specularCoefficient, length = length, width = width, height = height, lengthDirection = lengthDirection, widthDirection = widthDirection, r_shape = r_shape, extra = extra, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
					Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape2 (shapeType = "sphere", color = sphereColor, specularCoefficient = specularCoefficient, length = sphereDiameter, width = sphereDiameter, height = sphereDiameter, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, r_shape = r_CM - {1, 0, 0} * sphereDiameter / 2, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation and animateSphere;
					equation  
					r_0 = frame_a.r_0;
					v_0 = der(r_0);
					a_0 = der(v_0);
					connect (frame_a, frameTranslation.frame_a);
					connect (frame_b, frameTranslation.frame_b);
					connect (frame_a, body.frame_a);
				end BodyShape;
				  
			end Parts;
			  
			package Visualizers
				extends Modelica.Icons.Package;  
				package Advanced
					extends Modelica.Icons.Package;  
					model Shape
						extends ModelicaServices.Animation.Shape;  
						extends ModelicaServices.Animation.Shape;  
						extends Modelica.Utilities.Internal.PartialModelicaServices.Animation.PartialShape;  
					end Shape;
					  
				end Advanced;
				  
				package Internal
					extends Modelica.Icons.Package;  
					model Lines
						import SI = Modelica.SIunits;
						import Modelica.Mechanics.MultiBody;
						import Modelica.Mechanics.MultiBody.Types;
						import Modelica.Mechanics.MultiBody.Frames;
						import T = Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
						input Modelica.Mechanics.MultiBody.Frames.Orientation R = Frames.nullRotation();
						input Modelica.SIunits.Position r[3] = {0, 0, 0};
						input Modelica.SIunits.Position r_lines[3] = {0, 0, 0};
						input Real n_x[3] (unit = "1") = {1, 0, 0};
						input Real n_y[3] (unit = "1") = {0, 1, 0};
						input Modelica.SIunits.Position lines[:,2,2] = zeros(0, 2, 2);
						input Modelica.SIunits.Length diameter (min = 0) = 0.05;
						input Modelica.Mechanics.MultiBody.Types.Color color = {0, 128, 255};
						input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.7;
						protected
						Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape cylinders[n] (shapeType = "cylinder", lengthDirection = array(T.resolve1(R_rel, vector([lines[i, 2, :] - lines[i, 1, :]; 0])) for i in 1:n), length = array(Modelica.Math.Vectors.length(lines[i, 2, :] - lines[i, 1, :]) for i in 1:n), r = array(r_abs + T.resolve1(R_lines, vector([lines[i, 1, :]; 0])) for i in 1:n), width = diameter, height = diameter, widthDirection = {0, 1, 0}, color = color, R = R, specularCoefficient = specularCoefficient);
						parameter Integer n = size(lines, 1);
						Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation R_rel = T.from_nxy(n_x, n_y);
						Modelica.Mechanics.MultiBody.Frames.TransformationMatrices.Orientation R_lines = T.absoluteRotation(R.T, R_rel);
						Modelica.SIunits.Position r_abs[3] = r + T.resolve1(R.T, r_lines);
					end Lines;
					  
				end Internal;
				  
			end Visualizers;
			  
			package Types
				extends Modelica.Icons.Package;  
				type Axis
					= Modelica.Icons.TypeReal[3] (unit = "1");  
				  
				type AxisLabel
					= Modelica.Icons.TypeString;  
				  
				type RotationSequence
					= Modelica.Icons.TypeInteger[3] (min = {1, 1, 1}, max = {3, 3, 3});  
				  
				type Color
					= Modelica.Icons.TypeInteger[3] (min = 0, max = 255);  
				  
				type SpecularCoefficient
					= Modelica.Icons.TypeReal;  
				  
				type ShapeType
					= Modelica.Icons.TypeString;  
				  
				type ShapeExtra
					= Modelica.Icons.TypeReal;  
				  
				type GravityTypes = enumeration(
					NoGravity,
					UniformGravity,
					PointGravity
				);
				  
				package Defaults
					extends Modelica.Icons.Package;  
					constant Modelica.Mechanics.MultiBody.Types.Color BodyColor = {0, 128, 255};
					constant Modelica.Mechanics.MultiBody.Types.Color RodColor = {155, 155, 155};
					constant Modelica.Mechanics.MultiBody.Types.Color JointColor = {255, 0, 0};
					constant Modelica.Mechanics.MultiBody.Types.Color FrameColor = {0, 0, 0};
					constant Real FrameHeadLengthFraction = 5.0;
					constant Real FrameHeadWidthFraction = 3.0;
					constant Real FrameLabelHeightFraction = 3.0;
					constant Real ArrowHeadLengthFraction = 4.0;
					constant Real ArrowHeadWidthFraction = 3.0;
					constant Modelica.SIunits.Diameter BodyCylinderDiameterFraction = 3;
				end Defaults;
				  
			end Types;
			  
		end MultiBody;
		  
		package Rotational
			import SI = Modelica.SIunits;
			extends Modelica.Icons.Package;  
			package Components
				extends Modelica.Icons.Package;  
				model Fixed
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
					parameter Modelica.SIunits.Angle phi0 = 0;
					equation  
					flange.phi = phi0;
				end Fixed;
				  
				model Inertia
					import SI = Modelica.SIunits;
					Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
					parameter Modelica.SIunits.Inertia J (min = 0, start = 1);
					parameter StateSelect stateSelect = StateSelect.default;
					Modelica.SIunits.Angle phi (stateSelect = stateSelect);
					Modelica.SIunits.AngularVelocity w (stateSelect = stateSelect);
					Modelica.SIunits.AngularAcceleration a;
					equation  
					phi = flange_a.phi;
					phi = flange_b.phi;
					w = der(phi);
					a = der(w);
					J * a = flange_a.tau + flange_b.tau;
				end Inertia;
				  
				model SpringDamper
					import SI = Modelica.SIunits;
					extends Modelica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates;  
					extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;  
					parameter Modelica.SIunits.RotationalSpringConstant c (min = 0, start = 1.0e5);
					parameter Modelica.SIunits.RotationalDampingConstant d (min = 0, start = 0);
					parameter Modelica.SIunits.Angle phi_rel0 = 0;
					protected
					Modelica.SIunits.Torque tau_c;
					Modelica.SIunits.Torque tau_d;
					equation  
					tau_c = c * (phi_rel - phi_rel0);
					tau_d = d * w_rel;
					tau = tau_c + tau_d;
					lossPower = tau_d * w_rel;
				end SpringDamper;
				  
				model BearingFriction
					extends Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2;  
					extends Modelica.Mechanics.Rotational.Interfaces.PartialFriction;  
					extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;  
					parameter Real tau_pos[:,2] = [0, 1];
					parameter Real peak (min = 1) = 1;
					Modelica.SIunits.Angle phi;
					Modelica.SIunits.Torque tau;
					Modelica.SIunits.AngularVelocity w;
					Modelica.SIunits.AngularAcceleration a;
					equation  
					tau0 = Modelica.Math.tempInterpol1(0, tau_pos, 2);
					tau0_max = peak * tau0;
					free = false;
					phi = flange_a.phi - phi_support;
					flange_b.phi = flange_a.phi;
					w = der(phi);
					a = der(w);
					w_relfric = w;
					a_relfric = a;
				end BearingFriction;
				  
				model IdealGear
					extends Modelica.Mechanics.Rotational.Icons.Gear;  
					extends Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2;  
					parameter Real ratio (start = 1);
					Modelica.SIunits.Angle phi_a;
					Modelica.SIunits.Angle phi_b;
					equation  
					phi_a = flange_a.phi - phi_support;
					phi_b = flange_b.phi - phi_support;
					phi_a = ratio * phi_b;
					0 = ratio * flange_a.tau + flange_b.tau;
				end IdealGear;
				  
				model InitializeFlange
					extends Modelica.Blocks.Interfaces.BlockIcon;  
					Modelica.Blocks.Interfaces.RealInput phi_start if use_phi_start;
					Modelica.Blocks.Interfaces.RealInput w_start if use_w_start;
					Modelica.Blocks.Interfaces.RealInput a_start if use_a_start;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
					parameter Boolean use_phi_start = true;
					parameter Boolean use_w_start = true;
					parameter Boolean use_a_start = true;
					parameter StateSelect stateSelect = StateSelect.default;
					Modelica.SIunits.Angle phi_flange (stateSelect = stateSelect) = flange.phi;
					Modelica.SIunits.AngularVelocity w_flange (stateSelect = stateSelect) = der(phi_flange);
					protected
					Modelica.Mechanics.Rotational.Components.InitializeFlange.Set_phi_start set_phi_start if use_phi_start;
					Modelica.Mechanics.Rotational.Components.InitializeFlange.Set_w_start set_w_start if use_w_start;
					Modelica.Mechanics.Rotational.Components.InitializeFlange.Set_a_start set_a_start if use_a_start;
					Modelica.Mechanics.Rotational.Components.InitializeFlange.Set_flange_tau set_flange_tau;
					encapsulated model Set_phi_start
						import Modelica;
						extends Modelica.Blocks.Interfaces.BlockIcon;  
						Modelica.Blocks.Interfaces.RealInput phi_start;
						Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
						initial equation  
						flange.phi = phi_start;
						equation  
						flange.tau = 0;
					end Set_phi_start;
					  
					encapsulated model Set_w_start
						import Modelica;
						extends Modelica.Blocks.Interfaces.BlockIcon;  
						Modelica.Blocks.Interfaces.RealInput w_start;
						Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
						initial equation  
						der(flange.phi) = w_start;
						equation  
						flange.tau = 0;
					end Set_w_start;
					  
					encapsulated model Set_a_start
						import Modelica;
						extends Modelica.Blocks.Interfaces.BlockIcon;  
						Modelica.Blocks.Interfaces.RealInput a_start;
						Modelica.Mechanics.Rotational.Interfaces.Flange_b flange (phi.stateSelect = StateSelect.avoid);
						Modelica.SIunits.AngularVelocity w = der(flange.phi);
						initial equation  
						der(w) = a_start;
						equation  
						flange.tau = 0;
					end Set_a_start;
					  
					encapsulated model Set_flange_tau
						import Modelica;
						extends Modelica.Blocks.Interfaces.BlockIcon;  
						Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
						equation  
						flange.tau = 0;
					end Set_flange_tau;
					  
					equation  
					connect (set_w_start.w_start, w_start);
					connect (set_phi_start.phi_start, phi_start);
					connect (set_a_start.flange, flange);
					connect (set_w_start.flange, flange);
					connect (set_phi_start.flange, flange);
					connect (set_a_start.a_start, a_start);
					connect (set_flange_tau.flange, flange);
				end InitializeFlange;
				  
			end Components;
			  
			package Sensors
				extends Modelica.Icons.SensorsPackage;  
				model AngleSensor
					extends Modelica.Mechanics.Rotational.Interfaces.PartialAbsoluteSensor;  
					Modelica.Blocks.Interfaces.RealOutput phi;
					equation  
					phi = flange.phi;
				end AngleSensor;
				  
				model SpeedSensor
					extends Modelica.Mechanics.Rotational.Interfaces.PartialAbsoluteSensor;  
					Modelica.Blocks.Interfaces.RealOutput w;
					equation  
					w = der(flange.phi);
				end SpeedSensor;
				  
				model AccSensor
					extends Modelica.Mechanics.Rotational.Interfaces.PartialAbsoluteSensor;  
					Modelica.Blocks.Interfaces.RealOutput a;
					Modelica.SIunits.AngularVelocity w;
					equation  
					w = der(flange.phi);
					a = der(w);
				end AccSensor;
				  
			end Sensors;
			  
			package Sources
				extends Modelica.Icons.SourcesPackage;  
				model ConstantTorque
					extends Modelica.Mechanics.Rotational.Interfaces.PartialTorque;  
					parameter Modelica.SIunits.Torque tau_constant;
					Modelica.SIunits.Torque tau;
					equation  
					tau = -flange.tau;
					tau = tau_constant;
				end ConstantTorque;
				  
			end Sources;
			  
			package Interfaces
				extends Modelica.Icons.InterfacesPackage;  
				connector Flange_a
					Modelica.SIunits.Angle phi;
					flow Modelica.SIunits.Torque tau;
				end Flange_a;
				  
				connector Flange_b
					Modelica.SIunits.Angle phi;
					flow Modelica.SIunits.Torque tau;
				end Flange_b;
				  
				connector Support
					Modelica.SIunits.Angle phi;
					flow Modelica.SIunits.Torque tau;
				end Support;
				  
				model InternalSupport
					Modelica.Mechanics.Rotational.Interfaces.Flange_a flange;
					input Modelica.SIunits.Torque tau;
					Modelica.SIunits.Angle phi;
					equation  
					flange.tau = tau;
					flange.phi = phi;
				end InternalSupport;
				  
				partial model PartialTwoFlanges
					Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
				end PartialTwoFlanges;
				  
				partial model PartialCompliantWithRelativeStates
					Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
					Modelica.SIunits.Angle phi_rel (start = 0, stateSelect = stateSelect, nominal = phi_nominal);
					Modelica.SIunits.AngularVelocity w_rel (start = 0, stateSelect = stateSelect);
					Modelica.SIunits.AngularAcceleration a_rel (start = 0);
					Modelica.SIunits.Torque tau;
					parameter Modelica.SIunits.Angle phi_nominal (displayUnit = "rad") = 1e-4;
					parameter StateSelect stateSelect = StateSelect.prefer;
					equation  
					phi_rel = flange_b.phi - flange_a.phi;
					w_rel = der(phi_rel);
					a_rel = der(w_rel);
					flange_b.tau = tau;
					flange_a.tau = -tau;
				end PartialCompliantWithRelativeStates;
				  
				partial model PartialElementaryOneFlangeAndSupport2
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange;
					Modelica.Mechanics.Rotational.Interfaces.Support support (phi = phi_support, tau = -flange.tau) if useSupport;
					parameter Boolean useSupport = false;
					protected
					Modelica.SIunits.Angle phi_support;
					equation  
					if not useSupport then
					  phi_support = 0;
					end if;
				end PartialElementaryOneFlangeAndSupport2;
				  
				partial model PartialElementaryTwoFlangesAndSupport2
					Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a;
					Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b;
					Modelica.Mechanics.Rotational.Interfaces.Support support (phi = phi_support, tau = (-flange_a.tau) - flange_b.tau) if useSupport;
					parameter Boolean useSupport = false;
					protected
					Modelica.SIunits.Angle phi_support;
					equation  
					if not useSupport then
					  phi_support = 0;
					end if;
				end PartialElementaryTwoFlangesAndSupport2;
				  
				partial model PartialTorque
					extends Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport2;  
					Modelica.SIunits.Angle phi;
					equation  
					phi = flange.phi - phi_support;
				end PartialTorque;
				  
				partial model PartialAbsoluteSensor
					Modelica.Mechanics.Rotational.Interfaces.Flange_a flange;
					equation  
					0 = flange.tau;
				end PartialAbsoluteSensor;
				  
				partial model PartialFriction
					parameter Modelica.SIunits.AngularVelocity w_small = 1.0e10;
					Modelica.SIunits.AngularVelocity w_relfric;
					Modelica.SIunits.AngularAcceleration a_relfric;
					Modelica.SIunits.Torque tau0;
					Modelica.SIunits.Torque tau0_max;
					Boolean free;
					Real sa (unit = "1");
					Boolean startForward (start = false, fixed = true);
					Boolean startBackward (start = false, fixed = true);
					Boolean locked (start = false);
					constant Integer Unknown = 3;
					constant Integer Free = 2;
					constant Integer Forward = 1;
					constant Integer Stuck = 0;
					constant Integer Backward = -1;
					Integer mode (min = Backward, max = Unknown, start = Unknown, fixed = true);
					protected
					constant Modelica.SIunits.AngularAcceleration unitAngularAcceleration = 1;
					constant Modelica.SIunits.Torque unitTorque = 1;
					equation  
					startForward = pre(mode) == Stuck and (sa > tau0_max / unitTorque or pre(startForward) and sa > tau0 / unitTorque) or pre(mode) == Backward and w_relfric > w_small or initial() and w_relfric > 0;
					startBackward = pre(mode) == Stuck and (sa < (-tau0_max / unitTorque) or pre(startBackward) and sa < (-tau0 / unitTorque)) or pre(mode) == Forward and w_relfric < (-w_small) or initial() and w_relfric < 0;
					locked = not free and not (pre(mode) == Forward or startForward or pre(mode) == Backward or startBackward);
					a_relfric / unitAngularAcceleration = if locked then 0 else if free then sa else if startForward then sa - tau0_max / unitTorque else if startBackward then sa + tau0_max / unitTorque else if pre(mode) == Forward then sa - tau0_max / unitTorque else sa + tau0_max / unitTorque;
				end PartialFriction;
				  
			end Interfaces;
			  
			package Icons
				extends Modelica.Icons.Package;  
				partial class Gear
				end Gear;
				  
			end Icons;
			  
		end Rotational;
		  
	end Mechanics;
	  
	package Thermal
		extends Modelica.Icons.Package;  
		package HeatTransfer
			import Modelica.SIunits.Conversions.*;
			extends Modelica.Icons.Package;  
			package Interfaces
				extends Modelica.Icons.InterfacesPackage;  
				partial connector HeatPort
					Modelica.SIunits.Temperature T;
					flow Modelica.SIunits.HeatFlowRate Q_flow;
				end HeatPort;
				  
				connector HeatPort_a
					extends Modelica.Thermal.HeatTransfer.Interfaces.HeatPort;  
				end HeatPort_a;
				  
				partial model PartialElementaryConditionalHeatPortWithoutT
					Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort (Q_flow = -lossPower) if useHeatPort;
					parameter Boolean useHeatPort = false;
					Modelica.SIunits.Power lossPower;
				end PartialElementaryConditionalHeatPortWithoutT;
				  
			end Interfaces;
			  
		end HeatTransfer;
		  
	end Thermal;
	  
	package Math
		import SI = Modelica.SIunits;
		extends Modelica.Icons.Package;  
		function sin
			extends Modelica.Math.baseIcon1;  
			input Modelica.SIunits.Angle u; 
			output Real y; 
			external "builtin" y = sin(u);
			annotation(Library="ModelicaExternalC");
		end sin;
		function cos
			extends Modelica.Math.baseIcon1;  
			input Modelica.SIunits.Angle u; 
			output Real y; 
			external "builtin" y = cos(u);
			annotation(Library="ModelicaExternalC");
		end cos;
		function asin
			extends Modelica.Math.baseIcon2;  
			input Real u; 
			output Modelica.SIunits.Angle y; 
			external "builtin" y = asin(u);
			annotation(Library="ModelicaExternalC");
		end asin;
		function atan2
			extends Modelica.Math.baseIcon2;  
			input Real u1; 
			input Real u2; 
			output Modelica.SIunits.Angle y; 
			external "builtin" y = atan2(u1,u2);
			annotation(Library="ModelicaExternalC");
		end atan2;
		partial function baseIcon1
		end baseIcon1;
		partial function baseIcon2
		end baseIcon2;
		function tempInterpol1
			input Real u; 
			input Real table[:,:]; 
			input Integer icol; 
			output Real y; 
			protected
			Integer i; 
			Integer n; 
			Real u1; 
			Real u2; 
			Real y1; 
			Real y2; 
			algorithm 
			n := size(table, 1);
			if n <= 1 then
			  y := table[1, icol];
			else
			  if u <= table[1, 1] then
			    i := 1;
			  else
			    i := 2;
			    while i < n and u >= table[i, 1] loop
			      i := i + 1;
			    end while;
			    i := i - 1;
			  end if;
			  u1 := table[i, 1];
			  u2 := table[i + 1, 1];
			  y1 := table[i, icol];
			  y2 := table[i + 1, icol];
			  assert(u2 > u1, "Table index must be increasing");
			  y := y1 + (y2 - y1) * (u - u1) / (u2 - u1);
			end if;
		end tempInterpol1;
		  
		  
		  
		  
		  
		  
		  
		package Vectors
			extends Modelica.Icons.Package;  
			function length
				extends Modelica.Icons.Function;  
				input Real v[:]; 
				output Real result; 
				algorithm 
				result := sqrt(v * v);
			end length;
			function normalize
				extends Modelica.Icons.Function;  
				input Real v[:]; 
				input Real eps = 100 * Modelica.Constants.eps; 
				output Real result[size(v, 1)]; 
				algorithm 
				result := smooth(0, noEvent(if length(v) >= eps then v / length(v) else v / eps));
			end normalize;
			  
			  
		end Vectors;
		  
	end Math;
	  
	package Utilities
		extends Modelica.Icons.Package;  
		package Internal
			extends Modelica.Icons.Package;  
			partial package PartialModelicaServices
				extends Modelica.Icons.Package;  
				package Animation
					extends Modelica.Icons.Package;  
					partial model PartialShape
						import SI = Modelica.SIunits;
						import Modelica.Mechanics.MultiBody.Frames;
						import Modelica.Mechanics.MultiBody.Types;
						parameter Modelica.Mechanics.MultiBody.Types.ShapeType shapeType = "box";
						input Modelica.Mechanics.MultiBody.Frames.Orientation R = Frames.nullRotation();
						input Modelica.SIunits.Position r[3] = {0, 0, 0};
						input Modelica.SIunits.Position r_shape[3] = {0, 0, 0};
						input Real lengthDirection[3] (unit = "1") = {1, 0, 0};
						input Real widthDirection[3] (unit = "1") = {0, 1, 0};
						input Modelica.SIunits.Length length = 0;
						input Modelica.SIunits.Length width = 0;
						input Modelica.SIunits.Length height = 0;
						input Modelica.Mechanics.MultiBody.Types.ShapeExtra extra = 0.0;
						input Real color[3] = {255, 0, 0};
						input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.7;
					end PartialShape;
					  
					model PartialSurface
						import Modelica.Mechanics.MultiBody.Frames;
						import Modelica.Mechanics.MultiBody.Types;
						input Modelica.Mechanics.MultiBody.Frames.Orientation R = Frames.nullRotation();
						input Modelica.SIunits.Position r_0[3] = {0, 0, 0};
						parameter Integer nu = 2;
						parameter Integer nv = 2;
						parameter Boolean wireframe = false;
						parameter Boolean multiColoredSurface = false;
						input Real color[3] = {255, 0, 0};
						input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.7;
						input Real transparency = 0;
						replaceable function surfaceCharacteristic
							= Modelica.Mechanics.MultiBody.Interfaces.partialSurfaceCharacteristic;  
						  
					end PartialSurface;
					  
				end Animation;
				  
			end PartialModelicaServices;
			  
		end Internal;
		  
	end Utilities;
	  
	package Constants
		import SI = Modelica.SIunits;
		import NonSI = Modelica.SIunits.Conversions.NonSIunits;
		extends Modelica.Icons.Package;  
		constant Real pi = 2 * Modelica.Math.asin(1.0);
		constant Real eps = 1.e-15;
		constant Real small = 1.e-60;
		constant Real inf = 1.e+60;
	end Constants;
	  
	package Icons
		extends Modelica.Icons.Package;  
		partial function Function
		end Function;
		  
		partial package ExamplesPackage
		end ExamplesPackage;
		  
		partial model Example
		end Example;
		  
		partial package Package
		end Package;
		  
		partial package InterfacesPackage
		end InterfacesPackage;
		  
		partial package SourcesPackage
		end SourcesPackage;
		  
		partial package SensorsPackage
		end SensorsPackage;
		  
		partial class RotationalSensor
		end RotationalSensor;
		  
		partial record Record
		end Record;
		  
		type TypeReal
			extends Real;  
		end TypeReal;
		  
		type TypeInteger
			extends Integer;  
		end TypeInteger;
		  
		type TypeString
			extends String;  
		end TypeString;
		  
		connector SignalBus
		end SignalBus;
		  
		connector SignalSubBus
		end SignalSubBus;
		  
		partial class MotorIcon
		end MotorIcon;
		  
	end Icons;
	  
	package SIunits
		extends Modelica.Icons.Package;  
		package Conversions
			extends Modelica.Icons.Package;  
			function from_deg
				extends Modelica.SIunits.Conversions.ConversionIcon;  
				input Modelica.SIunits.Conversions.NonSIunits.Angle_deg degree; 
				output Modelica.SIunits.Angle radian; 
				algorithm 
				radian := Modelica.Constants.pi / 180.0 * degree;
			end from_deg;
			partial function ConversionIcon
			end ConversionIcon;
			  
			  
			package NonSIunits
				extends Modelica.Icons.Package;  
				type Angle_deg
					= Real (quantity = "Angle", unit = "deg");  
				  
			end NonSIunits;
			  
		end Conversions;
		  
		type Angle
			= Real (quantity = "Angle", unit = "rad", displayUnit = "deg");  
		  
		type Length
			= Real (quantity = "Length", unit = "m");  
		  
		type Position
			= Modelica.SIunits.Length;  
		  
		type Distance
			= Modelica.SIunits.Length (min = 0);  
		  
		type Diameter
			= Modelica.SIunits.Length (min = 0);  
		  
		type Time
			= Real (quantity = "Time", unit = "s");  
		  
		type AngularVelocity
			= Real (quantity = "AngularVelocity", unit = "rad/s");  
		  
		type AngularAcceleration
			= Real (quantity = "AngularAcceleration", unit = "rad/s2");  
		  
		type Velocity
			= Real (quantity = "Velocity", unit = "m/s");  
		  
		type Acceleration
			= Real (quantity = "Acceleration", unit = "m/s2");  
		  
		type Mass
			= Real (quantity = "Mass", unit = "kg", min = 0);  
		  
		type MomentOfInertia
			= Real (quantity = "MomentOfInertia", unit = "kg.m2");  
		  
		type Inertia
			= Modelica.SIunits.MomentOfInertia;  
		  
		type Force
			= Real (quantity = "Force", unit = "N");  
		  
		type Torque
			= Real (quantity = "Torque", unit = "N.m");  
		  
		type ElectricalTorqueConstant
			= Real (quantity = "ElectricalTorqueConstant", unit = "N.m/A");  
		  
		type RotationalSpringConstant
			= Real (quantity = "RotationalSpringConstant", unit = "N.m/rad");  
		  
		type RotationalDampingConstant
			= Real (quantity = "RotationalDampingConstant", unit = "N.m.s/rad");  
		  
		type Power
			= Real (quantity = "Power", unit = "W");  
		  
		type ThermodynamicTemperature
			= Real (quantity = "ThermodynamicTemperature", unit = "K", min = 0, start = 288.15, displayUnit = "degC");  
		  
		type Temperature
			= Modelica.SIunits.ThermodynamicTemperature;  
		  
		type LinearTemperatureCoefficient
			= Real (quantity = "LinearTemperatureCoefficient", unit = "1/K");  
		  
		type HeatFlowRate
			= Real (quantity = "Power", unit = "W");  
		  
		type ElectricCurrent
			= Real (quantity = "ElectricCurrent", unit = "A");  
		  
		type Current
			= Modelica.SIunits.ElectricCurrent;  
		  
		type ElectricPotential
			= Real (quantity = "ElectricPotential", unit = "V");  
		  
		type Voltage
			= Modelica.SIunits.ElectricPotential;  
		  
		type Capacitance
			= Real (quantity = "Capacitance", unit = "F", min = 0);  
		  
		type Inductance
			= Real (quantity = "Inductance", unit = "H");  
		  
		type Resistance
			= Real (quantity = "Resistance", unit = "Ohm");  
		  
	end SIunits;
	  
end Modelica;
  
model Modelica_Mechanics_MultiBody_Examples_Systems_RobotR3_fullRobot
	extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot;  
end Modelica_Mechanics_MultiBody_Examples_Systems_RobotR3_fullRobot;

end MyPackage;  
