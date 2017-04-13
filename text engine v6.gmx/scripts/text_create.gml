///text_create( string, max width, line height, halign, valign, default font, default colour, intro style, intro speed, outro style, outro speed )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _str         = argument0;
var _width_limit = argument1;
var _line_height = argument2;
var _halign      = argument3;
var _valign      = argument4;
var _def_font    = argument5;
var _def_colour  = argument6;
var _intro_style = argument7;
var _intro_speed = argument8;
var _outro_style = argument9;
var _outro_speed = argument10;

//Replace newlines with #
_str = string_replace_all( _str, chr(10)+chr(13), chr(13) );
_str = string_replace_all( _str, chr(13)+chr(10), chr(13) );
_str = string_replace_all( _str,         chr(10), chr(13) );
_str = string_replace_all( _str,             "#", chr(13) );
_str = string_replace_all( _str,            "\n", chr(13) );

draw_set_font( _def_font );
var _space_width = string_width( " " );
if ( !is_real( _line_height ) ) or ( _line_height < 0 ) var _line_height = string_height( chr(13) );

var _json = ds_map_create();

var _text_root_list         = ds_list_create();
var _hyperlink_map          = ds_map_create();
var _hyperlink_regions_list = ds_list_create();
var _model_sprite_list      = ds_list_create();
ds_map_add_list( _json, "lines"            , _text_root_list );
ds_map_add_map(  _json, "hyperlinks"       , _hyperlink_map );
ds_map_add_list( _json, "hyperlink regions", _hyperlink_regions_list );
_json[? "string"           ] = _str;
_json[? "default font"     ] = _def_font;
_json[? "default colour"   ] = _def_colour;
_json[? "width limit"      ] = _width_limit;
_json[? "line height"      ] = _line_height;
_json[? "halign"           ] = _halign;
_json[? "valign"           ] = _valign;
_json[? "length"           ] = 0;
_json[? "words"            ] = 0;
_json[? "width"            ] = 0;
_json[? "height"           ] = 0;
_json[? "left"             ] = 0;
_json[? "top"              ] = 0;
_json[? "right"            ] = 0;
_json[? "bottom"           ] = 0;
_json[? "intro style"      ] = _intro_style;
_json[? "intro max"        ] = 0;
_json[? "intro speed"      ] = _intro_speed;
_json[? "outro style"      ] = _outro_style;
_json[? "outro max"        ] = 0;
_json[? "outro speed"      ] = _outro_speed;
_json[? "transition timer" ] = 0;
_json[? "transition state" ] = text_state_intro;
_json[? "model"            ] = noone;
ds_map_add_list( _json, "model sprites", _model_sprite_list );

var _text_x = 0;
var _text_y = 0;

var _line_map = noone;
var _line_list = noone;
var _line_length = 0;

var _text_font      = _def_font;
var _text_colour    = _def_colour;
var _text_hyperlink = "";

//Use spaces as splitting points
var _sep_pos = string_length( _str ) + 1;
var _sep_prev_char = "";
var _sep_char = "";

var _char = " ";
var _pos = string_pos( _char, _str );
if ( _pos < _sep_pos ) and ( _pos > 0 ) {
    var _sep_char = _char;
    var _sep_pos = _pos;
}

var _char = chr(13);
var _pos = string_pos( _char, _str );
if ( _pos < _sep_pos ) and ( _pos > 0 ) {
    var _sep_char = _char;
    var _sep_pos = _pos;
}

var _char = "[";
var _pos = string_pos( _char, _str );
if ( _pos < _sep_pos ) and ( _pos > 0 ) {
    var _sep_char = _char;
    var _sep_pos = _pos;
}

var _char = "]";
var _pos = string_pos( _char, _str );
if ( _pos < _sep_pos ) and ( _pos > 0 ) {
    var _sep_char = _char;
    var _sep_pos = _pos;
}

