---
permalink: /sxos-games.html
title: Запуск игр в SX OS
author_profile: true
---
{% include toc title="Разделы" %}

# Что понадобится

Игры распространяются в двух форматах: 
* XCI - дампы картриджей. Как правило, не обновлённые версии. Обычно для таких игр нужно ещё выкачивать из eShop обновления или дополнительный контент. Занимают больше места, чем дампы игр из eShop
* NSP - дампы игр из eShop. Можно выкачать самые последние версии, с DLC. Иным образом обновить игру у вас не получится, поскольку для этого понадобится выйти в eShop, что не безопасно и чревато баном. Обычно занимают меньше места.

* [Игры](https://drive.google.com/drive/folders/1R28dVaYEkpd6mgK_arcQy26LHBC-0o48){:target="_blank"} в формате XCI 
	* [Ещё](https://www.reddit.com/r/SwitchPirates/comments/8s2e2t/download_switch_roms_from_here_the_sooner_you_do/){:target="_blank"}
* [Игры в формате NSP](https://www.reddit.com/r/switchroms/comments/8xjo94/multihost_eshop_dlc_download_index/){:target="_blank"}
	* Так же можно качать с серверов Nintendo [этим способом](sxos-games#часть-ii---закачка-игр-в-формате-nsp){:target="_blank"}
* [Лицензия на SX OS или SX OS Pro](https://team-xecuter.com/where-to-buy/){:target="_blank"}

# Установка и запуск игр в формате XCI 

1. Выключите консоль
1. Вставьте карту памяти в ПК
1. Скопируйте игру в формате `.xci` в корень карты памяти и вставьте её в консоль
1. [Запустите SX OS](sxos){:target="_blank"}
1. Запустите "Альбомы", чтобы попасть в меню выбора игр 
1. Выберите игру, нажатием кнопки (A)
1. SX OS съэмулирует картридж с выбранной игрой, запустите его и играйте 

## Предупреждения

* Не выходите онлайн с запущенной игры - чревато баном 
* Игру можно обновить через eShop, но я крайне не рекомендую этого делать. Рекомендация не выходить в интернет по прежнему актуальна
* Обновление игры можно скачать в формате NSP и установить

# Установка и запуск игр в формате NSP 

## [Способ I - Автоматически, с помощью NXShop](nxshop){:target="_blank"}

## Способ II - Вручную

### Что понадобится 

* Программа 
* Игра-донор: 
	* Если у вас есть доступ к eShop - [Pokemon Quest](https://www.nintendo.com/games/detail/pokemon-quest-switch){:target="_blank"}
	* Если у вас нет доступа к eShop - [Flashback](https://drive.google.com/open?id=1s_b0zjW5zDkLA4iGdpgBKMKyU7j54AG9){:target="_blank"}
* Devmenu 
	* [Для Pokemon Quest](files/devmenu_pq.zip){:target="_blank"}
	* [Для Flashback](files/devmenu_f.zip){:target="_blank"}
* Свежая версия программы [CDNSP GUI](https://darkumbra.net/forums/topic/174904-app-cdnsp-gui-v31-no-setup-needed-simply-double-click-and-use-beginner-friendly-fixed-cert-error-made-in-python-by-bob-rex123a1/?tab=comments#comment-1155841){:target="_blank"}
	* Для того, чтобы скачать эту программу вам придётся зарегистрироваться на сайте darkumbra.net
* [Файлы](https://drive.google.com/open?id=1DRxO2It8X93_I6d3PmJQj_qZUjAp6VOv){:target="_blank"}, необходимые для работы CDNSP GUI	
* [Python 3.7.0](https://www.python.org/ftp/python/3.7.0/python-3.7.0.exe){:target="_blank"}

### Часть I - Подготовительные работы

1. Выключите консоль
1. Вставьте карту памяти в ПК
1. Создайте в корне карты памяти папку `sxos`, а в ней папку `titles`
1. Поместите содержимое `zip`-архива с DevMenu в папку `sxos/titles`
	* Если у вас забаненная приставка и выхода в eShop вы не имеете, тогда вам необходима версия DevMenu для Flashback, а так же `.xci` самого Flashback - поместите его в корень вашей карты памяти 

### Часть II - Закачка игр в формате NSP 

Если у вас уже есть все необходимые игры в формате NSP, либо же вы решили скачать их по ссылкам из раздела [Что понадобится](#что-понадобится){:target="_blank"}, то переходите к [следующей части](#часть-iii---установка-игры-в-формате-nsp){:target="_blank"} 

1. Установите Python 3
	* Обязательно отметьте галочкой "Add Python 3.7 to PATH"
1. Перезагрузите ПК
1. Проверьте верно ли установился Python. Для этого в командной строке наберите `py`. Версия должна соответствовать установленной. Если это не так - удалите все установленные версии Python и повторите эту часть с пункта 1
1. Распакуйте `.zip`-архив с программой CDNSP GUI в удобную папку
	* Имейте ввиду, что в эту папку так же будут скачиваться игры, которые занимают порой не мало места. 
1. Распакуйте `.zip`-архив с файлами для CDNSP GUI в папку, в которую вы распаковали саму программу 
1. Откройте коммандную строку от имени администратора 
	* Нажмите `Win+Q` и введите "cmd"
	* Нажмите правой кнопкой мыши на "Командная строка" и выберите "Запуск от имени администратора"
1. С помощью командной строки перейдите в папку с программой CDNSP GUI
	* наберите команду `chdir /d "путь_к_папке_с_программой"`
1. В командной строке наберите `py название_программы.py`
	* На момент написания гайда, самой последней версией программы была 3.4 и строка выглядела так: `py CDNSP-GUI-Bob-v3.4.py`
1. Скрипт начнёт докачивать необходимые для работы файлы
1. В открывшемся окне программы введите название игры
	* В правой части окна можно выбрать что именно качать: 	
		* Base game + Update - выкачать полную версию игры со всеми обновлениями
		* Base game only- выкачать только игру, без обновлений
		* Update only - выкачать только обновления. Позже их можно установить поверх картриджной версии
	* Кнопка Download начнет закачку. Скачанная версия игры в формате `.nps` появится в папке с программой
	* Options -> Update Titlekeys - обновит список игр 

### Часть III - Установка игры в формате NSP

1. Скопируйте скачанную игру в формате `.nps` в корень карты памяти вашей приставки
1. Вставьте карту памяти в консоль и [запустите SX OS](sxos){:target="_blank"}
1. Запустите игру Pokemon Quest, либо XCI-версию игры Flashback, в зависимости от того есть ли у вас eShop или нет
1. Вместо игры откроется DevMenu 
	* Если запускается игра, проверьте все ли верно вы сделали в Часть I. На карте памяти по пути `sxos/titles` должна лежать папка `01005D100807A000`, если у вас eShop и вы запускали devmenu с помощью Pokemon Quest, или папка `01000A0004C50000`, если возможности скачать Pokemon Quest у вас нет, и вы запускаете devmenu через Flashback. В обоих случаях в папках должны быть `exfs` и `romfs`
1. В DevMenu выберите пункт пункт "Install from SD Card"
1. Выберите игру, которую хотите установить и нажмите (A)
	* Если игр несколько - нажмите "Install all"
1. Выберите куда игра будет устанавливаться (рекомендуем выбирать "Auto") и нажмите "Start"
1. После установки игры нажмите (HOME), чтобы вернуться в главное меню приставки
1. Запустите установленную игру