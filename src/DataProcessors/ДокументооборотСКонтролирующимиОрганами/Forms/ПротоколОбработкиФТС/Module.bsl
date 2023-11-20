#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипИсточника = ТипЗнч(Параметры.ИсточникСсылка);
	
	Если ТипИсточника = Тип("СправочникСсылка.ОтправкиФТС") Тогда
		HTMLТекст = Параметры.ИсточникСсылка.Протокол.Получить();
	Иначе //РегламентированныйОтчет или ЭлектронноеПредставление
		КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		ПоследняяОтправкаСсылка = КонтекстЭДО.ПолучитьПоследнююОтправкуОтчетаВФТС(Параметры.ИсточникСсылка);
		Если ПоследняяОтправкаСсылка<> Неопределено Тогда
			HTMLТекст = ПоследняяОтправкаСсылка.Протокол.Получить();
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.ИсточникСсылка.НаКонтроле Тогда
		Заголовок = НСтр("ru = 'Протокол'");
	ИначеЕсли Параметры.ИсточникСсылка.СтатусОтправки = Перечисления.СтатусыОтправки.Сдан Тогда
		Заголовок = НСтр("ru = 'Протокол о сдаче'");
	ИначеЕсли Параметры.ИсточникСсылка.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
		Заголовок = НСтр("ru = 'Протокол ошибок'");
	Иначе
		Заголовок = НСтр("ru = 'Протокол'");
	КонецЕсли;
	
	Элементы.КнопкаПечать.Видимость = Параметры.Свойство("ПечатьВозможна") И Параметры.ПечатьВозможна = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Ссылка = Неопределено;
	Попытка
		Ссылка = СокрЛП(нрег(ДанныеСобытия.Element.innerText));
		Если Лев(Ссылка, 7) <> "http://" И Лев(Ссылка, 8) <> "https://" Тогда
			Ссылка = Неопределено;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПерейтиПоНавигационнойСсылке(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Элементы.HTMLТекст.Документ.execCommand("Print");
	
КонецПроцедуры

#КонецОбласти