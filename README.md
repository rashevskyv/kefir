# KEFIR 6

# 🇺🇦 UKRAINE NEEDS YOUR HELP NOW!
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
2. **[Sigpatches](https://github.com/ITotalJustice/patches/releases)**. Thanks to the Atmosphere sigpatch, you can run unsigned (read: *pirated*) applications and games. 
3. **[hekate bootloader](https://github.com/CTCaer/hekate/releases/latest)**. Thanks to the bootloader, you can run firmware and other payloads through a convenient menu, create and restore a NAND backup, make EmuNAND, get information about the system state, mount a memory card to a PC without pulling it out of the switch, re-partition the memory card to install other operating systems, and much other
4. **Installed payloads**:
     * [Lockpick_RCM](https://github.com/rashevskyv/Lockpick_RCM) - payload for [dumping console's keys](http://switch.customfw.xyz/backup-nand#часть-iii---дампим-ключи)
     * [TegraExplorer](https://github.com/rashevskyv/TegraExplorer/)- A payload-based file explorer 
     
5. **Installed Homebrew**
     * [DBI](https://github.com/rashevskyv/dbi) - program for [installing games](http://switch.customfw.xyz/games) via USB or from a memory card
     * [tinfoil](http://tinfoil.io) - a program that allows [download games](http://switch.customfw.xyz/tinfoil) for the console directly from the network
     * [Kefir Updater](https://github.com/rashevskyv/kefir-updater) - updater for kefir 
     * [NX-Shell](https://github.com/joel16/NX-Shell/releases/latest) - file manager
     * [NX-Activity-Log](https://github.com/tallbl0nde/NX-Activity-Log/releases/latest) - a program that allows you to track time spent in games
     * [JKSV](https://github.com/J-D-K/JKSV/releases) - program for backup and restoration of saves
     * [Kefir Updater](https://github.com/rashevskyv/kefir-updater/releases) - program for updating kefir via the Internet
     * [pplay](https://github.com/Cpasjuste/pplay/releases/latest) - video player 
     * [Daybreak](https://github.com/Atmosphere-NX/Atmosphere/tree/0.14.1/troposphere/daybreak) - program for [safe update](http://switch.customfw.xyz/update-to-latest) version of the system software of the STB
     * [NXThemes Installer](https://github.com/exelix11/SwitchThemeInjector/releases/latest) - custom theme manager
     * [Linkalho](https://github.com/rdmrocha/linkalho) - [account linking program](http://switch.customfw.xyz/link-account)
6. **Installed modules**. Modules are additional components that work inside Atmosphere and allow you to do various cool things, such as using xbox-compatible controllers, emulating amiibo, overclocking, and more. Unfortunately, SX OS modules do not support
     * [sys-con](https://github.com/cathery/sys-con/releases/latest) - a module that allows you to connect almost any gamepads to the console via USB
     * [Mission Control](https://github.com/ndeadly/MissionControl) - a module that allows you to connect almost any gamepads to the console via bluetooth
     * [Tesla Overlay Menu](https://github.com/WerWolv/Tesla-Menu/releases) - special overlay menu for interacting with the system
          - [ovlEdiZon.ovl](https://github.com/proferabg/EdiZon-Overlay/releases) - Module for [using cheats](http://switch.customfw.xyz/cheats)
          - [ovlSysmodules.ovl](https://github.com/WerWolv/ovl-sysmodules/releases) - A module for enabling and disabling installed system modules (such as overclocking, emuuibo, etc.)
          - [nx-ovlloader](https://github.com/WerWolv/nx-ovlloader/releases/) - Host process for loading Switch overlay OVLs (NROs)

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
