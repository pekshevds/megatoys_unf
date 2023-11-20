#Область ПрограммныйИнтерфейс

#Область Отправка

Функция ПоказатьФормуДлительнойОтправки(ДополнительныеПараметры) Экспорт
	
	Если ЭтоПопыткаОткрытияВторогоОкнаДлительнойОперации(Истина, Ложь) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапомнитьКонтекстДлительнойОперации(ДополнительныеПараметры.КонтекстДлительнойОперации);
	ДополнительныеПараметры.Удалить("КонтекстДлительнойОперации");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьФормуДлительногоПроцесса", ЭтотОбъект, ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
	Возврат Истина;
	
КонецФункции

// Процедура - Оповестить об удачной отправке
//
// Параметры:
//  Параметры	 - Неопределено, Структура - Параметры оповещения:
//     * ПараметрыАвтозапроса - Структура - Параметры для выполнения автозапроса. 
//     * РезультатОтправки - Булево - Отчет отправлен или нет.
//     * ВыполняемоеОповещение - ОписаниеОповещения - описание оповещения действия, 
//           которое должно быть выполнено после закрытия формы длительной операции.
//
Процедура ОповеститьОбУдачнойОтправке(Параметры = Неопределено) Экспорт
	
	Оповестить("Успешная отправка", Параметры);
	
КонецПроцедуры

// Параметры:
//  Параметры	 - Неопределено, Структура - Параметры оповещения:
//     * НетДоступаВИнтернет  - Булево - Флаг, сообщающий об неудачной отправки в связи с отсуствием Интернета. 
//     * ПараметрыАвтозапроса - Структура - Параметры для выполнения автозапроса. 
//     * РезультатОтправки    - Булево - Отчет отправлен или нет.
//     * ВыполняемоеОповещение - ОписаниеОповещения - описание оповещения действия, 
//           которое должно быть выполнено после закрытия формы длительной операции.
//
Процедура ОповеститьОНеудачнойОтправке(Параметры = Неопределено) Экспорт
	
	Если ФормаГрупповойОтправкиЕстьСредиОткрытых(Истина) Тогда
		Форма = ФормаГрупповойОтправкиИзОткрытых(Истина);
		Если Форма.ВыполняетсяОтправка Тогда
			Оповестить("Неудачная отправка", Параметры);
		Иначе
			ОповеститьОРезультатеПроверкиВИнтернете(Ложь, "");
		КонецЕсли;
	ИначеЕсли ФормаДлительнойОтправкиЕстьСредиОткрытых(Ложь) Тогда
		// Оповещаем форму длительного обмена.
		Оповестить("Неудачная отправка", Параметры);
	ИначеЕсли Параметры <> Неопределено Тогда
		// Выполним действие, которое должно выполниться после неудачной операции.
		ВыполнитьСледующееДействие(Истина, Параметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповеститьОНеудачномДействии(ТекстОшибки = "") Экспорт
	
	ОповеститьОРезультатеПроверкиВИнтернете(Ложь, ТекстОшибки);
	
КонецПроцедуры

Процедура ОповеститьОРезультатеПроверкиВИнтернете(Успешно, Параметры) Экспорт
	
	Форма = ФормаГрупповойОтправкиИзОткрытых(Истина);
	Если Форма <> Неопределено Тогда
		
		Оповещение = ОповещениеОЗавершенииГрупповогоДействия(Форма);
		Если Оповещение <> Неопределено Тогда
			
			ВыполняемоеОповещение = Новый ОписаниеОповещения(
				Оповещение.ИмяПроцедуры,
				Оповещение.Модуль,
				Параметры);
			
			Если Успешно Тогда
				ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, ДлительнаяОтправкаКлиентСервер.ОповещениеУспешнаяПроверкаВИнтернете());
			Иначе
				ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, ДлительнаяОтправкаКлиентСервер.ОповещениеНеуспешнаяПроверкаВИнтернете());
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗакрытьФормуДлительнойОтправкиБезДальнейшихДействий() Экспорт

	Оповестить("Завершить отправку без дальнейших действий");

КонецПроцедуры

// При отправке в ФСРАР и ФТС сообщения копятся на сервере, а затем выводятся на клиенте за один раз.
Процедура ВывестиСообщенияССервераНаКлиенте(СообщенияПользователю) Экспорт
	
	Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(СообщениеПользователю);
	КонецЦикла;
	
	СообщенияПользователю.Очистить();
	
КонецПроцедуры

Функция ПараметрыДлительнойОтправки() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоОтправка", 					Истина);
	ДополнительныеПараметры.Вставить("ОтчетСсылка", 					Неопределено);
	ДополнительныеПараметры.Вставить("ОбщееКоличествоЭтапов", 			0);
	ДополнительныеПараметры.Вставить("КонтекстДлительнойОперации", 		Неопределено);
	ДополнительныеПараметры.Вставить("ЭтоОтправкаИзФормы1СОтчетность", 	Ложь);
	ДополнительныеПараметры.Вставить("ТипОперации", 					"");
	
	Возврат ДополнительныеПараметры;
	 
КонецФункции

