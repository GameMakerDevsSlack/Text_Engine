///scr_juju_gamepads_crude_any_connected()

var size = gamepad_get_device_count();
for( var i = 0; i < size; i++ ) if ( gamepad_is_connected( i ) ) return true;
return false;
