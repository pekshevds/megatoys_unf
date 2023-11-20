#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИПроверитьПереданныеПараметры(Отказ);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого Строка Из Строки Цикл
		Если Не ПустаяСтрока(Строка.Значение.Данные.ОКПД2Наименование) Тогда
			Строка.Значение.Оформление["ОКПД2"].УстановитьЗначениеПараметра("Текст",
				СтрШаблон(НСтр("ru = '%1 (ОКПД2: %2)'"),
				Строка.Значение.Данные.ОКПД2Наименование,
				Строка.Значение.Данные.ОКПД2));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

#Область ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры(Отказ);
	
	Если ЗначениеЗаполнено(Параметры.Получатель) Тогда
		
		Подразделение = Неопределено;
		Параметры.Свойство("Подразделение", Подразделение);
		
		Если Подразделение = Неопределено Тогда
			КлючиРеквизитовОрганизаций = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(
				Параметры.Получатель);
		Иначе
			ТаблицаИсточникиРеквизитов = ИнтеграцияЗЕРНО.НоваяТаблицаОрганизацияКонтрагентПодразделение();
			ИнтеграцияЗЕРНО.ДобавитьВТаблицуОтбораОрганизациюПодразделение(
				ТаблицаИсточникиРеквизитов, Параметры.Получатель, Параметры.Подразделение);
			КлючиРеквизитовОрганизаций = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(
				ТаблицаИсточникиРеквизитов);
		КонецЕсли;
		
		ОтборДинамическогоСписка = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
		
		ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ОтборДинамическогоСписка,, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора,
			"Грузополучатель",
			КлючиРеквизитовОрганизаций,,,,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора,
			"Покупатель",
			КлючиРеквизитовОрганизаций,,,,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти