class SVehicleWheel_BS extends SVehicleWheel;

function KApplyForce(out vector Force, out vector Torque) {
//Super.KApplyForce(Force, Torque);
Force += vect(0,0,1) * 100.000;
}
