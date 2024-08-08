precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//hsl to rgb formula based on https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
float hueToRgb(float temp1, float temp2, float hue) {

    if(6.0*hue < 1.0) {
        return temp2 + (temp1-temp2)*6.0*hue;
    }
    else if(2.0*hue < 1.0) {
        return temp1;
    }
    else if(3.0*hue < 2.0) {
        return temp2 + (temp1-temp2)*(0.666-hue)*6.0;
    }
    return temp2;
}

vec3 rgb(vec3 hsl) {
    vec3 rgb = vec3(0.0);
    if(hsl.g == 0.0) {
        rgb += hsl.b;
    }
    else {
        float temp1;
        if(hsl.b < 0.5) {
            temp1 = hsl.b * (1.0 + hsl.g);
        }
        else {
            temp1 = hsl.g + hsl.b - hsl.g * hsl.b;
        }

        float temp2 = 2.0*hsl.b - temp1;
        rgb.r += hueToRgb(temp1, temp2, hsl.r + 0.33);
        rgb.g += hueToRgb(temp1, temp2, hsl.r);
        rgb.b += hueToRgb(temp1, temp2, hsl.r - 0.33);
    }

    return rgb;
}

vec3 colorize(float hue) {
    return rgb(vec3(hue, 0.7, 0.5));
}

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
    const float HEIGHT = 10.0;
    const float SCALE = 2.0;
    const float DISPLACE_X = 0.0;
    const float DISPLACE_Y = -0.5;
    const float RADIUS = 1.0;
    const float SKEW = 0.0;
    for(float j = 0.0; j < HEIGHT; j++) {
        for(float i = 0.0; i < PARTICLE_COUNT; i++) {
            color += colorize(j/HEIGHT)*vec3(sdCircle(0.5*vec2(RADIUS*cos(i*6.283/PARTICLE_COUNT + u_time) + DISPLACE_X,j/HEIGHT*SCALE + 0.5*sin(i*6.283/PARTICLE_COUNT + u_time*SKEW) + DISPLACE_Y), uv, 0.02));
        }
    }

    gl_FragColor = vec4(color, 1.0);
}