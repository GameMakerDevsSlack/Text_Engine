///scr_juju_dialogue_clicked( instance )
//  
//  This script should be called whenever an option is selected. This could be a mouse click or a key press or what have you.
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

scr_juju_dialogue_select();

with( argument0 ) {
    
    if ( !is_undefined( dialogueScript ) ) {
        if ( dialogueScript != noone ) script_execute( dialogueScript );
    }
    
    var valid = false;
    if ( !is_undefined( dialogueTag ) ) {
        if ( real( dialogueTag ) != noone ) and ( instance_exists( dialogueOriginParent ) ) {
            valid = true;
            
            if ( dialogueOriginParent.dialogueDestruct ) {
                var newInst = scr_juju_dialogue( dialogueOriginParent.dialogueOriginX, dialogueOriginParent.dialogueOriginY, dialogueTag, dialogueOriginParent.dialogueCategory );
                scr_juju_dialogue_box_link_portrait( newInst, dialogueOriginParent.map_portrait );
                scr_juju_dialogue_box_destroy_children( dialogueOriginParent );
                with( dialogueOriginParent ) instance_destroy();
            } else {
                scr_juju_dialogue_box_destroy_children( dialogueOriginParent );
                scr_juju_dialogue_populate( dialogueOriginParent, dialogueTag, object_index );
            }
            
            
        }
    }
    
    if ( !valid ) {
        scr_juju_dialogue_box_destroy_children( dialogueOriginParent );
        scr_juju_dialogue_box_destroy_portrait( dialogueOriginParent );
        with( dialogueOriginParent ) instance_destroy();
    }
    
}
