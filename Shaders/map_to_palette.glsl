#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Standard rgb to HSL function
vec4 HSL(vec4 c)
{
	float low = min(c.r, min(c.g, c.b));
	float high = max(c.r, max(c.g, c.b));
	float delta = high - low;
	float sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(u_time+uv.xyx);

    gl_FragColor = vec4(col, 1.0);
    
    vec4 colorMapping = HSL(vec4(col, 1.0));
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