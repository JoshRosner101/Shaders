//This is a starfield shader created by following the tutorial at https://www.youtube.com/watch?v=rvDo9LvfoVE and https://www.youtube.com/watch?v=dhuigO4A7RY
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

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

float hash21(vec2 position) {
    position = fract(position*vec2(123.34, 456.21));
    position += dot(position, position+45.32);
    return fract(position.x * position.y);
}

vec3 starLayer(vec2 uv) { 
    vec3 color = vec3(0.0);

    //remap middle of box to origin
    vec2 gridUv = fract(uv) - 0.5;
    vec2 gridId = floor(uv);
    
    for(float y = -1.0; y <= 1.0; y++){
        for(float x = -1.0; x <= 1.0; x++){
            vec2 offset = vec2(x,y);
            float n = hash21(gridId+offset);
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
    uv *= rotate(time);

    vec3 color = vec3(0.0);
    const float numLayers = 8.0;
    for(float i = 0.0; i < 1.0; i += 1.0/numLayers) {
        float depth = fract(i + time);
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
    vec2 uv = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
    
    vec3 color = generateStarfield(uv);

    gl_FragColor = vec4(color,1.0);
}