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

//The MIT License
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#define MAX_DIST 8.0

#define SKY_BRITE 0.6

#define CRINKLY_SHIP 0 // set to 1 to give the ship some texture


const float atmos_thick = 30000.0;
const float earth_rad = 6310000.0;

float atmos_dist(in float dir_y) {
	// r^2 * dir_x^2 + (earth_rad + r *dir_y)^2 =
    // (atmos_thick + earth_rad)^2
    // r^2 * (dir_x^2 + dir_y^2) + 
    // r * 2.0 * dir_y * earth_rad +
    // earth_rad^2 -
    // (atmos_thick + earth_rad)^2 = 0.0
    // -------------------------------
    // r^2 * (dir_x^2 + dir_y^2) + 
    // r * 2.0 * dir_y * earth_rad -
    // atmos_thick^2 -
    // 2.0 * atmos_thick * earth_rad = 0.0
    // -------------------------------
    //r = (-b + sqrt(b^2 - 4ac)) / (2a)
    // a = 1.0
    // b = 2.0 * dir_y * earth_rad
	// c = -atmos_thick^2 - 2.0 * atmos_thick * earth_rad
    // r approx 
    // -dir_y*earth_rad + sqrt(dir_y^2+1.005)*earth_rad
    float b = 2.0 * dir_y * earth_rad;
    float c = -atmos_thick * atmos_thick - 2.0 * atmos_thick * earth_rad;
    return 0.5 * (sqrt(b * b - 4.0 * c) - b);
}

float dist_to_sun_visible(in vec3 ray_dir, in vec3 sun_dir) {
    if (false && ray_dir.y < 0.0) {
        return earth_rad;
    }
    if (sun_dir.y > 0.0) {
        return 1.0;
    }
    // e_z = sun_dir
    vec3 e_y = normalize(vec3(0.0, 1.0, 0.0) - sun_dir.y * sun_dir);
    vec3 e_x = normalize(cross(e_y, sun_dir));

    vec2 start_xy = earth_rad * vec2(e_x.y, e_y.y);
    vec2 ray_xy = vec2(dot(e_x,ray_dir), dot(e_y, ray_dir)); // do not normalize
    
    // (start_xy + d * ray_xy) ^2 = earth_rad^2
    // dot(start_xy, start_xy) - earth_rad^2 +
    // 2.0 * d * dot(start_xy, ray_xy) +
    // d^2 * dot(ray_xy, ray_xy) = 0.0
    
    float a = dot(ray_xy, ray_xy);
    float b = 2.0 * dot(start_xy, ray_xy);
    float c = dot(start_xy, start_xy) - earth_rad * earth_rad;
    
    return abs((-b + sqrt(b * b - 4.0 * a * c)) / (2.0 * a));
    
}

float atmos_weight(in vec3 dir, in vec3 sun_dir) {
    float d = atmos_dist(dir.y);
    float ds = max(atmos_thick, dist_to_sun_visible(dir, sun_dir));
    return max(0.0, atmos_thick/ds - (0.5 * atmos_thick)/d);
}

vec3 get_sun_dir(in float in_time) {
    
    float theta = mod(0.5 * in_time, 31.41592653589793);
    float ctheta = cos(theta);
    float stheta = sin(theta);
    
    mat3 rot_mat = mat3(ctheta, 0.0, -stheta,
                        0.0, 1.0, 0.0,
                        stheta, 0.0, ctheta);
    const vec3 sun_dir = normalize(vec3(0.0, 0.0, 1.0));
    
    const mat3 tilt_mat = mat3(0.8, 0.6, 0.0,
                               -0.6, 0.8, 0.0,
                               0.0, 0.0, 1.0);
    const mat3 inv_tilt_mat = mat3(0.8, -0.6, 0.0,
                               0.6, 0.8, 0.0,
                               0.0, 0.0, 1.0);
    vec3 dir = tilt_mat * sun_dir;
    dir = rot_mat * dir;
	return inv_tilt_mat * dir;
}

/**
 * Found some "Rayleigh scatter" equations on wikipedia.
 * Mostly copied them, but dropped some terms and simplified others.
 *
 * Vaguely ends up looking like a blue sky.
 */
vec3 sky_color(in vec3 dir) {
	vec3 sun_dir = get_sun_dir(-0.1); // -1.5);
    const vec3 lambdas = vec3(0.6, 0.5, 0.45);
    const vec3 sky_color_weights = vec3(0.9, 1.0, 0.8);
    const vec3 scatter_terms =
        sky_color_weights * vec3(0.0625) / (lambdas * lambdas * lambdas * lambdas);
    float cos_theta = max(min(dot(dir, sun_dir), 1.0), -1.0);
    float dir_factor = (1.0 + cos_theta * cos_theta) * 0.5;
    float w = atmos_weight(dir, sun_dir);
    float sin_theta = sqrt(1.0 - cos_theta * cos_theta);
    vec3 scatter_factor = w * 2.0 * scatter_terms;
    vec3 passthru = max(1.0 - scatter_factor, vec3(0.0));
    float direct_intense = smoothstep(0.02, 0.018, sin_theta) * step(0.0, cos_theta);
    return dir_factor * scatter_factor + direct_intense * passthru;
}




float s_min(in float x, in float y, in float s) {

    float bridge =
        clamp(abs(x-y)/s, 0.0, 1.0);
    return min(x,y) - 0.25 * s * (bridge - 1.0) * (bridge - 1.0);
}

float s_max(in float x, in float y, in float s) {
    float bridge =
        clamp(abs(x-y)/s, 0.0, 1.0);
    return max(x,y) + 0.25 * s * (bridge - 1.0) * (bridge - 1.0);
}

float falloff(in float x, in float range) {
    float h = smoothstep(range, 0.0, 1.0/x);
    return h * 0.1 * range / s_max(0.1 * range, 1.0/x, 0.05 * range);
}

vec3 perturb2(in vec3 loc) {
    return loc;
}

float vehicle_sdf2(in vec3 loc) {
    float ball1 = length(loc - vec3(0.0, -1.8, 0.0)) - 2.0;
    float ball2 = length(loc - vec3(0.0, 2.0, 0.0)) - 2.1;
    float disc = s_max(ball1, ball2, 0.05);
    float ball3 = length(loc - vec3(0.0, 0.07, 0.0)) - 0.5;
    float result = s_min(disc, max(ball3, -loc.y), 0.1);
    float mult = 1.0;
#if CRINKLY_SHIP    
    mult = 1.0 + 0.95 * mult;
#else
    mult = 1.0 + 0.95 * mult * smoothstep(0.025, 0.05, result);    
#endif
    return result * mult;
}

vec3 vehicle_sdf2_grad(in vec3 loc) {
    float dist = vehicle_sdf2(perturb2(loc));
    const float del = 0.01;
    return vec3(vehicle_sdf2(perturb2(loc + vec3(del, 0.0, 0.0))) - dist,
                vehicle_sdf2(perturb2(loc + vec3(0.0, del, 0.0))) - dist,
                vehicle_sdf2(perturb2(loc + vec3(0.0, 0.0, del))) - dist) / del;
}


float cast_to_vehicle2(in vec3 orig, in vec3 dir, out float sumdist) {
    vec3 p = orig;
    float accum = 0.0;
    sumdist = 0.0;
    for (int i = 0; i < 256; ++i) {
        float dist = vehicle_sdf2(p);
        // mindist = min(dist, mindist);
    	float remaining = 0.2 * dist;
        sumdist += remaining / max(1.0e-3, abs(dist));
        accum += remaining;
        p = orig + accum * dir;
        p = perturb2(p);
        if (remaining < 1.0e-3) {
            return accum;
        }
        if (accum > MAX_DIST) {
            return accum;
        }
    }
	return max(accum, MAX_DIST + 1.0);
}

