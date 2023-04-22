/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include <nxExt.h>
#include "errors.h"
#include "clock_manager.h"
#include "file_utils.h"
#include "clocks.h"
#include "process_management.h"
#include <cstring>

ClockManager* ClockManager::instance = NULL;

ClockManager* ClockManager::GetInstance()
{
    return instance;
}

void ClockManager::Exit()
{
    if(instance)
    {
        delete instance;
    }
}

void ClockManager::Initialize()
{
    if(!instance)
    {
        instance = new ClockManager();
    }
}

ClockManager::ClockManager()
{
    this->config = Config::CreateDefault();
    this->context = new SysClkContext;
    this->context->applicationId = 0;
    this->context->profile = SysClkProfile_Handheld;
    this->context->enabled = false;
    for(unsigned int i = 0; i < SysClkModule_EnumMax; i++)
    {
        this->context->freqs[i] = 0;
        this->context->overrideFreqs[i] = 0;
    }
    this->context->perfConfId = 0;
    this->running = false;
    this->lastTempLogNs = 0;
    this->lastCsvWriteNs = 0;

    this->oc = new SysClkOcExtra;
    this->oc->systemCoreBoostCPU = false;
    this->oc->batteryChargingDisabledOverride = false;
    this->oc->realProfile = SysClkProfile_Handheld;

    this->rnxSync = new ReverseNXSync;
    this->governor = new Governor();
}

ClockManager::~ClockManager()
{
    delete this->governor;
    delete this->rnxSync;
    delete this->oc;
    delete this->context;
    delete this->config;
}

void ClockManager::SetRunning(bool running)
{
    this->running = running;
}

bool ClockManager::Running()
{
    return this->running;
}

uint32_t ClockManager::GetHz(SysClkModule module)
{
    /* Temp override setting */
    uint32_t hz = this->context->overrideFreqs[module];

    /* Per-Game setting */
    if (!hz)
        hz = this->config->GetAutoClockHz(this->context->applicationId, module, this->context->profile);

    /* Global profile */
    if (!hz)
        hz = this->config->GetAutoClockHz(SYSCLK_GLOBAL_PROFILE_TID, module, this->context->profile);

    /* Return pre-set hz */
    ReverseNXMode mode;
    if (!hz && (mode = this->rnxSync->GetMode()))
    {
        switch (module)
        {
            case SysClkModule_CPU:
                hz = 1020'000'000;
                break;
            case SysClkModule_GPU:
                hz = (mode == ReverseNX_Docked ||
                      this->oc->realProfile == SysClkProfile_Docked) ?
                        768'000'000 : 460'800'000;
                break;
            case SysClkModule_MEM:
                hz = MEM_CLOCK_DOCK;
                break;
            default:
                break;
        }
    }

    if (hz)
    {
        /* Considering realProfile frequency limit */
        hz = Clocks::GetNearestHz(module, this->oc->realProfile, hz);
    }

    /* Handle CPU Auto Boost, no user-defined hz required */
    if (module == SysClkModule_CPU)
    {
        if (this->oc->systemCoreBoostCPU && hz < Clocks::boostCpuFreq)
            return Clocks::boostCpuFreq;
        if (!hz)
            /* Trigger RefreshContext() and Tick(), resetting default CPU frequency */
            return 1020'000'000;
    }

    return hz;
}

void ClockManager::Tick()
{
    std::scoped_lock lock{this->contextMutex};

    if (this->RefreshContext() && this->context->enabled)
    {
        for (unsigned int module = 0; module < SysClkModule_EnumMax; module++)
        {
            uint32_t hz = GetHz((SysClkModule)module);
            this->governor->SetMaxHz(hz, (SysClkModule)module);

            if (hz && hz != this->context->freqs[module] && !this->governor->IsHandledByGovernor((SysClkModule)module))
            {
                // Skip setting CPU or GPU clocks in CpuBoostMode if CPU <= boostCPUFreq or GPU >= 76.8MHz
                bool skipBoost = apmExtIsBoostMode(this->context->perfConfId) &&
                    ((module == SysClkModule_CPU && hz <= Clocks::boostCpuFreq) || module == SysClkModule_GPU);

                if (!skipBoost) {
                    FileUtils::LogLine("[mgr] %s clock set : %u.%u MHz", Clocks::GetModuleName((SysClkModule)module, true), hz/1000000, hz/100000 - hz/1000000*10);
                    Clocks::SetHz((SysClkModule)module, hz);
                    uint32_t hz_now = Clocks::GetCurrentHz((SysClkModule)module);
                    if (hz != hz_now)
                        FileUtils::LogLine("[mgr] Cannot set %s clock to %u.%u MHz", Clocks::GetModuleName((SysClkModule)module, true), hz/1000000, hz/100000 - hz/1000000*10);
                    this->context->freqs[module] = hz_now;
                }
            }
        }
    }
}

