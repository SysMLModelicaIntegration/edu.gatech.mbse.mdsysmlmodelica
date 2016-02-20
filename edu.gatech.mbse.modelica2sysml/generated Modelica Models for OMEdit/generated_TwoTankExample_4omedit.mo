package TwoTankExample
	function limitValue
		input Real pMin; 
		input Real pMax; 
		input Real p; 
		output Real pLim; 
		algorithm 
		pLim := if p > pMax then pMax else if p < pMin then pMin else p;
	end limitValue;
	  
	replaceable connector ActSignal
		Real act;
	end ActSignal;
	  
	connector ReadSignal
		Real val (unit = "m");
	end ReadSignal;
	  
	connector LiquidFlow
		Real lflow (unit = "m3/s");
	end LiquidFlow;
	  
	partial model BaseController
		TwoTankExample.ReadSignal cIn;
		TwoTankExample.ActSignal cOut;
		parameter Real K = 2;
		parameter Real T (unit = "s") = 10;
		parameter Real ref;
		Real error;
		Real outCtr;
		equation  
		error = ref - cIn.val;
		cOut.act = outCtr;
	end BaseController;
	  
	replaceable model LiquidSource
		TwoTankExample.LiquidFlow qOut;
		parameter Real flowLevel = 0.02;
		equation  
		qOut.lflow = if time > 150 then 3 * flowLevel else flowLevel;
	end LiquidSource;
	  
	model PIcontinuousController
		extends TwoTankExample.BaseController (K = 2, T = 10);  
		Real x;
		equation  
		der(x) = error / T;
		outCtr = K * (error + x);
	end PIcontinuousController;
	  
	model Tank
		TwoTankExample.ReadSignal tSensor;
		TwoTankExample.ActSignal tActuator;
		TwoTankExample.LiquidFlow qIn;
		TwoTankExample.LiquidFlow qOut;
		parameter Real area (unit = "m2") = 0.5;
		parameter Real flowGain (unit = "m2/s") = 0.05;
		parameter Real minV = 0;
		parameter Real maxV = 10;
		Real h (start = 0.0, unit = "m");
		equation  
		assert(minV >= 0, "minV - minimum Valve level must be >= 0 ");
		der(h) = (qIn.lflow - qOut.lflow) / area;
		qOut.lflow = limitValue(minV, maxV, -flowGain * tActuator.act);
		tSensor.val = h;
	end Tank;
	  
	model TanksConnectedPI
		TwoTankExample.LiquidSource source (flowLevel = 0.02);
		TwoTankExample.Tank tank1 (area = 1);
		TwoTankExample.Tank tank2 (area = 1.3);
		TwoTankExample.PIcontinuousController piContinuous1 (ref = 0.25);
		TwoTankExample.PIcontinuousController piContinuous2 (ref = 0.4);
		equation  
		connect (tank1.qOut, tank2.qIn);
		connect (tank2.tSensor, piContinuous2.cIn);
		connect (tank2.tActuator, piContinuous2.cOut);
		connect (source.qOut, tank1.qIn);
		connect (tank1.tActuator, piContinuous1.cOut);
		connect (tank1.tSensor, piContinuous1.cIn);
	end TanksConnectedPI;
	  
end TwoTankExample;
  
