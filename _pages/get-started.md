---
permalink: /get-started.html
title: Начнём
author_profile: true
---
{% include toc title="Разделы" %}

## Проверка консоли на наличие уязвимости Fusée Gelée

{% include /inc/checker.txt %}

## Блокировка обновлений

Удалите все активные точки доступа на вашей консоли

1. Включите приставку и перейдите в "**Системные настройки**" -> "**Интернет**" -> "**Интернет-настройки**"
1. Нажмите на каждую точку доступа в разделе "**Зарегистрированные сети**" и выберите "**Удалить настройки**" -> "**Удалить**"

<!--1. Включите приставку и перейдите в "**Системные настройки**" -> "**Интернет**" -> "**Интернет-настройки**"
1. Подключитесь к вашей WiFi-сети 
1. После успешного подключения снова перейдите в "**Интернет-настройки**" и выберите вашу WiFi-сеть 
1. Выберите "**Изменить настройки**" -> "**Настройки DNS**" -> "**Ручной ввод**"
1. В поле "**Первичный DNS**" введите `163.172.141.219`
1. В поле "**Вторичный DNS**" введите `45.248.48.62` и нажмите "**Сохранить**", а затем OK
1. Выберите "**Подключиться к этой сети**", после проверки нажмите ОК-->

## Выберите прошивку

Версию прошивки можно посмотреть в меню "Системные настройки", "Система"
{: .notice--success}

![]({{ base_path }}/images/screenshots/system-version.jpg) 
{: .text-center}
{: .notice--info}

Если версия прошивки не отображается и Switch пишет, что он готов к обновлению, выключите консоль, достаньте картридж, зажмите (vol+) + (vol-) и не отпуская кнопки громкости, включите приставку. Вы попадёте в меню восстановления в котором будет отображаться текущая версия прошивки. После перезагрузки приставки скачанное обновление удалиться. 
{: .notice--warning}

Выберите в таблице версию прошивки, соответствующую вашей. 

<table>
  <colgroup>
    <col span="1" style="width: 10%;">
    <col span="1" style="width: 10%;">
    <col span="1" style="width: 80%;">
  </colgroup>
  <thead>
    <tr>
      <th style="text-align: center">От</th>
      <th style="text-align: center">До</th>
      <th style="text-align: center">Способ</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center; font-weight: bold;">1.0.0</td>
      <td style="text-align: center; font-weight: bold;">6.0.0</td>
      <td style="text-align: center; font-weight: bold;"><a href="update-to-latest">Обновление до {% include /vars/sys_version.txt %}</a></td>
    </tr>
    <tr>
      <td style="text-align: center; font-weight: bold;" colspan="2">{% include /vars/sys_version.txt %}</td>
      <td style="text-align: center; font-weight: bold;"><a href="launch-cfw">Запуск кастомной прошивки</a></td>
    </tr>
    <tr>
      <td style="text-align: center; font-weight: bold;" colspan="2">6.2 и выше</td>
      <td style="text-align: center; font-weight: bold;">Взлом невозможен</td>
    </tr>
  </tbody>
</table>