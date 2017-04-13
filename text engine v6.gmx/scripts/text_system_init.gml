///text_system_init( char min, chat max, surface size, padding, font, [font]... )

global.text_font_char_min  = argument[0];
global.text_font_char_max  = argument[1];
global.text_font_char_size = 1 + global.text_font_char_max - global.text_font_char_min;
global.text_font_json      = ds_map_create();

var _surface_size         = argument[2];
var _padding              = argument[3];

global.text_font_surface_width  = _surface_size;
global.text_font_surface_height = _surface_size;
var _surface = surface_create( global.text_font_surface_width, global.text_font_surface_height );

surface_set_target( _surface );
draw_clear_alpha( c_black, 0 );

draw_set_colour( c_white );
draw_rectangle( 0, 0, 1, 1, false );

var _surf_x           = 2 + _padding;
var _surf_y           = 0;
var _surf_line_height = 2 + _padding;

for( var _i = 4; _i < argument_count; _i++ ) {
    
    var _font = argument[_i];
    var _font_map = ds_map_create();
    ds_map_add_map( global.text_font_json, _font, _font_map );
    _font_map[? "name" ] = font_get_name( _font );
    var _uvs = undefined;
    
    draw_set_font( _font );
    
    for( var _index = 0; _index < global.text_font_char_size; _index++ ) {
        
        var _ord = _index + global.text_font_char_min;
        var _char = chr( _ord );
        
        var _char_w = string_width( _char );
        var _char_h = string_height( _char );
        
        if ( _surf_x + _char_w + _padding >= _surface_size ) {
            _surf_x = 0;
            _surf_y += _surf_line_height;
            _surf_line_height = 0;
        }
        
        _uvs[ _index, 0 ] = _surf_x;
        _uvs[ _index, 1 ] = _surf_y;
        _uvs[ _index, 2 ] = _char_w;
        _uvs[ _index, 3 ] = _char_h;
        
        draw_set_alpha( 1 );
        draw_text( _surf_x, _surf_y, _char );
        draw_set_alpha( 0.5 );
        draw_text( _surf_x, _surf_y, _char );
        
        _surf_x += _char_w + _padding;
        _surf_line_height = max( _surf_line_height, _char_h );
        
    }
    
    _font_map[? "uvs" ] = _uvs;
    
}

draw_set_alpha( 1 );
surface_reset_target();

global.text_font_sprite  = sprite_create_from_surface( _surface, 0, 0, global.text_font_surface_width, global.text_font_surface_height, false, false, 0, 0 );
global.text_font_texture = sprite_get_texture( global.text_font_sprite, 0 );
