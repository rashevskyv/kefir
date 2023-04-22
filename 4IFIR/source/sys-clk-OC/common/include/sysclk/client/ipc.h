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
extern "C" {
#endif

#include "types.h"
#include "../config.h"
#include "../clocks.h"
#include "../ipc.h"

bool sysclkIpcRunning();
Result sysclkIpcInitialize(void);
void sysclkIpcExit(void);

Result sysclkIpcGetAPIVersion(u32* out_ver);
Result sysclkIpcGetVersionString(char* out, size_t len);
Result sysclkIpcGetCurrentContext(SysClkContext* out_context);
Result sysclkIpcGetProfileCount(u64 tid, u8* out_count);
Result sysclkIpcSetEnabled(bool enabled);
Result sysclkIpcExitCmd();
Result sysclkIpcSetOverride(SysClkModule module, u32 hz);
Result sysclkIpcGetProfiles(u64 tid, SysClkTitleProfileList* out_profiles);
Result sysclkIpcSetProfiles(u64 tid, SysClkTitleProfileList* profiles);
Result sysclkIpcGetConfigValues(SysClkConfigValueList* out_configValues);
Result sysclkIpcSetConfigValues(SysClkConfigValueList* configValues);
Result sysclkIpcSetReverseNXRTMode(ReverseNXMode mode);
Result sysclkIpcGetFrequencyTable(SysClkModule module, SysClkProfile profile, SysClkFrequencyTable* out_table);
Result sysclkIpcGetIsMariko(bool* out_is_mariko);
Result sysclkIpcGetBatteryChargingDisabledOverride(bool* out_is_true);
Result sysclkIpcSetBatteryChargingDisabledOverride(bool toggle_true);

static inline Result sysclkIpcRemoveOverride(SysClkModule module)
{
    return sysclkIpcSetOverride(module, 0);
}

#ifdef __cplusplus
}
#endif
