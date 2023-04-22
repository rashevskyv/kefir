/* --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include "misc_gui.h"

#include "fatal_gui.h"
#include "../format.h"

MiscGui::MiscGui()
{
    smInitialize();

    this->configList = new SysClkConfigValueList {};
    this->chargeInfo = new PsmChargeInfo {};
    this->i2cInfo    = new I2cInfo {};

    sysclkIpcGetIsMariko(&this->isMariko);
}

MiscGui::~MiscGui()
{
    delete this->configList;
    delete this->chargeInfo;
    delete this->i2cInfo;
    this->configToggles.clear();

    smExit();
}

void MiscGui::addConfigToggle(SysClkConfigValue configVal, const char* altName = nullptr) {
    const char* configName = altName ? altName : sysclkFormatConfigValue(configVal, true);
    tsl::elm::ToggleListItem* toggle = new tsl::elm::ToggleListItem(configName, this->configList->values[configVal]);
    toggle->setStateChangedListener([this, configVal](bool state) {
        this->configList->values[configVal] = uint64_t(state);
        Result rc = sysclkIpcSetConfigValues(this->configList);
        if (R_FAILED(rc))
            FatalGui::openWithResultCode("sysclkIpcSetConfigValues", rc);

        this->lastContextUpdate = armGetSystemTick();
    });
    this->listElement->addItem(toggle);
    this->configToggles[configVal] = toggle;
}

void MiscGui::updateConfigToggles() {
    for (const auto& [value, toggle] : this->configToggles) {
        if (toggle != nullptr)
            toggle->setState(this->configList->values[value]);
    }
}

void MiscGui::listUI()
{
    // Config list
    sysclkIpcGetConfigValues(this->configList);
    this->listElement->addItem(new tsl::elm::CategoryHeader("Config"));

    addConfigToggle(SysClkConfigValue_AutoCPUBoost, this->isMariko ? nullptr : "Auto CPU Boost (Unsafe)");
    addConfigToggle(SysClkConfigValue_SyncReverseNXMode);
    addConfigToggle(SysClkConfigValue_GovernorExperimental);

    // Charging Current
    this->chargingCurrentHeader = new tsl::elm::CategoryHeader("");
    this->listElement->addItem(this->chargingCurrentHeader);
    constexpr size_t current_steps = CHARGING_CURRENT_MA_LIMIT / 100;
    this->chargingCurrentBar = new StepTrackBarIcon("", current_steps + 1);
    this->chargingCurrentBar->setProgress(this->configList->values[SysClkConfigValue_ChargingCurrentLimit]);
    this->chargingCurrentBar->setValueChangedListener([this](u8 val) {
        if (val < 1) {
            val = 1;
            this->chargingCurrentBar->setProgress(val);
        }
        if (val > current_steps) {
            val = current_steps;
            this->chargingCurrentBar->setProgress(val);
        }
        uint32_t current_ma = val * 100;
        this->configList->values[SysClkConfigValue_ChargingCurrentLimit] = current_ma;

        snprintf(chargingCurrentBarDesc, sizeof(chargingCurrentBarDesc), "Charging Current: %lu mA (Now: %+d mA)", this->configList->values[SysClkConfigValue_ChargingCurrentLimit], (int)this->i2cInfo->batCurrent);
        this->chargingCurrentHeader->setText(chargingCurrentBarDesc);

        Result rc = sysclkIpcSetConfigValues(this->configList);
        if (R_FAILED(rc))
            FatalGui::openWithResultCode("sysclkIpcSetConfigValues", rc);

        this->lastContextUpdate = armGetSystemTick();
    });
    this->listElement->addItem(this->chargingCurrentBar);

    // Charging Limit
    this->chargingLimitHeader = new tsl::elm::CategoryHeader("");
    this->listElement->addItem(this->chargingLimitHeader);
    this->chargingLimitBar = new StepTrackBarIcon("", 100 + 1);
    this->chargingLimitBar->setProgress(this->configList->values[SysClkConfigValue_ChargingLimitPercentage]);
    this->chargingLimitBar->setValueChangedListener([this](u8 val) {
        if (val < 20) {
            val = 20;
            this->chargingLimitBar->setProgress(val);
        }
        this->configList->values[SysClkConfigValue_ChargingLimitPercentage] = val;

        snprintf(chargingLimitBarDesc, sizeof(chargingLimitBarDesc), "Battery Charging Limit: %lu%% (Now: %u%%)", this->configList->values[SysClkConfigValue_ChargingLimitPercentage], this->batteryChargePerc);
        this->chargingLimitHeader->setText(chargingLimitBarDesc);
        this->chargingLimitBar->setIcon(PsmGetBatteryStateIcon(this->chargeInfo));

        Result rc = sysclkIpcSetConfigValues(this->configList);
        if (R_FAILED(rc))
            FatalGui::openWithResultCode("sysclkIpcSetConfigValues", rc);

        this->lastContextUpdate = armGetSystemTick();
    });
    this->listElement->addItem(this->chargingLimitBar);
    this->listElement->addItem(new tsl::elm::CustomDrawer([](tsl::gfx::Renderer* renderer, s32 x, s32 y, s32 w, s32 h) {
      renderer->drawString("\uE016 Long-term use may render the battery gauge \ninaccurate!", false, x, y + 20, SMALL_TEXT_SIZE, DESC_COLOR);
    }), SMALL_TEXT_SIZE * 2 + 20);

    // Temporary toggles
    this->listElement->addItem(new tsl::elm::CategoryHeader("Temporary toggles"));

    this->chargingDisabledOverrideToggle = new tsl::elm::ToggleListItem("Force Disable Charging", false);
    chargingDisabledOverrideToggle->setStateChangedListener([this](bool state) {
        Result rc = sysclkIpcSetBatteryChargingDisabledOverride(state);
        if (R_FAILED(rc))
            FatalGui::openWithResultCode("sysclkIpcSetBatteryChargingDisabledOverride", rc);

        this->lastContextUpdate = armGetSystemTick();
    });
    this->listElement->addItem(this->chargingDisabledOverrideToggle);

    this->backlightToggle = new tsl::elm::ToggleListItem("Screen Backlight", false);
    backlightToggle->setStateChangedListener([this](bool state) {
        LblUpdate(true);
    });
    this->listElement->addItem(this->backlightToggle);

    // Info
    this->listElement->addItem(new tsl::elm::CategoryHeader("Info"));
    this->listElement->addItem(new tsl::elm::CustomDrawer([this](tsl::gfx::Renderer *renderer, s32 x, s32 y, s32 w, s32 h) {
        renderer->drawString(this->infoNames, false, x, y + 20, SMALL_TEXT_SIZE, DESC_COLOR);
        renderer->drawString(this->infoVals, false, x + 120, y + 20, SMALL_TEXT_SIZE, VALUE_COLOR);
    }), SMALL_TEXT_SIZE * 12 + 20);
}

void MiscGui::refresh() {
    BaseMenuGui::refresh();

    if (this->context && ++frameCounter >= 60)
    {
        frameCounter = 0;
        sysclkIpcGetConfigValues(this->configList);
        updateConfigToggles();

        PsmUpdate();
        this->chargingLimitBar->setIcon(PsmGetBatteryStateIcon(this->chargeInfo));

        bool chargingDisabledOverride;
        Result rc = sysclkIpcGetBatteryChargingDisabledOverride(&chargingDisabledOverride);
        if (R_FAILED(rc))
            FatalGui::openWithResultCode("sysclkIpcGetBatteryChargingDisabledOverride", rc);
        this->chargingDisabledOverrideToggle->setState(chargingDisabledOverride);

        LblUpdate();
        this->backlightToggle->setState(lblstatus);

        this->chargingCurrentBar->setProgress(this->configList->values[SysClkConfigValue_ChargingCurrentLimit] / 100);
        snprintf(chargingCurrentBarDesc, sizeof(chargingCurrentBarDesc), "Charging Current: %lu mA (Now: %+d mA)", this->configList->values[SysClkConfigValue_ChargingCurrentLimit], (int)this->i2cInfo->batCurrent);
        this->chargingCurrentHeader->setText(chargingCurrentBarDesc);

        this->chargingLimitBar->setProgress(this->configList->values[SysClkConfigValue_ChargingLimitPercentage]);
        snprintf(chargingLimitBarDesc, sizeof(chargingLimitBarDesc), "Charging Limit: %lu%% (Now: %u%%)", this->configList->values[SysClkConfigValue_ChargingLimitPercentage], this->batteryChargePerc);
        this->chargingLimitHeader->setText(chargingLimitBarDesc);

        I2cGetInfo(this->i2cInfo);
        UpdateInfo(this->infoVals, sizeof(this->infoVals));
    }
}
