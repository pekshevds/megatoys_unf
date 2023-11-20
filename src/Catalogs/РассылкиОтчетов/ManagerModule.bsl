///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Отчеты.*");
	Результат.Добавить("ФорматыОтчетов.*");
	Результат.Добавить("Получатели.*");
	
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Автор)
	|	ИЛИ Личная = ЛОЖЬ
	|	ИЛИ ЭтоГруппа = ИСТИНА";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КонтрольРассылкиОтчетов)
		И ПолучитьФункциональнуюОпцию("ХранитьИсториюРассылкиОтчетов") Тогда
		Команда = КомандыОтчетов.Добавить();
		Команда.Представление = НСтр("ru = 'Контроль рассылки отчетов'");
		Команда.КлючВарианта  = "КонтрольРассылкиОтчетов";
		Команда.Картинка  = БиблиотекаКартинок.Отчет;
		Команда.МножественныйВыбор = Ложь;
		Команда.Менеджер = "Отчет.КонтрольРассылкиОтчетов";
		Команда.ТипПараметра = Новый ОписаниеТипов("СправочникСсылка.РассылкиОтчетов");
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		МодульУправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ПаролиРассылокОтчетов", 
				НСтр("ru = 'Пароли для рассылки отчетов'"),
				ПечатнаяФормаПаролиРассылкиОтчетов(ПараметрыПечати, ОбъектыПечати),
				,
				"Справочник.РассылкиОтчетов.ПФ_MXL_ПаролиРассылкиОтчетов", НСтр("ru = 'Пароли для рассылки отчетов'"));
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Регистрирует к обработке рассылки отчетов.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РассылкиОтчетовФорматыОтчетов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.РассылкиОтчетов.ФорматыОтчетов КАК РассылкиОтчетовФорматыОтчетов
		|ГДЕ
		|	РассылкиОтчетовФорматыОтчетов.Формат = &Формат
		|СГРУППИРОВАТЬ ПО
		|	РассылкиОтчетовФорматыОтчетов.Ссылка";
	
	Запрос.УстановитьПараметр("Формат", Перечисления.ФорматыСохраненияОтчетов.HTML4);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры,
		РезультатЗапроса.ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	РассылкаОтчетовСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.РассылкиОтчетов");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока РассылкаОтчетовСсылка.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.РассылкиОтчетов");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", РассылкаОтчетовСсылка.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка.Заблокировать();
			
			РассылкаОтчетовОбъект = РассылкаОтчетовСсылка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.РассылкиОтчетов
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Формат", Перечисления.ФорматыСохраненияОтчетов.HTML4);
			
			МассивСтрокФорматов = РассылкаОтчетовОбъект.ФорматыОтчетов.НайтиСтроки(ПараметрыОтбора);
			
			Для Каждого Строка Из МассивСтрокФорматов Цикл
				Строка.Формат = Перечисления.ФорматыСохраненияОтчетов.HTML;
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(РассылкаОтчетовОбъект);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			// Если не удалось обработать одну из рассылок отчетов, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать рассылку отчетов %1 по причине: 
					|%2'"),
					РассылкаОтчетовСсылка.Ссылка, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.РассылкиОтчетов, РассылкаОтчетовСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.РассылкиОтчетов");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые рассылки отчетов (пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ВидыКонтактнойИнформации,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Обработана очередная порция рассылок отчетов: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ЛичныеРассылки";
	Элемент.Наименование              = НСтр("ru = 'Личные рассылки'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецПроцедуры

Функция КоличествоПолучателейСУчетомГрупп(Знач ПараметрыПолучателей) Экспорт

	КоличествоПолучателей = Новый Структура("Всего, Исключены", 0, Неопределено);
	
	Если ПараметрыПолучателей.ТипПолучателейРассылки = Неопределено Тогда
		Возврат КоличествоПолучателей;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	СписокПолучателей = Новый Соответствие;
	РассылкаОтчетовПереопределяемый.ПередФормированиемСпискаПолучателейРассылки(ПараметрыПолучателей, Запрос, Истина, СписокПолучателей);
	
	Если ЗначениеЗаполнено(Запрос.Текст) Тогда
		ПолучателиРассылки = РассылкаОтчетов.СформироватьСписокПолучателейРассылки(ПараметрыПолучателей, Неопределено);
		КоличествоПолучателей.Всего = ПолучателиРассылки.Количество();
		Возврат КоличествоПолучателей;
	КонецЕсли;
	
	ПолучателиМетаданные = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ПараметрыПолучателей.ТипПолучателейРассылки, Ложь);
	
	Если ПолучателиМетаданные = Неопределено Или ПолучателиМетаданные = Null Тогда
		Возврат КоличествоПолучателей;
	КонецЕсли;
	
	ТипПолучателей = ПараметрыПолучателей.ТипПолучателейРассылки.КлючОбъектаМетаданных.Получить();

	Запрос = Новый Запрос;

	Если ТипПолучателей = Тип("СправочникСсылка.Пользователи") Тогда

		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТаблицаПолучателей.Получатель,
		|	ТаблицаПолучателей.Исключен
		|ПОМЕСТИТЬ ТаблицаПолучателей
		|ИЗ
		|	&ТаблицаПолучателей КАК ТаблицаПолучателей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Пользователь.Ссылка КАК Получатель,
		|	МАКСИМУМ(ТаблицаПолучателей.Исключен) КАК Исключен
		|ПОМЕСТИТЬ Получатели
		|ИЗ
		|	ТаблицаПолучателей КАК ТаблицаПолучателей
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|		ПО СоставыГруппПользователей.ГруппаПользователей = ТаблицаПолучателей.Получатель
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО Пользователи.Ссылка = СоставыГруппПользователей.Пользователь
		|ГДЕ
		|	НЕ Пользователи.ПометкаУдаления
		|	И НЕ Пользователи.Недействителен
		|	И НЕ Пользователи.Служебный
		|СГРУППИРОВАТЬ ПО
		|	Пользователь.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	КОЛИЧЕСТВО(Получатели.Получатель) КАК КоличествоИсключены,
		|	0 КАК КоличествоОтправлять
		|ПОМЕСТИТЬ КоличествоПолучателей
		|ИЗ
		|	Получатели КАК Получатели
		|ГДЕ
		|	Получатели.Исключен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	0 КАК КоличествоИсключены,
		|	КОЛИЧЕСТВО(Получатели.Получатель) КАК КоличествоОтправлять
		|ИЗ
		|	Получатели КАК Получатели
		|ГДЕ
		|	НЕ Получатели.Исключен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(КоличествоПолучателей.КоличествоИсключены) КАК КоличествоИсключены,
		|	СУММА(КоличествоПолучателей.КоличествоОтправлять) КАК КоличествоОтправлять
		|ИЗ
		|	КоличествоПолучателей КАК КоличествоПолучателей";

	Иначе

		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТаблицаПолучателей.Получатель,
		|	ТаблицаПолучателей.Исключен
		|ПОМЕСТИТЬ ТаблицаПолучателей
		|ИЗ
		|	&ТаблицаПолучателей КАК ТаблицаПолучателей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	КОЛИЧЕСТВО(ИСТИНА) КАК КоличествоИсключены,
		|	СУММА(0) КАК КоличествоОтправлять
		|ПОМЕСТИТЬ КоличествоПолучателей
		|ИЗ
		|	Справочник.Пользователи КАК Получатели
		|ГДЕ
		|	Получатели.Ссылка В ИЕРАРХИИ
		|		(ВЫБРАТЬ
		|			Получатель
		|		ИЗ
		|			ТаблицаПолучателей
		|		ГДЕ
		|			Исключен)
		|	И НЕ Получатели.ПометкаУдаления
		|	И &ЭтоНеГруппа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СУММА(0) КАК КоличествоИсключены,
		|	КОЛИЧЕСТВО(ЛОЖЬ) КАК КоличествоОтправлять
		|ИЗ
		|	Справочник.Пользователи КАК Получатели
		|ГДЕ
		|	Получатели.Ссылка В ИЕРАРХИИ
		|		(ВЫБРАТЬ
		|			Получатель
		|		ИЗ
		|			ТаблицаПолучателей
		|		ГДЕ
		|			НЕ Исключен)
		|	И НЕ Получатели.ПометкаУдаления
		|	И &ЭтоНеГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(КоличествоПолучателей.КоличествоИсключены) КАК КоличествоИсключены,
		|	СУММА(КоличествоПолучателей.КоличествоОтправлять) КАК КоличествоОтправлять
		|ИЗ
		|	КоличествоПолучателей КАК КоличествоПолучателей";

		Если Не ПолучателиМетаданные.Иерархический Тогда
			// Не иерархический
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "В ИЕРАРХИИ", "В");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ЭтоНеГруппа", "");
		ИначеЕсли ПолучателиМетаданные.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияЭлементов Тогда
			// Иерархия элементов
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ЭтоНеГруппа", "");
		Иначе
			// Иерархия групп
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ЭтоНеГруппа", "И НЕ Получатели.ЭтоГруппа");
		КонецЕсли;

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Пользователи", ПолучателиМетаданные.ПолноеИмя());

	КонецЕсли;

	Запрос.УстановитьПараметр("ТаблицаПолучателей", ПараметрыПолучателей.Получатели.Выгрузить());
	Запрос.Текст = ТекстЗапроса;

	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаПолучатели = РезультатЗапроса.Выбрать();
		Если ВыборкаПолучатели.Следующий() Тогда
			КоличествоПолучателей.Всего = ВыборкаПолучатели.КоличествоОтправлять;
			КоличествоПолучателей.Исключены = ВыборкаПолучатели.КоличествоИсключены;
		КонецЕсли;
	Исключение
		Возврат КоличествоПолучателей;
	КонецПопытки;

	Возврат КоличествоПолучателей;

КонецФункции

Функция ПечатнаяФормаПаролиРассылкиОтчетов(Параметры, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;

	Макет = ПолучитьМакет("ПФ_MXL_ПаролиРассылкиОтчетов");

	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	ЗаголовокПечати = Макет.ПолучитьОбласть("Заголовок");

	ЗаголовокПечати.Параметры.Заголовок =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Пароли для получения рассылки отчетов %1 ""%2""'"), Символы.ПС, Параметры.НаименованиеРассылки);

	ТабличныйДокумент.Вывести(ЗаголовокПечати);

	ШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ШапкаТаблицы);

	СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");

	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаПолучатели.Получатель,
	|	ТаблицаПолучатели.АдресЭлектроннойПочты,
	|	ТаблицаПолучатели.ПарольАрхива
	|ПОМЕСТИТЬ ТаблицаПолучатели
	|ИЗ
	|	&ТаблицаПолучатели КАК ТаблицаПолучатели
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникПолучатели.Наименование КАК Получатель,
	|	Получатели.АдресЭлектроннойПочты,
	|	Получатели.ПарольАрхива
	|ИЗ
	|	ТаблицаПолучатели КАК Получатели
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК СправочникПолучатели
	|		ПО СправочникПолучатели.Ссылка = Получатели.Получатель";

	ПолучателиМетаданные = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Параметры.ИдентификаторОбъектаМетаданных,
		Ложь);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Пользователи", ПолучателиМетаданные.ПолноеИмя());

	ТаблицаПолучатели = Новый ТаблицаЗначений;
	ТаблицаПолучатели.Колонки.Добавить("Получатель", Параметры.ТипПолучателейРассылки);
	ТаблицаПолучатели.Колонки.Добавить("АдресЭлектроннойПочты", Новый ОписаниеТипов("Строка", ,
		Новый КвалификаторыСтроки(250)));
	ТаблицаПолучатели.Колонки.Добавить("ПарольАрхива", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50)));

	Для Каждого ЭлементПолучатель Из Параметры.Получатели Цикл
		СтрокаПолучатели = ТаблицаПолучатели.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПолучатели, ЭлементПолучатель);
	КонецЦикла;

	Запрос.УстановитьПараметр("ТаблицаПолучатели", ТаблицаПолучатели);
	Запрос.Текст = ТекстЗапроса;

	НомерСтроки = 1;

	РезультатЗапроса = Запрос.Выполнить();
	Выборка= РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы.Параметры, Выборка);
		СтрокаТаблицы.Параметры.НомерСтроки = НомерСтроки;
		ТабличныйДокумент.Вывести(СтрокаТаблицы);
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;

	ТабличныйДокумент.АвтоМасштаб = Истина;

	МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
	МодульУправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Параметры.Ссылка);

	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли

