///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму указанного отчета. 
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения
//                - Неопределено - форма, из которой открывается отчет.
//  Вариант - СправочникСсылка.ВариантыОтчетов
//          - СправочникСсылка.ДополнительныеОтчетыИОбработки - вариант 
//            отчета, форму которого требуется открыть. Если передан тип СправочникСсылка.ДополнительныеОтчетыИОбработки, 
//            то открывается дополнительный отчет, подключенный к программе. 
//  ДополнительныеПараметры - Структура - служебный параметр, не предназначен для использования.
//
Процедура ОткрытьФормуОтчета(Знач ФормаВладелец, Знач Вариант, Знач ДополнительныеПараметры = Неопределено) Экспорт
	Тип = ТипЗнч(Вариант);
	Если Тип = Тип("Структура") Тогда
		ПараметрыОткрытия = Вариант;
	ИначеЕсли Тип = Тип("СправочникСсылка.ВариантыОтчетов") 
		Или Тип = ТипСсылкиДополнительногоОтчета() Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Вариант);
		Если ДополнительныеПараметры <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
		КонецЕсли;
		ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыОткрытия, Неопределено, Истина);
		Возврат;
	Иначе
		ПараметрыОткрытия = Новый Структура("Ссылка, Отчет, ТипОтчета, ПолноеИмяОтчета, ИмяОтчета, КлючВарианта, КлючЗамеров");
		Если ТипЗнч(ФормаВладелец) = Тип("ФормаКлиентскогоПриложения") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ФормаВладелец);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Вариант);
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
	КонецЕсли;
	
	ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "ВыполнятьЗамеры", Ложь);
	
	ПараметрыОткрытия.ТипОтчета = ВариантыОтчетовКлиентСервер.ТипОтчетаСтрокой(ПараметрыОткрытия.ТипОтчета, ПараметрыОткрытия.Отчет);
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ТипОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определен тип отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТипОтчета = "Внутренний" Или ПараметрыОткрытия.ТипОтчета = "Расширение" Тогда
		Вид = "Отчет";
		КлючЗамеров = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОткрытия, "КлючЗамеров");
		Если ЗначениеЗаполнено(КлючЗамеров) Тогда
			ПараметрыКлиента = ПараметрыКлиента();
			Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
				ПараметрыОткрытия.ВыполнятьЗамеры = Истина;
				ПараметрыОткрытия.Вставить("ИмяОперации", КлючЗамеров + ".Открытие");
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ПараметрыОткрытия.ТипОтчета = "Дополнительный" Тогда
		Вид = "ВнешнийОтчет";
		Если Не ПараметрыОткрытия.Свойство("Подключен") Тогда
			ВариантыОтчетовВызовСервера.ПриПодключенииОтчета(ПараметрыОткрытия);
		КонецЕсли;
		Если Не ПараметрыОткрытия.Подключен Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Вариант внешнего отчета можно открыть только из формы отчета.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ИмяОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определено имя отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	ПолноеИмяОтчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОткрытия, "ПолноеИмяОтчета");
	
	Если Не ЗначениеЗаполнено(ПолноеИмяОтчета) Тогда 
		ПолноеИмяОтчета = Вид + "." + ПараметрыОткрытия.ИмяОтчета;
	КонецЕсли;
	
	КлючУникальности = ОтчетыКлиентСервер.КлючУникальности(ПолноеИмяОтчета, ПараметрыОткрытия.КлючВарианта);
	ПараметрыОткрытия.Вставить("КлючПараметровПечати",        КлючУникальности);
	ПараметрыОткрытия.Вставить("КлючСохраненияПоложенияОкна", КлючУникальности);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.ЗамерВремени(
			ПараметрыОткрытия.ИмяОперации,,
			Ложь);
	КонецЕсли;
	
	ОткрытьФорму(ПолноеИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Истина);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Открывает панель отчетов. Для использования из модулей общих команд.
//
// Параметры:
//  ПутьКПодсистеме - Строка - имя раздела или путь к подсистеме, для которой открывается панель отчетов.
//                    Задается в формате: "ИмяРаздела[.ИмяВложеннойПодсистемы1][.ИмяВложеннойПодсистемы2][...]".
//                    Раздел должен быть описан в ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов.
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - параметры обработчика общей команды.
//
Процедура ПоказатьПанельОтчетов(ПутьКПодсистеме, ПараметрыВыполненияКоманды) Экспорт
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ФормаСсылка = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ПараметрыКлиента = ПараметрыКлиента();
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.ЗамерВремени(
			"ПанельОтчетов.Открытие",,
			Ложь);
		Комментарий = Новый Соответствие;
		Комментарий.Вставить("ПутьКПодсистеме", ПутьКПодсистеме);
		МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, Комментарий);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПанельОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно, ФормаСсылка);
	
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Оповещает открытые панели отчетов, формы списков и элементов о изменениях.
//
// Параметры:
//  Параметр - Произвольный - могут быть переданы любые необходимые данные.
//  Источник - Произвольный - источник события. Например, можно передать другую форму.
//
Процедура ОбновитьОткрытыеФормы(Параметр = Неопределено, Источник = Неопределено) Экспорт
	
	Оповестить(ИмяСобытияИзменениеВарианта(), Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт 
	
	Если Не СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьДействияСообщения", ВариантыОтчетовКлиент,,
		"ПриОшибкеОбработкиДействияСообщения", ВариантыОтчетовКлиент);
	
	Попытка
		СистемаВзаимодействия.ПодключитьОбработчикДействияСообщения(Обработчик);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Варианты отчетов.Ошибка подключения обработчика действия сообщения'",
				ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			"Ошибка",
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
КонецПроцедуры

// Открывает карточку варианта отчета с настройками размещения в программе.
//
// Параметры:
//  Вариант - СправочникСсылка.ВариантыОтчетов - ссылка варианта отчета.
//
Процедура ПоказатьНастройкиОтчета(Вариант) Экспорт
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Вариант);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.ФормаЭлемента", ПараметрыФормы);
КонецПроцедуры

// Открывает диалог настройки размещения нескольких вариантов в разделах.
//
// Параметры:
//   Варианты - Массив - перемещаемые варианты отчетов (СправочникСсылка.ВариантыОтчетов).
//   Владелец - ФормаКлиентскогоПриложения - для блокирования окна владельца.
//
Процедура ОткрытьДиалогРазмещенияВариантовВРазделах(Варианты, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(Варианты) <> Тип("Массив") Или Варианты.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов для размещения в разделах.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Варианты", Варианты);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.РазмещениеВРазделах", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриОшибкеОбработкиДействияСообщения(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Варианты отчетов.Ошибка обработки действия сообщения'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

Процедура ОбработатьДействияСообщения(Сообщение, Действие, ДополнительныеПараметры) Экспорт 
	
	Если Действие = ВариантыОтчетовКлиентСервер.ИмяДействияПрименитьПереданныеНастройки() Тогда 
		Оповестить(Действие, Сообщение.Данные);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - см. Синтакс-помощник.
//   Элемент - ПолеФормы - поле признака использования.
//
Процедура ДеревоПодсистемИспользованиеПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Использование = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Использование = 2 Тогда
		СтрокаДерева.Использование = 0;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//     * Элементы - ВсеЭлементыФормы - коллекция элементов формы, где:
//         ** ДеревоПодсистем - ТаблицаФормы - иерархическая коллекция подсистем, в которых отображается отчет, где:
//              *** ТекущиеДанные - ДанныеФормыЭлементДерева - данные текущей строки дерева подсистем, где:
//                    **** Важность - Строка - степени важности, принимающее значение - "", "Важный", "См. также".
//                    **** Приоритет - Строка - код-счетчик.
//                    **** Использование - Число - признак размещения отчета в данной подсистеме.
//   Элемент - ПолеФормы - поле для редактирования признака важности.
//
Процедура ДеревоПодсистемВажностьПриИзменении(Форма, Элемент) Экспорт
	
	ДеревоПодсистем = Форма.Элементы.ДеревоПодсистем;
	
	СтрокаДерева = ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Важность = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Важность <> "" Тогда
		СтрокаДерева.Использование = 1;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// См. ВариантыОтчетов.ПараметрыКлиента
Функция ПараметрыКлиента()
	ПараметрыКлиента = Новый Структура;
	ПараметрыКлиента.Вставить("ВыполнятьЗамеры",
		ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности"));
	
	Возврат ПараметрыКлиента;
КонецФункции

// Имя события оповещения для изменения варианта отчета.
Функция ИмяСобытияИзменениеВарианта() Экспорт
	Возврат "Запись_ВариантыОтчетов";
КонецФункции

// Имя события оповещения для изменения общих настроек.
Функция ИмяСобытияИзменениеОбщихНастроек() Экспорт
	Возврат ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы() + ".ИзменениеОбщихНастроек";
КонецФункции

// Возвращает тип ссылки дополнительного отчета.
Функция ТипСсылкиДополнительногоОтчета()
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		Возврат Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки");
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики списка пользователей варианта отчета

#Область ПараметрыПодбораПользователейВариантаОтчета

// Открывает форму выбора пользователей или групп (внешних) пользователей.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы.
//   ПодборГруппВнешнихПользователей - Булево - признак подбора групп внешних пользователей.
//
Процедура ПодобратьПользователейВариантаОтчета(Форма, ПодборГруппПользователей = Ложь, ПодборГруппВнешнихПользователей = Ложь) Экспорт 
	
	ПараметрыПодбора = ПараметрыПодбораПользователейВариантаОтчета(
		Форма, ПодборГруппПользователей, ПодборГруппВнешнихПользователей);
	
	Если ПодборГруппВнешнихПользователей Тогда 
		
		ИмяФормыПодбора = "Справочник.ГруппыВнешнихПользователей.ФормаВыбора";
		
	Иначе
		
		ИмяФормыПодбора = "Справочник.Пользователи.ФормаВыбора";
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыПодбора, ПараметрыПодбора, Форма.Элементы.ПользователиВарианта);
	
КонецПроцедуры

// Конструктор параметров подбора пользователей варианта отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы.
//   ПодборГруппВнешнихПользователей - Булево - признак подбора групп внешних пользователей.
//
// Возвращаемое значение:
//   Структура - параметры открытия формы подбора, где:
//       * РежимВыбора - Булево - признак режима выбора  (см. Синтакс-помощник - Расширение справочника).
//       * ТекущаяСтрока - СправочникСсылка.Пользователи
//                       - СправочникСсылка.ГруппыПользователей
//                       - СправочникСсылка.ГруппыВнешнихПользователей
//                       - Неопределено - текущий пользователь или группа (внешних) пользователей.
//       * ЗакрыватьПриВыборе - Булево - признак необходимости закрытия формы выбора (см. Синтакс-помощник - Расширение справочника).
//       * МножественныйВыбор - Булево - признак выбора двух строк и более.
//       * РасширенныйПодбор - Булево - признак использования расширенных параметров подбора.
//       * ЗаголовокФормыПодбора - Строка - заголовок формы подбора, соответствующий контексту.
//       * ВыбранныеПользователи - СписокЗначений - коллекция выбранных пользователей или групп (внешних) пользователей.
//
Функция ПараметрыПодбораПользователейВариантаОтчета(Форма, ПодборГруппПользователей, ПодборГруппВнешнихПользователей = Ложь)
	
	ТекущиеДанные = Форма.Элементы.ПользователиВарианта.ТекущиеДанные;
	ВыбранныеПользователи = ВыбранныеПользователиВарианта(Форма.ПользователиВарианта, ПодборГруппВнешнихПользователей);
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	ПараметрыПодбора.Вставить("ТекущаяСтрока", ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.Значение));
	ПараметрыПодбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыПодбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыПодбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыПодбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор пользователей варианта отчета'"));
	ПараметрыПодбора.Вставить("ВыборГруппПользователей", ПодборГруппПользователей);
	ПараметрыПодбора.Вставить("ВыбранныеПользователи", ВыбранныеПользователи);
	
	Возврат ПараметрыПодбора;
	
КонецФункции

Функция ВыбранныеПользователиВарианта(ПользователиВарианта, ПодборГруппВнешнихПользователей)
	
	ТипыВыбранныхПользователей = Новый ОписаниеТипов(
		"СправочникСсылка.ГруппыПользователей, СправочникСсылка.Пользователи");
	
	Если ПодборГруппВнешнихПользователей Тогда 
		ТипыВыбранныхПользователей = Новый ОписаниеТипов("СправочникСсылка.ГруппыВнешнихПользователей");
	КонецЕсли;
	
	ВыбранныеПользователи = Новый Массив;
	
	Для Каждого ЭлементСписка Из ПользователиВарианта Цикл 
		
		Если ЭлементСписка.Пометка
			И ТипыВыбранныхПользователей.СодержитТип(ТипЗнч(ЭлементСписка.Значение)) Тогда 
			
			ВыбранныеПользователи.Добавить(ЭлементСписка.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВыбранныеПользователи.Количество() = 1
		И ВыбранныеПользователи[0] = Неопределено Тогда 
		
		Если ПодборГруппВнешнихПользователей Тогда 
			ВыбранныеПользователи[0] = ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи");
		Иначе
			ВыбранныеПользователи[0] = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ВсеПользователи");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВыбранныеПользователи;
	
КонецФункции

#КонецОбласти

#Область ОбработкаВыбораПользователейВариантаОтчета

Процедура ПользователиВариантаОтчетаОбработкаВыбора(Форма, ВыбранныеЗначения, СтандартнаяОбработка) Экспорт 
	
	Если ТипЗнч(ВыбранныеЗначения) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПользователиВарианта = Форма.ПользователиВарианта;
	
	Если Не ЗначениеЗаполнено(ВыбранныеЗначения) Тогда
		ПользователиВарианта.Очистить();
		Возврат;
	КонецЕсли;
	
	ОбщаяГруппаПользователей = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ВсеПользователи");
	ОбщаяГруппаВнешниеПользователи = ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи");
	
	Если ТипЗнч(ВыбранныеЗначения[0]) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда 
		
		ПодготовитьСписокКДобавлениюВнешнихПользователейВариантаОтчета(
			ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаВнешниеПользователи);
		
	Иначе
		
		ПодготовитьСписокКДобавлениюПользователейВариантаОтчета(
			ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаПользователей);
		
	КонецЕсли;
	
	Для Каждого Значение Из ВыбранныеЗначения Цикл 
		
		Если ПользователиВарианта.НайтиПоЗначению(Значение) = Неопределено Тогда 
			ПользователиВарианта.Добавить(Значение,, Истина, КартинкаПользователяВариантаОтчета(Значение));
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПользователиВарианта.НайтиПоЗначению(ОбщаяГруппаПользователей) <> Неопределено
		И ПользователиВарианта.НайтиПоЗначению(ОбщаяГруппаВнешниеПользователи) <> Неопределено Тогда 
		
		ПользователиВарианта.Очистить();
		ПользователиВарианта.Добавить(,, Истина, КартинкаПользователяВариантаОтчета());
		
	КонецЕсли;
	
	ОформитьПользователейВариантаОтчета(Форма);
	
КонецПроцедуры

Процедура ПодготовитьСписокКДобавлениюПользователейВариантаОтчета(ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаПользователей)
	
	Если ПользователиВарианта.НайтиПоЗначению(Неопределено) <> Неопределено Тогда 
		
		ПользователиВарианта.Очистить();
		
	Иначе
		
		ТипыПользователей = Новый ОписаниеТипов("СправочникСсылка.ГруппыПользователей, СправочникСсылка.Пользователи");
		УдалитьПользователейВариантаОтчетаУказанныхТипов(ПользователиВарианта, ТипыПользователей);
		
	КонецЕсли;
	
	Если ВыбранныеЗначения.Найти(ОбщаяГруппаПользователей) = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВыбранныеЗначения.Очистить();
	ВыбранныеЗначения.Добавить(ОбщаяГруппаПользователей);
	
КонецПроцедуры

Процедура ПодготовитьСписокКДобавлениюВнешнихПользователейВариантаОтчета(ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаПользователей)
	
	Если ПользователиВарианта.НайтиПоЗначению(ОбщаяГруппаПользователей) <> Неопределено
		Или ПользователиВарианта.НайтиПоЗначению(Неопределено) <> Неопределено Тогда 
		
		ВыбранныеЗначения.Очистить();
		Возврат;
		
	КонецЕсли;
	
	Если ВыбранныеЗначения.Найти(ОбщаяГруппаПользователей) = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТипыПользователей = Новый ОписаниеТипов("СправочникСсылка.ГруппыВнешнихПользователей");
	УдалитьПользователейВариантаОтчетаУказанныхТипов(ПользователиВарианта, ТипыПользователей);
	
	ВыбранныеЗначения.Очистить();
	ВыбранныеЗначения.Добавить(ОбщаяГруппаПользователей);
	
КонецПроцедуры

Процедура УдалитьПользователейВариантаОтчетаУказанныхТипов(ПользователиВарианта, ТипыПользователей)
	
	ИндексЭлемента = ПользователиВарианта.Количество() - 1;
	
	Пока ИндексЭлемента >= 0 Цикл 
		
		ЭлементСписка = ПользователиВарианта[ИндексЭлемента];
		
		Если ТипыПользователей.СодержитТип(ТипЗнч(ЭлементСписка.Значение)) Тогда 
			
			ПользователиВарианта.Удалить(ЭлементСписка);
			
		КонецЕсли;
		
		ИндексЭлемента = ИндексЭлемента - 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПользователиВариантаОтчетаПрочее

Функция КартинкаПользователяВариантаОтчета(Пользователь = Неопределено)
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда 
		
		Возврат БиблиотекаКартинок.СостояниеПользователя02;
		
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда 
		
		Возврат БиблиотекаКартинок.СостояниеПользователя08;
		
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда 
		
		Возврат БиблиотекаКартинок.СостояниеПользователя10;
		
	КонецЕсли;
	
	Возврат БиблиотекаКартинок.СостояниеПользователя04;
	
КонецФункции

Процедура ПроверитьПользователейВариантаОтчета(Форма) Экспорт 
	
	Объект = Форма.Объект;
	
	Если Не Объект.ТолькоДляАвтора Тогда 
		Возврат;
	КонецЕсли;
	
	ПользователиВарианта = Форма.ПользователиВарианта;
	ПользователиВарианта.Очистить();
	ПользователиВарианта.Добавить(
		Объект.Автор,
		"[ЭтоАвторВариантаОтчета]",,
		КартинкаПользователяВариантаОтчета(Объект.Автор));
	
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы, где:
//             ** ПользователиВарианта - ТаблицаФормы - список пользователей варианта отчета.
//   СбрасыватьПризнакИспользования - Булево - признак необходимости выключения использования.
//
Процедура ОформитьПользователейВариантаОтчета(Форма, СбрасыватьПризнакИспользования = Истина) Экспорт 
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	ЦветНеактивныхЗначений = ПараметрыКлиента.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	ВариантАвтор = Объект.Автор;
	
	КоличествоПомеченных = 0;
	Для Каждого Строка Из Форма.ПользователиВарианта Цикл 
		Если Строка.Значение = ВариантАвтор Тогда
			ПризнакАвтора = "[ЭтоАвторВариантаОтчета]";
		Иначе
			ПризнакАвтора = "";
			КоличествоПомеченных = КоличествоПомеченных + Булево(Строка.Пометка);
		КонецЕсли;
		Если Строка.Представление <> ПризнакАвтора Тогда
			Строка.Представление = ПризнакАвтора;
		КонецЕсли;
	КонецЦикла;
	
	Если СбрасыватьПризнакИспользования Тогда 
		Если КоличествоПомеченных > 0 Тогда
			Объект.ТолькоДляАвтора = Ложь;
		КонецЕсли;
		Форма.Доступен = ?(Объект.ТолькоДляАвтора, "Автору", "Всем");
	КонецЕсли;
	
	Элементы.ПользователиВарианта.ЦветТекста = ?(Объект.ТолькоДляАвтора, ЦветНеактивныхЗначений, Новый Цвет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеВариантаОтчетаИзФайла

Функция ИмяСобытияОбновленияВариантовОтчетовИзФайлов() Экспорт  
	
	Возврат "ОбновитьВариантыОтчетовИзФайлов";
	
КонецФункции

// Параметры:
//  СвойстваВариантаОтчета - см. СвойстваВариантаОтчетаОснования
//  ИдентификаторФормы - УникальныйИдентификатор
// 
Процедура ОбновитьВариантОтчетаИзФайлов(СвойстваВариантаОтчета, ИдентификаторФормы) Экспорт

	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Сведения об отчете (*.zip)|*.zip'");
	ПараметрыЗагрузки.ИдентификаторФормы = ИдентификаторФормы;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьВариантыОтчетовИзФайловЗавершение", ЭтотОбъект, 
		СвойстваВариантаОтчета);
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(Обработчик, ПараметрыЗагрузки);

КонецПроцедуры

// Параметры:
//   ОписаниеФайлов - Массив из Структура:
//     * Хранение - Строка
//     * Имя - Строка
//   СвойстваВариантаОтчетаОснования - см. СвойстваВариантаОтчетаОснования
//
Процедура ОбновитьВариантыОтчетовИзФайловЗавершение(ОписаниеФайлов, СвойстваВариантаОтчетаОснования) Экспорт 
	
	Если ТипЗнч(ОписаниеФайлов) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОписаниеФайлов.Количество() = 1 Тогда 
		ОбновитьВариантОтчетаИзФайла(ОписаниеФайлов[0], СвойстваВариантаОтчетаОснования);
		Возврат;
	КонецЕсли;
	
	СвойстваВариантовОтчетов = ВариантыОтчетовВызовСервера.ОбновитьВариантыОтчетовИзФайлов(ОписаниеФайлов);
	ТекстУведомления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Загружены из файла: %1'"), СвойстваВариантовОтчетов.Количество());
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Отчеты обновлены'"),, ТекстУведомления);
	Оповестить(ИмяСобытияОбновленияВариантовОтчетовИзФайлов(), СвойстваВариантовОтчетов);
	
КонецПроцедуры

// Параметры:
//   ОписаниеФайла - Структура:
//     * Хранение - Строка
//     * Имя - Строка
//   СвойстваВариантаОтчетаОснования - см. СвойстваВариантаОтчетаОснования
//
Процедура ОбновитьВариантОтчетаИзФайла(ОписаниеФайла, СвойстваВариантаОтчетаОснования) 
	
	Если ОписаниеФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СвойстваВариантаОтчетаОснования = Неопределено Тогда 
		СвойстваВариантаОтчетаОснования = СвойстваВариантаОтчетаОснования();
	КонецЕсли;
	
	СвойстваВариантаОтчета = ВариантыОтчетовВызовСервера.ОбновитьВариантОтчетаИзФайла(ОписаниеФайла, 
		СвойстваВариантаОтчетаОснования.Ссылка);
	Если СвойстваВариантаОтчетаОснования.ИмяОтчета = СвойстваВариантаОтчета.ИмяОтчета Тогда 
		
		ПараметрыОбновленияФормы = Новый Структура("КлючВарианта");
		ЗаполнитьЗначенияСвойств(ПараметрыОбновленияФормы, СвойстваВариантаОтчета);
		
		ОбновитьОткрытыеФормы(ПараметрыОбновленияФормы);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Отчет обновлен из файла'"), 
			ПолучитьНавигационнуюСсылку(СвойстваВариантаОтчета.Ссылка),
			СвойстваВариантаОтчета.ПредставлениеВарианта);
		
	ИначеЕсли СвойстваВариантаОтчетаОснования.ПредставлениеВарианта = СвойстваВариантаОтчета.ПредставлениеВарианта Тогда 
		
		ОткрытьФормуОтчета(Неопределено, СвойстваВариантаОтчета.Ссылка);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Отчет обновлен из файла'"), 
			ПолучитьНавигационнуюСсылку(СвойстваВариантаОтчета.Ссылка),
			СвойстваВариантаОтчета.ПредставлениеВарианта);
		
	Иначе
		
		Обработчик = Новый ОписаниеОповещения(
			"ОткрытьФормуВыбранногоВариантаОтчета", ЭтотОбъект, СвойстваВариантаОтчета.Ссылка);
		
		ШаблонТекстаВопроса = НСтр("ru = 'Выбраны настройки варианта отчета ""%1"",
			|которые не совпадают с ""%2"".
			|Замена настроек выбранного варианта отчета невозможна.
			|
			|Создать новый вариант отчета (или обновить существующий при наличии)?'");
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонТекстаВопроса,
			СвойстваВариантаОтчета.ПредставлениеВарианта,
			СвойстваВариантаОтчетаОснования.ПредставлениеВарианта);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Ответ - КодВозвратаДиалога
//   ВариантОтчета - СправочникСсылка.ВариантыОтчетов
//
Процедура ОткрытьФормуВыбранногоВариантаОтчета(Ответ, ВариантОтчета) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ОткрытьФормуОтчета(Неопределено, ВариантОтчета);
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//   Структура:
//     * Ссылка - СправочникСсылка.ВариантыОтчетов
//     * ИмяОтчета - Строка
//     * ПредставлениеВарианта - Строка
//
Функция СвойстваВариантаОтчетаОснования() Экспорт
	
	Возврат Новый Структура("Ссылка, ИмяОтчета, ПредставлениеВарианта");
	
КонецФункции

#КонецОбласти

#Область ОбменПользовательскимиНастройками

// Открывает форму выбора пользователей, (групп) пользователей.
//
// Параметры:
//  ОписаниеНастроек - Структура - параметры открытия формы выбора пользователей, (групп) пользователей, где:
//      * Настройки - ПользовательскиеНастройкиКомпоновкиДанных - настройки, которыми обмениваются.
//      * ВариантОтчета - СправочникСсылка.ВариантыОтчетов - ссылка на хранилище свойств варианта отчета.
//      * КлючОбъекта - Строка - измерение хранения настроек.
//      * КлючНастроек - Строка - измерение - идентификатор пользовательских настроек.
//      * Представление - Строка - наименование пользовательских настроек.
//      * ВариантМодифицирован - Булево - признак того, что вариант отчета изменен.
//
Процедура ПоделитьсяПользовательскимиНастройками(ОписаниеНастроек) Экспорт 
	
	Если ОписаниеНастроек.Настройки.Элементы.Количество() = 0 Тогда 
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Настройки (пользовательские) не установлены.'"));
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	ПараметрыПодбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыПодбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыПодбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыПодбора.Вставить("СкрытьПользователейБезПользователяИБ", Истина);
	ПараметрыПодбора.Вставить("ВыбранныеПользователи", Новый Массив);
	ПараметрыПодбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Поделиться настройками отчета с пользователями'"));
	ПараметрыПодбора.Вставить("ЗаголовокКнопкиЗавершенияПодбора", НСтр("ru = 'Поделиться'"));
	
	Обработчик = Новый ОписаниеОповещения(
		"ПоделитьсяПользовательскимиНастройкамиПослеВыбораПользователей", ВариантыОтчетовКлиент, ОписаниеНастроек);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыПодбора,,,,, Обработчик);
	
КонецПроцедуры

Процедура ПоделитьсяПользовательскимиНастройкамиПослеВыбораПользователей(ВыбранныеПользователи, ОписаниеНастроек) Экспорт 
	
	Если ВыбранныеПользователи = Неопределено
		Или ВыбранныеПользователи.Количество() = 0 Тогда 
		
		Возврат;
	КонецЕсли;
	
	ВариантыОтчетовВызовСервера.ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек);
	
	Предупреждение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеНастроек, "Предупреждение");
	
	Если ЗначениеЗаполнено(Предупреждение) Тогда 
		
		ПоказатьПредупреждение(, Предупреждение);
		Возврат;
		
	КонецЕсли;
	
	Пояснение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеНастроек, "Пояснение", "");
	ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки переданы'"),, Пояснение);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
