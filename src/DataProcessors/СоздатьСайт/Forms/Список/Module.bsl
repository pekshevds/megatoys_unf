#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстСтраницы = "
	|<html>
	|<head>
	|<meta http-equiv=Content-Type content=""text/html; charset=windows-1251"">
	|<style>
	|html { overflow:  auto; }
	|</style>
	|</head>
	|<body>
	|<div>
	|<table border=0 cellspacing=0 cellpadding=0 width=""80%""
	|style='border-collapse:collapse'>
	
	|<tr>
	|<td width=""25%"">
	|<p  align=center style='text-align:center'><span
	|style='font-size:16pt'></span></p>
	|</td>
	|<td width=""50%"">
	|<p  align=center style='text-align:center'><span
	|style='font-size:16pt'>Сайт</span></p>
	|</td>
	|<td width=""25%"">
	|<p  align=center style='text-align:center'><span
	|style='font-size:16pt'></span></p>
	|</td>
	|</tr>
	|";
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСайта.Организация,
	|	ДанныеСайта.АдресСайта КАК АдресСайта,
	|	ДанныеСайта.IDСайта,
	|	ДанныеСайта.EMail,
	|	ДанныеСайта.ПарольСайта,
	|	ДанныеСайта.ТипСайта,
	|	ДанныеСайта.URLАдминЗоны,
	|	ДанныеСайта.СайтСоздан
	|ИЗ
	|	РегистрСведений.ДанныеСайта КАК ДанныеСайта
	|ГДЕ
	|	ДанныеСайта.СайтСоздан";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Если Выборка.ТипСайта = 4 Тогда
			НадписьТипСайта = НСтр("ru = 'Интернет-магазин'");
		ИначеЕсли Выборка.ТипСайта = 3 Тогда
			НадписьТипСайта = НСтр("ru = 'Сайт компании'");
		ИначеЕсли Выборка.ТипСайта = 2 Тогда
			НадписьТипСайта = НСтр("ru = 'Лендинг'");
		ИначеЕсли Выборка.ТипСайта = 1 Тогда			
			НадписьТипСайта = НСтр("ru = 'Сайт специалиста'");
		КонецЕсли;
		
		ТекстСтраницы = ТекстСтраницы + "
		|<tr>
		|<td height=40 width=""25%"" style='width:25%;padding:0cm 5pt 0cm 5pt'>
		|<p><span style='font-size:12pt'>"+НадписьТипСайта+"</span></p>
		|</td>
		|<td height=40 width=""50%"" style='width:50%;padding:0cm 5pt 0cm 5pt'>
		|<p  align=center style='text-align:center'>
		|<a  href="""+"http://"+Выборка.АдресСайта+""">"+СокрЛП(Выборка.АдресСайта)+"</a></p>
		|</td>
		|<td height=40 width=""25%"" style='width:25%;padding:0cm 5pt 0cm 5pt'>
		|<p  align=center style='text-align:center'>
		|<a  href="""+Выборка.URLАдминЗоны+""">Открыть админзону</a></p>
		|</td>
		|</tr>
		|";

	КонецЦикла;
	
	ТекстСтраницы = ТекстСтраницы + "
	|</table>
	|<p><o:p>&nbsp;</p>
	|<p><o:p>&nbsp;</p>
	|</div>
	|</body>
	|</html>";
	
	СтраницаТипыСайтов = ТекстСтраницы;
	
	ПолеМетки = ЭтотОбъект.Элементы.Добавить("ОткрытьСписок", Тип("ДекорацияФормы"));
	ПолеМетки.Заголовок = НСтр("ru = 'Редактировать данные сайтов'");
	ПолеМетки.РастягиватьПоГоризонтали = Истина;
	ПолеМетки.УстановитьДействие("Нажатие", "Подключаемый_ОткрытьСписок");
	
	ПолеМетки.Гиперссылка = Истина;
	Шрифт = Новый Шрифт(ПолеМетки.Шрифт,, 10);
	ПолеМетки.Шрифт = Шрифт;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОткрытьСписок(Элемент)
	
	ОткрытьФорму("РегистрСведений.ДанныеСайта.ФормаСписка");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СравнениеТиповСайтовПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ДанныеСобытия) И ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДанныеСобытия.Href);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
