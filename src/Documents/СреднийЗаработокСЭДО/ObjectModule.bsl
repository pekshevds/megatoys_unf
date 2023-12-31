#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	ДействияПередЗаписью();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПередЗаписью

Процедура ДействияПередЗаписью() Экспорт
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата(); // АПК:143 Для фильтрации событий в журнале регистрации требуется дата сервера.
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли