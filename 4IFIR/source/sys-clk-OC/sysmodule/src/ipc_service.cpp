/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include "ipc_service.h"
#include <cstring>
#include <switch.h>
#include "file_utils.h"
#include "clock_manager.h"
#include "errors.h"

IpcService::IpcService()
{
    std::int32_t priority;
    Result rc = svcGetThreadPriority(&priority, CUR_THREAD_HANDLE);
    ASSERT_RESULT_OK(rc, "svcGetThreadPriority");
    rc = ipcServerInit(&this->server, SYSCLK_IPC_SERVICE_NAME, 42);
    ASSERT_RESULT_OK(rc, "ipcServerInit");
    rc = threadCreate(&this->thread, &IpcService::ProcessThreadFunc, this, NULL, 0x2000, priority, -2);
    ASSERT_RESULT_OK(rc, "threadCreate");
    this->running = false;
}

void IpcService::SetRunning(bool running)
{
    std::scoped_lock lock{this->threadMutex};
    if(this->running == running)
    {
        return;
    }

    this->running = running;

    if(running)
    {
        Result rc = threadStart(&this->thread);
        ASSERT_RESULT_OK(rc, "threadStart");
    }
    else
    {
        svcCancelSynchronization(this->thread.handle);
        threadWaitForExit(&this->thread);
    }
}

IpcService::~IpcService()
{
    this->SetRunning(false);
    Result rc = threadClose(&this->thread);
    ASSERT_RESULT_OK(rc, "threadClose");
    rc = ipcServerExit(&this->server);
    ASSERT_RESULT_OK(rc, "ipcServerExit");
}

void IpcService::ProcessThreadFunc(void *arg)
{
    Result rc;
    IpcService* ipcSrv = (IpcService*)arg;
    while(true)
    {
        rc = ipcServerProcess(&ipcSrv->server, &IpcService::ServiceHandlerFunc, arg);
        if(R_FAILED(rc))
        {
            if(rc == KERNELRESULT(Cancelled))
            {
                return;
            }
            if(rc != KERNELRESULT(ConnectionClosed))
            {
                FileUtils::LogLine("[ipc] ipcServerProcess: [0x%x] %04d-%04d", rc, R_MODULE(rc), R_DESCRIPTION(rc));
            }
        }
    }
}

Result IpcService::ServiceHandlerFunc(void* arg, const IpcServerRequest* r, u8* out_data, size_t* out_dataSize)
{
    IpcService* ipcSrv = (IpcService*)arg;

    switch(r->data.cmdId)
    {
        case SysClkIpcCmd_GetApiVersion:
            *out_dataSize = sizeof(u32);
            return ipcSrv->GetApiVersion((u32*)out_data);

        case SysClkIpcCmd_GetVersionString:
            if(r->hipc.meta.num_recv_buffers >= 1)
            {
                return ipcSrv->GetVersionString(
                    (char*)hipcGetBufferAddress(r->hipc.data.recv_buffers),
                    hipcGetBufferSize(r->hipc.data.recv_buffers)
                );
            }
            break;

        case SysClkIpcCmd_GetCurrentContext:
            *out_dataSize = sizeof(SysClkContext);
            return ipcSrv->GetCurrentContext((SysClkContext*)out_data);

        case SysClkIpcCmd_Exit:
            return ipcSrv->Exit();

        case SysClkIpcCmd_GetProfileCount:
            if(r->data.size >= sizeof(std::uint64_t))
            {
                *out_dataSize = sizeof(std::uint8_t);
                return ipcSrv->GetProfileCount((std::uint64_t*)r->data.ptr, (std::uint8_t*)out_data);
            }
            break;

        case SysClkIpcCmd_GetProfiles:
            if(r->data.size >= sizeof(std::uint64_t))
            {
                *out_dataSize = sizeof(SysClkTitleProfileList);
                return ipcSrv->GetProfiles((std::uint64_t*)r->data.ptr, (SysClkTitleProfileList*)out_data);
            }
            break;

        case SysClkIpcCmd_SetProfiles:
            if(r->data.size >= sizeof(SysClkIpc_SetProfiles_Args))
            {
                return ipcSrv->SetProfiles((SysClkIpc_SetProfiles_Args*)r->data.ptr);
            }
            break;

        case SysClkIpcCmd_SetEnabled:
            if(r->data.size >= sizeof(std::uint8_t))
            {
                return ipcSrv->SetEnabled((std::uint8_t*)r->data.ptr);
            }
            break;

        case SysClkIpcCmd_SetOverride:
            if(r->data.size >= sizeof(SysClkIpc_SetOverride_Args))
            {
                return ipcSrv->SetOverride((SysClkIpc_SetOverride_Args*)r->data.ptr);
            }
            break;

        case SysClkIpcCmd_GetConfigValues:
            *out_dataSize = sizeof(SysClkConfigValueList);
            return ipcSrv->GetConfigValues((SysClkConfigValueList*)out_data);

        case SysClkIpcCmd_SetConfigValues:
            if(r->data.size >= sizeof(SysClkConfigValueList))
            {
                return ipcSrv->SetConfigValues((SysClkConfigValueList*)r->data.ptr);
            }
            break;

        case SysClkIpcCmd_SetReverseNXRTMode:
            if (r->data.size >= sizeof(ReverseNXMode)) {
                ReverseNXMode mode = *((ReverseNXMode*)r->data.ptr);
                return ipcSrv->SetReverseNXRTMode(mode);
            }
            break;
        case SysClkIpcCmd_GetFrequencyTable:
            if(r->data.size >= sizeof(SysClkIpc_GetFrequencyTable_Args))
            {
                SysClkIpc_GetFrequencyTable_Args* in_args = (SysClkIpc_GetFrequencyTable_Args*)r->data.ptr;
                *out_dataSize = sizeof(SysClkFrequencyTable);
                return ipcSrv->GetFrequencyTable(in_args, (SysClkFrequencyTable*)out_data);
            }
            break;
        case SysClkIpcCmd_GetIsMariko:
            *out_dataSize = sizeof(bool);
            return ipcSrv->GetIsMariko((bool*)out_data);
        case SysClkIpcCmd_GetBatteryChargingDisabledOverride:
            *out_dataSize = sizeof(bool);
            return ipcSrv->GetBatteryChargingDisabledOverride((bool*)out_data);
        case SysClkIpcCmd_SetBatteryChargingDisabledOverride:
            if (r->data.size >= sizeof(bool)) {
                bool toggle_true = *((bool*)(r->data.ptr));
                return ipcSrv->SetBatteryChargingDisabledOverride(toggle_true);
            }
            break;
    }

    return SYSCLK_ERROR(Generic);
}

