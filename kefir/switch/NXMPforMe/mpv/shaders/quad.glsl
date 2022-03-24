//Created by kalan , from shadertoy

//!HOOK MAIN
//!BIND HOOKED

#define iResolution vec2(1.0,1.0)
#define iTime frame/10.0

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv = fract(uv * 2.);
    vec4 img = 	(MAIN_mul * vec4(texture(MAIN_raw, uv)).rgba);

    fragColor = img;
}


vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	mainImage( color,MAIN_pos);
	return color;
}

