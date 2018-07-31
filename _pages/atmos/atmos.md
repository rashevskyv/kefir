---
permalink: /atmos.html
title: Запуск Atmosphere
author_profile: true
---
{% include toc title="Разделы" %}

Хоть в текущем виде эту CFW и не следовало бы называть Atmosphere, для удобства мы будем продолжать это делать. В данный момент это скорее официальная прошивка с запущенными модулями от Atmosphere

[Подробнее про Atmosphere](launch-cfw#atmosphere){:target="_blank"}

# Что понадобится 

* [Установленный и рабочий HBL](launch-hbl#подготовительные-работы){:target="_blank"}
* Умение [вводить консоль в режим восстановления (RCM)](fusee-gelee#%D1%87%D0%B0%D1%81%D1%82%D1%8C-i---%D0%B2%D1%85%D0%BE%D0%B4-%D0%B2-rcm){:target="_blank"}
* [Изменённый модуль es-sysmodule](files/es-sysmodule.zip){:target="_blank"}
* Свежая версия пейлоада {% include inc/hekate.txt %}

# Инструкция

## Подготовительные работы 

1. Выключите Switch и вставьте его карту памяти в ПК 
1. Скопируйте содержимое `.zip`-архива [SDFilesSwitch](https://github.com/tumGER/SDFilesSwitch/releases/latest){:target="_blank"} в корень карты памяти
1. Скопируйте содержимое `.zip`-архива [с изменённым модулем es-sysmodule](files/es-sysmodule.zip){:target="_blank"} в корень карты памяти
	* Проверьте, что в папке `atmosphere/titles` есть папка `0100000000000033`
1. Откройте `hekate_ipl.ini` с помощью блокнота
1. Создайте новый блок сразу после блока `[Config]` со следующим содержимым, затем вставьте карту обратно в консоль:

{% highlight markdown %}

[CFW + Sig Patches + Clear Log]
kip1=modules/nx-dreport.kip
kip1=modules/oldlayered/loader.kip
kip1=modules/oldlayered/sm.kip
kip1=modules/oldlayered/fs_mitm.kip
kip1patch=nogc,nosigchk
atmosphere=1
{% endhighlight %}
	
![]({{ base_path }}/images/screenshots/hekate_settings_patched.png) 
{: .text-center}
{: .notice--info}

Если у вас перестал работать слот для картриджей на прошивке 5.1.0, замените строку `kip1patch=nogc,nosigchk` на `kip1patch=nosigchk`
{: .notice--danger}

## Запуск Atmosphere 

1. Запустите пейлоад {% include inc/hekate.txt %} с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

	Для перемещения по меню, hekata используйте клавиши (VOL-) и (VOL+), для выбора - (POWER)
	{: .notice--info}
	
1. На экране приставки выберите "Launch firmware" -> "CFW + Sig Patches + Clear Log"

___

# [Запуск Homebrew Launcher](launch-hbl#запуск-hbl-из-reinx-или-atmosphere)
{: .notice--success}
# [Запуск игр](atmos-games)
{: .notice--success}
# [Полезные инструкции](addons)
{: .notice--success}
# [Активация AutoRCM](autorcm)
{: .notice--success}