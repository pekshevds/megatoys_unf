

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Список, "Недействителен", Ложь, , , Истина);
	
	Если Параметры.Свойство("Подсистема") Тогда
		ТипПодсистемы = Параметры.Подсистема;
	Иначе
		ТипПодсистемы = 0;
		Элементы.ГруппаСущностиПоГрафику.Видимость = Ложь;
		Элементы.ОтборПоГрафику.Видимость = Ложь;
	КонецЕсли;
	
	Если ТипПодсистемы = 2 Тогда
		СущностиПоГрафику.ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СотрудникиСрезПоследних.ГрафикРаботы КАК ГрафикРаботы,
		|	СотрудникиСрезПоследних.Сотрудник КАК РесурсПредприятия
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			,
		|			НЕ Сотрудник.Недействителен
		|				И НЕ ГрафикРаботы = ЗНАЧЕНИЕ(Справочник.ГрафикиРаботы.ПустаяСсылка)) КАК СотрудникиСрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|	СотрудникиСрезПоследних.Сотрудник.Наименование";
		
		Элементы.СписокСотрудникиПоГрафикуРесурсПредприятия.Заголовок = НСтр("ru = 'Сотрудники по графику'");
		Элементы.ОтборПоГрафику.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоГрафикуПриИзменении(Элемент)
	
	УстановитьОтборПоГрафику();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СущностиПоГрафику, 
	"ГрафикРаботы",
	ТекущиеДанные.Ссылка,
	ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудникиПоГрафикуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СущностиПоГрафику.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.РесурсПредприятия) = Тип("СправочникСсылка.КлючевыеРесурсы") Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.РесурсПредприятия);
		ОткрытьФорму("Справочник.КлючевыеРесурсы.ФормаОбъекта",ПараметрыФормы);
	ИначеЕсли ТипЗнч(ТекущиеДанные.РесурсПредприятия) = Тип("СправочникСсылка.Сотрудники") Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.РесурсПредприятия);
		ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта",ПараметрыФормы);
	Иначе
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.РесурсПредприятия);
		ОткрытьФорму("Справочник.Бригады.ФормаОбъекта",ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительную(Команда)
	
	ПолеОтбора = Новый ПолеКомпоновкиДанных("Недействителен");
	НайденныйЭлемент = Неопределено;
	
	Для Каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных")
			Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеОтбора
			Тогда
			НайденныйЭлемент = ЭлементОтбора;
			Прервать
		КонецЕсли;
	КонецЦикла;
	
	Если НайденныйЭлемент = Неопределено
		Тогда
		Возврат;
	КонецЕсли;
	
	НовыйОтбор = НайденныйЭлемент;
	НовыйОтбор.Использование = Не НовыйОтбор.Использование;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоГрафику()
	
	Если ОтборПоГрафику = "Сотрудники" Тогда
		Элементы.СущностиПоГрафикуРесурсПредприятия.Заголовок = НСтр("ru = 'Сотрудники по графику'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СущностиПоГрафику, "ТипРесурса", 1);
	ИначеЕсли ОтборПоГрафику = "Бригады" Тогда
		Элементы.СущностиПоГрафикуРесурсПредприятия.Заголовок = НСтр("ru = 'Бригады по графику'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СущностиПоГрафику, "ТипРесурса", 2);
	ИначеЕсли ОтборПоГрафику = "Ресурсы" Тогда
		Элементы.СущностиПоГрафикуРесурсПредприятия.Заголовок = НСтр("ru = 'Ресурсы по графику'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СущностиПоГрафику, "ТипРесурса", 3);
	Иначе
		Элементы.СущностиПоГрафикуРесурсПредприятия.Заголовок = НСтр("ru = 'Все элементы по графику'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СущностиПоГрафику, "ТипРесурса", , , ,
			Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Список.Недействителен", Истина,
		ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "Наименование");
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста",
		ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти);

КонецПроцедуры

#КонецОбласти
