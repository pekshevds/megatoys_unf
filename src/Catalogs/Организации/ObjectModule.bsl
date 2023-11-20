#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	ДозаполнитьПоУмолчанию();

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// Проверка признака ОбменДанными.Загрузка выполняется ниже по коду.
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() И ЭтоНовый() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Организации.Ссылка) КАК КоличествоОрганизаций
		|ИЗ
		|	Справочник.Организации КАК Организации";
		Выборка = Запрос.Выполнить().Выбрать();

		Пока Выборка.Следующий() Цикл
			Если Выборка.КоличествоОрганизаций >= 2 Тогда
				Отказ = Истина;
				ОбщегоНазначения.СообщитьПользователю(НСтр(
					"ru='Ограничение базовой версии. В информационной базе могут быть введены только две организации.'"));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;  
	
	Если Не ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		
		Если Не ЭтоНовый() Тогда
			
			Если ГоловнаяОрганизация <> Ссылка Тогда
				ГоловнаяОрганизация = Ссылка;
			КонецЕсли;
			
		Иначе
			
			// Свойство "Ссылка" заведомо не заполнено.
			// Но в ходе обмена ссылка может быть передана.
			
			СсылкаНового = ПолучитьСсылкуНового();
			Если Не СсылкаНового.Пустая() Тогда
				Если ГоловнаяОрганизация <> СсылкаНового Тогда
					ГоловнаяОрганизация = СсылкаНового;
				КонецЕсли;
			Иначе
				УстановитьСсылкуНового(Справочники.Организации.ПолучитьСсылку());
				ГоловнаяОрганизация = ПолучитьСсылкуНового();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Проверим возможность внесения изменений
	Если ЭтоНовый() И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'В программе отключен учет по нескольким организациям.'"));
		Отказ = Истина;
	КонецЕсли;

	РегламентированнаяОтчетностьУСН.ПроверитьРегистрациюВИФНС(ЭтотОбъект, Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ИсторияКПП.Количество() = 1 Тогда
		ИсторияКПП.Очистить();
	ИначеЕсли ИсторияКПП.Количество() > 1 Тогда
		Справочники.Контрагенты.УстановитьАктуальноеЗначениеИсторииКПП(КПП, ИсторияКПП);
		ИсторияКПП[0].Период = '00010101';
		ВсеПериоды = ОбщегоНазначения.ВыгрузитьКолонку(ИсторияКПП, "Период", Истина);
		Если ВсеПериоды.Количество() <> ИсторияКПП.Количество() Тогда
			ТекстСообщения = НСтр("ru='В истории КПП есть записи с одинаковым периодом.'");
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
	КонецЕсли;

	Если ИсторияНаименований.Количество() = 1 Тогда
		// Если запись в истории наименований одна, то считается, что изменений нет
		// и значение наименования нужно определять из данных объекта.
		ИсторияНаименований.Очистить();
	ИначеЕсли ИсторияНаименований.Количество() > 1 Тогда
		// Первая запись в истории должна иметь пустую дату
		ИсторияНаименований.Сортировать("Период");
		ИсторияНаименований[0].Период = '00010101';
		
		// Последняя запись в истории всегда должна соответствовать наименованию в объекте
		Справочники.Организации.УстановитьАктуальноеЗначениеИсторииНаименований(Наименование, 
			НаименованиеПолное, 
			ИсторияНаименований);
	КонецЕсли;

	// Настройка данных реквизитов в зависимости от других реквизитов
	ПривестиДанныеКСогласованномуСостоянию(); 
	
	// БКЗБ
	Если ЭтотОбъект.ИспользуетсяОтчетность И ЭтотОбъект.ИПИспользуетТрудНаемныхРаботников Тогда
		Константы.ИспользоватьНачислениеЗарплаты.Установить(Истина);
		Константы.ИспользоватьКадровыйУчет.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	БанковскийСчетПоУмолчанию = Неопределено;
	ФайлЛоготип = Неопределено;
	ФайлФаксимильнаяПечать = Неопределено;
	ФизическоеЛицо = Неопределено;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ИспользуетсяОтчетность И Не ПолучитьФункциональнуюОпцию("ИспользоватьОтчетность") 
		И ОбщегоНазначенияУНФ.ЭтоУНФ() Тогда
		Константы.ФункциональнаяОпцияИспользоватьОтчетность.Установить(Истина);
	КонецЕсли;

	Если ИспользуетсяОтчетность И (ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо
		Или ИПИспользуетТрудНаемныхРаботников) Тогда
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуЗарплата") Тогда
			Константы.ФункциональнаяОпцияИспользоватьПодсистемуЗарплата.Установить(Истина);
		КонецЕсли;

		Если Не ПолучитьФункциональнуюОпцию("ВестиУчетНалогаНаДоходыИВзносов") И ОбщегоНазначенияУНФ.ЭтоУНФ() Тогда
			Константы.ФункциональнаяОпцияВестиУчетНалогаНаДоходыИВзносов.Установить(Истина);
		КонецЕсли;
	КонецЕсли;
	
	// БРО
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПриЗаписиОрганизации(ЭтотОбъект, Отказ);

	ЗаполнитьИННПодчиненныхОрганизаций(Ссылка, ИНН, Отказ);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДозаполнитьПоУмолчанию()

	Если Не ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
		ПроизводственныйКалендарь = ГрафикиРаботыУНФ.КалендарьПоПроизводственномуКалендарюРФ();
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ВидСтавкиНДСПоУмолчанию) Тогда
		ВидСтавкиНДСПоУмолчанию = Перечисления.ВидыСтавокНДС.Общая;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(КассаПоУмолчанию) Тогда
		КассаПоУмолчанию = Справочники.Кассы.ПолучитьКассуПоУмолчанию();
	КонецЕсли;

КонецПроцедуры

// Процедура согласовывает состояние одних реквизитов объекта в зависимости от других
//
Процедура ПривестиДанныеКСогласованномуСостоянию()

	ЭтоЮридическоеЛицо = (ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);

	Если ЭтоЮридическоеЛицо Тогда

		ИНН = Лев(ИНН, 10); // ИНН 10 цифр
		ОГРН = Лев(ОГРН, 13); // ОГРН 13 цифр
		СвидетельствоСерияНомер = "";
		СвидетельствоДатаВыдачи = '00010101';
		ФизическоеЛицо = Неопределено;

	ИначеЕсли ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда

		КПП = "";

	КонецЕсли;

	Если ГоловнаяОрганизация = Ссылка
		ИЛИ ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда

		ЦифровойИндексОбособленногоПодразделения = "";

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьИННПодчиненныхОрганизаций(ОрганизацияСсылка, ИНН, Отказ)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияСсылка", ОрганизацияСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрОрганизации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК СпрОрганизации
	|ГДЕ
	|	СпрОрганизации.ГоловнаяОрганизация = &ОрганизацияСсылка
	|	И СпрОрганизации.Ссылка <> &ОрганизацияСсылка";
	РезультатЗапроса = Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;

	ВыборкаОрганизации = РезультатЗапроса.Выбрать();
	Пока ВыборкаОрганизации.Следующий() Цикл

		ОрганизацияОбъект = ВыборкаОрганизации.Ссылка.ПолучитьОбъект();
		Попытка

			ОрганизацияОбъект.Заблокировать();
			ОрганизацияОбъект.ИНН = ИНН;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОрганизацияОбъект, Истина, Истина);
			ОрганизацияОбъект.Разблокировать();

		Исключение

			ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(НСтр("ru = 'ИзменениеИНН'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Организации, ВыборкаОрганизации.Ссылка,
				ПодробноеПредставлениеОшибки);

			ТекстСообщения = НСтр("ru ='Обновление ИНН подчиненной организации завершилось с ошибкой (%1)'");
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстСообщения, ВыборкаОрганизации.Ссылка));

			Отказ = Истина;

		КонецПопытки;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли