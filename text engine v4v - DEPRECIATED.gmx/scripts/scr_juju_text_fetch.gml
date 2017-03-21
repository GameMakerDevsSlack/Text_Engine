///scr_juju_text_fetch( database, tag )
//  
//  Grabs some text from a database as indicated by a tag.
//  
//  
//  argument0:  Dialogue database to use e.g. as created by scr_juju_dialogue_grid()
//  argument1:  The tag to load content from. This references tags in the database associated with the box instance via scr_juju_dialogue_box().
//  return   :  Text, as found in the database. If no text is found, the function returns an empty string.
//
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

var map_db = argument0;
var tag = argument1;

var map = ds_map_find_value( map_db, tag );
if ( is_undefined( map ) ) {
    show_debug_message( "scr_juju_dialogue_populate: tag unrecognised! " + string( tag ) );
    return "";
}

var text = ds_map_find_value( map, "text" );
if ( is_undefined( text ) ) {
    show_debug_message( "scr_juju_dialogue_db_find_text: no text found! " + string( tag ) );
    return "";
} else return text;
