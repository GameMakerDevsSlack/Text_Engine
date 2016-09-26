///scr_juju_dialogue_box_destroy_children( box instance )
//  
//  Internal script. Do not edit.
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

var list = argument0.lst_children;
var size = ds_list_size( list );
for( var i = 0; i < size; i++ ) with( ds_list_find_value( list, i ) ) instance_destroy();
ds_list_destroy( list );
argument0.lst_children = noone;
