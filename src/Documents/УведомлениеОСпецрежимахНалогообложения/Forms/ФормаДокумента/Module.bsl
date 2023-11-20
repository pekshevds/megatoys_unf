#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	КопированиеНеПоддерживается = Ложь;
	Параметры.Свойство("ВыбраннаяФорма", ВыбраннаяФорма);
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	Параметры.Свойство("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
	Параметры.Свойство("ИмяОтчета", ИмяОтчета);
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ЗаполнитьПриОткрытии", ЗаполнитьПриОткрытии);
	Если ТипЗнч(ЗначениеКопирования) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения") И ЗначениеЗаполнено(ЗначениеКопирования) Тогда 
		РеквизитыКлюча = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗначениеКопирования, "ИмяФормы,ИмяОтчета");
		ВыбраннаяФорма = "Отчет." + РеквизитыКлюча.ИмяОтчета + ".Форма." + РеквизитыКлюча.ИмяФормы;
		
		Попытка
			ТаблицаФорм = Отчеты[РеквизитыКлюча.ИмяОтчета].ПолучитьТаблицуФорм();
			Если ТаблицаФорм.Количество() > 0
				И ТаблицаФорм.НайтиСтроки(Новый Структура("ИмяФормы", РеквизитыКлюча.ИмяФормы)).Количество() = 0 Тогда 
				
				СтандартнаяОбработка = Ложь;
				ВыбраннаяФорма = "";
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Копирование данной редакции формы не поддерживается'"));
				КопированиеНеПоддерживается = Истина;
				Возврат;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	АдресДанные = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ВидУведомления = Объект.ВидУведомления;
		Организация = Объект.Организация;
	Иначе
		Если Параметры.Свойство("Организация") Тогда
			Организация = Параметры.Организация;
		КонецЕсли;
		Если Параметры.Свойство("ВидУведомления") Тогда
			ВидУведомления = Параметры.ВидУведомления;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяФормыДляОбъекта(ВидУведомления, ИмяОтчета, ИмяФормы)
	УведомлениеОСпецрежимахНалогообложения.ЗаменитьИмяОтчетаПередОткрытием(ВидУведомления, ИмяФормы, ИмяОтчета);
	Если ЗначениеЗаполнено(ИмяОтчета) И ЗначениеЗаполнено(ИмяФормы) 
		И Метаданные.Отчеты.Найти(ИмяОтчета) <> Неопределено Тогда 
		
		Имя = "Отчет."+ИмяОтчета+".Форма."+ИмяФормы;
	Иначе 
		Имя = ПолучитьИмяФормы(ВидУведомления);
	КонецЕсли;
	Возврат Имя;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяФормы(Вид)
	
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПолноеИмяФормыПоВиду(Вид);
	
КонецФункции

&НаКлиенте
Процедура ПолучитьОрганизациюИОткрыть(Вид, ИмяФормыСообщения)
	Данные = ПолучитьИзВременногоХранилища(АдресДанные);
	Если ЗначениеЗаполнено(ИмяФормыСообщения) Тогда
		ПараметрыОткрытия = Новый Структура("ЗаполнитьПриОткрытии", ЗаполнитьПриОткрытии);
		Если ЗначениеЗаполнено(Организация) Тогда
			ПараметрыОткрытия.Вставить("Организация", Организация);
			ПараметрыОткрытия.Вставить("ЗначениеКопирования", ЗначениеКопирования);
			ПараметрыОткрытия.Вставить("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
			ПараметрыОткрытия.Вставить("Данные", Данные);
			ПараметрыОткрытия.Вставить("ВидУведомления", ВидУведомления);
			Форма = ПолучитьФорму(ИмяФормыСообщения, ПараметрыОткрытия, ЭтотОбъект.ВладелецФормы);
			Если Форма <> Неопределено Тогда 
				Форма.Открыть();
			КонецЕсли;
		Иначе
			ПараметрыОткрытия.Вставить("Тип", Вид);
			ПараметрыОткрытия.Вставить("ЗначениеКопирования", ЗначениеКопирования);
			ПараметрыОткрытия.Вставить("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
			ПараметрыОткрытия.Вставить("Данные", Данные);
			ПараметрыОткрытия.Вставить("ВидУведомления", ВидУведомления);
			
			ФормаОрганизации = ПолучитьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.ФормаВыбораУведомления", ПараметрыОткрытия, ЭтотОбъект.ВладелецФормы, Данные);
			ФормаОрганизации.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			ФормаОрганизации.Открыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Ключ", Объект.Ссылка);
		ПараметрыОткрытияФормы.Вставить("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
		ПараметрыОткрытияФормы.Вставить("ВидУведомления", ВидУведомления);
		ПараметрыОткрытияФормы.Вставить("ЗаполнитьПриОткрытии", ЗаполнитьПриОткрытии);
		ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Ложь);
		
		Имя = ПолучитьИмяФормыДляОбъекта(ВидУведомления, Объект.ИмяОтчета, Объект.ИмяФормы);
		Если Имя = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		ОткрытьФорму(Имя, ПараметрыОткрытияФормы, , Объект.Ссылка);
	ИначеЕсли ЗначениеЗаполнено(ВыбраннаяФорма) И ЗначениеЗаполнено(Организация) Тогда 
		Данные = ПолучитьИзВременногоХранилища(АдресДанные);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Организация", Организация);
		ПараметрыОткрытия.Вставить("ЗначениеКопирования", ЗначениеКопирования);
		ПараметрыОткрытия.Вставить("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
		ПараметрыОткрытия.Вставить("ИмяОтчета", ИмяОтчета);
		ПараметрыОткрытия.Вставить("Данные", Данные);
		ПараметрыОткрытия.Вставить("ВидУведомления", ВидУведомления);
		ПараметрыОткрытия.Вставить("ЗаполнитьПриОткрытии", ЗаполнитьПриОткрытии);
		
		НоваяФорма = ПолучитьФорму(ВыбраннаяФорма, ПараметрыОткрытия, ВладелецФормы);
		Если НоваяФорма = Неопределено Тогда
			Возврат;
		Иначе
			НоваяФорма.Открыть();
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ВидУведомления) Тогда
		ИмяФормыСообщения = ПолучитьИмяФормы(ВидУведомления);
		ПолучитьОрганизациюИОткрыть(ВидУведомления, ИмяФормыСообщения);
	ИначеЕсли КопированиеНеПоддерживается Тогда 
		Отказ = Истина;
	Иначе
		Данные = ПолучитьИзВременногоХранилища(АдресДанные);
		ФормаВыбор = ПолучитьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.ФормаВыбораВидаСообщения", Новый Структура("Организация, Данные", Организация, Данные));
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
		ФормаВыбор.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
		ФормаВыбор.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ФормаВыбор.Открыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура")
		И РезультатВыбора.Свойство("РезультатВыбора")
		И ЗначениеЗаполнено(РезультатВыбора.РезультатВыбора) Тогда
		
		ИмяФормыСообщения = ПолучитьИмяФормы(РезультатВыбора.РезультатВыбора);
		ПолучитьОрганизациюИОткрыть(РезультатВыбора.РезультатВыбора, ИмяФормыСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти