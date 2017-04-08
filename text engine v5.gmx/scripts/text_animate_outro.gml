///text_animate_outro( json, increment )
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

_json[? "transition timer" ] = clamp( _json[? "transition timer" ] - _incr, 0, _json[? "outro max" ] );
if ( _json[? "transition timer" ] <= 0 ) _json[? "transition state" ] = text_state_invisible else _json[? "transition state" ] = text_state_outro;
