#define scr_juju_animate
///scr_juju_animate( id, rate/parameter, start x, start y, start alpha, end x, end y, end alpha, function )

with( argument0 ) {
    
    animateT = 0;
    animateIncr = argument1;
    
    if ( is_real( argument2 ) ) and ( is_real( argument5 ) ) {
        animateStartX = argument2;
        animateEndX   = argument5;
    } else {
        animateStartX = "";
        animateEndX   = "";
    }
    
    if ( is_real( argument3 ) ) and ( is_real( argument6 ) ) {
        animateStartY = argument3;
        animateEndY   = argument6;
    } else {
        animateStartY = "";
        animateEndY   = "";
    }
    
    if ( is_real( argument4 ) ) and ( is_real( argument7 ) ) {
        animateStartA = argument4;
        animateEndA   = argument7;
    } else {
        animateStartA = "";
        animateEndA   = "";
    }
    
    animateFunction = argument8;
    animateTReal = script_execute( animateFunction, animateT );
    scr_juju_animate_step_event();
    
}

#define scr_juju_animate_step_event
///scr_juju_animate_step_event()

if ( animateIncr != 0 ) {
    
    animateT += animateIncr;
    animateTReal = script_execute( animateFunction, animateT );
    animateT = clamp( animateT, 0, 1 );
    
    if ( animateIncr < 1 ) {
        if ( is_real( animateStartX ) ) and ( is_real( animateEndX ) ) x           = lerp( animateStartX, animateEndX, animateTReal );
        if ( is_real( animateStartY ) ) and ( is_real( animateEndY ) ) y           = lerp( animateStartY, animateEndY, animateTReal );
        if ( is_real( animateStartA ) ) and ( is_real( animateEndA ) ) image_alpha = lerp( animateStartA, animateEndA, animateTReal );
    }
    
}

#define scr_juju_animate_off
///scr_juju_animate_off()

animateIncr = 0;