 
#Область ОбработчикиСобытийФормы
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтеркампаниКлиентСервер.ИмяСобытияЗаписьНастройки() Тогда
		Элементы.Продавцы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПродавцыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Продавцы.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ОрганизацияПродавец", 
		ТекущаяСтрока.ОрганизацияПродавец, , , ЗначениеЗаполнено(ТекущаяСтрока.ОрганизацияПродавец));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОрганизацияПродавец", "Видимость", 
		НЕ ЗначениеЗаполнено(ТекущаяСтрока.ОрганизацияПродавец));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Приоритет", "Видимость", 
		ЗначениеЗаполнено(ТекущаяСтрока.ОрганизацияПродавец));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КнопкиСмещение", "Видимость", 
		ЗначениеЗаполнено(ТекущаяСтрока.ОрганизацияПродавец));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	Элементы.Продавцы.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СместитьВверх(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СместитьВверхНаСервере(ТекущаяСтрока.ОрганизацияВладелец, ТекущаяСтрока.ОрганизацияПродавец);
	
КонецПроцедуры

&НаСервере
Процедура СместитьВверхНаСервере(ОрганизацияВладелец, ОрганизацияПродавец)
	
	СместитьНастройку(ОрганизацияВладелец, ОрганизацияПродавец, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СместитьВниз(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СместитьВнизНаСервере(ТекущаяСтрока.ОрганизацияВладелец, ТекущаяСтрока.ОрганизацияПродавец);
	
КонецПроцедуры

&НаСервере
Процедура СместитьВнизНаСервере(ОрганизацияВладелец, ОрганизацияПродавец)
	
	СместитьНастройку(ОрганизацияВладелец, ОрганизацияПродавец, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
 
&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформление.Элементы.Очистить();
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Продавцы.ОрганизацияПродавец", Неопределено, ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "ПродавцыОрганизацияПродавец");
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", НСтр("ru = '<Все настройки>'"));
	
КонецПроцедуры

&НаСервере
Процедура СместитьНастройку(ОрганизацияВладелец, ОрганизацияПродавец, Вверх)
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями");
		ЭлементБлокировки.УстановитьЗначение("ОрганизацияПродавец", ОрганизацияПродавец);
		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.НастройкаПередачиТоваровМеждуОрганизациями.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОрганизацияПродавец.Установить(ОрганизацияПродавец);
		НаборЗаписей.Прочитать();
		ТаблицаНастроек = НаборЗаписей.Выгрузить();
		ТаблицаНастроек.Сортировать("Приоритет");
		Строка = ТаблицаНастроек.Найти(ОрганизацияВладелец, "ОрганизацияВладелец");
		Если Строка <> Неопределено Тогда
			Индекс = ТаблицаНастроек.Индекс(Строка);
			Если Вверх И Индекс = 0 Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;  
			Если НЕ Вверх И Индекс = ТаблицаНастроек.Количество() - 1 Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;  
			ТаблицаНастроек.Сдвинуть(Строка, ?(Вверх, -1, 1));
			Порядок = 0;
			Для каждого СтрокаНастроек Из ТаблицаНастроек Цикл
				Порядок = Порядок + 1;
				СтрокаНастроек.Приоритет = Порядок;
			КонецЦикла;
			НаборЗаписей.Загрузить(ТаблицаНастроек);
			НаборЗаписей.Записать(Истина);
			Элементы.Список.Обновить();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
 
 
