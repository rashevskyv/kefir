@echo off
chcp 866 >nul 2>&1

COLOR 0F

set reldir=E:\Switch\_kefir\release
set kefir_dir=E:\Switch\_kefir\kefir
set hekate_dir=E:\Switch\_kefir\kefir\bootloader\sys
set hekate_build=F:\git\dev\hekate\output
set hbl_build=F:\git\dev\nx-hbmenu\hbmenu.nro
set working_dir=E:\Switch\_kefir
set build_dir=%working_dir%\build
set googledrive_dir=S:\Мой диск\Shared\release
set sd=%build_dir%
set img=F:\VK\kefir
set site=F:\git\site\switch
set ps=F:\git\scripts\build_kefir.ps1
set dbi=E:\Switch\dbibackend
set /p ver=<version
if exist "%build_dir%" (RD /s /q "%build_dir%")
set site_inc=%site%\_includes\inc\kefir
set site_files=%site%\files
set site_img=%site%\images

set atmo_build="F:\git\dev\atmosphere-out.zip"
set kefirupdater="F:\git\dev\Kefir-updater\Kefir-updater.nro"


ECHO.
ECHO.
ECHO ==============================================================
ECHO.
ECHO.
ECHO         1.  Update atmo
ECHO         2.  Skip
ECHO.
ECHO.
ECHO ==============================================================
ECHO                                             Q.  Quit
ECHO.

set st=
set /p st=:

for %%A in ("2") do if "%st%"==%%A (goto noatmo)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

"C:\Program Files\7-Zip\7z.exe" x %atmo_build% -o%kefir_dir% -y


:noatmo

if exist "%hbl_build%" xcopy "%hbl_build%" "%kefir_dir%\" /H /Y /C /R

xcopy "%working_dir%\version" "%site_inc%\" /H /Y /C /R

xcopy "%working_dir%\version" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\version" "%site_files%\" /H /Y /C /R
xcopy "%working_dir%\version" "%kefir_dir%\switch\kefir-updater\" /H /Y /C /R
xcopy "%working_dir%\changelog" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\changelog" "%site_files%\" /H /Y /C /R

xcopy "%dbi%\DBI.nro" "%kefir_dir%\switch\DBI\DBI.nro" /H /Y /C /R

xcopy "%kefir_dir%\hekate_ctcaer_*.bin" "%kefir_dir%\payload.bin" /H /Y /C /R
del "%kefir_dir%\hekate_ctcaer_*.bin"

xcopy "%kefir_dir%\payload.bin" "%kefir_dir%\atmosphere\reboot_payload.bin" /H /Y /C /R
xcopy "%kefir_dir%\payload.bin" "%kefir_dir%\bootloader\update.bin" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%site_img%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo (1).png" "%working_dir%\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo.bmp" "%kefir_dir%\bootloader\bootlogo_kefir.bmp" /H /Y /C /R



rem ECHO.
rem ECHO.
rem ECHO ==============================================================
rem ECHO.
rem ECHO.
rem ECHO         1.  Increase version
rem ECHO         2.  Skip
rem ECHO.
rem ECHO.
rem ECHO ==============================================================
rem ECHO                                             Q.  Quit
rem ECHO.

rem set st=
rem set /p st=:

rem for %%A in ("2") do if "%st%"==%%A (goto start)
rem for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

rem set /p ver=<version
rem set /a ver = %ver% + 1
rem echo %ver% > version

xcopy "%working_dir%\version" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\version" "%site_files%\" /H /Y /C /R
xcopy "%working_dir%\version" "%kefir_dir%\switch\kefir-updater\" /H /Y /C /R
xcopy "%working_dir%\changelog" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\changelog" "%site_files%\" /H /Y /C /R


:start
if exist "%reldir%" (del /F /S /Q "%reldir%\*")
xcopy "%working_dir%\changelog" "%reldir%\" /H /Y /C /R
xcopy "%working_dir%\version" "%reldir%\" /H /Y /C /R

pause


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

if exist "%sd%\bootloader\hekate_ipl_*.ini" (del "%sd%\bootloader\hekate_ipl_*.ini")
if exist "%sd%\sxos\titles" (xcopy %sd%\sxos\titles\* %sd%\atmosphere\titles\  /Y /S /E /H /R /D)

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
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw -xr!.gitignore -xr!kefir_installer -xr!desktop.ini -xr!___build.bat -xr!hekate_ctcaer_*.bin -xr!kefir.png -xr!___build_test.bat -xr!install1.bat -xr!release -xr!release_test -xr!.git -xr!build -xr!emu.cmd -x!version -xr!changelog -xr!README.md -xr!install1.bat  %reldir%\kefir.zip %kefir_dir%\*

echo ------------------------------------------------------------------------
echo.
echo                                    DONE
echo.
echo ------------------------------------------------------------------------
echo.

if exist "%build_dir%" (RD /s /q "%build_dir%")

git add .
git commit -m "kefir%ver%"
git push

REM chdir /d %site%

REM git add .
REM git commit -m "%date:~3,8%"
REM git push

rem pause

powershell -file %ps%

:END

echo Press any button for exit

exit