#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
         Возврат;
	КонецЕсли;
	
	Константы.ДатаОбновленияНаВерсиюСПрочтенностью.Установить(ТекущаяДатаСеанса()); //АПК:1036 не проверять строку на орфографию.
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли