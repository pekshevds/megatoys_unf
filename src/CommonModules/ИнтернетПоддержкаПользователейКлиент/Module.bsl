///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейКлиент.
//
// Клиентские процедуры и функции Интернет-поддержки пользователей:
//  - определение настроек подключения;
//  - переход к подключению Интернет-поддержки пользователей;
//  - переход на страницы интегрированных сайтов;
//  - обработка событий приложения.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Возвращает настройки соединения с серверами Интернет-поддержки.
//
// Возвращаемое значение:
//  Структура - настройки соединения. Поля структуры:
//      * УстанавливатьПодключениеНаСервере - Булево - Истина, если подключение
//        устанавливается на сервере 1С:Предприятие;
//      * ТаймаутПодключения - Число - таймаут подключения к серверам в секундах;
//      * ДоменРасположенияСерверовИПП - Число - если 0, устанавливать подключение
//        к серверам ИПП в доменной зоне 1c.ru, если 1 - в доменной зоне 1c.eu.
//
Функция НастройкиСоединенияССерверами() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнтернетПоддержкаПользователей;
	Результат = Новый Структура("ДоменРасположенияСерверовИПП");
	ЗаполнитьЗначенияСвойств(Результат, ПараметрыРаботыКлиента);
	Результат.Вставить("УстанавливатьПодключениеНаСервере", Истина);
	Результат.Вставить("ТаймаутПодключения"               , 30);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область АутентификацияВСервисахИнтернетПоддержки

// Выполняет подключение к сервису Интернет-поддержки: ввод данных
// аутентификации (логина и пароля) для подключения к сервисам
// Интернет-поддержки.
// При успешном завершении возвращается введенный логин через
// объект ОписаниеОповещения.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - обработчик оповещения о
//          завершении. В обработчик оповещения возвращается значение:
//          Неопределено - при нажатии пользователем кнопки Отмена;
//          Структура, при успешном вводе логина и пароля.
//          Поля структуры:
//            * Логин - Строка - введенный логин;
//  ВладелецФормы - ФормаКлиентскогоПриложения - владелец формы подключения
//          Интернет-поддержки. Т.к. форма подключения Интернет-поддержки открывается
//          в режиме "Блокировать окно владельца", рекомендуется заполнять
//          значение этого параметра;
//
Процедура ПодключитьИнтернетПоддержкуПользователей(
		ОповещениеОЗавершении = Неопределено,
		ВладелецФормы = Неопределено) Экспорт
	
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		
		ОповещениеАвторизацияНедоступна = Новый ОписаниеОповещения(
			"ПриНедоступностиПодключенияИПП",
			ЭтотОбъект,
			ОповещениеОЗавершении);
		
		ПоказатьПредупреждение(
			ОповещениеАвторизацияНедоступна,
			НСтр("ru = 'Использование Интернет-поддержки пользователей недоступно при работе в модели сервиса.'"));
		Возврат;
		
	КонецЕсли;
	
	// Проверить права пользователя для интерактивной авторизации.
	Если Не ДоступноПодключениеИнтернетПоддержки() Тогда
		
		ОповещениеАвторизацияНедоступна = Новый ОписаниеОповещения(
			"ПриНедоступностиПодключенияИПП",
			ЭтотОбъект,
			ОповещениеОЗавершении);
		
		ПоказатьПредупреждение(
			ОповещениеАвторизацияНедоступна,
			НСтр("ru = 'Недостаточно прав для подключения Интернет-поддержки пользователей. Обратитесь к администратору.'"));
		Возврат;
		
	КонецЕсли;
	
	// Открыть форму подключения ИПП.
	ОткрытьФорму("ОбщаяФорма.ПодключениеИнтернетПоддержки",
		,
		ВладелецФормы,
		,
		,
		,
		ОповещениеОЗавершении);
	
КонецПроцедуры

// Определяет, доступно ли текущему пользователю выполнение интерактивного
// подключения Интернет-поддержки в соответствии с текущим режимом работы
// и правами пользователя.
//
// Возвращаемое значение:
//  Булево - Истина - интерактивное подключение доступно,
//           Ложь - в противном случае.
//
Функция ДоступноПодключениеИнтернетПоддержки() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнтернетПоддержкаПользователей;
	Возврат ПараметрыРаботыКлиента.ДоступноПодключениеИнтернетПоддержки;
	
КонецФункции

#КонецОбласти

#Область ПереходПоСсылкеНаПортал

// Открывает страницу сайта, система аутентификации которого интегрирована с
// Порталом 1С:ИТС.
// В зависимости от текущего режима работы информационной базы и наличия у
// текущего пользователя информационной базы соответствующих прав
// страница сайта может быть открыта с учетными данными пользователя Портала 1С:ИТС,
// для которого подключена Интернет-поддержка.
//
// Параметры:
//  URLСтраницыСайта - Строка - URL страницы сайта;
//  ЗаголовокОкна - Строка - заголовок окна для методов:
//      - ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу()
//      - ИнтеграцияПодсистемБИПКлиент.ОткрытьИнтернетСтраницу(),
//        если используется.
//
Процедура ОткрытьСтраницуИнтегрированногоСайта(URLСтраницыСайта, ЗаголовокОкна = "") Экспорт
	
	Состояние(, , НСтр("ru = 'Пожалуйста, подождите...'"));
	РезультатПолученияURL =
		ИнтернетПоддержкаПользователейВызовСервера.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(
			URLСтраницыСайта);
	Состояние();
	
	Если Не ПустаяСтрока(РезультатПолученияURL.КодОшибки)
		И РезультатПолученияURL.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
		ПоказатьОповещениеПользователя(
			,
			,
			НСтр("ru = 'Ошибка входа на Портал 1С:ИТС.
				|Подробнее см. в журнале регистрации.'"),
			БиблиотекаКартинок.Ошибка32);
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияПодсистемБИПКлиент.ОткрытьИнтернетСтраницу(
		РезультатПолученияURL.URL,
		ЗаголовокОкна,
		СтандартнаяОбработка);
	ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу(
		РезультатПолученияURL.URL,
		ЗаголовокОкна,
		СтандартнаяОбработка);
	
	Если СтандартнаяОбработка = Истина Тогда
		// Открытие Интернет-страницы стандартным способом.
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(РезультатПолученияURL.URL);
	КонецЕсли;
	
КонецПроцедуры

// Открывает главную страницу Портала.
//
Процедура ОткрытьГлавнуюСтраницуПортала() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(
			"?needAccessToken=true",
			НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП),
		НСтр("ru = 'Портал 1С:ИТС'"));
	
КонецПроцедуры

// Открывает страницу Портала для регистрации нового пользователя.
//
Процедура ОткрытьСтраницуРегистрацииНовогоПользователя() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
			"/registration",
			НастройкиСоединенияССерверами()),
		НСтр("ru = 'Регистрация'"));
	
КонецПроцедуры

// Открывает страницу Портала для восстановления пароля.
//
Процедура ОткрытьСтраницуВосстановленияПароля() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
			"/remind_request",
			НастройкиСоединенияССерверами()),
		НСтр("ru = 'Восстановление пароля'"));
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияСБиблиотекойСтандартныхПодсистем

// См. процедуру ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	// ПодключениеСервисовСопровождения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПодключениеСервисовСопровождения") Тогда
		МодульПодключениеСервисовСопровожденияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключениеСервисовСопровожденияКлиент");
		МодульПодключениеСервисовСопровожденияКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец ПодключениеСервисовСопровождения
	
	// ПолучениеОбновленийПрограмм
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
		МодульПолучениеОбновленийПрограммыКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец ПолучениеОбновленийПрограммыКлиент
	
	// МониторПортала1СИТС
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторПортала1СИТС") Тогда
		МодульМониторПортала1СИТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МониторПортала1СИТСКлиент");
		МодульМониторПортала1СИТСКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец МониторПортала1СИТС
	
	// СПАРКРиски
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец СПАРКРиски
	
	// ОблачныйАрхив20
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив20") Тогда
		МодульОблачныйАрхив20Клиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхив20Клиент");
		МодульОблачныйАрхив20Клиент.ПриНачалеРаботыСистемы(Параметры);
	КонецЕсли;
	// Конец ОблачныйАрхив20
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Преобразует значение из фиксированного типа.
// Параметры:
//  ЗначениеФиксированногоТипа - Произвольный - значение фиксированного типа
//       из которого необходимо получить значение нефиксированного типа.
//
// Возвращаемое значение:
//  Произвольный - полученное значение аналогичного нефиксированного типа.
//
Функция ЗначениеИзФиксированногоТипа(ЗначениеФиксированногоТипа) Экспорт

	Результат = Неопределено;
	ТипЗначения = ТипЗнч(ЗначениеФиксированногоТипа);

	Если ТипЗначения = Тип("ФиксированнаяСтруктура") Тогда

		Результат = Новый Структура;
		Для каждого КлючЗначение Из ЗначениеФиксированногоТипа Цикл
			Результат.Вставить(КлючЗначение.Ключ, ЗначениеИзФиксированногоТипа(КлючЗначение.Значение));
		КонецЦикла;

	ИначеЕсли ТипЗначения = Тип("ФиксированноеСоответствие") Тогда

		Результат = Новый Соответствие;
		Для каждого КлючЗначение Из ЗначениеФиксированногоТипа Цикл
			Результат.Вставить(КлючЗначение.Ключ, ЗначениеИзФиксированногоТипа(КлючЗначение.Значение));
		КонецЦикла;

	ИначеЕсли ТипЗначения = Тип("ФиксированныйМассив") Тогда

		Результат = Новый Массив;
		Для каждого ЭлементМассива Из ЗначениеФиксированногоТипа Цикл
			Результат.Добавить(ЗначениеИзФиксированногоТипа(ЭлементМассива));
		КонецЦикла;

	Иначе

		Результат = ЗначениеФиксированногоТипа;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Получает значение параметра приложения.
