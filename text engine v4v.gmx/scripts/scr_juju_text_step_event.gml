///scr_juju_text_step_event()
//  
//  This script should be placed in the Step event of an object called "obj_juju_text".
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadam
//  Juju on the GMC

if ( textPos < textLength ) {
    
    if ( textDelay == 0 ) {
        textPos = textLength;
    } else if ( textDelay > 0 ) {
        textTimer++;
    }
    
    if ( textTimer >= textDelay ) and ( textDelay >= 0 ) {
        
        if ( textDelay > 0 ) and ( textDelay < 1 ) textPos += floor( 1 / textDelay ) else textPos++;
        textPos = min( textPos, textLength );
        scr_juju_text_reveal();
        textTimer = 0;
        
    }
}

var prevIndex = textSegmentIndex;

var size = ds_list_size( lst_string );
for( var i = prevIndex + 1; i < size; i++ ) {
    
    var length = string_length( ds_list_find_value( lst_string, i - 1 ) );
    
    if ( textSegmentPos + length <= textPos ) {
        textSegmentIndex = i;
        textSegmentPos += length;
    } else {
        break;
    }
    
}

for( var i = prevIndex; i < textSegmentIndex; i++ ) {
    
    var style = ds_list_find_value( lst_string_style, i );
    if ( string_char_at( style, 1 ) == "!" ) {
        
        //Sorry :(
        var list = ds_list_create();
        
        style = string_delete( style, 1, 1 ) + ",";
        
        //Keep running over the string until there's nothing left or we exceed our iteration limit (which is probably because something's gone wrong...)
        var iterations = 0;
        do {
            iterations++;
            
            //Find the position of the next tag
            var sepOpenPos = string_pos( ",", style );
            
            if ( sepOpenPos != 0 ) {
                ds_list_add( list, string_copy( style, 1, sepOpenPos - 1) );
                style = string_delete( style, 1, sepOpenPos );
            }
        
        } until ( style == "" ) or ( iterations >= 1000 );
        if ( iterations >= 1000 ) show_debug_message( "scr_juju_text_process: too many iterations (separators)! " + string( style ) );
        
        if ( ds_list_find_value( list, 0 ) == "spr" ) {
            var portrait = ds_list_find_value( list, 1 );
            var spr = asset_get_index( ds_list_find_value( list, 2 ) );
            if ( instance_exists( textParent ) ) {
                var inst = ds_map_find_value( textParent.map_portrait, portrait );
                inst.sprite_index = spr;
            }
        } else if ( ds_list_find_value( list, 0 ) == "img" ) {
            var portrait = ds_list_find_value( list, 1 );
            var img = real( ds_list_find_value( list, 2 ) );
            if ( instance_exists( textParent ) ) {
                var inst = ds_map_find_value( textParent.map_portrait, portrait );
                inst.image_index = img;
            }
        } else if ( ds_list_find_value( list, 0 ) == "scr" ) {
            var scr = ds_list_find_value( list, 1 );
            var scrIndex = asset_get_index( scr );
            if ( scrIndex >= 0 ) {
                if ( instance_exists( textParent ) ) with( textParent ) script_execute( scrIndex );
            } else {
                show_debug_message( "scr_juju_text_step_event: scr command cannot find script! " + string( ds_list_find_value( list, 1 ) ) );
            }
        } else if ( ds_list_find_value( list, 0 ) == "delay" ) {
            textTimer -= real( ds_list_find_value( list, 1 ) );
        }
        
        //Sorry :(
        ds_list_destroy( list );
        
    }
}
