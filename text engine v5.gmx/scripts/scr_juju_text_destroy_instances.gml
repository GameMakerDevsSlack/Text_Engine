///scr_juju_text_destroy_instances( json )

var _json = argument0;

var _instances = _json[? "instances" ];
var _size = ds_list_size( _instances );
for( var _i = 0; _i < _size; _i++ ) with( _instances[| _i ] ) instance_destroy();
