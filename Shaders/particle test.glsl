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
    // -1.0 to 1.0
    vec2 uv = (2.0*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;
    vec2 uv2 = uv;
    vec3 color = vec3(0.0);

    uv2 *= 4.0;

    color += vec3(sdCircle(vec2(0.5), fract(uv2 + u_time), 0.3*(1.0-length(uv))));

    
    gl_FragColor = vec4(color,1.0);
}