
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ПредставлениеПериода = ПолучитьПредставлениеПериода(Объект.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			Прочитать();
		Иначе
			ОбновитьСтатусЕГАИС();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Прочитать();
		
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЭлементСписка = Элементы.ВидДокумента.СписокВыбора.НайтиПоЗначению(Объект.ВидДокумента);
	Если ЭлементСписка <> Неопределено Тогда
		ВидДокументаПредставление = ЭлементСписка.Представление;
	КонецЕсли;
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДоступностьЭлементовФормы();
	
	ОбновитьСтатусЕГАИС();
	
	РазблокироватьДанныеФормыДляРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтчетЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АрхивироватьДокумент(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Объект.Ссылка, ИнтеграцияЕГАИСКлиент);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьНаличиеОтклонений(Команда)
	
	ПересчитатьНаличиеОтклоненийНаСервере(Объект.ВидДокумента, Объект.Ссылка);
	
	ОповеститьОбИзмененииСтатуса();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ОтчетЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ОтчетЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ОтчетЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ ""Отчет ЕГАИС"" не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ ""Отчет ЕГАИС"" был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	УстановитьВидимостьПараметровЗапроса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияМеждуРегистрамиПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияМеждуРегистрамиПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияМеждуРегистрамиПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработанныеЧекиПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработанныеЧекиПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработанныеЧекиПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КодФСРАРПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КодФСРАР) Тогда
		Элемент.ВыбиратьТип = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодФСРАРОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами, НСтр("ru='Движения между регистрами'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2,      НСтр("ru='Движения по справке 2'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации, НСтр("ru='Информация об организации ЕГАИС'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН,       НСтр("ru='Необработанные ТТН'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки,        НСтр("ru='Обработанные чеки'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1,       НСтр("ru='Остатки в регистре №1'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2,       НСтр("ru='Остатки в регистре №2'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3,       НСтр("ru='Остатки в регистре №3'"));
	УстановитьУсловноеОформлениеВидаДокумента(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2,         НСтр("ru='История справок 2'"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеВидаДокумента(ВидДокумента, Представление)
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = ВидДокумента;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Представление);
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3 Тогда
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиАкцизныхМарокСправка2.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиАкцизныхМарокАлкогольнаяПродукция.ПутьКДанным);
		ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Заполнено;
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиАкцизныхМарокСправка2.ПутьКДанным);
		ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
		Элемент.Оформление.УстановитьЗначениеПараметра("Доступность",           Ложь);
		
		//
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиАкцизныхМарокАлкогольнаяПродукция.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиАкцизныхМарокАлкогольнаяПродукция.ПутьКДанным);
		ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиАкцизныхМарокСправка2.ПутьКДанным);
		ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Заполнено;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
		Элемент.Оформление.УстановитьЗначениеПараметра("Доступность",           Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьСтатусЕГАИС();
	
	ЗаполнитьСписокВидовОтчета();
	
	ДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусЕГАИС()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	СтатусЕГАИС        = МенеджерОбъекта.СтатусПоУмолчанию();
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовЕГАИС КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияЕГАИС.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусЕГАИС = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтчет);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеПередачуДанных);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтработайтеРасхождения);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтклонитеОтработкуРасхождений);
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(
		СтатусЕГАИС,
		ДальнейшееДействие,
		ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусЕГАИС <> Перечисления.СтатусыОбработкиОтчетаЕГАИС.Черновик
	                              И СтатусЕГАИС <> Перечисления.СтатусыОбработкиОтчетаЕГАИС.ОшибкаПередачи;
	
	Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	
	Элементы.ВидДокумента.Видимость              = НЕ РедактированиеФормыНеДоступно;
	Элементы.ВидДокументаПредставление.Видимость = РедактированиеФормыНеДоступно;
	
	Элементы.ФормаПересчитатьНаличиеОтклонений.Видимость = ОбщегоНазначения.РежимОтладки()
		И СтатусЕГАИС = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиОтчетаЕГАИС.ПолученОтчет");
	
	Элементы.ФормаАрхивироватьДокумент.Видимость = ЗначениеЗаполнено(Объект.Ссылка)
		И МенеджерОбъекта.КонечныеСтатусы(Ложь).Найти(СтатусЕГАИС) = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьОтчет" Тогда
		
		ИнтеграцияЕГАИСКлиент.ПодготовитьКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтчет"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Документ", Объект.Ссылка);
		ОткрытьФорму("Справочник.ЕГАИСПрисоединенныеФайлы.Форма.ФормаОшибки", ПараметрыОткрытияФормы, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтработайтеРасхождения" Тогда
		
		ОтработатьРасхождения();
		ОповеститьОбИзмененииСтатуса();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтклонитеОтработкуРасхождений" Тогда
		
		ОтработатьРасхождения(Истина);
		ОповеститьОбИзмененииСтатуса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВидовОтчета()
	
	ВидДокументаСписокВыбора = Элементы.ВидДокумента.СписокВыбора;
	ВидДокументаСписокВыбора.Очистить();
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ДвиженияМеждуРегистрамиЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами, НСтр("ru = 'Движения между регистрами'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ДвиженияПоСправке2ЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2, НСтр("ru = 'Движения по справке 2'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ИнформацияОбОрганизацииЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации, НСтр("ru = 'Информация об организации ЕГАИС'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ИсторияСправок2ЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2, НСтр("ru = 'История справок 2'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.НеобработанныеТТНЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН, НСтр("ru = 'Необработанные ТТН'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ОбработанныеЧекиЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки, НСтр("ru = 'Обработанные чеки'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ОстаткиАлкогольнойПродукцииЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1, НСтр("ru = 'Остатки в регистре №1'"));
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2, НСтр("ru = 'Остатки в регистре №2'"));
	КонецЕсли;
	
	Если ПравоДоступа("Использование", Метаданные.Отчеты.ОстаткиАкцизныхМарокЕГАИС) Тогда
		ВидДокументаСписокВыбора.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3, НСтр("ru = 'Остатки в регистре №3'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьЭлементовФормы()
	
	УстановитьВидимостьПараметровЗапроса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПараметровЗапроса(Форма)
	
	Форма.Элементы.ГруппаДвиженияМеждуРегистрами.Видимость      = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами");
	Форма.Элементы.ГруппаДвиженияПоСправке2.Видимость           = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2");
	Форма.Элементы.ГруппаИнформацияОбОрганизацииЕГАИС.Видимость = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации");
	Форма.Элементы.ГруппаНеобработанныеТТН.Видимость            = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН");
	Форма.Элементы.ГруппаОбработанныеЧеки.Видимость             = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки");
	Форма.Элементы.ГруппаОстаткиАлкогольнойПродукции.Видимость  = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1")
	                                                          ИЛИ Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2");
	Форма.Элементы.ГруппаОстаткиАкцизныхМарок.Видимость         = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3");
	Форма.Элементы.ГруппаИсторияСправок2.Видимость              = Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеПериодаНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормыВыбораПериода = Новый Структура("Значение", Объект.Период);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериодаИС",
		ПараметрыФормыВыбораПериода,
		ЭтотОбъект,
		ЭтотОбъект.УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйПериод <> Неопределено Тогда
		
		ВыбранныйПериод = НачалоМесяца(ВыбранныйПериод);
		Если ВыбранныйПериод = Объект.Период Тогда
			Возврат;
		КонецЕсли;
		Модифицированность = Истина;
		Объект.Период = ВыбранныйПериод;
		ПредставлениеПериода = ПолучитьПредставлениеПериода(ВыбранныйПериод);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Модифицированность = Истина;
	
	Если Направление = 1 Тогда
		Объект.Период = КонецМесяца(Объект.Период) + 1;
	ИначеЕсли Направление = -1 Тогда
		Объект.Период = НачалоМесяца(Объект.Период - 1);
	КонецЕсли;
	
	ПредставлениеПериода = ПолучитьПредставлениеПериода(Объект.Период);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеПериода(Период)
	
	Возврат Формат(Период, "ДФ='ММММ гггг'");
	
КонецФункции

&НаСервере
Процедура ОтработатьРасхождения(ОтклонитьИзменения = Ложь)
	
	ПараметрыОбновленияСтатуса = ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса();
	ПараметрыОбновленияСтатуса.ОбновлятьДвижения = Ложь;
	
	Если Объект.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3 И НЕ ОтклонитьИзменения Тогда
		Документы.ОтчетЕГАИС.ОтработатьРасхожденияЗапросОтчетаОстаткиВРегистре3(Объект.Ссылка);
	КонецЕсли;
	
	Документы.ОтчетЕГАИС.ОбновитьСтатусПослеПолученияДанных(
		Объект.Ссылка, ОперацияПоВидуДокумента(Объект.ВидДокумента),
		ПараметрыОбновленияСтатуса);
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПересчитатьНаличиеОтклоненийНаСервере(ВидДокумента, ДокументСсылка)
	
	ЕстьОшибки = Документы.ОтчетЕГАИС.ЕстьРасхожденияВПолученныхДанных(ВидДокумента, ДокументСсылка);
	Если ЕстьОшибки Тогда
		
		ПараметрыОбновленияСтатуса = ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса();
		ПараметрыОбновленияСтатуса.ОбновлятьДвижения = Ложь;
		ПараметрыОбновленияСтатуса.СтатусОбработки   = Перечисления.СтатусыОбработкиСообщенийЕГАИС.Ошибка;
		
		Документы.ОтчетЕГАИС.ОбновитьСтатусПослеПолученияДанных(
			ДокументСсылка, ОперацияПоВидуДокумента(ВидДокумента),
			ПараметрыОбновленияСтатуса);
		
	Иначе
		
		ПараметрыОбновленияСтатуса = ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса();
		ПараметрыОбновленияСтатуса.ОбновлятьДвижения = Ложь;
		
		Документы.ОтчетЕГАИС.ОбновитьСтатусПослеПолученияДанных(
			ДокументСсылка, ОперацияПоВидуДокумента(ВидДокумента),
			ПараметрыОбновленияСтатуса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОперацияПоВидуДокумента(ВидДокумента)
	
	Операция = Неопределено;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаДвиженияМеждуРегистрами;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2 Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаДвиженияПоСправке2;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаИнформацияОбОрганизации;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаНеобработанныеТТН;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОбработанныеЧеки;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1 Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОстаткиВРегистре1;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2 Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОстаткиВРегистре2;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3 Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОстаткиВРегистре3;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2 Тогда
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаИсторияСправок2;
	КонецЕсли;
	
	Возврат Операция;
	
КонецФункции

&НаКлиенте
Процедура ОповеститьОбИзмененииСтатуса()
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("Ссылка",    Объект.Ссылка);
	ПараметрОповещения.Вставить("Основание", Неопределено);
	
	Оповестить("ИзменениеСостоянияЕГАИС", ПараметрОповещения);
	
КонецПроцедуры

#КонецОбласти