Result IpcService::GetApiVersion(u32* out_version)
{
    *out_version = SYSCLK_IPC_API_VERSION;

    return 0;
}

Result IpcService::GetVersionString(char* out_buf, size_t bufSize)
{
    if(bufSize)
    {
        strncpy(out_buf, TARGET_VERSION, bufSize-1);
    }

    return 0;
}

Result IpcService::GetCurrentContext(SysClkContext* out_ctx)
{
    ClockManager* clockMgr = ClockManager::GetInstance();
    *out_ctx = clockMgr->GetCurrentContext();

    return 0;
}

Result IpcService::Exit()
{
    ClockManager* clockMgr = ClockManager::GetInstance();
    clockMgr->SetRunning(false);

    return 0;
}

Result IpcService::GetProfileCount(std::uint64_t* tid, std::uint8_t* out_count)
{
    Config* config = ClockManager::GetInstance()->GetConfig();
    if(!config->HasProfilesLoaded())
    {
        return SYSCLK_ERROR(ConfigNotLoaded);
    }

    *out_count = config->GetProfileCount(*tid);

    return 0;
}

Result IpcService::GetProfiles(std::uint64_t* tid, SysClkTitleProfileList* out_profiles)
{
    Config* config = ClockManager::GetInstance()->GetConfig();
    if(!config->HasProfilesLoaded())
    {
        return SYSCLK_ERROR(ConfigNotLoaded);
    }

    config->GetProfiles(*tid, out_profiles);

    return 0;
}

Result IpcService::SetProfiles(SysClkIpc_SetProfiles_Args* args)
{
    Config* config = ClockManager::GetInstance()->GetConfig();
    if(!config->HasProfilesLoaded())
    {
        return SYSCLK_ERROR(ConfigNotLoaded);
    }

    SysClkTitleProfileList profiles = args->profiles;

    if(!config->SetProfiles(args->tid, &profiles, true))
    {
        return SYSCLK_ERROR(ConfigSaveFailed);
    }

    return 0;
}

Result IpcService::SetEnabled(std::uint8_t* enabled)
{
    Config* config = ClockManager::GetInstance()->GetConfig();
    config->SetEnabled(*enabled);

    return 0;
}

Result IpcService::SetOverride(SysClkIpc_SetOverride_Args* args)
{
    SysClkModule module = args->module;
    std::uint32_t hz = args->hz;

    if(!SYSCLK_ENUM_VALID(SysClkModule, args->module))
    {
        return SYSCLK_ERROR(Generic);
    }

    Config* config = ClockManager::GetInstance()->GetConfig();
    config->SetOverrideHz(module, hz);

    return 0;
}

Result IpcService::GetConfigValues(SysClkConfigValueList* out_configValues)
{
    Config* config = ClockManager::GetInstance()->GetConfig();
    if(!config->HasProfilesLoaded())
    {
        return SYSCLK_ERROR(ConfigNotLoaded);
    }

    config->GetConfigValues(out_configValues);

    return 0;
}

Result IpcService::SetConfigValues(SysClkConfigValueList* configValues)
{
    Config* config = ClockManager::GetInstance()->GetConfig();
    if(!config->HasProfilesLoaded())
    {
        return SYSCLK_ERROR(ConfigNotLoaded);
    }

    SysClkConfigValueList configValuesCopy = *configValues;

    if(!config->SetConfigValues(&configValuesCopy, true))
    {
        return SYSCLK_ERROR(ConfigSaveFailed);
    }

    return 0;
}

Result IpcService::SetReverseNXRTMode(ReverseNXMode mode) {
    ClockManager::GetInstance()->SetRNXRTMode(mode);
    return 0;
}

Result IpcService::GetFrequencyTable(SysClkIpc_GetFrequencyTable_Args* args, SysClkFrequencyTable* out_table) {
    return Clocks::GetTable(args->module, args->profile, out_table);
}

Result IpcService::GetIsMariko(bool* out_is_mariko) {
    *out_is_mariko = Clocks::GetIsMariko();
    return 0;
}

Result IpcService::GetBatteryChargingDisabledOverride(bool* out_is_true) {
    *out_is_true = ClockManager::GetInstance()->GetBatteryChargingDisabledOverride();
    return 0;
}


Result IpcService::SetBatteryChargingDisabledOverride(bool toggle_true) {
    return ClockManager::GetInstance()->SetBatteryChargingDisabledOverride(toggle_true);
}

