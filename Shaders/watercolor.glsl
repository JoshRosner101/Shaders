precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;


float scaleUp(float uv) {
    return 0.5 * sin(uv) + 0.5;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution;

    //Scale up the uv
    uv *= 4.0;
    // uv.x += u_time;
    // uv.y += u_time*0.2;

    const float octaves = 50.0;
    for(float i = 1.0; i < octaves; i++) {
        uv += vec2(0.25/i * sin(i * uv.y + u_time + 0.3 * i) + 0.8, 1.0/i * sin(i * uv.x + u_time + 0.3 * i)+1.6);
    }

    vec3 color = vec3(scaleUp(uv.x), scaleUp(uv.y), scaleUp(uv.x+uv.y) - 0.5);
    color = vec3(mix(color.x, color.y, 0.5));
    gl_FragColor = vec4(color,1.0);
}