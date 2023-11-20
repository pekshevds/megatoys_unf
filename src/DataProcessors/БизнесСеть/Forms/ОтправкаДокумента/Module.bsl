
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.МассивСсылокНаОбъект) <> Тип("Массив") ИЛИ Параметры.МассивСсылокНаОбъект.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.МассивСсылокНаОбъект[0];
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МассивСсылокНаОбъект = Параметры.МассивСсылокНаОбъект;
	РеквизитыДокумента = ОбменСКонтрагентамиИнтеграция.ОписаниеОснованияЭлектронногоДокумента(Ссылка);
	Организация = РеквизитыДокумента.Организация;
	Контрагент = РеквизитыДокумента.Контрагент;
	ЭлектронныйАдресУведомления = ""; 
	ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(Контрагент, ЭлектронныйАдресУведомления);
	
	ЭДНадпись = Ссылка.Метаданные().Синоним + " " + Ссылка.Номер + " " + Формат(Ссылка.Дата, "ДЛФ=D");
	
	ТекстОрганизации = НСтр("ru = 'Для отправки документа подключите организацию %1 к сервису 1С:Бизнес-сеть.'");
	ТекстОрганизации = СтрШаблон(ТекстОрганизации, Организация);
	Элементы.ТекстРегистрацииОрганизации.Заголовок = ТекстОрганизации;
	
	ТекстКонтрагента = НСтр("ru = 'Контрагент ""%1"" не зарегистрирован в сервисе 1С:Бизнес-сеть.'");
	ТекстКонтрагента = СтрШаблон(ТекстКонтрагента, Контрагент);
	Элементы.ТекстРегистрацииКонтрагента.Заголовок = ТекстКонтрагента;
	
	Если ОбменСКонтрагентами.ОрганизацияПодключена(Организация) Тогда
		Элементы.ДекорацияПодключенияЭДО.Видимость = Ложь;
	КонецЕсли;
	
	// Проверка организации.
	ОрганизацияЗарегистрирована = БизнесСеть.ОрганизацияПодключена(Организация);
	
	ЗагрузитьПодготовленныеДанныеЭД(МассивСсылокНаОбъект, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована Тогда
		ЕстьПодключениеКСервису = Истина;
	Иначе
		ЕстьПодключениеКСервису = БизнесСеть.ОрганизацияПодключена();
	КонецЕсли;
	
	Если ЕстьПодключениеКСервису Тогда
		КонтрагентЗарегистрирован = КонтрагентЗарегистрирован(Организация, Контрагент, Отказ);
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована И КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_Стандартный";
	ИначеЕсли ОрганизацияЗарегистрирована И Не КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияКонтрагента";
	ИначеЕсли Не ОрганизацияЗарегистрирована И КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияОрганизации";
	Иначе
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияОрганизацииКонтрагента";
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована Тогда
		ОбновитьСписокИсторииОтправки(Отказ);
	КонецЕсли;
	
	СтруктураКонтактныхДанных = БизнесСеть.ОписаниеКонтактнойИнформацииПользователя();
	БизнесСетьПереопределяемый.ПолучитьКонтактнуюИнформациюПользователя(Пользователи.ТекущийПользователь(), СтруктураКонтактныхДанных);
	КонтактноеЛицо = СтруктураКонтактныхДанных.ФИО;
	Телефон = СтруктураКонтактныхДанных.Телефон;
	ЭлектроннаяПочта = СтруктураКонтактныхДанных.ЭлектроннаяПочта;
	
	ИзменитьВидимостьДоступностьЭлементов();
	ОтобразитьОжиданиеВыполненияОтправкиДокумента(Ложь, Элементы.КартинкаОжиданиеВыполненияОтправки);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не НаправитьУведомление Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ЭлектронныйАдресУведомления"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесСетьСлужебныйКлиент.ОткрытьПрофильУчастника(Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОчиститьСообщения();
	
	Если СписокИстории.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	ЗаполнитьСписокДокументовИстории(МассивСтруктур);
	
	Если МассивСтруктур.Количество() = 1 Тогда
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента",
			Новый Структура("СтруктураЭД", МассивСтруктур[0]), ЭтотОбъект);
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("СтруктураЭД", МассивСтруктур);
		ПараметрыОткрытия.Вставить("РежимПросмотраИстории", Истина);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ИсторияОтправки", ПараметрыОткрытия, ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОчиститьСообщения();
	
	Если ТаблицаДанных.Количество() > 1 Тогда
		
		МассивСтруктур = Новый Массив;
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			ПараметрыЭД = НовыеПараметрыДокумента();
			ПараметрыЭД.АдресХранилища    = СтрокаДанных.АдресХранилища;
			ПараметрыЭД.ФайлАрхива        = Истина;
			ПараметрыЭД.НаименованиеФайла = СтрокаДанных.НаименованиеФайла;
			ПараметрыЭД.НаправлениеЭД     = СтрокаДанных.НаправлениеЭД;
			ПараметрыЭД.Контрагент        = СтрокаДанных.Контрагент;
			ПараметрыЭД.ВладелецЭД        = СтрокаДанных.ВладелецЭД;
			ПараметрыЭД.Источник          = СтрокаДанных.Источник;
			ПараметрыЭД.ПубличнаяСсылкаQRКода        = СтрокаДанных.ПубличнаяСсылкаQRКода;
			ПараметрыЭД.ИзображениеQRКода            = ПолучитьИзВременногоХранилища(СтрокаДанных.АдресХранилищаКартинкиQRКода);
			ПараметрыЭД.ИдентификаторВременнойСсылки = СтрокаДанных.ИдентификаторВременнойСсылки;
			ПараметрыЭД.АдресХранилищаПредставления  = СтрокаДанных.АдресХранилищаПредставления;
			
			МассивСтруктур.Добавить(ПараметрыЭД);
		КонецЦикла;
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ИсторияОтправки",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтотОбъект);
			
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ПараметрыЭД = НовыеПараметрыДокумента(Истина);
		ПараметрыЭД.ФайлАрхива = Истина;
		ПараметрыЭД.СопроводительнаяИнформация = СопроводительнаяИнформация;
		ЗаполнитьЗначенияСвойств(ПараметрыЭД, ТаблицаДанных[0]);
		АдресХранилищаКартинкиQRКода = ТаблицаДанных[0].АдресХранилищаКартинкиQRКода;
		Если ЗначениеЗаполнено(АдресХранилищаКартинкиQRКода) Тогда
			ПараметрыЭД.ИзображениеQRКода = ПолучитьИзВременногоХранилища(АдресХранилищаКартинкиQRКода);
		КонецЕсли;
		ПараметрыЭД.АдресХранилищаПредставления = ТаблицаДанных[0].АдресХранилищаПредставления;
		ПараметрыФормы = Новый Структура("СтруктураЭД", ПараметрыЭД);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправитьУведомлениеПриИзменении(Элемент)
	
	Элементы.ЭлектронныйАдресУведомления.Доступность = НаправитьУведомление;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаПриИзменении(Элемент)
	
	УстановитьДоступностьФлагаУведомлятьПоПочте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьДокумент(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта, Истина) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты введен неверно'"),,
			"ЭлектроннаяПочта",,);
		Возврат;
	КонецЕсли;
	
	Если НаправитьУведомление И Не ПустаяСтрока(ЭлектронныйАдресУведомления)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектронныйАдресУведомления, Истина) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты контрагента введен неверно'"),,
			"ЭлектронныйАдресУведомления",,);
		Возврат;
	КонецЕсли;
	
	ОтправитьДокументыВСервис();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОрганизацию(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьОрганизациюПродолжение", ЭтотОбъект);
	
	БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Организация, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КонтрагентЗарегистрирован(Организация, Контрагент, Отказ)
	
	ПараметрыМетода = БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов();
	ПараметрыМетода.Ссылка      = Контрагент;
	ПараметрыМетода.Организация = Организация;
	
	ДанныеСервиса = БизнесСеть.РеквизитыУчастника(ПараметрыМетода, Отказ);
	
	Результат = Ложь;
	
	Если Не Отказ И ЗначениеЗаполнено(ДанныеСервиса) Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПодключитьОрганизациюПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.СтатусПодключения = "Подключена" Тогда
		ПодключитьОрганизациюПродолжениеНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьОрганизациюПродолжениеНаСервере()
	
	ОрганизацияЗарегистрирована         = Истина;
	ЕстьПодключениеКСервису             = Истина;
	Элементы.Зарегистрировать.Видимость = Ложь;
	
	Отказ = Ложь;
	
	// Проверка регистрации контрагента.
	КонтрагентЗарегистрирован = КонтрагентЗарегистрирован(Организация, Контрагент, Отказ);
	
	// Обновление истории отправки.
	ОбновитьСписокИсторииОтправки(Отказ);
	
	ОбновитьФайлПредставления();
	
	// Обновление видимости элементов.
	ИзменитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеЭД(СсылкиНаДокументы, Отказ)
	
	ТекстОшибки = "";
	
	ТаблицаЭД = БизнесСеть.ТаблицаЭлектронныхДокументовСформированныхЧерезБизнесСеть(
		СсылкиНаДокументы, ОрганизацияЗарегистрирована, УникальныйИдентификатор, Отказ, ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
	Если ТаблицаЭД = Неопределено Или Отказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТаблицаДанных.Загрузить(ТаблицаЭД);
	
	ТекстГиперссылки = НСтр("ru = 'документы не найдены'");
	Если ТаблицаДанных.Количество() > 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'открыть список (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных.Количество());
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ТекстГиперссылки = ТаблицаДанных[0].НаименованиеФайла;
	КонецЕсли;
	
	ЭДНадпись = ТекстГиперссылки;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьЭлементов()
	
	Элементы.РегистрацияОрганизации.Видимость = Не ОрганизацияЗарегистрирована;
	Элементы.РегистрацияКонтрагента.Видимость = Не КонтрагентЗарегистрирован И ЕстьПодключениеКСервису;
	Элементы.Контрагент.Видимость = КонтрагентЗарегистрирован;
	
	Элементы.Зарегистрировать.Видимость = Не ОрганизацияЗарегистрирована;
	
	Если Не ОрганизацияЗарегистрирована И Не КонтрагентЗарегистрирован Тогда
		Элементы.ТекстРегистрацииКонтрагента.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.ЧертаСверху, 1);
	КонецЕсли;
	
	ТребуетсяОтправкаУведомления = НЕ КонтрагентЗарегистрирован И ЗначениеЗаполнено(ЭлектронныйАдресУведомления);
	НаправитьУведомление = ТребуетсяОтправкаУведомления;
	Элементы.ЭлектронныйАдресУведомления.Доступность = ТребуетсяОтправкаУведомления;
	
	Если СписокИстории.Количество() = 0 Тогда
		Элементы.История.Гиперссылка = Ложь;
		Состояние = НСтр("ru = 'не отправлен'");
	ИначеЕсли СписокИстории.Количество() = 1 Тогда
		Элементы.История.Гиперссылка = Истина;
		ОтправленныеДанные = СписокИстории[0];
		Если ВРег(ОтправленныеДанные.Статус) = "ДОСТАВЛЕН" Тогда
			Состояние = НСтр("ru = 'доставлен'") + " " + Формат(ОтправленныеДанные.ДатаДоставки, "ДЛФ=D");
		Иначе
			Состояние = НСтр("ru = 'отправлен'") + " " + Формат(ОтправленныеДанные.Дата, "ДЛФ=D");
		КонецЕсли;
	Иначе
		Элементы.История.Гиперссылка = Истина;	
		ШаблонСостояния = НСтр("ru = 'отправлено (%1)'");
		Состояние = СтрШаблон(ШаблонСостояния, СписокИстории.Количество());
	КонецЕсли;
	
	Элементы.Отправить.Доступность = ОрганизацияЗарегистрирована;
	
	Элементы.УведомлятьПоПочте.Доступность = Не ПустаяСтрока(ЭлектроннаяПочта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДокументыВСервис()
	
	Если Не ОрганизацияЗарегистрирована Тогда
		Возврат;
	КонецЕсли;
	
	ОперацияОтправкиДокументов = ОтправитьДанныеДокументовЧерезБизнесСетьНаСервере();
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОтправитьДанныеДокументовЧерезБизнесСетьЗавершение", ЭтотОбъект);
	
	ОповещениеДляОбработки = Новый ОписаниеОповещения("ОтправитьДокументИПолучитьQRКодЧерезБизнесСетьЗавершение",
													БизнесСетьКлиент,
													Новый Структура("ОповещениеПриЗавершении", ОповещениеПриЗавершении));

	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ИдентификаторЗадания = ОперацияОтправкиДокументов.ИдентификаторЗадания;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ОперацияОтправкиДокументов, ОповещениеДляОбработки, ПараметрыОжидания);
	
	ОтобразитьОжиданиеВыполненияОтправкиДокумента(Истина, Элементы.КартинкаОжиданиеВыполненияОтправки);
	УстановитьАктивностьЭлементовФормы(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ОтправитьДанныеДокументовЧерезБизнесСетьНаСервере()
	
	ДополнительнаяИнформация = Новый Структура;
	ДополнительнаяИнформация.Вставить("СопроводительнаяИнформация", СопроводительнаяИнформация);
	ДополнительнаяИнформация.Вставить("КонтактноеЛицо",             КонтактноеЛицо);
	ДополнительнаяИнформация.Вставить("Телефон",                    Телефон);
	ДополнительнаяИнформация.Вставить("ЭлектроннаяПочта",           ЭлектроннаяПочта);
	ДополнительнаяИнформация.Вставить("УведомлятьПоПочте",          УведомлятьПоПочте);

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДополнительнаяИнформация", ДополнительнаяИнформация);
	
	ТаблицаЗначенийДанных = ТаблицаДанных.Выгрузить();
	ТаблицаДокументов = Новый Массив;
	Для Каждого СтрокаДанных Из ТаблицаЗначенийДанных Цикл
		ДанныеДокумента = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаДанных);
		ДанныеДокумента.Вставить("ДвоичныеДанныеПакета", ПолучитьИзВременногоХранилища(СтрокаДанных.АдресХранилища));
		ДанныеДокумента.Вставить("ДвоичныеДанныеПредставления", ПолучитьИзВременногоХранилища(СтрокаДанных.АдресХранилищаПредставления));
		ТаблицаДокументов.Добавить(ДанныеДокумента);
	КонецЦикла;
	
	ДополнительныеПараметры.Вставить("ТаблицаДокументов", ТаблицаДокументов);

	
	Возврат БизнесСеть.ОтправитьДанныеДокументовЧерезБизнесСетьВФоне(Новый УникальныйИдентификатор,
																					Неопределено,
																					ДополнительныеПараметры);
																								
КонецФункции

&НаКлиенте
Процедура ОтправитьДанныеДокументовЧерезБизнесСетьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Организация) 
		И БизнесСетьКлиент.ТребуетсяПовторноеПодключениеОрганизации(Организация) Тогда
		
		Оповещение = Новый ОписаниеОповещения("ОтправитьДокументыВСервисПослеПодключения", ЭтотОбъект);
		БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Организация, ЭтотОбъект, Оповещение);
		Возврат;
	КонецЕсли;
	
	Если Результат = Неопределено Или ТипЗнч(Результат) <> Тип("Структура") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Не удалось отправить документ. %1'"), БизнесСетьКлиентСервер.ПодробностиВЖурналеРегистрации()));
		ОтобразитьОжиданиеВыполненияОтправкиДокумента(Ложь, Элементы.КартинкаОжиданиеВыполненияОтправки);
		УстановитьАктивностьЭлементовФормы(Истина);
		Возврат;
	КонецЕсли;
	
	// Направление уведомления об отправке электронного документа через сервис.
	Если НаправитьУведомление Тогда
		
		ИдентификаторыСервиса = Результат.ИдентификаторыСервисаПоДокументам;
		МассивИдентификаторов = Новый Массив;
		Для Каждого ЭлементКоллекции Из ИдентификаторыСервиса Цикл
			МассивИдентификаторов.Добавить(ЭлементКоллекции.Ключ);
		КонецЦикла;
		
		ПараметрыМетода = Новый Структура;
		ПараметрыМетода.Вставить("Отправитель",           Организация);
		ПараметрыМетода.Вставить("Получатель",            Контрагент);
		ПараметрыМетода.Вставить("МассивИдентификаторов", МассивИдентификаторов);
		ПараметрыМетода.Вставить("ЭлектроннаяПочта",      ЭлектронныйАдресУведомления);
	
		БизнесСетьКлиент.ОтправитьУведомлениеОбОтправкиДокументаВСервис(ЭтотОбъект,
																		Новый УникальныйИдентификатор,
																		ПараметрыМетода);
	КонецЕсли;

	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДокументыВСервисПослеПодключения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтправитьДокументыВСервис();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьОжиданиеВыполненияОтправкиДокумента(Знач Видимость, КартинкаОжиданиеВыполненияОтправки)

	КартинкаОжиданиеВыполненияОтправки.Видимость = Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАктивностьЭлементовФормы(Активна)
	
	Элементы.НаправитьУведомление.ТолькоПросмотр        = Не Активна;
	Элементы.ЭлектронныйАдресУведомления.ТолькоПросмотр = Не Активна;
	Элементы.Документ.ТолькоПросмотр                    = Не Активна;
	Элементы.СопроводительнаяИнформация.ТолькоПросмотр  = Не Активна;
	Элементы.История.ТолькоПросмотр                     = Не Активна;
	Элементы.КонтактноеЛицо.ТолькоПросмотр              = Не Активна;
	Элементы.Телефон.ТолькоПросмотр                     = Не Активна;
	Элементы.ЭлектроннаяПочта.ТолькоПросмотр            = Не Активна;
	Элементы.УведомлятьПоПочте.ТолькоПросмотр           = Не Активна;
	Элементы.Отправить.Доступность                      = Активна;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовИстории(МассивСтруктур)
	
	МассивИдентификаторовДокументов = Новый Массив;
	ДокументыНаПроверку = Новый Массив;
	ДанныеПоДокументам = Новый Массив;
	Для Каждого СтрокаДанных Из СписокИстории Цикл
		МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
		
		Если ДокументыНаПроверку.Найти(СтрокаДанных.ВладелецЭД) = Неопределено Тогда
			ДокументыНаПроверку.Добавить(СтрокаДанных.ВладелецЭД);
			
			ДанныеПоДокументу = Новый Структура;
			ДанныеПоДокументу.Вставить("СсылкаНаДокумент", СтрокаДанных.ВладелецЭД);
			ДанныеПоДокументу.Вставить("Организация", Организация);
			ДанныеПоДокументам.Добавить(ДанныеПоДокументу);
		КонецЕсли;
	КонецЦикла;
	
	МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(
		Организация, МассивИдентификаторовДокументов, Ложь, УникальныйИдентификатор);
		
	АдресХранилищаQRRКодов = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ДанныеQRКодовПоДокументам = Новый Соответствие;
	Если БизнесСеть.ВыводитьQRКодНаПечатныхФормахДокументов() Тогда
		БизнесСеть.ПолучитьQRКодыПоДокументам(ДанныеПоДокументам, АдресХранилищаQRRКодов);
		ДанныеQRКодовПоДокументам = ПолучитьИзВременногоХранилища(АдресХранилищаQRRКодов);
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	Для Каждого СтрокаДанных Из СписокИстории Цикл
		ПараметрыДокумента = НовыеПараметрыДокумента(Истина);
		ЗаполнитьЗначенияСвойств(ПараметрыДокумента, СтрокаДанных);
		
		// Заполнение дополнительных параметров.
		АдресХранилища = МассивДанныхДокументов[СписокИстории.Индекс(СтрокаДанных)];
		ПараметрыДокумента.Вставить("АдресХранилища",    АдресХранилища);
		ПараметрыДокумента.Вставить("ФайлАрхива",        Истина);
		ПараметрыДокумента.Вставить("НаименованиеФайла", СтрокаДанных.Наименование);
		ПараметрыДокумента.Вставить("Контрагент",        Контрагент);
		ПараметрыДокумента.Вставить("Организация",        Организация);
		ПараметрыДокумента.Вставить("НаправлениеЭД",     ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Исходящий"));
		
		ДанныеQRКода = ДанныеQRКодовПоДокументам.Получить(СтрокаДанных.ВладелецЭД);
		
		Если ДанныеQRКода <> Неопределено Тогда
			ПараметрыДокумента.Вставить("ПубличнаяСсылкаQRКода",        ДанныеQRКода.ПубличнаяСсылкаQRКода);
			ПараметрыДокумента.Вставить("ИзображениеQRКода",            ДанныеQRКода.ИзображениеQRКода);
			ПараметрыДокумента.Вставить("ИдентификаторВременнойСсылки", ДанныеQRКода.Идентификатор);
			ПараметрыДокумента.Вставить("АдресХранилищаКартинкиQRКода", ПоместитьВоВременноеХранилище(ДанныеQRКода.ИзображениеQRКода));
		КонецЕсли;
		
		МассивСтруктур.Добавить(ПараметрыДокумента);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодключенияЭДООбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СпособыОбмена = Новый Массив;
	СпособыОбмена.Добавить(ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СпособыОбменаЭД", СпособыОбмена);
	ПараметрыФормы.Вставить("Организация",     Организация);
	ОчиститьСообщения();
	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФлагаУведомлятьПоПочте()
	
	Элементы.УведомлятьПоПочте.Доступность = Не ПустаяСтрока(ЭлектроннаяПочта);
	Если Не Элементы.УведомлятьПоПочте.Доступность Тогда
		УведомлятьПоПочте = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокИсторииОтправки(Отказ)
	
	ИдентификаторОрганизации = БизнесСеть.ИдентификаторОрганизации(Организация);
	
	СписокИстории.Очистить();
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Загрузка истории отправки документа.
		ПараметрыМетода = Новый Структура;
		
		ПараметрыМетода.Вставить("ИдентификаторОрганизации", ИдентификаторОрганизации);
		ПараметрыМетода.Вставить("МассивСсылокНаОбъект",    ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаТаблицы.ВладелецЭД));
		ПараметрыМетода.Вставить("РежимВходящихДокументов", Ложь);
		ПараметрыМетода.Вставить("ВозвращатьДанные",        Ложь);
		ПараметрыКоманды = БизнесСеть.ПараметрыКомандыПолучитьДокументы(ПараметрыМетода, Истина, Отказ);
		ДанныеСервиса    = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
		
		Если Отказ Тогда
			Прервать;
		ИначеЕсли ДанныеСервиса = Неопределено Или ТипЗнч(ДанныеСервиса) <> Тип("Массив") Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого ЭлементКоллекции Из ДанныеСервиса Цикл
			
			НоваяСтрока = СписокИстории.Добавить();
			НоваяСтрока.Дата = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементКоллекции.sentDate);
			Если ВРег(ЭлементКоллекции.deliveryStatus) = "SENT" Тогда
				НоваяСтрока.Статус = НСтр("ru = 'Отправлен'");
			ИначеЕсли ВРег(ЭлементКоллекции.deliveryStatus) = "DELIVERED" Тогда
				НоваяСтрока.Статус = НСтр("ru = 'Доставлен'");
			ИначеЕсли ВРег(ЭлементКоллекции.deliveryStatus) = "REJECTED" Тогда
				НоваяСтрока.Статус = НСтр("ru = 'Отклонен'");
			КонецЕсли; 
			
			НоваяСтрока.Наименование  = ЭлементКоллекции.documentTitle;
			НоваяСтрока.Идентификатор = ЭлементКоллекции.id;
			Если ЗначениеЗаполнено(ЭлементКоллекции.receivedDate) Тогда
				НоваяСтрока.ДатаДоставки = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементКоллекции.receivedDate);
			КонецЕсли;
			
			// Получение владельца электронного документа..
			СтрокаДанных = ТаблицаДанных.НайтиСтроки(Новый Структура("УникальныйИдентификатор", ЭлементКоллекции.documentGuid));
			НоваяСтрока.ВладелецЭД = СтрокаДанных[0].ВладелецЭД;
			
			// Заполнение дополнительной информации.
			НоваяСтрока.Информация    = ЭлементКоллекции.info;
			НоваяСтрока.Получатель    = ЭлементКоллекции.destinationOrganization.title;
			НоваяСтрока.КонтрагентИНН = ЭлементКоллекции.destinationOrganization.inn;
			НоваяСтрока.КонтрагентКПП = ЭлементКоллекции.destinationOrganization.kpp;
			
			// Удаление двоичных данных из структуры данных.
			НоваяСтрока.Источник = ЭлементКоллекции;
			Если НоваяСтрока.Источник.Свойство("documentData") Тогда
				НоваяСтрока.Источник.Удалить("documentData");
			КонецЕсли;
			Если НоваяСтрока.Источник.Свойство("documentPresentationData") Тогда
				НоваяСтрока.Источник.Удалить("documentPresentationData");	
			КонецЕсли;
			
			НоваяСтрока.КонтактноеЛицо   = ЭлементКоллекции.person.name;
			НоваяСтрока.ЭлектроннаяПочта = ЭлементКоллекции.person.email;
			НоваяСтрока.Телефон = ЭлементКоллекции.person.phone;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НовыеПараметрыДокумента(РасширенныеДанные = Ложь)
	
	Результат = Новый Структура;
	Результат.Вставить("АдресХранилища",    "");
	Результат.Вставить("ФайлАрхива",        Ложь);
	Результат.Вставить("НаименованиеФайла", "");
	Результат.Вставить("НаправлениеЭД");
	Результат.Вставить("Контрагент");
	Результат.Вставить("Организация");
	Результат.Вставить("ВладелецЭД");
	Результат.Вставить("Источник");
	Результат.Вставить("СопроводительнаяИнформация", "");
	Результат.Вставить("УникальныйИдентификатор",    "");
	Результат.Вставить("ПубличнаяСсылкаQRКода");
	Результат.Вставить("ИзображениеQRКода");
	Результат.Вставить("ИдентификаторВременнойСсылки");
	Результат.Вставить("АдресХранилищаПредставления", "");
	
	Если РасширенныеДанные Тогда
		Результат.Вставить("Дата",          Дата(1,1,1));
		Результат.Вставить("Статус");
		Результат.Вставить("Идентификатор");
		Результат.Вставить("Получатель");
		Результат.Вставить("Информация");
		Результат.Вставить("КонтрагентИНН", "");
		Результат.Вставить("КонтрагентКПП", "");
		Результат.Вставить("ДатаДоставки",  Дата(1,1,1));
		Результат.Вставить("КонтактноеЛицо");
		Результат.Вставить("Телефон");
		Результат.Вставить("ЭлектроннаяПочта");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьФайлПредставления()
	
	Если Не БизнесСеть.ВыводитьQRКодНаПечатныхФормахДокументов() Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
		
		ДанныеQRКода = БизнесСеть.ДанныеQRКодаПоДокументу(СтрокаДанных.ВладелецЭД, Организация, Отказ);
		
		Если ДанныеQRКода = Неопределено Или Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		АдресКаталога     = РаботаСФайламиБЭД.ВременныйКаталог();
		НаименованиеФайла = СтрокаДанных.НаименованиеФайла;
		ИмяФайлаПДФ = БизнесСеть.ФайлПредставленияПрикладногоДокументаСQRКодом(СтрокаДанных.ВладелецЭД,
			Организация, СтрокаДанных.ВидЭД, НаименованиеФайла, ДанныеQRКода);
		
		Если ЗначениеЗаполнено(ИмяФайлаПДФ) Тогда
			КопироватьФайл(ИмяФайлаПДФ, АдресКаталога + НаименованиеФайла + ".pdf");
			СтрокаДанных.АдресХранилищаПредставления  = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайлаПДФ));
			СтрокаДанных.АдресХранилищаКартинкиQRКода = ПоместитьВоВременноеХранилище(ДанныеQRКода.ИзображениеQRКода);
			СтрокаДанных.ПубличнаяСсылкаQRКода        = ДанныеQRКода.ПубличнаяСсылкаQRКода;
			СтрокаДанных.ИдентификаторВременнойСсылки = ДанныеQRКода.Идентификатор;
		КонецЕсли; 

	КонецЦикла;

КонецПроцедуры

#КонецОбласти
