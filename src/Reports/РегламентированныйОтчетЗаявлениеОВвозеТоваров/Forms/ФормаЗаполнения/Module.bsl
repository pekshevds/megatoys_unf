
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОК(Команда)
			
	КолвоЭлементов = Документы.Количество();
	
	Для ОбратныйИндекс = 1 По КолвоЭлементов Цикл
		
		Элемент = Документы[КолвоЭлементов - ОбратныйИндекс];
		
		Если НЕ ЗначениеЗаполнено(Элемент.Дата) И НЕ ЗначениеЗаполнено(Элемент.Номер) И НЕ ЗначениеЗаполнено(Элемент.Серия) Тогда	
	    	Документы.Удалить(Элемент);
		КонецЕсли;
				
	КонецЦикла;	
	
	Для Каждого Строка Из Документы Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Дата) ИЛИ НЕ ЗначениеЗаполнено(Строка.Номер + Строка.Серия) Тогда
			
			НомерСтроки = Документы.Индекс(Строка) + 1;
						
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Требуется дозаполнить строку %1.'"), НомерСтроки);
			Сообщение.Сообщить();
			
			Возврат;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Закрыть(Документы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Док Из Параметры.Документы Цикл
		
		НовДок = Документы.Добавить();
		НовДок.Дата  = Док.Дата;
		НовДок.Номер = Док.Номер;
		НовДок.Серия = Док.Серия;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти