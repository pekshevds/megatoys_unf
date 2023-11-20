#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Обработчик заполнения на основании документа ЗаказПокупателя.
//
// Параметры:
//	ДокументСсылкаЗаказПокупателя - ДокументСсылка.ЗаказПокупателя.
//	
Процедура ЗаполнитьПоЗаказПокупателя(ДокументСсылкаЗаказПокупателя) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаЗаказПокупателя);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеВКассу.ОтПокупателя) КАК ВидОперации,
	|	&Ссылка КАК ДокументОснование,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
	|	ТаблицаДокумента.Касса КАК Касса,
	|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ТаблицаДокумента.Контрагент КАК Контрагент,
	|	ТаблицаДокумента.Договор КАК Договор,
	|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ТаблицаДокумента.ОжидаетсяВыборВариантаКП
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Документы.ЗаказПокупателя.ПроверитьВозможностьВводаНаОснованииЗаказаПокупателя(
		ДокументСсылкаЗаказПокупателя, Новый Структура("ОжидаетсяВыборВариантаКП", Выборка.ОжидаетсяВыборВариантаКП));
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры // ЗаполнитьПоЗаказПокупателя()

// Обработчик заполнения на основании документа ОтчетКомиссионера.
//
// Параметры:
//	ДокументСсылкаОтчетКомиссионера - ДокументСсылка.ОтчетКомиссионера.
//	
Процедура ЗаполнитьПоОтчетКомиссионера(ДокументСсылкаОтчетКомиссионера) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаОтчетКомиссионера);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка КАК Ссылка,
	|	СУММА(ТаблицаЗапасы.СуммаВознаграждения) КАК СуммаВознаграждения
	|ПОМЕСТИТЬ ТаблицаСуммаВознаграждения
	|ИЗ
	|	Документ.ОтчетКомиссионера.Запасы КАК ТаблицаЗапасы
	|ГДЕ
	|	ТаблицаЗапасы.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасы.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеВКассу.ОтПокупателя) КАК ВидОперации,
	|	&Ссылка КАК ДокументОснование,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
	|	ТаблицаДокумента.Контрагент КАК Контрагент,
	|	ТаблицаДокумента.Договор КАК Договор,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.УдержатьКомиссионноеВознаграждение
	|			ТОГДА ТаблицаДокумента.СуммаДокумента - ТаблицаСуммаВознаграждения.СуммаВознаграждения
	|		ИНАЧЕ ТаблицаДокумента.СуммаДокумента
	|	КОНЕЦ КАК СуммаДокумента
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСуммаВознаграждения КАК ТаблицаСуммаВознаграждения
	|		ПО (ТаблицаСуммаВознаграждения.Ссылка = ТаблицаДокумента.Ссылка)
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
		
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры // ЗаполнитьПоОтчетКомиссионера()

// Обработчик заполнения на основании документа РасходнаяНакладная.
//
// Параметры:
//	ДокументСсылкаРасходнаяНакладная - ДокументСсылка.РасходнаяНакладная.
//	
Процедура ЗаполнитьПоРасходнаяНакладная(ДокументСсылкаРасходнаяНакладная) Экспорт
	
	РасходнаяНакладнаяВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
	ДокументСсылкаРасходнаяНакладная,
	"ВидОперации");
	
	Если РасходнаяНакладнаяВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ПередачаВПереработку Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Невозможен ввод документа на основании операции - ""%1""!'"),
		РасходнаяНакладнаяВидОперации);
	КонецЕсли;
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаРасходнаяНакладная);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеВКассу.ОтПокупателя) КАК ВидОперации,
	|	&Ссылка КАК ДокументОснование,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
	|	ТаблицаДокумента.Контрагент КАК Контрагент,
	|	ТаблицаДокумента.Договор КАК Договор,
	|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Документ.РасходнаяНакладная КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры // ЗаполнитьПоРасходнаяНакладная()

// Обработчик заполнения на основании документа АктВыполненныхРабот.
//
// Параметры:
//	ДокументСсылкаАктВыполненныхРабот - ДокументСсылка.АктВыполненныхРабот.
//	
Процедура ЗаполнитьПоАктВыполненныхРабот(ДокументСсылкаАктВыполненныхРабот) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаАктВыполненныхРабот);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеВКассу.ОтПокупателя) КАК ВидОперации,
	|	&Ссылка КАК ДокументОснование,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
	|	ТаблицаДокумента.Контрагент КАК Контрагент,
	|	ТаблицаДокумента.Договор КАК Договор,
	|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Документ.АктВыполненныхРабот КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры // ЗаполнитьПоАктВыполненныхРабот()

// Обработка заполнения на основании документа ОтчетОПереработке.
//
// Параметры:
//	ДокументСсылкаОтчетОПереработке - ДокументСсылка.ОтчетОПереработке.
//	
Процедура ЗаполнитьПоОтчетОПереработке(ДокументСсылкаОтчетОПереработке) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаОтчетОПереработке);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеВКассу.ОтПокупателя) КАК ВидОперации,
	|	&Ссылка КАК ДокументОснование,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
	|	ТаблицаДокумента.Контрагент КАК Контрагент,
	|	ТаблицаДокумента.Договор КАК Договор,
	|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Документ.ОтчетОПереработке КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
		
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры // ЗаполнитьПоОтчетОПереработке()

// Обработчик заполнения на основании документа ЗаказПокупателя.
//
// Параметры:
//	ДокументСсылкаЗаказПокупателя - ДокументСсылка.ЗаказПокупателя.
//	
Процедура ЗаполнитьПоНачислениеНалогов(ДокументСсылкаНачислениеНалогов) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаНачислениеНалогов);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеНаСчет.Налоги) КАК ВидОперации,
	|	&Ссылка КАК ДокументОснование,
	|	НачислениеНалогов.Организация КАК Организация,
	|	НачислениеНалогов.СуммаДокумента КАК СуммаДокумента,
	|	ВалютаУчета.Значение КАК ВалютаДокумента,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.Прочее) КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.НачислениеНалогов КАК НачислениеНалогов,
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	НачислениеНалогов.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Документы.НачислениеНалогов.ПроверитьВозможностьВводаНаОснованииНачисленияНалогов(ДокументСсылкаНачислениеНалогов,
		Новый Структура("ВидОперации", ДокументСсылкаНачислениеНалогов.ВидОперации));
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры // ЗаполнитьПоЗаказПокупателя()

Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПокупателя")] = "ЗаполнитьПоЗаказПокупателя";
	СтратегияЗаполнения[Тип("ДокументСсылка.ОтчетКомиссионера")] = "ЗаполнитьПоОтчетКомиссионера";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходнаяНакладная")] = "ЗаполнитьПоРасходнаяНакладная";
	СтратегияЗаполнения[Тип("ДокументСсылка.АктВыполненныхРабот")] = "ЗаполнитьПоАктВыполненныхРабот";
	СтратегияЗаполнения[Тип("ДокументСсылка.ОтчетОПереработке")] = "ЗаполнитьПоОтчетОПереработке";
	СтратегияЗаполнения[Тип("ДокументСсылка.ДоговорКредитаИЗайма")] = "ЗаполнитьПоДоговоруКредитаЗайма";
	СтратегияЗаполнения[Тип("ДокументСсылка.НачислениеНалогов")] = "ЗаполнитьПоНачислениеНалогов";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПоступлениеДСПлан.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПлатежныйКалендарь", ДополнительныеСвойства.ТаблицыДляДвижений, Движения,
		Отказ);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

#КонецОбласти

#Область ПрочиеРасчеты

// Обработчик ввода на основании документа ДоговорКредитаИЗайма.
//
// Параметры:
//	ДокументСсылкаДоговорКредитаИЗайма - ДокументСсылка.ДоговорКредитаИЗайма.
//	
Процедура ЗаполнитьПоДоговоруКредитаЗайма(ДокументСсылкаДоговорКредитаИЗайма) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаДоговорКредитаИЗайма);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	// Заполним данные шапки документа.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Ссылка КАК ДокументОснование,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Номер КАК НомерВходящегоДокумента,
	|	ТаблицаДокумента.Дата КАК ДатаВходящегоДокумента,
	|	ТаблицаДокумента.ВалютаРасчетов КАК ВалютаДокумента,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКредитаИЗайма.КредитПолученный)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|	КОНЕЦ КАК ТипДенежныхСредств,
	|	ТаблицаДокумента.Контрагент КАК Контрагент,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКредитаИЗайма.КредитПолученный)
	|			ТОГДА ТаблицаДокумента.СуммаДокумента
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаДокумента
	|ИЗ
	|	Документ.ДоговорКредитаИЗайма КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	Если Не Контрагент.Пустая() Тогда
		МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
		
		СписокВидовДоговоров = Неопределено;
		Договор = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли