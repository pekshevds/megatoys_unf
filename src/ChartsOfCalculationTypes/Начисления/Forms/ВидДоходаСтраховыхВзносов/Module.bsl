#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "КодДоходаСтраховыеВзносы2017,КодДоходаСтраховыеВзносы");
	Элементы.КодДоходаСтраховыеВзносы2017.ПараметрыВыбора = Параметры.ПараметрыВыбора;
	Элементы.КодДоходаСтраховыеВзносы.ПараметрыВыбора = Параметры.ПараметрыВыбора;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Если Модифицированность Тогда
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("КодДоходаСтраховыеВзносы2017", КодДоходаСтраховыеВзносы2017);
		ПараметрыОповещения.Вставить("КодДоходаСтраховыеВзносы", КодДоходаСтраховыеВзносы);
		
		Оповестить("ИзмененыВидыДоходаСтраховыхВзносов", ПараметрыОповещения, ВладелецФормы);
		
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти


