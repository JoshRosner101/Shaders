#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Standard rgb to HSL function
vec3 hsl(vec3 rgb) {
    vec3 hsl;
    float minimum = min(rgb.x, min(rgb.y, rgb.z));
    float maximum = max(rgb.x, max(rgb.y, rgb.z));
    float delta = maximum - minimum;
    float sum = maximum + minimum;
    //Luminance
    hsl.z = (sum)/2.0;
    if(delta == 0.0){
        return hsl;
    }

    //Saturation
    if(hsl.z < 0.5) {
        hsl.y = delta/sum;
    }
    else {
        hsl.y = delta/(2.0-sum);
    }

    //Hue
    if(maximum == rgb.r) {
        hsl.x = (rgb.g-rgb.b)/delta;
    }
    else if(maximum == rgb.g) {
        hsl.x = 2.0 + (rgb.b-rgb.r)/delta;
    }
    else {
        hsl.x = 4.0 + (rgb.r-rgb.g)/delta;
    }

    return hsl;
}

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(u_time+uv.xyx);

    gl_FragColor = vec4(col, 1.0);
    
    vec3 colorMapping = hsl(col);
    //Convert to HSL and decide which color based on the L (lightness)
    if(colorMapping.b >= 0.6975) {
        gl_FragColor.rgb = vec3(0.8784, 0.9725, 0.8157);
    }
    else if(colorMapping.b >= 0.575) {
        gl_FragColor.rgb = vec3(0.5176, 0.7529, 0.4392);
    }
    else if(colorMapping.b >= 0.35) {
        gl_FragColor.rgb = vec3(0.2039, 0.4078, 0.3373);
    }
    else {
        gl_FragColor.rgb = vec3(0.0314, 0.0941, 0.1255);
    }

}