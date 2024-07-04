precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


float sdCircle( vec2 center, vec2 point, float radius ) 
{
    return length(center - point)-radius;
}

float wholeNumber(float circle) {
    return step(circle, 0.0);
}

vec2 rotate(float location) {
    float offset = 3.1415/3.0*location;
    float delay = 0.0;
    float movement = smoothstep(delay, 10.0 + delay, u_time)*3.1415*10.0;
    float center = smoothstep(5.0 + delay, 10.0 + delay, u_time);
    return 0.5*vec2(cos(movement+offset), sin(movement+offset))*cos(center*3.1415/2.0);
}

vec3 tint(float i) {
    return vec3(mod(i + 1.0, 2.0), mod(4.0,i), (i-4.0 < 0.0));
}

void main()
{
    vec2 uv = (2.0*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;

    vec3 color = vec3(0.0);
    for (float i = 1.0; i <= 6.0; i++) {
        color += vec3(wholeNumber(sdCircle(rotate(i), uv, 0.1)))*tint(i);
    }

    gl_FragColor = vec4(color,1.0);
}