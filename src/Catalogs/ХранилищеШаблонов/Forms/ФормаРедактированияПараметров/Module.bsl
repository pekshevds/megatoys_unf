#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура УстановитьФормат(Текст, ДополнительныеПараметры) Экспорт
	
	Если НЕ Текст = Неопределено Тогда
		Формат = Текст;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.мСтрокаДерева = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	Иначе
		ШаблонЧеков = ДанныеФормыВЗначение(Параметры.мСтрокаДерева, Тип("ДеревоЗначений"));
		мСтрокаДерева = ШаблонЧеков.Строки.Найти(Параметры.Идентификатор, "Идентификатор", Истина);
		Формат           = Параметры.Формат;
		ШиринаСтроки     = Параметры.ШиринаСтроки;
		РазмещениеТекста = Параметры.РазмещениеТекста;
		Выравнивание     = Параметры.Выравнивание;
		Наименование     = Параметры.Наименование;
		Вычислять        = Параметры.Вычислять;
		// Префикс и постфикс
		Префикс          = Параметры.Префикс;
		Постфикс         = Параметры.Постфикс;
		
		// Пустое значение
		Элементы.ПустоеЗначение.ОграничениеТипа = мСтрокаДерева.ОписаниеТипа;
		
		Типы = мСтрокаДерева.ОписаниеТипа.Типы();
		Если мСтрокаДерева.ПустоеЗначение = Неопределено И Типы.Количество() = 1 Тогда
			// Примитивные типы
			ТипЗначенияПустогоЗначения = Типы[0];
			Если ТипЗначенияПустогоЗначения = Тип("Строка") Тогда
				ПустоеЗначение = "";
			ИначеЕсли ТипЗначенияПустогоЗначения = Тип("Число") Тогда
				ПустоеЗначение = 0;
			ИначеЕсли ТипЗначенияПустогоЗначения = Тип("Булево") Тогда
				ПустоеЗначение = Ложь;
			ИначеЕсли ТипЗначенияПустогоЗначения = Тип("Дата") Тогда
				ПустоеЗначение = '00010101';
			Иначе
				// Ссылочные типы
				ПустоеЗначение = Новый(Типы[0]);
			КонецЕсли;
		Иначе
			ПустоеЗначение = мСтрокаДерева.ПустоеЗначение;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ЭлементФормы Из Элементы.ГруппаОсновная.ПодчиненныеЭлементы Цикл
		ЭлементФормы.Доступность = Истина;
	КонецЦикла;
	
	Если мСтрокаДерева.Уровень() = 1 Тогда
		Элементы.ПанельШирина.Доступность = Ложь;
	КонецЕсли;
	
	Если мСтрокаДерева.ТипЭлемента = "СтрокаТекста" ИЛИ мСтрокаДерева.ТипЭлемента = "СоставнаяСтрока" Тогда
		Элементы.ПанельФормат.Доступность = Ложь;
		Элементы.ПанельПустоеЗначение.Доступность = Ложь;
	КонецЕсли;
	Если мСтрокаДерева.ТипЭлемента = "СтрокаДанных"  Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если мСтрокаДерева.ТипЭлемента = "СоставнаяСтрока" Тогда
		Элементы.ПанельФормат.Доступность = Ложь;
	КонецЕсли;
	
	Если мСтрокаДерева.ТипЭлемента = "Таблица" Тогда
		Элементы.ПанельВыравнивание.Доступность = Ложь;
		Элементы.ПанельЗабивать.Доступность = Ложь;
		Элементы.ПанельШирина.Доступность = Ложь;
		Элементы.ПанельФормат.Доступность = Ложь;
		Элементы.ПанельПустоеЗначение.Доступность = Ложь;
	КонецЕсли;
	
	Если мСтрокаДерева.Уровень() > 0 И мСтрокаДерева.Родитель.ТипЭлемента = "СоставнаяСтрока" Тогда
		Элементы.ПанельШирина.Доступность = Ложь;
		Если мСтрокаДерева.Родитель.ТипЭлемента = "СоставнаяСтрока" Тогда
			Элементы.ПанельВыравнивание.Доступность = Ложь;
			Элементы.ПанельЗабивать.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если мСтрокаДерева.ТипЭлемента = "СоставнаяСтрока"
		ИЛИ мСтрокаДерева.ТипЭлемента = "СтрокаТекста"
		ИЛИ мСтрокаДерева.ТипЭлемента = "Таблица" Тогда
		Элементы.ПанельЗаголовок.Доступность = Ложь;
	Иначе
		Элементы.ПанельЗаголовок.Доступность = Истина;
	КонецЕсли;
	
	Если Выравнивание = "Право" Тогда
		ПараметрВыравнивание = 1;
	ИначеЕсли Выравнивание = "Центр" Тогда
		ПараметрВыравнивание = 2;
	Иначе
		ПараметрВыравнивание = 0;
	КонецЕсли;
	Элементы.Постфикс.СписокВыбора.Добавить(Символы.ПС, НСтр("ru = 'Перенос строки'"));
	Элементы.Постфикс.СписокВыбора.Добавить(Символы.Таб, НСтр("ru = 'Табуляция'"));
	Элементы.Постфикс.СписокВыбора.Добавить(Символы.НПП, НСтр("ru = 'Неразрывный пробел'"));
	Элементы.Постфикс.СписокВыбора.Добавить(":", ":");
	Элементы.Постфикс.СписокВыбора.Добавить(".", ".");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФорматНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Конструктор = Новый КонструкторФорматнойСтроки(Формат);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьФормат", ЭтотОбъект);
	Конструктор.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьИзмененияЗакрытьФорму(Команда)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Формат", Формат);
	СтруктураПараметров.Вставить("Элемент", Наименование);
	СтруктураПараметров.Вставить("Ширина", ШиринаСтроки);
	СтруктураПараметров.Вставить("РазмещениеТекста", РазмещениеТекста);
	Если ПараметрВыравнивание = 0 Тогда
		Выравнивание = "Лево";
	ИначеЕсли ПараметрВыравнивание = 1 Тогда
		Выравнивание = "Право";
	ИначеЕсли ПараметрВыравнивание = 2 Тогда
		Выравнивание = "Центр";
	КонецЕсли;
	СтруктураПараметров.Вставить("Выравнивание", Выравнивание);
	// Префикс и постфикс
	СтруктураПараметров.Вставить("Префикс", Префикс);
	СтруктураПараметров.Вставить("Постфикс", Постфикс);
	// Пустое значение
	СтруктураПараметров.Вставить("ПустоеЗначение", ПустоеЗначение);
	СтруктураПараметров.Вставить("СтрокаПустоеЗначение", СтрокаПустоеЗначение);
	
	Если НЕ ПустаяСтрока(Параметры.мКэшМакетовАдрес) Тогда
		мКэшМакетов = ПолучитьИзВременногоХранилища(Параметры.мКэшМакетовАдрес);
		мКэшМакетов.Удалить(Параметры.Идентификатор);
		ПоместитьВоВременноеХранилище(мКэшМакетов, Параметры.мКэшМакетовАдрес);
	КонецЕсли;
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти
