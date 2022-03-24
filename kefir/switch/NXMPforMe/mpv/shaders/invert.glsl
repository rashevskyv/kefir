//!HOOK LUMA
//!BIND HOOKED

vec4 hook()
{
    float luma = LUMA_texOff(0).x;
    return vec4(1.0 - luma);
}