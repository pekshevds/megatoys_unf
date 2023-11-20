#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ПолноеИмяОбъектаЗагрузки;

	Если Параметры.Свойство("ОбъектЗагрузки", ПолноеИмяОбъектаЗагрузки) Тогда

		ОписаниеОбъектаЗагрузки = ЗагрузкаДанныхИзВнешнегоИсточника.ОбъектЗагрузкиПоПолномуИмени(
			ПолноеИмяОбъектаЗагрузки);
		Если ЗначениеЗаполнено(ОписаниеОбъектаЗагрузки.ОбъектЗагрузки) Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ОбъектЗагрузки",
				ОписаниеОбъектаЗагрузки.ОбъектЗагрузки, ВидСравненияКомпоновкиДанных.Равно, , Истина,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);

		КонецЕсли;

		Если Не ПустаяСтрока(ОписаниеОбъектаЗагрузки.ИмяТабличнойЧасти) Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ИмяТабличнойЧасти",
				ОписаниеОбъектаЗагрузки.ИмяТабличнойЧасти, ВидСравненияКомпоновкиДанных.Равно, , Истина,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);

		КонецЕсли;

	Иначе

		ВызватьИсключение НСтр("ru ='Самостоятельное использование формы не предусмотрено.'");

	КонецЕсли;

КонецПроцедуры

#КонецОбласти