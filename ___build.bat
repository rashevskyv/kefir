@echo off
chcp 866 >nul 2>&1

COLOR 0F

set reldir=E:\Switch\_kefir\release
set wd=E:\Switch\_kefir
set bd=%wd%\build
set gd=S:\Мой диск\Shared\release
set sd=%bd%\atmo
set img=F:\VK\kefir
set site=F:\git\site\switch
set ps=F:\git\scripts\build_kefir.ps1
set /p ver=<version
if exist "%bd%" (RD /s /q "%bd%")
set site_inc=%site%\_includes\inc\kefir
set site_files=%site%\files
set site_img=%site%\images

set atmo_build="F:\git\dev\atmosphere-out.zip"

"C:\Program Files\7-Zip\7z.exe" x %atmo_build% -o%wd% -y

xcopy "%wd%\version" "%site_inc%\" /H /Y /C /R
xcopy "%wd%\version" "%site_files%\" /H /Y /C /R
xcopy "%wd%\version" "%wd%\base\switch\kefirupdater\" /H /Y /C /R
xcopy "%wd%\changelog" "%site_inc%\" /H /Y /C /R
xcopy "%wd%\changelog" "%site_files%\" /H /Y /C /R

xcopy "%wd%\payload.bin" "%wd%\atmo\atmosphere\reboot_payload.bin" /H /Y /C /R
xcopy "%wd%\payload.bin" "%wd%\base\bootloader\update.bin" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%site_img%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%wd%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo.bmp" "%wd%\base\bootloader\bootlogo_kefir.bmp" /H /Y /C /R

pause

if exist "%reldir%" (del /F /S /Q "%reldir%\*")
xcopy "%wd%\changelog" "%reldir%\" /H /Y /C /R
xcopy "%wd%\version" "%reldir%\" /H /Y /C /R


echo ------------------------------------------------------------------------
echo.
echo                                   ATMO
echo.
echo ------------------------------------------------------------------------
echo.

mkdir %bd%
mkdir %sd%

xcopy "%wd%\base\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\payload.bin" "%sd%\" /H /Y /C /R

xcopy "%wd%\atmo\*" "%sd%\" /H /Y /C /R /S /E

if exist "%sd%\boot.dat" (del "%sd%\boot.dat")
copy "%sd%\bootloader\hekate_ipl_atmo.ini" "%sd%\bootloader\hekate_ipl.ini"
del "%sd%\sept\payload_*.bin"

if exist "%sd%\bootloader\payloads\sxos.bin" (del "%sd%\bootloader\payloads\sxos.bin")
if exist "%sd%\switch\sx.nro" (del "%sd%\switch\sx.nro")
if exist "%sd%\bootloader\ini\sxos.ini" (del "%sd%\bootloader\ini\sxos.ini")
del "%sd%\bootloader\hekate_ipl_*.ini"
if exist "%sd%\sxos\titles" (xcopy %sd%\sxos\titles\* %sd%\atmosphere\titles\  /Y /S /E /H /R /D)
if exist "%sd%\sxos\games" (move /Y %sd%\sxos\games\* %sd%\games)
if exist "%sd%\sxos" (RD /s /q "%sd%\sxos")
if exist "%sd%\switch\sx" (RD /s /q "%sd%\switch\sx")
if exist "%sd%\switch\themes" (RD /s /q "%sd%\switch\themes")
if exist "%sd%\switch\Lockpick" (RD /s /q "%sd%\switch\Lockpick")
if exist "%sd%\switch\Incognito" (RD /s /q "%sd%\switch\Incognito")
if exist "%sd%\switch\ChoiDujourNX" (RD /s /q "%sd%\switch\ChoiDujourNX")

if exist "%sd%\switch\fakenews-injector" (RD /s /q "%sd%\switch\fakenews-injector")
if exist "%sd%\pegascape" (RD /s /q "%sd%\pegascape")

echo ------------------------------------------------------------------------
echo.
echo                                   SX Chip
echo.
echo ------------------------------------------------------------------------
echo.

set sd=%bd%\chip

mkdir %sd%

xcopy "%wd%\base\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\payload.bin" "%sd%\" /H /Y /C /R

xcopy "%wd%\atmo\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%wd%\sxos\*" "%sd%\" /H /Y /C /R /S /E

if exist "%sd%\switch\Lockpick" (RD /s /q "%sd%\switch\Lockpick")
if exist "%sd%\exosphere.ini" (del "%sd%\exosphere.ini")

if exist "%sd%\bootloader\hekate_ipl_both_stock.ini" (copy "%sd%\bootloader\hekate_ipl_both_stock.ini" "%sd%\bootloader\hekate_ipl.ini")

del "%sd%\bootloader\hekate_ipl_*.ini"

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
if exist "%sd%\switch\mercury" (
	attrib +A %sd%\switch\mercury)

    
rem kefir
"C:\Program Files\7-Zip\7z.exe" a -mx9 -r0 -ssw -xr!.gitignore -xr!kefir_installer -xr!___build.bat -xr!kefir.png -xr!___build_test.bat -xr!install1.bat -xr!release -xr!release_test -xr!.git -xr!build -xr!emu.cmd -x!version -xr!changelog -xr!install1.bat  %reldir%\_kefir.7z %wd%\*

rem atmo
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -xr!kefir_installer -xr!kefir.png -ssw %reldir%\atmo.zip %bd%\atmo\*

rem sxchip
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw -xr!kefir_installer -xr!kefir.png -xr!exosphere.ini %reldir%\modchip.zip %bd%\chip\*


pause

echo ------------------------------------------------------------------------
echo.
echo                                    DONE
echo.
echo ------------------------------------------------------------------------
echo.

if exist "%bd%" (RD /s /q "%bd%")

git add .
git commit -m "kefir%ver%"
git push

REM chdir /d %site%

REM git add .
REM git commit -m "%date:~3,8%"
REM git push

pause

powershell -file %ps%

:END

echo Press any button for exit

exit