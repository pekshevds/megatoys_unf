#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	// Второстепенные реквизиты шапки заполняются в функции ОбновитьВторичныеДанные.
	ФиксацияИзменений.Очистить();
	
	// Заполнение ключевых реквизитов шапки.
	Организация = ОбъектКопирования.Организация;
	Сотрудник   = ОбъектКопирования.Сотрудник;
	
	// Очистка результатов.
	ХранилищеXML = Неопределено;
	ДатаОтправки = Неопределено;
	ИдентификаторСообщения   = "";
	ИдентификаторУведомления = "";
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(Основание) = Тип("Структура") Тогда
		Если Основание.Свойство("Действие")
			И Основание.Действие = "Исправить"
			И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.ИсправленияДокументов") Тогда
			МодульИсправлениеДокументовЗарплатаКадры = ОбщегоНазначения.ОбщийМодуль("ИсправлениеДокументовЗарплатаКадры");
			МодульИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(
				ЭтотОбъект,
				Основание.Ссылка,
				,
				,
				Основание);
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Основание);
			Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
				Основание = ОбщегоНазначенияБЗК.ЗначениеСвойства(Основание, "Основание");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.Сотрудники")
		И Не Основание.Пустая() Тогда
		Сотрудник = Основание;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаявлениеСотрудникаНаВыплатуПособия")
		И Не Основание.Пустая() Тогда
		ИменаРеквизитов = "Организация, Сотрудник, ДокументОснование";
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, ИменаРеквизитов);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	ИначеЕсли Метаданные().Реквизиты.ДокументОснование.Тип.СодержитТип(ТипЗнч(Основание))
		И ЗначениеЗаполнено(Основание) Тогда
		ДокументОснование = Основание;
	КонецЕсли;
	
	ЗначенияДляЗаполнения = Новый Структура("Ответственный");
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗначенияДляЗаполнения);
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		КадровыеДанные = КадровыеДанныеСотрудника();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, КадровыеДанные);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ПараметрыФиксации = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ПараметрыФиксацииВторичныхДанных();
		ЗаполнитьДанныеИзОснования(ПараметрыФиксации, Ложь);
	КонецЕсли;
	
	ОбновитьВторичныеДанные();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ПрекращаемыеЗаявления", ПрекращаемыеЗаявления.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрекращаемыеЗаявления.НомерСтроки КАК НомерСтроки,
	|	ПрекращаемыеЗаявления.Заявление КАК Заявление,
	|	ПрекращаемыеЗаявления.ОтветНаЗапрос КАК ОтветНаЗапрос
	|ПОМЕСТИТЬ ВТПрекращаемыеЗаявления
	|ИЗ
	|	&ПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрекращаемыеЗаявления1.Заявление КАК Дубль,
	|	""Заявление"" КАК ИмяПоля,
	|	ПрекращаемыеЗаявления1.НомерСтроки КАК НомерСтроки1,
	|	ПрекращаемыеЗаявления2.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ВТПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления2
	|		ПО ПрекращаемыеЗаявления1.Заявление = ПрекращаемыеЗаявления2.Заявление
	|			И (ПрекращаемыеЗаявления1.Заявление <> ЗНАЧЕНИЕ(Документ.ЗаявлениеСотрудникаНаВыплатуПособия.ПустаяСсылка))
	|			И ПрекращаемыеЗаявления1.НомерСтроки < ПрекращаемыеЗаявления2.НомерСтроки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПрекращаемыеЗаявления1.ОтветНаЗапрос,
	|	""ОтветНаЗапрос"",
	|	ПрекращаемыеЗаявления1.НомерСтроки,
	|	ПрекращаемыеЗаявления2.НомерСтроки
	|ИЗ
	|	ВТПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления2
	|		ПО ПрекращаемыеЗаявления1.ОтветНаЗапрос = ПрекращаемыеЗаявления2.ОтветНаЗапрос
	|			И (ПрекращаемыеЗаявления1.ОтветНаЗапрос <> ЗНАЧЕНИЕ(Документ.ОтветНаЗапросФССДляРасчетаПособия.ПустаяСсылка))
	|			И ПрекращаемыеЗаявления1.НомерСтроки < ПрекращаемыеЗаявления2.НомерСтроки";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Текст = НСтр("ru = 'Документ ""%1"" уже выбран в строке %2.'");
		Текст = СтрШаблон(Текст, СтрокаТаблицы.Дубль, СтрокаТаблицы.НомерСтроки1);
		СообщенияБЗК.СообщитьОбОшибкеВСтрокеТаблицы(
			Отказ,
			ЭтотОбъект,
			"ПрекращаемыеЗаявления",
			СтрокаТаблицы,
			СтрокаТаблицы.ИмяПоля,
			Текст);
	КонецЦикла;
	
	Если Не ОтправлятьЧерезСЭДО Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПрекращаемыеЗаявления.Ребенок");
	КонецЕсли;
	
	Если ОтправлятьЧерезПрямыеВыплаты Тогда
		ОбщегоНазначенияБЗК.ДобавитьЗначениеВМассив(ПроверяемыеРеквизиты, "ПрекращаемыеЗаявления.Заявление");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ПрекращаемыеЗаявления", ПрекращаемыеЗаявления.Выгрузить());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПрекращаемыеЗаявления.НомерСтроки КАК НомерСтроки,
		|	ПрекращаемыеЗаявления.Заявление КАК Заявление
		|ПОМЕСТИТЬ ВТПрекращаемыеЗаявления
		|ИЗ
		|	&ПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПрекращаемыеЗаявления.НомерСтроки КАК НомерСтроки,
		|	ПрочиеПрекращаемыеЗаявления.Ссылка КАК Ссылка,
		|	ПрочиеПрекращаемыеЗаявления.Заявление КАК Заявление
		|ИЗ
		|	ВТПрекращаемыеЗаявления КАК ПрекращаемыеЗаявления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ПрекращаемыеЗаявления КАК ПрочиеПрекращаемыеЗаявления
		|		ПО ПрекращаемыеЗаявления.Заявление = ПрочиеПрекращаемыеЗаявления.Заявление
		|			И (ПрочиеПрекращаемыеЗаявления.Ссылка <> &Ссылка)
		|			И (ПрекращаемыеЗаявления.Заявление <> ЗНАЧЕНИЕ(Документ.ЗаявлениеСотрудникаНаВыплатуПособия.ПустаяСсылка))
		|			И (НЕ ПрочиеПрекращаемыеЗаявления.Ссылка.ПометкаУдаления)
		|			И (ПрочиеПрекращаемыеЗаявления.Ссылка.ОтправлятьЧерезПрямыеВыплаты)";
		Таблица = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаТаблицы Из Таблица Цикл
			Текст = СтрШаблон(НСтр("ru = 'Документ ""%1"" уже использован в документе ""%2"".'"), СтрокаТаблицы.Заявление, СтрокаТаблицы.Ссылка);
			СообщенияБЗК.СообщитьОбОшибкеВСтрокеТаблицы(Отказ, ЭтотОбъект, "ПрекращаемыеЗаявления", СтрокаТаблицы, "Заявление", Текст);
		КонецЦикла;
	КонецЕсли;
	
	Если Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ОбъектЗафиксирован(ЭтотОбъект) Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Запрещено изменять %1, поскольку оно уже отправлено в ФСС.'"), Ссылка);
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, Ссылка, ТекстОшибки);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ДополнительныеСвойства.Вставить("ОбработкаПроверкиЗаполненияВыполнена", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ОбработкаПроверкиЗаполненияВыполнена") Тогда
		Если Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ОбъектЗафиксирован(ЭтотОбъект) Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Запрещено изменять %1, поскольку оно уже отправлено в ФСС.'"), Ссылка);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	КонецЕсли;
	
	ДоЗаписи = ЗначенияРеквизитовДоЗаписи();
	Если ЭтоНовый()
		Или НачалоДня(Дата)     <> НачалоДня(ДоЗаписи.Дата)
		Или Страхователь        <> ДоЗаписи.Страхователь
		Или ОтправлятьЧерезСЭДО <> ДоЗаписи.ОтправлятьЧерезСЭДО
		Или (ОтправлятьЧерезСЭДО И Не ЗначениеЗаполнено(НомерВПределахДня)) Тогда
		ЗаполнитьНомерВПределахДня();
	КонецЕсли;
	
	ЭтоПроведение = (РежимЗаписи = РежимЗаписиДокумента.Проведение
		Или (Проведен И РежимЗаписи = РежимЗаписиДокумента.Запись));
	
	Если ОтправлятьЧерезСЭДО Тогда
		Если ЭтоПроведение Тогда
			ТекстXML = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ТекстXML(ЭтотОбъект);
		Иначе
			ТекстXML = "";
		КонецЕсли;
		ХранилищеXML = Новый ХранилищеЗначения(ТекстXML, Новый СжатиеДанных(9));
	Иначе
		ХранилищеXML = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МеханизмФиксацииИзменений

Функция ОбновитьВторичныеДанные(ПараметрыФиксации = Неопределено) Экспорт
	Если Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ОбъектЗафиксирован(ЭтотОбъект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Модифицирован = Ложь;
	Если ПараметрыФиксации = Неопределено Тогда
		ПараметрыФиксации = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ПараметрыФиксацииВторичныхДанных(ЭтотОбъект);
	КонецЕсли;
	
	Если ЗаполнитьДанныеИзОснования(ПараметрыФиксации, Истина) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьДанныеОрганизации(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьИдентификаторУведомления() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьКадровыеДанныеСотрудника(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьРазрешениеНаПроживание(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьКонтактыФизическогоЛица(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьНаименованиеПриказа(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьДатуПредставленияПакетаДокументов(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция ЗаполнитьДанныеИзОснования(ПараметрыФиксации, УчитыватьФиксацию) Экспорт
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат Ложь;
	КонецЕсли;
	Реквизиты = Новый Структура;
	МенеджерОснования = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументОснование);
	МенеджерОснования.ЗаполнитьУведомлениеОПрекращенииОтпускаПоУходуЗаРебенкомПоОснованию(ДокументОснование, Реквизиты);
	Если УчитыватьФиксацию Тогда
		Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
	Иначе
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
		ФиксацияВторичныхДанныхВДокументах.ОтменитьФиксациюРеквизитовШапки(ЭтотОбъект, Реквизиты);
		Возврат Истина;
	КонецЕсли;
КонецФункции

Функция ЗаполнитьДанныеОрганизации(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИменаРеквизитов = 
	"Страхователь,
	|НаименованиеСтрахователя,
	|РегистрационныйНомерФСС,
	|КодПодчиненностиФСС,
	|ДополнительныйКодФСС,
	|НаименованиеТерриториальногоОрганаФСС,
	|ОГРН,
	|ИНН,
	|КПП,
	|ТелефонСтрахователя,
	|АдресЭлектроннойПочтыСтрахователя,
	|УполномоченныйПоПрямымВыплатамФСС,
	|ДолжностьУполномоченногоПоПрямымВыплатамФСС,
	|ОснованиеПодписиУполномоченногоПоПрямымВыплатамФСС";
	Реквизиты = Новый Структура(ИменаРеквизитов);
	
	// Подписанты.
	СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(Метаданные(), Организация);
	ЗаполнитьЗначенияСвойств(Реквизиты, СведенияОПодписях);
	
	// Реквизиты организации.
	ИменаПолей =
	"Страхователь,
	|РегистрационныйНомерФСС,
	|КодПодчиненностиФСС,
	|ДополнительныйКодФСС,
	|НаименованиеТерриториальногоОрганаФСС,
	|ОГРН,
	|ИННЮЛ,
	|КППЮЛ,
	|НаимЮЛПол,
	|НаимЮЛСокр,
	|ТелОрганизации_JSON,
	|АдресЭлектроннойПочтыОрганизации";
	СведенияОбОрганизации = СЭДОФСС.СведенияОСтрахователе(Организация, ИменаПолей, Дата);
	
	ЗаполнитьЗначенияСвойств(Реквизиты, СведенияОбОрганизации);
	
	Реквизиты.ИНН                               = СведенияОбОрганизации.ИННЮЛ;
	Реквизиты.КПП                               = СведенияОбОрганизации.КППЮЛ;
	Реквизиты.НаименованиеСтрахователя          = СведенияОбОрганизации.НаимЮЛПол;
	Реквизиты.ТелефонСтрахователя               = СведенияОбОрганизации.ТелОрганизации_JSON;
	Реквизиты.АдресЭлектроннойПочтыСтрахователя = СведенияОбОрганизации.АдресЭлектроннойПочтыОрганизации;
	Если СтрДлина(Реквизиты.НаименованиеСтрахователя) > 135 Тогда
		Реквизиты.НаименованиеСтрахователя = СведенияОбОрганизации.НаимЮЛСокр;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьИдентификаторУведомления()
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитШапкиЗафиксирован(ЭтотОбъект, "ИдентификаторУведомления") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИдентификаторДоНачала = ИдентификаторУведомления;
	
	Если ЗначениеЗаполнено(НомерВПределахДня) Тогда
		ИдентификаторУведомления = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ИдентификаторУведомления(ЭтотОбъект);
	Иначе
		ИдентификаторУведомления = "";
	КонецЕсли;
	
	Возврат ИдентификаторДоНачала <> ИдентификаторУведомления;
КонецФункции

Функция ЗаполнитьКадровыеДанныеСотрудника(ПараметрыФиксации)
	Реквизиты = Новый Структура(
		"СотрудникФамилия,
		|СотрудникИмя,
		|СотрудникОтчество,
		|СотрудникСНИЛС,
		|СотрудникИНН,
		|СотрудникДатаРождения,
		|КодСтраныГражданства,
		|УдостоверениеЛичностиВид,
		|УдостоверениеЛичностиСерия,
		|УдостоверениеЛичностиНомер,
		|УдостоверениеЛичностиДатаВыдачи,
		|УдостоверениеЛичностиКемВыдан,
		|УдостоверениеЛичностиСрокДействия");
	НовоеФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	
	КадровыеДанные = КадровыеДанныеСотрудника();
	Если КадровыеДанные <> Неопределено Тогда
		НовоеФизическоеЛицо = КадровыеДанные.ФизическоеЛицо;
		// ФИО, ИНН, СНИЛС, Дата рождения, Код страны гражданства.
		Реквизиты.СотрудникФамилия      = КадровыеДанные.Фамилия;
		Реквизиты.СотрудникИмя          = КадровыеДанные.Имя;
		Реквизиты.СотрудникОтчество     = КадровыеДанные.Отчество;
		Реквизиты.СотрудникСНИЛС        = КадровыеДанные.СтраховойНомерПФР;
		Реквизиты.СотрудникИНН          = КадровыеДанные.ИНН;
		Реквизиты.СотрудникДатаРождения = КадровыеДанные.ДатаРождения;
		Если ЗначениеЗаполнено(КадровыеДанные.Страна) Тогда
			Реквизиты.КодСтраныГражданства = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КадровыеДанные.Страна, "Код");
		КонецЕсли;
		// Удостоверение личности.
		Реквизиты.УдостоверениеЛичностиВид          = КадровыеДанные.ДокументВид;
		Реквизиты.УдостоверениеЛичностиСерия        = СокрЛП(КадровыеДанные.ДокументСерия);
		Реквизиты.УдостоверениеЛичностиНомер        = СокрЛП(КадровыеДанные.ДокументНомер);
		Реквизиты.УдостоверениеЛичностиДатаВыдачи   = КадровыеДанные.ДокументДатаВыдачи;
		Реквизиты.УдостоверениеЛичностиКемВыдан     = КадровыеДанные.ДокументКемВыдан;
		Реквизиты.УдостоверениеЛичностиСрокДействия = КадровыеДанные.ДокументСрокДействия;
	КонецЕсли;
	
	ЕстьИзменения = (ФизическоеЛицо <> НовоеФизическоеЛицо);
	ФизическоеЛицо = НовоеФизическоеЛицо;
	
	Если ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации) Тогда
		ЕстьИзменения = Истина;
	КонецЕсли;
	
	Возврат ЕстьИзменения;
КонецФункции

Функция КадровыеДанныеСотрудника()
	КадровыеДанныеСотрудника = ОбщегоНазначенияБЗК.ЗначениеСвойства(ДополнительныеСвойства, "КадровыеДанные");
	Если КадровыеДанныеСотрудника = Неопределено Тогда
		Если Не ЗначениеЗаполнено(Сотрудник) Тогда
			Возврат Неопределено;
		КонецЕсли;
		ИменаПолей = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ИменаПолейТребуемыхКадровыхДанных();
		КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудника(Истина, Сотрудник, ИменаПолей, Дата);
		Если КадровыеДанныеСотрудника = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(КадровыеДанныеСотрудника) = Тип("Структура") Тогда
		Возврат КадровыеДанныеСотрудника;
	КонецЕсли;
	ИменаПолей = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ИменаПолейТребуемыхКадровыхДанных();
	КадровыеДанные = Новый Структура(ИменаПолей);
	ЗаполнитьЗначенияСвойств(КадровыеДанные, КадровыеДанныеСотрудника);
	ДополнительныеСвойства.Вставить("КадровыеДанные", КадровыеДанные);
	Возврат КадровыеДанные;
КонецФункции

Функция ЗаполнитьРазрешениеНаПроживание(ПараметрыФиксации)
	Реквизиты = Новый Структура("РазрешениеНаПроживаниеВид, РазрешениеНаПроживаниеСерия, РазрешениеНаПроживаниеНомер,
		|РазрешениеНаПроживаниеДатаВыдачи, РазрешениеНаПроживаниеСрокДействия");
	
	Если ЗначениеЗаполнено(ФизическоеЛицо) И Не СЭДОФСС.ГражданствоРФ(КодСтраныГражданства) Тогда
		РазрешениеНаПроживание = Документы.СведенияОЗастрахованномЛицеФСС.НайтиРазрешениеНаПроживание(ФизическоеЛицо, Дата);
		Реквизиты.РазрешениеНаПроживаниеВид          = РазрешениеНаПроживание.Вид;
		Реквизиты.РазрешениеНаПроживаниеСерия        = СокрЛП(РазрешениеНаПроживание.Серия);
		Реквизиты.РазрешениеНаПроживаниеНомер        = СокрЛП(РазрешениеНаПроживание.Номер);
		Реквизиты.РазрешениеНаПроживаниеДатаВыдачи   = РазрешениеНаПроживание.ДатаВыдачи;
		Реквизиты.РазрешениеНаПроживаниеСрокДействия = РазрешениеНаПроживание.СрокДействия;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьКонтактыФизическогоЛица(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Реквизиты = Новый Структура("АдресРегистрации, СотрудникТелефон");
	
	ВидАдресПоПрописке  = КадровыйУчет.ВидКонтактнойИнформацииАдресПоПропискеФизическиеЛица();
	ВидТелефонДомашний  = КадровыйУчет.ВидКонтактнойИнформацииТелефонДомашнийФизическиеЛица();
	ВидТелефонМобильный = КадровыйУчет.ВидКонтактнойИнформацииТелефонМобильныйФизическиеЛица();
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(ВидАдресПоПрописке);
	ВидыКИ.Добавить(ВидТелефонДомашний);
	ВидыКИ.Добавить(ВидТелефонМобильный);
	
	ТаблицаКИ = КонтактнаяИнформацияБЗК.КонтактнаяИнформацияОбъектов(ФизическоеЛицо, , ВидыКИ);
	
	СтрокаКИ = ТаблицаКИ.Найти(ВидАдресПоПрописке, "Вид");
	Если СтрокаКИ <> Неопределено Тогда
		Реквизиты.АдресРегистрации = СтрокаКИ.Значение;
	КонецЕсли;
	
	СтрокаКИ = ТаблицаКИ.Найти(ВидТелефонДомашний, "Вид");
	Если СтрокаКИ <> Неопределено Тогда
		Реквизиты.СотрудникТелефон = СтрокаКИ.Значение;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Реквизиты.СотрудникТелефон) Тогда
		СтрокаКИ = ТаблицаКИ.Найти(ВидТелефонМобильный, "Вид");
		Если СтрокаКИ <> Неопределено Тогда
			Реквизиты.СотрудникТелефон = СтрокаКИ.Значение;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьНаименованиеПриказа(ПараметрыФиксации)
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитШапкиЗафиксирован(ЭтотОбъект, "НаименованиеПриказа") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НаименованиеПриказаДо = НаименованиеПриказа;
	
	ТипыПриказов = Перечисления.ОснованияПрекращенияПособийПоУходу;
	Если ТипПриказа = ТипыПриказов.ПриказОбУвольнении Тогда
		НаименованиеПриказа = НСтр("ru = 'Приказ о прекращении трудовых отношений'");
	ИначеЕсли ТипПриказа = ТипыПриказов.ПриказОДосрочномВыходеНаРаботу Тогда
		НаименованиеПриказа = НСтр("ru = 'Приказ о выходе на работу'");
	ИначеЕсли ТипПриказа = ТипыПриказов.СвидетельствоОСмертиРебенка Тогда
		НаименованиеПриказа = НСтр("ru = 'Свидетельство о смерти ребенка'");
	ИначеЕсли ТипПриказа = ТипыПриказов.ПрекращениеОснованийДляВыплатыПособия Тогда
		НаименованиеПриказа = "";
	ИначеЕсли ТипПриказа = ТипыПриказов.ИнойПриказИлиДокумент Тогда
		НаименованиеПриказа = "";
	Иначе
		НаименованиеПриказа = "";
	КонецЕсли;
	
	Возврат НаименованиеПриказа <> НаименованиеПриказаДо;
КонецФункции

Функция ЗаполнитьДатуПредставленияПакетаДокументов(ПараметрыФиксации)
	Реквизиты = Новый Структура("ДатаПредставленияПакетаДокументов", Дата);
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

#КонецОбласти

Функция ЗначенияРеквизитовДоЗаписи()
	ИменаРеквизитов = "Номер, Дата, Страхователь, ОтправлятьЧерезСЭДО";
	Если ЭтоНовый() Тогда
		Возврат ОбщегоНазначенияБЗК.ЗначенияСвойств(ЭтотОбъект, ИменаРеквизитов);
	Иначе
		Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	КонецЕсли;
КонецФункции

Процедура ЗаполнитьНомерВПределахДня() Экспорт
	Если ОтправлятьЧерезСЭДО Тогда
		НомерВПределахДня = НомерВПределахДня();
	Иначе
		НомерВПределахДня = 0;
	КонецЕсли;
	Если НомерВПределахДня > 9999 Тогда
		ТекстОШибки = НСтр("ru = 'Номер уведомления о прекращении отпуска по уходу %1 от %2 больше 9999. Перенесите документ на другую дату.'");
		ТекстОШибки = СтрШаблон(ТекстОШибки, Номер, Дата);
		ВызватьИсключение ТекстОШибки;
	КонецЕсли;
	ЗаполнитьИдентификаторУведомления();
КонецПроцедуры

Функция НомерВПределахДня()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Уведомление.НомерВПределахДня КАК НомерВПределахДня
	|ИЗ
	|	Документ.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком КАК Уведомление
	|ГДЕ
	|	Уведомление.Дата МЕЖДУ &НачалоДня И &КонецДня
	|	И Уведомление.Страхователь = &Страхователь
	|	И Уведомление.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Уведомление.НомерВПределахДня УБЫВ";
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(Дата));
	Запрос.УстановитьПараметр("КонецДня", КонецДня(Дата));
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.НомерВПределахДня + 1;
	КонецЕсли;
	
	Возврат 1;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли