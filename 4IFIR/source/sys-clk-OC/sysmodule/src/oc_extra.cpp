#include "oc_extra.h"

CpuCoreUtil::CpuCoreUtil(int coreid = -2, uint64_t ns = 1000'000ULL)
    : m_core_id(coreid), m_wait_time_ns(ns) { }

uint32_t CpuCoreUtil::Get() {
    struct _ctx {
        uint64_t systick;
        uint64_t idletick;
    } begin, end;

    begin.systick  = armGetSystemTick();
    begin.idletick = GetIdleTickCount();

    svcSleepThread(m_wait_time_ns);

    end.systick = armGetSystemTick();
    end.idletick = GetIdleTickCount();

    uint64_t diff_idletick = end.idletick - begin.idletick;
    uint64_t diff_systick  = end.systick - begin.systick;
    return UTIL_MAX - diff_idletick * 10 * 100ULL / diff_systick;
}

uint64_t CpuCoreUtil::GetIdleTickCount() {
    uint64_t idletick = 0;
    svcGetInfo(&idletick, InfoType_IdleTickCount, INVALID_HANDLE, m_core_id);
    return idletick;
}


GpuCoreUtil::GpuCoreUtil(uint32_t nvgpu_field)
    : m_nvgpu_field(nvgpu_field) { }

uint32_t GpuCoreUtil::Get() {
    uint32_t load;
    nvIoctl(m_nvgpu_field, NVGPU_GPU_IOCTL_PMU_GET_GPU_LOAD, &load);
    return load;
}


ReverseNXSync::ReverseNXSync()
    : m_rt_mode(ReverseNX_NotFound), m_tool_mode(ReverseNX_NotFound) {
    FILE *fp = fopen("/atmosphere/contents/0000000000534C56/flags/boot2.flag", "r");
    m_tool_enabled = fp ? true : false;
    if (fp)
        fclose(fp);
}

SysClkProfile ReverseNXSync::GetProfile(SysClkProfile real) {
    switch (this->GetMode()) {
        case ReverseNX_Docked:
            return SysClkProfile_Docked;
        case ReverseNX_Handheld:
            if (real == SysClkProfile_Docked)
                return SysClkProfile_HandheldChargingOfficial;
        default:
            return real;
    }
}

ReverseNXMode ReverseNXSync::GetMode() {
    if (!this->m_sync_enabled)
        return ReverseNX_NotFound;
    if (this->m_rt_mode)
        return this->m_rt_mode;
    return this->m_tool_mode;
}

ReverseNXMode ReverseNXSync::GetToolModeFromPatch(const char* patch_path) {
    constexpr uint32_t DOCKED_MAGIC = 0x320003E0;
    constexpr uint32_t HANDHELD_MAGIC = 0x52A00000;
    FILE *fp = fopen(patch_path, "rb");
    if (fp) {
        uint32_t buf = 0;
        fread(&buf, sizeof(buf), 1, fp);
        fclose(fp);

        if (buf == DOCKED_MAGIC)
            return ReverseNX_Docked;
        if (buf == HANDHELD_MAGIC)
            return ReverseNX_Handheld;
    }

    return ReverseNX_NotFound;
}

ReverseNXMode ReverseNXSync::RecheckToolMode() {
    ReverseNXMode mode = ReverseNX_NotFound;
    if (this->m_tool_enabled) {
        const char* fileName = "_ZN2nn2oe16GetOperationModeEv.asm64"; // or _ZN2nn2oe18GetPerformanceModeEv.asm64
        const char* filePath = new char[72];
        SCOPE_EXIT { delete[] filePath; };
        /* Check per-game patch */
        snprintf((char*)filePath, 72, "/SaltySD/patches/%016lX/%s", this->m_app_id, fileName);
        mode = this->GetToolModeFromPatch(filePath);
        if (!mode) {
            /* Check global patch */
            snprintf((char*)filePath, 72, "/SaltySD/patches/%s", fileName);
            mode = this->GetToolModeFromPatch(filePath);
        }
    }

    return mode;
}


void PsmExt::ChargingHandler(ClockManager* instance) {
    u32 current;
    Result res = I2c_Bq24193_GetFastChargeCurrentLimit(&current);
    if (R_SUCCEEDED(res)) {
        current -= current % 100;
        u32 chargingCurrent = instance->GetConfig()->GetConfigValue(SysClkConfigValue_ChargingCurrentLimit);
        if (current != chargingCurrent)
            I2c_Bq24193_SetFastChargeCurrentLimit(chargingCurrent);
    }

    PsmChargeInfo* info = new PsmChargeInfo;
    Service* session = psmGetServiceSession();
    serviceDispatchOut(session, Psm_GetBatteryChargeInfoFields, *info);

    if (PsmIsChargerConnected(info)) {
        u32 chargeNow = 0;
        if (R_SUCCEEDED(psmGetBatteryChargePercentage(&chargeNow))) {
            bool isCharging = PsmIsCharging(info);
            u32 chargingLimit = instance->GetConfig()->GetConfigValue(SysClkConfigValue_ChargingLimitPercentage);
            bool forceDisabled = instance->GetBatteryChargingDisabledOverride();
            if (isCharging && (forceDisabled || chargingLimit <= chargeNow))
                serviceDispatch(session, Psm_DisableBatteryCharging);
            if (!isCharging && chargingLimit > chargeNow)
                serviceDispatch(session, Psm_EnableBatteryCharging);
        }
    }

    delete info;
}

namespace GovernorImpl {

// Schedutil: https://github.com/torvalds/linux/blob/master/kernel/sched/cpufreq_schedutil.c
// C = 1.25, tipping-point 80.0% (used in Linux schedutil), 1.25 -> 1 + (1 >> 2)
// C = 1.5,  tipping-point 66.7%, 1.5 -> 1 + (1 >> 1)
// Utilization is frequency-invariant (normalized):
//   target_freq = C * max_freq(ref_freq) * util / max
void BaseGovernor::ApplyNewFreqFromNormUtil(uint32_t normUtil) {
    auto FindHzInTable = [](uint32_t* list, uint32_t hz) -> uint32_t {
        uint32_t* p = list;
        for (; *p != 0; p++) {
            if (hz <= *p)
                return *p;
        }
        return *(--p);
    };

    uint32_t next_freq = m_ref_hz / UTIL_MAX * normUtil;
    next_freq += next_freq >> 1;

    uint32_t new_hz;
    if (next_freq >= max_hz)
        new_hz = max_hz;
    else if (next_freq <= min_hz)
        new_hz = min_hz;
    else
        new_hz = FindHzInTable(m_hz_list, next_freq);

    ApplyTargetFreq(new_hz);
}

void CpuGovernor::GovernorWorker::Start() {
    if (this->running)
        return;

    this->running = true;
    Result rc = 0;
    for (int id = 0; id < CORE_NUMS; id++) {
        WorkerContext* s = &contexts[id];
        s->super = this->super;
        s->id    = id;
        int prio = (id == CORE_NUMS - 1) ? 0x3F : 0x3B; // Pre-emptive MT
        rc = threadCreate(&threads[id], &WorkerContext::Loop, (void*)s, NULL, 0x400, prio, id);
        ASSERT_RESULT_OK(rc, "threadCreate");
        rc = threadStart(&threads[id]);
        ASSERT_RESULT_OK(rc, "threadStart");
    }
}

void CpuGovernor::GovernorWorker::Stop() {
    if (!this->running)
        return;

    this->running = false;
    svcSleepThread(TICK_TIME_NS);

    for (auto &t : threads) {
        threadWaitForExit(&t);
        threadClose(&t);
    }
}

void CpuGovernor::Apply() {
    uint32_t util = 0;
    for (auto& ctx : this->m_worker.contexts) {
        uint32_t core_util = ctx.util;
        if (util < core_util)
            util = core_util;
    }

    this->m_util.Update(util);
    if (this->auto_boost && this->m_worker.contexts[SYS_CORE_ID].util > BOOST_THRESHOLD)
        this->ApplyBoost();
    else
        this->ApplyNewFreqFromNormUtil(this->m_util.Get());
}

void CpuGovernor::WorkerContext::Loop(void* args) {
    WorkerContext* s = static_cast<WorkerContext*>(args);
    CpuGovernor* self = s->super;
    GovernorWorker* worker = &(self->m_worker);
    int coreid = s->id;

    while (worker->running) {
        uint64_t tick = s->tick = armGetSystemTick();
        s->util = self->CalcNormalizedUtil(CpuCoreUtil(coreid, TICK_TIME_NS).Get());

        if (apmExtIsCPUBoosted(self->m_manager->GetPerfConf())) {
            svcSleepThread(TICK_TIME_NS);
            continue;
        }

        // Check if other cores are stuck
        for (int id = 0; id < CORE_NUMS; id++) {
            if (id == coreid)
                continue;

            uint64_t diff = std::abs((int64_t)worker->contexts[id].tick - (int64_t)tick);
            if (diff < SYSTICK_HZ / SAMPLE_RATE * 10)
                continue;

            // Stuck on system core and auto boost enabled, apply boost
            if (id == SYS_CORE_ID && self->auto_boost) {
                self->ApplyBoost();
                break;
            }

            // Stuck on other cores or auto boost disabled, apply max hz
            self->ApplyTargetFreq(self->max_hz);
            break;
        }
    }
}

void GpuGovernor::Apply() {
    uint32_t util = this->CalcNormalizedUtil(GpuCoreUtil(m_nvgpu_field).Get());
    this->m_util.Update(util);
    this->ApplyNewFreqFromNormUtil(this->m_util.Get());
}

}

void Governor::SetConfig(SysClkOcGovernorConfig config) {
    if (m_config == config)
        return;

    m_config = config;
    m_cpu_gov->m_worker.onConfigUpdated(config);
    m_manager.onConfigUpdated(config);
};

void Governor::SetPerfConf(uint32_t id) {
    m_perf_conf_id = id;
    m_apm_conf = Clocks::GetEmbeddedApmConfig(id);
}

void Governor::SetMaxHz(uint32_t maxHz, SysClkModule module) {
    if (!maxHz) // Fallback to apm configuration
        maxHz = Clocks::GetStockClock(m_apm_conf, (SysClkModule)module);

    switch (module) {
        case SysClkModule_CPU:
            m_cpu_gov->max_hz = maxHz;
            break;
        case SysClkModule_GPU:
            m_gpu_gov->max_hz = maxHz;
            m_gpu_gov->min_hz = (maxHz <= 153'600'000) ? maxHz : 153'600'000;
            break;
        default:
            break;
    }
}

void Governor::GovernorManager::Start() {
    if (this->running)
        return;

    this->running = true;
    Result rc = threadCreate(&thread, &ContextManager, (void*)this, NULL, 0x400, 0x3F, 3);
    ASSERT_RESULT_OK(rc, "threadCreate");
    rc = threadStart(&thread);
    ASSERT_RESULT_OK(rc, "threadStart");
}

void Governor::GovernorManager::Stop() {
    if (!this->running)
        return;

    this->running = false;
    svcSleepThread(TICK_TIME_NS);
    threadWaitForExit(&thread);
    threadClose(&thread);
}

void Governor::GovernorManager::ContextManager(void* args) {
    Governor* self = static_cast<Governor*>(args);

    constexpr uint64_t UPDATE_CONTEXT_RATE = SAMPLE_RATE / 2;
    uint64_t update_ticks = UPDATE_CONTEXT_RATE;
    bool cpuBoosted = false, gpuThrottled = false;

    while (self->m_manager.running) {
        bool shouldUpdateContext = ++update_ticks >= UPDATE_CONTEXT_RATE;
        if (shouldUpdateContext) {
            update_ticks = 0;

            uint32_t hz = self->m_gpu_gov->RefreshContext();
            // Sleep mode detected, wait 10 ticks
            while (!hz) {
                svcSleepThread(10 * TICK_TIME_NS);
                hz = self->m_gpu_gov->RefreshContext();
            }

            uint32_t perf_conf = self->GetPerfConf();
            if ((gpuThrottled = apmExtIsBoostMode(perf_conf)) && self->IsHandledByGovernor(SysClkModule_GPU))
                self->m_gpu_gov->ApplyBoost();

            if ((cpuBoosted = apmExtIsCPUBoosted(perf_conf)) && self->IsHandledByGovernor(SysClkModule_CPU))
                self->m_cpu_gov->ApplyBoost();
        }

        if (!gpuThrottled && self->IsHandledByGovernor(SysClkModule_GPU))
            self->m_gpu_gov->Apply();
        if (!cpuBoosted && self->IsHandledByGovernor(SysClkModule_CPU))
            self->m_cpu_gov->Apply();

        svcSleepThread(TICK_TIME_NS);
    }
};
