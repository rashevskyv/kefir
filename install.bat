@echo off
chcp 866 >nul 2>&1

COLOR 0F

set wd=%temp%\sdfiles
set clear=0
set cfw=ATMOS
set cfwname=Atmosphere
set lang=0
set bootscrn=1
set theme=0
set caffeine=0
set syscon=0
set syscon_flag=2

:disclaimer
cls
ECHO =======================================================================================================================
ECHO                                                 ПРОЧТИТЕ ВНИМАТЕЛЬНО!
ECHO                                                    READ CAREFULLY!
ECHO =======================================================================================================================
ECHO.
ECHO    На новых версиях Atmosphere для входа в Homebrew Menu нужно запускать любую игру, удерживая кнопку R на джойконе
ECHO    !!! При возникновении ошибок, выберите чистую установку в опциях кефира
ECHO    !!! Если вы собираетесь использовать Caffeine - отметьте это в опциях
ECHO    !!! Если вы устанавливаете kefir для обновления прошивки, выберите в опциях удаление темы
ECHO    Нажмите О на следующем экране, чтобы попасть в опции кефира
ECHO.
ECHO    Нажмите J, затем Enter, если вы ознакомились с написанным и готовы продолжить
ECHO.       
ECHO -----------------------------------------------------------------------------------------------------------------------
ECHO.
ECHO    For enter Homebrew Menu on new Atmosphere version hold R button while start any game
ECHO    Choose clean install on options if any errors on launch CFW
ECHO    Choose Caffeine in an options if you use it
ECHO.
ECHO    Press J and Enter if you has read this information and ready to proceed to installation
ECHO.
ECHO =======================================================================================================================
ECHO.
ECHO.
ECHO.
ECHO.

set st=
set /p st=

for %%A in ("J" "j" "О" "о") do if "%st%"==%%A (GOTO START)
for %%A in ("J" "j" "О" "о") do if "%st%" neq %%A (GOTO disclaimer)

cls

:START
:choose_cfw
cls
ECHO ------------------------------------------------------------------
ECHO            ======          Select CFW           =====
ECHO ------------------------------------------------------------------
ECHO.
ECHO    Choose SXOS only if you bought it or will buy
ECHO.
ECHO    Выбирете SXOS только, если вы купили её или собираетесь
ECHO.
ECHO           1. Atmosphere
ECHO           2. SXOS
ECHO           3. Atmo + SX
ECHO.
ECHO ==================================================================
ECHO                                                       O.  Options
ECHO                                                       Q.  Quit

set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (
	set cfw=ATMOS
	set cfwname=Atmosphere
)
for %%A in ("2") do if "%st%"==%%A (
	set cfw=SXOS
	set cfwname=SX OS     
)
for %%A in ("3") do if "%st%"==%%A (
	set cfw=BOTH
	set cfwname=both OSes 
)
for %%A in ("O" "o" "Щ" "щ" "J" "j" "о" "О" "0") do if "%st%"==%%A (GOTO OPTIONS)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)
goto newcard

:OPTIONS
COLOR 0E

cls
ECHO ------------------------------------------------------------------
ECHO               ======          Options           =====
ECHO ------------------------------------------------------------------
ECHO ------------------------------------------------------------------
ECHO           ======         Select Language          =====
ECHO           ======          Выберите язык           =====
ECHO ------------------------------------------------------------------
ECHO.
ECHO         1.  Русский
ECHO         2.  English
ECHO.
ECHO ==================================================================
ECHO                                                         Q.  Quit

set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (set lang=1)
for %%A in ("2") do if "%st%"==%%A (set lang=2)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

cls
if %lang%==1 (
	ECHO --------------------------------------------------------------------
	ECHO                ======          Options           =====
	ECHO --------------------------------------------------------------------
	ECHO --------------------------------------------------------------------
	ECHO            ======          Выберите CFW           =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO    Выбирете SXOS только, если вы купили её или собираетесь
	ECHO.
	ECHO           1. Atmosphere
	ECHO           2. SXOS
	ECHO           3. Atmo + SX
	ECHO.
	ECHO ====================================================================
	ECHO                                                         Q.  Quit
) else (
	ECHO --------------------------------------------------------------------
	ECHO              ======          Options           =====
	ECHO --------------------------------------------------------------------
	ECHO --------------------------------------------------------------------
	ECHO             ======          Select CFW           =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO    Choose SXOS only if you bought it or will buy
	ECHO.
	ECHO           1. Atmosphere
	ECHO           2. SXOS
	ECHO           3. Atmo + SX
	ECHO.
	ECHO ====================================================================
	ECHO                                                         Q.  Quit
)


set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (
	set cfw=ATMOS
	set cfwnum=1
	set cfwname=Atmosphere
)
for %%A in ("2") do if "%st%"==%%A (
	set cfw=SXOS
	set cfwnum=2
	set cfwname=SX OS     
)
for %%A in ("3") do if "%st%"==%%A (
	set cfw=BOTH
	set cfwnum=3
	set cfwname=both OSes 
)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)


:caffeine
cls
ECHO --------------------------------------------------------------------
ECHO               ======          Options           =====
ECHO --------------------------------------------------------------------
if %lang%==1 (
	ECHO --------------------------------------------------------------------
	ECHO               ======     Выберите эксплойт     =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Fusee-Gelee
	ECHO         2.  Caffeine
	ECHO.
	ECHO ====================================================================
	ECHO                                                          Q.  Выход
) else (
	ECHO --------------------------------------------------------------------
	ECHO                   =====  Choose explout =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Fusee-Gelee
	ECHO         2.  Caffeine
	ECHO.
	ECHO ====================================================================
	ECHO                                                          Q.  Quit
)
set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (set caffeine=0)
for %%A in ("2") do if "%st%"==%%A (set caffeine=1)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)


:syscon
cls
ECHO --------------------------------------------------------------------
ECHO               ======          Options           =====
ECHO --------------------------------------------------------------------
if %lang%==1 (
	ECHO --------------------------------------------------------------------
	ECHO               ======     Установить sys-con?     =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Да
	ECHO         2.  Нет
	ECHO.
	ECHO --------------------------------------------------------------------
	ECHO  SYS-CON - модуль для работы с проводными геймпадами. Почти любой
	ECHO  xinput-совместимый геймпад благодаря этому модулю, становится 
	ECHO  совместимым со Switch. Просто подключите геймпад по USB к консоли.
	ECHO  ВНИМАНИЕ! Модуль конфликтует с 8bitdo-адаптером!
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO ====================================================================
	ECHO                                                          Q.  Выход
) else (
	ECHO --------------------------------------------------------------------
	ECHO                    =====  Install sys-con? =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Yes
	ECHO         2.  No
	ECHO.
	ECHO ====================================================================
	ECHO                                                          Q.  Quit
)
set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (set syscon_flag=1)
for %%A in ("2") do if "%st%"==%%A (set syscon_flag=0)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

:opt
cls
ECHO --------------------------------------------------------------------
ECHO             ======          Options           =====
ECHO --------------------------------------------------------------------
if %lang%==1 (
	ECHO --------------------------------------------------------------------
	ECHO               ======     Тип установки     =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Обычная
	ECHO         2.  Чистая
	ECHO.
	ECHO --------------------------------------------------------------------
	ECHO  Используйте чистую установку, если при запуске системы вы получаете
	ECHO  ошибку. При чистой установке все файлы и папки на карте памяти, 
	ECHO  кроме папки "Nintendo", будут перемещены в  папку "backup"! Если в
	ECHO  папке "backup" нет ничего важного, удалите её вручную
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO ====================================================================
	ECHO                                                          Q.  Выход
) else (
	ECHO -------------------------------------------------
	ECHO           =====  Installation type =====
	ECHO -------------------------------------------------
	ECHO.
	ECHO         1.  General
	ECHO         2.  Clean
	ECHO.
	ECHO ==================================================
	ECHO                                          Q.  Quit
)
set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (set clear=0)
for %%A in ("2") do if "%st%"==%%A (set clear=1)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)
	
cls
ECHO ------------------------------------------------------------------
ECHO             ======          Options           =====
ECHO ------------------------------------------------------------------
if %lang%==1 (
	ECHO --------------------------------------------------------------------
	ECHO     ======     Настройки установки загрузочного экрана      =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO --------------------------------------------------------------------
	ECHO  Загрузочный экран - это картинка, которой вас встречает загрузка 
	ECHO  прошивки. В сборку входит загрузочный экран, на котором написана
	ECHO  дата сборки. Посмотреть на него можно в репозитории кефира.
	ECHO  Если вы хотите, чтобы был установлен наш бутскрин, выберите 1,
	ECHO  если хотите, чтобы остался тот, что у вас сейчас, выберите 2. 
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Установить новый - рекомендуется
	ECHO         2.  Оставить текущий
	ECHO.
	ECHO ====================================================================
	ECHO                                                         Q.  Выход
) else (
	ECHO --------------------------------------------------------------------
	ECHO            ======     Bootscreen setup settings      =====
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO --------------------------------------------------------------------
	ECHO  The boot screen is the picture that the firmware meets you with.
	ECHO  kefir includes a boot screen on which the build date is written.
	ECHO  You can look at it in the kefir's repository.
	ECHO --------------------------------------------------------------------
	ECHO.
	ECHO         1.  Install new - recomended
	ECHO         2.  Keep existing
	ECHO.
	ECHO ====================================================================
	ECHO                                                         Q.  Quit
)
set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (set bootscrn=1)
for %%A in ("2") do if "%st%"==%%A (set bootscrn=0)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)
	
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
	if %lang%==1 (
		set word=    По адресу %sd%:/ карта памяти не найдена  
	) else (
		set word=        There is no SD card in %sd%-drive         
	)
	goto WRONGSD
) else (
	if not exist "%sd%:\*" (goto WRONGSD)
)
if exist "%sd%:\_backup" (goto chckbkp)
goto main

:chckbkp
cls
if %lang%==0 (
	ECHO --------------------------------------------------------------
	ECHO  Old backup folder was founded. Remove it? 
	ECHO  If you has any important files there, copy them right now!
	ECHO ---------------------------------------------------------------
	ECHO  Найдена старая папка с бекапом, созданная, вероятно, при 
	ECHO  установке начисто. Рекомендуется её удалить. Если там остались 
	ECHO  важные файлы, перенесите их прямо сейчас!
	ECHO ---------------------------------------------------------------
	ECHO.
	ECHO         1.  Remove backup folder - recommended
	ECHO             Удалить папку backup - рекомендуется
	ECHO.
	ECHO         2.  Save backup folder
	ECHO             Оставить папку backup
	ECHO.
	ECHO ===============================================================
	ECHO                                                      Q.  Quit
) else (goto chckbkp1)
set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (goto rembkp)
for %%A in ("2") do if "%st%"==%%A (goto main)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)
goto main

