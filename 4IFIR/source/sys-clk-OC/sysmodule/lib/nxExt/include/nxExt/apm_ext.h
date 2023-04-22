/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

#include <switch.h>

Result apmExtInitialize(void);
void apmExtExit(void);

// Silently fail
Result apmExtSysRequestPerformanceMode(u32 mode);
Result apmExtSysSetCpuBoostMode(u32 mode);

Result apmExtGetPerformanceMode(u32 *out_mode);
Result apmExtGetCurrentPerformanceConfiguration(u32 *out_conf);

inline bool apmExtIsCPUBoosted(u32 conf_id) { // CPU boosted to 1785 MHz
    return (conf_id == 0x92220009 || conf_id == 0x9222000A);
};
inline bool apmExtIsBoostMode(u32 conf_id)  { // GPU throttled to 76.8 MHz
    return (conf_id >= 0x92220009 && conf_id <= 0x9222000C);
};

#ifdef __cplusplus
}
#endif
