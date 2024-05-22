//This is a noise shader created by following the tutorial at: https://www.youtube.com/watch?v=vcfIJ5Uu6Qw
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec2 noise2x2(vec2 p) {
  float x = dot(p, vec2(123.4, 234.5));
  float y = dot(p, vec2(345.6, 456.7));
  vec2 noise = vec2(x, y);
  noise = sin(noise);
  noise = noise * 43758.5453;
  noise = fract(noise);
  return noise;
}

//you can do xy or yx to switch things

void main()
{
    //xy coordinates divided by xy resolution
    vec2 uv = gl_FragCoord.xy/u_resolution;

    vec3 color = vec3(0.0);
    //Make the uv larger so fract can create a grid
    uv *= 4.0;
    vec2 currentGridId = floor(uv);
    vec2 currentGridCoord = fract(uv);
    //Recenter the uv at the middle of each grid
    currentGridCoord -= 0.5;
    //Flip over the y axis for each grid
    color = vec3(currentGridCoord, 0.0);

    vec2 redGridUv = currentGridCoord;
    redGridUv = abs(redGridUv);
    float distanceToEdgeOfGridCell = 2.0 * max(redGridUv.x, redGridUv.y);

    color = vec3(distanceToEdgeOfGridCell);
    //Creates an outer grid for demonstration
    vec3 gridColor = vec3(smoothstep(0.9, 1.0, distanceToEdgeOfGridCell), 0.0, 0.0);
    color = gridColor;

    float pointsOnGrid = 0.0;
    float minDistFromPixel = 100.0;

    for(float i = -1.0; i <= 1.0; i++) {
        for(float j = -1.0; j <= 1.0; j++) {
            vec2 adjGridCoords = vec2(i,j);
            vec2 pointOnAdjGrid = adjGridCoords;

            //pointOnAdjGrid = adjGridCoords + sin(u_time)*0.5;

            //add noise to the points
            vec2 noise = noise2x2(currentGridId + adjGridCoords);
            pointOnAdjGrid = adjGridCoords + sin(u_time * noise) * 0.5;

            float dist = length(currentGridCoord - pointOnAdjGrid);
            minDistFromPixel = min(dist, minDistFromPixel);

            pointsOnGrid += smoothstep(0.95, 0.96, 1.0-dist);
        }
    }

    vec3 pointsOnGridColor = vec3(pointsOnGrid);
    color = gridColor + pointsOnGridColor + minDistFromPixel;
    
    color = vec3(minDistFromPixel);


    gl_FragColor = vec4(color,1.0);
}