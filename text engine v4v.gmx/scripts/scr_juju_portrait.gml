///scr_juju_portrait( box instance, x, y, sprite, image, image speed, image xscale, name )

var boxInst = argument0;
var xx = argument1;
var yy = argument2;
var spr = argument3;
var img = argument4;
var spd = argument5;
var xscl = argument6;
var name = argument7;

var inst = instance_create( xx, yy, obj_juju_portrait );
scr_juju_dialogue_box_add_portrait( boxInst, inst, name );
inst.sprite_index = spr;
inst.image_index = img;
inst.image_speed = spd;
inst.image_xscale = xscl;
inst.portraitName = name;

return inst;
