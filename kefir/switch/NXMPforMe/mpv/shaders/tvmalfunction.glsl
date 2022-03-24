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

// Fake TV Screen Malfunction by Tambako
//
// To add:
// * Smooth vert borders. Maybe lighter ?
// * Black and white color definitions
// * Emboss ?
// * Vignette
// * Horizontal oscillations
// * Global time scale for harmonics etc.
// * Saturation + contrast
// * Convolution (separate for image and for noise)
// * Sound
//
// - Set harmonics as arrays 
// - Warp ?
// - Scanlines ?
// - Specular ?

const vec3 black_point = vec3(0.05, 0.08, 0.24);
const vec3 white_point = vec3(0.94, 0.90, 0.87);

const float im_saturation = 0.5;
const float im_contrast = 1.2;
const float im_brightness = 0.1;

const float noise1_min = 0.13;
const float noise1_max = 0.93;
const vec4 noise1_freq = vec4(1.4, 2.2, 3.8, 4.2);
const vec4 noise1_amp = vec4(2.5, 1.85, 1.22, 0.9);
const float noise1_threshold = 0.83;

const float noise2_min = 0.06;
const float noise2_max = 0.81;
const vec4 noise2_freq = vec4(0.75, 1.74, 2.12, 3.05);
const vec4 noise2_amp = vec4(2.2, 1.45, 1.12, 0.7);
const float noise2_threshold = 0.78;
const float noise2_saturation = 0.2;

const vec4 colhsh_freq = vec4(0.86, 1.32, 1.82, 2.25);
const vec4 colhsh_amp = vec4(1.45, 2.35, 1.12, 0.58);
const float colhsh_threshold = 0.92;
const float colhsh_intmin = 0.37;
const float colhsh_intmax = 0.40;

const vec4 colvsh_freq = vec4(0.46, 1.92, 3.82, 4.15);
const vec4 colvsh_amp = vec4(2.45, 1.35, 1.02, 0.5);
const float colvsh_threshold = 0.92;
const float colvsh_intmin = 2.80;
const float colvsh_intmax = 2.85;

const vec4 vsize_freq = vec4(0.045, 0.084, 0.112, 0.161);
const vec4 vsize_amp = vec4(1.6, 2.3, 2.7, 1.3);
const float vsize_threshold = 0.73;
const float vsize_factor = 0.21;

const mat3 im_convm = mat3( 1.0,  2.0,  -4.0,
                            2.0,  3.0,  3.0,
                           -2.0,  2.0,  1.0);

const mat3 noise_convm = mat3( 1.0,  2.0,  1.0,
                               2.0,  6.0,  0.0,
                              -2.0,  2.0,  1.0);

const float border_smoothness1 = 0.012;
const float border_smoothness2 = 0.020;
const float border_maxint = 1.16;

const float vig_falloff = 0.32;

const float emb_delta = 3.;
const float emb_int = 0.07;
const vec2 emb_speed = vec2(400., 100);

const float hosc_yfreq1 = 105.;
const float hosc_tfreq1 = 34.;
const float hosc_amp1 = 0.00036;
const float hosc_yfreq2 = 188.;
const float hosc_tfreq2 = 57.;
const float hosc_amp2 = 0.00024;

const float time_factor = 0.75;

float rand1(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.,85.5))) * 120.01);
}

