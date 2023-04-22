/*
 * --------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <p-sam@d3vs.net>, <natinusala@gmail.com>, <m4x@m4xw.net>
 * wrote this file. As long as you retain this notice you can do whatever you
 * want with this stuff. If you meet any of us some day, and you think this
 * stuff is worth it, you can buy us a beer in return.  - The sys-clk authors
 * --------------------------------------------------------------------------
 */

#include "base_gui.h"

#include "../elements/base_frame.h"
// #include "logo_rgba_bin.h"

#define LOGO_LABEL_X 40
#define LOGO_LABEL_Y 35
#define LOGO_LABEL_FONT_SIZE 20

#define VERSION_X 266
#define VERSION_Y LOGO_LABEL_Y
#define VERSION_FONT_SIZE SMALL_TEXT_SIZE

void BaseGui::preDraw(tsl::gfx::Renderer* renderer)
{
    renderer->drawString("Sys-clk-OC overlay", false, LOGO_LABEL_X, LOGO_LABEL_Y, LOGO_LABEL_FONT_SIZE, TEXT_COLOR);
    renderer->drawString(TARGET_VERSION, false, VERSION_X, VERSION_Y, VERSION_FONT_SIZE, DESC_COLOR);
}

tsl::elm::Element* BaseGui::createUI()
{
    BaseFrame* rootFrame = new BaseFrame(this);
    rootFrame->setContent(this->baseUI());
    return rootFrame;
}

void BaseGui::update()
{
    this->refresh();
}
