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

В данный момент времени не известно какие данные и куда консоль отправляет, когда она подключена по интернету. Именно поэтому наиболее безопасным способом блокировки телеметрии есть полное отключение интернета на приставке. Ни ввод DNS, ни введение консоли в режим полёта, а именно удаление всех точек доступа на приставке и полная изоляция её от подключения к сети интернет. При первом же подключении все собранные данные будут отправлены на сервера Nintendo. Чем это будет грозить вам в будущем - неизвестно. Наиболее вероятно, что баном!
{: .notice--danger}

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