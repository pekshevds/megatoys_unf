
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Первоначальное заполнение объекта.
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Организация",	"Объект.Организация");
		ЗначенияДляЗаполнения.Вставить("Подразделение",	"Объект.Подразделение");
		ЗначенияДляЗаполнения.Вставить("Ответственный",	"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере("Объект");
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
 	ОбменСБанками.ПриСозданииФормыДокументаНаСервере(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
 	ОбменСБанкамиКлиент.ОбработатьОповещениеФормыДокумента(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ЭтотОбъект.ТолькоПросмотр = ОбъектЗафиксирован();
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)   
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
			ЭтотОбъект,
			ТекущийОбъект,
			ПараметрыЗаписи);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанками.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
	ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект);
	ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияОбновитьФиксациюВФорме();
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников", ПараметрыЗаписи, Объект.Ссылка);
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
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
	
	Если НЕ ЗначениеЗаполнено(Объект.ЗарплатныйПроект) Тогда
		Объект.ЗарплатныйПроект = ЗарплатныйПроектПоОрганизации(Объект.Организация);
	КонецЕсли;
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьОтображениеПредупрежденийТЧ_Сотрудники", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСтрокуНаСервере(ТекущиеДанные.НомерСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСБанками

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда)
	ОтменитьВсеИсправленияНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеСотрудников(Команда)
	ОбновитьВторичныеДанныеДокумента();
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
			Команда,
			ЭтотОбъект,
			Объект);
	КонецЕсли;
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// ЭлектронноеВзаимодействие.ОбменСБанками
&НаКлиенте
Процедура Подключаемый_ПриНажатииНаСсылкуДиректБанк()
     ОбменСБанкамиКлиент.ОткрытьАктуальныйЭД(Объект.Ссылка, ЭтотОбъект);
 КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСБанками

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтотОбъект, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение());
	
	ОбновитьВторичныеДанныеДокумента();
	
	ФиксацияОбновитьФиксациюВФорме();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗарплатныйПроектПоОрганизации(Организация)
	Возврат ОбменСБанкамиПоЗарплатнымПроектам.ЗарплатныйПроектПоОрганизации(Организация);
КонецФункции

&НаСервере
Процедура ЗаполнитьНаСервере(УчитыватьФиксацию = Ложь)
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтотОбъект, Объект);
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьСотрудников(ДокументОбъект.Дата);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуНаСервере(НомерСтроки)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьСотрудника(ДокументОбъект.Дата, НомерСтроки);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

#Область МеханизмФиксацииИзменений

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	Возврат ДокументОбъект.ОбъектЗафиксирован();
	
КонецФункции

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	ОписаниеЭлементаФормы.ПрефиксПутиТекущиеДанные = "Элементы.Сотрудники.ТекущиеДанные";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	ОписаниеФормы.Вставить("ФормаРедактируетсяПослеФиксации", Ложь);
	
	Возврат ОписаниеФормы;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ФиксацияЭлементыОбработчикаЗафиксироватьИзменение()
	
	ОписаниеЭлементов = Новый Соответствие;
	ОписаниеЭлементов.Вставить("ДатаЗакрытия", "ДатаЗакрытия");
	ОписаниеЭлементов.Вставить("ЛицевойСчет", "ЛицевойСчет");
	
	Возврат ОписаниеЭлементов;
	
КонецФункции

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыСтрок(Форма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтотОбъект);
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтотОбъект, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
	
КонецФункции

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента(МассивСотрудников = Неопределено)
	
	Если ОбъектЗафиксирован() Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = ФиксацияПодготовленныйДокумент();
	
	ДокументОбъект.ОбновитьТабличнуюЧастьФизическиеЛица(МассивСотрудников);
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтотОбъект, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	
	ТекущаяСтрока = ЭтотОбъект.Элементы["Сотрудники"].ТекущаяСтрока;
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтотОбъект, Элемент, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение(), ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеПредупрежденийТЧ_Сотрудники()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьОтображениеПредупрежденийТЧ(ЭтотОбъект, "Сотрудники", Элементы.Сотрудники.ТекущаяСтрока);
КонецПроцедуры

// Конец Механизм фиксации изменений.
////////////////////////////////////////////////////////////////////////////////

#КонецОбласти

#КонецОбласти
