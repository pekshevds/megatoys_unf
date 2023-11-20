#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		СтрокаНабора.ЭтоРасчетыПоНачислениюУплатеВзносовВФСС = СтрокаНабора.ВидОбязательногоСтрахованияСотрудников
			= Перечисления.ВидыОбязательногоСтрахованияСотрудниковУНФ.ФСС; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
