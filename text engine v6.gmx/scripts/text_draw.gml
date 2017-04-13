///text_draw( x, y, json )
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _old_alpha = draw_get_alpha();

var _x     = argument0;
var _y     = argument1;
var _json  = argument2;
if ( _json < 0 ) exit;

var _hyperlinks        = _json[? "hyperlinks" ];
var _hyperlink_regions = _json[? "hyperlink regions" ];

//shader_set( shd_text_alpha );
//shader_set_uniform_f( shader_get_uniform( shd_text_alpha, "u_fAlpha" ), draw_get_alpha() );

d3d_model_draw( _json[? "model" ], _x, _y, 0, global.text_font_texture );

var _sprite_list = _json[? "model sprites" ];
var _sprites_size = ds_list_size( _sprite_list );
for( var _i = 0; _i < _sprites_size; _i++ ) {
    
    var _sprite_map = _sprite_list[| _i ];
    var _sprite_x = _x + _sprite_map[? "x" ];
    var _sprite_y = _y + _sprite_map[? "y" ];
    
    draw_sprite( _sprite_map[? "sprite" ], -1, _sprite_x, _sprite_y );
    
}

var _regions = ds_list_size( _hyperlink_regions );
for( var _i = 0; _i < _regions; _i++ ) {
    
    var _region_map = _hyperlink_regions[| _i ];
    
    var _region_x = _x + _region_map[? "x" ];
    var _region_y = _y + _region_map[? "y" ];
    var _hyperlink_map = _hyperlinks[? _region_map[? "hyperlink" ] ];
    
    if ( _hyperlink_map[? "down" ] ) {
        draw_rectangle( _region_x, _region_y, _region_x + _region_map[? "width" ], _region_y + _region_map[? "height" ], false );
    }
    
}

//shader_reset();
