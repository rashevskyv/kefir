---
permalink: /sxos-games.html
title: Запуск игр в SX OS
author_profile: true
---
{% include toc title="Разделы" %}

# Предупреждения

* Не выходите онлайн с запущенной пиратской игрой - чревато баном 
* Игру можно обновить через eShop, но я крайне не рекомендую этого делать. Рекомендация не выходить в интернет по прежнему актуальна
* Обновление игры можно скачать в формате NSP и установить [вручную](#с-помощью-sx-os){:target="_blank"}

# Что понадобится

* [Лицензия на SX OS или SX OS Pro](https://team-xecuter.com/where-to-buy/){:target="_blank"}

## Игры 

Игры распространяются в двух форматах: 
	* XCI - дампы картриджей. Как правило, не обновлённые версии. Обычно для таких игр нужно ещё выкачивать из eShop обновления или дополнительный контент. Занимают больше места, чем дампы игр из eShop
	* NSP - дампы игр из eShop. Можно выкачать самые последние версии, с DLC. Иным образом обновить игру у вас не получится, поскольку для этого понадобится выйти в eShop, что не безопасно и чревато баном. Обычно занимают меньше места.

* [Игры](https://drive.google.com/drive/folders/1R28dVaYEkpd6mgK_arcQy26LHBC-0o48){:target="_blank"} в формате XCI 
	* [Ещё](https://www.reddit.com/r/SwitchPirates/comments/8s2e2t/download_switch_roms_from_here_the_sooner_you_do/){:target="_blank"}
* [Игры в формате NSP](https://www.reddit.com/r/switchroms/comments/8xjo94/multihost_eshop_dlc_download_index/){:target="_blank"}
	* Так же можно качать с серверов Nintendo [этим способом](#download-nsp){:target="_blank"}

# Установка и запуск игр в формате XCI 

1. Выключите консоль
1. Вставьте карту памяти в ПК
1. Скопируйте игру в формате `.xci` в корень карты памяти и вставьте её в консоль
1. [Запустите SX OS](sxos){:target="_blank"}
1. Запустите "Альбомы", чтобы попасть в меню выбора игр 
1. Выберите игру, нажатием кнопки (A)
1. SX OS съэмулирует картридж с выбранной игрой, запустите его и играйте 

{% include inc/install-nsp.txt 

	sxos='Начиная с [SX OS 1.4](sxos#обновление-sx-os){:target="_blank"} программа поддерживает установку NSP из коробки.'
	
	cfw_link="SX OS](sxos" 
	
	cfw="SX OS" 

%}