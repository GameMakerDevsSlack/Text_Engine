///scr_juju_dialogue_from_grid( grid, existing database )
//
//  Creates a dialogue database from the contents of a grid, to be used with scr_juju_dialogue() and related scripts.
//  
//  argument0:  The source grid. This is typically created from a .csv
//  argument1:  An existing database to add to. Use a blank string "" to create a new one.
//  return   :  Returns the index for the dialogue database (in actuality, a nested data structure).
//  
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

var inGrid = argument0;
var map = argument1;

var gridW = ds_grid_width( inGrid );
var gridH = ds_grid_height( inGrid );

if ( !ds_exists( map, ds_type_map ) ) map = ds_map_create();
lst_blocks = ds_list_create();

var xx, yy, i, blockOpen, val;

for( xx = 0; xx < gridW; xx++ ) {
    
    blockOpen = false;
    
    for( yy = 0; yy < gridH; yy++ ) {
        
        var val = ds_grid_get( inGrid, xx, yy );
        
        if ( val == "!!startBlock" ) or ( val == "!!sB" ) {
            
            if ( blockOpen ) ds_list_add( lst_blocks, yy );
            ds_list_add( lst_blocks, xx, yy );
            blockOpen = true;
            
        } else if ( val == "!!endBlock" ) or ( val == "!!eB" ) {
            
            if ( blockOpen ) ds_list_add( lst_blocks, yy );
            blockOpen = false;
            
        }
        
    }
}

if ( blockOpen ) ds_list_add( lst_blocks, yy + 1 );

var sX, sY, eY, tag, map_text, map_option, list, val, text;

while( !ds_list_empty( lst_blocks ) ) {
    
    sX = ds_list_find_value( lst_blocks, 0 );
    sY = ds_list_find_value( lst_blocks, 1 ) + 1;
    eY = ds_list_find_value( lst_blocks, 2 );
        
    repeat( 3 ) ds_list_delete( lst_blocks, 0 );

    for( yy = sY; yy < eY; yy++ ) {
        
        tag = ds_grid_get( inGrid, sX, yy );
        if ( string_copy( tag, 1, 2 ) != "//" ) {
            if ( scr_juju_string_remove_whitespace( tag ) != "" ) {
                
                map_text = ds_map_create();
                list = ds_list_create();
                
                text = "";
                j = yy;
                do {
                    text += ds_grid_get( inGrid, sX + 1, j );
                    j++;
                } until ( scr_juju_string_remove_whitespace( ds_grid_get( inGrid, sX, j ) ) != "" ) or ( j >= eY );
                
                ds_map_add( map, tag, map_text );
                ds_map_add( map_text, "tag", tag );
                ds_map_add( map_text, "text", text );
                ds_map_add( map_text, "options", list );
                
                i = yy;
                while ( scr_juju_string_remove_whitespace( ds_grid_get( inGrid, sX + 3, i ) ) != "" ) and ( i < j ) {
                    
                    map_option = ds_map_create();
                    ds_list_add( list, map_option );
                    
                    ds_map_add( map_option, "text", ds_grid_get( inGrid, sX + 3, i ) );
                    
                    val = ds_grid_get( inGrid, sX + 5, i );
                    if ( scr_juju_string_remove_whitespace( val ) != "" ) ds_map_add( map_option, "tag", val );
                    
                    val = ds_grid_get( inGrid, sX + 2, i );
                    if ( scr_juju_string_remove_whitespace( val ) != "" ) {
                        val = asset_get_index( val );
                        if ( val >= 0 ) ds_map_add( map_option, "check_script", val );
                    }
                    
                    val = ds_grid_get( inGrid, sX + 4, i );
                    if ( scr_juju_string_remove_whitespace( val ) != "" ) {
                        val = asset_get_index( val );
                        if ( val >= 0 ) ds_map_add( map_option, "execute_script", val );
                    }
                    
                    i++;
                    
                }
                
            }
        }
    }
}

ds_list_destroy( lst_blocks );

return map;
