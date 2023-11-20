#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// ЗарплатаКадры

// см. ЗарплатаКадры.РегистрацияВНалоговомОрганеПодразделения();
Функция РегистрацияВНалоговомОргане(ПодразделениеОрганизации, Знач ДатаАктуальности = Неопределено) Экспорт
	
	Возврат ЗарплатаКадры.РегистрацияВНалоговомОрганеПодразделения(ПодразделениеОрганизации, ДатаАктуальности);
	
КонецФункции

// см. ПодразделенияОрганизацийБЗК.ПодчиненныеСтруктурныеЕдиницы()
Функция ПодчиненныеСтруктурныеЕдиницы(СтруктурнаяЕдиница) Экспорт
	
	Возврат ПодразделенияОрганизацийБЗК.ПодчиненныеСтруктурныеЕдиницы(СтруктурнаяЕдиница);
	
КонецФункции

// см. ПодразделенияОрганизацийБЗК.ТекстЗапросаСравненияНаборовСтруктурныхЕдиниц();
Функция ТекстЗапросаСравненияНаборовСтруктурныхЕдиниц(ИмяРегистра, ИмяРеквизита) Экспорт
	
	Возврат ПодразделенияОрганизацийБЗК.ТекстЗапросаСравненияНаборовСтруктурныхЕдиниц(ИмяРегистра, ИмяРеквизита);
	
КонецФункции

// Конец ЗарплатаКадры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ЗаполнитьРеквизитыИзПотребителя.
Процедура ЗаполнитьРеквизитыОбъектаДокументооборота(Прокси, ОбъектXDTO, СсылкаНаПотребитель) Экспорт
	
	Если Не ТипЗнч(СсылкаНаПотребитель) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
		"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
	Если ТипЗнч(ОбъектXDTO) = Тип("ОбъектXDTO")
			И МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, ОбъектXDTO, "DMSubdivision") Тогда
		ИнтеграцияС1СДокументооборотБЗК.ЗаполнитьРуководителяПодразделения(Прокси, ОбъектXDTO, СсылкаНаПотребитель);
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриСозданииПоСсылке.
Процедура ПриСозданииПоСсылке(ОбъектИС, ОбъектXDTO, ЗаполняемыйОбъектИС) Экспорт
	
	Если ТипЗнч(ОбъектИС) <> Тип("СправочникОбъект.ПодразделенияОрганизаций")
			Или ЗаполняемыйОбъектИС = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", ЗаполняемыйОбъектИС.Метаданные())
			И ЗначениеЗаполнено(ЗаполняемыйОбъектИС.Организация) Тогда
		ОбъектИС.Владелец = ЗаполняемыйОбъектИС.Организация;
	Иначе
		ОбъектИС.Владелец = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнитьСоответствиеТипов.
Процедура ДополнитьСоответствиеТипов(Таблица) Экспорт
	
	МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
		"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
	
	МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(
		Таблица, "DMSubdivision", Тип("СправочникСсылка.ПодразделенияОрганизаций"));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
