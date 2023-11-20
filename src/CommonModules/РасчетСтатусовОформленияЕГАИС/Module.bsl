// Механизм расчета статусов оформления документов ЕГАИС.
// 
// Для добавления нового документа-основания к документу ЕГАИС надо
//	- добавить ссылочный тип документа в определяемый тип с именем Основание<ИмяДокументаЕГАИС>
//	- добавить ссылочный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовЕГАИС
//	- добавить объектный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовЕГАИСОбъект
//
//	- дополнить процедуры общего модуля РасчетСтатусовОформленияЕГАИСПереопределяемый
//		- ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаЕГАИС()
//		- ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаЕГАИС()
//
// Для подключения документа ЕГАИС к этому механизму нужно:
//	- добавить его ссылочный тип в определяемый тип ДокументыЕГАИСПоддерживающиеСтатусыОформления
//	- добавить его объектный тип в определяемый тип ДокументыЕГАИСПоддерживающиеСтатусыОформленияОбъект
//	- добавить его объектный тип в определяемый тип ОснованиеСтатусыОформленияДокументовЕГАИСОбъект
//
//	- добавить в документ реквизит с именем ДокументОснования
//	- создать определяемый тип с именем Основание<ИмяДокументаЕГАИС>
//		- заполнить этот тип ссылочными типами документов-оснований
//
//	- добавить типы из определяемого типа Основание<ИмяДокументаЕГАИС> в ОснованиеСтатусыОформленияДокументовЕГАИС
//	- добавить соответствующие ссылочным объектные типы из определяемого типа Основание<ИмяДокументаЕГАИС> 
//	    в ОснованиеСтатусыОформленияДокументовЕГАИСОбъект
//
//	- дополнить процедуры общего модуля РасчетСтатусовОформленияЕГАИСПереопределяемый
//		- ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаЕГАИС()
//		- ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаЕГАИС()
//


#Область ПрограммныйИнтерфейс

#Область ОбработчикиПодписокНаСобытия

// Обработчик подписки на событие "Перед записью" документов ЕГАИС, поддерживающих статусы оформления.
// 
// Параметры:
//	Источник 		- ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформленияОбъект - записываемый объект
//	Отказ 			- Булево - параметр, определяющий будет ли записываться объект
//	РежимЗаписи 	- Булево - режим записи документа
//	РежимПроведения - Булево - режим проведения документа
//
Процедура РассчитатьСтатусОформленияЕГАИСПередЗаписьюДокументаОбработчик(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	РасчетСтатусовОформленияИС.ПередЗаписьюДокумента("ВестиСведенияДляДекларацийПоАлкогольнойПродукции", Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие "При записи" документов ЕГАИС, поддерживающих статусы оформления, и их документов-оснований.
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИСОбъект - записываемый объект
//	Отказ 	 - Булево - параметр, определяющий будет ли записываться объект
//
Процедура РассчитатьСтатусОформленияЕГАИСПриЗаписиДокументаОбработчик(Источник, Отказ) Экспорт
	
	РасчетСтатусовОформленияИС.ПриЗаписиДокумента("ВестиСведенияДляДекларацийПоАлкогольнойПродукции", Источник, Отказ, РасчетСтатусовОформленияЕГАИС);
	
КонецПроцедуры

#КонецОбласти

#Область ПересчетСтатусов

//Рассчитывает статусы оформления документов и записывает их в регистр сведений СтатусыОформленияДокументовЕГАИС.
//   ВАЖНО: все элементы массива Источники должны иметь одинаковый тип.
//
//Параметры:
//   Источники - Массив из ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС - 
//
Процедура РассчитатьСтатусыОформленияДокументовЕГАИС(Источники) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокументов("ВестиСведенияДляДекларацийПоАлкогольнойПродукции", Источники, РасчетСтатусовОформленияЕГАИС) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйнтерфейс

#Область ФункцииОбщегоМеханизма

//Возвращает признак, что документ ЕГАИС поддерживает статусы оформления (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ ЕГАИС поддерживающий статус оформления
//
Функция ЭтоДокументПоддерживающийСтатусОформления(Источник) Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыЕГАИСПоддерживающиеСтатусыОформленияОбъект.Тип.СодержитТип(ТипЗнч(Источник))
		Или Метаданные.ОпределяемыеТипы.ДокументыЕГАИСПоддерживающиеСтатусыОформления.Тип.СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//Возвращает признак, что проверяемый объект может являться основанием для документа ЕГАИС (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ-основание для документа ЕГАИС.
//
Функция ЭтоДокументОснование(Источник) Экспорт
	
	Возврат ТипОснование().СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//См. РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования.
//
//Возвращаемое значение:
//   Массив Из Строка - .
//
Функция ИменаДокументовДляДокументаОснования(ДокументОснование) Экспорт
	
	Возврат РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования(ДокументОснование,
		Метаданные.ОпределяемыеТипы.ДокументыЕГАИСПоддерживающиеСтатусыОформления.Тип);
	
КонецФункции

Функция МетаРеквизиты() Экспорт
	
	Возврат Метаданные.РегистрыСведений.СтатусыОформленияДокументовЕГАИС.Реквизиты;
	
КонецФункции

Функция ТипОснование() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ОснованиеСтатусыОформленияДокументовЕГАИС.Тип;
	
КонецФункции

Функция ТипДокумент() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыЕГАИС.Тип;
	
КонецФункции

#КонецОбласти

#Область Статусы

//Возвращает структуру с именами ключевых реквизитов документа-основания для документа ЕГАИС.
//   Значения этих реквизитов будут записаны в регистр сведений СтатусыОформленияДокументовЕГАИС.
//   Способ определения значения реквизита:
//     * Строка - имя реквизита документа-основания из которого следует взять значение (при обращении через
//     точку будет выполнено обращение к реквизиту первой строки одноименной ТЧ или к реквизиту реквизита основания);
//     * Произвольный - в т.ч. пустая строка - значение заполнения не зависящее от основания.
//
//Параметры:
//   МетаданныеОснования      - ОбъектМетаданныхДокумент - метаданные документа-основание из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС
//   МетаданныеДокументаЕГАИС - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления
//
//Возвращаемое значение:
//   Структура - имена реквизитов (в качестве типа приведен тип соответствующего реквизита):
//     * Проведен      - Булево - документ-основание проведен.
//     * Дата          - Дата   - дата основания.
//     * Номер         - Строка - номер основания.
//     * Ответственный - ОпределяемыйТип.Пользователь - пользователь, оформивший документ-основание; значение по умолчанию "Ответственный".
//     * Контрагент    - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация в документе-основании; значение по умолчанию "Организация".
//     * ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - торговая точка (склад) документа-основания; значение по умолчанию "Склад".
//
Функция РеквизитыДляРасчета(МетаданныеОснования, МетаданныеДокументаЕГАИС) Экспорт
	
	Реквизиты = Новый Структура;
	
	// Поля необходимости установки статуса
	Реквизиты.Вставить("Проведен", "Проведен");
	// Стандартные реквизиты
	Реквизиты.Вставить("Дата", "Дата");
	Реквизиты.Вставить("Номер", "Номер");
	// Переопределяемые реквизиты для отображения в списке к оформлению
	Реквизиты.Вставить("Ответственный", "Ответственный");
	Реквизиты.Вставить("Контрагент", "Организация");
	Реквизиты.Вставить("ТорговыйОбъект", "Склад");
	
	Если МетаданныеОснования = Метаданные.Документы.ТТНВходящаяЕГАИС Тогда
		Реквизиты.ТорговыйОбъект = "Грузополучатель.ТорговыйОбъект";
		Реквизиты.Контрагент = "Грузополучатель.Контрагент";
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.ТТНИсходящаяЕГАИС Тогда
		Реквизиты.ТорговыйОбъект = "Грузоотправитель.ТорговыйОбъект";
		Реквизиты.Контрагент = "Грузоотправитель.Контрагент";
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.УведомлениеОПланируемомИмпортеЕГАИС Тогда
		Реквизиты.ТорговыйОбъект = "ОрганизацияЕГАИС.ТорговыйОбъект";
		Реквизиты.Контрагент = "ОрганизацияЕГАИС.Контрагент";
	Иначе
		РасчетСтатусовОформленияЕГАИСПереопределяемый.ПриОпределенииРеквизитовОснования(
			МетаданныеОснования,
			МетаданныеДокументаЕГАИС,
			Реквизиты);
	КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

//Позволяет определить текст и параметры запроса выборки данных из документов-основания для расчета статуса оформления. 
//
//Параметры:
//   МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ЕГАИС>.
//   МетаданныеДокументаЕГАИС - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления.
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо определить.
//   ПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииЗапросаТоварыДокументаОснования(МетаданныеОснования, МетаданныеДокументаЕГАИС,
	ТекстЗапроса, ПараметрыЗапроса) Экспорт
	
	Если МетаданныеОснования = Метаданные.Документы.ТТНИсходящаяЕГАИС Тогда
		
		ТекстЗапроса = ИнтеграцияЕГАИС.ТекстЗапросаОрганизацииЕГАИСИспользующиеРегистр2();
		ТекстЗапроса = ТекстЗапроса + 
		";
		|ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка         КАК Ссылка,
		|	ЛОЖЬ                         КАК ЭтоДвижениеПриход,
		|	ТаблицаТовары.Номенклатура   КАК Номенклатура,
		|	ТаблицаТовары.Характеристика КАК Характеристика,
		|	ТаблицаТовары.Серия          КАК Серия,
		|	СУММА(1)                     КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РозничныеОрганизацииЕГАИС КАК РозничныеОрганизацииЕГАИС
		|		ПО ТаблицаТовары.Ссылка.Грузоотправитель = РозничныеОрганизацииЕГАИС.Ссылка
		|ГДЕ
		|	ТаблицаТовары.Ссылка В (&МассивДокументов)
		|	И ТаблицаТовары.Справка2 = ЗНАЧЕНИЕ(Справочник.Справки2ЕГАИС.Пустаяссылка)
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаТовары.Ссылка,
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Серия
		|";
	
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.УведомлениеОПланируемомИмпортеЕГАИС Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка            КАК Ссылка,
		|	ИСТИНА                          КАК ЭтоДвижениеПриход,
		|	ТаблицаТовары.Номенклатура      КАК Номенклатура,
		|	ТаблицаТовары.Характеристика    КАК Характеристика,
		|	ТаблицаТовары.Серия             КАК Серия,
		|	СУММА(ТаблицаТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Документ.УведомлениеОПланируемомИмпортеЕГАИС.Товары КАК ТаблицаТовары
		|ГДЕ
		|	ТаблицаТовары.Ссылка В (&МассивДокументов)
		|	И ТаблицаТовары.ИдентификаторУведомления <> """"
		|	И ТаблицаТовары.СтатусОбработки <> ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиУведомленияОПланируемомИмпортеЕГАИС.Отменен)
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаТовары.Ссылка,
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Серия
		|";
	
	КонецЕсли;
	
	РасчетСтатусовОформленияЕГАИСПереопределяемый.ПриОпределенииЗапросаТоварыДокументаОснования(
		МетаданныеОснования, МетаданныеДокументаЕГАИС, ТекстЗапроса, ПараметрыЗапроса);
	
КонецПроцедуры

//Рассчитывает статус оформления документа и записывает его в регистр сведений СтатусыОформленияДокументовЕГАИС.
//
//Параметры:
//   Источник - ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИСОбъект - источник необходимости расчета статуса.
//
Процедура РассчитатьСтатусОформленияДокумента(Источник) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокумента("ВестиСведенияДляДекларацийПоАлкогольнойПродукции", Источник, РасчетСтатусовОформленияЕГАИС) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

//Служебная. Дорабатывает полученную таблицу реквизитов и записывает статусы оформления. Специфика ЕГАИС.
//
//Параметры:
//   ТаблицаРеквизитов - ТаблицаЗначений - собранные общим механизмом реквизиты для записи статуса
//
Процедура ЗаписатьДляОснований(ТаблицаРеквизитов) Экспорт
	
	// Запишем статус оформления документа ЕГАИС.
	РасчетСтатусовОформленияИС.ЗаписатьСтатусОформленияДокументов(
		ТаблицаРеквизитов,
		РегистрыСведений.СтатусыОформленияДокументовЕГАИС,
		РасчетСтатусовОформленияЕГАИС);
	
КонецПроцедуры

//Возвращает признак необходимости записи в регистр "Статусы оформления документов ЕГАИС"
//
//Параметры:
//   ДокументОснование  - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС - записываемый в регистр документ-основание.
//   Реквизиты - См. РеквизитыДляРасчета - влияющие на запись значения реквизитов основания.
//   КоличествоСтрокДокументовОснования - Соответствие - количество строк основания требующих оформления.
//   ДополнительныеПараметры - Неопределено - не используется в подсистеме
//
//Возвращаемое значение:
//   Булево - признак необходимости записи
//
Функция ТребуетсяОформление(ДокументОснование, Реквизиты, КоличествоСтрокДокументовОснования, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если НЕ Реквизиты.Проведен Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрокДокументовОснования[ДокументОснование]);
	
КонецФункции

// Определяет текущий статус оформления документов ЕГАИС.
//   Особенности статуса оформления по сериям:
//     * Считается, что по одной номенклатуре в документе-основании серии либо указаны по всем строкам, либо отсутствуют.
//     * В случае, если в документе-основании серии не указаны, а в документе ЕГАИС указаны - это не ошибка оформления.
//   Возвращаемое соответствие в качестве ключей содержит ссылки на документы по которым происходит расчет, 
//     а в качестве значений - структуру с полями:
//     * СтатусОформления         - статус оформления объекта
//     * ДополнительнаяИнформация - информация для отладки.
//
// Параметры:
//   МассивДокументов         - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовЕГАИС - документы-основание для документа ЕГАИС
//   МетаданныеДокументаЕГАИС - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления
//   МенеджерВТ               - МенеджерВременныхТаблиц - (см. СформироватьТаблицуТоварыДокументовОснования)
//
// Возвращаемое значение:
//   Соответствие - расчетные статусы оформления документов.
//
Функция ОпределитьСтатусыОформленияДокументов(МассивДокументов, МетаданныеДокументаЕГАИС, МенеджерВТ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ОтборСтрокОформленныеТовары", Истина);
	Запрос.УстановитьПараметр("ПустаяСерия", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатуры"));
	
	ШаблонЗапросаВТОформленныеДокументы =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокументы.Ссылка КАК Ссылка,
	|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ОформленныеДокументы%1
	|ИЗ
	|	Документ.%1 КАК ТаблицаДокументы
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК Статусы
	|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
	|ГДЕ
	|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
	|	И ТаблицаДокументы.Проведен
	|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	
	ШаблонЗапросаОформленныеТовары = "
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
	|		%3 КАК ЭтоДвижениеПриход,
	|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
	|		ОформленныеТовары.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлениюССериями.Номенклатура ЕСТЬ NULL ТОГДА НЕОПРЕДЕЛЕНО
	|			ИНАЧЕ ОформленныеТовары.Серия КОНЕЦ КАК Серия,
	|		0                                КАК План,
	|		ОформленныеТовары.Количество     КАК Факт
	|	ИЗ
	|		Документ.%1.%2 КАК ОформленныеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
	|			И &ОтборСтрокОформленныеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКОформлениюССериями КАК ТоварыКОформлениюССериями
	|			ПО ОформленныеДокументы.ДокументОснование = ТоварыКОформлениюССериями.ДокументОснование
	|			И ОформленныеТовары.Номенклатура = ТоварыКОформлениюССериями.Номенклатура
	|			И ОформленныеТовары.Характеристика = ТоварыКОформлениюССериями.Характеристика
	|";
	
	ШаблонРазделительЗапросов = "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ИмяДокументаЕГАИС   = МетаданныеДокументаЕГАИС.Имя;
	
	Если МетаданныеДокументаЕГАИС = Метаданные.Документы.ТТНИсходящаяЕГАИС
		Или МетаданныеДокументаЕГАИС = Метаданные.Документы.ЧекЕГАИС
		Или МетаданныеДокументаЕГАИС = Метаданные.Документы.АктСписанияЕГАИС Тогда
		ЭтоДвижениеПриход = "ЛОЖЬ";
	Иначе
		ЭтоДвижениеПриход = "ИСТИНА";
	КонецЕсли;
	
	ТекстЗапросаВТОформленныеДокументы = СтрШаблон(ШаблонЗапросаВТОформленныеДокументы, ИмяДокументаЕГАИС) + ШаблонРазделительЗапросов;
	ТекстЗапросаОформленныеТовары = СтрШаблон(ШаблонЗапросаОформленныеТовары, ИмяДокументаЕГАИС, "Товары", ЭтоДвижениеПриход);
	
	Если МетаданныеДокументаЕГАИС = Метаданные.Документы.ОтчетОПроизводствеЕГАИС Тогда
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтрШаблон(
				ШаблонЗапросаОформленныеТовары,
				ИмяДокументаЕГАИС,
				"Сырье",
				"ЛОЖЬ");
				
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КонечныеСтатусы" + ИмяДокументаЕГАИС, Документы[ИмяДокументаЕГАИС].КонечныеСтатусы());
	
	ЧастиЗапроса = Новый Массив;
	ЧастиЗапроса.Добавить(ТекстЗапросаВТОформленныеДокументы);
	
	ЧастиЗапроса.Добавить(СтрШаблон("
		|ВЫБРАТЬ
		|	Товары.Ссылка         КАК ДокументОснование,
		|	Товары.Номенклатура   КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ ТоварыКОформлениюССериями
		|ИЗ 
		|	%1 КАК Товары
		|ГДЕ
		|	Товары.Серия НЕ В (&ПустаяСерия)
		|СГРУППИРОВАТЬ ПО
		|	Товары.Ссылка,
		|	Товары.Номенклатура,
		|	Товары.Характеристика
		|;
		|", РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента()));
		
	ЧастиЗапроса.Добавить(СтрШаблон("
		|ВЫБРАТЬ
		|	ТоварыКОформлению.ДокументОснование КАК ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура      КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика    КАК Характеристика,
		|	ТоварыКОформлению.Серия             КАК Серия,
		|	СУММА(ТоварыКОформлению.План)       КАК План,
		|	СУММА(ТоварыКОформлению.Факт)       КАК Факт
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.Ссылка 			 КАК ДокументОснование,
		|		Товары.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|		Товары.Номенклатура      КАК Номенклатура,
		|		Товары.Характеристика    КАК Характеристика,
		|		ВЫБОР
		|			КОГДА ТоварыКОформлениюССериями.Номенклатура ЕСТЬ NULL ТОГДА НЕОПРЕДЕЛЕНО
		|			ИНАЧЕ Товары.Серия КОНЕЦ КАК Серия,
		|		Товары.Количество        КАК План,
		|		0                        КАК Факт
		|	ИЗ
		|		%1 КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКОформлениюССериями КАК ТоварыКОформлениюССериями
		|			ПО Товары.Ссылка = ТоварыКОформлениюССериями.ДокументОснование
		|			И Товары.Номенклатура = ТоварыКОформлениюССериями.Номенклатура
		|			И Товары.Характеристика = ТоварыКОформлениюССериями.Характеристика
		|", РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента()));
	ЧастиЗапроса.Добавить(ТекстЗапросаОформленныеТовары);
	ЧастиЗапроса.Добавить("
		|	) КАК ТоварыКОформлению
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Серия
		|");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт > 0 И Т.План > 0 	   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт >= 0 И Т.План > Т.Факт ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьНеОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План <= Т.Факт 			   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьПолностьюОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План < Т.Факт 			   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОшибкиОформления
		|ПОМЕСТИТЬ РезультатПоДокументам
		|ИЗ
		|	Результат КАК Т
		|СГРУППИРОВАТЬ ПО
		|	Т.ДокументОснование");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА Т.ЕстьОшибкиОформления
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовЕГАИС.ЕстьОшибкиОформления)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И НЕ Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовЕГАИС.Оформлено)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовЕГАИС.ОформленоЧастично)
		|		КОГДА Т.ЕстьОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовЕГАИС.ОформленоЧастично)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовЕГАИС.НеОформлено)
		|	КОНЕЦ КАК СтатусОформления
		|ИЗ
		|	РезультатПоДокументам КАК Т");
	
	Запрос.Текст = СтрСоединить(ЧастиЗапроса);
	
	// Получим данные и определим статус оформления документа ЕГАИС.
	
	СтатусОформления = Новый Структура(
		"СтатусОформления, ДополнительнаяИнформация",
		Перечисления.СтатусыОформленияДокументовЕГАИС.НеОформлено,
		Неопределено);
	
	Результат = ИнтеграцияИСКлиентСервер.МассивВСоответствие(МассивДокументов, СтатусОформления);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка   = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос.Текст = "ВЫБРАТЬ * ИЗ Результат КАК Т ГДЕ Т.ДокументОснование = &ДокументОснование";
	
	Пока Выборка.Следующий() Цикл
		
		Запрос.УстановитьПараметр("ДокументОснование", Выборка.ДокументОснование);
		
		// Сохраним данные, использовавшиеся для расчета статуса.
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаДляРасчетаСтатуса = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
	
		ТаблицаДляРасчетаСтатуса.Колонки.ЭтоДвижениеПриход.Заголовок = НСтр("ru='Приходное движение'");
		ТаблицаДляРасчетаСтатуса.Колонки.План.Заголовок 			 = НСтр("ru='По документу-основанию'");
		ТаблицаДляРасчетаСтатуса.Колонки.Факт.Заголовок 			 = НСтр("ru='По документу ЕГАИС'");
		
		ДополнительнаяИнформация = Новый ХранилищеЗначения(ТаблицаДляРасчетаСтатуса, Новый СжатиеДанных(9));
		
		СтатусОформления = Новый Структура(
			"СтатусОформления, ДополнительнаяИнформация",
			Выборка.СтатусОформления,
			ДополнительнаяИнформация);
		
		Результат.Вставить(Выборка.ДокументОснование, СтатусОформления);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
