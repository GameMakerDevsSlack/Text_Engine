///text_create_model( json )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _json  = argument0;
if ( _json < 0 ) exit;

var _model = d3d_model_create();
d3d_model_primitive_begin( _model, pr_trianglelist );

var _max_alpha = draw_get_alpha();

var _text_limit  = _json[? "transition timer" ];
var _text_font   = _json[? "default font" ];
var _text_colour = _json[? "default colour" ];

draw_set_font( _text_font );
draw_set_colour( _text_colour );
draw_set_halign( fa_left );
draw_set_valign( fa_top );



var _lines = _json[? "lines" ];
var _lines_size = ds_list_size( _lines );
for( var _i = 0; _i < _lines_size; _i++ ) {
    
    var _line_map = _lines[| _i ];
    var _line_length = _line_map[? "length" ];
    
    var _line_x = _line_map[? "x" ];
    var _line_y = _line_map[? "y" ];
    
    var _words = _line_map[? "words" ];
    var _words_size = ds_list_size( _words );
    for( var _j = 0; _j < _words_size; _j++ ) {
        
        var _word_map = _words[| _j ];
        var _word_length = _word_map[? "length" ];
        var _word_w      = _word_map[? "width" ];
        var _word_h      = _word_map[? "height" ];
        
        if ( _word_map[? "sprite" ] == noone ) {
            
            var _font     = _word_map[? "font" ];
            var _font_uvs = ds_map_find_value( global.text_font_json[? _font ], "uvs" );
            var _colour   = _word_map[? "colour" ];
            
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
            var _string_size = string_length( _str );
            
            var _char_x = _str_x;
            var _char_y = _str_y;
            for( var _k = 1; _k <= _string_size; _k++ ) {
                
                var _char = string_copy( _str, _k, 1 );
                var _ord = ord( _char ) - global.text_font_char_min;
                
                if ( _ord < 0 ) or ( _ord >= global.text_font_char_size ) continue;
                
                var _uv_l   = _font_uvs[ _ord, 0 ] / global.text_font_surface_width;
                var _uv_t   = _font_uvs[ _ord, 1 ] / global.text_font_surface_height;
                var _char_w = _font_uvs[ _ord, 2 ];
                var _char_h = _font_uvs[ _ord, 3 ];
                var _uv_r   = _uv_l + _char_w / global.text_font_surface_width;
                var _uv_b   = _uv_t + _char_h / global.text_font_surface_height;
                
                d3d_model_vertex_texture_colour( _model,   _char_x        , _char_y        , 0,   _uv_l, _uv_t,   _colour, 1 );
                d3d_model_vertex_texture_colour( _model,   _char_x+_char_w, _char_y        , 0,   _uv_r, _uv_t,   _colour, 1 );
                d3d_model_vertex_texture_colour( _model,   _char_x        , _char_y+_char_h, 0,   _uv_l, _uv_b,   _colour, 1 );
                
                d3d_model_vertex_texture_colour( _model,   _char_x+_char_w, _char_y        , 0,   _uv_r, _uv_t,   _colour, 1 );
                d3d_model_vertex_texture_colour( _model,   _char_x+_char_w, _char_y+_char_h, 0,   _uv_r, _uv_b,   _colour, 1 );
                d3d_model_vertex_texture_colour( _model,   _char_x        , _char_y+_char_h, 0,   _uv_l, _uv_b,   _colour, 1 );
                
                _char_x += _char_w;
                
            }
            
        }
        
        var _word_hyperlink = _word_map[? "hyperlink" ];
        var _hyperlink_map = _hyperlinks[? _word_hyperlink ];
        if ( _hyperlink_map != undefined ) {
            
            d3d_model_vertex_texture_colour( _model,   _str_x        , _str_y+_word_h  , 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x+_word_w, _str_y+_word_h  , 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x        , _str_y+_word_h+1, 0,   0, 0,   _colour, 1 );
            
            d3d_model_vertex_texture_colour( _model,   _str_x+_word_w, _str_y+_word_h  , 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x+_word_w, _str_y+_word_h+1, 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x        , _str_y+_word_h+1, 0,   0, 0,   _colour, 1 );
            
        }
        
    }
    
}

draw_set_font( fnt_default );
draw_set_colour( c_black );

d3d_model_primitive_end( _model );
return _model;
