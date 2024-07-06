precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


float sdCircle( vec2 center, vec2 point, float radius ) 
{
    return step(length(center - point)-radius, 0.0);
}

void main()
{
    vec2 uv = (2.0*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;
    vec2 mouseuv = (2.0*u_mouse.xy-u_resolution.xy)/u_resolution.y;

    vec3 color = vec3(0.0);
    color += vec3(sdCircle(vec2(0.0), uv, 0.1));
    color -= vec3(sdCircle(mouseuv*0.025, uv, 0.05));

    gl_FragColor = vec4(color,1.0);
}