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

// Обработчик контекстного открытия отчета
//
// Параметры:
//  Объект		 - Произвольный	 - Источник контекстного открытия отчета
//  ПолеСвязи	 - Строка		 - Поле из настроек связи контекстного открытия
//  Отборы		 - Структура	 - Изменяемая структура отборов отчета
//  Отказ		 - Булево		 - Признак отмены открытия отчета
//
Процедура ПриКонтекстномОткрытии(Объект, ПолеСвязи, Отборы, Отказ) Экспорт
	
	Если ПолеСвязи = "Контрагент" Тогда
		Отборы.Вставить(ПолеСвязи, Объект.Контрагент);
	КонецЕсли;
	
	Если ПолеСвязи = "Договор" Тогда
		Отборы.Вставить(ПолеСвязи, Объект.Договор);
	КонецЕсли;
	
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
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);	
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
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Ведомость"].Теги = НСтр("ru = 'Запасы,Склады,Закупки,Товары,Номенклатура,Себестоимость'");
	НастройкиВариантов["Остатки"].Теги = НСтр("ru = 'Запасы,Склады,Закупки,Товары,Номенклатура,Себестоимость'");
	НастройкиВариантов["ИсторияРезервов"].Теги = НСтр("ru = 'Запасы,Склады,Товары,Номенклатура,Резерв'");
	НастройкиВариантов["ОстаткиРезервов"].Теги = НСтр("ru = 'Запасы,Склады,Товары,Номенклатура,Резерв'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Ведомость"].СвязанныеПоля, "СтруктурнаяЕдиница", 
		"Справочник.СтруктурныеЕдиницы");
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Ведомость"].СвязанныеПоля, "ЗаказПокупателя", 
		"Документ.ЗаказПокупателя");
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Ведомость"].СвязанныеПоля, "", "Обработка.ЗакрытиеМесяца", , 
		Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ИсторияРезервов"].СвязанныеПоля, "Номенклатура", 
		"Справочник.Номенклатура");
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ИсторияРезервов"].СвязанныеПоля, "ЗаказПокупателя", 
		"Документ.ЗаказПокупателя", , , Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ОстаткиРезервов"].СвязанныеПоля, "ЗаказПокупателя", 
		"Документ.ЗаказПокупателя", , , Истина);
	
КонецПроцедуры
 
#КонецОбласти 

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли