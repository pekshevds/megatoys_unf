
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элементы.Список.ТекущаяСтрока);
	ПараметрыОткрытия.Вставить("ДоступностьРесурса", Ложь);
	ОткрытьФорму("РегистрСведений.ВидыРесурсовПредприятия.ФормаЗаписи", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ТекущаяСтрокаСписка = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрокаСписка <> Неопределено Тогда
		Если ТекущаяСтрокаСписка.ВидРесурсаПредприятия = ПредопределенноеЗначение("Справочник.ВидыРесурсовПредприятия.ВсеРесурсы") Тогда
			ТекстСообщения = НСтр("ru = 'Объект не удален, т. к. ресурс предприятия должен входить в вид ""Все ресурсы"".'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокИзменить(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элементы.Список.ТекущаяСтрока);
	ПараметрыОткрытия.Вставить("ДоступностьРесурса", Ложь);
	ОткрытьФорму("РегистрСведений.ВидыРесурсовПредприятия.ФормаЗаписи", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти
