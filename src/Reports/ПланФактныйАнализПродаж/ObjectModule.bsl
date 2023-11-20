#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские
//                                                                                 настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	
	// В зависимости от параметра отчета "ИзмерениеПланирования" устанавливаем заголовок поля "ОбъектПланирования":
	// Номенклатура / Менеджер и т.д.
	ЗначениеПараметраКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИзмерениеПланирования"));
	Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("ОбъектПланирования");
	Если ЗначениеПараметраКД <> Неопределено И Поле <> Неопределено Тогда
		Поле.Заголовок = Строка(ЗначениеПараметраКД.Значение);
	КонецЕсли;
	
	// В зависимости от параметра отчета "ПоказательДиаграммы" устанавливаем нужные ресурсы в диаграмме (количественные или суммовые)
	ЗначениеПараметраКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПоказательДиаграммы"));
	Если ЗначениеПараметраКД <> Неопределено Тогда
		
		Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
			
			Если ТипЗнч(ЭлементСтруктуры) <> Тип("ДиаграммаКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементСтруктуры.Выбор.Элементы.Очистить();
			
			ВыбранноеПолеКД = ЭлементСтруктуры.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных(ЗначениеПараметраКД.Значение + "ФактПрогноз");
			ВыбранноеПолеКД.Использование = Истина;
			
			ВыбранноеПолеКД = ЭлементСтруктуры.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных(ЗначениеПараметраКД.Значение + "Факт");
			ВыбранноеПолеКД.Использование = Истина;
			
			ВыбранноеПолеКД = ЭлементСтруктуры.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных(ЗначениеПараметраКД.Значение + "План");
			ВыбранноеПолеКД.Использование = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Стандартная обработка отчета
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	// Изменим цвета серий диаграммы
	Для Каждого Рисунок Из ДокументРезультат.Рисунки Цикл
		
		Если Рисунок.ТипРисунка <> ТипРисункаТабличногоДокумента.Диаграмма Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Серия Из Рисунок.Объект.Серии Цикл
			Если СтрНайти(ВРег(Серия.Текст), ВРег("Прогноз")) > 0 Тогда
				Серия.Цвет = Новый Цвет(230, 210, 200);
			ИначеЕсли СтрНайти(ВРег(Серия.Текст), ВРег("Факт")) > 0 Тогда
				Серия.Цвет = Новый Цвет(255, 202, 125);
			ИначеЕсли СтрНайти(ВРег(Серия.Текст), ВРег("План")) > 0 Тогда
				Серия.Цвет = Новый Цвет(142, 201, 249);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		НастройкиТекВарианта.Значение.Теги = НСтр("ru = 'Компания,Продажи,CRM'");
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "ОбъектПланирования", "Справочник.Номенклатура");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "ОбъектПланирования", "Справочник.КатегорииНоменклатуры");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "ОбъектПланирования", "Справочник.Сотрудники");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли