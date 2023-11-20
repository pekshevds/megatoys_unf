
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КодНалоговогоОргана", КодНалоговогоОргана);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Проверка = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КодНалоговогоОргана);
	Если ЗначениеЗаполнено(Проверка)
			И СтрДлина(КодНалоговогоОргана) = 4 Тогда
			
			
			Закрыть(Формат(КодНалоговогоОргана, "ЧГ="));
			
		Иначе
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Код введен некорректно'"),,"КодНалоговогоОргана");
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
