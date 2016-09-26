///scr_juju_dialogue_populate( box instance, tag, option instance )
//  
//  Creates a handful of instances that handle a dialogue system, loading content from a .csv file and utilising scr_juju_text() for advanced formatting.
//  Please read scr_juju_text() and associated functions for more details on how to use the formatting system.
//  Also of note are the comments in the attached example. csv file. This script delies on data structures created by scr_juju_dialogue_from_grid().
//
//  
//  argument0:  The instance ID of the dialogue box instance.
//  argument1:  The tag to load content from. This references tags in the database associated with the box instance via scr_juju_dialogue_box().
//  argument2:  The object to create for each dialogue option. An empty string "" defaults to obj_juju_dialogue_option
//  
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC



var backInst = argument0;
var tag = argument1;
if ( !is_real( argument2 ) ) var optObj = obj_juju_dialogue_option else var optObj = argument2;

if ( backInst.lst_children == noone ) backInst.lst_children = ds_list_create();
if ( backInst.map_portrait == noone ) backInst.map_portrait = ds_map_create();

var backX = backInst.x;
var backY = backInst.y;

var map_db        = backInst.dialogueDB;
var offsetX       = backInst.dialogueOptionOffsetX;
var optionSpacing = backInst.dialogueOptionSpacing;
var delay         = backInst.dialogueDelay;
var startingStyle = backInst.dialogueStartingStyle;
var autosizeWidth = backInst.dialogueAutosizeWidth;
var lineSpacing   = backInst.dialogueLineSpacing;
var destruct      = backInst.dialogueDestruct;

var map = ds_map_find_value( map_db, tag );
if ( is_undefined( map ) ) {
    show_debug_message( "scr_juju_dialogue_populate: tag unrecognised! " + string( tag ) );
    exit;
}

var textInst = scr_juju_text( backX, backY, ds_map_find_value( map, "text" ), delay, startingStyle, autosizeWidth, lineSpacing );
scr_juju_dialogue_box_add_child( backInst, textInst );
scr_juju_animate( textInst, backInst,   0, 0, 0,   true, true, true,   scr_juju_animate_weld );

backInst.dialogueWidth = max( backInst.dialogueWidth, textInst.textWidth );
backInst.dialogueText = textInst;

textInst.textParent = backInst;
textInst.depth = backInst.depth - 1;


var prevInst = noone;
var lst_options = ds_map_find_value( map, "options" );
if ( !is_undefined( lst_options ) ) {
    
    var size = ds_list_size( lst_options );
    for( var i = 0; i < size; i++ ) {
        
        var map = ds_list_find_value( lst_options, i );
        var check = ds_map_find_value( map, "check_script" );
        
        if ( !is_undefined( check ) ) {
            if ( check != noone ) {
                check = script_execute( check );
            } else check = true;
        } else check = true;
        
        if ( check ) {
            
            var optInst = instance_create( backX + offsetX, textInst.y + textInst.textHeight + optionSpacing, optObj );
            scr_juju_dialogue_box_add_child( backInst, optInst );
            scr_juju_animate( optInst, backInst,   optInst.x - backInst.x, optInst.y - backInst.y, 0,   true, true, true,   scr_juju_animate_weld );
            
            //Change to "backInst.dialogueText" to have all options reveal simultaneously
            //Change to "textInst" to have all options reveal sequentially
            
            optInst.dialogueIndex = i;
            if ( prevInst == noone ) {
                optInst.dialoguePrevInst = optInst;
                optInst.gamepadOver = true;
            } else {
                prevInst.dialogueNextInst = optInst;
                optInst.dialoguePrevInst = prevInst;
            }
            if ( i >= size - 1 ) optInst.dialogueNextInst = optInst;
            
            optInst.dialogueOriginParent  = backInst;
            optInst.dialogueTriggerParent = backInst.dialogueText;
            optInst.depth                 = backInst.depth - 1;
            optInst.dialogueTag           = ds_map_find_value( map, "tag" );
            optInst.dialogueScript        = ds_map_find_value( map, "execute_script" );
            
            var textInst = scr_juju_text( optInst.x, optInst.y, ds_map_find_value( map, "text" ), delay, startingStyle, autosizeWidth - offsetX, lineSpacing );
            scr_juju_dialogue_box_add_child( backInst, textInst );
            scr_juju_animate( textInst, optInst,   0, 0, 0,   true, true, true,   scr_juju_animate_weld );
            
            optInst.dialogueText = textInst;
            textInst.textParent  = optInst;
            textInst.depth       = backInst.depth - 1;
            textInst.textDelay   = -( textInst.textDelay + 1 );
            
            backInst.dialogueWidth = max( backInst.dialogueWidth, textInst.textWidth + offsetX );
            prevInst = optInst;
            
        } else {
            if ( prevInst != noone ) prevInst.dialogueNextInst = prevInst;
        }
    }
    
}

backInst.dialogueHeight = textInst.y - backInst.y + textInst.textHeight;
