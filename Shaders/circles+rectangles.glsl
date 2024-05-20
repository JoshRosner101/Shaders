//This shader is a shape intersection tutorial which can be found at: https://www.youtube.com/watch?v=5r-8JCOsJwA
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define WIDTH 1600.0
#define HEIGHT 900.0

bool rect_contains_point(vec2 p1, vec2 p2, vec2 p) {
    return p1.x <= p.x && p.x <= p2.x && p1.y <= p.y && p.y <= p2.y;
}

bool circle_contains_point(vec2 center, float radius, vec2 point) {
    return length(center - point) <= radius;
}

vec2 remap(vec2 p) {
    return p/u_resolution.xy*vec2(WIDTH, HEIGHT);
}

vec2 closest_point(vec2 p1, vec2 p2, vec2 center) {
    float x = max(p1.x, min(p2.x, center.x));
    float y = max(p1.y, min(p2.y, center.y));
    return vec2(x, y);
}

void main()
{
    vec2 p = remap(gl_FragCoord.xy);

    vec2 size = vec2(450.0, 300.0);
    vec2 p1 = vec2(WIDTH * 0.5 - size.x*0.5, HEIGHT * 0.5 - size.y * 0.5);
    vec2 p2 = p1 + size;

    vec2 center = remap(u_mouse.xy);
    float radius = 200.0;

    vec2 closestPoint = closest_point(p1, p2, center);

    gl_FragColor = vec4(0.0);

    if (rect_contains_point(p1, p2, p)) {
        gl_FragColor += vec4(0.2, 0.09, 0.69, 1.0);
    }

    if(circle_contains_point(center, radius, p)) {
        if(length(center - closestPoint) <= radius) {
            gl_FragColor += vec4(0.05, 1.0, 0.38, 1.0);
        }
        else {
            gl_FragColor += vec4(0.702, 0.1686, 0.1686, 1.0);
        }
    }

    if(circle_contains_point(closestPoint, 10.0, p)) {
        gl_FragColor += vec4(1.0);
    }

}