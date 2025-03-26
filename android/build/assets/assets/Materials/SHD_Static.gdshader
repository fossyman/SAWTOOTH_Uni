shader_type spatial;

uniform sampler2D Static:filter_nearest;

void fragment() {
	vec2 ModUV = (UV + vec2(sin(TIME),cos(TIME)) * 15.0f);
	vec4 static = texture(Static,ModUV);
	ALBEDO = static.rgb;
	EMISSION = static.rgb * 0.5f;
}
