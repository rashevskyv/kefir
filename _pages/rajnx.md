---
permalink: /rajnx.html
title: RajNX
author_profile: true
---
{% include toc title="Разделы" %}

RajNX - бесплатная модульная кастомная прошивка. В качестве основного отличия можно выделить перехватчик логов, который складывает их на карту памяти, вместо того, чтобы отправлять в Nintendo. 

[Подробнее про RajNX](launch-cfw#rajnx){:target="_blank"}

{% include inc/launch_cfw.txt
 
	cfw="RajNX" 

	hekname="RajNX**
	* Если вы делали безопасное обновление прошивки с прошивки ниже, чем 4.0.0, то выберите **RajNX with nogc patch**

Обратите внимание, что при выборе **RajNX with nogc patch** у вас перестанет работать слот картриджа на прошивке 5.1.0. Это не ошибка, это сделано намеренно, чтобы не дать прошивке слота вашего картриджа обновиться! Выбирайте **RajNX**, если вам нужен рабочий слот и вы не делали безопасного обновления с прошивки ниже, чем 4.0.0!
{: .notice--warning}" 
	
	payload_name='`hekate.bin`'

	if_hekate='	* Для перемещения по меню, hekata используйте клавиши (VOL-) и (VOL+), для выбора - (POWER)'
	
	autoboot ='**RajNX**" (или "**RajNX with nogc patch**", если вы хотите сберечь слот, что актуально только для тех, кто делал [безопасное обновление](update-to-latest){:target="_blank"} с прошивки ниже, чем 4.0.0)'
%}
	

___

# [Запуск Homebrew Launcher](launch-hbl#запуск-hbl-из-reinx-или-atmosphere)
{: .notice--success}
# [Запуск игр](games)
{: .notice--success}
# [Полезные инструкции](addons)
{: .notice--success}
# [Активация AutoRCM](autorcm)
{: .notice--success}