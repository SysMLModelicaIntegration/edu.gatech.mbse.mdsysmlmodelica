package TwoTankExample

replaceable connector ActSignal "Signal to actuator for setting valve position"
Real act;
end ActSignal;

connector ReadSignal "Reading fluid level"
Real val(unit = "m");
end ReadSignal;

connector LiquidFlow "Liquid flow at inlets or outlets"
Real lflow(unit = "m3/s");
end LiquidFlow;

partial model BaseController
parameter Real K = 2 "Gain";
parameter Real T(unit = "s") = 10 "Time constant";
ReadSignal cIn "Input sensor level, connector";
ActSignal cOut "Control to actuator, connector";
parameter Real ref "Reference level";
Real error "Deviation from reference
level";
Real outCtr "Output control signal";
equation
error = ref - cIn.val;
cOut.act = outCtr;
end BaseController;

function limitValue
input Real pMin;
input Real pMax;
input Real p;
output Real pLim;
algorithm
pLim := if p>pMax then pMax else 
     if p<pMin then pMin else 
     p;
end limitValue;

replaceable model LiquidSource
LiquidFlow qOut;
parameter Real flowLevel = 0.02;
equation
qOut.lflow = if time > 150 then 3*flowLevel else 
flowLevel;
end LiquidSource;

model PIcontinuousController
extends BaseController(K = 2, T = 10);
Real x "State variable of continuous PI
controller";
equation
der(x) = error/T;
outCtr = K*(error + x);
end PIcontinuousController;

model Tank
ReadSignal tSensor "Connector, sensor reading tank
level (m)";
ActSignal tActuator "Connector, actuator controlling
input flow";
LiquidFlow qIn "Connector, flow (m3/s) through input
valve";
LiquidFlow qOut "Connector, flow (m3/s) through
output valve";
parameter Real area(unit = "m2") = 0.5;
parameter Real flowGain(unit = "m2/s") = 0.05;
parameter Real minV= 0;
parameter Real maxV =          10; // Limits for output valve flow
Real h(start = 0.0, unit = "m") "Tank level";
equation
assert(minV>=0,"minV - minimum Valve level must be >= 0 ");
der(h) = (qIn.lflow - qOut.lflow)/area; 
qOut.lflow = limitValue(minV, maxV, -flowGain*tActuator.act);
tSensor.val = h;
end Tank;

model TanksConnectedPI
LiquidSource source(flowLevel = 0.02);
Tank tank1(area = 1);
Tank tank2(area = 1.3);
PIcontinuousController piContinuous1(ref = 0.25);
PIcontinuousController piContinuous2(ref = 0.4);
equation
connect(source.qOut,tank1.qIn);
connect(tank1.tActuator,piContinuous1.cOut);
connect(tank1.tSensor,piContinuous1.cIn);
connect(tank1.qOut,tank2.qIn);
connect(tank2.tActuator,piContinuous2.cOut);
connect(tank2.tSensor,piContinuous2.cIn);
end TanksConnectedPI;


end TwoTankExample;
