///scr_juju_text( x, y, string, delay, starting style, autosize width, line spacing )
//  
//  Creates an instance that will display text formatted by tags.
//  This text can also be set to display "typewriter style".
//  Adding new styles (fonts/colours etc) is done by modifying scr_juju_text_formatting().
//  
//  !!! Unfortunately, there seems to be a bug in how GM handles optional arguments in YYC as of version 1.4.1657.
//  !!! As a result, accessing default values is done by sending a blank string ( "" ) as an argument.
//  
//  
//  Example: scr_juju_text( 5, 5, "[red]Lorry [yellow]Lorry [red]Lorry#[yellow]Lorry", "", "fontA", 100, "" );
//  
//  This draws "Lorry Lorry Lorry Lorry" at (5,5) with alternating red/yellow colouring using the font defined by "fontA" in scr_juju_text_styles().
//  The delay, colour, and line spacing are all set to default values. The maximum width allowed is 100px.
//  
//  
//  argument0:  x-coordinate of the text.
//  argument1:  y-coordinate of the text.
//  argument2:  String to draw. This string contains formatting tags that use square brackets [].
//  argument3:  Delay in frames between each character being drawn. Values less than or equal to 0 are set to default. Defaults to instant display of all text.
//  argument4:  Starting style to use for the string. Defaults to c_black and the GM default draw_set_font( -1 ).
//  argument5:  Maximum width of any line of text. Values less than or equal to 0 are set to default. Defaults to no width limit.
//  argument6:  Pixel distance between subsequent lines of text. Values less than or equal to 0 are VALID. Defaults to the height of the # newline character.
//  return   :  Instance ID of the text handler object
//
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadam
//  Juju on the GMC

//Create the text handling instance
if ( is_real( argument0 ) ) var xx = argument0 else var xx = x;
if ( is_real( argument1 ) ) var yy = argument1 else var yy = x;
var inst = instance_create( xx, yy, obj_juju_text );

//Jump into this instance and process the text
with( inst ) {
    scr_juju_text_init( argument3, argument4, argument5, argument6 )
    scr_juju_text_process( argument2 );
}

return inst;
