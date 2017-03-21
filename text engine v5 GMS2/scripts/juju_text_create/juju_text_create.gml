/// @desc juju_text_create
/// @param string
/// @param x
/// @param y
/// @param layer
/// @param object
/// @param default_font
/// @param max_width
/// @param line_height
/// @param halign
/// @param valign
/// @param default_colour

var _str         = argument0;
var _x           = argument1;
var _y           = argument2;
var _layer       = argument3;
var _obj         = argument4;
var _def_font    = argument5;
var _width_limit = argument6;
var _line_height = argument7;
var _halign      = argument8;
var _valign      = argument9;
var _def_colour  = argument10;

//Replace newlines with #
_str = string_replace_all( _str, chr(10)+chr(13), chr(13) );
_str = string_replace_all( _str, chr(13)+chr(10), chr(13) );
_str = string_replace_all( _str,         chr(10), chr(13) );
_str = string_replace_all( _str,             "#", chr(13) );
_str = string_replace_all( _str,            "\n", chr(13) );

with( instance_create_layer( _x, _y, _layer, _obj ) ) {
    
    draw_set_font( _def_font );
    var _space_width = string_width( " " );
    if ( !is_real( _line_height ) ) or ( _line_height < 0 ) var _line_height = string_height( chr(13) );
    
    text_string = _str;
    text_json = ds_map_create();
    
    var _text_root_list     = ds_list_create();
    var _text_instance_list = ds_list_create();
    ds_map_add_list( text_json, "lines"         , _text_root_list );
    ds_map_add_list( text_json, "instances"     , _text_instance_list );
    ds_map_add(      text_json, "string"        , _str );
    ds_map_add(      text_json, "default font"  , _def_font );
    ds_map_add(      text_json, "default colour", _def_colour );
    ds_map_add(      text_json, "width limit"   , _width_limit );
    ds_map_add(      text_json, "line height"   , _line_height );
    ds_map_add(      text_json, "halign"        , _halign );
    ds_map_add(      text_json, "valign"        , _valign );
    ds_map_add(      text_json, "length"        , 0 );
    ds_map_add(      text_json, "width"         , 0 );
    ds_map_add(      text_json, "height"        , 0 );
    ds_map_add(      text_json, "left"          , 0 );
    ds_map_add(      text_json, "top"           , 0 );
    ds_map_add(      text_json, "right"         , 0 );
    ds_map_add(      text_json, "bottom"        , 0 );
    
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
        
        var _substr_instance = noone;
        var _substr_object = noone;
        
        var _substr_length = _sep_pos - 1;
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
                    _text_font = _def_font;
                    _text_colour = _def_colour;
                    draw_set_font( _text_font );
                    
                } else {
                    
                    var _asset = asset_get_index( _parameters[0] );
                    if ( _asset >= 0 ) {
                        
                        if ( asset_get_type( _parameters[0] ) == asset_object ) {
                            
                            _substr_object = _asset;
                            _substr_instance = instance_create_layer( 0, 0, _layer, _substr_object );
                            ds_list_add( _text_instance_list, _substr_instance );
                            
                            _substr_instance.text_parent = id;
                            _substr_instance.text_parameters = _parameters;
                            _substr_width  = sprite_get_width(  _substr_instance.sprite_index );
                            _substr_height = sprite_get_height( _substr_instance.sprite_index );
                            
                            _substr_length = 1;
                            _text_x -= _space_width;
                            
                        } else if ( asset_get_type( _parameters[0] ) == asset_font ) {
                            
                            _skip = true;
                            _text_font = _asset;
                            draw_set_font( _text_font );
                            
                        } else {
                            
                            _skip = true;
                            var _colour = juju_text_colours( _parameters[0] );
                            if ( _colour != noone ) _text_colour = _colour;
                            
                        }
                        
                    } else {
                        
                        _skip = true;
                        var _colour = juju_text_colours( _parameters[0] );
                        if ( _colour != noone ) _text_colour = _colour;
                        
                    }
                    
                }
                
            } else {
                
                var _substr_width  = string_width( _substr );
                var _substr_height = string_height( _substr );
                
            }
            
        }
        
        //Element positioning
        if ( !_skip ) {
            
            //If we've run over the maximum width of the string
            if ( _substr_width + _text_x > _width_limit ) or ( _line_map == noone ) or ( _sep_prev_char == chr(13) ) {
                
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
            
            //Position any object created by the text
            if ( !instance_exists( _substr_instance ) ) {
                
                var _substr_x = _text_x;
                var _substr_y = ( _line_height - _substr_height )/2;
                
            } else {
                
                var _substr_x = _text_x + sprite_get_xoffset( _substr_instance.sprite_index );
                var _substr_y = ( _line_height - _substr_height )/2 + sprite_get_yoffset( _substr_instance.sprite_index );
                
            }
            
            //Add a new word
            var _map = ds_map_create();
            ds_map_add( _map, "x"       , _substr_x );
            ds_map_add( _map, "y"       , _substr_y );
            ds_map_add( _map, "width"   , _substr_width );
            ds_map_add( _map, "height"  , _substr_height );
            ds_map_add( _map, "string"  , _substr );
            ds_map_add( _map, "length"  , _substr_length + 1 ); //Include the separator character!
            ds_map_add( _map, "instance", _substr_instance );
            ds_map_add( _map, "object"  , _substr_object );
            ds_map_add( _map, "font"    , _text_font );
            ds_map_add( _map, "colour"  , _text_colour );
            
            //Add the word to the line list
            ds_list_add( _line_list, _map );
            ds_list_mark_as_map( _line_list, ds_list_size( _line_list ) - 1 );
            
            _text_x += _substr_width;
            if ( _substr_object == noone ) and ( _sep_char == " " ) _text_x += _space_width; //Add spacing if the separation character is a space
            
        }
        
        //Correction factor for commands
        //if ( _skip ) _text_x -= _space_width;
        
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
        
    text_json[? "width" ] = _textbox_width;
    text_json[? "height" ] = _textbox_height;
    
    
    
    
    //Horizontal justification
    if ( _halign == fa_left ) {
        
        text_json[? "left" ]  = 0;
        text_json[? "right" ] = _textbox_width;
        
    } else if ( _halign == fa_center ) {
        
        text_json[? "left" ]  = -_textbox_width/2;
        text_json[? "right" ] =  _textbox_width/2;
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _line_map[? "width" ]/2;
        }
        
    } else if ( _halign == fa_right ) {
        
        text_json[? "left" ]  = -_textbox_width;
        text_json[? "right" ] = 0;
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _line_map[? "width" ];
        }
        
    } else if ( _halign == fa_center_left ) {
        
        text_json[? "left" ]  = -_textbox_width/2;
        text_json[? "right" ] =  _textbox_width/2;
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _textbox_width/2;
        }
        
    } else if ( _halign == fa_center_right ) {
        
        text_json[? "left" ]  = -_textbox_width/2;
        text_json[? "right" ] =  _textbox_width/2;
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _line_map[? "width" ] - _textbox_width/2;
        }
        
    }
    
    //Vertical justification
    if ( _valign == fa_top ) {
        
        text_json[? "top" ]    = 0;
        text_json[? "bottom" ] = _textbox_height;
    
    } else if ( _valign == fa_middle ) {
        
        text_json[? "top" ]    = -_textbox_height/2;
        text_json[? "bottom" ] =  _textbox_height/2;
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "y" ] -= _textbox_height/2;
        }
        
    } else if ( _valign == fa_bottom ) {
        
        text_json[? "top" ]    = -_textbox_height;
        text_json[? "bottom" ] = 0;
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "y" ] -= _textbox_height;
        }
        
    }
    
    juju_text_position_instances( x, y, text_json );
    
    return id;
    
}