
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.РежимВыбора Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКнопкаВыбрать", "КнопкаПоУмолчанию", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКнопкаВыбрать", "Видимость", Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКнопкаВыбрать", "Видимость", Ложь);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
		Если Параметры.Свойство("ТекущаяСтрока") Тогда
			Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ПерепискаСКонтролирующимиОрганами", , Элемент.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти