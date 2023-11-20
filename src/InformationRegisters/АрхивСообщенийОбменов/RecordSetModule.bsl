

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		
		Прочитать();
		
		Если Количество() > 0 Тогда
			Запись = ЭтотОбъект[0];
			Если Запись.ПолноеИмяФайла <> "" Тогда
				УдалитьФайлы(Запись.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
		
		Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
