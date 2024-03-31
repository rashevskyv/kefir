# KEFIR 6


## Donate

### Paypal
[![PayPal](https://github.com/rashevskyv/kefir/assets/18294541/5e8a41b1-a15e-4e2c-a1fc-9230379ca1fa)](https://www.paypal.com/donate/?hosted_button_id=S5BLF972J8G92)

### Банка monobank
[![Monobank](https://github.com/rashevskyv/kefir/assets/18294541/82d547ee-f39e-43d2-8063-ed663114c1a9)](https://send.monobank.ua/jar/6VmeFAs1zG)

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

CFW pack with Atmosphere for NSW. Supports both Erista and Mariko

## What does kefir consist of

1. **[Kefirosphere](https://github.com/rashevskyv/Kefirosphere)** based on [Atmosphere](https://github.com/Atmosphere-NX/Atmosphere)
2. **[Sigpatches](https://jits.cc/patches)**. Thanks to the Atmosphere sigpatch, you can run unsigned (read: *pirated*) applications and games. 
3. **[hekate bootloader](https://github.com/CTCaer/hekate/releases/latest)**. Thanks to the bootloader, you can run firmware and other payloads through a convenient menu, create and restore a NAND backup, make EmuNAND, get information about the system state, mount a memory card to a PC without pulling it out of the switch, re-partition the memory card to install other operating systems, and much other
4. **Installed payloads**:
     * [Lockpick_RCM](https://github.com/rashevskyv/Lockpick_RCM) - payload for [dumping console's keys](http://switch.customfw.xyz/backup-nand#часть-iii---дампим-ключи)
     * [TegraExplorer](https://github.com/rashevskyv/TegraExplorer/)- A payload-based file explorer 
5. **Installed Homebrew**
     * [DBI](https://github.com/rashevskyv/dbi) - program for [installing games](http://switch.customfw.xyz/games) via USB or from a memory card
     * [tinfoil](http://tinfoil.io) - a program that allows [download games](http://switch.customfw.xyz/tinfoil) for the console directly from the network
     * [Kefir Updater](https://github.com/rashevskyv/kefir-updater) - updater for kefir
     * [Homebrew App Store 2.2](https://github.com/fortheusers/hb-appstore/releases){:target="_blank"} - appstore with hombrews
     * [Daybreak](https://github.com/Atmosphere-NX/Atmosphere/tree/0.14.1/troposphere/daybreak) - program for [safe update](http://switch.customfw.xyz/update-to-latest) version of the system software of the STB
     * [NXThemes Installer](https://github.com/exelix11/SwitchThemeInjector/releases/latest) - custom theme manager
     * [Linkalho](https://github.com/rdmrocha/linkalho) - [account linking program](http://switch.customfw.xyz/link-account)
6. **Installed Modules**. Modules are additional components that operate within the Atmosphere, allowing for various cool features, such as the use of Xbox-compatible controllers, amiibo emulation, overclocking, and more. Unfortunately, SX OS does not support modules.
  * [sys-con](https://github.com/cathery/sys-con) - a module that allows connecting almost any gamepad to the console via USB
  * [Mission Control](https://github.com/ndeadly/MissionControl) - a module that allows connecting almost any gamepad to the console via Bluetooth
  * [Uberhand](https://github.com/efosamark/Uberhand-Overlay) - a special overlay menu for interacting with the system and supporting custom scripts and modules
    - Scripts:
      * **DBI** - changing localization and updating the application
      * **Translate Interface** - additional interface translations to choose from
      * **Semi-stock** - loading into semi-stock from the menu
      * **Reboot and Shutdown** - rebooting and turning off the console from the menu
    - Modules:
      - [nx-ovlloader](https://github.com/WerWolv/nx-ovlloader/) - a process for working with nro through Tesla Menu
      - [ovlEdiZon.ovl](https://github.com/proferabg/EdiZon-Overlay/releases) - A module for [using cheats](cheats)
      - [ovlSysmodules.ovl](https://github.com/WerWolv/ovl-sysmodules/) - A module for enabling and disabling installed system modules (such as overclocking, emuiibo, and others)

## Installing or updating kefir

### Connecting the memory card to the PC

*If you are a macOS user, use [these guidelines](sd-macos) to avoid memory card problems*

If the console is turned off, insert the memory card into the PC, if it is turned on, then:

1. Reboot console through the menu called by holding down the (POWER) button
2. On the splash screen of kefir, press the volume down button to get into the hekate
3. Now you can remove the memory card from the switch and insert it into the PC.

* When pulling out the memory card in the **hekate**, you will not need to re-forward the payload to enter the firmware. It is enough to insert the card into the console and run the firmware via the **Launch** menu

### Installing kefir

1. Copy the contents of the **archive** `kefir.zip` from this repository to the root of the memory card.
2. Insert the memory card back into the Switch
3. In **hekate** select *More configs* -> *Update Kefir*
4. After the installation is complete, the set-top box will start into the firmware

## Kefir update directly on the console (kefir version 529 or higher)

1. Run [HBL](hbl) 
2. Select **Kefir Updater**
   * Internet connection required!
3. Click "**Update Kefir**", click on **Kefir% version_number%**, select **Download**
4. Wait for the download and decompression to finish, then click **Continue**. The prefix will reboot into the payload, after which the process of installing kefir will begin
5. After finishing the installation, press any button to load the Atmosphere

## **Important information!**

  * Hekate reboots directly from the firmware, through the usual reboot menu. Just hold down (VOL-) during kefir splash screen
  * You can access your memory card without removing it from the HOS via MTP (DBI -> Run MTP Responder) **You cannot update kefir by this way!**
  * Installing and updating kefir is the same!
