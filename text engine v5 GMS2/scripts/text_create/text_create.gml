/// @param string
/// @param default_font
/// @param max_width
/// @param line_height
/// @param halign
/// @param valign
/// @param default_colour
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _str         = argument0;
var _def_font    = argument1;
var _width_limit = argument2;
var _line_height = argument3;
var _halign      = argument4;
var _valign      = argument5;
var _def_colour  = argument6;

//Replace newlines with #
_str = string_replace_all( _str, chr(10)+chr(13), chr(13) );
_str = string_replace_all( _str, chr(13)+chr(10), chr(13) );
_str = string_replace_all( _str,         chr(10), chr(13) );
_str = string_replace_all( _str,             "#", chr(13) );
_str = string_replace_all( _str,           "\\n", chr(13) );

draw_set_font( _def_font );
var _space_width = string_width( string_hash_to_newline(" ") );
if ( !is_real( _line_height ) ) or ( _line_height < 0 ) var _line_height = string_height( string_hash_to_newline(chr(13)) );

var _json = ds_map_create();

var _text_root_list     = ds_list_create();
ds_map_add_list( _json, "lines"         , _text_root_list );
ds_map_add(      _json, "string"        , _str );
ds_map_add(      _json, "default font"  , _def_font );
ds_map_add(      _json, "default colour", _def_colour );
ds_map_add(      _json, "width limit"   , _width_limit );
ds_map_add(      _json, "line height"   , _line_height );
ds_map_add(      _json, "halign"        , _halign );
ds_map_add(      _json, "valign"        , _valign );
ds_map_add(      _json, "length"        , 0 );
ds_map_add(      _json, "width"         , 0 );
ds_map_add(      _json, "height"        , 0 );
ds_map_add(      _json, "left"          , 0 );
ds_map_add(      _json, "top"           , 0 );
ds_map_add(      _json, "right"         , 0 );
ds_map_add(      _json, "bottom"        , 0 );

var _text_x = 0;
var _text_y = 0;

var _line_map = noone;
var _line_list = noone;

var _text_font   = _def_font;
var _text_colour = _def_colour;

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
    var _substr = string_copy( _str, 1, _substr_length );
    _str = string_delete( _str, 1, _sep_pos );
    
    var _substr_sprite = noone;
    
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
                _text_font = _def_font;
                _text_colour = _def_colour;
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
                    
                } else {
                    
                    _skip = true;
                    var _colour = text_colours( _parameters[0] );
                    if ( _colour != noone ) _text_colour = _colour;
                    
                }
                
            }
            
        } else {
            
            _substr_width  = string_width( string_hash_to_newline(_substr) );
            _substr_height = string_height( string_hash_to_newline(_substr) );
            
        }
        
    }
    
    //Element positioning
    if ( !_skip ) {
        
        //If we've run over the maximum width of the string
        if ( _substr_width + _text_x > _width_limit ) or ( _line_map == noone ) or ( _sep_prev_char == chr(13) ) {
            
            if ( _substr_sprite != noone ) show_message( "5  " + sprite_get_name( _substr_sprite ) + ":" + string( _substr_width ) );
            
            if ( _line_map != noone ) {
                
                ds_map_replace( _line_map, "width" , _text_x );
                ds_map_replace( _line_map, "height", _line_height );
                
                _text_x = 0;
                _text_y += _line_height;
                
            }
            
            _line_map = ds_map_create();
            _line_list = ds_list_create();
            
            ds_list_add( _text_root_list, _line_map );
            ds_list_mark_as_map( _text_root_list, ds_list_size( _text_root_list ) - 1 );
            
            ds_map_add(      _line_map, "x"     , 0 );
            ds_map_add(      _line_map, "y"     , _text_y );
            ds_map_add(      _line_map, "width" , 0 );
            ds_map_add(      _line_map, "height", _line_height );
            ds_map_add_list( _line_map, "words" , _line_list );
            
        }
        
        //Add a new word
        var _map = ds_map_create();
        ds_map_add( _map, "x"       , _text_x );
        ds_map_add( _map, "y"       , ( _line_height - _substr_height ) div 2 );
        ds_map_add( _map, "width"   , _substr_width );
        ds_map_add( _map, "height"  , _substr_height );
        ds_map_add( _map, "string"  , _substr );
        ds_map_add( _map, "sprite"  , _substr_sprite );
        ds_map_add( _map, "length"  , _substr_length + 1 ); //Include the separator character!
        ds_map_add( _map, "font"    , _text_font );
        ds_map_add( _map, "colour"  , _text_colour );
        
        //Add the word to the line list
        ds_list_add( _line_list, _map );
        ds_list_mark_as_map( _line_list, ds_list_size( _line_list ) - 1 );
        
        _text_x += _substr_width;
        if ( _sep_char == " " ) _text_x += _space_width; //Add spacing if the separation character is a space
        
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
ds_map_replace( _line_map, "width" , _text_x );
ds_map_replace( _line_map, "height", _line_height );

//Textbox width and height
var _lines_size = ds_list_size( _text_root_list );

var _textbox_width = 0;
for( var _i = 0; _i < _lines_size; _i++ ) {
    var _line_map = _text_root_list[| _i ];
    _textbox_width = max( _textbox_width, _line_map[? "width" ] );
}

var _line_map = _text_root_list[| _lines_size - 1 ];
var _textbox_height = _line_map[? "y" ] + _line_map[? "height" ];
    
_json[? "width" ] = _textbox_width;
_json[? "height" ] = _textbox_height;




//Horizontal justification
if ( _halign == fa_left ) {
    
    _json[? "left" ]  = 0;
    _json[? "right" ] = _textbox_width;
    
} else if ( _halign == fa_center ) {
    
    _json[? "left" ]  = -_textbox_width div 2;
    _json[? "right" ] =  _textbox_width div 2;
    
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _line_map[? "width" ] div 2;
    }
    
} else if ( _halign == fa_right ) {
    
    _json[? "left" ]  = -_textbox_width;
    _json[? "right" ] = 0;
    
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _line_map[? "width" ];
    }
    
} else if ( _halign == fa_center_left ) {
    
    _json[? "left" ]  = -_textbox_width div 2;
    _json[? "right" ] =  _textbox_width div 2;
    
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _textbox_width div 2;
    }
    
} else if ( _halign == fa_center_right ) {
    
    _json[? "left" ]  = -_textbox_width div 2;
    _json[? "right" ] =  _textbox_width div 2;
    
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "x" ] -= _line_map[? "width" ] - _textbox_width div 2;
    }
    
}

//Vertical justification
if ( _valign == fa_top ) {
    
    _json[? "top" ]    = 0;
    _json[? "bottom" ] = _textbox_height;

} else if ( _valign == fa_middle ) {
    
    _json[? "top" ]    = -_textbox_height div 2;
    _json[? "bottom" ] =  _textbox_height div 2;
    
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "y" ] -= _textbox_height div 2;
    }
    
} else if ( _valign == fa_bottom ) {
    
    _json[? "top" ]    = -_textbox_height;
    _json[? "bottom" ] = 0;
    
    for( var _i = 0; _i < _lines_size; _i++ ) {
        var _line_map = _text_root_list[| _i ];
        _line_map[? "y" ] -= _textbox_height;
    }
    
}

return _json;