@echo off
chcp 866 >nul 2>&1

COLOR 0F

set reldir=E:\Switch\_kefir\release_test
set kefir_dir=E:\Switch\_kefir\kefir
set working_dir=E:\Switch\_kefir
set build_dir=%working_dir%\build
set gd=S:\Мой диск\Shared\release_test
set sd=%build_dir%\atmo
set img=F:\VK\kefir
set site=F:\git\site\switch
set ps=F:\git\scripts\build_kefir.ps1
set /p ver=<version
if exist "%build_dir%" (RD /s /q "%build_dir%")
set site_inc=%site%\_includes\inc\kefir
set site_files=%site%\files
set site_img=%site%\images

set atmo_build="F:\git\dev\atmosphere-out.zip"
set kefirupdater="F:\git\dev\Kefir-updater\Kefir-updater.nro"
set hekate="F:\git\dev\hekate\output"

"C:\Program Files\7-Zip\7z.exe" x %atmo_build% -o%kefir_dir% -y

if exist "%reldir%" (del /F /S /Q "%reldir%\*")
xcopy "%working_dir%\changelog" "%reldir%\" /H /Y /C /R
xcopy "%working_dir%\version" "%reldir%\" /H /Y /C /R

xcopy "%working_dir%\version" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\version" "%site_files%\" /H /Y /C /R
xcopy "%kefirupdater%" "%kefir_dir%\switch\kefirupdater\" /H /Y /C /R
xcopy "%working_dir%\version" "%kefir_dir%\switch\kefirupdater\" /H /Y /C /R
xcopy "%working_dir%\changelog" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\changelog" "%site_files%\" /H /Y /C /R

xcopy "%hekate%\hekate.bin" "%kefir_dir%\payload.bin" /H /Y /C /R
xcopy "%hekate%\libsys_lp0.bso" "%kefir_dir%\bootloader\sys\libsys_lp0.bso" /H /Y /C /R
xcopy "%hekate%\libsys_minerva.bso" "%kefir_dir%\bootloader\sys\libsys_minerva.bso" /H /Y /C /R
xcopy "%hekate%\module_sample.bso" "%kefir_dir%\bootloader\sys\module_sample.bso" /H /Y /C /R
xcopy "%hekate%\nyx.bin" "%kefir_dir%\bootloader\sys\nyx.bin" /H /Y /C /R

xcopy "%kefir_dir%\payload.bin" "%kefir_dir%\atmosphere\reboot_payload.bin" /H /Y /C /R
xcopy "%kefir_dir%\payload.bin" "%kefir_dir%\bootloader\update.bin" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%site_img%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%working_dir%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo.bmp" "%kefir_dir%\bootloader\bootlogo_kefir.bmp" /H /Y /C /R



echo ------------------------------------------------------------------------
echo.
echo                                   ATMO
echo.
echo ------------------------------------------------------------------------
echo.

mkdir %build_dir%
mkdir %sd%

xcopy "%kefir_dir%\*" "%sd%\" /H /Y /C /R /S /E
xcopy "%kefir_dir%\payload.bin" "%sd%\" /H /Y /C /R

del "%sd%\sept\payload_*.bin"

if exist "%sd%\bootloader\hekate_ipl_*.ini" (del "%sd%\bootloader\hekate_ipl_*.ini")

if exist "%sd%\switch\themes" (RD /s /q "%sd%\switch\themes")
if exist "%sd%\switch\Lockpick" (RD /s /q "%sd%\switch\Lockpick")
if exist "%sd%\switch\Incognito" (RD /s /q "%sd%\switch\Incognito")
if exist "%sd%\switch\ChoiDujourNX" (RD /s /q "%sd%\switch\ChoiDujourNX")

if exist "%sd%\switch\fakenews-injector" (RD /s /q "%sd%\switch\fakenews-injector")
if exist "%sd%\pegascape" (RD /s /q "%sd%\pegascape")

echo ------------------------------------------------------------------------
echo.
echo                                   Fix Atributes
echo.
echo ------------------------------------------------------------------------
echo.

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
if exist "%build_dir%" (
	attrib -A /S /D %build_dir%\*
	attrib -A %build_dir%)
if exist "%sd%\switch\mercury" (
	attrib +A %sd%\switch\mercury)

    
rem kefir
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw -xr!.gitignore -xr!kefir_installer -xr!desktop.ini -xr!___build.bat -xr!___build_beta.bat -xr!install1.bat -xr!release -xr!release_test -xr!.git -xr!build -xr!emu.cmd -x!version -xr!changelog -xr!install1.bat %reldir%\kefir.zip %kefir_dir%\*