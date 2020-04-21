@echo off
chcp 866 >nul 2>&1

COLOR 0F

set reldir=E:\Switch\_kefir\release
set wd=E:\Switch\_kefir
set bd=%wd%\build
set sd=%bd%\atmo
set img=F:\VK\kefir
set site=F:\git\site\switch
set ps=D:\SYS_FOLDERS\Desktop\SWITCH_BUILD.ps1
if exist "%bd%" (RD /s /q "%bd%")
if exist "%reldir%\atmo.zip" (del "%reldir%\atmo.zip")
if exist "%reldir%\atmo_vanilla.zip" (del "%reldir%\atmo_vanilla.zip")
if exist "%reldir%\sxos.zip" (del "%reldir%\sxos.zip")
if exist "%reldir%\_kefir.7z" (del "%reldir%\_kefir.7z")
set site_inc=%site%\_includes\inc\kefir
set site_files=%site%\files
set site_img=%site%\images

xcopy "%wd%\version" "%site_inc%\" /H /Y /C /R
xcopy "%wd%\version" "%site_files%\" /H /Y /C /R
xcopy "%wd%\version" "%reldir%\" /H /Y /C /R
xcopy "%wd%\version" "%wd%\base\switch\kefirupdater\" /H /Y /C /R
rem xcopy "%wd%\version" "%wd%\base\switch\kefirupdater" /H /Y /C /R
xcopy "%wd%\changelog" "%site_inc%\" /H /Y /C /R
xcopy "%wd%\changelog" "%site_files%\" /H /Y /C /R
xcopy "%wd%\changelog" "%reldir%\" /H /Y /C /R

xcopy "%wd%\payload.bin" "%wd%\atmo\atmosphere\reboot_payload.bin" /H /Y /C /R
xcopy "%wd%\payload.bin" "%wd%\base\bootloader\update.bin" /H /Y /C /R
rem xcopy "F:\git\dev\kefirupdater\kefirupdater.nro" "%wd%\base\switch\kefirupdater\kefirupdater.nro" /H /Y /C /R
rem xcopy "F:\git\dev\Atmosphere\stratosphere\ams_mitm\ams_mitm.kip" "%wd%\atmo\atmosphere\kips\ams_mitm.kip" /H /Y /C /R
rem xcopy "%wd%\base\switch\tinfoil\locations.conf" "%wd%\sxos\switch\sx\locations.conf" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%site_img%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%wd%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo.bmp" "%wd%\base\bootloader\bootlogo.bmp" /H /Y /C /R

pause

echo ------------------------------------------------------------------------
echo.
echo                                   ATMO
echo.
echo ------------------------------------------------------------------------
echo.

set sd=%bd%\atmo

mkdir %bd%
mkdir %sd%

xcopy "%wd%\base\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\payload.bin" "%sd%\" /H /Y /C /R

:cfw_ATMOS
xcopy "%wd%\atmo\*" "%sd%\" /H /Y /C /R /S /E

rem if exist "%sd%\boot.dat" (del "%sd%\boot.dat")
copy "%sd%\sept\payload_neutos.bin" "%sd%\sept\payload.bin"
copy "%sd%\bootloader\hekate_ipl_neutos.ini" "%sd%\bootloader\hekate_ipl.ini"
del "%sd%\sept\payload_*.bin"

