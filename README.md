# Kefir 3
![Github latest downloads](https://img.shields.io/github/downloads/rashevskyv/kefir/total.svg)

[Українською](README_ukr.md)

## What is Kefir

This is a collection consisting of modified Atmosphere, necessary programs and scripts that install everything correctly. It was created to facilitate the installation and maintenance of software on a hacked Nintendo Switch. The changes made to Atmosphere are aimed at improving the quality of using the system itself.

Main differences from vanilla Atmosphere:
  * Kefir versions alongside system versions
  * Installation of exFAT memory card driver by default when updating the system
  * Removal of ACID signature verification for using homebrew without patches
  * Removal of system logging to prevent memory card cluttering and excessive usage
  * Redirection of saves from internal memory to memory card when using emuNAND to reduce the probability of losing them if emuNAND fails (optional)

**Kefir** is **not a firmware**! It's a collection consisting of Atmosphere firmware and the necessary minimum of recommended programs, plugins, modules and other software.

Latest supported system version: **23.5.0**.

## Why do you need Kefir?

First of all, Kefir is needed to simplify the user's life. That is, if the user has the recommended version of system software and the latest version of Kefir, then everything should work for them. It can be said that the user is in controlled conditions. It's enough to name the version of the system software and Kefir, and it immediately becomes clear what is approximately installed in the system.

## What is new in Kefir 3

Kefir 3 has one main app: **[Kefir Hub](https://github.com/rashevskyv/kefir-hub)** ([documentation](https://hub.customfw.xyz)). It replaces several programs of the old pack:

| Before (Kefir 2) | Now (Kefir 3) |
|---|---|
| Sphaira, hbmenu | Kefir Hub (it also opens as the homebrew menu) |
| Kefir Updater | Kefir Hub → **Tools** → **Updater** (Kefir updates) |
| Daybreak | Kefir Hub → **Tools** → **Updater** (system updates from a ZIP or a folder) |
| Linkalho | Kefir Hub → **Tools** → **Tools** → **Users** (account linking) |
| Ultrahand menus: Settings, Software, Theme, Translate Interface | Kefir Hub → **Tools** → **Kefir Settings**, **Software** and **Themes** |

In Kefir Hub, press **R** to open **Tools**. The first start shows short hints about where everything is.

## Kefir composition

1. **[Kefirosphere](https://github.com/rashevskyv/Kefirosphere)**, a fork of [Atmosphere](https://github.com/Atmosphere-NX/Atmosphere)
2. **Signature patches**. They are built into the Kefirosphere loader, and [sys-patch](https://github.com/impeeza/sys-patch) is installed too. Thanks to them, you can run unsigned (read: *pirated*) programs and games on Atmosphere.
3. **Bootloader [hekate](https://github.com/CTCaer/hekate)**: Thanks to the bootloader, you can launch firmware and other payloads through a convenient menu, create and restore NAND backups, make EmuNAND, get information about the system state, mount the memory card to PC without removing it from the switch, repartition the memory card for installing other OSes, and much more
4. **Installed payloads**:
  * [Lockpick_RCM](https://github.com/impeeza/Lockpick_RCMDecScots) - program for dumping console keys
  * [TegraExplorer](https://github.com/rashevskyv/TegraExplorer/) - file manager for Switch in the form of a payload. Analog of GodMode9 for 3DS. Kefir also uses it to install its updates
5. **Installed Homebrew**
  * [Kefir Hub](https://github.com/rashevskyv/kefir-hub) - the main app of Kefir: homebrew menu, Kefir and system updates, game installation (USB, MTP, network), saves, account linking, themes, homebrew store, Kefir settings, system tools
  * [DBI](https://github.com/rashevskyv/dbi) - program for installing games via USB or from memory card. On a PC, use [DBI Backend Qt](https://github.com/rashevskyv/dbibackend-qt) with it
  * [NXThemes Installer](https://github.com/exelix11/SwitchThemeInjector) - custom themes manager
  * [NX-Activity-Log](https://github.com/aoihera/NX-Activity-Log) - Nintendo Switch play activity visualizer
  * [pipensx](https://gitlab.com/pipensx-group/pipensx) - torrent catalog viewer and downloader
  * [TorrentShopNX](https://github.com/Langegen/TorrentShopNX) - torrent catalog for the console
6. **Installed modules**. Modules are additional components that work inside Atmosphere and allow you to do various cool things, for example, using Xbox-compatible controllers, amiibo emulation, overclocking, etc.
  * [sys-con](https://github.com/o0Zz/sys-con) - module that allows connecting almost any gamepad to the console via USB
  * [Mission Control](https://github.com/ndeadly/MissionControl) - module that allows connecting almost any gamepad to the console via bluetooth
  * [sys-patch](https://github.com/impeeza/sys-patch) - signature patches in memory
  * [Ultrahand](https://github.com/ppkantorski/Ultrahand-Overlay) - overlay menu, opened with (L) + **d-pad down** + (R3)
    - Packages: **Semi-Stock** (boot into semi-stock from the menu), **Reboot** and **Shutdown**
    - Overlays:
      - [nx-ovlloader](https://github.com/WerWolv/nx-ovlloader) - loader for overlays
      - [ovlEdiZon](https://github.com/proferabg/EdiZon-Overlay) - cheats
      - [ovlSysmodules](https://github.com/ppkantorski/ovl-sysmodules) - turns installed system modules on and off
      - [sys-patch overlay](https://github.com/impeeza/sys-patch) - sys-patch status and settings

## Instructions for installing/updating kefir

### First installation or installation on a clean memory card

1. Copy the **contents** of the `kefir.zip` archive from the repository to the root of the console's memory card
2. Insert the memory card into the Switch
3. Launch the console into firmware, according to your hack type. `payload.bin` - the payload that needs to be injected when launching the console via Fusée Gelée, is located in the archive with the collection

### Updating kefir or transitioning from another collection

#### Updating kefir directly on the console (recommended)

1. Open **Kefir Hub** (it starts as the homebrew menu)
2. Press **R** to open **Tools**, then select **Updater** (Internet connection required!)
3. Select the new Kefir version and install it. The console reboots into TegraExplorer, which installs Kefir
4. After the installation is complete, the console boots into the firmware

> The same **Updater** installs system updates. Daybreak is no longer in Kefir.

#### Manual installation instructions (all OS)

##### Connecting the console's memory card to PC

If you are a MacOS user, follow the recommended steps to avoid problems with the memory card.

If the console is turned off, insert the memory card into the PC. If it's turned on:
1. Restart the console through the menu that is called by holding the (POWER) button
2. On the kefir splash screen, press the volume down button to get to hekate
3. Now you can remove the memory card from the switch and insert it into the PC.

> When removing the memory card in hekate, you won't need to re-inject the payload to enter the firmware. Just insert the card into the console and launch the firmware through the **Launch** menu

##### Installing kefir (all OS)

1. Copy the **contents** of the `kefir.zip` archive from the repository to the root of the console's memory card
2. Insert the memory card back into the Switch
3. In **hekate**, select **More configs** -> **Update Kefir**
4. After the installation is complete, the console will boot into the firmware

> You can also simply turn off the console, remove the card from it, copy kefir onto it with replacement, then insert the card back into the Switch and turn on the console. In this case, the update script will be launched automatically

> The update removes the programs that Kefir 3 no longer ships: Kefir Updater, Daybreak, Linkalho and the old Ultrahand menus.

#### Clean kefir installation (recommended when errors occur)

1. Delete everything from the card except the `Nintendo` and `emummc` folders, if they exist
2. Install kefir using a convenient method described above

#### Debugging kefir installation (recommended if a clean installation didn't help)

1. Copy the `Nintendo` and `emummc` folders, if they exist, to PC
2. Format your memory card in FAT32 and return the folders back
3. Install kefir using a convenient method

### Troubleshooting

If you encounter a [NOFAT] error or any other problem with updating through the update script, use the kefir installation through `install.bat`:

1. Unpack `kefir.zip` to any convenient location **on PC**, *except the console's memory card*
2. **Insert into PC** the console's memory card
3. Run `install.bat` from the folder where you unpacked `kefir.zip` and specify the letter of your memory card
4. Wait for the copying to complete
5. Insert the card into PC and launch the firmware

> If you get the "**Is BEK missing**" error, turn off the console and turn it on again.

## Launching Atmosphere

If after entering the firmware the console doesn't see the card and requires a firmware update for it to work, or simply hangs on a black screen after the Nintendo logo, then your console doesn't have exFAT drivers installed! Format the memory card in FAT32.

In hekate, autoboot is set by default. That is, when the console starts, the hekate menu will not be displayed, but the firmware will start immediately. To go to the hekate menu, hold (VOL-) during the splash screen appearance.

### **Important Information!**

  * Reboot to hekate happens directly from the firmware, through the normal reboot menu. Just hold (VOL-) during the kefir splash screen
  * You can access your memory card without removing it from the console via MTP in **Kefir Hub** or **DBI** (**Run MTP Responder**), or through hekate (does not work correctly for everyone, **it is impossible to update kefir via MTP**)
  * Installing and updating kefir are done the same way!
  * If you encounter the "**Is BEK missing**" error, turn off the console and turn it on again.

## Additional Information
* Kefir settings are in **Kefir Hub** → **Tools** → **Kefir Settings**: overclock, 40 MB applet memory, USB 3.0, emuMMC saves on the memory card, 8GB memory mode, Nextendo, interface translation
* DBI updates and the homebrew store (App Store) are in **Kefir Hub** → **Tools** → **Software**
* To switch to semi-stock
  * **From the firmware itself**: open Ultrahand ((L) + **d-pad down** + (R3)) > `Kefir Menu` > `Semi-Stock Status`
  * **When starting the console**: Navigate to hekate and select `More-configs` > `Semi-stock (Legacy)`
  * Note that when launching from firmware, the installed theme will be disabled, which will help avoid errors if there are different versions of system software and emuNAND on the console
* You can update kefir and the system version in **Kefir Hub** → **Tools** → **Updater**

### Overclocking
* To turn overclocking on or off, open **Kefir Hub** → **Tools** → **Kefir Settings** → `Overclock status`

### 8GB Memory Support Mode
* **Only for consoles with physically soldered 8GB RAM.** Other consoles will not boot correctly
* **Enabling**: **Kefir Hub** → **Tools** → **Kefir Settings** → `8GB DRAM status`
* **Disabling** if the console does not boot: hekate > `Payloads` > `TegraExplorer` > `Remove_8GB-RAM_config.te`, or reinstall kefir
 

________

## Kefir's sources moved here - [bitbucket](https://bitbucket.org/kefir-switch/kefir/src/master/), kefir binary on releases

## Donate to kefir's dev
### Paypal
[![PayPal](https://github.com/rashevskyv/kefir/assets/18294541/5e8a41b1-a15e-4e2c-a1fc-9230379ca1fa)](https://www.paypal.com/donate/?hosted_button_id=S5BLF972J8G92)

### Банка monobank
[![mono](https://github.com/user-attachments/assets/adc1d908-c511-4e03-8d63-f0370a7752bd)](https://send.monobank.ua/jar/9PwYEXHYbs)

## Donate for support Ukraine
### 🇺🇦 UKRAINE NEEDS YOUR HELP NOW!
>
> I'm the creator of this project and I'm Ukrainian.
>
> **My country, Ukraine, [is being invaded by the Russian Federation, right now](https://www.bbc.com/news/world-europe-60504334)**. I've fled Ivano-Frankivs'k and now I'm safe with my family in the western part of Ukraine. At least for now.
> Russia is hitting target all over my country by ballistic missiles.
>
> **Please, save me and help to save my country!**
>
> Ukrainian National Bank opened [an account to Raise Funds for Ukraine’s Armed Forces](https://bank.gov.ua/en/news/all/natsionalniy-bank-vidkriv-spetsrahunok-dlya-zboru-koshtiv-na-potrebi-armiyi):
>
> ```
> SWIFT Code NBU: NBUA UA UX
> JP MORGAN CHASE BANK, New York
> SWIFT Code: CHASUS33
> Account: 400807238
> 383 Madison Avenue, New York, NY 10179, USA
> IBAN: UA843000010000000047330992708
> ```
> 
> [Come Back and Alive found (savelife.in.ua)](https://savelife.in.ua/)
> 
> ```
> BITCOIN
> bc1qkd5az2ml7dk5j5h672yhxmhmxe9tuf97j39fm6
> 
> ETHEREUM (eth, usdt, usdc)
> 0xa1b1bbB8070Df2450810b8eB2425D543cfCeF79b
> 0x93Bda139023d582C19D70F55561f232D3CA6a54c
> 
> TRC20 (tether)
> TX9aNri16bSxVYi6oMnKDj5RMKAMBXWzon
> 
> Solana (sol)
> 8icxpGYCoR8SRKqLYsSarcAjBjBPuXAuHkeJjJx5ju7a
> ```
>
> You can also donate to [charity supporting Ukrainian army](https://savelife.in.ua/en/donate/).
>
> **THANK YOU!**

