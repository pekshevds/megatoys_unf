///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПользователиСертификата = Параметры.Пользователи;
	ВладелецСертификата = Параметры.Пользователь;
	РежимПросмотра = Параметры.РежимПросмотра;
	
	Если ПользователиСертификата = Неопределено Тогда
		ПользователиСертификата = Новый Массив;
	КонецЕсли;
	
	Если ПользователиСертификата.Количество() > 0
		ИЛИ ВладелецСертификата <> Пользователи.ТекущийПользователь()
		ИЛИ НЕ ЗначениеЗаполнено(ВладелецСертификата) Тогда
		СпособВыбора = "СписокПользователей";
	Иначе
		СпособВыбора = "ТолькоДляМеня";
	КонецЕсли;
	
	ЗаполнитьПолныйСписок(ПользователиСертификата, ВладелецСертификата);
	УправлениеФормой(ЭтотОбъект);
	НастроитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыбораПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если РежимПросмотра Тогда
		Результат = Неопределено;
	Иначе	
		Результат = Новый Структура;
		Результат.Вставить("Пользователи", Новый Массив);
		Результат.Вставить("Пользователь", ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
		
		Если СпособВыбора = "СписокПользователей" Тогда
			Для Каждого СтрокаПользователя Из ТаблицаПользователей Цикл
				Если СтрокаПользователя.Пометка Тогда
					Результат.Пользователи.Добавить(СтрокаПользователя.Пользователь);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Результат.Пользователь = ПользователиКлиент.ТекущийПользователь();	
		КонецЕсли;
		Если Результат.Пользователи.Количество() = 1 Тогда
			Результат.Пользователь = Результат.Пользователи[0];
			Результат.Пользователи.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПометку(Команда)
	
	ИзменитьПометкиСписка(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	
	ИзменитьПометкиСписка(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьПометкиСписка(ЗначениеПометки)
	
	Для Каждого СтрокаПользователя Из ТаблицаПользователей Цикл
		СтрокаПользователя.Пометка = ЗначениеПометки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("BackColor");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.ДобавленныйРеквизитФон;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаПользователей.Основной");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементПоляОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоляОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаПользователей");
	ЭлементПоляОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолныйСписок(ПользователиСертификата, ВладелецСертификата)
	
	МассивПользователей = Новый Массив;
	Если ПользователиСертификата <> Неопределено Тогда
		МассивПользователей = ПользователиСертификата;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВладелецСертификата)
		И СпособВыбора = "СписокПользователей" Тогда
		МассивПользователей.Добавить(ВладелецСертификата);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Ссылка КАК Пользователь,
	|	ВЫБОР
	|		КОГДА Пользователи.Ссылка В (&Пользователи)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Пометка,
	|	ВЫБОР
	|		КОГДА Пользователи.Ссылка = &ВладелецСертификата
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Основной
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	(НЕ Пользователи.ПометкаУдаления
	|				И НЕ Пользователи.Недействителен
	|				И (НЕ Пользователи.Служебный
	|						И Пользователи.ИдентификаторПользователяИБ <> &ПустойИдентификаторПользователяИБ
	|					ИЛИ Пользователи.Ссылка = &ТекущийПользователь)
	|			ИЛИ Пользователи.Ссылка В (&Пользователи))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Пользователи", МассивПользователей);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("ПустойИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	Запрос.УстановитьПараметр("ВладелецСертификата", ВладелецСертификата);
	
	ТаблицаПользователей.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(КонтекстФормы)
	
	ЭлементыФормы = КонтекстФормы.Элементы;
	
	Если КонтекстФормы.РежимПросмотра Тогда
		ЭлементыФормы.ТаблицаПользователей.ТолькоПросмотр = Истина;
		ЭлементыФормы.СпособВыбора.ТолькоПросмотр = Истина;
		ЭлементыФормы.СпособВыбораСписок.ТолькоПросмотр = Истина;
	Иначе	
		ЭлементыФормы.ТаблицаПользователей.ТолькоПросмотр = НЕ КонтекстФормы.СпособВыбора = "СписокПользователей";
	КонецЕсли;	
	
	ЭлементыФормы.ПользователиПометитьВсе.Доступность = НЕ ЭлементыФормы.ТаблицаПользователей.ТолькоПросмотр;
	ЭлементыФормы.ПользователиОтменитьПометку.Доступность = НЕ ЭлементыФормы.ТаблицаПользователей.ТолькоПросмотр;
		
КонецПроцедуры

#КонецОбласти
