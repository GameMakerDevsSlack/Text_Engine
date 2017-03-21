///scr_juju_text_init( delay, starting style, autosize width, line spacing )
//  
//  This script is called by scr_juju_text() and scr_juju_text_instant().
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadam
//  Juju on the GMC

//Parenting control
textParent = noone;
textSegmentIndex = 0;
textSegmentPos = 0;

//Typewriter variables
textPos = 0;
textTimer = 0;
if ( is_real( argument0 ) ) textDelay = argument0 else textDelay = 0;

//Set the default style
textStartStyle = string( argument1 );
if ( textStartStyle == "" ) textStartStyle = "GMdefault";
if ( !scr_juju_text_styles( textStartStyle ) ) {
    textStartStyle = "GMdefault";
    scr_juju_text_styles( textStartStyle );
}
textStartFont = scr_juju_font_get();
textStartColour = draw_get_colour();

//Set the size of the autosizing box
if ( is_real( argument2 ) ) textBoxWidth = argument2 else textBoxWidth = 9999999;

//Set the distance between lines of text
if ( is_real( argument3 ) ) textLineSpacing = argument3 else textLineSpacing = string_height( "#" );

//Set up data structures that describe the content, format and position of text segments
lst_string       = ds_list_create();
lst_string_style = ds_list_create();
lst_string_x     = ds_list_create();
lst_string_y     = ds_list_create();
