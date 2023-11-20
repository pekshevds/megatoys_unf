
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокВидовЦен();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаПередЗакрытием", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Порядок сортировки был изменен. Сохранить порядок?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ИндексироватьСписок();
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	ЗафиксироватьИзмененияВидовЦен(Отказ);
	
	Если НЕ Отказ Тогда
		
		Модифицированность = Ложь;
		Закрыть(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаВидовЦенПоУмолчанию(Команда)
	
	СортироватьВидыЦенПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВопросаПередЗакрытием(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Отказ = Ложь;
		ЗафиксироватьИзмененияВидовЦен(Отказ);
		Модифицированность = Ложь;
		
		Если НЕ Отказ Тогда
			
			Закрыть(Истина);
			
		КонецЕсли;
		
	Иначе
		
		Модифицированность = Ложь;
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВидовЦен()
	
	Список.Загрузить(Справочники.ВидыЦен.ПолучитьСортированнуюТаблицуВидовЦен());
	
КонецПроцедуры

&НаКлиенте
Процедура ИндексироватьСписок()
	
	НомерСтроки = 1;
	Для каждого Строка Из Список Цикл
	
		Строка.ПорядокКолонок = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Процедура ЗафиксироватьИзмененияВидовЦен(Отказ)
	
	Если Модифицированность Тогда
		
		НачатьТранзакцию();
		
		Попытка
			
			Для каждого Строка Из Список Цикл
				
				ВидЦеныОбъект = Строка.ВидЦены.ПолучитьОбъект();
				ВидЦеныОбъект.Заблокировать();
				ВидЦеныОбъект.ПорядокКолонок = Строка.ПорядокКолонок;
				ВидЦеныОбъект.Записать();
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			Отказ = Истина;
			
			ИмяСобытия = НСтр("ru = 'Фиксация сортировки видов цен'", ОбщегоНазначения.КодОсновногоЯзыка());
			ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(ИмяСобытия, 
				УровеньЖурналаРегистрации.Ошибка, 
				Метаданные.Справочники.ВидыЦен, 
				Строка.ВидЦены, 
				ПредставлениеОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СортироватьВидыЦенПоУмолчанию()
	
	НачатьТранзакцию();
		
	Попытка
			
		Для каждого Строка Из Список Цикл
			
			Строка.ПорядокКолонок = 0;
			ВидЦеныОбъект = Строка.ВидЦены.ПолучитьОбъект();
			ВидЦеныОбъект.Заблокировать();
			ВидЦеныОбъект.ПорядокКолонок = 0;
			ВидЦеныОбъект.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
			
			ОтменитьТранзакцию();
			
			ИмяСобытия = НСтр("ru = 'Сортировка видов цен по умолчанию'", ОбщегоНазначения.КодОсновногоЯзыка());
			ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка, 
				Метаданные.Справочники.ВидыЦен, 
				Строка.ВидЦены, 
				ПредставлениеОшибки);
			
		КонецПопытки;
	
	Список.Загрузить(Справочники.ВидыЦен.ПолучитьСортированнуюТаблицуВидовЦен());
	
КонецПроцедуры

#КонецОбласти