//This is an implementation of the hexagonal tiling that was made by following the tutorial at https://www.youtube.com/watch?v=VmrIDyYiJBA
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Pseudo-random number generator
float Hash21(vec2 uv) {
    uv = fract(uv*vec2(234.34,435.345));
    uv += dot(uv, uv+34.23);
    return fract(uv.x*uv.y);
}

float hexDist(vec2 uv) {
    uv = abs(uv);
    float c = dot(uv, normalize(vec2(1.0,1.73)));
    c = max(c, uv.x);
    return c;
}

vec4 hexCoords(vec2 uv) {
    vec2 ratio = vec2(1.0, 1.73);
    vec2 h = ratio/2.0;
    vec2 gridUvA = mod(uv, ratio) - h;
    vec2 gridUvB = mod(uv - h, ratio) - h;
    vec2 gridUv;
    if(length(gridUvA) < length(gridUvB)) {
        gridUv = gridUvA;
    }
    else {
        gridUv = gridUvB;
    }
    //this is the hexagonal UV
    float x = atan(gridUv.x,gridUv.y);
    float y = 0.5 - hexDist(gridUv);
    //different for each grid cell
    vec2 gridId = uv-gridUv;
    return vec4(x, y, gridId);
}

void main()
{
    vec2 uv = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;

    vec3 color = vec3(0.0);

    uv *= 10.0;
    vec4 hexCoordinates = hexCoords(uv);
    float c = smoothstep(0.08, 0.1, hexCoordinates.y*sin(hexCoordinates.z*hexCoordinates.w+u_time));
    if(bool(mod(hexCoordinates.z, 2.0)*2.0-1.0)) {
    c *= -1.0;
    }
    if(bool(mod(hexCoordinates.w, 2.0)*2.0-1.0)) {
    c *= -1.0;
    }
    color +=c-c*abs((hexCoordinates.x)*sin(hexCoordinates.z*hexCoordinates.w+u_time));


    gl_FragColor = vec4(color,1.0);
}