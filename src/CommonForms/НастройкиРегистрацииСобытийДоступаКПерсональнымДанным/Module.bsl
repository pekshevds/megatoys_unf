///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗащитаПерсональныхДанных.ПриСозданииФормыНастройкиРегистрацииСобытий(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКатегорииПерсональныхДанных

&НаКлиенте
Процедура Подключаемый_ПриИзмененииКатегорииПерсональныхДанныхИспользование(Элемент)
	
	ДанныеТекущейСтроки = ЭтотОбъект.КатегорииПерсональныхДанных.НайтиПоИдентификатору(
		Элементы.КатегорииПерсональныхДанных.ТекущаяСтрока);
	
	ПодчиненныеСтроки = ДанныеТекущейСтроки.ПолучитьЭлементы();
	Если ПодчиненныеСтроки.Количество() > 0 Тогда
		Для Каждого СтрокаДерева Из ПодчиненныеСтроки Цикл
			СтрокаДерева.Использование = ДанныеТекущейСтроки.Использование;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	ЗащитаПерсональныхДанных.ПриЗаписиФормыНастройкиРегистрацииСобытий(ЭтотОбъект);
	Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьНаСервере();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
