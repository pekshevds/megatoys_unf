#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Отбор.Свойство("ЗаписьКалендаря") Тогда
		Элементы.ЗаписьКалендаря.Видимость = Ложь;
		Элементы.ОбъектУменьшенияНалога.Видимость = Ложь;
		Элементы.КодПООКТМО.Видимость = Ложь;
		Элементы.КодИФНС.Видимость = Ложь;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
