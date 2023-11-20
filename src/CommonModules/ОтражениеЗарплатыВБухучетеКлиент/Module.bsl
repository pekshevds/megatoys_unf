////////////////////////////////////////////////////////////////////////////////
// ОтражениеЗарплатыВБухучетеКлиент: методы отражения зарплаты в бухучете,
//									 работающие на стороне клиента.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ПроцедурыИФункцииРедактированияВФормеПроцентаЕнвд

// Обрабатывает событие НачалоВыбора элемента управления ПроцентЕНВДСтрока.
Процедура ПроцентЕНВДСтрокаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ОповещениеЗавершения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Форма, ОповещениеЗавершения", Форма, ОповещениеЗавершения);
	Оповещение = Новый ОписаниеОповещения("ПроцентЕНВДСтрокаНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ТекстЗаголовка = НСтр("ru = 'Процент ЕНВД'");
	ПоказатьВводЧисла(Оповещение, Форма.ПроцентЕНВД, ТекстЗаголовка, 8, 5);
	
КонецПроцедуры

Процедура ПроцентЕНВДСтрокаНачалоВыбораЗавершение(НовыйПроцентЕНВД, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если НовыйПроцентЕНВД = Неопределено Или НовыйПроцентЕНВД = Форма.ПроцентЕНВД Тогда 
		Возврат;
	КонецЕсли;
	
	ОшибкаВводаПроцента = НовыйПроцентЕНВД > 100 Или НовыйПроцентЕНВД < 0;
	Если ОшибкаВводаПроцента Тогда
		ВывестиПредупреждениеОбОшибкеВводаПроцентаЕНВД();
	Иначе
		Форма.ПроцентЕНВД = НовыйПроцентЕНВД;
		Форма.ПроцентЕНВДСтрока = Формат(Форма.ПроцентЕНВД, "ЧЦ=8; ЧДЦ=5; ЧН=0");
		Форма.ПроцентЕНВДСтрокаПрежнееЗначение = Форма.ПроцентЕНВДСтрока;
		Форма.ЗарегистрироватьПроцентЕНВД();
	КонецЕсли;
	
	ОтражениеЗарплатыВБухучетеКлиентСервер.ОбновитьИнфонадписьПроцентЕНВД(Форма);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает событие ПриИзменении элемента управления ПроцентЕНВДСтрока.
Процедура ПроцентЕНВДСтрокаПриИзменении(Форма, Элемент, НовоеЗначение) Экспорт
	
	ОшибкаВводаПроцента = Ложь;
	Попытка
		НовыйПроцентЕНВД = Число(?(ПустаяСтрока(НовоеЗначение), 0, НовоеЗначение));
	Исключение
		ОшибкаВводаПроцента = Истина;
		НовыйПроцентЕНВД = 0;
	КонецПопытки;
	
	ОшибкаВводаПроцента = ОшибкаВводаПроцента Или НовыйПроцентЕНВД >100 Или НовыйПроцентЕНВД < 0;
	
	Если ОшибкаВводаПроцента Тогда
		ВывестиПредупреждениеОбОшибкеВводаПроцентаЕНВД();
		// Установим в поле редактирования значение, которое было до начала редактирования.
		Форма.ПроцентЕНВДСтрока = Форма.ПроцентЕНВДСтрокаПрежнееЗначение;
	Иначе
		// установим новое значение
		Форма.ПроцентЕНВД = НовыйПроцентЕНВД;
		Если ПустаяСтрока(НовоеЗначение) Тогда
			// Очистили значение, т.е. отменяем регистрацию процента ЕНВД на текущий месяц.
			Форма.ПроцентЕНВДСтрока = "";
		Иначе
			Форма.ПроцентЕНВДСтрока = Формат(Форма.ПроцентЕНВД, "ЧЦ=8; ЧДЦ=5; ЧН=0");
		КонецЕсли;
		Форма.ЗарегистрироватьПроцентЕНВД();
	КонецЕсли;
	
	Форма.ПроцентЕНВДСтрокаПрежнееЗначение = Форма.ПроцентЕНВДСтрока;
	
	ОтражениеЗарплатыВБухучетеКлиентСервер.ОбновитьИнфонадписьПроцентЕНВД(Форма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВывестиПредупреждениеОбОшибкеВводаПроцентаЕНВД()

	// Введено число не из диапазона 0…100, или запрещенные символы.
	ТекстСообщения = НСтр("ru = 'Для ввода процента ЕНВД необходимо указать число от 0 до 100. Редактирование отменено.'");
	ПоказатьПредупреждение(, ТекстСообщения);

КонецПроцедуры

#КонецОбласти
