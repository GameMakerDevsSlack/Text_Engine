///text_scrollbox_destroy( scrollbox json )

var _scroll_json = argument0;

if ( surface_exists( _scroll_json[? "surface" ] ) ) surface_free( _scroll_json[? "surface" ] );
ds_map_destroy( _scroll_json );
