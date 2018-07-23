---
permalink: /atmos-games.html
title: Запуск игр с помощью LayeredFS
author_profile: true
---
{% include toc title="Разделы" %}

# Что понадобится

* Свежая версия [nsp_xci_decryptor](https://github.com/rashevskyv/nsp_xci_decryptor/archive/master.zip){:target="_blank"}
* [hactool 1.1.0](https://github.com/SciresM/hactool/releases/tag/1.1.0){:target="_blank"}
* Свежая версия [Plague](https://gbatemp.net/threads/atmosphere-mod-plague-easy-layeredfs-app-switching-alpha.508123/){:target="_blank"}
* Доступ к eShop или несколько установленных на приставке игр (картриджные версии тоже подходят)
* Настроенная и работающая [Atmosphere](atmos){:target="_blank"}
* Умение [запускать пейлоады через Fusée Gelée](fusee-gelee){:target="_blank"}
* [Отображение расширений файлов в Windows](file-extensions-windows){:target="_blank"} должно быть включено
* [Список совместимости](https://awesome-table.com/-LFDcC2m8HJCLBPe-7e0/view){:target="_blank"} игр с донорами 
* [Игры](https://drive.google.com/drive/folders/1R28dVaYEkpd6mgK_arcQy26LHBC-0o48){:target="_blank"} (Google Disk) в формате XCI
	* [Ещё](https://www.reddit.com/r/SwitchPirates/comments/8s2e2t/download_switch_roms_from_here_the_sooner_you_do/){:target="_blank"}
* [Игры в формате NSP](https://www.reddit.com/r/switchroms/comments/8xjo94/multihost_eshop_dlc_download_index/){:target="_blank"}
	* Так же можно качать с серверов Nintendo [этим способом](sxos-games#часть-ii---закачка-игр-в-формате-nsp){:target="_blank"}

# Инструкция

## Часть I - Подготовительные работы

1. Ознакомьтесь со [списком совместимости](https://awesome-table.com/-LFDcC2m8HJCLBPe-7e0/view){:target="_blank"} игр с донорами и скачайте из eShop необходимые для замены демо-версии
1. На ПК распакуйте `zip`-архив с [nsp_xci_decryptor](https://github.com/imPRAGMA/LFSKit/releases/latest){:target="_blank"} в удобное место 
1. Создайте папку `games` в папке `nsp_xci_decryptor`
1. Создайте папку `updates` в папке `nsp_xci_decryptor`
1. Распакуйте `zip`-архив с [hactool 1.1.0](https://github.com/SciresM/hactool/releases/tag/1.1.0){:target="_blank"} в папку с nsp_xci_decryptor
	* `hactool.exe` должна находится в той же папке, что и `decrypt.bat`
1. Запустите `get_keys.bat`, чтобы получить ключи
	* Если по какой-то причине скрипт не работает, скачайте их [вручную](files/keys_ini.zip){:target="_blank"} и поместите `keys.txt` в ту же папку, где находится `hactool.exe` и `decrypt.bat`
1. С помощью [таблицы совместимости](https://awesome-table.com/-LFDcC2m8HJCLBPe-7e0/view){:target="_blank"} подберите рабочую пару донор-игра 
1. Отключите на приставке интернет
1. Отключите Switch и вставьте его карту памяти в ПК
1. Поместите файл `mod_Plague.nro` из `.zip`-архива Plague в папку `switch` на карте памяти приставки
1. Создайте папку `plague` в папке `modules` на карте памяти приставки
1. Поместите `.kip-`файлы из `.zip`-архива Plague в папку `modules/plague` на карте памяти приставки
1. Откройте файл `hekate_ipl.ini` в текстовом редакторе и пропишите после блока [config] следующие строки: 
	* `{----- Plague ------}`
	* `[Plague]`
	* `kip1=modules/plague/loader.kip`
	* `kip1=modules/plague/sm.kip`
	* `kip1=modules/plague/fs_mitm.kip`
	* `atmosphere=1`

	![]({{ base_path }}/images/screenshots/plague-config.png) 
	{: .text-center}
	{: .notice--info}

## Часть II - Распаковка игр 

1. Поместите скачанные игры в формате `.xci` или\и `.nsp` в папку `nsp_xci_decryptor/games`
1. Если вы планируете устанавливать игру в формате NSP вместе с обновлением, то её необходимо перепаковать: 
	1. Поместите обновление в папку `nsp_xci_decryptor/updates` в папке с nsp_xci_decryptor
	1. Запустите `decrypt_and_merge_nsp_game_with_update.bat`
	1. Перетяните на окно программы файл игры и нажмите Enter 
	1. Перетяните на окно программы обновление для игры, что вы использовали выше и нажмите Enter 
	1. Дождитесь окончания перепаковки
1. Запустите `decrypt_games_folder.bat` для распаковки всех игр, находящихся в папке `games`
	* Если хотите распаковать только одну из папки - перетяните её на файл `decrypt.bat`
1. Убедитесь, что программа не выдаёт ошибку, после чего нажмите любую кнопку для закрытия окна программы

## Часть III - Установка и запуск изменённой игры

1. Переместите папку `backups` из папки `nsp_xci_decryptor` в корень карты памяти Switch
1. Верните карту памяти обратно в приставку
1. Запустите пейлоад [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"} с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

	Для перемещения по меню, hekata используйте клавиши (VOL-) и (VOL+), для выбора - (POWER)
	{: .notice--info}
	
1. На экране приставки выберите "Launch firmware" -> "Plague"
	* Приставка запустится в обычное меню
1. Запустите "Альбомы", чтобы войти в Homebrew Launcher

	![]({{ base_path }}/images/screenshots/gallery.jpg) 
	{: .text-center}
	{: .notice--info}

1. Запустите "Plague"
1. Нажмите (X), чтобы создать пару донор-игра
1. Выберите игру-донор
1. Выберите игру, которая будет загружаться при запуске донора
	* Для удаления связки игра-донор, нажмите (Y)
	* Для изменения связки игра-донор выберите связку и нажмите (A)
1. Нажмите (HOME) для выхода в меню и выберите игру-донор

## Предостережения

* Могут не работать сохранения
* Иконка и название в главном меню приставки останутся от игры-донора
* Игра может зависать при запуске, может помочь нажатие кнопки (HOME) или перезагрузка приставки
* Работает только из "Plague"
* При выходе из такой игры онлайн практически наверняка получите бан!