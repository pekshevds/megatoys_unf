////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборот3ВызовСервера: сервер, вызов сервера
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область АсинхронныеОперации

// Получает HTML предпросмотр объекта из Документооборота в фоновом задании.
//
// Параметры:
//   УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы, из которой выполняется запрос.
//   ID - Строка - уникальный идентификатор объекта в Документообороте.
//   Тип - Строка - имя типа XDTO.
//
// Возвращаемое значение:
//   см. ДлительныеОперации.ВыполнитьВФоне
//
Функция ПолучитьHTMLПредпросмотрОбъектаАсинхронно(УникальныйИдентификатор, ID, Тип) Экспорт
	
	ПараметрыДлительнойОперации = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПараметрыДлительнойОперации();
	ПараметрыДлительнойОперации.Вставить("ID", ID);
	ПараметрыДлительнойОперации.Вставить("Тип", Тип);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // Запускать сразу.
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Получение HTML предпросмотра объекта из 1С:Документооборот'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияС1СДокументооборот3.ПолучитьHTMLПредпросмотрОбъектаВФоне",
		ПараметрыДлительнойОперации,
		ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

// Возвращает навигационную ссылку, по которой открывается связанная база 1С:Документооборот.
//
// Параметры:
//   БезАвторизации - Булево - к навигационной ссылке следует добавить параметры авторизации.
//
// Возвращаемое значение:
//   Строка
//
Функция НавигационнаяСсылкаБазыДО(БезАвторизации = Ложь) Экспорт
	
	АдресВебСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.АдресВебСервиса1СДокументооборот();
	
	Если БезАвторизации = Ложь
			И ПараметрыСеанса.ИнтеграцияС1СДокументооборотПарольИзвестен
			И Не ПараметрыСеанса.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияОС
			И Не ПараметрыСеанса.ИнтеграцияС1СДокументооборотИспользуетсяАутентификацияJWT Тогда
		Адрес = СтрШаблон("%1?N=%2&P=%3",
			АдресВебСервиса,
			ПараметрыСеанса.ИнтеграцияС1СДокументооборотИмяПользователя,
			ПараметрыСеанса.ИнтеграцияС1СДокументооборотПароль);
	Иначе
		Адрес = АдресВебСервиса;
	КонецЕсли;
	
	Возврат Адрес;
	
КонецФункции

// Стартует в 1С:Документооборот обработку объекта.
//
// Параметры:
//   ОбъектДО - Структура- объект ДО, обработку которого требуется запустить:
//     * ID - Строка
//     * type - Строка
//     * name - Строка
//     * ВнешнийОбъект - ЛюбаяСсылка - ссылка на связанный объект ИС.
//   ТекстОшибки - Строка - неявно возвращаемое значение, текст сообщения об ошибке.
//
// Возвращаемое значение:
//   Булево - Истина, если обработка была запущена успешно.
//
Функция НачатьОбработку(ОбъектДО, ТекстОшибки) Экспорт
	
	Успешно = Истина;
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMStartProcessingRequest");
	
	Запрос.object = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ОбъектДО.ID,
		ОбъектДО.type);
	
	ВнешнийОбъект = Неопределено;
	ОбъектДО.Свойство("ВнешнийОбъект", ВнешнийОбъект);
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоСуществует(Запрос, "link")
			И ЗначениеЗаполнено(ВнешнийОбъект) Тогда
		Запрос.link = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьDMLink(
			Прокси,
			ОбъектДО.ID,
			ОбъектДО.type,
			ВнешнийОбъект);
	КонецЕсли;
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, Ответ, "DMError") Тогда
		Успешно = Ложь;
		ТекстОшибки = СокрЛП(Ответ.description);
		// Запишем в ЖР полный текст ошибки.
		ЗаписьЖурналаРегистрации(
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(Ответ.subject),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
	КонецЕсли;
	
	Возврат Успешно;
	
КонецФункции

// Получает из Документооборота подходящие для указанного типа объекта ИС правила загрузки данных в ДО.
//
// Параметры:
//   ТипОбъектаИС - Строка - полное имя типа объекта ИС.
//   ПравилаЗагрузкиXDTO - СписокXDTO - список правил загрузки, которые в целях оптимизации могли быть
//      получены ранее в пакетном запросе к 1С:Документооборот.
//
// Возвращаемое значение:
//   Массив из Структура:
//     * ПравилоЗагрузкиВДО - Строка
//     * ПравилоЗагрузкиВДОID - Строка
//     * ТипОбъектаДО - Строка
//     * ВидДокументаДО - Строка
//     * ВидДокументаДОID - Строка
//
Функция ПодходящиеПравилаЗагрузкиВДО(ТипОбъектаИС, Знач ПравилаЗагрузкиXDTO = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ТипОбъектаИС) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ПравилаЗагрузкиXDTO = Неопределено Тогда
		Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
		
		Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetDataLoadingRulesRequest");
		Запрос.externalObjectType = ТипОбъектаИС;
		
		Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
		
		ПравилаЗагрузкиXDTO = Ответ.dataLoadingRules;
	КонецЕсли;
	
	Для Каждого ПравилоЗагрузкиXDTO Из ПравилаЗагрузкиXDTO Цикл
		Правило = Новый Структура;
		
		Правило.Вставить("ПравилоЗагрузкиВДО", ПравилоЗагрузкиXDTO.objectName);
		Правило.Вставить("ПравилоЗагрузкиВДОID", ПравилоЗагрузкиXDTO.objectID.id);
		Правило.Вставить("НавигационнаяСсылка", ПравилоЗагрузкиXDTO.objectID.navigationRef);
		
		Правило.Вставить("ТипОбъектаДО", ПравилоЗагрузкиXDTO.objectType);
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ПравилоЗагрузкиXDTO, "documentType") Тогда
			Правило.Вставить("ВидДокументаДО", ПравилоЗагрузкиXDTO.documentType.name);
			Правило.Вставить("ВидДокументаДОID", ПравилоЗагрузкиXDTO.documentType.objectID.id);
		КонецЕсли;
		
		Результат.Добавить(Правило);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Подбирает для переданных объектов ИС подходящие им правила интеграции.
//
// Параметры:
//   СписокОбъектовИС - Массив из ОпределяемыйТип.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый - список
//     объектов ИС, для которых требуется подобрать подходящие правила интеграции.
//   ТолькоПриоритетные - Булево - правила будут отсортированы по приоритету, и в выборку попадут только
//     правила с наивысшим приоритетом. Чем больше ключевых реквизитов правила совпало со значениями реквизитов
//     объекта ИС, тем выше приоритет правила для данного конкретного объекта ИС.
//   СвернутьПоПравилуДО - Булево - свернуть итоговый список подходящих правил интеграции по указанной в них
//     ссылке на правило загрузки данных в ДО.
//
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//     * Ключ - ОпределяемыйТип.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый - объект ИС.
//     * Значение - Массив из СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом3 - список подходящих правил.
//
Функция ПодходящиеПравилаИнтеграции(СписокОбъектовИС, ТолькоПриоритетные = Ложь, СвернутьПоПравилуДО = Ложь) Экспорт
	
	Результат = Новый Соответствие;
	
	Если СписокОбъектовИС.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Сформируем массив из типов переданных объектов ИС без повторений.
	МассивТиповОбъектовИС = Новый Массив;
	Для Каждого ОбъектИС Из СписокОбъектовИС Цикл
		ТипОбъектаИС = ОбъектИС.Метаданные().ПолноеИмя();
		Если МассивТиповОбъектовИС.Найти(ТипОбъектаИС) = Неопределено Тогда
			МассивТиповОбъектовИС.Добавить(ТипОбъектаИС);
		КонецЕсли;
	КонецЦикла;
	
	// Найдем правила интеграции, соответствующие указанным типам.
	// Выберем имена и значения, указанных в них ключевых реквизитов.
	ЗапросВсеПравила = Новый Запрос(
		"ВЫБРАТЬ
		|	ПравилаИнтеграцииС1СДокументооборотом3.ТипОбъектаИС КАК ТипОбъектаИС,
		|	ПравилаИнтеграцииС1СДокументооборотом3.Ссылка КАК Правило,
		|	ПравилаИнтеграцииС1СДокументооборотом3.ПравилоЗагрузкиДанныхВДО КАК ПравилоЗагрузкиДанныхВДО,
		|	ПравилаИнтеграцииС1СДокументооборотом3КлючевыеРеквизитыИС.Имя КАК ИмяРеквизита,
		|	ПравилаИнтеграцииС1СДокументооборотом3КлючевыеРеквизитыИС.ЭтоДополнительныйРеквизитИС КАК ЭтоДополнительныйРеквизитИС,
		|	ПравилаИнтеграцииС1СДокументооборотом3КлючевыеРеквизитыИС.ЗначениеРеквизита КАК Значение
		|ПОМЕСТИТЬ ВсеПравила
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом3 КАК ПравилаИнтеграцииС1СДокументооборотом3
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаИнтеграцииС1СДокументооборотом3.КлючевыеРеквизитыИС КАК ПравилаИнтеграцииС1СДокументооборотом3КлючевыеРеквизитыИС
		|		ПО (ПравилаИнтеграцииС1СДокументооборотом3КлючевыеРеквизитыИС.Ссылка = ПравилаИнтеграцииС1СДокументооборотом3.Ссылка)
		|ГДЕ
		|	НЕ ПравилаИнтеграцииС1СДокументооборотом3.ПометкаУдаления
		|	И ПравилаИнтеграцииС1СДокументооборотом3.ТипОбъектаИС В(&МассивТиповОбъектовИС)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеПравила.ТипОбъектаИС КАК ТипОбъектаИС,
		|	ВсеПравила.Правило КАК Правило,
		|	ВсеПравила.ПравилоЗагрузкиДанныхВДО КАК ПравилоЗагрузкиДанныхВДО,
		|	ВсеПравила.ИмяРеквизита КАК ИмяРеквизита,
		|	ВсеПравила.ЭтоДополнительныйРеквизитИС КАК ЭтоДополнительныйРеквизитИС,
		|	ВсеПравила.Значение КАК Значение
		|ИЗ
		|	ВсеПравила КАК ВсеПравила
		|ИТОГИ
		|	МАКСИМУМ(ПравилоЗагрузкиДанныхВДО)
		|ПО
		|	ТипОбъектаИС,
		|	Правило
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВсеПравила.ТипОбъектаИС КАК ТипОбъектаИС,
		|	ВЫБОР
		|		КОГДА ВсеПравила.ЭтоДополнительныйРеквизитИС
		|			ТОГДА """"
		|		ИНАЧЕ ВсеПравила.ИмяРеквизита
		|	КОНЕЦ КАК ИмяРеквизита,
		|	ВсеПравила.ЭтоДополнительныйРеквизитИС КАК ЭтоДополнительныйРеквизитИС
		|ИЗ
		|	ВсеПравила КАК ВсеПравила
		|ГДЕ
		|	НЕ ВсеПравила.ИмяРеквизита ЕСТЬ NULL
		|ИТОГИ ПО
		|	ТипОбъектаИС");
	ЗапросВсеПравила.УстановитьПараметр("МассивТиповОбъектовИС", МассивТиповОбъектовИС);
	
	МассивРезультатовВсеПравила = ЗапросВсеПравила.ВыполнитьПакет();
	КолВоТаблиц = МассивРезультатовВсеПравила.Количество();
	
	ВыборкаПравилаГруппировкаПоТипам = МассивРезультатовВсеПравила[КолВоТаблиц - 2].Выбрать(
		ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыборкаРеквизитыДляАнализа = МассивРезультатовВсеПравила[КолВоТаблиц - 1].Выбрать(
		ОбходРезультатаЗапроса.ПоГруппировкам);
	
	// Динамически сформируем и выполним запрос, который выберет из БД список объектов ИС,
	// для которых требуется подобрать правила интеграции, а также значения их реквизитов,
	// которые будем анализировать при поиске подходящего правила.
	ЗапросДанныеОбъектов = Новый Запрос;
	ЗапросДанныеОбъектов.УстановитьПараметр("СписокОбъектовИС", СписокОбъектовИС);
	МассивОбщийТекстЗапроса = Новый Массив;
	
	Для Каждого ТипОбъектаИС Из МассивТиповОбъектовИС Цикл
		ТекстЗапросаДляТипа = СтрЗаменить(
			"ВЫБРАТЬ
			|	""&ТипОбъектаИС"" КАК ТипОбъектаИС,
			|	&ВыборкаПолей,
			|	ОбъектИС.Ссылка КАК Ссылка
			|ИЗ
			|	&ТипОбъектаИС КАК ОбъектИС
			|ГДЕ
			|	ОбъектИС.Ссылка В(&СписокОбъектовИС)",
			"&ТипОбъектаИС",
			ТипОбъектаИС);
		
		ВыборкаПолей = "";
		ВыборкаРеквизитыДляАнализа.Сбросить();
		Если ВыборкаРеквизитыДляАнализа.НайтиСледующий(ТипОбъектаИС, "ТипОбъектаИС") Тогда
			МассивВыборкаПолей = Новый Массив;
			ВыборкаДетальныеЗаписи = ВыборкаРеквизитыДляАнализа.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если Не ВыборкаДетальныеЗаписи.ЭтоДополнительныйРеквизитИС Тогда
					МассивВыборкаПолей.Добавить(СтрШаблон("ОбъектИС.%1 КАК %1", ВыборкаДетальныеЗаписи.ИмяРеквизита));
				КонецЕсли;
			КонецЦикла;
			
			Если МассивВыборкаПолей.Количество() > 0 Тогда
				ВыборкаПолей = СтрСоединить(МассивВыборкаПолей, ", ") + ", ";
			КонецЕсли;
		КонецЕсли;
		
		МассивОбщийТекстЗапроса.Добавить(СтрЗаменить(ТекстЗапросаДляТипа, "&ВыборкаПолей,", ВыборкаПолей));
	КонецЦикла;
	
	ЗапросДанныеОбъектов.Текст = СтрСоединить(МассивОбщийТекстЗапроса, " ; ");
	МассивРезультатовДанныеОбъектов = ЗапросДанныеОбъектов.ВыполнитьПакет();
	
	// Для каждого из объектов ИС переберем все подходящие им по типу правила, и добавим в результат
	// функции те из правил, которые подходят по ключевым реквизитам для конкретного объекта.
	Индекс = 0;
	Для Каждого ТипОбъектаИС Из МассивТиповОбъектовИС Цикл
		ВыборкаПравилаГруппировкаПоТипам.Сбросить();
		Если ВыборкаПравилаГруппировкаПоТипам.НайтиСледующий(ТипОбъектаИС, "ТипОбъектаИС") Тогда
			ЕстьПравила = Истина;
			ВыборкаПравила = ВыборкаПравилаГруппировкаПоТипам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Иначе
			ЕстьПравила = Ложь;
		КонецЕсли;
		
		ТаблицаДанныхОбъекта = МассивРезультатовДанныеОбъектов[Индекс].Выгрузить();
		Для Каждого ДанныеОбъектаИС Из ТаблицаДанныхОбъекта Цикл
			ПодходящиеПравила = Новый ТаблицаЗначений;
			ПодходящиеПравила.Колонки.Добавить("Правило",
				Новый ОписаниеТипов("СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом3"));
			ПодходящиеПравила.Колонки.Добавить("Приоритет",
				Новый ОписаниеТипов("Число"));
			ПодходящиеПравила.Колонки.Добавить("ПравилоЗагрузкиДанныхВДО",
				Новый ОписаниеТипов("Строка"));
			
			Если ЕстьПравила Тогда
				ВыборкаПравила.Сбросить();
				Пока ВыборкаПравила.Следующий() Цикл
					ДанныеПравила = ВыборкаПравила.Выбрать();
					Приоритет = 0;
					
					Если ПравилоПодходитОбъекту(ДанныеПравила, ДанныеОбъектаИС, Приоритет) Тогда
						СтрокаПодходящиеПравила = ПодходящиеПравила.Добавить();
						СтрокаПодходящиеПравила.Правило = ВыборкаПравила.Правило;
						СтрокаПодходящиеПравила.Приоритет = Приоритет;
						СтрокаПодходящиеПравила.ПравилоЗагрузкиДанныхВДО = ВыборкаПравила.ПравилоЗагрузкиДанныхВДО;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			// Вернем только правила с наивысшим приоритетом.
			ПравилаСВысшимПриоритетом = Новый Массив;
			Если ПодходящиеПравила.Количество() > 0 Тогда
				
				СсылкиНаПравилаДО = Новый Массив;
				ПодходящиеПравила.Сортировать("Приоритет УБЫВ");
				МаксПриоритет = ПодходящиеПравила[0].Приоритет;
				
				Для Каждого Строка Из ПодходящиеПравила Цикл
					
					Если СвернутьПоПравилуДО
							И СсылкиНаПравилаДО.Найти(Строка.ПравилоЗагрузкиДанныхВДО) <> Неопределено Тогда
						Продолжить;
					КонецЕсли;
					
					Если (Строка.Приоритет = МаксПриоритет) Или Не ТолькоПриоритетные Тогда
						ПравилаСВысшимПриоритетом.Добавить(Строка.Правило);
						СсылкиНаПравилаДО.Добавить(Строка.ПравилоЗагрузкиДанныхВДО);
					Иначе
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Результат.Вставить(ДанныеОбъектаИС.Ссылка, ПравилаСВысшимПриоритетом);
		КонецЦикла;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Подбирает для переданного объекта ИС подходящие ему правила интеграции.
//
// Параметры:
//   ОбъектИС - ОпределяемыйТип.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый - объект ИС,
//     для которого требуется подобрать подходящие правила интеграции.
//   ТолькоПриоритетные - Булево - правила будут отсортированы по приоритету, и в выборку попадут только
//     правила с наивысшим приоритетом. Чем больше ключевых реквизитов правила совпало со значениями реквизитов
//     объекта ИС, тем выше приоритет правила для данного конкретного объекта ИС.
//   ДопИнформация - Булево - если Истина, вместо массива правил будет возвращен массив структур, содержащих помимо
//     ссылки на само правило значения его ключевых реквизитов.
//
// Возвращаемое значение:
//   Массив из СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом3 - список подходящих правил.
//   см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеПравилаИнтеграции
//
Функция ПодходящиеПравилаИнтеграцииОбъекта(ОбъектИС, ТолькоПриоритетные = Ложь, ДопИнформация = Ложь) Экспорт
	
	СписокОбъектовИС = Новый Массив;
	СписокОбъектовИС.Добавить(ОбъектИС);
	ПодходящиеПравилаИнтеграции = ПодходящиеПравилаИнтеграции(СписокОбъектовИС, ТолькоПриоритетные);
	ПодходящиеПравилаИнтеграцииОбъекта = ПодходящиеПравилаИнтеграции[ОбъектИС];
	
	Если Не ДопИнформация Тогда
		Возврат ПодходящиеПравилаИнтеграцииОбъекта;
	КонецЕсли;
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Правила.Ссылка КАК Ссылка,
		|	Правила.ТипОбъектаИС КАК ТипОбъектаИС,
		|	Правила.ТипОбъектаДО КАК ТипОбъектаДО,
		|	Правила.ПредставлениеОбъектаИС КАК ПредставлениеОбъектаИС,
		|	Правила.ПредставлениеОбъектаДО КАК ПредставлениеОбъектаДО,
		|	Правила.ВидДокументаДОID КАК ВидДокументаДОID
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом3 КАК Правила
		|ГДЕ
		|	Правила.Ссылка В(&ПодходящиеПравилаИнтеграцииОбъекта)");
	Запрос.УстановитьПараметр("ПодходящиеПравилаИнтеграцииОбъекта", ПодходящиеПравилаИнтеграцииОбъекта);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Правило = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеПравилаИнтеграции();
		Правило.Ссылка = Выборка.Ссылка;
		Правило.ТипОбъектаИС = Выборка.ТипОбъектаИС;
		Правило.ТипОбъектаДО = Выборка.ТипОбъектаДО;
		Правило.ПредставлениеОбъектаИС = Выборка.ПредставлениеОбъектаИС;
		Правило.ПредставлениеОбъектаДО = Выборка.ПредставлениеОбъектаДО;
		Правило.ИдентификаторВидаДокумента = Выборка.ВидДокументаДОID;
		Правило.ТипВидаДокумента = ?(ЗначениеЗаполнено(Выборка.ВидДокументаДОID), "DMDocumentType", "");
		
		Результат.Добавить(Правило);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Подбирает для основного предмета задачи ДО подходящие правила интеграции.
//
// Параметры:
//   ЗадачаXDTO - ОбъектXDTO - объект XDTO типа DMTaskAction.
//   ОсновнойПредметID - Строка - неявно возвращаемое значение, идентификатор основного объекта.
//   ОсновнойПредметТип - Строка - неявно возвращаемое значение, тип основного объекта.
//
// Возвращаемое значение:
//   Массив из см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеПравилаИнтеграции
//
Функция ПодходящиеПравилаИнтеграцииПоОсновномуПредметуЗадачи(ЗадачаXDTO,
		ОсновнойПредметID = "", ОсновнойПредметТип = "") Экспорт
	
	ТипОбъектаДО = "";
	ВидДокументаДОID = "";
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ЗадачаXDTO, "mainApplication") Тогда
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ЗадачаXDTO.mainApplication, "document") Тогда
			mainApplication = ЗадачаXDTO.mainApplication.document; // ОбъектXDTO
			ВидДокументаДОID = ЗадачаXDTO.mainApplication.document.documentType.objectID.id;
		ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ЗадачаXDTO.mainApplication, "correspondent") Тогда
			mainApplication = ЗадачаXDTO.mainApplication.correspondent; // ОбъектXDTO
		ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ЗадачаXDTO.mainApplication, "meeting") Тогда
			mainApplication = ЗадачаXDTO.mainApplication.meeting; // ОбъектXDTO
		КонецЕсли;
		ТипОбъектаДО = mainApplication.Тип().Имя;
		ОсновнойПредметID = mainApplication.objectID.id;
		ОсновнойПредметТип = mainApplication.objectID.type;
	КонецЕсли;
	ПодходящиеПравила = Новый Массив;
	Если ТипОбъектаДО = "" Тогда
		Возврат ПодходящиеПравила;
	КонецЕсли;
	
	ВыборкаПравил = ИнтеграцияС1СДокументооборот3ПовтИсп.ОбщийНаборПравилИнтеграции(
		ТипОбъектаДО,
		ВидДокументаДОID);
	Пока ВыборкаПравил.Следующий() Цикл
		
		КлючевыеРеквизитыДО = ВыборкаПравил.КлючевыеРеквизитыДО; // ВыборкаИзРезультатаЗапроса
		КлючевойРеквизит = КлючевыеРеквизитыДО.Выбрать();
		ПравилоПодходит = Истина;
		Пока КлючевойРеквизит.Следующий() Цикл
			Если КлючевойРеквизит.ЭтоДополнительныйРеквизитДО Тогда
				
				ДопРеквизитПодходит = Ложь;
				Для Каждого ДопРеквизитXDTO Из mainApplication.additionalProperties Цикл
					Если ДопРеквизитXDTO.objectID.id = КлючевойРеквизит.Имя Тогда
						Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
								ДопРеквизитXDTO, "propertySimpleValue") Тогда
							ДопРеквизитПодходит =
								(ДопРеквизитXDTO.propertySimpleValue = КлючевойРеквизит.ЗначениеРеквизита);
						ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
								ДопРеквизитXDTO, "propertyObjectValue") Тогда
							ДопРеквизитПодходит =
								(ДопРеквизитXDTO.propertyObjectValue.objectID.id = КлючевойРеквизит.ЗначениеРеквизитаID)
								И (ДопРеквизитXDTO.propertyObjectValue.objectID.type = КлючевойРеквизит.ЗначениеРеквизитаТип);
						КонецЕсли;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Не ДопРеквизитПодходит Тогда
					ПравилоПодходит = Ложь;
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
					mainApplication, КлючевойРеквизит.Имя) Тогда
				
				Если ТипЗнч(mainApplication[КлючевойРеквизит.Имя]) = Тип("ОбъектXDTO")
						И ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
							mainApplication[КлючевойРеквизит.Имя], "objectID") Тогда
					Если mainApplication[КлючевойРеквизит.Имя].objectID.ID <> КлючевойРеквизит.ЗначениеРеквизитаID
							Или mainApplication[КлючевойРеквизит.Имя].objectID.type <> КлючевойРеквизит.ЗначениеРеквизитаТип Тогда
						ПравилоПодходит = Ложь;
						Прервать;
					КонецЕсли;
				Иначе
					Если mainApplication[КлючевойРеквизит.Имя] <> КлючевойРеквизит.ЗначениеРеквизита Тогда
						ПравилоПодходит = Ложь;
						Прервать;
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				
				ПравилоПодходит = Ложь;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
		Если ПравилоПодходит Тогда
			ПодходящееПравило = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеПравилаИнтеграции();
			ПодходящееПравило.Ссылка = ВыборкаПравил.Ссылка;
			ПодходящееПравило.ПредставлениеОбъектаДО = ВыборкаПравил.ПредставлениеОбъектаДОСКлючевымиПолями;
			ПодходящееПравило.ПредставлениеОбъектаИС = ВыборкаПравил.ПредставлениеОбъектаИССКлючевымиПолями;
			ПодходящееПравило.ТипОбъектаДО = ВыборкаПравил.ТипОбъектаДО;
			ПодходящееПравило.ТипОбъектаИС = ВыборкаПравил.ТипОбъектаИС;
			ПодходящееПравило.ИдентификаторВидаДокумента = ВыборкаПравил.ИдентификаторВидаДокумента;
			ПодходящееПравило.ТипВидаДокумента = ?(ЗначениеЗаполнено(ВыборкаПравил.ИдентификаторВидаДокумента),
				"DMDocumentType",
				"");
			ПодходящиеПравила.Добавить(ПодходящееПравило);
		КонецЕсли;
		
	КонецЦикла;
	ВыборкаПравил.Сбросить();
	
	Возврат ПодходящиеПравила;
	
КонецФункции

// Подбирает для переданного типа объектов ИС подходящие правила интеграции.
//
// Параметры:
//   ТипОбъектаИС - Строка - тип объектов ИС.
//
// Возвращаемое значение:
//   Массив из см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеПравилаИнтеграции
//
Функция ПодходящиеПравилаИнтеграцииПоТипуОбъектаИС(ТипОбъектаИС) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Правила.Ссылка КАК Ссылка,
		|	Правила.ТипОбъектаИС КАК ТипОбъектаИС,
		|	Правила.ТипОбъектаДО КАК ТипОбъектаДО,
		|	Правила.ПредставлениеОбъектаИС КАК ПредставлениеОбъектаИС,
		|	Правила.ПредставлениеОбъектаДО КАК ПредставлениеОбъектаДО,
		|	Правила.ВидДокументаДОID КАК ВидДокументаДОID
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом3 КАК Правила
		|ГДЕ
		|	НЕ Правила.ПометкаУдаления
		|	И Правила.ТипОбъектаИС = &ТипОбъектаИС");
	Запрос.УстановитьПараметр("ТипОбъектаИС", ТипОбъектаИС);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Правило = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеПравилаИнтеграции();
		Правило.Ссылка = Выборка.Ссылка;
		Правило.ТипОбъектаИС = Выборка.ТипОбъектаИС;
		Правило.ТипОбъектаДО = Выборка.ТипОбъектаДО;
		Правило.ПредставлениеОбъектаИС = Выборка.ПредставлениеОбъектаИС;
		Правило.ПредставлениеОбъектаДО = Выборка.ПредставлениеОбъектаДО;
		Правило.ИдентификаторВидаДокумента = Выборка.ВидДокументаДОID;
		Правило.ТипВидаДокумента = ?(ЗначениеЗаполнено(Выборка.ВидДокументаДОID), "DMDocumentType", "");
		
		Результат.Добавить(Правило);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает из кэша ссылку на объект ДО.
//
// Возвращаемое значение:
//   Строка - ссылка на объект ДО.
//
Функция ПолучитьСсылкуНаОбъектДО() Экспорт
	
	Возврат ПараметрыСеанса.ИнтеграцияС1СДокументооборотОбъектДО;
	
КонецФункции

// Возвращает представление предмета задачи, являющегося объектом ИС.
//
// Параметры:
//   Ссылка - ЛюбаяСсылка - ссылка на объект ИС.
//
// Возвращаемое значение:
//   Строка - представление объекта.
//
Функция ПредставлениеПриложенияОбъектаИС(Ссылка) Экспорт
	
	ИмяКонфигурации = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СокращенноеНаименованиеКонфигурации();
	Если ЗначениеЗаполнено(ИмяКонфигурации) Тогда
		ПредставлениеПриложения = СтрШаблон(НСтр("ru = '%1, объект %2'"),
			Строка(Ссылка),
			ИмяКонфигурации);
	Иначе
		ПредставлениеПриложения = СтрШаблон(НСтр("ru = '%1, объект ИС'"),
			Строка(Ссылка));
	КонецЕсли;
	
	Возврат ПредставлениеПриложения;
	
КонецФункции

// Помещает в кэш ссылку на объект ДО.
//
// Параметры:
//   ОбъектДО - Строка - ссылка на объект ДО.
//
Процедура УстановитьСсылкуНаОбъектДО(ОбъектДО) Экспорт
	
	ПараметрыСеанса.ИнтеграцияС1СДокументооборотОбъектДО = ОбъектДО;
	
КонецПроцедуры

// Проверяет описывает ли переданный тип документ ДО3.
//
// Параметры:
//   ТипОбъектаXDTO - Строка - тип объекта.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоДокументДО3(ТипОбъектаXDTO) Экспорт
	
	Возврат ИнтеграцияС1СДокументооборот3.ЭтоДокументДО3(ТипОбъектаXDTO);
	
КонецФункции

#КонецОбласти

#Область Файлы

// Изменяет роли файлов.
//
// Параметры:
//   Файлы - Массив из см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла
//   ВыбраннаяРольID - Строка - идентификатор новой роли файлов.
//
Процедура ЗаменитьРольФайлов(Файлы, ВыбраннаяРольID) Экспорт
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси,"DMChangeFilesRoleRequest");
	
	Запрос.newRole = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMFileRole");
	Запрос.newRole.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ВыбраннаяРольID,
		"DMFileRole");
	Запрос.newRole.name = "";
	
	ФайлыДляИзмененияРолей = Запрос.files; // СписокXDTO
	Для Каждого Файл Из Файлы Цикл
		ФайлXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMFile");
		ФайлXDTO.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			Файл.ID,
			Файл.Тип);
		ФайлXDTO.name = "";
		ФайлыДляИзмененияРолей.Добавить(ФайлXDTO);
	КонецЦикла;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
КонецПроцедуры

// Копирует присоединенные файлы объекта, хранящиеся на стороне ИС в связанный объект на стороне ДО.
//
// Параметры:
//   ПрисоединенныеФайлыВИС - Массив из ЛюбаяСсылка - список присоединенных файлов в ИС.
//   ВладелецID - Строка - идентификатор владельца файла в Документообороте.
//   ВладелецТип - Строка - тип XDTO владельца файла в Документообороте.
//   ВладелецПредставление - Строка - представление объекта-владельца файла в ИС.
//   Владелец - ЛюбаяСсылка - ссылка на объект-владелец файла в ИС.
//   РольФайлаID - Строка - роль файла.
//
// Возвращаемое значение:
//   Массив из см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла.
//
Функция ПеренестиФайлыИСвДО(ПрисоединенныеФайлыВИС, ВладелецID, ВладелецТип, ВладелецПредставление, Владелец,
		РольФайлаID = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru='Отсутствует модуль %1'"), "РаботаСФайлами");
	КонецЕсли;
	
	СозданныеФайлы = Новый Массив;
	
	КолВоФайлов = ПрисоединенныеФайлыВИС.Количество() - 1;
	Для Индекс = 0 По КолВоФайлов Цикл
		
		НомерФайла = КолВоФайлов - Индекс;
		ФайлВИС = ПрисоединенныеФайлыВИС[НомерФайла].Значение;
		ДанныеФайла = МодульРаботаСФайлами.ДанныеФайла(ФайлВИС);
		
		ТекущийФайл = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла(
			ДанныеФайла.Наименование,
			Неопределено,
			"DMFile",
			ДанныеФайла.Расширение,
			РольФайлаID);
		ТекущийФайл.Размер = ДанныеФайла.Размер;
		ТекущийФайл.ДатаМодификации = МестноеВремя(ДанныеФайла.ДатаМодификацииУниверсальная);
		ТекущийФайл.ДатаМодификацииУниверсальная = ДанныеФайла.ДатаМодификацииУниверсальная;
		Если ДанныеФайла.СтатусИзвлеченияТекста = "Извлечен" Тогда
			ТекстХранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеФайла.Ссылка, "ТекстХранилище");
			Если ТипЗнч(ТекстХранилище) = Тип("ХранилищеЗначения") Тогда
				ТекущийФайл.Текст = ТекстХранилище.Получить();
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыСоздания = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.НовыеПараметрыСозданияФайла(
			ТекущийФайл);
		ПараметрыСоздания.АдресВременногоХранилищаФайла = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
		ПараметрыСоздания.Владелец = Владелец;
		
		ПараметрыСоздания.ВнешнийОбъект.ID = Строка(ФайлВИС.УникальныйИдентификатор());
		ПараметрыСоздания.ВнешнийОбъект.type = ФайлВИС.Метаданные().ПолноеИмя();
		ПараметрыСоздания.ВнешнийОбъект.name = ДанныеФайла.Наименование;
		
		ТекущийФайл.ID = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.СоздатьФайлВДокументообороте(
			ПараметрыСоздания,
			ВладелецID,
			ВладелецТип,
			ВладелецПредставление);
		
		СозданныеФайлы.Добавить(ТекущийФайл);
		
		ПрисоединенныеФайлыВИС.Удалить(НомерФайла);
		
	КонецЦикла;
	
	Возврат СозданныеФайлы;
	
КонецФункции

#КонецОбласти

#Область Задачи

// Начинает асинхронное изменение задачи, а также, при необходимости, получает из 1С:Документооборот обновленные
// данные в одном пакетном запросе.
//
// Параметры:
//   ИмяОперации - Строка - предопределенное имя операции над задачей. Доступные варианты: ВыполнитьДействиеЗадачи,
//     ВзятьВРаботу, ОтменитьВзятиеВРаботу.
//   ДанныеПоЗадаче - см. ИнтеграцияС1СДокументооборот3КлиентСервер.ДанныеПоЗадаче
//   УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы, из которой выполняется запрос.
//   ТребуетсяОбновлениеДанных - Булево - требуется выполнить запрос на обновление данных.
//   ЭтоФормаСпискаЗадач - Булево - операция выполняется из формы списка задач.
//   ПараметрыФормыСпискаЗадач - см. ИнтеграцияС1СДокументооборот3КлиентСервер.ПараметрыФормыСпискаЗадач
//
// Возвращаемое значение:
//   см. ДлительныеОперации.ВыполнитьВФоне
//
Функция ДлительнаяОперацияНадЗадачей(ИмяОперации, ДанныеПоЗадаче, УникальныйИдентификатор,
		ТребуетсяОбновлениеДанных = Истина, ЭтоФормаСпискаЗадач = Ложь,
		Знач ПараметрыФормыСпискаЗадач = Неопределено) Экспорт
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	ЗапросыПакета = Новый Массив;
	
	Если ИмяОперации = "ВыполнитьДействиеЗадачи" Тогда
		ЗапросыПакета.Добавить(ИнтеграцияС1СДокументооборот3.ВыполнитьДействиеЗадачиЗапрос(Прокси, ДанныеПоЗадаче));
		
	ИначеЕсли ИмяОперации = "ВзятьВРаботу" Тогда
		ЗапросыПакета.Добавить(ИнтеграцияС1СДокументооборот3.ВзятьЗадачуВРаботуЗапрос(Прокси, ДанныеПоЗадаче));
		
	ИначеЕсли ИмяОперации = "ОтменитьВзятиеВРаботу" Тогда
		ЗапросыПакета.Добавить(ИнтеграцияС1СДокументооборот3.ОтменитьВзятиеЗадачиВРаботуЗапрос(Прокси, ДанныеПоЗадаче));
		
	ИначеЕсли ИмяОперации = "УстановитьФлаг" Тогда
		ЗапросыПакета.Добавить(ИнтеграцияС1СДокументооборот3.УстановитьФлагЗадачиЗапрос(Прокси, ДанныеПоЗадаче));
		
	КонецЕсли;
	
	Если ТребуетсяОбновлениеДанных Тогда
		Если ЭтоФормаСпискаЗадач Тогда
			ИнтеграцияС1СДокументооборот3.ДополнитьФильтрыОтбораЗадач(
				Прокси,
				ПараметрыФормыСпискаЗадач.Фильтры,
				ПараметрыФормыСпискаЗадач.БыстрыйПоиск);
			ЗапросыПакета.Добавить(
				ИнтеграцияС1СДокументооборот3.СписокЗадачЗапрос(
					Прокси,
					ПараметрыФормыСпискаЗадач.ТекущаяСтраница,
					ПараметрыФормыСпискаЗадач.РазмерСтраницыДинамическогоСписка,
					ПараметрыФормыСпискаЗадач.ПолеДляСортировки,
					ПараметрыФормыСпискаЗадач.НаправлениеСортировкиПоля,
					ПараметрыФормыСпискаЗадач.Фильтры,
					ПараметрыФормыСпискаЗадач.ОтображениеКарточкиЗадачи));
			
		Иначе
			ЗапросыПакета.Добавить(
				ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъектыЗапрос(
					Прокси,
					ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПоЗадаче.ДействиеЗадачи),
					"htmlView"));
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ВыполнитьПакетныйЗапросАсинхронно(
		Прокси,
		ЗапросыПакета,
		УникальныйИдентификатор,
		ИмяОперации);
	
КонецФункции

// Обрабатывает результат действия над задачей.
//
// Параметры:
//   РезультатДействияСтрока - Строка - результат действия над задачей, преобразованный в строку.
//   ДанныеДляОбновления - ОбъектXDTO - неявно возвращаемое значение, в которое будут переданы данные,
//     необходимые для обновления формы.
//
// Возвращаемое значение:
//   Структура:
//     * Успешно - Булево
//     * ТекстПредупреждения - Строка
//
Функция РезультатДействияНадЗадачей(РезультатДействияСтрока, ДанныеДляОбновления) Экспорт
	
	Результат = Новый Структура("Успешно, ТекстПредупреждения", Истина, "");
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОтветНаЗапросыПакета = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СтрокаВОбъектXDTO(
		Прокси,
		РезультатДействияСтрока);
	
	РезультатВыполнения = ОтветНаЗапросыПакета.responses[0];
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, РезультатВыполнения, "DMError") Тогда
		Результат.Успешно = Ложь;
		Результат.ТекстПредупреждения = СокрЛП(РезультатВыполнения.description);
	КонецЕсли;
	
	Если ОтветНаЗапросыПакета.responses.Количество() = 2 Тогда
		ДанныеДляОбновления = ОтветНаЗапросыПакета.responses[1];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПравилоПодходитОбъекту(ДанныеПравила, ДанныеОбъектаИС, Приоритет)
	
	ПравилоПодходит = Истина;
	
	Пока ДанныеПравила.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ДанныеПравила.ИмяРеквизита) Тогда
			// Ключевые реквизиты не заданы, считаем что правило подходит
			Прервать;
			
		ИначеЕсли ДанныеПравила.ЭтоДополнительныйРеквизитИС Тогда
			Свойство = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДопРеквизитПоИмени(ДанныеПравила.ИмяРеквизита);
			ЗначениеСвойства = УправлениеСвойствами.ЗначениеСвойства(ДанныеОбъектаИС.Ссылка, Свойство);
			Если ЗначениеСвойства = Неопределено Тогда
				// В объекте доп свойство не задано. Но в правилах ключевой реквизит может быть задан как пустой.
				ПравилоПодходит = (ДанныеПравила.Значение = Ложь) Или Не ЗначениеЗаполнено(ДанныеПравила.Значение);
				Если Не ПравилоПодходит Тогда
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ЗначениеСвойства <> ДанныеПравила.Значение Тогда
				ПравилоПодходит = Ложь;
				Прервать;
				
			КонецЕсли;
			
		ИначеЕсли ДанныеОбъектаИС[ДанныеПравила.ИмяРеквизита] <> ДанныеПравила.Значение Тогда
			ПравилоПодходит = Ложь;
			Прервать;
			
		КонецЕсли;
		
		Приоритет = Приоритет + 1;
	КонецЦикла;
	
	Возврат ПравилоПодходит;
	
КонецФункции

#КонецОбласти