///read_me___obj_juju_text()
//  
//  obj_juju_text handles the physical drawing of text. It can be tweened but does not directly do
//  any other operations itself. Mouse/gamepad interaction is handled by obj_juju_dialogue_option.
//  
//  Text is drawn by obj_juju_text via scr_juju_text_draw_event(). Text is parsed by scr_juju_text_process().
//  During the parsing process, the string passed to the script is split into sections of differing
//  style; styles are changed by tags in the string itself. The string is further split into pieces
//  where newlines need to be inserted, either because the developer has specified a # newline character
//  or the length of the line of text exceeds the autosize width. Each piece of text, termed a "segment"
//  is stored in a ds_list.
//  
//  
//  obj_juju_text can be tweened via scr_juju_animate().
//  
//  
//  textStyleStart
//     The default style for this piece of text, as defined by scr_juju_text()
//  textStartColour
//     The default colour for this piece of text, as defined by textStyleStart.
//  textStartFont
//     The default font for this piece of text, as defined by textStyleStart.
//  
//  textParent
//     The instance "owner" of this piece of text. Instances without an owner have textParent = noone
//     If the parent instance is destroyed, the text is NOT also destroyed.
//     textParent is used primarily to execute command tags.
//  
//  textLength
//     The overall character length of the text i.e. the sum of all text segment lengths.
//     This is not necessarily the same as the length of input string (especially after tags have been
//     removed).
//  textPos
//     The position of the typewriter head along the entire text.
//  textSegmentIndex
//     The last text segment that is to be fully displayed.
//  textSegmentPos
//     The position of the typewriter head within the text segment.
//  
//  textDelay
//     The delay, in frames, between each character being displayed. Negative values pause text display
//     but don't decrement the text display. A value of 0 instantly displays all text. A value between
//     0 and 1 permits the developer to display more than more character at a time. The number of
//     characters displayed is equal to floor(1/textDelay).
//  textTimer
//     Keeps track of when a character should be displayed. Can be modified (e.g. the [!delay] command
//     tag) to temporarily pause the typewriter head.
//  
//  lst_string
//     Holds the text content for each text segment.
//  lst_string_style
//     Holds the style tag for each text segment.
//  lst_string_x
//     Holds the x coordinate of each text segment. Text is drawn with top-left alignment. This position
//     is relative to the position of obj_juju_text. This allows for tweening.
//  lst_string_y
//     Holds the y coordinate of each text segment. Text is drawn with top-left alignment. This position
//     is relative to the position of obj_juju_text. This allows for tweening.
//  
//  textWidth
//     The overall maximum width of the text as drawn by scr_juju_text_draw_event(). Measured in pixels.
//  textHeight
//     The overall maximum height of the text as drawn by scr_juju_text_draw_event(). Measured in pixels.
//     
//  
//  Version 4p
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC
