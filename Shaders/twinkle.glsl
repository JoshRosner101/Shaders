//This is the default shader on ShaderToy written in glsl
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Pseudo-random number generator
float Hash21(vec2 position) {
    position = fract(position*vec2(123.34, 456.21));
    position += dot(position, position+45.32);
    return fract(position.x * position.y);
}

//Pseudo-random number generator
vec2 Hash22(vec2 uv) {
    float x = dot(uv, vec2(451.9143,132.931));
    float y = dot(uv, vec2(391.4913,841.0293));
    return sin(sin(vec2(x,y))* 32419.131);
}

float smoothing(float noise) {
    return smoothstep(0.997, 1.0, noise);
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
    vec2 gradBottomLeft = Hash22(bottomLeft);
    vec2 gradBottomRight = Hash22(bottomRight);
    vec2 gradTopLeft = Hash22(topLeft);
    vec2 gradTopRight = Hash22(topRight);

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

mat2 rotate(float angle) {
    float x = cos(angle), y = sin(angle);
    return mat2(x, -y, y, x);
}

float star(vec2 uv, float flare) {
    float distance = length(uv);
    float glow = 0.05/distance;
    
    float rays = max(0., 1.0-abs(uv.x*uv.y*20000.));
    glow += rays * flare;
    uv *= rotate(3.1415/4.0);
    rays = max(0., 1.0-abs(uv.x*uv.y*1000.));
    glow += rays * 0.3 * flare;

    glow *= smoothstep(1.0, 0.2, distance);
    return glow;
}

vec3 starLayer(vec2 uv) { 
    vec3 color = vec3(0.0);

    //remap middle of box to origin
    vec2 gridUv = fract(uv) - 0.5;
    vec2 gridId = floor(uv);
    
    for(float y = -1.0; y <= 1.0; y++){
        for(float x = -1.0; x <= 1.0; x++){
            vec2 offset = vec2(x,y);
            float n = Hash21(gridId+offset);
            float size = fract(n*321.31);
            float star = star(gridUv -offset -(vec2(n,fract(n*10.0))-0.5), smoothstep(0.7, 0.9, size)*0.5);
            
            vec3 tint = sin(vec3(0.4, 0.89, 1.0)*fract(n*4141.02)*62.2831)*0.5 + 0.5;
            //modify this to set the colors differently
            tint *= vec3(0.4157, 0.1961, 0.6667);
            //twinkle
            star *= sin(u_time*3. + n*6.2831)*0.5+0.75;
            color += star*size*tint;
        }
    }
    return color;
}

vec3 generateStarfield(vec2 uv) {
    uv *= 3.0;
    float time = u_time*0.05;
    //uv *= rotate(time);

    vec3 color = vec3(0.0);
    const float numLayers = 3.0;
    for(float i = 0.0; i < 1.0; i += 1.0/numLayers) {
        float depth = fract(i);
        float scale = mix(20.0, 0.5, depth);
        float fade = depth*smoothstep(1.0, 0.9, depth);
        color += starLayer(uv * scale + i*90.0) * fade;
    }
    //Changes the color to light blue
    color.xyz = color.xxx * vec3(0.549, 0.7373, 1.0);
    return color;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;

    vec3 color = vec3(0.0);
    float noise = Hash21(uv);
    float noise2 = Hash21(uv + 2.0);
    float noise3 = Hash21(uv + 4.0);
    //Add the dust
    color = vec3(fbmPerlinNoise(vec2(uv.x+ u_time*0.05, uv.y + u_time*0.2))*0.75);
    //Add the stars
    //color += vec3(smoothing(noise) + 0.5* smoothing(noise2) + 0.35* smoothing(noise3));
    color += generateStarfield(uv);

    gl_FragColor = vec4(color,1.0);
}