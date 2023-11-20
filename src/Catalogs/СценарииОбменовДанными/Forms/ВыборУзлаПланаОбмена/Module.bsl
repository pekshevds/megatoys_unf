#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	ПрочитатьДеревоУзловОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекПараметры = УстановитьПараметрыФормы();
	Элементы.ДеревоУзловОбмена.ТекущаяСтрока = ТекПараметры.ТекущаяСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	ТекПараметры = УстановитьПараметрыФормы();
	Элементы.ДеревоУзловОбмена.ТекущаяСтрока = ТекПараметры.ТекущаяСтрока;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоУзлов

&НаКлиенте
Процедура ДеревоУзловОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПроизвестиВыборУзлов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Выбирает узел и передает выбранные значения в вызывающую форму.
&НаКлиенте
Процедура ВыбратьУзел(Команда)
	ПроизвестиВыборУзлов();
КонецПроцедуры

// Открывает форму узла, заданную в конфигурации.
&НаКлиенте
Процедура ИзменитьУзел(Команда)
	
	Узел = Элементы.ДеревоУзловОбмена.ТекущиеДанные.Ссылка;
	Если Узел <> Неопределено Тогда
		ПоказатьЗначение(,Узел);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаКод.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыборУзлов()
	
	Данные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если Данные <> Неопределено И Данные.Ссылка <> Неопределено Тогда
		ОповеститьОВыборе(Данные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДеревоУзловОбмена()
		
	Дерево = РеквизитФормыВЗначение("ДеревоУзловОбмена", Тип("ДеревоЗначений"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиТранспорта.Корреспондент КАК Ссылка,
		|	НастройкиТранспорта.Корреспондент.Код КАК Код,
		|	НастройкиТранспорта.Корреспондент.Наименование КАК Наименование,
		|	ТИПЗНАЧЕНИЯ(НастройкиТранспорта.Корреспондент) КАК ТипУзла
		|ИЗ
		|	РегистрСведений.НастройкиТранспортаОбменаДанными КАК НастройкиТранспорта
		|ГДЕ
		|	НастройкиТранспорта.ВидТранспортаСообщенийОбменаПоУмолчанию = &ВидТранспорта
		|	И НастройкиТранспорта.WSКонечнаяТочкаКорреспондента <> &ОбменСообщениямиПустаяСсылка
		|ИТОГИ ПО
		|	ТипУзла";
	
	Запрос.УстановитьПараметр("ВидТранспорта", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Запрос.УстановитьПараметр("ОбменСообщениямиПустаяСсылка", ПланыОбмена["ОбменСообщениями"].ПустаяСсылка());
	
	ВыборкаПоТипамУзлов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоТипамУзлов.Следующий() Цикл
		
		ПланОбмена = Метаданные.НайтиПоТипу(ВыборкаПоТипамУзлов.ТипУзла);
		
		СтрокаПланОбмена = Дерево.Строки.Добавить();
		СтрокаПланОбмена.Наименование = Строка(ПланОбмена);
		СтрокаПланОбмена.ИндексКартинки = 0;
		
		ВыборкаПоУзлам = ВыборкаПоТипамУзлов.Выбрать();
		
		Пока ВыборкаПоУзлам.Следующий() Цикл
			
			СтрокаУзел = СтрокаПланОбмена.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУзел, ВыборкаПоУзлам);
			СтрокаУзел.ИндексКартинки = 2;

		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,  "ДеревоУзловОбмена");
	
КонецПроцедуры

&НаСервере
Функция УстановитьПараметрыФормы()
	
	Результат = Новый Структура("ТекущаяСтрока");
		
	Если Параметры.НачальноеЗначениеВыбора <> Неопределено Тогда
		Результат.ТекущаяСтрока = ИдентификаторСтрокиПоУзлу(ДеревоУзловОбмена, Параметры.НачальноеЗначениеВыбора);	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИдентификаторСтрокиПоУзлу(Данные, Ссылка)
	Для Каждого ТекСтрока Из Данные.ПолучитьЭлементы() Цикл
		Если ТекСтрока.Ссылка = Ссылка Тогда
			Возврат ТекСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		Результат = ИдентификаторСтрокиПоУзлу(ТекСтрока, Ссылка);
		Если Результат <> Неопределено Тогда 
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

#КонецОбласти
