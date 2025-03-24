shader_type spatial;

uniform sampler2D pic:filter_nearest;
uniform sampler2D Static:filter_nearest;
uniform sampler2D Wallpaper:filter_nearest;

uniform bool ShowWallpaper;

void fragment() {
	vec4 face = texture(pic,UV);
	vec2 ModUV = (UV + vec2(sin(TIME),cos(TIME)) * 15.0f);
	vec4 static = texture(Static,ModUV);
	vec4 wallpaper = texture(Wallpaper,UV);
	
	if (ShowWallpaper)
	{
	ALBEDO = wallpaper.rgb + static.rgb;
	EMISSION = wallpaper.rgb * wallpaper.rgb - static.rgb * 0.7f;
	}
	else
	{
	ALBEDO = face.rgb * static.rgb;
	EMISSION = face.rgb * face.rgb * static.rgb * 0.3f;
	}
}

void light() {
	// Called for every pixel for every light affecting the material.
}
