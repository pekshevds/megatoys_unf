
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПодобратьКлассификатор.Видимость = ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.КТРУ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьКлассификатор(Команда)
	
	ОткрытьФорму("Справочник.КТРУ.Форма.ДобавлениеЭлементовВКлассификатор",, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти