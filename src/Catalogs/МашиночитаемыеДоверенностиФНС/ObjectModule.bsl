#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПометкаУдаления ИЛИ Ссылка.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = НСтр("ru = 'Машиночитаемая доверенность (ФНС)'") + ?(ЗначениеЗаполнено(НомерДоверенности), " №" + НомерДоверенности, "")
		+ ?(ЗначениеЗаполнено(ДатаВыдачи), " " + НСтр("ru = 'от'") + " "
		+ Формат(ДатаВыдачи, "ДФ='дд.ММ.гггг'") + " " + НСтр("ru = 'г.'"), "");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли