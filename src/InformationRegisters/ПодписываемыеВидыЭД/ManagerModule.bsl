#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.ПодписываемыеВидыЭД;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
		
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодписываемыеВидыЭД.СертификатЭП
	|ИЗ
	|	РегистрСведений.ПодписываемыеВидыЭД КАК ПодписываемыеВидыЭД
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ПодписываемыеВидыЭД.ВидЭД) = ТИП(Перечисление.ТипыДокументовЭДО)
	|	И ПодписываемыеВидыЭД.ВидЭД <> ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.Прикладной)";
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		
		МетаданныеОбъекта = Метаданные.РегистрыСведений.ПодписываемыеВидыЭД;
		ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
		
		Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь, "Справочник.ВидыДокументовЭДО") Тогда
			Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
				Параметры.Очередь, ПолноеИмяОбъекта);
			Возврат;
		КонецЕсли;
		
		ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
		
		ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
		
		МодульОбменСКонтрагентамиИнтеграция = ОбщегоНазначения.ОбщийМодуль("ОбменСКонтрагентамиИнтеграция");
		СоответствиеВидовДокументов = МодульОбменСКонтрагентамиИнтеграция.СоответствиеВидовЭДВидамДокументовЭДО();
		
		ОбъектовОбработано = 0;
		ПроблемныхОбъектов = 0;
		
		Для Каждого СтрокаДанных Из ВыбранныеДанные Цикл
			
			НачатьТранзакцию();
			Попытка
				
				Записать = Ложь;
				
				НаборЗаписей = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.СертификатЭП.Установить(СтрокаДанных.СертификатЭП);
				ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
				
				НаборЗаписей.Прочитать();
				
				Если НаборЗаписей.Количество() Тогда
	
					ОбработатьДанные_ЗаполнитьВидДокумента(НаборЗаписей, СоответствиеВидовДокументов, Записать);
				
				КонецЕсли;
	
				Если Записать Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ПараметрыОтметкиВыполнения);
				КонецЕсли;
				
				ОбъектовОбработано = ОбъектовОбработано + 1;
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				
				ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
				
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать подписываемые виды электронных документов для: %1 по причине:
					|%2'"), СтрокаДанных.СертификатЭП, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, СтрокаДанных.СертификатЭП, ТекстСообщения);
			КонецПопытки;
			
		КонецЦикла;
		
		Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые подписываемые виды электронных документов (пропущены): %1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
			ВызватьИсключение ТекстСообщения;
		Иначе
			ШаблонСообщения = НСтр("ru = 'Обработана очередная порция подписываемых видов электронных документов: %1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Информация,
				МетаданныеОбъекта,, ТекстСообщения);
		КонецЕсли;
		
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов =
			Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
		
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		
	Иначе
		
		Параметры.ОбработкаЗавершена = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Отбор = "";
	Если Параметры.Свойство("Отбор", Отбор)
		И ТипЗнч(Отбор) = Тип("Структура") И Отбор.Количество() <> 0 Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ВидыЭДПоСертификату";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Только для внутреннего использования
Процедура СохранитьПодписываемыеВидыЭД(СертификатСсылка, ПодписываемыеЭД = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПодписываемыеЭД = Неопределено Тогда
		ПодписываемыеЭД = Новый ТаблицаЗначений;
		ПодписываемыеЭД.Колонки.Добавить("СертификатЭП");
		ПодписываемыеЭД.Колонки.Добавить("ВидЭД");
		ПодписываемыеЭД.Колонки.Добавить("Использовать");
		ВидыЭД = КриптографияБЭД.ПодписываемыеВидыДокументов();
		Для Каждого ВидЭД Из ВидыЭД Цикл
			НовЗапись = ПодписываемыеЭД.Добавить();
			НовЗапись.СертификатЭП = СертификатСсылка;
			НовЗапись.ВидЭД = ВидЭД;
			НовЗапись.Использовать = Истина;
		КонецЦикла
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.СертификатЭП.Установить(СертификатСсылка);
	НаборЗаписей.Загрузить(ПодписываемыеЭД);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьДанные_ЗаполнитьВидДокумента(НаборЗаписей, СоответствиеВидовДокументов, Записать)
	
	Таблица = НаборЗаписей.Выгрузить();
	ТаблицаНовых = Таблица.СкопироватьКолонки();
	СтрокиДляУдаления = Новый Массив;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если ОбщегоНазначения.ЗначениеСсылочногоТипа(СтрокаТаблицы.ВидЭД) 
			И СтрокаТаблицы.ВидЭД.Метаданные().ПолноеИмя() = "Перечисление.ТипыДокументовЭДО" Тогда
			
			МодульЭлектронныеДокументы = ОбщегоНазначения.ОбщийМодуль("ЭлектронныеДокументыЭДО");
			ТипыДокументовЭДО          = Перечисления["ТипыДокументовЭДО"];
			
			НовыйВидДокумента = СоответствиеВидовДокументов[СтрокаТаблицы.ВидЭД];
			Если Таблица.Найти(НовыйВидДокумента, "ВидЭД") = Неопределено И НовыйВидДокумента <> Неопределено Тогда
				СтрокаТаблицы.ВидЭД = НовыйВидДокумента;
			Иначе 
				СтрокиДляУдаления.Добавить(СтрокаТаблицы);
			КонецЕсли;
			Если СтрокаТаблицы.ВидЭД = ТипыДокументовЭДО.УдалитьПроизвольный Тогда
				ОбработатьДанные_ДобавитьНовыеВидыДокументов(Таблица, ТаблицаНовых,
					МодульЭлектронныеДокументы.ВидыДокументовДляПроизвольногоФормата(), СтрокаТаблицы, СтрокиДляУдаления);
			КонецЕсли;
			Если СтрокаТаблицы.ВидЭД = ТипыДокументовЭДО.Прикладной Тогда
				ОбработатьДанные_ДобавитьНовыеВидыДокументов(Таблица, ТаблицаНовых,
					МодульЭлектронныеДокументы.ПрикладныеВидыДокументов(), СтрокаТаблицы, СтрокиДляУдаления);
			КонецЕсли;
			Записать = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаДляУдаления Из СтрокиДляУдаления Цикл
		Таблица.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ТаблицаНовых Цикл
		Если Таблица.Найти(СтрокаТаблицы.ВидЭД, "ВидЭД") = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Таблица.Добавить(), СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	Если Записать Тогда
		НаборЗаписей.Загрузить(Таблица);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанные_ДобавитьНовыеВидыДокументов(Таблица, ТаблицаНовых, НовыеВиды, СтрокаТаблицыСтарых,
	СтрокиДляУдаления)
	
	Для Каждого ВидДокумента Из НовыеВиды Цикл
		СтрокаНовогоВида = Таблица.Найти(ВидДокумента, "ВидЭД");
		Если СтрокаНовогоВида = Неопределено Тогда
			СтрокаНовогоВида = ТаблицаНовых.Добавить();
		КонецЕсли;
		СтрокаНовогоВида.ВидЭД = ВидДокумента;
		СтрокаНовогоВида.СертификатЭП = СтрокаТаблицыСтарых.СертификатЭП;
		СтрокаНовогоВида.Использовать = СтрокаТаблицыСтарых.Использовать;
	КонецЦикла;
	
	Если СтрокиДляУдаления.Найти(СтрокаТаблицыСтарых) = Неопределено Тогда
		СтрокиДляУдаления.Добавить(СтрокаТаблицыСтарых);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли