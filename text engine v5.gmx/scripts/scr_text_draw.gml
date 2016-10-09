///scr_text_draw( x, y, json )

var _x    = argument0;
var _y    = argument1;
var _json = argument2;

var _def_font = _json[? "default font" ];

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
        
        var _str = _word_map[? "string" ];
        var _str_x = _line_x + _word_map[? "x" ];
        var _str_y = _line_y + _word_map[? "y" ];
        
        draw_text( _str_x, _str_y, _str );
        
    }
    
}
