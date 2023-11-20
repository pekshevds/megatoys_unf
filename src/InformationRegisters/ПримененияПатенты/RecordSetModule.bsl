#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.РозничнаяТорговляОблагаетсяПатентом Тогда
			
	        ПроверяемыеРеквизиты.Добавить("СтавкаНДС");
			
		КонецЕсли;	
			
	КонецЦикла;	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли