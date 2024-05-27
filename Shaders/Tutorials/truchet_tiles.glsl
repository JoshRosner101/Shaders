//This is an implementation of the truchet effect that was made by following the tutorial at https://www.youtube.com/watch?v=2R7h76GoIJM
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

void main()
{
    vec2 uv = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;

    vec3 color = vec3(0.0);

    uv *= 10.0;
    //-0.5 to 0.5
    vec2 gv = fract(uv) - 0.5;
    vec2 id = floor(uv);
    float thickness = 0.1;

    //random flipping
    float n = Hash21(id);
    if(n<.5) gv.x *= -1.;

    //lines
    float distance = abs(abs(gv.x + gv.y)-0.5);

    vec2 circleUV = gv - 0.5*sign(gv.x + gv.y + 0.001);
    distance = length(circleUV);
    float mask = smoothstep(0.01, -0.01, abs(distance-0.5)-thickness);
    float angle = atan(circleUV.x, circleUV.y); //-pi to pi
    float checker = mod(id.x+id.y, 2.)*2.0 - 1.0;
    float flow = sin(angle*10.0*checker+u_time);

    float x = fract(angle/1.57);
    float y = (distance-(0.5-thickness))/(thickness * 2.0);
    y = abs(y-0.5)*2.;
    vec2 truchetUV = vec2(x,y);
    color += flow * mask;
    color *= 1.0-truchetUV.y;
    
    //draw an outline
    // if(gv.x > .48 || gv.y > .48) {
    //     color = vec3(1.0,0.0,0.0);
    // }
    gl_FragColor = vec4(color,1.0);
}