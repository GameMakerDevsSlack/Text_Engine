///scr_juju_csv_load( file, cell delimiter, text delimiter )
//  
//  Loads a .csv file, with a comma separator, into a ds_grid that is automatically sized to the data.
//  Useful for translations, dialogue trees, mods etc.
//  
//  Version 4r
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

//Collect the filename. You don't strictly have to do this but it's good practice for larger scripts in case you need to change things around
var file = argument0;
var cellDelimiter = argument1;
var textDelimiter = argument2;

var cellDelimiterOrd = ord( cellDelimiter );
var textDelimiterOrd = ord( textDelimiter );

//
var buffer = buffer_create( 1, buffer_grow, 1 );
buffer_load_ext( buffer, file, 0 );
buffer_seek( buffer, buffer_seek_start, 0 );

//Initialise width and height of the spreadsheet
var sheetWidth = 0;
var sheetHeight = 1;

//Create a list that'll store the entire contents of the file. I/O is slow but ds_list is pretty fast
var list = ds_list_create();

var prevVal = 0;
var nextVal = 0;
var val = 0;
var str = "";
var inText = false;
var grid = noone;

var size = buffer_get_size( buffer );
for( var i = 0; i < size; i++ ) {
    
    prevVal = val;
    var val = buffer_read( buffer, buffer_u8 );
    
    if ( val == 13 ) continue;
    
    if ( val == textDelimiterOrd ) {
        
        var nextVal = buffer_peek( buffer, buffer_tell( buffer ), buffer_u8 );
        
        if ( inText ) {
            if ( nextVal == textDelimiterOrd ) continue;
            if ( prevVal == textDelimiterOrd ) {
                str += textDelimiter;
                continue;
            }
        }
        
        inText = !inText;
        continue;
        
    }
    
    if ( inText ) and ( ( prevVal == 13 ) and ( val == 10 ) ) {   
        str += "#";
        continue;
    }
    
    if ( ( val == cellDelimiterOrd ) or ( ( prevVal == 13 ) and ( val == 10 ) ) ) and ( !inText ) {
        
        sheetWidth++;
        if ( grid == noone ) {
            grid = ds_grid_create( max( 6, sheetWidth ), sheetHeight );
            ds_grid_clear( grid, "" );
        } else ds_grid_resize( grid, max( sheetWidth, ds_grid_width( grid ) ), sheetHeight );
        
        ds_grid_set( grid, sheetWidth - 1, sheetHeight - 1, str );
        str = "";
        inText = false;
        
        if ( val == 10 ) {
            sheetWidth = 0;
            sheetHeight++;
        }
        
        continue;
    }
    
    str += chr( val );
    
}

//
buffer_delete( buffer );

sheetWidth = ds_grid_width( grid );
sheetHeight = ds_grid_height( grid );
for( var yy = 0; yy < sheetHeight; yy++ ) {
    for( var xx = 0; xx < sheetWidth; xx++ ) {
        var val = ds_grid_get( grid, xx, yy );
        if ( !is_string( val ) ) ds_grid_set( grid, xx, yy, "" );
    }
}

//Return the grid, ready for use elsewhere
return grid;
