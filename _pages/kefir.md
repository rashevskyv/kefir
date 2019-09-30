---
title: Kefir
permalink: /kefir.html
author_profile: true
---
{% include toc title="Разделы" %}

## KEFIR {% include /inc/kefir/version %}

В контексте этого руководства - сборник, состоящий из выбранного кастома, необходимых программ и скриптов, которые все это установят правильным образом. Подробнее про кефир [здесь](https://vk.com/@switchopen-sostav-kefirachast-pervaya-obschaya-informaciya-o-sostave){:target="_blank"}

![kefir](/images/kefir.png){: width="70%"}
{: .text-center}

### **ВНИМАНИЕ!**
  * Ручной запуск кастома теперь производится через `hekate -> Launch -> %ваш кастом%`
  * Перезагрузка в hekate происходит прямо из HOS через обычное меню перезагрузки/ Просто зажмите (VOL-) во время сплешскрина кефира
  * В hekate можно вынуть карту из приставки, а затем, вставив обратно, запустить прошивку через `hekate -> Launch -> Atmosphere`
  * **На новых версиях Atmosphere для входа в Homebrew Menu нужно запускать Альбом удерживая кнопку (R)**

____

### Состав kefir 
    
* Atmosphere 0.9.4 или SXOS 2.9 beta
* Поддерживает запуск через [Fusée Gelée](fusee-gelee){:target="_blank"} или [Caffeine](caffeine){:target="_blank"}
* [hekate 5](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"} и [ACID-патчи для неё](https://github.com/Joonie86/hekate/releases/latest){:target="_blank"}
* Homebrew 
  * [Kefir Updater 0.3.1](https://github.com/Povstalez/Kefir-Updater/releases/latest){:target="_blank"} - программа для обновления kefir через интернет
  * [Checkpoint 3.7.2](https://github.com/FlagBrew/Checkpoint/releases/latest){:target="_blank"} - программа для [резервного копирования и восстановления сейвов](checkpoint){:target="_blank"}
  * [Lockpick_RCM](https://github.com/shchmue/Lockpick_RCM/releases/latest){:target="_blank"} - программа для [дампа ключей приставки](backup-nand#часть-iii---дампим-ключи){:target="_blank"}
  * [pplay 2.1](https://github.com/Cpasjuste/pplay/releases/latest){:target="_blank"} - видеоплеер 
  * [{% include /inc/tinfoil.txt %}](https://discord.io/homebrew){:target="_blank"} - программа, позволяющая [качать игры](tinfoil){:target="_blank"} для приставки прямо из сети 
  * [ChoiDujourNX 1.0.2](https://switchtools.sshnuke.net/){:target="_blank"} - программа для [безопасного обновления](update-to-latest){:target="_blank"} версии системного ПО приставки
  * [nxmtp](https://github.com/liuervehc/nxmtp/releases/latest){:target="_blank"} - программа, монтирующая карту памяти Switch в виде MTP-устройства. Подключите приставку к ПК кабелем и запустите программу 
  * [NXThemes Installer 2.1.0](https://github.com/exelix11/SwitchThemeInjector/releases/latest){:target="_blank"} - менеджер кастомных тем 
  * DBI-19 for NSP-installing - программа для [установки игр по USB](dbi#установка-приложений-в-формате-nsp-по-usb){:target="_blank"} или [с карты памяти](dbi#установка-приложений-в-формате-nsp-с-карты-памяти){:target="_blank"}
  * [SXInstaller 1.5.2](https://sx.xecuter.com/){:target="_blank"} (SXOS only) - аналог tinfoil для SXOS

____

### Changelog

{% include /inc/kefir/changelog %}

____

### Инструкция по установке kefir 
{% spoiler Инструкции по автоматической установке (только для Windows) %}

1. Скачайте свежий {% include abbr/kefir_git.txt %} (файл `_kefir.7z`)
1. Распакуйте `_kefir.7z` в любое удобное место на ПК
1. **Вставьте в ПК** карту памяти приставки
1. Запустите `update_sdfiles.bat` из папки, в которую вы распаковали `_kefir.7z`
1. Вводите ответы, соответствующие вашей ситуации
1. Дождитесь окончания копирования
1. Продолжайте следовать [руководству](http://switch.customfw.xyz){:target="_blank"}
{% endspoiler %}

{% spoiler Инструкции по автоматической установке (только для macOS) %}

1. Скачайте [kefir Updater for macOS](https://github.com/Player-0ne/kefirUpdater_macOS/releases/latest){:target="_blank"}, нажав на ссылку **Source code (zip)**
1. **Вставьте в ПК** карту памяти приставки
1. Запустите `kefirUpdater.app`
1. Вводите ответы, соответствующие вашей ситуации
1. Дождитесь окончания копирования
1. Продолжайте следовать [руководству](http://switch.customfw.xyz){:target="_blank"}
{% endspoiler %}

{% spoiler Инструкция по установке вручную (все ОС) %}

### Удаление файлов старых прошивок

1. Если вы использовали пользовательские модификации, читы или переводы, переместите папку 'titles' из папки `sxos` или `ReiNX` или `atmosphere` (название папки зависит от вашей прошивки) в корень карты памяти 
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
1. Удалите из корня вашей карты памяти следующие папки и файлы (если они есть): 
   + `ReiNX` 
   + `RajNX` 
   + `sxos` 
   + `bootloader\ini\sxos.ini` 
   + `bootloader\ini\atmosphere.ini` 
   + `bootloader\ini\reinx.ini` 
   + `bootloader\ini\rajnx.ini` 
   + `bootloader\payloads\sxos.bin` 
   + `bootloader\payloads\reinx.bin` 
   + `bootloader\payloads\rajnx.bin` 
   + `bootloader\payloads\payload.bin` 
   + `bootloader\payloads\fusee-primary.bin` 
   + `atmosphere` 
   + `config` 
   + `tinfoil` 
   + `rajnx_ipl.ini`
   + `switch\n1dus.nro`
   + `switch\ftpd.nro`
   + `switch\tinfoil.nro`

### Для установки Atmosphere

1. Скопируйте в корень карты памяти приставки **содержимое** архива `atmo.zip` из репзитория {% include /abbr/kefir_addr.txt %}
1. Переместите папку `titles` из корня карты памяти в папку `atmosphere`, если она есть
   * Саму папку, а не её содержимое
1. Исправьте атрибуты по инструкции ниже 
1. enjoy

### Для установки SX OS

1. Скопируйте в корень карты памяти приставки **содержимое** архива `sxos.zip` репзитория {% include /abbr/kefir_addr.txt %}
1. Переместите папку `titles` из корня карты памяти в папку `sxos`
   * Саму папку, а не её содержимое
1. Исправьте атрибуты по инструкции ниже 
1. enjoy

### Исправление атрибутов 

**ДЕЛАТЬ ОБЯЗАТЕЛЬНО** после ручной установки

1. Запустите приставку без карты памяти с помощью `payload.bin`
1. Кнопками громкости и кнопкой включения перейдите в меню **tools**
1. Вставьте карту памяти в приставку
1. Выберите **Fix archive bit (except Nintendo folder)** и дождитесь окончания установки 
1. Выберите **Back** -> **Launch** - >**YOUR_OS_NAME**
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