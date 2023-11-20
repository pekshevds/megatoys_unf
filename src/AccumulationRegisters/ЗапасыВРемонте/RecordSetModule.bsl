#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыВРемонте.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРемонтеИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРемонтеИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыВРемонтеИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыВРемонтеИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыВРемонтеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыВРемонте.НомерСтроки КАК НомерСтроки,
		|	ЗапасыВРемонте.Номенклатура КАК Номенклатура,
		|	ЗапасыВРемонте.Характеристика КАК Характеристика,
		|	ЗапасыВРемонте.Серия КАК Серия,
		|	ЗапасыВРемонте.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ВЫБОР
		|		КОГДА ЗапасыВРемонте.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыВРемонте.Количество
		|		ИНАЧЕ -ЗапасыВРемонте.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыВРемонтеПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыВРемонте КАК ЗапасыВРемонте
		|ГДЕ
		|	ЗапасыВРемонте.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыВРемонтеИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыВРемонтеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыВРемонтеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыВРемонтеИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыВРемонтеИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыВРемонтеИзменение.Серия КАК Серия,
		|	ДвиженияЗапасыВРемонтеИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияЗапасыВРемонтеИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыВРемонтеПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыВРемонтеИзменение КАК ДвиженияЗапасыВРемонтеИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыВРемонте.НомерСтроки,
		|	ЗапасыВРемонте.Номенклатура,
		|	ЗапасыВРемонте.Характеристика,
		|	ЗапасыВРемонте.Серия,
		|	ЗапасыВРемонте.СтруктурнаяЕдиница,
		|	ВЫБОР
		|		КОГДА ЗапасыВРемонте.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыВРемонте.Количество
		|		ИНАЧЕ -ЗапасыВРемонте.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыВРемонте КАК ЗапасыВРемонте
		|ГДЕ
		|	ЗапасыВРемонте.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыВРемонтеИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРемонтеИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыВРемонтеИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыВРемонтеИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗапасыВРемонтеИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыВРемонтеИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыВРемонтеИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыВРемонтеИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыВРемонтеИзменение.Серия КАК Серия,
	|	ДвиженияЗапасыВРемонтеИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СУММА(ДвиженияЗапасыВРемонтеИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыВРемонтеИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыВРемонтеИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыВРемонтеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыВРемонтеПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыВРемонтеПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыВРемонтеПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыВРемонтеПередЗаписью.Серия КАК Серия,
	|		ДвиженияЗапасыВРемонтеПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияЗапасыВРемонтеПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыВРемонтеПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыВРемонтеПередЗаписью КАК ДвиженияЗапасыВРемонтеПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыВРемонтеПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыВРемонтеПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыВРемонтеПриЗаписи.Характеристика,
	|		ДвиженияЗапасыВРемонтеПриЗаписи.Серия,
	|		ДвиженияЗапасыВРемонтеПриЗаписи.СтруктурнаяЕдиница,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыВРемонтеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыВРемонтеПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыВРемонтеПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыВРемонтеПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыВРемонте КАК ДвиженияЗапасыВРемонтеПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыВРемонтеПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыВРемонтеИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыВРемонтеИзменение.Номенклатура,
	|	ДвиженияЗапасыВРемонтеИзменение.Характеристика,
	|	ДвиженияЗапасыВРемонтеИзменение.Серия,
	|	ДвиженияЗапасыВРемонтеИзменение.СтруктурнаяЕдиница
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыВРемонтеИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	СтруктурнаяЕдиница");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыВРемонтеИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыВРемонтеИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыВРемонтеПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыВРемонтеПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли