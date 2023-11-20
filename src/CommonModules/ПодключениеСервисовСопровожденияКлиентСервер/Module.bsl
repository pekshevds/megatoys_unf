///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ПодключениеСервисовСопровожденияКлиентСервер.
//
// Клиент-серверные процедуры и функции подключения тестовых периодов.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает новые параметры формы обработки ПодключениеСервисовСопровождения.Формы.ПодключениеТестовогоПериода,
// которые используются для отображения состояния подключения.
//
// Параметры
//  ИдентификаторТестовогоПериода - Строка - уникальный идентификатор тестового периода;
//  Наименование                  - Строка - наименование тестового периода;
//  Идентификатор                 - Строка - уникальный идентификатор тестового периода;
//  ИдентификаторЗапроса          - Строка - идентификатор запроса на подключение;
//  ОписаниеОшибки                - Строка - описание ошибки при подключении;
//  СостояниеПодключения          - Перечисление.СостоянияПодключенияСервисов - состояние запроса на подключение;
//  РежимРегламентногоЗадания     - Булево - если истина, после получения подтверждения,
//                                  будет удалена информация о запросе и регламентное задание.
//
// Возвращаемое значение:
//   Структура - параметры формы.
//
Функция НовыйПараметрыФормыОтобразитьРезультат(
		ИдентификаторТестовогоПериода,
		Наименование,
		Идентификатор,
		ИдентификаторЗапроса,
		ОписаниеОшибки,
		СостояниеПодключения = Неопределено,
		РежимРегламентногоЗадания = Ложь) Экспорт
	
	ПараметрыОтображения = Новый Структура;
	ПараметрыОтображения.Вставить("ИдентификаторТестовогоПериода", ИдентификаторТестовогоПериода);
	ПараметрыОтображения.Вставить("Наименование",                  Наименование);
	ПараметрыОтображения.Вставить("ИдентификаторЗапроса",          ИдентификаторЗапроса);
	ПараметрыОтображения.Вставить("ИнформацияОбОшибке",            ОписаниеОшибки);
	ПараметрыОтображения.Вставить("СостояниеПодключения",          СостояниеПодключения);
	ПараметрыОтображения.Вставить("РежимРегламентногоЗадания",     РежимРегламентногоЗадания);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыОтображения", ПараметрыОтображения);
	ПараметрыФормы.Вставить("Идентификатор",        Идентификатор);
	ПараметрыФормы.Вставить("ОтобразитьРезультат",  Истина);
	
	Возврат ПараметрыФормы;
	
КонецФункции

// Настройка отображения формы подключения тестового периода.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - Форма подключения тестового периода;
//  Подключение - Булево - Признак подключения.
//
Процедура НастроитьОтображениеФормы(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Если Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения") Тогда
		Элементы[ИмяЭлемента("ДекорацияИнформацияОбОшибке")].Заголовок = Форма.ИнформацияОбОшибке;
	ИначеЕсли Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен") Тогда
		Элементы[ИмяЭлемента("ДекорацияНадписьПодключен")].Заголовок = НСтр("ru = 'Сервис успешно подключен.'");
	ИначеЕсли Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно") Тогда
		Элементы[ИмяЭлемента("ДекорацияИнформацияОбОшибке")].Заголовок = НСтр("ru = 'Ошибка при получении доступных тестовых периодов:
			|Не обнаружены доступные тестовые периоды.'");
	КонецЕсли;
	
	УстановитьВидимостьДоступностьКнопокПодключения(Форма);
	
КонецПроцедуры

// Настройка отображения кнопок подключения тестового периода.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - Форма подключения тестового периода;
//  Подключение - Булево - Признак подключения.
//
Процедура УстановитьВидимостьДоступностьКнопокПодключения(Форма, Подключение = Ложь) Экспорт
	
	Элементы = Форма.Элементы;
	СостояниеПодключения = Форма.СостояниеПодключения;
	ПараметрыПодключения = Форма.ДанныеПодключения.ПараметрыПодключения;
	ЭлементСтраницыПодключения = Элементы[ИмяЭлемента("СтраницыПодключения")];
	ЭлементКомандаДалее = Элементы[ПараметрыПодключения.ИмяЭлементаКомандыДалее];
	
	Если Подключение Тогда
		ЭлементСтраницыПодключения.ТекущаяСтраница = Элементы[ИмяЭлемента("ГруппаДлительнаяОперация")];
		ЭлементКомандаДалее.Видимость              = Ложь;
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения") Тогда
		ЭлементСтраницыПодключения.ТекущаяСтраница = Элементы[ИмяЭлемента("ГруппаОшибка")];
		ЭлементКомандаДалее.Видимость              = Истина;
		ЭлементКомандаДалее.Заголовок              = НСтр("ru = 'Повторить попытку'");
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение") Тогда
		ЭлементКомандаДалее.Видимость              = Истина;
		ЭлементКомандаДалее.Заголовок              = НСтр("ru = 'Проверить подключение'");
		ЭлементСтраницыПодключения.ТекущаяСтраница = Элементы[ИмяЭлемента("ГруппаОшибкаТаймаут")];
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен") Тогда
		ЭлементСтраницыПодключения.ТекущаяСтраница = Элементы[ИмяЭлемента("ГруппаПодключенТестовыйПериод")];
		ЭлементКомандаДалее.Видимость              = Ложь;
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно") Тогда
		ЭлементКомандаДалее.Видимость              = Ложь;
	ИначеЕсли ПодключениеДоступно(СостояниеПодключения) Тогда
		ЭлементСтраницыПодключения.ТекущаяСтраница = Элементы[ИмяЭлемента("ГруппаДоступныеТестовыеПериоды")];
		ЭлементКомандаДалее.Видимость              = Истина;
		ЭлементКомандаДалее.Заголовок              = НСтр("ru = 'Подключить'");
	КонецЕсли;
	
КонецПроцедуры

// Определяет доступность подключения тестового периода.
//
// Возвращаемое значение:
//   Булево - Доступность подключения.
//
Функция ПодключениеДоступно(Знач СостояниеПодключения) Экспорт
	
	Результат = (СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.НеПодключен")
		Или СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения"));
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя элемента для размещения реквизитов тестовых периодов на форме.
//
// Параметры:
//  ИмяЭлемента - Строка - имя элемента;
//  Постфикс - Строка - постфикс имени
//
// Возвращаемое значение:
//   Строка - новое имя элемента.
//
Функция ИмяЭлемента(ИмяЭлемента, Постфикс = "") Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"%1%2%3",
		"ПодключениеТестовогоПериода_",
		ИмяЭлемента,
		Постфикс);
		
КонецФункции

// Возвращает идентификатор имени события оповещения заполнения данных формы.
//
// Возвращаемое значение:
//  Строка
//
Функция ИмяСобытияЗаполненияДанныхФормы() Экспорт
	Возврат "ЗаполнитьДанныеФормы";
КонецФункции

// Возвращает идентификатор имени события оповещения действия при заполнении тестовых периодов.
//
// Возвращаемое значение:
//  Строка
//
Функция ИмяСобытияДействияПриОтображенииТестовыхПериодов() Экспорт
	Возврат "ПриОтображенииТестовыхПериодов";
КонецФункции

// Возвращает идентификатор имени события оповещения действия перед закрытием формы подключения тестового периода.
//
// Возвращаемое значение:
//  Строка
//
Функция ИмяСобытияПередЗакрытиемФормыПодключения() Экспорт
	Возврат "ПередЗакрытиемФормыПодключения";
КонецФункции

#КонецОбласти
