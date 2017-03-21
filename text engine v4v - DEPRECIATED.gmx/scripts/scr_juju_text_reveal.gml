///scr_juju_text_reveal()
//  
//  This script is called by scr_juju_text_step_event() every time a new character is revealed.
//  This would typically used to play a sound effect.
//  
//  Version 4c
//  December 2015
//  @jujuadams
//  /u/jujuadams
//  Juju on the GMC

if ( !audio_is_playing( snd_key ) ) audio_play_sound( snd_key, 1, false );
