//This is the default shader on ShaderToy written in glsl
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//you can do xy or yx to switch things

void main()
{
    //xy coordinates divided by xy resolution
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec3 color = 0.5+0.5*cos(u_time+st.xyx+vec3(0,2,4));

    gl_FragColor = vec4(color,1.0);
}