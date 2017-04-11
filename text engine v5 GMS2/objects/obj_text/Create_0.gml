///Create
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _str = @"This is text.
[$9A23C1]This text is coloured with a hex code[].
[fnt_tnr_32]This is[] text [c_blue]in [fnt_verdana_32_bold]various [c_red][fnt_tnr_32]styles.[]
This is a [fnt_verdana_32_bold]line of text[] that is much longer than the (800 pixel) [fnt_verdana_32_bold]maximum width[].
[fnt_tnr_32_italics]It is also possible to insert images [link|unique name|example_do_bloop][spr_test][/link].[]
[link|another unique name|example_do_close]Click here to destroy this text[/link] [fnt_tnr_32](or on the grumpy pug [link|yet another unique name|example_do_close][spr_test_2][/link])[].";

text_json = text_create( _str, 800, 100, fa_center, fa_top, fnt_verdana_32, c_white, text_fade_per_line, 0.1, text_fade_per_line, 0.2 );
scrollbox = text_scrollbox_create( 830, 550, 30, 30, c_gray );

x = ( room_width  - scrollbox[? "width"  ] ) div 2;
y = ( room_height - scrollbox[? "height" ] ) div 2;

