
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктурнаяЕдиница") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтруктурнаяЕдиница",
			Параметры.СтруктурнаяЕдиница);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
