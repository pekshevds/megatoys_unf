#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Состояние = Справочники.СостоянияСобытий.Запланировано;
	Событие = Документы.Событие.ПустаяСсылка();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	СтратегияЗаполнения[Тип("ДокументСсылка.Событие")] = "ЗаполнитьПоСобытию";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПокупателя")] = "ЗаполнитьПоЗаказуПокупателя";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения, "Состояние");
	
	Если Работы.Количество() = 0 Тогда
		Работы.Добавить();
	КонецЕсли;
	
	ДозаполнитьПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоложениеВидаРабот <> Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		Для каждого СтрокаТабличнойЧасти Из Работы Цикл
			СтрокаТабличнойЧасти.ВидРабот = ВидРабот;
		КонецЦикла;
	Иначе
		ВидРабот = ЗаполнениеОбъектовУНФ.ЗначениеДляШапки(Работы, "ВидРабот");
	КонецЕсли;
	
	РассчитатьДатаНачалаОкончания();
	СуммаДокумента = Работы.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ЗаданиеНаРаботу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗаданияНаРаботу", ДополнительныеСвойства.ТаблицыДляДвижений, Движения,
		Отказ);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Работа Из Работы Цикл
		
		Если Работа.ДатаОкончания < Работа.ДатаНачала Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='Дата окончания не может быть меньше даты начала.'"),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Работы", Работа.НомерСтроки, "ДатаОкончания")
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьДатаНачалаОкончания() Экспорт
	
	ДатаНачала = Неопределено;
	ДатаОкончания = Неопределено;
	Для каждого Строка Из Работы Цикл
		Если Не ЗначениеЗаполнено(ДатаНачала)
			Или (ЗначениеЗаполнено(Строка.ДатаНачала) И Строка.ДатаНачала < ДатаНачала) Тогда
			ДатаНачала = Строка.ДатаНачала;
		КонецЕсли;
		Если Строка.ДатаОкончания > ДатаОкончания Тогда
			ДатаОкончания = Строка.ДатаОкончания;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыЗаполненияДокумента

Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения.Свойство("ДанныеЗаписиКалендаря")
		И ТипЗнч(ДанныеЗаполнения.ДанныеЗаписиКалендаря) = Тип("Структура") Тогда
		
		Комментарий			= ДанныеЗаполнения.ДанныеЗаписиКалендаря.Наименование;
		КалендарьСотрудника	= ДанныеЗаполнения.ДанныеЗаписиКалендаря.Календарь;
		
		НоваяСтрокаРабот = Работы.Добавить();
		НоваяСтрокаРабот.ДатаНачала		= ДанныеЗаполнения.ДанныеЗаписиКалендаря.Начало;
		НоваяСтрокаРабот.ДатаОкончания	= ДанныеЗаполнения.ДанныеЗаписиКалендаря.Окончание;
		НоваяСтрокаРабот.Комментарий	= ДанныеЗаполнения.ДанныеЗаписиКалендаря.Описание;
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Работы") Тогда
		Для Каждого СтрокаРаботы Из ДанныеЗаполнения.Работы Цикл
			ЗаполнитьЗначенияСвойств(Работы.Добавить(), СтрокаРаботы);
		КонецЦикла;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Контрагент")
		И Не ЗначениеЗаполнено(Работы) Тогда
		НоваяСтрока = Работы.Добавить();
		НоваяСтрока.Заказчик = ДанныеЗаполнения.Контрагент;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоСобытию(ДанныеЗаполнения) Экспорт
	
	Событие = ДанныеЗаполнения.Ссылка;
	Если ДанныеЗаполнения.Участники.Количество() > 0 Тогда
		НоваяСтрока = Работы.Добавить();
		НоваяСтрока.Заказчик = ДанныеЗаполнения.Участники[0].Контакт;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуПокупателя(ДанныеЗаполнения) Экспорт
	
	ДанныеЗаполненияВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ВидОперации");
	
	Если ДанныеЗаполненияВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу
		ИЛИ ДанныеЗаполненияВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПереработку Тогда
		ЗаполнитьПоЗаказуНаПродажуИлиНаПереработку(ДанныеЗаполнения);
	КонецЕсли;
	
	Если ДанныеЗаполненияВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		ЗаполнитьПоЗаказНаряду(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказНаряду(ДанныеЗаполнения)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказПокупателя.Организация КАК Организация,
	|	ЗаказПокупателя.ВидЦен КАК ВидЦен,
	|	ЗаказПокупателя.СтруктурнаяЕдиницаПродажи КАК СтруктурнаяЕдиница,
	|	ЗаказПокупателя.ВидРабот КАК ВидРабот,
	|	ЗаказПокупателя.Финиш КАК Финиш,
	|	ЗаказПокупателя.Старт КАК Старт,
	|	ЗаказПокупателя.Ссылка КАК Заказчик,
	|	ЗаказПокупателя.Работы.(
	|		Ссылка КАК Заказчик,
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		ВидРабот КАК ВидРабот,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		Количество КАК Количество,
	|		Кратность КАК Кратность,
	|		Коэффициент КАК Коэффициент
	|	) КАК Работы
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаИзРезультатаЗапроса);
	
	ТаблицаРаботы = ВыборкаИзРезультатаЗапроса.Работы.Выгрузить();
	Для каждого СтрокаРаботы Из ТаблицаРаботы Цикл
		
		НоваяСтрока = Работы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаботы);
		
		НоваяСтрока.Трудоемкость	= СтрокаРаботы.Количество * СтрокаРаботы.Кратность * СтрокаРаботы.Коэффициент;
		НоваяСтрока.ДатаНачала		= ВыборкаИзРезультатаЗапроса.Старт;
		НоваяСтрока.ДатаОкончания	= НоваяСтрока.ДатаНачала + НоваяСтрока.Трудоемкость * 3600
		
	КонецЦикла;
	
	Если Работы.Количество() = 0 Тогда
		НоваяСтрока = Работы.Добавить();
		НоваяСтрока.Заказчик = ВыборкаИзРезультатаЗапроса.Заказчик;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуНаПродажуИлиНаПереработку(ДанныеЗаполнения)
	
	ТипыНоменклатуры = Новый Массив;
	ТипыНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Услуга);
	ТипыНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Работа);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказПокупателя.Организация КАК Организация,
	|	ЗаказПокупателя.ВидЦен КАК ВидЦен,
	|	ЗаказПокупателя.СтруктурнаяЕдиницаПродажи КАК СтруктурнаяЕдиница,
	|	ЗаказПокупателя.ОжидаетсяВыборВариантаКП КАК ОжидаетсяВыборВариантаКП
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказПокупателяЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПокупателяЗапасы.Характеристика КАК Характеристика,
	|	ЗаказПокупателяЗапасы.ДатаОтгрузки КАК ДатаНачала,
	|	ЗаказПокупателяЗапасы.Цена КАК Цена,
	|	ЗаказПокупателяЗапасы.Сумма КАК Сумма,
	|	ЗаказПокупателяЗапасы.Ссылка КАК Заказчик
	|ИЗ
	|	ВТЗаказПокупателяЗапасы КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры В(&ТипыНоменклатуры)");
	
	Документы.ЗаказПокупателя.ДобавитьТаблицуЗапасыВМенеджерВременныхТаблиц(ДанныеЗаполнения, Запрос.МенеджерВременныхТаблиц, Истина);
	
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения);
	Запрос.УстановитьПараметр("ТипыНоменклатуры", ТипыНоменклатуры);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Если Выборка.Следующий() Тогда
		
		Документы.ЗаказПокупателя.ПроверитьВозможностьВводаНаОснованииЗаказаПокупателя(
			ДанныеЗаполнения, Новый Структура("ОжидаетсяВыборВариантаКП", Выборка.ОжидаетсяВыборВариантаКП));
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	Работы.Очистить();
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Работы.Добавить(), Выборка);
	КонецЦикла;
	
	Если Работы.Количество() = 0 Тогда
		НоваяСтрока = Работы.Добавить();
		НоваяСтрока.Заказчик = ДанныеЗаполнения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДозаполнитьПоУмолчанию()
	
	Цена = 0;
	Если ЗначениеЗаполнено(ВидЦен) И ЗначениеЗаполнено(ВидРабот) Тогда
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("ДатаОбработки",	ТекущаяДата());
		СтруктураДанных.Вставить("Номенклатура",	ВидРабот);
		СтруктураДанных.Вставить("Характеристика",	Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
		СтруктураДанных.Вставить("Коэффициент",		1);
		СтруктураДанных.Вставить("ВалютаДокумента",	ВидЦен.ВалютаЦены);
		СтруктураДанных.Вставить("ВидЦен",			ВидЦен);
		Цена = ЦенообразованиеСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанных);
	КонецЕсли;
	
	Для Каждого Работа Из Работы Цикл
		
		Если Не ЗначениеЗаполнено(Работа.ДатаНачала) Тогда
			Работа.ДатаНачала = НачалоДня(ТекущаяДатаСеанса());
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Работа.ДатаОкончания) Тогда
			Работа.ДатаОкончания = КонецДня(Работа.ДатаНачала);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Работа.Трудоемкость) Тогда
			Работа.Трудоемкость = (Работа.ДатаОкончания - Работа.ДатаНачала) / 3600;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Работа.Цена) Тогда
			Работа.Цена = Цена;
		КонецЕсли;
		
		Работа.Сумма = Работа.Трудоемкость * Работа.Цена;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(КалендарьСотрудника) Тогда
		КалендарьСотрудника = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойКалендарь");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсКалендаряСотрудника

Процедура ОбновитьЗаписьКалендаряПриЗаписиИсточника(ЗаписиПоИсточнику) Экспорт
	
	// Отмена всех существующих записей календарей по событию в случае очистки календаря в событии или установки пометки удаления
	Если ПометкаУдаления Или Не ЗначениеЗаполнено(КалендарьСотрудника) Тогда
	
		Для Каждого ЗаписьКалендаря Из ЗаписиПоИсточнику Цикл
			ЗаписьКалендаря = ЗаписьКалендаря.ПолучитьОбъект();
			ЗаписьКалендаря.УстановитьПометкуУдаления(Истина);
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	АктуальныеЗаписиКалендаря = Новый Массив;
	
	Для Каждого СтрокаРабот Из Работы Цикл
		
		Если СтрокаРабот.НомерСтроки > ЗаписиПоИсточнику.Количество() Тогда
			
			ЗаписьКалендаря = Справочники.ЗаписиКалендаряСотрудника.СоздатьЭлемент();
			ЗаписьКалендаря.УстановитьНовыйКод();
			
		Иначе
			
			ЗаписьКалендаря = ЗаписиПоИсточнику[СтрокаРабот.НомерСтроки-1].ПолучитьОбъект();
			
			Если ЗаписьКалендаря.ПометкаУдаления Тогда
				ЗаписьКалендаря.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
		ОбменСGoogle.ОбработатьСменуКалендаря(ЗаписьКалендаря, КалендарьСотрудника);
		
		ПредставлениеЗаписи = СтрШаблон(
			НСтр("ru='Задание: %1'"),
			?(ПоложениеВидаРабот = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке, ВидРабот, СтрокаРабот.ВидРабот));
		
		ЗаписьКалендаря.Наименование = ПредставлениеЗаписи;
		ЗаписьКалендаря.Источник = Ссылка;
		ЗаписьКалендаря.Календарь = КалендарьСотрудника;
		ЗаписьКалендаря.Начало = СтрокаРабот.ДатаНачала;
		ЗаписьКалендаря.Окончание = СтрокаРабот.ДатаОкончания;
		ЗаписьКалендаря.Описание = СтрокаРабот.Комментарий;
		ЗаписьКалендаря.НомерСтрокиИсточника = СтрокаРабот.НомерСтроки;
		ЗаписьКалендаря.ОтветственныйИсточника = Сотрудник;
		ЗаписьКалендаря.Завершено = Состояние = Справочники.СостоянияСобытий.Завершено
			Или Состояние = Справочники.СостоянияСобытий.Отменено;
			
		ЗаполнитьКолонкуЗаписиКалендаря(ЗаписьКалендаря);	
		ЗаписьКалендаря.Записать();
		
		АктуальныеЗаписиКалендаря.Добавить(ЗаписьКалендаря.Ссылка);
		
	КонецЦикла;
	
	ЗаписиКУдалению = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ЗаписиПоИсточнику, АктуальныеЗаписиКалендаря);
	Для каждого ЗаписьКалендаря Из ЗаписиКУдалению Цикл
		ЗаписьКалендаряОбъект = ЗаписьКалендаря.ПолучитьОбъект();
		ЗаписьКалендаряОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьИсточникПриИзмененииЗаписиКалендаря(ЭлементыПланировщика) Экспорт
	
	Для Каждого ДанныеЭлемента Из ЭлементыПланировщика Цикл
		СтрокаРабот = Работы.Получить(ДанныеЭлемента.НомерСтрокиИсточника-1);
		СтрокаРабот.ДатаНачала		= ДанныеЭлемента.Начало;
		СтрокаРабот.ДатаОкончания	= ДанныеЭлемента.Конец;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьКолонкуЗаписиКалендаря(ЗаписьКалендаря)
	
	КолонкаКалендаря = Справочники.КолонкиКалендарейСотрудников.ПустаяСсылка();
	ДополнительныеСвойства.Свойство("КолонкаКалендаря", КолонкаКалендаря);
	
	Если ЗначениеЗаполнено(КолонкаКалендаря) Тогда
		ЗаписьКалендаря.КолонкаКалендаря = КолонкаКалендаря;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЗаписьКалендаря.КолонкаКалендаря) 
		ИЛИ ЗаписьКалендаря.КолонкаКалендаря.Владелец <> ЗаписьКалендаря.Календарь Тогда
		ЗаписьКалендаря.КолонкаКалендаря = Справочники.КолонкиКалендарейСотрудников.КолонкаНеобработанное(ЗаписьКалендаря.Календарь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли