//This is a noise shader created by following the tutorial at: https://www.youtube.com/watch?v=7fd331zsie0
precision mediump float;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Standard random function BUT different for two points, varying over time
vec2 randomVector(vec2 uv) {
    float x = dot(uv, vec2(451.9143,132.931));
    float y = dot(uv, vec2(391.4913,841.0293));
    return sin(sin(vec2(x,y))* 32419.131 + u_time);
}

float perlinNoise(vec2 uv) {
    //Scale up the uv
    uv *= 4.0;
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

    //Smooth out the noise (removes rough edges)
    gridUv = smoothstep(0.0, 1.0, gridUv);

    //Linearly interpolate everything together
    float bottom = mix(dotBottomLeft, dotBottomRight, gridUv.x);
    float top = mix(dotTopLeft, dotTopRight, gridUv.x);
    float perlin = mix(bottom, top, gridUv.y);

    //And that's perlin noise!
    return perlin;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;
    
    float perlin = perlinNoise(uv);
    vec3 color = vec3(perlin + 0.2);

    // Some variants:
    
    // Billow noise
    // float billow = abs(perlin);
    // color = vec3(billow);

    // Ridged noise
    // float ridgedNoise = 1.0 - abs(perlin);
    // ridgedNoise = pow(ridgedNoise, 2.0);
    // color = vec3(ridgedNoise);

    gl_FragColor = vec4(color,1.0);
}