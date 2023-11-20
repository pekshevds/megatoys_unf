
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоЗначений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаДляПоиска = "Из кассы на счет, Со счета в кассу, Между счетами, Между кассами";
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации) = Тип("Строка") И
		СтрНайти(СтрокаДляПоиска, Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации) = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Выберите операцию (не группу)'"));
	Иначе
		Закрыть(Элемент.ТекущиеДанные.ВидОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ТипЗнч(Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации) = Тип("СправочникСсылка.ХозяйственныеОперации") Тогда
		Закрыть(Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации);
	Иначе
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Выберите операцию (не группу)'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьЗначениеВДерево(ЗначениеСтроки, ВеткаРодитель)
	
	СтрокаДерева = ВеткаРодитель.ПолучитьЭлементы().Добавить();
	СтрокаДерева.ВидОперации = ЗначениеСтроки;
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиСписокВДерево(СписокХозОпераций, ВеткаРодитель)
	
	Для Каждого ЭлементСписка Из СписокХозОпераций Цикл
		ДобавитьЗначениеВДерево(ЭлементСписка.Значение, ВеткаРодитель);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗначений()
	
	// Поступление.
	ВеткаПоступление = ДеревоЗначений.ПолучитьЭлементы().Добавить();
	ВеткаПоступление.ВидОперации = "Поступление";
	
	//    Поступление. Банк.
	СписокОперацийПоступлениеНаСчет = Новый СписокЗначений;
	ДвиженияДенежныхСредствВызовСервера.ЗаполнитьСписокВыбораВидовОпераций("ПоступлениеНаСчет", СписокОперацийПоступлениеНаСчет);
	ПеренестиСписокВДерево(СписокОперацийПоступлениеНаСчет, ВеткаПоступление);
	
	// Расход.
	ВеткаРасход = ДеревоЗначений.ПолучитьЭлементы().Добавить();
	ВеткаРасход.ВидОперации = "Расход";
	
	//    Расход. Банк.
	СписокОперацийРасходСоСчета = Новый СписокЗначений;
	ДвиженияДенежныхСредствВызовСервера.ЗаполнитьСписокВыбораВидовОпераций("РасходСоСчета", СписокОперацийРасходСоСчета);
	ПеренестиСписокВДерево(СписокОперацийРасходСоСчета, ВеткаРасход);
	
КонецПроцедуры

#КонецОбласти





