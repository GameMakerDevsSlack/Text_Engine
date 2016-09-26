///scr_juju_dialogue_box( db, x, y, box object, next category, option x offset, option spacing, delay, starting style, autosize width, line spacing, regen box )
//  
//  
//  argument0 :  Dialogue database to use e.g. as created by scr_juju_dialogue_grid()
//  argument1 :  x-coordinate of the dialogue box.
//  argument2 :  y-coordinate of the dialogue box.
//  argument3 :  Object to create for the dialogue box. An empty string "" defaults to obj_juju_dialogue_box
//  argument4 :  Dialogue box category to be used for subsequent dialogue boxes. Typically the same category.
//  argument5 :  x-offset of the dialogue options. This is measured from the left hand side of the dialogue box.
//  argument6 :  Extra y-axis spacing between each piece of text (main text/dialogue options). This is in addition to line spacing.
//  argument7 :  Delay in frames between each character being drawn. Values equal to 0 are set to default. Defaults to instant display of all text.
//  argument8 :  Starting style to use for all text. Defaults to "GMdefault".
//  argument9 :  Maximum width of the dialogue box. Defaults to no width limit.
//  argument10:  Pixel distance between subsequent lines of text. Defaults to the height of the # newline character.
//  argument11:  Whether or not to destroy and re-create a dialogue box when a dialogue option is selected.
//  return    :  Instance ID of the dialogue box.
//  
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

if ( !is_real( argument3 ) ) var backObj = obj_juju_dialogue_box else var backObj = argument3;

var backInst = instance_create( argument1, argument2, backObj );
backInst.dialogueWidth = 0;
backInst.dialogueHeight = 0;
backInst.lst_children = noone;
backInst.map_portrait = noone;

backInst.dialogueDB = argument0;
backInst.dialogueOriginX = argument1;
backInst.dialogueOriginY = argument2;
backInst.dialogueCategory = argument4;

if ( !is_real( argument5 ) ) {
    backInst.dialogueOptionOffsetX = 20;
} else {
    backInst.dialogueOptionOffsetX = argument5;
}

backInst.dialogueDelay = argument7;

if ( argument8 == "" ) {
    backInst.dialogueStartingStyle = "GMdefault";
} else if ( !scr_juju_text_styles( argument8 ) ) {
    backInst.dialogueStartingStyle = "GMdefault";
} else {
    backInst.dialogueStartingStyle = argument8;
}

if ( !is_real( argument6 ) ) {
    backInst.dialogueOptionSpacing = 0;
} else {
    backInst.dialogueOptionSpacing = argument6;
}

scr_juju_text_styles( "GMdefault" );

backInst.dialogueAutosizeWidth = argument9;
backInst.dialogueLineSpacing = argument10;

if ( !is_real( argument11 ) ) {
    backInst.dialogueDestruct = false;
} else {
    backInst.dialogueDestruct = argument11;
}

return backInst;
