#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - в зависимости от факта добавления отчета
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КодыМаркировкиДляДекларацииИСМП) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КодыМаркировкиДляДекларацииИСМП.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru='Коды маркировки для декларации ИС МП'");
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "КодыМаркировкиДляДекларацииИСМП");
		КомандаОтчет.КлючВарианта = "Основной";
		КомандаОтчет.ЕстьУсловияВидимости = Ложь;
		
		//ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаОтчет, "ДокументОснование",, ВидСравненияКомпоновкиДанных.Заполнено);
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Структура - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); 
// Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	
	НастройкиВарианта.ВидимостьПоУмолчанию = Истина;
	НастройкиВарианта.Описание = НСтр("ru= 'Формирование кодов маркировки для декларации ИС МП'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей = НСтр("ru= 'Маркировка
		|ИСМП'");
	
КонецПроцедуры

#КонецОбласти

// Возвращает внешний набор данных для построения отчета.
//
// Параметры:
//  СписокДокументов - Массив - массив документов.
//
// Возвращаемое значение:
//  ТаблицаЗначений - внешний набор данных.
//
Функция ДанныеИнформационнойБазы(ДокументСсылка) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Номенклатура",      Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	Результат.Колонки.Добавить("ЗначениеШтрихкода", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	Результат.Колонки.Добавить("Штрихкод",  Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров"));
	Результат.Колонки.Добавить("Ссылка",      Новый ОписаниеТипов("ДокументСсылка.МаркировкаТоваровИСМП"));
	Результат.Колонки.Добавить("КодТНВЭД", ОбщегоНазначения.ОписаниеТипаСтрока(10));
	Результат.Колонки.Добавить("Количество", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	
	Если ТипЗнч(ДокументСсылка) = Тип("СписокЗначений") И ДокументСсылка.Количество() Тогда
		ДанныеШапки           = ШтрихкодированиеИС.ПолучитьСтруктуруРеквизитовДокумента(ДокументСсылка[0].Значение);
	ИначеЕсли ЗначениеЗаполнено(ДокументСсылка) Тогда
		ДанныеШапки           = ШтрихкодированиеИС.ПолучитьСтруктуруРеквизитовДокумента(ДокументСсылка);
	Иначе
		Возврат Результат;
	КонецЕсли;
	
	ПараметрыСканирования = ШтрихкодированиеИС.ПараметрыСканирования(ДанныеШапки);
	ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП = Ложь;
	
	ПараметрыНормализацииПрочее = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
	ПараметрыНормализацииПрочее.НачинаетсяСоСкобки = Ложь;
	
	ПользовательскиеПараметрыРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПользовательскиеПараметрыРазбораКодаМаркировки();
	ПользовательскиеПараметрыРазбораКодаМаркировки.ПроверятьАлфавитЭлементов = Ложь;
	
	НастройкиРазбораКодаМаркировки = Новый Структура;
	НастройкиРазбораКодаМаркировки.Вставить("Кеш",              РазборКодаМаркировкиИССлужебныйКлиентСервер.ИнициализироватьНастройкиИспользующиеРезультатыПредыдущихРазборов());
	НастройкиРазбораКодаМаркировки.Вставить("Общие",            РазборКодаМаркировкиИССлужебный.НастройкиРазбораКодаМаркировки(, Ложь));
	НастройкиРазбораКодаМаркировки.Вставить("Пользовательские", ПользовательскиеПараметрыРазбораКодаМаркировки);
	
	ВидПродукции = ДанныеШапки.ВидПродукции;
	
	Если ДанныеШапки.ОтчетПроизводственнойЛинии Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ДанныеШапки.Ссылка);
		
		Если ДанныеШапки.ВариантЗаполненияДекларации = Перечисления.ВариантыЗаполненияДекларацииИСМП.АТК Тогда
			
			Запрос.Текст = "ВЫБРАТЬ
			|	ВложенныеШтрихкодыАТКИСМП.ДокументОснование КАК ДокументОснование,
			|	МАКСИМУМ(ВложенныеШтрихкодыАТКИСМП.Версия) КАК Версия
			|ПОМЕСТИТЬ ВерсииСообщений
			|ИЗ
			|	РегистрСведений.ВложенныеШтрихкодыАТКИСМП КАК ВложенныеШтрихкодыАТКИСМП
			|ГДЕ
			|	ВложенныеШтрихкодыАТКИСМП.ДокументОснование = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	ВложенныеШтрихкодыАТКИСМП.ДокументОснование
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВложенныеШтрихкодыАТКИСМП.АТК КАК АТК
			|ИЗ
			|	ВерсииСообщений КАК ВерсииСообщений
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВложенныеШтрихкодыАТКИСМП КАК ВложенныеШтрихкодыАТКИСМП
			|		ПО (ВложенныеШтрихкодыАТКИСМП.ДокументОснование = ВерсииСообщений.ДокументОснование)
			|			И (ВложенныеШтрихкодыАТКИСМП.Версия = ВерсииСообщений.Версия)";
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				СтрокаРезультата = Результат.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРезультата, ДанныеШапки);
				// Код АТК получен из сервиса, нормализация не требуется.
				СтрокаРезультата.ЗначениеШтрихкода = Выборка.АТК;
				
			КонецЦикла;
			
		Иначе
			
			Запрос.Текст = "ВЫБРАТЬ
			|	ДанныеОтчета.НормализованноеЗначениеШтрихкода         КАК НормализованноеЗначениеШтрихкода,
			|	ДанныеОтчета.НормализованноеЗначениеШтрихкодаУпаковки КАК НормализованноеЗначениеШтрихкодаУпаковки,
			|	ДанныеОтчета.ЗначениеШтрихкода                        КАК ЗначениеШтрихкода,
			|	ДанныеОтчета.ЗначениеШтрихкодаУпаковки                КАК ЗначениеШтрихкодаУпаковки,
			|	ЛОЖЬ КАК ФорматBase64,
			|	ДанныеОтчета.НомерСтроки  КАК КлючЗаписи
			|ИЗ
			|	Документ.МаркировкаТоваровИСМП.ДанныеОтчетаПроизводственнойЛинии КАК ДанныеОтчета
			|ГДЕ
			|	ДанныеОтчета.Ссылка =  &Ссылка
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеРегистра.НормализованноеЗначениеШтрихкода,
			|	ДанныеРегистра.НормализованноеЗначениеШтрихкодаУпаковки,
			|	ДанныеРегистра.ЗначениеШтрихкода,
			|	ДанныеРегистра.ЗначениеШтрихкодаУпаковки,
			|	Ложь,
			|	ДанныеРегистра.КлючЗаписи
			|ИЗ
			|	РегистрСведений.ДанныеОтчетаПроизводственнойЛинииИСМП КАК ДанныеРегистра
			|ГДЕ
			|	ДанныеРегистра.Документ = &Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	КлючЗаписи";
			
			ДанныеОтчета = Запрос.Выполнить().Выгрузить();
			
			
			ПараметрыРазбора = Новый Структура;
			ПараметрыРазбора.Вставить("ВосстанавливатьСтруктуруКодаМаркировки", Не ПараметрыСканирования.ПроверятьСтруктуруКодовМаркировки);
			ПараметрыРазбора.Вставить("ПроверятьАлфавитКодовМаркировки",        ПараметрыСканирования.ПроверятьАлфавитКодовМаркировки);
			
			КодыМаркировкиНормализованы = Истина;
	
			Для Каждого СтрокаОтчета Из ДанныеОтчета Цикл
				Если ЗначениеЗаполнено(СтрокаОтчета.ЗначениеШтрихкода) Тогда
					КодыМаркировкиНормализованы = Ложь;
				КонецЕсли;
				Прервать;
			КонецЦикла;
			
			ПараметрыРазбора.Вставить("КодыМаркировкиНормализованы", КодыМаркировкиНормализованы);
				
			ДанныеОтчета.Колонки.Добавить("ТекстОшибкиЗначениеШтрихкода", Новый ОписаниеТипов("Строка"));
			ДанныеОтчета.Колонки.Добавить("ТекстОшибкиЗначениеШтрихкодаУпаковки", Новый ОписаниеТипов("Строка"));
			
			РезультатОбработкиДанныхОтчета = РазборКодаМаркировкиИССлужебный.НормализоватьДанныеОтчетаПроизводственнойЛинии(
				ДанныеОтчета, ВидПродукции, ПараметрыРазбора);
			
			ЗаполнитьДанныеДекларацииПоДеревуУпаковок = Ложь;
			Если ДанныеШапки.ВариантЗаполненияДекларации = Перечисления.ВариантыЗаполненияДекларацииИСМП.КодыУпаковок Тогда
				ЗаполнитьДанныеДекларацииПоДеревуУпаковок = Истина;	
				ИсточникДанных   = Новый Массив;
				КешДанныхРазбора = Новый Соответствие;
			КонецЕсли;
			
			Для Каждого СтрокаДанных Из РезультатОбработкиДанныхОтчета.ОбработанныеДанныеОтчета Цикл
				
				ИсходнаяСтрока = СтрокаДанных.ИсходнаяСтрока;
				
				Если ЗаполнитьДанныеДекларацииПоДеревуУпаковок Тогда
					
					ИсточникДанных.Добавить(
						Новый Структура(
							"Штрихкод, ШтрихкодУпаковки",
							ИсходнаяСтрока.НормализованноеЗначениеШтрихкода, ИсходнаяСтрока.НормализованноеЗначениеШтрихкодаУпаковки));
					
				КонецЕсли;
				
				Для Каждого ИменаКолонок Из РезультатОбработкиДанныхОтчета.ГруппыКолонок Цикл
					
					Если Не ЗначениеЗаполнено(ИсходнаяСтрока[ИменаКолонок.КодМаркировки]) Тогда
						Продолжить;
					КонецЕсли;
					
					Если ЗаполнитьДанныеДекларацииПоДеревуУпаковок Тогда
						
						Если КешДанныхРазбора[ИсходнаяСтрока[ИменаКолонок.НормализованныйКодМаркировки]] = Неопределено Тогда
							КешДанныхРазбора.Вставить(
								ИсходнаяСтрока[ИменаКолонок.НормализованныйКодМаркировки],
								Новый Структура("ВидУпаковки, ТипШтрихкода, EAN, GTIN, КоличествоВложенныхЕдиниц, ДанныеРазбора, КодДляПередачиИСМП",
									СтрокаДанных[ИменаКолонок.ВидУпаковки],
									СтрокаДанных[ИменаКолонок.ТипШтрихкода],
									СтрокаДанных[ИменаКолонок.EAN],
									СтрокаДанных[ИменаКолонок.GTIN],
									СтрокаДанных[ИменаКолонок.КоличествоВложенныхЕдиниц],
									СтрокаДанных[ИменаКолонок.ДанныеРазбора],
									СтрокаДанных[ИменаКолонок.КодДляПередачиИСМП]));
						КонецЕсли;
						
					Иначе
						
						Если СтрокаДанных[ИменаКолонок.ВидУпаковки] = Перечисления.ВидыУпаковокИС.Потребительская Тогда
							СтрокаРезультата = Результат.Добавить();
							ЗаполнитьЗначенияСвойств(СтрокаРезультата, ДанныеШапки);
							СтрокаРезультата.ЗначениеШтрихкода = СтрокаДанных[ИменаКолонок.КодДляПередачиИСМП];
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
			Если ЗаполнитьДанныеДекларацииПоДеревуУпаковок Тогда
				
				РезультатОбработки = ИнтеграцияИСМПСлужебный.ДеревоУпаковокПоДаннымОтчетаПроизводственнойЛинии(
					ДанныеШапки, ИсточникДанных, КешДанныхРазбора);
				Если ЗначениеЗаполнено(РезультатОбработки.ТекстОшибки) Тогда
					ВызватьИсключение  РезультатОбработки.ТекстОшибки;
				КонецЕсли;
				
				Для Каждого СтрокаДерева Из РезультатОбработки.ДеревоУпаковок.Строки Цикл
					СтрокаРезультата = Результат.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРезультата, ДанныеШапки);
					СтрокаРезультата.ЗначениеШтрихкода = СтрокаДерева.КодДляПередачиИСМП;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеШапки.ВариантЗаполненияДекларации = Перечисления.ВариантыЗаполненияДекларацииИСМП.АТК Тогда
			ИмяТабличнойЧасти = "ШтрихкодыАТК";
		Иначе
			ИмяТабличнойЧасти = "ШтрихкодыУпаковок";
		КонецЕсли;
		
		СписокЗапросов = Новый СписокЗначений;
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Штрихкоды.Ссылка           КАК Ссылка,
		|	Штрихкоды.ШтрихкодУпаковки КАК Штрихкод
		|ИЗ
		|	Документ.МаркировкаТоваровИСМП.%1 КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Ссылка В (&ДокументИСМП)";
		
		ТекстЗапроса = СтрШаблон(ТекстЗапроса, ИмяТабличнойЧасти);
		
		СписокЗапросов.Добавить(ТекстЗапроса, "ТаблицаУпаковок");
		
		СписокЗапросов.Добавить(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.Ссылка       КАК Ссылка,
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.КодТНВЭД     КАК КодТНВЭД
		|ИЗ
		|	Документ.МаркировкаТоваровИСМП.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка В (&ДокументИСМП)",
		"Товары");
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("ДокументИСМП", ДанныеШапки.Ссылка);
		
		РезультатЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, СписокЗапросов);
		
		//@skip-warning
		ТаблицаУпаковок = РезультатЗапроса["ТаблицаУпаковок"].Выгрузить();
		//@skip-warning
		Товары = РезультатЗапроса["Товары"].Выгрузить();
		Товары.Индексы.Добавить("Номенклатура");
		
		ПараметрыОтбора = Новый Структура("Номенклатура");
		
		Если ДанныеШапки.ВариантЗаполненияДекларации = Перечисления.ВариантыЗаполненияДекларацииИСМП.КодыМаркировки Тогда
			
			РезультатПоиска = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(
				ТаблицаУпаковок.ВыгрузитьКолонку("Штрихкод"),
				ПараметрыСканирования);
			
			Для Каждого СтрокаТаблицы Из РезультатПоиска.МаркированныеТовары Цикл
				
				Если СтрокаТаблицы.ВидУпаковки <> Перечисления.ВидыУпаковокИС.Потребительская Тогда
					Продолжить;
				КонецЕсли;
				
				РезультатРазбора = ШтрихкодированиеИС.НоваяСтруктураОбработкиШтрихкодаУпрощенныйРазбор(
					СтрокаТаблицы.Штрихкод, ВидПродукции, НастройкиРазбораКодаМаркировки);
					
				НормализованныйКодМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.НормализоватьКодМаркировки(
					РезультатРазбора.ДанныеРазбора, ВидПродукции, ПараметрыНормализацииПрочее);
				
				СтрокаРезультата = Результат.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРезультата, СтрокаТаблицы);
				СтрокаРезультата.Ссылка = ДанныеШапки.Ссылка;
				СтрокаРезультата.ЗначениеШтрихкода = НормализованныйКодМаркировки;
				
				ПараметрыОтбора.Номенклатура = СтрокаТаблицы.Номенклатура;
				СтрокиТоваров = Товары.НайтиСтроки(ПараметрыОтбора);
				Если СтрокиТоваров.Количество() > 0 Тогда
					СтрокаРезультата.КодТНВЭД = СтрокиТоваров[0].КодТНВЭД;
				Иначе
					СобытияФормИСПереопределяемый.ПриИзмененииНоменклатуры(Неопределено, СтрокаРезультата);
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			Маркировка = ЭлектронноеВзаимодействиеИСМП.ЧастичноеСодержимое(ТаблицаУпаковок);
			Для Каждого СтрокаУпаковки Из Маркировка Цикл
				
				СтрокаРезультата = Результат.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРезультата, СтрокаУпаковки);
				
				ПараметрыОтбора.Номенклатура = СтрокаУпаковки.Номенклатура;
				СтрокиТоваров = Товары.НайтиСтроки(ПараметрыОтбора);
				Если СтрокиТоваров.Количество() > 0 Тогда
					СтрокаРезультата.КодТНВЭД = СтрокиТоваров[0].КодТНВЭД;
				Иначе
					СобытияФормИСПереопределяемый.ПриИзмененииНоменклатуры(Неопределено, СтрокаРезультата);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