:chckbkp1
if %lang%==1 (
	ECHO --------------------------------------------------------------
	ECHO  Найдена старая папка с бекапом, созданная, вероятно, при 
	ECHO  установке начисто. Рекомендуется её удалить. Если там остались 
	ECHO  важные файлы, перенесите их прямо сейчас!
	ECHO --------------------------------------------------------------
	ECHO.
	ECHO         1.  Удалить папку backup - рекомендуется
	ECHO         2.  Оставить папку backup
	ECHO.
	ECHO.
	ECHO ==============================================================
	ECHO                                             Q.  Выход
) else (
	ECHO --------------------------------------------------------------
	ECHO  Old backup folder was founded. Remove it? 
	ECHO  If you have any important files there, copy them right now!
	ECHO --------------------------------------------------------------
	ECHO.
	ECHO         1.  Remove backup folder - recommended
	ECHO         2.  Save backup folder
	ECHO.
	ECHO.
	ECHO ==============================================================
	ECHO                                             Q.  Quit
)

set st=
set /p st=:

for %%A in ("1") do if "%st%"==%%A (goto rembkp)
for %%A in ("2") do if "%st%"==%%A (goto main)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)
goto main

:main
COLOR 0F

if not exist "%sd%:\" (goto WRONGSD)

if %syscon_flag%==2 (
    if exist "%sd%:\atmosphere\contents\690000000000000D" (set syscon=1) else (set syscon=0)
) else (
    set syscon=%syscon_flag%
)

echo %syscon_flag%
echo %syscon%

cls
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                        Удаление устаревших файлов
	echo.
	echo ------------------------------------------------------------------------
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                      Removing outdated files on sd
	echo.
	echo ------------------------------------------------------------------------
)

if exist "%sd%:\base" (RD /s /q  "%sd%:\base")
if exist "%sd%:\atmo" (RD /s /q  "%sd%:\atmo")
if exist "%sd%:\misc" (RD /s /q  "%sd%:\misc")
if exist "%sd%:\bootloader\ini\RajNX.ini" (del "%sd%:\bootloader\ini\RajNX.ini")
if exist "%sd%:\bootloader\ini\ReiNX.ini" (del "%sd%:\bootloader\ini\ReiNX.ini")
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\bootloader\payloads\ReiNX.bin" (del "%sd%:\bootloader\payloads\ReiNX.bin")
if exist "%sd%:\ReiNX\titles\010000000000100D" (RD /s /q "%sd%:\ReiNX\titles\010000000000100D")
if exist "%sd%:\hekate_ipl.ini" (del "%sd%:\hekate_ipl.ini")
if exist "%sd%:\rajnx_ipl.ini" (del "%sd%:\rajnx_ipl.ini")
if exist "%sd%:\bootlogo.bmp" (del "%sd%:\bootlogo.bmp")

if %clear%==1 (
	if not exist "%sd%:\_backup" (mkdir %sd%:\_backup\)
	FOR /d %%A IN (%sd%:\*) DO (
		IF "%%A" NEQ "%sd%:\Nintendo" IF "%%A" NEQ "%sd%:\_backup" (move /Y %%A %sd%:\_backup)
	)
	
	set emuiibo=0
	
	move /Y %sd%:\*.* %sd%:\_backup"
	
)

echo                                    DONE
echo ------------------------------------------------------------------------
echo.
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo          Перемещение папок LayeredFS ReiNX в папки Atmosphere  
	echo.
	echo ------------------------------------------------------------------------
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo              Move ReiNX LayeredFS tiles to Atmosphere folder 
	echo.
	echo ------------------------------------------------------------------------
)

    if exist "%sd%:\ReiNX\titles\010000000000100D" (RD /s /q "%sd%:\ReiNX\titles\010000000000100D")
    if exist "%sd%:\ReiNX\titles" (xcopy %sd%:\ReiNX\titles\* %sd%:\atmosphere\contents\ /Y /S /E /H /R /D) >nul 2>&1
    if exist "%sd%:\ReiNX" (RD /s /q "%sd%:\ReiNX")
    if exist "%sd%:\RajNX" (RD /s /q "%sd%:\RajNX")

echo                                    DONE
echo ------------------------------------------------------------------------
echo.
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                       Удаление файлов старого пака
	echo.
	echo ------------------------------------------------------------------------
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                          Remove old pack files
	echo.
	echo ------------------------------------------------------------------------
)

if exist "%sd%:\atmosphere\exefs_patches" (RD /s /q "%sd%:\atmosphere\exefs_patches")
if exist "%sd%:\atmosphere\kip_patches" (RD /s /q "%sd%:\atmosphere\kip_patches")
if exist "%sd%:\atmosphere\hekate_kips" (RD /s /q "%sd%:\atmosphere\hekate_kips")
if exist "%sd%:\bootloader\debug" (RD /s /q "%sd%:\bootloader\debug")
if exist "%sd%:\modules" (RD /s /q "%sd%:\modules")

if exist "%sd%:\atmosphere\titles" (mkdir %sd%:\atmosphere\contents)
if exist "%sd%:\atmosphere\content" (mkdir %sd%:\atmosphere\contents)
if exist "%sd%:\atmosphere\titles" (xcopy "%sd%:\atmosphere\titles\*" "%sd%:\atmosphere\contents" /H /Y /C /R /S /E)
if exist "%sd%:\atmosphere\titles" (RD /s /q  "%sd%:\atmosphere\titles")
if exist "%sd%:\atmosphere\content" (xcopy "%sd%:\atmosphere\content\*" "%sd%:\atmosphere\contents" /H /Y /C /R /S /E)
if exist "%sd%:\atmosphere\content" (RD /s /q  "%sd%:\atmosphere\content")

if exist "%sd%:\atmosphere\contents\0100000000000032" (RD /s /q "%sd%:\atmosphere\contents\0100000000000032")
if exist "%sd%:\atmosphere\contents\0100000000000034" (RD /s /q "%sd%:\atmosphere\contents\0100000000000034")
if exist "%sd%:\atmosphere\contents\0100000000000036" (RD /s /q "%sd%:\atmosphere\contents\0100000000000036")
if exist "%sd%:\atmosphere\contents\0100000000000037" (RD /s /q "%sd%:\atmosphere\contents\0100000000000037")
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

if exist "%sd%:\atmosphere\fusee-secondary_atmo.bin" (del "%sd%:\atmosphere\fusee-secondary_atmo.bin")
if exist "%sd%:\atmosphere\hbl_atmo.nsp" (del "%sd%:\atmosphere\hbl_atmo.nsp")
if exist "%sd%:\atmosphere\fusee-secondary.bin.sig" (del "%sd%:\atmosphere\fusee-secondary.bin.sig")
if exist "%sd%:\atmosphere\hbl.nsp.sig" (del "%sd%:\atmosphere\hbl.nsp.sig")
if exist "%sd%:\atmosphere\hbl.json" (del "%sd%:\atmosphere\hbl.json")
if exist "%sd%:\atmosphere\BCT.ini" (del "%sd%:\atmosphere\BCT.ini")
if exist "%sd%:\atmosphere\system_settings.ini" (del "%sd%:\atmosphere\system_settings.ini")
if exist "%sd%:\atmosphere\loader.ini" (del "%sd%:\atmosphere\system_settings.ini")
if exist "%sd%:\atmosphere\kips\fs_mitm.kip" (del "%sd%:\atmosphere\kips\fs_mitm.kip")
if exist "%sd%:\atmosphere\kips\ldn_mitm.kip" (del "%sd%:\atmosphere\kips\ldn_mitm.kip")
if exist "%sd%:\atmosphere\kips\loader.kip" (del "%sd%:\atmosphere\kips\loader.kip")
if exist "%sd%:\atmosphere\kips\pm.kip" (del "%sd%:\atmosphere\kips\pm.kip")
if exist "%sd%:\atmosphere\kips\sm.kip" (del "%sd%:\atmosphere\kips\sm.kip")
if exist "%sd%:\atmosphere\kips\ams_mitm.kip" (del "%sd%:\atmosphere\kips\ams_mitm.kip")
if exist "%sd%:\atmosphere\flags\hbl_cal_read.flag" (del "%sd%:\atmosphere\flags\hbl_cal_read.flag")
if exist "%sd%:\atmosphere\exosphere.bin" (del "%sd%:\atmosphere\exosphere.bin")
if exist "%sd%:\atmosphere\hbl.nsp" (del "%sd%:\atmosphere\hbl.nsp")
if exist "%sd%:\atmosphere\loader.ini" (del "%sd%:\atmosphere\loader.ini")
if exist "%sd%:\atmosphere\reboot_payload.bin" (del "%sd%:\atmosphere\reboot_payload.bin")
if exist "%sd%:\atmosphere\BCT.ini" (del "%sd%:\atmosphere\BCT.ini")
if exist "%sd%:\sxos\bootloader" (RD /s /q  "%sd%:\sxos\bootloader")
if exist "%sd%:\sxos\switch" (RD /s /q  "%sd%:\sxos\switch")
if exist "%sd%:\sept" (RD /s /q  "%sd%:\sept")
if exist "%sd%:\sxos\boot.dat" (del "%sd%:\sxos\boot.dat")
if exist "%sd%:\sxos\sxos" (
	xcopy %sd%:\sxos\sxos\* %sd%:\sxos\ /Y /S /E /H /R /D
)
if exist "%sd%:\atmosphere\fusee-secondary.bin" (del "%sd%:\atmosphere\fusee-secondary.bin")
if exist "%sd%:\bootloader\payloads\fusee-primary-payload.bin" (del "%sd%:\bootloader\payloads\fusee-primary-payload.bin")
if exist "%sd%:\bootloader\payloads\Lockpick_RCM.bin" (del "%sd%:\bootloader\payloads\Lockpick_RCM.bin")
if exist "%sd%:\bootloader\payloads\biskeydump.bin" (del "%sd%:\bootloader\payloads\biskeydump.bin")
if exist "%sd%:\bootloader\payloads\fusee-payload.bin" (del "%sd%:\bootloader\payloads\fusee-payload.bin")
if exist "%sd%:\bootloader\payloads\fusee-primary.bin" (del "%sd%:\bootloader\payloads\fusee-primary.bin")
if exist "%sd%:\bootloader\payloads\sxos.bin" (del "%sd%:\bootloader\payloads\sxos.bin")
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\fusee-secondary.bin" (del "%sd%:\fusee-secondary.bin")
if exist "%sd%:\atmosphere\fusee-secondary.bin" (del "%sd%:\atmosphere\fusee-secondary.bin")
if exist "%sd%:\bootloader\ini\Atmosphere.ini" (del "%sd%:\bootloader\ini\Atmosphere.ini")
if exist "%sd%:\bootloader\ini\atmosphere.ini" (del "%sd%:\bootloader\ini\atmosphere.ini")
if exist "%sd%:\bootloader\ini\!atmosphere.ini" (del "%sd%:\bootloader\ini\!atmosphere.ini")
if exist "%sd%:\bootloader\ini\sxos.ini" (del "%sd%:\bootloader\ini\sxos.ini")
if exist "%sd%:\bootloader\ini\!sxos.ini" (del "%sd%:\bootloader\ini\!sxos.ini")
if exist "%sd%:\bootloader\ini\RajNX.ini" (del "%sd%:\bootloader\ini\RajNX.ini")
if exist "%sd%:\bootloader\ini\!RajNX.ini" (del "%sd%:\bootloader\ini\!RajNX.ini")
if exist "%sd%:\bootloader\ini\For 1.0.0 users only!.ini" (del "%sd%:\bootloader\ini\For 1.0.0 users only!.ini")
if exist "%sd%:\license-request.dat" (del "%sd%:\license-request.dat")
if exist "%sd%:\boot.dat" (del "%sd%:\boot.dat")
if exist "%sd%:\hbmenu.nro" (del "%sd%:\hbmenu.nro")
if exist "%sd%:\keys.dat" (del "%sd%:\keys.dat")
if exist "%sd%:\BCT.ini" (del "%sd%:\BCT.ini")
if exist "%sd%:\hekate_ipl.ini" (del "%sd%:\hekate_ipl.ini")
if exist "%sd%:\bootloader\update.bin" (del "%sd%:\bootloader\update.bin")
if exist "%sd%:\bootloader\update.bin.sig" (del "%sd%:\bootloader\update.bin.sig")
if exist "%sd%:\bootloader\patches_template.ini" (del "%sd%:\bootloader\patches_template.ini")
if exist "%sd%:\bootloader\patches.ini" (del "%sd%:\bootloader\patches.ini")
if exist "%sd%:\bootloader\hekate_ipl.ini" (del "%sd%:\bootloader\hekate_ipl.ini")
if exist "%sd%:\hekate_ipl.ini" (del "%sd%:\hekate_ipl.ini")

RD /s /q "%sd%:\_themebkp"
if exist "%sd%:\atmosphere\contents\0100000000001000" (mkdir %sd%:\_themebkp\0100000000001000)
if exist "%sd%:\atmosphere\contents\0100000000001000" (xcopy "%sd%:\atmosphere\contents\0100000000001000\*" "%sd%:\_themebkp\0100000000001000" /H /Y /C /R /S /E)
if exist "%sd%:\atmosphere\contents\0100000000001000" (RD /s /q "%sd%:\atmosphere\contents\0100000000001000")
if exist "%sd%:\atmosphere\contents\0100000000000352" (RD /s /q "%sd%:\atmosphere\contents\0100000000000352")

if exist "%sd%:\switch\lithium" (RD /s /q "%sd%:\switch\lithium")
if exist "%sd%:\switch\tinfoil" (RD /s /q "%sd%:\switch\tinfoil")
rem if exist "%sd%:\switch\EdiZon.nro" (del "%sd%:\switch\EdiZon.nro")
if exist "%sd%:\switch\tinfoil\tinfoil.nro" (del "%sd%:\switch\tinfoil\tinfoil.nro")
if exist "%sd%:\switch\tinfoil\keys.txt" (del "%sd%:\switch\tinfoil\keys.txt")
if exist "%sd%:\switch\checkpoint.nro" (del "%sd%:\switch\checkpoint.nro")
if exist "%sd%:\switch\checkpoint\checkpoint.nro" (del "%sd%:\switch\checkpoint\checkpoint.nro")
if exist "%sd%:\switch\pplay.nro" (del "%sd%:\switch\pplay.nro")
if exist "%sd%:\switch\NX-SHELL.nro" (del "%sd%:\switch\NX-SHELL.nro")
if exist "%sd%:\switch\reboot_to_payload.nro" (del "%sd%:\switch\reboot_to_payload.nro")
if exist "%sd%:\switch\NxThemesInstaller.nro" (del "%sd%:\switch\NxThemesInstaller.nro")
if exist "%sd%:\switch\NxThemesInstaller\NxThemesInstaller.nro" (del "%sd%:\switch\NxThemesInstaller\NxThemesInstaller.nro")
if exist "%sd%:\switch\sx.nro" (del "%sd%:\switch\sx.nro")
if exist "%sd%:\switch\n1dus.nro" (del "%sd%:\switch\n1dus.nro")
if exist "%sd%:\switch\ChoiDujourNX.nro" (del "%sd%:\switch\ChoiDujourNX.nro")
if exist "%sd%:\switch\ChoiDujourNX\ChoiDujourNX.nro" (del "%sd%:\switch\ChoiDujourNX\ChoiDujourNX.nro")
if exist "%sd%:\switch\dbi.nro" (del "%sd%:\switch\dbi.nro")
if exist "%sd%:\switch\dbi\dbi.nro" (del "%sd%:\switch\dbi\dbi.nro")
if exist "%sd%:\switch\nxmtp.nro" (del "%sd%:\switch\nxmtp.nro")
if exist "%sd%:\switch\nxmtp\nxmtp.nro" (del "%sd%:\switch\nxmtp\nxmtp.nro")
if exist "%sd%:\switch\sx\locations.conf" (del "%sd%:\switch\sx\locations.conf")
if exist "%sd%:\switch\sx\sx.nro" (del "%sd%:\switch\sx\sx.nro")
if exist "%sd%:\switch\sx.nro" (del "%sd%:\switch\sx.nro")
if exist "%sd%:\switch\incognito.nro" (del "%sd%:\switch\incognito.nro")
if exist "%sd%:\switch\incognito\incognito.nro" (del "%sd%:\switch\incognito\incognito.nro")
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
if exist "%sd%:\switch\fakenews-injector\fakenews-injector.nro" (del "%sd%:\switch\fakenews-injector\fakenews-injector.nro")
if exist "%sd%:\switch\fakenews-injector.nro" (del "%sd%:\switch\fakenews-injector.nro")
if exist "%sd%:\switch\gag-order.nro" (del "%sd%:\switch\gag-order.nro")
if exist "%sd%:\games\hbgShop_forwarder_classic.nsp" (del "%sd%:\games\hbgShop_forwarder_classic.nsp")
if exist "%sd%:\games\hbgShop_forwarder_dark_v3.nsp" (del "%sd%:\games\hbgShop_forwarder_dark_v3.nsp")
if exist "%sd%:\games\hbgShop_forwarder_dark_v4.nsp" (del "%sd%:\games\hbgShop_forwarder_dark_v4.nsp")
if exist "%sd%:\switch\fakenews-injector" (RD /s /q "%sd%:\switch\fakenews-injector")


:install_pack

if %lang%==1 (
	echo.
	echo                   Копирования пака во временную папку 
	echo.
	echo ------------------------------------------------------------------------
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                    Copy pack files to temp directory 
	echo.
	echo ------------------------------------------------------------------------
)

if exist "%temp%\sdfiles\" (RD /s /q "%temp%\sdfiles\")
if not exist "%temp%\sdfiles\" (mkdir %temp%\sdfiles\)
if not exist "%temp%\sdfiles\atmo" (mkdir %temp%\sdfiles\atmo)
xcopy "%~dp0atmo" "%temp%\sdfiles\atmo" /H /Y /C /R /S /E >nul 2>&1
if not exist "%temp%\sdfiles\base" (mkdir %temp%\sdfiles\base)
xcopy "%~dp0base" "%temp%\sdfiles\base" /H /Y /C /R /S /E >nul 2>&1
if not exist "%temp%\sdfiles\misc" (mkdir %temp%\sdfiles\misc)
xcopy "%~dp0misc" "%temp%\sdfiles\misc" /H /Y /C /R /S /E >nul 2>&1
if not exist "%temp%\sdfiles\sxos" (mkdir %temp%\sdfiles\sxos)
xcopy "%~dp0sxos" "%temp%\sdfiles\sxos" /H /Y /C /R /S /E >nul 2>&1
copy "%~dp0payload.bin" "%temp%\sdfiles\payload.bin" >nul 2>&1
copy "%~dp0update_sdfiles.bat" "%temp%\sdfiles\update_sdfiles.bat" >nul 2>&1

if %bootscrn%==0 (
	if exist "%wd%\base\bootloader\bootlogo.bmp" (del "%wd%\base\bootloader\bootlogo.bmp")
)


echo                                      DONE
echo ------------------------------------------------------------------------
echo.
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                      Установка пака на карту памяти
	echo.
	echo ------------------------------------------------------------------------
	echo.
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                          Installing pack files 
	echo.
	echo ------------------------------------------------------------------------
	echo.
)
xcopy "%wd%\base\*" "%sd%:\" /H /Y /C /R /S /E
xcopy "%wd%\payload.bin" "%sd%:\" /H /Y /C /R
if exist "%sd%:\sdfiles.zip" (del "%sd%:\sdfiles.zip")

if exist "%sd%:\tinfoil\ticket" (RD /s /q "%sd%:\tinfoil\ticket")
if exist "%sd%:\tinfoil\extracted" (RD /s /q "%sd%:\tinfoil\extracted")
if exist "%sd%:\tinfoil" (
	move /Y %sd%:\tinfoil\nsp\* %sd%:\games
	move /Y %sd%:\tinfoil\xci %sd%:\games
	RD /s /q "%sd%:\tinfoil"
)

echo                                    DONE
echo ------------------------------------------------------------------------
echo.
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                            Установка %cfwname% 
	echo.
	echo ------------------------------------------------------------------------
	echo.
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                            Installing %cfwname% 
	echo.
	echo ------------------------------------------------------------------------
	echo.
)

goto cfw_%cfw%

:cfw_ATMOS
xcopy "%wd%\atmo\*" "%sd%:\" /H /Y /C /R /S /E

if exist "%sd%:\boot.dat" (del "%sd%:\boot.dat")
if exist "%sd%:\bootloader\payloads\sxos.bin" (del "%sd%:\bootloader\payloads\sxos.bin")
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\switch\sx.nro" (del "%sd%:\switch\sx.nro")
if exist "%sd%:\bootloader\ini\sxos.ini" (del "%sd%:\bootloader\ini\sxos.ini")
if exist "%sd%:\bootloader\hekate_ipl_both.ini" (del "%sd%:\bootloader\hekate_ipl_both.ini")
if exist "%sd%:\bootloader\hekate_ipl_misc.ini" (del "%sd%:\bootloader\hekate_ipl_misc.ini")
if exist "%sd%:\bootloader\hekate_ipl_sx.ini" (del "%sd%:\bootloader\hekate_ipl_sx.ini")
if exist "%sd%:\bootloader\hekate_ipl_hm.ini" (del "%sd%:\bootloader\hekate_ipl_hm.ini")
if exist "%sd%:\bootloader\hekate_ipl_atmo.ini" (copy "%sd%:\bootloader\hekate_ipl_atmo.ini" "%sd%:\bootloader\hekate_ipl.ini")
if exist "%sd%:\bootloader\hekate_ipl_atmo.ini" (del "%sd%:\bootloader\hekate_ipl_atmo.ini")
if exist "%sd%:\sxos\titles" (xcopy %sd%:\sxos\titles\* %sd%:\atmosphere\contents\  /Y /S /E /H /R /D)
if exist "%sd%:\sxos\games" (move /Y %sd%:\sxos\games\* %sd%:\games)

if %syscon%==0 (RD /s /q "%sd%:\atmosphere\contents\690000000000000D")

if exist "%sd%:\sxos\emunand" (
if not exist "%sd%:\sxos_" (mkdir %sd%:\sxos_\emunand)
move /Y %sd%:\sxos\emunand\* %sd%:\sxos_\emunand
if exist "%sd%:\sxos" (RD /s /q "%sd%:\sxos")
if not exist "%sd%:\sxos\" (mkdir %sd%:\sxos\emunand)
if exist "%sd%:\sxos_\emunand" (move /Y %sd%:\sxos_\emunand\* %sd%:\sxos\emunand)
if exist "%sd%:\sxos_" (RD /s /q "%sd%:\sxos_")
)

if exist "%sd%:\switch\sx" (RD /s /q "%sd%:\switch\sx")
if exist "%sd%:\switch\themes" (RD /s /q "%sd%:\switch\themes")
if exist "%sd%:\titles" (xcopy "%wd%\titles\*" "%sd%:\atmosphere\contents" /H /Y /C /R /S /E)
if exist "%sd%:\titles" (RD /s /q "%sd%:\titles")

goto caffeine


:cfw_SXOS

xcopy "%wd%\atmo\*" "%sd%:\" /H /Y /C /R /S /E
xcopy "%wd%\sxos\*" "%sd%:\" /H /Y /C /R /S /E
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\bootloader\hekate_ipl_atmo.ini" (del "%sd%:\bootloader\hekate_ipl_atmo.ini")
if exist "%sd%:\bootloader\hekate_ipl_misc.ini" (del "%sd%:\bootloader\hekate_ipl_misc.ini")
if exist "%sd%:\bootloader\hekate_ipl_hm.ini" (del "%sd%:\bootloader\hekate_ipl_hm.ini")
if exist "%sd%:\bootloader\hekate_ipl_both.ini" (del "%sd%:\bootloader\hekate_ipl_both.ini")
if exist "%sd%:\bootloader\hekate_ipl_sx.ini" (copy "%sd%:\bootloader\hekate_ipl_sx.ini" "%sd%:\bootloader\hekate_ipl.ini")
if exist "%sd%:\bootloader\hekate_ipl_sx.ini" (del "%sd%:\bootloader\hekate_ipl_sx.ini")
if exist "%sd%:\atmosphere\exefs_patches" (RD /s /q "%sd%:\atmosphere\exefs_patches")
if exist "%sd%:\atmosphere\kip_patches\fs_patches" (RD /s /q "%sd%:\atmosphere\kip_patches\fs_patches")

goto caffeine

:cfw_BOTH
xcopy "%wd%\atmo\*" "%sd%:\" /H /Y /C /R /S /E
xcopy "%wd%\sxos\*" "%sd%:\" /H /Y /C /R /S /E
if exist "%sd%:\bootloader\payloads\rajnx_ipl.bin" (del "%sd%:\bootloader\payloads\rajnx_ipl.bin")
if exist "%sd%:\bootloader\hekate_ipl_atmo.ini" (del "%sd%:\bootloader\hekate_ipl_atmo.ini")
if exist "%sd%:\bootloader\hekate_ipl_misc.ini" (del "%sd%:\bootloader\hekate_ipl_misc.ini")
if exist "%sd%:\bootloader\hekate_ipl_sx.ini" (del "%sd%:\bootloader\hekate_ipl_sx.ini")
if exist "%sd%:\bootloader\hekate_ipl_hm.ini" (del "%sd%:\bootloader\hekate_ipl_hm.ini")
if exist "%sd%:\bootloader\hekate_ipl_both.ini" (copy "%sd%:\bootloader\hekate_ipl_both.ini" "%sd%:\bootloader\hekate_ipl.ini")
if exist "%sd%:\bootloader\hekate_ipl_both.ini" (del "%sd%:\bootloader\hekate_ipl_both.ini")

:caffeine
if %caffeine%==1 (goto cfw_DONE)

if exist "%sd%:\switch\fakenews-injector" (RD /s /q "%sd%:\switch\fakenews-injector")
if exist "%sd%:\pegascape" (RD /s /q "%sd%:\pegascape")

:cfw_DONE

echo                                    DONE
echo ------------------------------------------------------------------------
echo.

if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                    Установка атрибутов файлов и папок 
	echo.
	echo ------------------------------------------------------------------------
	echo.
) else (
	echo ------------------------------------------------------------------------
	echo.
	echo                             Fix atributes 
	echo.
	echo ------------------------------------------------------------------------
	echo.
)

if exist "%sd%:\atmosphere" (
	attrib -A /S /D %sd%:\atmosphere\*
	attrib -A %sd%:\atmosphere)
if exist "%sd%:\atmosphere\contents" (
	attrib -A /S /D %sd%:\atmosphere\contents*
	attrib -A %sd%:\atmosphere\contents)
if exist "%sd%:\sept" (
	attrib -A /S /D %sd%:\sept\*
	attrib -A %sd%:\sept)
if exist "%sd%:\bootloader" (
	attrib -A /S /D %sd%:\bootloader\*
	attrib -A %sd%:\bootloader)
if exist "%sd%:\config" (
	attrib -A /S /D %sd%:\config\*
	attrib -A %sd%:\config)
if exist "%sd%:\switch" (
	attrib -A /S /D %sd%:\switch\*
	attrib -A %sd%:\switch)
if exist "%sd%:\switch\mercury" (
	attrib +A %sd%:\switch\mercury)
if exist "%sd%:\tinfoil" (
	attrib -A /S /D %sd%:\tinfoil\*
	attrib -A %sd%:\tinfoil)
if exist "%sd%:\games" (
	attrib -A /S /D %sd%:\games\*
	attrib -A %sd%:\games)
if exist "%sd%:\themes" (
	attrib -A /S /D %sd%:\themes\*
	attrib -A %sd%:\themes)
if exist "%sd%:\emuiibo" (
	attrib -A /S /D %sd%:\emuiibo\*
	attrib -A %sd%:\emuiibo)
if exist "%sd%:\_backup" (
	attrib -A /S /D %sd%:\_backup\*
	attrib -A %sd%:\_backup)
if exist "%sd%:\hbmenu.nro" (attrib -A %sd%:\hbmenu.nro)
if exist "%sd%:\keys.dat" (attrib -A %sd%:\keys.dat)
if exist "%sd%:\boot.dat" (attrib -A %sd%:\boot.dat)
if exist "%sd%:\payload.bin" (attrib -A %sd%:\payload.bin)
if exist "%sd%:\sxos" (
	attrib -A /S /D %sd%:\sxos\*
	attrib -A %sd%:\sxos)
if exist "%sd%:\sxos" (
	attrib -A /S /D %sd%:\pegascape\*
	attrib -A %sd%:\pegascape)
if exist "%sd%:\switch\fakenews-injector" (
	attrib -A /S /D %sd%:\switch\fakenews-injector\*
	attrib -A %sd%:\switch\fakenews-injector)



echo                                    DONE
echo.
echo ------------------------------------------------------------------------
echo.

cls
COLOR 0A
echo.
if %lang%==1 (
	echo ========================================================================
	echo.
	echo             Всё готово! Вставьте карту памяти в приставку!
	echo.
	echo ========================================================================
	echo ========================================================================
	echo.
	echo              Если при запуске приставки вы видите ошибку,
	echo       проделайте установку пака еще раз, выбрав чистую установку!
	echo.
	echo ========================================================================
	echo ========================================================================
	echo.
) else (
	echo ========================================================================
	echo.
	echo                 DONE! Insert you SD into the console!
	echo.
	echo ========================================================================
	echo ========================================================================
	echo.
	echo             If you got an error after lauching console,
	echo          install pack one more time but choose clean install!
	echo.
	echo ========================================================================
	echo ========================================================================
	echo.
)

goto end

:WRONGSD
cls
COLOR C

		set word=    По адресу %sd%:/ карта памяти не найдена  
	) else (
		set word=        There is no SD card in drive %sd%:/        


if %lang%==0 (
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

for %%A in ("1") do if "%st%"==%%A (GOTO main)
for %%A in ("2") do if "%st%"==%%A (GOTO newcard)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

) else (goto wrongsd1)

:wrongsd1
cls
if %lang%==1 (
	ECHO ----------------------------------------------------------
	ECHO ======              Вы выбрали диск %sd%:/              =====
	ECHO. 
	ECHO ====== %word%   =====
	ECHO ----------------------------------------------------------
	ECHO.
	ECHO       Убедитесь, что указали правильную букву диска
	ECHO.
	ECHO         1.  Буква диска указана верно
	ECHO         2.  Ввести другую букву диска
	ECHO.
	ECHO ==========================================================
	ECHO                                              Q.  Выход
	ECHO.
) else (
	ECHO ----------------------------------------------------------
	ECHO ======               You choosed: %sd%:/                =====
	ECHO. 
	ECHO ======%word%=====
	ECHO ----------------------------------------------------------
	ECHO.
	ECHO       Make sure that you set correct SD card letter
	ECHO.
	ECHO         1.  The card letter is correct
	ECHO         2.  Choose another card letter
	ECHO.
	ECHO ==========================================================
	ECHO                                              Q.  Quit
	ECHO.
)

set st=
set /p st=:

for %%A in ("N" "n" "2" "т" "Т") do if "%st%"==%%A (GOTO newcard)
for %%A in ("Y" "y" "1" "н" "Н") do if "%st%"==%%A (GOTO main)
for %%A in ("Q" "q" "Й" "й") do if "%st%"==%%A (GOTO END)

:rembkp
if %lang%==1 (
	echo ------------------------------------------------------------------------
	echo.
	echo                         Удаление папки _backup
	echo                               Ожидайте!
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
if exist "%sd%:\update_sdfiles.bat" (del "%sd%:\update_sdfiles.bat")
exit