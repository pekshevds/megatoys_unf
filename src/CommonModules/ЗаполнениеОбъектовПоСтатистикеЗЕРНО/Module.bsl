#Область СлужебныйПрограммныйИнтерфейс

// Заполнение документа "Формирование партии ЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * ЦельИспользования                - СправочникСсылка.КлассификаторНСИЗЕРНО
//  * Организация                      - ОпределяемыйТип.Организация.
//  * Подразделение                    - ОпределяемыйТип.Подразделение.
//  * Операция                         - ПеречислениеСсылка.ВидыОперацийЗЕРНО
//  * ВидПродукции                     - ПеречислениеСсылка.ВидыПродукцииИС
//  * НазначениеПартии                 - СправочникСсылка.КлассификаторНСИЗЕРНО
//  * СтранаНазначения                 - СправочникСсылка.СтраныМира
//  * ГодУрожая                        - Число
//  * ВладелецПартии                   - ОпределяемыйТип.ОрганизацияКонтрагентГосИС.
//  * ПодразделениеВладельцаПартии     - ОпределяемыйТип.Подразделение
//  * ПоставитьПартиюНаХранение        - Булево
//  * Товаропроизводитель              - ОпределяемыйТип.ОрганизацияКонтрагентГосИС
//  * ПодразделениеТоваропроизводителя - ОпределяемыйТип.Подразделение.
Функция ДанныеЗаполненияФормированиеПартийЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",                  ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение",                ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ВидПродукции",                 Перечисления.ВидыПродукцииИС.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Операция",                     Перечисления.ВидыОперацийЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НазначениеПартии",             Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("СтранаНазначения",             Неопределено);
	ДанныеЗаполнения.Вставить("ГодУрожая",                    2000);
	ДанныеЗаполнения.Вставить("ЦельИспользования",            Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ВладелецПартии",               ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("ОрганизацияКонтрагентГосИС"));
	ДанныеЗаполнения.Вставить("ПодразделениеВладельцаПартии", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ПоставитьПартиюНаХранение",    Ложь);
	
	ДанныеЗаполнения.Вставить("Товаропроизводитель",              ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("ОрганизацияКонтрагентГосИС"));
	ДанныеЗаполнения.Вставить("ПодразделениеТоваропроизводителя", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                                         КАК Количество,
	|	Документ.Организация                      КАК Организация,
	|	Документ.Подразделение                    КАК Подразделение,
	|	Документ.ВидПродукции                     КАК ВидПродукции,
	|	Документ.ВладелецПартии                   КАК ВладелецПартии,
	|	Документ.ПодразделениеВладельцаПартии     КАК ПодразделениеВладельцаПартии,
	|	Документ.ПоставитьПартиюНаХранение        КАК ПоставитьПартиюНаХранение,
	|	Документ.Операция                         КАК Операция,
	|	Документ.НазначениеПартии                 КАК НазначениеПартии,
	|	Документ.СтранаНазначения                 КАК СтранаНазначения,
	|	Документ.ГодУрожая                        КАК ГодУрожая,
	|	Документ.ЦельИспользования                КАК ЦельИспользования,
	|	Документ.Товаропроизводитель              КАК Товаропроизводитель,
	|	Документ.ПодразделениеТоваропроизводителя КАК ПодразделениеТоваропроизводителя
	|ИЗ
	|	Документ.ФормированиеПартийЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.ВидПродукции = ВидПродукции(ДанныеПоследнихДокументов);
	
	ЗаполнитьПоСтатистике(
		"Организация",
		ДанныеЗаполнения, ДанныеПоследнихДокументов, "ВидПродукции");
		
	Если ДанныеЗаполнения.ВидПродукции = Перечисления.ВидыПродукцииИС.ПродуктыПереработкиЗерна Тогда
		ЗаполнитьПоСтатистике(
			"Подразделение, Операция, НазначениеПартии, ЦельИспользования,
			|Товаропроизводитель, ПодразделениеТоваропроизводителя",
			ДанныеЗаполнения, ДанныеПоследнихДокументов, "Организация, ВидПродукции");
	ИначеЕсли ДанныеЗаполнения.ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
		ЗаполнитьПоСтатистике(
			"Подразделение, Операция, НазначениеПартии, ЦельИспользования, СтранаНазначения,
			|ВладелецПартии, ПодразделениеВладельцаПартии,
			|ГодУрожая, ПоставитьПартиюНаХранение",
			ДанныеЗаполнения, ДанныеПоследнихДокументов, "Организация, ВидПродукции");
	КонецЕсли;
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ВидПродукции) Тогда
		ДанныеЗаполнения.ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Операция) Тогда
		Если ДанныеЗаполнения.ВидПродукции = Перечисления.ВидыПродукцииИС.ПродуктыПереработкиЗерна Тогда
			ДанныеЗаполнения.Операция          = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИзОстатков;
		Иначе
			ДанныеЗаполнения.Операция          = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииПриСбореУрожая;
			ДанныеЗаполнения.ГодУрожая         = Год(ТекущаяУниверсальнаяДата());
		КонецЕсли;
		ДанныеЗаполнения.НазначениеПартии  = Справочники.КлассификаторНСИЗЕРНО.НазначениеПартииХранениеОбработка;
		ДанныеЗаполнения.ЦельИспользования = Справочники.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииПищевые;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа "Формирование партии из других партий ЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация.
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * ЦельИспользования - СправочникСсылка.КлассификаторНСИЗЕРНО
//  * Организация       - ОпределяемыйТип.Организация.
//  * Подразделение     - ОпределяемыйТип.Подразделение.
//  * ВидПродукции      - ПеречислениеСсылка.ВидыПродукцииИС
//  * Операция          - ПеречислениеСсылка.ВидыОперацийЗЕРНО
//  * НазначениеПартии  - СправочникСсылка.КлассификаторНСИЗЕРНО
//  * ВладелецПартии    - ОпределяемыйТип.ОрганизацияКонтрагентГосИС.
Функция ДанныеЗаполненияФормированиеПартийИзДругихПартийЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",                  ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение",                ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ВидПродукции",                 Перечисления.ВидыПродукцииИС.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Операция",                     Перечисления.ВидыОперацийЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НазначениеПартии",             Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ЦельИспользования",            Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ВладелецПартии",               ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("ОрганизацияКонтрагентГосИС"));
	ДанныеЗаполнения.Вставить("ПодразделениеВладельцаПартии", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ГодУрожая",                    2000);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                                     КАК Количество,
	|	Документ.Организация                  КАК Организация,
	|	Документ.Подразделение                КАК Подразделение,
	|	Документ.ВидПродукции                 КАК ВидПродукции,
	|	Документ.Операция                     КАК Операция,
	|	Документ.ВладелецПартии               КАК ВладелецПартии,
	|	Документ.ПодразделениеВладельцаПартии КАК ПодразделениеВладельцаПартии,
	|	Документ.НазначениеПартии             КАК НазначениеПартии,
	|	Документ.ГодУрожая                    КАК ГодУрожая,
	|	Документ.ЦельИспользования            КАК ЦельИспользования
	|ИЗ
	|	Документ.ФормированиеПартийИзДругихПартийЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.ВидПродукции = ВидПродукции(ДанныеПоследнихДокументов);
	
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение, Операция, НазначениеПартии, ЦельИспользования, ВладелецПартии, ПодразделениеВладельцаПартии, ГодУрожая",
		ДанныеЗаполнения, ДанныеПоследнихДокументов, "ВидПродукции");
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ВидПродукции) Тогда
		ДанныеЗаполнения.ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Операция) Тогда
		ДанныеЗаполнения.Операция          = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИзДругихПартий;
		ДанныеЗаполнения.НазначениеПартии  = Справочники.КлассификаторНСИЗЕРНО.НазначениеПартииХранениеОбработка;
		ДанныеЗаполнения.ЦельИспользования = Справочники.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииПищевые;
		ДанныеЗаполнения.ГодУрожая         = Год(ТекущаяУниверсальнаяДата());
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа "Формирование партии при производстве ЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация.
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * ЦельИспользования   - СправочникСсылка.КлассификаторНСИЗЕРНО
//  * Организация         - ОпределяемыйТип.Организация
//  * Подразделение       - ОпределяемыйТип.Подразделение.
//  * Товаропроизводитель - ОпределяемыйТип.ОрганизацияКонтрагентГосИС.
//  * НазначениеПартии    - СправочникСсылка.КлассификаторНСИЗЕРНО
Функция ДанныеЗаполненияФормированиеПартийПриПроизводствеЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",         ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение",       ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("Товаропроизводитель", Неопределено);
	ДанныеЗаполнения.Вставить("НазначениеПартии",    Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ЦельИспользования",   Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                             КАК Количество,
	|	Документ.Организация          КАК Организация,
	|	Документ.Подразделение        КАК Подразделение,
	|	Документ.НазначениеПартии     КАК НазначениеПартии,
	|	Документ.ЦельИспользования    КАК ЦельИспользования,
	|	Документ.Товаропроизводитель  КАК Товаропроизводитель
	|ИЗ
	|	Документ.ФормированиеПартийПриПроизводствеЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение, НазначениеПартии, ЦельИспользования, Товаропроизводитель",
		ДанныеЗаполнения, ДанныеПоследнихДокументов);
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.НазначениеПартии) Тогда
		ДанныеЗаполнения.НазначениеПартии  = Справочники.КлассификаторНСИЗЕРНО.НазначениеПартииХранениеОбработка;
		ДанныеЗаполнения.ЦельИспользования = Справочники.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииПищевые;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа ЗапросОстатковПартийЗЕРНО по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * Организация    - ОпределяемыйТип.Организация.
//  * Подразделение  - ОпределяемыйТип.Подразделение.
//  * ВидПродукции   - ПеречислениеСсылка.ВидыПродукцииИС
//  * Операция       - ПеречислениеСсылка.ВидыОперацийЗЕРНО
//  * ВладелецПартии - ОпределяемыйТип.ОрганизацияКонтрагентГосИС
//  * Элеватор       - ОпределяемыйТип.ОрганизацияКонтрагентГосИС
Функция ДанныеЗаполненияЗапросаОстатковПартийЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",                  ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение",                ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ВидПродукции",                 Перечисления.ВидыПродукцииИС.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Операция",                     Перечисления.ВидыОперацийЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ВладелецПартии",               ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("ОрганизацияКонтрагентГосИС"));
	ДанныеЗаполнения.Вставить("ПодразделениеВладельцаПартии", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("Элеватор",                     ДанныеЗаполнения.ВладелецПартии);
	ДанныеЗаполнения.Вставить("ПодразделениеЭлеватора",       ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                                     КАК Количество,
	|	Документ.Организация                  КАК Организация,
	|	Документ.Операция                     КАК Операция,
	|	Документ.Подразделение                КАК Подразделение,
	|	Документ.ВладелецПартии               КАК ВладелецПартии,
	|	Документ.ПодразделениеВладельцаПартии КАК ПодразделениеВладельцаПартии,
	|	Документ.ВидПродукции                 КАК ВидПродукции,
	|	Документ.Элеватор                     КАК Элеватор,
	|	Документ.ПодразделениеЭлеватора       КАК ПодразделениеЭлеватора
	|ИЗ
	|	Документ.ЗапросОстатковПартийЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|	И Документ.Операция <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗЕРНО.ЗагрузкаОстатковПартий)
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.ВидПродукции = ВидПродукции(ДанныеПоследнихДокументов);
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение, Операция, ВладелецПартии, ПодразделениеВладельцаПартии, Элеватор, ПодразделениеЭлеватора",
		ДанныеЗаполнения, ДанныеПоследнихДокументов, "ВидПродукции");
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ВидПродукции) Тогда
		ВидыПродукции = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
		Если ВидыПродукции.Количество() Тогда
			ДанныеЗаполнения.ВидПродукции = ВидыПродукции[0];
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа ВнесениеСведенийОСобранномУрожаеЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * Организация   - ОпределяемыйТип.Организация.
//  * Подразделение - ОпределяемыйТип.Подразделение.
//  * Склад         - ОпределяемыйТип.Склад
Функция ДанныеЗаполненияВнесениеСведенийОСобранномУрожаеЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",   ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                      КАК Количество,
	|	Документ.Организация   КАК Организация,
	|	Документ.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.ВнесениеСведенийОСобранномУрожаеЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.Организация = Организация(ДанныеПоследнихДокументов);
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение",
		ДанныеЗаполнения, ДанныеПоследнихДокументов);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа "Списание партии ЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * ЦельИспользования - СправочникСсылка.КлассификаторНСИЗЕРНО
//  * Организация       - ОпределяемыйТип.Организация.
//  * Подразделение     - ОпределяемыйТип.Подразделение.
//  * ВидПродукции      - ПеречислениеСсылка.ВидыПродукцииИС
//  * Операция          - ПеречислениеСсылка.ВидыОперацийЗЕРНО
//  * НазначениеПартии  - СправочникСсылка.КлассификаторНСИЗЕРНО
Функция ДанныеЗаполненияСписаниеПартийЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",     ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение",   ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ВидПродукции",    Перечисления.ВидыПродукцииИС.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Склад",           ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Склад"));
	ДанныеЗаполнения.Вставить("ПричинаСписания", Справочники.КлассификаторНСИЗЕРНО.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ОписаниеПричины", "");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                          КАК Количество,
	|	Документ.Организация       КАК Организация,
	|	Документ.Подразделение     КАК Подразделение,
	|	Документ.ВидПродукции      КАК ВидПродукции,
	|	Документ.Склад             КАК Склад,
	|	Документ.ПричинаСписания   КАК ПричинаСписания,
	|	Документ.ОписаниеПричины   КАК ОписаниеПричины
	|ИЗ
	|	Документ.СписаниеПартийЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.ВидПродукции = ВидПродукции(ДанныеПоследнихДокументов);
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение, Склад, ПричинаСписания, ОписаниеПричины",
		ДанныеЗаполнения, ДанныеПоследнихДокументов, "ВидПродукции");
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ВидПродукции) Тогда
		ВидыПродукции = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
		Если ВидыПродукции.Количество() Тогда
			ДанныеЗаполнения.ВидПродукции = ВидыПродукции[0];
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа "Оформление СДИЗ ЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация.
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * Организация - ОпределяемыйТип.Организация
//  * Подразделение - ОпределяемыйТип.Подразделение
//  * ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС
//  * Операция - ПеречислениеСсылка.ВидыОперацийЗЕРНО
Функция ДанныеЗаполненияОформлениеСДИЗЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",   ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ВидПродукции",  Перечисления.ВидыПродукцииИС.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Операция",      Перечисления.ВидыОперацийЗЕРНО.ПустаяСсылка());
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                          КАК Количество,
	|	Документ.Организация       КАК Организация,
	|	Документ.Подразделение     КАК Подразделение,
	|	Документ.ВидПродукции      КАК ВидПродукции,
	|	Документ.Операция          КАК Операция
	|ИЗ
	|	Документ.ОформлениеСДИЗЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.ВидПродукции = ВидПродукции(ДанныеПоследнихДокументов);
	
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение, Операция",
		ДанныеЗаполнения, ДанныеПоследнихДокументов, "ВидПродукции");
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ВидПродукции) Тогда
		ДанныеЗаполнения.ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Операция) Тогда
		ДанныеЗаполнения.Операция          = Перечисления.ВидыОперацийЗЕРНО.ОформлениеСДИЗРФ;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Заполнение документа "Погашение СДИЗ ЗЕРНО" по статистике
// Параметры:
//  Организация - ОпределяемыйТип.Организация.
//
// Возвращаемое значение:
//	Структура - данные заполнения:
//  * Организация   - ОпределяемыйТип.Организация.
//  * Подразделение - ОпределяемыйТип.Подразделение.
//  * ВидПродукции  - ПеречислениеСсылка.ВидыПродукцииИС
//  * Операция      - ПеречислениеСсылка.ВидыОперацийЗЕРНО
Функция ДанныеЗаполненияПогашениеСДИЗЗЕРНО(Организация) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация",   ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация"));
	ДанныеЗаполнения.Вставить("Подразделение", ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение"));
	ДанныеЗаполнения.Вставить("ВидПродукции",  Перечисления.ВидыПродукцииИС.ПустаяСсылка());
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 3
	|	1                          КАК Количество,
	|	Документ.Организация       КАК Организация,
	|	Документ.Подразделение     КАК Подразделение,
	|	Документ.ВидПродукции      КАК ВидПродукции
	|ИЗ
	|	Документ.ПогашениеСДИЗЗЕРНО КАК Документ
	|ГДЕ
	|	(Документ.Организация = &Организация Или &БезУчетаОрганизации)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Документ.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("БезУчетаОрганизации", Не ЗначениеЗаполнено(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПоследнихДокументов = РезультатЗапроса.Выгрузить();
	
	ДанныеЗаполнения.ВидПродукции = ВидПродукции(ДанныеПоследнихДокументов);
	
	ЗаполнитьПоСтатистике(
		"Организация, Подразделение",
		ДанныеЗаполнения, ДанныеПоследнихДокументов, "ВидПродукции");
	
	// Значения по-умолчанию
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ВидПродукции) Тогда
		ВидыПродукции = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
		Если ВидыПродукции.Количество() Тогда
			ДанныеЗаполнения.ВидПродукции = ВидыПродукции[0];
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

Процедура ЗаполнитьПустойРеквизит(Объект, ДанныеСтатистики, ИмяРеквизита) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект[ИмяРеквизита])
		Или ТипЗнч(Объект[ИмяРеквизита]) = Тип("Булево") Тогда
		Объект[ИмяРеквизита] = ДанныеСтатистики[ИмяРеквизита];
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВидПродукции(ДанныеПоследнихДокументов)
	
	ДанныеАнализа = ДанныеПоследнихДокументов.Скопировать(,"ВидПродукции, Количество");
	ДанныеАнализа.Свернуть("ВидПродукции", "Количество");
	ДанныеАнализа.Сортировать("Количество Убыв");
	Если ДанныеАнализа.Количество() > 0 Тогда
		ВидПродукции = ДанныеАнализа[0].ВидПродукции;
	КонецЕсли;
	
	Возврат ВидПродукции;
	
КонецФункции

Процедура ЗаполнитьПоСтатистике(Поля, ДанныеЗаполнения, ДанныеПоследнихДокументов, ПоляОтбора = "Организация")
	
	Отбор = Новый Структура;
	ОтбираемыеПоля = СтрРазделить(ПоляОтбора, ",");
	
	Для Каждого ПолеОтбора Из ОтбираемыеПоля Цикл
		ИмяПоля = СокрЛП(ПолеОтбора);
		Если ДанныеЗаполнения[ИмяПоля] <> Неопределено Тогда
			Отбор.Вставить(ИмяПоля, ДанныеЗаполнения[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	Если Отбор.Количество() = 0 Тогда
		Отбор = Неопределено;
	КонецЕсли;
	
	ЗаполняемыеПоля = СтрРазделить(Поля, ",");
	
	РезультатыАнализа = ДанныеПоследнихДокументов.Скопировать(
		Отбор, Поля + ", Количество");
	
	РезультатыАнализа.Свернуть(Поля, "Количество");
	РезультатыАнализа.Сортировать("Количество Убыв");
	Если РезультатыАнализа.Количество() > 0 Тогда
		Для Каждого Поле Из ЗаполняемыеПоля Цикл
			ИмяПоля = СокрЛП(Поле);
			ДанныеЗаполнения[ИмяПоля] = РезультатыАнализа[0][ИмяПоля];
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция Организация(ДанныеПоследнихДокументов)
	
	ДанныеАнализа = ДанныеПоследнихДокументов.Скопировать(,"Организация, Количество");
	ДанныеАнализа.Свернуть("Организация", "Количество");
	ДанныеАнализа.Сортировать("Количество Убыв");
	Если ДанныеАнализа.Количество() > 0 Тогда
		Организация = ДанныеАнализа[0].Организация;
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции

#КонецОбласти
