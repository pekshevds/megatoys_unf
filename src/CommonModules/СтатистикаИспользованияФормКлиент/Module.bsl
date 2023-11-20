#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийДляПодключения

// Добавляет статистику, вызывается из обработчика ПриЗакрытии формы
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения
//  Завершение работы    - Булево
//
Процедура ПриЗакрытии(Форма, ЗавершениеРаботы) Экспорт
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПараметра = ИмяПараметраКлиентскогоКэша();
	
	Если СтатистикаИспользованияФормКлиентПовтИсп.ИспользуетсяБизнесСтатистикаЦентраМониторинга()
		И ТипЗнч(ПараметрыПриложения[ИмяПараметра]) = Тип("СписокЗначений")
		И ПараметрыПриложения[ИмяПараметра].Количество() > 0 Тогда
		
		СтатистикаИспользованияФормВызовСервера.ЗаписатьСтатистику(ПараметрыПриложения[ИмяПараметра]);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет статистику вызова события полученного элемента
//
// Параметры:
//  Форма          - ФормаКлиентскогоПриложения       - Форма - источник события
//  Элемент        - ВсеЭлементыФормы                 - КнопкаФормы, ДекорацияФормы, ПолеФормы и т.д.
//  ИмяСобытия     - Строка                           - Описание события
//
Процедура ПриИнтерактивномДействии(Форма, Элемент, ИмяСобытия) Экспорт
	
	Если СтатистикаИспользованияФормКлиентПовтИсп.ИспользуетсяБизнесСтатистикаЦентраМониторинга() Тогда
		
		ИмяОперации = СформироватьИмяОперации(Форма, Элемент.Имя, ИмяСобытия);
		ДобавитьСтатистикуИспользованияФормы(ИмяОперации);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Процедура добавляет статистику в клиентский кэш для последующего сохранения на сервере
//
// Параметры:
//  ИмяОперации				 - Строка	 - имя операции бизнес-статистики. См. ЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики()
//  СохранитьНаСервереСразу	 - Булево	 - признак сброса накопленного клиентского кэша на сервер
//
Процедура ДобавитьСтатистикуИспользованияФормы(знач ИмяОперации, знач СохранитьНаСервереСразу = Ложь) Экспорт
	
	ИмяПараметра = ИмяПараметраКлиентскогоКэша();
	
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
	КонецЕсли;
	
	Если ПараметрыПриложения[ИмяПараметра].НайтиПоЗначению(ИмяОперации) = Неопределено Тогда
		ПараметрыПриложения[ИмяПараметра].Добавить(ИмяОперации);
	КонецЕсли;
	
	Если СохранитьНаСервереСразу Тогда
		СтатистикаИспользованияФормВызовСервера.ЗаписатьСтатистику(ПараметрыПриложения[ИмяПараметра]);
	КонецЕсли;
	
КонецПроцедуры

// Процедура сохраняет статистику нажатия команды, если она была вызвана из форм, подключенных к сбору статистики
//
// Параметры:
//  ИмяКоманды			 - Строка	 - имя команды, будет использовано в ключе бизнес-операции
//  ФормаВладелец		 - ФормаКлиентскогоПриложения	 - форма, из которой вызвана команда
//  ОснованиеСоздания	 - ЛюбаяСсылка, Произвольный	 - Параметр расширения управляемой формы для объектов. См. Основание в синтакс-помощнике.
//
Процедура ПроверитьЗаписатьСтатистикуКоманды(знач ИмяКоманды, знач ФормаВладелец, знач ОснованиеСоздания = Неопределено) Экспорт
	
	Если СтатистикаИспользованияФормКлиентПовтИсп.ИспользуетсяБизнесСтатистикаЦентраМониторинга()
		И ПроверитьПараметрыКоманды(ФормаВладелец, ОснованиеСоздания) Тогда
		
		ИмяОперации = СформироватьИмяОперации(ФормаВладелец, ИмяКоманды, "Нажатие");
		ДобавитьСтатистикуИспользованияФормы(ИмяОперации);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура сохраняет статистику нажатия команд печати, сформированных подсистемой Печать.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - форма, из которой вызвана команда
//  Команда	 - КомандаФормы	 - нажатая команда печати
//
Процедура ДобавитьСтатистикуПодключаемойКоманды(Форма, Команда) Экспорт
	
	Если СтатистикаИспользованияФормКлиентПовтИсп.ИспользуетсяБизнесСтатистикаЦентраМониторинга()
		И ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		
		ОписаниеКоманды = ПодключаемыеКомандыКлиентПовтИсп.ОписаниеКоманды(Команда.Имя, Форма.ПараметрыПодключаемыхКоманд.АдресТаблицыКоманд);
		ИмяОперации = СформироватьИмяОперации(Форма, ОписаниеКоманды.Идентификатор, "Нажатие");
		ДобавитьСтатистикуИспользованияФормы(ИмяОперации);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьПараметрыКоманды(ФормаВладелец, ОснованиеСоздания)
	
	ФормыДляСбораСтатистики = Новый Массив;
	
	ФормыДляСбораСтатистики.Добавить("Документ.ЗаказПокупателя.Форма.ФормаДокумента");
	ФормыДляСбораСтатистики.Добавить("Документ.РасходнаяНакладная.Форма.ФормаДокумента");
	
	ТипыОснованийСозданияДляСтатистики = Новый Массив;
	ТипыОснованийСозданияДляСтатистики.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
	ТипыОснованийСозданияДляСтатистики.Добавить(Тип("ДокументСсылка.РасходнаяНакладная"));
	ТипыОснованийСозданияДляСтатистики = Новый ОписаниеТипов(ТипыОснованийСозданияДляСтатистики);
	
	Результат = СтатистикаИспользованияФормКлиентПовтИсп.ИспользуетсяБизнесСтатистикаЦентраМониторинга()
		И ТипЗнч(ФормаВладелец) = Тип("ФормаКлиентскогоПриложения")
		И ФормыДляСбораСтатистики.Найти(ФормаВладелец.ИмяФормы) <> Неопределено
		И (ОснованиеСоздания = Неопределено Или ТипыОснованийСозданияДляСтатистики.СодержитТип(ТипЗнч(ОснованиеСоздания)));
		
	Возврат Результат;
	
КонецФункции

Функция ИмяПараметраКлиентскогоКэша()
	
	Возврат "УправлениеНебольшойФирмой.СтатистикаИспользованияФорм";
	
КонецФункции

Функция СформироватьИмяОперации(Форма, ИмяЭлемента, ИмяСобытия)
	
	ШаблонИмениОперации = "[КлючФормы].[ИмяЭлемента].[ИмяСобытия]";
	
	ВставляемыеЗначения = Новый Структура("КлючФормы, ИмяЭлемента, ИмяСобытия");
	ВставляемыеЗначения.КлючФормы	= СформироватьКлючФормы(Форма);
	ВставляемыеЗначения.ИмяЭлемента	= ИмяЭлемента;
	ВставляемыеЗначения.ИмяСобытия	= ИмяСобытия;
	
	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонИмениОперации, ВставляемыеЗначения);
	
КонецФункции

Функция СформироватьКлючФормы(Форма)
	
	КлючНазначения = Форма.КлючНазначенияИспользования;
	
	// Вырежем вставку в ключ назначения использования от подсистемы БСП "Свойства"
	Поз = СтрНайти(КлючНазначения, "КлючНаборовСвойств");
	Если Поз > 0 Тогда
		КлючНазначения = Лев(КлючНазначения, Поз-1);
	КонецЕсли;
	
	Возврат Форма.ИмяФормы + ?(ПустаяСтрока(КлючНазначения), "", "/" + КлючНазначения);
	
КонецФункции

#КонецОбласти
