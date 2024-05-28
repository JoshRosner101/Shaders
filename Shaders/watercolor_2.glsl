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
    uv *= 5.0;
    uv.x += u_time;
    uv.y += u_time*0.2;

    const float octaves = 20.0;
    for(float i = 1.0; i < octaves; i++) {
        uv += vec2(1.5/i * sin(i * uv.y + u_time + 0.5 * i) + 0.2, 0.3/i * sin(i * uv.x + u_time + 0.1 * i)+1.2);
    }

    vec3 color = vec3(scaleUp(uv.x), scaleUp(uv.x-uv.y), scaleUp(uv.x+uv.y));
    
    gl_FragColor = vec4(color,1.0);
}