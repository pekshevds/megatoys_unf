#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьПараметровУсловия(ИмяМакетаСКД, ПараметрыУсловия, ПараметрыРасчетаСкидок, МВТ = Неопределено) Экспорт
	
	ПодготовленныеДанные = Неопределено;
	ДанныеДанногоМакета = Новый Структура;
	Если ПараметрыРасчетаСкидок.Свойство("ДанныеДляПроизвольныхУсловий", ПодготовленныеДанные) Тогда
		Если ТипЗнч(ПодготовленныеДанные) = Тип("Структура") И ПодготовленныеДанные.Свойство(ИмяМакетаСКД, ДанныеДанногоМакета) Тогда
			Если Не ТипЗнч(ДанныеДанногоМакета) = Тип("Структура") Тогда
				ДанныеДанногоМакета = Новый Структура;
			КонецЕсли;
		КонецЕсли;		
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого ПодготовленныйПараметр Из ДанныеДанногоМакета Цикл		
		ОписаниеПараметра = ПараметрыУсловия.Найти(ПодготовленныйПараметр.Ключ);
		Если ОписаниеПараметра = Неопределено Тогда
			Если ТипЗнч(ПодготовленныйПараметр.Значение) = Тип("ТаблицаЗначений") 
				И МВТ = Неопределено Тогда
				// Заполнение временных таблиц не требуется (таблица документа была помещена ранее)
			ИначеЕсли ТипЗнч(ПодготовленныйПараметр.Значение) = Тип("ТаблицаЗначений") Тогда
				// Таблицы значения не передаются в виде параметров - они помещаются во временную таблицу,
				// Имя временной таблицы можно переопределить в ПолучитьИмяВременнойТаблицыПоИмениПараметра()
				ИмяВТ = "ВременнаяТаблица_" + ПодготовленныйПараметр.Ключ;
				ЗарплатаКадры.СоздатьВТПоТаблицеЗначений(МВТ, ПодготовленныйПараметр.Значение, ИмяВТ, Истина); 
			КонецЕсли;
		Иначе
			ОписаниеПараметра.Значение = ПодготовленныйПараметр.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПодготовитьСтандартноеОписаниеОбъекта(Объект, Товары) Экспорт
	Результат = Новый Структура();
	
	// Табличная часть Товары
	ОписаниеТоваров = Товары.Скопировать();
	Если ОписаниеТоваров.Колонки.ЕдиницаИзмерения.ТипЗначения.Типы().Найти(Тип("СправочникСсылка.ЕдиницыИзмерения")) = Неопределено Тогда
		Единицы = ОписаниеТоваров.ВыгрузитьКолонку("ЕдиницаИзмерения");
		ОписаниеТоваров.Колонки.Удалить("ЕдиницаИзмерения");
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("СправочникСсылка.ЕдиницыИзмерения"));
		МассивТипов.Добавить(Тип("СправочникСсылка.КлассификаторЕдиницИзмерения"));
		ОписаниеТоваров.Колонки.Добавить("ЕдиницаИзмерения",Новый ОписаниеТипов(МассивТипов));
		ОписаниеТоваров.ЗагрузитьКолонку(Единицы, "ЕдиницаИзмерения");
	КонецЕсли;
	
	// Реквизиты, которые могут быть и в табличной части, и в шапке документа должен быть перенесены в табличную часть
	// Заказ покупателя
	ИмяКолонкиЗаказ = "Заказ";
	ИмяРеквизитаЗаказ = "Заказ";
	// В части документов заказ на зывается "Заказ", а в части "ЗаказПокупателя". 
	// В механизме произвольных условий должно быть одинаково - "Заказ".
	Если ОписаниеТоваров.Колонки.Найти(ИмяКолонкиЗаказ) = Неопределено Тогда
		ОписаниеТоваров.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказПокупателя"));
		Если Не ОписаниеТоваров.Колонки.Найти("ЗаказПокупателя") = Неопределено Тогда
			ИмяКолонкиЗаказ = "ЗаказПокупателя";
		Иначе
			// Документ не связан с заказом покупателя, либо это и есть заказ.
			ИмяКолонкиЗаказ = Неопределено;
		КонецЕсли;
	КонецЕсли;
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизитаЗаказ) Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ЗаказПокупателя") Тогда 
			ИмяРеквизитаЗаказ = "ЗаказПокупателя";
		Иначе
			// Документ не связан с заказом покупателя, либо это и есть заказ.
			ИмяРеквизитаЗаказ = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	// Существуют документы, где заказ может быть в ТЧ или в шапке (для каждого экземпляра документа определяется индивидуально)
	ЗаполнятьЗаказПоТЧ = Ложь;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПоложениеЗаказаПокупателя") Тогда
		Если Не Объект["ПоложениеЗаказаПокупателя"] = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
			ЗаполнятьЗаказПоТЧ = Истина;
		КонецЕсли;
	КонецЕсли; 
	Если ЗаполнятьЗаказПоТЧ Тогда
		Если Не ИмяКолонкиЗаказ = Неопределено // для документов, не связанных с заказом покупателя, колонка останется не заполненной
			И Не ИмяКолонкиЗаказ = "Заказ"  Тогда // Значение указывается в табличной части, в другой колонке, чем нужно для расчета скидок 
			// В некоторых документах колонка называется "Заказ", в некоторых "ЗаказПокупателя"
			ОписаниеТоваров.ЗагрузитьКолонку(ОписаниеТоваров.ВыгрузитьКолонку(ИмяКолонкиЗаказ), "Заказ");
		// Иначе значения уже находсятся в колонке Заказ, ничего переносить не нужно
		КонецЕсли;
	ИначеЕсли Не ИмяРеквизитаЗаказ = Неопределено Тогда // для документов, не связанных с заказом покупателя, колонка останется не заполненной
		// Значение указывается в шапке, нужно заполнить строки таблицы по шапке
		ОписаниеТоваров.ЗаполнитьЗначения(Объект[ИмяРеквизитаЗаказ], "Заказ");
	КонецЕсли;
	
	// Структурная единица
	ИмяКолонкиСклад = "СтруктурнаяЕдиница";
	// В части документов заказ на зывается "Заказ", а в части "ЗаказПокупателя". 
	// В механизме произвольных условий должно быть одинаково - "Заказ".
	СкладВШапке = Истина;
	// Существуют документы, где заказ может быть в ТЧ или в шапке (для каждого экземпляра документа определяется индивидуально)
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПоложениеСклада")
		И Не Объект["ПоложениеСклада"] = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		СкладВШапке = Ложь;
	КонецЕсли;
	Если СкладВШапке Тогда
		Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяКолонкиСклад) Тогда
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ТорговыйОбъект") Тогда
				ИмяКолонкиСклад = "ТорговыйОбъект";
			ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "СтруктурнаяЕдиницаРезерв") Тогда
				ИмяКолонкиСклад = "СтруктурнаяЕдиницаРезерв";
			ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Подразделение") Тогда
				ИмяКолонкиСклад = "Подразделение";
			Иначе
				ИмяКолонкиСклад = Неопределено;
			КонецЕсли;
		КонецЕсли;
		Если Не ИмяКолонкиСклад = Неопределено Тогда // Иначе колонка СтруктурнаяЕдиница останется не заполненной
			Если ОписаниеТоваров.Колонки.Найти("СтруктурнаяЕдиница") = Неопределено Тогда
				ОписаниеТоваров.Колонки.Добавить("СтруктурнаяЕдиница", Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
			КонецЕсли;
			ОписаниеТоваров.ЗаполнитьЗначения(Объект[ИмяКолонкиСклад], "СтруктурнаяЕдиница");
		КонецЕсли;
	Иначе
		Если ОписаниеТоваров.Колонки.Найти(ИмяКолонкиСклад) = Неопределено Тогда
			ИмяКолонкиСклад = Неопределено;
		КонецЕсли;
		Если Не ИмяКолонкиСклад = Неопределено И Не ИмяКолонкиСклад = "СтруктурнаяЕдиница" Тогда // Иначе колонка СтруктурнаяЕдиница останется не заполненной
			Если ОписаниеТоваров.Колонки.Найти(ИмяКолонкиСклад) = Неопределено Тогда
				ОписаниеТоваров.Колонки.Добавить("СтруктурнаяЕдиница", Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
			КонецЕсли;
			ОписаниеТоваров.ЗагрузитьКолонку(ОписаниеТоваров.ВыгрузитьКолонку(ИмяКолонкиСклад), "СтруктурнаяЕдиница");
		КонецЕсли;
		
	КонецЕсли;

	// Ответственный
	// В некоторых документах, ответственный может быть указан в ТЧ, в некоторых - только в шапке.
	Если ОписаниеТоваров.Колонки.Найти("Ответственный") = Неопределено Тогда
		ОписаниеТоваров.Колонки.Добавить("Ответственный", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПоложениеОтветственный") Тогда
		Если Объект["ПоложениеОтветственный"] = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
			// Значение указывается в шапке, нужно перенести в ТЧ
			ОписаниеТоваров.ЗаполнитьЗначения(Объект["Ответственный"], "Ответственный");
		КонецЕсли;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Ответственный") Тогда
		ОписаниеТоваров.ЗаполнитьЗначения(Объект["Ответственный"], "Ответственный");
	КонецЕсли;	
	Результат.Вставить("Товары", ОписаниеТоваров);
	
	// Реквизиты шапки
	// В РМК в качестве объекта используется ДанныеФормыСтруктура, где могут быть представлены не все реквизиты. 
	// В этом случае, мы считаем их не заполненными
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Дата") Тогда
		Результат.Вставить("Дата", Объект.Дата);
	Иначе
		Результат.Вставить("Дата", ТекущаяДатаСеанса());
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Контрагент") Тогда
		Результат.Вставить("Контрагент", Объект.Контрагент);
	Иначе
		Результат.Вставить("Контрагент", ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Организация") Тогда
		Результат.Вставить("Организация", Объект.Организация);
	Иначе
		Результат.Вставить("Организация", ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Договор") Тогда
		Результат.Вставить("Договор", Объект.Договор);
	Иначе
		Результат.Вставить("Договор", ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ДисконтнаяКарта") Тогда
		Результат.Вставить("ДисконтнаяКарта", Объект.ДисконтнаяКарта);
	Иначе
		Результат.Вставить("ДисконтнаяКарта", ПредопределенноеЗначение("Справочник.ДисконтныеКарты.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Автор") Тогда
		Результат.Вставить("Автор", Объект.Автор);
	Иначе
		Результат.Вставить("Автор", ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ВидЦен") Тогда
		Результат.Вставить("ВидЦен", Объект.ВидЦен);
	Иначе
		Результат.Вставить("ВидЦен", ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ДокументОснование") Тогда
		Результат.Вставить("ДокументОснование", Объект.ДокументОснование);
	Иначе
		Результат.Вставить("ДокументОснование", Неопределено);
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Комментарий") Тогда
		Результат.Вставить("Комментарий", Объект.Комментарий);
	Иначе
		Результат.Вставить("Комментарий", "");
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "НалогообложениеНДС") Тогда
		Результат.Вставить("НалогообложениеНДС", Объект.НалогообложениеНДС); 
	Иначе
		Результат.Вставить("НалогообложениеНДС", ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка"));
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "НоменклатураДоставки") Тогда
		Результат.Вставить("НоменклатураДоставки", Объект.НоменклатураДоставки); 
	Иначе
		Результат.Вставить("НоменклатураДоставки", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
	КонецЕсли;	
	
	Возврат Результат;
КонецФункции

Функция ПодготовитьОписаниеОбъектаПроизвольныхУсловий(Объект, Товары) Экспорт
	Результат = Новый Структура;
	СписокСхем = СписокСхемСКД();
	Для Каждого Схема Из СписокСхем.ТиповыеСхемы Цикл
		ТекущийРезультат = ПодготовитьСтандартноеОписаниеОбъекта(Объект, Товары);
		Результат.Вставить(Схема.Ключ, ТекущийРезультат);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция СписокСхемСКД() Экспорт
	ТиповыеСхемы = Новый Структура;
	ТиповыеСхемы.Вставить("ДанныеДокумента", "Данные документа");
	СхемыРасширений = Новый Структура;
	Возврат Новый Структура("ТиповыеСхемы, СхемыРасширений", ТиповыеСхемы, СхемыРасширений)
КонецФункции

#КонецОбласти

#КонецЕсли