shader_type canvas_item;

uniform vec4 scanline_color: source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float scanline_spacing: hint_range(2.0, 20.0) = 4.0;
uniform float scanline_width: hint_range(0.1, 1.0) = 0.5;
uniform float edge_softness: hint_range(0.0, 1.0) = 0.25;

void fragment() {
    vec2 uv = FRAGCOORD.xy;

    float line_pos = fract(uv.y / scanline_spacing);
    float scanline = smoothstep(
        scanline_width + edge_softness,
        scanline_width - edge_softness,
        abs(line_pos - 0.5) * 2.0
    );

    COLOR = vec4(scanline_color.rgb, scanline * scanline_color.a);
}