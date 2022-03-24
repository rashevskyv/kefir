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
// Game Console-powered webcam.
// Intended for video meetings using iq's MemixApp.
// Thanks to Evvvvil (Glow Broski!), Flopine, Nusan, BigWings, and a bunch of others for sharing their knowledge!

// License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

float glow = 0.0;
float pathGlow = 0.0;
float terrainGlow = 0.0;

#define gt (mod(iTime, 10.0))


float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

mat2 rot(float a) {
    float c = cos(a);
    float s = sin(a);
    return mat2(c, s, -s, c);
}

float sdSphere(vec3 p, float r) {
    return length(p) - r;
}

float sdBox( vec3 p, vec3 b ) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x,max(q.y,q.z)), 0.0);
}

float sdCylinder(vec3 p, float r, float h) {
	vec2 d = abs(vec2(length(p.xy), p.z)) - vec2(h, r);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

float sdCapsule(vec3 p, float h, float r) {
  p.x -= clamp(p.x, 0.0, h);
  return length(p) - r;
}

vec3 getRayDir(vec3 ro, vec3 lookAt, vec2 uv) {
    vec3 forward = normalize(lookAt - ro);
    vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), forward));
    vec3 up = cross(forward, right);
    return normalize(forward + right * uv.x + up * uv.y);
}

vec2 min2(vec2 a, vec2 b) {
    return a.x < b.x ? a : b;
}

vec4 min4(vec4 a, vec4 b) {
    return a.x < b.x ? a : b;
}

vec3 sdScreen(vec3 p, vec3 box) {
    box *= vec3(0.85, 0.45, 0.05);
    p += vec3(0.0, -0.8, 0.27);
    return vec3(sdBox(p, box) - 0.025, p.x / box.x * 0.5, p.y / box.y * 0.5);
}

float sdButton(vec3 p) {
    float d = sdCylinder(p, 0.08, 0.08) - 0.05;
    float r = 2.0;
    return smin(d, -sdSphere(p + vec3(0.0, 0.0, r + 0.1), r), -0.05);
}

float sdControls(vec3 p) {
    // D-pad
    vec3 pp = p + vec3(0.55, 0.45, 0.37);
    vec3 dpad = vec3(0.1, 0.3, 0.1);
    float d = min(sdBox(pp, dpad), sdBox(pp, dpad.yxz));
    float r = 2.0;
    d = smin(d, -sdSphere(pp + vec3(0.0, 0.0, r), r), -0.05);
    r = 0.17;
    d = max(d, -sdSphere(pp + vec3(0.0, 0.0, r * 0.9), r));
    
    // Fire buttons.
    d = min(d, sdButton(p + vec3(-0.32, 0.5, 0.3)));
    d = min(d, sdButton(p + vec3(-0.7, 0.35, 0.3)));

    // Start/select.
    p += vec3(0.0, 1.15, 0.34);
    p.x = abs(p.x) - 0.12;
    d = min(d, sdCapsule(p, 0.2, 0.06));
    
    return d;
}

vec4 sdCase(vec3 p) {
    const float height = 3.4;
    
    p.yz *= rot(sin(fract(iTime * 0.1) * 6.283) * 0.1);
    p.xz *= rot(sin(fract(iTime * 0.2) * 6.283) * 0.2);
    
    // Front base.
    vec3 pp = p;
    pp.z += pp.z < 0.0 ? (abs(0.5 + 0.5 * cos(pp.y * 0.7)) - 1.0) * max(0.0, (-pp.y - 1.3) / height * 2.0) : 0.0;
    
    float edgeIndent = sin(3.14159 * smoothstep(-0.10, -0.04, pp.z)) * 0.005;
    vec3 box = vec3(1.0, height / 2.0, 0.2);
    float d = sdBox(pp, box - vec3(edgeIndent, edgeIndent, 0.0)) - 0.1;
    
    // P1 P2
    pp = p + vec3(0.00, 0.99, 0.37);
    d = max(d, -sdSphere(pp + vec3(0.22, 0.0, 0.0), 0.08));
    pp.x = abs(pp.x - 0.22) - 0.06;
    d = max(d, -sdSphere(pp + vec3(0.0, 0.0, 0.0), 0.08));

#if 0
    // Rear bump.
    d = smin(d, sdBox(p - vec3(0.0, -0.3, 0.4), box * vec3(0.90, 0.7, 0.2)) - 0.05, 0.2);
#endif
    
    // Power light.
    float power = sdSphere(p - vec3(-0.75, 1.4, -0.3), 0.03);
    glow += 0.01 / (0.01 + power * power * 400.0);
    
    // Screen indent.
    return min4(min4(min4(vec4(d, 1.5, 0.0, 0.0), vec4(sdScreen(p, box), 2.5).xwyz), vec4(power, 3.5, 0.0, 0.0)), vec4(sdControls(p), 4.5, 0.0, 0.0));
}

vec2 sdTraveller(vec3 p) {
    p.z = mod(p.z + gt * 40.0, 50.0) - 25.0;
    
    float open = abs(sin(gt * 4.0));
    
    vec3 pp = p;
    pp.yz *= rot(open);
    float bodyTop = max(sdSphere(pp, 1.3), -pp.y);
    
    pp.yz += vec2(-0.6, 1.0);
    pp.x = abs(pp.x) - 0.6;
    float eyes = sdSphere(pp, 0.2);
    
    p.yz *= rot(-open);
    float bodyBottom = max(sdSphere(p, 1.3), p.y);
    
    float body = min(bodyTop, bodyBottom);
   
    return min2(vec2(body, 6.0), vec2(eyes, 4.0));
}

vec2 sdRoad(vec3 p) {
    p.x += 8.0;
    p.xz *= rot(-0.75 + sin(p.z * 0.1) * 0.06);
    
    p.y += sin(p.z * 0.1);

    // Road.
    p.y += 4.0;
    
    vec3 pp = p;
    pp.x = abs(pp.x) - 2.0;
    float d1 = length(pp.xy) - 0.3;
    
    // Traveller.
    p.z -= 10.0;
    p.y -= 1.0;
    vec2 d2 = sdTraveller(p);
    
    // Glow.
    pathGlow += 0.1 / (0.1 + d1 * d1 * 5.0);
    
    return min2(vec2(d1, 5.0), d2);
}

vec2 sdTerrain(vec3 p) {
    p.y += 5.0;
    p.z += iTime;
    
    p.xz = mod(p.xz, 5.0) - 2.5;

    float d = min(length(p.xy), length(p.yz));
    
    terrainGlow += 0.001 / (0.001 + d * d * 5.0);
    
    return vec2(d, 3.5);
}

vec4 map(vec3 p) {
    return min4(min4(sdCase(p), vec4(sdRoad(p), 0.0, 0.0)), vec4(sdTerrain(p), 0.0, 0.0));
}

vec3 calcNormal(in vec3 p) {
    // Thanks iq!
    vec2 e = vec2(1.0, -1.0) * 0.5773 * 0.0005;
    return normalize(e.xyy * map(p + e.xyy).x + 
					 e.yyx * map(p + e.yyx).x + 
					 e.yxy * map(p + e.yxy).x + 
					 e.xxx * map(p + e.xxx).x);
}

float calcShadow(vec3 p, vec3 lightPos, float sharpness) {
    vec3 rd = normalize(lightPos - p);
    
    float h;
    float minH = 1.0;
    float d = 0.01;
    for (int i = 0; i < 5; i++) {
        h = map(p + rd * d).x;
        minH = abs(h / d);
        if (minH < 0.01)
            return 0.0;
        d += h;
    }
    
    return minH * sharpness;
}

float calcOcc(vec3 p, vec3 n, float strength) {
    const float dist = 0.08;
    return 1.0 - (dist - map(p + n * dist).x) * strength;
}


/**********************************************************************************/


vec3 vignette(vec3 col, vec2 fragCoord) {
    vec2 q = fragCoord.xy / iResolution.xy;
    col *= 0.5 + 0.5 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.4);
    return col;
}

vec3 getWebCam(vec2 uv) {
    if (iTime < 5.0) return vec3(0.01);
    if (iTime < 6.0) return vec3(0.03);
    
    ivec2 t = textureSize(iChannel0, 0);
    float ar = float(t.y) / float(-t.x);
    
    const vec2 res = vec2(160.0, 144.0) * 0.4;
    uv = floor(uv * res) / res;
    
    vec3 col = texture(iChannel0, 1.0-(uv * vec2(ar, 1.0) + vec2(0.5))).rgb;
    col = floor(col * 12.0) / 12.0;
    
    return mix(vec3(0.03), col, clamp(iTime - 7.0, 0.0, 1.0));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    vec3 col = vec3(0.0);

    // Raymarch.
    vec3 ro = vec3(0.0, 1.0, -4.0);
    vec3 rd = getRayDir(ro, vec3(0.0, 0.2, 0.0), uv);

    int hit = 0;
    float d = 0.01;
    vec3 p;
    float steps;
    vec2 puv;
    for (steps = 0.0; steps < 55.0; steps++) {
        p = ro + rd * d;
        vec4 h = map(p);

        if (h.x < 0.001 * d) {
            hit = int(h.y);
            puv = h.zw;
            break;
        }

        d += h.x;
    }

    if (hit > 0) {
        vec3 n = calcNormal(p);
        vec3 lightPos = vec3(3.0, 3.0, -10.0);
        vec3 lightCol = vec3(1.0, 0.9, 0.8);
        vec3 lightToPoint = normalize(lightPos - p);
        vec3 skyCol = vec3(0.05);
        float occ = calcOcc(p, n, 20.0);
        float spe = pow(max(0.0, dot(rd, reflect(lightToPoint, n))), 15.0);
        float mainLight = max(0.0, dot(n, lightToPoint));
        float backLight = clamp(dot(n, -rd), 0.01, 1.0) * 0.1;
        vec3 skyLight = clamp(dot(n, vec3(0.0, 1.0, 0.0)), 0.01, 1.0) * 0.4 * skyCol;
        float fog = 1.0 - exp(-d * 0.03);

        vec3 mat;
        if (hit == 1) {
            // Case
            mat = vec3(0.1, 0.8, 0.15);
        } else if (hit == 2) {
            // Screen.
            vec2 uv = (puv - vec2(0.0, 0.05)) * 1.4;
            mat = abs(uv.x) < 0.5 && abs(uv.y) < 0.5 ? getWebCam(uv) : vec3(0.0);
            
            if (puv.y < -0.36 && puv.y > -0.45) {
                puv.x = (puv.x - 0.45) * 15.0 - puv.y * 8.0;
                if (puv.x > 0.0 && puv.x < 3.0)
                {
                    switch(int(puv.x)) {
                        case 0: mat = vec3(1.0, 0.0, 0.0); break;
                        case 1: mat = vec3(0.0, 1.0, 0.0); break;
                        case 2: mat = vec3(0.0, 0.0, 1.0); break;
                    }
                }
            }
        } else if (hit == 3) {
            // Power light.
            mat = vec3(0.1);
        } else if (hit == 4) {
            // Controls.
            mat = vec3(0.1);
        } else if (hit == 5) {
            // Road.
            mat = vec3(0.7);
        } else if (hit == 6) {
            // Traveller.
            mat = vec3(0.7, 0.7, 0.1) * 2.0;
        }
        
        col = (mainLight + (spe + backLight) * occ) * lightCol;
        col += skyLight * occ;
        col = mix(col * mat, vec3(0.0), fog);
    }
    
    // Glow.
    if (iTime < 5.0) glow = 0.0;
    col += (glow + terrainGlow) * vec3(0.7, 0.1, 0.1);
    col += pathGlow * vec3(0.1, 0.1, 0.8);

    // Output to screen
    col = pow(vignette(col, fragCoord), vec3(0.4545));
    fragColor = vec4(col, 1.0);
}

vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	mainImage( color,vec2(MAIN_pos.x,1.0-MAIN_pos.y));
	//mainImage( color,vec2(MAIN_pos.x,MAIN_pos.y));
	return color;
}
