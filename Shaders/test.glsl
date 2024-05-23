//This is the default shader on ShaderToy written in glsl
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//you can do xy or yx to switch things

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;

    vec3 color = 0.5+0.5*cos(u_time+uv.xyx+vec3(0,2,4));

    gl_FragColor = vec4(color,1.0);
}