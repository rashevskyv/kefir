---
permalink: /get-started.html
title: Начнём
author_profile: true
---
{% include toc title="Разделы" %}

Выберите в таблице версию прошивки, соответствующую вашей. 

Версию прошивки можно посмотреть в меню "Системные настройки", "Система"
{: .notice--success}

Если версия прошивки не отображается и Switch пишет, что он готов к обновлению, выключите консоль, достаньте картридж, зажмите (vol+) + (vol-) и не отпуская кнопки громкости, включите приставку. Вы попадёте в меню восстановления в котором будет отображаться текущая версия прошивки. После перезагрузки приставки скачанное обновление удалиться. 
{: .notice--warning}

![]({{ base_path }}/images/screenshots/system-version.jpg) 
{: .text-center}
{: .notice--info}

## Блокировка доступа к сервисам Nintendo

Наиболее простым способом не получить бан является полное отключение консоли от сети интернет путём удаления точки доступа. Однако, если вам все-таки нужно активное WiFi-соединение, но без доступа к сервисам Nintendo, можно организовать подключение к сети через DNS-сервера, которые блокируют доступ Switch к сервисам Nintendo. Но я бы не надеялся на то, что это обезопасит от бана на 100%. Повысит вероятность не попасть в бан, разве что 
{: .notice--info}

1. Включите приставку и перейдите в "**Системные настройки**" -> "**Интернет**" -> "**Интернет-настройки**"
1. Подключитесь к вашей WiFi-сети 
1. После успешного подключения снова перейдите в "**Интернет-настройки**" и выберите вашу WiFi-сеть 
1. Выберите "**Изменить настройки**" -> "**Настройки DNS**" -> "**Ручной ввод**"
1. В поле "**Первичный DNS**" введите `163.172.141.219`
1. В поле "**Первичный DNS**" введите `45.248.48.62` и нажмите "**Сохранить**", а затем OK
1. Выберите "**Подключиться к этой сети**", после проверки нажмите ОК

## Выберите прошивку

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
      <td style="text-align: center; font-weight: bold;">5.1.0</td>
      <td style="text-align: center; font-weight: bold;"><a href="update-to-latest">Обновление до {% include /vars/sys_version.txt %}</a></td>
    </tr>
    <tr>
      <td style="text-align: center; font-weight: bold;" colspan="2">{% include /vars/sys_version.txt %}</td>
      <td style="text-align: center; font-weight: bold;"><a href="launch-cfw">Запуск кастомной прошивки</a></td>
    </tr>
  </tbody>
</table>