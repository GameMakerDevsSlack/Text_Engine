///scr_juju_text_styles( tag )
//  
//  This script is fully customiseable by the developer and should be customised to add personality to the project.
//  Called by scr_juju_text_process() and scr_juju_text_draw_event().
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadam
//  Juju on the GMC
                
switch( argument0 ) {
    
    //Shorthand [] tag for resetting the font/colour to the starting style.
    case "":            { return scr_juju_text_styles( textStartStyle ); break; }
    
    //It's good form to fully define styles that are then used as starting styles for scr_juju_text() and scr_juju_dialogue()
    case "styleA":      { scr_juju_font_set( fnt_a ); draw_set_colour( make_colour_rgb( 40, 40, 40 ) ); break; }
    case "styleB":      { scr_juju_font_set( fnt_b ); draw_set_colour( make_colour_rgb( 40, 40, 40 ) ); break; }
    
    //Note that you really should be assigning custom colours to precomputed values stored in enums/macros/constants.
    case "red":         { draw_set_colour( make_colour_rgb( 230, 30, 40 ) ); break; }
    case "orange":      { draw_set_colour( c_orange ); break; }
    case "yellow":      { draw_set_colour( c_yellow ); break; }
    case "lime":        { draw_set_colour( c_lime ); break; }
    case "green":       { draw_set_colour( make_colour_rgb( 27, 156, 60 ) ); break; }
    case "blue":        { draw_set_colour( make_colour_rgb( 0, 121, 255 ) ); break; }
    case "fuchsia":     { draw_set_colour( c_fuchsia ); break; }
    case "purple":      { draw_set_colour( c_purple ); break; }
    
    //Individual font definitions. This will change the font without changing the colour.
    //It's annoying how you can't switch normal-bold-italic within the same font but hey ho.
    case "fontA":       { scr_juju_font_set( fnt_a ); break; }
    case "fontAbold":   { scr_juju_font_set( fnt_a_bold ); break; }
    case "fontAitalic": { scr_juju_font_set( fnt_a_italic ); break; }
    case "fontB":       { scr_juju_font_set( fnt_b ); break; }
    case "fontBitalic": { scr_juju_font_set( fnt_b_italic ); break; }
    
    //Handful of terminator tags.
    case "/colour":     { draw_set_colour( textStartColour ); break; }
    case "/color":      { draw_set_colour( textStartColour ); break; }
    case "/c":          { draw_set_colour( textStartColour ); break; }
    case "/font":       { scr_juju_font_set( textStartFont ); break; }
    case "/f":          { scr_juju_font_set( textStartFont ); break; }
    
    //Don't remove these two cases, they're used as failsafe styles.
    case "GMdefault":   { scr_juju_font_set( -1 ); draw_set_colour( c_black ); break; }
    default:            { scr_juju_font_set( -1 ); draw_set_colour( c_black ); show_debug_message( "scr_juju_text_styles: unknown tag! " + string( argument0 ) ); return false; }
    
}

return true;
