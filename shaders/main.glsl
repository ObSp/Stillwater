vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    return Texel(image, uvs) * color;
}