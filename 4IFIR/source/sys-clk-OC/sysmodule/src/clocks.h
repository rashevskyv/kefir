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
#include <cstdint>
#include <switch.h>
#include <sysclk.h>

#define MAX_MEM_CLOCK         1862'400'000
#define MEM_CLOCK_MARIKO_MIN  1600'000'000
#define MEM_CLOCK_DOCK        1600'000'000
#define BOOST_THRESHOLD       95'0

class Clocks
{
public:
    static inline uint32_t boostCpuFreq = 1785000000;
    static inline uint32_t maxMemFreq = 0;

    static inline uint32_t* GetNearestHzPtr(uint32_t* hzListStart, uint32_t* hzListEnd, uint32_t freq) {
        uint32_t* p = hzListStart;
        while (p < hzListEnd) {
            if (freq <= *p)
                return p;
            p++;
        }
        return hzListEnd;
    }

    static inline SysClkFrequencyTable freqTable[SysClkModule_EnumMax] = {
        {}, // CPU
        {}, // GPU
        {   // MEM
            665600000,
            800000000,
            1065600000,
            1331200000,
            1600000000,
        },
    };

    typedef struct FreqRange {
        uint32_t* first;
        uint32_t* last;
        uint32_t* min;
        uint32_t* max[SysClkProfile_EnumMax];

        void InitDefault(SysClkModule module) {
            SysClkFrequencyTable* table_head = &freqTable[module];
            uint32_t* p = this->first = this->min = &table_head->freq[0];

            // Get pointer to last value
            for (int i = 0; i < FREQ_TABLE_MAX_ENTRY_COUNT; i++) {
                if (!*(++p)) {
                    --p;
                    break;
                }
            }

            this->last = p;
            for (auto& m: this->max) {
                m = p;
            }
        };

        uint32_t* FindFreq(uint32_t freq, SysClkProfile profile = SysClkProfile_Docked) {
            return GetNearestHzPtr(this->min, this->max[profile], freq);
        };
    } FreqRange;

    static inline FreqRange freqRange[SysClkModule_EnumMax];
    static void UpdateFreqRange();

    static Result GetRange(SysClkModule module, SysClkProfile profile, uint32_t** min, uint32_t** max);
    static Result GetTable(SysClkModule module, SysClkProfile profile, SysClkFrequencyTable* out_table);
    static void SetAllowUnsafe(bool allow);
    static bool GetIsMariko() { return isMariko; };
    static void Exit();
    static void Initialize();
    static SysClkApmConfiguration* GetEmbeddedApmConfig(uint32_t confId);
    static uint32_t GetStockClock(SysClkApmConfiguration* apm, SysClkModule module);
    static void ResetToStock(unsigned int module = SysClkModule_EnumMax);
    static SysClkProfile GetCurrentProfile();
    static std::uint32_t GetCurrentHz(SysClkModule module);
    static void SetHz(SysClkModule module, std::uint32_t hz);
    static const char* GetProfileName(SysClkProfile profile, bool pretty);
    static const char* GetModuleName(SysClkModule module, bool pretty);
    static const char* GetThermalSensorName(SysClkThermalSensor sensor, bool pretty);
    static std::uint32_t GetNearestHz(SysClkModule module, SysClkProfile profile, std::uint32_t inHz);
    static std::uint32_t GetTemperatureMilli(SysClkThermalSensor sensor);

protected:
    static inline bool allowUnsafe;
    static inline bool isMariko;
    static std::int32_t GetTsTemperatureMilli(TsLocation location);
    static PcvModule GetPcvModule(SysClkModule sysclkModule);
    static PcvModuleId GetPcvModuleId(SysClkModule sysclkModule);
    static std::uint32_t GetMaxAllowedHz(SysClkModule module, SysClkProfile profile);
};