float rand2(vec2 co)
{
    float r1 = fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
    return fract(sin(dot(vec2(r1, co.xy*1.562) ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 noise1(vec2 fragCoord)
{
	vec2 uvr = 1.1*fragCoord.xy / iResolution.xy + iTime*14.9;
    
    return vec4(vec3(rand1(uvr)*0.7+0.3), 1.0);   
}

vec4 noise2(vec2 fragCoord)
{
	vec2 uvr = 1.124*fragCoord.xy / iResolution.xy + iTime*3.3242;
    vec2 uvg = 2.549*fragCoord.xy / iResolution.xy + iTime*4.2623;
    vec2 uvb = 3.846*fragCoord.xy / iResolution.xy + iTime*6.2344;
    
    return vec4(mix(vec3(rand2(uvr))*1.5, vec3(rand2(uvr), rand2(uvg), rand2(uvb)), noise2_saturation), 1.0);
}

vec4 noise1conv(mat3 mat, vec2 pos)
{
   vec4 pixval = vec4(0.);
   float csum = 0.;
   
   for (int y=0; y<3; y++)
   {
       for (int x=0; x<3; x++)
       {
           vec2 ipos = pos + vec2(float(x-1), float(y-1));
           pixval+= noise1(ipos)*mat[x][y];
           csum+= mat[x][y];
       }
   }
   return pixval/csum; 
}

vec4 noise2conv(mat3 mat, vec2 pos)
{
   vec4 pixval = vec4(0.);
   float csum =0.;
   
   for (int y=0; y<3; y++)
   {
       for (int x=0; x<3; x++)
       {
           vec2 ipos = pos + vec2(float(x-1), float(y-1));
           pixval+= noise2(ipos)*mat[x][y];
           csum+= mat[x][y];
       }
   }
   return pixval/csum; 
}

float harms(vec4 freq, vec4 amp, float threshold)
{
   float val = 0.;
   for (int h=0; h<4; h++)
      val+= amp[h]*sin(iTime*time_factor*freq[h]);
   val = (1. + val/(amp[0]+amp[1]+amp[2]+amp[3]))/2.;
   return smoothstep(threshold, 1., val);
}

vec4 iconv(mat3 mat, vec2 pos)
{
   vec4 pixval = vec4(0.);
   float csum =0.;
   
   for (int y=0; y<3; y++)
   {
       for (int x=0; x<3; x++)
       {
           vec2 ipos = pos + vec2(float(x-1)/iResolution.x, 1.0-float(y-1)/iResolution.y);
           pixval+= texture(iChannel0, ipos)*mat[x][y];
           csum+= mat[x][y];
       }
   }
   return pixval/csum;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec4 im;
    vec2 uv0 = fragCoord.xy / iResolution.xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = vec2(uv.x,1.0-uv.y);
	
    float iTime2 = iTime*time_factor;
    
    // Vertical size
    float vsize_f = 1. + vsize_factor*harms(vsize_freq, vsize_amp, vsize_threshold);
    uv = uv*vec2(1., vsize_f) + vec2(0., (1.-vsize_f)/2.);
    float vsize_f2 = border_smoothness1 + border_smoothness2 - 0.005;
    uv.y*= 1. - 2.*vsize_f2;
    uv.y+= vsize_f2;
    
    // Side oscillations
    uv.x+= hosc_amp1*(sin(uv.y*hosc_yfreq1 + iTime2*hosc_tfreq1));
    uv.x+= hosc_amp2*(sin(uv.y*hosc_yfreq2 + iTime2*hosc_tfreq2));

    // Color specific dynamic shift
    float colhsh_d = harms(colhsh_freq, colhsh_amp, colhsh_threshold);
    float colvsh_d = harms(colvsh_freq, colvsh_amp, colvsh_threshold);
    
    vec2 uvr = mod(uv + vec2(colhsh_d*colhsh_intmin, colvsh_d*colvsh_intmin), 1.);
    vec2 uvg = mod(uv + vec2(colhsh_d*(colhsh_intmin + colhsh_intmax)/2., colvsh_d*(colvsh_intmin + colvsh_intmax)/2.), 1.);
    vec2 uvb = mod(uv + vec2(colhsh_d*colhsh_intmax, colvsh_d*colvsh_intmax), 1.);
    
    vec4 wcam;
    
    // Convolution
    //wcam.r = texture(iChannel0, uvr).r;
    //wcam.g = texture(iChannel0, uvg).g;
    //wcam.b = texture(iChannel0, uvb).b;
    wcam = iconv(im_convm, uvr); 
    wcam*= vsize_f;
    
    // Saturation
    wcam = mix(vec4((wcam.r + wcam.g + wcam.b)/3.), wcam, im_saturation);
    
    // Constrast
    wcam = wcam*im_contrast - 0.5*im_contrast + 0.5 + im_brightness;
    
    // Emboss
    vec2 d = iTime2 * emb_speed;
    vec2 uv1 = uv - d/iResolution.xy;
    vec2 uv2 = uv  + (vec2(emb_delta, emb_delta) - d)/iResolution.xy;
    uv1 = mod(uv1, 1.);
    uv2 = mod(uv2, 1.);
    vec4 embc = texture(iChannel0,uv2) - texture(iChannel0,uv1);
    float embi = emb_int*(embc.r + embc.g + embc.b)/3.;
    im = wcam + vec4(embi, embi, embi, 1.);
    
    // Pseudo-harmonic noise
    float noise1_b = harms(noise1_freq, noise1_amp, noise1_threshold)*(noise1_max-noise1_min)+noise1_min;
    im = mix(im, noise1conv(noise_convm, fragCoord), noise1_b);
    
    // White noise
    float noise2_b = harms(noise2_freq, noise2_amp, noise2_threshold)*(noise2_max-noise2_min)+noise2_min;
    im = mix(im, noise2conv(noise_convm, fragCoord), noise2_b);
    
    // Black and white point
    im = im*vec4(white_point - black_point, 1.) + vec4(black_point, 1.);
    
    // Vignette (www.shadertoy.com/view/4lSXDm)
    vec2 coord = (uv0 - 0.5) * (iResolution.x/iResolution.y) * 2.0;
    float rf = sqrt(dot(coord, coord)) * vig_falloff;
    float rf2_1 = rf * rf + 1.0;
    float e = 1.0 / (rf2_1 * rf2_1);
    im*= e;
    
    // Top/bottom borders
    float border_maxint2 = border_maxint*vsize_f;
    float border_smoothness22 = border_smoothness2*pow(vsize_f, 2.);
    im*= smoothstep(0., border_smoothness1, uv.y)*(1. - smoothstep(1.-border_smoothness1, 1., uv.y));
    im*= border_maxint2*(1./border_maxint2 + (1. - 1./border_maxint2)*(1. - smoothstep(border_smoothness1, border_smoothness1 + border_smoothness22, uv.y)));
    im*= border_maxint2*(1./border_maxint2 + (1. - 1./border_maxint2)*(smoothstep(1. - border_smoothness1 - border_smoothness22, 1. - border_smoothness1, uv.y)));    
    
    fragColor = im;
}

vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	mainImage( color,vec2(MAIN_pos.x,1.0-MAIN_pos.y));
	//mainImage( color,vec2(MAIN_pos.x,MAIN_pos.y));
	return color;
}
