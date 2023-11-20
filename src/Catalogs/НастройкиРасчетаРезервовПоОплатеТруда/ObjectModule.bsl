
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытийФормы

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДублирующиесяНастройки(Отказ);
	
	Если Не Отказ Тогда
		ПроверитьИспользованиеРезерва(Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПроверитьИспользованиеВидаРезерва(Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		СинхронизироватьПометкуУдаления(ПометкаУдаления, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РезервыПоОплатеТруда.НастройкиРасчетаРезервовПоОплатеТрудаОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено
		И ДанныеЗаполнения.Свойство("Организация")
		И ЗначениеЗаполнено(ДанныеЗаполнения.Организация) Тогда
		ПроверитьДоступностьЗаписиНастройки(ДанныеЗаполнения.Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПроверитьДоступностьЗаписиНастройки(ОбъектКопирования.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СинхронизироватьПометкуУдаления(ПометкаУдаления, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ГоловнаяОрганизация");
	
	Если Организация <> ГоловнаяОрганизация Тогда
		Если ДополнительныеСвойства.Свойство("СинхронизацияПометкиУдаления") Тогда
			Возврат;
		КонецЕсли;
		Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГоловнаяОрганизация, "ПометкаУдаления") Тогда
			Отказ = Истина;
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Добавлять или удалять настройки можно только для головной организации ""%1""'"), ГоловнаяОрганизация);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
	КонецЕсли;
	
	Организации = РезервыПоОплатеТруда.ВсяОрганизация(ГоловнаяОрганизация);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("Организации",         Организации);
	Запрос.УстановитьПараметр("Резерв",              Резерв);
	Запрос.УстановитьПараметр("ВидРезерва",          ВидРезерва);
	Запрос.УстановитьПараметр("НачалоПериода",       НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",        КонецПериода);
	Запрос.УстановитьПараметр("ПометкаУдаления",     ПометкаУдаления);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Организация КАК Организация,
	|	НастройкиРасчетаРезервовПоОплатеТруда.ПометкаУдаления КАК ПометкаУдаления,
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НастройкиРасчетаРезервовПоОплатеТруда КАК НастройкиРасчетаРезервовПоОплатеТруда
	|ГДЕ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Резерв = &Резерв
	|	И НастройкиРасчетаРезервовПоОплатеТруда.ВидРезерва = &ВидРезерва
	|	И НастройкиРасчетаРезервовПоОплатеТруда.НачалоПериода = &НачалоПериода
	|	И НастройкиРасчетаРезервовПоОплатеТруда.КонецПериода = &КонецПериода
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Организация В(&Организации)
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Организация <> &ГоловнаяОрганизация
	|	И НастройкиРасчетаРезервовПоОплатеТруда.ПометкаУдаления <> &ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.ПометкаУдаления = ПометкаУдаления;
		СправочникОбъект.ДополнительныеСвойства.Вставить("СинхронизацияПометкиУдаления", Истина);
		СправочникОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДоступностьЗаписиНастройки(ОрганизацияНастройки)
	
	ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОрганизацияНастройки, "ГоловнаяОрганизация");
	Если ОрганизацияНастройки <> ГоловнаяОрганизация Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Добавлять или удалять настройки можно только для головной организации ""%1""'"), ГоловнаяОрганизация);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДублирующиесяНастройки(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",        Ссылка);
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("Резерв",        Резерв);
	Запрос.УстановитьПараметр("ВидРезерва",    ВидРезерва);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НастройкиРасчетаРезервовПоОплатеТруда КАК НастройкиРасчетаРезервовПоОплатеТруда
	|ГДЕ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка <> &Ссылка
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Организация = &Организация
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Резерв = &Резерв
	|	И НастройкиРасчетаРезервовПоОплатеТруда.ВидРезерва = &ВидРезерва
	|	И (НастройкиРасчетаРезервовПоОплатеТруда.НачалоПериода = &НачалоПериода
	|			ИЛИ НастройкиРасчетаРезервовПоОплатеТруда.КонецПериода = &КонецПериода)";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Запись с подобными настройками уже существует.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьИспользованиеВидаРезерва(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",        Ссылка);
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("Резерв",        Резерв);
	Запрос.УстановитьПараметр("ВидРезерва",    ВидРезерва);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка КАК Ссылка,
	|	НастройкиРасчетаРезервовПоОплатеТруда.ВидРезерва КАК ВидРезерва
	|ИЗ
	|	Справочник.НастройкиРасчетаРезервовПоОплатеТруда КАК НастройкиРасчетаРезервовПоОплатеТруда
	|ГДЕ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка <> &Ссылка
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Организация = &Организация
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Резерв = &Резерв
	|	И НастройкиРасчетаРезервовПоОплатеТруда.ВидРезерва <> &ВидРезерва";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Отказ = Истина;
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Выбранный резерв уже использован в настройках как вид резерва ""%1"".'"), Выборка.ВидРезерва);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьИспользованиеРезерва(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",        Ссылка);
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("Резерв",        Резерв);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка КАК Ссылка,
	|	НастройкиРасчетаРезервовПоОплатеТруда.Резерв КАК Резерв
	|ИЗ
	|	Справочник.НастройкиРасчетаРезервовПоОплатеТруда КАК НастройкиРасчетаРезервовПоОплатеТруда
	|ГДЕ
	|	НастройкиРасчетаРезервовПоОплатеТруда.Ссылка <> &Ссылка
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Организация = &Организация
	|	И НастройкиРасчетаРезервовПоОплатеТруда.Резерв = &Резерв
	|	И НастройкиРасчетаРезервовПоОплатеТруда.ВидРезерва <> Значение(Перечисление.ВидыРезервовПоОплатеТруда.Отпуск)";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Повторное использование резерва в настройках допустимо только для вида резерва ""Отпуск"".'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли