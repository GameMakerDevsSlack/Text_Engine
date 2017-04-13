///text_destroy( json )

var _json = argument0;

if ( _json >= 0 ) {
    if ( _json[? "model" ] >= 0 ) d3d_model_destroy( _json[? "model" ] );
    if ( surface_exists( _json[? "surface" ] ) ) surface_free( _json[? "surface" ] );
    ds_map_destroy( _json );
}
