//This is a fireworks shader created by following the tutorial at https://www.youtube.com/watch?v=xDxAnguEOn8
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define numParticles 50.0
#define numExplosions 2.0

// Had to use a hash without sine because the normal one wouldn't work properly
// Hash without Sine
// Created by David Hoskins.
vec2 Hash12(float seed)
{
    vec3 p3 = fract(vec3(seed) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.xz+p3.yy)*p3.zx);
}

float Explosion(vec2 uv, float fractTime) {
    float sparks = 0.0;
    for(float i = 0.0; i < numParticles; i++) {
        vec2 direction = Hash12(i + 1.0) - 0.5;
        //Animations can be done over fractTime, since it goes from 0 to 1 every second
        float distance = length(uv - direction*fractTime);
        float brightness = 0.0005;

        brightness *= 0.5*sin(fractTime*20.0 + i) + 0.5;
        brightness *= smoothstep(1.0, 0.75, fractTime);
        sparks += brightness/distance;
    }
    return sparks;
}

void main()
{
    vec2 uv = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;

    vec3 color = vec3(0.0);

    for(float i = 0.0; i < numExplosions; i++) {
        float t = u_time+i/numExplosions;
        float floorT = floor(t);
        vec3 uniqueColor = sin(vec3(.34,.54,.43)*floorT + i*913.)*0.25 + 0.75;
        vec2 offset = Hash12(i+1.+floorT*numExplosions)-0.5;
        color += Explosion(uv-offset, fract(t))*uniqueColor;
    }

    gl_FragColor = vec4(color,1.0);
}