
#Область ПрограммныйИнтерфейс

// Новые параметры формы цены и валюта.
// 
// Параметры:
//  Объект - ДанныеФормыСтруктура
//  ТолькоПросмотр - Булево
//  Организация - СправочникСсылка.Организации
//  ПерезаполнитьЦены - Булево
//  ПересчитатьЦены - Булево
//  ТекстПредупреждения - Строка
// 
// Возвращаемое значение:
//  Структура - Новые параметры формы цены и валюта
Функция НовыеПараметрыФормыЦеныИВалюта(Знач Объект, ТолькоПросмотр, Организация, ПерезаполнитьЦены, ПересчитатьЦены,
	ТекстПредупреждения = "") Экспорт

	Результат = Новый Структура;
	Результат.Вставить("БылиВнесеныИзменения", Ложь);
	Результат.Вставить("ВалютаДокумента", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("ВалютаПередИзменением", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("ВидСкидкиНаценки", ПредопределенноеЗначение("Справочник.ВидыСкидокНаценок.ПустаяСсылка"));
	Результат.Вставить("ВидЦен", ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка"));
	Результат.Вставить("ВидЦенКонтрагента", ПредопределенноеЗначение("Справочник.ВидыЦенКонтрагентов.ПустаяСсылка"));
	Результат.Вставить("ДатаДокумента", Объект.Дата);
	Результат.Вставить("ДисконтнаяКарта", ПредопределенноеЗначение("Справочник.ДисконтныеКарты.ПустаяСсылка"));
	Результат.Вставить("Договор", ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка"));
	Результат.Вставить("ДополнительнаяИнформацияМинимальныеЦены", "");
	Результат.Вставить("ЗапретитьИзменениеВалюты", Ложь);
	Результат.Вставить("Контрагент", ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	Результат.Вставить("Кратность", 1);
	Результат.Вставить("Курс", 1);
	Результат.Вставить("НалогообложениеНДС", ПредопределенноеЗначение(
		"Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка"));
	Результат.Вставить("НДСВключатьВСтоимость", Ложь);
	Результат.Вставить("Организация", Организация);
	Результат.Вставить("ПерезаполнитьЦены", ПерезаполнитьЦены);
	Результат.Вставить("ПересчитатьЦены", ПересчитатьЦены);
	Результат.Вставить("ПоложениеСклада", ПредопределенноеЗначение(
		"Перечисление.ПоложениеРеквизитаНаФорме.ПустаяСсылка"));
	Результат.Вставить("РегистрироватьЦеныПоставщика", Ложь);
	Результат.Вставить("СпециальныйНалоговыйРежим", ПредопределенноеЗначение(
		"Перечисление.СпециальныеНалоговыеРежимы.ПустаяСсылка"));
	Результат.Вставить("СтруктурнаяЕдиница", ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка"));
	Результат.Вставить("СтруктурныеЕдиницы", Новый Массив);
	Результат.Вставить("СуммаВключаетНДС", Ложь);
	Результат.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	Результат.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	Результат.Вставить("ЭтоСчетФактура", Ложь);
	Результат.Вставить("ЭтоВозврат", Ложь);
	Результат.Вставить("ТипОбъектаВладельца", "");
	Результат.Вставить("ИзменятьВидимостьВидовЦенВозвратов", Ложь);

	Для Каждого ТекСвойство Из НеобязательныеСвойства() Цикл
		Если Не Результат.Свойство(ТекСвойство) Тогда
			ВызватьИсключение СтрШаблон(НСтр("ru = 'Указан неправильный реквизит: ""%1"".'"), ТекСвойство);
		КонецЕсли;
		ИмяСвойства = СтрШаблон("%1ЕстьРеквизит", ТекСвойство);
		Результат.Вставить(ИмяСвойства, Объект.Свойство(ТекСвойство));
	КонецЦикла;

	ЦенообразованиеКлиентСервер.ЗаполнитьПоляВидаЦенВозврата(Результат, Объект);
	ЗаполнитьЗначенияСвойств(Результат, Объект);

	Возврат Результат;

КонецФункции

// Необязательные свойства.
// 
// Возвращаемое значение:
//  Массив - имена реквизитов, которые могут отсутствовать в документах.
Функция НеобязательныеСвойства() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ВалютаДокумента");
	Результат.Добавить("ВидСкидкиНаценки");
	Результат.Добавить("ВидЦен");
	Результат.Добавить("ВидЦенКонтрагента");
	Результат.Добавить("ДисконтнаяКарта");
	Результат.Добавить("Договор");
	Результат.Добавить("Контрагент");
	Результат.Добавить("НалогообложениеНДС");
	Результат.Добавить("НДСВключатьВСтоимость");
	Результат.Добавить("РегистрироватьЦеныПоставщика");
	Результат.Добавить("СпециальныйНалоговыйРежим");
	Результат.Добавить("СуммаВключаетНДС");
	Возврат Результат;

КонецФункции

// Результат формы цены и валюта.
// 
// Возвращаемое значение:
//  Структура - Результат формы цены и валюта:
//   * БылиВнесеныИзменения - Булево
//   * ВидЦен - СправочникСсылка.ВидыЦен
//   * ВидЦенКонтрагента - СправочникСсылка.ВидыЦенКонтрагентов
//   * РегистрироватьЦеныПоставщика - Булево
//   * ВидСкидкиНаценки - СправочникСсылка.ВидыСкидокНаценок
//   * ВалютаДокумента - СправочникСсылка.Валюты
//   * НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС
//   * СпециальныйНалоговыйРежим - ПеречислениеСсылка.СпециальныеНалоговыеРежимы
//   * СуммаВключаетНДС - Булево
//   * НДСВключатьВСтоимость - Булево
//   * ВалютаРасчетов - СправочникСсылка.Валюты
//   * КурсРасчетов - Число
//   * КратностьРасчетов - Число
//   * ПредВалютаДокумента - СправочникСсылка.Валюты
//   * ПредНалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС
//   * ПредСпециальныйНалоговыйРежим - ПеречислениеСсылка.СпециальныеНалоговыеРежимы
//   * ПредСуммаВключаетНДС - Булево
//   * ПерезаполнитьЦены - Булево
//   * ПересчитатьЦены - Булево
//   * ИмяФормы - Строка
//   * КурсПересчетаЦен - Структура
//   * ПерезаполнитьСкидки - Булево
//   * ДисконтнаяКарта - СправочникСсылка.ДисконтныеКарты
//   * ИзмененаДисконтнаяКарта - Булево
//   * ПроцентСкидкиПоДисконтнойКарте - Число
//   * Контрагент - СправочникСсылка.Контрагенты
Функция РезультатФормыЦеныИВалюта() Экспорт

	Результат = Новый Структура;
	
	Результат.Вставить("БылиВнесеныИзменения", Ложь);
	
	Результат.Вставить("ВидЦен", ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка"));
	Результат.Вставить("ВидЦенКонтрагента", ПредопределенноеЗначение("Справочник.ВидыЦенКонтрагентов.ПустаяСсылка"));
	Результат.Вставить("РегистрироватьЦеныПоставщика", Ложь);
	Результат.Вставить("ВидСкидкиНаценки", ПредопределенноеЗначение("Справочник.ВидыСкидокНаценок.ПустаяСсылка"));
	
	Результат.Вставить("ВалютаДокумента", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("НалогообложениеНДС", ПредопределенноеЗначение(
		"Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка"));
	Результат.Вставить("СпециальныйНалоговыйРежим", ПредопределенноеЗначение(
		"Перечисление.СпециальныеНалоговыеРежимы.ПустаяСсылка"));
	Результат.Вставить("СуммаВключаетНДС", Ложь);
	Результат.Вставить("НДСВключатьВСтоимость", Ложь);
	
	Результат.Вставить("ВалютаРасчетов", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("КурсРасчетов", 1);
	Результат.Вставить("КратностьРасчетов", 1);
	
	Результат.Вставить("ПредВалютаДокумента", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("ПредНалогообложениеНДС", ПредопределенноеЗначение(
		"Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка"));
	Результат.Вставить("ПредСпециальныйНалоговыйРежим", ПредопределенноеЗначение(
		"Перечисление.СпециальныеНалоговыеРежимы.ПустаяСсылка"));
	Результат.Вставить("ПредСуммаВключаетНДС", Ложь);
	
	Результат.Вставить("ПерезаполнитьЦены", Ложь);
	Результат.Вставить("ПересчитатьЦены", Ложь);
	
	Результат.Вставить("ИмяФормы", "ОбщаяФорма.ЦеныИВалюта");
	
	Результат.Вставить("КурсПересчетаЦен", Новый Структура);
	Результат.КурсПересчетаЦен.Вставить("Курс", 1);
	Результат.КурсПересчетаЦен.Вставить("Кратность", 1);
	
	// ДисконтныеКарты
	Результат.Вставить("ПерезаполнитьСкидки", Ложь);
	
	Результат.Вставить("ДисконтнаяКарта", ПредопределенноеЗначение("Справочник.ДисконтныеКарты.ПустаяСсылка"));
	Результат.Вставить("ИзмененаДисконтнаяКарта", Ложь);
	Результат.Вставить("ПроцентСкидкиПоДисконтнойКарте", 0);
	Результат.Вставить("Контрагент", ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	
	Возврат Результат;

КонецФункции

// Текст надписи цены и валюта.
// 
// Параметры:
//  Объект - ДанныеФормыСтруктура
//  ВалютаРасчетов - СправочникСсылка.Валюты
//  КурсНациональнаяВалюта - Число
//  УчетВалютныхОпераций - Булево
//  СуммаВключаетНДС - Булево
// 
// Возвращаемое значение:
//  Строка - текст надписи цены и валюта
Функция ТекстНадписиЦеныИВалюта(Знач Объект, Знач ВалютаРасчетов, Знач КурсНациональнаяВалюта,
	Знач УчетВалютныхОпераций, Знач СуммаВключаетНДС = Ложь) Экспорт
	
	ПоляНадписи = ПоляНадписи(Объект, ВалютаРасчетов, КурсНациональнаяВалюта, УчетВалютныхОпераций);
	
	СоставНадписи = Новый Массив;
	
	Если ПоляНадписи.УчетВалютныхОпераций И ЗначениеЗаполнено(ПоляНадписи.ВалютаДокумента) Тогда
		СоставНадписи.Добавить(ПредставлениеВалютаИКурс(ПоляНадписи));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляНадписи.ВидЦен) Тогда
		СоставНадписи.Добавить(СокрЛП(ПоляНадписи.ВидЦен));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляНадписи.ВидЦенКонтрагента) Тогда
		СоставНадписи.Добавить(СокрЛП(ПоляНадписи.ВидЦенКонтрагента));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляНадписи.ВидСкидкиНаценки) Тогда
		СоставНадписи.Добавить(СокрЛП(ПоляНадписи.ВидСкидкиНаценки));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляНадписи.ДисконтнаяКарта) И ДисконтныеКартыУНФВызовСервера.СтарыйМеханизмСкидок(
		ПоляНадписи.ДисконтнаяКарта) Тогда
		Если ЗначениеЗаполнено(ПоляНадписи.ПроцентСкидкиПоДисконтнойКарте) Тогда
			ПроцентПоКарте = СтрШаблон(НСтр("ru = '%1%% по карте'"), ПоляНадписи.ПроцентСкидкиПоДисконтнойКарте);
			СоставНадписи.Добавить(ПроцентПоКарте);
		Иначе
			СоставНадписи.Добавить(СокрЛП(ПоляНадписи.ДисконтнаяКарта));
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляНадписи.НалогообложениеНДС) Тогда
		СоставНадписи.Добавить(
			РаботаСФормойДокументаКлиентСервер.КраткоеПредставлениеТипаНалогообложенияНДС(
			ПоляНадписи.НалогообложениеНДС));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоляНадписи.СпециальныйНалоговыйРежим) И ПоляНадписи.СпециальныйНалоговыйРежим
		<> ПредопределенноеЗначение("Перечисление.СпециальныеНалоговыеРежимы.НеПрименяется") Тогда
		СоставНадписи.Добавить(СокрЛП(ПоляНадписи.СпециальныйНалоговыйРежим));
	КонецЕсли;
	
	Если СуммаВключаетНДС Тогда
		Если ПоляНадписи.СуммаВключаетНДС Тогда
			СоставНадписи.Добавить(НСтр("ru = 'Сумма включает НДС'"));
		Иначе
			СоставНадписи.Добавить(НСтр("ru = 'Сумма не включает НДС'"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтрСоединить(СоставНадписи, " • ");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Поля надписи "Цена и валюта"
// 
// Параметры:
//  Объект - ДанныеФормыСтруктура
//  ВалютаРасчетов - СправочникСсылка.Валюты
//  КурсНациональнаяВалюта - Число
//  УчетВалютныхОпераций - Булево
// 
// Возвращаемое значение:
//  Структура - Поля надписи "Цена и валюта"
Функция ПоляНадписи(Знач Объект, Знач ВалютаРасчетов, Знач КурсНациональнаяВалюта, Знач УчетВалютныхОпераций)
	
	Результат = Новый Структура;
	Результат.Вставить("ВидЦен", ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка"));
	Результат.Вставить("ВидЦенКонтрагента", ПредопределенноеЗначение("Справочник.ВидыЦенКонтрагентов.ПустаяСсылка"));
	Результат.Вставить("ВидСкидкиНаценки", ПредопределенноеЗначение("Справочник.ВидыСкидокНаценок.ПустаяСсылка"));
	Результат.Вставить("ВалютаДокумента", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("Курс", 1);
	Результат.Вставить("СуммаВключаетНДС", Ложь);
	Результат.Вставить("НалогообложениеНДС", ПредопределенноеЗначение(
		"Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка"));
	Результат.Вставить("СпециальныйНалоговыйРежим", ПредопределенноеЗначение(
		"Перечисление.СпециальныеНалоговыеРежимы.ПустаяСсылка"));
	Результат.Вставить("ДисконтнаяКарта", ПредопределенноеЗначение("Справочник.ДисконтныеКарты.ПустаяСсылка"));
	Результат.Вставить("ПроцентСкидкиПоДисконтнойКарте", 0);
	
	ЗаполнитьЗначенияСвойств(Результат, Объект);
	
	Результат.Вставить("ВалютаРасчетов", ВалютаРасчетов);
	Результат.Вставить("КурсНациональнаяВалюта", КурсНациональнаяВалюта);
	Результат.Вставить("УчетВалютныхОпераций", УчетВалютныхОпераций);
	
	ЦенообразованиеКлиентСервер.ВыбратьПоляНадписиВидовЦенДляВозвратов(Результат, Объект);
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеВалютаИКурс(Знач ПоляНадписи)
	
	КомпонентыВалютаИКурс = Новый Массив;
	
	Если ПоляНадписи.ВалютаДокумента = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
		КомпонентыВалютаИКурс.Добавить(СокрЛП(ПоляНадписи.ВалютаДокумента));
	Иначе
		КомпонентыВалютаИКурс.Добавить(
			СокрЛП(УправлениеНебольшойФирмойПовтИсп.ПолучитьСимвольноеПредставлениеВалюты(ПоляНадписи.ВалютаДокумента)));
		КомпонентыВалютаИКурс.Добавить(СокрЛП(ПоляНадписи.Курс));
	КонецЕсли;
	
	Возврат СтрСоединить(КомпонентыВалютаИКурс, " ");
	
КонецФункции

#КонецОбласти