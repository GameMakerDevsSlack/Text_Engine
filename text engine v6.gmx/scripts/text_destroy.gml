///text_destroy( json )

var _json = argument0;

if ( _json >= 0 ) {
    if ( _json[? "vertex buffer" ] >= 0 ) vertex_delete_buffer( _json[? "vertex buffer" ] );
    ds_map_destroy( _json );
}

return noone;
