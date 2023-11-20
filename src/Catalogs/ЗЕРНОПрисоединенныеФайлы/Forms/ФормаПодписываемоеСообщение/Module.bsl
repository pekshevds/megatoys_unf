
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = Параметры.Сообщение;
	Если Сообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ОписаниеОперацииПоДействиюССообщением(
		Параметры.Сообщение.Операция,
		Параметры.ОперацияСообщения,
		Параметры.ДополнительноеОписание,
		Параметры.НомерВерсии,
		ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПредставлениеНомераСтраницы(Параметры.НомерСтраницы));
	
	ТекстСообщенияXML = ИнтеграцияИС.ФорматироватьXMLСПараметрами(
			Сообщение[Параметры.ИмяПоляСообщения],
			ИнтеграцияИС.ПараметрыФорматированияXML(Истина));
	
	ТабличныйДокументТекстСообщенияXML.УстановитьТекст(ТекстСообщенияXML);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти