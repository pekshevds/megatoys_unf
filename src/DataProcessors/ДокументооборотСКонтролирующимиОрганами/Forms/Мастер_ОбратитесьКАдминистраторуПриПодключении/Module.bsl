
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализация(Параметры);
	УправлениеФормойПриСозданииНаСервере(Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	МультирежимКлиент.ПоказатьАдминистраторов(ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьИзменение(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСамостоятельно(Команда)
	
	Закрыть("Самостоятельно");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Инициализация(Параметры)
	
	Мультирежим.ТаблицаИзАдреса(ЭтотОбъект, Параметры.АдресТаблицы, "ТаблицаПользователей");
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормойПриСозданииНаСервере(Параметры)
	
	Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Для подключения к 1С-Отчетности обратитесь к '") ,
		Новый ФорматированнаяСтрока(НСтр("ru = 'администратору'"),,,,"администраторы"),
		".");
		
КонецПроцедуры


#КонецОбласти




