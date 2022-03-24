//!HOOK MAIN
//!BIND HOOKED

#define iResolution vec2(1.0,1.0)
#define iTime frame/10.0
#define iMouse vec3(0.0,0.0,0.0)

#define iChannelResolution vec2(0.5,0.5)

#define iChannel0 MAIN_raw
#define iChannel1 MAIN_raw
#define iChannel2 MAIN_raw
#define iChannel3 MAIN_raw
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(123.45, 875.43))) * 5432.3);
}

// Smooth noise generator.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    f = f * f * (3.0 - 2.0 * f); // smoothstep with no clamp.
    
    return mix(a, b, f.x) +
           (c - a) * f.y * (1.0 - f.x) +
           (d - b) * f.x * f.y;
}

mat2 rot(float ang) {
	float c = cos(ang);
    float s = sin(ang);
    return mat2(c, -s, s, c);
}

float smin( float a, float b, float k )
{
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*k*(1.0/4.0);
}

float sdIntersect(float d1, float d2) { return max(d1, d2); }

float sdFrame(vec3 p) {
    float ang = 0.2;
    
    vec3 q = p;
    q.y = abs(q.y);
    
    float tb = length((q.yz * rot(-ang)).x - 1.0);

    q = p;
    q.x = abs(q.x);
    float lr = length((q.xz * rot(-ang)).x - 1.0);
    
    float d = smin(lr, tb, 0.05); // Smooth corners.
    float dp = length(p.z) - 0.75; // Clip frame front/back.
    
    float surface = noise((p.xy + p.yz) * 60.0);
    return sdIntersect(d, dp) - surface * 0.001;
}

float length6( vec3 p ) { p=p*p*p; p=p*p; return pow(p.x+p.y+p.z,1.0/6.0); }

float sdScreen(vec3 p) {
    float d = length(p) - 1.1;
    float d2 = length6(p) - 1.1;

    float surface = noise((p.xy + p.yz) * 200.0);
    return mix(d, d2, 0.8) - surface * 0.0001;
}

vec2 map(vec3 p) {
    float d1 = sdFrame(p);
    float d2 = sdScreen(p);
    return d1 < d2 ? vec2(d1, 0.5) : vec2(d2, 1.5);
}

vec3 calcNormal(in vec3 p) {
    // Thanks community! I didn't fancy deriving this...
    vec3 n = vec3(0.0);
    for (int i = 0; i < 4; i++)
    {
        vec3 e = 0.5773*(2.0*vec3((((i+3)>>1)&1),((i>>1)&1),(i&1)) - 1.0);
        n += e * map(p + 0.0005 * e).x;
    }
    
    return normalize(n);
}

float calcShadow(vec3 origin, vec3 lightOrigin, float fuzziness) {
    float s = 1.0;
    
    vec3 rayDir = normalize(lightOrigin - origin);
    float d = 1.0;
    while (d < 20.0 && s > 0.0) {
        float distToObj = map(origin + rayDir * d).x;
        s = min(s, 0.5 + 0.5 * distToObj / (fuzziness * d));
        d += clamp(distToObj, 0.2, 1.0);
    }
    
    return smoothstep(0.0, 1.0, s);
}

float calcOcclusion(vec3 origin, vec3 n, float unu) {
    float occ = 0.0;
    float d = 0.01;
    for (int i = 1; i < 5; i++) {
        float h = map(origin + n * d).x;
        occ += d - h;
        d += 0.15;
    }
    
    return 1.0 - clamp(occ * 0.5, 0.0, 1.0);
}

float calcSpec(vec3 rd, vec3 n, vec3 l)
{
    vec3 h = normalize(l - rd);
    return pow(max(dot(h, n), 0.0), 100.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy - 0.5;
    
    vec3 ro = vec3(0.0, 0.0, -3.0); // z = -3.0
    vec3 rd = normalize(vec3(uv, 1.0));
    
    vec3 lightPos = normalize(vec3(5.0, 10.0, -10.0));
    
    float d = 0.01;
    vec2 hit;
    vec3 p;
    for(float steps = 0.0; steps < 64.0; steps++) {
        p = ro + rd * d;
        vec2 dist = map(p);
        if (abs(dist.x) < 0.001 * d) {
			hit = dist;
            break;
        }
        if (d > 8.0)
            break;// todo - limit max dist
        
        d += dist.x;
    }
    
    vec3 col = vec3(0);
    
    if (hit.y > 0.0) {
        vec3 n = calcNormal(p);
        float mainLight = clamp(dot(n, lightPos), 0.2, 1.0);
		float occ = calcOcclusion(p, n, 0.5);
        vec3 rearLight = vec3(0.1, 1.0, 0.1) * clamp(dot(n, vec3(0.0, 0.0, -1.0)), 0.0, 1.0);
            
        if (hit.y > 1.0) {
            // Hit screen.
            vec2 t = uv * 0.85;
            t.x *= mix(1.0, 2.0, pow(abs(t.x) / 0.5, 5.0));
            vec3 tex = texture(iChannel0, t + 0.5).rgb;
            float lum = 0.2126 * tex.r + 0.7152 * tex.g + 0.0722 * tex.b;
            float scanline = 0.3 + 0.7 * floor(mod(t.y * iResolution.y * 0.3 / cos(p.x * 0.5), 2.0));
            col = vec3(0.1, 1.0, 0.1) * pow(lum * 2.0, 1.7) * pow(mainLight, 3.0) * scanline;
        } else {
            // Hit frame.
	        col = vec3(mainLight);
            col *= calcShadow(p + 0.01 * d, lightPos, 1.0);
	        col += rearLight;
        }
        
        col *= pow(occ, 2.0);
        col += calcSpec(rd, n, lightPos) * 0.3;
    }
    
    fragColor = vec4(pow(col , vec3(0.4545)), 1.0);
}

vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	//mainImage( color,vec2(MAIN_pos.x,1.0-MAIN_pos.y));
	mainImage( color,vec2(MAIN_pos.x,MAIN_pos.y));
	return color;
}
