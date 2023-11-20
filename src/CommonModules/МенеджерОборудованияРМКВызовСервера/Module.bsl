
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет рабочее место и необходимость актуализации рабочего места по идентификатору 
//
// Параметры:
//  ИдентификаторРабочегоМеста - Строка - исходные данные для определения результата
//	ИмяКомпьютераРабочегоМеста - Строка - исходные данные для создания нового рабочего места, при необходимости
//
// Возвращаемое значение:
//  Результат - Структура - результат проверки
//		*АктуальноеРабочееМесто - СправочникСсылка.РабочиеМеста
//		*ЗаменитьРабочееМесто - Булево
//
Функция АктуальноеРабочееМестоПользователя(ИдентификаторРабочегоМеста, ИмяКомпьютераРабочегоМеста) Экспорт
	Возврат МенеджерОборудованияРМК.АктуальноеРабочееМестоПользователя(ИдентификаторРабочегоМеста,
		ИмяКомпьютераРабочегоМеста);
КонецФункции

// Переопределяет формируемый шаблон чека.
//
// Параметры:
//  ОбщиеПараметры - Структура - см.ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека().
//  ДополнительныйТекст - Строка - дополнительный текст шаблона чека.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//  ТипОборудования - Строка - типы оборудования строкой.
//
// Возвращаемое Значение:
//  Булево
Функция СформироватьШаблонЧека(ОбщиеПараметры, ДополнительныйТекст, СтандартнаяОбработка,
	ТипОборудования = "") Экспорт
		Возврат МенеджерОборудованияРМК.СформироватьШаблонЧека(ОбщиеПараметры, ДополнительныйТекст, СтандартнаяОбработка,
			ТипОборудования);
КонецФункции

// Возвращает структуру шаблона чека.
//
// Параметры:
//  ПараметрыШаблонаЧека - Структура - исходные данные для формирования структуры чека.
//  ДополнительныйТекст - Строка.
//  ТипОборудования - Строка.
//
// Возвращаемое значение:
//  НовыеПараметрыЧека - Структура, Неопределено - структура шаблона чека.
//
Функция ПолучитьСтруктуруШаблонаЧека(ПараметрыШаблонаЧека, ДополнительныйТекст = "", ТипОборудования = "") Экспорт
	Возврат МенеджерОборудованияРМК.ПолучитьСтруктуруШаблонаЧека(ПараметрыШаблонаЧека,
		ДополнительныйТекст, ТипОборудования);
КонецФункции

#КонецОбласти