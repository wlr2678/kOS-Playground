clearscreen.

wait 1.

// staging, throttle, steering, go
when stage:liquidfuel < 0.1 then {
    stage.
    print "Staging".
    preserve.
}

lock throttle to 1.
lock steering to r(0,0,-90) + heading(90,90).
stage.
wait until ship:altitude > 1000.

// P-loop setup
set G to Kerbin:MU / Kerbin:RADIUS^2.
lock accvec to ship:sensors:acc - ship:sensors:grav.
lock gforce to accvec:mag / G.
lock dthrott to 0.05 * (1.2 - gforce). //gain * (setpoint - input)

set thrott to 1.
lock throttle to thrott.

until ship:altitude > 40000 {
    set thrott to thrott + dthrott.
    wait 0.1.
    print "Acc: " + round(accvec, 2) at (0, 1).
    print "Gforce: " + round(gforce, 2) at (0, 2).
    print "Throttle: " + round(throttle, 2) at (0, 3).
}