
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Подразделение = Неопределено;
	Параметры.Свойство("Подразделение", Подразделение);
	
	Если Подразделение = Неопределено Тогда
		ВладелецПартии = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(Параметры.Организация);
	Иначе
		ТаблицаИсточникиРеквизитов = ИнтеграцияЗЕРНО.НоваяТаблицаОрганизацияКонтрагентПодразделение();
		ИнтеграцияЗЕРНО.ДобавитьВТаблицуОтбораОрганизациюПодразделение(
			ТаблицаИсточникиРеквизитов, Параметры.Организация, Параметры.Подразделение);
		ВладелецПартии = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(
			ТаблицаИсточникиРеквизитов);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ВладелецПартии", ВладелецПартии);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти