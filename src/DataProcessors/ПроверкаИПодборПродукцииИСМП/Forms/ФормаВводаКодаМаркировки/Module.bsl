
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Параметры.ТекстОшибкиКонтроляКодовМаркировки) Тогда
		Заголовок = НСтр("ru = 'Контроль кодов маркировок'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольКодовМаркировки;
		
		Элементы.ТекстОшибкиКонтроляКодовМаркировки.Заголовок = Параметры.ТекстОшибкиКонтроляКодовМаркировки;
	Иначе
		Заголовок = НСтр("ru = 'Сканирование кода маркировки'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеКодаМаркировки;
	КонецЕсли;
	
	Номенклатура              = Параметры.Номенклатура;
	Характеристика            = Параметры.Характеристика;
	Серия                     = Параметры.Серия;
	ДанныеШтрихкода           = Параметры.ДанныеШтрихкода;
	ПараметрыСканирования     = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыСканирования, Ложь);
	Документ                  = Параметры.Документ;
	ВидМаркируемойПродукции   = Параметры.ВидПродукции;
	
	ЭтоТестовыйПериод = ИнтеграцияИСМП.ЭтоТестовыйПериод(ВидМаркируемойПродукции);
	СерииИспользуются = ИнтеграцияИС.СерииИспользуются();
	
	// Только в формах проверки и подбора.
	ПоддерживаетсяОбъемноСортовойУчет = ПроверкаИПодборПродукцииИСМПКлиентСервер.ПоддерживаетсяОбъемноСортовойУчет(
		ПараметрыСканирования, ВидМаркируемойПродукции)
		И ПараметрыСканирования.ИспользуетсяСоответствиеШтрихкодовСтрокДерева;
	
	ДобавлятьБезКодаМаркировки = (Не ПараметрыСканирования.ТолькоМаркируемаяПродукция
		И Параметры.РазрешатьДобавлениеБезКодаМарки И ЭтоТестовыйПериод)
		Или ПоддерживаетсяОбъемноСортовойУчет;
	
	УстановитьВидимостьЭлементовДобавитьБезКодаМаркировки(ЭтотОбъект, ДобавлятьБезКодаМаркировки);
	
	// Заполнить выбор для добавления без кода маркировки при непосредственном сканировании в документ.
	// Без использования формы проверки и подбора.
	Элементы.ГруппаЗапомнитьВыбор.Видимость = Не ПараметрыСканирования.ИспользуетсяСоответствиеШтрихкодовСтрокДерева;
	
	Элементы.РаспечататьНовыйКодМаркировки.Видимость = ПараметрыСканирования.ДоступнаПечатьЭтикеток;
	
	Если ТипЗнч(ПараметрыСканирования.ДопустимыйСпособВводаВОборот) = Тип("Массив") Тогда
		ДопустимыйСпособВводаВОборот.ЗагрузитьЗначения(ПараметрыСканирования.ДопустимыйСпособВводаВОборот);
	ИначеЕсли ЗначениеЗаполнено(ПараметрыСканирования.ДопустимыйСпособВводаВОборот) Тогда
		ДопустимыйСпособВводаВОборот.Добавить(ПараметрыСканирования.ДопустимыйСпособВводаВОборот);
	КонецЕсли;
	
	Организация                  = ПараметрыСканирования.Организация;
	МаркировкаОстатков           = ПараметрыСканирования.ЭтоМаркировкаОстатков;
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Документ = ПараметрыСканирования.СсылкаНаОбъект;
	КонецЕсли;
	
	ИнтеграцияИСМПКлиентСервер.УстановитьКартинкуСканированияКодаПоВидуПродукции(Элементы.ДекорацияКартинка, ВидМаркируемойПродукции);
	
	ШтрихкодированиеИСПереопределяемый.ПриОпределенииСочетанияКлавишДобавитьБезМаркировкиВФормеСканирования(
		Команды.ДобавитьБезКодаМаркировки.СочетаниеКлавиш);
	
	НазначитьЗаголовокКомандыДобавитьБезМаркировкиСервер();
	СброситьРазмерыИПоложениеОкна();
	
	Если ЭтоАдресВременногоХранилища(ПараметрыСканирования.КэшМаркируемойПродукции) Тогда
		ДанныеКэша = ПолучитьИзВременногоХранилища(ПараметрыСканирования.КэшМаркируемойПродукции);
		КэшМаркируемойПродукции = ПоместитьВоВременноеХранилище(ДанныеКэша, УникальныйИдентификатор);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
		ЭтотОбъект,
		ЭтотОбъект,
		"Номенклатура", "ХарактеристикиИспользуются");
	
	ОбновитьПредставленияНоменклатуры();
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеКодаМаркировки Тогда
		ЭтотОбъект.ТекущийЭлемент = Элементы.СтраницаСканированиеКодаМаркировки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Документ)
		И ВладелецФормы <> Неопределено
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ВладелецФормы, "Объект")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ВладелецФормы.Объект, "Ссылка") Тогда
		Документ = ВладелецФормы.Объект.Ссылка;
	КонецЕсли;
	
	Если ВладелецФормы <> Неопределено
		И (ВладелецФормы.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор"
			Или ВладелецФормы.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор") Тогда
		
		УстановитьВидимостьЭлементовДобавитьБезКодаМаркировки(ЭтотОбъект, ПоддерживаетсяОбъемноСортовойУчет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольКодовМаркировки Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольКодовМаркировки
		Или Не ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканированияЛокальные = ПараметрыСканирования();
	
	ДанныеПроверки = ШтрихкодированиеИСМПКлиент.ДанныеПроверкиПередОбработкойШтрихкода(
		ВидМаркируемойПродукции, Данные, ПараметрыСканированияЛокальные);
	
	Если ДанныеПроверки.ЕстьОшибки Тогда
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ДанныеПроверки.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
		"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканированияЛокальные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВвестиКодМаркировки(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиент.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьБезКодаМаркировки(Команда)
	
	ОбработатьБезВводаМарки = Истина;
	
	Если Не ПоддерживаетсяОбъемноСортовойУчет Тогда
		Комментарий = Нстр("ru='Отказ ввода кода маркировки по инициативе пользователя'");
		ДобавитьСообщениеДляЖурналаРегистрацииОНевозможностиВводаКодаМарки(Комментарий);
	КонецЕсли;
	
	ДанныеШтрихкодаБезМаркировки = ДанныеШтрихкода;
	Если ПоддерживаетсяОбъемноСортовойУчет Тогда
		
		// Количество будет уточнено пользователем
		ДанныеШтрихкодаБезМаркировки.ВидУпаковки  = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.ОбъемноСортовойУчет");
		ДанныеШтрихкодаБезМаркировки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128");
		ДанныеШтрихкодаБезМаркировки.ТипУпаковки  = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.ПустаяСсылка");
		
		ДанныеШтрихкодаБезМаркировки.КоличествоПотребительскихУпаковок         = 0;
		ДанныеШтрихкодаБезМаркировки.Количество                                = 0;
		ДанныеШтрихкодаБезМаркировки.Коэффициент                               = 0;
		ДанныеШтрихкодаБезМаркировки.ПлановоеКоличествоПотребительскихУпаковок = 0;
		
	Иначе
		
		ДанныеШтрихкодаБезМаркировки.КоличествоПотребительскихУпаковок = 1;
		ДанныеШтрихкодаБезМаркировки.ТипУпаковки                       = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар");
		
	КонецЕсли;
	
	ДанныеШтрихкодаБезМаркировки.ОбработатьБезМаркировки = Истина;
	
	ДанныеШтрихкода.ОбработатьБезМаркировки = Истина;
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
		"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОбработатьБезВводаМарки = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьНовыйКодМаркировки(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьНовыйКодМаркировкиИВывестиНаПечать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыСканирования()
	
	Если ПараметрыСканирования = Неопределено Тогда
		ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(ВладелецФормы);
		Если ДопустимыйСпособВводаВОборот.Количество() = 1 Тогда
			ПараметрыСканирования.ДопустимыйСпособВводаВОборот = ДопустимыйСпособВводаВОборот.Получить(0).Значение;
		Иначе
			ПараметрыСканирования.ДопустимыйСпособВводаВОборот = ДопустимыйСпособВводаВОборот.ВыгрузитьЗначения();
		КонецЕсли;
	КонецЕсли;
	
	// Не сохранения исходных параметров сканирования, которые используются
	// при нажатии на команду Добавить без кода маркировки.
	ПараметрыСканированияЛокальные = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыСканирования, Ложь);
	
	ПараметрыСканированияЛокальные.РазрешеноЗапрашиватьКодМаркировки = Ложь;
	ПараметрыСканированияЛокальные.КэшМаркируемойПродукции           = КэшМаркируемойПродукции;
	ПараметрыСканированияЛокальные.ВыводитьСообщенияОбОшибках        = Ложь;
	ПараметрыСканированияЛокальные.ИспользуетсяСоответствиеШтрихкодовСтрокДерева = Ложь;
	ПараметрыСканированияЛокальные.ВозможнаЗагрузкаТСД               = Ложь;
	
	ДопустимыеВидыПродукции = Новый Массив;
	ДопустимыеВидыПродукции.Добавить(ВидМаркируемойПродукции);
	ПараметрыСканированияЛокальные.ДопустимыеВидыПродукции = ДопустимыеВидыПродукции;
	ДанныеУточнения = Новый Структура;
	Если ПараметрыСканированияЛокальные.ДополнительныеПараметры.Свойство("ДанныеУточнения") Тогда
		ДанныеУточнения = ПараметрыСканированияЛокальные.ДополнительныеПараметры.ДанныеУточнения;
	КонецЕсли;
	ДанныеУточнения.Вставить("Номенклатура", Номенклатура);
	ДанныеУточнения.Вставить("Характеристика", Характеристика);
	Если ЗначениеЗаполнено(Серия) Тогда 
		ДанныеУточнения.Вставить("Серия", Серия);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеШтрихкода.Количество) Тогда 
		ДанныеУточнения.Вставить("Количество", ДанныеШтрихкода.Количество);
	КонецЕсли;
	ПараметрыСканированияЛокальные.ДополнительныеПараметры.Вставить("ДанныеУточнения", ДанныеУточнения);
	
	Возврат ПараметрыСканированияЛокальные;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидПродукцииИС(Форма)
	
	Возврат Форма.ВидМаркируемойПродукции;
	
КонецФункции

#Область Печать

&НаКлиенте
Процедура РаспечататьНовыйКодЗавершение(ДанныеОтветаРезервированияИПечати, ДополнительныеПараметры) Экспорт
	
	Если ДанныеОтветаРезервированияИПечати = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОтветаРезервированияИПечати.РезультатРезервирования.Количество() Тогда
		СтрокаРезультата = ДанныеОтветаРезервированияИПечати.РезультатРезервирования.Получить(0);
		СтруктураДополнительныхПараметров = Новый Структура();
		СтруктураДополнительныхПараметров.Вставить("ОтключитьЗапросДанныхСервиса",  Истина);
		СтруктураДополнительныхПараметров.Вставить("СохраняемыеНастройки", ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки);
		СтруктураДополнительныхПараметров.Вставить("ЭтоПечатьКодаМаркировкиИзПула", Истина);
		
		ДанныеШтрихкода = Новый Структура(
			"Штрихкод, Количество",
			ШтрихкодированиеИСКлиентСервер.Base64ВШтрихкод(СтрокаРезультата.ПолныйКодМаркировки), 1);
		РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, СтруктураДополнительныхПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(РезультатВыбораДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбораДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ЕстьОшибкиИлиНесоответствиеНоменклатуре(РезультатВыбораДанныеШтрихкода);
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ТекстСообщения);
		
	ИначеЕсли РезультатВыбораДанныеШтрихкода.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская")
		Или РезультатВыбораДанныеШтрихкода.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая")
		Или РезультатВыбораДанныеШтрихкода.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Набор")
		Или ОбработатьБезВводаМарки Тогда
		
		ОбработатьШтрихкодКодаМаркировки(РезультатВыбораДанныеШтрихкода, ДополнительныеПараметры);
		
	Иначе
		
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(
			НСтр("ru = 'Недопустимый формат штрихкода'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОшибкиИлиНесоответствиеНоменклатуре(РезультатВыбораДанныеШтрихкода)
	
	ТекстСообщения = "";
	Если ЗначениеЗаполнено(РезультатВыбораДанныеШтрихкода.ТекстОшибки) Тогда
		ТекстСообщения = РезультатВыбораДанныеШтрихкода.ТекстОшибки;
	ИначеЕсли ЗначениеЗаполнено(РезультатВыбораДанныеШтрихкода.Номенклатура)
		И ЗначениеЗаполнено(Номенклатура)
		И (РезультатВыбораДанныеШтрихкода.Номенклатура <> Номенклатура Или РезультатВыбораДанныеШтрихкода.Характеристика <> Характеристика)
		И Не (ПараметрыСканирования.ТребуетсяЧастичноеВыбытие
			  И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкода, "ЧастичноеВыбытиеВариантУчета")
			  И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(РезультатВыбораДанныеШтрихкода, "ЧастичноеВыбытиеВариантУчета")
			  И РезультатВыбораДанныеШтрихкода.ЧастичноеВыбытиеВариантУчета = ПредопределенноеЗначение("Перечисление.ВариантыУчетаЧастичногоВыбытияИСМП.НастроеннаяНоменклатура")
			  И ЭтоНастроенноеВыбытие(Номенклатура, Характеристика, РезультатВыбораДанныеШтрихкода.Номенклатура, РезультатВыбораДанныеШтрихкода.Характеристика)) Тогда
		
		Если ЗначениеЗаполнено(РезультатВыбораДанныеШтрихкода.Характеристика) Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Код маркировки не соответствует номенклатуре %1 (%2)'"),
				Номенклатура, Характеристика);
		Иначе
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Код маркировки не соответствует номенклатуре %1'"), Номенклатура);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		Возврат ТекстСообщения;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкодКодаМаркировки(РезультатВыбораДанныеШтрихкода, ДополнительныеПараметры)
	
	Если ЗапомнитьВыбор И ДанныеШтрихкода.ОбработатьБезМаркировки Тогда
		
		ДанныеВыбора = ШтрихкодированиеИСКлиент.ИнициализацияСтруктурыДанныхСохраненногоВыбора().ДанныеВыбора;
		ЗаполнитьЗначенияСвойств(ДанныеВыбора, ДанныеШтрихкода);
		РезультатВыбораДанныеШтрихкода.ДополнительныеПараметры = Новый Структура("ДанныеВыбора,ЗапомнитьВыбор", ДанныеВыбора, Истина);
		
	КонецЕсли;
	
	Если ПараметрыСканирования.ДополнительныеПараметры.Свойство("ДанныеУточнения") Тогда
		Если ПараметрыСканирования.ДополнительныеПараметры.ДанныеУточнения.Свойство("ШаблонЭтикетки") Тогда
			РезультатВыбораДанныеШтрихкода.ТребуетсяВыборСерии = Ложь;
		КонецЕсли;
		Если ПараметрыСканирования.ДополнительныеПараметры.Свойство("ЗапомнитьВыбор") Тогда
			РезультатВыбораДанныеШтрихкода.ДополнительныеПараметры = Новый Структура("ДанныеВыбора,ЗапомнитьВыбор",
				ПараметрыСканирования.ДополнительныеПараметры.ДанныеУточнения,
				ПараметрыСканирования.ДополнительныеПараметры.ЗапомнитьВыбор);
		КонецЕсли;
	КонецЕсли;
	
	АдресРезультатаОбработкиШтрихкода = ПоместитьВоВременноеХранилище(РезультатВыбораДанныеШтрихкода, УникальныйИдентификатор);
	
	Если Строка(ЭтотОбъект.ДанныеШтрихкода.ТипШтрихкода) = "EAN13" Тогда
		ДанныеШтрихкода.Вставить("УНФ_ДанныеИсходногоШтрихкодаEAN", ЭтотОбъект.ДанныеШтрихкода);
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеКодаМаркировки Тогда
		
		ПодключитьОбработчикОжидания("ЗакрытьФормуПриСканировании", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоНастроенноеВыбытие(Номенклатура, Характеристика, НоменклатураВыбытия, ХарактеристикаВыбытия)
	
	Возврат РегистрыСведений.НастройкиЧастичногоВыбытияТоваровИСМП.ЭтоНастроенноеВыбытие(
		Номенклатура, Характеристика, НоменклатураВыбытия, ХарактеристикаВыбытия);
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуПриСканировании()
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультатаОбработкиШтрихкода);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(РезультатВыбораДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканированияЛокальные = ПараметрыСканирования();
	
	// После уточнения коэффициентов
	Если Не РезультатВыбораДанныеШтрихкода.Свойство("Номенклатура")
		И ДанныеШтрихкода.Свойство("ОбработатьБезМаркировки")
		И ДанныеШтрихкода.ОбработатьБезМаркировки Тогда
		ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
			"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканированияЛокальные);
		Возврат;
	КонецЕсли;
	
	Штрихкод = "";
	Если РезультатВыбораДанныеШтрихкода.Свойство("ФорматBase64")
		И РезультатВыбораДанныеШтрихкода.ФорматBase64 Тогда
		Штрихкод = ШтрихкодированиеИСКлиентСервер.Base64ВШтрихкод(РезультатВыбораДанныеШтрихкода.Штрихкод);
	Иначе
		Штрихкод = РезультатВыбораДанныеШтрихкода.Штрихкод;
	КонецЕсли;
	
	ДанныеПроверки = ШтрихкодированиеИСМПКлиент.ДанныеПроверкиПередОбработкойШтрихкода(
		ВидМаркируемойПродукции, Штрихкод, ПараметрыСканированияЛокальные, ДополнительныеПараметры);
	
	Если ДанныеПроверки.ЕстьОшибки Тогда
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ДанныеПроверки.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода.Свойство("ДанныеRFID")
		И ДанныеШтрихкода.ДанныеRFID <> Неопределено Тогда
		ПараметрыСканированияЛокальные.ДополнительныеПараметры.Вставить("ДанныеRFID", ДанныеШтрихкода.ДанныеRFID);
	КонецЕсли;
	
	ПараметрыСканирования.ДополнительныеПараметры = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыСканированияЛокальные.ДополнительныеПараметры);
	
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
		"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, РезультатВыбораДанныеШтрихкода, ПараметрыСканированияЛокальные);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбновитьПредставленияНоменклатуры()
	
	ПараметрыПредставленияНоменклатуры = ИнтеграцияИСКлиентСервер.ПараметрыПредставленияНоменклатуры();
	ПараметрыПредставленияНоменклатуры.Номенклатура               = Номенклатура;
	ПараметрыПредставленияНоменклатуры.Характеристика             = Характеристика;
	ПараметрыПредставленияНоменклатуры.ХарактеристикиИспользуются = ХарактеристикиИспользуются;
	ПараметрыПредставленияНоменклатуры.Серия                      = Серия;
	ПараметрыПредставленияНоменклатуры.СерииИспользуются          = СерииИспользуются И ЗначениеЗаполнено(Серия);
	ПараметрыПредставленияНоменклатуры.ТолькоПросмотр             = Истина;
	
	Представление = ИнтеграцияИСКлиентСервер.ПредставлениеНоменклатурыФорматированнойСтрокой(ПараметрыПредставленияНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ТекстСообщения)
	
	ИмяЭлемента = "ИнформацияВводаКодаМаркировки";
	
	ДобавитьЭлементДекорацияНаФорму();
	Элементы[ИмяЭлемента].Заголовок = ТекстСообщения;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементДекорацияНаФорму()
	
	ИмяЭлемента = "ИнформацияВводаКодаМаркировки";
	
	Если Элементы.Найти(ИмяЭлемента) = Неопределено Тогда
		Элементы.Добавить(ИмяЭлемента, Тип("ДекорацияФормы"), Элементы.ГруппаИнформация);
		Элементы[ИмяЭлемента].ЦветТекста = ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НазначитьЗаголовокКомандыДобавитьБезМаркировкиСервер()
	
	Клавиши = ЭтотОбъект.Команды.ДобавитьБезКодаМаркировки.СочетаниеКлавиш;
	ПредставлениеСочетанияКлавиш = "(";
	Если Клавиши.Ctrl Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Ctrl+";
	КонецЕсли;
	
	Если Клавиши.Alt Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Alt+";
	КонецЕсли;
	
	Если Клавиши.Shift Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Shift+";
	КонецЕсли;
	
	ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + Клавиши.Клавиша + ")";
	
	Элементы.ДобавитьБезКодаМаркировки.Заголовок = Элементы.ДобавитьБезКодаМаркировки.Заголовок + " " + ПредставлениеСочетанияКлавиш;
	
	Если ПоддерживаетсяОбъемноСортовойУчет Тогда
		
		ДанныеТекстаПодсказки = Новый Массив();
		Если ИнтеграцияИСМП.ЭтоТестовыйПериод(ВидМаркируемойПродукции) Тогда
			ДанныеТекстаПодсказки.Добавить(НСтр("ru='Если код маркировки не читается или отсутствует или требуется объемно-сортовой учет - используйте команду'"));
		Иначе
			ДанныеТекстаПодсказки.Добавить(НСтр("ru='При объемно-сортовом учете - используйте команду'"));
		КонецЕсли;
		ДанныеТекстаПодсказки.Добавить(" ");
		ДанныеТекстаПодсказки.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru='Добавить без кода маркировки'"),
				Новый Шрифт(Элементы.ДекорацияПодсказкаДобавитьБезКодаМаркировки.Шрифт,,, Истина)));
		ДанныеТекстаПодсказки.Добавить(".");
		Элементы.ДекорацияПодсказкаДобавитьБезКодаМаркировки.Заголовок = Новый ФорматированнаяСтрока(ДанныеТекстаПодсказки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСообщениеДляЖурналаРегистрацииОНевозможностиВводаКодаМарки(Комментарий, КодМаркировки="")
	
	СтруктураСообщения = Новый Структура;
	
	СтруктураСообщения.Вставить("ИмяСобытия",     НСтр("ru='Отказ от сканирования кода маркировки'"));
	СтруктураСообщения.Вставить("Уровень",        "Информация");
	СтруктураСообщения.Вставить("Комментарий",    Комментарий);
	СтруктураСообщения.Вставить("Данные",         Неопределено);
	СтруктураСообщения.Вставить("СсылкаНаОбъект", Неопределено);
	СтруктураСообщения.Вставить("КодМаркировки",  КодМаркировки);
	
	ШтрихкодированиеИСКлиентПереопределяемый.ПриОпределенииИнформацииОбОтказеВводаКодаМаркиДляЖурналаРегистрации(
		ВладелецФормы, СтруктураСообщения);
	
	ДобавитьСообщениеДляЖурналаРегистрации(СтруктураСообщения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСообщениеДляЖурналаРегистрации(СтруктураСообщения)
	
	Если СтруктураСообщения.СсылкаНаОбъект <> Неопределено Тогда
		МетаданныеОбъекта = СтруктураСообщения.СсылкаНаОбъект.Метаданные();
	КонецЕсли;
	
	УровеньЖурнала = Неопределено;
	Если СтруктураСообщения.Уровень = "Информация" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
	ИначеЕсли СтруктураСообщения.Уровень = "Ошибка" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
	ИначеЕсли СтруктураСообщения.Уровень = "Предупреждение" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение;
	ИначеЕсли СтруктураСообщения.Уровень = "Примечание" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Примечание;
	КонецЕсли;
	
	ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(
		СтруктураСообщения.ИмяСобытия, УровеньЖурнала, МетаданныеОбъекта, СтруктураСообщения.Данные, СтруктураСообщения.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ФормаВводаКодаМаркировки", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйКодМаркировкиИВывестиНаПечать()
	
	Если ВладелецФормы.СохраненВыборПоМаркируемойПродукции Тогда
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
			Номенклатура = ВладелецФормы.ДанныеВыбораПоМаркируемойПродукции.Номенклатура;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Характеристика) Тогда
			Характеристика = ВладелецФормы.ДанныеВыбораПоМаркируемойПродукции.Характеристика;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Серия) Тогда
			Серия = ВладелецФормы.ДанныеВыбораПоМаркируемойПродукции.Серия;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПечатиЭтикетки                    = ПечатьЭтикетокИСМПКлиентСервер.СтруктураПечатиЭтикетки();
	СтруктураПечатиЭтикетки.Организация        = Организация;
	СтруктураПечатиЭтикетки.ВидПродукции       = ВидПродукцииИС(ЭтотОбъект);
	СтруктураПечатиЭтикетки.Номенклатура       = Номенклатура;
	СтруктураПечатиЭтикетки.Характеристика     = Характеристика;
	СтруктураПечатиЭтикетки.Серия              = Серия;
	Если ДопустимыйСпособВводаВОборот.Количество() > 0 Тогда
		СтруктураПечатиЭтикетки.СпособВводаВОборот = ДопустимыйСпособВводаВОборот.Получить(0).Значение;
	КонецЕсли;
	СтруктураПечатиЭтикетки.GTIN               = ШтрихкодированиеИСКлиентСервер.GTINПоШтрихкодуEAN(ДанныеШтрихкода.Штрихкод);
	СтруктураПечатиЭтикетки.МаркировкаОстатков = МаркировкаОстатков;
	
	ОписаниеОповещенияРаспечататьНовыйКодЗавершение = Новый ОписаниеОповещения(
		"РаспечататьНовыйКодЗавершение", ЭтотОбъект);
	
	СтруктураПараметров = ПечатьЭтикетокИСМПКлиент.СтруктураПараметровПечатиНовогоКодаМаркировки(
		СтруктураПечатиЭтикетки, ЭтотОбъект, ОписаниеОповещенияРаспечататьНовыйКодЗавершение);
	
	Если ВладелецФормы.СохраненВыборПоМаркируемойПродукции Тогда
		ДанныеВыбора = ВладелецФормы.ДанныеВыбораПоМаркируемойПродукции;
		СтруктураПараметров.Шаблон = ДанныеВыбора.ШаблонМаркировки;
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, ДанныеВыбора);
	КонецЕсли;
	
	СтруктураПараметров.ПараметрыСканирования = ПараметрыСканирования;
	СтруктураПараметров.Организация           = Организация;
	СтруктураПараметров.ВидПродукции          = ВидПродукцииИС(ЭтотОбъект);
	СтруктураПараметров.Документ              = Документ;
	СтруктураПараметров.Номенклатура          = Номенклатура;
	СтруктураПараметров.Характеристика        = Характеристика;
	СтруктураПараметров.Серия                 = Серия;
	СтруктураПараметров.GTIN                  = СтруктураПечатиЭтикетки.GTIN;
	Если ДанныеШтрихкода.ТребуетВзвешивания Тогда
		СтруктураПараметров.Количество = ДанныеШтрихкода.Количество;
	КонецЕсли;
	ПечатьЭтикетокИСМПКлиент.РаспечататьНовыйКодМаркировки(Истина, СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьФормуУточненияДанных() Экспорт
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект);
	ШтрихкодированиеИСКлиент.Подключаемый_ОткрытьФормуУточненияДанных(ЭтотОбъект, ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементовДобавитьБезКодаМаркировки(Форма, ЗначениеДоступности)
	Форма.Элементы.ДобавитьБезКодаМаркировки.Видимость                   = ЗначениеДоступности;
	Форма.Элементы.ДекорацияПодсказкаДобавитьБезКодаМаркировки.Видимость = ЗначениеДоступности;
	Форма.Элементы.ЗапомнитьВыбор.Видимость                              = ЗначениеДоступности;
КонецПроцедуры

#КонецОбласти
