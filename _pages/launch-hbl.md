---
permalink: /launch-hbl.html
title: Запуск Homebrew Launcher
author_profile: true
---
{% include toc title="Разделы" %}

# Что понадобится

* [Запущенная CFW](launch-cfw){:target="_blank"}
* Свежая версия [SDFiles от VK:3ds_cfw](https://github.com/rashevskyv/switch/releases/latest){:target="_blank"}

# Подготовительные работы

1. Выключите Switch и вставьте его карту памяти в ПК 
1. Скопируйте содержимое `.zip`-архива [SDFiles от VK:3ds_cfw](https://github.com/rashevskyv/switch/releases/latest){:target="_blank"} в корень карты памяти, если ещё не делали этого
1. Вставьте карту памяти в консоль и запустите [выбранный кастом](launch-cfw){:target="_blank"}

# Инструкция

## Часть I - Запуск HBL

Homebrew Launcher (HBL) - среда для запуска самописных приложений для Switch. 

Запустите Альбом, чтобы попасть в HBL

![]({{ base_path }}/images/screenshots/gallery.jpg) 
{: .text-center}
{: .notice--info}

**Для пользователей [Atmosphere](atmos){:target="_blank"}{:target="_blank"}**
1. Запустите Альбом, чтобы попасть в HBL
	* Для запуска Альбомов вместо HBL, зажмите (R) при запуске
	
**Для пользователей [SX OS](sxos){:target="_blank"}:**
1. С помощью (R) листайте на вкладку HOMEBREW 

## Часть II - Работа с HBL

1. Для установки приложений хоумбрю просто скопируйте файл .nro в папку /switch/ на SD-карте. Новые приложения так же можно устанавливать через приложение Appstore 
	* Помните, что при извлечении карты памяти приставка перезагрузится и вам, после того, как вы скопируете приложения на карту и вставите её в Switch, снова придётся запускать CFW. Используйте доступ по (FTP)[ftp]{:target="_blank"} с помощью приложения ftpd, чтобы избежать этого
1. Список доступных приложений ищите в [Switch Appstore](https://www.switchbru.com/appstore/#/){:target="_blank"}
1. Для того, чтобы запустить галерею, зажмите (L) при запуске HBL

{% capture notice-7 %}
Если в списке приложений пусто, снимите с файлов архивные атрибуты: 

* В hekata перейдите в меню **Tools** выберите **Unset archive bit (all sd files)**

Не меняйте атрибуты папки Nintendo!
{: .notice--danger}
{% endcapture %}

<div class="notice--warning">{{ notice-7 | markdownify }}</div>


## Список полезных приложений 

* [Homebrew Appstore](https://github.com/vgmoose/hb-appstore/releases/latest){:target="_blank"} - магазин приложений
* [FTPD](https://github.com/mtheall/ftpd/releases/latest){:target="_blank"} - FTP-клиент
* [Checkpoint](https://github.com/FlagBrew/Checkpoint/releases/latest){:target="_blank"} - программа для резервного копирования сохранений
* [NX-shell](https://github.com/joel16/NX-Shell/releases/latest){:target="_blank"} - многофункциональный файловый менеджер 
* [Эмуляторы](https://www.switchbru.com/appstore/#/category/emulators){:target="_blank"} - богатый список эмуляторов ретро-консолей