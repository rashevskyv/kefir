//!HOOK MAIN
//!BIND HOOKED

#define iResolution vec3(1.0,1.0,1.0)
#define iTime frame/10.0
#define iMouse vec3(0.2,0.2,0.2)

#define iChannelResolution vec3(0.5,0.5)

#define iChannel0 MAIN_raw
#define iChannel1 MAIN_raw
#define iChannel2 MAIN_raw
#define iChannel3 MAIN_raw

/*

Just a quick experiment with rain drop ripples.

-- 
Zavie

*/

// Maximum number of cells a ripple can cross.
#define MAX_RADIUS 2

// Set to 1 to hash twice. Slower, but less patterns.
#define DOUBLE_HASH 0

// Hash functions shamefully stolen from:
// https://www.shadertoy.com/view/4djSRW
#define HASHSCALE1 .1031
#define HASHSCALE3 vec3(.1031, .1030, .0973)

float hash12(vec2 p)
{
	vec3 p3  = fract(vec3(p.xyx) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

vec2 hash22(vec2 p)
{
	vec3 p3 = fract(vec3(p.xyx) * HASHSCALE3);
    p3 += dot(p3, p3.yzx+19.19);
    return fract((p3.xx+p3.yz)*p3.zy);

}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float resolution = 10. * exp2(-3.*iMouse.x/iResolution.x);
	vec2 uv = fragCoord.xy / iResolution.y * resolution;
    vec2 p0 = floor(uv);

    float circles = 0.;
    for (int j = -MAX_RADIUS; j <= MAX_RADIUS; ++j)
    {
        for (int i = -MAX_RADIUS; i <= MAX_RADIUS; ++i)
        {
			vec2 pi = p0 + vec2(i, j);
            #if DOUBLE_HASH
            vec2 h = hash22(pi);
            #else
            vec2 h = pi;
            #endif
            vec2 p = pi + hash22(h);

            float t = fract(0.3*iTime + hash12(h));
            float d = length(p - uv) - (float(MAX_RADIUS) + 1.)*t;

            circles += (1. - t) * (1. - t)
                * mix(sin(31.*d) * 0.5 + 0.5, 1., 0.1)
                * smoothstep(-0.6, -0.3, d)
                * smoothstep(0., -0.3, d);
        }
    }

    float intensity = mix(0.01, 0.15, smoothstep(0.1, 0.6, abs(fract(0.05*iTime + 0.5)*2.-1.)));
    vec3 n = vec3(dFdx(circles), dFdy(circles), 0.);
    n.z = sqrt(1. - dot(n.xy, n.xy));
    vec3 color = texture(iChannel0, uv/resolution - intensity*n.xy).rgb + 5.*pow(clamp(dot(n, normalize(vec3(1., 0.7, 0.5))), 0., 1.), 6.);
	fragColor = vec4(color, 1.0);
}


vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	//mainImage( color,vec2(MAIN_pos.x,1.0-MAIN_pos.y));
	mainImage( color,vec2(MAIN_pos.x,MAIN_pos.y));
	return color;
}


