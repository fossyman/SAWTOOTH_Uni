shader_type sky;

uniform sampler2D Colors:filter_linear;
uniform sampler2D Static:filter_nearest;
void sky() {
	vec2 UVOFFSET = vec2(TIME * 0.5,0.0);
	vec3 CurrentColor = vec3(0,0,0);
	vec4 text = texture(Colors,UVOFFSET);
	
	vec2 staticUV = (SCREEN_UV * 2.0) + vec2(TIME * 5.0,TIME * 5.0);
	vec4 staticTexture = texture(Static,staticUV);
	staticTexture.a *= 0.1;
	text *= 0.1;
	COLOR = text.rgb + staticTexture.rgb;
}
