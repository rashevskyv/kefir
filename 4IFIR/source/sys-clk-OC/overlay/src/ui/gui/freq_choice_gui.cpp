/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include "freq_choice_gui.h"

#include "../format.h"
#include "fatal_gui.h"

FreqChoiceGui::FreqChoiceGui(std::uint32_t selectedMHz, SysClkModule module, SysClkProfile profile, FreqChoiceListener listener)
{
    this->hzTable = new SysClkFrequencyTable;
    Result rc = sysclkIpcGetFrequencyTable(module, profile, hzTable);
    if (R_FAILED(rc)) {
        FatalGui::openWithResultCode("sysclkIpcGetFrequencyTable", rc);
    }

    this->selectedMHz = selectedMHz;
    this->listener = listener;
}

FreqChoiceGui::~FreqChoiceGui() {
    delete this->hzTable;
}

tsl::elm::ListItem* FreqChoiceGui::createFreqListItem(std::uint32_t mhz, bool selected)
{
    tsl::elm::ListItem* listItem = new tsl::elm::ListItem(formatListFreqMhz(mhz));
    listItem->setValue(selected ? "\uE14B" : "");

    listItem->setClickListener([this, mhz](u64 keys) {
        if((keys & HidNpadButton_A) == HidNpadButton_A && this->listener)
        {
            if(this->listener(mhz))
            {
                tsl::goBack();
            }
            return true;
        }

        return false;
    });

    return listItem;
}

void FreqChoiceGui::listUI()
{
    this->listElement->addItem(this->createFreqListItem(0, this->selectedMHz == 0));

    size_t idx = 0;
    uint32_t freq;
    while(idx < FREQ_TABLE_MAX_ENTRY_COUNT && (freq = this->hzTable->freq[idx]))
    {
        uint32_t mhz = freq / 1000'000;
        this->listElement->addItem(this->createFreqListItem(mhz, mhz == this->selectedMHz));
        idx++;
    }
}
