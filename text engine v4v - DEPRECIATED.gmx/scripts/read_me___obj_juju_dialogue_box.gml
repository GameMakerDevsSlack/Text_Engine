///read_me___obj_juju_dialogue_box()
//  
//  Dialogue boxes take information stored in a database (in reality, a complex nested data structure)
//  and creates a series of obj_juju_text and obj_juju_dialogue_option instances. Dialogue boxes also
//  act as the "master controller" of those instances and any obj_juju_portrait instances that are
//  linked to the dialogue box.
//
//  scr_juju_dialogue() provides a convenient template for creating categories of dialogue box. You
//  may want one type of dialogue box for a conversation with a town NPC and another altogether for
//  a cutscene or boss encounter. It also allows the developer to change one set of parameters and
//  adjust behaviours across an entire project.
//  
//  
//  obj_juju_dialogue_box can be tweened via scr_juju_animate().
//  
//  
//  dialogueHeight
//     The height of the dialogue box. This is the sum of each line of text, including text attached
//     to obj_juju_dialogue_option.
//  dialogueWidth
//     The maximal width of the dialogue box. This is the sum of each line of text, including text
//     attached to obj_juju_dialogue_option.
//  
//  dialogueDB
//     The index for the dialogue database that's to be used for this dialogue tree.
//  dialogueText
//     The instance of obj_juju_text that's attached to this instance.
//  
//  dialogueDestruct
//     Whether or not to destroy (and recreate) this dialogue box when the user selects an option.
//  dialogueCategory
//     The category, as defined in scr_juju_dialogue(), to use for the next dialogue box.
//  
//  dialogueOriginX
//     The target x-coordinate for the next dialogue box, should one be created by the engine.
//  dialogueOriginY
//     The target y-coordinate for the next dialogue box, should one be created by the engine.
//  
//  dialogueOptionOffsetX
//     The x-offset for the dialogue options. This is measured from the left hand side of the dialogue
//     box.
//  dialogueOptionSpacing
//     The additional y-spacing between each dialogue option. This is measured from the bottom of the
//     previous option to the top of the next.
//  dialogueDelay
//     The character display delay for each piece of text in the dialogue box. See scr_juju_text().
//  dialogueStartingStyle
//     The starting style for every piece of text in the dialogue box. See scr_juju_text().
//  dialogueAutosizeWidth
//     The autosize width for the dialogue box, in pixels. This puts a limit on the maximal width.
//  dialogueLineSpacing
//     The line spacing in the text itself (rather than between dialogue options). See scr_juju_text().
//  
//  
//  Version 4p
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC
