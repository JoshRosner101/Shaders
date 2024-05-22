//This is a variant of the voronoi noise function that shows whole colors, not gradients
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Standard random function
vec2 random (vec2 uv) {
    return vec2(fract(sin(dot(uv.xy, vec2(349.2321,353.931)))* 32219.131));
}

void main()
{
    //xy coordinates divided by xy resolution
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    vec3 color = vec3(0.0);

    //Scale the uv
    uv.x*= 4.45;
    uv.y*= 6.0;

    //Create the tiles
    vec2 currentGridId = floor(uv);
    vec2 currentGridCoord = fract(uv);

    //This time keep the point as a vector to create colors from
    vec2 minPoint;
    float minDistFromPixel = 1.0;

    for(float i = -1.0; i <= 1.0; i++) {
        for(float j = -1.0; j <= 1.0; j++) {
            vec2 adjGridCoords = vec2(i,j);
            vec2 pointOnAdjGrid = 0.5 + 0.5*sin(0.54 * u_mouse.y/u_resolution.y - 0.4 * + u_mouse.x/u_resolution.x+ 6.2831 * random(currentGridId + adjGridCoords));

            float distance = length(adjGridCoords + pointOnAdjGrid - currentGridCoord);
            //This makes the colors snap to the individual tiles
            if(distance < minDistFromPixel) {
                //minDistFromPixel shouldn't be greater than the distance
                minDistFromPixel = distance;
                //If this isn't the if statement, it will create colors for each TILE
                minPoint = pointOnAdjGrid;
            }
        }
    }

    //Create colors with given weights
    color += dot(minPoint,vec2(.4,.5)) + minDistFromPixel * 0.15;

    gl_FragColor = vec4(color,1.0);
}