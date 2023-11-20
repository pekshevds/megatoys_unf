#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИменаСтраниц();
	ЗаполнитьДоступныеВидыПродукции();
	
	ОбработатьПереданныеПараметрыПриСозданииНаСервере();
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	СтраницыФормы                    = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница    = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	ИспользоватьПодразделения        = ИнтеграцияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс();
	Элементы.Подразделение.Видимость                = ИспользоватьПодразделения;
	Элементы.ПодразделениеЭлеватора.Видимость       = ИспользоватьПодразделения;
	Элементы.ПодразделениеВладельцаПартии.Видимость = ИспользоватьПодразделения;
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	СброситьРазмерыИПоложениеОкна();
	
	// РаботаСПолямимСоставногоТипа
	СобытияФормИС.ПоляСоставногоТипаИнициализация(ЭтотОбъект, ИменаЭлементовПолейСоставногоТипа());
	// Конец РаботаСПолямимСоставногоТипа
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Не ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0
		И ВидЗапроса = 1 Тогда
		
		Если Результат.Параметр[1] = Неопределено Тогда
			Штрихкод = Результат.Параметр[0];    // Достаем штрихкод из основных данных
		Иначе
			Штрихкод = Результат.Параметр[1][1]; // Достаем штрихкод из дополнительных данных
		КонецЕсли;
		
		Идентификатор = ИдентификаторИзШтрихкода(Штрихкод);
		
		Если ЗначениеЗаполнено(Идентификатор) Тогда
			
			СтруктураПоиска = Новый Структура("Идентификатор", Идентификатор);
			Если ИсходящиеЗапросы.НайтиСтроки(СтруктураПоиска).Количество() Тогда
				Если ТипЗапроса = "Партии" Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Партия %1 уже добавлена'"), Идентификатор));
				Иначе
					ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'СДИЗ %1 уже добавлен'"), Идентификатор));
				КонецЕсли;
			Иначе
				СтрокаТЧ = ИсходящиеЗапросы.Добавить();
				СтрокаТЧ.НомерСтроки   = ИсходящиеЗапросы.Количество();
				СтрокаТЧ.Идентификатор = Идентификатор;
			КонецЕсли;
			
		Иначе
			
			Если ТипЗапроса = "Партии" Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Из штрихкода %1 не удалось получить номер партии'"), Штрихкод));
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Из штрихкода %1 не удалось получить номер СДИЗ'"), Штрихкод));
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидЗапроса = 2 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ИсходящиеЗапросы");
		МассивНепроверяемыхРеквизитов.Добавить("ИсходящиеЗапросы.Идентификатор");
		Если Не (ТипЗапроса = "Партии" И ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Операция");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Дата начала периода не заполнена.'"),,
				"НачалоПериода",,
				Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КонецПериода)
			И НачалоПериода >= КонецПериода Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Дата конца периода загрузки должна быть больше даты начала.'"),,
				"КонецПериода",,
				Отказ);
		КонецЕсли;
		
	ИначеЕсли ВидЗапроса = 3 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ИсходящиеЗапросы");
		МассивНепроверяемыхРеквизитов.Добавить("ИсходящиеЗапросы.Идентификатор");
		МассивНепроверяемыхРеквизитов.Добавить("Операция");
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Операция");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// РаботаСПолямимСоставногоТипа
	Если ВРег(Лев(ИмяСобытия, 6)) = "ЗАПИСЬ" Тогда
		СобытияФормИСКлиент.ПолеСоставногоТипаОбработатьИзменениеДанных(ЭтотОбъект, Источник);
	КонецЕсли;
	// Конец РаботаСПолямимСоставногоТипа
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьРезультат") Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Изменения", ВходящиеСообщения);
		
		ОткрытьФорму("ОбщаяФорма.РезультатВыполненияОбменаЗЕРНО", ПараметрыОткрытияФормы, ЭтотОбъект);
			
	Иначе
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЗапросаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ВидЗапроса");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПродукцииПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидКлассификатораПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойПриИзменении(Элемент)
	
	ПолеСоставногоТипаПриИзменении(Элемент);
	ОпределитьТипОрганизацияКонтрагент(ТипЭлеватора, Элеватор);
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	ПолеСоставногоТипаОткрытие(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	ОпределитьТипОрганизацияКонтрагент(ТипЭлеватора, Элеватор);
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПолеСоставногоТипаАвтоПодбор(Элемент, Элемент.ТекстРедактирования, ДанныеВыбора, Неопределено, 0, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойПриИзменении(Элемент)
	
	ПолеСоставногоТипаПриИзменении(Элемент);
	ОпределитьТипОрганизацияКонтрагент(ТипВладельцаПартии, ВладелецПартии);
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	ПолеСоставногоТипаОткрытие(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	ОпределитьТипОрганизацияКонтрагент(ТипВладельцаПартии, ВладелецПартии);
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПолеСоставногоТипаАвтоПодбор(Элемент, Элемент.ТекстРедактирования, ДанныеВыбора, Неопределено, 0, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "Операция");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИдентификаторы

&НаКлиенте
Процедура ИдентификаторыПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ПронумероватьТаблицу(ЭтотОбъект, "ИсходящиеЗапросы");
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторыСДИЗИдентификаторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗагруженныеОбъекты

&НаКлиенте
Процедура ЗагруженныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ЗагруженныеОбъекты.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(, ТекущиеДанные.Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалееНачало(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнениеЗаявкиЗЕРНОНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы + 1] = "СтраницаЗапросОшибка" Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы - 1] = "СтраницаЗапросОшибка" Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВНачало(Команда)
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("ТипЗапроса", ТипЗапроса);
	ОткрытьФорму(
		"ОбщаяФорма.ЗагрузкаИдентификаторовИзВнешнихФайлов",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьРезультатЗагрузкиИзВнешнегоФайла", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеЗакрыть(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеОбмена

&НаСервере
Функция ВыполнениеЗаявкиЗЕРНОНачалоНаСервере()
	
	ВходящиеСообщения.Очистить();
	ЗагруженныеОбъекты.Очистить();
	
	РезультатОбмена = Неопределено;
	
	Если ВидЗапроса = 1 Тогда
		
		ВходящиеДанные = Новый Массив();
		
		Если ТипЗапроса = "Партии" Тогда
			
			ПараметрыОбработкиСообщений = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
			ПараметрыОбработкиСообщений.Организация      = Организация;
			ПараметрыОбработкиСообщений.Подразделение    = Подразделение;
			ПараметрыОбработкиСообщений.Операция         = Перечисления.ВидыОперацийЗЕРНО.ЗапросПартий;
			ПараметрыОбработкиСообщений.Ссылка           = Справочники.РеестрПартийЗЕРНО.ПустаяСсылка();
			ПараметрыОбработкиСообщений.ВидПродукции     = ВидПродукции;
			ПараметрыЗапроса                             = Новый Структура;
			ПараметрыОбработкиСообщений.ПараметрыЗапроса = ПараметрыЗапроса;
			ПараметрыЗапроса.Вставить("НомерПартии", ИсходящиеЗапросы.Выгрузить().ВыгрузитьКолонку("Идентификатор"));
			
			ВходящиеДанные.Добавить(ПараметрыОбработкиСообщений);
			
		Иначе
			
			ПараметрыОбработкиСообщений = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
			ПараметрыОбработкиСообщений.Операция      = Перечисления.ВидыОперацийЗЕРНО.ЗапросСДИЗ;
			ПараметрыОбработкиСообщений.Ссылка        = Справочники.СДИЗЗЕРНО.ПустаяСсылка();
			ПараметрыОбработкиСообщений.ВидПродукции  = ВидПродукции;
			ПараметрыОбработкиСообщений.Организация   = Организация;
			ПараметрыОбработкиСообщений.Подразделение = Подразделение;
			Если ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
				ПараметрыОбработкиСообщений.ЭтоЭлеватор = (ТипОрганизации = 1);
			КонецЕсли;
			
			ПараметрыЗапроса                             = Новый Структура;
			ПараметрыОбработкиСообщений.ПараметрыЗапроса = ПараметрыЗапроса;
			ПараметрыЗапроса.Вставить("НомерСДИЗ",                      ИсходящиеЗапросы.Выгрузить().ВыгрузитьКолонку("Идентификатор"));
			ПараметрыЗапроса.Вставить("ЗапрашиватьПогашенияСДИЗ",       ЗапрашиватьПогашенияСДИЗ);
			ПараметрыЗапроса.Вставить("ЗапрашиватьОтказыПогашенийСДИЗ", ЗапрашиватьОтказыПогашенийСДИЗ);
			
			ВходящиеДанные.Добавить(ПараметрыОбработкиСообщений);
			
		КонецЕсли;
		
		РезультатОбмена = ИнтеграцияЗЕРНОВызовСервера.ПодготовитьКПередаче(ВходящиеДанные, УникальныйИдентификатор);
		
	ИначеЕсли (ВидЗапроса = 2 Или ВидЗапроса = 3) Тогда
		
		ВходящиеДанные = Новый Массив();
		
		ПараметрыОбработкиСообщений = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
		ПараметрыОбработкиСообщений.Организация   = Организация;
		ПараметрыОбработкиСообщений.Подразделение = Подразделение;
		ПараметрыОбработкиСообщений.ВидПродукции  = ВидПродукции;
		ПараметрыЗапроса                          = Новый Структура;
		
		Если ТипЗапроса = "МестаФормированияПартий" Тогда
			
			ПараметрыОбработкиСообщений.Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросМестФормированияПартий;
			ПараметрыОбработкиСообщений.Ссылка   = Справочники.РеестрМестФормированияПартийЗЕРНО.ПустаяСсылка();
			
		ИначеЕсли ТипЗапроса = "РезультатыИсследований" Тогда
			
			ПараметрыОбработкиСообщений.Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросРезультатовИсследований;
			ПараметрыОбработкиСообщений.Ссылка   = Справочники.РезультатыИсследованийЗЕРНО.ПустаяСсылка();
			
			Если ЗначениеЗаполнено(СтатусРезультатовИсследований) Тогда
				ПараметрыЗапроса.Вставить("Статус", СтатусРезультатовИсследований);
			КонецЕсли;
		
		ИначеЕсли ТипЗапроса = "Классификаторы" Тогда
			
			ДополнительныеКлассификаторы = Новый Массив();
			ПараметрыОбработкиСообщений.Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросКлассификатора;
			
			Если ВидКлассификатора = Перечисления.ВидыКлассификаторовЗЕРНО.ПотребительскоеСвойство
				И ЗагрузитьДопустимыеЗначенияПотребительскихСвойств Тогда
				ДополнительныеКлассификаторы.Добавить(Перечисления.ВидыКлассификаторовЗЕРНО.ДопустимыеЗначенияПотребительскихСвойств);
			КонецЕсли;
			Если (ВидКлассификатора = Перечисления.ВидыКлассификаторовЗЕРНО.ТНВЭД
				Или ВидКлассификатора = Перечисления.ВидыКлассификаторовЗЕРНО.ОКПД2)
				И ЗагрузитьВидыСельхозКультур Тогда
				ДополнительныеКлассификаторы.Добавить(Перечисления.ВидыКлассификаторовЗЕРНО.ВидСельскохозяйственнойКультуры);
			КонецЕсли;
			
			Если ДополнительныеКлассификаторы.Количество() Тогда
				ПараметрыОбработкиСообщений.Ссылка = Новый Массив();
				ПараметрыОбработкиСообщений.Ссылка.Добавить(ВидКлассификатора);
				Для Каждого ДополнительныйКлассификатор Из ДополнительныеКлассификаторы Цикл
					ПараметрыОбработкиСообщений.Ссылка.Добавить(ДополнительныйКлассификатор);
				КонецЦикла;
			Иначе
				ПараметрыОбработкиСообщений.Ссылка = ВидКлассификатора;
			КонецЕсли;
			
		ИначеЕсли ТипЗапроса = "Элеваторы" Тогда
			
			ПараметрыОбработкиСообщений.Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросРеестраЭлеваторов;
			ПараметрыОбработкиСообщений.Ссылка   = Справочники.РеестрЭлеваторовЗЕРНО.ПустаяСсылка();
		
		ИначеЕсли ТипЗапроса = "Партии" Тогда
			
			ПараметрыОбработкиСообщений.Операция = Операция;
			ПараметрыОбработкиСообщений.Ссылка   = Справочники.РеестрПартийЗЕРНО.ПустаяСсылка();
			
			Если ЗначениеЗаполнено(СтатусПартии) Тогда
				ПараметрыЗапроса.Вставить("Статус", СтатусПартии);
			КонецЕсли;
			
			Если Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросПартийНаХранении Тогда
				ПараметрыОбработкиСообщений.ЭтоЭлеватор = Истина;
				Если ЗначениеЗаполнено(ВладелецПартии) Тогда
					ПараметрыЗапроса.Вставить("ВладелецПартии",               ВладелецПартии);
					ПараметрыЗапроса.Вставить("ПодразделениеВладельцаПартии", ПодразделениеВладельцаПартии);
				КонецЕсли;
			Иначе
				Если ЗначениеЗаполнено(Элеватор) Тогда
					ПараметрыЗапроса.Вставить("Элеватор",               Элеватор);
					ПараметрыЗапроса.Вставить("ПодразделениеЭлеватора", ПодразделениеЭлеватора);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			ПараметрыОбработкиСообщений.Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросСДИЗ;
			ПараметрыОбработкиСообщений.Ссылка   = Справочники.СДИЗЗЕРНО.ПустаяСсылка();
			
			Если ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
				ПараметрыОбработкиСообщений.ЭтоЭлеватор = (ТипОрганизации = 1);
			КонецЕсли;
			
			ПараметрыЗапроса.Вставить("ЗапрашиватьПогашенияСДИЗ",       ЗапрашиватьПогашенияСДИЗ);
			ПараметрыЗапроса.Вставить("ЗапрашиватьОтказыПогашенийСДИЗ", ЗапрашиватьОтказыПогашенийСДИЗ);
			Если ЗначениеЗаполнено(СтатусСДИЗ) Тогда
				ПараметрыЗапроса.Вставить("Статус", СтатусСДИЗ);
			КонецЕсли;
			Если ЗначениеЗаполнено(ВидСДИЗ) Тогда
				ПараметрыЗапроса.Вставить("ВидСДИЗ", ВидСДИЗ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
			ПараметрыЗапроса.Вставить("Интервал", ИнтеграцияЗЕРНОКлиентСервер.СтруктураИнтервала(НачалоПериода, КонецПериода));
		ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
			ПараметрыЗапроса.Вставить("Интервал", ИнтеграцияЗЕРНОКлиентСервер.СтруктураИнтервала(НачалоПериода));
		ИначеЕсли Не ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
			ПараметрыЗапроса.Вставить("Интервал", ИнтеграцияЗЕРНОКлиентСервер.СтруктураИнтервала(, КонецПериода));
		КонецЕсли;
		ПараметрыОбработкиСообщений.ПараметрыЗапроса = ПараметрыЗапроса;
		
		ВходящиеДанные.Добавить(ПараметрыОбработкиСообщений);
		
		РезультатОбмена = ИнтеграцияЗЕРНОВызовСервера.ПодготовитьКПередаче(ВходящиеДанные, УникальныйИдентификатор);
		
	КонецЕсли;
	
	Возврат РезультатОбмена;
	
КонецФункции

&НаКлиенте
Процедура ВыполнениеЗаявкиЗЕРНОНачало()
	
	РезультатОбмена = ВыполнениеЗаявкиЗЕРНОНачалоНаСервере();
	
	ОбработатьРезультатОбменаЗЕРНО(РезультатОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаЗЕРНО(РезультатОбмена)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОписаниеОповещения);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	ИнтеграцияЗЕРНОСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОписаниеОповещения, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	Если Изменения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоОшибок     = 0;
	КоличествоОбъектов   = 0;
	
	СтруктураПоиска = Новый Структура("Объект");
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		
		НоваяСтрока = ВходящиеСообщения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементДанных,, "Объект");
		
		Если ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
			НоваяСтрока.Объект = Новый ФиксированныйМассив(ЭлементДанных.Объект);
			КоличествоОбъектов = КоличествоОбъектов + ЭлементДанных.Объект.Количество();
			Для Каждого СсылкаНаОбъект Из ЭлементДанных.Объект Цикл
				СтруктураПоиска.Объект = СсылкаНаОбъект;
				Если ЗагруженныеОбъекты.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					СтрокаДанных = ЗагруженныеОбъекты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДанных, СтруктураПоиска);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецЕсли;
			
	КонецЦикла;
	
	Если КоличествоОшибок > 0 Тогда
		ТекстРезультатаВыполненияОбмена = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр( "ru = 'Результат обмена данным с ошибками (%1)'"),
				КоличествоОшибок),, ЦветПроблема,, "ОткрытьРезультат");
	Иначе
		ТекстРезультатаВыполненияОбмена = Новый ФорматированнаяСтрока(
			НСтр( "ru = 'Результат обмена данным'"),,,, "ОткрытьРезультат");
	КонецЕсли;
	
	Элементы.ТекстРезультатаВыполненияОбмена.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеИнтерфейсом

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация                    = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов              = Новый Структура(СписокРеквизитов);
	ЭтоЗапросСДИЗ                    = (Форма.ТипЗапроса = "СДИЗ");
	ЭтоЗапросРезультатовИсследований = (Форма.ТипЗапроса = "МестаФормированияПартий");
	ЭтоЗапросКлассификатора          = (Форма.ТипЗапроса = "Классификаторы");
	ЭтоЗапросПартий                  = (Форма.ТипЗапроса = "Партии");
	ЭтоЗерно                         = (Форма.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно"));
	ЭтоЭлеватор                      = (Форма.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ЗапросПартийНаХранении"));
	
	Если Инициализация Или СтруктураРеквизитов.Свойство("ВидЗапроса") Тогда
		Элементы.ИдентификаторыИдентификатор.АвтоОтметкаНезаполненного = (Форма.ВидЗапроса = 1);
		Элементы.НачалоПериода.АвтоОтметкаНезаполненного               = (Форма.ВидЗапроса = 2);
		Элементы.СтатусСДИЗ.Видимость                                  = (Форма.ВидЗапроса = 2);
		Элементы.ВидСДИЗ.Видимость                                     = (Форма.ВидЗапроса = 2);
		Элементы.НачалоПериода.Видимость                               = (Форма.ВидЗапроса = 2);
		Элементы.КонецПериода.Видимость                                = (Форма.ВидЗапроса = 2);
		Элементы.ГруппаИнформация.Видимость                            = (Форма.ВидЗапроса = 1);
		Элементы.Идентификаторы.Видимость                              = (Форма.ВидЗапроса = 1);
	КонецЕсли;
	
	Элементы.ТипОрганизации.Видимость = (Форма.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно")
		И ЭтоЗапросСДИЗ);
	
	Элементы.СтатусСДИЗ.Видимость                     = (ЭтоЗапросСДИЗ И Форма.ВидЗапроса = 2);
	Элементы.ВидСДИЗ.Видимость                        = (ЭтоЗапросСДИЗ И Форма.ВидЗапроса = 2);
	Элементы.ЗапрашиватьПогашенияСДИЗ.Видимость       = ЭтоЗапросСДИЗ;
	Элементы.ЗапрашиватьОтказыПогашенийСДИЗ.Видимость = ЭтоЗапросСДИЗ;
	Элементы.ВидЗапроса.Видимость                     = (ЭтоЗапросСДИЗ Или ЭтоЗапросПартий);
	Элементы.ВидПродукции.Видимость                   = (ЭтоЗапросСДИЗ Или ЭтоЗапросПартий);
	Элементы.СтатусРезультатовИсследований.Видимость  = ЭтоЗапросРезультатовИсследований;
	Элементы.ВидКлассификатора.Видимость              = ЭтоЗапросКлассификатора;
	Элементы.СтатусПартии.Видимость                   = (ЭтоЗапросПартий И Форма.ВидЗапроса = 2);
	Элементы.Операция.Видимость                       = (ЭтоЗапросПартий И Форма.ВидЗапроса = 2 И ЭтоЗерно);
	Элементы.ВладелецПартииСтрокой.Видимость          = (ЭтоЗапросПартий И Форма.ВидЗапроса = 2 И ЭтоЭлеватор И ЭтоЗерно);
	Элементы.ПодразделениеВладельцаПартии.Видимость   = (ЭтоЗапросПартий И Форма.ВидЗапроса = 2 И ЭтоЭлеватор И ЭтоЗерно И Форма.ТипВладельцаПартии = 0);
	Элементы.ЭлеваторСтрокой.Видимость                = (ЭтоЗапросПартий И Форма.ВидЗапроса = 2 И Не ЭтоЭлеватор И ЭтоЗерно);
	Элементы.ПодразделениеЭлеватора.Видимость         = (ЭтоЗапросПартий И Форма.ВидЗапроса = 2 И Не ЭтоЭлеватор И ЭтоЗерно И Форма.ТипЭлеватора = 0);
	
	Элементы.ЗагрузитьДопустимыеЗначенияПотребительскихСвойств.Видимость = (Форма.ВидКлассификатора = ПредопределенноеЗначение("Перечисление.ВидыКлассификаторовЗЕРНО.ПотребительскоеСвойство"));
	Элементы.ЗагрузитьВидыСельхозКультур.Видимость = (Форма.ВидКлассификатора = ПредопределенноеЗначение("Перечисление.ВидыКлассификаторовЗЕРНО.ОКПД2")
		Или Форма.ВидКлассификатора = ПредопределенноеЗначение("Перечисление.ВидыКлассификаторовЗЕРНО.ТНВЭД"));
	
	Если ЭтоЗапросПартий Тогда
		Элементы.ИдентификаторыИдентификатор.Заголовок = НСтр( "ru = 'Номер партии'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаСтраниц()
	
	СтраницыФормы = Новый Массив();
	
	СтраницыФормы.Добавить("СтраницаИсходныеДанные");
	СтраницыФормы.Добавить("СтраницаЗапросОжидание");
	СтраницыФормы.Добавить("СтраницаЗапросОшибка");
	СтраницыФормы.Добавить("СтраницаЗапросРезультат");
	
	ИменаСтраниц = Новый ФиксированныйМассив(СтраницыФормы);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницуНавигации(Форма)
	
	СтраницыФормы     = Форма.Элементы.ГруппаСтраницы;
	СтраницыНавигации = Форма.Элементы.Навигация;
	
	ИндексСтраницы    = Форма.ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	КоличествоСтраниц = Форма.ИменаСтраниц.Количество();
	
	Если ИндексСтраницы = 0 Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияНачало;
		Форма.Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ИндексСтраницы = (КоличествоСтраниц - 1) Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОкончание;
		Форма.Элементы.ОкончаниеЗакрыть.КнопкаПоУмолчанию = Истина;
	Иначе
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияПродолжение;
		Если НЕ Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию Тогда
			Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОпределитьТипОрганизацияКонтрагент(ТипВладельца, ОрганизацияКонтрагент)
	
	ТипВладельца = ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(ОрганизацияКонтрагент);
	
КонецПроцедуры

#КонецОбласти

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбработатьРезультатЗагрузкиИзВнешнегоФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Идентификатор");
	Для Каждого Идентификатор Из Результат Цикл
		
		Отбор.Идентификатор = Идентификатор;
		Если ИсходящиеЗапросы.НайтиСтроки(Отбор).Количество() Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТЧ = ИсходящиеЗапросы.Добавить();
		СтрокаТЧ.Идентификатор = Идентификатор;
		
	КонецЦикла;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ПронумероватьТаблицу(ЭтотОбъект, "ИсходящиеЗапросы");
	
КонецПроцедуры

&НаКлиенте
Функция ИдентификаторИзШтрихкода(Штрихкод)
	
	НачалоДанныхСДИЗ   = СтрНайти(Штрихкод, "СДИЗ:") + 5;
	НачалоДанныхПартия = СтрНайти(Штрихкод, "Партия:");
	
	Если НачалоДанныхСДИЗ = 0 Или НачалоДанныхПартия = 0 Тогда
		Возврат Неопределено;
	Иначе
		Если ТипЗапроса = "Партии" Тогда
			Возврат СокрЛП(Сред(Штрихкод, НачалоДанныхПартия + 7));
		Иначе
			Возврат СокрЛП(Сред(Штрихкод, НачалоДанныхСДИЗ, НачалоДанныхПартия - НачалоДанныхСДИЗ));
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыШапки(СсылкаНаОбъект)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СДИЗЗЕРНО.Ссылка,
		|	СДИЗЗЕРНО.ВидПродукции КАК ВидПродукции,
		|	СДИЗЗЕРНО.Идентификатор,
		|	СДИЗЗЕРНО.Грузоотправитель,
		|	СДИЗЗЕРНО.Грузополучатель,
		|	СДИЗЗЕРНО.Продавец,
		|	СДИЗЗЕРНО.Покупатель,
		|	СДИЗЗЕРНО.УполномоченноеЛицо
		|ИЗ
		|	Справочник.СДИЗЗЕРНО КАК СДИЗЗЕРНО
		|ГДЕ
		|	СДИЗЗЕРНО.Ссылка В (&СсылкаНаОбъект)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РезультатыИсследованийЗЕРНО.Ссылка,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Зерно) КАК ВидПродукции,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	РезультатыИсследованийЗЕРНО.Товаропроизводитель
		|ИЗ
		|	Справочник.РезультатыИсследованийЗЕРНО КАК РезультатыИсследованийЗЕРНО
		|ГДЕ
		|	РезультатыИсследованийЗЕРНО.Ссылка В (&СсылкаНаОбъект)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РеестрМестФормированияПартийЗЕРНО.Ссылка,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Зерно) КАК ВидПродукции,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	РеестрМестФормированияПартийЗЕРНО.Товаропроизводитель
		|ИЗ
		|	Справочник.РеестрМестФормированияПартийЗЕРНО КАК РеестрМестФормированияПартийЗЕРНО
		|ГДЕ
		|	РеестрМестФормированияПартийЗЕРНО.Ссылка В (&СсылкаНаОбъект)";
	
	Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КлючПоискаОрганизации = Новый Массив();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВидПродукции) Тогда
			ВидПродукции = ВыборкаДетальныеЗаписи.ВидПродукции;
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Грузоотправитель) Тогда
			КлючПоискаОрганизации.Добавить(ВыборкаДетальныеЗаписи.Грузоотправитель);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Грузополучатель) Тогда
			КлючПоискаОрганизации.Добавить(ВыборкаДетальныеЗаписи.Грузополучатель);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Продавец) Тогда
			КлючПоискаОрганизации.Добавить(ВыборкаДетальныеЗаписи.Продавец);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Покупатель) Тогда
			КлючПоискаОрганизации.Добавить(ВыборкаДетальныеЗаписи.Покупатель);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.УполномоченноеЛицо) Тогда
			КлючПоискаОрганизации.Добавить(ВыборкаДетальныеЗаписи.УполномоченноеЛицо);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Организация)
		И КлючПоискаОрганизации.Количество() Тогда
		
		СвязанныеЗначения = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.ОрганизацииКонтрагентыПоКлючам(КлючПоискаОрганизации);
		
		Для Каждого КлючПоиска Из КлючПоискаОрганизации Цикл
			
			СвязанноеЗначение = СвязанныеЗначения[КлючПоиска];
			
			Если СвязанноеЗначение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СвязанноеЗначение.Организация) Тогда
				Организация   = СвязанноеЗначение.Организация;
				Подразделение = СвязанноеЗначение.Подразделение;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеВидыПродукции()
	
	ВидыПродукции = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
	
	Элементы.ВидПродукции.СписокВыбора.Очистить();
	Для Каждого УчитываемйВидПродукции Из ВидыПродукции Цикл
		Элементы.ВидПродукции.СписокВыбора.Добавить(УчитываемйВидПродукции, Строка(УчитываемйВидПродукции));
	КонецЦикла;
	Элементы.ВидПродукции.СписокВыбора.СортироватьПоПредставлению();
	
	Если ВидыПродукции.Количество() = 1 Тогда
		ВидПродукции = ВидыПродукции[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметрыПриСозданииНаСервере()
	
	Организация = Параметры.Организация;
	Если ЗначениеЗаполнено(Параметры.ВидПродукции) Тогда
		ВидПродукции = Параметры.ВидПродукции;
	КонецЕсли;
	
	ТипЗапроса = Параметры.ТипЗапроса;
	
	Если ЗначениеЗаполнено(Параметры.Идентификатор) Тогда
		
		СтрокаТЧ = ИсходящиеЗапросы.Добавить();
		СтрокаТЧ.НомерСтроки   = ИсходящиеЗапросы.Количество();
		СтрокаТЧ.Идентификатор = Параметры.Идентификатор;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СсылкаНаОбъект) Тогда
		ЗаполнитьРеквизитыШапки(Параметры.СсылкаНаОбъект);
	КонецЕсли;
	
	Элементы.Идентификаторы.Видимость     = Ложь;
	Элементы.Надпись.Видимость            = Ложь;
	Элементы.КартинкаИнформация.Видимость = Ложь;
	
	Если ТипЗапроса = "МестаФормированияПартий" Тогда
		ВидЗапроса = 2;
		Заголовок  = НСтр("ru = 'Запрос мест формирования партий'");
	ИначеЕсли ТипЗапроса = "РезультатыИсследований" Тогда
		ВидЗапроса = 2;
		Заголовок  = НСтр("ru = 'Запрос результатов исследований'");
	ИначеЕсли ТипЗапроса = "Классификаторы" Тогда
		ВидЗапроса        = 3;
		Заголовок         = НСтр("ru = 'Запрос классификатора'");
		ВидКлассификатора = Параметры.СсылкаНаОбъект;
		ЗагрузитьДопустимыеЗначенияПотребительскихСвойств = Истина;
		ЗагрузитьВидыСельхозКультур                       = Истина;
	ИначеЕсли ТипЗапроса = "Элеваторы" Тогда
		ВидЗапроса = 3;
		Заголовок = НСтр("ru = 'Запрос реестра элеваторов'");
	ИначеЕсли ТипЗапроса = "Партии" Тогда
		Если ЗначениеЗаполнено(Параметры.ВидЗапроса) Тогда
			ВидЗапроса = Параметры.ВидЗапроса;
		Иначе
			ВидЗапроса = 2;
		КонецЕсли;
		Заголовок  = НСтр("ru = 'Запрос партий'");
		Операция   = Перечисления.ВидыОперацийЗЕРНО.ЗапросПартий;
		Элементы.Надпись.Видимость            = Истина;
		Элементы.КартинкаИнформация.Видимость = Истина;
	Иначе
		Элементы.Надпись.Видимость            = Истина;
		Элементы.КартинкаИнформация.Видимость = Истина;
		Заголовок = НСтр("ru = 'Запрос СДИЗ'");
		Если ЗначениеЗаполнено(Параметры.ВидЗапроса) Тогда
			ВидЗапроса = Параметры.ВидЗапроса;
		Иначе
			ВидЗапроса = 2;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ВидКлассификатора.СписокВыбора.СортироватьПоЗначению();
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ЗапросСправочниковЗЕРНО", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#Область РаботаСПолямимСоставногоТипа

&НаСервереБезКонтекста
Функция ИменаЭлементовПолейСоставногоТипа()
	
	Возврат "ВладелецПартииСтрокой,ЭлеваторСтрокой";
	
КонецФункции

&НаКлиенте
Процедура ПолеСоставногоТипаОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОкончаниеВыбора(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаПриИзменении(Элемент)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаОткрытие(Элемент, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаАвтоПодбор(ЭтотОбъект,
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
