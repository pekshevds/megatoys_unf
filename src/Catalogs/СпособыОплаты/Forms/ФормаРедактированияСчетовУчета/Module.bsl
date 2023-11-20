
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчета = Параметры.СчетУчета;
	СчетЗатрат = Параметры.СчетЗатрат;
	
	Если ОтказИзменитьСчетУчета(Параметры.Ссылка) Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'В базе есть движения по этому эквайринговому терминалу: изменение счета учета запрещено.'");
		Элементы.Пояснение.Видимость = Истина;
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Параметры.Ссылка.Метаданные()) Тогда
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПереводыВПути");
	КонецЕсли;
	
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетЗатрат) Тогда
		СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПрочиеРасходы");
	КонецЕсли;
	
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПереводыВПути");
	СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПрочиеРасходы");
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета учета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.Ссылка,
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.НомерСтроки,
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.ЭквайринговыйТерминал,
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.ВидПлатежнойКарты,
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.НомерПлатежнойКарты,
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.Сумма
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах.БезналичнаяОплата КАК ОтчетОРозничныхПродажахОплатаПлатежнымиКартами
	|ГДЕ
	|	ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.Ссылка.Проведен = ИСТИНА
	|	И ОтчетОРозничныхПродажахОплатаПлатежнымиКартами.ЭквайринговыйТерминал = &ЭквайринговыйТерминал
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОперацияПоПлатежнымКартам.Ссылка,
	|	1,
	|	ОперацияПоПлатежнымКартам.ЭквайринговыйТерминал,
	|	ОперацияПоПлатежнымКартам.ВидПлатежнойКарты,
	|	ОперацияПоПлатежнымКартам.НомерПлатежнойКарты,
	|	ОперацияПоПлатежнымКартам.СуммаДокумента
	|ИЗ
	|	Документ.ОперацияПоПлатежнымКартам КАК ОперацияПоПлатежнымКартам
	|ГДЕ
	|	ОперацияПоПлатежнымКартам.Ссылка.Проведен = ИСТИНА
	|	И ОперацияПоПлатежнымКартам.ЭквайринговыйТерминал = &ЭквайринговыйТерминал");
	
	Запрос.УстановитьПараметр("ЭквайринговыйТерминал", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчета()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетовРасчетов()
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("СчетУчета", СчетУчета);
	СтруктураПараметры.Вставить("СчетЗатрат", СчетЗатрат);
	
	Оповестить("ИзменилсяСчетУчетаЭквайринговыеТерминалы", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти
