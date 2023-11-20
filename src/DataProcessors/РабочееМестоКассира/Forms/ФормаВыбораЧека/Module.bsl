
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ЭтоЧекКоррекции = Параметры.Свойство("ЧекКоррекции");
	ЭтоВозвратПродажи = Параметры.Свойство("ВозвратПродажи");
	
	ОбщегоНазначенияРМКПереопределяемый.СформироватьЗапросТаблицаЧековПоУмолчанию(ЭтотОбъект);
	Если Параметры.Свойство("ВозвратПродажи") Тогда
		
		ЗаполнитьТаблицуЧековККМ();
		
	ИначеЕсли Параметры.Свойство("ВозвратСкупки") Тогда
		
		ЗаполнитьТаблицуЧековККМНаВозвратСкупки();
		
	ИначеЕсли Параметры.Свойство("ВыборДокументаРассрочки") Тогда
		
		Элементы.ВозвратБезЧека.Видимость = Ложь;
		ЗаполнитьТаблицуЧековККМОплаченныхВРассрочку();
		
	ИначеЕсли Параметры.Свойство("ВыборОтложенногоЧека") Тогда
		
		Элементы.ГруппаПодсказкаПоискЧекаПоКоду.Видимость = Ложь;
		Элементы.ВозвратБезЧека.Видимость = Ложь;
		ЗаполнитьТаблицуОтложенныхЧековККМ();
		
	ИначеЕсли Параметры.Свойство("РежимПечатиЧека") Тогда
		
		РежимПечатиЧека = Параметры.РежимПечатиЧека;
		Элементы.ВозвратБезЧека.Видимость = Ложь;
		ЗаполнитьТаблицуЧековККМДляПовторнойПечати();
		
	ИначеЕсли ЭтоЧекКоррекции Тогда
		
		Элементы.ВозвратБезЧека.Видимость = Ложь;
		ЗаполнитьТаблицуЧековККМ();
		
	КонецЕсли;
	
	Если Параметры.Свойство("МассивКассККМ") Тогда
		
		МассивКассККМ = Параметры.МассивКассККМ;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ТаблицаЧековККМ,
			"МассивКассККМ",
			МассивКассККМ);
			
	КонецЕсли;
	
	Если Параметры.Свойство("МассивОрганизаций") Тогда
		
		МассивОрганизаций = Параметры.МассивОрганизаций;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ТаблицаЧековККМ,
			"МассивОрганизаций",
			МассивОрганизаций);
			
	КонецЕсли;
	
	Если Параметры.Свойство("ТорговыйОбъект") Тогда
		
		ТорговыйОбъект = Параметры.ТорговыйОбъект;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ТаблицаЧековККМ,
			"ТорговыйОбъект",
			ТорговыйОбъект);
			
	КонецЕсли;
	
	Если Параметры.Свойство("ВыводитьКомментарийКЧеку") Тогда

		Элементы.ТаблицаЧековККМКомментарий.Видимость = Параметры.ВыводитьКомментарийКЧеку;

	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ТаблицаЧековККМ,
		"ИсключатьЧекиККМСВозвратами",
		ЭтоЧекКоррекции);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ТаблицаЧековККМ,
		"ИсключатьЧекиККМПредоплатыЗачтеные",
		ЭтоВозвратПродажи);
	
	ПоддерживаемыеТипыПО = НСтр("ru = 'СканерШтрихкода'");
	ОбщегоНазначенияРМК.НастроитьПодключаемоеОборудование(ЭтотОбъект, "");
	ПродажиРМК.ЗаполнитьТаблицуОборудование(ЭтотОбъект, ПоддерживаемыеТипыПО);
	
	УстановитьУсловноеОформление();
	
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИспользоватьПодключаемоеОборудование Тогда
		
		Для Каждого СтрокаТЧ Из Оборудование Цикл
			
			ОповещениеОНачалеПодключения = Новый ОписаниеОповещения(
				"НачатьПодключениеОборудованиеПоИдентификаторуЗавершение",
				ЭтотОбъект, 
				СтрокаТЧ);
			
			МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоИдентификатору(
				ОповещениеОНачалеПодключения,
				УникальныйИдентификатор,
				СтрокаТЧ.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData" Тогда
			
			Если Параметр[1] = Неопределено Тогда
				Штрихкод = Параметр[0];
			Иначе
				Штрихкод = Параметр[1][1];
			КонецЕсли;
			
			ВыполнитьПоискЧекаККМ(Штрихкод);
			
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ОбщегоНазначенияРМККлиент.ИспользоватьВнешнееСобытие() И ВводДоступен() Тогда
		
		Если Событие = "Штрихкод" Или Событие = "ПолученШтрихкод" Или Событие = "ScanData" Тогда
			ВыполнитьПоискЧекаККМ(Данные);
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЧеков

&НаКлиенте
Процедура ТаблицаЧековККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗафиксироватьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ЗафиксироватьВыбор();
КонецПроцедуры

&НаКлиенте
Процедура ВозвратБезЧека(Команда)
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("ВозвратБезЧека");
	Закрыть(СтруктураСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуОтложенныхЧековККМ()
	ОбщегоНазначенияРМКПереопределяемый.ЗаполнитьТаблицуОтложенныхЧековККМ(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЧековККМ()
	ОбщегоНазначенияРМКПереопределяемый.ЗаполнитьТаблицуЧековККМНаВозврат(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЧековККМДляПовторнойПечати()
	ОбщегоНазначенияРМКПереопределяемый.ЗаполнитьТаблицуЧековККМДляПовторнойПечати(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыбор()
	
	ТекущиеДанные = Элементы.ТаблицаЧековККМ.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("ЧекККМ", ТекущиеДанные.Ссылка);
		СтруктураСтроки.Вставить("СуммаРассрочки", ТекущиеДанные.СуммаДокумента);
		
		Если ЗначениеЗаполнено(РежимПечатиЧека) Тогда
			СтруктураСтроки.Вставить("РежимПечатиЧека", РежимПечатиЧека);
		КонецЕсли;
		
		Закрыть(СтруктураСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискЧекаККМ(Штрихкод)
	
	РасшифровкаКода = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.РасшифроватьQRКодЧекаККТ(Штрихкод);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденныеЧеки = Новый Массив;
	
	Если РасшифровкаКода.Расшифрован Тогда
		Запрос = Новый Запрос;
		ОбщегоНазначенияРМКПереопределяемый.СформироватьЗапросЧекПоФискальномуПризнаку(Запрос, ЭтотОбъект, РасшифровкаКода);
		Если Не ЗначениеЗаполнено(Запрос.Текст) Тогда
			ТекстОшибки = НСтр("ru = 'Не сформирован запрос для поиска чека по фискальному признаку.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ВыборкаНайденныхЧеков = Запрос.Выполнить().Выбрать();
		Пока ВыборкаНайденныхЧеков.Следующий() Цикл
			НайденныеЧеки.Добавить(ВыборкаНайденныхЧеков.Ссылка);
		КонецЦикла;
		
	Иначе
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ФискальныеОперации.ДокументОснование КАК Ссылка
		|ИЗ
		|	РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
		|ГДЕ
		|	ФискальныеОперации.ИдентификаторОплатыПлатежнойСистемы = &ФискальныйПризнак
		|	И ФискальныеОперации.ИдентификаторОплатыПлатежнойСистемы <> """"");
		
		Запрос.УстановитьПараметр("ФискальныйПризнак", Штрихкод);
		ВыборкаНайденныхЧеков = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаНайденныхЧеков.Следующий() Цикл
			НайденныеЧеки.Добавить(ВыборкаНайденныхЧеков.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НайденныеЧеки.Количество() > 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ТаблицаЧековККМ,
			"Ссылка",
			НайденныеЧеки,
			ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОборудованиеПоИдентификаторуЗавершение(Данные, СтрокаТЧ) Экспорт

	Если НЕ Данные.Результат Тогда
		
		ОписаниеОшибки = СтрЗаменить(Данные.ОписаниеОшибки, "'", "");
		
		СтрокаПредупреждения = НСтр("ru = 'При подключении устройства произошла ошибка:
									|""%1"".';
									|en = 'An error occurred when connecting the device:
									|""%1"".'");
		ТекстПредупреждения = СтрШаблон(СтрокаПредупреждения, ОписаниеОшибки);
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		СтрокаТЧ.Подключено = 1;
		
	Иначе
		
		СтрокаТЧ.Подключено = 0;
		
		Если СтрокаТЧ.ТипОборудования =
					ОбщегоНазначенияКлиент.ПредопределенныйЭлемент(
						"Перечисление.ТипыПодключаемогоОборудования.ДисплейПокупателя") Тогда
			ПодключитьОбработчикОжидания("ВывестиИнформациюНаДисплейПокупателя", 0.1, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЧековККМНаВозвратСкупки()
	ОбщегоНазначенияРМКПереопределяемый.ЗаполнитьТаблицуЧековККМНаВозвратСкупки(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЧековККМОплаченныхВРассрочку()
	ОбщегоНазначенияРМКПереопределяемый.ЗаполнитьТаблицуЧековККМОплаченныхВРассрочку(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Представление даты сегодня.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", НСтр("ru = 'ДФ=ЧЧ:мм'"));
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЧековККМДата.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаЧековККМ.Дата");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбора.ПравоеЗначение = Новый СтандартнаяДатаНачала(ВариантСтандартнойДатыНачала.НачалоЭтогоДня);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаЧековККМ.Дата");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбора.ПравоеЗначение = Новый СтандартнаяДатаНачала(ВариантСтандартнойДатыНачала.НачалоСледующегоДня);
	
КонецПроцедуры

#КонецОбласти