precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main()
{
    vec2 uv = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
    uv *= 3.0;

    vec3 color = vec3(0.0);

    float distance = length(uv);
    float glow = 0.05/distance;
    color += glow;
    //This doesn't work the way it should?
    float rays = max(0., 1.0-abs(uv.x*uv.y*1000.));
    color += rays;


    gl_FragColor = vec4(color,1.0);
}