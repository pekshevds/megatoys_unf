
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Функция возвращает структуру значений по умолчанию для документа для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПоУмолчанию(Основание, СсылкаНаОформляемыйДокумент) Экспорт
	
	СтруктураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктураЗначенияПоУмолчанию.Вставить("Документ",         СсылкаНаОформляемыйДокумент);
	СтруктураЗначенияПоУмолчанию.Вставить("Основание",        Основание);
	
	СтруктураЗначенияПоУмолчанию.Вставить("СтатусОформления", Перечисления.СтатусыОформленияДокументовЕГАИС.НеОформлено);
	СтруктураЗначенияПоУмолчанию.Вставить("Архивный", Ложь);
	
	СтруктураЗначенияПоУмолчанию.Вставить("Дата",  '00010101');
	СтруктураЗначенияПоУмолчанию.Вставить("Номер", "");
	СтруктураЗначенияПоУмолчанию.Вставить("Контрагент");
	СтруктураЗначенияПоУмолчанию.Вставить("ТорговыйОбъект");
	СтруктураЗначенияПоУмолчанию.Вставить("Ответственный");
	
	Возврат СтруктураЗначенияПоУмолчанию;
	
КонецФункции

// Проверяет наличие записей в регистре по указанным документам-основаниям и документу ЕГАИС.
//
Функция ДокументыОснованияСЗаписямиРегистра(МассивДокументов, ПустаяСсылкаЕГАИС) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатусыОформления.Основание,
	|	СтатусыОформления.Архивный
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовЕГАИС КАК СтатусыОформления
	|ГДЕ
	|	СтатусыОформления.Основание В (&МассивДокументов)
	|	И СтатусыОформления.Документ = &ПустаяСсылкаЕГАИС";
	
	Запрос.УстановитьПараметр("МассивДокументов",  МассивДокументов);
	Запрос.УстановитьПараметр("ПустаяСсылкаЕГАИС", ПустаяСсылкаЕГАИС);
	
	Результат = Новый Структура("Неоформленные, Архивные", Новый Массив, Новый Массив);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Архивный Тогда
			Результат.Архивные.Добавить(Выборка.Основание);
		Иначе
			Результат.Неоформленные.Добавить(Выборка.Основание);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Удаляет запись из регистра по переданному документу.
//
// Параметры:
//  Основание - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС - документ-основание
//  Документ - ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления - документ ЕГАИС не требующий оформления
//
Процедура УдалитьЗаписьРегистра(Основание, Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СтатусыОформленияДокументовЕГАИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Основание.Установить(Основание);
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();

КонецПроцедуры

//Архивирует записи из регистра по переданным документам.
//
//Параметры:
//   Основания - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС - массив распоряжений
//   Документ  - ОпределяемыйТип.ДокументыЕГАИС - документ, данные по которому необходимо архивировать
//
//Возвращаемое значение:
//   Массив Из Структура - (См. ИнтеграцияЕГАИСКлиентСервер.СтруктураИзменения)
//
Функция АрхивироватьРаспоряженияКОформлению(Основания, Документ) Экспорт
	
	Изменения = Новый Массив;
	
	НаборЗаписей = РегистрыСведений.СтатусыОформленияДокументовЕГАИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	
	Если Не ПравоДоступа("Изменение", Документ.Метаданные()) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для обработки распоряжений к оформлению'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Основание Из Основания Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра());
			ЭлементБлокировки.УстановитьЗначение("Документ",  Документ);
			ЭлементБлокировки.УстановитьЗначение("Основание", Основание);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей.Отбор.Основание.Установить(Основание);
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Выбран() Тогда
				
				Для Каждого СтрокаТЧ Из НаборЗаписей Цикл
					СтрокаТЧ.Архивный = Истина;
				КонецЦикла;
				
				НаборЗаписей.Записать();
				
				СтрокаРезультата = ИнтеграцияЕГАИСКлиентСервер.СтруктураИзменения();
				СтрокаРезультата.Объект            = Документ;
				СтрокаРезультата.ДокументОснование = Основание;
				
				Изменения.Добавить(СтрокаРезультата);
				
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось архивировать распоряжение к оформлению %1 по причине: %2'"),
				Основание, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru='ЕГАИС'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.СтатусыОформленияДокументовЕГАИС,
				Основание,
				ТекстСообщения);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Изменения;
	
КонецФункции

//Осуществляет запись в регистр по переданным данным.
//
//Параметры:
//   ДанныеЗаписи - Структура - (см. ЗначенияПоУмолчанию)
//
Процедура ВыполнитьЗаписьВРегистр(ДанныеЗаписи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.СтатусыОформленияДокументовЕГАИС.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрСведений.СтатусыОформленияДокументовЕГАИС";
	
КонецФункции

#КонецОбласти

#КонецЕсли