class ONSPRV_BSX extends ONSPRV;

function KApplyForce(out vector Force, out vector Torque) {
Super.KApplyForce(Force, Torque);
Force += vect(0,0,1) * 30;
}

defaultproperties {
}
