//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_amount;
uniform vec2  u_texel;

void main() {
    vec2 o = u_texel * 2.0 * u_amount;
    vec4 c = texture2D(gm_BaseTexture, v_vTexcoord) * 0.4;
    c += texture2D(gm_BaseTexture, v_vTexcoord + vec2( o.x, 0.0)) * 0.15;
    c += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-o.x, 0.0)) * 0.15;
    c += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0,  o.y)) * 0.15;
    c += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -o.y)) * 0.15;

    float g = dot(c.rgb, vec3(0.299, 0.587, 0.114));
    c.rgb = mix(c.rgb, vec3(g), 0.5 * u_amount);          // desaturate
    c.rgb *= 1.0 - 0.45 * u_amount;                        // dim
    float v = distance(v_vTexcoord, vec2(0.5));
    c.rgb *= 1.0 - smoothstep(0.35, 0.85, v) * 0.5 * u_amount;   // vignette
    gl_FragColor = vec4(c.rgb, 1.0);
}