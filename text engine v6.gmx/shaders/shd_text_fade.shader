attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fTime;
uniform float u_fSmoothness;

float get_text_index( vec4 colour ) { //Returns the index (1 -> length, inclusive) of the character we're drawing
    return colour.a*255.0;
    //return ( colour.g + colour.b*256.0 )*255.0;
}

void main() {
    
    float alpha = max( 0.0, min( 1.0, ( 1.0 + u_fTime - get_text_index( v_vColour ) ) / u_fSmoothness ) );
    gl_FragColor = vec4( v_vColour.rgb, alpha ) * texture2D( gm_BaseTexture, v_vTexcoord );
    
}
