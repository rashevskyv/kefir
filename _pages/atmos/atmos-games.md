---
permalink: /atmos-games.html
title: Запуск игр в Atmosphere
author_profile: true
---
{% include toc title="Разделы" %}

# Что понадобится

* Настроенная и работающая [Atmosphere](atmos){:target="_blank"}
* Умение [запускать пейлоады через Fusée Gelée](fusee-gelee){:target="_blank"}
* Игра-донор: 
	* [Pokemon Quest](https://www.nintendo.com/games/detail/pokemon-quest-switch){:target="_blank"}
* [Devmenu](files/devmenu_atm.zip){:target="_blank"}
* [tinfoil](files/tinfoil.zip){:target="_blank"}
* [Игры в формате NSP](https://www.reddit.com/r/switchroms/comments/8xjo94/multihost_eshop_dlc_download_index/){:target="_blank"}
	* Так же можно качать с серверов Nintendo [этим способом](sxos-games#часть-ii---закачка-игр-в-формате-nsp){:target="_blank"}

# Инструкция

## Часть I - Подготовительные работы

1. Выключите консоль
1. Вставьте карту памяти в ПК
1. Скопируйте содержимое `.zip`-архива с [Devmenu](files/devmenu_atm.zip){:target="_blank"} в корень карты памяти приставки
	* Проверьте, что в папке `atmosphere/titles` есть папка `01005D100807A000`
1. Поместите содержимое `.zip`-архива [tinfoil](files/tinfoil.zip){:target="_blank"} в корень карты памяти приставки
1. Поместите игру в формате NSP в папку `nsp` на карте памяти. Если таковой папки нет, создайте её

## Часть II - Установка Devmenu

1. Скопируйте скачанную игру в формате `.nps` в папку `tinfoil/nsp`, расположенную в корне вашей карты памяти. Если такой папки нет - создайте её
1. Вставьте карту памяти в консоль и [запустите Atmosphere](atmos){:target="_blank"}
	* Делайте подготовительные работы только в том случае, если не делали их ранее!
1. Запустите "Альбомы", чтобы войти в Homebrew Launcher

	![]({{ base_path }}/images/screenshots/gallery.jpg) 
	{: .text-center}
	{: .notice--info}

1. Запустите tinfoil
1. Выберите "Title Managment" -> "Install NSP"
1. Выделите `.nsp`-файл с игрой-донором и нажмите (A)
1. Дождитесь окончания установки 
	* На экране появится надпись "Done!"
1. Нажмите (HOME) для выхода в меню приставки

## Часть III - Установка игры в формате NSP

1. Запустите игру Pokemon Quest, вместо игры откроется DevMenu 
	* Если запускается игра, проверьте все ли верно вы сделали в Часть I. На карте памяти по пути `atmosphere/titles` должна лежать папка `01005D100807A000`
1. В DevMenu выберите пункт пункт "Install from SD Card"
1. Выберите игру, которую хотите установить и нажмите (A)
	* Если игр несколько - нажмите "Install all"
1. Выберите куда игра будет устанавливаться (рекомендуем выбирать "Auto") и нажмите "Start"
1. После установки игры нажмите (HOME), чтобы вернуться в главное меню приставки
1. Запустите установленную игру