void ClockManager::WaitForNextTick()
{
    /* Self-check system core (#3) usage via idleticks at intervals (Not enabled at higher CPU freq or without charger) */
    uint64_t tickWaitTimeMs = this->GetConfig()->GetConfigValue(SysClkConfigValue_PollingIntervalMs);

    if (this->governor->IsHandledByGovernor(SysClkModule_CPU)) {
        svcSleepThread(tickWaitTimeMs * 1000'000ULL);
        return;
    }

    bool boostOK =
        this->GetConfig()->GetConfigValue(SysClkConfigValue_AutoCPUBoost) &&
        this->context->enabled &&
        this->oc->realProfile != SysClkProfile_Handheld &&
        this->context->freqs[SysClkModule_CPU] <= Clocks::boostCpuFreq;

    if (boostOK) {
        uint32_t core3Util = CpuCoreUtil(3, tickWaitTimeMs * 1000'000ULL).Get();
        bool lastBoost = this->oc->systemCoreBoostCPU;
        this->oc->systemCoreBoostCPU = (core3Util >= BOOST_THRESHOLD);

        if (lastBoost && !this->oc->systemCoreBoostCPU)
            Clocks::SetHz(SysClkModule_CPU, GetHz(SysClkModule_CPU));

        if (!lastBoost && this->oc->systemCoreBoostCPU)
            Clocks::SetHz(SysClkModule_CPU, Clocks::boostCpuFreq);

        return;
    }

    if (this->oc->systemCoreBoostCPU) {
        this->oc->systemCoreBoostCPU = false;
        Clocks::SetHz(SysClkModule_CPU, GetHz(SysClkModule_CPU));
    }
    svcSleepThread(tickWaitTimeMs * 1000'000ULL);
}

bool ClockManager::RefreshContext()
{
    PsmExt::ChargingHandler(this->GetInstance());

    bool hasChanged = false;
    SysClkProfile realProfile = Clocks::GetCurrentProfile();
    if (realProfile != this->oc->realProfile)
    {
        FileUtils::LogLine("[mgr] Profile change: %s", Clocks::GetProfileName(realProfile, true));
        this->oc->realProfile = realProfile;
        // Signal that power state has been changed, reset the override
        this->SetBatteryChargingDisabledOverride(false);
        hasChanged = true;
    }

    hasChanged = this->config->Refresh();
    if (hasChanged) {
        this->rnxSync->ToggleSync(this->GetConfig()->GetConfigValue(SysClkConfigValue_SyncReverseNXMode));
        bool allowUnsafe = this->GetConfig()->GetConfigValue(SysClkConfigValue_AllowUnsafeFrequencies);
        Clocks::SetAllowUnsafe(allowUnsafe);

        this->governor->SetAutoCPUBoost(this->GetConfig()->GetConfigValue(SysClkConfigValue_AutoCPUBoost));
        this->governor->SetCPUBoostHz(Clocks::GetNearestHz(SysClkModule_CPU, this->oc->realProfile, Clocks::boostCpuFreq));
    }

    bool enabled = this->GetConfig()->Enabled();
    if(enabled != this->context->enabled)
    {
        this->context->enabled = enabled;
        FileUtils::LogLine("[mgr] " TARGET " status: %s", enabled ? "enabled" : "disabled");
        hasChanged = true;
    }

    std::uint64_t applicationId = ProcessManagement::GetCurrentApplicationId();
    if (applicationId != this->context->applicationId)
    {
        FileUtils::LogLine("[mgr] TitleID change: %016lX", applicationId);
        this->context->applicationId = applicationId;
        hasChanged = true;

        /* Clear ReverseNX state */
        this->rnxSync->Reset(applicationId);
    }

    SysClkOcGovernorConfig governorConfig = SysClkOcGovernorConfig_AllDisabled;
    if (this->GetConfig()->GetConfigValue(SysClkConfigValue_GovernorExperimental)) {
        governorConfig = SysClkOcGovernorConfig_Default;
        SysClkOcGovernorConfig governorConfigTitle = this->GetConfig()->GetTitleGovernorConfig(applicationId);
        if (governorConfig != governorConfigTitle)
            governorConfig = governorConfigTitle;
    }
    this->governor->SetConfig(governorConfig);

    /* Update PerformanceConfigurationId */
    {
        uint32_t confId = 0;
        Result rc = 0;
        rc = apmExtGetCurrentPerformanceConfiguration(&confId);
        ASSERT_RESULT_OK(rc, "apmExtGetCurrentPerformanceConfiguration");
        if (this->context->perfConfId != confId)
        {
            this->context->perfConfId = confId;
            this->governor->SetPerfConf(confId);
            hasChanged = true;
        }
    }

    {
        SysClkProfile current  = this->context->profile;
        SysClkProfile expected = this->rnxSync->GetProfile(this->oc->realProfile);
        this->context->profile = expected;
        if (current != expected)
            hasChanged = true;
    }

    // let ptm module handle boost clocks rather than resetting
    if (hasChanged && !apmExtIsBoostMode(this->context->perfConfId)) {
        Clocks::ResetToStock();
    }

    std::uint32_t hz = 0;
    for (unsigned int module = 0; module < SysClkModule_EnumMax; module++)
    {
        hz = Clocks::GetCurrentHz((SysClkModule)module);

        if (hz != 0 && hz != this->context->freqs[module])
        {
            this->context->freqs[module] = hz;
            if (!this->governor->IsHandledByGovernor((SysClkModule)module)) {
                FileUtils::LogLine("[mgr] %s clock change: %u.%u MHz", Clocks::GetModuleName((SysClkModule)module, true), hz/1000000, hz/100000 - hz/1000000*10);
                hasChanged = true;
            }
        }

        hz = this->GetConfig()->GetOverrideHz((SysClkModule)module);
        if (hz != this->context->overrideFreqs[module])
        {
            if(hz)
            {
                FileUtils::LogLine("[mgr] %s override change: %u.%u MHz", Clocks::GetModuleName((SysClkModule)module, true), hz/1000000, hz/100000 - hz/1000000*10);
            }
            else
            {
                FileUtils::LogLine("[mgr] %s override disabled", Clocks::GetModuleName((SysClkModule)module, true));
                Clocks::ResetToStock(module);
            }
            this->context->overrideFreqs[module] = hz;
            hasChanged = true;
        }
    }

    // temperatures do not and should not force a refresh, hasChanged untouched
    std::uint32_t millis = 0;
    std::uint64_t ns = armTicksToNs(armGetSystemTick());
    std::uint64_t tempLogInterval = this->GetConfig()->GetConfigValue(SysClkConfigValue_TempLogIntervalMs) * 1000000ULL;
    bool shouldLogTemp = tempLogInterval && ((ns - this->lastTempLogNs) > tempLogInterval);
    for (unsigned int sensor = 0; sensor < SysClkThermalSensor_EnumMax; sensor++)
    {
        millis = Clocks::GetTemperatureMilli((SysClkThermalSensor)sensor);
        if(shouldLogTemp)
        {
            FileUtils::LogLine("[mgr] %s temp: %u.%u °C", Clocks::GetThermalSensorName((SysClkThermalSensor)sensor, true), millis/1000, (millis - millis/1000*1000) / 100);
        }
        this->context->temps[sensor] = millis;
    }

    if(shouldLogTemp)
    {
        this->lastTempLogNs = ns;
    }

    std::uint64_t csvWriteInterval = this->GetConfig()->GetConfigValue(SysClkConfigValue_CsvWriteIntervalMs) * 1000000ULL;

    if(csvWriteInterval && ((ns - this->lastCsvWriteNs) > csvWriteInterval))
    {
        FileUtils::WriteContextToCsv(this->context);
        this->lastCsvWriteNs = ns;
    }

    return hasChanged;
}

void ClockManager::SetRNXRTMode(ReverseNXMode mode) {
    this->rnxSync->SetRTMode(mode);
}

SysClkContext ClockManager::GetCurrentContext()
{
    std::scoped_lock lock{this->contextMutex};
    return *this->context;
}

Config* ClockManager::GetConfig()
{
    return this->config;
}

bool ClockManager::GetBatteryChargingDisabledOverride() {
    return this->oc->batteryChargingDisabledOverride;
}

Result ClockManager::SetBatteryChargingDisabledOverride(bool toggle_true) {
    this->oc->batteryChargingDisabledOverride = toggle_true;
    return 0;
}
