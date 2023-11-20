#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = "УправлениеНебольшойФирмой";
	Настройки.ИмяКонфигурацииПриемника.Вставить("БухгалтерияПредприятия");
	Настройки.ИмяКонфигурацииПриемника.Вставить("БухгалтерияПредприятияБазовая");
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
	Если ИспользуетсяТестовыйРежимОбменПоПравилам() Тогда
		
		// Тестирование перехода на новый обмен
		
	Иначе
		
		// Если свойство установлено, в рабочих местах управления настройками не будет предлагаться настроить этот вид обмена.
		// Существующие обмены этого вида будут продолжать отображаться в списке настроенных обменов.
		// Получение сообщения обмена в новом формате будет инициировать переход на новый вид обмена.
		Настройки.Вставить("ИмяПланаОбменаДляПереходаНаНовыйОбмен", "СинхронизацияДанныхЧерезУниверсальныйФормат");
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = "Настройки обмена для УНФ-БП";
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки);
	
	Если ИспользуетсяТестовыйРежимОбменПоПравилам()
		И ОбщегоНазначенияУНФ.ЭтоУНФ() Тогда
		
		ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
		
	Иначе
		
		// Если свойство установлено, в рабочих местах управления настройками не будет предлагаться настроить этот вид обмена.
		// Существующие обмены этого вида будут продолжать отображаться в списке настроенных обменов.
		// Получение сообщения обмена в новом формате будет инициировать переход на новый вид обмена.
		ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Ложь;
		
	КонецЕсли;
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "\1c\smallbusiness\";
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "БухгалтерияПредприятия";
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = '1С:Бухгалтерия предприятия 8, ред. 3.0'");
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена =               НСтр("ru = 'Настройка синхронизации с программой ""1С:Бухгалтерия предприятия 8, ред. 3.0""'");
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена =                       НСтр("ru = 'Синхронизация с программой ""1С:Бухгалтерия предприятия 8, ред. 3.0""'");
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента =         НСтр("ru = '1С:Бухгалтерия предприятия 8, ред. 3.0'");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Дополнение к функционалу БСП

// Возвращает режим запуска, в случае интерактивного инициирования синхронизации
// Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
// На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	
	Если УзелИнформационнойБазы.РучнойОбмен Тогда
		
		Возврат "ИнтерактивнаяСинхронизация";
		
	Иначе
		
		Возврат "АвтоматическаяСинхронизация";
		
	КонецЕсли;
	
КонецФункции

// Возвращает сценарий работы помощника интерактивного сопоставления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
	Если УзелИнформационнойБазы.РучнойОбмен Тогда
		
		Возврат "ИнтерактивнаяСинхронизацияДокументов";
		
	КонецЕсли;
	
КонецФункции

// Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
// Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
// Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	// Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	
	Возврат Результат;
	
КонецФункции

Функция ОбщиеДанныеУзлов()
	
	Возврат "РежимВыгрузкиПриНеобходимости, РучнойОбмен";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки)
	
	Возврат "";
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	ПоясняющийТекст = НСтр("ru = '	Позволяет синхронизировать данные между приложениями 1С:Управление нашей фирмой, ред. 1.6 и 1С:Бухгалтерия предприятия 8, ред. 3.0. Из приложения Управление нашей фирмой в приложение Бухгалтерия предприятия переносятся справочники и все необходимые документы, а из приложения Бухгалтерия предприятия в приложение Управление нашей фирмой - справочники и документы учета денежных средств. Для получения более подробной информации нажмите на ссылку Подробное описание.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции // КраткаяИнформацияПоОбмену()

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
//   в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	Если ПолучитьФункциональнуюОпцию("РаботаВМоделиСервиса") Тогда
		ПутьКИнформацииПоОбмену = "https://1cfresh.com/articles/obmen";
	Иначе
		ПутьКИнформацииПоОбмену = "https://its.1c.ru/db/metod81#content:7296:hdoc";
	КонецЕсли;
	
	Возврат ПутьКИнформацииПоОбмену;
	
КонецФункции

// Возвращает сокращенное строковое представление коллекции значений.
// 
// Параметры:
//  Коллекция 						- массив или список значений.
//  МаксимальноеКоличествоЭлементов - число, максимальное количество элементов включаемое в представление.
//
// Возвращаемое значение:
//  Строка.
//
Функция СокращенноеПредставлениеКоллекцииЗначений(Коллекция, МаксимальноеКоличествоЭлементов = 3) Экспорт
	
	СтрокаПредставления = "";
	
	КоличествоЗначений			 = Коллекция.Количество();
	КоличествоВыводимыхЭлементов = Мин(КоличествоЗначений, МаксимальноеКоличествоЭлементов);
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Для НомерЗначения = 1 По КоличествоВыводимыхЭлементов Цикл
			
			СтрокаПредставления = СтрокаПредставления + Коллекция.Получить(НомерЗначения - 1) + ", ";	
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		Если КоличествоЗначений > КоличествоВыводимыхЭлементов Тогда
			СтрокаПредставления = СтрокаПредставления + ", ... ";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииУНФ

// Инициализирует у всех узлов режим выгрузки при необходимости
//
Процедура ИнициализироватьРежимВыгрузкиПриНеобходимости() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	БП.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия30 КАК БП
	|ГДЕ
	|	БП.Ссылка <> &ЭтотУзел
	|	И ВЫБОР
	|			КОГДА БП.РежимВыгрузкиПриНеобходимости <> ЗНАЧЕНИЕ(Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ = ИСТИНА");
	
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия30.ЭтотУзел());
	
	ВыборкаУзлов = Запрос.Выполнить().Выбрать();
	Пока ВыборкаУзлов.Следующий() Цикл
		
		УзелПланаОбменаОбъект = ВыборкаУзлов.Ссылка.ПолучитьОбъект();
		УзелПланаОбменаОбъект.РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		УзелПланаОбменаОбъект.ДополнительныеСвойства.Вставить("Загрузка");
		УзелПланаОбменаОбъект.Записать();
		
		РегистрыСведений.ИзмененияОбщихДанныхУзлов.ЗарегистрироватьИзменения(УзелПланаОбменаОбъект.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет массив узлов на которых будет произведена регистрация объекта
//
Функция ОпределитьМассивПолучателей(Выгрузка, Объект, Получатели) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Выгрузка Тогда
		Возврат Получатели;
	КонецЕсли;
	
	Если Объект.ДополнительныеСвойства.Свойство("УзлыДляРегистрации")
		И ТипЗнч(Объект.ДополнительныеСвойства.УзлыДляРегистрации) = Тип("Массив") Тогда
		Получатели = Объект.ДополнительныеСвойства.УзлыДляРегистрации;
		Возврат Получатели;
	КонецЕсли;
	
	МассивИсключаемыхУзлов = Новый Массив;
	Для Каждого Узел Из Получатели Цикл
		Если Не ОбъектПодходитПодНастройкиВыгрузкиУзла(Узел, Объект) Тогда
			МассивИсключаемыхУзлов.Добавить(Узел);
		КонецЕсли;
	КонецЦикла;
	
	Получатели = ОбщегоНазначенияКлиентСервер.РазностьМассивов(Получатели, МассивИсключаемыхУзлов);
	Возврат Получатели;
	
КонецФункции

Функция ОбъектПодходитПодНастройкиВыгрузкиУзла(Узел, Объект)
	
	ЭтоРучнойОбмен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел, "РучнойОбмен");
	Если ЭтоРучнойОбмен Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ВыгружатьВидДокумента(Узел, Объект)
		И ОперацияДокументаПодходитПодНастройкиВыгрузкиУзла(Узел, Объект);
	
КонецФункции

Функция ВыгружатьВидДокумента(Узел, Объект)
	
	ИспользоватьОтборПоВидамДокументов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел,
		"ИспользоватьОтборПоВидамДокументов");
	Если Не ИспользоватьОтборПоВидамДокументов Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиСинхронизацииВидыДокументов.Ссылка КАК Ссылка,
	|	НастройкиСинхронизацииВидыДокументов.ИмяОбъектаМетаданных КАК ИмяОбъектаМетаданных
	|ИЗ
	|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ВидыДокументов КАК НастройкиСинхронизацииВидыДокументов
	|ГДЕ
	|	НастройкиСинхронизацииВидыДокументов.Ссылка = &Ссылка
	|	И НастройкиСинхронизацииВидыДокументов.ИмяОбъектаМетаданных = &ИмяОбъектаМетаданных";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат",
		Узел.Метаданные().ПолноеИмя());
	Запрос.УстановитьПараметр("Ссылка", Узел);
	
	ИмяОбъектаМетаданных = Объект.Метаданные().Имя;
	Если (ТипЗнч(Объект) = Тип("ДокументОбъект.ЗаказПокупателя")
		ИЛИ ТипЗнч(Объект) = Тип("ДокументСсылка.ЗаказПокупателя"))
		И Объект.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу Тогда
		ИмяОбъектаМетаданных = ИмяОбъектаМетаданных + "Продажа";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ИмяОбъектаМетаданных", ИмяОбъектаМетаданных);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции

Функция ОперацияДокументаПодходитПодНастройкиВыгрузкиУзла(Узел, Объект)
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Если Объект.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
			Возврат Истина;
		Иначе
			ЗаказПокупателяВыгружаетсяПоУмолчанию = ТипЗнч(Узел) = Тип(
				"ПланОбменаСсылка.СинхронизацияДанныхЧерезУниверсальныйФормат")
				И (Узел.ВариантНастройки = "ВебВитрина"
				Или Узел.ВариантНастройки = "КабинетКлиента"
				Или Узел.ВариантНастройки = "ОбменМК"
				Или Узел.ВариантНастройки = "ОбменКасса");
			Возврат ЗаказПокупателяВыгружаетсяПоУмолчанию ИЛИ Узел.ПереноситьЗаказыКакСчетаНаОплату;
		КонецЕсли;
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПеремещениеЗапасов") Тогда
		Если Объект.ВидОперации = Перечисления.ВидыОперацийПеремещениеЗапасов.Перемещение
			И ТипЗнч(Узел) = Тип("ПланОбменаСсылка.СинхронизацияДанныхЧерезУниверсальныйФормат")
			И Узел.НеВыгружатьПеремещенияЗапасов Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Регистрирует документы, связанные с переданным документом по ссылке.
//
Процедура ЗарегистрироватьСвязанныеДокументы(Выгрузка, Объект, ПРО, Получатели) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Выгрузка
		ИЛИ Объект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗарегистрированныхДокументов = Неопределено;
	Объект.ДополнительныеСвойства.Свойство("ЗарегистрированныеДокументы", МассивЗарегистрированныхДокументов);
	Если ТипЗнч(МассивЗарегистрированныхДокументов) <> Тип("Массив") Тогда
		МассивЗарегистрированныхДокументов = Новый Массив;
	КонецЕсли;
	
	Если МассивЗарегистрированныхДокументов.Найти(Объект.Ссылка) = Неопределено Тогда
		МассивЗарегистрированныхДокументов.Добавить(Объект.Ссылка);
	КонецЕсли;
	
	МассивУзловДляРегистрации = Новый Массив;
	Для каждого УзелПолучатель Из Получатели Цикл
		Если УзелПолучатель.ИспользоватьОтборПоВидамДокументов
			ИЛИ УзелПолучатель.РучнойОбмен Тогда
			МассивУзловДляРегистрации.Добавить(УзелПолучатель);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивУзловДляРегистрации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СвязанныеДокументы = Новый ТаблицаЗначений;
	СвязанныеДокументы.Колонки.Добавить("Документ");
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.АвансовыйОтчет") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.ВыданныеАвансы Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Оплаты Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.АктВыполненныхРабот") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ДополнительныеРасходы") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Запасы Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.ДокументПоступления;
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ЗаказПокупателя")
		И Объект.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетКомиссионера") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Покупатели Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.СчетФактура;
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетКомитенту") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетОПереработке") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетПереработчика") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПоступлениеВКассу") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПоступлениеНаСчет") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОперацияПоПлатежнымКартам") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПриходнаяНакладная") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.РасходИзКассы") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.РасходнаяНакладная") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.КорректировкаПоступления") Тогда
		
		Если ЗначениеЗаполнено(Объект.ИсправляемыйДокументПоступления) Тогда
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = Объект.ИсправляемыйДокументПоступления;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.КорректировкаРеализации") Тогда
		
		Если ЗначениеЗаполнено(Объект.ИсправляемыйДокументРеализации) Тогда
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = Объект.ИсправляемыйДокументРеализации;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.РасходСоСчета") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.СчетФактура") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.ДокументыОснования Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.ДокументОснование;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.СчетФактураПолученный") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.ДокументыОснования Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.ДокументОснование;
		КонецЦикла;
		
	КонецЕсли;
	
	СвязанныеДокументы.Свернуть("Документ");
	Если СвязанныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект = СтрокаТаблицы.Документ.ПолучитьОбъект();
		Если ДокументОбъект = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если МассивЗарегистрированныхДокументов.Найти(ДокументОбъект.Ссылка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДоступныеУзлы = Новый Массив;
		
		МетаДокумент = ДокументОбъект.Метаданные();
		Для каждого УзелДляРегистрации Из МассивУзловДляРегистрации Цикл
			
			Если УзелДляРегистрации.Метаданные().Состав.Найти(МетаДокумент) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если УзелДляРегистрации.Метаданные().Реквизиты.Найти("АвтоматическиЗачитыватьАвансы") <> Неопределено Тогда
				АвтоматическиЗачитыватьАвансыВБП = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелДляРегистрации, "АвтоматическиЗачитыватьАвансы");
				Если АвтоматическиЗачитыватьАвансыВБП Тогда
					Если Объект.Метаданные().ТабличныеЧасти.Найти("РасшифровкаПлатежа") <> Неопределено
					  ИЛИ (ТипЗнч(СтрокаТаблицы.Документ) = Тип("ДокументСсылка.ПоступлениеВКассу")
						ИЛИ ТипЗнч(СтрокаТаблицы.Документ) = Тип("ДокументСсылка.ПоступлениеНаСчет")
						ИЛИ ТипЗнч(СтрокаТаблицы.Документ) = Тип("ДокументСсылка.РасходИзКассы")
						ИЛИ ТипЗнч(СтрокаТаблицы.Документ) = Тип("ДокументСсылка.РасходСоСчета")) Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ДоступныеУзлы.Добавить(УзелДляРегистрации);
		КонецЦикла;
		
		Если ДоступныеУзлы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект.ДополнительныеСвойства.Вставить("УзлыДляРегистрации", ДоступныеУзлы);
		ДокументОбъект.ДополнительныеСвойства.Вставить("ЗарегистрированныеДокументы", МассивЗарегистрированныхДокументов);
		ОбменДаннымиСобытия.ВыполнитьПравилаРегистрацииДляОбъекта(ДокументОбъект, ПРО.ИмяПланаОбмена, Неопределено);
		
	КонецЦикла;
	
КонецПроцедуры

// Предназначена для тестирования перехода на универсальный формат.
Функция ИспользуетсяТестовыйРежимОбменПоПравилам()
	
	ИспользуетсяТестовыйРежим = Ложь;
	Если НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат ИспользуетсяТестовыйРежим;
	КонецЕсли;
	
	Попытка
		Если Найти(ВРег(Константы.ЗаголовокСистемы.Получить()), ВРег("ОбменПоПравилам")) > 0 Тогда
			ИспользуетсяТестовыйРежим = Истина;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Возврат ИспользуетсяТестовыйРежим;
	
КонецФункции

#КонецОбласти

#КонецЕсли