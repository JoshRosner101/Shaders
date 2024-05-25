//This is a noise shader created by following the tutorial at: https://www.youtube.com/watch?v=KllOFoUnKhU
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Standard random function
float random (vec2 uv) {
    return (fract(sin(dot(uv.xy, vec2(451.9143,132.931)))* 32419.131));
}

float valueNoise(vec2 uv) {
    //Scale it up for tiling
    uv *= 4.0;
    uv.y*=0.75;

    vec2 gridUv = fract(uv - u_mouse.x/u_resolution.x* 2.0);
    vec2 gridId = floor(uv - u_mouse.x/u_resolution.x* 2.0);
    //color = vec3(gridId, 0.0) * 0.125;

    //Removes rough edges
    gridUv = smoothstep(0.0, 1.0, gridUv);

    //randomize and learnarly interpolate for bottom
    float bottomLeft = random(gridId);
    float bottomRight = random(gridId + vec2(1.0, 0.0));
    float bottom = mix(bottomLeft, bottomRight, gridUv.x);

    //same for top
    float topLeft = random(gridId + vec2(0.0, 1.0));
    float topRight = random(gridId + vec2(1.0, 1.0));
    float top = mix(topLeft, topRight, gridUv.x);

    //Interpolate them together
    return mix(bottom, top, gridUv.y);
}

void main()
{
    //xy coordinates divided by xy resolution
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    vec3 color = vec3(0.0);

    //random(uv) is just white noise

    float noise = valueNoise(uv);
    noise += valueNoise(uv * 2.0) / 0.8;
    noise += valueNoise(uv * 3.0) / 6.0;
    noise += valueNoise(uv * 6.0) / 9.0;
    noise += valueNoise(uv * 1.42) / 3.0;
    noise /= 3.0;
    noise = pow(noise, 2.0);

    color += vec3(noise);

    gl_FragColor = vec4(color,1.0);
}