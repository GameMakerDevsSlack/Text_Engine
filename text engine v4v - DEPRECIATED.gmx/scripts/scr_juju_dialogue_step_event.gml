///scr_juju_dialogue_step_event()
//  
//  This script should be placed in the Step event of objects used as dialogue option handlers.
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

if ( dialogueTriggerParent != noone ) {
    if ( instance_exists( dialogueTriggerParent ) ) {
        if ( dialogueTriggerParent.object_index == obj_juju_text ) var inst = dialogueTriggerParent else var inst = dialogueTriggerParent.dialogueText;
        if ( inst.textPos >= inst.textLength ) and ( instance_exists( dialogueText ) ) {
            if ( dialogueText.textDelay < 0 ) dialogueText.textDelay = -( dialogueText.textDelay + 1 );
        }
    }
}
