---
permalink: /autorcm.html
title: AutoRCM
author_profile: true
---
{% include toc title="Разделы" %}

AutoRCM - на консоли специальным образом изменяется загрузочный сектор, вследствие чего консоль не может загрузиться прямо в систему и загружается автоматически в режим RCM. Достаточно просто включить консоли и она автоматически попадёт в режим восстановления. Не нужно зажимать комбинацию кнопок и использовать замыкатель, но пейлоад для запуска прошивки всё равно передавать нужно!
{: .notice--info}

Если вы используете [Caffeine](caffeine){:target="_blank"}, то вам **ни в коем случае** нельзя использовать AutoRCM! Иначе приставка превратится в кирпич! При любых подозрениях на включенный AutoRCM, удалите его по этой инструкции!
{: .notice--danger}

# Что понадобится

* Умение [запускать пейлоады через Fusée Gelée](fusee-gelee){:target="_blank"}

# Рекомендуемый способ 

## Установка AutoRCM

{% include inc/launch-hekate.txt %}
1. Перейдите в раздел "**Tools**" -> "**Archive bit - AutoRCM**" (внизу экрана) и установите "**AutoRCM**" в положение "**ON**"
1. Нажмите "**Home**" вверху экрана
1. [Запустите {% include abbr/cfw.txt abbr="кастомную прошивку" %}](cfw) 

___

[Закрыть страницу](javascript:window.close();)
{: .notice--success}

## Отключение AutoRCM 

{% include inc/launch-hekate.txt %}
1. Перейдите в раздел "**Tools**" -> "**Archive bit - AutoRCM**" (внизу экрана) и установите "**AutoRCM**" в положение "**OFF**"
1. Нажмите "**Home**" вверху экрана
1. [Запустите {% include abbr/cfw.txt abbr="кастомную прошивку" %}](cfw) 

___

[Закрыть страницу](javascript:window.close();)
{: .notice--success}

# SX OS

В SX OS есть встроенный механизм активации AutoRCM через меню загрузчика, однако я все же рекомендую использовать для этого bricmii
	
## Установка AutoRCM

1. Запустите SX OS
1. При появлении заставки зажмите и удерживайте (VOL+)
1. Перейдите в "**Options**" -> "**Install AutoRCM**" -> "**Continue**"
1. Нажмите "**Back**" дважды, чтобы вернуться в главное меню и выберите "Boot custom FW" для запуска SX OS

После активации AutoRCM при наличии {% include abbr/dongle.txt abbr="донгла" %} система сразу будет грузиться в SX OS, если донгла нет, то нужно будет посылать [загрузчик SX OS](https://sx.xecuter.com/download/payload.bin){:target="_blank"} с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

___

[Закрыть страницу](javascript:window.close();)
{: .notice--success}

## Удаление AutoRCM 

Категорически не рекомендуется удалять AutoRCM, если вы делали [безопасное обновление системы](update-to-latest){:target="_blank"} - [сожжёте предохранители](update-to-latest#%D1%82%D0%B5%D0%BE%D1%80%D0%B5%D1%82%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F-%D1%87%D0%B0%D1%81%D1%82%D1%8C){:target="_blank"}

1. Запустите SX OS
1. При появлении заставки зажмите и удерживайте (VOL+)
1. Перейдите в "Options" -> "Uninstall AutoRCM" -> "Continue"
1. Нажмите "Back" дважды, чтобы вернуться в главное меню и выберите "Boot custom FW" для запуска SX OS

___

[Закрыть страницу](javascript:window.close();)
{: .notice--success}