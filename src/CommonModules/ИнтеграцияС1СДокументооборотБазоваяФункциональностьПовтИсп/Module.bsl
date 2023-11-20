////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп, сервер, повт. использование
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает текущую версию Библиотеки интеграции с 1С:Документооборотом.
//
// Возвращаемое значение:
//   см. ОбновлениеИнформационнойБазы.ВерсияИБ
//
Функция ВерсияБИД() Экспорт
	
	Возврат ОбновлениеИнформационнойБазы.ВерсияИБ("БиблиотекаИнтеграцииС1СДокументооборотом");
	
КонецФункции

// Получает доступность функционала версии web-сервиса Документооборота.
//
// Параметры:
//   ВерсияСервиса - Строка - версия web-сервиса Документооборота, содержащая требуемый функционал.
//   Оптимистично - Булево - признак необходимости вернуть Истина, если версия сервиса пока неизвестна.
//
// Возвращаемое значение:
//   см. ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса
//
Функция ДоступенФункционалВерсииСервиса(ВерсияСервиса = "", Оптимистично = Ложь) Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса(
		ВерсияСервиса,
		Оптимистично);
	
КонецФункции

// Возвращает идентификатор текущей базы данных, если он есть. Если нет, создает его и возвращает.
//
// Возвращаемое значение:
//   Строка
//
Функция ИдентификаторБазыДанных() Экспорт
	
	ЭтотУзел = ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.ЭтотУзел();
	НаименованиеУзла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзел, "Наименование");
	
	Если СтрДлина(НаименованиеУзла) <> 36 Тогда
		ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
		ЭтотУзелОбъект.Заблокировать();
		ЭтотУзелОбъект.Наименование = Строка(Новый УникальныйИдентификатор);
		ЭтотУзелОбъект.Код = 0;
		ЭтотУзелОбъект.ОбменДанными.Загрузка = Истина;
		ЭтотУзелОбъект.Записать();
	КонецЕсли;
	
	Возврат НаименованиеУзла;
	
КонецФункции

// Возвращает настройки базы Документооборота.
//
// Возвращаемое значение:
//   см. ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьНастройки
//
Функция ПолучитьНастройки() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьНастройки();
	
КонецФункции

// Создает прокси веб-сервиса Документооборота. В случае ошибки при создании вызывается исключение.
//
// Параметры:
//   ВызыватьИсключение - Булево - Истина, если при невозможности получения следует вызвать исключение.
//
// Возвращаемое значение:
//   см. ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьПрокси
//
Функция ПолучитьПрокси(ВызыватьИсключение = Истина) Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьПрокси(ВызыватьИсключение);
	
КонецФункции

// Формирует таблицу соответствия типов XDTO и типов объектов информационной базы
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * ИмяТипаXDTO - Строка - имя типа XDTO.
//     * ТипОбъектаИС - Тип - тип объекта ИС.
//     * ИмяТипаИС - Строка - полное имя типа объекта ИС.
//
Функция СоответствиеТипов() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ИмяТипаXDTO", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ТипОбъектаИС", Новый ОписаниеТипов("Тип"));
	
	// Поддерживаемые справочники.
	Если ТипВалюты() <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(
			Таблица,
			"DMCurrency",
			ТипВалюты());
	КонецЕсли;
	Если ТипКлассификаторБанков() <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(
			Таблица,
			"DMBank",
			ТипКлассификаторБанков());
	КонецЕсли;
	Если ТипПользователи() <> Неопределено Тогда
		Настройки = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИспользоватьИнтеграцию();
		Если Настройки.ИспользоватьИнтеграциюДО2 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(
				Таблица,
				"DMUser",
				ТипПользователи());
		ИначеЕсли Настройки.ИспользоватьИнтеграциюДО3 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(
				Таблица,
				"DMEmployee",
				ТипПользователи());
		КонецЕсли;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнитьСоответствиеТипов(Таблица);
	
	Таблица.Колонки.Добавить("ИмяТипаИС", Новый ОписаниеТипов("Строка"));
	
	Для Каждого Строка Из Таблица Цикл
		Строка.ИмяТипаИС = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИмяОбъектаМетаданныхПоТипу(
			Строка.ТипОбъектаИС);
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Получает текущего пользователя 1С:Документооборота.
//
// Возвращаемое значение:
//   см. ИнтеграцияС1СДокументооборотБазоваяФункциональность.ТекущийПользовательДокументооборота
//
Функция ТекущийПользовательДокументооборота() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ТекущийПользовательДокументооборота();
	
