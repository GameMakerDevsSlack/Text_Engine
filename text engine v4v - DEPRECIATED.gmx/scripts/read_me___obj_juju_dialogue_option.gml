///read_me___obj_juju_dialogue_option()
//  
//  obj_juju_dialogue_option controls the button pressing mechanisms of dialoge boxes. All instance are
//  linked to an instance of obj_juju_text and an instance of obj_juju_dialogue box. Attached text display is
//  paused by using a negative textDelay value. Text is unpaused when the trigger parent, defined by
//  dialogueTriggerParent, has finished displaying its text. The trigger parent can be any instance with
//  an attached obj_juju_text or an instance of obj_juju_text itself.
//  
//  
//  obj_juju_dialogue option cannot be tweened by the developer.
//  
//  
//  dialogueScript
//     The script to execute when this instance is selected by the user via scr_juju_dialogue_clicked().
//     Defined by column 5 within a .csv block. This value is <undefinied> if these is no script to execute.
//  
//  dialogueTag
//     The dialogue database tag to change to if this instance is selected. If left blank, the attached
//     dialogue box will close.
//  
//  dialogueOriginParent
//     The instance of obj_juju_dialogue_box that this instance is attached to.
//  dialogueText
//     The instance of obj_juju_text that this instance is attached to.
//  
//  dialogueIndex
//     The numeric index for this dialogue option on its attached dialogue box. The first dialogue option
//     on a given dialogue box is given index 0.
//  dialoguePrevInst
//     The GameMaker instance ID of the previous dialogue option. This is usually above the current instance.
//  dialogueNextInst
//     The GameMaker instance ID of the next dialogue option. This is usually below the current instance.
//  
//  dialogueTriggerParent
//     The instance that controls when text is displayed. The trigger parent can be any instance with an
//     attached obj_juju_text or an instance of obj_juju_text itself.
//  
//  
//  Version 4p
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC
