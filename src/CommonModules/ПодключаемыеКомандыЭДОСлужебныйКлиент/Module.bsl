// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Выполнение команды после подтверждения записи
//
// Параметры:
//  РезультатВопроса - КодВозвратаДиалога
//  ДополнительныеПараметры - Структура
//
Процедура ВыполнитьПодключаемуюКомандуЭДОПодтверждениеЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	Источник = ДополнительныеПараметры.Источник;
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		
		Форма.Записать();
		Если Источник.Ссылка.Пустая() Или Форма.Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;		
			
		ДокументыУчета = Новый Массив;
		ДокументыУчета.Добавить(Источник.Ссылка);

		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ДокументыУчета", ДокументыУчета);

		Оповестить("ОбновитьСостояниеЭД", ПараметрыОповещения);
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыОснований = ДополнительныеПараметры.Источник;
	Если ТипЗнч(ОбъектыОснований) <> Тип("Массив") Тогда
		ОбъектыОснований = ОбъектыОснований(ОбъектыОснований);
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ОбъектыОснований", ОбъектыОснований);
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	ОбъектыОснований = ДополнительныеПараметры.ОбъектыОснований;
	
	ОписаниеКоманды = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ОписаниеКоманды, Ложь);
	
	Если ОписаниеКоманды.РежимИспользованияПараметра = РежимИспользованияПараметраКоманды.Множественный Тогда
		ПараметрКоманды = ОбъектыОснований;
		ОписаниеКоманды.Вставить("ПараметрКоманды", ОбъектыОснований);
	Иначе
		Если ОбъектыОснований.Количество() Тогда
			ПараметрКоманды = ОбъектыОснований[0];
		Иначе
			ПараметрКоманды = Неопределено;
		КонецЕсли;
		ОписаниеКоманды.Вставить("ПараметрКоманды", ПараметрКоманды);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеКоманды.Обработчик) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКоманды.Вставить("Источник", Форма);
	ОписаниеКоманды.Вставить("Уникальность", Ложь);
	
	МассивИмениОбработчика = СтрРазделить(ОписаниеКоманды.Обработчик, ".");
	МодульОбработки = ОбщегоНазначенияКлиент.ОбщийМодуль(МассивИмениОбработчика[0]);
	Обработчик = Новый ОписаниеОповещения(МассивИмениОбработчика[1], МодульОбработки, ОписаниеКоманды);
	ВыполнитьОбработкуОповещения(Обработчик, ПараметрКоманды);
	
КонецПроцедуры

// Обновить команды ЭДО на форме списка (старый алгоритм).
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ПараметрыУправленияВидимостью - см. ПодключаемыеКомандыЭДОСлужебный.ПараметрыУправленияВидимостьюЭДО
//  ТаблицаФормы - ТаблицаФормы
//
Процедура ОбновитьКомандыСписка(Форма, ПараметрыУправленияВидимостью, ТаблицаФормы) Экспорт

	Если ТаблицаФормы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВыбранныеОбъекты = Новый Массив;
	ОбъектыДляПроверкиАлгоритмами = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ТаблицаФормы.ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		ТекущаяСтрока = ТаблицаФормы.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено Тогда
			ВыбранныеОбъекты.Добавить(ТекущаяСтрока);
			Если ТипЗнч(ТекущаяСтрока) = Тип("ДанныеФормыСтруктура") Тогда
				ОбъектыДляПроверкиАлгоритмами.Добавить(ТекущаяСтрока.Ссылка);
			Иначе
				ОбъектыДляПроверкиАлгоритмами.Добавить(ТекущаяСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	КомандыДляПроверкиАлгоритмами = Новый Соответствие;
	Для Каждого Команда Из ПараметрыУправленияВидимостью.КомандыСУсловиямиВидимости Цикл
		КомандаЭлемент = Форма.Элементы[Команда.ИмяВФорме];
		Видимость = Истина;
		Для Каждого Объект Из ВыбранныеОбъекты Цикл
			ЗначениеСтроки = Неопределено;
			Если Объект.Свойство(Команда.ИмяРеквизитаУсловия, ЗначениеСтроки) Тогда
				Видимость = Команда.ЗначениеУсловия = ЗначениеСтроки;
				Если Не Видимость Тогда
					КомандыДляПроверкиАлгоритмами.Удалить(Команда);
					Прервать;
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(Команда.ИмяАлгоритмаПроверкиУсловия) Тогда
				КомандыДляПроверкиАлгоритмами.Вставить(Команда, Команда.ИмяАлгоритмаПроверкиУсловия);
			Иначе
				Возврат;
			КонецЕсли;
		КонецЦикла;
		КомандаЭлемент.Видимость = Видимость;
	КонецЦикла;
	УстановитьВидимостьКомандПоАлгоритмам(Форма, КомандыДляПроверкиАлгоритмами, ОбъектыДляПроверкиАлгоритмами);

КонецПроцедуры

// Обновить команды ЭДО на форме списка (новый алгоритм).
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ПараметрыУправленияВидимостью - см. ПодключаемыеКомандыЭДОСлужебный.ПараметрыУправленияВидимостьюЭДО
//  ТаблицаФормы - ТаблицаФормы
//
Процедура ОбновитьКомандыСпискаНаКлиенте(Форма, ПараметрыУправленияВидимостью, ТаблицаФормы) Экспорт
	Если Не ЗначениеЗаполнено(ТаблицаФормы.ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	ПолеСоЗначениямиВидимости = ПодключаемыеКомандыЭДОКлиентСервер.ИмяПоляЗначенийВидимостиКомандЭДО();
	Для Каждого Команда Из ПараметрыУправленияВидимостью.КомандыСУсловиямиВидимости Цикл
		КомандаЭлемент = Форма.Элементы[Команда.ИмяВФорме];
		КомандаЭлемент.Видимость = Истина;
		Для Каждого ВыделеннаяСтрока Из ТаблицаФормы.ВыделенныеСтроки Цикл
			
			Если Не ВыделеннаяСтрокаКорректнаДляОпределенияВидимостиКоманд(ВыделеннаяСтрока) Тогда
				КомандаЭлемент.Видимость = Ложь;
				Прервать;
			КонецЕсли;
			
			ДанныеСтроки = ТаблицаФормы.ДанныеСтроки(ВыделеннаяСтрока);
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеСтроки,
				ПолеСоЗначениямиВидимости) Тогда
				Если Не ДанныеСтроки[ПолеСоЗначениямиВидимости][Команда.ИмяВФорме] Тогда
					КомандаЭлемент.Видимость = Ложь;
					Прервать;
				КонецЕсли;
			Иначе
				ШаблонСообщения = НСтр("ru = 'Не найдено служебное поле значений видимости команд ЭДО на форме [ИмяФормы]
									   |Проверьте правильность внедрения библиотеки электронных документов';");
				ПараметрыШаблона = Новый Структура("ИмяФормы", Форма.ИмяФормы);
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонСообщения, ПараметрыШаблона);
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

// Обновить команды ЭДО на форме объекта.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ПараметрыУправленияВидимостью - см. ПодключаемыеКомандыЭДОСлужебный.ПараметрыУправленияВидимостьюЭДО
//  ДанныеФормы - ДанныеФормыСтруктура
//
Процедура ОбновитьКомандыОбъекта(Форма, ПараметрыУправленияВидимостью, ДанныеФормы) Экспорт

	КомандыДляПроверкиАлгоритмами = Новый Соответствие;
	Для Каждого Команда Из ПараметрыУправленияВидимостью.КомандыСУсловиямиВидимости Цикл
		КомандаЭлемент = Форма.Элементы[Команда.ИмяВФорме];
		ЗначениеСтроки = Неопределено;
		Если ДанныеФормы.Свойство(Команда.ИмяРеквизитаУсловия, ЗначениеСтроки) Тогда
			КомандаЭлемент.Видимость = Команда.ЗначениеУсловия = ЗначениеСтроки;
		ИначеЕсли ЗначениеЗаполнено(Команда.ИмяАлгоритмаПроверкиУсловия) Тогда
			КомандыДляПроверкиАлгоритмами.Вставить(Команда, Команда.ИмяАлгоритмаПроверкиУсловия);
		Иначе
			КомандаЭлемент.Видимость = Истина;
		КонецЕсли;
	КонецЦикла;
	ПроверяемыйОбъект = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеФормы.Ссылка);
	УстановитьВидимостьКомандПоАлгоритмам(Форма, КомандыДляПроверкиАлгоритмами, ПроверяемыйОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получение ссылок объектов из формы
//
// Параметры:
//  Источник - ТаблицаФормы, Объект - данные формы.
//
// Возвращаемое значение:
//  Массив - ссылки на объекты.
//
Функция ОбъектыОснований(Источник)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ВыделенныеСтроки = Источник.ВыделенныеСтроки;
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущаяСтрока <> Неопределено Тогда
				Результат.Добавить(ТекущаяСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Результат.Добавить(Источник.Ссылка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьВидимостьКомандПоАлгоритмам(Форма, КомандыДляПроверкиАлгоритмами, ПроверяемыеОбъекты)
	Алгоритмы = Новый Соответствие;
	Для Каждого КомандаИАлгоритм Из КомандыДляПроверкиАлгоритмами Цикл
		Алгоритмы.Вставить(КомандаИАлгоритм.Значение, Истина);
	КонецЦикла;
	ЗначенияАлгоритмов = ПодключаемыйКомандыЭДОСлужебныйВызовСервера.ВычислитьЗначенияАлгоритмов(Алгоритмы,
		ПроверяемыеОбъекты);
	Для Каждого КомандаИАлгоритм Из КомандыДляПроверкиАлгоритмами Цикл
		Команда = КомандаИАлгоритм.Ключ;
		КомандаЭлемент = Форма.Элементы[Команда.ИмяВФорме];
		КомандаЭлемент.Видимость = Команда.ЗначениеУсловия = ЗначенияАлгоритмов[КомандаИАлгоритм.Значение];
	КонецЦикла;
КонецПроцедуры

Функция ВыделеннаяСтрокаКорректнаДляОпределенияВидимостиКоманд(ВыделеннаяСтрока)
	Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыделеннаяСтрока) Тогда
		Возврат Ложь;
	КонецЕсли;
			
	Возврат Истина;
КонецФункции

#КонецОбласти