clearScreen.

lock throttle to 1.0.
//set mythrottle to throttle.

print "Counting down:".
from {local countdown is 3.} until countdown = 0 step {set countdown to countdown-1.} do{
    print "..." + countdown.
    wait 1.
}
stage.

set mysteer to heading(90, 90).
lock steering to mysteer.

until ship:apoapsis > 90000 {
    wait 1.

    if ship:velocity:surface:mag < 100 {
        set mysteer to heading(90, 90).
    }
    else if ship:velocity:surface:mag >= 100 and ship:velocity:surface:mag < 200 {
        
        set mysteer to heading(90, 80).
        print "Pitching to 80 degrees." at (0, 15).
        print "Apoapsis Height: " + round(ship:apoapsis, 0) at (0, 16).
    }
    else if ship:velocity:surface:mag >= 200 {
        set mysteer to ship:velocity:surface:direction.
        print "Performing gravity turn." at (0, 15).
        unlock steering.
        sas on.
        set sasmode to "prograde".
        print "Apoapsis Height: " + round(ship:apoapsis, 2) at (0, 16).
        print "Inclination: " + round(ship:orbit:inclination, 2) at (0, 17).
        print "Speed at apoapsis: " + round(visviva(ship:apoapsis, ship:orbit:semimajoraxis)) at (0, 18).
    }

    if ship:apoapsis < 60000 {
        set warp to 3.
    }
    else if ship:apoapsis >= 60000 {
        set warp to 2.
    }
}

clearscreen.
print "90km apoapsis reached, cutting throttle and stage for coasting.".
lock throttle to 0.
wait 0.5.
stage.
set warp to 2.

wait until ship:altitude > 70000.
set warp to 0.

wait 5.
warpto(time:seconds + eta:apoapsis - 60).
sas off.
set mysteer to heading(90, 0).
lock steering to mysteer.
lock throttle to 1.

//Circularization
wait until ship:verticalspeed <= 300.
stage.

until ship:periapsis > 90000 {
    
    set mysteer to heading(90, 0 - (30 * ship:verticalspeed/300)).

    print "Circularizing." at (0, 15).
    print "Apoapsis Height: " + round(ship:apoapsis, 2) at (0, 16).
    print "Periapsis Height: " + round(ship:periapsis, 2) at (0, 17).
    print "Inclination: " + round(ship:orbit:inclination, 2) at (0, 18).
    print "Speed at apoapsis: " + round(visviva(ship:apoapsis, ship:orbit:semimajoraxis)) at (0, 19).
    print "Throttle: " + round(throttle*100) at (0, 25).
}

wait until ship:periapsis > 90000.
print "Nominal orbit insertion, ascent script stopped.".
lock throttle to 0.
set ship:control:pilotmainthrottle to 0.

function visviva {
    parameter height.
    parameter sma.
    set speed to sqrt(Kerbin:MU * (2/(600000+height) - 1/sma)).
    return speed.
}

function orbitalvel {
    parameter height.
    set orbitalvelocity to sqrt(Kerbin:MU/height).
    return orbitalvelocity.
}