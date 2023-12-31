#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПриПолученииНастроек

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//      Настройки - Структура - Содержит настройки по умолчанию.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = "УправлениеНебольшойФирмой";
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	Настройки.ЭтоПланОбменаXDTO = Истина;
	Настройки.ФорматОбмена = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData";
	
	ВерсииФормата 		= Новый Соответствие;
	ВерсииФормата.Вставить("1.8", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.10", МенеджерОбменаЧерезУниверсальныйФормат);
	
	Настройки.ВерсииФорматаОбмена = ВерсииФормата;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена      = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки 	 = Истина;
	Настройки.Алгоритмы.ПриСохраненииНастроекСинхронизацииДанных = Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки = "ОбменУРМК";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Ложь;
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет синхронизировать данные между любыми программами, поддерживающими универсальный формат обмена ""Enterprise Data"".'");
		
	ОписаниеВарианта.КраткаяИнформацияПоОбмену 		= КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену 	= "ПланОбмена.ОбменСУРМК.Форма.ПодробнаяИнформация";
	ОписаниеВарианта.ОбщиеДанныеУзлов = "ХранитьКартыЛояльностиВРМК";
	
КонецПроцедуры

// Заполняет узел обмена настройками отправки и получения данных (ограничения передачи данных и значения по умолчанию).
//
// Параметры:
//  Корреспондент - ПланОбменаОбъект - узел плана обмена, соответствующий корреспонденту.
//  ДанныеЗаполнения - Структура - структура с данными для заполнения настроек отправки и получения данных.
//
Процедура ПриСохраненииНастроекСинхронизацииДанных(Корреспондент, ДанныеЗаполнения) Экспорт
	
	ЗаполнитьЗначенияСвойств(Корреспондент, ДанныеЗаполнения, 
		"ДатаНачалаВыгрузкиДокументов,
		|ТорговыйОбъект,
		|ВидЦен,
		|УРМК,
		|ИспользоватьОтборПоОрганизациям,
		|ХранитьКартыЛояльностиВРМК,
		|ВыгружатьОстаткиНоменклатуры,
		|ВыгружатьЗаказы");
	
	Корреспондент.КассыККМ.Загрузить(ДанныеЗаполнения.КассыККМ);
	Корреспондент.Организации.Загрузить(ДанныеЗаполнения.Организации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


