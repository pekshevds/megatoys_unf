
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текст запроса для поиска объектов по штрихкоду
//
// Параметры:
//  ФильтрПоиска - Структура - параметры определяющие состав таблиц и условий запроса
//
// Возвращаемое значение:
//  Строка - текст запроса.
//
Функция ТекстЗапросаШтрихкодыБазы(ФильтрПоиска = Неопределено) Экспорт
	
	Если ФильтрПоиска = Неопределено Тогда
		ФильтрПоиска = Новый Структура;
	КонецЕсли;
	
	ТекстОбъединитьВсе = 
	"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|";
	
	МодульШК = РаботаСоШтрихкодамиПереопределяемый;
	МассивЗапросов = Новый Массив;
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаШтрихкоды(ФильтрПоиска, МассивЗапросов);
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаШтрихкодыУпаковокТоваров(ФильтрПоиска, МассивЗапросов);
	
	Если ФильтрПоиска.Свойство("ЭтоКодМаркировки") Тогда
		ТекстЗапроса = СтрСоединить(МассивЗапросов, ТекстОбъединитьВсе);
		Возврат ТекстЗапроса;
	КонецЕсли;
	
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаКодыSKU(ФильтрПоиска, МассивЗапросов);
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаСерии(ФильтрПоиска, МассивЗапросов);
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаНоменклатурнойКлассификации(ФильтрПоиска, МассивЗапросов);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда	
		Если ФильтрПоиска.Свойство("ШаблонНомерТелефона") ИЛИ ФильтрПоиска.Количество() = 0 Тогда
			ДобавитьТекстЗапросаОбъектыПоТелефону(МассивЗапросов, ФильтрПоиска);
		КонецЕсли;
		Если ФильтрПоиска.Свойство("ШаблонАдресЭП") ИЛИ ФильтрПоиска.Количество() = 0  Тогда
			ДобавитьТекстЗапросаОбъектыПоАдресуЭП(МассивЗапросов, ФильтрПоиска);
		КонецЕсли;
	КонецЕсли;
	
	Если ФильтрПоиска.Свойство("ШаблонНомерТелефона") Тогда
		РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаПоТелефону(ФильтрПоиска, МассивЗапросов);
		Если ФильтрПоиска.Свойство("ДобавлятьНеизвестнуюКИ") Тогда
			ДобавитьТекстЗапросаВМассив(ТекстЗапросаТелефонПоШаблону(), МассивЗапросов);
		КонецЕсли;
	КонецЕсли;
	
	Если ФильтрПоиска.Свойство("ШаблонАдресЭП") Тогда
		РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаПоАдресуЭП(ФильтрПоиска, МассивЗапросов);
		Если ФильтрПоиска.Свойство("ДобавлятьНеизвестнуюКИ") Тогда
			ДобавитьТекстЗапросаВМассив(ТекстЗапросаАдресЭППоШаблону(), МассивЗапросов);
		КонецЕсли;
	КонецЕсли;
	
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаШаблоныРегистрацииКарт(ФильтрПоиска, МассивЗапросов);
	РаботаСоШтрихкодамиПереопределяемый.ДобавитьТекстЗапросаДополнительныеОбъекты(ФильтрПоиска, МассивЗапросов);
	
	ТекстЗапроса = СтрСоединить(МассивЗапросов, ТекстОбъединитьВсе);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает структуру данных поиска по штрихкоду
//
// Параметры:
//  Штрихкод - Строка - штрихкод для поиска
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызван поиск
//
// Возвращаемое значение:
//  Структура - данные поиска.
//
Функция ДанныеПоискаПоШтрихкоду(Штрихкод, Форма) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыСобытийПО") Тогда
		Если Форма.ПараметрыСобытийПО = Неопределено Тогда
			СтруктураДействий = Новый Структура;
		Иначе
			СтруктураДействий = Форма.ПараметрыСобытийПО;
		КонецЕсли;
	Иначе
		СтруктураДействий = Новый Структура;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ФильтрПоискаПоШтрихкоду") Тогда
		Если Форма.ФильтрПоискаПоШтрихкоду = Неопределено Тогда
			ФильтрПоискаПоШтрихкоду = Новый Структура;
			РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьФильтрПоискаПоУмолчанию(ФильтрПоискаПоШтрихкоду);
		Иначе
			ФильтрПоискаПоШтрихкоду = Форма.ФильтрПоискаПоШтрихкоду;
		КонецЕсли;
	Иначе
		ФильтрПоискаПоШтрихкоду = Новый Структура;
		РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьФильтрПоискаПоУмолчанию(ФильтрПоискаПоШтрихкоду);
	КонецЕсли;
	
	СуффиксСерверЛояльности = "";
	Если ФильтрПоискаПоШтрихкоду.Свойство("ДанныеПокупателя") Тогда
		СуффиксСерверЛояльности = "СЛ";
		ФильтрПоискаПоШтрихкоду.Удалить("ДанныеПокупателя");
	КонецЕсли;
	
	Запрос = Новый Запрос();
	
	ЭтоКодМаркировки = Ложь;
	ДанныеМаркировки = Неопределено;
	ДанныеРазбораКода = Неопределено;
	ШтрихкодПоиска = Штрихкод;
	ШтрихкодМарки = Штрихкод;
	НомерТелефона = "";
	АдресЭП = "";
	КИПоШтрихкоду = ТипКонтактнойИнформацияПоШтрихкоду(Штрихкод);
	Если КИПоШтрихкоду.Свойство("НомерТелефона", НомерТелефона) Тогда
		ФильтрПоискаПоШтрихкоду.Вставить(СтрШаблон("ШаблонНомерТелефона%1", СуффиксСерверЛояльности));
	КонецЕсли;
	Если КИПоШтрихкоду.Свойство("АдресЭП", АдресЭП) Тогда
		ФильтрПоискаПоШтрихкоду.Вставить(СтрШаблон("ШаблонАдресЭП%1", СуффиксСерверЛояльности));
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("РегистрацияНовойКарты") Тогда
		ФильтрПоискаПоШтрихкоду.Вставить("РегистрацияНовойКарты");
	КонецЕсли;
	
	ДобавлятьНеизвестнуюКИ = Ложь;
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьПризнакВводаНеизвестнойКИ(Форма, ДобавлятьНеизвестнуюКИ);
	Если ДобавлятьНеизвестнуюКИ Тогда
		ФильтрПоискаПоШтрихкоду.Вставить("ДобавлятьНеизвестнуюКИ");
	КонецЕсли;
	
	Если ФильтрПоискаПоШтрихкоду.Свойство("Номенклатура") Тогда
		Если НЕ ФильтрПоискаПоШтрихкоду.Свойство("ШаблонНомерТелефона")
			И НЕ ФильтрПоискаПоШтрихкоду.Свойство("ШаблонАдресЭП") Тогда
			
			КодИКоличествоВесовогоТовара = Неопределено;
			РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьКодИКоличествоВесовогоТовара(Штрихкод, КодИКоличествоВесовогоТовара);
			
			Если НЕ КодИКоличествоВесовогоТовара = Неопределено Тогда
				ФильтрПоискаПоШтрихкоду.Вставить("ШаблонКодТовараSKU");
				Запрос.УстановитьПараметр("КодТовара", КодИКоличествоВесовогоТовара.КодТовара);
				Запрос.УстановитьПараметр("КоличествоТовара", КодИКоличествоВесовогоТовара.КоличествоТовара);
			КонецЕсли;
			
			Если НЕ ФильтрПоискаПоШтрихкоду.Свойство("ШаблонКодТовараSKU") Тогда
				ДанныеМаркировки = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара(Штрихкод);
				ЭтоКодМаркировки = ЭтоШтрихкодМарки(ДанныеМаркировки);
				Если ЭтоКодМаркировки Тогда
					Если НЕ ДанныеМаркировки.EAN = Неопределено Тогда
						ШтрихкодПоиска = ДанныеМаркировки.EAN;
						ШтрихкодМарки = ДанныеМаркировки.EAN;
					КонецЕсли;
					ФильтрПоискаПоШтрихкоду.Вставить("ЭтоКодМаркировки");
					
					СимволGS1 = МенеджерОборудованияМаркировкаКлиентСервер.РазделительGS1();
					Разделитель = МенеджерОборудованияМаркировкаКлиентСервер.ЭкранированныйСимволGS1();
					КодМаркировкиОригинал = СтрЗаменить(Штрихкод, Разделитель, СимволGS1);
					ДанныеРазбораКода = РазборКодаМаркировкиИССлужебный.РазобратьКодМаркировки(КодМаркировкиОригинал);
					Если НЕ ДанныеРазбораКода = Неопределено Тогда
						ШтрихкодМарки = ДанныеРазбораКода.НормализованныйКодМаркировки;
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаШтрихкодыБазы(ФильтрПоискаПоШтрихкоду);
	
	ТекстЗапросаВыборки = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ШтрихкодыВсе.Штрихкод КАК Штрихкод,
	|	ШтрихкодыВсе.Владелец КАК Владелец,
	|	ШтрихкодыВсе.Характеристика КАК Характеристика,
	|	ШтрихкодыВсе.Упаковка КАК Упаковка,
	|	ШтрихкодыВсе.Серия КАК СерияНоменклатуры,
	|	ШтрихкодыВсе.Партия КАК Партия,
	|	ТИПЗНАЧЕНИЯ(ШтрихкодыВсе.Владелец) КАК ТипОбъекта,
	|	ШтрихкодыВсе.ШаблонШтрихкода КАК ШаблонШтрихкода,
	|	0 КАК НомерСтроки,
	|	ШтрихкодыВсе.Количество КАК Количество
	|ИЗ
	|	ШтрихкодыВсе КАК ШтрихкодыВсе";
	
	ТекстЗапроса = ТекстЗапроса +
	"
	|; 
	|////////////////////////////////////////////////////////////////////////////////
	|" + ТекстЗапросаВыборки;
	
	Запрос.Текст = ТекстЗапроса;
	
	ПараметрНомерТелефона = ОбщегоНазначенияРМК.ПолучитьОбратныйНомерТелефонаБезКодаСтраны(НомерТелефона);
	РаботаСоШтрихкодамиПереопределяемый.ПодготовитьНомерТелефонаДляПоиска(ПараметрНомерТелефона, НомерТелефона);
	Запрос.УстановитьПараметр("Штрихкод", ШтрихкодПоиска);
	Запрос.УстановитьПараметр("ШтрихкодМарки", ШтрихкодМарки);
	Запрос.УстановитьПараметр("ДлинаШтрихкода", СтрДлина(ШтрихкодПоиска));
	Запрос.УстановитьПараметр("НомерТелефона", ПараметрНомерТелефона);
	Запрос.УстановитьПараметр("ШтрихкодИнверсия", ПолучитьИнверсиюСтроки(ШтрихкодПоиска));
	Запрос.УстановитьПараметр("АдресЭП", АдресЭП);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ФильтрПоискаПоШтрихкоду", ФильтрПоискаПоШтрихкоду);
	ДополнительныеПараметры.Вставить("ШтрихкодОригинал", Штрихкод);
	ДополнительныеПараметры.Вставить("ШтрихкодПоиска", ШтрихкодПоиска);
	ДополнительныеПараметры.Вставить("ШтрихкодМарки", ШтрихкодМарки);
	ДополнительныеПараметры.Вставить("ДанныеМаркировки", ДанныеМаркировки);
	ДополнительныеПараметры.Вставить("ДанныеРазбораКода", ДанныеРазбораКода);
	ДополнительныеПараметры.Вставить("ЭтоКодМаркировки", ЭтоКодМаркировки);
	
	РаботаСоШтрихкодамиПереопределяемый.ДополнитьПараметрыЗапросаПоиска(Запрос, Форма, ДополнительныеПараметры);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НеизвестныеДанныеПО = Истина;
	
	СтруктураПараметров = СтруктураДанныхПоиска();
	ДополнитьСтруктуруРезультатамиПоиска(СтруктураПараметров, Выборка, Штрихкод, "", НеизвестныеДанныеПО);
	СтруктураПараметров.ПараметрыШтрихкода = ДополнительныеПараметры;
	СтруктураПараметров.Вставить("ФормаВызова", Форма);
	
	РаботаСоШтрихкодамиПереопределяемый.СкорректироватьСтруктуруРезультата(
			СтруктураПараметров,
			Штрихкод,
			СтруктураДействий,
			НеизвестныеДанныеПО,
			Истина);
	СтруктураПараметров.Удалить("ФормаВызова");
	
	НайденоОбъектов = СтруктураПараметров.ЗначенияПоиска.Количество();
	Если НайденоОбъектов > 1 Тогда
		СтруктураПараметров.Вставить("ИспользоватьНовыйАлгоритмПоискаПоШтрихкоду");
	КонецЕсли;
	
	СтруктураПараметров.НеизвестныеДанныеПО = НеизвестныеДанныеПО;
	
	Позиция = НайтиНедопустимыеСимволыXML(Штрихкод);
	Если Позиция > 0 Тогда
		Штрихкод = Лев(Штрихкод, Позиция - 1);
	КонецЕсли;
	
	СтруктураПараметров.ДанныеПО = Штрихкод;
	СтруктураПараметров.ТипДанныхПО = "Штрихкод";
	СтруктураПараметров.ПараметрыШтрихкода = ДополнительныеПараметры;
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьТекстЗапросаОбъектыПоТелефону(МассивЗапросов, ФильтрПоискаПоШтрихкоду)
	
	СУсловиемПоиска = ФильтрПоискаПоШтрихкоду.Количество() > 0;
	
	МассивСправочниковСКИ = Новый Массив;
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьМассивСправочниковСКИ(МассивСправочниковСКИ, ФильтрПоискаПоШтрихкоду);
	
	Для Каждого СтрокаМассива Из МассивСправочниковСКИ Цикл
		
		Если СУсловиемПоиска И НЕ ФильтрПоискаПоШтрихкоду.Свойство(СтрокаМассива) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаКИ = "ВЫБРАТЬ
		|	КонтактнаяИнформация.НомерТелефона,
		|	КонтактнаяИнформация.Ссылка,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	ЗНАЧЕНИЕ(Перечисление.ШаблоныШтрихкодов.Телефон)
		|ИЗ
		|	&ТаблицаКИ КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Тип = Значение(Перечисление.ТипыКонтактнойИнформации.Телефон) И &Условие";
		
		ТекстЗапросаКИ = СтрЗаменить(ТекстЗапросаКИ, "&ТаблицаКИ" , "Справочник." + СтрокаМассива + ".КонтактнаяИнформация");
		ТекстЗапросаКИ = СтрЗаменить(ТекстЗапросаКИ, "И &Условие", 
			?(СУсловиемПоиска, "И КонтактнаяИнформация.НомерТелефона = &НомерТелефона", ""));
		МассивЗапросов.Добавить(ТекстЗапросаКИ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьТекстЗапросаОбъектыПоАдресуЭП(МассивЗапросов, ФильтрПоискаПоШтрихкоду)
	
	СУсловиемПоиска = ФильтрПоискаПоШтрихкоду.Количество() > 0;

	МассивСправочниковСКИ = Новый Массив;
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьМассивСправочниковСКИ(МассивСправочниковСКИ, ФильтрПоискаПоШтрихкоду);
	
	Для Каждого СтрокаМассива Из МассивСправочниковСКИ Цикл
		
		Если СУсловиемПоиска И НЕ ФильтрПоискаПоШтрихкоду.Свойство(СтрокаМассива) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаКИ = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Представление,
		|	КонтактнаяИнформация.Ссылка,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	ЗНАЧЕНИЕ(Перечисление.ШаблоныШтрихкодов.АдресЭП)
		|ИЗ
		|	&ТаблицаКИ КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Тип = Значение(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты) И &Условие";
		
		ТекстЗапросаКИ = СтрЗаменить(ТекстЗапросаКИ, "&ТаблицаКИ" , "Справочник." + СтрокаМассива + ".КонтактнаяИнформация");
		ТекстЗапросаКИ = СтрЗаменить(ТекстЗапросаКИ, "И &Условие", 
			?(СУсловиемПоиска, "И КонтактнаяИнформация.АдресЭП = &АдресЭП", ""));
		МассивЗапросов.Добавить(ТекстЗапросаКИ);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапросаТелефонПоШаблону()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&НомерТелефона,
	|	НЕОПРЕДЕЛЕНО,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ЗНАЧЕНИЕ(Перечисление.ШаблоныШтрихкодов.Телефон)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаАдресЭППоШаблону()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&АдресЭП,
	|	НЕОПРЕДЕЛЕНО,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ЗНАЧЕНИЕ(Перечисление.ШаблоныШтрихкодов.АдресЭП)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ДобавитьТекстЗапросаВМассив(ТекстЗапроса, МассивЗапросов)
	
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		МассивЗапросов.Добавить(ТекстЗапроса);
	КонецЕсли;
	
КонецПроцедуры

Функция ТипКонтактнойИнформацияПоШтрихкоду(Штрихкод)
	
	НомерТелефона = СокрЛП(Штрихкод);
	НомерТелефона = СтрЗаменить(НомерТелефона, "(", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, ")", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "-", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, " ", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "+", "");
	
	СтруктураКИ = Новый Структура;
	
	Если ЭтоСтрокаНомераТелефона(НомерТелефона) Тогда
		
		СтруктураКИ.Вставить("НомерТелефона", НомерТелефона);
		Возврат СтруктураКИ;
		
	КонецЕсли;
	
	АдресЭП = Штрихкод;
	
	Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭП) Тогда
		
		СтруктураКИ.Вставить("АдресЭП", АдресЭП);
		Возврат СтруктураКИ;
		
	КонецЕсли;
	
	Возврат СтруктураКИ;
	
КонецФункции

Процедура ДополнитьСтруктуруРезультатамиПоиска(
	СтруктураПараметров,
	Выборка,
	Знач Штрихкод = "",
	МагнитныйКод = "",
	НеизвестныеДанныеПО = Ложь)
	
	Если Не ПустаяСтрока(Штрихкод) Тогда
		Позиция = НайтиНедопустимыеСимволыXML(Штрихкод);
		Если Позиция > 0 Тогда
			Штрихкод = Лев(Штрихкод, Позиция - 1);
		КонецЕсли;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		
		Если ОбщегоНазначения.ЗначениеСсылочногоТипа(Выборка.Владелец) Тогда
			Если Не ОбщегоНазначения.СсылкаСуществует(Выборка.Владелец) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НеизвестныеДанныеПО = Ложь;
		
		СтруктураШтрихкода = НачатьСтруктуруРезультатовПоиска(СтруктураПараметров, Выборка, Штрихкод, МагнитныйКод);
		
		ЗаполнитьЗначенияСвойств(СтруктураШтрихкода, Выборка, , "Штрихкод");
		
		ДополнительныеДанные = Новый Структура;
		РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьДополнительныеДанныеОбъектовВыборки(ДополнительныеДанные, Выборка);
		СтруктураШтрихкода.Вставить("ДополнительныеДанные", ДополнительныеДанные);
		
		Для Каждого ДополнительныйПараметр Из ДополнительныеДанные Цикл
			СтруктураШтрихкода.Вставить(ДополнительныйПараметр.Ключ, ДополнительныйПараметр.Значение);
		КонецЦикла;
		
		СтруктураПараметров.ЗначенияПоиска.Добавить(СтруктураШтрихкода);
		
	КонецЦикла;
	
КонецПроцедуры

Функция НачатьСтруктуруРезультатовПоиска(
	СтруктураПараметров,
	Выборка,
	Штрихкод,
	МагнитныйКод)
	
	СтруктураШтрихкода = Новый Структура;
	Если ЗначениеЗаполнено(СтруктураПараметров.ДанныеПО) Тогда
		СтруктураШтрихкода.Вставить("ДанныеПО", СтруктураПараметров.ДанныеПО);
	ИначеЕсли ЗначениеЗаполнено(Штрихкод) Тогда
		СтруктураШтрихкода.Вставить("ДанныеПО", Штрихкод);
	Иначе
		СтруктураШтрихкода.Вставить("ДанныеПО", МагнитныйКод);
	КонецЕсли;
	СтруктураШтрихкода.Вставить("НомерСтрокиЗагрузки", Выборка.НомерСтроки);
	СтруктураШтрихкода.Вставить("Штрихкод", Штрихкод);
	СтруктураШтрихкода.Вставить("МагнитныйКод", МагнитныйКод);
	СтруктураШтрихкода.Вставить("Количество", Выборка.Количество);
	
	СтруктураШтрихкода.Вставить("Владелец");
	СтруктураШтрихкода.Вставить("ТипОбъекта");
	СтруктураШтрихкода.Вставить("ШаблонШтрихкода");
	СтруктураШтрихкода.Вставить("Характеристика");
	СтруктураШтрихкода.Вставить("Упаковка");
	СтруктураШтрихкода.Вставить("СерияНоменклатуры");

	
	Возврат СтруктураШтрихкода;
	
