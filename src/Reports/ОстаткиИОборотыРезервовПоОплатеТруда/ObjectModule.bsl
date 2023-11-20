#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Отказ = Ложь;
	ПередКомпоновкойМакета(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиОтчета);
	
	// Создадим и инициализируем процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Обозначим начало вывода
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновки);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

Процедура ПередКомпоновкойМакета(Отказ)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	Если Не КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючВарианта") Тогда
		Отказ = Истина;
	Иначе
		КлючВариантаОтчета = КомпоновщикНастроек.Настройки.ДополнительныеСвойства.КлючВарианта;
		Если НЕ ЗначениеЗаполнено(КлючВариантаОтчета) Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОстаткиОбороты = Ложь;
	ПоСотрудникам  = Ложь;
	Если КлючВариантаОтчета = "ОстаткиОборотыРезервовПоОплатеТруда" Тогда
		ОстаткиОбороты = Истина;
	ИначеЕсли КлючВариантаОтчета = "РезервыПоОплатеТрудаПоСотрудникам" Тогда
		ПоСотрудникам = Истина;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	Организация = ЗначениеПараметра.Значение;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Резерв"));
	Резерв = ЗначениеПараметра.Значение;
	
	ПоказательНУ = Ложь;
	ПоказательБУ = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Показатель"));
	Если ЗначениеПараметра.Значение = Истина Тогда
		ПоказательНУ = Истина;
		ПоказательБУ = Ложь;
	КонецЕсли;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	НачалоПериода = ЗначениеПараметра.Значение.ДатаНачала;
	КонецПериода  = ЗначениеПараметра.Значение.ДатаОкончания;
	
	Если РезервыПоОплатеТруда.ФормируютсяРезервыВОрганизации(Организация, КонецПериода) Тогда
		НастройкиРезервов = РезервыПоОплатеТруда.НастройкиРезерва(Организация, Резерв, КонецПериода);
		НормативныйМетод  = НастройкиРезервов.НормативныйМетодБУ;
	Иначе
		НастройкиРезервов = РезервОтпусков.НастройкиРезервовОтпусков(Организация, КонецПериода);
		НормативныйМетод = РезервОтпусков.МетодНачисленияРезерваОтпусков(Организация, КонецПериода) = Перечисления.МетодыНачисленияРезервовПоОплатеТруда.НормативныйМетод;
	КонецЕсли;
	
	МетодОбязательств   = Не НормативныйМетод;
	ФормироватьРезервБУ = НастройкиРезервов.ФормироватьРезервБУ;
	ФормироватьРезервНУ = НастройкиРезервов.ФормироватьРезервНУ;
	
	Если Не ЗначениеЗаполнено(Резерв) Тогда
		ТекстОшибки = НСтр("ru = 'Укажите резерв, по которому формируется отчет'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметра.Значение = НачалоПериода;
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецПериода;
	ЗначениеПараметра.Использование = Истина;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
	
	Таблица = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ТаблицаРезервы");
	
	МассивНазванийГруппировок = Новый Массив;
	Если ОстаткиОбороты Тогда
		МассивНазванийГруппировок.Добавить("ГруппировкаТипОценочногоОбязательства");
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
			МассивНазванийГруппировок.Добавить("ГруппировкаСтатьяФинансирования");
		КонецЕсли;
	ИначеЕсли ПоСотрудникам Тогда
		МассивНазванийГруппировок.Добавить("ГруппировкаСотрудник");
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
			МассивНазванийГруппировок.Добавить("ГруппировкаСтатьяФинансированияСотрудник");
		КонецЕсли;
	КонецЕсли;
	
	МассивГруппировок = Новый Массив;
	
	Если ПоказательНУ Тогда
		Показатель = "НУ";
		Если ОстаткиОбороты Тогда
			СуффиксГруппировки = "ОстаткиОбороты";
		ИначеЕсли ПоСотрудникам Тогда
			СуффиксГруппировки = "";
		КонецЕсли;
		
	Иначе
		Показатель = "БУ";
		Если ОстаткиОбороты Тогда
			СуффиксГруппировки = "ОстаткиОбороты";
		ИначеЕсли ПоСотрудникам Тогда
			СуффиксГруппировки = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ИмяГруппировки Из МассивНазванийГруппировок Цикл
		ИсходнаяГруппировка     = НайтиПоИмени(Таблица.Строки,ИмяГруппировки);
		Если ИсходнаяГруппировка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяГруппировки          = ИмяГруппировки + Показатель + СуффиксГруппировки;
		ИсходнаяГруппировка.Имя = ИмяГруппировки;
		МассивГруппировок.Добавить(ИсходнаяГруппировка);
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить(Показатель);
	
	Для Каждого Группировка Из МассивГруппировок Цикл
		Группировка.Использование = Истина;
	КонецЦикла;
	
	МассивПоказателейРасчета = Новый Массив;
	
	Если ОстаткиОбороты Тогда
		
		МассивПоказателейРасчета.Добавить("НачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("Расход" + Показатель);
		МассивПоказателейРасчета.Добавить("Приход" + Показатель);
		МассивПоказателейРасчета.Добавить("КонечныйОстаток" + Показатель);
		
	ИначеЕсли ПоСотрудникам Тогда
		
		// Остатки на начало
		МассивПоказателейРасчета.Добавить("СуммаРезерваНачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовНачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиНачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваНачальныйОстатокВсего" + Показатель);
		
		// Выбыло
		МассивПоказателейРасчета.Добавить("СуммаРезерваРасход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовРасход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиРасход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваРасходВсего" + Показатель);
		
		// Начислено
		МассивПоказателейРасчета.Добавить("СуммаРезерваПриход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовПриход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиПриход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваПриходВсего" + Показатель);
		
		// Остатки на конец
		МассивПоказателейРасчета.Добавить("СуммаРезерваКонечныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовКонечныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиКонечныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваКонечныйОстатокВсего" + Показатель);
		
	КонецЕсли;
	
	Номер = 0;
	
	Для Каждого Группировка Из МассивГруппировок Цикл
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ОтчетыСервер.ДобавитьВыбранноеПоле(Группа, СтрЗаменить(МассивНазванийГруппировок[Номер], "Группировка", ""));
		
		Для Каждого ИмяПоказателя Из МассивПоказателейРасчета Цикл
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ОтчетыСервер.ДобавитьВыбранноеПоле(Группа, ИмяПоказателя);
		КонецЦикла;
		
		Номер = Номер + 1;
		
	КонецЦикла;
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных)));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.Вставить("РазрешеноМенятьВарианты",    Истина);
	Настройки.Вставить("РазрешеноИзменятьСтруктуру", Ложь);
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> КлючВарианта Тогда
		
		МассивУдаляемыхСхем = Новый Массив;
		Если КлючВарианта = "ОстаткиОборотыРезервовПоОплатеТруда" Тогда
			МассивУдаляемыхСхем.Добавить("НаборДанныхПоСотрудникам");
		ИначеЕсли КлючВарианта = "РезервыПоОплатеТрудаПоСотрудникам" Тогда
			МассивУдаляемыхСхем.Добавить("НаборДанныхОстаткиОбороты");
		КонецЕсли;
		
		Для Каждого ИмяУдаляемойСхемы Из МассивУдаляемыхСхем Цикл
			УдаляемаяСхема = СхемаКомпоновкиДанных.НаборыДанных.Найти(ИмяУдаляемойСхемы);
			Если УдаляемаяСхема <> Неопределено Тогда
				СхемаКомпоновкиДанных.НаборыДанных.Удалить(УдаляемаяСхема);
			КонецЕсли;
		КонецЦикла;
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = КлючВарианта;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли