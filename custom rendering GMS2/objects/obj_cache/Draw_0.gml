///Draw

draw_background( font_background, 0, 0 );

for( var _font = ds_map_find_first( font_uvs_map ); _font != undefined; _font = ds_map_find_next( font_uvs_map, _font ) ) {
    
    var _uvs = font_uvs_map[? _font ];
    for( var _i = 0; _i < font_char_count; _i++ ) {
        
        var _l = _uvs[ _i, 0 ];
        var _t = _uvs[ _i, 1 ];
        var _r = _l + _uvs[ _i, 2 ];
        var _b = _t + _uvs[ _i, 3 ];
        
        draw_rectangle( _l, _t, _r, _b, true );
        
    }
    
}

draw_set_colour( c_white );

d3d_model_draw( model, 0, 200, 0, font_texture );
draw_text( 0, 300, string_hash_to_newline(test_string) );

