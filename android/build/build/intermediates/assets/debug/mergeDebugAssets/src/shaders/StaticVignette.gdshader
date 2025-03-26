shader_type canvas_item;


uniform sampler2D Static:filter_nearest,repeat_enable;
uniform sampler2D OpacityMask;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 NEWUV = SCREEN_UV + TIME * 1.1f;
	vec4 T = texture(Static,NEWUV);
	vec4 O = texture(OpacityMask,UV);
	T.a *= O.a;
	COLOR = T;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
