///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
// В разделы необходимо добавить метаданные тех разделов,
// в которых размещены команды вызова.
// Для начальной страницы указать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
//
// Параметры:
//   Разделы - Массив из ОбъектМетаданных - метаданные раздела (подсистемы).
//           - Массив из Строка - для начальной страницы.
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Продажи);
	Разделы.Добавить(Метаданные.Подсистемы.Закупки);
	Разделы.Добавить(Метаданные.Подсистемы.Склад);
	Разделы.Добавить(Метаданные.Подсистемы.Работы);
	Разделы.Добавить(Метаданные.Подсистемы.Производство);
	Разделы.Добавить(Метаданные.Подсистемы.Деньги);
	Разделы.Добавить(Метаданные.Подсистемы.Персонал);
	Разделы.Добавить(Метаданные.Подсистемы.Компания);
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
// В Разделы необходимо добавить метаданные тех разделов, 
// в которых размещены команды вызова.
// Для начальной страницы указать ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы.
//
// Параметры:
//   Разделы - Массив из ОбъектМетаданных - метаданные раздела (подсистемы).
//           - Массив из Строка - для начальной страницы.
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Продажи);
	Разделы.Добавить(Метаданные.Подсистемы.Закупки);
	Разделы.Добавить(Метаданные.Подсистемы.Склад);
	Разделы.Добавить(Метаданные.Подсистемы.Работы);
	Разделы.Добавить(Метаданные.Подсистемы.Производство);
	Разделы.Добавить(Метаданные.Подсистемы.Деньги);
	Разделы.Добавить(Метаданные.Подсистемы.Персонал);
	Разделы.Добавить(Метаданные.Подсистемы.Компания);
	
КонецПроцедуры

#КонецОбласти