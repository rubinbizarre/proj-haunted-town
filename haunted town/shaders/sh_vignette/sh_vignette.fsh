varying vec2 v_uv;
uniform float u_intensity; // 0..1 max darkness at the corners
uniform float u_inner;     // where the fade starts, e.g. 0.35
uniform float u_outer;     // where it's fully dark, e.g. 0.85

void main() {
    float d = length(v_uv - 0.5) * 1.4142; // 0 at centre, ~1 at corners
    float a = smoothstep(u_inner, u_outer, d) * u_intensity;
    gl_FragColor = vec4(0.0, 0.0, 0.0, a);
}