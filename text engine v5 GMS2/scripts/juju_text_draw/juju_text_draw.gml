/// @desc juju_text_draw
/// @param x
/// @param y
/// @param json

var _x    = argument0;
var _y    = argument1;
var _json = argument2;

var _text_font   = _json[? "default font" ];
var _text_colour = _json[? "default colour" ];
draw_set_font( _text_font );
draw_set_colour( _text_colour );

var _lines    = _json[? "lines" ];
var _lines_size = ds_list_size( _lines );
for( var _i = 0; _i < _lines_size; _i++ ) {
    
    var _line_map = _lines[| _i ];
    
    var _line_x = _x + _line_map[? "x" ];
    var _line_y = _y + _line_map[? "y" ];
    
    var _words = _line_map[? "words" ];
    var _words_size = ds_list_size( _words );
    for( var _j = 0; _j < _words_size; _j++ ) {
        
        var _word_map = _words[| _j ];
        if ( _word_map[? "object" ] != noone ) continue;
        
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
        var _str_x = _line_x + _word_map[? "x" ];
        var _str_y = _line_y + _word_map[? "y" ];
        
        draw_text( _str_x, _str_y, _str );
        //draw_rectangle( _str_x, _str_y, _str_x + _word_map[? "width" ], _str_y + _word_map[? "height" ], true );
        
    }
    
    //draw_rectangle( _line_x, _line_y, _line_x + _line_map[? "width" ], _line_y + _line_map[? "height" ], true );
    
}

draw_set_font( -1 );
draw_set_colour( c_black );