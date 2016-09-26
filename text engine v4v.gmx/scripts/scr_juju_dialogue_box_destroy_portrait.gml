///scr_juju_dialogue_box_destroy_portrait( box instance )
//  
//  Internal script. Do not edit.
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

var map = argument0.map_portrait;
if ( map == noone ) exit;

while( ds_map_size( map ) ) {
    
    var key = ds_map_find_first( map );
    var inst = ds_map_find_value( map, key );
    ds_map_delete( map, key );
    
    with( inst ) {
        animateIncr = -animateIncr;
        destroying = true;
    }
    
}

ds_map_destroy( map );
argument0.map_portrait = noone;
