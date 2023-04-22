/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include "base_menu_gui.h"

#include "fatal_gui.h"

BaseMenuGui::BaseMenuGui()
{
    this->context = nullptr;
    this->lastContextUpdate = 0;
    this->listElement = nullptr;
}

BaseMenuGui::~BaseMenuGui()
{
    if(this->context)
    {
        delete this->context;
    }
}

void BaseMenuGui::preDraw(tsl::gfx::Renderer* renderer)
{
    BaseGui::preDraw(renderer);
    if(this->context)
    {
        char buf[32];

        renderer->drawString("App ID: ", false, 40, 60, SMALL_TEXT_SIZE, DESC_COLOR);
        snprintf(buf, sizeof(buf), "%016lX", context->applicationId);
        renderer->drawString(buf, false, 100, 60, SMALL_TEXT_SIZE, VALUE_COLOR);

        renderer->drawString("Profile: ", false, 266, 60, SMALL_TEXT_SIZE, DESC_COLOR);
        renderer->drawString(sysclkFormatProfile(context->profile, true), false, 322, 60, SMALL_TEXT_SIZE, VALUE_COLOR);

        static struct
        {
            SysClkModule m;
            std::uint32_t x;
        } freqOffsets[SysClkModule_EnumMax] = {
            { SysClkModule_CPU, 80 },
            { SysClkModule_GPU, 200 },
            { SysClkModule_MEM, 320 },
        };

        for(unsigned int i = 0; i < SysClkModule_EnumMax; i++)
        {
            std::uint32_t hz = this->context->freqs[freqOffsets[i].m];
            snprintf(buf, sizeof(buf), "%u MHz", hz / 1000000);
            renderer->drawString(buf, false, freqOffsets[i].x, 85, SMALL_TEXT_SIZE, VALUE_COLOR);
        }
        renderer->drawString("CPU:", false, 40, 85, SMALL_TEXT_SIZE, DESC_COLOR);
        renderer->drawString("GPU:", false, 160, 85, SMALL_TEXT_SIZE, DESC_COLOR);
        renderer->drawString("MEM:", false, 270, 85, SMALL_TEXT_SIZE, DESC_COLOR);

        static struct
        {
            SysClkThermalSensor s;
            std::uint32_t x;
        } tempOffsets[SysClkModule_EnumMax] = {
            { SysClkThermalSensor_SOC, 80 },
            { SysClkThermalSensor_PCB, 200 },
            { SysClkThermalSensor_Skin, 320 },
        };

        renderer->drawString("SOC:", false, 40, 110, SMALL_TEXT_SIZE, DESC_COLOR);
        renderer->drawString("PCB:", false, 160, 110, SMALL_TEXT_SIZE, DESC_COLOR);
        renderer->drawString("Skin:", false, 270, 110, SMALL_TEXT_SIZE, DESC_COLOR);
        for(unsigned int i = 0; i < SysClkModule_EnumMax; i++)
        {
            std::uint32_t millis = this->context->temps[tempOffsets[i].s];
            snprintf(buf, sizeof(buf), "%u.%u °C", millis / 1000, (millis - millis / 1000 * 1000) / 100);
            renderer->drawString(buf, false, tempOffsets[i].x, 110, SMALL_TEXT_SIZE, VALUE_COLOR);
        }
    }
}

void BaseMenuGui::refresh()
{
    std::uint64_t ticks = armGetSystemTick();

    if(armTicksToNs(ticks - this->lastContextUpdate) > 500000000UL)
    {
        this->lastContextUpdate = ticks;
        if(!this->context)
        {
            this->context = new SysClkContext;
        }

        Result rc = sysclkIpcGetCurrentContext(this->context);
        if(R_FAILED(rc))
        {
            FatalGui::openWithResultCode("sysclkIpcGetCurrentContext", rc);
            return;
        }
    }
}

tsl::elm::Element* BaseMenuGui::baseUI()
{
    tsl::elm::List* list = new tsl::elm::List();
    this->listElement = list;
    this->listUI();

    return list;
}
