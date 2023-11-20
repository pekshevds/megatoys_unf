#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа ИЛИ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Возвращает список контрагентов, связанных с контактом
Функция СвязанныеКонтрагенты(Контакт) Экспорт
	
	Контрагенты = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(Контакт) Тогда
		Возврат Контрагенты;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка КАК Ссылка
		|ИЗ
		|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних(, Контакт = &Контакт) КАК СвязиКонтрагентКонтактСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО (Контрагенты.Ссылка = СвязиКонтрагентКонтактСрезПоследних.Контрагент)
		|ГДЕ
		|	Контрагенты.ПометкаУдаления = ЛОЖЬ
		|	И СвязиКонтрагентКонтактСрезПоследних.СвязьНедействительна = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Контакт", Контакт);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Контрагенты.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Контрагенты;
	
КонецФункции

// Получает ссылку на элемент справочника с переданными свойствами.
// Если элемент с таким набором свойств отсутствует в справочнике,
// он автоматически создается.
//
// Параметры:
//  - Владелец - Ссылка - ссылка на элемент-владелец
//  - ДанныеЗаполнения  - структура свойств, которыми должен обладать
//                        элемент справочника. Элементы структуры:
//    - Должность - Строка - должность контактного лица
//    - Фамилия   - Строка - фамилия контактного лица
//    - Имя       - Строка - имя контактного лица
//    - Отчество  - Строка - отчество контактного лица
//
// Возвращаемое значение:
//  - Ссылка - ссылка на элемент справочника
//
Функция ПолучитьЭлемент(Владелец, Наименование) Экспорт
	
	
	Результат = ПустаяСсылка();
	
	// Поиск существующего контактного лица
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец",  Владелец);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛица.Ссылка
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних  КАК СвязиКонтрагентКонтакт
	|	ПО КонтактныеЛица.Ссылка = СвязиКонтрагентКонтакт.Контакт
	|		И СвязиКонтрагентКонтакт.Контрагент = &Владелец
	|	И КонтактныеЛица.Наименование = &Наименование";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Если Результат.Пустая() Тогда
		НовоеКонтактноеЛицо = СоздатьЭлемент();
		НовоеКонтактноеЛицо.Наименование       = Наименование;
		НовоеКонтактноеЛицо.Записать();
		РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(Владелец, НовоеКонтактноеЛицо);
		
		Результат = НовоеКонтактноеЛицо.Ссылка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучателиЭлектронногоПисьма(КонтактноеЛицо, ВидКонтактнойИнформации = Неопределено) Экспорт
	
	ПолучателиЭлектронногоПисьма = Новый ТаблицаЗначений;
	ПолучателиЭлектронногоПисьма.Колонки.Добавить("Контакт", Метаданные.ОпределяемыеТипы.КонтактСобытия.Тип);
	ПолучателиЭлектронногоПисьма.Колонки.Добавить("КакСвязаться", Новый ОписаниеТипов("Строка"));
	
	КонтактнаяИнформацияОбъекта = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(КонтактноеЛицо, 
		ВидКонтактнойИнформации, ТекущаяДатаСеанса(), Ложь);
	
	Если ВидКонтактнойИнформации = Неопределено Тогда
		ОтборКонтактнойИнформации = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		СтрокиКонтактнойИнформации = КонтактнаяИнформацияОбъекта.НайтиСтроки(ОтборКонтактнойИнформации);
	Иначе
		СтрокиКонтактнойИнформации = КонтактнаяИнформацияОбъекта;
	КонецЕсли;
	
	Для каждого Строка Из СтрокиКонтактнойИнформации Цикл
		НовыйПолучатель = ПолучателиЭлектронногоПисьма.Добавить();
		НовыйПолучатель.Контакт = КонтактноеЛицо;
		НовыйПолучатель.КакСвязаться = Строка.Представление;
	КонецЦикла;
	
	Возврат ПолучателиЭлектронногоПисьма;
	
КонецФункции

Функция ПолучателиСообщенияSMS(КонтактноеЛицо, ВидКонтактнойИнформации = Неопределено) Экспорт
	
	ПолучателиСообщенияSMS = Новый ТаблицаЗначений;
	ПолучателиСообщенияSMS.Колонки.Добавить("Контакт", Метаданные.ОпределяемыеТипы.КонтактСобытия.Тип);
	ПолучателиСообщенияSMS.Колонки.Добавить("КакСвязаться", Новый ОписаниеТипов("Строка"));
	
	КонтактнаяИнформацияОбъекта = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(КонтактноеЛицо, 
		ВидКонтактнойИнформации, ТекущаяДатаСеанса(), Ложь);
	
	Если ВидКонтактнойИнформации = Неопределено Тогда
		ОтборКонтактнойИнформации = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
		СтрокиКонтактнойИнформации = КонтактнаяИнформацияОбъекта.НайтиСтроки(ОтборКонтактнойИнформации);
	Иначе
		СтрокиКонтактнойИнформации = КонтактнаяИнформацияОбъекта;
	КонецЕсли;
	
	Для каждого Строка Из СтрокиКонтактнойИнформации Цикл
		НовыйПолучатель = ПолучателиСообщенияSMS.Добавить();
		НовыйПолучатель.Контакт = КонтактноеЛицо;
		НовыйПолучатель.КакСвязаться = Строка.Представление;
	КонецЦикла;
	
	Возврат ПолучателиСообщенияSMS;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Рекурсия") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ВыборГруппИЭлементов <> ИспользованиеГруппИЭлементов.Группы Тогда
		Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
		КонецЕсли;
	Иначе
		Для Каждого КлючИЗначение Из Параметры.Отбор Цикл
			НайденныйРеквизит = Метаданные.Справочники.КонтактныеЛица.Реквизиты.Найти(КлючИЗначение.Ключ);
			Если НайденныйРеквизит = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если НайденныйРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента Тогда
				Параметры.Отбор.Удалить(КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Параметры.Вставить("Рекурсия");
	ДанныеВыбора = ПолучитьДанныеВыбора(Параметры);
	ДополнитьДанныеВыбораСвязямиСКонтрагентами(ДанныеВыбора, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ДобавитьКИ(ЭлементСправочника, ПредставлениеКИ, ВидКИ)
	
	XMLПредставление = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(ПредставлениеКИ, ВидКИ);
	УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(ЭлементСправочника, XMLПредставление, ВидКИ, ВидКИ.Тип);
	
КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
КонецПроцедуры

// Поля загрузки данных из внешнего источника.
// 
// Параметры:
//  ТаблицаПолейЗагрузки - см. ЗагрузкаДанныхИзВнешнегоИсточника.СоздатьТаблицуПолейОписанияЗагрузки
//  НастройкиЗагрузкиДанных - см. ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере
//
Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт

	ОписанияТиповПолей = ЗагрузкаДанныхИзВнешнегоИсточника.НовыйОписанияТиповПолейЗагрузки();

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КонтактныеЛица");
	НаименованиеПредставление = НСтр("ru='ФИО (наименование)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Наименование",
		НаименованиеПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Контакт", 1,
		Истина, Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Код", НСтр("ru = 'Код'"),
		ОписанияТиповПолей.ОписаниеТиповСтрока9, ОписаниеТиповКолонка, "Контакт", 2, , Истина);

	ГруппаПредставление = НСтр("ru='Группа'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Родитель",
		ГруппаПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка, , , , );

	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаКонтрагентов") Тогда

		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ГруппыДоступаКонтрагентов");
		ГруппаДоступаПредставление = НСтр("ru='Группа доступа'");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ГруппаДоступа",
			ГруппаДоступаПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока200, ОписаниеТиповКолонка, , , Истина);

	КонецЕсли;

	ТелефонПредставление = НСтр("ru='Телефон'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Телефон",
		ТелефонПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписанияТиповПолей.ОписаниеТиповСтрока100);
	АдресПочтыПредставление = НСтр("ru='E-mail'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "АдресЭП",
		АдресПочтыПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписанияТиповПолей.ОписаниеТиповСтрока100);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическогоЛица");
	ПолПредставление = НСтр("ru='Пол'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Пол", ПолПредставление,
		ОписанияТиповПолей.ОписаниеТиповСтрока3, ОписаниеТиповКолонка);

	ДатаРожденияПредставление = НСтр("ru='Дата рождения'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДатаРождения",
		ДатаРожденияПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписанияТиповПолей.ОписаниеТиповДата);

	ДокументПредставление = НСтр("ru='Документ'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки,
		"ДокументУдостоверяющийЛичность", ДокументПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока250,
		ОписанияТиповПолей.ОписаниеТиповСтрока250);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ИсточникиПривлеченияПокупателей");
	ИсточникПривлеченияПредставление = НСтр("ru='Источник привлечения'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИсточникПривлечения",
		ИсточникПривлеченияПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("Строка");
	ЗаметкиПредставление = НСтр("ru='Заметки'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Комментарий",
		ЗаметкиПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока0000, ОписаниеТиповКолонка);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");

	ИННКПП1Представление = НСтр("ru='(1) ИНН/КПП или ИНН'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИНН_КПП1",
		ИННКПП1Представление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_1", 1);

	КонтрагентНаименование1Представление = НСтр("ru='(1) Контрагент (наименование)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контрагент1Наименование",
		КонтрагентНаименование1Представление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка,
		"Контрагент_1", 2);

	КонтрагентРасчетныйСчет1Представление = НСтр("ru='(1) Контрагент (расчетный счет)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РасчетныйСчет1",
		КонтрагентРасчетныйСчет1Представление, ОписанияТиповПолей.ОписаниеТиповСтрока50, ОписаниеТиповКолонка,
		"Контрагент_1", 3);

	КонтрагентДолжность1Представление = НСтр("ru='(1) Должность (роль)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Должность1",
		КонтрагентДолжность1Представление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка,
		"Контрагент_1", 4);

	ИННКПП2Представление = НСтр("ru='(2) ИНН/КПП или ИНН'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИНН_КПП2",
		ИННКПП2Представление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_2", 1);

	КонтрагентНаименование2Представление = НСтр("ru='(2) Контрагент (наименование)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контрагент2Наименование",
		КонтрагентНаименование2Представление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка,
		"Контрагент_2", 2);

	КонтрагентРасчетныйСчет2Представление = НСтр("ru='(2) Контрагент (расчетный счет)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РасчетныйСчет2",
		КонтрагентРасчетныйСчет2Представление, ОписанияТиповПолей.ОписаниеТиповСтрока50, ОписаниеТиповКолонка,
		"Контрагент_2", 3);

	КонтрагентДолжность2Представление = НСтр("ru='(2) Должность (роль)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Должность2",
		КонтрагентДолжность2Представление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка,
		"Контрагент_2", 4);

	ИННКПП3Представление = НСтр("ru='(3) ИНН/КПП или ИНН'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИНН_КПП3",
		ИННКПП3Представление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Контрагент_3", 1);

	КонтрагентНаименование3Представление = НСтр("ru='(3) Контрагент (наименование)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контрагент3Наименование",
		КонтрагентНаименование3Представление, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка,
		"Контрагент_3", 2);

	КонтрагентРасчетныйСчет3Представление = НСтр("ru='(3) Контрагент (расчетный счет)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РасчетныйСчет3",
		КонтрагентРасчетныйСчет3Представление, ОписанияТиповПолей.ОписаниеТиповСтрока50, ОписаниеТиповКолонка,
		"Контрагент_3", 3);

	КонтрагентДолжность3Представление = НСтр("ru='(3) Должность (роль)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Должность3",
		КонтрагентДолжность3Представление, ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка,
		"Контрагент_3", 4);
	
	// ДополнительныеРеквизиты
	НаборСвойств_Справочник_КонтактныеЛица = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_КонтактныеЛица");
	ЗагрузкаДанныхИзВнешнегоИсточника.ПодготовитьСоответствиеПоДополнительнымРеквизитам(НастройкиЗагрузкиДанных,
		НаборСвойств_Справочник_КонтактныеЛица);
	Если НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов.Количество() > 0 Тогда

		ИмяПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяПоляДобавленияДополнительныхРеквизитов();
		ДополнительныеРеквизитыПредставление = НСтр("ru='Дополнительные реквизиты'");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, ИмяПоля,
			ДополнительныеРеквизитыПредставление, ОписанияТиповПолей.ОписаниеТиповСтрока150,
			ОписанияТиповПолей.ОписаниеТиповСтрока11, , , , , , Истина, НаборСвойств_Справочник_КонтактныеЛица);

	КонецЕсли;

КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтактноеЛицо(СтрокаТаблицыФормы.Контакт, СтрокаТаблицыФормы.Наименование, СтрокаТаблицыФормы.Код);
		
		// Родитель по наименованию
		ЗначениеПоУмолчанию = Справочники.КонтактныеЛица.ПустаяСсылка();
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьРодителя("КонтактныеЛица", СтрокаТаблицыФормы.Родитель, СтрокаТаблицыФормы.Родитель_ВходящиеДанные, ЗначениеПоУмолчанию);
		
		// Группа доступа
		Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаКонтрагентов") Тогда
			
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьГруппуДоступа(СтрокаТаблицыФормы.ГруппаДоступа, СтрокаТаблицыФормы.ГруппаДоступа_ВходящиеДанные);
			
		КонецЕсли;
		
		// КИ (адрес ЭП, телефон)
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.АдресЭП, СтрокаТаблицыФормы.АдресЭП_ВходящиеДанные);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Телефон, СтрокаТаблицыФормы.Телефон_ВходящиеДанные);
		
		// Пол
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьПолФизическогоЛица(СтрокаТаблицыФормы.Пол, СтрокаТаблицыФормы.Пол_ВходящиеДанные);
		
		// Дата рождения
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВДату(СтрокаТаблицыФормы.ДатаРождения, СтрокаТаблицыФормы.ДатаРождения_ВходящиеДанные);
		
		// Документ удостоверяющий личность
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.ДокументУдостоверяющийЛичность, СтрокаТаблицыФормы.ДокументУдостоверяющийЛичность_ВходящиеДанные);
		
		// Источник привлечения
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьИсточникиПривлеченияПокупателей(СтрокаТаблицыФормы.ИсточникПривлечения, СтрокаТаблицыФормы.ИсточникПривлечения_ВходящиеДанные);
		
		// Комментарий
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Комментарий, СтрокаТаблицыФормы.Комментарий_ВходящиеДанные);
		
		// (1) Контрагент по ИНН, КПП, Наименованию, Расчетному счету
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(СтрокаТаблицыФормы.Контрагент_1, СтрокаТаблицыФормы.ИНН_КПП1, СтрокаТаблицыФормы.Контрагент1Наименование, СтрокаТаблицыФормы.РасчетныйСчет1);
		
		// (2) Контрагент по ИНН, КПП, Наименованию, Расчетному счету
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(СтрокаТаблицыФормы.Контрагент_2, СтрокаТаблицыФормы.ИНН_КПП2, СтрокаТаблицыФормы.Контрагент2Наименование, СтрокаТаблицыФормы.РасчетныйСчет2);
		
		// (3) Контрагент по ИНН, КПП, Наименованию, Расчетному счету
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(СтрокаТаблицыФормы.Контрагент_3, СтрокаТаблицыФормы.ИНН_КПП3, СтрокаТаблицыФормы.Контрагент3Наименование, СтрокаТаблицыФормы.РасчетныйСчет3);
		
		// Дополнительные реквизиты
		Если НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() > 0 Тогда
			
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьДополнительныеРеквизиты(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты);
			
		КонецЕсли;
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	СтрокаТаблицыФормы._СтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.Контакт);
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля] = СтрокаТаблицыФормы._СтрокаСопоставлена
											ИЛИ (НЕ СтрокаТаблицыФормы._СтрокаСопоставлена И НЕ ПустаяСтрока(СтрокаТаблицыФормы.Наименование));
	
КонецПроцедуры

Процедура ОбработатьПодготовленныеДанные(СтруктураДанных, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ТекущийПользователь				= Пользователи.АвторизованныйПользователь();
	НастройкиОбновленияСвойств		= СтруктураДанных.НастройкиЗагрузкиДанных.НастройкиОбновленияСвойств;
	ОбновлятьСуществующие			= СтруктураДанных.НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	СоздаватьЕслиНеСопоставлено		= СтруктураДанных.НастройкиЗагрузкиДанных.СоздаватьЕслиНеСопоставлено;
	ТаблицаСопоставленияДанных		= СтруктураДанных.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных				= ТаблицаСопоставленияДанных.Количество();
	КоличествоЗаписейТранзакции		= 0;
	ТранзакцияОткрыта				= Ложь;
	
	Попытка
		
		Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
			
			Если НЕ ТранзакцияОткрыта 
				И КоличествоЗаписейТранзакции = 0 Тогда
				
				НачатьТранзакцию();
				ТранзакцияОткрыта = Истина;
				
			КонецЕсли;
			
			ЗагрузкаВПриложениеВозможна = СтрокаТаблицы[ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна()];
			
			СогласованноеСостояниеСтроки = (СтрокаТаблицы._СтрокаСопоставлена И ОбновлятьСуществующие) 
				ИЛИ (НЕ СтрокаТаблицы._СтрокаСопоставлена И СоздаватьЕслиНеСопоставлено);
				
			Если ЗагрузкаВПриложениеВозможна И СогласованноеСостояниеСтроки Тогда
				
				КоличествоЗаписейТранзакции = КоличествоЗаписейТранзакции + 1;
				
				Если СтрокаТаблицы._СтрокаСопоставлена Тогда
					
					ЭлементСправочника = СтрокаТаблицы.Контакт.ПолучитьОбъект();
					ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы, НастройкиОбновленияСвойств.ИменаПолейОбновляемые, НастройкиОбновленияСвойств.ИменаПолейНеподлежащихОбновлению);
					
				Иначе
					
					ЭлементСправочника = Справочники.КонтактныеЛица.СоздатьЭлемент();
					ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы);
					
					ЭлементСправочника.ДатаСоздания = ТекущаяДатаСеанса();
					ЭлементСправочника.Родитель = СтрокаТаблицы.Родитель;
					
				КонецЕсли;
				
				ЭлементСправочника.Наименование = СтрокаТаблицы.Наименование;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.Телефон) Тогда
					
					ДобавитьКИ(ЭлементСправочника, СтрокаТаблицы.Телефон, Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица);
					
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.АдресЭП) Тогда
					
					ДобавитьКИ(ЭлементСправочника, СтрокаТаблицы.АдресЭП, Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица);
					
				КонецЕсли;
				
				Если СтруктураДанных.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() > 0 Тогда
					
					ЗагрузкаДанныхИзВнешнегоИсточника.ОбработатьВыбранныеДополнительныеРеквизиты(ЭлементСправочника, СтрокаТаблицы._СтрокаСопоставлена, СтрокаТаблицы, СтруктураДанных.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты);
					
				КонецЕсли;
				
				ЭлементСправочника.Записать();
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент_1) Тогда
					
					РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(СтрокаТаблицы.Контрагент_1, ЭлементСправочника.Ссылка, СтрокаТаблицы.Должность1,ТекущийПользователь,);
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент_2) Тогда
					
					РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(СтрокаТаблицы.Контрагент_2, ЭлементСправочника.Ссылка, СтрокаТаблицы.Должность2, ТекущийПользователь,);
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент_3) Тогда
					
					РегистрыСведений.СвязиКонтрагентКонтакт.НоваяСвязь(СтрокаТаблицы.Контрагент_3, ЭлементСправочника.Ссылка, СтрокаТаблицы.Должность3, ТекущийПользователь,);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ИндексТекущейСтроки = ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицы);
			ТекстПрогресса      = СтрШаблон(НСтр("ru ='Обработано %1 из %2 строк...'"), ИндексТекущейСтроки, РазмерТаблицыДанных);
			ПроцентВыполнения   = Окр(ИндексТекущейСтроки * 100 / РазмерТаблицыДанных);
			
			ДлительныеОперации.СообщитьПрогресс(ПроцентВыполнения, ТекстПрогресса);
			
			Если ТранзакцияОткрыта
				И КоличествоЗаписейТранзакции > ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.МаксимумЗаписейВОднойТранзакции() Тогда
				
				ЗафиксироватьТранзакцию();
				ТранзакцияОткрыта = Ложь;
				КоличествоЗаписейТранзакции = 0;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТранзакцияОткрыта 
			И КоличествоЗаписейТранзакции > 0 Тогда
			
			ЗафиксироватьТранзакцию();
			ТранзакцияОткрыта = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Загрузка данных'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, 
			Метаданные.Справочники.Номенклатура, , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.//
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформацияУНФ

Процедура ЗаполнитьДанныеПанелиКонтактнаяИнформация(ВладелецКИ, ДанныеПанелиКонтактнойИнформации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Ссылка КАК Ссылка,
	|	КонтактнаяИнформация.Тип КАК Тип,
	|	КонтактнаяИнформация.Вид КАК Вид,
	|	КонтактнаяИнформация.Представление КАК Представление,
	|	КонтактнаяИнформация.ЗначенияПолей КАК ЗначенияПолей,
	|	КонтактнаяИнформация.Значение КАК Значение
	|ИЗ
	|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Ссылка = &ВладелецКИ";
	
	Запрос.УстановитьПараметр("ВладелецКИ", ВладелецКИ);
	ДанныеКИ = Запрос.Выполнить().Выбрать();
	
	Пока ДанныеКИ.Следующий() Цикл
		Комментарий = УправлениеКонтактнойИнформацией.КомментарийКонтактнойИнформации(ДанныеКИ.Значение);
		НоваяСтрока = Новый Структура;
		НоваяСтрока.Вставить("Отображение", Строка(ДанныеКИ.Вид) + ": " + ДанныеКИ.Представление + ?(ПустаяСтрока(Комментарий), "", ", " + Комментарий));
		НоваяСтрока.Вставить("ИндексПиктограммы", КонтактнаяИнформацияПанельУНФ.ИндексПиктограммыПоТипу(ДанныеКИ.Тип));
		НоваяСтрока.Вставить("ТипОтображаемыхДанных", "ЗначениеКИ");
		НоваяСтрока.Вставить("ВладелецКИ", ВладелецКИ);
		НоваяСтрока.Вставить("ПредставлениеКИ", ДанныеКИ.Представление);
		НоваяСтрока.Вставить("ТипКИ", ДанныеКИ.Тип);
		ДанныеПанелиКонтактнойИнформации.Добавить(НоваяСтрока);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	РедактируемыеРеквизиты.Добавить("ГруппаДоступа");
	РедактируемыеРеквизиты.Добавить("ДатаСоздания");
	РедактируемыеРеквизиты.Добавить("Недействителен");
	РедактируемыеРеквизиты.Добавить("Ответственный");
	РедактируемыеРеквизиты.Добавить("ИсточникПривлечения");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Возвращает таблицу контрагентов , которые связаны с контактами
//
Функция СоответствиеКонтрагентовИКонтактов(Контакты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПРЕДСТАВЛЕНИЕ(Контрагенты.Ссылка) КАК Представление,
	|	СвязиКонтрагентКонтакт.Контакт КАК Контакт
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО (Контрагенты.Ссылка = СвязиКонтрагентКонтакт.Контрагент)
	|ГДЕ
	|	СвязиКонтрагентКонтакт.Контакт В(&Контакты)
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Контакты", Контакты);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает представление контакта, со списком связанных с ним контрагентов через запятую
//
Функция ПредставлениеКонтакта(ПредставлениеЭлемента, ПредставленияСвязанныхКонтрагентов)
	
	ПредставлениеКонтрагентов = "";
	
	Если ПредставленияСвязанныхКонтрагентов.Количество() > 0 Тогда
		ПредставлениеКонтрагентов = СтрШаблон(НСтр("ru = '(Контрагенты: %1)'"), 
			СтрСоединить(ПредставленияСвязанныхКонтрагентов, ", "));
	Иначе
		ПредставлениеКонтрагентов = НСтр("ru = '(<нет связей>)'");
	КонецЕсли;
	
	ШаблонПредставлениеКонтакта = СтрШаблон(НСтр("ru = '%1 %2'"), 
		ПредставлениеЭлемента,
		ПредставлениеКонтрагентов);
	ПредставлениеКонтакта = Новый ФорматированнаяСтрока(ШаблонПредставлениеКонтакта);
	
	Возврат ПредставлениеКонтакта;
	
КонецФункции

Процедура ДополнитьДанныеВыбораСвязямиСКонтрагентами(ДанныеВыбора, Параметры)
	
	СоответствиеКонтрагентовИКонтактов = СоответствиеКонтрагентовИКонтактов(ДанныеВыбора.ВыгрузитьЗначения());
	
	Для Каждого ДанныеКонтакта Из ДанныеВыбора Цикл
		СвязанныеКонтрагенты = СоответствиеКонтрагентовИКонтактов.НайтиСтроки(Новый Структура("Контакт", ДанныеКонтакта.Значение));
		ПредставленияКонтрагентов = Новый Массив;
		Для каждого ДанныеКонтрагента Из СвязанныеКонтрагенты Цикл
			ПредставленияКонтрагентов.Добавить(ДанныеКонтрагента.Представление);
		КонецЦикла;
		ПредставлениеКонтакта = ПредставлениеКонтакта(ДанныеКонтакта.Представление, ПредставленияКонтрагентов);
		Если Параметры.Свойство("СтрокаПоиска") Тогда
			ПредставлениеКонтакта = СтрНайтиИВыделитьОформлением(ПредставлениеКонтакта, Параметры.СтрокаПоиска);
		КонецЕсли;
		ДанныеКонтакта.Представление = ПредставлениеКонтакта;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли