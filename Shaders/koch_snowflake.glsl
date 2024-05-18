//This shader was made by following the tutorial found at https://www.youtube.com/watch?v=il_Qg9AqQkE

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 N(float angle) {
    return vec2(sin(angle), cos(angle));
}

void main()
{
    //xy coordinates divided by xy resolution
    vec2 uv = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
    vec2 mouse = u_mouse.xy/u_resolution.xy;
    uv *= 1.5;

    vec3 color = vec3(0.0);

    uv.x = abs(uv.x);
    uv.y += tan((5./6.)*3.1415) * 0.5;

    //tan(angle) = y/x
    //tan((5./6.)*3.1415) * 0.5 = y
    vec2 normal = N((5./6.)*3.1415);
    float distance = dot(uv - vec2(.5,0.), normal);
    uv -= normal*max(distance, 0.0) * 2.0;
    //color += smoothstep(0.01,0.0,abs(d));

    normal = N((2.0/3.0)*3.1415);
    
    float scale = 1.0;
    uv.x += 0.5;
    for(int i = 0; i < 4; i++) {
        uv *= 3.0;
        scale *= 3.0;
        uv.x -= 1.5;

        uv.x = abs(uv.x);
        uv.x -= 0.5;
        uv -= normal*min(dot(uv, normal), 0.0) * 2.0;
    }

    distance = length(uv - vec2(clamp(uv.x, -1., 1.), 0.0));
    color += smoothstep(1./u_resolution.y, .0, distance/scale);
    color.rg += uv / scale;

    gl_FragColor = vec4(color,1.0);
}