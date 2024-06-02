//This is the default shader on ShaderToy written in glsl
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Standard random function BUT different for two points, varying over time
vec2 randomVector(vec2 uv) {
    float x = dot(uv, vec2(451.9143,132.931));
    float y = dot(uv, vec2(391.4913,841.0293));
    return sin(sin(vec2(x,y))* 32419.131);
}

float perlinNoise(vec2 uv) {
    //Grid Id = each corner
    vec2 gridId = floor(uv);
    //Grid Uv = uv for each tile
    vec2 gridUv = fract(uv);

    //Find the corners of each tile
    vec2 bottomLeft = gridId + vec2(0.0, 0.0);
    vec2 bottomRight = gridId + vec2(1.0, 0.0);
    vec2 topLeft = gridId + vec2(0.0, 1.0);
    vec2 topRight = gridId + vec2(1.0, 1.0);

    //Create a random vector (gradient) at each of those points
    vec2 gradBottomLeft = randomVector(bottomLeft);
    vec2 gradBottomRight = randomVector(bottomRight);
    vec2 gradTopLeft = randomVector(topLeft);
    vec2 gradTopRight = randomVector(topRight);

    //Distance from current pixel to each corner
    vec2 distBottomLeft = gridUv - vec2(0.0, 0.0);
    vec2 distBottomRight = gridUv - vec2(1.0, 0.0);
    vec2 distTopLeft = gridUv - vec2(0.0, 1.0);
    vec2 distTopRight = gridUv - vec2(1.0, 1.0);

    //Dot product of random vectors and distances
    float dotBottomLeft = dot(gradBottomLeft, distBottomLeft);
    float dotBottomRight = dot(gradBottomRight, distBottomRight);
    float dotTopLeft = dot(gradTopLeft, distTopLeft);
    float dotTopRight = dot(gradTopRight, distTopRight);

    //Linearly interpolate everything together
    float bottom = mix(dotBottomLeft, dotBottomRight, gridUv.x);
    float top = mix(dotTopLeft, dotTopRight, gridUv.x);
    float perlin = mix(bottom, top, gridUv.y);

    //And that's perlin noise!
    return perlin;
}

float fbmPerlinNoise(vec2 uv) {
    float fbmNoise = 0.0;
    float amplitude = 0.5;
    //Number of times we generate noise
    const float octaves = 6.0;

    for(float i = 0.0; i < octaves; i++) {
        fbmNoise += perlinNoise(uv) * amplitude;
        //Decrease amplitude increase scale
        amplitude *= 0.5;
        uv *= 2.0;
    }

    return fbmNoise;
}

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
    color = vec3(fbmPerlinNoise(vec2(uv.x+ u_time*0.05, uv.y + u_time*0.2))*0.75);
    color += vec3(smoothing(noise) + 0.5* smoothing(noise2) + 0.35* smoothing(noise3));

    gl_FragColor = vec4(color,1.0);
}