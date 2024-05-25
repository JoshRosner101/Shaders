//This is a noise shader created by following the tutorial at: https://www.youtube.com/watch?v=cWiLGZPwXCs
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

//Perlin noise function from perlin_noise.glsl
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
    return perlin + 0.2;
}

float fbmPerlinNoise(vec2 uv) {
    float fbmNoise = 0.0;
    float amplitude = 0.1;
    //Number of times we generate noise
    const float octaves = 2.0;

    for(float i = 0.0; i < octaves; i++) {
        fbmNoise += perlinNoise(uv) * amplitude;
        //Decrease amplitude increase scale
        amplitude *= 0.5;
        uv *= 2.0;
    }

    return fbmNoise;
}

//domain warping means use noise to generate more noise
float domainWarpFbmPerlinNoise(vec2 uv) {
    float fbm1 = fbmPerlinNoise(uv + vec2(0.0, 0.0));
    float fbm2 = fbmPerlinNoise(uv + vec2(3.4, 1.9));

    float fbm3 = fbmPerlinNoise(uv + 4.0 * fbm1 + vec2(2.6, 5.1));
    float fbm4 = fbmPerlinNoise(uv + 4.0 * fbm2 + vec2(7.1, 4.9));
    return fbmPerlinNoise(vec2(fbm3,fbm4));
}

vec3 calcNormal(vec2 uv) {
    float diff = 0.001;
    float p1 = domainWarpFbmPerlinNoise(uv + vec2(diff, 0.0));
    float p2 = domainWarpFbmPerlinNoise(uv - vec2(diff, 0.0));
    float p3 = domainWarpFbmPerlinNoise(uv + vec2(0.0, diff));
    float p4 = domainWarpFbmPerlinNoise(uv - vec2(0.0, diff));
    vec3 normal = normalize(vec3(p1-p2, p3-p4, diff));
    return normal;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;
    
    float perlin = perlinNoise(uv);
    vec3 color = vec3(perlin);

    float fbmNoise = fbmPerlinNoise(uv);
    color = vec3(fbmNoise);

    float domainWarpFbmNoise = domainWarpFbmPerlinNoise(uv);
    color = vec3(domainWarpFbmNoise);

    vec3 normal = calcNormal(uv);

    //diffuse lighting
    vec3 white = vec3(1.0);
    vec3 lightColor = white;

    vec3 lightSource = vec3(1.0);
    float diffuseStrength = max(0.0, dot(normal, lightSource));
    vec3 diffuse = diffuseStrength * lightColor;
    vec3 lighting = diffuse * 0.5;
    color = lighting;

    //specular lighting
    vec3 cameraSource = vec3(0.0, 0.0, 1.0);
    vec3 viewSource = normalize(cameraSource);
    vec3 reflectSource = normalize(reflect(-lightSource, normal));
    float specularStrength = max(0.0, dot(viewSource, reflectSource));
    specularStrength = pow(specularStrength, 32.0);
    vec3 specular = specularStrength * lightColor;

    //combine both
    lighting = diffuse * 0.5 + specular * 0.5;
    color = lighting;

    gl_FragColor = vec4(color,1.0);
}