@echo off
chcp 1251 >nul 2>&1

COLOR 0F

set working_dsk=F:
set working_dir=%working_dsk%\git\dev
set reldir=%working_dir%\_kefir\release
set testdir=%working_dir%\_kefir\test
set gdisk=P:\Мій диск\kefir
set gdisk_rel=%gdisk%\release
set gdisk_test=%gdisk%\test
set kefir_dir=%working_dir%\_kefir\kefir
set hekate_dir=%working_dir%\_kefir\kefir\bootloader\sys
set hekate_build=%working_dir%\hekate\output
set hbl_build=%working_dir%\nx-hbmenu\hbmenu.nro
set build_dir=%working_dir%\_kefir\build
set googledrive_dir=%reldir%
set sd=%build_dir%
set img=%working_dir%\_kefir\bootlogo
set site=%working_dsk%\git\site\switch
set suffix=""
set dbi=%working_dsk%\Switch\dbibackend
set /p ver=<version
if exist "%build_dir%" (RD /s /q "%build_dir%")
set site_inc=%site%\_includes\inc\kefir
set site_files=%site%\files
set site_img=%site%\images

set atmo_build="%working_dir%\atmosphere-out.zip"
set kefirupdater="%working_dir%\kefir-updater\Kefir-updater.nro"

if exist "%reldir%" (RD /s /q "%reldir%")
MKLINK /D "%reldir%" "%gdisk_rel%"

if exist "%testdir%" (RD /s /q "%testdir%")
MKLINK /D "%testdir%" "%gdisk_test%"

cls

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

"E:\Switch\7zip\7za.exe" x %atmo_build% -o%kefir_dir% -y

:noatmo

if exist "%hbl_build%" xcopy "%hbl_build%" "%kefir_dir%\" /H /Y /C /R

xcopy "%dbi%\DBI.nro" "%kefir_dir%\switch\DBI\DBI.nro" /H /Y /C /R

xcopy "%kefir_dir%\hekate_ctcaer_*.bin" "%kefir_dir%\payload.bin" /H /Y /C /R
del "%kefir_dir%\hekate_ctcaer_*.bin"

xcopy "%kefir_dir%\payload.bin" "%kefir_dir%\atmosphere\reboot_payload.bin" /H /Y /C /R
xcopy "%kefir_dir%\payload.bin" "%kefir_dir%\bootloader\update.bin" /H /Y /C /R
xcopy "%img%\kiosk.png" "%site_img%\kefir.png" /H /Y /C /R
xcopy "%img%\kiosk.png" "%working_dir%\_kefir\kefir.png" /H /Y /C /R
xcopy "%img%\bootlogo.bmp" "%kefir_dir%\bootloader\bootlogo_kefir.bmp" /H /Y /C /R

xcopy "E:\Switch\Games\Tinfoil*.nsp" "%kefir_dir%\games\Tinfoil [050000BADDAD0000].nsp" /H /Y /C /R
xcopy "%working_dir%\_kefir\version" "%kefir_dir%\switch\kefir-updater\" /H /Y /C /R

cls

ECHO.
ECHO.
ECHO ==============================================================
ECHO.
ECHO.
ECHO         1.  release
ECHO         2.  pre
ECHO         3.  temp
ECHO.
ECHO.
ECHO ==============================================================
ECHO                                             Q.  Quit
ECHO.

set st=
set /p st=:

for %%A in ("2") do if "%st%"==%%A (set suffix="_pre")
for %%A in ("3") do if "%st%"==%%A (set suffix="_test")
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

if not %suffix%=="" (GOTO start)

xcopy "%working_dir%\_kefir\version" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\_kefir\version" "%site_files%\" /H /Y /C /R
xcopy "%working_dir%\_kefir\changelog" "%site_inc%\" /H /Y /C /R
xcopy "%working_dir%\_kefir\changelog" "%site_files%\" /H /Y /C /R

:start

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

    
if not %suffix%=="" (set reldir=%testdir%)

if exist "%reldir%" (del /F /S /Q "%reldir%\*")
xcopy "%working_dir%\_kefir\changelog*" "%reldir%\" /H /Y /C /R
xcopy "%working_dir%\_kefir\version" "%reldir%\" /H /Y /C /R

rem kefir
"E:\Switch\7zip\7za.exe" a -tzip -mx9 -r0 -ssw -xr!.gitignore -xr!kefir_installer -xr!desktop.ini -xr!___build.bat -xr!hekate_ctcaer_*.bin -xr!kefir.png -xr!___build_test.bat -xr!install1.bat -xr!release -xr!release_test -xr!.git -xr!build -xr!emu.cmd -x!version -xr!changelog* -xr!README.md -xr!install1.bat %reldir%\kefir%ver%%suffix%.zip %kefir_dir%\*

echo ------------------------------------------------------------------------
echo.
echo                                    DONE
echo.
echo ------------------------------------------------------------------------
echo.

if %suffix%=="_test" (GOTO END)
if %suffix%=="" (set ps=%working_dsk%\git\scripts\build_kefir.ps1)

if exist "%build_dir%" (RD /s /q "%build_dir%")

git add .
git commit -m "kefir%ver%%suffix%"
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