///scr_juju_ease_cubic_out( t )
//  
//  Standard cubic tween.
//  For use with scr_juju_animate() but can be used elsewhere.
//  
//  Version 4L
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

var t = argument0;
t = -t;

return t*t*t + 1;
