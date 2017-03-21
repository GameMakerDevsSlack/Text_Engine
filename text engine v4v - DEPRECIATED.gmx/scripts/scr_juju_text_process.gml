///scr_juju_text_process( string )
//  
//  This script is called by scr_juju_text() and scr_juju_text_instant().
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadam
//  Juju on the GMC

var newlineChar = "#";

//REFRESH DATA STRUCTURES
ds_list_clear( lst_string );
ds_list_clear( lst_string_style );
ds_list_clear( lst_string_x );
ds_list_clear( lst_string_y );



//FORMATTING PASS

//Find the number of tag brackets
var aBracket = string_count( "[", argument0 );
var bBracket = string_count( "]", argument0 );

//If tags aren't complete
if ( aBracket != bBracket ) {
    
    show_debug_message( "scr_juju_text_process: irregular or malformed formatting! " + string( argument0 ) );
    
    //Add the entire string, unprocessed, as a single segment
    ds_list_add( lst_string      , argument0 );
    ds_list_add( lst_string_style, textStartStyle );
    ds_list_add( lst_string_x    , 0 );
    ds_list_add( lst_string_y    , 0 );
    
//Valid formatting (probably)
} else {
    
    //Set the work string to whatever was sent to this script
    var str = argument0;
    
    //Grab the starting style
    var style = textStartStyle;
    
    var foundEscape = false;
    
    //Keep running over the string until there's nothing left or we exceed our iteration limit (which is probably because something's gone wrong...)
    var iterations = 0;
    do {
        iterations++;
        
        //Find the position of the next tag
        var tagOpenPos = string_pos( "[", str );
        
        //The next tag isn't at the front of the work string
        if ( tagOpenPos != 1 ) {
            
            //If there's no tag left in the work string
            if ( tagOpenPos == 0 ) {
                
                //Grab what's left and clean out the work string (this will break out of the do...until loop)
                var substr = str;
                str = "";
            
            //If the tag is further along the string
            } else {
                
                //Chop up the working string
                var substr = string_copy( str, 1, tagOpenPos - 1 );
                str = string_delete( str, 1, tagOpenPos - 1 );
            }
            
            if ( string_pos( "{}", substr ) > 0 ) {
                foundEscape = true;
                substr = string_replace( substr, "{}", "" );
            }
            
            //Submit this string segment
            ds_list_add( lst_string      , substr );
            ds_list_add( lst_string_style, style );
            ds_list_add( lst_string_x    , 0 );
            ds_list_add( lst_string_y    , 0 );
            
            if ( foundEscape ) {
                ds_list_add( lst_string      , str );
                ds_list_add( lst_string_style, style );
                ds_list_add( lst_string_x    , 0 );
                ds_list_add( lst_string_y    , 0 );
                break;
            }
            
        //The open tag marker is right at the front of the work string, ready to process
        } else {
            
            //Find the end of the tag
            var tagClosePos = string_pos( "]", str );
            
            //The tag text is the substring inbetween these two markers
            substr = string_copy( str, 2, tagClosePos - 2 );
            
            //Cut out the tag from the working string
            str = string_delete( str, 1, tagClosePos );
            
            if ( string_char_at( substr, 1 ) == "!" ) {
            
                //Submit this string segment
                ds_list_add( lst_string      , "" );
                ds_list_add( lst_string_style, substr );
                ds_list_add( lst_string_x    , 0 );
                ds_list_add( lst_string_y    , 0 );
                
                //show_message( style );
                
            } else {
                
                style = substr;
                
                //Submit this string segment
                ds_list_add( lst_string      , "" );
                ds_list_add( lst_string_style, style );
                ds_list_add( lst_string_x    , 0 );
                ds_list_add( lst_string_y    , 0 );
                
            }
            
        }
    
    } until ( str == "" ) or ( iterations >= 1000 );
    if ( iterations >= 1000 ) show_debug_message( "scr_juju_text_process: too many iterations (tags)! " + string( argument0 ) );

}



//NEWLINE STRIPPING

