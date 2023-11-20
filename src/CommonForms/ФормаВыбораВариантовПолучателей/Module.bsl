#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресВХранилище = Параметры.АдресВХранилище;
	Если НЕ ЭтоАдресВременногоХранилища(АдресВХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыСоответствие = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	СтрокиПервогоУровня = Варианты.ПолучитьЭлементы();
	Дерево = РеквизитФормыВЗначение("Варианты", Тип("ДеревоЗначений"));
	
	Контрагенты = Новый Массив;
	
	Для Каждого Соответствие Из ВариантыСоответствие Цикл
		
		Псевдоним = Соответствие.Ключ;
		
		СтрокаПервогоУровня = Дерево.Строки.Добавить();
		СтрокаПервогоУровня.ПредставлениеСтрокой = Псевдоним;
		МассивВариантов = Соответствие.Значение; 
		
		Для Каждого Вариант Из МассивВариантов Цикл
			
			Наименование = Вариант.Наименование;
			Адрес = Вариант.АдресЭП;
			
			СтрокаВторогоУровня = СтрокаПервогоУровня.Строки.Добавить();
			СтрокаВторогоУровня.КонтактCRM = Вариант.КонтактCRM;
			СтрокаВторогоУровня.ПредставлениеСтрокой = СтрШаблон("%1 <%2>",
				Наименование, Адрес);
			СтрокаВторогоУровня.ТипПолучателя = Вариант.ТипПолучателя;
			СтрокаВторогоУровня.Контакт = Вариант.Контакт;
			СтрокаВторогоУровня.АдресЭП = Вариант.АдресЭП;
			Контрагенты.Добавить(Вариант.КонтактCRM);
			
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "Варианты");
	
	ЗаполнитьКартинкиКонтактов(Контрагенты);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПометкаПриИзменении(Элемент)
	
	ИДТекущейСтроки = Элементы.Варианты.ТекущаяСтрока;
	ЭлементТаблицы = Варианты.НайтиПоИдентификатору(ИДТекущейСтроки);
	
	Строки = ЭлементТаблицы.ПолучитьЭлементы();
	Для Каждого Строка Из Строки Цикл
		Строка.Пометка = ЭлементТаблицы.Пометка;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Адрес = АдресТаблицыВыбранныхПолучателей();
	Закрыть(Адрес);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКартинкиКонтактов(Контрагенты)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка,
	|	Контрагенты.ВидКонтрагента
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка В(&Контрагенты)");
	
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	
	ВидыКонтрагентов = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВидыКонтрагентов[Выборка.Ссылка] = Выборка.ВидКонтрагента;
	КонецЦикла;
	
	Родители = Варианты.ПолучитьЭлементы();
	Для каждого Родитель Из Родители Цикл
		Строки = Родитель.ПолучитьЭлементы();
		Для Каждого Строка Из Строки Цикл
			Строка.ИндексКартинки = ЭлектроннаяПочтаУНФ.КартинкаУчастникаПоТипуКонтакта(Строка.КонтактCRM
				, ВидыКонтрагентов);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция АдресТаблицыВыбранныхПолучателей()
	
	ТаблицаАдресантов = Новый ТаблицаЗначений;
	ТаблицаАдресантов.Колонки.Добавить("ТипПолучателя",
	Новый ОписаниеТипов("ПеречислениеСсылка.ТипыПолучателейЭлектронногоПисьма"));
	ТаблицаАдресантов.Колонки.Добавить("КонтактCRM", 
	Новый ОписаниеТипов("СправочникСсылка.Контрагенты,СправочникСсылка.КонтактныеЛица,СправочникСсылка.Лиды,СправочникСсылка.КонтактыЛидов, СправочникСсылка.ФизическиеЛица"));
	ТаблицаАдресантов.Колонки.Добавить("Контакт", Новый ОписаниеТипов("СправочникСсылка.АдресатыПисем"));
	ТаблицаАдресантов.Колонки.Добавить("АдресЭП", Новый ОписаниеТипов("Строка"));
	
	Родители = Варианты.ПолучитьЭлементы();
	Для каждого Родитель Из Родители Цикл
		Строки = Родитель.ПолучитьЭлементы();
		Для Каждого Строка Из Строки Цикл
			Если Строка.Пометка Тогда 
				НоваяСтрока = ТаблицаАдресантов.Добавить();
				НоваяСтрока.КонтактCRM = Строка.КонтактCRM;
				НоваяСтрока.Контакт = Строка.Контакт;
				НоваяСтрока.ТипПолучателя = Строка.ТипПолучателя;
				НоваяСтрока.АдресЭП = Строка.АдресЭП;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(ТаблицаАдресантов); 
	Возврат АдресВХранилище;
	
КонецФункции

#КонецОбласти



