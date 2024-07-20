precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float sdCircle( vec2 center, vec2 point, float radius ) 
{
    return step(length(center - point)-radius, 0.0);
}

void main()
{
    // -1.0 to 1.0
    vec2 uv = (2.0*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;
    vec2 uv2 = uv * 10.0;
    vec3 color = vec3(cos(u_time + uv.yxy + vec3(1.0, 0.0, 2.0)));

    vec2 movinguv2 = uv2 + u_time;

    vec2 point = fract(movinguv2);
    vec2 tile = floor(movinguv2);

    float radius = 0.3*(1.0-length(uv));
    float alpha = 0.0;
    alpha += sdCircle(vec2(0.5), point, radius);
    // for(float k = 1.0; k <= 2.0; k++) {
    //     for(float i = 0.0; i < 2.0; i++) {
    //         for(float j = 0.0; j < 2.0; j++) {
    //             alpha += 0.5*sdCircle(vec2(0.5)*k, point*2.0*k - vec2(mod(j, 2.0), mod(i, 2.0))*k, radius/k);
    //         }
    //     }
    // }

    //Flips direction for every other circle
    float direction = 1.0;
    if(bool(mod(tile.x, 2.0))) {
        direction *= -1.0;
    }
    if(bool(mod(tile.y, 2.0))) {
        direction *= -1.0;
    }

    for(float i = 0.0; i < 4.0; i++) {
        float theta = i*3.1415/2.0 + direction*3.1415/2.0*smoothstep(0.0, 1.0, fract(u_time/1.5));
        alpha += 0.5*sdCircle(vec2(0.5) + 0.25*vec2(cos(theta), sin(theta)), point, radius/2.0);
    }

    //This adds shading
    //color *= length(point);
    
    gl_FragColor = vec4(color, alpha);
}