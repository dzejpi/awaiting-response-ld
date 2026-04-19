shader_type canvas_item;
render_mode unshaded;

uniform float signal_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 wave_color : source_color = vec4(0.737, 0.686, 0.714, 1.0);
uniform float line_thickness = 0.05;
uniform float pulse_speed = 8;

void fragment() {
    vec2 uv = UV;
    float s = pow(signal_strength, 0.5);

    // --- Wave shape ---
	float scroll = TIME * 0.3;
    float wave = sin((uv.x + scroll) * 6.0 * 4.0) * 0.3;
    wave += sin((uv.x + scroll) * 6.0 * 8.0) * 0.2;
    wave += sin((uv.x + scroll) * 6.0 * 16.0) * 0.1;
    wave += sin((uv.x + scroll) * 6.0 * 32.0) * 0.05;
    wave += fract(sin((uv.x + scroll) * 127.1) * 32768.0) * 0.15 - 0.075;

    // --- Pulse amplitude up and down over time ---
    float pulse = sin(TIME * pulse_speed) * 0.9;
    wave *= s * mix(0.3, 1.0, pulse);

    float line = smoothstep(line_thickness, 0.0, abs(uv.y - 0.5 - wave));

    COLOR = vec4(wave_color.rgb, line * wave_color.a);
}