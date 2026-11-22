shader_type spatial;

uniform sampler2D base_color_map : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D normal_map : hint_normal, filter_linear_mipmap_anisotropic;
uniform sampler2D rm_map : filter_linear_mipmap_anisotropic;
uniform float stone_gain = 1.0;
uniform float moss_gain = 1.0;

void fragment() {
	vec3 original = texture(base_color_map, UV).rgb;
	float brightest = max(original.r, max(original.g, original.b));
	float darkest = min(original.r, min(original.g, original.b));
	float chroma = brightest - darkest;
	float luminance = dot(original, vec3(0.2126, 0.7152, 0.0722));
	// Pedra neutra. Madeira, fogo e bandeiras mantêm suas cores.
	float stone_mask = (1.0 - smoothstep(0.035, 0.15, chroma)) * smoothstep(0.025, 0.08, luminance);
	vec3 stone = vec3(luminance * stone_gain);
	vec3 color = mix(original, stone, stone_mask * 0.92);
	float green_dominance = original.g - max(original.r, original.b);
	float moss_mask = smoothstep(0.012, 0.08, green_dominance);
	color.g *= mix(1.0, moss_gain, moss_mask);
	ALBEDO = color;
	NORMAL_MAP = texture(normal_map, UV).rgb;
	vec3 rm = texture(rm_map, UV).rgb;
	ROUGHNESS = rm.g;
	METALLIC = rm.b;
}
