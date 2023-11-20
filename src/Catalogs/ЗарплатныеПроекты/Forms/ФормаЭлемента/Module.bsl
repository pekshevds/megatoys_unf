#Область ОписаниеПеременных

&НаКлиенте
Перем БылаСтруктураНаименования;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		Объект.Валюта = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		Объект.Наименование = "";
		
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
		
	КонецЕсли;
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	ИспользоватьТиповойОбмен = ОбменСБанкамиПоЗарплатнымПроектам.ИспользоватьТиповойЭОИСБанком(СсылкаНаОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	НастроитьПолеНомерДоговора(ЭтотОбъект);
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
	УстановитьДоступностьЭлементовЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СсылкаНаОбъект = ТекущийОбъект.Ссылка;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	НастроитьПолеНомерДоговора(ЭтотОбъект);
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
	УстановитьДоступностьЭлементовЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	БылаСтруктураНаименования = СтруктураНаименования();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ИспользоватьЭлектронныйДокументооборотСБанком И ИспользоватьТиповойОбмен Тогда
		Объект.НомерДоговора = Лев(Объект.НомерДоговора, Элементы.НомерДоговора.ОграничениеТипа.КвалификаторыСтроки.Длина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИспользованиеЭлектронногоОбменаСБанкамиПрежнее = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныйОбменСБанкамиПоЗарплатнымПроектам");
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ИспользованиеЭлектронногоОбменаСБанками = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныйОбменСБанкамиПоЗарплатнымПроектам");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененЗарплатныйПроект", Объект.Ссылка);
	
	Если ИспользованиеЭлектронногоОбменаСБанкамиПрежнее <> ИспользованиеЭлектронногоОбменаСБанками Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
	    ОбновитьЭлементыДополнительныхРеквизитов();
	    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства	

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
	СформироватьАвтоНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныйДокументооборотСБанкомПриИзменении(Элемент)
	НастроитьПолеНомерДоговора(ЭтотОбъект);
	УстановитьДоступностьЭлементовЭДО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ФорматФайлаПриИзменении(Элемент)
	НастроитьПолеНомерДоговора(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НомерДоговораПриИзменении(Элемент)
	
	Объект.НомерДоговора = СокрЛП(Объект.НомерДоговора);
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДоговораПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭДОНажатие(Элемент)
	Обработчик = Новый ОписаниеОповещения("ПослеСозданияНастройкиЭДО", ЭтотОбъект);
	ОбменСБанкамиКлиент.ОткрытьСоздатьНастройкуОбмена(Объект.Организация, Объект.Банк, Объект.РасчетныйСчет, Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура ПослеСозданияНастройкиЭДО(НастройкаЭДО, Параметры) Экспорт
	Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(Объект.Организация, Объект.Банк);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьПолеНомерДоговора(Форма)
	
	Если Форма.Объект.ИспользоватьЭлектронныйДокументооборотСБанком И Форма.ИспользоватьТиповойОбмен Тогда
		МаксимальнаяДлинаНомераДоговора = 
			ОбменСБанкамиПоЗарплатнымПроектамКлиентСервер.МаксимальнаяДлинаНомераДоговора(Форма.Объект.ФорматФайла);
		Подсказка = 
			СтрШаблон(
				НСтр("ru = '%1 допускает длину номера договора не более %2 символов.'"),
				Форма.Объект.ФорматФайла,
				МаксимальнаяДлинаНомераДоговора);
	Иначе
		МаксимальнаяДлинаНомераДоговора = 40;
		Подсказка = "";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "НомерДоговора", 
		"ОграничениеТипа", Новый ОписаниеТипов("Строка",,,Новый КвалификаторыСтроки(МаксимальнаяДлинаНомераДоговора)));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "НомерДоговора", "Подсказка", Подсказка);
	
КонецПроцедуры	
	
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовЭДО(Форма)
	
	ИспользоватьЭлектронныйДокументооборотСБанком = Форма.Объект.ИспользоватьЭлектронныйДокументооборотСБанком;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "НастройкаЭДО", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ЭлектронныйДокументооборотСБанком", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
		
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		Форма, "Банк", ИспользоватьЭлектронныйДокументооборотСБанком);
		
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		Форма, "ФорматФайла", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		Форма, "КодировкаФайла", ИспользоватьЭлектронныйДокументооборотСБанком);
		
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьТаблицыФормы(
		Форма, "СистемыРасчетовПоБанковскимКартам", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаТаблицыФормы(
		Форма, "СистемыРасчетовПоБанковскимКартамСистемаРасчетовПоБанковскимКартам", ИспользоватьЭлектронныйДокументооборотСБанком);
		
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами()
	
	ВидимостьПрямогоОбмена = ВидимостьПрямогоОбмена();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаЭДО", "Видимость", ВидимостьПрямогоОбмена);
	
	ЗаголовокНадписи = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(Объект.Организация, Объект.Банк);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаЭДО", "Заголовок", ЗаголовокНадписи);
	
КонецПроцедуры

&НаСервере
Функция ВидимостьПрямогоОбмена()
	
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Банк) Тогда
		БИКБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Банк, "Код");
		ВидимостьПрямогоОбмена = ОбменСБанками.ВозможенПрямойОбменСБанком(БИКБанка, 2);
	Иначе
		ВидимостьПрямогоОбмена = Ложь;
	КонецЕсли;
	
	Возврат ВидимостьПрямогоОбмена;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНаименованияЗарплатногоПроекта(СтруктураНаименования)
	
	Представление = "";
	Если ЗначениеЗаполнено(СтруктураНаименования.Банк) И ЗначениеЗаполнено(СтруктураНаименования.НомерДоговора) И ЗначениеЗаполнено(СтруктураНаименования.ДатаДоговора) Тогда
		Представление = СтрШаблон(
			НСтр("ru = '%1 №%2 от %3 г.'"), 
			СтруктураНаименования.Банк,
			СтруктураНаименования.НомерДоговора,
			Формат(СтруктураНаименования.ДатаДоговора, "ДЛФ=Д"));
	ИначеЕсли ЗначениеЗаполнено(СтруктураНаименования.Банк) И ЗначениеЗаполнено(СтруктураНаименования.НомерДоговора) Тогда
		Представление = СтрШаблон(
			НСтр("ru = '%1 №%2'"), 
			СтруктураНаименования.Банк,
			СтруктураНаименования.НомерДоговора);
	ИначеЕсли ЗначениеЗаполнено(СтруктураНаименования.Банк) Тогда
		Представление = Строка(СтруктураНаименования.Банк);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Функция СтруктураНаименования()
	
	Возврат Новый Структура("Банк, НомерДоговора, ДатаДоговора", Объект.Банк, Объект.НомерДоговора, Объект.ДатаДоговора);
	
КонецФункции

&НаКлиенте
Процедура СформироватьАвтоНаименование()
	
	ПрежнееНаименование = ПредставлениеНаименованияЗарплатногоПроекта(БылаСтруктураНаименования);
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) 
		Или ПрежнееНаименование = Объект.Наименование Тогда
		Объект.Наименование = ПредставлениеНаименованияЗарплатногоПроекта(СтруктураНаименования());
	КонецЕсли;
	
	БылаСтруктураНаименования = СтруктураНаименования();
	
КонецПроцедуры

#Область ПроцедурыПодсистемыСвойств

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
