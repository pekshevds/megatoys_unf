#Область СлужебныеПроцедурыИФункции

//****************************FBO****************************
Функция getOrderOptByID(Запрос)
	
	id = Запрос.ПараметрыЗапроса.Получить("id");
	Если ЗначениеЗаполнено(id) Тогда 
		
		ЗаказОптСтрокой = Обработки.mega_OrderExchange.ПолучитьЗаказОптСтрокой(id);
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(ЗаказОптСтрокой, КодировкаТекста.UTF8);
	Иначе
		
		Ответ = Новый HTTPСервисОтвет(400);
		Ответ.УстановитьТелоИзСтроки("Не указан id", КодировкаТекста.UTF8);
	КонецЕсли;
	Возврат Ответ
КонецФункции

Функция devideOrderOptByID(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(500);
	Если Обработки.mega_OrderExchange.ИзменитьЗаказПокупателяПослеОтчетаОСборке(
			Запрос.ПолучитьТелоКакСтроку()) Тогда 
		Ответ = Новый HTTPСервисОтвет(200);
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

//****************************WB****************************
Функция getOrderWildberriesByID(Запрос)
	
	id = Запрос.ПараметрыЗапроса.Получить("id");
	Если ЗначениеЗаполнено(id) Тогда 
		
		ЗаказВБСтрокой = Обработки.mega_OrderExchange.ПолучитьЗаказWildberriesСтрокой(id);
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(ЗаказВБСтрокой, КодировкаТекста.UTF8);
	Иначе
		
		Ответ = Новый HTTPСервисОтвет(400);
		Ответ.УстановитьТелоИзСтроки("Не указан id", КодировкаТекста.UTF8);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция devideOrderWildberriesByID(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(500);
	Если Обработки.mega_OrderExchange.ИзменитьЗаказПокупателяПослеОтчетаОСборке(
			Запрос.ПолучитьТелоКакСтроку()) Тогда 
		Ответ = Новый HTTPСервисОтвет(200);
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

//****************************OZON****************************
Функция getOrderOzonByID(Запрос)
	
	id = Запрос.ПараметрыЗапроса.Получить("id");
	Если ЗначениеЗаполнено(id) Тогда 
		
		ЗаказОзонСтрокой = Обработки.mega_OrderExchange.ПолучитьЗаказOzonСтрокой(id);
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json");
		Ответ.УстановитьТелоИзСтроки(ЗаказОзонСтрокой, КодировкаТекста.UTF8);
	Иначе
		
		Ответ = Новый HTTPСервисОтвет(400);
		Ответ.УстановитьТелоИзСтроки("Не указан id", КодировкаТекста.UTF8);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция devideOrderOzonByID(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(500);
	Если Обработки.mega_OrderExchange.ИзменитьЗаказПокупателяПослеОтчетаОСборке(
			Запрос.ПолучитьТелоКакСтроку()) Тогда 
		Ответ = Новый HTTPСервисОтвет(200);
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

#КонецОбласти