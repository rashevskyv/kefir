/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include "app_profile_gui.h"

#include "../format.h"
#include "fatal_gui.h"

AppProfileGui::AppProfileGui(std::uint64_t applicationId, SysClkTitleProfileList* profileList)
{
    this->applicationId = applicationId;
    this->profileList = profileList;
}

AppProfileGui::~AppProfileGui()
{
    delete this->profileList;
}

void AppProfileGui::openFreqChoiceGui(tsl::elm::ListItem* listItem, SysClkProfile profile, SysClkModule module)
{
    tsl::changeTo<FreqChoiceGui>(this->profileList->mhzMap[profile][module], module, profile, [this, listItem, profile, module](std::uint32_t mhz) {
        this->profileList->mhzMap[profile][module] = mhz;
        listItem->setValue(formatListFreqMhz(this->profileList->mhzMap[profile][module]));
        Result rc = sysclkIpcSetProfiles(this->applicationId, this->profileList);
        if(R_FAILED(rc))
        {
            FatalGui::openWithResultCode("sysclkIpcSetProfiles", rc);
            return false;
        }

        return true;
    });
}

void AppProfileGui::addModuleListItem(SysClkProfile profile, SysClkModule module)
{
    tsl::elm::ListItem* listItem = new tsl::elm::ListItem(sysclkFormatModule(module, true));
    listItem->setValue(formatListFreqMhz(this->profileList->mhzMap[profile][module]));
    listItem->setClickListener([this, listItem, profile, module](u64 keys) {
        if((keys & HidNpadButton_A) == HidNpadButton_A)
        {
            this->openFreqChoiceGui(listItem, profile, module);
            return true;
        }

        return false;
    });

    this->listElement->addItem(listItem);
}

void AppProfileGui::addProfileUI(SysClkProfile profile)
{
    this->listElement->addItem(new tsl::elm::CategoryHeader(sysclkFormatProfile(profile, true)));
    this->addModuleListItem(profile, SysClkModule_CPU);
    this->addModuleListItem(profile, SysClkModule_GPU);
    this->addModuleListItem(profile, SysClkModule_MEM);
}

void AppProfileGui::listUI()
{
    if (this->applicationId != SYSCLK_GLOBAL_PROFILE_TID) {
        SysClkConfigValueList* configList = new SysClkConfigValueList;
        sysclkIpcGetConfigValues(configList);
        bool globalGovernorEnabled = configList->values[SysClkConfigValue_GovernorExperimental];

        if (globalGovernorEnabled) {
            tsl::elm::ToggleListItem* cpuGovernorToggle = new tsl::elm::ToggleListItem("CPU Freq Governor",
                GetGovernorEnabled(this->profileList->governorConfig, SysClkModule_CPU));
            cpuGovernorToggle->setStateChangedListener([this](bool state) {
                this->profileList->governorConfig = ToggleGovernor(this->profileList->governorConfig, SysClkModule_CPU, state);

                Result rc = sysclkIpcSetProfiles(this->applicationId, this->profileList);
                if (R_FAILED(rc))
                    FatalGui::openWithResultCode("sysclkIpcSetProfiles", rc);
            });
            this->listElement->addItem(cpuGovernorToggle);

            tsl::elm::ToggleListItem* gpuGovernorToggle = new tsl::elm::ToggleListItem("GPU Freq Governor",
                GetGovernorEnabled(this->profileList->governorConfig, SysClkModule_GPU));
            gpuGovernorToggle->setStateChangedListener([this](bool state) {
                this->profileList->governorConfig = ToggleGovernor(this->profileList->governorConfig, SysClkModule_GPU, state);

                Result rc = sysclkIpcSetProfiles(this->applicationId, this->profileList);
                if (R_FAILED(rc))
                    FatalGui::openWithResultCode("sysclkIpcSetProfiles", rc);
            });
            this->listElement->addItem(gpuGovernorToggle);
        }

        delete configList;
    }

    this->addProfileUI(SysClkProfile_Docked);
    this->addProfileUI(SysClkProfile_Handheld);
    this->addProfileUI(SysClkProfile_HandheldCharging);
    this->addProfileUI(SysClkProfile_HandheldChargingOfficial);
    this->addProfileUI(SysClkProfile_HandheldChargingUSB);
}

void AppProfileGui::changeTo(std::uint64_t applicationId)
{
    SysClkTitleProfileList* profileList = new SysClkTitleProfileList;
    Result rc = sysclkIpcGetProfiles(applicationId, profileList);
    if(R_FAILED(rc))
    {
        delete profileList;
        FatalGui::openWithResultCode("sysclkIpcGetProfiles", rc);
        return;
    }

    tsl::changeTo<AppProfileGui>(applicationId, profileList);
}

void AppProfileGui::update()
{
    BaseMenuGui::update();

    if(this->context && this->applicationId != SYSCLK_GLOBAL_PROFILE_TID && this->applicationId != this->context->applicationId)
    {
        tsl::changeTo<FatalGui>(
            "Application changed\n\n"
            "\n"
            "The running application changed\n\n"
            "while editing was going on.",
            ""
        );
    }
}