КонецФункции

// Возвращает тип справочника Валюты.
//
// Параметры:
//   ТипОбъекта - Булево - требуется вернуть тип ссылки или тип объекта.
//
// Возвращаемое значение:
//   Тип
//   Неопределено
//
Функция ТипВалюты(ТипОбъекта = Ложь) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		Если ТипОбъекта Тогда
			ИмяТипа = "СправочникОбъект.Валюты";
		Иначе
			ИмяТипа = "СправочникСсылка.Валюты";
		КонецЕсли;
		Возврат Тип(ИмяТипа);
	КонецЕсли;
	
КонецФункции

// Возвращает тип справочника Классификатор банков.
//
// Параметры:
//   ТипОбъекта - Булево - требуется вернуть тип ссылки или тип объекта.
//
// Возвращаемое значение:
//   Тип
//   Неопределено
//
Функция ТипКлассификаторБанков(ТипОбъекта = Ложь) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		Если ТипОбъекта Тогда
			ИмяТипа = "СправочникОбъект.КлассификаторБанков";
		Иначе
			ИмяТипа = "СправочникСсылка.КлассификаторБанков";
		КонецЕсли;
		Возврат Тип(ИмяТипа);
	КонецЕсли;
	
КонецФункции

// Возвращает тип справочника Пользователи.
//
// Параметры:
//   ТипОбъекта - Булево - требуется вернуть тип ссылки или тип объекта.
//
// Возвращаемое значение:
//   Тип
//   Неопределено
//
Функция ТипПользователи(ТипОбъекта = Ложь) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Пользователи") Тогда
		Если ТипОбъекта Тогда
			ИмяТипа = "СправочникОбъект.Пользователи";
		Иначе
			ИмяТипа = "СправочникСсылка.Пользователи";
		КонецЕсли;
		Возврат Тип(ИмяТипа);
	КонецЕсли;
	
КонецФункции

// Возвращает массив типов объектов ИС, поддерживающих бесшовную интеграцию.
//
// Возвращаемое значение:
//   Массив из Тип
//
Функция ТипыОбъектовПоддерживающихИнтеграцию() Экспорт
	
	Типы = Новый Массив;
	
	Типы = Метаданные.ОпределяемыеТипы.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый.Тип.Типы();
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриОпределенииТиповОбъектовПоддерживающихИнтеграцию(
		Типы);
	
	Возврат Типы;
	
КонецФункции

// Возвращает узел Документооборота. В случае отсутствия узел будет создан.
//
// Возвращаемое значение:
//   ПланОбменаСсылка.ИнтеграцияС1СДокументооборотомПереопределяемый
//
Функция УзелДокументооборота() Экспорт
	
	ЭтотУзел = ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.ЭтотУзел();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ИнтеграцияС1СДокументооборотомПереопределяемый.Ссылка КАК Ссылка,
		|	ИнтеграцияС1СДокументооборотомПереопределяемый.Наименование КАК Наименование
		|ИЗ
		|	ПланОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый КАК ИнтеграцияС1СДокументооборотомПереопределяемый
		|ГДЕ
		|	ИнтеграцияС1СДокументооборотомПереопределяемый.Ссылка <> &ЭтотУзел");
	Запрос.УстановитьПараметр("ЭтотУзел", ЭтотУзел);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Узел = Выборка.Ссылка;
	Иначе
		Узел1СДокументооборота = ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.СоздатьУзел();
		Узел1СДокументооборота.Наименование = НСтр("ru='1С:Документооборот'");
		Узел1СДокументооборота.Код = 1;
		Узел1СДокументооборота.Записать();
		Узел = Узел1СДокументооборота.Ссылка;
	КонецЕсли;
	
	Возврат Узел;
	
КонецФункции

// Определяет является ли текущий сеанс фоновым заданием.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоФоновоеЗадание() Экспорт
	
	Возврат ПолучитьТекущийСеансИнформационнойБазы().ПолучитьФоновоеЗадание() <> Неопределено;
	
КонецФункции

#КонецОбласти