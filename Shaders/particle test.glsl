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
    vec2 uv2 = uv * 10.0;
    vec3 color = vec3(cos(u_time + uv.yxy + vec3(1.0, 0.0, 2.0)));

    vec2 point = fract(uv2 + u_time);
    float radius = 0.3*(1.0-length(uv));
    float alpha = sdCircle(vec2(0.5), point, radius);

    
    gl_FragColor = vec4(color, alpha);
}