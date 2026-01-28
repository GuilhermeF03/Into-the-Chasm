shader_type canvas_item;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 fill_color = vec4(0,0,0, 1.0);
	
	COLOR = mix(texture_color, fill_color, 1.0);
	COLOR.a = texture_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
