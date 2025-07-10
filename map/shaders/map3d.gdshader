shader_type spatial;

uniform sampler2D subview_image: source_color, filter_linear_mipmap, repeat_enable;

void fragment() {
	vec3 subview_texture = texture(subview_image,UV).rgb;

	ALBEDO = subview_texture;
}
