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
	
	Если Не ЗначениеЗаполнено(Параметры.ОснованиеПлатежа)
		Или Не ЗначениеЗаполнено(Параметры.НастройкиПодключения) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастройкиШаблонов = ПереводыСБПc2bСлужебный.НастройкиШаблоновСообщений();
	ОснованиеПлатежа = Параметры.ОснованиеПлатежа;
	Если Параметры.НастройкиПодключения.Количество() = 1 Тогда
		НастройкаПодключения = Параметры.НастройкиПодключения[0];
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		ВариантОтправки = "ЭлектроннаяПочта";
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда
		ВариантОтправки = "Телефон";
	КонецЕсли;
	
	УправлениеЭлементамиФормыПоДанным();
	УправлениеЭлементамиФормыПоПодсистемам();
	
	ВосстановитьШаблоныПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(НастройкаПодключения) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не обнаружена настройка подключения к Системе быстрых платежей.'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОсновная Тогда
		НачатьПолучениеПлатежнойСсылки();
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиент.УстановитьОтображениеКнопкиКопироватьВБуфер(Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если СтатусОперацииИзменен Тогда
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
		ПараметрыОповещения.Вставить("НастройкаПодключения", НастройкаПодключения);
		Оповестить("ИзмененСтатусСБП", ПараметрыОповещения);
	КонецЕсли;
	
	Если НастройкиШаблонов.Используется 
		И ЗначениеЗаполнено(ОснованиеПлатежа) Тогда
		
		СохранитьШаблоныПоУмолчанию(
			ОснованиеПлатежа,
			ШаблонСообщенияЭлектроннаяПочта,
			ШаблонСообщенияТелефон);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ШаблонСообщенияЭлектроннаяПочтаПриИзменении(Элемент)
	
	ВариантОтправки = "ЭлектроннаяПочта";
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонСообщенияТелефонПриИзменении(Элемент)
	
	ВариантОтправки = "Телефон";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиНастройкаПодключения

&НаКлиенте
Процедура НастройкиПодключенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьНастройкуПодключения(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьНастройкуПодключения(Команда)
	
	СтрокаНастройкиПодключения = НастройкиНастройкаПодключения.НайтиПоИдентификатору(
		Элементы.НастройкиПодключенияВыбор.ТекущаяСтрока);
	Если СтрокаНастройкиПодключения = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбрана настройка подключения для формирования платежной ссылки в Системе быстрых платежей.'"),
			,
			,
			"НастройкиНастройкаПодключения");
		Возврат;
	КонецЕсли;
	
	НастройкаПодключения = СтрокаНастройкиПодключения.НастройкаПодключения;
	Элементы.ОтправитьСсылку.КнопкаПоУмолчанию = Истина;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОсновная;
	НачатьПолучениеПлатежнойСсылки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСсылку(Команда)
	
	Закрыть();
	
	Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
		ОтправитьПлатежнуюСсылку();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьQR(Команда)
	
	Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму(
			"ОбщаяФорма.ОтображениеQRКодаСБПc2b",
			Новый Структура(
				"ПлатежнаяСсылка, ОснованиеПлатежа",
				ПлатежнаяСсылка,
				ОснованиеПлатежа),
			ЭтотОбъект);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Платежная ссылка не сформирована.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСсылку(Команда)
	
	НачатьПолучениеПлатежнойСсылки(ТребуетсяОбновлениеПлатежнойСсылки);
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьВБуфер(Команда)
	
	// Копирование происходит с предварительной очисткой через обработчик, для обхода поведения платформы
	// при повторном копировании - при определенных условиях копирование не происходит.
	ЭтотОбъект.БуферОбмена = "";
	ПодключитьОбработчикОжидания("КопироватьСсылкуВБуфер", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеПлатежнойСсылки

&НаСервере
Функция ПолучитьПлатежнуюСсылкуНаСервере(
		ОснованиеПлатежа,
		УникальныйИдентификатор,
		СоздатьНовую)
	
	Элементы.ОбновитьСсылку.Видимость = Ложь;
	НовыйИдентификаторОплаты = СоздатьНовую;
	ТекущийСтатусОперации = Неопределено;
	ТребуетсяУточнениеСтатуса = Ложь;
	
	ДанныеДляФормированияПлатежнойСсылки =
		РегистрыСведений.ИдентификаторыОперацийСБПc2b.ДанныеДляФормированияПлатежнойСсылкиОперацииСБП(ОснованиеПлатежа);
	
	ИдентификаторМерчанта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		НастройкаПодключения,
		"ИдентификаторМерчанта");
	
	Если ДанныеДляФормированияПлатежнойСсылки <> Неопределено
		И ДанныеДляФормированияПлатежнойСсылки.ИдентификаторМерчанта <> ИдентификаторМерчанта
		И Не СоздатьНовую Тогда
		
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Статус", "НеобходимоАктуализировать");
		
	ИначеЕсли ДанныеДляФормированияПлатежнойСсылки = Неопределено 
		Или СоздатьНовую 
		Или Не ЗначениеЗаполнено(ДанныеДляФормированияПлатежнойСсылки.СтатусОперации)Тогда
		
		НовыйИдентификаторОплаты = Истина;
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Формирование идентификатора оплаты.'");
		
		РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
			ПараметрыВыполнения,
			"ПереводыСБПc2bСлужебный.СлужебныйДинамическаяСсылка",
			ОснованиеПлатежа,
			НастройкаПодключения);
		
	ИначеЕсли ДанныеДляФормированияПлатежнойСсылки.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаВПроцессе() Тогда
		
		ТекущийСтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполняется();
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Актуализация статуса идентификатора оплаты.'");
		
		РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
			ПараметрыВыполнения,
			"ПереводыСБПc2bСлужебный.АктуализироватьСтатусОплаты",
			ОснованиеПлатежа,
			НастройкаПодключения,
			ДанныеДляФормированияПлатежнойСсылки);
		
	ИначеЕсли ДанныеДляФормированияПлатежнойСсылки.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаВыполнена() Тогда
		
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Статус", "СтатусПолучен");
		РезультатВыполнения.Вставить(
			"СтатусОперации",
			СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполнена());
		РезультатВыполнения.Вставить(
			"ПлатежнаяСсылка",
			ДанныеДляФормированияПлатежнойСсылки.ПлатежнаяСсылка);
		РезультатВыполнения.Вставить(
			"СуммаОплаты",
			ДанныеДляФормированияПлатежнойСсылки.СуммаОперации);
		
	ИначеЕсли ДанныеДляФормированияПлатежнойСсылки.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаОтменена()
		ИЛИ ДанныеДляФормированияПлатежнойСсылки.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаОтклонена() Тогда
		
		Если ДанныеДляФормированияПлатежнойСсылки.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаОтменена() Тогда
			ТекущийСтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтменена();
		ИначеЕсли ДанныеДляФормированияПлатежнойСсылки.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаОтклонена() Тогда
			ТекущийСтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтклонена();
		КонецЕсли;
		
		ТребуетсяУточнениеСтатуса = Истина;
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Формирование платежной ссылки.'");
		
		РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
			ПараметрыВыполнения,
			"ПереводыСБПc2bСлужебный.СлужебныйДинамическаяСсылка",
			ОснованиеПлатежа,
			НастройкаПодключения);
		
	Иначе
		РезультатВыполнения = Неопределено;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось определить статус операции, обработка прервана.'"));
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьПлатежнуюСсылкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ТребуетсяОбновлениеПлатежнойСсылки = Ложь;
	ОписаниеОшибки = "";
	КодОшибки = "";
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
	
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если НовыйИдентификаторОплаты Тогда
			СтатусОперацииИзменен = Истина;
			РезультатОперации.Вставить(
				"СтатусОперации",
				СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполняется());
		КонецЕсли;
			
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			СтатусОперации = "Ошибка";
			ОписаниеОшибки = РезультатОперации.СообщениеОбОшибке;
			КодОшибки = РезультатОперации.КодОшибки;
			УправлениеЭлементамиФормыПоСтатусуОперации(СтатусОперации, ОписаниеОшибки, КодОшибки);
			Возврат;
		КонецЕсли;
		
		Если ТребуетсяУточнениеСтатуса Тогда
			ДанныеСтатусаПоОснованиюПлатежа = ПолучитьДанныеСтатусаПоОснованиюПлатежа(ОснованиеПлатежа);
			ЗаполнитьЗначенияСвойств(РезультатОперации, ДанныеСтатусаПоОснованиюПлатежа, "КодОшибки, СообщениеОбОшибке");
			СтатусОперации = ДанныеСтатусаПоОснованиюПлатежа.СтатусОперации;
			РезультатОперации.Вставить("СтатусОперации", СтатусОперации);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			СтатусОперации = "Ошибка";
			ОписаниеОшибки = РезультатОперации.СообщениеОбОшибке;
			КодОшибки = РезультатОперации.КодОшибки;
		ИначеЕсли РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтменена()
			Или РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтклонена() Тогда
			СтатусОперации = РезультатОперации.СтатусОперации;
		Иначе
			ПлатежнаяСсылка = РезультатОперации.ПлатежнаяСсылка;
			СтатусОперации = РезультатОперации.СтатусОперации;
			СуммаОплаты = РезультатОперации.СуммаОплаты;
			Если РезультатОперации.Свойство("НеобходимоАктуализировать") Тогда
				ТребуетсяОбновлениеПлатежнойСсылки = РезультатОперации.НеобходимоАктуализировать;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Результат.Статус = "СтатусПолучен" Тогда
		СтатусОперации = Результат.СтатусОперации;
		СуммаОплаты = Результат.СуммаОплаты;
		Если СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполнена() Тогда
			ПлатежнаяСсылка = Результат.ПлатежнаяСсылка;
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОписаниеОшибки = НСтр("ru = 'Ошибка во время выполнения запроса.'");
		СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОшибка();
	ИначеЕсли Результат.Статус = "НеобходимоАктуализировать" Тогда
		ПлатежнаяСсылка = "";
		ТребуетсяОбновлениеПлатежнойСсылки = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийСтатусОперации)
		И ТекущийСтатусОперации <> СтатусОперации Тогда
		СтатусОперацииИзменен = Истина;
	КонецЕсли;
	
	УправлениеЭлементамиФормыПоСтатусуОперации(
		СтатусОперации,
		ОписаниеОшибки, КодОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПолучениеПлатежнойСсылки(СоздатьНовую = Ложь)
	
	ПлатежнаяСсылка = "";
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	
	РезультатВыполнения = ПолучитьПлатежнуюСсылкуНаСервере(
		ОснованиеПлатежа,
		ЭтотОбъект.УникальныйИдентификатор,
		СоздатьНовую);
		
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПолучитьПлатежнуюСсылкуЗавершение",
		ЭтотОбъект);
	
	Если РезультатВыполнения.Статус <> "Выполняется" Тогда
		ПолучитьПлатежнуюСсылкуЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	Элементы.ДекорацияПояснениеКФорме.ЦветТекста = Новый Цвет;
	Элементы.ДекорацияПояснениеКФорме.Заголовок = НСтр("ru = 'Ожидание ответа сервиса о текущем состоянии оплаты.'");
	Элементы.ДекорацияДлительнаяОперация.Видимость = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
		
