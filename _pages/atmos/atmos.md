---
permalink: /atmos.html
title: Запуск Atmosphere
author_profile: true
---
{% include toc title="Разделы" %}

Хоть в текущем виде эту CFW и не следовало бы называть Atmosphere, для удобства я буду продолжать это делать. В данный момент это скорее официальная прошивка с запущенными модулями от Atmosphere

# Что понадобится 

* Свежая версия пейлоада [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"}
* Свежая версия [SDFilesSwitch](https://github.com/tumGER/SDFilesSwitch/releases/latest){:target="_blank"}


# Инструкция
## Подготовительные работы 

Если вы делали [безопасное обновление системы](update-to-latest){:target="_blank"}, **пропустите этот шаг**! Переписав `hekate_ipl.ini` после безопасного обновления вы рискуете обновить прошивку слота для картриджа!!
{: .notice--danger}

1. Выключите Switch и вставьте его карту памяти в ПК 
1. Скопируйте содержимое `.zip`-архива [SDFilesSwitch](https://github.com/tumGER/SDFilesSwitch/releases/latest){:target="_blank"} в корень карты памяти

## Запуск Atmosphere 

1. Запустите пейлоад [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"} с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

	Для перемещения по меню, hekata используйте клавиши (VOL-) и (VOL+), для выбора - (POWER)
	{: .notice--info}
	
1. На экране приставки выберите "Launch firmware" -> "LayeredFS + Clear Log"

___

# [Запуск Homebrew Launcher](launch-hbl#%D0%97%D0%B0%D0%BF%D1%83%D1%81%D0%BA-hbl-%D0%B8%D0%B7-atmosphere)
{: .notice--success}
# [Запуск игр с помощью LayeredFS](atmos-games)
{: .notice--success}