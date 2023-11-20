///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОФДКлиент".
// ОбщийМодуль.ОФДКлиент.
//
// Клиентские процедуры настройки использования интеграции ОФД:
//  - открытие форм настроек подключения к ОФД.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет доступность использования функциональности настройки подключения 
// и параметров кассы на основании прав доступа пользователя.
//
// Возвращаемое значение:
//  Булево - если Истина, настройка подключения доступна.
//
Функция НастройкаПодключенияДоступна() Экспорт
	
	Возврат ОФДВызовСервера.НастройкаПодключенияДоступна();
	
КонецФункции

// Открывает форму настройки подключения к ОФД.
//
// Параметры:
//  НастройкиПодключения - Структура - параметры настройки подключения к ОФД:
//    * Касса - ОпределяемыйТип.КассаОФДБИП - Касса для которой выполняется настройка параметров подключения.
//  ОписаниеОповещения - ОписаниеОповещения, Неопределено - оповещение, которое
//    необходимо вызвать после завершения работы с параметрами подключения.
//
Процедура ПараметрыПодключения(
		НастройкиПодключения,
		ОписаниеОповещения = Неопределено) Экспорт
		
	Если НастройкаПодключенияДоступна() Тогда
		
		ОткрытьФорму(
			"Обработка.ПодключениеКОФД.Форма.НастройкаПараметровКассы",
			НастройкиПодключения,
			,
			,
			,
			,
			ОписаниеОповещения);
			
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'У пользователя недостаточно прав для выполнения настройки.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодключениеКОФД

// Открывает форму настройки подключения к ОФД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения, Неопределено - оповещение, которое
//    необходимо вызвать после завершения настройки подключения. В случае успешного
//    завершения настройки подключения в результате оповещения будет возвращено Истина;
//
Процедура СлужебнаяПодключитьОФД(ОписаниеОповещения = Неопределено) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПодключениеКОФД.Форма.НастройкаПодключения",
		,
		,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыФункции

// Открывает форму журнала регистрации с отбором
// по событию см. ИмяСобытияЖурналаРегистрации.
//
Процедура ОткрытьЖурналРегистрации() Экспорт
	
	Если Не ОФДВызовСервера.ЭтоПолноправныйПользователь() Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Недостаточно прав доступа для просмотра журнала регистрации.'"));
		
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", ИмяСобытияЖурналаРегистрации());
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	
КонецПроцедуры

// Возвращает имя события для журнала регистрации, которое используется
// для записи событий загрузки данных из внешних систем.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'ОФД'",
		ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#КонецОбласти
