#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


float ring(in float distance, in float edge) {
    return 1.0 - step(edge, abs(distance - 0.1));
}

void main()
{
    vec2 st = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    st = fract(st * 3.0) - 0.5;
    float distance = length(st);
    float shape1 = ring((sin(u_time*3.1415)+ 2.0)/10.0, distance + log(distance));
    st = fract(st * 1.5) - 0.5;
    distance = length(st);
    shape1 += ring((sin(u_time*3.1415)+ 2.0)/10.0, distance + log(distance));


    vec3 color = 0.5+0.5*cos(u_time+st.xyx+vec3(0,2,4));
    vec3 finalColor = vec3(0.0);

    finalColor += color * shape1;

    gl_FragColor = vec4(finalColor,1.0);
}