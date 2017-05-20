attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_fLine;

void main() {
    
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    v_fLine = in_Position.z - 256.0*float( int( in_Position.z / 256.0 ) );
    
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_fLine;

uniform float u_fTime;
uniform float u_fSmoothness;

void main() {
    
    float alpha = max( 0.0, min( 1.0, ( u_fTime - v_fLine ) / u_fSmoothness ) );
    gl_FragColor = vec4( v_vColour.rgb, alpha ) * texture2D( gm_BaseTexture, v_vTexcoord );
    
}
