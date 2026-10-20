#define PI 3.1415926535897932384626433832795

varying vec2 vUv;

//	Classic Perlin 2D Noise 
//	by Stefan Gustavson (https://github.com/stegu/webgl-noise)
//
vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

vec4 permute(vec4 x) {
  return mod(((x*34.0)+1.0)*x, 289.0);
}

float cnoise(vec2 P){
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 * 
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 pivot){
    return vec2(
        cos(rotation) * (uv.x - pivot.x) - sin(rotation) * (uv.y - pivot.y) + pivot.x,
        sin(rotation) * (uv.x - pivot.x) + cos(rotation) * (uv.y - pivot.y) + pivot.y
    );
}

void main()
{
    // Pattern 1 - basic UV color
    // gl_FragColor = vec4(vUv, 1.0, 1.0);

    // Pattern 2 - basic UV color with zero blue (rasta)
    // gl_FragColor = vec4(vUv, 0.0, 1.0);
    
    // Pattern 3 - b/w horizontal gradient
    // float strength = vUv.x;

    // Pattern 4 - b/w vertical gradient
    // float strength = vUv.y;

    // Pattern 5 - inverted b/w vertical gradient
    // float strength = 1.0 - vUv.y;

    // Pattern 6  - tight b/w vertical gradient
    // float strength = vUv.y * 10.0;

    // Pattern 7 - repeating pattern
    // float strength = mod(vUv.y * 10.0, 1.0);

    // Pattern 8 - wide horizontal bars
    // float strength = mod(vUv.y * 10.0, 1.0);
    // strength = step(0.5, strength);
    
    // Pattern 9 - narrow horizontal bars
    // float strength = mod(vUv.y * 10.0, 1.0);
    // strength = step(0.8, strength);

    // Pattern 10 - vertical bars
    // float strength = mod(vUv.x * 10.0, 1.0);
    // strength = step(0.8, strength);

    // Pattern 11 - grid
    // float strength = step(0.8, mod(vUv.x * 10.0, 1.0));
    // strength += step(0.8, mod(vUv.y * 10.0, 1.0));

    // Pattern 12 - dot matrix
    // float strength = step(0.8, mod(vUv.x * 10.0, 1.0));
    // strength *= step(0.8, mod(vUv.y * 10.0, 1.0));

    // Pattern 13 -  horizontal bar grid
    // float strength = step(0.4, mod(vUv.x * 10.0, 1.0));
    // strength *= step(0.8, mod(vUv.y * 10.0, 1.0));

    // Pattern 14 - L bar grid
    // float barX = step(0.4, mod(vUv.x * 10.0, 1.0));
    // barX *= step(0.8, mod(vUv.y * 10.0, 1.0));

    // float barY = step(0.4, mod(vUv.y * 10.0, 1.0));
    // barY *= step(0.8, mod(vUv.x * 10.0, 1.0));

    // float strength = barX + barY;

    // Pattern 15 - cross grid
    // float barX = step(0.4, mod(vUv.x * 10.0, 1.0));
    // barX *= step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));

    // float barY = step(0.4, mod(vUv.y * 10.0, 1.0));
    // barY *= step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0));

    // float strength = barX + barY;

    // Pattern 16 - gradient bar
    // float strength = abs(vUv.x - 0.5);

    // Pattern 17 - gradient cross
    // float strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    // Pattern 18 - square center burst
    // float strength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    // Pattern 19 - frame
    // float strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

    // Pattern 20 - narrow frame
    // float outerSq = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    // float innerSq = 1.0 - step(0.25, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

    // float strength = outerSq * innerSq;

    // Pattern 21 - stepped vertical gradient
    // float strength = floor(vUv.x * 10.0) / 10.0;

    // Pattern 22 - stepped diagonal gradient
    // float strength = floor(vUv.x * 10.0) / 10.0;
    // strength *= floor(vUv.y * 10.0) / 10.0;

    // Pattern 23 - tv static
    // float strength = random(vUv);

    // Pattern 24 - large static
    // vec2 gridUv = vec2(
    //     floor(vUv.x * 10.0) / 10.0,
    //     floor(vUv.y * 10.0) / 10.0
    // );
    // float strength = random(gridUv);

    // Pattern 25 - skewed large static
    // vec2 gridUv = vec2(
    //     floor(vUv.x * 10.0) / 10.0,
    //     floor(vUv.y * 10.0 + vUv.x * 5.0) / 10.0
    // );
    // float strength = random(gridUv);

    // Pattern 26 - corner radial gradient
    // float strength = length(vUv);

    // Pattern 27 - center burst gradient
    // float strength = length(vUv - 0.5);
    // OR
    // float strength = distance(vUv, vec2(0.5, 0.5)); // allows movement of center point

    // Pattern 28 - inverted center burst gradient
    // float strength = 1.0 - length(vUv - 0.5);
    // OR
    // float strength = 1.0 - distance(vUv, vec2(0.5, 0.5)); // allows movement of center point

    // Pattern 29 - dot burst
    // float strength = 0.015 / distance(vUv, vec2(0.5));

    // Pattern 30 - stretched dot burst
    // vec2 lightUv = vec2(
    //     vUv.x * 0.1 + 0.45,
    //     vUv.y * 0.5 + 0.25
    // );
    // float strength = 0.015 / distance(lightUv, vec2(0.5));

    // Pattern 31 - star burst
    // vec2 lightUvX = vec2(vUv.x * 0.1 + 0.45, vUv.y * 0.5 + 0.25);
    // float lightX = 0.015 / distance(lightUvX, vec2(0.5));

    // vec2 lightUvY = vec2(vUv.y * 0.1 + 0.45, vUv.x * 0.5 + 0.25);
    // float lightY = 0.015 / distance(lightUvY, vec2(0.5));

    // float strength = lightX * lightY;
    
    // Pattern 32 - rotated starburst
    // vec2 rotatedUv = rotate(vUv, PI/4.0, vec2(0.5));

    // vec2 lightUvX = vec2(rotatedUv.x * 0.1 + 0.45, rotatedUv.y * 0.5 + 0.25);
    // float lightX = 0.015 / distance(lightUvX, vec2(0.5));

    // vec2 lightUvY = vec2(rotatedUv.y * 0.1 + 0.45, rotatedUv.x * 0.5 + 0.25);
    // float lightY = 0.015 / distance(lightUvY, vec2(0.5));

    // float strength = lightX * lightY;

    // Pattern 33 - cutout circle
    // float strength = step(0.25, distance(vUv, vec2(0.5)));

    // Pattern 34 - circle outline gradient
    // float strength = abs(distance(vUv, vec2(0.5)) - 0.25);

    // Pattern 35 - circle outline cutout
    // float strength = step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

    // Pattern 36 - circle outline
    // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

    // Pattern 37 - drunk wavy circle outline
    // vec2 waveUv = vec2(
    //     vUv.x,
    //     vUv.y + sin(vUv.x * 30.0) * 0.1
    // );
    // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));

    // Pattern 38 - splat
    // vec2 waveUv = vec2(
    //     vUv.x + sin(vUv.y * 30.0) * 0.1,
    //     vUv.y + sin(vUv.x * 30.0) * 0.1
    // );
    // float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));

    // Pattern 39 - misc shape (would be a cool visualizer)
    vec2 waveUv = vec2(
        vUv.x + sin(vUv.y * 100.0) * 0.1,
        vUv.y + sin(vUv.x * 100.0) * 0.1
    );
    float strength = 1.0 - step(0.01, abs(distance(waveUv, vec2(0.5)) - 0.25));

    // Pattern 40 - angular gradient
    // float angle = atan(vUv.x, vUv.y);
    // float strength = angle;

    // Pattern 41 - angular gradient centered at (0.5, 0.5)
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // float strength = angle;

    // Pattern 42 - angular radial gradient
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // float strength = angle;

    // Pattern 43 - stepped radial gradient
    // float angle = atan(vUv.x - 0.5, vUv.y- 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // angle *= 20.0;
    // angle = mod(angle, 1.0);
    // float strength = angle;

    // Pattern 44 - radial gradient 4
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // float strength = sin(angle * 100.0);

    // Pattern 45 - wavy circle outline (stamp shape)
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // float sinusoid = sin(angle * 100.0);

    // float radius = 0.25 + sinusoid * (PI / 128.0);
    // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));

    // Pattern 46 - perlin noise
    // float strength = cnoise(vUv * 10.0);

    // Pattern 47 - perlin noise (no fade)
    // float strength = step(0.0, cnoise(vUv * 10.0));

    // Pattern 48 - neon noise
    // float strength = 1.0 - abs(cnoise(vUv * 10.0));

    // Pattern 49 - blobs
    // float strength = step(0.5, sin(cnoise(vUv * 10.0) * 20.0));

    // clamp strength
    strength = clamp(strength, 0.0, 1.0);

    // Add color
    vec3 blackColor = vec3(0.0);
    vec3 uvColor = vec3(vUv, 0.5); // 0.0 - rasta; 0.5 - rainbow
    vec3 mixedColor = mix(blackColor, uvColor, strength);
    gl_FragColor = vec4(mixedColor, 1.0);

    // gl_FragColor = vec4(vec3(strength), 1.0);
}