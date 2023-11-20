#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбменДаннымиСервер.ФормаНастройкиУзлаПриСозданииНаСервере(ЭтотОбъект, "АвтономнаяРабота");
	ОбменДаннымиУНФ.ПриСозданииНаСервереФормыУзла(ЭтотОбъект, Элементы);
	ОбменДаннымиУНФ.ОбновитьЗаголовкиКомандФормы(ЭтотОбъект, Элементы);
	
	Элементы.СинхронизироватьТокеныАвторизацииИСМП.Видимость = ПолучитьФункциональнуюОпцию(
		"ВестиУчетМаркируемойПродукцииИСМП");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбменДаннымиУНФКлиент.ОбновитьСвойстваЭлементовФормы(ЭтотОбъект, ЭтотОбъект, Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)

	ОбменДаннымиУНФКлиент.ОбновитьСвойстваЭлементовФормы(ЭтотОбъект, ЭтотОбъект, Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОрганизацииНажатие(Элемент)

	ПараметрыФормы = ОбменДаннымиУНФКлиентСервер.НовыеПараметрыФормыВыбораДополнительныхУсловий();
	ПараметрыФормы.ТаблицаВыбора = "Справочник.Организации";
	ПараметрыФормы.ТаблицаЗаполнения = "Организации";
	ПараметрыФормы.КолонкаЗаполнения = "Организация";
	ПараметрыФормы.ЗаголовокФормыВыбора = НСтр("ru = 'Организации'");
	ПараметрыФормы.АдресВыбранныхЗначений = АдресВыбранныхЗначений(ПараметрыФормы);

	ОткрытьФорму("ОбщаяФорма.НастройкаОтборовУзлаРИБ", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОрганизацииРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент,
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	ОбменДаннымиУНФКлиент.ВыбратьОрганизацииРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоСкладамПриИзменении(Элемент)

	ОбменДаннымиУНФКлиент.ОбновитьСвойстваЭлементовФормы(ЭтотОбъект, ЭтотОбъект, Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСкладыИМагазиныНажатие(Элемент)

	ПараметрыФормы = ОбменДаннымиУНФКлиентСервер.НовыеПараметрыФормыВыбораДополнительныхУсловий();
	ПараметрыФормы.ТаблицаВыбора = "Справочник.СтруктурныеЕдиницы";
	ПараметрыФормы.ТаблицаЗаполнения = "СкладыИМагазины";
	ПараметрыФормы.КолонкаЗаполнения = "СтруктурнаяЕдиница";
	ПараметрыФормы.ЗаголовокФормыВыбора = НСтр("ru = 'Склады и магазины'");
	ПараметрыФормы.АдресВыбранныхЗначений = АдресВыбранныхЗначений(ПараметрыФормы);
	ПараметрыФормы.УпорядочитьПоВозрастаниюИерархии = Истина;

	Фильтр = ОбменДаннымиУНФКлиентСервер.НовыйФильтрФормыВыбораДополнительныхУсловий();
	Фильтр.ИмяПараметра = "ТипСтруктурнойЕдиницы";
	Фильтр.ИмяПоля = "ТипСтруктурнойЕдиницы";
	Для Каждого ТипСтруктурнойЕдиницы Из ОбменДаннымиУНФКлиентСервер.ТипыСтруктурныхЕдиницСкладыИМагазины() Цикл
		Фильтр.ЗначениеПараметра.Добавить(ТипСтруктурнойЕдиницы);
	КонецЦикла;
	ПараметрыФормы.Фильтры.Добавить(Фильтр);

	ОткрытьФорму("ОбщаяФорма.НастройкаОтборовУзлаРИБ", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСкладыИМагазиныРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент,
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбменДаннымиУНФКлиент.ВыбратьСкладыИМагазиныРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьТокеныАвторизацииИСМППриИзменении(Элемент)

	ОбменДаннымиУНФКлиент.ОбновитьСвойстваЭлементовФормы(ЭтотОбъект, ЭтотОбъект, Элементы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)

	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресВыбранныхЗначений(Знач ПараметрыФормы)

	ДанныеФормыКоллекция = ЭтотОбъект[ПараметрыФормы.ТаблицаЗаполнения];
	ТаблицаЗначений = ДанныеФормыКоллекция.Выгрузить( , ПараметрыФормы.КолонкаЗаполнения);
	Результат = ПоместитьВоВременноеХранилище(ТаблицаЗначений, УникальныйИдентификатор);
	Возврат Результат;

КонецФункции

&НаСервере
Процедура ОбновитьДанныеОбъекта(ВыбранноеЗначение)

	ОбменДаннымиУНФ.ОбновитьДанныеОбъекта(ЭтотОбъект, ВыбранноеЗначение);
	ОбменДаннымиУНФ.ОбновитьЗаголовкиКомандФормы(ЭтотОбъект, Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт

	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти