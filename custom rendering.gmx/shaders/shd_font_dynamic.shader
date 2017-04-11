attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vReferencePosition;

void main() {
    
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vReferencePosition = in_Colour;
    v_vTexcoord = in_TextureCoord;
    
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;
varying vec4 v_vReferencePosition;

uniform sampler2D u_sReference;

void main() {
    
    vec4 colour = texture2D( u_sReference, v_vReferencePosition.rg );
    gl_FragColor = colour * texture2D( gm_BaseTexture, v_vTexcoord );
    
}

