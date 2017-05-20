//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/


if ( keyboard_check_pressed( vk_anykey ) and !keyboard_check_pressed( vk_space ) ) test_mode = ( test_mode + 1 ) mod 3;

if ( test_mode == 2 ) {
    
    //This script returns <noone> when the text has fully faded out
    var _result = text_scrollbox_step( scrollbox_x, scrollbox_y, scrollbox, scrollbox_focus_text, mouse_x, mouse_y, false );
    if ( _result < 0 ) {
		introduction_text_json = noone;
		scrollbox_focus_text = outro_text_json;
	}
    
    if ( os_browser != browser_not_a_browser ) { //Callbacks don't work properly in HTML5 due to obfuscation :(
        if ( text_test_for_click( scrollbox_focus_text, "unique name"  ) ) example_do_bork();
        if ( text_test_for_click( scrollbox_focus_text, "twinned link" ) ) example_do_close();
        if ( text_test_for_click( scrollbox_focus_text, "url"          ) ) example_open_url();
    }

}