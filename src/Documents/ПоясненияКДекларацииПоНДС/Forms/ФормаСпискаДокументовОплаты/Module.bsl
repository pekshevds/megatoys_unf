
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого Строка Из Параметры.ДокументыОплаты Цикл
		ДокументОплаты = ДокументыОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(ДокументОплаты, Строка.Значение);
		ДокументОплаты.Представление = Строка.Представление;
	КонецЦикла;
	
	Если ТолькоПросмотр Тогда
		Элементы.ДокументыОплаты.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элементы.ФормаКомандаОК.Видимость = Ложь;
	КонецЕсли;
	
	РеквизитыДокументовОплаты = Документы.ПоясненияКДекларацииПоНДС.РеквизитыДокументовОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда 
		
		Если НЕ ПеренестиВДокумент Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Отменить изменения?'");
	
			ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
				ЭтотОбъект, 
				Отказ, 
				ЗавершениеРаботы,
				ТекстПредупреждения, 
				"ПеренестиВДокумент");
			
		ИначеЕсли Не Отказ Тогда
			Отказ = НЕ ПроверитьЗаполнениеНаКлиенте();
			Если Отказ Тогда
				ПеренестиВДокумент = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ДокументыОплатыНомерПриИзменении(Элемент)
	
	УстановитьПредставление(Элементы.ДокументыОплаты.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОплатыДатаПриИзменении(Элемент)
	
	УстановитьПредставление(Элементы.ДокументыОплаты.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Если ПроверитьЗаполнениеНаКлиенте() Тогда
		РезультатЗакрытия = СписокДокументовОплаты();
		ОповеститьОВыборе(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ПеренестиВДокумент = Ложь;
	Модифицированность = Ложь;
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СписокДокументовОплаты()
	
	СписокДокументовОплаты = Новый СписокЗначений();
	
	Для Каждого ДокументОплаты Из ДокументыОплаты Цикл
		ЗначенияРеквизитов = Новый Структура(РеквизитыДокументовОплаты);
		ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ДокументОплаты);
		СписокДокументовОплаты.Добавить(ЗначенияРеквизитов, ДокументОплаты.Представление);
	КонецЦикла;
	
	Возврат СписокДокументовОплаты;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	
	Для Каждого ДокументОплаты Из ДокументыОплаты Цикл
		Если НЕ ЗначениеЗаполнено(ДокументОплаты.Номер) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер'"));
			Поле = "ДокументыОплаты["+ Формат(ДокументыОплаты.Индекс(ДокументОплаты), "ЧДЦ=; ЧГ=0") +"].Номер";
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ДокументОплаты.Дата) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата'"));
			Поле = "ДокументыОплаты["+ Формат(ДокументыОплаты.Индекс(ДокументОплаты), "ЧДЦ=; ЧГ=0") +"].Дата";
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ;

КонецФункции

&НаСервере
Процедура УстановитьПредставление(Строка)
	ДанныеСтроки = ДокументыОплаты.НайтиПоИдентификатору(Строка);
	ДанныеСтроки.Представление = Документы.ПоясненияКДекларацииПоНДС.ПредставлениеДокументаОплаты(ДанныеСтроки);
КонецПроцедуры

#КонецОбласти