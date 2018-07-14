---
permalink: /atmos-games.html
title: Использование FTP
author_profile: true
---
{% include toc title="Разделы" %}

# Что понадобится

* Доступ к eShop или несколько установленных на приставке игр
* Настроенная и работающая [Atmosphere](atmos){:target="_blank"}
* Умение [запускать пейлоады через Fusée Gelée](fusee-gelee){:target="_blank"}
* [Отображение расширений файлов в Windows](file-extensions-windows){:target="_blank"} должно быть включено
* Свежая версия [PRAGMA's LFS Kit](https://github.com/imPRAGMA/LFSKit/releases/latest){:target="_blank"}
* [Ключи](files/keys_ini.zip){:target="_blank"} для расшифровки XCI-образов 
* [Список совместимости](https://awesome-table.com/-LFDcC2m8HJCLBPe-7e0/view){:target="_blank"} игр с донорами 
* [Игры](https://drive.google.com/drive/folders/1R28dVaYEkpd6mgK_arcQy26LHBC-0o48){:target="_blank"} в формате XCI 
	* [Ещё](https://www.reddit.com/r/SwitchPirates/comments/8s2e2t/download_switch_roms_from_here_the_sooner_you_do/){:target="_blank"}

# Инструкция

## Часть I - Подготовительные работы

1. Ознакомьтесь со [списком совместимости](https://awesome-table.com/-LFDcC2m8HJCLBPe-7e0/view){:target="_blank"} игр с донорами и скачайте из eShop необходимые для замены демо-версии
1. На ПК распакуйте `zip`-архив с [PRAGMA's LFS Kit](https://github.com/imPRAGMA/LFSKit/releases/latest){:target="_blank"} в удобное место 
1. Распакуйте `zip`-архив с [ключами](files/keys_ini.zip){:target="_blank"} в папку с PRAGMA's LFS Kit
1. Поместите выбранную игру в формате `.xci` в папку с PRAGMA's LFS Kit
1. Переименуйте игру в `game.xci`
	* `PRAGMAsLayeredFSKit.exe`, `keys.ini` и `game.xci` должны лежать в одной папке

## Часть II - Подготовка файлов игры

1. Запустите `PRAGMAsLayeredFSKit.exe`
1. Нажмите ".XCI Decrypter and .npdm editor"
1. Найдите TitleID той игры в которую мы будем делать внедрение другой игры в [этом списке](http://switchbrew.org/index.php?title=Title_list/Games){:target="_blank"} и скопируйте его в появившееся окно
1. Нажмите "DECRYPT XCI - by @PRAGMA"
1. Подождите окончания перепаковки и нажмите "OK" в выскочившем окошке
1. В папке программы появится новая папка с названием, совпадающим с TitleID, который вы копировали ранее

## Часть III - Установка и запуск измененной игры

1. Отключите на приставке интернет
1. Отключите Switch и вставьте его карту памяти в ПК
1. Скопируйте папку с названием, совпадающим с TitleID, который вы копировали ранее на карту памяти приставки в папку `atmosphere/titles`
1. Верните карту памяти обратно в приставку
1. Запустите пейлоад [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"} с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

	Для перемещения по меню hekata используйте клавиши (VOL-) и (VOL+), для выбора - (POWER)
	{: .notice--info}
	
1. На экране приставки выберите "Launch firmware" -> "LayeredFS + Clear Log"
	* Приставка запустится в обычное меню
1. Запустите игру, которую вы выбрали в качестве донора. Вместо неё должна запуститься подменённая игра

## Предостережения

* Могут не работать сохранения
* Иконка и название в главном меню приставки останутся от игры-донора
* Игра может зависать при запуске, может помочь нажатие кнопки (HOME) или перезагрузка приставки
* Работает только из hekata + layeredFS
* При выходе из такой игры практически наверняка получите бан!