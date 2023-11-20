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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыКРасходуСоСкладов.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыКРасходуСоСкладовИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыКРасходуСоСкладовИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыКРасходуСоСкладовИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыКРасходуСоСкладовИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыКРасходуСоСкладовПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос( 
		"ВЫБРАТЬ
		|	ЗапасыКРасходуСоСкладов.НомерСтроки КАК НомерСтроки,
		|	ЗапасыКРасходуСоСкладов.Организация КАК Организация,
		|	ЗапасыКРасходуСоСкладов.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ЗапасыКРасходуСоСкладов.Номенклатура КАК Номенклатура,
		|	ЗапасыКРасходуСоСкладов.Характеристика КАК Характеристика,
		|	ЗапасыКРасходуСоСкладов.Партия КАК Партия,
		|	ВЫБОР
		|		КОГДА ЗапасыКРасходуСоСкладов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыКРасходуСоСкладов.Количество
		|		ИНАЧЕ -ЗапасыКРасходуСоСкладов.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью,
		|	ЗапасыКРасходуСоСкладов.ДокументОснование КАК ДокументОснование,
		|	ЗапасыКРасходуСоСкладов.Ячейка КАК Ячейка
		|ПОМЕСТИТЬ ДвиженияЗапасыКРасходуСоСкладовПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыКРасходуСоСкладов КАК ЗапасыКРасходуСоСкладов
		|ГДЕ
		|	ЗапасыКРасходуСоСкладов.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыКРасходуСоСкладовИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыКРасходуСоСкладовПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос( 
		"ВЫБРАТЬ
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование КАК ДокументОснование,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Ячейка КАК Ячейка,
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыКРасходуСоСкладовПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение КАК ДвиженияЗапасыКРасходуСоСкладовИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыКРасходуСоСкладов.НомерСтроки,
		|	ЗапасыКРасходуСоСкладов.Организация,
		|	ЗапасыКРасходуСоСкладов.СтруктурнаяЕдиница,
		|	ЗапасыКРасходуСоСкладов.Номенклатура,
		|	ЗапасыКРасходуСоСкладов.Характеристика,
		|	ЗапасыКРасходуСоСкладов.Партия,
		|	ЗапасыКРасходуСоСкладов.ДокументОснование,
		|	ЗапасыКРасходуСоСкладов.Ячейка,
		|	ВЫБОР
		|		КОГДА ЗапасыКРасходуСоСкладов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыКРасходуСоСкладов.Количество
		|		ИНАЧЕ -ЗапасыКРасходуСоСкладов.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыКРасходуСоСкладов КАК ЗапасыКРасходуСоСкладов
		|ГДЕ
		|	ЗапасыКРасходуСоСкладов.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыКРасходуСоСкладовИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыКРасходуСоСкладовИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыКРасходуСоСкладовИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыКРасходуСоСкладовИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияЗапасыКРасходуСоСкладовИзменение".
	
	Запрос = Новый Запрос( 
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыКРасходуСоСкладовИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Партия КАК Партия,
	|	СУММА(ДвиженияЗапасыКРасходуСоСкладовИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыКРасходуСоСкладовИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыКРасходуСоСкладовИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование КАК ДокументОснование,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Ячейка КАК Ячейка
	|ПОМЕСТИТЬ ДвиженияЗапасыКРасходуСоСкладовИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.ДокументОснование КАК ДокументОснование,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.Ячейка КАК Ячейка,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыКРасходуСоСкладовПередЗаписью КАК ДвиженияЗапасыКРасходуСоСкладовПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Организация,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Характеристика,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Партия,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.ДокументОснование,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Ячейка,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыКРасходуСоСкладов КАК ДвиженияЗапасыКРасходуСоСкладовПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыКРасходуСоСкладовПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыКРасходуСоСкладовИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Организация,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.СтруктурнаяЕдиница,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Номенклатура,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Характеристика,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Партия,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование,
	|	ДвиженияЗапасыКРасходуСоСкладовИзменение.Ячейка
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыКРасходуСоСкладовИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	Номенклатура,
	|	Характеристика,
	|	Партия");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыКРасходуСоСкладовИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыКРасходуСоСкладовИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыКРасходуСоСкладовПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыКРасходуСоСкладовПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли