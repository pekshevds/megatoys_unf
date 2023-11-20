///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ОбновитьПовторноИспользуемыеЗначения();
	Оповестить("ДобавлениеУдалениеСостоянияОригиналаПервичногоДокумента");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Параметры:
//  Команда - КомандаФормы
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;

	Если Команда.Имя = "НастройкаПорядкаЭлементовОбычное__Вниз" Или Команда.Имя = "НастройкаПорядкаЭлементовОбычное__Вверх" Тогда
		Если ТекущиеДанные.Ссылка = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана")
			Или ТекущиеДанные.Ссылка = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен") Тогда
			ПоказатьПредупреждение(,НСтр("ru='Начальное и конечное состояние перемещать нельзя.'"));
		Иначе

			Если Команда.Имя = "НастройкаПорядкаЭлементовОбычное__Вниз" Тогда
				Перемещать = ВозможностьПеремещения("Вниз",ТекущиеДанные.РеквизитДопУпорядочивания);
			ИначеЕсли Команда.Имя = "НастройкаПорядкаЭлементовОбычное__Вверх" Тогда
				Перемещать = ВозможностьПеремещения("Вверх",ТекущиеДанные.РеквизитДопУпорядочивания);
			КонецЕсли;

			Если Перемещать Тогда
				 ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
			Иначе
				ПоказатьПредупреждение(,НСтр("ru = 'Начальное и конечное состояние перемещать нельзя.'"));
			КонецЕсли;

		КонецЕсли;
	Иначе
		ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
 	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт

    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);

КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)

    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);

КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
//Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВозможностьПеремещения(Перемещение, НомерПорядка);

	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	              |	СостоянияОригиналовПервичныхДокументов.Ссылка КАК Ссылка
	              |ИЗ
	              |	Справочник.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	              |ГДЕ
	              |	СостоянияОригиналовПервичныхДокументов.РеквизитДопУпорядочивания > &НомерПорядка
	              |	И СостоянияОригиналовПервичныхДокументов.Ссылка <> ЗНАЧЕНИЕ(Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана)
	              |	И СостоянияОригиналовПервичныхДокументов.Ссылка <> ЗНАЧЕНИЕ(Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналыНеВсе)
	              |	И СостоянияОригиналовПервичныхДокументов.Ссылка <> ЗНАЧЕНИЕ(Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен)";

	Если Перемещение = "Вверх" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"> &НомерПорядка","< &НомерПорядка");
	КонецЕсли;

	Запрос.УстановитьПараметр("НомерПорядка", НомерПорядка);
	
	Выборка = Запрос.Выполнить();

	Если Не Выборка.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

#КонецОбласти
