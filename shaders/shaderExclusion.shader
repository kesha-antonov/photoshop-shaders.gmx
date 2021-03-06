//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.	

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~//
// Exclusion Shader
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D texExclusion;

vec4 exclusion(sampler2D tex, vec4 inColor)
{
    /*
    //MOBILE SPECIFIC CODE
    float displayWidth = 1196.0; //Enter the display dimensions as a uniform float.
    float displayHeight = 768.0;
    float displayScreenButton = 64.0;
    vec2 blendUV = vec2(v_vTexcoord.x * (displayWidth / (displayHeight - displayScreenButton)), v_vTexcoord.y * (displayWidth / (displayHeight + displayScreenButton)));
    vec4 blend = texture2D(texExclusion, blendUV); 
    */   
    vec4 blend = texture2D(tex, v_vTexcoord);    
    vec4 outColor = vec4((abs(inColor - blend)).rgb,inColor.a);
    return mix(inColor, outColor, blend.a);
}

void main()
{

    vec4 inColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = exclusion(texExclusion, inColor);
}
