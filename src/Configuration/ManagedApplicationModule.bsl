///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

// ИнтеграцияГОСИС
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт;
Перем глПодключаемоеОборудованиеСобытиеОбработаноДанные Экспорт; // для предотвращения повторной обработки события
// Конец ИнтеграцияГОСИС

// ЭлектронноеВзаимодействие
Перем ПараметрыПодсистемыОбменСБанками Экспорт;
// При соответствующих настройках сертификата ЭП в соответствии будут храниться пары Сертификат-Пароль (в данном сеансе)
Перем СоответствиеСертификатаИПароля Экспорт;
// Конец ЭлектронноеВзаимодействие

// ТехнологияСервиса
Перем ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса Экспорт;
// Конец ТехнологияСервиса

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// МобильныйКлиент
	МобильныйКлиентУНФКлиент.ПередНачаломРаботыСистемы();
	// Конец МобильныйКлиент
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЗапускПриложения");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ОбщегоНазначенияРМККлиент.ПриНачалеРаботыСистемы();
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
			Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора,
		Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	
	// ИнтеграцияГОСИС
	Если глПодключаемоеОборудованиеСобытиеОбработаноДанные <> Неопределено
		И глПодключаемоеОборудованиеСобытиеОбработаноДанные[Данные] <> Неопределено Тогда
		глПодключаемоеОборудованиеСобытиеОбработаноДанные.Удалить(Данные);
		Возврат;
	КонецЕсли;
	// Конец ИнтеграцияГОСИС
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ПриГлобальномПоиске(СтрокаПоиска, ПланПоиска)
	
	ГлобальныйПоискКлиент.ПриГлобальномПоиске(СтрокаПоиска, ПланПоиска);
	
КонецПроцедуры

Процедура ПриВыбореРезультатаГлобальногоПоиска(ЭлементРезультата, СтандартнаяОбработка)
	
	ГлобальныйПоискКлиент.ПриВыбореРезультатаГлобальногоПоиска(ЭлементРезультата, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

// ИнтеграцияГОСИС
глПодключаемоеОборудованиеСобытиеОбработано = Истина;
// Конец ИнтеграцияГОСИС

#КонецОбласти