КонецПроцедуры

#КонецОбласти

#Область ОтправкаПлатежнойСсылки

&НаКлиенте
Процедура ОтправитьПлатежнуюСсылку()
	
	ШаблоныИспользуются = НастройкиШаблонов.Используется;
	
	Если ВариантОтправки = "ЭлектроннаяПочта" Тогда
		
		Если ШаблоныИспользуются И ЗначениеЗаполнено(ШаблонСообщенияЭлектроннаяПочта) Тогда
			СформироватьСообщениеДляОтправки(КонструкторПараметровОтправки(ШаблонСообщенияЭлектроннаяПочта, "Письмо"));
		Иначе
			Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
				МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
				МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(КонструкторПараметровОтправкиБезШаблона());
			КонецЕсли;
		КонецЕсли;
	
	ИначеЕсли ВариантОтправки = "Телефон" Тогда
		
		Если ШаблоныИспользуются И ЗначениеЗаполнено(ШаблонСообщенияТелефон) Тогда
			СформироватьСообщениеДляОтправки(КонструкторПараметровОтправки(ШаблонСообщенияТелефон, "СообщениеSMS"));
		Иначе
			ПоказатьФормуСообщения(
				Новый Структура("Текст, Получатель, ДополнительныеПараметры", ПлатежнаяСсылка, СписокПолучателей())
				,
				"СообщениеSMS",
				ОснованиеПлатежа);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФормуСообщения(Сообщение, ВидСообщения, Предмет)
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда 
			
			ДополнительныеПараметры = Новый Структура("ИсточникКонтактнойИнформации, Предмет, ПеревестиВТранслит");
			
			Если Сообщение.ДополнительныеПараметры <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Сообщение.ДополнительныеПараметры);
			КонецЕсли;
			
			ДополнительныеПараметры.Предмет = Предмет;
			
			Текст = ?(Сообщение.Свойство("Текст"), Сообщение.Текст, "");
			
			Получатели = Новый Массив;
			
			ЗаполнитьПолучателейИзСообщения(Получатели, Сообщение);
			
			МодульОтправкаSMSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОтправкаSMSКлиент");
			МодульОтправкаSMSКлиент.ОтправитьSMS(Получатели, Текст, ДополнительныеПараметры);
			
		Иначе
			КопироватьСсылкуВБуфер();
		КонецЕсли;
	Иначе
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСообщениеДляОтправки(ПараметрыОтправки)
	
	Результат = СформироватьСообщениеНаСервере(ПараметрыОтправки);
	
	ПоказатьФормуСообщения(
		Результат,
		ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения,
		ПараметрыОтправки.Предмет);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьСообщениеНаСервере(ПараметрыОтправки)
	
	МодульШаблоныСообщений = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщений");
	
	Результат = МодульШаблоныСообщений.СформироватьСообщение(
		ПараметрыОтправки.Шаблон,
		ПараметрыОтправки.Предмет,
		ПараметрыОтправки.УникальныйИдентификатор,
		ПараметрыОтправки.ДополнительныеПараметры);
	
	Вложения = Новый Массив;
	
	Для каждого ЭлементКоллекции Из Результат.Вложения Цикл
		
		ТекущееВложение = Новый Структура;
		
		ТекущееВложение.Вставить("Представление");
		ТекущееВложение.Вставить("АдресВоВременномХранилище");
		ТекущееВложение.Вставить("Кодировка");
		ТекущееВложение.Вставить("Идентификатор");
		
		ЗаполнитьЗначенияСвойств(ТекущееВложение, ЭлементКоллекции);
		
		Вложения.Добавить(ТекущееВложение);
		
	КонецЦикла;
	
	Результат.Вставить("Предмет", ПараметрыОтправки.Предмет);
	Результат.Вложения = Вложения;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция КонструкторПараметровОтправки(Шаблон, ВидСообщения)
	
	ПараметрыОтправки = Новый Структура();
	ПараметрыОтправки.Вставить("Шаблон", Шаблон);
	ПараметрыОтправки.Вставить("Предмет", ОснованиеПлатежа);
	ПараметрыОтправки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтправки.Вставить("ДополнительныеПараметры", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Истина);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ВидСообщения", ВидСообщения);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ОтправитьСразу", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("КонтактныеДанныеЧека", "");
	
	Возврат ПараметрыОтправки;
	
