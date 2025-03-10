shader_type spatial;

uniform sampler2D WaterTexture:filter_nearest;
uniform vec2 UVSpeed;

uniform sampler2D noise_texture;
uniform float wave_scale;
uniform float wave_strength;
void vertex() {
	vec2 global_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
    float noise_value = texture(noise_texture, global_position * wave_scale).r;
    float wave = sin(global_position.x * 0.2 + global_position.y * 0.2 + TIME + noise_value * 10.0) * wave_strength;
    VERTEX.y += wave;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 ModUV = vec2(UV.x + UVSpeed.x * TIME,UV.y + UVSpeed.y * TIME);
	vec4 Water = texture(WaterTexture,ModUV);
	
	ALBEDO = Water.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
