///text_step( x, y, json, mouse x, mouse y )
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

var _text_limit  = _json[? "transition timer" ];
var _text_font   = _json[? "default font" ];
var _text_colour = _json[? "default colour" ];
var _hyperlinks  = _json[? "hyperlinks" ];

for( var _key = ds_map_find_first( _hyperlinks ); _key != undefined; _key = ds_map_find_next( _hyperlinks, _key ) ) {
    var _map = _hyperlinks[? _key ];
    _map[? "over" ] = false;
    _map[? "clicked" ] = false;
}

if ( _json[? "transition state" ] != text_state_visible ) exit;

var _lines = _json[? "lines" ];
var _lines_size = ds_list_size( _lines );
for( var _i = 0; _i < _lines_size; _i++ ) {
    
    var _line_map = _lines[| _i ];
    var _line_length = _line_map[? "length" ];
    
    var _line_x = _x + _line_map[? "x" ];
    var _line_y = _y + _line_map[? "y" ];
    
    var _words = _line_map[? "words" ];
    var _words_size = ds_list_size( _words );
    for( var _j = 0; _j < _words_size; _j++ ) {
        
        var _word_map = _words[| _j ];
        var _word_length = _word_map[? "length" ];
        
        var _word_hyperlink = _word_map[? "hyperlink" ];
        var _hyperlink_map = _hyperlinks[? _word_hyperlink ];
        
        if ( _word_map[? "sprite" ] != noone ) {
            
            var _sprite = _word_map[? "sprite" ];
            var _str_x = _line_x + _word_map[? "x" ];
            var _str_y = _line_y + _word_map[? "y" ];
            
            if ( _hyperlink_map != undefined ) and ( point_in_rectangle( _mouse_x, _mouse_y, _str_x, _str_y, _str_x + _word_map[? "width" ], _str_y + _word_map[? "height" ] ) ) {
                _hyperlink_map[? "over" ] = true;
            }
            
        } else {
            
            var _str = _word_map[? "string" ];
            var _str_x = _line_x + _word_map[? "x" ];
            var _str_y = _line_y + _word_map[? "y" ];
            
            if ( _hyperlink_map != undefined ) and ( point_in_rectangle( _mouse_x, _mouse_y, _str_x, _str_y, _str_x + _word_map[? "width" ], _str_y + _word_map[? "height" ] ) ) {
                _hyperlink_map[? "over" ] = true;
            }
            
        }
        
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
