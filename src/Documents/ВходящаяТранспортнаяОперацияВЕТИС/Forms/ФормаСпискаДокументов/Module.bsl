
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ИнтеграцияВЕТИС.ПриСозданииНаСервереФормыСпискаДокументовВЕТИС(ЭтотОбъект, "Список", "");
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда
		//Отборы
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацииВЕТИС", ОрганизацииВЕТИС, СтруктураБыстрогоОтбора,Ложь);
		//Представления отбора по организации
		ОрганизацияВЕТИС = СтруктураБыстрогоОтбора.ОрганизацияВЕТИС;
		ОрганизацииВЕТИСПредставление = СтруктураБыстрогоОтбора.ОрганизацииВЕТИСПредставление;
		ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект);
		
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		ИнтеграцияВЕТИСКлиентСервер.ОрганизацияВЕТИСОтборПриИзменении(ЭтотОбъект,"Грузополучатель");
		
		Если ИнтеграцияВЕТИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюВЕТИСПриСозданииНаСервере(ДальнейшееДействиеВЕТИС, СтруктураБыстрогоОтбора) Тогда
			УстановитьОтборПоДальнейшемуДействиюСервер();
		КонецЕсли;
		
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействиеВЕТИС.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
	
	Если НЕ ПравоДоступа("Добавление",Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС) Тогда
		Элементы.СтраницаКОформлению.Видимость = Ложь;
	ИначеЕсли Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
	ВосстановитьНастройкиФормы();
	
	УстановитьВидимостьТаблицыКОформлению();
	
	УстановитьВидимостьДальнейшихДействий();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ИнтеграцияВЕТИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Оформлено",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Оформлено",,,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, Неопределено, Истина, "Оформлено",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено",,"Грузополучатель");
	
КонецПроцедуры


&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Оформлено",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Оформлено",,,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, Неопределено, Истина, "Оформлено",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено",,"Грузополучатель");
	
КонецПроцедуры


&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ОрганизацииВЕТИС, Истина, "КОформлению",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "КОформлению",,,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, Неопределено, Истина, "КОформлению",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению",,"Грузополучатель");
	
КонецПроцедуры


&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ОрганизацииВЕТИС, Истина, "КОформлению",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "КОформлению",,,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, Неопределено, Истина, "КОформлению",,"Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению",,"Грузополучатель");
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	ОтветственныйОтборПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусВЕТИСПриИзменении(Элемент)
	СтатусОтборПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеВЕТИСПриИзменении(Элемент)
	ДальнейшееДействиеОтборПриИзменении();
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ТТНПродукцияПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	УстановитьВидимостьТаблицыКОформлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Оформить(Команда)
	
	ОчиститьСообщения();
	
	МассивВСД = Новый Массив;
	Если ТТНПродукция = 0 Тогда //продукция
		Если НЕ ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокКОформлению, Ложь) Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ИдентификаторСтроки Из Элементы.СписокКОформлению.ВыделенныеСтроки Цикл
			МассивВСД.Добавить(ИдентификаторСтроки);
		КонецЦикла;
		Если НЕ ВозможностьВводаВходящейТранспортнойОперации(МассивВСД) Тогда
			Возврат;
		КонецЕсли;
	Иначе 
		Если НЕ ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокТТНКОформлению,Истина) Тогда
			Возврат;
		ИначеЕсли НЕ ПолучитьВСДПоОтбору(Элементы.СписокТТНКОформлению.ТекущиеДанные, МассивВСД) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр( "ru = 'Нет данных для заполнения'"),,"СписокТТНКОформлению");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Документ.ВходящаяТранспортнаяОперацияВЕТИС.ФормаОбъекта",
		Новый Структура("Основание",МассивВСД), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Архивировать(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(ЭтотОбъект, Элементы.СписокКОформлению, ИнтеграцияВЕТИСКлиент,
		ПредопределенноеЗначение("Документ.ВходящаяТранспортнаяОперацияВЕТИС.ПустаяСсылка"), "Ссылка");
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияВЕТИСКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияВЕТИСКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(
			ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВозможностьПеремещения(Команда)
	
	ПараметрыПередачи = ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи();
	ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеВозможностьПеремещения");
	
	ИнтеграцияВЕТИСКлиент.ПодготовитьСообщенияКПередаче(Элементы.Список, ПараметрыПередачи, ПравоИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ПараметрыПередачи = ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи();
	ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные");
	
	ИнтеграцияВЕТИСКлиент.ПодготовитьСообщенияКПередаче(Элементы.Список, ПараметрыПередачи, ПравоИзменения);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьВСДПоИдентификатору(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	
	ОрганизацииВЕТИСДляОбмена = ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(ЭтотОбъект);
	Если ОрганизацииВЕТИСДляОбмена <> Неопределено
		И ОрганизацииВЕТИСДляОбмена.Количество() = 1 Тогда
		
		ОрганизацияВЕТИСДляОбмена = ОрганизацииВЕТИСДляОбмена[0];
		ПараметрыОткрытия.Вставить("ХозяйствующийСубъект", ОрганизацияВЕТИСДляОбмена.Организация);
		
		Если ОрганизацияВЕТИСДляОбмена.Предприятия.Количество() = 1 Тогда
			ПараметрыОткрытия.Вставить("Предприятие", ОрганизацияВЕТИСДляОбмена.Предприятия[0]);
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ЗапросВСД",
		ПараметрыОткрытия,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(, ВыбраннаяСтрока[0]);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормыСписокТТНКОформлению

&НаКлиенте
Процедура СписокТТНКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьПредупреждение(,НСтр("ru = 'Открытие ветеринарно-сопроводительных документов возможно в режиме просмотра ""по ВСД""'"),30);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусВЕТИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.СтатусВЕТИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ВходящаяТранспортнаяОперацияВЕТИС.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусВЕТИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействиеВЕТИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ВходящаяТранспортнаяОперацияВЕТИС.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата",            Элементы.Дата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокКОформлению.Дата", Элементы.СписокКОформлениюДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДальнейшихДействий()
	
	КомандВГруппе = 2;
	
	ОперацииДопустимыхДействий = Документы.ВходящаяТранспортнаяОперацияВЕТИС.ОперацииДопустимыхДействий();
	Если ОперацииДопустимыхДействий.Получить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные) <> Неопределено Тогда
		Если НЕ ПользователиВЕТИС.ОперацияДоступнаПользователю(ОперацииДопустимыхДействий.Получить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные)) Тогда
			КомандВГруппе = КомандВГруппе - 1;
			Элементы.СписокПередатьДанные.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ОперацииДопустимыхДействий.Получить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеВозможностьПеремещения) <> Неопределено Тогда
		Если НЕ ПользователиВЕТИС.ОперацияДоступнаПользователю(ОперацииДопустимыхДействий.Получить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеВозможностьПеремещения)) Тогда
			КомандВГруппе = КомандВГруппе - 1;
			Элементы.СписокПроверитьВозможностьПеремещения.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если КомандВГруппе<2 Тогда
		Элементы.Действия.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьТаблицыКОформлению()
	
	Если ТТНПродукция Тогда
		Элементы.СписокТТНКОформлению.Видимость                      = Истина;
		Элементы.СписокТТНКОформлениюКоманднаяПанельГруппа.Видимость = Истина;
		Элементы.СписокКОформлению.Видимость                         = Ложь;
		Элементы.СписокКОформлениюКоманднаяПанельГруппа.Видимость    = Ложь;
	Иначе 
		Элементы.СписокТТНКОформлению.Видимость                      = Ложь;
		Элементы.СписокТТНКОформлениюКоманднаяПанельГруппа.Видимость = Ложь;
		Элементы.СписокКОформлению.Видимость                         = Истина;
		Элементы.СписокКОформлениюКоманднаяПанельГруппа.Видимость    = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ВходящаяТранспортнаяОперацияВЕТИСФормаСпискаДокументов", "ТТНПродукция", ТТНПродукция);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	ТТНПродукция = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ВходящаяТранспортнаяОперацияВЕТИСФормаСпискаДокументов", "ТТНПродукция", ТТНПродукция);
	
КонецПроцедуры

&НаСервере
Функция ВозможностьВводаВходящейТранспортнойОперации(Знач ВыделенныеСтроки)
	
	Если ВыделенныеСтроки = Неопределено Тогда
		Возврат Ложь;
	ИначеЕсли ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат Ложь;
	ИначеЕсли ВыделенныеСтроки.Количество() = 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	МассивВСД = Новый Массив;
	ДанныеОтбора = ИнтеграцияВЕТИСКлиентСервер.РеквизитыПодбораВСДВоВходящуюТранспортнуюОперацию();
	ЗаполнитьЗначенияСвойств(ДанныеОтбора,ВыделенныеСтроки[0]);
	ВыборкаВСД = ДоступныеВСД(ДанныеОтбора);
	Пока ВыборкаВСД.Следующий() Цикл 
		МассивВСД.Добавить(ВыборкаВСД.Ссылка);
	КонецЦикла;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл 
		Если МассивВСД.Найти(ВыделеннаяСтрока) = Неопределено Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Различаются ключевые реквизиты ВСД. Выделенные строки должны быть включены в различные входящие транспортные операции'"),,"СписокКОформлению");
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПолучитьВСДПоОтбору(Знач СтрокаОтбора, МассивВСД)
	
	МассивВСД = Новый Массив;
	ДанныеОтбора = ИнтеграцияВЕТИСКлиентСервер.РеквизитыПодбораВСДВоВходящуюТранспортнуюОперацию();
	ЗаполнитьЗначенияСвойств(ДанныеОтбора,СтрокаОтбора);
	ВыборкаВСД = ДоступныеВСД(ДанныеОтбора);
	Пока ВыборкаВСД.Следующий() Цикл 
		МассивВСД.Добавить(ВыборкаВСД.Ссылка);
	КонецЦикла;
	
	Возврат (МассивВСД.Количество()>0);
	
