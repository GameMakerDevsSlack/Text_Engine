///read_me___list_of_command_tags()
//  
//  Commands tags are used in-line to pass instructions to the engine during the display of text.
//  Once a command tag is reached during typewriter display of text, the command is executed.
//  Command tags are executed from scr_juju_text_step_event().
//  
//  For text that the player skips (pressing a mouse button, pressing a key etc) or text that is displayed
//  instantly (has a delay of 0), all commands tags are executed at the same time in the order in which
//  they appear in the text. For example:
//  
//  "blah blah blah [!img,left,1]blah blah blah [!img,left,0]"
//  
//  Under normal operation, the image index of the portrait tagged as "left" will change to 1 and then to 0 a few frames later.
//  If this text is skipped or drawn without typewriter delay, the image index will display as 0.
//  
//  
//  [!spr,argument1,argument2]
//     argument1: The portrait tag to target.
//     argument2: The new sprite index for the target portrait. This is the internal GameMaker name of the sprite.
//  
//  [!img,argument1,argument2]
//     argument1: The portrait tag to target.
//     argument2: The new image index for the target portrait.
//  
//  [!delay,argument1]
//     argument1: The number of steps to delay. For a game running at 60FPS, 1 second of delay is equal to a value of 60.
//  
//  [!scr,argument1]
//     argument1: A script to execute. This is the internal GameMaker name of the script.
//  
//  
//  Version 4p
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC
