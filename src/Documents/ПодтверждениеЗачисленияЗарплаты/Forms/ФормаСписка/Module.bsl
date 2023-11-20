
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ПараметрыСозданияФормыСписка = ОбменСБанкамиКлиентСервер.ПараметрыСозданияФормыСписка();
	ПараметрыСозданияФормыСписка.ГруппаКоманд.Добавить = Истина;
	ПараметрыСозданияФормыСписка.ГруппаКоманд.Родитель = Элементы.КоманднаяПанельФормы;
	ПараметрыСозданияФормыСписка.СписокДокументов.МестоРасположения = "Дата";
	
 	ОбменСБанками.ПриСозданииФормыСпискаНаСервере(ЭтотОбъект, ПараметрыСозданияФормыСписка);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.ОбработатьОповещениеФормыСписка(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияДокументовЗачисленияЗарплаты"));
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.ПриВыбореСтрокиИзСпискаДокументов(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);	
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСБанками
&НаКлиенте
Процедура Подключаемый_ВыполнитьСинхронизациюДиректБанк(Команда)
    ОбменСБанкамиКлиент.СинхронизироватьСБанком();
 КонецПроцедуры
 
 &НаКлиенте
Процедура Подключаемый_ОбработатьСобытиеДиректБанк(
	Параметр1 = Неопределено,
	Параметр2 = Неопределено,
	Параметр3 = Неопределено)
	ОбменСБанкамиКлиент.ОбработатьСобытиеНаФормеСписка(Параметр1, Параметр2, Параметр3)
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСБанками

#КонецОбласти
