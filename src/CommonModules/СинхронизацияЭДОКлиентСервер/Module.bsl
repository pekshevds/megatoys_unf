//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру для определения параметров подключения ЭДО.
//
// Возвращаемое значение:
//  см. УчетныеЗаписиЭДОКлиентСервер.НовыеПараметрыПодключенияЭДО.
//
Функция НовыеПараметрыПодключенияЭДО() Экспорт
	
	Возврат УчетныеЗаписиЭДОКлиентСервер.НовыеПараметрыПодключенияЭДО();
	
КонецФункции

// См. УчетныеЗаписиЭДОКлиентСервер.НовыеПараметрыОбновленияСертификата
Функция НовыеПараметрыОбновленияСертификата() Экспорт
	
	Возврат УчетныеЗаписиЭДОКлиентСервер.НовыеПараметрыОбновленияСертификата();
	
КонецФункции

// Возвращает описание операции подключения ЭДО.
//
// Параметры:
//  Параметры - см. УчетныеЗаписиЭДОКлиентСервер.НовыеПараметрыПодключенияЭДО. 
//
// Возвращаемое значение:
//  См. УчетныеЗаписиЭДОКлиентСервер.НоваяОперацияЭДО.
//
Функция НоваяОперацияПодключенияЭДО(Знач Параметры = Неопределено) Экспорт

	Возврат УчетныеЗаписиЭДОКлиентСервер.НоваяОперацияПодключенияЭДО(Параметры);

КонецФункции

// См. УчетныеЗаписиЭДОКлиентСервер.НоваяОперацияОбновленияСертификата
Функция НоваяОперацияОбновленияСертификата(Знач Параметры = Неопределено) Экспорт

	Возврат УчетныеЗаписиЭДОКлиентСервер.НоваяОперацияОбновленияСертификата(Параметры);

КонецФункции

// См. УчетныеЗаписиЭДОКлиентСервер.ОперацияПодключенияЭДОКорректна
Функция ОперацияПодключенияЭДОКорректна(Знач ОперацияЭДО) Экспорт
	
	Возврат УчетныеЗаписиЭДОКлиентСервер.ОперацияПодключенияЭДОКорректна(ОперацияЭДО);
	
КонецФункции

// См. УчетныеЗаписиЭДОКлиентСервер.ОперацияОбновленияСертификатаКорректна
Функция ОперацияОбновленияСертификатаКорректна(Знач ОперацияЭДО) Экспорт
	
	Возврат УчетныеЗаписиЭДОКлиентСервер.ОперацияОбновленияСертификатаКорректна(ОперацияЭДО);
	
КонецФункции

// Возвращает ключ синхронизации.
// 
// Возвращаемое значение:
// 	Структура:
// * ВыбранныйСертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// * СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// * ИдентификаторУчетнойЗаписи - Строка
// * МаркерВалиден - Булево - если сервис вернул ошибку некорректного маркера, устанавливается значение Ложь
// * МаркерПросрочен - Булево - истек срок действия маркера
// * ДатаПервогоЗапросаМаркера - Дата
// * КоличествоЗапросовМаркера - Число
Функция НовыйКлючСинхронизации() Экспорт
	
	КлючСинхронизации = Новый Структура;
	КлючСинхронизации.Вставить("ИдентификаторУчетнойЗаписи", "");
	КлючСинхронизации.Вставить("Сертификаты", Новый Массив);
	КлючСинхронизации.Вставить("СпособОбмена", ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ПустаяСсылка"));
	КлючСинхронизации.Вставить("ВыбранныйСертификат", 
		ПредопределенноеЗначение("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка"));
	КлючСинхронизации.Вставить("МаркерРасшифрованный", Неопределено);
	КлючСинхронизации.Вставить("МаркерЗашифрованный", Неопределено);
	КлючСинхронизации.Вставить("МаркерВалиден", Истина);
	КлючСинхронизации.Вставить("МаркерПросрочен", Ложь);
	КлючСинхронизации.Вставить("ДатаПервогоЗапросаМаркера", Дата(1, 1, 1));
	КлючСинхронизации.Вставить("КоличествоЗапросовМаркера", 0);
	
	Возврат КлючСинхронизации;
	
КонецФункции

// Инициализирует ключи синхронизации.
// 
// Возвращаемое значение:
// 	Соответствие из КлючИЗначение:
//    * Ключ - Строка - идентификатор учетной записи
//    * Значение - см. СинхронизацияЭДОКлиентСервер.НовыйКлючСинхронизации
Функция НовыеКлючиСинхронизации() Экспорт
	
	Возврат Новый Соответствие;
	
КонецФункции

// Проверяет, является ли способ обмена обменом через оператора электронного документооборота.
// 
// Параметры:
// 	СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// Возвращаемое значение:
// 	Булево
Функция ЭтоОбменЧерезОператора(СпособОбмена) Экспорт
	
	Возврат СпособОбмена = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО")
		Или СпособОбмена = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезОператораЭДОТакском");
		
КонецФункции

// Возвращает результат отправки объектов.
// 
// Возвращаемое значение:
// 	Структура:
// * Ошибка - Булево - при отправке произошла ошибка
// * ОтправленныеОбъекты - Соответствие из КлючИЗначение:
//     * Ключ - ЛюбаяСсылка
//     * Значение - Структура:
//        ** Успех - - Булево
//        ** ОшибкаПередачи - см. СинхронизацияЭДО.НоваяОшибкаПередачи
// * ТребуетсяОбработкаНаКлиенте - Булево - если Истина, отправку необходимо выполнить с клиента, вызвав 
//                                 см. СинхронизацияЭДОКлиент.ОтправитьОбъекты, передав КонтекстОтправки.
// * КонтекстОтправки - Произвольный, Неопределено - данные, необходимые для вызова клиентского метода отправки.
// * КонтекстДиагностики - Неопределено
//                       - См. ОбработкаНеисправностейБЭДКлиентСервер.НовыйКонтекстДиагностики
// * ДополнительныеПараметры - Неопределено
//                           - Произвольный - значение, переданное в см. СинхронизацияЭДО.ОтправитьОбъекты.
//
Функция НовыйРезультатОтправкиОбъектов() Экспорт
	
	РезультатОтправки = Новый Структура;
	РезультатОтправки.Вставить("Ошибка", Ложь);
	РезультатОтправки.Вставить("ТребуетсяОбработкаНаКлиенте", Ложь);
	РезультатОтправки.Вставить("КонтекстОтправки", Неопределено);
	РезультатОтправки.Вставить("КонтекстДиагностики", Неопределено);
	РезультатОтправки.Вставить("ОтправленныеОбъекты", Новый Соответствие);
	РезультатОтправки.Вставить("ДополнительныеПараметры", Неопределено);
	РезультатОтправки.Вставить("РезультатыОтправкиПолучения", Новый Структура("Успешные, Неудачные", Новый Массив, Новый Массив));
	
	Возврат РезультатОтправки;
	
КонецФункции

// Возвращает операции настроек регламентных заданий синхронизации.
// 
// Возвращаемое значение:
// 	Структура:
// * Отправка - Строка
// * Получение - Строка
// * ПоУмолчанию - Строка
Функция ОперацииПроверкиНастроекРегламентныхЗаданий() Экспорт
	
	Операции = Новый Структура;
	Операции.Вставить("Отправка", "Отправка");
	Операции.Вставить("Получение", "Получение");
	Операции.Вставить("ПоУмолчанию", "ПоУмолчанию");
	
	Возврат Операции;
	
КонецФункции

// Возвращает имя регламентного задания "Пометка на удаление транспортных контейнеров электронных документов".
// 
// Возвращаемое значение:
// 	Строка
Функция ИмяРегламентногоЗаданияПометкаНаУдалениеТранспортныхКонтейнеровЭлектронныхДокументов() Экспорт
	
	Возврат ТранспортныеКонтейнерыЭДОКлиентСервер.ИмяРегламентногоЗаданияПометкаНаУдалениеТранспортныхКонтейнеровЭлектронныхДокументов();
	
КонецФункции

// Возвращает имя регламентного задания "Отправка электронных документов".
// 
// Возвращаемое значение:
// 	Строка
Функция ИмяРегламентногоЗаданияОтправкаЭлектронныхДокументов() Экспорт
	
	Возврат "ОтправкаЭлектронныхДокументов";
	
КонецФункции

// Возвращает имя регламентного задания "Получение электронных документов".
// 
// Возвращаемое значение:
// 	Строка
Функция ИмяРегламентногоЗаданияПолучениеЭлектронныхДокументов() Экспорт
	
	Возврат "ПолучениеЭлектронныхДокументов";
	
КонецФункции

// Возвращает имя регламентного задания "Проверка новых электронных документов".
// 
// Возвращаемое значение:
// 	Строка
Функция ИмяРегламентногоЗаданияПроверкаНовыхЭлектронныхДокументов() Экспорт
	
	Возврат "ПроверкаНовыхЭлектронныхДокументов";
	
КонецФункции

#Область СервисЭДО

// См. СервисЭДОКлиентСервер.СсылкаНаОписаниеСервисаЭДО
Функция СсылкаНаОписаниеСервисаЭДО() Экспорт
	
	Возврат СервисЭДОКлиентСервер.СсылкаНаОписаниеСервисаЭДО();
	
КонецФункции

#КонецОбласти

#Область ОбработкаНеисправностей

// См. ОбменСКонтрагентамиИнтеграцияКлиентСерверСобытия.ПриИнициализацииКонтекстаДиагностики
Процедура ПриИнициализацииКонтекстаДиагностики(КонтекстДиагностики) Экспорт
	
	КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами.Вставить("ТекущаяУчетнаяЗапись", "");
	КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами.Вставить("РезультатыОтправкиПолучения",
		Новый Структура("Успешные, Неудачные", Новый Массив, Новый Массив));
	
КонецПроцедуры

// См. ОбменСКонтрагентамиИнтеграцияКлиентСерверСобытия.ПриИнициализацииОшибки
Процедура ПриИнициализацииОшибки(Ошибка) Экспорт
	
	Ошибка.Вставить("УчетнаяЗапись", "");
	
КонецПроцедуры

// См. ОбменСКонтрагентамиИнтеграцияКлиентСерверСобытия.ПриДобавленииОшибки
Процедура ПриДобавленииОшибки(КонтекстДиагностики, Ошибка) Экспорт
	
	Если Не ЗначениеЗаполнено(Ошибка.УчетнаяЗапись)
		И ЗначениеЗаполнено(КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами.ТекущаяУчетнаяЗапись) Тогда
		Ошибка.УчетнаяЗапись = КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами.ТекущаяУчетнаяЗапись;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак того, что операция выполняется с данной учетной записью.
// 
// Параметры:
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 	УчетнаяЗапись - Строка
Процедура УстановитьТекущуюУчетнуюЗапись(КонтекстДиагностики, УчетнаяЗапись) Экспорт
	
	Если КонтекстДиагностики = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами.ТекущаяУчетнаяЗапись = УчетнаяЗапись;
	
КонецПроцедуры

// Устанавливает признак того, что операция выполняется с данной учетной записью.
// 
// Параметры:
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
Процедура СброситьТекущуюУчетнуюЗапись(КонтекстДиагностики) Экспорт
	
	Если КонтекстДиагностики = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами.ТекущаяУчетнаяЗапись = "";
	
КонецПроцедуры

// Возвращает вид ошибки, при неудачном получении транспортного контейнера.
// 
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиПовторноеПолучениеКонтейнера() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ПовторноеПолучениеТранспортногоКонтейнера";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Не удалось сохранить транспортный контейнер ЭДО'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Обратитесь"">Обратитесь</a> в тех. поддержку'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Обратитесь", 
		ОбработкаНеисправностейБЭДКлиентСервер.ОбработчикОткрытияФормыОбращенияВТехподдержку());
		
	Возврат ВидОшибки;
	
КонецФункции

// Возвращает вид ошибки, при отсутствии сертификатов у учетной записи.
// 
// Параметры:
// 	Операция - Строка - см. УчетныеЗаписиЭДОКлиентСервер.ОперацииПомощникаРегистрацииСертификатов
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиЕстьУчетныеЗаписиБезСертификатов(Операция = "") Экспорт
	
	Если Операция = УчетныеЗаписиЭДОКлиентСервер.ОперацииПомощникаРегистрацииСертификатов().Подписание Тогда
		ОписаниеПроблемы = НСтр("ru = 'Нет доступного сертификата для подписания документов'");
		ЗаголовокПроблемы = НСтр("ru = 'Не удалось подписать документы'");
	Иначе 
		ОписаниеПроблемы = НСтр("ru = 'Нет доступного сертификата для отправки документов'");
		ЗаголовокПроблемы = НСтр("ru = 'Не удалось отправить документы'");
	КонецЕсли;
	
	ОбработчикОткрытияПомощника = "СинхронизацияЭДОКлиент.ДобавитьСертификатУчетнойЗаписи";
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ЕстьУчетныеЗаписиБезСертификатов";
	ВидОшибки.ВыполнятьОбработчикАвтоматически = Истина;
	ВидОшибки.АвтоматическиВыполняемыйОбработчик = ОбработчикОткрытияПомощника;
	ВидОшибки.ЗаголовокПроблемы = ЗаголовокПроблемы;
	ВидОшибки.ОписаниеПроблемы = ОписаниеПроблемы;
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Добавьте"">Добавьте</a> сертификат для учетной записи'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Добавьте", ОбработчикОткрытияПомощника);
		
	Возврат ВидОшибки;
	
КонецФункции

// См. КриптографияБЭДСобытия.ПриОшибкеВыполненияКриптографическойОперации
Процедура ПриОшибкеВыполненияКриптографическойОперации(КонтекстДиагностики, ПодробноеПредставлениеОшибки, КраткоеПредставлениеОшибки) Экспорт
	
	Если КонтекстДиагностики = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущаяУчетнаяЗапись = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		КонтекстДиагностики.ДополнительныеСвойства.ОбменСКонтрагентами, "ТекущаяУчетнаяЗапись", "");
	
	Если Не ЗначениеЗаполнено(ТекущаяУчетнаяЗапись) Тогда
		Возврат;
	КонецЕсли;
	
	Шаблон = НСтр("ru = '%1
		|
		|Учетная запись ЭДО: %2'");
	
	ПодробноеПредставлениеОшибки = СтрШаблон(Шаблон, ПодробноеПредставлениеОшибки, ТекущаяУчетнаяЗапись);
	КраткоеПредставлениеОшибки = СтрШаблон(Шаблон, КраткоеПредставлениеОшибки, ТекущаяУчетнаяЗапись);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти