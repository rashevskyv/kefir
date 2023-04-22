/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include <cstring>
#include <nxExt.h>
#include "clocks.h"
#include "errors.h"
#include "file_utils.h"

Result Clocks::GetRange(SysClkModule module, SysClkProfile profile, uint32_t** min, uint32_t** max)
{
    switch (module) {
        case SysClkModule_CPU:
        case SysClkModule_GPU:
        case SysClkModule_MEM:
            *min = freqRange[module].min;
            *max = freqRange[module].max[profile];
            break;
        default:
            ERROR_THROW("No such PcvModule: %u", module);
    }

    if (!*min || !*max || *max < *min || size_t(*max - *min + 1) > sizeof(SysClkFrequencyTable))
        return SYSCLK_ERROR(InternalFrequencyTableError);

    return 0;
}

void Clocks::UpdateFreqRange() {
    freqRange[SysClkModule_MEM].InitDefault(SysClkModule_MEM);
    if (isMariko) {
        freqRange[SysClkModule_MEM].first = freqRange[SysClkModule_MEM].min = freqRange[SysClkModule_MEM].FindFreq(1600'000'000);
    }

    freqRange[SysClkModule_CPU].InitDefault(SysClkModule_CPU);
    uint32_t* cpu_max_freq = freqRange[SysClkModule_CPU].last;
    uint32_t CPU_SAFE_MAX = isMariko ? 1963'500'000 : 1785'000'000;
    uint32_t CPU_UNSAFE_MAX[SysClkProfile_EnumMax];
    for (auto &m : CPU_UNSAFE_MAX) {
        m = *cpu_max_freq;
    }
    if (!isMariko) {
        CPU_UNSAFE_MAX[SysClkProfile_Handheld] = 1785'000'000;
    }

    freqRange[SysClkModule_GPU].InitDefault(SysClkModule_GPU);
    uint32_t* gpu_max_freq = freqRange[SysClkModule_GPU].last;
    uint32_t GPU_SAFE_MAX[SysClkProfile_EnumMax];
    if (isMariko) {
        for (auto &m : GPU_SAFE_MAX) {
            m = 998'400'000;
        }
    } else {
        GPU_SAFE_MAX[SysClkProfile_Handheld] = \
        GPU_SAFE_MAX[SysClkProfile_HandheldCharging] = 460'800'000;
        GPU_SAFE_MAX[SysClkProfile_HandheldChargingUSB] = 768'000'000;
        GPU_SAFE_MAX[SysClkProfile_HandheldChargingOfficial] = \
        GPU_SAFE_MAX[SysClkProfile_Docked] = 921'600'000;
    };
    uint32_t GPU_UNSAFE_MAX[SysClkProfile_EnumMax];
    for (auto &m : GPU_UNSAFE_MAX) {
        m = *gpu_max_freq;
    }
    if (isMariko) {
        GPU_UNSAFE_MAX[SysClkProfile_Handheld] = 998'400'000;
    } else {
        memcpy(GPU_UNSAFE_MAX, GPU_SAFE_MAX, sizeof(GPU_UNSAFE_MAX));
    }

    const bool use_unsafe = allowUnsafe;
    for (int i = 0; i < int(SysClkProfile_EnumMax); i++) {
        freqRange[SysClkModule_CPU].max[i] = std::min(cpu_max_freq,
            freqRange[SysClkModule_CPU].FindFreq(use_unsafe ? CPU_UNSAFE_MAX[i] : CPU_SAFE_MAX, SysClkProfile(i)));
        freqRange[SysClkModule_GPU].max[i] = std::min(gpu_max_freq,
            freqRange[SysClkModule_GPU].FindFreq(use_unsafe ? GPU_UNSAFE_MAX[i] : GPU_SAFE_MAX[i], SysClkProfile(i)));
    }
}

Result Clocks::GetTable(SysClkModule module, SysClkProfile profile, SysClkFrequencyTable* out_table) {
    uint32_t* min = NULL;
    uint32_t* max = NULL;
    if (Result res = GetRange(module, profile, &min, &max)) {
        return res;
    }

    memset(out_table, 0, sizeof(SysClkFrequencyTable));
    uint32_t* p = min;
    size_t idx = 0;
    while(p <= max)
        out_table->freq[idx++] = *p++;

    return 0;
}

void Clocks::SetAllowUnsafe(bool allow) {
    if (allowUnsafe != allow) {
        allowUnsafe = allow;
        UpdateFreqRange();
    }
};

void Clocks::Initialize()
{
    Result rc = 0;

    u64 hardware_type = 0;
    rc = splInitialize();
    ASSERT_RESULT_OK(rc, "splInitialize");
    rc = splGetConfig(SplConfigItem_HardwareType, &hardware_type);
    ASSERT_RESULT_OK(rc, "splGetConfig");
    splExit();

    switch (hardware_type) {
        case 0: // Icosa
        case 1: // Copper
            isMariko = false;
            break;
        case 2: // Hoag
        case 3: // Iowa
        case 4: // Calcio
        case 5: // Aula
            isMariko = true;
            break;
        default:
            ERROR_THROW("Unknown hardware type: 0x%X!", hardware_type);
            return;
    }

    if(hosversionAtLeast(8,0,0))
    {
        rc = clkrstInitialize();
        ASSERT_RESULT_OK(rc, "pcvInitialize");
    }
    else
    {
        rc = pcvInitialize();
        ASSERT_RESULT_OK(rc, "pcvInitialize");
    }

    rc = apmExtInitialize();
    ASSERT_RESULT_OK(rc, "apmExtInitialize");

    rc = psmInitialize();
    ASSERT_RESULT_OK(rc, "psmInitialize");

    rc = tsInitialize();
    ASSERT_RESULT_OK(rc, "tsInitialize");

    if(hosversionAtLeast(5,0,0))
    {
        rc = tcInitialize();
        ASSERT_RESULT_OK(rc, "tcInitialize");
    }

    FileUtils::ParseLoaderKip();

    UpdateFreqRange();
}

void Clocks::Exit()
{
    if(hosversionAtLeast(8,0,0))
    {
        pcvExit();
    }
    else
    {
        clkrstExit();
    }

    apmExtExit();
    psmExit();
    tsExit();

    if(hosversionAtLeast(5,0,0))
    {
        tcExit();
    }
}

const char* Clocks::GetModuleName(SysClkModule module, bool pretty)
{
    const char* result = sysclkFormatModule(module, pretty);

    if(!result)
    {
        ERROR_THROW("No such SysClkModule: %u", module);
    }

    return result;
}

const char* Clocks::GetProfileName(SysClkProfile profile, bool pretty)
{
    const char* result = sysclkFormatProfile(profile, pretty);

    if(!result)
    {
        ERROR_THROW("No such SysClkProfile: %u", profile);
    }

    return result;
}

const char* Clocks::GetThermalSensorName(SysClkThermalSensor sensor, bool pretty)
{
    const char* result = sysclkFormatThermalSensor(sensor, pretty);

    if(!result)
    {
        ERROR_THROW("No such SysClkThermalSensor: %u", sensor);
    }

    return result;
}

PcvModule Clocks::GetPcvModule(SysClkModule sysclkModule)
{
    switch(sysclkModule)
    {
        case SysClkModule_CPU:
            return PcvModule_CpuBus;
        case SysClkModule_GPU:
            return PcvModule_GPU;
        case SysClkModule_MEM:
            return PcvModule_EMC;
        default:
            ERROR_THROW("No such SysClkModule: %u", sysclkModule);
    }

    return (PcvModule)0;
}

PcvModuleId Clocks::GetPcvModuleId(SysClkModule sysclkModule)
{
    PcvModuleId pcvModuleId;
    Result rc = pcvGetModuleId(&pcvModuleId, GetPcvModule(sysclkModule));
    ASSERT_RESULT_OK(rc, "pcvGetModuleId");

    return pcvModuleId;
}

SysClkApmConfiguration* Clocks::GetEmbeddedApmConfig(uint32_t confId)
{
    SysClkApmConfiguration* apmConfiguration = NULL;
    for(size_t i = 0; sysclk_g_apm_configurations[i].id; i++)
    {
        if(sysclk_g_apm_configurations[i].id == confId)
        {
            apmConfiguration = &sysclk_g_apm_configurations[i];
            break;
        }
    }

    if(!apmConfiguration)
    {
        ERROR_THROW("Unknown apm configuration: %x", confId);
    }
    return apmConfiguration;
}

uint32_t Clocks::GetStockClock(SysClkApmConfiguration* apm, SysClkModule module)
{
    switch (module) {
        case SysClkModule_CPU:
            return apm->cpu_hz;
        case SysClkModule_GPU:
            return apm->gpu_hz;
        case SysClkModule_MEM:
            return GetIsMariko() ? MEM_CLOCK_MARIKO_MIN : apm->mem_hz;
        default:
            ERROR_THROW("Unknown SysClkModule: %x", module);
            return 0;
    }
}

void Clocks::ResetToStock(unsigned int module)
{
    if(hosversionAtLeast(9,0,0))
    {
        std::uint32_t confId = 0;
        Result rc = apmExtGetCurrentPerformanceConfiguration(&confId);
        ASSERT_RESULT_OK(rc, "apmExtGetCurrentPerformanceConfiguration");

        SysClkApmConfiguration* apmConfiguration = GetEmbeddedApmConfig(confId);

        if (module == SysClkModule_EnumMax || module == SysClkModule_CPU)
        {
            Clocks::SetHz(SysClkModule_CPU, GetStockClock(apmConfiguration, SysClkModule_CPU));
        }
        if (module == SysClkModule_EnumMax || module == SysClkModule_GPU)
        {
            Clocks::SetHz(SysClkModule_GPU, GetStockClock(apmConfiguration, SysClkModule_GPU));
        }
        if (module == SysClkModule_EnumMax || module == SysClkModule_MEM)
        {
            Clocks::SetHz(SysClkModule_MEM, GetStockClock(apmConfiguration, SysClkModule_MEM));
        }
    }
    else
    {
        Result rc = 0;
        std::uint32_t mode = 0;
        rc = apmExtGetPerformanceMode(&mode);
        ASSERT_RESULT_OK(rc, "apmExtGetPerformanceMode");

        rc = apmExtSysRequestPerformanceMode(mode);
        ASSERT_RESULT_OK(rc, "apmExtSysRequestPerformanceMode");
    }
}

SysClkProfile Clocks::GetCurrentProfile()
{
    std::uint32_t mode = 0;
    Result rc = apmExtGetPerformanceMode(&mode);
    ASSERT_RESULT_OK(rc, "apmExtGetPerformanceMode");

    if(mode)
    {
        return SysClkProfile_Docked;
    }

    PsmChargerType chargerType;

    rc = psmGetChargerType(&chargerType);
    ASSERT_RESULT_OK(rc, "psmGetChargerType");

    switch(chargerType)
    {
        case PsmChargerType_EnoughPower:
            return SysClkProfile_HandheldChargingOfficial;
        case PsmChargerType_LowPower:
        case PsmChargerType_NotSupported:
            return SysClkProfile_HandheldChargingUSB;
        default:
            return SysClkProfile_Handheld;
    }
}

void Clocks::SetHz(SysClkModule module, std::uint32_t hz)
{
    Result rc = 0;

    if(hosversionAtLeast(8,0,0))
    {
        ClkrstSession session = {0};

        rc = clkrstOpenSession(&session, Clocks::GetPcvModuleId(module), 3);
        ASSERT_RESULT_OK(rc, "clkrstOpenSession");
        rc = clkrstSetClockRate(&session, hz);
        ASSERT_RESULT_OK(rc, "clkrstSetClockRate");

        clkrstCloseSession(&session);
    }
    else
    {
        rc = pcvSetClockRate(Clocks::GetPcvModule(module), hz);
        ASSERT_RESULT_OK(rc, "pcvSetClockRate");
    }
}

std::uint32_t Clocks::GetCurrentHz(SysClkModule module)
{
    Result rc = 0;
    std::uint32_t hz = 0;

    if(hosversionAtLeast(8,0,0))
    {
        ClkrstSession session = {0};

        rc = clkrstOpenSession(&session, Clocks::GetPcvModuleId(module), 3);
        ASSERT_RESULT_OK(rc, "clkrstOpenSession");

        rc = clkrstGetClockRate(&session, &hz);
        ASSERT_RESULT_OK(rc, "clkrstGetClockRate");

        clkrstCloseSession(&session);
    }
    else
    {
        rc = pcvGetClockRate(Clocks::GetPcvModule(module), &hz);
        ASSERT_RESULT_OK(rc, "pcvGetClockRate");
    }

    return hz;
}

std::uint32_t Clocks::GetNearestHz(SysClkModule module, SysClkProfile profile, std::uint32_t inHz)
{
    uint32_t *min = nullptr, *max = nullptr;
    if (GetRange(module, profile, &min, &max))
        ERROR_THROW("table lookup failed for SysClkModule: %u", module);

    return *GetNearestHzPtr(min, max, inHz);
}

std::int32_t Clocks::GetTsTemperatureMilli(TsLocation location)
{
    Result rc;
    std::int32_t millis = 0;

    if(hosversionAtLeast(14,0,0))
    {
        rc = tsGetTemperature(location, &millis);
        ASSERT_RESULT_OK(rc, "tsGetTemperature(%u)", location);
        millis *= 1000;
    }
    else
    {
        rc = tsGetTemperatureMilliC(location, &millis);
        ASSERT_RESULT_OK(rc, "tsGetTemperatureMilliC(%u)", location);
    }

    return millis;
}

std::uint32_t Clocks::GetTemperatureMilli(SysClkThermalSensor sensor)
{
    std::int32_t millis = 0;

    if(sensor == SysClkThermalSensor_SOC)
    {
        millis = GetTsTemperatureMilli(TsLocation_External);
    }
    else if(sensor == SysClkThermalSensor_PCB)
    {
        millis = GetTsTemperatureMilli(TsLocation_Internal);
    }
    else if(sensor == SysClkThermalSensor_Skin)
    {
        if(hosversionAtLeast(5,0,0))
        {
            Result rc = tcGetSkinTemperatureMilliC(&millis);
            ASSERT_RESULT_OK(rc, "tcGetSkinTemperatureMilliC");
        }
    }
    else
    {
        ERROR_THROW("No such SysClkThermalSensor: %u", sensor);
    }

    return std::max(0, millis);
}