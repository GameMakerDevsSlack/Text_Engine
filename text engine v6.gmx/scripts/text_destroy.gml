///text_destroy( json )

var _json = argument0;

if ( _json >= 0 ) {
    d3d_model_destroy( _json[? "model" ] );
    ds_map_destroy( _json );
}
