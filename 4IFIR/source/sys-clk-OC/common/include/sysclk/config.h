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

const uint32_t CHARGING_CURRENT_MA_LIMIT = 3000;

typedef enum {
    SysClkConfigValue_PollingIntervalMs = 0,
    SysClkConfigValue_TempLogIntervalMs,
    SysClkConfigValue_CsvWriteIntervalMs,
    SysClkConfigValue_AutoCPUBoost,
    SysClkConfigValue_SyncReverseNXMode,
    SysClkConfigValue_AllowUnsafeFrequencies,
    SysClkConfigValue_ChargingCurrentLimit,
    SysClkConfigValue_ChargingLimitPercentage,
    SysClkConfigValue_GovernorExperimental,
    SysClkConfigValue_EnumMax,
} SysClkConfigValue;

typedef struct {
    uint64_t values[SysClkConfigValue_EnumMax];
} SysClkConfigValueList;

static inline const char* sysclkFormatConfigValue(SysClkConfigValue val, bool pretty)
{
    switch(val)
    {
        case SysClkConfigValue_PollingIntervalMs:
            return pretty ? "Polling Interval (ms)" : "poll_interval_ms";
        case SysClkConfigValue_TempLogIntervalMs:
            return pretty ? "Temperature logging interval (ms)" : "temp_log_interval_ms";
        case SysClkConfigValue_CsvWriteIntervalMs:
            return pretty ? "CSV write interval (ms)" : "csv_write_interval_ms";
        case SysClkConfigValue_AutoCPUBoost:
            return pretty ? "Auto CPU Boost" : "auto_cpu_boost";
        case SysClkConfigValue_SyncReverseNXMode:
            return pretty ? "Sync ReverseNX Mode Sync" : "sync_reversenx_mode";
        case SysClkConfigValue_AllowUnsafeFrequencies:
            return pretty ? "Allow Unsafe Frequencies" : "allow_unsafe_freq";
        case SysClkConfigValue_ChargingCurrentLimit:
            return pretty ? "Charging Current Limit (mA)" : "charging_current";
        case SysClkConfigValue_ChargingLimitPercentage:
            return pretty ? "Charging Limit (%%)" : "charging_limit_perc";
        case SysClkConfigValue_GovernorExperimental:
            return pretty ? "Frequency Governor (Experimental)" : "governor_experimental";
        default:
            return NULL;
    }
}

static inline uint64_t sysclkDefaultConfigValue(SysClkConfigValue val)
{
    switch(val)
    {
        case SysClkConfigValue_PollingIntervalMs:
            return 500ULL;
        case SysClkConfigValue_TempLogIntervalMs:
        case SysClkConfigValue_CsvWriteIntervalMs:
        case SysClkConfigValue_AllowUnsafeFrequencies:
        case SysClkConfigValue_GovernorExperimental:
        case SysClkConfigValue_AutoCPUBoost:
            return 0ULL;
        case SysClkConfigValue_SyncReverseNXMode:
            return 1ULL;
        case SysClkConfigValue_ChargingCurrentLimit:
            return 2000ULL;
        case SysClkConfigValue_ChargingLimitPercentage:
            return 100ULL;
        default:
            return 0ULL;
    }
}

static inline uint64_t sysclkValidConfigValue(SysClkConfigValue val, uint64_t input)
{
    switch(val)
    {
        case SysClkConfigValue_PollingIntervalMs:
            return input > 0;
        case SysClkConfigValue_TempLogIntervalMs:
        case SysClkConfigValue_CsvWriteIntervalMs:
            return true;
        case SysClkConfigValue_AutoCPUBoost:
        case SysClkConfigValue_SyncReverseNXMode:
        case SysClkConfigValue_AllowUnsafeFrequencies:
        case SysClkConfigValue_GovernorExperimental:
            return (input & 0x1) == input;
        case SysClkConfigValue_ChargingCurrentLimit:
            return (input >= 100 && input <= CHARGING_CURRENT_MA_LIMIT && input % 100 == 0);
        case SysClkConfigValue_ChargingLimitPercentage:
            return (input <= 100 && input >= 20);
        default:
            return false;
    }
}