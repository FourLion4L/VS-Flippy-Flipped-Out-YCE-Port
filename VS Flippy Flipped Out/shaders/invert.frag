#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;

#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color (also saving alpha)
    vec4 camera = texture(iChannel0,uv);
	float alpha = camera.a;
    vec3 col = 1.0 - camera.xyz;

    // Output to screen
    fragColor = vec4(col.r * alpha, col.g * alpha, col.b * alpha, alpha);
}

// https://www.shadertoy.com/view/dssXRl (edited a bit hehe.  - Levka4)