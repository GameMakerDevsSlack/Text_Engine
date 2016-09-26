///scr_juju_gamepads_crude_any_button_released( buttonIndex )

var size = gamepad_get_device_count();
for( var i = 0; i < size; i++ ) {
    if ( gamepad_is_connected( i ) ) {
        if ( gamepad_button_check_released( i, argument0 ) ) return true;
    }
}

return false;
