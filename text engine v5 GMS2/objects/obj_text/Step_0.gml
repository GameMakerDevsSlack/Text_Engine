///Step
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

text_json = text_scrollbox_step( x, y, scrollbox, text_json, mouse_x, mouse_y, true );
if ( text_json < 0 ) {
    var _str = "Nothing more to see here!#Made by [link|url|example_open_url]@jujuadams";
    text_json = text_create( _str, 800, 100, fa_left, fa_top, fnt_verdana_32, c_white, text_fade_per_line, 0.1, text_fade_per_line, 0.2 );
}

if ( os_browser != browser_not_a_browser ) { //Callbacks don't work properly in HTML5 due to obfuscation :(
    if ( text_test_for_click( text_json, "unique name"             ) ) example_do_bloop();
    if ( text_test_for_click( text_json, "another unique name"     ) ) example_do_close();
    if ( text_test_for_click( text_json, "yet another unique name" ) ) example_do_close();
    if ( text_test_for_click( text_json, "url"                     ) ) example_open_url();
}