КонецФункции

&НаКлиенте
Функция КонструкторПараметровОтправкиБезШаблона()
	
	ПараметрыСообщения = Новый Структура;
	
	ПараметрыСообщения.Вставить("Получатель", СписокПолучателей());
	ПараметрыСообщения.Вставить("Предмет", ОснованиеПлатежа);
	ПараметрыСообщения.Вставить("Тема", НСтр("ru = 'Ссылка для оплаты'"));
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("НастройкаПодключения", НастройкаПодключения);
	ПараметрыОперации.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	
	Если ИнтернетПоддержкаПользователейВызовСервера.ОтправлятьПисьмаВФорматеHTML() Тогда
		ПараметрыСообщения.Вставить(
			"Текст",
			Новый Структура(
				"ТекстHTML, СтруктураВложений",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстПисьмаБезШаблонаHTML(),
					ПлатежнаяСсылка),
				Новый Структура()));
	Иначе
		ПараметрыСообщения.Вставить(
			"Текст",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстПисьмаБезШаблонаТекст(),
				ПлатежнаяСсылка));
	КонецЕсли;
	
	ИнтеграцияПодсистемБИПКлиент.ПриЗаполненииПараметровСообщенияБезШаблонаСБП(
		ПараметрыСообщения,
		ПараметрыОперации);
	ПереводыСБПc2bКлиентПереопределяемый.ПриЗаполненииПараметровСообщенияБезШаблонаСБП(
		ПараметрыСообщения,
		ПараметрыОперации);
	
	Возврат ПараметрыСообщения;
	