vec3 get_bounce2(in vec3 pt, in vec3 dir, out float edge_term) {
    vec3 norm = normalize(vehicle_sdf2_grad(pt));
    edge_term = smoothstep(0.7, 0.3, abs(dot(normalize(dir), norm)));
    return normalize(reflect(dir, norm));
}




vec4 castRayUFO(in vec2 fragCoord) {
	vec2 uv = (2.0 * fragCoord.xy - iResolution.xy) / iResolution.y;
	vec3 ray_orig = vec3(0.0, 0.5, -5.0);
	vec3 ray_dir = normalize(vec3(uv, 7.0));
    
    float wiggle = abs(mod(0.2 * iTime, 4.0) - 2.0) - 1.0;
    wiggle = 0.2 * sign(wiggle) * smoothstep(0.0, 1.0, abs(wiggle));// - 1.5;
    float ct = sin(wiggle);
    float st = cos(wiggle);
    mat3 twist = mat3(ct, 0.0, st,
                      0.0, 1.0, 0.0,
                      -st, 0.0, ct);
    ray_dir = twist * ray_dir;
    ray_orig = twist * ray_orig;
    wiggle = 0.05 * sin(iTime);
    ct = cos(wiggle);st = sin(wiggle);
    twist = mat3(ct, st, 0.0,
                 -st, ct, 0.0,
                 0.0, 0.0, 1.0);
    wiggle = 0.05 * sin(0.71 *iTime + 1.3);
    ct = cos(wiggle);st = sin(wiggle);
    twist *= mat3(1.0, 0.0, 0.0,
                  0.0, ct, st,
                 0.0, -st, ct);

    ray_dir = twist * ray_dir;
    ray_orig = twist * ray_orig;
    
    ray_orig = ray_orig - vec3(0.0, 0.2, 0.0) -
        sin(vec3(4.2, 1.2, 3.4) * iTime) * 0.2 * vec3(0.5, 0.1, 0.2);
    float closeness = MAX_DIST;
    float d = cast_to_vehicle2(ray_orig, ray_dir, closeness);
    
    vec3 ray_mul = vec3(1.0);
    vec3 paste_color = vec3(0.0);
    if (d < MAX_DIST) {
        vec3 pt = ray_orig + d * ray_dir;
        float edginess = 0.0;
        ray_dir = get_bounce2(pt, ray_dir, edginess);
        ray_mul = mix(vec3(1.0, 0.9, 0.85), ray_mul, edginess);
        vec2 window_cent = vec2(0.0, 0.3);
        vec2 window_size = vec2(0.7, 0.4);
        vec2 projected = (pt.zy - window_cent) / window_size;

        if (abs(projected.x) < 0.5 && abs(projected.y) < 0.5) {
            paste_color = texture(iChannel0, projected + vec2(0.5)).rgb;
            paste_color *= smoothstep(0.5, 0.45, length(projected));
        }
    }

    vec3 thump = sin(vec3(0.1, 0.8, -0.6) + iTime * vec3(4.1, 6.5, 5.2));
    thump = 0.3 * smoothstep(0.8, 1.0, thump);

    float darken = 0.15 * (1.0 + 3.0 * smoothstep(1.5, 0.5, dot(thump, vec3(1.0))));
    return vec4(SKY_BRITE * darken * ray_mul * sky_color(ray_dir) +
                (0.25 + 1.75 * smoothstep(0.05, 0.8, thump))
                * falloff(closeness, 0.5) + paste_color, 1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	fragColor = castRayUFO(fragCoord);
}

vec4 hook(){
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	mainImage( color,vec2(MAIN_pos.x,1.0-MAIN_pos.y));
	//mainImage( color,vec2(MAIN_pos.x,MAIN_pos.y));
	return color;
}


