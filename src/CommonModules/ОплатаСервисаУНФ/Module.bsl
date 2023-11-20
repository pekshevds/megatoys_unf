
#Область ПрограммныйИнтерфейс

// См. ОплатаСервисаПереопределяемый.ПриУстановкеПредставленияВалютыОплаты
//
Процедура ПриУстановкеПредставленияВалютыОплаты(ПредставлениеВалютыОплаты) Экспорт
	
	ПредставлениеВалютыОплаты = НСтр("ru='руб.'");
	
КонецПроцедуры

// См. ОплатаСервисаПереопределяемый.ПриПолученииИмениФормыОбработкиОтвета
//
Процедура ПриПолученииИмениФормыОбработкиОтвета(ИмяФормыОбработкиОтвета) Экспорт
	
	ИмяФормыОбработкиОтвета = "Обработка.ОплатаСервисаУНФ.Форма.ОбработкаОтвета";
	
КонецПроцедуры

// См. ОплатаСервисаПереопределяемый.ПриОпределенииПоддержкиЗагрузкиТарифов
//
Процедура ПриОпределенииПоддержкиЗагрузкиТарифов(Результат) Экспорт
	
	Результат = Истина;
	
КонецПроцедуры

// См. ОплатаСервисаПереопределяемый.ПриЗагрузкеТарифов
//
Процедура ПриЗагрузкеТарифов(ИсходныеДанные) Экспорт
	
	УстановитьНастройкиПоУмолчанию();
	СоздатьНоменклатуруПоДаннымТарифовСервиса(ИсходныеДанные);

КонецПроцедуры

// См. ОплатаСервисаПереопределяемый.ПриСозданииСчетаНаОплату
//
Процедура ПриСозданииСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, РезультатОбработки) Экспорт
	
	СчетНаОплатуСоздан = Ложь;
	Попытка
		СчетНаОплату = СоздатьСчетНаОплатуПоДаннымМенеджераСервиса(ДанныеЗапроса, РезультатОбработки);
		СчетНаОплатуСоздан = Истина;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Если Не СчетНаОплатуСоздан Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = НСтр("ru='Не удалось запросить счет на оплату на стороне обслуживающей организации.'");
	КонецЕсли;
	
КонецПроцедуры

// См. ОплатаСервисаПереопределяемый.ПриПолученииПечатнойФормыСчетаНаОплату
//
Процедура ПриПолученииПечатнойФормыСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, ПечатнаяФорма, РезультатОбработки) экспорт
	
	ПечатнаяФормаПолучена = Ложь;
	Попытка
		ПечатнаяФорма = ПечатнаяФормаСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, РезультатОбработки);
		ПечатнаяФормаПолучена = Истина;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Если Не ПечатнаяФормаПолучена Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = НСтр("ru='Счет у обслуживающей организации заказан успешно, но получить печатную форму автоматически не удалось.
		|
		|Свяжитесь с обслуживающей организацией.'");
	КонецЕсли;
	
КонецПроцедуры

// См. ОплатаСервисаПереопределяемый.ПриПолученииДанныхСчетаНаОплату
//
Процедура ПриПолученииДанныхСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, Данные, РезультатОбработки) Экспорт
	
	ПреобразованныеСчета = Документы.СчетНаОплату.СформироватьСчетаНаОплатуВXML(СчетНаОплату);
	ПреобразованныйСчет = Неопределено;
	
	Для каждого ОписаниеСчета Из ПреобразованныеСчета Цикл
		Если ОписаниеСчета.Ссылка = СчетНаОплату Тогда
			ПреобразованныйСчет = ОписаниеСчета;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПреобразованныйСчет = Неопределено Или ЗначениеЗаполнено(ПреобразованныйСчет.ТекстОшибки) Тогда
		Если ПреобразованныйСчет = Неопределено Тогда
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,, СчетНаОплату, 
				НСтр("ru='Не найдены двоичные данные счета в результате метода Документы.СчетНаОплату.СформироватьСчетаНаОплатуВXML'"));
		Иначе
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,, СчетНаОплату, ПреобразованныйСчет.ТекстОшибки);
		КонецЕсли;
		
		// Внутри метода Документы.СчетНаОплату.СформироватьСчетаНаОплатуВXML
		// могут быть выданы сообщения пользователю о проблемах конвертации объекта в xml.
		СообщенияПользователю = ТекстСообщенийПользователю();
		Если ЗначениеЗаполнено(СообщенияПользователю) Тогда
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,, СчетНаОплату, СообщенияПользователю);
		КонецЕсли;
		
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = НСтр("ru='Счет у обслуживающей организации заказан успешно, но обменяться электронными документами автоматически не получилось.
		|
		|Свяжитесь с обслуживающей организацией.'");
		Возврат;
	КонецЕсли;
	
	Данные = ПолучитьИзВременногоХранилища(ПреобразованныйСчет.АдресВоВременномХранилище);
	
КонецПроцедуры

// Пример реализации метода отправки признака оплаты счета в менеджер сервиса.
// 
// Параметры:
//  СчетНаОплату - ДокументСсылка.СчетНаОплату
//  Оплачен - Булево - признак оплаты счета.
// 
// Возвращаемое значение:
//  HTTPОтвет - ответ менеджера сервиса.
//
Функция ОтправитьПризнакОплатыСчета(СчетНаОплату, Оплачен) Экспорт
	
	Данные = ОплатаСервиса.ШаблонДанныхОтвета();
	Данные.Вставить("paid", Оплачен);
	ИдентификаторСчета = СчетНаОплату.УникальныйИдентификатор();
	Результат = ОплатаСервиса.ОтправитьОтветВУчетнуюСистемуБиллинга(ИдентификаторСчета, Данные);
	
	Если ТипЗнч(Результат) = Тип("HTTPСервисОтвет") Тогда
		КодСостояния = СтрШаблон("%1 %2", Результат.КодСостояния, Результат.Причина);
	Иначе
		КодСостояния = Результат.КодСостояния
	КонецЕсли;
	Комментарий = СтрШаблон(НСтр("ru='ОплатаСервиса.ОтправитьОтветВУчетнуюСистемуБиллинга()
		|Код состояния: %1
		|Тело ответа: %2'"),
		КодСостояния,
		Результат.ПолучитьТелоКакСтроку());
	ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Информация,,, Комментарий);
	
	Возврат Результат;
	
КонецФункции

// Функция - Создать счет на оплату поставщика
//
// Параметры:
//  ДанныеСчетаНаОплатуСсылка - Строка - Ссылка на двоичные данные полученного счета на оплату.
//  РезультатОбработки - Структура:
//   * Ошибка - Булево - признак ошибки
//   * Сообщение - Строка - сообщение об ошибки
// 
// Возвращаемое значение:
//  ДокументСсылка.СчетНаОплатуПоставщика - созданный документ.
//
Функция СоздатьСчетНаОплатуПоставщика(ДанныеСчетаНаОплатуСсылка, РезультатОбработки) Экспорт
	
	СчетНаОплатуПоставщика = Неопределено;
	Попытка
		СчетНаОплатуПоставщика = СоздатьСчетНаОплатуОтОбслуживающейОрганизации(ДанныеСчетаНаОплатуСсылка, РезультатОбработки);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Если СчетНаОплатуПоставщика = Неопределено Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = НСтр("ru='Счет у обслуживающей организации заказан успешно, но создать счет на оплату (полученный) автоматически не получилось.
		|
		|Свяжитесь с обслуживающей организацией.'");
	КонецЕсли;
	
	Возврат СчетНаОплатуПоставщика;
	
КонецФункции

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОбработкаСчетовНаОплатуСервиса.ИмяМетода);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик подписки на событие ФактОплатыЗаказовПриЗаписиСчетаНаОплатуСервиса.
//
Процедура ФактОплатыЗаказовПриЗаписиСчетаНаОплатуСервисаПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическоеВыставлениеСчетовДляОплатыСервиса") Тогда
		Возврат;
	КонецЕсли;
	
	СчетаНаОплату = Новый Массив;
	Для каждого Строка Из Источник Цикл
		СчетаНаОплату.Добавить(Строка.СчетНаОплату);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НеоплаченныеСчетаОплатыСервиса.СчетНаОплату КАК СчетНаОплату
	|ИЗ
	|	РегистрСведений.НеоплаченныеСчетаОплатыСервиса КАК НеоплаченныеСчетаОплатыСервиса
	|ГДЕ
	|	НеоплаченныеСчетаОплатыСервиса.СчетНаОплату В (&СчетаНаОплату)";
	Запрос.УстановитьПараметр("СчетаНаОплату", СчетаНаОплату);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьИспользованиеРегламентногоЗадания(Истина);
	
КонецПроцедуры

// Обработчик регламентного задания ОбработкаСчетовНаОплатуСервиса.
//
Процедура ОбработкаСчетовНаОплатуСервиса() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбработкаСчетовНаОплатуСервиса);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НеоплаченныеСчетаОплатыСервиса.СчетНаОплату КАК СчетНаОплату,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФактОплаты.Сумма, 0) = ЕСТЬNULL(ФактОплаты.СуммаОплаты, 0) + ЕСТЬNULL(ФактОплаты.СуммаАванса, 0)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Оплачен
	|ИЗ
	|	РегистрСведений.НеоплаченныеСчетаОплатыСервиса КАК НеоплаченныеСчетаОплатыСервиса
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФактОплатыЗаказов КАК ФактОплаты
	|		ПО НеоплаченныеСчетаОплатыСервиса.СчетНаОплату = ФактОплаты.СчетНаОплату";
	
	НаборЗаписейНеоплаченныеСчета = РегистрыСведений.НеоплаченныеСчетаОплатыСервиса.СоздатьНаборЗаписей();
	ОплаченныеСчета = Новый Массив;
	
	ИнформацияОбОплатеСчетов = Запрос.Выполнить().Выбрать();
	Пока ИнформацияОбОплатеСчетов.Следующий() Цикл
		Если ИнформацияОбОплатеСчетов.Оплачен = Истина Тогда
			ОплаченныеСчета.Добавить(ИнформацияОбОплатеСчетов.СчетНаОплату);
		Иначе
			НоваяЗапись = НаборЗаписейНеоплаченныеСчета.Добавить();
			НоваяЗапись.СчетНаОплату = ИнформацияОбОплатеСчетов.СчетНаОплату;
		КонецЕсли;
	КонецЦикла;
	
	Если ОплаченныеСчета.Количество() = 0 Тогда
		УстановитьИспользованиеРегламентногоЗадания(Ложь);
		Возврат;
	КонецЕсли;
	
	Для каждого СчетНаОплату Из ОплаченныеСчета Цикл
		ОтправитьПризнакОплатыСчета(СчетНаОплату, Истина);
	КонецЦикла;
	
	НаборЗаписейНеоплаченныеСчета.Записать(Истина);
	
	УстановитьИспользованиеРегламентногоЗадания(Ложь);
	
КонецПроцедуры

Функция ИмяСобытияЖР() Экспорт
	
	Возврат НСтр("ru='Оплата сервиса'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьНастройкиПоУмолчанию()
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ИспользоватьАвтоматическоеВыставлениеСчетовДляОплатыСервиса.Установить(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации";
	Организации = Запрос.Выполнить().Выгрузить();
	
	Если Организации.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеАбоненты = ПрограммныйИнтерфейсСервиса.Абоненты();
	Если ДоступныеАбоненты.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	СвязьОрганизацияАбонент = РегистрыСведений.СвязьАбонентСервисаОрганизация.СоздатьНаборЗаписей();
	НоваяСтрока = СвязьОрганизацияАбонент.Добавить();
	НоваяСтрока.КодАбонента = ДоступныеАбоненты[0].Код;
	НоваяСтрока.Организация = Организации[0].Ссылка;
	СвязьОрганизацияАбонент.Записать(Истина);
	
КонецПроцедуры

Процедура СоздатьНоменклатуруПоДаннымТарифовСервиса(ИсходныеДанные)
	
	ДанныеЗаполнения = Новый ТаблицаЗначений;
	ДанныеЗаполнения.Колонки.Добавить("Артикул", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	ДанныеЗаполнения.Колонки.Добавить("Наименование", ОбщегоНазначения.ОписаниеТипаСтрока(500));
	ДанныеЗаполнения.Колонки.Добавить("Цена", ОбщегоНазначения.ОписаниеТипаСтрока(9));
	
	ДобавитьСтрокиПоТарифам(ДанныеЗаполнения, ИсходныеДанные.ТарифыПровайдера, ПрефиксТарифаПровайдера());
	ДобавитьСтрокиПоТарифам(ДанныеЗаполнения, ИсходныеДанные.ТарифыОбслуживающейОрганизации, ПрефиксТарифаОбслуживающейОрганизации());
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИсходныеДанные.Артикул КАК Артикул,
	|	ИсходныеДанные.Наименование КАК Наименование
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	&ИсходныеДанные КАК ИсходныеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходныеДанные.Артикул КАК Артикул,
	|	ИсходныеДанные.Наименование КАК Наименование,
	|	ЕСТЬNULL(Номенклатура.Ссылка, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
	|	ЕСТЬNULL(Номенклатура.Наименование, """") КАК НаименованиеНоменклатуры
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО (Номенклатура.Артикул = ИсходныеДанные.Артикул)";
	Запрос.УстановитьПараметр("ИсходныеДанные", ДанныеЗаполнения);
	
	ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
	ВидСтавкиНДСПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОрганизацияПоУмолчанию, "ВидСтавкиНДСПоУмолчанию");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Наименование", Выборка.Наименование);
		ДанныеЗаполнения.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Услуга);
		ДанныеЗаполнения.Вставить("ЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.шт);
		ДанныеЗаполнения.Вставить("КатегорияНоменклатуры", Справочники.КатегорииНоменклатуры.БезКатегории);
		ДанныеЗаполнения.Вставить("Артикул", Выборка.Артикул);
		
		Номенклатура = Справочники.Номенклатура.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(Номенклатура, ДанныеЗаполнения);
		Номенклатура.Заполнить(ДанныеЗаполнения);
		Номенклатура.НаименованиеПолное = Номенклатура.Наименование;
		Номенклатура.СчетУчетаЗапасов = ПланыСчетов.Управленческий.СырьеИМатериалы;
		Номенклатура.СчетУчетаЗатрат = ПланыСчетов.Управленческий.НезавершенноеПроизводство;
		Номенклатура.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
		Номенклатура.ВидСтавкиНДС = ВидСтавкиНДСПоУмолчанию;
		Номенклатура.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция РазыменоватьДанныеСчетаНаОплатуПоДаннымМенеджераСервиса(ДанныеЗапроса, РезультатОбработки)
	
	ДанныеСчета = Новый Структура;
	ДанныеСчета.Вставить("Контрагент");
	ДанныеСчета.Вставить("Организация");
	ДанныеСчета.Вставить("Номенклатура", Новый Массив);
	
	ДанныеСчета.Организация = ОрганизацияПоКодуАбонента(ДанныеЗапроса.КодПродавца);
	Если Не ЗначениеЗаполнено(ДанныеСчета.Организация) Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = СтрШаблон(НСтр("ru = 'Не удалось создать счет на оплату на стороне обслуживающей организации.
		|Не найдена настройка организации для кода абонента - %1.
		|
		|Свяжитесь с обслуживающей организацией.'"), ДанныеЗапроса.КодПродавца);
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, РезультатОбработки.Сообщение);
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеСчета.Контрагент = НайтиСоздатьКонтрагента(ДанныеЗапроса.ПубличныйИдентификаторПокупателя, ДанныеЗапроса.НаименованиеПокупателя);
	
	Для Каждого Строка Из ДанныеЗапроса.Тарифы Цикл
		
		Если ЗначениеЗаполнено(Строка.КодТарифаОбслуживающейОрганизации) Тогда
			Префикс = ПрефиксТарифаОбслуживающейОрганизации();
			КодТарифа = Строка.КодТарифаОбслуживающейОрганизации;
		Иначе
			Префикс = ПрефиксТарифаПровайдера();
			КодТарифа = Строка.КодТарифаПровайдера;
		КонецЕсли;
		Артикул = АртикулНоменклатуры(Префикс, КодТарифа, Строка.КодПериодаДействия);
		Номенклатура = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", Артикул);
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
			РезультатОбработки.Ошибка = Истина;
			РезультатОбработки.Сообщение = СтрШаблон(НСтр("ru = 'Не удалось создать счет на оплату на стороне обслуживающей организации.
			|Не найдена подходящая номенклатура для описания тарифа. Артикул %1.
			|
			|Свяжитесь с обслуживающей организацией.'"), Артикул);
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, РезультатОбработки.Сообщение);
			Возврат Неопределено;
		КонецЕсли;
		
		ДанныеНоменклатуры = Новый Структура;
		ДанныеНоменклатуры.Вставить("Номенклатура", Номенклатура);
		ДанныеНоменклатуры.Вставить("Количество", Строка.Количество);
		ДанныеНоменклатуры.Вставить("Сумма", Строка.Сумма);
		
		ДанныеСчета.Номенклатура.Добавить(ДанныеНоменклатуры);
	КонецЦикла;
	
	Возврат ДанныеСчета;
	
КонецФункции

Функция СоздатьСчетНаОплатуПоДаннымМенеджераСервиса(ДанныеЗапроса, РезультатОбработки)
	
	ДанныеСчета = РазыменоватьДанныеСчетаНаОплатуПоДаннымМенеджераСервиса(ДанныеЗапроса, РезультатОбработки);
	Если РезультатОбработки.Ошибка Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СчетНаОплатуСсылка = Документы.СчетНаОплату.ПолучитьСсылку(Новый УникальныйИдентификатор(ДанныеЗапроса.ИдентификаторСчета));
	Если Не ОбщегоНазначения.СсылкаСуществует(СчетНаОплатуСсылка) Тогда
		СчетНаОплату = Документы.СчетНаОплату.СоздатьДокумент();
		СчетНаОплату.УстановитьСсылкуНового(СчетНаОплатуСсылка);
		СчетНаОплату.Дата = ТекущаяДатаСеанса();
		СчетНаОплату.УстановитьНовыйНомер();
		СчетНаОплату.Заполнить(Неопределено);
	Иначе
		СчетНаОплату = СчетНаОплатуСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	СчетНаОплату.Организация = ДанныеСчета.Организация;
	СчетНаОплату.Контрагент = ДанныеСчета.Контрагент;
	СчетНаОплату.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(ДанныеСчета.Контрагент);
	
	СчетНаОплату.Запасы.Очистить();
	Для Каждого СтрокаДанныеНоменклатуры Из ДанныеСчета.Номенклатура Цикл
		ДанныеНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаДанныеНоменклатуры.Номенклатура,
			"ЕдиницаИзмерения,ВидСтавкиНДС");
		
		НоваяСтрока = СчетНаОплату.Запасы.Добавить();
		НоваяСтрока.Номенклатура = СтрокаДанныеНоменклатуры.Номенклатура;
		НоваяСтрока.Количество = СтрокаДанныеНоменклатуры.Количество;
		НоваяСтрока.Сумма = СтрокаДанныеНоменклатуры.Сумма;
		НоваяСтрока.Цена = СтрокаДанныеНоменклатуры.Сумма / СтрокаДанныеНоменклатуры.Количество;
		НоваяСтрока.ЕдиницаИзмерения = ДанныеНоменклатуры.ЕдиницаИзмерения;
		НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(ДанныеНоменклатуры.ВидСтавкиНДС);
		СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(НоваяСтрока.СтавкаНДС);
		Если СчетНаОплату.СуммаВключаетНДС Тогда
			НоваяСтрока.СуммаНДС = НоваяСтрока.Сумма - (НоваяСтрока.Сумма) / ((СтавкаНДС + 100) / 100);
			НоваяСтрока.Всего = НоваяСтрока.Сумма;
		Иначе
			НоваяСтрока.СуммаНДС = НоваяСтрока.Сумма * СтавкаНДС / 100;
			НоваяСтрока.Всего = НоваяСтрока.Сумма + НоваяСтрока.СуммаНДС;
		КонецЕсли;
	КонецЦикла;
	СчетНаОплату.СуммаДокумента = СчетНаОплату.Запасы.Итог("Всего");
	СчетНаОплату.Комментарий = СтрШаблон(НСтр("ru='#Создан автоматически. Выставление счета на оплату сервиса.
	|Код абонента %1'"), ДанныеЗапроса.КодПокупателя);
	
	СчетНаОплатуЗаписан = Ложь;
	Попытка
		СчетНаОплату.Записать(РежимЗаписиДокумента.Проведение);
		СчетНаОплатуЗаписан = Истина;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Если Не СчетНаОплатуЗаписан Тогда
		СчетНаОплату.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	СчетНаОплатуСсылка = СчетНаОплату.Ссылка;
	
	ЗаписьНеоплаченныйСчет = РегистрыСведений.НеоплаченныеСчетаОплатыСервиса.СоздатьМенеджерЗаписи();
	ЗаписьНеоплаченныйСчет.СчетНаОплату = СчетНаОплатуСсылка;
	ЗаписьНеоплаченныйСчет.Записать(Истина);
	
	Возврат СчетНаОплатуСсылка;
	 
КонецФункции

Функция СоздатьСчетНаОплатуОтОбслуживающейОрганизации(ДанныеСчетаНаОплатуСсылка, РезультатОбработки)
	
	ДанныеДокументов = Документы.СчетНаОплату.РазобратьСчетаНаОплатуПокупателюXML(ДанныеСчетаНаОплатуСсылка);
	
	Если ДанныеДокументов.Количество() = 0 Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = СтрШаблон(НСтр("ru='Не удалось создать счет на оплату (полученный) на основании полученных данных электронного документа.
		|
		|%1'"), ТекстСообщенийПользователю());
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	
	ДанныеСчета = ДанныеДокументов[0].ДанныеСчета;
	
	СуммаДокумента = ДанныеСчета.ШапкаДокумента.СуммаДокумента;
	
	Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", ДанныеСчета.ШапкаДокумента.ИННОрганизации);
	Если Не ЗначениеЗаполнено(Организация) Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = СтрШаблон(НСтр("ru='Не удалось создать счет на оплату (полученный) по причине:
		|Не найдена организация по ИНН: %1'"), ДанныеСчета.ШапкаДокумента.ИННОрганизации);
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	
	ДанныеЗаполненияКонтрагента = ДанныеСчета.РеквизитыКонтрагента;
	ДанныеЗаполненияКонтрагента.Вставить("Покупатель", Истина);
	Контрагент = Справочники.Контрагенты.СоздатьКонтрагента(ДанныеЗаполненияКонтрагента);
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = НСтр("ru='Не удалось создать счет на оплату (полученный) по причине:
		|Не удалось найти или создать обслуживающую организацию в справочнике контрагентов по реквизитам.'");
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	ДанныеКонтрагента = ДанныеКонтрагента(Контрагент);
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("Дата", ДанныеСчета.ШапкаДокумента.Дата);
	ДанныеЗаполнения.Вставить("ДатаВходящегоДокумента", ДанныеСчета.ШапкаДокумента.Дата);
	ДанныеЗаполнения.Вставить("НомерВходящегоДокумента", ДанныеСчета.ШапкаДокумента.Номер);
	ДанныеЗаполнения.Вставить("Контрагент", Контрагент);
	ДанныеЗаполнения.Вставить("БанковскийСчет", ДанныеКонтрагента.БанковскийСчетПоУмолчанию);
	Если Не ДанныеКонтрагента.ВестиРасчетыПоДоговорам Тогда
		ДанныеЗаполнения.Вставить("Договор", Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент));
	Иначе
		МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
		СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документы.СчетНаОплатуПоставщика.ПустаяСсылка());
		ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
		ДанныеЗаполнения.Вставить("Договор", ДоговорПоУмолчанию);
	КонецЕсли;
	ДанныеЗаполнения.Вставить("ВалютаДокумента", ДанныеКонтрагента.БанковскийСчетПоУмолчаниюВалютаДенежныхСредств);
	
	ВидСтавкиНДСПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ВидСтавкиНДСПоУмолчанию");
	
	СчетНаОплатуПоставщика = Документы.СчетНаОплатуПоставщика.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(СчетНаОплатуПоставщика, ДанныеЗаполнения);
	СчетНаОплатуПоставщика.Заполнить(ДанныеЗаполнения);
	СчетНаОплатуПоставщика.Комментарий = НСтр("ru='#Создан автоматически. Выставление счета на оплату сервиса.'");
	
	Для каждого Товар Из ДанныеСчета.Товары Цикл
		Если ЗначениеЗаполнено(Товар.СтавкаНДС) Тогда
			ВидСтавкиНДС = Товар.СтавкаНДС.ВидСтавкиНДС;
		Иначе
			ВидСтавкиНДС = ВидСтавкиНДСПоУмолчанию;
		КонецЕсли;
		
		НоваяСтрока = СчетНаОплатуПоставщика.Запасы.Добавить();
		НоваяСтрока.Номенклатура = НайтиСоздатьУслугуПоНаименованию(Товар.Наименование, ВидСтавкиНДС);
		НоваяСтрока.ЕдиницаИзмерения = НоваяСтрока.Номенклатура.ЕдиницаИзмерения;
		НоваяСтрока.Количество = Товар.Количество;
		НоваяСтрока.Цена       = Товар.Цена;
		НоваяСтрока.Сумма      = Товар.Сумма;
		НоваяСтрока.СуммаНДС   = Товар.СуммаНДС;
		НоваяСтрока.СтавкаНДС  = Товар.СтавкаНДС;
		НоваяСтрока.Всего = НоваяСтрока.Сумма + НоваяСтрока.СуммаНДС;
	КонецЦикла;
	
	Если СчетНаОплатуПоставщика.Запасы.Итог("СуммаНДС") > 0 Тогда
		СчетНаОплатуПоставщика.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС;
	Иначе
		СчетНаОплатуПоставщика.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС;
	КонецЕсли;
	
	СчетНаОплатуПоставщикаЗаписан = Ложь;
	ТекстОшибки = "";
	Попытка
		СчетНаОплатуПоставщика.Записать(РежимЗаписиДокумента.Проведение);
		СчетНаОплатуПоставщикаЗаписан = Истина;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Если Не СчетНаОплатуПоставщикаЗаписан Тогда
		Попытка
			СчетНаОплатуПоставщика.Записать(РежимЗаписиДокумента.Запись);
			СчетНаОплатуПоставщикаЗаписан = Истина;
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		КонецПопытки;
	КонецЕсли;
	
	Если Не СчетНаОплатуПоставщикаЗаписан Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = СтрШаблон(НСтр("ru='Не удалось создать счет на оплату поставщика.
		|
		|%1'"), ТекстОшибки);
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	
	Возврат СчетНаОплатуПоставщика.Ссылка;
	
КонецФункции

Функция ПечатнаяФормаСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, РезультатОбработки)
	
	КомандыПечатиЗаказа = УправлениеПечатью.КомандыПечатиФормы("Документ.СчетНаОплату.Форма.ФормаСписка");
	ВыбраннаяКомандаПечати = КомандыПечатиЗаказа.Найти("СчетНаОплату", "Идентификатор");
	ВыбранныеКомандыПечати = Новый Массив;
	Если ВыбраннаяКомандаПечати <> Неопределено Тогда
		ВыбранныеКомандыПечати.Добавить(ВыбраннаяКомандаПечати);
	КонецЕсли;
	
	НастройкиСохранения = УправлениеПечатью.НастройкиСохранения();
	НастройкиСохранения.ФорматыСохранения.Очистить();
	НастройкиСохранения.ФорматыСохранения.Добавить(ТипФайлаТабличногоДокумента.MXL);
	
	РезультатПечати = УправлениеПечатью.НапечататьВФайл(ВыбранныеКомандыПечати, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СчетНаОплату), НастройкиСохранения);
	Если РезультатПечати.Количество() <> 0 Тогда
		ПечатнаяФорма = РезультатПечати[0].ДвоичныеДанные;
	Иначе
		ПечатнаяФорма = Неопределено;
	КонецЕсли;
	
	Если ПечатнаяФорма = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Поток = ПечатнаяФорма.ОткрытьПотокДляЧтения();
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(Поток);
	Поток.Закрыть();
	
	Возврат ТабличныйДокумент;

КонецФункции

Функция ПрефиксТарифаПровайдера()
	
	Возврат "PR-";
	
КонецФункции

Функция ПрефиксТарифаОбслуживающейОрганизации()
	
	Возврат "SC-";
	
КонецФункции

Функция АртикулНоменклатуры(Префикс, КодТарифа, КодПериодаДействия)
	
	Возврат Префикс + СтрСоединить(СтрРазделить(СокрЛП(КодТарифа), " ", Ложь), "-") + "-" + КодПериодаДействия;
	
КонецФункции

Процедура ДобавитьСтрокиПоТарифам(ДанныеЗаполнения, Тарифы, Префикс)
	
	Для Каждого Тариф Из Тарифы Цикл
		Для Каждого Период Из Тариф.ПериодыДействия Цикл
			НоваяСтрока = ДанныеЗаполнения.Добавить();
			НоваяСтрока.Артикул = АртикулНоменклатуры(Префикс, Тариф.Код, Период.Код);
			НоваяСтрока.Наименование = СтрШаблон(НСтр("ru = '%1 на %2'"), Тариф.Наименование, Период.Наименование);
			НоваяСтрока.Цена = Период.Сумма;
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры

Функция ОрганизацияПоКодуАбонента(КодАбонента)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СвязьАбонентСервисаОрганизация.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.СвязьАбонентСервисаОрганизация КАК СвязьАбонентСервисаОрганизация
	|ГДЕ
	|	СвязьАбонентСервисаОрганизация.КодАбонента = &КодАбонента";
	Запрос.УстановитьПараметр("КодАбонента", КодАбонента);
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Организация = Результат.Организация;
	Иначе
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции

Функция НайтиСоздатьКонтрагента(ИНН, Наименование)
	
	Контрагент = Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", ИНН);
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Контрагент;
	КонецЕсли;
	
	КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент();
	КонтрагентОбъект.ИНН = ИНН;
	КонтрагентОбъект.Наименование = Наименование;
	КонтрагентОбъект.Заполнить(Неопределено);
	КонтрагентОбъект.ЗаполнитьПоИНН();
	КонтрагентОбъект.Записать();
	
	Возврат КонтрагентОбъект.Ссылка;
	
КонецФункции

Функция НайтиСоздатьУслугуПоНаименованию(Наименование, ВидСтавкиНДС)
	
	Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию(Наименование, Истина);
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Номенклатура;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Наименование", Наименование);
	ДанныеЗаполнения.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Услуга);
	ДанныеЗаполнения.Вставить("ЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.шт);
	ДанныеЗаполнения.Вставить("КатегорияНоменклатуры", Справочники.КатегорииНоменклатуры.БезКатегории);
	Номенклатура = Справочники.Номенклатура.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(Номенклатура, ДанныеЗаполнения);
	Номенклатура.Заполнить(ДанныеЗаполнения);
	Номенклатура.НаименованиеПолное = Номенклатура.Наименование;
	Номенклатура.СчетУчетаЗапасов = ПланыСчетов.Управленческий.СырьеИМатериалы;
	Номенклатура.СчетУчетаЗатрат = ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Номенклатура.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
	Номенклатура.ВидСтавкиНДС = ВидСтавкиНДС;
	Номенклатура.Записать();
	Возврат Номенклатура.Ссылка;
	
КонецФункции

Процедура УстановитьИспользованиеРегламентногоЗадания(Использование)
	ИмяСобытия = НСтр("ru='ОбновлениеЗадания'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ОбработкаСчетовНаОплатуСервиса);
	
	НадоСоздатьЗадание = Использование И Задание = Неопределено;
	Если НадоСоздатьЗадание Тогда
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания());
		ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 10);
		ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОбработкаСчетовНаОплатуСервиса);
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		Возврат;
	КонецЕсли;
	
	НадоИзменитьЗадание = Задание <> Неопределено И Задание.Использование <> Использование;
	Если Не НадоИзменитьЗадание Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
	
КонецПроцедуры

Функция РасписаниеРегламентногоЗадания()
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ДниНедели   = ДниНедели;
	Расписание.Месяцы      = Месяцы;
	Расписание.ПериодПовтораВТечениеДня = ?(ОбщегоНазначения.РежимОтладки(), 5, 180);
	Расписание.ПериодПовтораДней        = 1; // каждый день
	
	Возврат Расписание;
	
КонецФункции

Функция ДанныеКонтрагента(Контрагент)
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Контрагент),
		НСтр("ru='Не заполнено значение реквизита ""Контрагент""'"), НСтр("ru='метод ""ДанныеКонтрагента""'"));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Ссылка,
	|	Контрагенты.БанковскийСчетПоУмолчанию КАК БанковскийСчетПоУмолчанию,
	|	Контрагенты.БанковскийСчетПоУмолчанию.ВалютаДенежныхСредств КАК БанковскийСчетПоУмолчаниюВалютаДенежныхСредств,
	|	Контрагенты.ВестиРасчетыПоДоговорам КАК ВестиРасчетыПоДоговорам
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Контрагент);
	ДанныеКонтрагента = Запрос.Выполнить().Выбрать();
	ДанныеКонтрагента.Следующий();
	Возврат ДанныеКонтрагента;
	
КонецФункции

Функция ТекстСообщенийПользователю()
	
	МассивСообщений = Новый Массив;
	СообщенияПользователю = ПолучитьСообщенияПользователю();
	Для каждого СообщениеПользователю Из СообщенияПользователю Цикл
		МассивСообщений.Добавить(СообщениеПользователю.Текст);
	КонецЦикла;
	Возврат СтрСоединить(МассивСообщений, Символы.ПС);
	
КонецФункции

#КонецОбласти 
