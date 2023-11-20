
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.Список.ПодчиненныеЭлементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.ОрганизацияОтбора.Видимость = Ложь;
		
	ИначеЕсли Параметры.Свойство("Отбор") И ТипЗнч(Параметры.Отбор) = Тип("Структура")
		И Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		ОрганизацияОтбора = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
		
		ОтборПоОрганизации = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоОрганизации.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
		ОтборПоОрганизации.ПравоеЗначение = ОрганизацияОтбора;
		ОтборПоОрганизации.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборПоОрганизации.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Завершение обновления"
		ИЛИ ИмяСобытия = "Завершение расшифровки"
		ИЛИ ИмяСобытия = "Завершение групповой отправки"
		ИЛИ ТипЗнч(Источник) <> Тип("ФормаКлиентскогоПриложения")
		И (СтрНайти(ИмяСобытия, "Запись_") > 0
		ИЛИ ИмяСобытия = "Завершение отправки в контролирующий орган"
		ИЛИ ИмяСобытия = "Завершение отправки"
		ИЛИ ИмяСобытия = "Актуализация состояния отправки") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтбораПриИзменении(Элемент)
	
	Если Список.Отбор.Элементы.Количество() = 0 Тогда
		ОтборОрганизация = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Иначе
		ОтборОрганизация = Список.Отбор.Элементы[0]
	КонецЕсли;
	ОтборОрганизация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ОтборОрганизация.ПравоеЗначение = ОрганизацияОтбора;
	ОтборОрганизация.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОрганизация.Использование = ЗначениеЗаполнено(ОрганизацияОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиФНС.Форма.ФормаЗагрузкиИзФайла",,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
