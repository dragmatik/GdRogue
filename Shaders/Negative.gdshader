shader_type canvas_item;

uniform bool invert_colors = false; // Add this line

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    if (invert_colors) {
        COLOR = vec4(1.0 - color.rgb, color.a); // Invert colors
    } else {
        COLOR = color; // Use original colors
    }
}