Процедура ПоказатьПростуюФормуОжидания(Форма) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИдентификаторВладельца", Форма.УникальныйИдентификатор);
	
	ОткрытьФорму("Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.ДлительнаяОперация", ДополнительныеПараметры, Форма);
	
КонецПроцедуры

Процедура ЗакрытьПростуюФормуОжидания(Форма) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИдентификаторВладельца", Форма.УникальныйИдентификатор);
	
	Оповестить("Закрыть_ДлительнаяОперация",,Форма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ГрупповаяОтправка

Функция ФормаГрупповойОтправкиЕстьСредиОткрытых(УчитыватьВыполнениеОтправкиИлиПроверки = Истина) Экспорт
	
	Окно = ФормаГрупповойОтправкиИзОткрытых(УчитыватьВыполнениеОтправкиИлиПроверки);
	
	Возврат Окно <> Неопределено;
	
КонецФункции

Функция ФормаГрупповойОтправкиИзОткрытых(УчитыватьВыполнениеОтправкиИлиПроверки = Истина) Экспорт
	
	Окна = ПолучитьОкна();
	
	Если Окна = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Для Каждого ОткрытоеОкно Из Окна Цикл
		
		Если ТипЗнч(ОткрытоеОкно) <> Тип("ОкноКлиентскогоПриложения") Тогда
			Продолжить;
		КонецЕсли;
		
		ОткрытыеФормы = ОткрытоеОкно.Содержимое;
		
		Если ОткрытыеФормы.Количество() <> 1 Тогда
			Продолжить;
		КонецЕсли;
		
		ОткрытаяФорма = ОткрытыеФормы[0];
		ИмяФормы      = ОткрытаяФорма.ИмяФормы;
		Открыта       = ОткрытаяФорма.Открыта();
		КраткоеИмя    = ДлительнаяОтправкаКлиентСервер.ИмяФормыПоПолномуИмени(ИмяФормы);
		
		ЭтоФормаГрупповойОтправки = КраткоеИмя = "ГрупповаяОтправка";
		
		Если ЭтоФормаГрупповойОтправки И Открыта Тогда
			
			УчтеноВыполнениеОтправки = 
				ОткрытаяФорма.ВыполняетсяОтправкаИлиПроверка И УчитыватьВыполнениеОтправкиИлиПроверки 
				ИЛИ НЕ УчитыватьВыполнениеОтправкиИлиПроверки;
			
			Если УчтеноВыполнениеОтправки Тогда
				Возврат ОткрытаяФорма;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОповещениеОЗавершенииГрупповогоДействия(Значение) Экспорт
	
	Форма = ДлительнаяОтправкаКлиентСервер.ФормаГрупповойОтправки(Значение);
	
	Если Форма = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат Форма.ОповещениеОЗавершенииДействия;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбменИРасшифровка

Функция ПоказатьФормуДлительногоОбмена(ДополнительныеПараметры) Экспорт
	
	Если ЭтоПопыткаОткрытияВторогоОкнаДлительнойОперации(Ложь, ДополнительныеПараметры.ЭтоРасшифровка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапомнитьКонтекстДлительнойОперации(ДополнительныеПараметры);
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьФормуДлительногоПроцесса", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
	Возврат Истина;

КонецФункции

// Оповещение формы бублика о начале нового этапа обмена.
// Используется для наращивания процента.
// 
Процедура ОповеститьОСменеЭтапаОбмена(
		ИмяСобытия, 
		Орган = Неопределено,
		Отправка = Неопределено, 
		УчетнаяЗапись = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИмяСобытия", 		ИмяСобытия);
	ДополнительныеПараметры.Вставить("Орган", 			Орган);
	ДополнительныеПараметры.Вставить("Отправка", 		Отправка);
	ДополнительныеПараметры.Вставить("УчетнаяЗапись", 	УчетнаяЗапись);
	
	Оповестить("Смена этапа обмена", ДополнительныеПараметры);
	
КонецПроцедуры

// Оповещение формы бублика о начале нового этапа обмена.
// Используется для наращивания процента.
// 
Процедура ОповеститьОСменеЭтапаРасшифровки(Параметры) Экспорт
	
	Оповестить("Смена этапа расшифровки", Параметры);
	
КонецПроцедуры

Процедура ОповеститьОЗавершенииОбмена() Экспорт
	
	Оповестить("Завершение обновления");
	
КонецПроцедуры

Процедура ОповеститьОЗавершенииРасшифровки(Параметры) Экспорт
	
	Оповестить("Завершение расшифровки", Параметры);
	
КонецПроцедуры

Функция ПараметрыДлительногоОбмена() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоОбмен", 					Истина);
	ДополнительныеПараметры.Вставить("ЭтоРасшифровка", 				Ложь);
	ДополнительныеПараметры.Вставить("ЭтоАвторасшифровка",          Ложь);
	ДополнительныеПараметры.Вставить("ЭтоОбменИзФормы1СОтчетность", Ложь);
	ДополнительныеПараметры.Вставить("ЭтоОбменИзОтчета", 			Ложь);
	ДополнительныеПараметры.Вставить("ЭтоОбменИзЭтаповОтправки", 	Ложь);
	ДополнительныеПараметры.Вставить("ЭтоОбменИзЖурналаОбмена", 	Ложь);
	ДополнительныеПараметры.Вставить("ОтчетСсылка", 				Неопределено);
	ДополнительныеПараметры.Вставить("Организации", 				Неопределено);
	ДополнительныеПараметры.Вставить("ВыводитьПроценты", 			Истина);
	ДополнительныеПараметры.Вставить("ОбщееКоличествоЭтапов", 		0);
	ДополнительныеПараметры.Вставить("АдресДереваНовыхСобытий",     "");
	
	Возврат ДополнительныеПараметры;
	 
КонецФункции

Процедура ОповеститьОНевозможностиОбновитьСтатусОтчета() Экспорт
	
	Оповестить("Невозможно обновить состояние отчета");
	
КонецПроцедуры

#КонецОбласти

#Область МастерИлиЗагрузкаМодуля

Функция ОткрытьФормуОжиданияЗагрузкиМодуля(ДополнительныеПараметры, КонтекстЭДО = Неопределено) Экспорт
	
	ДополнительныеПараметры.Вставить("ЭтоОбновлениеМодуля", Истина);
	
	ФормаОткрыта = ДлительнаяОтправкаКлиентСервер.ФормаДлительнойОтправкиОткрыта()
		ИЛИ ФормаЕстьСредиОткрытых("Мастер_ОпределениеОткрываемойФормы");
	
	Если ФормаОткрыта Тогда
		
		// Если форма открыта, значит КонтекстЭДО уже был получен и сейчас получать его повторно не нужно.
		СообщитьОНачалеОбновленияМодуля(ДополнительныеПараметры);
		
	ИначеЕсли КонтекстЭДО <> Неопределено Тогда
		
		Результат = Новый Структура();
		Результат.Вставить("КонтекстЭДО", КонтекстЭДО);
		Результат.Вставить("ТекстОшибки", "");
	
		ПоказатьФормуДлительногоПроцесса(Результат, ДополнительныеПараметры);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПоказатьФормуДлительногоПроцесса", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
			
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
		
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

// Процедура - Закрыть форму ожидания загрузки модуля
//
// Параметры:
//  ОставитьОткрытой		 - Булево - Если обновление выполняется из мастера, то ОставитьОткрытой = Ложь.
//		И только в момент открытия мастера ОставитьОткрытой = Истина. Т.е. закрытие бублика выполняется из мастера.
//  УдалосьОбновитьМодуль	 - Булево, Неопределено. Неопределено - если форму бублика нужно закрыть молча без 
//		отображения результата обновления.
//
Процедура ЗакрытьФормуОжиданияЗагрузкиМодуля(ОставитьОткрытой = Ложь, УдалосьОбновитьМодуль = Неопределено) Экспорт

	Если ОставитьОткрытой Тогда
		
		Заголовок 			= НСтр("ru = 'Пожалуйста, подождите...'");
		ОсновнойТекст 		= НСтр("ru = 'Открывается помощник подключения к 1С-Отчетности...'"); 
		
		ОбновитьНадписьИЗаголовок(ОсновнойТекст, , Заголовок);
		
	Иначе
		Оповестить("Закрыть форму ожидания загрузки модуля", УдалосьОбновитьМодуль);
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьНадписьИЗаголовок(
	ОсновнойТекст 		= Неопределено, 
	ДополнительныйТекст = Неопределено, 
	Заголовок 			= Неопределено,
	ЭтоНачалоОбновления = Ложь) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОсновнойТекст", 		ОсновнойТекст);
	ДополнительныеПараметры.Вставить("ДополнительныйТекст", ДополнительныйТекст);
	ДополнительныеПараметры.Вставить("Заголовок", 			Заголовок);
	ДополнительныеПараметры.Вставить("ЭтоНачалоОбновления", ЭтоНачалоОбновления);

	Оповестить(НСтр("ru = 'Длительное действие. Обновить надпись и заголовок'"), ДополнительныеПараметры); 
	
КонецПроцедуры

Процедура СообщитьОНачалеОбновленияМодуля(ВходящийКонтекст)
	
	Если ВходящийКонтекст.Свойство("ЭтоОбновлениеМодуля") 
		И ВходящийКонтекст.ЭтоОбновлениеМодуля Тогда
	
		Если ВходящийКонтекст.ЭтоОбновлениеИзМастера Тогда
			ОсновнойТекст = НСтр("ru = 'Открывается помощник подключения к 1С-Отчетности...'"); 
		Иначе
			ОсновнойТекст = НСтр("ru = 'Выполняется обновление модуля 1С-Отчетности...'");
		КонецЕсли;
		
		Заголовок = НСтр("ru = 'Пожалуйста, подождите...'");
		
		ОбновитьНадписьИЗаголовок(ОсновнойТекст, , Заголовок, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаЗаявления

Функция ПоказатьФормуДлительнойОтправкиЗаявления(ДополнительныеПараметры) Экспорт
		
	Если ЭтоПопыткаОткрытияВторогоОкнаДлительнойОперации(Ложь, Ложь) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапомнитьКонтекстДлительнойОперации(ДополнительныеПараметры);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьФормуДлительногоПроцесса", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
	Возврат Истина;

КонецФункции

Функция ПараметрыДлительнойОтправкиЗаявления() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоОтправкаЗаявления", 		Истина);
	ДополнительныеПараметры.Вставить("Организация", 				Неопределено);
	ДополнительныеПараметры.Вставить("ВыводитьПроценты", 			Ложь);
	ДополнительныеПараметры.Вставить("СоздаватьКлюч"	, 			Ложь);
	
	Возврат ДополнительныеПараметры;
	 
КонецФункции

Процедура ОповеститьОбУдачнойОтправкеЗаявления(Организация, Заявление = Неопределено, ТекстПояснения = Неопределено) Экспорт
	
	Оповестить(
		"Успешная отправка заявления на переход",
		Новый Структура("Организация, ТекстПояснения", Организация, ТекстПояснения),
		Заявление);
	
КонецПроцедуры

Процедура ОповеститьОНеудачнойОтправкеЗаявления() Экспорт
	
	Оповестить("Неудачная отправка заявления на переход");
	
КонецПроцедуры

#КонецОбласти

#Область Общие

Функция ПоказатьУниверсальнуюФормуДлительногоДействия(ДополнительныеПараметры) Экспорт
		
	Если ЭтоПопыткаОткрытияВторогоОкнаДлительнойОперации(Ложь, Ложь) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗапомнитьКонтекстДлительнойОперации(ДополнительныеПараметры);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьФормуДлительногоПроцесса", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
	Возврат Истина;

КонецФункции

Функция ПараметрыЗапускаУниверсальногоДлительногоДействия() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Заголовок", "");
	ДополнительныеПараметры.Вставить("Надпись"	, "");
	ДополнительныеПараметры.Вставить("ВыводитьПроценты", Ложь);
	ДополнительныеПараметры.Вставить("ЭтоУниверсальноеОжидание"	, Истина);
	
	Возврат ДополнительныеПараметры;
	 
КонецФункции

// Для метода ВывестиСостояниеВФормуДлительногоДействия
Функция ПараметрыСостоянияУниверсальногоДлительногоДействия() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Заголовок", "");
	ДополнительныеПараметры.Вставить("Надпись"	, "");
	ДополнительныеПараметры.Вставить("Картинка"	, БиблиотекаКартинок.ДлительнаяОперация48);
	ДополнительныеПараметры.Вставить("ПоказатьКнопкуЗакрыть", Ложь);
	
	Возврат ДополнительныеПараметры;
	 
КонецФункции

Процедура ВывестиСостояниеВФормуДлительногоДействия(ПараметрыФормы) Экспорт
	
	Оповестить("Изменить состояние длительного действия", ПараметрыФормы);

КонецПроцедуры
 

// Отправляет в форму длительной операции оповещение о том, 
// какое действие сейчас выполняется после нажатия на кнопку Отправить.
// Если форма закрыта, то текст выводится в всплывающее окно состояния.
//
// Эта процедура так же вызывается из модуля РегламентированнаяОтчетностьКлиент!
// 
Процедура ВывестиСостояние(ТекстСообщения, Картинка = Неопределено) Экспорт
	
	ФормаОткрыта = ДлительнаяОтправкаКлиентСервер.ФормаДлительнойОтправкиОткрыта();
	
	Если ДлительнаяОтправкаКлиент.ВыводСостоянияЗапрещен() Тогда
		// Ничего не делаем.
	ИначеЕсли ФормаОткрыта Тогда 
		Оповестить("Пересчитать процент отправки", ТекстСообщения);
	Иначе
		Если ЗначениеЗаполнено(Картинка) Тогда
			Состояние(ТекстСообщения,,,Картинка);
		Иначе
			Состояние(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапомнитьКонтекстДлительнойОперации(
		ВходящийКонтекст, 
		ИмяПараметраПриложения = "БРО.ПараметрыОбновленияОтправкиИзПанелиОтправки") Экспорт

	ПараметрыПриложения.Вставить(ИмяПараметраПриложения, ВходящийКонтекст);

КонецПроцедуры

Функция КонтекстДлительнойОперации(ИмяПараметраПриложения = "БРО.ПараметрыОбновленияОтправкиИзПанелиОтправки") Экспорт
	
	ДополнительныеПараметры = ПараметрыПриложения[ИмяПараметраПриложения];
	ПараметрыПриложения.Удалить(ИмяПараметраПриложения);
	
	Возврат ДополнительныеПараметры;

КонецФункции 

Функция ОшибкиКлиент() Экспорт
	
	ПараметрыОтправки = ДлительнаяОтправкаКлиентСервер.ЗначенияПараметровДлительнойОтправки();
	Возврат ПараметрыОтправки["Ошибки"];
	
КонецФункции

Функция ОшибкиКлиентСервер() Экспорт
	
	// Сервер
	ОшибкиСервер = ДлительнаяОтправкаВызовСервера.ОшибкиСервер();
	ОшибкиСервер = Новый Массив(ОшибкиСервер);
	
	// Клиент
	ОшибкиКлиент = ДлительнаяОтправкаКлиент.ОшибкиКлиент();
	ОшибкиКлиент = Новый Массив(ОшибкиКлиент);
	
	// Объединяем ошибки с клиента и сервера.
	ВсеОшибки = ОшибкиКлиент;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеОшибки, ОшибкиСервер);
	
	ВсеОшибки = Новый ФиксированныйМассив(ВсеОшибки);
	
	Возврат ВсеОшибки;
	
КонецФункции

Процедура ИзменитьПараметрыДлительнойОтправкиКлиентСервер(КлючПараметра, НовоеЗначение) Экспорт
	
	// Клиент
	ДлительнаяОтправкаКлиентСервер.ИзменитьПараметрыДлительнойОтправки(КлючПараметра, НовоеЗначение);
	// Сервер
	ДлительнаяОтправкаВызовСервера.ИзменитьПараметрыДлительнойОтправкиСервер(КлючПараметра, НовоеЗначение);
	
КонецПроцедуры

Процедура ОчиститьПараметрыДлительнойОтправкиКлиентСервер() Экспорт

	// Клиент
	ДлительнаяОтправкаКлиентСервер.ОчиститьПараметрыДлительнойОтправки();
	// Сервер
	ДлительнаяОтправкаВызовСервера.ОчиститьПараметрыДлительнойОтправкиСервер();

КонецПроцедуры

#КонецОбласти

#Область ВыводСообщенийПриДлительнойОперации

Процедура ЗапретитьВыводСостояния() Экспорт
	
	ИмяПараметра = ИмяПараметраЗапретаВыводаСообщений();
	ЗапрещенВыводСообщений = Истина;
	ПараметрыПриложения.Вставить(ИмяПараметра, ЗапрещенВыводСообщений);
	
КонецПроцедуры

Процедура СброситьЗапретВыводаСостояния() Экспорт
	
	ИмяПараметра = ИмяПараметраЗапретаВыводаСообщений();
	ЗапрещенВыводСообщений = Ложь;
	ПараметрыПриложения.Вставить(ИмяПараметра, ЗапрещенВыводСообщений);
	
КонецПроцедуры

Функция ВыводСостоянияЗапрещен() Экспорт

	ИмяПараметра = ИмяПараметраЗапретаВыводаСообщений();
	ДлительнаяОтправкаЗапрещена = ПараметрыПриложения[ИмяПараметра];
		
	Если ДлительнаяОтправкаЗапрещена = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат ДлительнаяОтправкаЗапрещена;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПрочиеПроцедурыИФункции

Функция ЭтоПопыткаОткрытияВторогоОкнаДлительнойОперации(
		ЭтоОтправка 	= Ложь,
		ЭтоРасшифровка 	= Ложь)
		
	Если НЕ ФормаДлительнойОтправкиЕстьСредиОткрытых(Истина) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	// Описание того, что хотят запустить.
	Если ЭтоОтправка Тогда
		ТекстПредупреждения = НСтр("ru = 'Отправка не может быть начата.'");
	ИначеЕсли ЭтоРасшифровка Тогда
		ТекстПредупреждения = НСтр("ru = 'Расшифровка не может быть начата.'");
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Действие не может быть начато.'");
	КонецЕсли;
	
	ТекстПредупреждения = ТекстПредупреждения + НСтр("ru = '
                   |Дождитесь завершения предыдущей операции.'");
				   
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
	Возврат Истина;

КонецФункции

Функция ФормаДлительнойОтправкиЕстьСредиОткрытых(ИгнорироватьФормуГрупповойОтправки) Экспорт
	
	Возврат ФормаЕстьСредиОткрытых("ДлительноеДействие") 
		ИЛИ ФормаЕстьСредиОткрытых("ГрупповаяОтправка") И НЕ ИгнорироватьФормуГрупповойОтправки;
	
КонецФункции

Функция ФормаЕстьСредиОткрытых(ЧастьИмениФормы) Экспорт
	
	Окна = ПолучитьОкна();
	
	Если Окна = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Для Каждого ОткрытоеОкно Из Окна Цикл
		Если ТипЗнч(ОткрытоеОкно) = Тип("ОкноКлиентскогоПриложения") 
			И ОткрытоеОкно.Содержимое.Количество() = 1
			И Найти(ОткрытоеОкно.Содержимое[0].ИмяФормы, ЧастьИмениФормы) <> 0 Тогда
			
			Возврат ОткрытоеОкно.Содержимое[0].Открыта();
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ИмяПараметраЗапретаВыводаСообщений()

	Возврат "БРО.ЗапрещенВыводСообщенийПриДлительнойОтправке";

КонецФункции

Процедура ПоказатьФормуДлительногоПроцесса(Результат, ВходящийКонтекст) Экспорт
	
	КонтекстЭДОКлиент 	= Результат.КонтекстЭДО;
	ТекстОшибки 		= Результат.ТекстОшибки;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ПутьКОбъекту = КонтекстЭДОКлиент.ПутьКОбъекту;
	ВходящийКонтекст.Вставить("ПутьКОбъекту", ПутьКОбъекту);
	
	АктивнаяФорма = ТекущаяАктивнаяФорма();
	Если АктивнаяФорма = Неопределено Тогда
		ВходящийКонтекст.Вставить("ИдентификаторПолучателя", Новый УникальныйИдентификатор);
	Иначе
		ВходящийКонтекст.Вставить("ИдентификаторПолучателя", АктивнаяФорма.УникальныйИдентификатор);
	КонецЕсли;
	
	ДопПараметрыОповещения = Новый Структура;
	ДопПараметрыОповещения.Вставить("КонтекстЭДОКлиент", КонтекстЭДОКлиент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьФормуПослеДлительнойОперации", 
		ЭтотОбъект,
		ДопПараметрыОповещения);
		
	ЭтоГрупповаяОтправка = ДлительнаяОтправкаКлиент.ФормаГрупповойОтправкиЕстьСредиОткрытых(Истина);
	Если ЭтоГрупповаяОтправка Тогда 
		АктивнаяФорма.ПриНачалеДлительнойОперации();
		Возврат;
	Иначе
	// Передавать владельца важно для формы автозапроса ФСС, ФСРАР, РПН, ФТС.
	// Если не передавать владельца, то панель отправки отчета перерисовываться не будет.
	ОткрытьФорму(ПутьКОбъекту + ".Форма.ДлительноеДействие", ВходящийКонтекст, АктивнаяФорма,,,,ОписаниеОповещения);
	КонецЕсли;
	
	СообщитьОНачалеОбновленияМодуля(ВходящийКонтекст);
	
КонецПроцедуры

Процедура ПоказатьФормуПослеДлительнойОперации(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		Если Результат.ЭтоОтправка Тогда
			ПоказатьФормуПослеДлительнойОтправки(Результат, ВходящийКонтекст);
		ИначеЕсли Результат.ЭтоОтправкаЗаявления Тогда
			ПоказатьФормуПослеДлительнойОтправкиЗаявления(Результат, ВходящийКонтекст)
		Иначе
			ПоказатьФормуПослеДлительногоОбмена(Результат, ВходящийКонтекст);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьФормуПослеДлительнойОтправкиЗаявления(Результат, ВходящийКонтекст)
	
	КонтекстЭДОКлиент = ВходящийКонтекст.КонтекстЭДОКлиент;
	
	Если Результат.ЕстьОшибки Тогда
		
		ПоказатьОшибки(КонтекстЭДОКлиент.ПутьКОбъекту, Результат);
		
	ИначеЕсли Результат.ВыполняемоеОповещение <> Неопределено Тогда
		
		ВыполняемоеОповещение 	= Результат.ВыполняемоеОповещение;
		РезультатОтправки 		= Результат.РезультатОтправки;
		
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, РезультатОтправки);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьФормуПослеДлительнойОтправки(Результат, ВходящийКонтекст)
	
	КонтекстЭДОКлиент = ВходящийКонтекст.КонтекстЭДОКлиент;
	
	Если Результат.ЗакрытьБезДальнейшихДействий И НЕ Результат.ЭтоАвтозапрос Тогда
		
		Если Результат.ВыполняемоеОповещение <> Неопределено Тогда
			// Продолжаем выполнять действие, которое должно быть выполнено
			// после закрытия бублика.
			ВыполняемоеОповещение = Результат.ВыполняемоеОповещение;
			
			Если Результат.Свойство("РезультатОтправки")  Тогда
				РезультатОтправки = Результат.РезультатОтправки;
				ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, РезультатОтправки);
			Иначе
				ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Результат.ЕстьОшибки Тогда
		
		ПоказатьОшибки(КонтекстЭДОКлиент.ПутьКОбъекту, Результат);
		
	ИначеЕсли Результат.ЭтоАвтозапрос Тогда
		
		Если НЕ Результат.ЗакрытьБезДальнейшихДействий Тогда
			ПоказатьПротоколАвтозапросаОтчета(КонтекстЭДОКлиент, Результат);
		КонецЕсли;
		
	ИначеЕсли Результат.ВыполняемоеОповещение <> Неопределено Тогда
		
		// Продолжаем выполнять действие, которое должно быть выполнено
		// после закрытия бублика.
		ВыполняемоеОповещение = Результат.ВыполняемоеОповещение;
		
		Если Результат.Свойство("РезультатОтправки")  Тогда
			РезультатОтправки = Результат.РезультатОтправки;
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, РезультатОтправки);
		Иначе
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьФормуПослеДлительногоОбмена(Результат, ВходящийКонтекст)
	
	КонтекстЭДОКлиент = ВходящийКонтекст.КонтекстЭДОКлиент;
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		Если Результат.ЗакрытьБезДальнейшихДействий Тогда
			
			// Ничего не делаем если форму бублика:
			// - закрыли по крестику.
			// - закрыли по кнопке Закрыть при наличии другой кнопки.
			Оповестить1СОтчетностьОНовыхИОшибках(Результат);
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПослеЗавершенияДлительногоДействия();
			
		ИначеЕсли Результат.ЕстьОшибки И НЕ Результат.ЕстьНовые Тогда
			
			ПоказатьОшибки(КонтекстЭДОКлиент.ПутьКОбъекту, Результат);
			
		ИначеЕсли Результат.ЭтоОбменИзОтчета
			ИЛИ Результат.ЭтоОбменИзЭтаповОтправки Тогда

			Если ЗначениеЗаполнено(Результат.ПротоколНесданогоОтчета) Тогда
				
				КонтекстЭДОКлиент.ОткрытьПротокол(
					Результат.ОтчетСсылка, 
					Результат.НаименованиеКонтролирующегоОргана, 
					Результат.ПротоколНесданогоОтчета);
					
			КонецЕсли;
			
			// Показываем форму с описанием того, что есть новые и ошибки.
			Если Результат.ЕстьНовые
				И ЗначениеЗаполнено(Результат.ТекстРезультатаОбменаПоОрганизации) Тогда
				
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ПоказатьФормуНовыхПослеПоказаРезультатаОбмена", 
					ЭтотОбъект, 
					Результат); 
					
				КонтекстДлительнойОперации = Новый Структура();
				КонтекстДлительнойОперации.Вставить("ПутьКОбъекту", 		КонтекстЭДОКлиент.ПутьКОбъекту);
				КонтекстДлительнойОперации.Вставить("Результат", 			Результат);
				КонтекстДлительнойОперации.Вставить("ОписаниеОповещения", 	ОписаниеОповещения);
				
				ЗапомнитьКонтекстДлительнойОперации(
					КонтекстДлительнойОперации, 
					"БРО.ОтложенноОтображениеРезультатовОбмена");
				
				// Глобальный обработчик из модуля ДлительнаяОтправкаКлиентГлобальный.
				ПодключитьОбработчикОжидания("Подключаемый_ОтложенноПоказатьРезультатОбновления", 5, Истина);
				
			КонецЕсли;
			
		ИначеЕсли Результат.ЕстьНовые ИЛИ Результат.ЕстьОшибки Тогда
			
			ПоказатьНовые(Результат);
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

Процедура Оповестить1СОтчетностьОНовыхИОшибках(Результат)

	Если Результат.ЕстьНовые Тогда
		
		ПараметрыОповещения = Неопределено;
		Если Результат.ЕстьОшибки Тогда
			ПараметрыОповещения = ПоместитьВоВременноеХранилище(Результат, Новый УникальныйИдентификатор);
		КонецЕсли;
			
		Оповестить("Получены новые сообщения 1С-Отчетности без смены страницы", ПараметрыОповещения);
			
	КонецЕсли;

КонецПроцедуры
	
Функция ТекущаяАктивнаяФорма(Имя = Неопределено)

	ФормаГрупповойОткрыта = ДлительнаяОтправкаКлиент.ФормаГрупповойОтправкиЕстьСредиОткрытых(Истина);
	Если ФормаГрупповойОткрыта Тогда
		АктивнаяФорма = ДлительнаяОтправкаКлиент.ФормаГрупповойОтправкиИзОткрытых(Истина);
		Возврат АктивнаяФорма;
	Иначе
	АктивноеОкно = АктивноеОкно();
	// Запоминаем окно, в которое будут выводиться сообщения об ошибках
	// чтобы исключить вывод сообщений в окно бублика.
	// Иначе при закрытии бублика все сообщения об ошибках потеряются.
	
	Если АктивноеОкно = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		
		ТекущееОкно  = АктивноеОкно().Содержимое;
		АктивнаяФорма = Неопределено;
		Для каждого ТекущаяФорма Из ТекущееОкно Цикл
			АктивнаяФорма = ТекущаяФорма;
			Прервать;
		КонецЦикла;
		
		Возврат АктивнаяФорма;
		
	КонецЕсли;
	КонецЕсли;

КонецФункции

Процедура ПоказатьОшибки(ПутьКОбъекту, ВходящийКонтекст) Экспорт
	
	// Разбиваем параметры на параметры формы и параметры оповещения.
	ПараметрыФормы 			= Новый Структура;
	ДополнительныеПараметры = Новый Структура;
	
	Для каждого СвойствоКонтекста Из ВходящийКонтекст Цикл
		
		Если СвойствоКонтекста.Ключ = "ВыполняемоеОповещение" 
			ИЛИ СвойствоКонтекста.Ключ = "РезультатОтправки" Тогда
			ДополнительныеПараметры.Вставить(СвойствоКонтекста.Ключ, СвойствоКонтекста.Значение);
		Иначе
			ПараметрыФормы.Вставить(СвойствоКонтекста.Ключ, СвойствоКонтекста.Значение);
		КонецЕсли;
		
	КонецЦикла; 
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьОшибки_Завершение", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	Если ЕстьОшибкаРазмераПисьмаФНС(ПараметрыФормы) Тогда
		
		Ошибка = ОшибкаРазмераПисьмаФНС(ПараметрыФормы.Ошибки);
		
		ПоказатьОшибкуПроверкиПисьмаФНС(
			ПараметрыФормы.ОтчетСсылка, 
			ПутьКОбъекту, 
			Ошибка, 
			ОписаниеОповещения);
		
	Иначе
		ОткрытьФорму(ПутьКОбъекту + ".Форма.ОшибкиОтправки", ПараметрыФормы,,,,, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьОшибки_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПослеЗавершенияДлительногоДействия();
	ВыполнитьСледующееДействие(Результат, ВходящийКонтекст);
	
КонецПроцедуры

Процедура ВыполнитьСледующееДействие(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(ВходящийКонтекст) = Тип("Структура")
		И ВходящийКонтекст.Свойство("ВыполняемоеОповещение") Тогда
		
		ВыполняемоеОповещение = ВходящийКонтекст.ВыполняемоеОповещение; 
		
		Если ВходящийКонтекст.Свойство("РезультатОтправки") Тогда
			РезультатОтправки = ВходящийКонтекст.РезультатОтправки;
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, РезультатОтправки);
		Иначе
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПоказатьНовые(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.ЕстьОшибки Тогда
		
		АдресСведенийПоОшибкам = ПоместитьВоВременноеХранилище(ДополнительныеПараметры, Новый УникальныйИдентификатор);
		ДополнительныеПараметры.Вставить("АдресСведенийПоОшибкам", АдресСведенийПоОшибкам);
		
	КонецЕсли;
	
	ОткрытьФорму(ДополнительныеПараметры.ПутьКОбъекту + ".Форма.ФормаНовыхСобытий",
		ДополнительныеПараметры,
		,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

Процедура ПоказатьРезультатОбмена() Экспорт
	
	КонтекстДлительнойОперации = КонтекстДлительнойОперации("БРО.ОтложенноОтображениеРезультатовОбмена");
	
	Если КонтекстДлительнойОперации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКОбъекту 		= КонтекстДлительнойОперации.ПутьКОбъекту; 
	Результат 			= КонтекстДлительнойОперации.Результат;
	ОписаниеОповещения 	= КонтекстДлительнойОперации.ОписаниеОповещения;
	
	ОткрытьФорму(ПутьКОбъекту + ".Форма.РезультатОбмена", Результат,,,,,ОписаниеОповещения);

КонецПроцедуры

Процедура ПоказатьФормуНовыхПослеПоказаРезультатаОбмена(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат <> Истина Тогда
		// Пользователь отказался от просмотра результата обмена из формы отчета.
		Возврат;
	КонецЕсли;
		
	ПоказатьНовые(ВходящийКонтекст);
	
КонецПроцедуры

Процедура ПоказатьОшибкуПроверкиПисьмаФНС(Письмо, ПутьКОбъекту, Ошибка, ОписаниеЗавершения = Неопределено) Экспорт
	
	Ошибка.Вставить("Письмо", Письмо);
	
	ДополнительныеПараметры = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(Ошибка);
	ДополнительныеПараметры.Вставить("ОписаниеЗавершения", ОписаниеЗавершения);
	 
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьОшибкуПроверкиПисьмаФНС_ПослеСозданияПакета", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	ОткрытьФорму(
		ПутьКОбъекту + ".Форма.ОшибкаОтправкиПисьмаВФНС", 
		Ошибка,
		,
		,
		,
		,
		ОписаниеОповещения);
		
КонецПроцедуры
	
Процедура ПоказатьОшибкуПроверкиПисьмаФНС_ПослеСозданияПакета(Опись, ВходящийКонтекст) Экспорт
	
	Если НЕ ВходящийКонтекст.БлокироватьОтправку И НЕ ЗначениеЗаполнено(Опись) Тогда
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОписаниеЗавершения);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Опись) Тогда
		ПоказатьЗначение(, Опись);
	КонецЕсли;
		
КонецПроцедуры

Функция ПриказНаРазмераПисьмаФНС5Мб()
	Возврат "ЕД-7-26/1011@";
КонецФункции

Функция ЕстьОшибкаРазмераПисьмаФНС(ПараметрыФормы)
	
	Ошибки      = ПараметрыФормы.Ошибки;
	ОтчетСсылка = ПараметрыФормы.ОтчетСсылка;
	Орган       = ПараметрыФормы.ВидКонтролирующегоОргана;
	
	Проверять = 
		ТипЗнч(ОтчетСсылка) = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами")
		И Орган = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС");
		
	Если НЕ Проверять Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Приказ = ПриказНаРазмераПисьмаФНС5Мб();
	
	Для каждого Ошибка Из Ошибки Цикл
		Если СтрНайти(Ошибка.ОписаниеОшибки, Приказ) > 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Ложь;
	
КонецФункции

Функция ОшибкаРазмераПисьмаФНС(Ошибки)
	
	Приказ = ПриказНаРазмераПисьмаФНС5Мб();
	
	Для каждого Ошибка Из Ошибки Цикл
		Если СтрНайти(Ошибка.ОписаниеОшибки, Приказ) > 0 Тогда
			Возврат Ошибка.ОписаниеОшибки;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#Область Автозапрос

Процедура ПоказатьПротоколАвтозапросаОтчета(КонтекстЭДОКлиент, Результат)
	
	Если Результат.ПротоколЗаполнен И ЗначениеЗаполнено(Результат.ОтправкаСсылка) Тогда
		
		КонтекстЭДОКлиент.ПоказатьПротоколОбработкиПоСсылкеИсточника(
			Результат.ВидКонтролирующегоОргана, 
			Результат.ОтправкаСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти