///scr_juju_dialogue_select()
//  
//  This script is called by scr_juju_dialogue_clicked() every time a new character is revealed.
//  This would typically used to play a sound effect.
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

if ( !audio_is_playing( snd_bell ) ) audio_play_sound( snd_bell, 1, false );
