
#define MAX_LIGHTS 30

extern int numLights;

extern vec2[MAX_LIGHTS] pos;
extern float[MAX_LIGHTS] power;
extern float[MAX_LIGHTS] radius;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 addent = vec4(0,0,0, 0);

    for (int i = 0; i < numLights; ++i) {
        number dist = distance(screen_coords, pos[i]);

        number alpha = (radius[i]/dist) * power[i];
        
        if (alpha > power[i]) alpha = power[i];
        
        addent = addent + vec4(alpha, alpha, alpha, 0);
    }

    return Texel(image, uvs) * color + addent;
}