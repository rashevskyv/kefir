---
permalink: /rajnx.html
title: RajNX
author_profile: true
---
{% include toc title="Разделы" %}

RajNX - бесплатная модульная кастомная прошивка. В качестве основного отличия можно выделить перехватчик логов, который складывает их на карту памяти, вместо того, чтобы отправлять в Nintendo            
[Подробнее про RajNX...](launch-cfw#rajnx){:target="_blank"}

{% include inc/launch_cfw.txt
 
	cfw="RajNX" 

	hekname='More configs... -> RajNX**
1. Вы увидите загрузчик RajNX, который лишь в мелочах внешне отличается от hekate. Выберите "**Launche firmware -> RajNX**"
	* Если вы делали безопасное обновление прошивки с прошивки ниже, чем 4.0.0, то выберите прошивку с приставкой **... with nogc patch**
	* Если вы планируете использовать пользовательские модификации, выбирите прошивку с "**LayeredFS**"

Обратите внимание, что при выборе прошивки с приставкой **... with nogc patch** у вас перестанет работать слот картриджа на прошивке 5.1.0. Это не ошибка, это сделано намеренно, чтобы не дать прошивке слота вашего картриджа обновиться! Выбирайте **RajNX**, если вам нужен рабочий слот и вы не делали безопасного обновления с прошивки ниже, чем 4.0.0!
{: .notice--warning}' 
	
	payload_name='`payload.bin`'

	autoboot ='**More configs... -> RajNX**"
1. Попав в загрузчик RajNX, выберите "**Launch options -> Autoboot -> RajNX**", или любую другую, как вы делали ранее, при запуске прошивки'
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