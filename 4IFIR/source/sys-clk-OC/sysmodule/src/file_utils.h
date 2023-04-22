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
#include <switch.h>
#include <time.h>
#include <vector>
#include <string>
#include <cstring>
#include <atomic>
#include <cstdarg>
#include <sysclk.h>

#define FILE_CONFIG_DIR "/config/sys-clk"
#define FILE_FLAG_CHECK_INTERVAL_NS 5000000000ULL
#define FILE_CONTEXT_CSV_PATH FILE_CONFIG_DIR "/context.csv"
#define FILE_LOG_FLAG_PATH FILE_CONFIG_DIR "/log.flag"
#define FILE_LOG_FILE_PATH FILE_CONFIG_DIR "/log.txt"

typedef struct cvb_coefficients {
    s32 c0 = 0;
    s32 c1 = 0;
    s32 c2 = 0;
    s32 c3 = 0;
    s32 c4 = 0;
    s32 c5 = 0;
} cvb_coefficients;

typedef struct cvb_entry_t {
    u64 freq;
    cvb_coefficients cvb_dfll_param;
    cvb_coefficients cvb_pll_param;
} cvb_entry_t;
static_assert(sizeof(cvb_entry_t) == 0x38);

using CustomizeCpuDvfsTable = cvb_entry_t[FREQ_TABLE_MAX_ENTRY_COUNT];
using CustomizeGpuDvfsTable = cvb_entry_t[FREQ_TABLE_MAX_ENTRY_COUNT];

constexpr uint32_t CUST_REV = 4;

typedef struct CustTable {
    u8  cust[4] = {'C', 'U', 'S', 'T'};
    u32 custRev;
    u32 mtcConf;
    u32 commonCpuBoostClock;
    u32 commonEmcMemVolt;
    u32 eristaCpuMaxVolt;
    u32 eristaEmcMaxClock;
    u32 marikoCpuMaxVolt;
    u32 marikoEmcMaxClock;
    u32 marikoEmcVddqVolt;
    CustomizeCpuDvfsTable eristaCpuDvfsTable;
    CustomizeCpuDvfsTable marikoCpuDvfsTable;
    CustomizeGpuDvfsTable eristaGpuDvfsTable;
    CustomizeGpuDvfsTable marikoGpuDvfsTable;
    void* eristaMtcTable;
    void* marikoMtcTable;
} CustTable;
static_assert(sizeof(CustTable) == sizeof(u8) * 4 + sizeof(u32) * 9 + sizeof(CustomizeCpuDvfsTable) * 4 + sizeof(void*) * 2);
static_assert(sizeof(CustTable) == 7000);

class FileUtils
{
  public:
    static void Exit();
    static Result Initialize();
    static bool IsInitialized();
    static void InitializeAsync();
    static void LogLine(const char *format, ...);
    static void WriteContextToCsv(const SysClkContext* context);
    static void ParseLoaderKip();
    static Result mkdir_p(const char* dirpath);
  protected:
    static void RefreshFlags(bool force);
    static Result CustParser(const char* path, size_t filesize);
};
