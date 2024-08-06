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
    vec3 color = vec3(0.0);

    const float PARTICLE_COUNT = 20.0;
    const float ROTATIONS = 10.0;
    // for(float j = 0.0; j < ROTATIONS; j++) {
    //     for(float i = 0.0; i < PARTICLE_COUNT; i++) {
    //         color += vec3(sdCircle(0.5*vec2(cos(j*3.1415/ROTATIONS)*cos(i*6.283/PARTICLE_COUNT),sin(j*3.1415/ROTATIONS)*sin(i*6.283/PARTICLE_COUNT)), uv, 0.02));
    //     }
    // }

    //Cylinder
    const float HEIGHT = 5.0;
    for(float j = 0.0; j < HEIGHT; j++) {
        for(float i = 0.0; i < PARTICLE_COUNT; i++) {
            color += vec3(sdCircle(0.5*vec2(cos(i*6.283/PARTICLE_COUNT + u_time),j/HEIGHT), uv, 0.02));
        }
    }

    gl_FragColor = vec4(color, 1.0);
}