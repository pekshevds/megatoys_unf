
#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КоличествоСимволовПослеЗапятой = 3;
	
	Количество = Параметры.Количество;
	Цена = Параметры.Цена;
	Сумма = Параметры.Сумма;
	ПроцентСкидкиНаценки = Параметры.ПроцентСкидкиНаценки;
	ПроцентАвтоматическойСкидки = Параметры.ПроцентАвтоматическойСкидки;
	НоменклатураХарактеристикаИПартия = Параметры.НоменклатураХарактеристикаИПартия;
	
	// Установка сочетания клавиш
	Для Сч = 0 По 9 Цикл
		Элементы["Кнопка"+Сч].СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша["Num"+Сч], Ложь, Истина, Ложь);
	КонецЦикла;
	Элементы.РазделительДробнойЧасти.СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша.NumDecimal);
	Элементы.Сбросить.СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша.BackSpace);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриИзменении элемента Количество формы.
//
&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	СуммаБезСкидки = Цена * Количество;
	
	// Скидки.
	Если СуммаБезСкидки <> 0 Тогда
		Если ПроцентСкидкиНаценки = 100 Тогда
			СуммаПослеПримененияРучныхСкидокНаценок = 0;
		ИначеЕсли ПроцентСкидкиНаценки <> 0 И Количество <> 0 Тогда
			СуммаПослеПримененияРучныхСкидокНаценок = СуммаБезСкидки * (1 - (ПроцентСкидкиНаценки) / 100);
		Иначе
			СуммаПослеПримененияРучныхСкидокНаценок = СуммаБезСкидки;
		КонецЕсли;
	Иначе
		СуммаПослеПримененияРучныхСкидокНаценок = СуммаБезСкидки;
	КонецЕсли;
	
	СуммаРучнойСкидки = СуммаБезСкидки - СуммаПослеПримененияРучныхСкидокНаценок;
	
	Если ПроцентАвтоматическойСкидки <> 0 Тогда
		СуммаАвтоматическойСкидки = СуммаБезСкидки * ПроцентАвтоматическойСкидки / 100;
	Иначе
		СуммаАвтоматическойСкидки = 0;
	КонецЕсли;
	СуммаСкидки = СуммаАвтоматическойСкидки + СуммаРучнойСкидки;
	
	Сумма = СуммаБезСкидки - ?(СуммаСкидки > СуммаБезСкидки, СуммаБезСкидки, СуммаСкидки);
	
КонецПроцедуры

// Процедура - обработчик события Очистка элемента Количество формы.
//
&НаКлиенте
Процедура КоличествоОчистка(Элемент, СтандартнаяОбработка)
	
	ВводимоеЧисло = "";
	ПервыйВвод = Ложь;
	Количество = 0;
	КоличествоПриИзменении(Элементы.Количество);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет цифру справа от введенного числа. Учитывается наличие разделителя дробной части.
//
&НаКлиенте
Процедура ДобавитьЦифру(ВведеннаяЦифраСтрокой)
	
	Если ПервыйВвод Тогда
		ВводимоеЧисло = "";
		ПервыйВвод = Ложь;
	КонецЕсли;
	
	Запятая = Сред(ВводимоеЧисло, СтрДлина(ВводимоеЧисло) - КоличествоСимволовПослеЗапятой, 1);
	
	Если НЕ Запятая = "," Тогда
		ВводимоеЧисло = ВводимоеЧисло + ВведеннаяЦифраСтрокой;
	КонецЕсли;
	
	Количество = ПривестиСтрокуКЧислу(ВводимоеЧисло, Истина);
	КоличествоПриИзменении(Элементы.Количество);
	
КонецПроцедуры

// Функция выполняет приведение строки к числу
// Параметры:
//  ЧислоСтрокой           - Строка - Строка приводимая к числу
//  ВозвращатьНеопределено - Булево - Если Истина и строка содержит некорректное значение, то возвращать Неопределено
//
// Возвращаемое значение:
//  Число
//
&НаКлиенте
Функция ПривестиСтрокуКЧислу(ЧислоСтрокой, ВозвращатьНеопределено = Ложь)
	
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеЧисла = ОписаниеТипаЧисла.ПривестиЗначение(ЧислоСтрокой);
	
	Если ВозвращатьНеопределено И (ЗначениеЧисла = 0) Тогда
		
		Стр = Строка(ЧислоСтрокой);
		Если Стр = "" Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Стр = СтрЗаменить(СокрЛП(Стр), "0", "");
		Если (Стр <> "") И (Стр <> ".") И (Стр <> ",") Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеЧисла;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область Калькулятор

// Процедура - обработчик команды РазделительДробнойЧасти формы.
//
&НаКлиенте
Процедура КомандаТочка(Команда)
	
	Если ПервыйВвод Тогда
		ВводимоеЧисло = "";
		ТекПервыйВвод = Ложь;
	КонецЕсли;
	
	Если ВводимоеЧисло = "" Тогда
		ВводимоеЧисло = "0";
	КонецЕсли;
	
	ЧислоВхождений = СтрЧислоВхождений(ВводимоеЧисло, ",");
	
	Если Не ЧислоВхождений > 0 Тогда
		ВводимоеЧисло = ВводимоеЧисло + ",";
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды Сбросить формы.
//
&НаКлиенте
Процедура КомандаСтереть(Команда)
	
	ВводимоеЧисло = "";
	ПервыйВвод = Ложь;
	Количество = 0;
	КоличествоПриИзменении(Элементы.Количество);
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка1 формы.
//
&НаКлиенте
Процедура Кнопка1(Команда)
	
	ДобавитьЦифру("1");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка2 формы.
//
&НаКлиенте
Процедура Кнопка2(Команда)
	
	ДобавитьЦифру("2");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка3 формы.
//
&НаКлиенте
Процедура Кнопка3(Команда)
	
	ДобавитьЦифру("3");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка4 формы.
//
&НаКлиенте
Процедура Кнопка4(Команда)
	
	ДобавитьЦифру("4");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка5 формы.
//
&НаКлиенте
Процедура Кнопка5(Команда)
	
	ДобавитьЦифру("5");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка6 формы.
//
&НаКлиенте
Процедура Кнопка6(Команда)
	
	ДобавитьЦифру("6");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка7 формы.
//
&НаКлиенте
Процедура Кнопка7(Команда)
	
	ДобавитьЦифру("7");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка8 формы.
//
&НаКлиенте
Процедура Кнопка8(Команда)
	
	ДобавитьЦифру("8");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка9 формы.
//
&НаКлиенте
Процедура Кнопка9(Команда)
	
	ДобавитьЦифру("9");
	
КонецПроцедуры

// Процедура - обработчик команды Кнопка0 формы.
//
&НаКлиенте
Процедура Кнопка0(Команда)
	
	ДобавитьЦифру("0");
	
КонецПроцедуры

#КонецОбласти

// Процедура - обработчик команды ОК формы.
//
&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура("Количество", Количество);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти