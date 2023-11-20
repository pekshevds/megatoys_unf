////////////////////////////////////////////////////////////////////////////////
// Общий модуль ИнтеграцияЭДОКлиентСервер
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбъектУчета

// Инициализирует объект учета.
//
// Параметры:
//  Ссылка - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект учета.
//  Данные - Произвольный - данные объекта учета.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - инициализированный объект учета.
//
Функция НовыйОбъектУчета(Ссылка, Данные = Неопределено) Экспорт
	
	ОбъектУчета = Новый Структура;
	ОбъектУчета.Вставить("Ссылка", Ссылка);
	ОбъектУчета.Вставить("Данные", Данные);
	
	Возврат Новый ФиксированнаяСтруктура(ОбъектУчета);
	
КонецФункции

Функция НовоеОписаниеОбъектаУчетаСтруктура() Экспорт
	
	Описание = Новый Структура;
	
	Описание.Вставить("ОбъектУчета");
	Описание.Вставить("Направление");
	Описание.Вставить("ТипДокумента");
	Описание.Вставить("ПрикладнойТипДокумента");
	Описание.Вставить("Организация");
	Описание.Вставить("Контрагент");
	Описание.Вставить("Договор");
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти

#Область ГотовностьКДокументообороту

// Возвращает признак готовности к документообороту всех объектов, участвовавших в проверке.
//
// Параметры:
//  Проверка - см. ИнтеграцияЭДО.НоваяПроверкаГотовностиКДокументообороту
//
// Возвращаемое значение:
//  Булево - признак готовности.
//
Функция ГотовностьКДокументообороту(Знач Проверка) Экспорт
	
	Возврат Не ЗначениеЗаполнено(Проверка.Неготовые);
	
КонецФункции

#КонецОбласти

#Область ВидыОшибок

Функция ВидОшибкиОбновлениеВерсииЭДЗакрытПринудительно() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ОбновлениеВерсииЭДЗакрытПринудительно";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Электронный документ закрыт принудительно'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Были изменены ключевые реквизиты, участвующие в электронном документообороте'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Создайте"">Создайте</a> новый электронный документ'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Создайте", "ИнтеграцияЭДОКлиент.ОткрытьФормуСозданияНовогоЭД");
	
	Возврат ВидОшибки;
	
КонецФункции

Функция ВидОшибкиОбновлениеВерсииЭДСформированоИсправление() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ОбновлениеВерсииЭДСформированоИсправление";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Электронный документ стал неактуальным'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Были изменены ключевые реквизиты, участвующие в электронном документообороте'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Сформировать"">Сформировать</a> исправление электронного документа'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Сформировать", "ИнтеграцияЭДОКлиент.ОткрытьФормуИсправленияЭД");
	
	Возврат ВидОшибки;
	
КонецФункции

Функция ВидОшибкиОбновлениеВерсииЭДТребуетсяАннулирование() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ОбновлениеВерсииЭДТребуетсяАннулирование";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Электронный документ стал неактуальным'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Были изменены ключевые реквизиты, участвующие в электронном документообороте'");
	ОписаниеРешения = НСтр("ru = '<a href = ""Создайте"">Аннулируйте старый и создайте</a> новый электронный документ'");
	ВидОшибки.ОписаниеРешения = ОписаниеРешения;
	ВидОшибки.ОбработчикиНажатия.Вставить("Создайте",
		"ИнтеграцияЭДОКлиент.ОткрытьФормуАннулированияСтарогоЭДИСозданияНового");
		
	Возврат ВидОшибки;
	
КонецФункции
#КонецОбласти

// Инициализирует данные электронного документа для отражения в учете.
// 
// Возвращаемое значение:
//  Структура - инициализированные данные электронного документа для отражения в учете:
// * ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО, ДокументСсылка.ЭлектронныйДокументИсходящийЭДО -
// * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО -
// * ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО -
// * Отправитель - СправочникСсылка.Организации, СправочникСсылка.Контрагенты -
// * Получатель - СправочникСсылка.Организации, СправочникСсылка.Контрагенты -
// * ИдентификаторОтправителя - Строка -
// * ИдентификаторПолучателя - Строка -
// * ЕстьПравилаОтраженияВУчете - Булево -
// * СостояниеДокумента - ПеречислениеСсылка.СостоянияДокументовЭДО -
// * Направление - ПеречислениеСсылка.НаправленияЭДО -
// * ДанныеОсновногоФайла - Структура - Основной присоединенный файл:
// ** ИмяФайла - Строка -
// ** ДвоичныеДанные - ДвоичныеДанные -
// * ДанныеДополнительногоФайла - Структура - Дополнительный присоединенный файл:
// ** ИмяФайла - Строка -
// ** ДвоичныеДанные - ДвоичныеДанные -
// * ОтключитьКонтрольОтраженияВУчете - Булево -
// * ДополнительныеДанные - Структура -
// * ПредставлениеДокумента - Строка -
Функция НовыеДанныеЭлектронногоДокументаДляОтраженияВУчете() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ЭлектронныйДокумент", Неопределено);
	Параметры.Вставить("ВидДокумента");
	Параметры.Вставить("ТипДокумента", Неопределено);
	Параметры.Вставить("Отправитель", Неопределено);
	Параметры.Вставить("Получатель", Неопределено);
	Параметры.Вставить("ИдентификаторОтправителя", "");
	Параметры.Вставить("ИдентификаторПолучателя", "");	
	Параметры.Вставить("ЕстьПравилаОтраженияВУчете", Ложь);
	Параметры.Вставить("СостояниеДокумента");
	Параметры.Вставить("Направление", ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Входящий"));
	Параметры.Вставить("ДанныеОсновногоФайла", РаботаСФайламиБЭДКлиентСервер.НовоеОписаниеФайла());
	Параметры.Вставить("ДанныеДополнительногоФайла", РаботаСФайламиБЭДКлиентСервер.НовоеОписаниеФайла());
	Параметры.Вставить("ОтключитьКонтрольОтраженияВУчете", Ложь);
	Параметры.Вставить("ДополнительныеДанные", Новый Структура);
	Параметры.Вставить("ПредставлениеДокумента", "");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти



