///text_do_outro( json )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _json = argument0;

if ( _json < 0 ) exit;

if ( _json[? "transition state" ] = text_state_intro ) or ( _json[? "transition state" ] = text_state_visible ) {
    _json[? "transition timer" ] = _json[? "outro max" ];
    _json[? "transition state" ] = text_state_outro;
}
