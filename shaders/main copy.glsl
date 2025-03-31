
#define MAX_LIGHTS 30
extern float power[MAX_LIGHTS];

extern int numLights;
extern vec2[] pos;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 addent = vec4(0,0,0, 0);

    for (int i=0; i<numLights; ++i) {
        
    }

    return Texel(image, uvs) * color + addent;
}