shader_type canvas_item;

uniform vec4 tint_color: source_color;
uniform bool enabled = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (!enabled) {
		COLOR = color;
	}
	else {
	COLOR.rgb = vec3((color.r + color.g + color.b) / 3.f);
	COLOR.rgb = vec3((COLOR.rgb + tint_color.rgb) / 2.f);
	}
}