for( var i = 0; i < ds_list_size( lst_string ); i++ ) {
    
    var str   = ds_list_find_value( lst_string      , i );
    var style = ds_list_find_value( lst_string_style, i );
    
    //Try to find a newline character
    var newlinePosition = string_pos( newlineChar, str );
    
    if ( newlinePosition != 0 ) {
        
        //The next line is everything after the newline character
        var newStr = string_delete( str, 1, newlinePosition );
        
        //The old line is everything up to but not including the newline character
        var str = string_copy( str, 1, newlinePosition - 1 );
        
        //Change the old text for something shorter
        ds_list_replace( lst_string, i, str );
        
        //Add the remainder of the string to a new segment at a different y-coordinate but to the hard left
        ds_list_insert( lst_string      , i + 1, newStr );
        ds_list_insert( lst_string_style, i + 1, style );
        ds_list_insert( lst_string_x    , i + 1, 0 );
        ds_list_insert( lst_string_y    , i + 1, textLineSpacing );
        
    }
}

//AUTOSIZE AND POSITIONING

//Set up the "carriage" to the top-left
var carriageX = 0;
var carriageY = 0;
var maxWidth = 0;

//Iterate over all string segments
for( var i = 0; i < ds_list_size( lst_string ); i++ ) {
    
    var newStr = "";
    
    var str   = ds_list_find_value( lst_string      , i );
    var style = ds_list_find_value( lst_string_style, i );
    var yy    = ds_list_find_value( lst_string_y    , i );
    
    //Set the internal font. This ensures string_width() returns an accurate value
    if ( string_char_at( style, 1 ) != "!" ) scr_juju_text_styles( style );
    
    //Set the position of this string to where the carriage is
    if ( yy != 0 ) {
        carriageX = 0;
        carriageY += yy;
    }
    
    ds_list_replace( lst_string_x, i, carriageX );
    ds_list_replace( lst_string_y, i, carriageY );
    
    //Tidy up the start of new lines, removing any superfluous spaces
    if ( carriageX == 0 ) while ( string_char_at( str, 1 ) == " " ) str = string_delete( str, 1, 1 );
    
    //Keep running over the string until there's nothing left or we exceed our iteration limit (which is probably because something's gone wrong...)
    var iterations = 0;
    do {
        iterations++;
        
        //Find the position of the next convenient splitting point
        var spacePosition = string_pos( " ", str );
        
        //If there's no splitting point, choose the end of the string
        if ( spacePosition == 0 ) spacePosition = string_length( str );
        
        //Measure the size of the substring
        var substr = string_copy( str, 1, spacePosition );
        var substrWidth = string_width( substr );
        
        
        //If the substring, when added onto the end of the carriage positon, exceed the width of the textbox...
        if ( carriageX + substrWidth >= textBoxWidth ) and !( ( substrWidth > textBoxWidth ) and ( carriageX <= 0 ) ) {
            
            //Add a new segment
            ds_list_insert( lst_string      , i + 1, str );
            ds_list_insert( lst_string_style, i + 1, style );
            ds_list_insert( lst_string_x    , i + 1, 0 );
            ds_list_insert( lst_string_y    , i + 1, textLineSpacing );
            
            //And clear the work string
            str = "";
        
        //If the substring doesn't exceed the textbox's width...
        } else {
            
            //Update the maximum width for this text snippet
            maxWidth = max( maxWidth, carriageX + substrWidth );
            
            //Remove the substring from the work string
            str = string_delete( str, 1, spacePosition );
            
            //Add the substring onto the output string
            newStr += substr;
            
            //Increment the carriage position
            carriageX += substrWidth;
            
        }
        
    } until ( str == "" ) or ( iterations >= 1000 );
    if ( iterations >= 1000 ) show_debug_message( "scr_juju_text_process: too many iterations (autosize)! " + string( argument0 ) );
    
    //Replace the string segment in the list with the output string
    ds_list_replace( lst_string, i, newStr );
    
}

//Set the font to our starting style
scr_juju_text_styles( textStartStyle );
var size = ds_list_size( lst_string ) - 1;
var text = ds_list_find_value( lst_string, size );
if ( text == "" ) text = newlineChar;
textWidth  = maxWidth;
textHeight = ds_list_find_value( lst_string_y, size ) + string_height( text );

//Reset the font
scr_juju_text_styles( "GMdefault" );



//SUM STRING SEGMENT LENGTHS
textLength = 0;
var size = ds_list_size( lst_string );
for( var i = 0; i < size; i++ ) {
    var str = ds_list_find_value( lst_string, i );
    textLength += string_length( str );
}