КонецФункции

&НаКлиенте
Функция ТекстПисьмаБезШаблонаHTML()
	
	HTMLСтрока =
	"<html>
	|<head>
	|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
	|<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"" />
	|<meta name=""format-detection"" content=""telephone=no"" />
	|</head>
	|<body>
	|<p>Ссылка для оплаты: <a href=""%1"">%1</a></p>
	|
	|</body>
	|</html>";
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1'"), HTMLСтрока);
	
КонецФункции

&НаКлиенте
Функция ТекстПисьмаБезШаблонаТекст()
	
	Возврат НСтр("ru = 'Ссылка для оплаты: %1'");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПолучателейИзСообщения(Получатели, Сообщение)
	
	Если Не Сообщение.Свойство("Получатель") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Сообщение.Получатель) = Тип("СписокЗначений") Тогда
		
		Для каждого ЭлементКоллекции Из Сообщение.Получатель Цикл
			
			КонтактныеДанные = Новый Структура;
			
			КонтактныеДанные.Вставить("Телефон",                      ЭлементКоллекции.Значение);
			КонтактныеДанные.Вставить("Представление",                ЭлементКоллекции.Представление);
			КонтактныеДанные.Вставить("ИсточникКонтактнойИнформации", Неопределено);
			
			Получатели.Добавить(КонтактныеДанные);
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Сообщение.Получатель) = Тип("Массив") Тогда
		
		Для каждого ЭлементКоллекции Из Сообщение.Получатель Цикл
			
			КонтактныеДанные = Новый Структура;
			
			КонтактныеДанные.Вставить("Телефон",                      ЭлементКоллекции.НомерТелефона);
			КонтактныеДанные.Вставить("Представление",                ЭлементКоллекции.Представление);
			КонтактныеДанные.Вставить("ИсточникКонтактнойИнформации", ЭлементКоллекции.ИсточникКонтактнойИнформации);
			
			Получатели.Добавить(КонтактныеДанные);
		
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СписокПолучателей()
	
	СписокПолучателей = Новый СписокЗначений;
	
	ИнтеграцияПодсистемБИП.ПриФормированииСпискаПолучателейСообщенияСБП(
		ОснованиеПлатежа,
		ВариантОтправки,
		СписокПолучателей);
	ПереводыСБПc2bПереопределяемый.ПриФормированииСпискаПолучателейСообщенияСБП(
		ОснованиеПлатежа,
		ВариантОтправки,
		СписокПолучателей);
	
	Возврат СписокПолучателей;
	
