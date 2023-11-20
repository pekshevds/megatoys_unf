#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбраннаяСтрока) Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатьВыпискиЗаПериод(Команда)
	
	ПараметрыФормы = Новый Структура("ВидОперации", "ПечатьВыписки");
	ОткрытьФорму("Документ.СообщениеОбменСБанками.Форма.ПечатьВыпискиЗаПериод", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьКомплекта(Команда)

	ПараметрыФормы = Новый Структура("ВидОперации", "ПечатьКомплектаДокументов");
	ОткрытьФорму("Документ.СообщениеОбменСБанками.Форма.ПечатьВыпискиЗаПериод", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
