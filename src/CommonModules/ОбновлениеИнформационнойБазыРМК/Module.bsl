
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаРабочегоМестаКассира";
	Описание.Версия = ОбщегоНазначенияРМК.ВерсияБиблиотеки();
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре.
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно".
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "1.0.7.128";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыРМК.ЗаполнитьСпособПечатиТоварногоЧека";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "1.0.8.42";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыРМК.ОбновитьПризнакиВидовОплатВНастройкахРМК";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "1.0.9.17";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыРМК.ПеренестиБыстрыеТоварыИзНастроекВПалитруТоваров";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.10.21";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыРМК.ЗаменитьКомандуОткрытияДенежногоЯщикаВГорячихКлавишах";
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример:
//  // Пример обхода выполненных обработчиков обновления:
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример:
//  // Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику".
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСпособПечатиТоварногоЧека() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиРабочегоМестаКассира.Ссылка КАК Настройки
	|ИЗ
	|	Справочник.НастройкиРабочегоМестаКассира КАК НастройкиРабочегоМестаКассира
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ПО НастройкиРабочегоМестаКассира.РабочееМесто = ПодключаемоеОборудование.РабочееМесто
	|ГДЕ
	|	НастройкиРабочегоМестаКассира.ПометкаУдаления
	|	И ЕСТЬNULL(ПодключаемоеОборудование.ТипОборудования, ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ПустаяСсылка)) = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ПринтерЧеков)
	|	И ЕСТЬNULL(ПодключаемоеОборудование.УстройствоИспользуется, ЛОЖЬ)
	|	И НЕ ЕСТЬNULL(ПодключаемоеОборудование.ПометкаУдаления, ЛОЖЬ)");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.НастройкиРабочегоМестаКассира");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Настройки);
			Блокировка.Заблокировать();
			
			СправочникОбъект = Выборка.Настройки.ПолучитьОбъект();
			СправочникОбъект.СпособФормированияТоварногоЧека = 2;
			СправочникОбъект.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ТекстСообщения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ИмяСобытия = НСтр("ru = 'Ошибка при изменении данных справочника.'", КодОсновногоЯзыка);
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				Выборка.Настройки,
				,
				ТекстСообщения);
				
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьПризнакиВидовОплатВНастройкахРМК() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	НастройкиРабочегоМестаКассира.Ссылка КАК НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРабочегоМестаКассира КАК НастройкиРабочегоМестаКассира");
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.НастройкиРабочегоМестаКассира");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.НастройкаРМК);
			Блокировка.Заблокировать();
			
			ОбъектНастройкаРМК = Выборка.НастройкаРМК.ПолучитьОбъект();
			ОбъектНастройкаРМК.ИспользоватьОплатуНаличными = Истина;
			
			ОбщегоНазначенияРМКПереопределяемый.ОбновитьНастройкиПризнаковВидовОплат(ОбъектНастройкаРМК);
			
			ОбъектНастройкаРМК.Записать();
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ТекстСообщения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ИмяСобытия = НСтр("ru = 'Ошибка при обновлении настроек РМК'", КодОсновногоЯзыка);
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				Выборка.НастройкаРМК,
				,
				ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПеренестиБыстрыеТоварыИзНастроекВПалитруТоваров() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиРабочегоМестаКассираБыстрыеТовары.Ссылка КАК НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРабочегоМестаКассира.БыстрыеТовары КАК НастройкиРабочегоМестаКассираБыстрыеТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкиРабочегоМестаКассираБыстрыеТовары.Ссылка");
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НастройкаРМК.БыстрыеТовары.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.НастройкиРабочегоМестаКассира");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.НастройкаРМК);
			Блокировка.Заблокировать();
			
			ОбъектНастройкаРМК = Выборка.НастройкаРМК.ПолучитьОбъект();
			БыстрыеТовары = ОбъектНастройкаРМК.БыстрыеТовары;
			
			НоваяПалитра = Справочники.ПалитраТоваровРМК.СоздатьЭлемент();
			НоваяПалитра.Наименование = НСтр("ru = 'Палитра быстрых товаров'");
			НоваяПалитра.ШрифтЭлементовПодбора = ОбщегоНазначения.ЗначениеВСтрокуXML(ШрифтыСтиля.ШрифтОбычныйПолужирный12РМК);
			НоваяПалитра.КоличествоЭлементовВРяду = 4;
			НоваяПалитра.КоличествоРядов = 3;
			НоваяПалитра.ВысотаЭлемента = 5;
			
			СоставПалитры = НоваяПалитра.Состав;
			
			Для Каждого СтрокаТовара Из БыстрыеТовары Цикл
				
				СтрокаПалитры = СоставПалитры.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПалитры, СтрокаТовара);
				СтрокаПалитры.ИндексПозиции = СтрокаТовара.НомерСтроки;
				
				СтрокаПалитры.ХарактеристикиИспользуются =
					ОбщегоНазначенияРМК.ТребуетсяВводХарактеристикиДляНоменклатуры(СтрокаПалитры.Номенклатура);
				
				Если ЗначениеЗаполнено(СтрокаПалитры.Характеристика) Тогда
					СтрокаПалитры.ИмяЭлемента = СтрШаблон(НСтр("ru = '%1 %2'"), СтрокаПалитры.Номенклатура, СтрокаПалитры.Характеристика);
				Иначе
					СтрокаПалитры.ИмяЭлемента = СтрШаблон(НСтр("ru = '%1'"), СтрокаПалитры.Номенклатура);
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(СтрокаТовара.ЦветФона) Тогда
					СтрокаПалитры.ЦветФона = ОбщегоНазначения.ЗначениеВСтрокуXML(ЦветаСтиля.ЦветАктивнойКнопкиРМК);
				КонецЕсли;
				
				СтрокаПалитры.ЦветШрифта = ОбщегоНазначения.ЗначениеВСтрокуXML(Новый Цвет(0, 0, 0));
				СтрокаПалитры.Шрифт = НоваяПалитра.ШрифтЭлементовПодбора;
				
			КонецЦикла;
			
			НоваяПалитра.Записать();
			
			ОбъектНастройкаРМК.СтруктураБыстрыхТоваров = НоваяПалитра.Ссылка;
			ОбъектНастройкаРМК.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ТекстСообщения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ИмяСобытия = НСтр("ru = 'Ошибка при обновлении настроек РМК'", КодОсновногоЯзыка);
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				Выборка.НастройкаРМК,
				,
				ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьКомандуОткрытияДенежногоЯщикаВГорячихКлавишах() Экспорт
	
	ИмяСтаройКнопки = "ОткрытьДенежныйЯщикПриВыдачеНаличных";
	ИмяНовойКнопки = "ОткрытьДенежныйЯщик";
	
	ЗапросНастроекРМК = Новый Запрос;
	ЗапросНастроекРМК.Текст = 
	"ВЫБРАТЬ
	|	НастройкиРабочегоМестаКассираГорячиеКлавиши.Ссылка КАК НастройкаРМК
	|ИЗ
	|	Справочник.НастройкиРабочегоМестаКассира.ГорячиеКлавиши КАК НастройкиРабочегоМестаКассираГорячиеКлавиши
	|ГДЕ
	|	НастройкиРабочегоМестаКассираГорячиеКлавиши.ИмяКнопки = &ИмяСтаройКнопки";
	ЗапросНастроекРМК.УстановитьПараметр("ИмяСтаройКнопки", ИмяСтаройКнопки);
	
	ВыборкаНастроекРМК = ЗапросНастроекРМК.Выполнить().Выбрать();
	Пока ВыборкаНастроекРМК.Следующий() Цикл
		НастройкаРМКОбъект = ВыборкаНастроекРМК.НастройкаРМК.ПолучитьОбъект();
		СтрокаНовойКнопки = НастройкаРМКОбъект.ГорячиеКлавиши.Найти(ИмяНовойКнопки, "ИмяКнопки");
		СтрокаСтаройКнопки = НастройкаРМКОбъект.ГорячиеКлавиши.Найти(ИмяСтаройКнопки, "ИмяКнопки");
		Если СтрокаНовойКнопки = Неопределено Тогда
			СтрокаСтаройКнопки.ИмяКнопки = ИмяНовойКнопки;
		Иначе
			НастройкаРМКОбъект.ГорячиеКлавиши.Удалить(СтрокаСтаройКнопки);
		КонецЕсли;
		НастройкаРМКОбъект.ОбменДанными.Загрузка = Истина;
		НастройкаРМКОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
