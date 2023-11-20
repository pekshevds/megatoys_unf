
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.Документы.ТранспортныйКонтейнерЭДО;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	ПараметрыВыборки.ПолныеИменаОбъектов = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	
	Параметры.ПараметрыВыборки.ДополнительныеИсточникиДанных.Вставить("УдалитьЭлектронныеДокументы.УдалитьЭлектронныйДокумент");

	Запрос = Новый Запрос;
	
	МассивТекстовЗапроса = Новый Массив;
	
	МассивТекстовЗапроса.Добавить( 
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ТранспортныйКонтейнерЭДО.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ТранспортныйКонтейнерЭДО КАК ТранспортныйКонтейнерЭДО
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТранспортныйКонтейнерЭДО.УдалитьЭлектронныеДокументы КАК
	|			ТранспортныйКонтейнерЭДОУдалитьЭлектронныеДокументы
	|		ПО ТранспортныйКонтейнерЭДО.Ссылка = ТранспортныйКонтейнерЭДОУдалитьЭлектронныеДокументы.Ссылка
	|ГДЕ
	|	ТранспортныйКонтейнерЭДО.Ссылка > &Ссылка
	|	И
	|		(ТранспортныйКонтейнерЭДО.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыТранспортныхСообщенийБЭД.РаспакованДокументыНеОбработаны)
	|	ИЛИ НЕ ТранспортныйКонтейнерЭДОУдалитьЭлектронныеДокументы.Ссылка ЕСТЬ NULL
	|	И (ТранспортныйКонтейнерЭДОУдалитьЭлектронныеДокументы.Ссылка.ИдентификаторДокументооборота = """"
	|	ИЛИ НЕ ИСТИНА В
	|		(ВЫБРАТЬ
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.ОбъектыТранспортныхКонтейнеровЭДО КАК ОбъектыТранспортныхКонтейнеровЭДО
	|		ГДЕ
	|			ОбъектыТранспортныхКонтейнеровЭДО.ТранспортныйКонтейнер = ТранспортныйКонтейнерЭДОУдалитьЭлектронныеДокументы.Ссылка)))");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСГИСЭПД") Тогда
		МодульОбменСГИСЭПД = ОбщегоНазначения.ОбщийМодуль("ОбменСГИСЭПД");
		МассивТекстовЗапроса.Добавить( 
		"
		|ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ТранспортныйКонтейнерЭДО.Ссылка
		|ИЗ
		|	Документ.ТранспортныйКонтейнерЭДО КАК ТранспортныйКонтейнерЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыТранспортныхКонтейнеровЭДО КАК ОбъектыТранспортныхКонтейнеровЭДО
		|		ПО ТранспортныйКонтейнерЭДО.Ссылка = ОбъектыТранспортныхКонтейнеровЭДО.ТранспортныйКонтейнер
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СообщениеЭДО КАК СообщениеЭДО
		|		ПО СообщениеЭДО.Ссылка = ОбъектыТранспортныхКонтейнеровЭДО.Объект
		|		И СообщениеЭДО.ТипЭлементаРегламента В (&МассивТитуловЭПД)
		|ГДЕ
		|	ТранспортныйКонтейнерЭДО.Ссылка > &Ссылка
		|	И ТранспортныйКонтейнерЭДО.ВидСервисаЭДО <> &ВидСервисаЭПД");
		
		Запрос.УстановитьПараметр("ВидСервисаЭПД", Перечисления.ВидыСервисовЭДО.ЭПД);
		Запрос.УстановитьПараметр("МассивТитуловЭПД", МодульОбменСГИСЭПД.ТипыЭлементовРегламентаЭПД());
	КонецЕсли;
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, "
	|ОБЪЕДИНИТЬ
	|") + "
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	ОтработаныВсеДанные = Ложь;
	Ссылка = Документы.ТранспортныйКонтейнерЭДО.ПустаяСсылка();
	
	Пока Не ОтработаныВсеДанные Цикл
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Контейнеры = Запрос.Выполнить().Выгрузить();
		
		КоличествоСтрок = Контейнеры.Количество();
		
		Если КоличествоСтрок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			Ссылка = Контейнеры[КоличествоСтрок - 1].Ссылка;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Контейнеры.ВыгрузитьКолонку("Ссылка"));
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.Документы.ТранспортныйКонтейнерЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если Не ЗначениеЗаполнено(ВыбранныеДанные) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	НаборСсылок = ВыбранныеДанные.ВыгрузитьКолонку("Ссылка");
	
	МассивЭПД = Новый Массив;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСГИСЭПД") Тогда
		МодульОбменСГИСЭПД = ОбщегоНазначения.ОбщийМодуль("ОбменСГИСЭПД");
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ТранспортныйКонтейнерЭДО.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ТранспортныйКонтейнерЭДО КАК ТранспортныйКонтейнерЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыТранспортныхКонтейнеровЭДО КАК ОбъектыТранспортныхКонтейнеровЭДО
		|		ПО ТранспортныйКонтейнерЭДО.Ссылка = ОбъектыТранспортныхКонтейнеровЭДО.ТранспортныйКонтейнер
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СообщениеЭДО КАК СообщениеЭДО
		|		ПО СообщениеЭДО.Ссылка = ОбъектыТранспортныхКонтейнеровЭДО.Объект
		|		И СообщениеЭДО.ТипЭлементаРегламента В (&МассивТитуловЭПД)
		|ГДЕ
		|	ТранспортныйКонтейнерЭДО.Ссылка В (&НаборСсылок)
		|	И ТранспортныйКонтейнерЭДО.ВидСервисаЭДО <> &ВидСервисаЭПД";
		
		Запрос.УстановитьПараметр("МассивТитуловЭПД", МодульОбменСГИСЭПД.ТипыЭлементовРегламентаЭПД());
		Запрос.УстановитьПараметр("НаборСсылок", НаборСсылок);
		Запрос.УстановитьПараметр("ВидСервисаЭПД", Перечисления.ВидыСервисовЭДО.ЭПД);
	
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивЭПД.Добавить(Выборка.Ссылка);	
		КонецЦикла;
	КонецЕсли;
	
	Для каждого СсылкаНаОбъект Из НаборСсылок Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", СсылкаНаОбъект);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Записать = Ложь;
			
			Объект = СсылкаНаОбъект.ПолучитьОбъект();
			Если Объект <> Неопределено Тогда
				ОбработатьДанные_ЗаполнитьИдентификаторДокументооборота(Объект, Записать);
				ОбработатьДанные_ПеренестиЭлектронныеДокументыВРегистр(Объект, Записать);
				ОбработатьДанные_ПодготовитьКРаспаковкеНеобработанныеКонтейнеры(Объект, Записать);
				ОбработатьДанные_ЗаполнитьПризнакЭПД(Объект, МассивЭПД, Записать);
			КонецЕсли;
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(СсылкаНаОбъект, ПараметрыОтметкиВыполнения);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать транспортный контейнер ЭДО: %1 по причине:'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, СсылкаНаОбъект) + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, СсылкаНаОбъект, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые транспортные контейнеры ЭДО (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция транспортных контейнеров ЭДО: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов
		+ ОбъектовОбработано;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьДанные_ПеренестиЭлектронныеДокументыВРегистр(Объект, Записать)
	
	Если Объект.УдалитьЭлектронныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиДляУдаления = Новый Массив;
	Для Каждого СтрокаТЧ Из Объект.УдалитьЭлектронныеДокументы Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ.УдалитьЭлектронныйДокумент) Тогда
			Продолжить;
		КонецЕсли;
		СообщениеЭДО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.УдалитьЭлектронныйДокумент, "ВладелецФайла");
		Если Не ЗначениеЗаполнено(СообщениеЭДО) Тогда
			Продолжить;
		КонецЕсли;
		НачатьТранзакцию();
		Попытка
			ПоляБлокировки = Новый Структура;
			ПоляБлокировки.Вставить("Объект", СообщениеЭДО);
			ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку("РегистрСведений.ОбъектыТранспортныхКонтейнеровЭДО",
				ПоляБлокировки);

			СуществующийКонтейнер = ТранспортныеКонтейнерыЭДО.КонтейнерОбъекта(Объект.Ссылка, Объект.Направление);

			Если Не ЗначениеЗаполнено(СуществующийКонтейнер) Тогда

				МенеджерЗаписи = РегистрыСведений.ОбъектыТранспортныхКонтейнеровЭДО.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.ТранспортныйКонтейнер = Объект.Ссылка;
				МенеджерЗаписи.Объект = СообщениеЭДО;
				МенеджерЗаписи.Записать();

			КонецЕсли;
			СтрокиДляУдаления.Добавить(СтрокаТЧ);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Операция = НСтр("ru = 'Добавление объекта в транспортный контейнер ЭДО'");
			ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбработкаНеисправностейБЭД.ОбработатьОшибку(
				Операция, ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами,
				ПодробноеПредставлениеОшибки, ТекстОшибки);
		КонецПопытки;

	КонецЦикла;
	
	Если СтрокиДляУдаления.Количество() Тогда
		Записать = Истина;
		Для Каждого СтрокаТЧ Из СтрокиДляУдаления Цикл
			Объект.УдалитьЭлектронныеДокументы.Удалить(СтрокаТЧ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанные_ЗаполнитьИдентификаторДокументооборота(Объект, Записать)
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторДокументооборота) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.УдалитьЭлектронныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Объект.УдалитьЭлектронныеДокументы Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ.УдалитьЭлектронныйДокумент) Тогда
			Продолжить;
		КонецЕсли;
		СообщениеЭДО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.УдалитьЭлектронныйДокумент, "ВладелецФайла");
		Если Не ЗначениеЗаполнено(СообщениеЭДО) Тогда
			Продолжить;
		КонецЕсли;
		ДокументыСообщений = ЭлектронныеДокументыЭДО.ДокументыСообщений(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СообщениеЭДО));
		ЭлектронныйДокумент = ДокументыСообщений[СообщениеЭДО];
		СвойстваДокумента = ЭлектронныеДокументыЭДО.СвойстваДокумента(ЭлектронныйДокумент,
			"ИдентификаторДокументооборота");
		
		Объект.ИдентификаторДокументооборота = СвойстваДокумента.ИдентификаторДокументооборота;
		Записать = Истина;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанные_ПодготовитьКРаспаковкеНеобработанныеКонтейнеры(Объект, Записать)
	
	Если Объект.Статус <> Перечисления.СтатусыТранспортныхСообщенийБЭД.РаспакованДокументыНеОбработаны Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Статус = Перечисления.СтатусыТранспортныхСообщенийБЭД.КРаспаковке;
	
	Записать = Истина;
	
КонецПроцедуры

Процедура ОбработатьДанные_ЗаполнитьПризнакЭПД(Объект, МассивЭПД, Записать)
	
	Если МассивЭПД.Найти(Объект.Ссылка) <> Неопределено 
		И Объект.ВидСервисаЭДО <> Перечисления.ВидыСервисовЭДО.ЭПД Тогда
		Объект.ВидСервисаЭДО = Перечисления.ВидыСервисовЭДО.ЭПД;	
		Записать = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
