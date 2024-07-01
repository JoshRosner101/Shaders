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
    return 0.5*vec2(cos(u_time+offset), sin(u_time+offset));
}
vec3 tint(float i) {
    return vec3(1.0);
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