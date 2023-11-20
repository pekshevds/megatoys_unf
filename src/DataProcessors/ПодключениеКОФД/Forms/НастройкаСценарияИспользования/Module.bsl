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
	
	Касса = Параметры.Касса;
	НастройкаПодключения = Параметры.НастройкаПодключения;
	НастройкиИнтеграцииОФД = ОФДСлужебный.НастройкиИнтеграции();
	
	НастройкиИнтеграцииОФД.Вставить("ИдентификаторИспользуемогоСценария", Неопределено);
	Если НастройкиИнтеграцииОФД.КоличествоИспользуемыхСценариев = 1 Тогда
		Для Каждого Настройка Из НастройкиИнтеграцииОФД Цикл
			Если Настройка.Значение = Истина Тогда
				НастройкиИнтеграцииОФД.Вставить("ИдентификаторИспользуемогоСценария", Настройка.Ключ);
				ИдентификаторВыбранногоСценария = Настройка.Ключ;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Элементы.ГруппаБазовый.Видимость = НастройкиИнтеграцииОФД.ИспользоватьЗагрузкуИтоговСмены;
	Элементы.ГруппаРасширенный.Видимость = НастройкиИнтеграцииОФД.ИспользоватьЗагрузкуДокументов;
	
	ЗаполненыДанныеАутентификации
		= ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
		
	Если Не ЗаполненыДанныеАутентификации Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
	ИначеЕсли Не ЗначениеЗаполнено(НастройкиИнтеграцииОФД.ИдентификаторИспользуемогоСценария) Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
		Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Выполняется получение списка касс по данным ОФД.'");
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(НастройкиИнтеграцииОФД.ИдентификаторИспользуемогоСценария) Тогда
		ПолучитьКассы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МагазинОбработкаВыбора(
		Элемент,
		ВыбранноеЗначение,
		ДополнительныеДанные,
		СтандартнаяОбработка)
	
	Значение                = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	МагазинЗначение         = ВыбранноеЗначение;
	РегистрационныйНомерККТ = "";
	ЗаводскойНомерФН        = "";
	
	ЗаполнитьСписокКасс();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКассыОбработкаВыбора(
		Элемент,
		ВыбранноеЗначение,
		ДополнительныеДанные,
		СтандартнаяОбработка)
	
	Значение = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	ПредставлениеКассыЗначение = ВыбранноеЗначение;
	
	РегистрационныйНомерККТ = ДанныеКасс[МагазинЗначение][ПредставлениеКассыЗначение].РегистрационныйНомер;
	ЗаводскойНомерФН        = ДанныеКасс[МагазинЗначение][ПредставлениеКассыЗначение].НомерФискальногоНакопителя;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОписаниеРезультатаОбработкаНавигационнойСсылки(
	Элемент,
	НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "open:log" Тогда
		СтандартнаяОбработка = Ложь;
		ОФДКлиент.ОткрытьЖурналРегистрации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
			ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				,
				ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольИПППриИзменении(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ПриИзмененииСекретныхДанных(
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольИППНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтернетПоддержкаПользователейКлиент.ОтобразитьСекретныеДанные(
		ЭтотОбъект,
		Элемент,
		"ПарольИПП");
	
КонецПроцедуры

&НаКлиенте
Процедура БазовыйСценарийРасширеннаяПодсказкаОбработкаНавигационнойСсылки(
	Элемент,
	НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "open:totalsVerification" Тогда
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
			"https://portal.1c.ru/applications/1C-OFD-receipt#totalsVerification");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасширенныйСценарийРасширеннаяПодсказкаОбработкаНавигационнойСсылки(
	Элемент,
	НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "open:totalsVerification" Тогда
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
			"https://portal.1c.ru/applications/1C-OFD-receipt#totalsVerification");
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "open:receiptsData" Тогда
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
			"https://portal.1c.ru/applications/1C-OFD-receipt#receiptsData");
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "open:salesData" Тогда
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
			"https://portal.1c.ru/applications/1C-OFD-receipt#salesData");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Отказ = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		
		Результат = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьДанныеАутентификации(
			Новый Структура("Логин, Пароль",
			ЛогинИПП, ПарольИПП));
		
		Если Результат.Отказ Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				Результат.СообщениеОбОшибке,
				,
				Результат.Поле);
			Возврат;
		КонецЕсли;
		
		ПроверитьПодключениеКПорталу1СИТС(
			ЛогинИПП,
			ПарольИПП,
			Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ЛогинИПП = "";
		ПарольИПП = "";
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария Тогда
		
		Если Не ЗначениеЗаполнено(ИдентификаторВыбранногоСценария) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Для продолжения необходимо выбрать сценарий использования кассы.'"));
			Возврат;
		КонецЕсли;
		
		Если Не СписокКассПолучен Тогда
			ПолучитьКассы();
		Иначе
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКассы;
		КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКассы Тогда 
		
		Если Не ЗначениеЗаполнено(РегистрационныйНомерККТ) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Для продолжения необходимо выбрать магазин и кассу.'"));
			Возврат;
		КонецЕсли;
		
		ВыполнитьПодключениеКассы();
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат Тогда
		
		ЭтотОбъект.Закрыть(РезультатНастройки);
		
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКассы Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат И Не СписокКассПолучен Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат И СписокКассПолучен Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКассы
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ПроверитьПодключениеКПорталу1СИТС(Логин, Пароль, Отказ)
	
	РезультатПроверки = ИнтернетПоддержкаПользователей.ПроверитьЛогинИПароль(
		Логин,
		Пароль);
	
	Если РезультатПроверки.Результат Тогда
		
		ДанныеАутентификации = Новый Структура;
		ДанныеАутентификации.Вставить("Логин", Логин);
		ДанныеАутентификации.Вставить("Пароль", Пароль);
		
		УстановитьПривилегированныйРежим(Истина);
		ИнтернетПоддержкаПользователей.СохранитьДанныеАутентификации(
			ДанныеАутентификации);
		УстановитьПривилегированныйРежим(Ложь);
	Иначе
		ОбщегоНазначения.СообщитьПользователю(
			РезультатПроверки.СообщениеОбОшибке,
			,
			,
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу
		Или Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКассы Тогда
		Элементы.Назад.Видимость
			= Не ЗначениеЗаполнено(НастройкиИнтеграцииОФД.ИдентификаторИспользуемогоСценария);
		Элементы.Далее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат Тогда
		Если ПодключениеЗавершено Тогда
			Элементы.Назад.Видимость  = Ложь;
			Элементы.Отмена.Видимость = Ложь;
			Элементы.Далее.Видимость  = Истина;
			Элементы.Далее.Заголовок  = НСтр("ru = 'OK'");
		Иначе
			Элементы.Назад.Видимость  = Истина;
			Элементы.Отмена.Видимость = Истина;
			Элементы.Далее.Видимость  = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключениеКассы()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Операция подключения кассы на портале.'");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("РегистрационныйНомерККТ", РегистрационныйНомерККТ);
	ПараметрыПроцедуры.Вставить("ИдентификаторТарифа",     ИдентификаторВыбранногоСценария);
	ПараметрыПроцедуры.Вставить("НастройкаПодключения",    НастройкаПодключения);
	ПараметрыПроцедуры.Вставить(
		"Касса",
		Элементы.ПредставлениеКассы.СписокВыбора.НайтиПоЗначению(ПредставлениеКассы).Представление);
	
	РезультатВыполнения = ПодключитьКассуЗапускЗадания(
		ПараметрыПроцедуры,
		ЭтотОбъект.УникальныйИдентификатор);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПодключитьКассуЗавершение",
		ЭтотОбъект);
	
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		ПодключитьКассуЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Выполняется попытка подключения кассы.'");
	
	УстановитьВидимостьДоступность();
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодключитьКассуЗапускЗадания(
	Знач ПараметрыФункции,
	Знач УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания
		= НСтр("ru = 'Подключение кассы на портале.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		"СервисИнтеграцииСОФД.ПодключитьКассу",
		ПараметрыФункции);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ПодключитьКассуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеИнформацииОбОшибке(РезультатОперации.СообщениеОбОшибке);
		Иначе
			
			РезультатНастройки = Новый Структура;
			РезультатНастройки.Вставить("СценарийИспользования",   ИдентификаторВыбранногоСценария);
			РезультатНастройки.Вставить("НастройкаПодключения",    НастройкаПодключения);
			РезультатНастройки.Вставить("РегистрационныйНомерККТ", РегистрационныйНомерККТ);
			РезультатНастройки.Вставить("ЗаводскойНомерФН",        ЗаводскойНомерФН);
			РезультатНастройки.Вставить("СценарийИспользования",   ИдентификаторВыбранногоСценария);
			РезультатНастройки.Вставить(
				"Магазин",
				Элементы.Магазин.СписокВыбора.НайтиПоЗначению(Магазин).Представление);
			РезультатНастройки.Вставить(
				"ПредставлениеКассы",
				Элементы.ПредставлениеКассы.СписокВыбора.НайтиПоЗначению(ПредставлениеКассы).Представление);
			
			ЗаписатьНастройкиКассы(Касса, РезультатНастройки);
			
			УстановитьОтображениеУспешногоЗавершения();
			
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		УстановитьОтображениеИнформацииОбОшибке(Результат.КраткоеПредставлениеОшибки)
		
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьНастройкиКассы(Знач Касса, Знач РезультатНастройки)
	
	РегистрыСведений.НастройкиКассОФД.ЗаписатьНастройкиКассы(
		Касса,
		РезультатНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКассы()
	
	ДанныеКасс = Неопределено;
	Магазин    = Неопределено;
	ПредставлениеКассы      = Неопределено;
	
	Элементы.Магазин.СписокВыбора.Очистить();
	Элементы.ПредставлениеКассы.СписокВыбора.Очистить();
	
	Если Не ЗначениеЗаполнено(НастройкаПодключения) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	РезультатВыполнения = ПолучитьКассыЗапускЗадания();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПолучитьКассыЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		ПолучитьКассыЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ПолучитьКассыЗапускЗадания()
	
	Элементы.ДекорацияСостояние.Заголовок =
		НСтр("ru = 'Получение списка касс по данным ОФД. Пожалуйста подождите.'");
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	
	ПараметрыФункции = Новый Структура;
	ПараметрыФункции.Вставить("НастройкаПодключения", НастройкаПодключения);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(
		ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания
		= НСтр("ru = 'Получение списка касс по данным оператора фискальных данных.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		"ОФДСлужебный.КассыНастройкиПодключения",
		ПараметрыФункции);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьКассыЗавершение(
		Результат,
		ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеИнформацииОбОшибке(РезультатОперации.СообщениеОбОшибке);
		Иначе
			
			ДанныеКасс = Новый Структура;
			
			Для Каждого КлючЗначение Из РезультатОперации.ДанныеКасс Цикл
				
				ОписаниеКасс = Новый Структура;
				
				Для Каждого ОписаниеКассы Из КлючЗначение.ПереченьКасс Цикл
					
					ДанныеКассы = Новый Структура;
					ДанныеКассы.Вставить(
						"Наименование",
						ОписаниеКассы.Наименование);
					ДанныеКассы.Вставить(
						"НомерФискальногоНакопителя",
						ОписаниеКассы.НомерФискальногоНакопителя);
					ДанныеКассы.Вставить(
						"РегистрационныйНомер",
						ОписаниеКассы.РегистрационныйНомер);
					
					ОписаниеКасс.Вставить(ОписаниеКассы.Идентификатор, ДанныеКассы);
					
				КонецЦикла;
				
				Элементы.Магазин.СписокВыбора.Добавить(
					КлючЗначение.Идентификатор,
					КлючЗначение.Наименование);
				ДанныеКасс.Вставить(
					КлючЗначение.Идентификатор,
					ОписаниеКасс);
				
			КонецЦикла;
			
			Если ЗначениеЗаполнено(ИдентификаторВыбранногоСценария) Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКассы;
			Иначе
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборСценария;
			КонецЕсли;
			
			СписокКассПолучен = Истина;
			
		КонецЕсли;
		
		УстановитьВидимостьДоступность();
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		УстановитьОтображениеИнформацииОбОшибке(Результат.КраткоеПредставлениеОшибки);
		
		ИдентификаторВыбранногоСценария = "ОшибкаПолученияДанных";
		
		УстановитьВидимостьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокКасс()
	
	Элементы.ПредставлениеКассы.СписокВыбора.Очистить();
	
	Для Каждого ОписаниеКассы Из ДанныеКасс[МагазинЗначение] Цикл
		Элементы.ПредставлениеКассы.СписокВыбора.Добавить(
			ОписаниеКассы.Ключ,
			ОписаниеКассы.Значение.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеИнформацииОбОшибке(
		ИнформацияОбОшибке,
		Ошибка = Истина,
		ОтображатьЖР = Истина)
	
	Если ОтображатьЖР Тогда
		
		ПредставлениеОшибки = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|
					|
					|Подробную информацию см. в %2.'"),
				ИнформацияОбОшибке,
				?(
					ОФДВызовСервера.ЭтоПолноправныйПользователь(),
					НСтр("ru = '<a href = ""open:log"">Журнале регистрации</a>'"),
					НСтр("ru = 'Журнале регистрации'"))));
		
	Иначе
		ПредставлениеОшибки = ИнформацияОбОшибке;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат;
	Элементы.ДекорацияОписаниеРезультата.Заголовок = ПредставлениеОшибки;
	Элементы.ДекорацияКартинкаРезультат.Картинка = ?(Ошибка,
		БиблиотекаКартинок.Ошибка32,
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеУспешногоЗавершения()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат;
	Элементы.ДекорацияКартинкаРезультат.Картинка = БиблиотекаКартинок.Успешно32;
	ПодключениеЗавершено = Истина;
	Элементы.ДекорацияОписаниеРезультата.Заголовок = НСтр("ru = 'Касса успешно подключена.'");
	
КонецПроцедуры

#КонецОбласти
