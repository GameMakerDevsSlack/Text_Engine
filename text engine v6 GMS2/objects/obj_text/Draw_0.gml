//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

draw_set_colour( c_white );
draw_set_font( fnt_consolas );

switch( test_mode ) {
    case 0:
        draw_text( 5, 5, "CUSTOM" );
        var _timer = get_timer();
        text_draw( 15, 40, lorem_ipsum_json, 0.5 + 0.5*dsin( current_time/150 ), 20 );
        shader_reset();
        _timer = get_timer() - _timer;
    break;
    case 1:
        draw_text( 5, 5, "NATIVE" );
        var _sep = string_height( chr(13) );
        var _timer = get_timer();
        draw_text_ext( 15, 40, lorem_ipsum_string, _sep, 800 );
        _timer = get_timer() - _timer;
    break;
    case 2:
        draw_text( 5, 5, "SCROLLBOX" );
        var _timer = get_timer();
        text_scrollbox_draw( scrollbox_x, scrollbox_y, scrollbox, scrollbox_focus_text );
        _timer = get_timer() - _timer;
    break;
}


test_smoothed_timer = lerp( test_smoothed_timer, _timer, 0.008 );
draw_text( 200, 5, "render time =" + string_format( _timer, 4, 0 ) + "us // smoothed = " + string_format( test_smoothed_timer, 4, 0 ) + "us" );
draw_set_font( fnt_default );