while( string_length( _str ) > 0 ) {
    
    var _skip = false;
    
    var _substr_width = undefined;
    var _substr_height = undefined;
    
    var _substr_length = _sep_pos - 1;
    var _substr_sprite = noone;
    var _substr = string_copy( _str, 1, _substr_length );
    _str = string_delete( _str, 1, _sep_pos );
    
    //Command handling
    if ( !_skip ) {
        if ( _sep_prev_char == "[" ) and ( _sep_char == "]" ) {
            
            var _work_str = _substr + "|";
            
            var _pos = string_pos( "|", _work_str );
            var _parameters = undefined;
            var _count = 0;
            while( _pos > 0 ) {
                
                _parameters[_count] = string_copy( _work_str, 1, _pos - 1 );
                _count++;
                
                _work_str = string_delete( _work_str, 1, _pos );
                _pos = string_pos( "|", _work_str );
                
            }
            
            if ( _parameters[0] == "" ) {
                
                _skip = true;
                _text_font      = _def_font;
                _text_colour    = _def_colour;
                _text_hyperlink = "";
                draw_set_font( _text_font );
                
            } else {
                
                var _asset = asset_get_index( _parameters[0] );
                if ( _asset >= 0 ) {
                    
                    //Asset is a sprite...
                    if ( asset_get_type( _parameters[0] ) == asset_sprite ) {
                        
                        _substr_sprite = _asset;
                        _substr_width  = sprite_get_width(  _substr_sprite );
                        _substr_height = sprite_get_height( _substr_sprite );
                        _substr_length = 1;
                        
                    //Asset is a font...
                    } else if ( asset_get_type( _parameters[0] ) == asset_font ) {
                        
                        _skip = true;
                        _text_font = _asset;
                        draw_set_font( _text_font );
                    
                    //Asset is a colour..?
                    } else {
                        
                        _skip = true;
                        var _colour = text_colours( _parameters[0] );
                        if ( _colour != noone ) _text_colour = _colour;
                        
                    }
                
                //Not an asset
                } else {
                    
                    _skip = true;
                    if ( _parameters[0] == "/link" ) {
                        
                        _text_hyperlink = "";
                        
                    } else if ( _parameters[0] == "link" ) {
                        
                        if ( array_length_1d( _parameters ) >= 2 ) {
                            
                            _text_hyperlink = _parameters[1];
                            
                            var _map = _hyperlink_map[? _text_hyperlink ];
                            if ( _map == undefined ) {
                                
                                _map = ds_map_create();
                                ds_map_add_map( _hyperlink_map, _text_hyperlink, _map );
                                _map[? "over" ] = false;
                                _map[? "down" ] = false;
                                
                                if ( array_length_1d( _parameters ) >= 3 ) {
                                    _map[? "script name" ] = _parameters[2];
                                    _map[? "script"      ] = asset_get_index( _parameters[2] );
                                } else {
                                    _map[? "script name" ] = "";
                                    _map[? "script"      ] = asset_get_index( "" );
                                }
                                
                            }
                            
                        } else {
                            
                            _text_hyperlink = "";
                            
                        }
                        
                    } else {
                        
                        //Test if it's a colour
                        var _colour = text_colours( _parameters[0] );
                        if ( _colour != noone ) {
                            
                            _text_colour = _colour;
                            
                        //Test if it's a hexcode
                        } else {
                            
                            var _colour_string = string_upper( _parameters[0] );
                            if ( string_length( _colour_string ) <= 7 ) and ( ( string_copy( _colour_string, 1, 1 ) == "#" ) or ( string_copy( _colour_string, 1, 1 ) == "$" ) ) {
                                
                                var _hex = "0123456789ABCDEF";
                                var _red   = max( string_pos( string_copy( _colour_string, 3, 1 ), _hex )-1, 0 ) + ( max( string_pos( string_copy( _colour_string, 2, 1 ), _hex )-1, 0 ) << 4 );
                                var _green = max( string_pos( string_copy( _colour_string, 5, 1 ), _hex )-1, 0 ) + ( max( string_pos( string_copy( _colour_string, 4, 1 ), _hex )-1, 0 ) << 4 );
                                var _blue  = max( string_pos( string_copy( _colour_string, 7, 1 ), _hex )-1, 0 ) + ( max( string_pos( string_copy( _colour_string, 6, 1 ), _hex )-1, 0 ) << 4 );
                                _text_colour = make_colour_rgb( _red, _green, _blue );
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        } else {
            
            _substr_width  = string_width( _substr );
            _substr_height = string_height( _substr );
            
        }
        
    }
    
    //Element positioning
    if ( !_skip ) {
        
        //If we've run over the maximum width of the string
        if ( _substr_width + _text_x > _width_limit ) or ( _line_map == noone ) or ( _sep_prev_char == chr(13) ) {
            
            if ( _line_map != noone ) {
                
                _line_map[? "width"  ] = _text_x;
                _line_map[? "height" ] = _line_height;
                
                _text_x = 0;
                _text_y += _line_height;
                _line_length = 0;
                
            }
            
            _line_map = ds_map_create();
            _line_list = ds_list_create();
            
            ds_list_add( _text_root_list, _line_map ); ds_list_mark_as_map( _text_root_list, ds_list_size( _text_root_list ) - 1 );
            
            _line_map[? "x"      ] = 0;
            _line_map[? "y"      ] = _text_y;
            _line_map[? "width"  ] = 0;
            _line_map[? "height" ] = _line_height;
            _line_map[? "length" ] = 0;
            ds_map_add_list( _line_map, "words" , _line_list );
            
        }
        
        //Add a new word
        var _map = ds_map_create();
        _map[? "x"         ] = _text_x;
        _map[? "y"         ] = ( _line_height - _substr_height ) div 2;
        _map[? "width"     ] = _substr_width;
        _map[? "height"    ] = _substr_height;
        _map[? "string"    ] = _substr;
        _map[? "sprite"    ] = _substr_sprite;
        _map[? "length"    ] = _substr_length; //Include the separator character!
        _map[? "font"      ] = _text_font;
        _map[? "colour"    ] = _text_colour;
        _map[? "hyperlink" ] = _text_hyperlink;
        
        //If we've got a word with a hyperlink, add it to our list of hyperlink regions
        if ( _text_hyperlink != "" ) {
            var _region_map = ds_map_create();
            _region_map[? "x"         ] = _map[? "x"         ];
            _region_map[? "y"         ] = _map[? "y"         ] + _text_y;
            _region_map[? "width"     ] = _map[? "width"     ];
            _region_map[? "height"    ] = _map[? "height"    ];
            _region_map[? "hyperlink" ] = _map[? "hyperlink" ];
            _region_map[? "line"      ] = ds_list_size( _text_root_list )-1;
            ds_list_add( _hyperlink_regions_list, _region_map );
            ds_list_mark_as_map( _hyperlink_regions_list, ds_list_size( _hyperlink_regions_list )-1 );
        }
        
        //Add the word to the line list
        ds_list_add( _line_list, _map ); ds_list_mark_as_map( _line_list, ds_list_size( _line_list )-1 );
        
        _text_x += _substr_width;
        if ( _sep_char == " " ) {
            _text_x += _space_width; //Add spacing if the separation character is a space
            if ( _substr != "" ) _map[? "width" ] += _space_width;
        }
        
        _line_map[? "length" ] += _substr_length;
        if ( _substr_length > 0 ) _json[? "words" ]++;
        _json[? "length" ] += _substr_length;
        
    }
    
    //Find the next separator
    _sep_prev_char = _sep_char;
    _sep_char = "";
    _sep_pos = string_length( _str ) + 1;
    
    if ( _sep_prev_char != "[" ) {
        _char = " ";
        _pos = string_pos( _char, _str );
        if ( _pos < _sep_pos ) and ( _pos > 0 ) {
            _sep_char = _char;
            _sep_pos = _pos;
        }
    }
    
    var _char = chr(13);
    var _pos = string_pos( _char, _str );
    if ( _pos < _sep_pos ) and ( _pos > 0 ) {
        _sep_char = _char;
        _sep_pos = _pos;
    }

    var _char = "[";
    var _pos = string_pos( _char, _str );
    if ( _pos < _sep_pos ) and ( _pos > 0 ) {
        var _sep_char = _char;
        var _sep_pos = _pos;
    }
    
    var _char = "]";
    var _pos = string_pos( _char, _str );
    if ( _pos < _sep_pos ) and ( _pos > 0 ) {
        var _sep_char = _char;
        var _sep_pos = _pos;
    }
    
}

//Finish defining the last line
_line_map[? "width"  ] = _text_x;
_line_map[? "height" ] = _line_height;

//Textbox width and height
var _lines_size = ds_list_size( _text_root_list );

var _textbox_width = 0;
for( var _i = 0; _i < _lines_size; _i++ ) {
    var _line_map = _text_root_list[| _i ];
    _textbox_width = max( _textbox_width, _line_map[? "width" ] );
}

var _line_map = _text_root_list[| _lines_size - 1 ];
var _textbox_height = _line_map[? "y" ] + _line_map[? "height" ];
  
_json[? "width" ]  = _textbox_width;
_json[? "height" ] = _textbox_height;

var _hyperlink_region_size = ds_list_size( _hyperlink_regions_list );


//Figure out limits for transition animation depending on type
switch( _intro_style ) {
    case text_no_fade:       _json[? "intro max" ] = 1;                                 break;
    case text_fade:          _json[? "intro max" ] = 1;                                 break;
    case text_fade_per_char: _json[? "intro max" ] = _json[? "length" ];                break;
    case text_fade_per_word: _json[? "intro max" ] = _json[? "words" ];                 break;
    case text_fade_per_line: _json[? "intro max" ] = ds_list_size( _json[? "lines" ] ); break;
}

switch( _outro_style ) {
    case text_no_fade:       _json[? "outro max" ] = 1;                                 break;
    case text_fade:          _json[? "outro max" ] = 1;                                 break;
    case text_fade_per_char: _json[? "outro max" ] = _json[? "length" ];                break;
    case text_fade_per_word: _json[? "outro max" ] = _json[? "words" ];                 break;
    case text_fade_per_line: _json[? "outro max" ] = ds_list_size( _json[? "lines" ] ); break;
}


//Horizontal justification
if ( _halign == fa_left ) {
    
    _json[? "left" ]  = 0;
    _json[? "right" ] = _textbox_width;
    
} else if ( _halign == fa_center ) {
    
    _json[? "left" ]  = -_textbox_width div 2;
    _json[? "right" ] =  _textbox_width div 2;
    
    //Adjust word positions
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _line_map[? "width" ] div 2;
    }
    
    //Adjust hyperlink region positions
    for( var _i = 0; _i < _hyperlink_region_size; _i++ ) {
        var _region_map = _hyperlink_regions_list[| _i ];
        var _line_map = _text_root_list[| _region_map[? "line" ] ];
        _region_map[? "x" ] -= _line_map[? "width" ] div 2;
    }
    
} else if ( _halign == fa_right ) {
    
    _json[? "left" ]  = -_textbox_width;
    _json[? "right" ] = 0;
    
    //Adjust word positions
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _line_map[? "width" ];
    }
    
    //Adjust hyperlink region positions
    for( var _i = 0; _i < _hyperlink_region_size; _i++ ) {
        var _region_map = _hyperlink_regions_list[| _i ];
        var _line_map = _text_root_list[| _region_map[? "line" ] ];
        _region_map[? "x" ] -= _line_map[? "width" ];
    }
    
} else if ( _halign == fa_center_left ) {
    
    _json[? "left" ]  = -_textbox_width div 2;
    _json[? "right" ] =  _textbox_width div 2;
    
    //Adjust word positions
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _textbox_width div 2;
    }
    
    //Adjust hyperlink region positions
    for( var _i = 0; _i < _hyperlink_region_size; _i++ ) {
        var _region_map = _hyperlink_regions_list[| _i ];
        var _line_map = _text_root_list[| _region_map[? "line" ] ];
        _region_map[? "x" ] -= _textbox_width div 2;
    }
    
} else if ( _halign == fa_center_right ) {
    
    _json[? "left" ]  = -_textbox_width div 2;
    _json[? "right" ] =  _textbox_width div 2;
    
    //Adjust word positions
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _line_map[? "width" ] - _textbox_width div 2;
    }
    
    //Adjust hyperlink region positions
    for( var _i = 0; _i < _hyperlink_region_size; _i++ ) {
        var _region_map = _hyperlink_regions_list[| _i ];
        var _line_map = _text_root_list[| _region_map[? "line" ] ];
        _region_map[? "x" ] -= _line_map[? "width" ] - _textbox_width div 2;
    }
    
}

//Vertical justification
if ( _valign == fa_top ) {
    
    _json[? "top" ]    = 0;
    _json[? "bottom" ] = _textbox_height;

} else if ( _valign == fa_middle ) {
    
    _json[? "top" ]    = -_textbox_height div 2;
    _json[? "bottom" ] =  _textbox_height div 2;
    
    //Adjust word positions
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "y" ] -= _textbox_height div 2;
    }
    
    //Adjust hyperlink region positions
    for( var _i = 0; _i < _hyperlink_region_size; _i++ ) {
        var _region_map = _hyperlink_regions_list[| _i ];
        var _line_map = _text_root_list[| _region_map[? "line" ] ];
        _region_map[? "y" ] -= _textbox_height div 2;
    }
    
} else if ( _valign == fa_bottom ) {
    
    _json[? "top" ]    = -_textbox_height;
    _json[? "bottom" ] = 0;
    
    //Adjust word positions
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "y" ] -= _textbox_height;
    }
    
    //Adjust hyperlink region positions
    for( var _i = 0; _i < _hyperlink_region_size; _i++ ) {
        var _region_map = _hyperlink_regions_list[| _i ];
        var _line_map = _text_root_list[| _region_map[? "line" ] ];
        _region_map[? "y" ] -= _textbox_height;
    }
    
}








