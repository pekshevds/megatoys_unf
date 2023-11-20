
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Номенклатура") Тогда
		
		Номенклатура = Параметры.Отбор.Номенклатура;
		
		Если НЕ Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Управление запасами используется только для запасов'");
			Элементы.Список.ТолькоПросмотр = Истина;
			
		// Наборы
		ИначеЕсли Номенклатура.ЭтоНабор Тогда
			
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Управление запасами недоступно для наборов'");
			Элементы.Список.ТолькоПросмотр = Истина;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
