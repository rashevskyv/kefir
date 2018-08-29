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
1. Скопируйте содержимое `.zip`-архива [SDFiles от VK:3ds_cfw](https://github.com/rashevskyv/switch/releases/latest){:target="_blank"} в корень карты памяти
1. Вставьте карту памяти в консоль и запустите [выбранный кастом](launch-cfw){:target="_blank"}

# Инструкция

## Часть I - Запуск HBL

Homebrew Launcher (HBL) - среда для запуска самописных приложений для Switch. 

Запустите Альбом, чтобы попасть в HBL

![]({{ base_path }}/images/screenshots/gallery.jpg) 
{: .text-center}
{: .notice--info}

**Для пользователей [ReiNX](reinx){:target="_blank"} и [RajNX](rajnx){:target="_blank"}**
1. Запустите Альбом, чтобы попасть в HBL
	
**Для пользователей [SX OS 1.4](sxos#обновление-sx-os){:target="_blank"} и выше:**
1. С помощью (R) листайте на вкладку HOMEBREW 

## Часть II - Работа с HBL

1. Для установки приложений хоумбрю просто скопируйте файл .nro в папку /switch/ на SD-карте.
	* Помните, что при извлечении карты памяти приставка перезагрузится и вам, после того, как вы скопируете приложения на карту и вставите её в Switch, снова придётся запускать CFW. Используйте доступ по FTP с помощью приложения ftpd, чтобы избежать этого.
1. Список доступных приложений ищите в [Switch Appstore](https://www.switchbru.com/appstore/#/){:target="_blank"}
1. Для того, чтобы запустить галерею, зажмите (L) при запуске HBL

Если в списке приложений пусто, снимите с файлов архивные атрибуты удобным способом: 
* На маке выполните в терминале команду `sudo chflags -R arch`, находясь в корне карты памяти
* В hekata перейдите в меню **Tools** выберите **Unset archive bit (all sd files)**
* В Windows войдите в свойства папки и в поле "Атрибуты" уберите все галочки, так же сделайте в меню "Другие"

## Список полезных приложений 

* [Homebrew Appstore](https://www.switchbru.com/appstore/#/app/appstore){:target="_blank"} - магазин приложений
* [FTPD](https://www.switchbru.com/appstore/#/app/ftpd){:target="_blank"} - FTP-клиент
* [Edizon](https://www.switchbru.com/appstore/#/app/Edizon){:target="_blank"} - программа для резервного копирования сохранений
* [NX-shell](https://www.switchbru.com/appstore/#/app/NX-shell){:target="_blank"} - многофункциональный файловый менеджер 
* [SDFileUpdater](https://www.switchbru.com/appstore/#/app/SDFileUpdater){:target="_blank"} - программа для обновления файлов Atmosphere на карте памяти
* [Эмуляторы](https://www.switchbru.com/appstore/#/category/emulators){:target="_blank"} - богатый список эмуляторов ретро-консолей