КонецФункции

#Область ОтборДальнейшиеДействия

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "СтатусВЕТИС",
	                                                                        СтатусВЕТИС,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусВЕТИС));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеОтборПриИзменении()
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив дальшейних действий
//
&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ВходящаяТранспортнаяОперацияВЕТИС.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ВходящаяТранспортнаяОперацияВЕТИС.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияВЕТИС.УстановитьОтборПоДальнейшемуДействию(Список,
	                                                     ДальнейшееДействиеВЕТИС,
	                                                     ВсеТребующиеДействия(),
	                                                     ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ДоступныеВСД(ДанныеОтбора)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГрузоотправительХозяйствующийСубъект", ДанныеОтбора.ГрузоотправительХозяйствующийСубъект);
	Запрос.УстановитьПараметр("ГрузоотправительПредприятие",          ДанныеОтбора.ГрузоотправительПредприятие);
	Запрос.УстановитьПараметр("ГрузополучательХозяйствующийСубъект",  ДанныеОтбора.ГрузополучательХозяйствующийСубъект);
	Запрос.УстановитьПараметр("ГрузополучательПредприятие",           ДанныеОтбора.ГрузополучательПредприятие);
	Запрос.УстановитьПараметр("ПеревозчикХозяйствующийСубъект",       ДанныеОтбора.ПеревозчикХозяйствующийСубъект);
	Запрос.УстановитьПараметр("СпособХранения",                       ДанныеОтбора.СпособХранения);
	Запрос.УстановитьПараметр("ТипТТН",                               ДанныеОтбора.ТипТТН);
	Запрос.УстановитьПараметр("СерияТТН",                             ДанныеОтбора.СерияТТН);
	Запрос.УстановитьПараметр("НомерТТН",                             ДанныеОтбора.НомерТТН);
	Запрос.УстановитьПараметр("ДатаТТН",                              ДанныеОтбора.ДатаТТН);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка                             КАК Ссылка,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Продукция                          КАК Продукция,
	|	ВетеринарноСопроводительныйДокументВЕТИС.КоличествоВЕТИС                    КАК КоличествоВЕТИС,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ЕдиницаИзмеренияВЕТИС              КАК ЕдиницаИзмеренияВЕТИС,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиСтрока                 КАК СрокГодностиСтрока,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиТочностьЗаполнения     КАК СрокГодностиТочностьЗаполнения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиНачалоПериода          КАК СрокГодностиНачалоПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиКонецПериода           КАК СрокГодностиКонецПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваСтрока             КАК ДатаПроизводстваСтрока,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваТочностьЗаполнения КАК ДатаПроизводстваТочностьЗаполнения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваНачалоПериода      КАК ДатаПроизводстваНачалоПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваКонецПериода       КАК ДатаПроизводстваКонецПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Маршрут.(
	|		Предприятие   КАК Предприятие,
	|		Адрес         КАК Адрес,
	|		ТипТранспорта КАК ТипТранспорта)                                        КАК Маршрут
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВетеринарноСопроводительныйДокументВЕТИС
	|ГДЕ
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительХозяйствующийСубъект = &ГрузоотправительХозяйствующийСубъект
	|	И ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительПредприятие          = &ГрузоотправительПредприятие
	|	И ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательХозяйствующийСубъект  = &ГрузополучательХозяйствующийСубъект
	|	И ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательПредприятие           = &ГрузополучательПредприятие
	|	И ВетеринарноСопроводительныйДокументВЕТИС.ПеревозчикХозяйствующийСубъект       = &ПеревозчикХозяйствующийСубъект
	|	И ВетеринарноСопроводительныйДокументВЕТИС.СпособХранения                       = &СпособХранения
	|	И ВетеринарноСопроводительныйДокументВЕТИС.СерияТТН                             = &СерияТТН
	|	И ВетеринарноСопроводительныйДокументВЕТИС.ДатаТТН                              = &ДатаТТН
	|	И ВетеринарноСопроводительныйДокументВЕТИС.НомерТТН                             = &НомерТТН
	|	И ВетеринарноСопроводительныйДокументВЕТИС.ТипТТН                               = &ТипТТН
	|	И ВетеринарноСопроводительныйДокументВЕТИС.Статус                               = ЗНАЧЕНИЕ(Перечисление.СтатусыВетеринарныхДокументовВЕТИС.Оформлен)";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

