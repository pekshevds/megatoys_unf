#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстРезультатаОбменаПоОрганизации) Тогда
		Элементы.ПоясняющийТекст.Заголовок 				= Параметры.ТекстРезультатаОбменаПоОрганизации;
		Элементы.ДекорацияДлительнаяОперация.Картинка 	= Параметры.КартинкаРезультатаОбменаПоОрганизации;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Показать(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти