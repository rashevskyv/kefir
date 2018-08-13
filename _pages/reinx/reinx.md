---
permalink: /reinx.html
title: ReiNX
author_profile: true
---
{% include toc title="Разделы" %}

ReiNX - бесплатная модульная кастомная прошивка. Поддерживает RomMenu, идентичный такому же из SX OS, но не умеет монтировать XCI 

[Подробнее про ReiNX](launch-cfw#reinx){:target="_blank"}

# Что понадобится 

* Умение [вводить консоль в режим восстановления (RCM)](fusee-gelee#%D1%87%D0%B0%D1%81%D1%82%D1%8C-i---%D0%B2%D1%85%D0%BE%D0%B4-%D0%B2-rcm){:target="_blank"}
* Свежая версия [SDFiles от VK:3ds_cfw](https://github.com/rashevskyv/switch/releases/latest){:target="_blank"}

# Инструкция

### Подготовительные работы 

1. Выключите Switch и вставьте его карту памяти в ПК 
1. Скопируйте содержимое `.zip`-архива [SDFiles от VK:3ds_cfw](https://github.com/rashevskyv/switch/releases/latest){:target="_blank"} в корень карты памяти с заменой
	* Помните, что это действие перезапишет ваш конфиг. Если вы изменяли его - не забудьте внести изменения в новый конфиг! 
1. `ReiNX.bin` из `.zip`-архива [SDFiles от VK:3ds_cfw](https://github.com/rashevskyv/switch/releases/latest){:target="_blank"} - это пейлоад, который вы будете запускать для запуска прошивки с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}. Скопируйте его на ПК.
1. Вставьте карту в консоль

### Запуск {{ include.cfw }}

1. Запустите пейлоад `ReiNX.bin` с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

Обратите внимание, что по-умолчанию у вас перестанет работать слот картриджа на прошивке 5.1.0. Это не ошибка, это сделано намеренно, чтобы не дать прошивке слота вашего картриджа обновиться! Для того, чтобы он вновь заработал, удалите файл `nogc` из папки ReiNX на карте памяти
{: .notice--warning}

Если после запуска приставка не видит карту и требует обновить прошивку для её работы - вам нужно установить драйвера exFAT, [обновив прошивку следующим образом](update-to-latest){:target="_blank"}! Даже если у вас уже установлена последняя прошивка, но нет драйверов exFAT, обновите приставку указанным образом, либо официально через настройки! Помните, что если вы обновлялись до последней версии с помощью [безопасного обновления](update-to-latest){:target="_blank"}, обновление через настройки [сожжёт предохранители](update-to-latest#теоретическая-часть){:target="_blank"}! 
{: .notice--warning}
	
___

# [Запуск Homebrew Launcher](launch-hbl#запуск-hbl-из-reinx-или-atmosphere)
{: .notice--success}
# [Запуск игр](reinx-games)
{: .notice--success}
# [Полезные инструкции](addons)
{: .notice--success}
# [Активация AutoRCM](autorcm)
{: .notice--success}