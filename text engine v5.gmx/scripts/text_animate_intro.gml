///text_animate_intro( json, increment )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _json = argument0;
var _incr = argument1;

_json[? "transition timer" ] = clamp( _json[? "transition timer" ] + _incr, 0, _json[? "intro max" ] );
if ( _json[? "transition timer" ] >= _json[? "intro max" ] ) _json[? "transition state" ] = text_state_visible else _json[? "transition state" ] = text_state_intro;
