@echo off
chcp 866 >nul 2>&1

COLOR 0F

set wd=%temp%\sdfiles
set clear=0
set cfw=ATMO
set cfwname=Atmosphere
set lang=0
set theme_flag=0
set theme=0
set caffeine=0
set dbi=0
set tesla=0
set tesla_flag=1
set modchip=1
set bootdat=1
set syscon=1
set missioncontrol=1
set payloadbin=1
set nyx=0


:newcard
COLOR 0F
cls
if %lang%==1 (
	echo Выберите вашу карту памяти из смонтированных
) else (
	echo Choose mounted SD card letter
)

for /f "tokens=3-6 delims=: " %%a in ('WMIC LOGICALDISK GET FreeSpace^,Name^,Size^,filesystem^,description ^|FINDSTR /I "Removable" ^|findstr /i "exfat fat32"') do (@echo wsh.echo "Disk letter: %%c;" ^& " free: " ^& FormatNumber^(cdbl^(%%b^)/1024/1024/1024, 2^)^& " GB;"^& " size: " ^& FormatNumber^(cdbl^(%%d^)/1024/1024/1024, 2^)^& " GB;" ^& " FS: %%a" > %temp%\tmp.vbs & @if not "%%c"=="" @echo( & @cscript //nologo %temp%\tmp.vbs & del %temp%\tmp.vbs)
echo.
if %lang%==1 (
	set /P sd="Введите букву по которой смонтирована карта памяти: "
) else (
	set /P sd="Enter SD card letter: "
)

if not exist "%sd%:\" (
	set word=        There is no SD card in %sd%-drive         
	goto WRONGSD
) else (
	if not exist "%sd%:\*" (goto WRONGSD)
)

:main

if not exist "%sd%:\boot.dat" (set bootdat=0)
if not exist "%sd%:\atmosphere\contents\690000000000000D\flags\boot2.flag" (set syscon=0)
if not exist "%sd%:\atmosphere\contents\010000000000bd00\flags\boot2.flag" (set missioncontrol=0)
if not exist "%sd%:\payload.bin" (set payloadbin=0)

rem set missioncontrol=0


echo ------------------------------------------------------------------------
echo.
echo                          Remove old pack files                          
echo.
echo ------------------------------------------------------------------------
echo.


if exist "%sd%:\atmosphere\exefs_patches" (RD /s /q "%sd%:\atmosphere\exefs_patches")
if exist "%sd%:\atmosphere\kip_patches" (RD /s /q "%sd%:\atmosphere\kip_patches")
if exist "%sd%:\atmosphere\hekate_kips" (RD /s /q "%sd%:\atmosphere\hekate_kips")
if exist "%sd%:\bootloader\debug" (RD /s /q "%sd%:\bootloader\debug")
if exist "%sd%:\modules" (RD /s /q "%sd%:\modules")
if exist "%sd%:\atmo" (RD /s /q "%sd%:\atmo")

if exist "%sd%:\atmosphere\titles" (rename %sd%:\atmosphere\titles contents)
if exist "%sd%:\atmosphere\title" (rename %sd%:\atmosphere\title contents)
if exist "%sd%:\atmosphere\content" (rename %sd%:\atmosphere\content contents)

if exist "%sd%:\atmosphere\contents\0100000000000032" (RD /s /q "%sd%:\atmosphere\contents\0100000000000032")
if exist "%sd%:\atmosphere\contents\010000000000003C" (RD /s /q "%sd%:\atmosphere\contents\010000000000003C")
if exist "%sd%:\atmosphere\contents\0100000000000034" (RD /s /q "%sd%:\atmosphere\contents\0100000000000034")
if exist "%sd%:\atmosphere\contents\0100000000000037" (RD /s /q "%sd%:\atmosphere\contents\0100000000000037")
if exist "%sd%:\atmosphere\contents\0100000000000036" (RD /s /q "%sd%:\atmosphere\contents\0100000000000042")
if exist "%sd%:\atmosphere\contents\0100000000000042" (RD /s /q "%sd%:\atmosphere\contents\0100000000000042")
if exist "%sd%:\atmosphere\contents\010000000000002b" (RD /s /q "%sd%:\atmosphere\contents\010000000000002b")
if exist "%sd%:\atmosphere\contents\010000000000000D" (RD /s /q "%sd%:\atmosphere\contents\010000000000000D")
if exist "%sd%:\atmosphere\contents\010000000000100D" (RD /s /q "%sd%:\atmosphere\contents\010000000000100D")
if exist "%sd%:\atmosphere\contents\4200000000000010" (RD /s /q "%sd%:\atmosphere\contents\4200000000000010")
if exist "%sd%:\atmosphere\contents\0100000000000008" (RD /s /q "%sd%:\atmosphere\contents\0100000000000008")
if exist "%sd%:\atmosphere\contents\690000000000000D" (RD /s /q "%sd%:\atmosphere\contents\690000000000000D")
if exist "%sd%:\atmosphere\contents\420000000000000E" (RD /s /q "%sd%:\atmosphere\contents\420000000000000E")
if exist "%sd%:\atmosphere\contents\010000000000100B" (RD /s /q "%sd%:\atmosphere\contents\010000000000100B")
if exist "%sd%:\atmosphere\contents\01FF415446660000" (RD /s /q "%sd%:\atmosphere\contents\01FF415446660000")
if exist "%sd%:\atmosphere\contents\0100000000000352" (RD /s /q "%sd%:\atmosphere\contents\0100000000000352")
if exist "%sd%:\atmosphere\contents\00FF747765616BFF" (RD /s /q "%sd%:\atmosphere\contents\00FF747765616BFF")
if exist "%sd%:\atmosphere\contents\00FF0012656180FF" (RD /s /q "%sd%:\atmosphere\contents\00FF0012656180FF")
if exist "%sd%:\atmosphere\contents\0100000000001013" (RD /s /q "%sd%:\atmosphere\contents\0100000000001013")
if exist "%sd%:\atmosphere\contents\010000000007E51A" (RD /s /q "%sd%:\atmosphere\contents\010000000007E51A")
if exist "%sd%:\atmosphere\contents\420000000007E51A" (RD /s /q "%sd%:\atmosphere\contents\420000000007E51A")
if exist "%sd%:\atmosphere\contents\0100000000001000" (RD /s /q "%sd%:\atmosphere\contents\0100000000001000")
if exist "%sd%:\atmosphere\contents\010000000000100C" (RD /s /q "%sd%:\atmosphere\contents\010000000000100C")
if exist "%sd%:\atmosphere\contents\0000000000534C56" (RD /s /q "%sd%:\atmosphere\contents\0000000000534C56")
if exist "%sd%:\atmosphere\contents\0100000000000081" (RD /s /q "%sd%:\atmosphere\contents\0100000000000081")
if exist "%sd%:\atmosphere\contents\010000000000bd00" (RD /s /q "%sd%:\atmosphere\contents\010000000000bd00")

if exist "%sd%:\atmosphere\erpt_reports" (RD /s /q "%sd%:\atmosphere\erpt_reports")
if exist "%sd%:\atmosphere\fatal_reports" (RD /s /q "%sd%:\atmosphere\fatal_reports")
if exist "%sd%:\atmosphere\fatal_errors" (RD /s /q "%sd%:\atmosphere\fatal_errors")
if exist "%sd%:\atmosphere\crash_reports" (RD /s /q "%sd%:\atmosphere\crash_reports")
if exist "%sd%:\atmosphere\stratosphere.romfs" (del "%sd%:\atmosphere\stratosphere.romfs")

if exist "%sd%:\atmosphere\fusee-secondary_atmo.bin" (del "%sd%:\atmosphere\fusee-secondary_atmo.bin")
if exist "%sd%:\atmosphere\hbl_atmo.nsp" (del "%sd%:\atmosphere\hbl_atmo.nsp")
if exist "%sd%:\atmosphere\fusee-secondary.bin.sig" (del "%sd%:\atmosphere\fusee-secondary.bin.sig")
if exist "%sd%:\atmosphere\hbl.nsp.sig" (del "%sd%:\atmosphere\hbl.nsp.sig")
if exist "%sd%:\atmosphere\hbl.json" (del "%sd%:\atmosphere\hbl.json")
if exist "%sd%:\atmosphere\BCT.ini" (del "%sd%:\atmosphere\BCT.ini")
if exist "%sd%:\atmosphere\config\BCT.ini" (del "%sd%:\atmosphere\config\BCT.ini")
if exist "%sd%:\atmosphere\package3" (del "%sd%:\atmosphere\package3")
if exist "%sd%:\atmosphere\system_settings.ini" (del "%sd%:\atmosphere\system_settings.ini")
if exist "%sd%:\atmosphere\loader.ini" (del "%sd%:\atmosphere\system_settings.ini")
if exist "%sd%:\atmosphere\kips" (RD /s /q  "%sd%:\atmosphere\kips")
if exist "%sd%:\atmosphere\erpt_reports" (RD /s /q  "%sd%:\atmosphere\erpt_reports")
if exist "%sd%:\atmosphere\flags\hbl_cal_read.flag" (del "%sd%:\atmosphere\flags\hbl_cal_read.flag")
if exist "%sd%:\atmosphere\exosphere.bin" (del "%sd%:\atmosphere\exosphere.bin")
if exist "%sd%:\atmosphere\hbl.nsp" (del "%sd%:\atmosphere\hbl.nsp")
if exist "%sd%:\atmosphere\loader.ini" (del "%sd%:\atmosphere\loader.ini")
if exist "%sd%:\atmosphere\reboot_payload.bin" (del "%sd%:\atmosphere\reboot_payload.bin")
if exist "%sd%:\atmosphere\BCT.ini" (del "%sd%:\atmosphere\BCT.ini")
if exist "%sd%:\sxos\bootloader" (RD /s /q  "%sd%:\sxos\bootloader")
if exist "%sd%:\sxos\switch" (RD /s /q  "%sd%:\sxos\switch")
if exist "%sd%:\sxos\exefs_patches" (RD /s /q  "%sd%:\sxos\exefs_patches")
if exist "%sd%:\sept" (RD /s /q  "%sd%:\sept")
if exist "%sd%:\sxos\boot.dat" (del "%sd%:\sxos\boot.dat")
if exist "%sd%:\games\tinfoil*.*" (del "%sd%:\games\tinfoil*.*")
if exist "%sd%:\sxos\sxos" (
	xcopy %sd%:\sxos\sxos\* %sd%:\sxos\ /Y /S /E /H /R /D
)
if exist "%sd%:\atmosphere\fusee-secondary.bin" (del "%sd%:\atmosphere\fusee-secondary.bin")
if exist "%sd%:\bootloader\payloads\fusee-primary-payload.bin" (del "%sd%:\bootloader\payloads\fusee-primary-payload.bin")
if exist "%sd%:\bootloader\payloads\Lockpick_RCM.bin" (del "%sd%:\bootloader\payloads\Lockpick_RCM.bin")
if exist "%sd%:\bootloader\payloads\biskeydump.bin" (del "%sd%:\bootloader\payloads\biskeydump.bin")
if exist "%sd%:\bootloader\payloads\fusee-payload.bin" (del "%sd%:\bootloader\payloads\fusee-payload.bin")
if exist "%sd%:\bootloader\payloads\fusee-primary.bin" (del "%sd%:\bootloader\payloads\fusee-primary.bin")
if exist "%sd%:\bootloader\payloads\fusee.bin" (del "%sd%:\bootloader\payloads\fusee.bin")
if exist "%sd%:\bootloader\payloads\sxos.bin" (del "%sd%:\bootloader\payloads\sxos.bin")
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\fusee-secondary.bin" (del "%sd%:\fusee-secondary.bin")
if exist "%sd%:\atmosphere\fusee-secondary.bin" (del "%sd%:\atmosphere\fusee-secondary.bin")
if exist "%sd%:\bootloader\ini\Atmosphere.ini" (del "%sd%:\bootloader\ini\Atmosphere.ini")
if exist "%sd%:\bootloader\ini\atmosphere.ini" (del "%sd%:\bootloader\ini\atmosphere.ini")
if exist "%sd%:\bootloader\ini\sxos.ini" (del "%sd%:\bootloader\ini\sxos.ini")
if exist "%sd%:\bootloader\ini\hekate_keys.ini" (del "%sd%:\bootloader\ini\hekate_keys.ini")
if exist "%sd%:\bootloader\hekate_keys.ini" (del "%sd%:\bootloader\hekate_keys.ini")
if exist "%sd%:\bootloader\kefir.ini" (del "%sd%:\bootloader\kefir.ini")
if exist "%sd%:\bootloader\ini\RajNX.ini" (del "%sd%:\bootloader\ini\RajNX.ini")
if exist "%sd%:\bootloader\updating.bmp" (del "%sd%:\bootloader\updating.bmp")

if exist "%sd%:\license-request.dat" (del "%sd%:\license-request.dat")
if exist "%sd%:\boot.dat" (del "%sd%:\boot.dat")
if exist "%sd%:\hekate*.bin" (del "%sd%:\hekate*.bin")
if exist "%sd%:\hbmenu.nro" (del "%sd%:\hbmenu.nro")
if exist "%sd%:\keys.dat" (del "%sd%:\keys.dat")
if exist "%sd%:\BCT.ini" (del "%sd%:\BCT.ini")
if exist "%sd%:\startup.te" (del "%sd%:\startup.te")
if exist "%sd%:\hekate_ipl.ini" (del "%sd%:\hekate_ipl.ini")

if exist "%sd%:\bootloader\hekate_ipl.ini" (del "%sd%:\bootloader\hekate_ipl.ini")
if exist "%sd%:\bootloader\update.bin" (del "%sd%:\bootloader\update.bin")
if exist "%sd%:\bootloader\update.bin.sig" (del "%sd%:\bootloader\update.bin.sig")
if exist "%sd%:\bootloader\patches_template.ini" (del "%sd%:\bootloader\patches_template.ini")
if exist "%sd%:\bootloader\patches.ini" (del "%sd%:\bootloader\patches.ini")
if exist "%sd%:\bootloader\bootlogo.bmp" (del "%sd%:\bootloader\bootlogo.bmp")
if exist "%sd%:\bootloader\res\icon_payload.bmp" (del "%sd%:\bootloader\res\icon_payload.bmp")
if exist "%sd%:\bootloader\res\icon_switch.bmp" (del "%sd%:\bootloader\res\icon_switch.bmp")
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\switch\games\hbmenu*.nsp" (del "%sd%:\switch\games\hbmenu*.nsp")
if exist "%sd%:\switch\lithium" (RD /s /q "%sd%:\switch\lithium")
if exist "%sd%:\switch\tinfoil" (RD /s /q "%sd%:\switch\tinfoil")
if exist "%sd%:\switch\LinkUser" (RD /s /q "%sd%:\switch\LinkUser")
if exist "%sd%:\switch\KosmosToolbox" (RD /s /q "%sd%:\switch\KosmosToolbox")
if exist "%sd%:\switch\KosmosUpdater" (RD /s /q "%sd%:\switch\KosmosUpdater")
if exist "%sd%:\switch\mercury" (RD /s /q "%sd%:\switch\mercury")
if exist "%sd%:\switch\nxmtp" (RD /s /q "%sd%:\switch\nxmtp")
rem if exist "%sd%:\switch\EdiZon.nro" (del "%sd%:\switch\EdiZon.nro")
if exist "%sd%:\switch\tinfoil\tinfoil.nro" (del "%sd%:\switch\tinfoil\tinfoil.nro")
if exist "%sd%:\switch\tinfoil\keys.txt" (del "%sd%:\switch\tinfoil\keys.txt")
if exist "%sd%:\switch\nxmtp.nro" (del "%sd%:\switch\nxmtp.nro")
if exist "%sd%:\switch\pplay.nro" (del "%sd%:\switch\pplay.nro")
if exist "%sd%:\switch\NX-SHELL.nro" (del "%sd%:\switch\NX-SHELL.nro")
if exist "%sd%:\switch\reboot_to_payload.nro" (del "%sd%:\switch\reboot_to_payload.nro")
if exist "%sd%:\switch\NxThemesInstaller.nro" (del "%sd%:\switch\NxThemesInstaller.nro")
if exist "%sd%:\switch\NxThemesInstaller\NxThemesInstaller.nro" (del "%sd%:\switch\NxThemesInstaller\NxThemesInstaller.nro")
if exist "%sd%:\switch\sx.nro" (del "%sd%:\switch\sx.nro")
if exist "%sd%:\switch\n1dus.nro" (del "%sd%:\switch\n1dus.nro")
if exist "%sd%:\switch\ChoiDujourNX.nro" (del "%sd%:\switch\ChoiDujourNX.nro")
if exist "%sd%:\switch\ChoiDujourNX\ChoiDujourNX.nro" (del "%sd%:\switch\ChoiDujourNX\ChoiDujourNX.nro")
if exist "%sd%:\switch\kefirupdater\kefirupdater.nro" (del "%sd%:\switch\kefirupdater\kefirupdater.nro")
if exist "%sd%:\switch\kefirupdater\kefir-updater.nro" (del "%sd%:\switch\kefirupdater\kefir-updater.nro")
if exist "%sd%:\switch\kefirupdater.nro" (del "%sd%:\switch\kefirupdater\kefirupdater.nro")
if exist "%sd%:\switch\kefir-updater.nro" (del "%sd%:\switch\kefirupdater\kefir-updater.nro")
if exist "%sd%:\switch\daybreak.nro" (del "%sd%:\switch\daybreak.nro")
if exist "%sd%:\switch\daybreak\daybreak.nro" (del "%sd%:\switch\daybreak\daybreak.nro")
if exist "%sd%:\switch\kefirupdater\cheats.zip" (del "%sd%:\switch\kefirupdater\cheats.zip")
if exist "%sd%:\switch\kefirupdater\kefir.zip" (del "%sd%:\switch\kefirupdater\kefir.zip")
if exist "%sd%:\switch\kefirupdater\firmware.zip" (del "%sd%:\switch\kefirupdater\firmware.zip")

if exist "%sd%:\switch\LinkUser" (RD /s /q "%sd%:\switch\LinkUser\")
if exist "%sd%:\switch\dbi.nro" (del "%sd%:\switch\dbi.nro")
if exist "%sd%:\switch\btpair.nro" (del "%sd%:\switch\btpair.nro")
if exist "%sd%:\switch\btpair\btpair.nro" (del "%sd%:\switch\btpair\btpair.nro")
if exist "%sd%:\switch\.DBI.nro.star" (del "%sd%:\switch\.DBI.nro.star")
if exist "%sd%:\switch\dbi\dbi.nro" (del "%sd%:\switch\dbi\dbi.nro")
rem if exist "%sd%:\switch\dbi\dbi.config" (copy "%sd%:\switch\dbi\dbi.config" "%sd%:\switch\dbi\dbi.config.bak")
if exist "%sd%:\switch\dbi\dbi.config" (del "%sd%:\switch\dbi\dbi.config")
if exist "%sd%:\switch\Lockpick\Lockpick.nro" (del "%sd%:\switch\Lockpick\Lockpick.nro")
if exist "%sd%:\switch\Lockpick.nro" (del "%sd%:\switch\Lockpick.nro")
if exist "%sd%:\switch\nxmtp.nro" (del "%sd%:\switch\nxmtp.nro")
if exist "%sd%:\switch\nxmtp" (RD /s /q "%sd%:\switch\nxmtp\")
if exist "%sd%:\switch\NX-Activity-Log.nro" (del "%sd%:\switch\NX-Activity-Log.nro")
if exist "%sd%:\switch\switch-cheats-updater" (RD /s /q "%sd%:\switch\switch-cheats-updater\")
if exist "%sd%:\switch\FreshHay" (RD /s /q "%sd%:\switch\FreshHay\")
if exist "%sd%:\switch\nx-ntpc" (RD /s /q "%sd%:\switch\nx-ntpc\")
if exist "%sd%:\switch\sx\locations.conf" (del "%sd%:\switch\sx\locations.conf")
if exist "%sd%:\switch\sx\sx.nro" (del "%sd%:\switch\sx\sx.nro")
if exist "%sd%:\switch\sx.nro" (del "%sd%:\switch\sx.nro")
if exist "%sd%:\switch\incognito.nro" (del "%sd%:\switch\incognito.nro")
if exist "%sd%:\switch\incognito" (RD /s /q "%sd%:\switch\incognito")
if exist "%sd%:\switch\ultimate_updater.nro" (del "%sd%:\switch\ultimate_updater.nro")
if exist "%sd%:\switch\zerotwoxci.nro" (del "%sd%:\switch\zerotwoxci.nro")
if exist "%sd%:\switch\dOPUS.nro" (del "%sd%:\switch\dOPUS.nro")
if exist "%sd%:\switch\tinfoil.nro" (del "%sd%:\switch\tinfoil.nro")
if exist "%sd%:\switch\tinfoil_batch.nro" (del "%sd%:\switch\tinfoil_batch.nro")
if exist "%sd%:\switch\tinfoil_duckbill.nro" (del "%sd%:\switch\tinfoil_duckbill.nro")
if exist "%sd%:\switch\tinfoil_usb-fix.nro" (del "%sd%:\switch\tinfoil_usb-fix.nro")
if exist "%sd%:\switch\ldnmitm_config.nro" (del "%sd%:\switch\ldnmitm_config.nro")
if exist "%sd%:\switch\ldnmitm_config" (RD /s /q "%sd%:\switch\ldnmitm_config")
if exist "%sd%:\pegascape" (RD /s /q "%sd%:\pegascape")
if exist "%sd%:\switch\fakenews-injector.nro" (del "%sd%:\switch\fakenews-injector.nro")
if exist "%sd%:\switch\gag-order.nro" (del "%sd%:\switch\gag-order.nro")
if exist "%sd%:\games\hbgShop*.nsp" (del "%sd%:\games\hbgShop_forwarder_classic.nsp")
if exist "%sd%:\games\Tinfoil*.nsp" (del "%sd%:\games\hbgShop_forwarder_dark_v3.nsp")
if exist "%sd%:\switch\fakenews-injector" (RD /s /q "%sd%:\switch\fakenews-injector")
if exist "%sd%:\sxos\sx" (RD /s /q "%sd%:\sxos\sx")
if exist "%sd%:\switch\tinfoil" (RD /s /q "%sd%:\switch\tinfoil")


if exist "%sd%:\exosphere.ini" (del "%sd%:\exosphere.ini")

if exist "%sd%:\bootloader\nyx.ini" (
	copy "%sd%:\bootloader\nyx.ini" "%sd%:\bootloader\nyx.bkp"
	)


	echo ------------------------------------------------------------------------
	echo.
	echo                             Installing                   
	echo.
	echo ------------------------------------------------------------------------


rem if exist "%temp%\sdfiles\" (RD /s /q "%temp%\sdfiles\")
rem if not exist "%temp%\sdfiles\" (mkdir %temp%\sdfiles\)
xcopy "%~dp0*" "%sd%:\" /H /Y /C /R /S /E
rem xcopy "%wd%\payload.bin" "%sd%:\" /H /Y /C /R

if exist "%sd%:\hekate_ctcaer_*.bin" (del "%sd%:\hekate_ctcaer_*.bin")

if exist "E:\Switch\addons\themes" (xcopy "E:\Switch\addons\themes\*" "%sd%:\themes" /H /Y /C /R /S /E /I)
if exist "E:\Switch\addons\atmosphere" (xcopy "E:\Switch\addons\atmosphere\*" "%sd%:\atmosphere" /H /Y /C /R /S /E /I)
if exist "E:\Switch\TinGen-main\index.tfl" (xcopy "E:\Switch\TinGen-main\index.tfl" "%sd%:\" /H /Y /C /R /S /E /I)

if exist "%sd%:\bootloader\nyx.bkp" (
	copy "%sd%:\bootloader\nyx.bkp" "%sd%:\bootloader\nyx.ini"
	del "%sd%:\bootloader\nyx.bkp"
	)

	echo ------------------------------------------------------------------------
	echo.
	echo                              Fix atributes                              
	echo.
	echo ------------------------------------------------------------------------
	echo.
)

if exist "%sd%:\atmosphere" (
	attrib -A /S /D %sd%:\atmosphere\*
	attrib -A %sd%:\atmosphere)
if exist "%sd%:\atmosphere\contents" (
	attrib -A /S /D %sd%:\atmosphere\contents\*
	attrib -A %sd%:\atmosphere\contents)
if exist "%sd%:\bootloader" (
	attrib -A /S /D %sd%:\bootloader\*
	attrib -A %sd%:\bootloader)
if exist "%sd%:\config" (
	attrib -A /S /D %sd%:\config\*
	attrib -A %sd%:\config)
if exist "%sd%:\switch" (
	attrib -A /S /D %sd%:\switch\*
	attrib -A %sd%:\switch)
if exist "%sd%:\games" (
	attrib -A /S /D %sd%:\games\*
	attrib -A %sd%:\games)
if exist "%sd%:\themes" (
	attrib -A /S /D %sd%:\themes\*
	attrib -A %sd%:\themes)
if exist "%sd%:\hbmenu.nro" (attrib -A %sd%:\hbmenu.nro)
if exist "%sd%:\boot.dat" (attrib -A %sd%:\boot.dat)
if exist "%sd%:\payload.bin" (attrib -A %sd%:\payload.bin)
if exist "%sd%:\pegascape" (
	attrib -A /S /D %sd%:\pegascape\*
	attrib -A %sd%:\pegascape)

reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbstor\11ECA7E0 /v MaximumTransferLength /t REG_DWORD /d 00100000 /f>nul 2>&1
if exist "%sd%:\TinGen" (RD /s /q "%sd%:\TinGen")

if exist "%sd%:\kefir" (RD /s /q "%sd%:\kefir")
if exist "%sd%:\switch\kefir-updater\startup.te" (del "%sd%:\switch\kefir-updater\startup.te")
if exist "%sd%:\switch\kefir-updater\update.te" (del "%sd%:\switch\kefir-updater\update.te")

if exist "%sd%:\startup.te" (del "%sd%:\startup.te")

if exist "%sd%:\bootloader\hekate_ipl.ini" (del "%sd%:\bootloader\hekate_ipl.ini")
if exist "%sd%:\bootloader\hekate_ipl_.ini" (copy %sd%:\bootloader\hekate_ipl_.ini %sd%:\bootloader\hekate_ipl.ini /Y)>nul 2>&1

if exist "%sd%:\bootloader\hekate_ipl_.ini" (del "%sd%:\bootloader\hekate_ipl_.ini")
if exist "%sd%:\bootloader\ini\*kefir_updater.ini" (del "%sd%:\bootloader\ini\*kefir_updater.ini")
if exist "%sd%:\bootloader\res\ku.bmp" (del "%sd%:\bootloader\res\ku.bmp")
if exist "%sd%:\switch\kefirupdater\kefir-updater.bin" (del "%sd%:\switch\kefirupdater\kefir-updater.bin"
if exist "%sd%:\switch\kefirupdater\startup.te" (del "%sd%:\switch\kefirupdater\startup.te")
if exist "%sd%:\install.bat" (del "%sd%:\install.bat")
if exist "%sd%:\bootloader\nyx.ini_" (del "%sd%:\bootloader\nyx.ini_")
if exist "%sd%:\switch\kefirupdater" (RD /s /q "%sd%:\switch\kefirupdater")

if %syscon%==0 (
	del "%sd%:\atmosphere\contents\690000000000000D\flags\boot2.flag"
	)

if %missioncontrol%==0 (
	del "%sd%:\atmosphere\contents\010000000000bd00\flags\boot2.flag"
	)

cd %sd%:\

if exist .DS_STORE del /s /q /f /a .DS_STORE
if exist ._.* del /s /q /f /a ._.*

goto end

:WRONGSD
cls
COLOR C


	ECHO ----------------------------------------------------------
	ECHO ======            Choosed SD letter is: %sd%:/            =====
	ECHO ======               Выбранный диск: %sd%:/               =====
	ECHO.
	ECHO ======     По адресу %sd%:/ карта памяти не найдена     =====
	ECHO ======       There is no SD card in drive %sd%:/        =====
	ECHO ----------------------------------------------------------
	ECHO.
	ECHO          Убедитесь, что указали правильную букву диска
	ECHO. 
	ECHO            1.  The card letter is correct
	ECHO                Буква диска указана верно
	ECHO.
	ECHO            2.  Choose another card letter
	ECHO                Ввести другую букву диска
	ECHO.
	ECHO ==========================================================
	ECHO                                              Q.  Выход
	ECHO.

set st=
set /p st=:

for %%A in ("Y" "y" "1" "н" "Н") do if "%st%"==%%A (GOTO main)
for %%A in ("N" "n" "2" "т" "Т") do if "%st%"==%%A (GOTO newcard)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

:rembkp
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                         Удаление папки _backup                          
	echo                                Ожидайте!                                
	echo.
	echo ------------------------------------------------------------------------
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                         Removing _backup folder                         
	echo                              Please wait!                               
	echo.
	echo ------------------------------------------------------------------------
)

RD /s /q "%sd%:\_backup"
goto main

:END
if %lang%==1 (
	echo. 
	echo Нажмите любую клавишу для выхода
) else (
	echo. 
	echo Press any button for exit
)

RD /s /q "%wd%
pause>nul 2>&1
exit

	echo                          Удаление папки _backup                         
	echo                                Ожидайте!                                
	echo.
	echo ------------------------------------------------------------------------
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                         Removing _backup folder                         
	echo                              Please wait!                               
	echo.
	echo ------------------------------------------------------------------------
)

RD /s /q "%sd%:\_backup"
goto main

:END
	echo. 
	cls
	COLOR 2
	echo ------------------------------------------------------------------------
	echo                            All Done
	echo ------------------------------------------------------------------------
	echo. 
	echo. 
	echo Press any button for exit


rem RD /s /q "%wd%
pause>nul 2>&1
exit