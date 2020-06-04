---
permalink: /hbl.html
title: Запуск Homebrew Launcher
author_profile: true
---
{% include toc title="Разделы" %}

Homebrew Launcher (hbl) - среда для запуска самописных приложений для Switch. Запуск производится через изменённое приложение Альбомы или через программу-форвардер.

![]({{ base_path }}/images/screenshots/gallery.jpg) 
{: .text-center}
{: .notice--info}

Существуют два режима работы Homebrew, запущенных через Homebrew launcher (HBL): режим апплета и режим тайтла. В первом случае приложению доступно только 400Мб из всей памяти консоли, во втором - вся память (4Gb). Некоторые приложения, например Checkpoint, Edizon, Tinfoil, не будут работать в режиме апплета, поскольку им необходима вся доступная память приставки (кому-то для поиска читов, кому-то из-за плохой оптимизации). В atmosphere для запуска HBL в режиме тайтла, нужно запускать игру, удерживая (R) (держать кнопку нужно до тех пор, пока не запустится HBL). Или использовать форвардер. В случае же с SX OS, при запуске Альбомов их проприетарный Homebrew Launcher и так запустится в режиме тайтла. 

## Что понадобится

* [Запущенная CFW](cfw){:target="_blank"}
* Свежая версия {% include abbr/kefir_addr.txt %}

## Подготовительные работы

1. Выключите Switch и вставьте его карту памяти в ПК 
1. Установите `.7z`-архив {% include abbr/kefir_addr.txt %}, если ещё не делали этого
1. Вставьте карту памяти в консоль и запустите [выбранный {% include abbr/cfw.txt abbr="кастом" %}](cfw){:target="_blank"}

##  Работа с HBL

* Для запуска в режиме апплета, запустите Альбомы, удерживая клавишу (R)
    ![]({{ base_path }}/images/screenshots/gallery.jpg) 
    {: .text-center}
    {: .notice--info}
* Для запуска в режиме тайтла, запустите любую игру, удерживая клавишу (R)
* Для установки приложений хоумбрю просто скопируйте файл `.nro` в папку `/switch/` на SD-карте.
    * Используйте **DBI** для копирования homebrew в режиме MTP. Для этого подключите приставку к ПК кабелем, запустите DBI и нажмите (X) в главном меню программы
    * Вы можете так же смонтировать карту памяти через hekate ({% include inc/sd_hekate.md %})
* Список доступных приложений ищите в [Switch Appstore](https://www.switchbru.com/appstore/#/){:target="_blank"}
* [Список полезных Homebrew приложений для Switch](https://vk.com/@pg_testing-homebrew-apps-for-switch)

{% capture notice-7 %}
Если в списке приложений пусто, снимите с файлов архивные атрибуты: 

* {% include /inc/fixatributes.txt %}

{% endcapture %}

<div class="notice--warning">{{ notice-7 | markdownify }}</div>

___

[Закрыть страницу](javascript:window.close();)
{: .notice--success}