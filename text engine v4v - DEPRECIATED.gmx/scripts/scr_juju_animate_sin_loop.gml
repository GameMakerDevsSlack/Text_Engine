///scr_juju_animate_sin_loop()
//  
//  Tweens on a smoothly reciprocating path.
//  For use with scr_juju_animate().
//  
//  Version 4L
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

animateT = animateT mod 1;
return ( 0.5 - 0.5 * cos( 2 * pi * animateT ) );
