precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


float sdCircle( vec2 center, vec2 point, float radius ) 
{
    return step(length(center - point)-radius, 0.0);
}

vec2 Hash12(float seed)
{
    vec3 p3 = fract(vec3(seed) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 19.19);
    return 1.25*(fract((p3.xz+p3.yy)*p3.zx)-0.5);
}

vec3 eyeball(vec2 uv, vec2 center){
    vec2 mouseuv = (2.0*u_mouse.xy-u_resolution.xy)/u_resolution.y - center;
    vec3 color = vec3(0.0);
    float radius = 0.1;
    color += vec3(sdCircle(center, uv, radius));
    color -= vec3(sdCircle(center + mouseuv*0.5*radius, uv, radius*0.5));
    return color;
}

void main()
{
    // -1.0 to 1.0
    vec2 uv = (2.0*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;
    
    vec3 color = vec3(0.0);
    //vec2 center = 0.5*vec2(cos(u_time), sin(u_time));
    //color += eyeball(uv, center);
    for(float i = 0.0; i < 5.0; i++) {
        color += eyeball(uv, Hash12(i));
    }
    
    gl_FragColor = vec4(color,1.0);
}