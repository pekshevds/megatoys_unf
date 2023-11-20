#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИПроверитьПереданныеПараметры();
	
	УстановитьБыстрыйОтборСервер();
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
	ИнтеграцияЗЕРНО.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействие.СписокВыбора, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ИнтеграцияИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СобытияФормЗЕРНОКлиент.ИмяСобытияИзмененаНастройкаАвтоматическогоОбмена() Тогда
		НастроитьДоступностьКомандыВыполнитьОбмен();
	КонецЕсли;
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Статус", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборОрганизацииЗавершение = Новый ОписаниеОповещения("ВыборОрганизацииЗавершение", ЭтотОбъект);
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",, ВыборОрганизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборОрганизацииЗавершение = Новый ОписаниеОповещения("ВыборОрганизацииЗавершение", ЭтотОбъект);
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",, ВыборОрганизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЗЕРНОКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиент.ОрганизацииДляОбмена(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияЗЕРНОКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список, ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияЗЕРНОКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.Статус.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ЗапросОстатковПартийЗЕРНО.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействие.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ЗапросОстатковПартийЗЕРНО.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры();
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.МножественныйВыбор <> Неопределено Тогда
		Элементы.Список.МножественныйВыбор = Параметры.МножественныйВыбор;
	КонецЕсли;
	
	Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОрганизацииЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЗЕРНО - Массив дальшейних действий
//
&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ЗапросОстатковПартийЗЕРНО.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ЗапросОстатковПартийЗЕРНО.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияЗЕРНО.УстановитьОтборПоДальнейшемуДействию(
		Список, ДальнейшееДействие, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организации,,, Истина);
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	
	Если ИнтеграцияЗЕРНО.НеобходимОтборПоДальнейшемуДействиюПриСозданииНаСервере(ДальнейшееДействие, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьКомандыВыполнитьОбмен()
	
	СобытияФормЗЕРНО.ДоступностьКомандыВыполнитьОбмен(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()

	ИнтеграцияЗЕРНОСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам()
	
	СобытияФормЗЕРНО.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
