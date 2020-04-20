---
title: Kefir
permalink: /kefir.html
author_profile: true
---
{% include toc title="Разделы" %}

## KEFIR {% include /inc/kefir/version %}

<!--В данный момент всем, у кого прошивка 9.0.1 или ниже рекомендуется использовать [последний релизный кефир](https://github.com/rashevskyv/switch/releases/tag/332){:target="_blank"}. [Кефир 400](https://github.com/rashevskyv/switch/releases){:target="_blank"} предназначен в первую очередь для тех, кто установил себе 9.1.0! Покуда версия пре-релизная, её можно установить только вручную!-->

В контексте этого руководства - сборник, состоящий из выбранного кастома, необходимых программ и скриптов, которые все это установят правильным образом. Подробнее про кефир [здесь](https://vk.com/@switchopen-sostav-kefirachast-pervaya-obschaya-informaciya-o-sostave){:target="_blank"}. Зачем он нужен? Всё очень просто. Кефир содержит в себе самое полезное и проверенное временем ПО, которое в свежем кефире всегда идёт актуальной версии. Кефир устанавливается с помощью скрипта, который написан таким образом, чтобы удалять при установке все проблемные модули, из-за которых система моет работать нестабильно или не работать вовсе. При возникновении проблем, достаточно назвать версию кефира, чтобы сразу стало ясно какое именно ПО и какой версии сейчас на вашей приставке. 

![kefir](/images/kefir.png){: width="70%"}
{: .text-center}

### **ВНИМАНИЕ!**
  * Перезагрузка в hekate происходит прямо из HOS через обычное меню перезагрузки. Просто зажмите (VOL-) во время сплешскрина кефира
  * В hekate можно вынуть карту из приставки, а затем, вставив обратно, запустить прошивку через `hekate -> Launch -> Atmosphere`
  * **На новых версиях Atmosphere изменился способ входа в Homebrew Menu. [Подробнее](hbl){:target="_blank"}**
  * Установка и обновление kefir проводятся одинаково!

____

### Состав kefir 

* Кастомная прошивка на выбор: 
  * [NEUTOS](https://github.com/borntohonk/NEUTOS/releases){:target="_blank"} - специальный форк Atmosphere OS, заточенный для работы с tinfoil и для беспроблемного запуска пиратских игр с приставки 
  * [SXOS](https://sx.xecuter.com){:target="_blank"}
* Загрузчик [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"} поддерживает запуск через [Fusée Gelée](fusee-gelee){:target="_blank"} или [Caffeine](caffeine){:target="_blank"}
* [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"}
* Установленное Homebrew 
  * [Kefir Updater](https://github.com/rashevskyv/kefir-updater/releases){:target="_blank"} - программа для обновления kefir через интернет
  * [NX-Shell](https://github.com/joel16/NX-Shell/releases/latest){:target="_blank"} - файловый менеджер
  * [FreshHay](https://github.com/devgru/FreshHay/releases){:target="_blank"} - программа для скачивания и распаковки рекомендуемой версии системного ПО прямо на приставке
  * [JKSV](https://github.com/J-D-K/JKSV/releases){:target="_blank"} - программа для резервного копирования и восстановления сейвов
  * [Lockpick_RCM](https://github.com/shchmue/Lockpick_RCM/releases/latest){:target="_blank"} - программа для [дампа ключей приставки](backup-nand#часть-iii---дампим-ключи){:target="_blank"}
  * [Incognoto_RCM](https://github.com/borntohonk/Incognito_RCM/releases/){:target="_blank"} - программа, стирающая серийный номер приставки, чтобы [заблокировать обновления и спрятать консоль от Nintendo](https://switch.customfw.xyz/block-update){:target="_blank"}
  * [pplay](https://github.com/Cpasjuste/pplay/releases/latest){:target="_blank"} - видеоплеер 
  * [{% include /inc/tinfoil.txt %}](https://discord.gg/X3Q9tM){:target="_blank"} - программа, позволяющая [качать игры](tinfoil){:target="_blank"} для приставки прямо из сети 
  * [ChoiDujourNX ](https://switchtools.sshnuke.net/){:target="_blank"} - программа для [безопасного обновления](update-to-latest){:target="_blank"} версии системного ПО приставки
  * [NXThemes Installer](https://github.com/exelix11/SwitchThemeInjector/releases/latest){:target="_blank"} - менеджер кастомных тем 
  * DBI - программа для [установки игр](games){:target="_blank"} по USB или с карты памяти
  * [SXInstaller](https://sx.xecuter.com/){:target="_blank"} (SXOS only) - аналог tinfoil для SXOS
  * [sys-con](https://github.com/cathery/sys-con/releases/latest){:target="_blank"} - модуль, позволяющий подключать к консоли по USB практически любые геймпады
  * [Tesla Overlay Menu](https://gbatemp.net/threads/tesla-the-nintendo-switch-overlay-menu.557362/){:target="_blank"} - специальное оверлей-меню для взаимодействия с системой
    - [ovlEdiZon.ovl](https://gbatemp.net/threads/tesla-the-nintendo-switch-overlay-menu.557362/){:target="_blank"} - Модуль для [использования читов](cheats){:target="_blank"}
    - [ovlSysmodules.ovl](https://github.com/WerWolv/ovl-sysmodules/releases){:target="_blank"} - Модуль для включения и отключения установленных системных модулей (как-то разгон, emuuibo и прочее)

____

### Changelog

{% include /inc/kefir/changelog %}

____

### Инструкция по установке kefir 
{% spoiler Инструкции по автоматической установке (только для Windows) %}

1. Скачайте свежий {% include abbr/kefir_git.txt %} (файл `_kefir.7z`)
1. Распакуйте `_kefir.7z` в любое удобное место на ПК
1. **Вставьте в ПК** карту памяти приставки
1. Запустите `install.bat` из папки, в которую вы распаковали `_kefir.7z`
1. Вводите ответы, соответствующие вашей ситуации
    * Если вы используете Caffeine, не забудьте выбрать его в опциях установщика
1. Дождитесь окончания копирования
1. Продолжайте следовать [руководству](http://switch.customfw.xyz){:target="_blank"}
{% endspoiler %}

{% spoiler Инструкция по установке вручную (все ОС) %}

### Вы можете получить доступ к карте памяти двумя способами: 

1. Достав карту памяти из приставки и вставив её в ПК
  1. Перезагрузите приставку через меню, вызываемое удерживанием кнопки (POWER) 
  1. На сплеш-скрине кефира нажмите кнопку понижения громкости, чтобы попасть в hekate 
  1. Находясь в hekate вы модете достать карту памяти и вставить её в ПК
1. С помощью DBI 
  1. Запустите DBI 
  1. Подключите консоль к ПК по USB-кабелю 
  1. В DBI выберите пункт "**Run MTP Responder**"
  1. На ПК смонтируется новое устройство - **Switch**, папка "**External SD card**" и есть ваша карта памяти 
    * Помните, что вы не сможете установить kefir автоматически по MTP!

### Удаление файлов старых прошивок

1. Если вы использовали пользовательские модификации, читы или переводы, переместите папку `titles` из папки `sxos` или `ReiNX` или `atmosphere` (название папки зависит от вашей прошивки) в корень карты памяти. Если не использовали, пропустите эту часть
1. Удалите из папки 'titles' папки со следующими названиями (если они там есть): 
  * `010000000000100D`
  * `0100000000000032`
  * `0100000000000034`
  * `0100000000000036`
  * `010000000000000D`
  * `420000000000000E`
  * `0100000000001000`
  * `0100000000000352`
  * `4200000000000010`
1. Удалите из корня вашей карты памяти все папки, кроме папок `titles`, `sxos`, `emuMMC` и `Nintendo`, если таковые там есть

### Для установки Atmosphere

1. Скопируйте в корень карты памяти приставки **содержимое** архива `atmo.zip` из репозитория {% include /abbr/kefir_addr.txt %}
1. Переместите папку `titles` из корня карты памяти в папку `atmosphere`
1. Переименуйте папку `titles` в `contents`
   * Саму папку, а не её содержимое
1. Исправьте атрибуты по инструкции ниже 
1. enjoy

### Для установки SX OS

1. Скопируйте в корень карты памяти приставки **содержимое** архива `sxos.zip` репозитория {% include /abbr/kefir_addr.txt %}
1. Переместите папку `titles` из корня карты памяти в папку `sxos`
   * Саму папку, а не её содержимое
1. Исправьте атрибуты по инструкции ниже 
1. enjoy

### Исправление атрибутов 

**ДЕЛАТЬ ОБЯЗАТЕЛЬНО** после ручной установки

1. Запустите приставку без карты памяти с помощью `payload.bin`
1. Кнопками громкости и кнопкой включения перейдите в меню **tools**
1. Вставьте карту памяти в приставку
1. Выберите **Unset archive bit** и дождитесь окончания установки 
1. Выберите **Back** -> **Launch** - >**YOUR_OS_NAME**
{% endspoiler %}

{% spoiler Обновление кефира прямо на приставке %}

1. Запустите [HBL](hbl){:target="_blank"}
1. Выберите **Kefir Updater**
    * Требуется подключение к интернету!
1. Выберите ОС, которую используете
1. По окончанию установки, перезагрузите приставку

{% endspoiler %}


{% spoiler Читы %}
**`edizon_cheats.zip` - читы для использования вместе с Edizon и атмосферой!**

1. Скопируйте папки `EdiZon` и `switch` из архива `edizon_cheats.zip` в корень вашей карты памяти
1. Скопируйте папку с названием, соответствующем кастому, который вы используете, в корень карты памяти
  * `atmosphere` для пользователей Atmosphere 
  * `sxos` для пользователей SXOS
{% endspoiler %}

___

[Закрыть страницу](javascript:window.close();)
{: .notice--success}