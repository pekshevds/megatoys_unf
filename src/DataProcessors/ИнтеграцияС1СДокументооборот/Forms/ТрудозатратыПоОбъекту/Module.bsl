#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВнешнийОбъект") Тогда
		Если ТипЗнч(Параметры.ВнешнийОбъект) = Тип("Структура") Тогда
			ПредметID = Параметры.ВнешнийОбъект.ID;
			ПредметТип = Параметры.ВнешнийОбъект.type;
		Иначе
			ВнешнийОбъект = Параметры.ВнешнийОбъект;
		КонецЕсли;
	КонецЕсли;
	
	// Хронометраж.
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP")
			И Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("3.0.1.1") Тогда
		ВывестиСписокТрудозатрат();
	Иначе
		Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтотОбъект);
		Элементы.Работы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Модифицированность = Ложь;
	ВывестиСписокТрудозатрат();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиСписокТрудозатрат()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	СписокУсловий = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "source";
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ПредметID,
			ПредметТип);
	Иначе
		Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьExternalObject(
			Прокси,
			ВнешнийОбъект);
	КонецЕсли;
	
	УсловияОтбора.Добавить(Условие);
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMActualWork",
		СписокУсловий);
	
	Работы.Очистить();
	
	Для Каждого СтрокаОтвета Из Ответ.items Цикл
		
		Строка = СтрокаОтвета.object;
		
		НоваяСтрока = Работы.Добавить();
		НоваяСтрока.ДатаДобавления = Строка.addDate;
		НоваяСтрока.Начало = Строка.begin;
		НоваяСтрока.Окончание = Строка.end;
		НоваяСтрока.Работа = Строка.description;
		НоваяСтрока.Длительность = Строка.duration / 3600;
		НоваяСтрока.ДлительностьСтр = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(НоваяСтрока.Длительность);
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.workType, "ВидРабот", Ложь);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.project,"Проект", Ложь);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.projectTask,"ПроектнаяЗадача", Ложь);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.source, "Источник", Ложь);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(НоваяСтрока, Строка.user, "Пользователь", Ложь);
		
		НоваяСтрока.ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(
			НоваяСтрока.Проект, НоваяСтрока.ПроектнаяЗадача);
		
	КонецЦикла;
	
	Работы.Сортировать("ДатаДобавления");
	
КонецПроцедуры

#КонецОбласти
