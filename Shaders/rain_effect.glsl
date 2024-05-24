//This is my attempt at trying to learn how to create a pixel rain shader
precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

float rain(vec2 uv) {
    uv.x -= mod(uv.x, 0.0125);
    uv.y -= mod(uv.y, 0.025);

    /*
        //This is an alternate version with different numbers
        float offset = sin(uv.x * 0.025);
        float speed = abs(cos(uv.x*9.0))*.51 + 0.1;
  
        float gridUv = fract(uv.y + u_time*speed + offset);
        gridUv += fract(uv.x + u_time*speed - offset) * 0.3;
    */

    float gridUv = (fract(uv.y + (u_time + 1340.0) * abs(cos(uv.x * 2.0))*0.2 - 0.4));
    return 0.08/gridUv;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;
    gl_FragColor = vec4(vec3(rain(uv)), 1.0);
}