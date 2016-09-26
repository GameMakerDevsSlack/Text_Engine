///scr_juju_text_draw_event()
//  
//  This script should be placed in the Draw event of an object called "obj_juju_text".
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadam
//  Juju on the GMC

var oldColour = draw_get_colour();
var oldFont = scr_juju_font_get();

draw_set_alpha( image_alpha );
draw_set_valign( fa_middle );
draw_set_halign( fa_left );

scr_juju_text_styles( textStartStyle );

var size = ds_list_size( lst_string );
for( var i = 0; i < textSegmentIndex; i++ ) {
    
    var str   = ds_list_find_value( lst_string      , i );
    var style = ds_list_find_value( lst_string_style, i );
    var xx    = ds_list_find_value( lst_string_x    , i );
    var yy    = ds_list_find_value( lst_string_y    , i );
    
    if ( string_char_at( style, 1 ) != "!" ) scr_juju_text_styles( style );
    draw_text( x + xx, round( y + yy + textLineSpacing * 0.5 ), str );
    
}


var str   = ds_list_find_value( lst_string      , textSegmentIndex );
var style = ds_list_find_value( lst_string_style, textSegmentIndex );
var xx    = ds_list_find_value( lst_string_x    , textSegmentIndex );
var yy    = ds_list_find_value( lst_string_y    , textSegmentIndex );

if ( string_char_at( style, 1 ) != "!" ) scr_juju_text_styles( style );
draw_text( x + xx, round( y + yy + textLineSpacing * 0.5 ), string_copy( str, 1, textPos - textSegmentPos ) );


draw_set_colour( oldColour );
draw_set_valign( fa_top );
scr_juju_font_set( oldFont );
draw_set_alpha( 1 );
