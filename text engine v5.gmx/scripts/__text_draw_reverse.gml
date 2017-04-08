///text_draw_reverse( x, y, json, debug )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _x     = argument0;
var _y     = argument1;
var _json  = argument2;
var _debug = argument3;

var _max_alpha = draw_get_alpha();

var _text_limit  = _json[? "transition timer" ];
var _text_font   = _json[? "default font" ];
var _text_colour = _json[? "default colour" ];
var _outro_style = _json[? "outro style" ];

draw_set_font( _text_font );
draw_set_colour( _text_colour );
draw_set_halign( fa_right );
draw_set_valign( fa_top );
if ( _outro_style == text_fade ) draw_set_alpha( _max_alpha * clamp( _text_limit, 0, 1 ) );

var _lines    = _json[? "lines" ];
var _lines_size = ds_list_size( _lines );
for( var _i = _lines_size-1; _i >= 0; _i-- ) {
    
    var _line_map = _lines[| _i ];
    var _line_length = _line_map[? "length" ];
    
    if ( _outro_style == text_fade_per_line ) {
        draw_set_alpha( _max_alpha * clamp( _text_limit, 0, 1 ) );
        if ( _text_limit <= 0 ) break;
    }
    
    var _line_x = _x + _line_map[? "x" ];
    var _line_y = _y + _line_map[? "y" ];
    
    var _words = _line_map[? "words" ];
    var _words_size = ds_list_size( _words );
    for( var _j = _words_size-1; _j >= 0; _j-- ) {
        
        var _word_map = _words[| _j ];
        var _word_length = _word_map[? "length" ];
        
        if ( _outro_style == text_fade_per_word ) {
            draw_set_alpha( _max_alpha * clamp( _text_limit, 0, 1 ) );
            if ( _text_limit <= 0 ) break;
        }
        
        if ( _word_map[? "sprite" ] != noone ) {
            
            var _sprite = _word_map[? "sprite" ];
            var _str_x = _line_x + _word_map[? "x" ];
            var _str_y = _line_y + _word_map[? "y" ];
            
            draw_sprite_ext( _word_map[? "sprite" ], 0, _str_x + sprite_get_xoffset( _sprite ), _str_y + sprite_get_yoffset( _sprite ), 1, 1, 0, c_white, draw_get_alpha() );
            if ( _debug ) draw_rectangle( _str_x, _str_y, _str_x + _word_map[? "width" ], _str_y + _word_map[? "height" ], true );
            
        } else {
            
            var _font   = _word_map[? "font" ];
            var _colour = _word_map[? "colour" ];
            
            if ( _font != _text_font   ) {
                _text_font = _font;
                draw_set_font( _text_font );
            }
            if ( _colour != _text_colour ) {
                _text_colour = _colour;
                draw_set_colour( _text_colour );
            }
            
            var _str = _word_map[? "string" ];
            var _str_x = _line_x + _word_map[? "x" ] + string_width( _str );
            var _str_y = _line_y + _word_map[? "y" ];
            
            if ( _outro_style == text_fade_per_char ) {
                var _string_limit = min( string_length( _str ) + 1, _text_limit );
                _str = string_copy( _str, string_length( _str ) - _string_limit + 2, _string_limit );
            }
            
            draw_text( _str_x, _str_y, _str );
            if ( _debug ) draw_rectangle( _str_x, _str_y, _str_x + _word_map[? "width" ], _str_y + _word_map[? "height" ], true );
            
        }
        
        if ( _outro_style == text_fade_per_char ) {
            _text_limit -= _word_length;
            if ( _text_limit <= 0 ) break;
        }
        
        if ( _outro_style == text_fade_per_word ) and ( _word_length > 0 ) _text_limit--;
        
    }
    
    if ( _debug ) draw_rectangle( _line_x, _line_y, _line_x + _line_map[? "width" ], _line_y + _line_map[? "height" ], true );
    if ( _outro_style == text_fade_per_line ) _text_limit--;
    
}

if ( _debug ) draw_rectangle( x + _json[? "left" ], y + _json[? "top" ], x + _json[? "right" ], y + _json[? "bottom" ], true );

draw_set_font( fnt_default );
draw_set_colour( c_black );
draw_set_alpha( _max_alpha );
