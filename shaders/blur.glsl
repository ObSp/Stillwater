
extern number blurSize;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 sum = vec4(0.0);
    float size = blurSize / love_ScreenSize.x; // Normalize blur size
    
    float weights[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);
    
    sum += Texel(texture, texture_coords) * weights[0];
    for (int i = 1; i < 5; i++) {
        vec2 offset = vec2(float(i) * size, 0.0);
        sum += Texel(texture, texture_coords + offset) * weights[i];
        sum += Texel(texture, texture_coords - offset) * weights[i];
    }
    
    return sum * color;
}