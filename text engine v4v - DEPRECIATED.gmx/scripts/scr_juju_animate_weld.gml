///scr_juju_animate_weld()

if ( instance_exists( animateIncr ) ) {
    if ( is_real( animateStartX ) ) x = animateIncr.x + animateStartX;
    if ( is_real( animateStartY ) ) y = animateIncr.y + animateStartY;
    if ( is_real( animateStartA ) ) image_alpha = animateIncr.image_alpha;
}
