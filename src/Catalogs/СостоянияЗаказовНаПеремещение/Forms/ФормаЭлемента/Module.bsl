
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Цвет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования, "Цвет").Получить();
		Иначе
			Цвет = Метаданные.ЭлементыСтиля.БазовыйЦветСостояний.Значение;
		КонецЕсли;
		
		ОтобразитьНовыеДанные(Цвет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОтобразитьНовыеДанные(ТекущийОбъект.Цвет.Получить());
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеЦвета = Цвет;
	
	Если ЗначениеЦвета = Новый Цвет(0, 0, 0) Тогда
		ЗначениеЦвета = Неопределено;
	КонецЕсли;
	
	ТекущийОбъект.Цвет = Новый ХранилищеЗначения(ЗначениеЦвета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СостоянияЗаказовНаПеремещение", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УстановитьЦвет(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработчикОповещенияЦветВыборНажатие", ЭтотОбъект);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Цвет", Цвет);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораЦветаУНФ", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещенияЦветВыборНажатие(Цвет, ДополнительныеПараметры) Экспорт
	
	Если Цвет <> Неопределено И Цвет <> КодВозвратаДиалога.Отмена Тогда
		ОтобразитьНовыеДанные(Цвет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтобразитьНовыеДанные(НовыйЦвет)
	Цвет = НовыйЦвет;
	
	Элементы.Цвет.ЦветТекста = Цвет;
	Элементы.Цвет.ЦветФона = Цвет;
КонецПроцедуры

#КонецОбласти
