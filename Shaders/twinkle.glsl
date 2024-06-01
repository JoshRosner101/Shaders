//This is the default shader on ShaderToy written in glsl
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Pseudo-random number generator
float Hash21(vec2 uv) {
    uv = fract(uv*vec2(234.34,435.345));
    uv += dot(uv, uv+34.23);
    return fract(uv.x*uv.y - u_time*0.0005);
}

float smoothing(float noise) {
    return smoothstep(0.997, 1.0, noise);
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;

    vec3 color = vec3(0.0);
    float noise = Hash21(uv);
    float noise2 = Hash21(uv + 2.0);
    float noise3 = Hash21(uv + 4.0);
    color = vec3(smoothing(noise) + 0.5* smoothing(noise2) + 0.35* smoothing(noise3));

    gl_FragColor = vec4(color,1.0);
}