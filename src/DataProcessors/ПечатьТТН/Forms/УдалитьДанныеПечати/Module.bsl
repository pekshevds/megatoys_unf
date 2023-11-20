#Область ОписаниеПеременных

&НаКлиенте
Перем НачальныеЗначенияРеквизитов;

#КонецОбласти

#Область Служебные

&НаКлиенте
Процедура БылиВнесеныИзменения(СтруктураПараметров)
	
	ЕстьИзменения = Ложь;
	
	Для каждого ЗначенияРеквизита Из НачальныеЗначенияРеквизитов Цикл
		
		// Если значение на форме изменили, необходимо его добавить в структуру, которую передадим в документ источник
		ЗначениеРеквизитаФормы = ЭтаФорма[ЗначенияРеквизита.Ключ];
		Если ЗначенияРеквизита.Значение <> ЗначениеРеквизитаФормы Тогда
			
			СтруктураПараметров.Вставить(ЗначенияРеквизита.Ключ, ЗначениеРеквизитаФормы);
			ЕстьИзменения = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураПараметров.Вставить("ЕстьИзменения", ЕстьИзменения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораАдресаДоставки(ЭлементАдреса, Владелец, ВидКИ, ОчищатьСписок = Истина)
	
	МассивВладельцев = Новый Массив;
	МассивВладельцев.Добавить(Владелец);
	
	Адреса = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивВладельцев, , ВидКИ);
	
	Для Каждого Адрес Из Адреса Цикл
		
		ЭлементАдреса.СписокВыбора.Добавить(Адрес.Представление);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресДоставки(ОчиститьПоле = Ложь)
	
	Если ОчиститьПоле Тогда
		
		АдресДоставки = "";
		
	КонецЕсли;
	
	Элементы.АдресДоставки.СписокВыбора.Очистить();
	
	ИсточникАдресовДоставки = ?(ЗначениеЗаполнено(Грузополучатель), Грузополучатель, Контрагент);
	ЗаполнитьСписокВыбораАдресаДоставки(Элементы.АдресДоставки, ИсточникАдресовДоставки, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОснованияПечати(Параметры)
	
	СписокВыбораЭлемента = Элементы.ОснованиеПечатиСсылка.СписокВыбора;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		
		СписокВыбораЭлемента.Добавить(ДоговорКонтрагента, Обработки.ПечатьТТН.ПредставлениеОснованияПечати(ДоговорКонтрагента));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование)
		И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.СчетНаОплату") Тогда
		
		СписокВыбораЭлемента.Добавить(ДокументОснование, Обработки.ПечатьТТН.ПредставлениеОснованияПечати(ДокументОснование));
		
	КонецЕсли;
	
	Если Параметры.МассивЗаказов.Количество() > 0 Тогда
		
		Для каждого СтрокаМассива Из Параметры.МассивЗаказов Цикл
			
			СписокВыбораЭлемента.Добавить(СтрокаМассива, Обработки.ПечатьТТН.ПредставлениеОснованияПечати(СтрокаМассива));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.Свойство("УсловияСчетаЗаказа") Тогда
		УсловияСчетаЗаказа = Параметры.УсловияСчетаЗаказа;
	КонецЕсли;
	Если Параметры.Свойство("УсловияГарантийногоТалона") Тогда
		УсловияГарантийногоТалона = Параметры.УсловияГарантийногоТалона;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, , "ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца, КлючНазначенияИспользования, ТолькоПросмотр");
	
	Если Источник = "РасходнаяНакладная" 
		ИЛИ Источник = "ОтчетОПереработке" Тогда
		
		ЗаполнитьОснованияПечати(Параметры);
		ЗаполнитьАдресДоставки();
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПлановаяОценка", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Получил", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПолучилДолжность", "Видимость", Ложь);
		
	ИначеЕсли Источник = "ПеремещениеЗапасов" Тогда
		
		ЗаполнитьСписокВыбораАдресаДоставки(Элементы.АдресДоставки, Параметры.СтруктурнаяЕдиницаПолучатель, Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОснованиеПечати", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаРеквизитыПечати", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПлановаяОценка", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Грузоотправитель", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Грузополучатель", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Получил", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПолучилДолжность", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УсловияГарантийногоТалона", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УсловияСчетаЗаказа", "Видимость", Ложь);
		
	ИначеЕсли Источник = "СборкаЗапасов" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОснованиеПечати", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаРеквизитыПечати", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаПеревозчик", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаДоверенность", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Руководитель", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РуководительДолжность", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГлавныйБухгалтер", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОтступ", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УсловияСчетаЗаказа", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НачальныеЗначенияРеквизитов = Новый Структура;
	
	// Сведения о текущем документе
	НачальныеЗначенияРеквизитов.Вставить("ДоговорКонтрагента",			ДоговорКонтрагента);
	НачальныеЗначенияРеквизитов.Вставить("ОснованиеПечати",				ОснованиеПечати);
	НачальныеЗначенияРеквизитов.Вставить("ОснованиеПечатиСсылка",		ОснованиеПечатиСсылка);
	НачальныеЗначенияРеквизитов.Вставить("ПлановаяОценка",				ПлановаяОценка);
	НачальныеЗначенияРеквизитов.Вставить("УсловияСчетаЗаказа",			УсловияСчетаЗаказа);
	НачальныеЗначенияРеквизитов.Вставить("УсловияГарантийногоТалона",	УсловияГарантийногоТалона);
	
	// Банковские счета
	НачальныеЗначенияРеквизитов.Вставить("БанковскийСчетОрганизации",	БанковскийСчетОрганизации);
	НачальныеЗначенияРеквизитов.Вставить("БанковскийСчетКонтрагента",	БанковскийСчетКонтрагента);
	
	// Логистика
	НачальныеЗначенияРеквизитов.Вставить("Грузоотправитель",			Грузоотправитель);
	НачальныеЗначенияРеквизитов.Вставить("Грузополучатель",				Грузополучатель);
	НачальныеЗначенияРеквизитов.Вставить("АдресДоставки",				АдресДоставки);
	
	// Перевозчик
	НачальныеЗначенияРеквизитов.Вставить("Перевозчик",					Перевозчик);
	НачальныеЗначенияРеквизитов.Вставить("БанковскийСчетПеревозчика",	БанковскийСчетПеревозчика);
	НачальныеЗначенияРеквизитов.Вставить("СрокДоставки",				СрокДоставки);
	НачальныеЗначенияРеквизитов.Вставить("Водитель",					Водитель);
	НачальныеЗначенияРеквизитов.Вставить("Автомобиль",					Автомобиль);
	НачальныеЗначенияРеквизитов.Вставить("Прицеп",						Прицеп);
	
	// Ответственные лица
	НачальныеЗначенияРеквизитов.Вставить("Руководитель",				Руководитель);
	НачальныеЗначенияРеквизитов.Вставить("РуководительДолжность",		РуководительДолжность);
	НачальныеЗначенияРеквизитов.Вставить("ГлавныйБухгалтер",			ГлавныйБухгалтер);
	НачальныеЗначенияРеквизитов.Вставить("Отпустил",					Отпустил);
	НачальныеЗначенияРеквизитов.Вставить("ОтпустилДолжность",			ОтпустилДолжность);
	НачальныеЗначенияРеквизитов.Вставить("Получил",						Получил);
	НачальныеЗначенияРеквизитов.Вставить("ПолучилДолжность",			ПолучилДолжность);
	
	// Доверенность
	НачальныеЗначенияРеквизитов.Вставить("ДоверенностьНомер",			ДоверенностьНомер);
	НачальныеЗначенияРеквизитов.Вставить("ДоверенностьДата",			ДоверенностьДата);
	НачальныеЗначенияРеквизитов.Вставить("ДоверенностьВыдана",			ДоверенностьВыдана);
	НачальныеЗначенияРеквизитов.Вставить("ДоверенностьЛицо",			ДоверенностьЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзмененияФормы()
	
	СтруктураПараметров = Новый Структура;
	БылиВнесеныИзменения(СтруктураПараметров);
	
	Если СтруктураПараметров.ЕстьИзменения Тогда
		
		СтруктураПараметров.Удалить("ЕстьИзменения");
		ОповеститьОВыборе(СтруктураПараметров);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьИзмененияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПредставлениеОснованияПечати(Команда)
	
	Если Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеВвода Тогда
		
		Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеНадписи;
		
	Иначе
		
		Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.ОснованиеПечати.ПодсказкаВвода = НСтр("ru ='Представление основания печати'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РеквизитыФормы

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	Если Грузополучатель <> Контрагент Тогда
		
		ЗаполнитьАдресДоставки(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПечатиСсылкаПриИзменении(Элемент)
	
	ОснованиеПечати = Элементы.ОснованиеПечатиСсылка.ТекстРедактирования;
	
КонецПроцедуры

#КонецОбласти