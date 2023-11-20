#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидСтавкиНДС) И Не ДополнительныеСвойства.Свойство("ОбновлениеВидовСтавокНДС") Тогда
		ВидСтавкиНДС =  Перечисления.ВидыСтавокНДС.ВидСтавки(
			Новый Структура("Ставка,НеОблагается,Расчетная", Ставка, НеОблагается, Расчетная));
	КонецЕсли;
	
	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли