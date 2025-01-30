// shaders/transition.shader
shader_type canvas_item;

uniform float progress: hint_range(0, 1);
uniform vec4 fade_color: source_color = vec4(0,0,0,1);

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float alpha = smoothstep(0.0, 1.0, progress);
    COLOR = mix(color, fade_color, alpha);
}