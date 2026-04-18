shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float signal_strength : hint_range(0.0, 1.0) = 0.0;
uniform float aberration_amount = 0.008;
uniform float noise_amount = 0.12;
uniform float vignette_strength = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    float s = pow(signal_strength, 0.25);

    // --- Chromatic aberration ---
    float offset = aberration_amount * s;
    float r = texture(SCREEN_TEXTURE, uv + vec2(offset, 0.0)).r;
    float g = texture(SCREEN_TEXTURE, uv).g;
    float b = texture(SCREEN_TEXTURE, uv - vec2(offset, 0.0)).b;
    vec3 col = vec3(r, g, b);

    // --- Noise ---
    float noise = fract(sin(dot(uv * 500.0 + TIME * 0.1, vec2(12.9898, 78.233))) * 43758.5453);
    col += (noise - 0.25) * noise_amount * s;

    // --- Vignette ---
    vec2 centered = uv - vec2(0.5);
    centered.x *= SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    float dist = length(centered);
    float vignette = smoothstep(0.5, 0.2, dist);
    col *= mix(1.0, vignette, vignette_strength * s);

    // --- Flickering ---
    float flicker = sin(TIME * 3.0) * 0.015 * s;
    col += flicker;

    COLOR = vec4(col, 1.0);
}