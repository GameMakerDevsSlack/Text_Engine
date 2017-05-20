varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fTime;
uniform float u_fSmoothness;

float get_text_index( vec4 colour ) { //Returns the index (1 -> length, inclusive) of the character we're drawing
    return colour.a*255.0;
    //return ( colour.g + colour.b*256.0 )*255.0;
}

void main() {
    
    float alpha = max( 0.0, min( 1.0, ( u_fTime - get_text_index( v_vColour ) ) / u_fSmoothness ) );
    gl_FragColor = vec4( v_vColour.rgb, alpha ) * texture2D( gm_BaseTexture, v_vTexcoord );
    
}
