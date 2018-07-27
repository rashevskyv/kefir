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
* Свежая версия пейлоада [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"}
* [Модуль](/files/atmos-patched.zip){:target="_blank"} с пропатченной подписью для Atmosphere

# Инструкция

## Подготовительные работы 

1. Выключите Switch и вставьте его карту памяти в ПК 
1. Скопируйте содержимое `.zip`-архива [SDFilesSwitch](https://github.com/tumGER/SDFilesSwitch/releases/latest){:target="_blank"} в корень карты памяти
1. Скопируйте содержимое `.zip`-архива с [модулем](/files/atmos-patched.zip){:target="_blank"} в корень карты памяти
1. Откройте `hekate_ipl.ini` с помощью блокнота
1. Создайте новый блок сразу после блока `[Config]` со следующим содержимым:

	* `[CFW + Sig Patches + Clear Log]`
	* `kip1=modules/nx-dreport.kip`
	* `kip1=modules/oldlayered/loader.kip`
	* `kip1=modules/oldlayered/sm.kip`
	* `kip1=modules/oldlayered/fs_mitm.kip`
	* `kip1=modules/sys-ftpd.kip`
	* `kip1=modules/FS510-exfat_nocmac_nosigchk.kip1`
	* `kip1=FS_510_exfat_nogc.kip1`
	* `atmosphere=1`
	
		![]({{ base_path }}/images/screenshots/hekate_settings_patched.png) 
		{: .text-center}
		{: .notice--info}

	Обратите внимание, в этот конфиг уже добавлен модуль, необходимый вам в случае безопасного обновления с сохранением работоспособности слота для картриджа! Если вы по собственному желанию перемещали его куда-либо, убедитесь, что в конфиге прописан правильный путь!!!
	{: .notice--danger}

1. Вставьте карту памяти обратно в консоль

## Запуск Atmosphere 

1. Запустите пейлоад [hekate](https://github.com/CTCaer/hekate/releases/latest){:target="_blank"} с помощью [Fusée Gelée](fusee-gelee){:target="_blank"}

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