&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.УчетнаяЗапись) Тогда
		
		ЗаписьОблачнойПодписи = РегистрыСведений.НастройкиОбменаСервисаПодписи.СоздатьМенеджерЗаписи();
		ЗаписьОблачнойПодписи.УчетнаяЗапись = Параметры.УчетнаяЗапись;
		ЗаписьОблачнойПодписи.Идентификатор = Параметры.УчетнаяЗапись.УникальныйИдентификатор();
		ЗаписьОблачнойПодписи.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьОблачнойПодписи.УчетнаяЗапись) Тогда
			ЗначениеВДанныеФормы(ЗаписьОблачнойПодписи, Запись);
		Иначе
			Запись.УчетнаяЗапись = Параметры.УчетнаяЗапись;
			Запись.Идентификатор = Параметры.УчетнаяЗапись.УникальныйИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеНастроекЭДООрганизации", Запись.УчетнаяЗапись);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	
	Элементы.УчетнаяЗапись.ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти
