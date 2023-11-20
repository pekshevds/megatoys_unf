#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Получатель)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Получатель)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ


// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиПолученияЭлектронныхДокументов;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиПолученияЭлектронныхДокументов.Отправитель,
	|	НастройкиПолученияЭлектронныхДокументов.Получатель,
	|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя,
	|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя
	|ИЗ
	|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
	|ГДЕ
	|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовЭДО.ПустаяСсылка)
	|	И
	|		(НастройкиПолученияЭлектронныхДокументов.УдалитьВидДокумента <> ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.ПустаяСсылка)
	|	ИЛИ НастройкиПолученияЭлектронныхДокументов.УдалитьПрикладнойВидЭД <> &ПустойПрикладнойТипДокумента)
	|	ИЛИ НастройкиПолученияЭлектронныхДокументов.СпособОбработки = ""ПоступлениеТоваровУслуг""
	|	И НастройкиПолученияЭлектронныхДокументов.УдалитьВидДокумента В (&ТипыДокументовИзменитьСпособОбработки)
	|;
	|//////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиПолученияЭлектронныхДокументов.Отправитель,
	|	НастройкиПолученияЭлектронныхДокументов.Получатель,
	|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя,
	|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя,
	|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки
	|ИЗ
	|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
	|ГДЕ
	|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки = &СпособОбработкиНеОтражать";
	
	Запрос.УстановитьПараметр("ПустойПрикладнойТипДокумента",
		Метаданные.ОпределяемыеТипы.ПрикладныеТипыЭлектронныхДокументовЭДО.Тип.ПривестиЗначение());
	Запрос.УстановитьПараметр("ТипыДокументовИзменитьСпособОбработки", ТипыДокументовИзменитьСпособОбработки());
	Запрос.УстановитьПараметр("СпособОбработкиНеОтражать", НекорректныйСпособОбработкиНеОтражать());
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Выгрузка = Результаты[0].Выгрузить();
	
	ВыборкаНекорректныеСпособыОбработки = Результаты[1].Выбрать();
	Пока ВыборкаНекорректныеСпособыОбработки.Следующий() Цикл
		// Проверка регистра строки, т.к. запрос его не учитывает.
		Если ВыборкаНекорректныеСпособыОбработки.СпособОбработки = НекорректныйСпособОбработкиНеОтражать() Тогда
			НоваяСтрока = Выгрузка.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаНекорректныеСпособыОбработки);
		КонецЕсли;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиПолученияЭлектронныхДокументов;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	СоответствиеВидовДокументов = ОбменСКонтрагентамиИнтеграция.СоответствиеВидовЭДВидамДокументовЭДО();
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого СтрокаДанных Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Записать = Ложь;
			
			НаборЗаписей = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Отправитель.Установить(СтрокаДанных.Отправитель);
			НаборЗаписей.Отбор.Получатель.Установить(СтрокаДанных.Получатель);
			НаборЗаписей.Отбор.ИдентификаторОтправителя.Установить(СтрокаДанных.ИдентификаторОтправителя);
			НаборЗаписей.Отбор.ИдентификаторПолучателя.Установить(СтрокаДанных.ИдентификаторПолучателя);
			ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
			
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() Тогда
				
				ОбработатьДанные_ЗаполнитьВидДокумента(НаборЗаписей, СоответствиеВидовДокументов, Записать);
				ОбработатьДанные_ИсправитьСпособОбработки(НаборЗаписей, Записать);
				
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
			
			СтруктураКлючаЗаписи = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаДанных);
			КлючЗаписиСтрокой = ОбщегоНазначенияБЭДКлиентСервер.СтруктураВСтроку(СтруктураКлючаЗаписи);
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать настройки получения электронных документов для: %1 по причине:
				|%2'"), СтрокаДанных.Отправитель, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, КлючЗаписиСтрокой, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые настройки получения электронных документов (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция настроек получения электронных документов: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов =
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Удаляет настройки отправки ЭДО
// 
//  Параметры - СписокЗначений - параметры учетной записи для удаления
//  АдресРезультата - Строка - путь временного хранилища
//
Функция УдалитьНастройкиОтраженияВУчете(Получатель, Отправитель, ИдентификаторПолучателя,
	ИдентификаторОтправителя) Экспорт
	
	Результат                = Истина;
	
	НаборЗаписей = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(Отправитель);
	НаборЗаписей.Отбор.Получатель.Установить(Получатель);
	
	Если ЗначениеЗаполнено(ИдентификаторПолучателя) Тогда
		НаборЗаписей.Отбор.ИдентификаторПолучателя.Установить(ИдентификаторПолучателя);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторОтправителя) Тогда
		НаборЗаписей.Отбор.ИдентификаторОтправителя.Установить(ИдентификаторОтправителя);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		// Попытка удаления. Управляемую блокировку устанавливать нет необходимости.
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось удалить настройки отражения в учете электронных документов по:
                                      |Организация: %1,
                                      |Контрагент: %2,
                                      |Идентификатор организации: %3.
                                      |Идентификатор контрагента: %4'"), Получатель, Отправитель,
                                      ИдентификаторПолучателя, ИдентификаторОтправителя);
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление настроек отражения в учете ЭДО'"), ОбработкаОшибок.ПодробноеПредставлениеОшибки(Информация), ТекстОшибки);
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьДанные_ЗаполнитьВидДокумента(НаборЗаписей, СоответствиеВидовДокументов, Записать)
	
	ЗаписиДляУдаления = Новый Массив;
	ТипыДокументовИзменитьСпособОбработки = ТипыДокументовИзменитьСпособОбработки();
	Для Каждого Запись Из НаборЗаписей Цикл
		Если ТипыДокументовИзменитьСпособОбработки.Найти(Запись.УдалитьВидДокумента) <> Неопределено
			И Запись.СпособОбработки = "ПоступлениеТоваровУслуг" Тогда
			СпособОбработки = ?(Запись.УдалитьВидДокумента = Перечисления.ТипыДокументовЭДО.АктНаПередачуПрав,
				"АктНаПередачуПрав", "АктВыполненныхРабот");
			Запись.СпособОбработки = СпособОбработки;
			Записать = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.ВидДокумента) Тогда
			Если ЗначениеЗаполнено(Запись.УдалитьПрикладнойВидЭД) Тогда
				ТипДокумента = Запись.УдалитьПрикладнойВидЭД;
			ИначеЕсли ЗначениеЗаполнено(Запись.УдалитьВидДокумента) Тогда 
				ТипДокумента = Запись.УдалитьВидДокумента;
			Иначе
				Возврат;
			КонецЕсли;
			Если Запись.УдалитьВидДокумента = Перечисления.ТипыДокументовЭДО.ПередачаТоваровМеждуОрганизациями Тогда
				ЗаписиДляУдаления.Добавить(Запись);
			КонецЕсли;
			Запись.ВидДокумента = СоответствиеВидовДокументов[ТипДокумента];
			Записать = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Запись Из ЗаписиДляУдаления Цикл
		НаборЗаписей.Удалить(Запись);
		Записать = Истина;
	КонецЦикла;
	
	ТаблицаНастроек = НаборЗаписей.Выгрузить();
	
	Отбор = Новый Структура("ВидДокумента",
		ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот));
	СтрокиАктВыполненныхРабот = ТаблицаНастроек.НайтиСтроки(Отбор);
	Если СтрокиАктВыполненныхРабот.Количество() > 1 Тогда
		УдаляемаяСтрока = ТаблицаНастроек.Найти(Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот);
		Если УдаляемаяСтрока <> Неопределено Тогда
			ТаблицаНастроек.Удалить(УдаляемаяСтрока);
		Иначе
			ТаблицаНастроек.Удалить(СтрокиАктВыполненныхРабот[0]);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		СтрокаТаблицы.УдалитьВидДокумента = Перечисления.ТипыДокументовЭДО.ПустаяСсылка();
		СтрокаТаблицы.УдалитьПрикладнойВидЭД = Неопределено;
	КонецЦикла;
	
	НаборЗаписей.Загрузить(ТаблицаНастроек);
	
КонецПроцедуры

Процедура ОбработатьДанные_ИсправитьСпособОбработки(НаборЗаписей, Записать)
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Если Запись.СпособОбработки = НекорректныйСпособОбработкиНеОтражать() Тогда
			Запись.СпособОбработки = ИнтеграцияЭДО.СпособОбработки_НеОтражать();
			Записать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ТипыДокументовИзменитьСпособОбработки()
	
	ТипыДокументов = Новый Массив;
	ТипыДокументов.Добавить(Перечисления.ТипыДокументовЭДО.УдалитьАктИсполнитель);
	ТипыДокументов.Добавить(Перечисления.ТипыДокументовЭДО.АктНаПередачуПрав);
	
	Возврат ТипыДокументов;
	
КонецФункции

Функция НекорректныйСпособОбработкиНеОтражать()
	
	Возврат "НЕОТРАЖАТЬ";
	
КонецФункции

#КонецОбласти

#КонецЕсли
