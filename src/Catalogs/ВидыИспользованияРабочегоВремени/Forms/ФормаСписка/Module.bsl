
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
		РежимВыбораИнформацииОВидеВремени = Параметры.РежимВыбораИнформацииОВидеВремени;
		Если РежимВыбораИнформацииОВидеВремени Тогда
			РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		КонецЕсли;
	КонецЕсли;
	
	УчетРабочегоВремени.ПриСозданииФормыСпискаСправочникаВидыИспользованияРабочегоВремени(ЭтотОбъект, Параметры);
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "Ссылка, Предопределенный");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не РежимВыбораИнформацииОВидеВремени Тогда
		Возврат;
	КонецЕсли;

	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	
	ДанныеВыбора = Новый Структура("ВидВремени, БуквенноеОбозначение, Наименование, Целосменное"); 
	ДанныеВыбора.ВидВремени = ВыбраннаяСтрока;
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		ДанныеВыбора.БуквенноеОбозначение = ДанныеТекущейСтроки.БуквенныйКод;
		ДанныеВыбора.Наименование = ДанныеТекущейСтроки.Наименование;
		ДанныеВыбора.Целосменное = ДанныеТекущейСтроки.Целосменное;
	КонецЕсли;
	
 	ОповеститьОВыборе(ДанныеВыбора);	
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
