#pragma once
#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <nxExt.h>
#include <sysclk.h>
#include <switch.h>
#include "errors.h"
#include "file_utils.h"
#include "clocks.h"

// Forward declaration
class ClockManager;
class Governor;
#include "clock_manager.h"


class CpuCoreUtil {
public:
    CpuCoreUtil (int coreid, uint64_t ns);
    uint32_t Get();

protected:
    const int m_core_id;
    const uint64_t m_wait_time_ns;
    static constexpr uint64_t IDLETICKS_PER_MS = 192;
    static constexpr uint32_t UTIL_MAX = 100'0;

    uint64_t GetIdleTickCount();
};


class GpuCoreUtil {
public:
    GpuCoreUtil (uint32_t nvgpu_field);
    uint32_t Get();

protected:
    uint32_t m_nvgpu_field;
    static constexpr uint64_t NVGPU_GPU_IOCTL_PMU_GET_GPU_LOAD = 0x80044715;
};


class ReverseNXSync {
public:
    ReverseNXSync ();

    void ToggleSync(bool enable)    { m_sync_enabled = enable; };
    void Reset(uint64_t app_id)     { m_app_id = app_id; SetRTMode(ReverseNX_NotFound); GetToolMode(); }
    ReverseNXMode GetRTMode()           { return m_rt_mode; };
    void SetRTMode(ReverseNXMode mode)  { m_rt_mode = mode; };
    ReverseNXMode GetToolMode()         { return m_tool_mode = RecheckToolMode(); };
    SysClkProfile GetProfile(SysClkProfile real);
    ReverseNXMode GetMode();

protected:
    std::atomic<ReverseNXMode> m_rt_mode;
    ReverseNXMode m_tool_mode;
    uint64_t m_app_id = 0;
    bool m_tool_enabled;
    bool m_sync_enabled;

    ReverseNXMode GetToolModeFromPatch(const char* patch_path);
    ReverseNXMode RecheckToolMode();
};


namespace PsmExt {
    void ChargingHandler(ClockManager* instance);
}


constexpr uint64_t SAMPLE_RATE = 200;
constexpr uint64_t TICK_TIME_NS = 1000'000'000 / SAMPLE_RATE;
constexpr uint64_t SYSTICK_HZ = 19200000;

namespace GovernorImpl {
    constexpr uint32_t UTIL_MAX = 1000;

    class BaseGovernor {
    public:
        BaseGovernor(SysClkModule module) : m_module(module) {
            m_hz_list = Clocks::freqTable[module].freq;
            m_ref_hz  = *Clocks::freqRange[module].last;
        };

        uint32_t RefreshContext() { return this->m_target_hz = Clocks::GetCurrentHz(this->m_module); };

        uint32_t min_hz, max_hz, boost_hz;

    protected:
        uint32_t CalcNormalizedUtil(uint32_t rawUtil) {
            return ((uint64_t)rawUtil * m_target_hz / m_ref_hz);
        };

        void ApplyNewFreqFromNormUtil(uint32_t norm);

        void ApplyTargetFreq(uint32_t hz) {
            if (!hz || m_target_hz == hz)
                return;

            m_target_hz = hz;
            Clocks::SetHz(m_module, hz);
        };

        SysClkModule m_module;
        uint32_t* m_hz_list;
        uint32_t m_target_hz, m_ref_hz;

        friend Governor;
    };

    class CpuGovernor : public BaseGovernor {
    public:
        CpuGovernor(Governor* manager)
        : BaseGovernor(SysClkModule_CPU), m_manager(manager) {
            boost_hz = Clocks::boostCpuFreq;
            m_worker.super = this;
        };

        ~CpuGovernor() { this->m_worker.Stop(); };

        void Apply();

        void ApplyBoost() {
            ApplyTargetFreq((max_hz > boost_hz) ? max_hz : boost_hz);
        };

        bool auto_boost;

    protected:
        static constexpr int CORE_NUMS = 4;
        static constexpr int SYS_CORE_ID = CORE_NUMS - 1;

        // PELT: https://github.com/torvalds/linux/blob/master/kernel/sched/pelt.c
        // Util_acc_n = Util_0 + Util_1 * D + Util_2 * D^2 + ... + Util_n * D^n
        // To approximate D (decay multiplier):
        //   After 50 ms (if SAMPLE_RATE == 200, 10 samples)
        //   UTIL_MAX * D^10 ≈ 1 (UTIL_MAX decayed to 1)
        // D = 4129 / 8192
        // Util_acc_max = Util_acc_inf = 2012
        typedef struct PeltUtil {
            uint32_t util_acc = 0;

            static constexpr uint32_t DECAY_DIVIDENT = 4129;
            static constexpr uint32_t DECAY_DIVISOR  = 8192;
            static constexpr uint32_t UTIL_ACC_MAX   = 2012;

            uint32_t Get()              { return (util_acc * UTIL_MAX / UTIL_ACC_MAX); };
            void Update(uint32_t util)  { util_acc = util_acc * DECAY_DIVIDENT / DECAY_DIVISOR + util; };
        } PeltUtil;
        PeltUtil m_util;

        typedef struct {
            CpuGovernor*super;
            int         id;
            uint32_t    util;
            uint64_t    tick;

            static void Loop(void* args);
        } WorkerContext;

        typedef struct GovernorWorker {
            Thread threads[CORE_NUMS];
            WorkerContext contexts[CORE_NUMS];
            bool running;
            CpuGovernor* super;

            void Start();
            void Stop();

            void onConfigUpdated(SysClkOcGovernorConfig config) {
                bool expected = (config >> SysClkOcGovernorConfig_CPU_Shift) & 1;
                if (expected != running)
                    expected ? Start() : Stop();
            };
        } GovernorWorker;
        GovernorWorker m_worker;

        Governor* m_manager;

        friend Governor;
    };

    class GpuGovernor : public BaseGovernor {
    public:
        GpuGovernor() : BaseGovernor(SysClkModule_GPU) {
            min_hz   = 153'600'000;
            boost_hz =  76'800'000;

            nvInitialize();
            Result rc = nvOpen(&m_nvgpu_field, "/dev/nvhost-ctrl-gpu");
            if (R_FAILED(rc)) {
                ASSERT_RESULT_OK(rc, "nvOpen");
                nvExit();
            }
        };

        ~GpuGovernor() {
            nvClose(m_nvgpu_field);
            nvExit();
        };

        void ApplyBoost() {
            ApplyTargetFreq(boost_hz);
        };

        void Apply();

    protected:
        // Get average value from a sliding window in O(1)
        template <typename T, size_t WINDOW_SIZE>
        class SWindowAvg {
        public:
            SWindowAvg() {}

            void Add(T item) {
                T pop = m_queue[m_next];
                m_queue[m_next] = item;
                m_next = (m_next + 1) % WINDOW_SIZE;
                m_sum -= pop;
                m_sum += item;
            }

            T Get() { return m_sum / WINDOW_SIZE; }

        protected:
            size_t m_next = 0;
            T m_sum = 0;
            T m_queue[WINDOW_SIZE] = {};
        };

        // Get max value from a sliding window in O(1)
        template <typename T, size_t WINDOW_SIZE>
        class SWindowMax {
        protected:
            typedef struct {
                T item;
                T max;
            } s_Entry;

            struct s_Stack {
                s_Entry m_stack[WINDOW_SIZE] = {};
                size_t m_next = WINDOW_SIZE;

                bool  empty() { return m_next == 0; };
                s_Entry top() { return m_stack[m_next-1]; };
                s_Entry pop() { return m_stack[--m_next]; };
                void   push(s_Entry item) {
                    if (m_next == WINDOW_SIZE)
                        return;
                    m_stack[m_next++] = item;
                };
            };

            s_Stack enqStack;
            s_Stack deqStack;

            void Push(s_Stack& stack, T item) {
                s_Entry n = {
                    .item = item,
                    .max  = enqStack.empty() ? item : std::max(item, enqStack.top().max)
                };
                stack.push(n);
            }

            T Pop() {
                if (deqStack.empty()) {
                    while (!enqStack.empty())
                        Push(deqStack, enqStack.pop().max);
                }
                return deqStack.pop().item;
            }

        public:
            SWindowMax() {}

            void Add(T item) { Pop(); Push(enqStack, item); }

            T Get() {
                if (!enqStack.empty()) {
                    T enqMax = enqStack.top().max;
                    if (!deqStack.empty()) {
                        T deqMax = deqStack.top().max;
                        return std::max(deqMax, enqMax);
                    }
                    return enqMax;
                }
                if (!deqStack.empty())
                    return deqStack.top().max;
                return 0;
            }
        };

        typedef struct MaxWindow {
            SWindowMax<uint32_t, 32> window {};
            uint32_t util_acc = 0;

            //   After 160 ms (if SAMPLE_RATE == 200, 32 samples)
            //   UTIL_MAX * D^32 ≈ 1 (UTIL_MAX decayed to 1)
            // D = 6880 / 8192
            // Util_acc_max = Util_acc_inf = 6145
            static constexpr uint32_t DECAY_DIVIDENT = 6880;
            static constexpr uint32_t DECAY_DIVISOR  = 8192;
            static constexpr uint32_t UTIL_ACC_MAX   = 6145;

            uint32_t Get()              { return ((util_acc * UTIL_MAX / UTIL_ACC_MAX) + window.Get()) / 2; };
            void Update(uint32_t util)  { window.Add(util); util_acc = util_acc * DECAY_DIVIDENT / DECAY_DIVISOR + util; };
        } MaxWindow;
        MaxWindow m_util;

        uint32_t m_nvgpu_field;
    };

}

class Governor {
public:
    Governor() {
        m_cpu_gov = new GovernorImpl::CpuGovernor(this);
        m_gpu_gov = new GovernorImpl::GpuGovernor();
    };

    ~Governor() {
        m_manager.Stop();
        delete m_cpu_gov;
        delete m_gpu_gov;
    };

    SysClkOcGovernorConfig GetConfig() { return m_config; };
    inline bool IsHandledByGovernor(SysClkModule module) { return GetGovernorEnabled(this->GetConfig(), module); };
    void SetConfig(SysClkOcGovernorConfig config);

    void SetPerfConf(uint32_t id);
    uint32_t GetPerfConf() { return m_perf_conf_id; };

    void SetMaxHz(uint32_t maxHz, SysClkModule module);

    void SetAutoCPUBoost(bool enabled) { m_cpu_gov->auto_boost = enabled; };
    void SetCPUBoostHz(uint32_t boostHz) { m_cpu_gov->boost_hz = boostHz; };

protected:
    typedef struct GovernorManager {
        bool running = false;
        Thread thread;

        void Start();
        void Stop();
        void onConfigUpdated(SysClkOcGovernorConfig config) {
            bool shouldRun = (config != SysClkOcGovernorConfig_AllDisabled);
            shouldRun ? Start() : Stop();
        };
        static void ContextManager(void* args);
    } GovernorManager;
    GovernorManager m_manager;

    SysClkOcGovernorConfig m_config = SysClkOcGovernorConfig_AllDisabled;

    uint32_t m_perf_conf_id;
    SysClkApmConfiguration* m_apm_conf;

    GovernorImpl::CpuGovernor* m_cpu_gov;
    GovernorImpl::GpuGovernor* m_gpu_gov;
};
