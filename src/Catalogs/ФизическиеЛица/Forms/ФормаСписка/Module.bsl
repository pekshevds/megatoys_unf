
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	УстановитьОтборНедействительные(ЭтотОбъект);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Группа Тогда
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормы"
			+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	УстановитьОтборНедействительные(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительные(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Форма.Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// 1. Недействительная номенклатура отображается серым
	НовоеУсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение 	= Истина;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти