
#Область Служебные

&НаСервере
Процедура ЗаписатьПредоплатуВХранилище()
	
	ТаблицаПредоплаты = Объект.Предоплата.Выгрузить();
	ПоместитьВоВременноеХранилище(ТаблицаПредоплаты, КэшЗначений.АдресДокументовПредоплатыВХранилище);
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыПредоплата

&НаСервере
Функция ПоместитьПредоплатаВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(
		Объект.Предоплата.Выгрузить(,
			"Документ,
			|СуммаРасчетов,
			|Курс,
			|Кратность,
			|СуммаПлатежа"),
		УникальныйИдентификатор);
	
КонецФункции // ПоместитьПредоплатаВХранилище()

&НаСервере
Процедура ПолучитьПредоплатаИзХранилища(АдресПредоплатаВХранилище)
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресПредоплатаВХранилище);
	Объект.Предоплата.Загрузить(ТаблицаДляЗагрузки);
	
КонецПроцедуры // ПолучитьПредоплатаИзХранилища()

&НаКлиенте
Процедура РедактироватьЗачетПредоплатыЗавершение1(Результат, ДополнительныеПараметры) Экспорт
	
	АдресПредоплатаВХранилище = ДополнительныеПараметры.АдресПредоплатаВХранилище;
	
	РедактироватьЗачетПредоплатыФрагмент1(АдресПредоплатаВХранилище, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗачетПредоплатыФрагмент1(Знач АдресПредоплатаВХранилище, Знач КодВозврата)
	
	РедактироватьЗачетПредоплатыФрагмент(АдресПредоплатаВХранилище, КодВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗачетПредоплатыЗавершение(Результат, ДополнительныеПараметры) Экспорт

	АдресПредоплатаВХранилище = ДополнительныеПараметры.АдресПредоплатаВХранилище;
	КодВозврата = Результат;

	РедактироватьЗачетПредоплатыФрагмент(АдресПредоплатаВХранилище, КодВозврата);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗачетПредоплатыФрагмент(Знач АдресПредоплатаВХранилище, Знач КодВозврата)

	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСчетФактура.Продажа") И (КодВозврата
		= КодВозвратаДиалога.OK) Тогда
		ПолучитьПредоплатаИзХранилища(АдресПредоплатаВХранилище);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДокументПриИзменении(Документ)
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить("СуммаРасчетов", Документ.РасшифровкаПлатежа.Итог("СуммаРасчетов"));
	
	Возврат СтруктураДанные;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КэшЗначений = Параметры.КэшЗначений;
	КэшЗначений.Вставить("АдресДокументовПредоплатыВХранилище", Параметры.АдресДокументовПредоплатыВХранилище);
	КэшЗначений.Вставить("Ссылка", Документы.СчетФактура.ПустаяСсылка());
	
	Объект.Предоплата.Загрузить(ПолучитьИзВременногоХранилища(КэшЗначений.АдресДокументовПредоплатыВХранилище));
	
	Параметры.Свойство("Дата", Объект.Дата);
	Параметры.Свойство("ВидОперации", Объект.ВидОперации);
	Параметры.Свойство("Контрагент", Объект.Контрагент);
	Параметры.Свойство("Договор", Объект.Договор);
	Параметры.Свойство("Курс", Объект.Курс);
	Параметры.Свойство("Кратность", Объект.Кратность);
	Параметры.Свойство("ВалютаДокумента", Объект.ВалютаДокумента);
	Параметры.Свойство("СуммаДокумента", Объект.СуммаДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область Элементы

&НаКлиенте
Процедура ПредоплатаДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Документ) Тогда
		
		СтруктураДанные = ПолучитьДанныеДокументПриИзменении(СтрокаТабличнойЧасти.Документ);
		
		СтрокаТабличнойЧасти.СуммаРасчетов = СтруктураДанные.СуммаРасчетов;
		
		СтрокаТабличнойЧасти.Курс = 
			?(СтрокаТабличнойЧасти.Курс = 0,
				?(Объект.Курс = 0,
				1,
				Объект.Курс),
			СтрокаТабличнойЧасти.Курс);
		
		СтрокаТабличнойЧасти.Кратность =
			?(СтрокаТабличнойЧасти.Кратность = 0,
				?(Объект.Кратность = 0,
				1,
				Объект.Кратность),
			СтрокаТабличнойЧасти.Кратность);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ВалютыУНФКлиентСервер.Пересчитать(
			СтрокаТабличнойЧасти.СуммаРасчетов,
			СтрокаТабличнойЧасти.Курс,
			?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КурсНациональнаяВалюта, Объект.Курс),
			СтрокаТабличнойЧасти.Кратность,
			?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КратностьНациональнаяВалюта, Объект.Кратность));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредоплатаСуммаРасчетовПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
		
	СтрокаТабличнойЧасти.Курс = ?(
		СтрокаТабличнойЧасти.Курс = 0,
			?(Объект.Курс = 0,
			1,
			Объект.Курс),
		СтрокаТабличнойЧасти.Курс);
	
	СтрокаТабличнойЧасти.Кратность = ?(
		СтрокаТабличнойЧасти.Кратность = 0,
			?(Объект.Кратность = 0,
			1,
			Объект.Кратность),
		СтрокаТабличнойЧасти.Кратность);
	
	СтрокаТабличнойЧасти.СуммаПлатежа = ВалютыУНФКлиентСервер.Пересчитать(
		СтрокаТабличнойЧасти.СуммаРасчетов,
		СтрокаТабличнойЧасти.Курс,
		?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КурсНациональнаяВалюта, Объект.Курс),
		СтрокаТабличнойЧасти.Кратность,
		?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КратностьНациональнаяВалюта, Объект.Кратность));

КонецПроцедуры

&НаКлиенте
Процедура ПредоплатаКурсПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Курс = ?(
		СтрокаТабличнойЧасти.Курс = 0,
		1,
		СтрокаТабличнойЧасти.Курс);
	
	СтрокаТабличнойЧасти.Кратность = ?(
		СтрокаТабличнойЧасти.Кратность = 0,
		1,
		СтрокаТабличнойЧасти.Кратность);
	
	СтрокаТабличнойЧасти.СуммаПлатежа = ВалютыУНФКлиентСервер.Пересчитать(
		СтрокаТабличнойЧасти.СуммаРасчетов,
		СтрокаТабличнойЧасти.Курс,
		?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КурсНациональнаяВалюта, Объект.Курс),
		СтрокаТабличнойЧасти.Кратность,
		?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КратностьНациональнаяВалюта, Объект.Кратность));
	
КонецПроцедуры

&НаКлиенте
Процедура ПредоплатаКратностьПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Курс = ?(
		СтрокаТабличнойЧасти.Курс = 0,
		1,
		СтрокаТабличнойЧасти.Курс);
	
	СтрокаТабличнойЧасти.Кратность = ?(
		СтрокаТабличнойЧасти.Кратность = 0,
		1,
		СтрокаТабличнойЧасти.Кратность);
	
	СтрокаТабличнойЧасти.СуммаПлатежа = ВалютыУНФКлиентСервер.Пересчитать(
		СтрокаТабличнойЧасти.СуммаРасчетов,
		СтрокаТабличнойЧасти.Курс,
		?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КурсНациональнаяВалюта, Объект.Курс),
		СтрокаТабличнойЧасти.Кратность,
		?(Объект.ВалютаДокумента = КэшЗначений.НациональнаяВалюта, КэшЗначений.КратностьНациональнаяВалюта, Объект.Кратность));
	
КонецПроцедуры

&НаКлиенте
Процедура ПредоплатаСуммаПлатежаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Курс = ?(
		СтрокаТабличнойЧасти.Курс = 0,
		1,
		СтрокаТабличнойЧасти.Курс);
	
	СтрокаТабличнойЧасти.Кратность = 1;
	
	СтрокаТабличнойЧасти.Курс =
		?(СтрокаТабличнойЧасти.СуммаРасчетов = 0,
			1,
			СтрокаТабличнойЧасти.СуммаПлатежа
		  / СтрокаТабличнойЧасти.СуммаРасчетов
		  * Объект.Курс);
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура РедактироватьЗачетПредоплаты(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите вначале контрагента.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Договор) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите вначале договор контрагента.'"));
		Возврат;
	КонецЕсли;
	
	АдресПредоплатаВХранилище = ПоместитьПредоплатаВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресПредоплатаВХранилище", АдресПредоплатаВХранилище);
	ПараметрыПодбора.Вставить("Подбор", Объект.ВидОперации = ПредопределенноеЗначение(
		"Перечисление.ВидыОперацийСчетФактура.Продажа"));
	ПараметрыПодбора.Вставить("ЕстьЗаказ", Ложь);
	ПараметрыПодбора.Вставить("ЗаказВШапке", Ложь);
	ПараметрыПодбора.Вставить("Компания", КэшЗначений.Компания);
	ПараметрыПодбора.Вставить("Заказ", Неопределено);
	ПараметрыПодбора.Вставить("Дата", Объект.Дата);
	ПараметрыПодбора.Вставить("Ссылка", КэшЗначений.Ссылка);
	ПараметрыПодбора.Вставить("Контрагент", Объект.Контрагент);
	ПараметрыПодбора.Вставить("Договор", Объект.Договор);
	ПараметрыПодбора.Вставить("Курс", Объект.Курс);
	ПараметрыПодбора.Вставить("Кратность", Объект.Кратность);
	ПараметрыПодбора.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	ПараметрыПодбора.Вставить("СуммаДокумента", Объект.СуммаДокумента);
	
	ДополнительныеПараметры = Новый Структура("АдресПредоплатаВХранилище, ПараметрыПодбора", АдресПредоплатаВХранилище,
		ПараметрыПодбора);
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьЗачетПредоплатыЗавершение1", ЭтотОбъект,
		ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаПодбораАвансовПокупателей", ПараметрыПодбора, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьПредоплатуВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

#КонецОбласти