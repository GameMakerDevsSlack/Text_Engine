///scr_juju_text_create( x, y, string, object, default font, max width, line height, halign, valign, default colour )

var _x           = argument0;
var _y           = argument1;
var _str         = argument2;
var _obj         = argument3;
var _def_font    = argument4;
var _width_limit = argument5;
var _line_height = argument6;
var _halign      = argument7;
var _valign      = argument8;
var _def_colour  = argument9;

//Replace newlines with #
_str = string_replace_all( _str, chr(10)+chr(13), chr(13) );
_str = string_replace_all( _str, chr(13)+chr(10), chr(13) );
_str = string_replace_all( _str, chr(10), " # " );
_str = string_replace_all( _str, chr(13), " # " );

//Space out command tags
_str = string_replace_all( _str, "[", " [" );
_str = string_replace_all( _str, "]", "] " );

//Tag a space onto the end so the loop find every word
_str += " ";

with( instance_create( _x, _y, _obj ) ) {
    
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
    
    var _text_x = 0;
    var _text_y = 0;
    
    var _line_map = noone;
    var _line_list = noone;
    
    var _text_font   = _def_font;
    var _text_colour = _def_colour;
    
    //Use spaces as splitting points
    var _pos = string_pos( " ", _str );
    while( _pos > 0 ) {
        
        var _skip = false;
        var _new_line = false;
        
        var _substr_instance = noone;
        var _substr_object = noone;
        
        var _substr_length = _pos - 1;
        //if ( _substr_length <= 0 ) _skip = true;
        var _substr = string_copy( _str, 1, _substr_length );
        _str = string_delete( _str, 1, _pos );
        
        //Command handling
        if ( !_skip ) {
            if ( string_copy( _substr, 1, 1 ) == "[" ) and ( string_copy( _substr, _substr_length, 1 ) == "]" ) {
                
                _substr = string_copy( _substr, 2, _substr_length - 2 );
                
                if ( _substr == "" ) {
                    
                    _skip = true;
                    _text_font = _def_font;
                    _text_colour = _def_colour;
                    draw_set_font( _text_font );
                    
                } else {
                    
                    var _asset = asset_get_index( _substr );
                    if ( _asset >= 0 ) {
                        
                        if ( asset_get_type( _substr ) == asset_object ) {
                            
                            _substr_object = _asset;
                            _substr_instance = instance_create( 0, 0, _substr_object );
                            ds_list_add( _text_instance_list, _substr_instance );
                            
                            _substr_instance.text_parent = id;
                            _substr_width  = sprite_get_width(  _substr_instance.sprite_index );
                            _substr_height = sprite_get_height( _substr_instance.sprite_index );
                            
                            _substr_length = 1;
                            _text_x -= _space_width;
                            
                        } else if ( asset_get_type( _substr ) == asset_font ) {
                            
                            _skip = true;
                            _text_font = _asset;
                            draw_set_font( _text_font );
                            
                        } else {
                            
                            _skip = true;
                            var _colour = scr_juju_text_colours( _substr );
                            if ( _colour != noone ) _text_colour = _colour;
                            
                        }
                        
                    } else {
                        
                        _skip = true;
                        var _colour = scr_juju_text_colours( _substr );
                        if ( _colour != noone ) _text_colour = _colour;
                        
                    }
                    
                }
                
            } else if ( _substr == "#" ) {
                
                _new_line = true;
                _substr_width = 0;
                _substr_height = 0;
                
            } else {
                
                var _substr_width  = string_width( _substr );
                var _substr_height = string_height( _substr );
                
            }
            
        }
        
        //Element positioning
        if ( !_skip ) {
            
            if ( _substr_width + _text_x > _width_limit ) or ( _line_map == noone ) or ( _new_line ) {
                
                if ( _line_map != noone ) {
                    
                    ds_map_replace( _line_map, "width" , _text_x - _space_width );
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
            
            if ( !instance_exists( _substr_instance ) ) {
                
                var _substr_x = _text_x;
                var _substr_y = ( _line_height - _substr_height )/2;
                
            } else {
                
                var _substr_x = _text_x + sprite_get_xoffset( _substr_instance.sprite_index );
                var _substr_y = ( _line_height - _substr_height )/2 + sprite_get_yoffset( _substr_instance.sprite_index );
                
            }
            
            var _map = ds_map_create();
            ds_map_add( _map, "x"       , _substr_x );
            ds_map_add( _map, "y"       , _substr_y );
            ds_map_add( _map, "width"   , _substr_width );
            ds_map_add( _map, "height"  , _substr_height );
            ds_map_add( _map, "string"  , _substr );
            ds_map_add( _map, "length"  , _substr_length + 1 ); //Include the space!
            ds_map_add( _map, "instance", _substr_instance );
            ds_map_add( _map, "object"  , _substr_object );
            ds_map_add( _map, "font"    , _text_font );
            ds_map_add( _map, "colour"  , _text_colour );
            
            ds_list_add( _line_list, _map );
            ds_list_mark_as_map( _line_list, ds_list_size( _line_list ) - 1 );
            
            if ( _substr_object == noone ) {
                if ( !_new_line ) _text_x += _substr_width + _space_width;
            } else {
                _text_x += _substr_width;
            }
            
        }
        
        if ( _skip ) _text_x -= _space_width;
        
        var _pos = string_pos( " ", _str );
        
    }
    
    //Finish defining the last line
    ds_map_replace( _line_map, "width" , _text_x - _space_width );
    ds_map_replace( _line_map, "height", _line_height );
    
    //Justification
    if ( _halign == fa_center ) {
        
        var _lines_size = ds_list_size( _text_root_list );
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _line_map[? "width" ]/2;
        }
        
    } else if ( _halign == fa_right ) {
        
        var _lines_size = ds_list_size( _text_root_list );
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _line_map[? "width" ];
        }
        
    } else if ( _halign == fa_center_left ) {
        
        var _lines_size = ds_list_size( _text_root_list );
        
        var _max_width = 0;
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _max_width = max( _max_width, _line_map[? "width" ] );
        }
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _max_width/2;
        }
        
    } else if ( _halign == fa_center_right ) {
        
        var _lines_size = ds_list_size( _text_root_list );
        
        var _max_width = 0;
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _max_width = max( _max_width, _line_map[? "width" ] );
        }
        
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "x" ] -= _line_map[? "width" ] - _max_width/2;
        }
        
    }
    
    if ( _valign == fa_middle ) {
        
        var _lines_size = ds_list_size( _text_root_list );
        var _last_line = _text_root_list[| _lines_size - 1 ];
        var _max_height = ( _line_map[? "y" ] + _line_map[? "height" ] )/2;
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "y" ] -= _max_height;
        }
        
    } else if ( _valign == fa_bottom ) {
        
        var _lines_size = ds_list_size( _text_root_list );
        var _last_line = _text_root_list[| _lines_size - 1 ];
        var _max_height = _line_map[? "y" ] + _line_map[? "height" ];
        for( var _i = 0; _i < _lines_size; _i++ ) {
            var _line_map = _text_root_list[| _i ];
            _line_map[? "y" ] -= _max_height;
        }
        
    }
    
    scr_juju_text_position_instances( x, y, text_json );
    
    return id;
    
}
