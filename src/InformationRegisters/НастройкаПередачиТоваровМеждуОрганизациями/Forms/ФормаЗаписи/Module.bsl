
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ТолькоПросмотр И НЕ ЗначениеЗаполнено(Запись.Приоритет) Тогда
		УстановитьПорядокПоУмолчанию();
	КонецЕсли;
	
	АвтоматическиУменьшатьПередачи = (Запись.СпособВозвратаТоваров = ПредопределенноеЗначение("Перечисление.СпособыВозвратаТоваров.УменьшениеПередачи"));
	
	// Заполнения по умолчанию
	Если НЕ ТолькоПросмотр И (Не ЗначениеЗаполнено(Запись.СпособПередачиТоваров)
		ИЛИ Элементы.СпособПередачиТоваров.СписокВыбора.НайтиПоЗначению(Запись.СпособПередачиТоваров) = Неопределено) Тогда
		Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.НеПередается;
	КонецЕсли;
	Если НЕ ТолькоПросмотр И Не ЗначениеЗаполнено(Запись.СпособВозвратаТоваров) Тогда
		Запись.СпособВозвратаТоваров = Перечисления.СпособыВозвратаТоваров.НеТребуется;
	КонецЕсли;
	
	Если Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.НеПередается
		И ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи.ОрганизацияВладелец)
		И РегистрыСведений.НастройкаПередачиТоваровМеждуОрганизациями.ЕстьНезакрытыеРезервы(Запись.ОрганизацияВладелец, Запись.ОрганизацияПродавец) Тогда
		ТолькоПросмотр = Истина;
		КлючСохраненияПоложенияОкна = "РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями.ФормаЗаписи.ВариантСПредупреждением";
	Иначе
		Если Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.НеПередается Тогда
			КлючСохраненияПоложенияОкна = "РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями.ФормаЗаписи.ВариантБезПередачи";
		КонецЕсли; 
		Элементы.ГруппаПредупрежденияРезервы.Видимость = Ложь;
	КонецЕсли;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, Запись);
	КонецЕсли;
	Оповестить(ИнтеркампаниКлиентСервер.ИмяСобытияЗаписьНастройки(), Запись.ОрганизацияПродавец);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОписаниеОповещенияОЗакрытии = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияВладелецПриИзменении(Элемент)
	
	Запись.КонтрагентВладельца = КонтрагентИнтеркампани(Запись.ОрганизацияВладелец);

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПродавецПриИзменении(Элемент)
	
	Запись.КонтрагентПродавец = КонтрагентИнтеркампани(Запись.ОрганизацияПродавец);
	УстановитьПорядокПоУмолчанию();

КонецПроцедуры

&НаКлиенте
Процедура СпособПередачиТоваровПриИзменении(Элемент)
	
	СпособПередачиТоваровПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиУменьшатьПередачиПриИзменении(Элемент)
	
	Если АвтоматическиУменьшатьПередачи Тогда
		Запись.СпособВозвратаТоваров = ПредопределенноеЗначение("Перечисление.СпособыВозвратаТоваров.УменьшениеПередачи");
	Иначе
		Запись.СпособВозвратаТоваров = ПредопределенноеЗначение("Перечисление.СпособыВозвратаТоваров.НеТребуется");
	КонецЕсли;
	АвтоматическиУменьшатьПередачиПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = ПолучитьПараметрыФормыВыбора(Запись.ОрганизацияВладелец, Запись.ОрганизацияПродавец, Запись.Договор);
	Если ПараметрыФормы.КонтролироватьВыборДоговора Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.Валюта.Видимость = (Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию)
		И ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций");
	Элементы.ВидЦены.Видимость = (Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.НеПередается);
	Элементы.Договор.Видимость = (Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.НеПередается);
	Элементы.АвтоматическиУменьшатьПередачи.Видимость = (Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.НеПередается);
	Элементы.ДатаНачалаУчетаВозвратов.Видимость = (ЗначениеЗаполнено(Запись.СпособВозвратаТоваров) 
		И Запись.СпособВозвратаТоваров <> Перечисления.СпособыВозвратаТоваров.НеТребуется);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура СпособПередачиТоваровПриИзмененииСервер()
	
	Если Запись.СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию Тогда
		Запись.Валюта = Неопределено;
	КонецЕсли;
	
	Если Запись.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.НеПередается Тогда
		Запись.ВидЦены = Неопределено;
	КонецЕсли;
	
	Запись.Договор = Неопределено;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура АвтоматическиУменьшатьПередачиПриИзмененииСервер()
	
	Если АвтоматическиУменьшатьПередачи Тогда
		Запись.ДатаНачалаУчетаВозвратов = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.Договор) Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Договор, "ВидЦен, ВалютаРасчетов");
		Запись.ВидЦены = ЗначенияРеквизитов.ВидЦен;
		Запись.Валюта = ЗначенияРеквизитов.ВалютаРасчетов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ДоговорПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыФормыВыбора(Организация, Контрагент, Договор)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонтролироватьВыборДоговора", Истина);
	ПараметрыФормы.Вставить("Контрагент", Контрагент);
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("ТекущаяСтрока", Договор);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервереБезКонтекста
Функция КонтрагентИнтеркампани(Организация)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "КонтрагентИнтеркампани", Истина);
	
КонецФункции

&НаСервере
Процедура УстановитьПорядокПоУмолчанию()
	
	Если НЕ ЗначениеЗаполнено(Запись.ОрганизацияПродавец) Тогда
		Запись.Приоритет = 0;
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияПродавец", Запись.ОрганизацияПродавец);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(НастройкаПередачиТоваровМеждуОрганизациями.Приоритет) КАК Приоритет
	|ИЗ
	|	РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК НастройкаПередачиТоваровМеждуОрганизациями
	|ГДЕ
	|	НастройкаПередачиТоваровМеждуОрганизациями.ОрганизацияПродавец = &ОрганизацияПродавец";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Приоритет) Тогда
		Запись.Приоритет = Выборка.Приоритет + 1;
	Иначе
		Запись.Приоритет = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
