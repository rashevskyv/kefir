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

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

typedef enum
{
    SysClkProfile_Handheld = 0,
    SysClkProfile_HandheldCharging,
    SysClkProfile_HandheldChargingUSB,
    SysClkProfile_HandheldChargingOfficial,
    SysClkProfile_Docked,
    SysClkProfile_EnumMax
} SysClkProfile;

typedef enum
{
    SysClkModule_CPU = 0,
    SysClkModule_GPU,
    SysClkModule_MEM,
    SysClkModule_EnumMax
} SysClkModule;

typedef enum
{
    SysClkThermalSensor_SOC = 0,
    SysClkThermalSensor_PCB,
    SysClkThermalSensor_Skin,
    SysClkThermalSensor_EnumMax
} SysClkThermalSensor;

typedef struct
{
    uint8_t  enabled;
    uint64_t applicationId;
    SysClkProfile profile;
    uint32_t freqs[SysClkModule_EnumMax];
    uint32_t overrideFreqs[SysClkModule_EnumMax];
    uint32_t temps[SysClkThermalSensor_EnumMax];
    uint32_t perfConfId;
} SysClkContext;

typedef enum
{
    ReverseNX_NotFound = 0,
    ReverseNX_SystemDefault = 0,
    ReverseNX_Handheld,
    ReverseNX_Docked,
} ReverseNXMode;

typedef struct
{
    bool systemCoreBoostCPU;
    bool batteryChargingDisabledOverride;
    SysClkProfile realProfile;
} SysClkOcExtra;

#define FREQ_TABLE_MAX_ENTRY_COUNT  31

typedef struct
{
    uint32_t freq[FREQ_TABLE_MAX_ENTRY_COUNT];
} SysClkFrequencyTable;

typedef enum {
    SysClkOcGovernorConfig_AllDisabled  = 0,
    SysClkOcGovernorConfig_CPU_Shift    = 0,
    SysClkOcGovernorConfig_CPUOnly      = 1 << SysClkOcGovernorConfig_CPU_Shift,
    SysClkOcGovernorConfig_CPU          = 1 << SysClkOcGovernorConfig_CPU_Shift,
    SysClkOcGovernorConfig_GPU_Shift    = 1,
    SysClkOcGovernorConfig_GPUOnly      = 1 << SysClkOcGovernorConfig_GPU_Shift,
    SysClkOcGovernorConfig_GPU          = 1 << SysClkOcGovernorConfig_GPU_Shift,
    SysClkOcGovernorConfig_AllEnabled   = 3,
    SysClkOcGovernorConfig_Default      = 3,
    SysClkOcGovernorConfig_Mask         = 3,
} SysClkOcGovernorConfig;

inline bool GetGovernorEnabled(SysClkOcGovernorConfig config, SysClkModule module) {
    switch (module) {
        case SysClkModule_CPU:
            return (config >> SysClkOcGovernorConfig_CPU_Shift) & 1;
        case SysClkModule_GPU:
            return (config >> SysClkOcGovernorConfig_GPU_Shift) & 1;
        case SysClkModule_MEM:
            return false;
        default:
            return config != SysClkOcGovernorConfig_AllDisabled;
    }
}

inline SysClkOcGovernorConfig ToggleGovernor(SysClkOcGovernorConfig prev, SysClkModule module, bool state) {
    uint8_t shift;
    switch (module) {
        case SysClkModule_CPU:
            shift = SysClkOcGovernorConfig_CPU_Shift;
            break;
        case SysClkModule_GPU:
            shift = SysClkOcGovernorConfig_GPU_Shift;
            break;
        case SysClkModule_MEM:
            return prev;
        default:
            return state ? SysClkOcGovernorConfig_AllEnabled : SysClkOcGovernorConfig_AllDisabled;
    }
    return (SysClkOcGovernorConfig)((prev & ~(1 << shift)) | state << shift);
}

typedef struct
{
    union {
        uint32_t mhz[(size_t)SysClkProfile_EnumMax * (size_t)SysClkModule_EnumMax];
        uint32_t mhzMap[SysClkProfile_EnumMax][SysClkModule_EnumMax];
    };
    SysClkOcGovernorConfig governorConfig;
} SysClkTitleProfileList;

#define SYSCLK_GLOBAL_PROFILE_TID       0xA111111111111111

extern uint32_t g_freq_table_mem_hz[];
extern uint32_t g_freq_table_cpu_hz[];
extern uint32_t g_freq_table_gpu_hz[];

#define SYSCLK_ENUM_VALID(n, v) ((v) < n##_EnumMax)

static inline const char* sysclkFormatModule(SysClkModule module, bool pretty)
{
    switch(module)
    {
        case SysClkModule_CPU:
            return pretty ? "CPU" : "cpu";
        case SysClkModule_GPU:
            return pretty ? "GPU" : "gpu";
        case SysClkModule_MEM:
            return pretty ? "Memory" : "mem";
        default:
            return NULL;
    }
}

static inline const char* sysclkFormatThermalSensor(SysClkThermalSensor thermSensor, bool pretty)
{
    switch(thermSensor)
    {
        case SysClkThermalSensor_SOC:
            return pretty ? "SOC" : "soc";
        case SysClkThermalSensor_PCB:
            return pretty ? "PCB" : "pcb";
        case SysClkThermalSensor_Skin:
            return pretty ? "Skin" : "skin";
        default:
            return NULL;
    }
}

static inline const char* sysclkFormatProfile(SysClkProfile profile, bool pretty)
{
    switch(profile)
    {
        case SysClkProfile_Docked:
            return pretty ? "Docked" : "docked";
        case SysClkProfile_Handheld:
            return pretty ? "Handheld" : "handheld";
        case SysClkProfile_HandheldCharging:
            return pretty ? "Charging" : "handheld_charging";
        case SysClkProfile_HandheldChargingUSB:
            return pretty ? "USB Charger" : "handheld_charging_usb";
        case SysClkProfile_HandheldChargingOfficial:
            return pretty ? "Official Charger" : "handheld_charging_official";
        default:
            return NULL;
    }
}
