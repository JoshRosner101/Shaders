//This shader was made by following the tutorial found at https://www.youtube.com/watch?v=f4s1h2YETNY
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//This is a procedural color palette generation function taken from https://iquilezles.org/articles/palettes/
vec3 palette(in float t)
{
    //Colors were picked out using http://dev.thi.ng/gradients/
    vec3 a = vec3(0.500, 0.608, 0.778);
    vec3 b = vec3(-0.362, -0.302, 0.198);
    vec3 c = vec3(1.728, -2.612, -0.832);
    vec3 d = vec3(0.000, 0.333, 0.667);
    return a + b*cos( 6.28318*(c*t+d) );
}

void main()
{
    //Normalized color space that is adjusted to the aspect ratio (no stretching)
    vec2 st = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec2 st0 = st;

    vec3 finalColor = vec3(0.0);

    //this iterates on itself to create a larger fractal design
    for (float i = 0.0; i < 3.0; i++) {
        //adjust color space to center the design (not exactly centered to increase variance)
        st = fract(st * 1.5) - 0.5;

        float distance = length(st);
        //This is done to increase variance
        distance *= exp(-length(st0));

        //using the distance from the initial coordinates makes the gradient globally change, not just locally
        vec3 color = palette(length(st0) + i*0.4 + u_time*0.2);

        distance = sin(distance*10.0 + u_time)/10.0;
        distance = abs(distance);

        //distance = step(0.1, distance);
        //distance = smoothstep(0.0,0.1,distance);
        
        //Inverse function, scaled down to make sure values aren't only white
        distance = 0.01/distance;

        //This makes the darker colors darker, while making the lighter ones stand out more (increase contrast)
        distance = pow(distance, 2.0);

        finalColor += color * distance;
    }

    gl_FragColor = vec4(finalColor,1.0);
}