КонецФункции

// Формирует предопределенную структуру,
// Которая используется при поиске по ШК.
//
// Возвращаемое значение:
//  Структура - структура данных поиска.
//
Функция СтруктураДанныхПоиска()
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ЗначенияПоиска", Новый Массив);
	СтруктураПараметров.Вставить("НеизвестныеДанныеПО", Истина);
	СтруктураПараметров.Вставить("ДанныеПО", "");
	СтруктураПараметров.Вставить("ТипДанныхПО", "Штрихкод");
	СтруктураПараметров.Вставить("ПараметрыШтрихкода", Новый Структура);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция ЭтоШтрихкодМарки(ДанныеМаркировки)
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеМаркировки, "ТипИдентификатораТовара") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТипИдентификатораТовара = ДанныеМаркировки.ТипИдентификатораТовара;
	
	ТипыИдентификаторов = Перечисления.ТипыИдентификаторовТовараККТ;
	
	Возврат (ТипИдентификатораТовара = ТипыИдентификаторов.ИзделияИзНатуральногоМеха 
		ИЛИ ТипИдентификатораТовара = ТипыИдентификаторов.КодТовараВФорматеDataMatrixGS1
		ИЛИ ТипИдентификатораТовара = ТипыИдентификаторов.КодТовараВФорматеЕГАИС2
		ИЛИ ТипИдентификатораТовара = ТипыИдентификаторов.КодТовараВФорматеЕГАИС3);
	
КонецФункции

Функция ЭтоСтрокаНомераТелефона(НомерТелефона)
	
	ДлинаНомераБезКодаСтраны = 10;
	РезультатФункции = ((СтрДлина(НомерТелефона) = ДлинаНомераБезКодаСтраны + 1
			И (Лев(НомерТелефона, 1) = "7" Или Лев(НомерТелефона, 1) = "8"))
		Или СтрДлина(НомерТелефона) = ДлинаНомераБезКодаСтраны)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерТелефона);
		
	Возврат РезультатФункции;
	
КонецФункции

Функция ПолучитьИнверсиюСтроки(ИсходнаяСтрока)
	
	НоваяСтрока = "";
	
	ДлинаИсходногоТекста = СтрДлина(ИсходнаяСтрока);
	Пока ДлинаИсходногоТекста > 0 Цикл
		НоваяСтрока = НоваяСтрока + Сред(ИсходнаяСтрока, ДлинаИсходногоТекста, 1);
		ДлинаИсходногоТекста = ДлинаИсходногоТекста - 1;
	КонецЦикла;
	
	Возврат НоваяСтрока;
	
КонецФункции

#КонецОбласти
