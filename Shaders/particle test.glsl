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
    vec3 color = 0.5+0.5*cos(u_time+uv.xyx+vec3(0,2,4));

    vec2 movinguv2 = uv2 + u_time;

    vec2 point = fract(movinguv2);
    vec2 tile = floor(movinguv2);

    float radius = 0.3*(1.0-length(uv));
    float alpha = 0.0;
    color += 0.25*sdCircle(vec2(0.5), point, radius/2.0);

    //Flips direction for every other circle
    float direction = (mod(tile.x, 2.0)*2.0-1.0)*(mod(tile.y, 2.0)*2.0-1.0);

    const float rotationSpeed = 1.0;
    const float numCircles = 5.0;
    float angle = 6.283/numCircles;
    for(float i = 0.0; i < numCircles; i++) {
        float theta = i*angle + direction*angle*smoothstep(0.0, 1.0, fract(u_time/1.5*rotationSpeed));
        alpha += 0.5*sdCircle(vec2(0.5) + radius*vec2(cos(theta), sin(theta)), point, radius);
    }

    //This adds shading
    color *= length(point);
    
    gl_FragColor = vec4(color, alpha);
}