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

#include <atomic>
#include <sysclk.h>

#include "config.h"
#include "clocks.h"
#include <nxExt/cpp/lockable_mutex.h>

#include "oc_extra.h"

// Forward declaration
class ReverseNXSync;
class Governor;

class ClockManager
{
  public:
    static ClockManager* GetInstance();
    static void Initialize();
    static void Exit();

    void SetRunning(bool running);
    bool Running();
    void Tick();
    void WaitForNextTick();
    void SetRNXRTMode(ReverseNXMode mode);
    SysClkContext GetCurrentContext();
    Config* GetConfig();
    bool GetBatteryChargingDisabledOverride();
    Result SetBatteryChargingDisabledOverride(bool toggle_true);

  protected:
    ClockManager();
    virtual ~ClockManager();

    bool RefreshContext();
    uint32_t GetHz(SysClkModule);

    static ClockManager *instance;
    std::atomic_bool running;
    LockableMutex contextMutex;
    Config *config;
    SysClkContext *context;
    std::uint64_t lastTempLogNs;
    std::uint64_t lastCsvWriteNs;

    SysClkOcExtra *oc;
    ReverseNXSync *rnxSync;
    Governor *governor;
};
