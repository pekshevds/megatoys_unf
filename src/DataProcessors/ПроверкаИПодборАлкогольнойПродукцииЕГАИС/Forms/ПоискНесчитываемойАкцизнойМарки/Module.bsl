#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СоответствиеШтрихкодов = Параметры.СоответствиеШтрихкодов;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НайденныеАкцизныеМаркиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = НайденныеАкцизныеМарки.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ЗакрытьФорму(ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеАкцизныеМаркиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ДанныеСтроки = НайденныеАкцизныеМарки.НайтиПоИдентификатору(Значение);
	
	ЗакрытьФорму(ДанныеСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура НайденныеАкцизныеМаркиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиАкцизныеМарки(Команда)
	
	ОчиститьСообщения();
	
	Если СтрДлина(СтрокаПоиска) < 6 Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать по крайней мере 6 символов.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "СтрокаПоиска",,);
		Возврат;
	КонецЕсли;
	
	НайденныеАкцизныеМарки.Очистить();
	
	Для Каждого ЭлементСоответствия Из СоответствиеШтрихкодов Цикл
		
		ШтриховойКод = ЭлементСоответствия.Ключ;
		
		Если СтрДлина(ШтриховойКод) = 68 Тогда
			
			ПодстрокаВКоторойИщем = Сред(ШтриховойКод, 20, 18);
			
			Если СтрНайти(ПодстрокаВКоторойИщем, СтрокаПоиска) > 0 Тогда
				
				НайденнаяСтрокаДерева = ВладелецФормы.ДеревоМаркированнойПродукции.НайтиПоИдентификатору(ЭлементСоответствия.Значение);
				Если НайденнаяСтрокаДерева <> Неопределено Тогда
					
					НоваяСтрока = НайденныеАкцизныеМарки.Добавить();
					НоваяСтрока.Штрихкод             = НайденнаяСтрокаДерева.Штрихкод;
					НоваяСтрока.АлкогольнаяПродукция = НайденнаяСтрокаДерева.АлкогольнаяПродукция;
					НоваяСтрока.НомерЗаявки          = Сред(ШтриховойКод, 20, 12);
					НоваяСтрока.НомерМарки           = Сред(ШтриховойКод, 32, 6);
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли СтрДлина(ШтриховойКод) = 150 Тогда
			
			ПодстрокаВКоторойИщем = Сред(ШтриховойКод, 4, 11);
			
			Если СтрНайти(ПодстрокаВКоторойИщем, СтрокаПоиска) > 0 Тогда
				
				НайденнаяСтрокаДерева = ВладелецФормы.ДеревоМаркированнойПродукции.НайтиПоИдентификатору(ЭлементСоответствия.Значение);
				Если НайденнаяСтрокаДерева <> Неопределено Тогда
					
					НоваяСтрока = НайденныеАкцизныеМарки.Добавить();
					НоваяСтрока.Штрихкод    = НайденнаяСтрокаДерева.Штрихкод;
					НоваяСтрока.АлкогольнаяПродукция = НайденнаяСтрокаДерева.АлкогольнаяПродукция;
					НоваяСтрока.НомерЗаявки          = Сред(ШтриховойКод, 4, 3);
					НоваяСтрока.НомерМарки           = Сред(ШтриховойКод, 7, 8);
					
				КонецЕсли;
				
			КонецЕсли;
			
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьФорму(ДанныеСтроки)
	
	Если ДанныеСтроки <> Неопределено Тогда
		
		Закрыть(ДанныеСтроки.Штрихкод);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура НайденныеАкцизныеМаркиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.НайденныеАкцизныеМарки.ТекущиеДанные = Неопределено Тогда
	ИначеЕсли ТекущаяСтрока<>Элементы.НайденныеАкцизныеМарки.ТекущиеДанные.Штрихкод Тогда
		ТекущаяСтрока = Элементы.НайденныеАкцизныеМарки.ТекущиеДанные.Штрихкод;
		Если СтрДлина(ТекущаяСтрока) = 150 Тогда
			Элементы.НайденныеАкцизныеМаркиШтрихкод.Заголовок = НСтр("ru = 'Серия'");
		Иначе 
			Элементы.НайденныеАкцизныеМаркиШтрихкод.Заголовок = НСтр("ru = 'Номер заявки'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти