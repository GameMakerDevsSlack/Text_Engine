///scr_juju_dialogue( x, y, tag, category )
//  
//  Fully generates a dialogue box with the relevant text and buttons as defined in the dialogue database.
//  This script is fully customiseable by the developer and should be customised to add personality to the project.
//  Called by scr_juju_dialogue_clicked().
//  
//  Version 4f
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

//You may want to access other databases somehow. Swap this out if needed.
var db = global.dialogueDB;

var xx = argument0;
var yy = argument1;
var tag = argument2;
var category = argument3;

//Nothing more fancy than a big switch statement.
switch( category ) {
    
    //Example category, nothing exciting here
    case "default_category":
    
        //Create a dialogue box. This is a dense function so let's go left-to-right (first three arguments are self-explanatory so from argument2)
        //arg 2: Use the default dialogue box object (obj_juju_dialogue_box)
        //arg 3: Use the same category for further dialogue boxes
        //arg 4: The x-offset for option buttons is 20px, measured from the leftmost edge of the dialogue box. This gives us a bit of room for arrows etc
        //arg 5: There's 4px extra separation between option buttons. A bit more room makes walls of text look a little less intimidating!
        //arg 6: We'll use a delay value of 0.5 for all text in the dialogue box. Numbers less than one will reveal 1/delay characters per step (in this case, 2 chars per step)
        //arg 7: The default style will be "styleA". Look at scr_juju_text_styles() to see what this is doing.
        //arg 8: The autosizing width is 400px. This stop any one line from exceeding that width... the system isn't perfect and very long strings without spaces will glitch out.
        //arg 9: Use the defaul line spacing - this is equal to the string height of a newline character in the starting style's font.
        //arg10: The dialogue box object will destroy itself and regenerated every time an option is selected.
        var backInst = scr_juju_dialogue_box( db, xx, yy, "", category,   20, 4, 0.5, "styleA", 400, "",   true );
        
        //Manually set the width of the dialogue box to 400px. The width that's sent to the dialogue box is automatically autosized to longest line of text in the dialogue box.
        backInst.dialogueWidth = 400;
        
        //Add a tweening animation to the dialogue box.
        scr_juju_animate( backInst, 0.02,   xx, yy - 150, 0,   xx, yy, 1,   scr_juju_ease_cubic_in );
        
        //Fill up the dialogue box with text and buttons as per the .csv file. Don't forget this step ;)
        scr_juju_dialogue_populate( backInst, tag, "" );
        
    break;
    
    //For production runs, you might want to create some kind of fall-back dialogue category
    default:
        show_debug_message( "scr_juju_dialogue: unrecognised category! (" + string( category ) + ")" );
        var backInst = noone;
    break;
    
}

return backInst;
