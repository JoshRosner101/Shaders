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
    vec2 scaledUv = uv * 5.0;
    vec3 color = vec3(0.0);

    vec2 movement = vec2(sin(u_time),cos(u_time))/u_time;
    
    //vec2(u_time+cos(u_time)*sin(u_time), u_time+sin(u_time)*tan(u_time));
    //vec2(u_time+cos(u_time), u_time+sin(u_time));
    vec2 movingScaledUv = scaledUv + movement;

    vec2 point = fract(movingScaledUv);
    vec2 tile = floor(movingScaledUv);

    float radius = 0.25*(1.0-length(uv)*0.75);
    color += 0.25*sdCircle(vec2(0.5), point, radius/4.0);

    //Flips direction for every other circle
    float direction = (mod(tile.x, 2.0)*2.0-1.0)*(mod(tile.y, 2.0)*2.0-1.0);

    const float rotationSpeed = 1.0;
    const float numCircles = 5.0;
    float angle = 6.283/numCircles;
    for(float i = 0.0; i < numCircles; i++) {
        float theta = i*angle + direction*angle*smoothstep(0.0, 1.0, fract(u_time/1.5*rotationSpeed));
        color += 0.5*sdCircle(vec2(0.5) + radius*vec2(cos(theta), sin(theta)), point, radius);
    }

    //This adds shading
    color *= length(point);

    //This adds back the color
    color *= 0.5+0.5*cos(u_time+uv.xyx+vec3(0,2,4));

    //This adds background color
    vec3 background = vec3(0.1);
    // Adds soft outer glow
    background += vec3(0.025*1.0-0.3*radius);
    color += background;
    // Adds soft tiling
    color += 0.025*length(0.5*point);
    
    //Creates small tiles
    //color *= vec3(length(fract(uv*100.0)));

    gl_FragColor = vec4(color, 1.0);
}