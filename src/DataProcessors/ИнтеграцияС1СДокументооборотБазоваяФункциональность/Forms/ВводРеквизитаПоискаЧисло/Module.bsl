#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Заголовок;
	Значение = Параметры.Значение;
	ВидСравнения = ?(ЗначениеЗаполнено(Параметры.ОператорСравнения), Параметры.ОператорСравнения, ">=");
	Если ЗначениеЗаполнено(Параметры.ОператорСравнения2) Тогда
		ВидСравнения = "Между";
		Значение2 = Параметры.Значение2;
	КонецЕсли;
	
	Если ВидСравнения <> "="
			И ВидСравнения <> ">="
			И ВидСравнения <> "<="
			И ВидСравнения <> "Между" Тогда
		ВидСравнения = "=";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСравненияПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполнитьВыбор(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Искать(Команда)
	
	ВыполнитьВыбор(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.ЗначениеРавно.Видимость = (ВидСравнения = "=");
	Элементы.ЗначениеОт.Видимость = (ВидСравнения = ">=");
	Элементы.ЗначениеПо.Видимость = (ВидСравнения = "<=");
	Элементы.ГруппаМежду.Видимость = (ВидСравнения = "Между");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбор(НайтиСразу)
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", Значение);
	Если ВидСравнения = "Между" Тогда
		Если Значение2 < Значение Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Проверьте введенные значения: левое число меньше правого.'"));
			Возврат;
		КонецЕсли;
		Результат.Вставить("ОператорСравнения", ">=");
		Результат.Вставить("Значение2", Значение2);
		Результат.Вставить("ОператорСравнения2", "<=");
	Иначе
		Результат.Вставить("ОператорСравнения", ВидСравнения);
		Результат.Вставить("ОператорСравнения2", "");
	КонецЕсли;
	Результат.Вставить("НайтиСразу", НайтиСразу);
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти