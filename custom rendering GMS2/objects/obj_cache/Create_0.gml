///Create

font_texture_width = 1024;
font_texture_height = 1024;
font_uvs_map = ds_map_create();
font_char_min = 32;
font_char_max = 127;
font_char_count = 1 + font_char_max - font_char_min;
font_background = noone;

var _surface = surface_create( font_texture_width, font_texture_height );
var _surface_x = 0;
var _surface_y = 0;
var _surface_line_height = 0;

surface_set_target( _surface );

draw_clear_alpha( c_white, 0 );
draw_set_colour( c_white );

for( var _font = 0; _font < 99999; _font++ ) {
    
    if ( !font_exists( _font ) ) continue;
    draw_set_font( _font );
    
    var _char_uvs = undefined;
    _char_uvs[ font_char_count, 4 ] = 0;
    font_uvs_map[? _font ] = _char_uvs;
    
    for( var _ord = font_char_min; _ord <= font_char_max; _ord++ ) {
        
        _char_uvs[ _ord - font_char_min, 4 ] = 0;
        
        var _index = _ord - font_char_min;
        var _char = chr( _ord );
        var _char_width = string_width( string_hash_to_newline(_char) );
        var _char_height = string_height( string_hash_to_newline(_char) );
        
        if ( _char_width <= 0 ) continue;
        
        if ( _surface_x + _char_width >= font_texture_width ) {
            _surface_x = 0;
            _surface_y += _surface_line_height;
            _surface_line_height = 0;
        }
        
        draw_text( _surface_x, _surface_y, string_hash_to_newline(_char) );
        
        _char_uvs[ _index, 0 ] = _surface_x;
        _char_uvs[ _index, 1 ] = _surface_y;
        _char_uvs[ _ord - font_char_min, 2 ] = _char_width;
        _char_uvs[ _ord - font_char_min, 3 ] = _char_height;
        
        _surface_x += _char_width;
        _surface_line_height = max( _surface_line_height, _char_height );
        
    }
    
}

surface_reset_target();

font_background = background_create_from_surface( _surface, 0, 0, font_texture_width, font_texture_height, false, false );
font_texture = background_get_texture( font_background );
surface_free( _surface );


model = d3d_model_create();

test_string = "Hello world!";

var _str = test_string;
var _font = fnt_tnr;
var _uvs = font_uvs_map[? _font ];
var _str_size = string_length( _str );
var _str_x = 0;

d3d_model_primitive_begin( model, pr_trianglelist );

for( var _i = 1; _i <= _str_size; _i++ ) {
    
    var _char = string_copy( _str, _i, 1 );
    var _ord = ord( _char );
    var _index = _ord - font_char_min;
    
    var _l = _uvs[ _index, 0 ] / font_texture_width;
    var _t = _uvs[ _index, 1 ] / font_texture_height;
    var _w = _uvs[ _index, 2 ];
    var _h = _uvs[ _index, 3 ];
    var _r = _l + _w / font_texture_width;
    var _b = _t + _h / font_texture_height;
    
    d3d_model_vertex_texture( model,   _str_x     ,  0, 0,   _l, _t );
    d3d_model_vertex_texture( model,   _str_x + _w,  0, 0,   _r, _t );
    d3d_model_vertex_texture( model,   _str_x     , _h, 0,   _l, _b );
    
    d3d_model_vertex_texture( model,   _str_x + _w,  0, 0,   _r, _t );
    d3d_model_vertex_texture( model,   _str_x + _w, _h, 0,   _r, _b );
    d3d_model_vertex_texture( model,   _str_x     , _h, 0,   _l, _b );
    
    _str_x += _w;
    
}

d3d_model_primitive_end( model );

