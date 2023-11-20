#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УзелОбмена = Параметры.УзелОбмена;
	ВыгружатьТолькоИзменения = Параметры.ВыгружатьТолькоИзменения;
	
	Если Параметры.Свойство("ОбменЗаказами") Тогда
		ОбменЗаказами = Параметры.ОбменЗаказами;
	КонецЕсли;
	Если Параметры.Свойство("ОбменТоварами") Тогда
		ОбменТоварами = Параметры.ОбменТоварами;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыполняетсяОбмен;
	ПодключитьОбработчикОжидания("ЗапуститьВыполнениеОбмена", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапуститьВыполнениеОбмена()
	
	ПараметрыОбмена = Новый Структура;
	ПараметрыОбмена.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыОбмена.Вставить("ВыгружатьТолькоИзменения", ВыгружатьТолькоИзменения);
	
	Если ОбменТоварами<>Неопределено Тогда
		ПараметрыОбмена.Вставить("ОбменТоварами", ОбменТоварами);
	КонецЕсли;
	Если ОбменЗаказами<>Неопределено Тогда
		ПараметрыОбмена.Вставить("ОбменЗаказами", ОбменЗаказами);
	КонецЕсли;
	
	ДлительнаяОперация = ВыполнитьОбменССайтомНаСервере(ПараметрыОбмена);
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОперацииЗагрузки", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииОперацииЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Выполнение обмена с сайтом'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()), "Ошибка", Результат.ПодробноеПредставлениеОшибки, , Истина);
			
		Элементы.ПоясняющийТекст.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполнение обмена с сайтом прервано по причине:
				|%1
				|Подробности см. в журнале регистрации.'"),
			Результат.КраткоеПредставлениеОшибки);
			
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОшибка;
			
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 ""%2""'"),
			Формат(ТекущаяДата(), "ДЛФ=DT"),
			УзелОбмена) 
		,,
		НСтр("ru = 'Обмен с сайтом завершен'"),
		БиблиотекаКартинок.Информация32);
		
	Оповестить("ЗавершенСеансОбменаССайтом", УзелОбмена);
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьОбменССайтомНаСервере(ПараметрыОбмена)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выполнение обмена с сайтом'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("ОбменССайтом.ВыполнитьОбменИнтерактивно", ПараметрыОбмена,
		ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
