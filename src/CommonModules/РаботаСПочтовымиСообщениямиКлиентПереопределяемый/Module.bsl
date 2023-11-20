///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается перед открытием формы нового письма.
// Открытие формы может быть отменено изменением параметра СтандартнаяОбработка.
//
// Параметры:
//  ПараметрыОтправки    - см. РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма
//  ОбработчикЗавершения - ОписаниеОповещения - описание процедуры, которая будет вызвана после завершения
//                                              отправки письма.
//  СтандартнаяОбработка - Булево - признак продолжения открытия формы нового письма после выхода из этой
//                                  процедуры. Если установить Ложь, форма письма открыта не будет.
//
Процедура ПередОткрытиемФормыОтправкиПисьма(ПараметрыОтправки, ОбработчикЗавершения, СтандартнаяОбработка) Экспорт
	
	Если НЕ ЭлектроннаяПочтаУНФВызовСервера.ИспользуетсяРаботаССобытиями() Тогда
		ПривестиПредставлениеПолучателейКСтроке(ПараметрыОтправки);
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПараметрыОтправки.Свойство("ПолучателиВыбраныИнтерактивно") Тогда
		ПараметрыОтправки.Вставить("ПолучателиВыбраныИнтерактивно", Ложь);
		ПараметрыОтправки.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
		Если НЕ ПараметрыОтправки.Свойство("Шаблон") Тогда
			ПараметрыОтправки.ПолучателиВыбраныИнтерактивно = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыОтправки.ПолучателиВыбраныИнтерактивно Тогда
		ОткрытьФормуОтправкиПочтовогоСообщения(ПараметрыОтправки.Получатель, ПараметрыОтправки);
		Возврат;
	КонецЕсли;
	
	Получатель = ЭлектроннаяПочтаУНФВызовСервера.ПодготовленныеЭлектронныеАдресаПолучателей(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыОтправки.Предмет));
		
	Если Получатель.Количество() <= 1 Тогда
		ОткрытьФормуОтправкиПочтовогоСообщения(Получатель, ПараметрыОтправки);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Получатели", Получатель);
	ПараметрыФормы.Вставить("НеВыбиратьФорматВложений", Истина);
	
	ПараметрыОтправки.ПолучателиВыбраныИнтерактивно = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораПолучателей", РаботаСПочтовымиСообщениямиКлиентПереопределяемый, ПараметрыОтправки);
	
	ОткрытьФорму("ОбщаяФорма.ПодготовкаНовогоПисьма", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПослеВыбораПолучателей(Результат, ПараметрыОтправки) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуОтправкиПочтовогоСообщения(Результат.Получатели, ПараметрыОтправки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПривестиПредставлениеПолучателейКСтроке(ПараметрыОтправки)
	
	Если НЕ ПараметрыОтправки.Свойство("Получатель") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОтправки.Получатель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Получатель Из ПараметрыОтправки.Получатель Цикл
		Если ТипЗнч(Получатель.Представление) <> Тип("Строка") Тогда
			Получатель.Представление = Строка(Получатель.Представление);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОткрытьФормуОтправкиПочтовогоСообщения(Получатель, ПараметрыОтправки)
	Перем Отправитель, Вложения, Тема, Текст, УдалятьФайлыПослеОтправки, ДокументыОснования;
	
	ПараметрыОтправки.Свойство("Отправитель", Отправитель);
	ПараметрыОтправки.Свойство("Тема", Тема);
	ПараметрыОтправки.Свойство("Текст", Текст);
	ПараметрыОтправки.Свойство("Вложения", Вложения);
	ПараметрыОтправки.Свойство("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	ПараметрыОтправки.Свойство("ДокументыОснования", ДокументыОснования);
	
	Если ПараметрыОтправки.Свойство("Предмет") И ЗначениеЗаполнено(ПараметрыОтправки.Предмет) Тогда
		ДокументыОснования = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыОтправки.Предмет);
	КонецЕсли;
	
	ОбработчикЗавершения = Неопределено;
	ПараметрыОтправки.Свойство("ОбработчикЗавершения", ОбработчикЗавершения);
	
	// Используем форму документа Событие с типом "Электронное письмо".
	УправлениеНебольшойФирмойКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(Отправитель, Получатель,
		Тема, Текст, Вложения, ДокументыОснования, УдалятьФайлыПослеОтправки, ОбработчикЗавершения);
	
КонецПроцедуры

#КонецОбласти