if exist "%sd%\bootloader\payloads\sxos.bin" (del "%sd%\bootloader\payloads\sxos.bin")
if exist "%sd%\bootloader\payloads\rajnx_ipl.bin" (del "%sd%\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%\switch\sx.nro" (del "%sd%\switch\sx.nro")
if exist "%sd%\bootloader\ini\sxos.ini" (del "%sd%\bootloader\ini\sxos.ini")
del "%sd%\bootloader\hekate_ipl_*.ini"
if exist "%sd%\sxos\titles" (xcopy %sd%\sxos\titles\* %sd%\atmosphere\titles\  /Y /S /E /H /R /D)
if exist "%sd%\sxos\games" (move /Y %sd%\sxos\games\* %sd%\games)
if exist "%sd%\sxos" (RD /s /q "%sd%\sxos")
if exist "%sd%\switch\sx" (RD /s /q "%sd%\switch\sx")
if exist "%sd%\switch\themes" (RD /s /q "%sd%\switch\themes")
if exist "%sd%\titles" (xcopy "%wd%\titles\*" "%sd%\atmosphere\titles" /H /Y /C /R /S /E)
if exist "%sd%\titles" (RD /s /q "%sd%\titles")

if exist "%sd%\switch\fakenews-injector" (RD /s /q "%sd%\switch\fakenews-injector")
if exist "%sd%\pegascape" (RD /s /q "%sd%\pegascape")

echo ------------------------------------------------------------------------
echo.
echo                               ATMO VANILLA
echo.
echo ------------------------------------------------------------------------
echo.

set sd=%bd%\atmo_vanilla

mkdir %sd%

xcopy "%wd%\base\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\payload.bin" "%sd%\" /H /Y /C /R

:cfw_ATMOS
xcopy "%wd%\atmo\*" "%sd%\" /H /Y /C /R /S /E

if exist "%sd%\boot.dat" (del "%sd%\boot.dat")
copy "%sd%\sept\payload_atmo.bin" "%sd%\sept\payload.bin"
copy "%sd%\bootloader\hekate_ipl_atmo.ini" "%sd%\bootloader\hekate_ipl.ini"
del "%sd%\sept\payload_*.bin"
RD /s /q "%sd%\switch\tinfoil"

if exist "%sd%\bootloader\payloads\sxos.bin" (del "%sd%\bootloader\payloads\sxos.bin")
if exist "%sd%\bootloader\payloads\rajnx_ipl.bin" (del "%sd%\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%\switch\sx.nro" (del "%sd%\switch\sx.nro")
if exist "%sd%\bootloader\ini\sxos.ini" (del "%sd%\bootloader\ini\sxos.ini")
del "%sd%\bootloader\hekate_ipl_*.ini"
if exist "%sd%\sxos\titles" (xcopy %sd%\sxos\titles\* %sd%\atmosphere\titles\  /Y /S /E /H /R /D)
if exist "%sd%\sxos\games" (move /Y %sd%\sxos\games\* %sd%\games)
if exist "%sd%\sxos" (RD /s /q "%sd%\sxos")
if exist "%sd%\switch\sx" (RD /s /q "%sd%\switch\sx")
if exist "%sd%\switch\themes" (RD /s /q "%sd%\switch\themes")
if exist "%sd%\titles" (xcopy "%wd%\titles\*" "%sd%\atmosphere\titles" /H /Y /C /R /S /E)
if exist "%sd%\titles" (RD /s /q "%sd%\titles")

if exist "%sd%\switch\fakenews-injector" (RD /s /q "%sd%\switch\fakenews-injector")
if exist "%sd%\pegascape" (RD /s /q "%sd%\pegascape")

  
echo ------------------------------------------------------------------------
echo.
echo                                   SXOS
echo.
echo ------------------------------------------------------------------------
echo.


set sd=%bd%\sxos

mkdir %sd%

xcopy "%wd%\base\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\payload.bin" "%sd%\" /H /Y /C /R

:cfw_SXOS



xcopy "%wd%\atmo\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\sxos\*" "%sd%\" /H /Y /C /R /S /E
if exist "%sd%\bootloader\payloads\rajnx_ipl.bin" (del "%sd%\bootloader\payloads\rajnx_ipl.bin")

copy "%sd%\sept\payload_atmo.bin" "%sd%\sept\payload.bin"
if exist "%sd%\bootloader\hekate_ipl_sx.ini" (copy "%sd%\bootloader\hekate_ipl_sx.ini" "%sd%\bootloader\hekate_ipl.ini")
del "%sd%\sept\payload_*.bin"
del "%sd%\bootloader\hekate_ipl_*.ini"

if exist "%sd%\atmosphere\exefs_patches" (RD /s /q "%sd%\atmosphere\exefs_patches")
if exist "%sd%\atmosphere\kip_patches\fs_patches" (RD /s /q "%sd%\atmosphere\kip_patches\fs_patches")

if exist "%sd%\switch\fakenews-injector" (RD /s /q "%sd%\switch\fakenews-injector")
if exist "%sd%\pegascape" (RD /s /q "%sd%\pegascape")

del "%bd%\atmo\atmosphere\kips\ams_mitm.kip"
del "%bd%\sxos\atmosphere\kips\ams_mitm.kip"

if exist "%sd%\atmosphere" (
	attrib -A /S /D %sd%\atmosphere\*
	attrib -A %sd%\atmosphere)
if exist "%sd%\atmosphere\titles" (
	attrib -A /S /D %sd%\atmosphere\titles*
	attrib -A %sd%\atmosphere\titles)
if exist "%sd%\sept" (
	attrib -A /S /D %sd%\sept\*
	attrib -A %sd%\sept)
if exist "%sd%\bootloader" (
	attrib -A /S /D %sd%\bootloader\*
	attrib -A %sd%\bootloader)
if exist "%sd%\config" (
	attrib -A /S /D %sd%\config\*
	attrib -A %sd%\config)
if exist "%sd%\switch" (
	attrib -A /S /D %sd%\switch\*
	attrib -A %sd%\switch)
if exist "%sd%\tinfoil" (
	attrib -A /S /D %sd%\tinfoil\*
	attrib -A %sd%\tinfoil)
if exist "%sd%\games" (
	attrib -A /S /D %sd%\games\*
	attrib -A %sd%\games)
if exist "%sd%\themes" (
	attrib -A /S /D %sd%\themes\*
	attrib -A %sd%\themes)
if exist "%sd%\emuiibo" (
	attrib -A /S /D %sd%\emuiibo\*
	attrib -A %sd%\emuiibo)
if exist "%sd%\_backup" (
	attrib -A /S /D %sd%\_backup\*
	attrib -A %sd%\_backup)
if exist "%sd%\hbmenu.nro" (attrib -A %sd%\hbmenu.nro)
if exist "%sd%\keys.dat" (attrib -A %sd%\keys.dat)
if exist "%sd%\boot.dat" (attrib -A %sd%\boot.dat)
if exist "%sd%\payload.bin" (attrib -A %sd%\payload.bin)
if exist "%sd%\sxos" (
	attrib -A /S /D %sd%\sxos\*
	attrib -A %sd%\sxos)
if exist "%sd%\sxos" (
	attrib -A /S /D %sd%\pegascape\*
	attrib -A %sd%\pegascape)
if exist "%sd%\switch\fakenews-injector" (
	attrib -A /S /D %sd%\switch\fakenews-injector\*
	attrib -A %sd%\switch\fakenews-injector)    
if exist "%bd%" (
	attrib -A /S /D %bd%\*
	attrib -A %bd%)
if exist "%sd%:\switch\mercury" (
	attrib +A %sd%:\switch\mercury)

    
rem kefir
"C:\Program Files\7-Zip\7z.exe" a -mx9 -r0 -ssw -xr!.gitignore -xr!___build.bat -xr!release -xr!.git -xr!build -xr!emu.cmd -xr!version -xr!changelog %reldir%\_kefir.7z %wd%\*

rem atmo
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw -xr!690000000000000D -xr!010000000007E51A -xr!0100000000000352 -xr!420000000007E51A -xr!sys-con -xr!.overlays %reldir%\atmo.zip %bd%\atmo\* 

rem atmo_vanilla
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw -xr!690000000000000D -xr!NEUTOS.bin -xr!010000000007E51A -xr!0100000000000352 -xr!420000000007E51A -xr!tinfoil -xr!sys-con -xr!.overlays %reldir%\atmo_vanilla.zip %bd%\atmo_vanilla\* 

rem sxos
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw  -xr!690000000000000D -xr!010000000007E51A -xr!0100000000000352 -xr!420000000007E51A -xr!sys-con -xr!.overlays %reldir%\sxos.zip %bd%\sxos\*

REM pause

echo ------------------------------------------------------------------------
echo.
echo                                    DONE
echo.
echo ------------------------------------------------------------------------
echo.

if exist "%bd%" (RD /s /q "%bd%")

git add .
git commit -m "%date:~3,8%"
git push

REM chdir /d %site%

REM git add .
REM git commit -m "%date:~3,8%"
REM git push

powershell -file %ps% kefir

:END
if %lang%==1 (
	echo. 
	echo Нажмите любую клавишу для выхода
) else (
	echo. 
	echo Press any button for exit
)

exit