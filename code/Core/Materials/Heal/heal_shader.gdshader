shader_type canvas_item;
render_mode unshaded;

uniform vec4 heal_color : source_color = vec4(0.5, 1.0, 0.7, 1.0); // healing tint

// Intensity params
uniform float intensity = 1.0;
uniform float min_intensity = 0.25;
uniform float max_intensity = 0.8;

//
uniform float speed = 1.0;

// Full-body pulse using TIME
void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float time = TIME * speed;

    // Simple soft pulse oscillates from 0 to 1
    float pulse = clamp(0.5 + 0.5 * sin(time), min_intensity, max_intensity);

    // Apply healing tint blended with original texture
    vec3 blended_rgb = mix(tex_color.rgb,
		tex_color.rgb + heal_color.rgb * pulse,
		pulse * intensity
	);
    float blended_alpha = tex_color.a;

    COLOR = vec4(blended_rgb, blended_alpha);
}