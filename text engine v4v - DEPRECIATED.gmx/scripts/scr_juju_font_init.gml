#define scr_juju_font_init
///scr_juju_font_init()
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

global.juju_font = -1;

#define scr_juju_font
///scr_juju_font( font )
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

scr_juju_font_set( argument0 );

#define scr_juju_font_get
///scr_juju_font_get()
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

return global.juju_font;

#define scr_juju_font_set
///scr_juju_font_set( font )
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

global.juju_font = argument0;
draw_set_font( argument0 );

#define scr_juju_font_find_modifier
///scr_juju_font_find_modifier( font, italic, bold )
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

/*
var suffix = "_";
if ( argument1 ) suffix += "i";
if ( argument2 ) suffix += "b";

var font = argument0;
var foundFont = font;

var fontName = font_get_name( font );

if ( suffix != "_" ) {
    fontName += suffix;
    foundFont = asset_get_index( fontName );
}

if ( foundFont < 0 ) return font else return foundFont;
*/

return argument[0];