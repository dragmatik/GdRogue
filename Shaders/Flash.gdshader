shader_type canvas_item;

uniform bool Smooth = true;
uniform bool EnableOutline = true; // Added to toggle the outline
uniform float width : hint_range(0.0, 64) = 1.0;
uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 selection_color = vec4(1.0, 0.0, 0.0, 1.0); // Color for selection
uniform float color_intensity : hint_range(0.0, 1.0) = 1.0; // Slider for color intensity
uniform int pixel_size : hint_range(1, 10) = 1; // Set to constant value of 1

void fragment()
{
    float _width = width;
    vec2 unit = (1.0 / float(pixel_size)) / vec2(textureSize(TEXTURE, 0));
    vec4 pixel_color = texture(TEXTURE, UV);

    if (EnableOutline) {
        if (pixel_color.a == 0.0) {
            pixel_color = outline_color;
            pixel_color.a = 0.0;
            for (float x = -ceil(_width); x <= ceil(_width); x++) {
                for (float y = -ceil(_width); y <= ceil(_width); y++) {
                    if (texture(TEXTURE, UV + vec2(x * unit.x, y * unit.y)).a == 0.0 || (x == 0.0 && y == 0.0)) {
                        continue;
                    }
                    if (Smooth) {
                        pixel_color.a += outline_color.a / (pow(x, 2) + pow(y, 2)) * (1.0 - pow(2.0, -_width));
                        if (pixel_color.a > 1.0) {
                            pixel_color.a = 1.0;
                        }
                    } else {
                        pixel_color.a = outline_color.a;
                    }
                }
            }
        } else {
            // Blend the selection color with the sprite color when outline is enabled, applying color intensity
            pixel_color.rgb = mix(pixel_color.rgb, selection_color.rgb, color_intensity * selection_color.a);
        }
    } else {
        // Use selection color with intensity if outline is disabled
        if (pixel_color.a > 0.0) {
            pixel_color = mix(pixel_color, selection_color, color_intensity);
        }
    }

    COLOR = pixel_color;
}
