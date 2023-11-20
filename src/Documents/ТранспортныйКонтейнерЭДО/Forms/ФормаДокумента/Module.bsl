
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектронныеДокументы.Параметры.УстановитьЗначениеПараметра("ТранспортныйКонтейнер", Объект.Ссылка);
	Статус = Объект.Статус;
	ЗаполнитьСписокВыбораСтатусовКонтейнера();
	
	ОбновитьВидимостьДоступность();
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭД.КонтекстныеПодсказки_ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПанельКонтекстныхНовостей, Элементы.ГруппаКонтекстныхПодсказок);
	СформироватьКонтекст();
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Статус = Объект.Статус;
	СтатусыКРаспаковке = ТранспортныеКонтейнерыЭДО.СтатусыНеРаспакованныхТранспортныхСообщенийБЭД();
	Элементы.КомандаРаспаковатьКонтейнер.Видимость = СтатусыКРаспаковке.Найти(Объект.Статус) <> Неопределено;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.Статус = Статус Тогда
		ТекущийОбъект.Статус = Статус;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораСтатусовКонтейнера();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Прочитать();
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭлектронныеДокументы.Параметры.УстановитьЗначениеПараметра("ТранспортныйКонтейнер", Объект.Ссылка);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭлектронныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументСообщенияЭДО(Элемент.ТекущиеДанные.Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РаспаковатьКонтейнер(Команда)
	
	Контейнеры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка);
	ТранспортныеКонтейнерыЭДОСлужебныйКлиент.РаспаковатьКонтейнеры(Контейнеры);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Статус = ПредопределенноеЗначение("Перечисление.СтатусыТранспортныхСообщенийБЭД.Отменен");
	Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораСтатусовКонтейнера()
	
	Если Объект.Направление = Перечисления.НаправленияЭДО.Входящий Тогда
		Элементы.Статус.СписокВыбора.ЗагрузитьЗначения(СписокСтатусовВходящий());
	Иначе
		Элементы.Статус.СписокВыбора.ЗагрузитьЗначения(СписокСтатусовИсходящий());
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокСтатусовВходящий()
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.КРаспаковке);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Распакован);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.РаспакованДокументыНеОбработаны);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Неизвестный);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отменен);
	
	Возврат МассивСтатусов;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокСтатусовИсходящий()
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Доставлен);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отправлен);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.ПодготовленКОтправке);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отменен);
	
	Возврат МассивСтатусов;
	
КонецФункции

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
	ЭтоИсходящийКонтейнер = (Объект.Направление = Перечисления.НаправленияЭДО.Исходящий);
	ЭтоВходящийКонтейнер = (Объект.Направление = Перечисления.НаправленияЭДО.Входящий);
	
	Элементы.ГруппаИсторияОбработкиВходящий.Видимость = Не ЭтоИсходящийКонтейнер;
	Элементы.ГруппаИсторияОбработкиИсходящий.Видимость = Не ЭтоВходящийКонтейнер;
	
	ИспользуютсяДоговорыКонтрагентов = ИнтеграцияЭДО.ИспользуютсяДоговорыКонтрагентов();
	Элементы.ДоговорКонтрагента.Видимость    = ИспользуютсяДоговорыКонтрагентов;
	Элементы.ДекорацияПустаяОтступ.Видимость = ИспользуютсяДоговорыКонтрагентов;
	Элементы.Отменить.Видимость = ЭтоИсходящийКонтейнер;
	
КонецПроцедуры

#Область КонтекстныеПодсказки

&НаКлиенте
Процедура Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие(Элемент)
	
	КонтекстныеПодсказкиБЭДКлиент.ЭлементУправленияНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКонтекст(КатегорииПересчета = Неопределено) 
	
	Если Не КонтекстныеПодсказкиБЭД.ФункционалКонтекстныхПодсказокДоступен() Тогда 
		Возврат;
	КонецЕсли;
	
	Категория = КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_ОператорАбонента();
	Если ЗначениеЗаполнено(Категория)  
			И ?(ЗначениеЗаполнено(КатегорииПересчета), КатегорииПересчета.Найти(Категория) <> Неопределено, Истина) Тогда 
		Значение = КонтекстныеПодсказкиБЭДКатегоризация.ОператорАбонента(Объект.Получатель); 
		КонтекстныеПодсказкиБЭДКлиентСервер.УстановитьЗначениеКатегорииКонтекстаФормы(ЭтаФорма, Категория, Значение);
	КонецЕсли;
	
	Категория = КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации();
	Если ЗначениеЗаполнено(Категория)  
			И ?(ЗначениеЗаполнено(КатегорииПересчета), КатегорииПересчета.Найти(Категория) <> Неопределено, Истина) Тогда 
		Значение = КонтекстныеПодсказкиБЭДКатегоризация.КодОператораУчетнойЗаписиОрганизации(Объект.Организация); 
		КонтекстныеПодсказкиБЭДКлиентСервер.УстановитьЗначениеКатегорииКонтекстаФормы(ЭтаФорма, Категория, Значение);
	КонецЕсли;
		
	КонтекстныеПодсказкиБЭД.ОтобразитьАктуальныеДляКонтекстаНовости(ЭтотОбъект);
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные).
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";	
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПанельКонтекстныхНовостейОбработкаНавигационнойСсылки(Элемент, ПараметрНавигационнаяСсылка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	КонтекстныеПодсказкиБЭДКлиент.ПанельКонтекстныхНовостей_ЭлементПанелиНовостейОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		ПараметрНавигационнаяСсылка,
		СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти 

#КонецОбласти