//
// Устанавливает значение параметра приложения.
//
// Параметры:
//  ИмяПараметра - Строка - идентификатор параметра;
//  ЗначениеПоУмолчанию - Произвольный - значение параметра по умолчанию;
//
// Возвращаемое значение:
//  Произвольный - значение параметра.
//
Функция ЗначениеПараметраПриложения(ИмяПараметра, ЗначениеПоУмолчанию = Неопределено) Экспорт

	ПараметрыБиблиотеки = ПараметрыПриложения.Получить("ИнтернетПоддержкаПользователей");
	Если ПараметрыБиблиотеки = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;

	ЗначениеПараметра = ПараметрыБиблиотеки.Получить(ИмяПараметра);
	Возврат ?(ЗначениеПараметра = Неопределено, ЗначениеПоУмолчанию, ЗначениеПараметра);

КонецФункции

// Устанавливает значение параметра приложения.
//
// Параметры:
//  ИмяПараметра - Строка - идентификатор параметра;
//  ЗначениеПараметра - Произвольный - новое значение параметра;
//
Процедура УстановитьЗначениеПараметраПриложения(ИмяПараметра, ЗначениеПараметра) Экспорт

	ПараметрыБиблиотеки = ПараметрыПриложения.Получить("ИнтернетПоддержкаПользователей");
	Если ПараметрыБиблиотеки = Неопределено Тогда
		ПараметрыБиблиотеки = Новый Соответствие;
		ПараметрыПриложения.Вставить(
			"ИнтернетПоддержкаПользователей",
			ПараметрыБиблиотеки);
	КонецЕсли;

	ПараметрыБиблиотеки.Вставить(ИмяПараметра, ЗначениеПараметра);

КонецПроцедуры

// Возвращает текст заголовка элемента формы из строки или форматированной строки.
//
Функция ТекстФорматированногоЗаголовка(Заголовок) Экспорт
	
	Если ТипЗнч(Заголовок) <> Тип("ФорматированнаяСтрока") Тогда
		Возврат Заголовок;
	КонецЕсли;
	
	ФДок = Новый ФорматированныйДокумент;
	ФДок.УстановитьФорматированнуюСтроку(Заголовок);
	Возврат ФДок.ПолучитьТекст();
	
КонецФункции

// Устанавливает видимость кнопки формы "Копировать в буфер".
//
// Параметры:
//  Элементы - ВсеЭлементыФормы - элементы формы владельца.
//
Процедура УстановитьОтображениеКнопкиКопироватьВБуфер(Элементы) Экспорт
	
	ТипПлатформыКлиента = ОбщегоНазначенияКлиент.ТипПлатформыКлиента();	
	#Если ВебКлиент Тогда 
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
		
	ОтображатьКнопкуКопироватьВБуфер = (ТипПлатформыКлиента = ТипПлатформы.Windows_x86 
		ИЛИ ТипПлатформыКлиента = ТипПлатформы.Windows_x86_64)
		И Не ЭтоВебКлиент;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"КопироватьВБуфер",
		"Видимость",
		ОтображатьКнопкуКопироватьВБуфер);
		
КонецПроцедуры

#КонецОбласти

#Область ПереходПоСсылкеНаПортал

// Открывает Интернет-страницу в обозревателе.
//
// Параметры:
//  АдресСтраницы - Строка - URL-адрес открываемой страницы;
//  ЗаголовокОкна - Строка - заголовок открываемой страницы,
//   если для открытия страницы используется внутренняя форма конфигурации;
//  Логин - Строка - логин для авторизации на портале поддержи пользователей;
//  Пароль - Строка - пароль для авторизации на портале поддержки пользователей;
//
Процедура ОткрытьВебСтраницу(
		Знач АдресСтраницы,
		ЗаголовокОкна = "",
		Логин = Неопределено,
		Пароль = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗаголовокОкна", ЗаголовокОкна);
	ДополнительныеПараметры.Вставить("Логин"        , Логин);
	ДополнительныеПараметры.Вставить("Пароль"       , Пароль);
	
	ОткрытьВебСтраницуСДополнительнымиПараметрами(
		АдресСтраницы,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает Интернет-страницу в обозревателе.
//
// Параметры:
//  АдресСтраницы - Строка - URL-адрес открываемой страницы;
//  ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры открытия страницы.
//
Процедура ОткрытьВебСтраницуСДополнительнымиПараметрами(
	Знач АдресСтраницы,
	Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗаголовокОкна"              , "");
	ПараметрыОткрытия.Вставить("Логин"                      , "");
	ПараметрыОткрытия.Вставить("Пароль"                     , "");
	ПараметрыОткрытия.Вставить("ЭтоПолноправныйПользователь", Неопределено);
	ПараметрыОткрытия.Вставить("НастройкиПрокси"            , Неопределено);
	ПараметрыОткрытия.Вставить("НастройкиСоединения"        , Неопределено);
	ПараметрыОткрытия.Вставить("РазделениеВключено"         , Ложь);
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ДополнительныеПараметры);
	КонецЕсли;
	
	Если ПараметрыОткрытия.ЭтоПолноправныйПользователь = Неопределено Тогда
		ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
		ПараметрыОткрытия.ЭтоПолноправныйПользователь =
			ПараметрыРаботыКлиента.ЭтоПолноправныйПользователь;
		ПараметрыОткрытия.РазделениеВключено = ПараметрыРаботыКлиента.РазделениеВключено;
	КонецЕсли;
	
	НеобходимаАвторизации = (СтрНайти(АдресСтраницы, "?needAccessToken=true") > 0
		Или СтрНайти(АдресСтраницы, "&needAccessToken=true") > 0);
	
	Если НеобходимаАвторизации Тогда
		// Удаление параметра из URL
		
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "?needAccessToken=true&", "");
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "?needAccessToken=true" , "");
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "&needAccessToken=true&", "");
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "&needAccessToken=true" , "");
		
	КонецЕсли;
	
	URL = АдресСтраницы;
	Если НеобходимаАвторизации И ПараметрыОткрытия.ЭтоПолноправныйПользователь Тогда
		
		// Получение URL для открытия страницы.
		Состояние(, , НСтр("ru = 'Переход на Портал 1С:ИТС'"));
		РезультатПолученияURL =
			ИнтернетПоддержкаПользователейВызовСервера.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(АдресСтраницы);
		Состояние();
		
		Если Не ПустаяСтрока(РезультатПолученияURL.КодОшибки)
			И РезультатПолученияURL.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
			ПоказатьОповещениеПользователя(
				,
				,
				НСтр("ru = 'Ошибка входа на Портал 1С:ИТС.
					|Подробнее см. в журнале регистрации.'"),
				БиблиотекаКартинок.Ошибка32);
		КонецЕсли;
		
		URL = РезультатПолученияURL.URL;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияПодсистемБИПКлиент.ОткрытьИнтернетСтраницу(
		URL,
		ПараметрыОткрытия.ЗаголовокОкна,
		СтандартнаяОбработка);
	ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу(
		URL,
		ПараметрыОткрытия.ЗаголовокОкна,
		СтандартнаяОбработка);
	
	Если СтандартнаяОбработка = Истина Тогда
		// Открытие Интернет-страницы стандартным способом.
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(URL);
	КонецЕсли;
	
КонецПроцедуры

// Открывает личный кабинет пользователя в обозревателе.
//
Процедура ОткрытьЛичныйКабинетПользователя() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(
			"/software?needAccessToken=true",
			НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП),
		НСтр("ru = 'Личный кабинет пользователя'"));
	
КонецПроцедуры

// Открывает личный кабинет пользователя в обозревателе.
//
Процедура ОткрытьСтраницуОфициальнаяПоддержка() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(
			"/support?needAccessToken=true",
			НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП),
		НСтр("ru = 'Официальная поддержка'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОтображениеСекретныхДанныхНаФорме

// Устанавливает видимость кнопки отображения символов.
//
// Параметры:
//  Элемент  - ПолеФормы - элемент формы с секретными данными.
//
Процедура ПриИзмененииСекретныхДанных(Элемент) Экспорт
	
	Если Элемент.КнопкаВыбора = Неопределено Тогда
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.ВводимыеСимволыВидны;
		Элемент.КнопкаВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Изменяет режим отображения символов поля с секретными данными.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, на которой обрабатываются секретные данные.
//  Элемент - ПолеФормы - элемент формы с секретными данными.
//  ИмяРеквизита - Строка - имя реквизита формы для обновления данных.
//
Процедура ОтобразитьСекретныеДанные(Форма, Элемент, ИмяРеквизита) Экспорт
	
	Элемент.РежимПароля = Не Элемент.РежимПароля;
	Форма[ИмяРеквизита] = Элемент.ТекстРедактирования;
	Если Элемент.РежимПароля Тогда
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.ВводимыеСимволыВидны;
	Иначе
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.ВводимыеСимволыСкрыты;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработка оповещения недоступности подключения Интернет-поддержки.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - оповещение для вызова.
//
Процедура ПриНедоступностиПодключенияИПП(ОповещениеОЗавершении) Экспорт

	Если ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Неопределено);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