КонецФункции

#КонецОбласти

#Область ШаблоныПоУмолчанию

&НаСервереБезКонтекста
Процедура СохранитьШаблоныПоУмолчанию(ОснованиеПлатежа, ШаблонСообщенияЭлектроннаяПочта, ШаблонСообщенияТелефон)
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОснованиеПлатежа)) Тогда
		ПредставлениеОснования = ОснованиеПлатежа.Метаданные().ПолноеИмя();
	Иначе
		ПредставлениеОснования = ОснованиеПлатежа;
	КонецЕсли;
	
	// Шаблоны электронной почты
	КлючНастроек = "ШаблоныСообщенийЭлектроннойПочты";
	
	Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ФормаФункциональнойСсылкиСБП",
		КлючНастроек);
	
	Если Настройки = Неопределено Тогда
		ШаблоныПоУмолчанию = Новый Соответствие();
	Иначе
		ШаблоныПоУмолчанию = Настройки;
	КонецЕсли;
	
	ШаблоныПоУмолчанию.Вставить(ПредставлениеОснования, ШаблонСообщенияЭлектроннаяПочта);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"ФормаПодготовкиПлатежнойСсылкиСБП",
		КлючНастроек,
		ШаблоныПоУмолчанию);
	
	// Шаблоны SMS сообщений
	КлючНастроек = "ШаблоныСообщенийSMS";
	
	Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ФормаФункциональнойСсылкиСБП",
		КлючНастроек);
	
	Если Настройки = Неопределено Тогда
		ШаблоныПоУмолчанию = Новый Соответствие();
	Иначе
		ШаблоныПоУмолчанию = Настройки;
	КонецЕсли;
	
	ШаблоныПоУмолчанию.Вставить(ПредставлениеОснования, ШаблонСообщенияТелефон);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"ФормаПодготовкиПлатежнойСсылкиСБП",
		КлючНастроек,
		ШаблоныПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьШаблоныПоУмолчанию()
	
	Если НастройкиШаблонов.Используется
		И ЗначениеЗаполнено(ОснованиеПлатежа) Тогда
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОснованиеПлатежа)) Тогда
			ПредставлениеОснования = ОснованиеПлатежа.Метаданные().ПолноеИмя();
		Иначе
			ПредставлениеОснования = ОснованиеПлатежа;
		КонецЕсли;
		
		// Шаблоны электронной почты
		Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
			"ФормаПодготовкиПлатежнойСсылкиСБП",
			"ШаблоныСообщенийЭлектроннойПочты");
		
		Если Настройки <> Неопределено
			И ТипЗнч(Настройки) = Тип("Соответствие")
			И Настройки[ПредставлениеОснования] <> Неопределено Тогда
			
			ШаблонСообщенияЭлектроннаяПочта = Настройки[ПредставлениеОснования];
			
		КонецЕсли;
		
		// Шаблоны SMS сообщений
		Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
			"ФормаПодготовкиПлатежнойСсылкиСБП",
			"ШаблоныСообщенийSMS");
		
		Если Настройки <> Неопределено
			И ТипЗнч(Настройки) = Тип("Соответствие")
			И Настройки[ПредставлениеОснования] <> Неопределено Тогда
			
			ШаблонСообщенияТелефон = Настройки[ПредставлениеОснования];
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УправлениеЭлементамиФормыПоДанным()
	
	Если Параметры.НастройкиПодключения.Количество() = 1 Тогда
		Элементы.ОтправитьСсылку.КнопкаПоУмолчанию = Истина;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОсновная;
	Иначе
		Для Каждого НастройкаПодключения Из Параметры.НастройкиПодключения Цикл
			НоваяНастройкаПодключения = НастройкиНастройкаПодключения.Добавить();
			НоваяНастройкаПодключения.НастройкаПодключения = НастройкаПодключения;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормыПоПодсистемам()
	
	ЕстьЭлектроннаяПочта = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
	ЕстьОтправкаSMS = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS");
	ИспользуютсяШаблоны = НастройкиШаблонов.Используется;
	
	ЕстьВыборВариантаОтправки = ЕстьЭлектроннаяПочта И ЕстьОтправкаSMS;

	Элементы.ГруппаВариантОтправкиЭлектроннаяПочта.Видимость = ЕстьЭлектроннаяПочта;
	Элементы.НадписьВариантОтправкиЭлектроннаяПочта.Видимость = Не ЕстьВыборВариантаОтправки;
	Элементы.ВариантОтправкиЭлектроннаяПочта.Видимость = ЕстьВыборВариантаОтправки;
	
	Элементы.ГруппаВариантОтправкиТелефон.Видимость = ЕстьОтправкаSMS;
	Элементы.НадписьВариантОтправкиТелефон.Видимость = Не ЕстьВыборВариантаОтправки;
	Элементы.ВариантОтправкиТелефон.Видимость = ЕстьВыборВариантаОтправки;
	
	Если Не ЕстьЭлектроннаяПочта И Не ЕстьОтправкаSMS Тогда
		Элементы.ГруппаВариантОтправки.Видимость = Ложь;
		Элементы.ОтправитьСсылку.Видимость = Ложь; 
	КонецЕсли;
	
	Если Не (ЕстьВыборВариантаОтправки ИЛИ ИспользуютсяШаблоны) Тогда
		
		Элементы.ГруппаВариантОтправки.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ИспользуютсяШаблоны Тогда
		Элементы.ГруппаВариантОтправки.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ГруппаВариантОтправкиПереключатели.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ШаблонСообщенияЭлектроннаяПочта.Видимость = Ложь;
		Элементы.ШаблонСообщенияТелефон.Видимость = Ложь;
		Элементы.ДекорацияКонвертОтправка.Видимость = Ложь;
		Элементы.ДекорацияСообщенияОтправка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормыПоСтатусуОперации(СтатусОперации, ОписаниеОшибки, КодОшибки)
	
	Элементы.ДекорацияДлительнаяОперация.Видимость = Ложь;
	
	Если ТребуетсяОбновлениеПлатежнойСсылки Тогда
		
		Элементы.ДекорацияПояснениеКФорме.Заголовок = 
			НСтр("ru = 'Внимание. Данные оплаты были изменены, требуется обновление ссылки.'");
		
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
		
		Элементы.Страницы.ТолькоПросмотр = Истина;
		Элементы.ОбновитьСсылку.Видимость = Истина;
		Элементы.КопироватьВБуфер.Доступность = Ложь;
		Элементы.ОтправитьСсылку.Доступность = Ложь;
		Элементы.ПоказатьQR.Доступность = Ложь;
	ИначеЕсли СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполняется() Тогда
		
		Элементы.ДекорацияПояснениеКФорме.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ссылка для оплаты сформирована и готова к отправке покупателю. Сумма к оплате %1 руб.'"),
				СуммаОплаты);
			
		Элементы.ДекорацияПояснениеКФорме.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = Новый Цвет;
		
		Элементы.Страницы.ТолькоПросмотр = Ложь;
		Элементы.ГруппаВариантОтправки.ТолькоПросмотр = Ложь;
		Элементы.ГруппаПолеВводаСсылки.ТолькоПросмотр = Ложь;
		Элементы.ОбновитьСсылку.Видимость = Ложь;
		Элементы.КопироватьВБуфер.Доступность = Истина;
		Элементы.ОтправитьСсылку.Доступность = Истина;
		Элементы.ПоказатьQR.Доступность = Истина;
		
	ИначеЕсли СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполнена() Тогда
		
		Элементы.ДекорацияПояснениеКФорме.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Платежная ссылка была сформирована и отправлена покупателю. Оплачена сумма %1 руб.'"),
				СуммаОплаты);
		
		Элементы.ДекорацияПояснениеКФорме.ЦветФона = ЦветаСтиля.ЦветФонаПодсказки;
		
		Элементы.Страницы.ТолькоПросмотр = Истина;
		Элементы.ОбновитьСсылку.Видимость = Ложь;
		Элементы.КопироватьВБуфер.Доступность = Ложь;
		Элементы.ОтправитьСсылку.Доступность = Ложь;
		Элементы.ПоказатьQR.Доступность = Ложь;
		
	ИначеЕсли СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОшибка() Тогда
		
		Элементы.ДекорацияПояснениеКФорме.Заголовок = ОписаниеОшибки;
		
		Если КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиУжеОплачен() Тогда
			Элементы.ДекорацияПояснениеКФорме.ЦветФона = ЦветаСтиля.ЦветФонаПодсказки;
			Элементы.ОбновитьСсылку.Видимость = Ложь;
		Иначе
			Элементы.ДекорацияПояснениеКФорме.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			Элементы.ОбновитьСсылку.Видимость = Истина;
		КонецЕсли;
			
		Элементы.ГруппаВариантОтправки.ТолькоПросмотр = Истина;
		Элементы.ГруппаПолеВводаСсылки.ТолькоПросмотр = Истина;
		Элементы.КопироватьВБуфер.Доступность = Ложь;
		Элементы.ОтправитьСсылку.Доступность = Ложь;
		Элементы.ПоказатьQR.Доступность = Ложь;
		
	ИначеЕсли СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтклонена()
		ИЛИ СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтменена() Тогда
		
		Элементы.ДекорацияПояснениеКФорме.Заголовок = 
			НСтр("ru = 'Операция отменена или истек срок жизни платежной ссылки, для обновления необходимо изменить данные оплаты.'");
			
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста; 
	
		Элементы.Страницы.ТолькоПросмотр = Истина;
		Элементы.ОбновитьСсылку.Видимость = Ложь;
		Элементы.КопироватьВБуфер.Доступность = Ложь;
		Элементы.ОтправитьСсылку.Доступность = Ложь;
		Элементы.ПоказатьQR.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСсылкуВБуфер()
	
	ЭтотОбъект.БуферОбмена = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<!DOCTYPE html>
		|<html>
		|	<body onload='copy()'>
		|		<input id='input' type='text'/>
		|		<script>
		|			function copy() {
		|				var text = '%1';
		|				var ua = navigator.userAgent;
		|				if (ua.search(/MSIE/) > 0 || ua.search(/Trident/) > 0) {
		|					window.clipboardData.setData('Text', text);
		|				} else {
		|					var copyText = document.getElementById('input');
		|					copyText.value = text;
		|					copyText.select();
		|					document.execCommand('copy');
		|				}
		|			}
		|		</script>
		|	</body>
		|</html>",
		ПлатежнаяСсылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Ссылка получена'"),
		,
		НСтр("ru = 'Ссылка для оплаты через СБП скопирована в буфер обмена'"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеСтатусаПоОснованиюПлатежа(ОснованиеПлатежа)
	
	ДанныеОснованияПлатежа =
		РегистрыСведений.ИдентификаторыОперацийСБПc2b.ДанныеДляФормированияПлатежнойСсылкиОперацииСБП(ОснованиеПлатежа);
		
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("СтатусОперации", Неопределено);
	РезультатОперации.Вставить("КодОшибки", "");
	РезультатОперации.Вставить("СообщениеОбОшибке", "");
		
	Если ДанныеОснованияПлатежа.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаВПроцессе() Тогда
		РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполняется();
	ИначеЕсли ДанныеОснованияПлатежа.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаВыполнена() Тогда
		РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполнена();
	ИначеЕсли ДанныеОснованияПлатежа.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаОтменена() Тогда
		РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтменена();
	ИначеЕсли ДанныеОснованияПлатежа.СтатусОперации = СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаОтклонена() Тогда
		РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОтклонена();
	Иначе
		РезультатОперации.КодОшибки = "НеизвестныйСтатус";
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Не удалось определить статус операции.'");
		РезультатОперации.СтатусОперации = СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииОшибка();
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

#КонецОбласти

