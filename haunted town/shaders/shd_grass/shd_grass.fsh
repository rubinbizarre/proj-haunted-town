// shd_grass.fsh
// fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform vec2  u_resolution; // pixel dimensions of your surface

// --- Compact hash noise (value noise) ---
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)),
             dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f); // smoothstep

    return mix(mix(dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

// --- fBm: two octaves ---
float fbm(vec2 p) {
    float v = 0.0;
    v += 0.60 * noise(p * 1.0);
    v += 0.40 * noise(p * 2.5);
    return v * 0.5 + 0.5; // remap to [0, 1]
}

void main() {
    // scale UVs to world-space-feeling coordinates
    vec2 uv = v_vTexcoord * (u_resolution / 64.0);

    // animate: scroll the noise slightly over time, with variation per axis
    vec2 timeOffset = vec2(u_time * 0.15, u_time * 0.08);

    //float n = fbm(uv + timeOffset);
	float n = fbm(mod(uv + timeOffset, vec2(8.0)));

    // base grass colours
    vec3 grassDark  = vec3(0.22, 0.32, 0.15); // deep shadowed green
    vec3 grassLight = vec3(0.38, 0.52, 0.24); // lighter sun-caught green

    vec3 colour = mix(grassDark, grassLight, n);

    gl_FragColor = vec4(colour, 1.0);
}