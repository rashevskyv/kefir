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



#define N_CHARS 2.0    // how many characters are in the character image
#define Y_PIXELS 24.0  // reduce input image to this many mega-pixels from top to bottom
#define DROP_SPEED 0.5 // how fast the drips fall
#define ASPECT 2.7     // aspect ratio of input webcam image relative to matrix characters
#define MIN_DROP_SPEED 0.2    // range 0-1. is added to column speeds to avoid stopped columns.
#define STATIC_STRENGTH 0.1   // range 0-1. how intense is the tv static
#define SCANLINE_STRENGTH 0.4 // range 0-1. how dark are the tv scanlines
#define NUM_SCANLINES 70.0    // how many scanlines in entire image
#define GRADIENT_BLACK 0.2    // range 0-1. how dark do the darkest parts of the drip-gradients
#define MATRIX_OPACITY 0.8    // range 0-1. matrix effect has this much solidity over original image

// random functions adapted from https://www.shadertoy.com/view/lsXSDn                  
float rand2d(vec2 v){
    return fract(sin(dot(v.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(float x) {
    return fract(sin(x) * 3928.2413);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    // pixelate webcam image into mega-pixels
    float xPix = floor(uv.x * Y_PIXELS * ASPECT) / Y_PIXELS / ASPECT;
    float yPix = floor(uv.y * Y_PIXELS) / Y_PIXELS;
    vec2 uvPix = vec2(xPix, yPix);
    // ideally we should blur the input image to reduce flickering
    vec4 pixelColor = texture(iChannel0, uvPix);

    // compute uv within each mega-pixel
    vec2 uvInPix = vec2(
    	mod(uv.x * Y_PIXELS * ASPECT, 1.0),
    	mod(uv.y * Y_PIXELS, 1.0)
    );

    // offset char image to appropriate char
    float charOffset = floor(pixelColor.r * N_CHARS * 0.999) / N_CHARS;
    uvInPix.x = uvInPix.x / N_CHARS + charOffset;
    vec4 charColor = texture(iChannel1, uvInPix);
    
    // falling drip highlight
    float highlightClock = -2.0 + yPix + iTime*DROP_SPEED + rand(xPix);
    float highlight = mod(1.0 - max(0.0, highlightClock), 1.0);
    highlight = mix(highlight, 1.0, GRADIENT_BLACK);
    charColor *= highlight * 1.5;
    
	// mixer controls where the original image is visible
    // before the drips cover it
    float mixer = clamp(highlightClock * 100.0, 0.0, 1.0);
    
    // multiply char images and webcam mega-pixels
    float result = charColor.r * pixelColor.r;

    // add scanlines
    result *= 1.0 - SCANLINE_STRENGTH * (sin(uv.y * NUM_SCANLINES*3.14159*2.0)/2.0+0.5);
    
	// map to a black->green->white gradient
    vec4 greenResult = vec4(
        max(0.0, result*3.0 - 1.2),
        result*1.6,
        max(0.0, result*3.0 - 1.5),
        1.0
    );
        
    // add tv static
    float stat = rand2d(uv * vec2(0.0005, 1.0) + iTime * 0.1) * STATIC_STRENGTH;
    greenResult += stat;
    greenResult = mix(pixelColor, greenResult, MATRIX_OPACITY);
    
    // mix original image behind drips
    vec4 origImage = texture(iChannel0, uv);
    fragColor = mix(origImage, greenResult, mixer);
}

vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	//mainImage( color,vec2(MAIN_pos.x,1.0-MAIN_pos.y));
	mainImage( color,vec2(MAIN_pos.x,MAIN_pos.y));
	return color;
}