//Build precached text model
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
        var _str_x = _line_x + _word_map[? "x" ];
        var _str_y = _line_y + _word_map[? "y" ];
        var _sprite = _word_map[? "sprite" ];
        
        if ( _sprite != noone ) {
            
            var _sprite_map = ds_map_create();
            _sprite_map[? "x"      ] = _str_x + sprite_get_xoffset( _sprite );
            _sprite_map[? "y"      ] = _str_y + sprite_get_yoffset( _sprite );
            _sprite_map[? "sprite" ] = _sprite;
            
            ds_list_add( _model_sprite_list, _sprite_map );
            ds_list_mark_as_map( _model_sprite_list, ds_list_size( _model_sprite_list )-1 );
            
        } else {
            
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
        
        if ( _hyperlink_map[? _word_map[? "hyperlink" ] ] != undefined ) {
            
            var _word_w = _word_map[? "width" ];
            var _word_h = _word_map[? "height" ];
            
            d3d_model_vertex_texture_colour( _model,   _str_x        , _str_y+_word_h-1, 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x+_word_w, _str_y+_word_h-1, 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x        , _str_y+_word_h+1, 0,   0, 0,   _colour, 1 );
            
            d3d_model_vertex_texture_colour( _model,   _str_x+_word_w, _str_y+_word_h-1, 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x+_word_w, _str_y+_word_h+1, 0,   0, 0,   _colour, 1 );
            d3d_model_vertex_texture_colour( _model,   _str_x        , _str_y+_word_h+1, 0,   0, 0,   _colour, 1 );
            
        }
        
    }
    
}

draw_set_font( fnt_default );
draw_set_colour( c_black );

d3d_model_primitive_end( _model );
_json[? "model" ] = _model;

return _json;
