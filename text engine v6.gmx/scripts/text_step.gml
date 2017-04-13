///text_step( x, y, json, mouse x, mouse y, destroy if invisible )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _x       = argument0;
var _y       = argument1;
var _json    = argument2;
var _mouse_x = argument3;
var _mouse_y = argument4;
var _destroy = argument5;

if ( _json < 0 ) return noone;

if ( _json[? "transition state" ] == text_state_intro ) {
    _json[? "transition timer" ] = clamp( _json[? "transition timer" ] + _json[? "intro speed" ], 0, _json[? "intro max" ] );
    if ( _json[? "transition timer" ] >= _json[? "intro max" ] ) _json[? "transition state" ] = text_state_visible;
}

if ( _json[? "transition state" ] == text_state_outro ) {
    _json[? "transition timer" ] = clamp( _json[? "transition timer" ] - _json[? "outro speed" ], 0, _json[? "outro max" ] );
    if ( _json[? "transition timer" ] <= 0 ) _json[? "transition state" ] = text_state_invisible;
}

var _text_limit        = _json[? "transition timer" ];
var _text_font         = _json[? "default font" ];
var _text_colour       = _json[? "default colour" ];
var _hyperlinks        = _json[? "hyperlinks" ];
var _hyperlink_regions = _json[? "hyperlink regions" ];

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    var _map = _hyperlinks[? _key ];
    _map[? "over" ] = false;
    _map[? "clicked" ] = false;
}

if ( _json[? "transition state" ] == text_state_invisible ) {
    ds_map_destroy( _json );
    return noone;
}

if ( _json[? "transition state" ] != text_state_visible ) return _json;

var _regions = ds_list_size( _hyperlink_regions );
for( var _i = 0; _i < _regions; _i++ ) {
    
    var _region_map = _hyperlink_regions[| _i ];
    
    var _region_x = _x + _region_map[? "x" ];
    var _region_y = _y + _region_map[? "y" ];
    var _hyperlink_map = _hyperlinks[? _region_map[? "hyperlink" ] ];
    
    if ( _hyperlink_map != undefined ) and ( point_in_rectangle( _mouse_x, _mouse_y, _region_x, _region_y, _region_x + _region_map[? "width" ], _region_y + _region_map[? "height" ] ) ) {
        _hyperlink_map[? "over" ] = true;
    }
    
}

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    var _map = _hyperlinks[? _key ];
    if ( _map[? "over" ] ) {
        if ( mouse_check_button_pressed( mb_left ) ) {
            _map[? "down" ] = true;
        } else if ( !mouse_check_button( mb_left ) ) and ( _map[? "down" ] ) {
            _map[? "down" ] = false;
            _map[? "clicked" ] = true;
            if ( script_exists( _map[? "script" ] ) ) script_execute( _map[? "script" ] );
        }
    } else {
        _map[? "down" ] = false;
    }
}

return _json;
