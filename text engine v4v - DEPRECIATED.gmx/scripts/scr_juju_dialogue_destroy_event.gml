///scr_juju_dialogue_destroy_event()
//  
//  This script should be placed in the Destroy event of objects used as dialogue option handlers.
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

if ( instance_exists( dialogueText ) ) with( dialogueText ) instance_destroy();
