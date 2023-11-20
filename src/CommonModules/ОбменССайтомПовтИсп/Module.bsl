#Область ПрограммныйИнтерфейс

// Выполняет поиск валюты по строковому коду, полученному из XML.
//
// Параметры:
//	КодВалютыСтрока - Cтрока - код валюты
//
// Возвращаемое значение:
//	СправочникСсылка.Валюты - найденная валюта.
//
Функция ОбработатьВалютуXML(КодВалютыСтрока) Экспорт
	
	Валюта = Справочники.Валюты.НайтиПоНаименованию(КодВалютыСтрока);
	
	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		Валюта = Константы.НациональнаяВалюта.Получить();
	КонецЕсли;
		
	Возврат Валюта;
	
КонецФункции

// Определяет имя поля контактной информации.
//
// Параметры:
//	ИмяТипа - строка, имя типа контактной информации
//
// Возвращаемое значение:
//	Строка, имя поля контактной информации.
//
Функция ОпределитьПоТипуИмяПоляКонтактнойИнформации(ИмяТипа) Экспорт
	
	Если ИмяТипа = "Почтовый индекс" Тогда
		ИмяПоля = "Индекс";
	ИначеЕсли ИмяТипа = "Населенный пункт" Тогда
		ИмяПоля = "НаселенныйПункт";
	Иначе
		ИмяПоля = ИмяТипа;
	КонецЕсли;
	
	Возврат ИмяПоля;
	
КонецФункции

// Получает уникальный идентификатор объекта для выгрузки в XML.
//
// Параметры:
//	Объект - произвольный ссылочный тип
//	Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры
//
// Возвращаемое значение:
//	Строка, уникальный идентификатор объекта.
//
Функция СформироватьУникальныйИдентификаторОбъекта(Объект, Характеристика = Неопределено) Экспорт
	
	Ид = "";
	Попытка
		
		Ид = Строка(Объект.УникальныйИдентификатор());
		
		Если ТипЗнч(Объект) = Тип("СправочникСсылка.Номенклатура")
			И (НЕ Объект.ЭтоГруппа)
			И Объект.ИспользоватьХарактеристики
			И ЗначениеЗаполнено(Характеристика) Тогда
			
			Ид = Ид + "#" + Строка(Характеристика.УникальныйИдентификатор());
			
		КонецЕсли;
		
	Исключение
	КонецПопытки;
	
	Возврат Ид;
	
КонецФункции

// Получает ставку НДС по значению XML.
//
// Параметры:
//	ЗначениеНалога - строка
//	Организация - СправочникСсылка.Организации
// 
// Возвращаемое значение:
//	СправочникСсылка.СтавкиНДС.
//
Функция ПолучитьПоЗначениюДляВыгрузкиСтавкуНДС(ЗначениеНалога) Экспорт
	
	Ставка = 0;
	Расчетная = Ложь;
	НеОблагается = Ложь;
	
	Если ЗначениеНалога = "0" ИЛИ ЗначениеНалога = "0.00" Тогда
		Ставка = 0;
	ИначеЕсли ЗначениеНалога = "10" ИЛИ ЗначениеНалога = "10.00" Тогда
		Ставка = 10;
	ИначеЕсли ЗначениеНалога = "10/110" Тогда
		Ставка = 10;
		Расчетная = Истина;
	ИначеЕсли ЗначениеНалога = "18" ИЛИ ЗначениеНалога = "18.00" Тогда
		Ставка = 18;
	ИначеЕсли ЗначениеНалога = "18/118" Тогда
		Ставка = 18;
		Расчетная = Истина;
	ИначеЕсли ЗначениеНалога = "20" ИЛИ ЗначениеНалога = "20.00" Тогда
		Ставка = 20;
	ИначеЕсли ЗначениеНалога = "20/120" Тогда
		Ставка = 20;
		Расчетная = Истина;
	Иначе
		НеОблагается = Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.Ставка = &Ставка
	|	И СтавкиНДС.НеОблагается = &НеОблагается
	|	И СтавкиНДС.Расчетная = &Расчетная";
	
	Запрос.УстановитьПараметр("Ставка", Ставка);
	Запрос.УстановитьПараметр("НеОблагается", НеОблагается);
	Запрос.УстановитьПараметр("Расчетная", Расчетная);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		
		СтавкаНДС = Выборка.СтавкаНДС;
		
	Иначе
		
		НоваяСтавка = Справочники.СтавкиНДС.СоздатьЭлемент();
		НоваяСтавка.Наименование = ?(НеОблагается, "Без НДС", Строка(Ставка) + "%");
		НоваяСтавка.Ставка = Ставка;
		НоваяСтавка.НеОблагается = НеОблагается;
		НоваяСтавка.Записать();
		
		СтавкаНДС = НоваяСтавка.Ссылка;
		
	КонецЕсли;
	
	Возврат СтавкаНДС
	
КонецФункции

// Получает значение ставки НДС для выгрузки в XML.
//
// Параметры:
//	СтавкаНДС - Перечисления.СтавкиНДС
// 
// Возвращаемое значение:
//	Строка - значение ставки НДС.
//
Функция ПолучитьПоСтавкеНДСЗначениеДляВыгрузки(СтавкаНДС) Экспорт
	
	Если СтавкаНДС.НеОблагается Тогда 
		ЗначениеНалога = НСтр("ru = 'Без НДС'");
	ИначеЕсли СтавкаНДС.Ставка = 0 Тогда 
		ЗначениеНалога = "0";
	ИначеЕсли СтавкаНДС.Ставка = 10 Тогда 
		ЗначениеНалога = "10" + ?(СтавкаНДС.Расчетная, "/110", "");
	ИначеЕсли СтавкаНДС.Ставка = 18 Тогда 
		ЗначениеНалога = "18" + ?(СтавкаНДС.Расчетная, "/118", "");
	ИначеЕсли СтавкаНДС.Ставка = 20 Тогда 
		ЗначениеНалога = "20" + ?(СтавкаНДС.Расчетная, "/120", "");
	Иначе
		ЗначениеНалога = Строка(СтавкаНДС.Ставка);
	КонецЕсли;
	
	Возврат ЗначениеНалога;
	
КонецФункции

Функция ПолучитьПоСтавкеНДСЗначениеДляВыгрузкиЧисло(СтавкаНДС) Экспорт
	
	Возврат СтавкаНДС.Ставка;
	
КонецФункции

// Выполняет поиск вида скидки по наименованию и проценту скидки.
// Если вид скидки не найден, он создается.
//
Функция ПолучитьВидСкидкиНаДокумент(НаименованиеСкидки, Процент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыСкидокНаценок.Ссылка
	|ИЗ
	|	Справочник.ВидыСкидокНаценок КАК ВидыСкидокНаценок
	|ГДЕ
	|	ВидыСкидокНаценок.Наименование = &Наименование
	|	И ВидыСкидокНаценок.Процент = &Процент";
	
	Запрос.УстановитьПараметр("Наименование", СокрЛП(НаименованиеСкидки));
	Запрос.УстановитьПараметр("Процент", Процент);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		НоваяСкидка = Справочники.ВидыСкидокНаценок.СоздатьЭлемент();
		НоваяСкидка.Наименование = НаименованиеСкидки;
		НоваяСкидка.Процент = Процент;
		НоваяСкидка.Записать();
		
		ВидСкидки = НоваяСкидка.Ссылка;
		
	Иначе
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		ВидСкидки = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат ВидСкидки;
	
КонецФункции

// Получает предопределенный узел плана обмена
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена как оно задано в конфигураторе
// 
// Возвращаемое значение:
//  ЭтотУзел - ПланОбменаСсылка - предопределенный узел плана обмена
//
Функция ПолучитьЭтотУзелПланаОбмена(ИмяПланаОбмена) Экспорт
	
	Возврат ПланыОбмена[ИмяПланаОбмена].ЭтотУзел()
	
КонецФункции

// Определяет, является ли реквизит объекта строкой неограниченной длины
//
// Параметры:
//  ИмяОбъекта - Строка - имя объекта, например "Справочник.Номенклатура"
//  ИмяРеквизита - Строка - имя Реквизита, например "Комментарий"
// 
// Возвращаемое значение:
//  Истина - реквизит имеет тип Строка неограниченной длины, иначе Ложь
//
Функция ПроверитьНеограниченнаяСтрока(ИмяОбъекта, ИмяРеквизита) Экспорт
	
	ОписаниеТипаНеограниченнаяСтрока = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная));
	
	Если СтрНайти(ИмяОбъекта, "Справочник")<>0 Тогда
		ИмяСправочника = СтрЗаменить(ИмяОбъекта, "Справочник.", "");
		Если НоменклатураВДокументахКлиентСервер.ЕстьРеквизитОбъекта(ИмяРеквизита, Метаданные.Справочники[ИмяСправочника].Реквизиты) Тогда
			Возврат Метаданные.Справочники[ИмяСправочника].Реквизиты[ИмяРеквизита].Тип = ОписаниеТипаНеограниченнаяСтрока;
		ИначеЕсли НоменклатураВДокументахКлиентСервер.ЕстьРеквизитОбъекта(ИмяРеквизита, Метаданные.Справочники[ИмяСправочника].СтандартныеРеквизиты) Тогда
			Возврат Метаданные.Справочники[ИмяСправочника].СтандартныеРеквизиты[ИмяРеквизита].Тип = ОписаниеТипаНеограниченнаяСтрока;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли СтрНайти(ИмяОбъекта, "ПланВидовХарактеристик")<>0 Тогда
		ИмяПВХ = СтрЗаменить(ИмяОбъекта, "ПланВидовХарактеристик.", "");
		Если НоменклатураВДокументахКлиентСервер.ЕстьРеквизитОбъекта(ИмяРеквизита, Метаданные.ПланыВидовХарактеристик[ИмяПВХ].Реквизиты) Тогда
			Возврат Метаданные.ПланыВидовХарактеристик[ИмяПВХ].Реквизиты[ИмяРеквизита].Тип = ОписаниеТипаНеограниченнаяСтрока;
		ИначеЕсли НоменклатураВДокументахКлиентСервер.ЕстьРеквизитОбъекта(ИмяРеквизита, Метаданные.ПланыВидовХарактеристик[ИмяПВХ].СтандартныеРеквизиты) Тогда
			Возврат Метаданные.ПланыВидовХарактеристик[ИмяПВХ].СтандартныеРеквизиты[ИмяРеквизита].Тип = ОписаниеТипаНеограниченнаяСтрока;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Определяет, заказ пришел с сайта или был создан другим способом.
//
Функция ЭтоЗаказССайта(Заказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Заказ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыПокупателейССайта.НомерЗаказаНаСайте КАК НомерНаСайте
	|ИЗ
	|	РегистрСведений.ЗаказыПокупателейССайта КАК ЗаказыПокупателейССайта
	|ГДЕ
	|	ЗаказыПокупателейССайта.ЗаказПокупателя = &Заказ";
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции

// Определяет, отображать кнопку формы настройки сортировки или нет.
//
// Возвращаемое значение:
//  Булево - отображать форму настройки сортировки или нет
Функция ОтображатьКнопкуСортировкиНаФорме() Экспорт
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОбменУправлениеНебольшойФирмойСайт.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.ОбменУправлениеНебольшойФирмойСайт КАК ОбменУправлениеНебольшойФирмойСайт
	|ГДЕ
	|	ОбменУправлениеНебольшойФирмойСайт.ВыгружатьКартинки
	|	И НЕ ОбменУправлениеНебольшойФирмойСайт.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти
