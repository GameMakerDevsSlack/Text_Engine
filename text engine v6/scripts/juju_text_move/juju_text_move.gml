/// @desc juju_text_move
/// @param instance
/// @param x
/// @param y

var _text_inst = argument0;
var _x         = argument1;
var _y         = argument2;

with( _text_inst ) {
    
    var _dx = _x - x;
    var _dy = _y - y;
    
    x = _x;
    y = _y;
    
    var _text_instance_list = text_json[? "instances" ];
    
    var _size = ds_list_size( _text_instance_list );
    for( var _i = 0; _i < _size; _i++ ) {
        
        var _inst = _text_instance_list[| _i ];
        with( _inst ) {
            x += _dx;
            y += _dy;
        }
        
    }
    
}