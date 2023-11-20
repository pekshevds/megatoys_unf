
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.ОрганизацияЕГАИС.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ОрганизацияЕГАИС", Параметры.ОрганизацияЕГАИС);
	КонецЕсли;
	
	Если Параметры.ИмпортПроизводство = Истина Или Параметры.ИмпортПроизводство = Ложь Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ИмпортПроизводство", Истина, ВидСравненияКомпоновкиДанных.Равно,,
			Параметры.ИмпортПроизводство, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;
	
	Если Параметры.ТолькоМаркируемая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Маркируемый", Истина, ВидСравненияКомпоновкиДанных.Равно,,
			Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ИначеЕсли Параметры.ТолькоНемаркируемая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Маркируемый", Истина, ВидСравненияКомпоновкиДанных.Равно,,
			Ложь, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный)
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти