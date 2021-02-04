# kefir ![Github latest downloads](https://img.shields.io/github/downloads/rashevskyv/kefir/total.svg)

CFW pack with Atmosphere for NSW. Supports both Erista and Mariko

## What does kefir consist of

1. **[Atmosphere](https://github.com/Atmosphere-NX/Atmosphere/releases/)**
2. **[Sigpatches](https://github.com/ITotalJustice/patches/releases)**. Thanks to the Atmosphere sigpatch, you can run unsigned (read: *pirated*) applications and games. 
3. **Загрузчик [hekate](https://github.com/CTCaer/hekate/releases/latest)**. БThanks to the bootloader, you can run firmware and other payloads through a convenient menu, create and restore a NAND backup, make EmuNAND, get information about the system state, mount a memory card to a PC without pulling it out of the switch, re-partition the memory card to install other operating systems, and much other
4. **Установленные пейлоады**:
     * [Lockpick_RCM](https://github.com/rashevskyv/Lockpick_RCM) - payload for [dumping console's keys](http://switch.customfw.xyz/backup-nand#часть-iii---дампим-ключи)
     * [Incognoto_RCM](https://github.com/jimzrt/Incognito_RCM) - payload for removing prodinfo information, that allow you [avoid ban more effectively](https://switch.customfw.xyz/block-update)
5. **Установленное Homebrew**
     * [DBI](https://github.com/rashevskyv/dbi) - program for [installing games](http://switch.customfw.xyz/games) via USB or from a memory card
     * [tinfoil](http://tinfoil.io) - a program that allows [download games](http://switch.customfw.xyz/tinfoil) for the console directly from the network
     * [FreshHay](https://github.com/devgru/FreshHay/releases) - program for downloading and unpacking the recommended version of the system software directly on the console
     * [NX-Shell](https://github.com/joel16/NX-Shell/releases/latest) - file manager
     * [NX-Activity-Log](https://github.com/tallbl0nde/NX-Activity-Log/releases/latest) - a program that allows you to track time spent in games
     * [JKSV](https://github.com/J-D-K/JKSV/releases) - program for backup and restoration of saves
     * [Kefir Updater](https://github.com/rashevskyv/kefir-updater/releases) - program for updating kefir via the Internet
     * [pplay](https://github.com/Cpasjuste/pplay/releases/latest) - video player 
     * [Daybreak](https://github.com/Atmosphere-NX/Atmosphere/tree/0.14.1/troposphere/daybreak) - program for [safe update](http://switch.customfw.xyz/update-to-latest) version of the system software of the STB
     * [NXThemes Installer](https://github.com/exelix11/SwitchThemeInjector/releases/latest) - custom theme manager
     * [switch-cheats-updater](https://github.com/HamletDuFromage/switch-cheats-updater/releases) - a program for downloading [cheats](http://switch.customfw.xyz/cheats) for installed games.
     * [Linkhlo](https://github.com/rdmrocha/linkalho) - [account linking program](http://switch.customfw.xyz/link-account)
6. **Installed modules**. Modules are additional components that work inside Atmosphere and allow you to do various cool things, such as using xbox-compatible controllers, emulating amiibo, overclocking, and more. Unfortunately, SX OS modules do not support
     * [sys-con](https://github.com/cathery/sys-con/releases/latest) - a module that allows you to connect almost any gamepads to the console via USB
     * [Mission Control](https://github.com/ndeadly/MissionControl) - a module that allows you to connect almost any gamepads to the console via bluetooth
     * [Tesla Overlay Menu](https://github.com/WerWolv/Tesla-Menu/releases) - special overlay menu for interacting with the system
          - [ovlEdiZon.ovl](https://werwolv.net/downloads/EdiZonOverlay.zip) - Module for [using cheats](http://switch.customfw.xyz/cheats)
          - [ovlSysmodules.ovl](https://github.com/WerWolv/ovl-sysmodules/releases) - A module for enabling and disabling installed system modules (such as overclocking, emuuibo, etc.)
          - [nx-ovlloader](https://github.com/WerWolv/nx-ovlloader/releases/){:target="_blank"} - Host process for loading Switch overlay OVLs (NROs)


## Kefir installation instructions (auto, Windows only)

1. Download `_kefir.7z`
1. Unpack `_kefir.7z` anywhere on your PC
1. **Insert into PC** console's memory card
1. Run `install.bat` from the folder where you unpacked` _kefir.7z` and carefully read everything that is written on the screen
1. Enter answers that are appropriate for your situation
    * If you are using **Caffeine** remember to select it in the **options** of installer
1. Wait for the end of copying

## Manual installation instructions (all OS)

### Connecting the STB memory card to the PC:

1. **Via DBI (Recommended for MacOS and other OS users too)**
	1. Start DBI via [HBL](http://switch.customfw.xyz/hbl)
	1. Connect your console to your PC using a USB cable
	1. In DBI select "**Run MTP Responder**"
	1. A new device is mounted on the PC - **Switch**, the folder "**External SD card**" and there is your memory card
	* Remember, MTP can only transfer files manually. Automatic installation via MTP is not possible.
1. **By inserting a memory card into a PC (not recommended for macOS users)**
	1. Reboot the set-top box through the menu called by holding the (POWER) button
	1. On the splash screen of kefir, press the volume down button to get into hekate
	1. Now you can remove the memory card from the PC and insert it into the switch. When you pull out the memory card in the hekate, you do not need to re-forward the payload to enter the firmware. It is enough to insert the card into the console and run the firmware via the **Launch** menu

### Removing old firmware files

1. If you used custom modifications, cheats or translations, move the `contents` folder from the` SX OS` or `atmosphere` folder (the name of the folder depends on your firmware) to the root of the memory card. If not used, skip this part.
1. Remove from the `titles` folder the folders with the following names (if any):
  * `010000000000100D`
  * `0100000000000032`
  * `0100000000000034`
  * `0100000000000036`
  * `010000000000000D`
  * `420000000000000E`
  * `0100000000001000`
  * `0100000000000352`
  * `4200000000000010`
  * `010000000007E51A`
1. Delete all folders from the root of your memory card, except the folders `titles`,` sxos`, `emuMMC` and` Nintendo`, if any.

### Installing Atmosphere

1. Copy the contents of ** the archive `modchip.zip` from the repository of kefir to the root of the memory card.
1. Move the `contents` folder from the root of the memory card to the` atmosphere` folder
1. Correct the attributes according to the instructions below

### Fix attributes

1. In **hekate** go to the **Tools** menu, switch to the **Arch bit • RCM • Touch • Partitions** tab (at the bottom of the screen), select **Fix Archive Bit**
* To get into hekate, if you are not in it, restart the STB by holding the power button for 5 seconds while in the custom firmware, then select **Power Options** -> **Restart**. When the kefir splash skin appears, press (VOL-) (volume down button)
1. After finishing fixing the attributes, click **Close** in the upper right corner
1. Select **Home** -> **Launch** -> **Atmosphere** to boot back into the firmware

### **Important information!**

  * Hekate reboots directly from the firmware, through the usual reboot menu. Just hold down (VOL-) during kefir splash screen
  * You can access your memory card without removing it from the STB via MTP (DBI -> Run MTP Responder)
  * Installing and updating kefir is the same!