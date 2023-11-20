
#Область ПрограммныйИнтерфейс

#Область Локализация

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма, в которой расположена команда
//  Команда                 - КомандаФормы     - команда формы
//  ДополнительныеПараметры - Структура        - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	Если Команда.Имя = "ПроверитьАкцизныеМарки"
		Или Команда.Имя = "ПроверитьАкцизныеМаркиЕГАИС" Тогда
		
		ОчиститьСообщения();
		ПроверкаИПодборПродукцииЕГАИСКлиент.ОткрытьФормуСканированияАлкогольнойПродукции(Форма);
		Возврат;
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры);
	
КонецПроцедуры

// Обрабатывает нажатие на гиперссылку со статусом обработки документа в ЕГАИС.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в которой произошло нажатие на гиперссылку,
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки,
//  СтандартнаяОбработка - Булево - признак стандартной (системной) обработки события.
//
Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
	Если НЕ ЭтоНавигационнаяСсылкаЕГАИС(НавигационнаяСсылкаФорматированнойСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиент.ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЭтоНавигационнаяСсылкаЕГАИС(ИмяСобытия) Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПослеЗаписи(Форма, ПараметрыЗаписи);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - ПолеВвода        - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
// 
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Вызывается при наступлении события "Выбор" в табличной части.
// Открывает форму выбранного элемента, если имя реквизита входит в массив имен.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма объекта,
// 	ТаблицаФормы - ТаблицаФормы - таблица в которой произошло событие,
// 	ВыбранноеПоле - ПолеФормы
Процедура ВыборЭлементаТабличнойЧастиОткрытьФормуЭлемента(Форма, ТаблицаФормы, ВыбранноеПоле) Экспорт
	
	Если ТаблицаФормы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивИмен = МассивИменРеквизитовФормыОткрытия();
	
	ИмяТабличнойЧасти = ТаблицаФормы.Имя;
	
	Для Каждого ИмяЭлемента Из МассивИмен Цикл
		
		Если Форма.Элементы.Найти(ИмяТабличнойЧасти + ИмяЭлемента) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Форма.Элементы[ИмяТабличнойЧасти + ИмяЭлемента] = ВыбранноеПоле
			И ЗначениеЗаполнено(ТаблицаФормы.ТекущиеДанные[ИмяЭлемента]) Тогда
			
			ПоказатьЗначение(, ТаблицаФормы.ТекущиеДанные[ИмяЭлемента]);
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОткрытьФормуВыбораАлкогольнойПродукции(ВладелецФормы, Реквизиты, СтандартнаяОбработка) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораАлкогольнойПродукции(ВладелецФормы, Реквизиты, СтандартнаяОбработка);
	
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Реквизиты) Тогда
		
		Для Каждого КлючИЗначение Из Реквизиты Цикл
			Если КлючИЗначение.Значение <> Неопределено Тогда
				ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЕсли;
		КонецЦикла;
		
		Если Реквизиты.Свойство("ВидАлкогольнойПродукции")
			И ЗначениеЗаполнено(Реквизиты.ВидАлкогольнойПродукции) Тогда
			ПараметрыОтбора.Вставить("ВидПродукции", Реквизиты.ВидАлкогольнойПродукции);
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Отбор",                ПараметрыОтбора);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ФормаВыбора", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры

// Открывает форму сопоставления классификатора ЕГАИС с номенклатурой.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы сопоставления,
//  ПараметрыОткрытияФормы - Структура - параметры, передаваемые в форму сопоставления.
//
Процедура ОткрытьФормуСопоставленияКлассификаторовЕГАИС(Форма, ОповещениеПриЗавершении = Неопределено, ПараметрыОткрытияФормы = Неопределено) Экспорт
	
	СтандартнаяОбработка = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСопоставленияКлассификаторовЕГАИС(
		Форма,
		ОповещениеПриЗавершении,
		ПараметрыОткрытияФормы,
		СтандартнаяОбработка);
		
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		ПараметрыОткрытияФормы = Новый Структура;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.СопоставлениеКлассификаторовЕГАИС.Форма.СопоставлениеКлассификаторовЕГАИС",
		ПараметрыОткрытияФормы,
		Форма,
		Форма.УникальныйИдентификатор,,,
		ОповещениеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


// Устанавливает формат редактирования полей Количество для документов ЕГАИС в зависимости от признака "Тип продукции"
//   номенклатуры ЕГАИС
//
// Параметры:
//   Форма                  - ФормаКлиентскогоПриложения     - источник вызова
//   НеупакованнаяПродукция - Булево               - признак редактируемой строки строки "Неупакованная продукция"
//   РеквизитыКоличество    - Строка               - элементы формы для установки формата редактирования (через запятую)
//
Процедура УстановитьФорматРедактированияПоляКоличество(Форма, НеупакованнаяПродукция,Знач РеквизитыКоличество) Экспорт
	
	РеквизитыКоличество = СтрРазделить(РеквизитыКоличество, ",", Ложь);
	Элементы = Форма.Элементы;
	ФорматРедактирования = ?(НеупакованнаяПродукция, "", "ЧДЦ=0;");
	Для Каждого РеквизитФормы Из РеквизитыКоличество Цикл
		Элементы[СокрЛП(РеквизитФормы)].ФорматРедактирования = ФорматРедактирования;
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает формат редактирования полей Количество для документов ЕГАИС в зависимости от признака "Тип продукции"
//   номенклатуры ЕГАИС. Если упаковка отличается от базовой (количество не совпадает с количеством ЕГАИС), формат для 
//   колонки "Количество упаковок" не применяется
//
// Параметры:
//   Форма               - ФормаКлиентскогоПриложения     - источник вызова
//   ДанныеСтроки        - ДанныеФормыСтруктура - данные строки табличной части с колонками "НеупакованнаяПродукция",
//                                                "Количество", "КоличествоУпаковок"
//   РеквизитыКоличество - Строка               - дополнительные элементы формы для установки формата редактирования (через запятую)
//
Процедура УстановитьФорматРедактированияПоляКоличествоСУчетомУпаковок(Форма, ДанныеСтроки, Знач РеквизитыКоличество = "") Экспорт
	
	Если ДанныеСтроки.Количество = ДанныеСтроки.КоличествоУпаковок Тогда
		РеквизитыКоличество = СтрРазделить(РеквизитыКоличество, ",", Ложь);
		РеквизитыКоличество.Добавить("ТоварыКоличествоУпаковок");
		РеквизитыКоличество = СтрСоединить(РеквизитыКоличество, ",");
	КонецЕсли;
	УстановитьФорматРедактированияПоляКоличество(Форма, ДанныеСтроки.НеупакованнаяПродукция, РеквизитыКоличество);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МассивИменРеквизитовФормыОткрытия()
	
	Массив = Новый Массив;
	Массив.Добавить("АлкогольнаяПродукция");
	Массив.Добавить("Справка2");
	
	Возврат Массив;
	
КонецФункции

Функция ЭтоНавигационнаяСсылкаЕГАИС(НавигационнаяСсылка)
	
	Возврат СтрНайти(НавигационнаяСсылка, "ЕГАИС") > 0;
	
КонецФункции

#КонецОбласти

