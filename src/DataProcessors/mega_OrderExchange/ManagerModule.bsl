
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ФункцияПреобразованияЗаписи(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
	Если ТипЗнч(Значение) = Тип("УникальныйИдентификатор") Тогда
		Возврат Строка(Значение);
	КонецЕсли;
	Отказ = Истина;
КонецФункции

Функция ПолучитьЗаказОптСтрокой(id)Экспорт 
	
	id = 	Лев(id, 8) + "-" + 
			Сред(id, 9, 4) + "-" + 
			Сред(id, 13, 4) + "-" + 
			Сред(id, 17, 4) + "-" + 
			Прав(id, 12);
	
	ИсходящаяСтруктура = Новый Структура;
	МассивЗаказов = Новый Массив;
	
	
	ЗаписьJSON 							= Новый ЗаписьJSON;
	ЗаписьJSON.ПроверятьСтруктуру 		= Истина;
	ПараметрыЗаписиJSON 				= Новый ПараметрыЗаписиJSON(, Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	
	
	ЗаказПокупателя = ЗаказПокупателяПоИдентификатору(id);	
	ЗаказПокупателя = ЗаказПокупателя.ПолучитьОбъект();
	
	СписокФБО = СписокФБО();
	ФБО = МассивФБО(СписокФБО);
	
	Если (ЗаказПокупателя <> Неопределено) И 
			(ФБО.Найти(ЗаказПокупателя.Контрагент) <> Неопределено) Тогда 
		
				
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказПокупателяТовары.НомерСтроки КАК НомерСтроки,
		|	ЗаказПокупателяТовары.Номенклатура.Наименование КАК Наименование,
		|	ЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
		|	ЗаказПокупателяТовары.Номенклатура.Штрихкод КАК Штрихкод,
		|	ЗаказПокупателяТовары.Номенклатура.Код КАК Код,
		|	ЗаказПокупателяТовары.Номенклатура.Артикул КАК Артикул,
		|	ЗаказПокупателяТовары.Количество КАК Количество,
		|	ЗаказПокупателяТовары.mega_НомерЗаказа КАК НомерДокумента,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя КАК НоменклатураПокупателя,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Код КАК НоменклатураПокупателяКод,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Наименование КАК НоменклатураПокупателяНаименование,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Артикул КАК НоменклатураПокупателяАртикул,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Идентификатор КАК НоменклатураПокупателяИдентификатор
		|ИЗ
		|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяТовары
		|ГДЕ
		|	ЗаказПокупателяТовары.Ссылка = &ЗаказПокупателя
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		
		
		Покупатель = ПолучитьПокупателя(ЗаказПокупателя.Контрагент);
		ИсходящаяСтруктура.Вставить("head", Новый Структура("id,number,date,type,customer", 
										Строка(ЗаказПокупателя.Ссылка.УникальныйИдентификатор()), 
										ЗаказПокупателя.Номер, 
										Формат(ЗаказПокупателя.Дата, "ДФ=yyyyMMddHHmmss"),
										СписокФБО.Получить(ЗаказПокупателя.Контрагент),
										Покупатель));		 

		Пока Выборка.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(Выборка.Номенклатура) Тогда 
				
				Продолжить;
			КонецЕсли;
			
			Структура = Новый Структура;
			Структура.Вставить("index", 	Выборка.НомерСтроки);
			Структура.Вставить("name", 		СокрЛП(Лев(Выборка.Наименование, 150)));
			Структура.Вставить("id", 		Строка(Выборка.Номенклатура.УникальныйИдентификатор()));
			Структура.Вставить("code", 		СокрЛП(Выборка.Код));
			Структура.Вставить("art", 		СокрЛП(Выборка.Артикул));
			Структура.Вставить("qnt", 		Строка(Выборка.Количество));
			Структура.Вставить("number", 	СокрЛП(Выборка.НомерДокумента));
			Структура.Вставить("barcode", 	Выборка.Штрихкод);						                            			
			
//			НоменклатураПокупателя = ПолучитьНоменклатуруПокупателя(ЗаказПокупателя.Контрагент, Выборка.Номенклатура);
//			Если НоменклатураПокупателя <> Неопределено Тогда 
//				
//				Структура.Вставить("name", 		СокрЛП(Лев(НоменклатураПокупателя.Наименование, 150)));
//				Структура.Вставить("code", 		НоменклатураПокупателя.Код);
//				Структура.Вставить("art", 		НоменклатураПокупателя.Артикул);
//				Структура.Вставить("barcode", 	НоменклатураПокупателя.Идентификатор);
//			КонецЕсли;

			Если ЗначениеЗаполнено(Выборка.НоменклатураПокупателя) Тогда
				
				НоменклатураПокупателя = Новый Структура;
				НоменклатураПокупателя.Вставить("id", Строка(Выборка.НоменклатураПокупателя.УникальныйИдентификатор()));
				НоменклатураПокупателя.Вставить("code", Выборка.НоменклатураПокупателяКод);
				НоменклатураПокупателя.Вставить("name", Выборка.НоменклатураПокупателяНаименование);
				НоменклатураПокупателя.Вставить("art", Выборка.НоменклатураПокупателяАртикул);
				НоменклатураПокупателя.Вставить("barcode", Выборка.НоменклатураПокупателяИдентификатор);
							
				Структура.Вставить("customer", 	НоменклатураПокупателя);
			КонецЕсли;
			
			МассивЗаказов.Добавить(Структура);
		КонецЦикла;
	КонецЕсли;
	
	ИсходящаяСтруктура.Вставить("items", МассивЗаказов);	
	ЗаписатьJSON(ЗаписьJSON, ИсходящаяСтруктура, Новый НастройкиСериализацииJSON, "ФункцияПреобразованияЗаписи");
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция ПолучитьЗаказWildberriesСтрокой(id)Экспорт 
	
	id = 	Лев(id, 8) + "-" + 
			Сред(id, 9, 4) + "-" + 
			Сред(id, 13, 4) + "-" + 
			Сред(id, 17, 4) + "-" + 
			Прав(id, 12);
	
	ИсходящаяСтруктура = Новый Структура;
	МассивЗаказов = Новый Массив;
		
	//ЗаказПокупателя = Документы.ЗаказПокупателя.ПолучитьСсылку(Новый УникальныйИдентификатор(id));
	ЗаказПокупателя = ЗаказПокупателяПоИдентификатору(id);
	ЗаказПокупателя = ЗаказПокупателя.ПолучитьОбъект();
	
	Если ЗаказПокупателя <> Неопределено Тогда 
				
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказПокупателяТовары.НомерСтроки КАК НомерСтроки,
		|	ЗаказПокупателяТовары.Номенклатура.НаименованиеПолное КАК Наименование,
		|	ЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
		|	ЗаказПокупателяТовары.Номенклатура.Код КАК Код,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя КАК НоменклатураПокупателя,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Наименование КАК НаименованиеПокупателя,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Артикул КАК АртикулПокупателя,
		|	ЗаказПокупателяТовары.mega_НоменклатураПокупателя.Идентификатор КАК Идентификатор,
		|	ЗаказПокупателяТовары.mega_НомерЗаказа КАК НомерДокумента,
		|	ЗаказПокупателяТовары.Номенклатура.Штрихкод КАК Штрихкод
		|ИЗ
		|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяТовары
		|ГДЕ
		|	ЗаказПокупателяТовары.Ссылка = &ЗаказПокупателя
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		ЗаписьJSON 							= Новый ЗаписьJSON;
		ЗаписьJSON.ПроверятьСтруктуру 		= Истина;
		ПараметрыЗаписиJSON 				= Новый ПараметрыЗаписиJSON(, Символы.Таб);
		ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
		
		
		ИсходящаяСтруктура.Вставить("head", Новый Структура("id,number,date", 
										Строка(ЗаказПокупателя.Ссылка.УникальныйИдентификатор()), 
										ЗаказПокупателя.Номер, 
										Формат(ЗаказПокупателя.Дата, "ДФ=yyyyMMddHHmmss")));

		Пока Выборка.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(Выборка.Номенклатура) Тогда 
				
				Продолжить;
			КонецЕсли;
									
			Структура = Новый Структура;
			Структура.Вставить("index", 	Выборка.НомерСтроки);
			Структура.Вставить("name1", 	СокрЛП(Лев(Выборка.Наименование, 150)));
			Структура.Вставить("id", 		Строка(Выборка.Номенклатура.УникальныйИдентификатор()));
			Структура.Вставить("code", 		СокрЛП(Выборка.Код));
			Структура.Вставить("number", 	СокрЛП(Выборка.НомерДокумента));
			
			Структура.Вставить("name2", 	СокрЛП(Лев(Выборка.НаименованиеПокупателя, 150)));
			Структура.Вставить("art", 		СокрЛП(Выборка.АртикулПокупателя));
			Структура.Вставить("barcode", 	СокрЛП(Выборка.Идентификатор));
			Если Не ЗначениеЗаполнено(Выборка.НоменклатураПокупателя) Тогда 
				
				ВыборкаНоменклатураПоставщика = Справочники.НоменклатураПоставщиков.НоменклатураПоставщика(ЗаказПокупателя.Контрагент, Выборка.Номенклатура);
				Если ВыборкаНоменклатураПоставщика.Следующий() Тогда 
					
					НоменклатураПоставщика = ВыборкаНоменклатураПоставщика.Ссылка;
					
					Структура.Вставить("name2", 	СокрЛП(НоменклатураПоставщика.Наименование));
					Структура.Вставить("art", 		СокрЛП(НоменклатураПоставщика.Артикул));
					
					barcode = СокрЛП(НоменклатураПоставщика.Идентификатор);
					Если barcode = "" Тогда 
						barcode = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьШтрихкодПоНоменклатуре(Выборка.Номенклатура);
					КонецЕсли;
					Структура.Вставить("barcode", 	barcode);
				КонецЕсли;
			КонецЕсли;                                       
			Если Структура.barcode = "" Тогда 
				Структура.barcode = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьШтрихкодПоНоменклатуре(Выборка.Номенклатура);
			КонецЕсли;
			
			
			МассивЗаказов.Добавить(Структура);
		КонецЦикла;
	КонецЕсли;
	
	ИсходящаяСтруктура.Вставить("items", МассивЗаказов);
	ЗаписатьJSON(ЗаписьJSON, ИсходящаяСтруктура);
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция ПолучитьЗаказOzonСтрокой(id)Экспорт 
	
	id = 	Лев(id, 8) + "-" + 
			Сред(id, 9, 4) + "-" + 
			Сред(id, 13, 4) + "-" + 
			Сред(id, 17, 4) + "-" + 
			Прав(id, 12);
	
	ИсходящаяСтруктура = Новый Структура;
	МассивЗаказов = Новый Массив;
			
	ЗаказПокупателя = ЗаказПокупателяПоИдентификатору(id);
	ЗаказПокупателя = ЗаказПокупателя.ПолучитьОбъект();
	
	Если ЗаказПокупателя <> Неопределено Тогда 
				
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказПокупателяТовары.НомерСтроки КАК НомерСтроки,
		|	ЗаказПокупателяТовары.Номенклатура.Наименование КАК Наименование,
		|	ЗаказПокупателяТовары.Номенклатура.Штрихкод КАК Штрихкод,
		|	ЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
		|	ЗаказПокупателяТовары.Номенклатура.Код КАК Код,
		|	ЗаказПокупателяТовары.Номенклатура.Артикул КАК Артикул,
		|	ЗаказПокупателяТовары.mega_НомерЗаказа КАК НомерДокумента
		|ИЗ
		|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяТовары
		|ГДЕ
		|	ЗаказПокупателяТовары.Ссылка = &ЗаказПокупателя
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		ЗаписьJSON 							= Новый ЗаписьJSON;
		ЗаписьJSON.ПроверятьСтруктуру 		= Истина;
		ПараметрыЗаписиJSON 				= Новый ПараметрыЗаписиJSON(, Символы.Таб);
		ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
		
		
		ИсходящаяСтруктура.Вставить("head", Новый Структура("id,number,date", 
										Строка(ЗаказПокупателя.Ссылка.УникальныйИдентификатор()), 
										ЗаказПокупателя.Номер, 
										Формат(ЗаказПокупателя.Дата, "ДФ=yyyyMMddHHmmss")));

		Пока Выборка.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(Выборка.Номенклатура) Тогда 
				
				Продолжить;
			КонецЕсли;
						
			Структура = Новый Структура;
			Структура.Вставить("index", 	Выборка.НомерСтроки);
			Структура.Вставить("name", 		СокрЛП(Лев(Выборка.Наименование, 150)));
			Структура.Вставить("id", 		Строка(Выборка.Номенклатура.УникальныйИдентификатор()));
			Структура.Вставить("code", 		СокрЛП(Выборка.Код));
			Структура.Вставить("art", 		СокрЛП(Выборка.Артикул));
			Структура.Вставить("number", 	СокрЛП(Выборка.НомерДокумента));
			Структура.Вставить("barcode", 	СокрЛП(Выборка.Штрихкод));
							
			
			МассивЗаказов.Добавить(Структура);
		КонецЦикла;
	КонецЕсли;
	
	ИсходящаяСтруктура.Вставить("items", МассивЗаказов);
	ЗаписатьJSON(ЗаписьJSON, ИсходящаяСтруктура);
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция ИзменитьЗаказПокупателяПослеОтчетаОСборке(ВходящаяСтрока)Экспорт 
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ВходящаяСтрока);
	ВходящаяСтруктура = ПрочитатьJSON(ЧтениеJSON, Ложь);
	
	ЗаказПокупателя = Документы.ЗаказПокупателя.ПолучитьСсылку(Новый УникальныйИдентификатор(ВходящаяСтруктура.id));
	ЗаказПокупателя = ЗаказПокупателя.ПолучитьОбъект();
	
	Если ЗаказПокупателя <> Неопределено Тогда
		
		Если ВходящаяСтруктура.items.Количество() <> ЗаказПокупателя.Запасы.Количество() Тогда 
			
			Возврат Ложь;
		КонецЕсли;
		
		БылиОшибки = Ложь;
		НачатьТранзакцию();
		
		//Корректируем текущий заказ
		Для Каждого ТекСтрока Из ВходящаяСтруктура.items Цикл 
			
			СтрокаДокумента = ЗаказПокупателя.Запасы[ТекСтрока.item - 1];
			СтрокаДокумента.mega_Собран = ТекСтрока.flag;
						
		КонецЦикла;
		
		//Попытка
		//	ЗаказПокупателя.Записать(РежимЗаписиДокумента.Проведение);
		//Исключение
		//	
		//	ЗаписьЖурналаРегистрации("devideorder",,, "devideorder " + Строка(ЗаказПокупателя), ОписаниеОшибки());
		//	
		//	ОтменитьТранзакцию();
		//	Возврат Ложь;
		//КонецПопытки;
		
		//Создаем копию текущего заказа
		НовыйЗаказПокупателя = ЗаказПокупателя.Скопировать();
		НовыйЗаказПокупателя.Номер = "";
		НовыйЗаказПокупателя.Дата = ЗаказПокупателя.Дата;
		
		НовыйЗаказПокупателя.Комментарий = "### Не собранный товар по " + Строка(ЗаказПокупателя);
		
		
		//Удаляем не собранные строки из текущего 
		
		БылоУдаление = Ложь;
		НомерСтроки = ЗаказПокупателя.Запасы.Количество() - 1;
		Пока НомерСтроки >= 0 Цикл 
			
			Если НЕ ЗаказПокупателя.Запасы[НомерСтроки].mega_Собран Тогда 
				
				ЗаказПокупателя.Запасы.Удалить(НомерСтроки);
				БылоУдаление = Истина;
			КонецЕсли;
			
			НомерСтроки = НомерСтроки - 1;
		КонецЦикла;
		
		
		
		Попытка			
			ЗаказПокупателя.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
				
			БылиОшибки = Истина;
			ЗаписьЖурналаРегистрации("devideorder",,, "devideorder " + Строка(ЗаказПокупателя), ОписаниеОшибки());					
		КонецПопытки;           
				
		
		//Удаляем собранные строки из копии текущего
		НомерСтроки = НовыйЗаказПокупателя.Запасы.Количество() - 1;
		Пока НомерСтроки >= 0 Цикл 
			
			Если НовыйЗаказПокупателя.Запасы[НомерСтроки].mega_Собран Тогда 
				
				НовыйЗаказПокупателя.Запасы.Удалить(НомерСтроки);
			КонецЕсли;
			
			НомерСтроки = НомерСтроки - 1;
		КонецЦикла;
		
		Если НовыйЗаказПокупателя.Запасы.Количество() > 0 Тогда 
			
			Попытка
				НовыйЗаказПокупателя.Записать(РежимЗаписиДокумента.Запись);
			Исключение								
				
				БылиОшибки = Истина;
				ЗаписьЖурналаРегистрации("devideorder",,, "devideorder " + Строка(НовыйЗаказПокупателя), ОписаниеОшибки());										
			КонецПопытки;			
		КонецЕсли;
		
		Если БылиОшибки Тогда 
			ОтменитьТранзакцию();
			
			Возврат Ложь;
		Иначе 
			
			ЗафиксироватьТранзакцию();			
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция ИзменитьЗаказПокупателяПослеОтчетаОСборкеОпт(ВходящаяСтрока)Экспорт 
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ВходящаяСтрока);
	ВходящаяСтруктура = ПрочитатьJSON(ЧтениеJSON, Ложь);
	
	ЗаказПокупателя = Документы.ЗаказПокупателя.ПолучитьСсылку(Новый УникальныйИдентификатор(ВходящаяСтруктура.id));
	ЗаказПокупателя = ЗаказПокупателя.ПолучитьОбъект();
	
	Если ЗаказПокупателя <> Неопределено Тогда
		
		Если ВходящаяСтруктура.items.Количество() <> ЗаказПокупателя.Запасы.Количество() Тогда 
			
			Возврат Ложь;
		КонецЕсли;
		
		БылиОшибки = Ложь;
		НачатьТранзакцию();
		
		//Создаем копию текущего заказа
		НовыйЗаказПокупателя = ЗаказПокупателя.Скопировать();
		НовыйЗаказПокупателя.Номер = "";
		НовыйЗаказПокупателя.Дата = ЗаказПокупателя.Дата;
		НовыйЗаказПокупателя.Запасы.Очистить();		
		НовыйЗаказПокупателя.Комментарий = "### Не собранный товар по " + Строка(ЗаказПокупателя);
		
		//Корректируем текущий заказ и его копию
		Для Каждого ТекСтрока Из ВходящаяСтруктура.items Цикл 
			
			СтрокаЗаказПокупателя = ЗаказПокупателя.Запасы[ТекСтрока.item - 1];
			Если ТекСтрока.flag Тогда 				
				
				СтрокаЗаказПокупателя.mega_Собран = ТекСтрока.flag;
				Продолжить;
			КонецЕсли;
			
			СтрокаНовогоЗаказПокупателя = НовыйЗаказПокупателя.Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНовогоЗаказПокупателя, СтрокаЗаказПокупателя);
			
			//Если что-нибудь собрали
			Если ТекСтрока.collected > 0 Тогда 
				
				ПараметрыРасчета = Новый Структура;
				ПараметрыРасчета.Вставить("СброситьФлагСкидкиРассчитаны", Истина);
				ПараметрыРасчета.Вставить("СуммаВключаетНДС", ЗаказПокупателя.СуммаВключаетНДС);
				ПараметрыРасчета.Вставить("ИспользоватьМинимальныеЦены", Ложь);
				
				СтрокаЗаказПокупателя.Количество = ТекСтрока.collected;
				СтрокаЗаказПокупателя.mega_Собран = Истина;
				ТабличныеЧастиУНФКлиентСервер.РассчитатьСуммыВСтрокеТЧ(СтрокаЗаказПокупателя, ПараметрыРасчета);
			КонецЕсли;
			
			Если ТекСтрока.collected < СтрокаНовогоЗаказПокупателя.Количество Тогда
				
				ПараметрыРасчета = Новый Структура;
				ПараметрыРасчета.Вставить("СброситьФлагСкидкиРассчитаны", Истина);
				ПараметрыРасчета.Вставить("СуммаВключаетНДС", НовыйЗаказПокупателя.СуммаВключаетНДС);
				ПараметрыРасчета.Вставить("ИспользоватьМинимальныеЦены", Ложь);
				
				СтрокаНовогоЗаказПокупателя.Количество = СтрокаНовогоЗаказПокупателя.Количество - ТекСтрока.collected;			
				ТабличныеЧастиУНФКлиентСервер.РассчитатьСуммыВСтрокеТЧ(СтрокаНовогоЗаказПокупателя, ПараметрыРасчета);
			КонецЕсли;
						
		КонецЦикла;
				
		Попытка			
			ЗаказПокупателя.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
				
			БылиОшибки = Истина;
			ЗаписьЖурналаРегистрации("devideorder",,, "devideorder " + Строка(ЗаказПокупателя), ОписаниеОшибки());					
		КонецПопытки;           
								
		Если НовыйЗаказПокупателя.Запасы.Количество() > 0 Тогда 
			
			Попытка
				НовыйЗаказПокупателя.Записать(РежимЗаписиДокумента.Запись);
			Исключение								
				
				БылиОшибки = Истина;
				ЗаписьЖурналаРегистрации("devideorder",,, "devideorder " + Строка(НовыйЗаказПокупателя), ОписаниеОшибки());										
			КонецПопытки;			
		КонецЕсли;
		
		Если БылиОшибки Тогда 
			ОтменитьТранзакцию();
			
			Возврат Ложь;
		Иначе 
			
			ЗафиксироватьТранзакцию();			
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПокупателя(Контрагент)
	Покупатель = Новый Структура;
	Покупатель.Вставить("id", Строка(Контрагент.УникальныйИдентификатор()));
	Покупатель.Вставить("code", Строка(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Код")));
	Покупатель.Вставить("name", Строка(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Наименование"))); 
	Возврат Покупатель;
КонецФункции

Функция ЗаказПокупателяПоИдентификатору(id) 
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор(id);
	Возврат Документы.ЗаказПокупателя.ПолучитьСсылку(УникальныйИдентификатор);
КонецФункции

Функция ПолучитьНоменклатуруПокупателя(Покупатель, Номенклатура)
	
	ВыборкаНоменклатурыПоставщика = Справочники.НоменклатураПоставщиков.НоменклатураПоставщика(Покупатель, Номенклатура);
	Если ВыборкаНоменклатурыПоставщика.Следующий() Тогда 
		
		ДанныеНоменклатурыПоставщика = Справочники.НоменклатураПоставщиков.ДанныеНоменклатурыПоставщика(ВыборкаНоменклатурыПоставщика.Ссылка);
		Структура = Новый Структура();
		Структура.Вставить("Код", ДанныеНоменклатурыПоставщика.Код);
		Структура.Вставить("Наименование", ДанныеНоменклатурыПоставщика.Наименование);
		Структура.Вставить("Идентификатор", ДанныеНоменклатурыПоставщика.Код);
		Структура.Вставить("Артикул", ДанныеНоменклатурыПоставщика.Артикул);
		Возврат Структура;
	КонецЕсли;	
	Возврат Неопределено;
КонецФункции

Функция МассивФБО(СписокФБО)
	
	ФБО = Новый Массив;
	
	Для Каждого ЭлементСпискаФБО из СписокФБО Цикл 
		ФБО.Добавить(ЭлементСпискаФБО.Ключ);
	КонецЦикла;
	
	Возврат ФБО;
КонецФункции

Функция СписокФБО()
	
	ФБО = Новый Соответствие;
	
	Вайлдберриз = Справочники.Контрагенты.НайтиПоКоду("УТ0004010");
	Если ЗначениеЗаполнено(Вайлдберриз) Тогда 
		
		ФБО.Вставить(Вайлдберриз, "wb");
	КонецЕсли;
	
	
	Озон = Справочники.Контрагенты.НайтиПоКоду("УТ0004009");
	Если ЗначениеЗаполнено(Вайлдберриз) Тогда 
		
		ФБО.Вставить(Озон, "ozon");
	КонецЕсли;
	
	test = Справочники.Контрагенты.НайтиПоКоду("НФ-000002");
	Если ЗначениеЗаполнено(test) Тогда 
		
		ФБО.Вставить(test, "test");
	КонецЕсли;
	
	Возврат ФБО;
КонецФункции

#КонецОбласти

#КонецЕсли
