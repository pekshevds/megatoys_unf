#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидПродукции = Параметры.ВидПродукции;
	РежимВыбора  = Параметры.РежимВыбора;
	
	Параметры.Свойство("ВозвращатьСсылкуНаЭлементКлассификатора", ВозвращатьСсылкуНаЭлементКлассификатора);
	Если ТипЗнч(Параметры.ОКПД2) <> Тип("Строка")
		И ЗначениеЗаполнено(Параметры.ОКПД2)
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры.ОКПД2, "Код") Тогда
		ОКПД2 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ОКПД2, "Код");
	Иначе
		ОКПД2 = Строка(Параметры.ОКПД2);
	КонецЕсли;
	
	ТекущийКодТНВЭД = Неопределено;
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		ТекущийКодТНВЭД = Параметры.ТекущаяСтрока;
		Если ТипЗнч(ТекущийКодТНВЭД) <> Тип("Строка") И ЗначениеЗаполнено(ТекущийКодТНВЭД)
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущийКодТНВЭД, "Код") Тогда
			ТекущийКодТНВЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийКодТНВЭД, "Код");
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокТНВЭД();
	ЗаполнитьСписокЗЕРНО();
	
	Если ТекущийКодТНВЭД <> Неопределено Тогда
		УстановитьТекущуюСтроку(ТекущийКодТНВЭД);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, "Список", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(Значение, "Список", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗЕРНО

&НаКлиенте
Процедура СписокЗЕРНОВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, "СписокЗЕРНО", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗЕРНОВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(Значение, "СписокЗЕРНО", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	
	ТекущиеДанные = Элементы.СписокЗЕРНО.ТекущиеДанные;
	ОбработкаВыбораЗначенияСписка(ТекущиеДанные, "СписокЗЕРНО", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзСправочника(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ОбработкаВыбораЗначенияСписка(ТекущиеДанные, "Список", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	
	ОписаниеПриЗавершении = Новый ОписаниеОповещения("Подключаемый_ПриЗавершенииОперации", ЭтотОбъект);
	
	ПараметрыОбработкиСообщений = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
	ПараметрыОбработкиСообщений.Ссылка = ПредопределенноеЗначение("Перечисление.ВидыКлассификаторовЗЕРНО.ТНВЭД");
	
	ИнтеграцияЗЕРНОКлиент.ПодготовитьКПередаче(
		ЭтотОбъект,
		ПараметрыОбработкиСообщений,
		ОписаниеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, ИмяСписка, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы[ИмяСписка], Истина) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("ДанныеФормыСтруктура")
		Или ТипЗнч(ВыбраннаяСтрока) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ДанныеСтроки = ВыбраннаяСтрока;
	Иначе
		ДанныеСтроки = Элементы[ИмяСписка].ДанныеСтроки(ВыбраннаяСтрока);
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не ДанныеСтроки.Сопоставлено Или ВозвращатьСсылкуНаЭлементКлассификатора Тогда
			Результат = ОбработкаВыбораЗначенияИзСпискаНаСервере(ДанныеСтроки.Код, ДанныеСтроки.НаименованиеПолное);
		КонецЕсли;
		
		Если ВозвращатьСсылкуНаЭлементКлассификатора Тогда
			ВыбранноеЗначение = Результат;
		Иначе
			ВыбранноеЗначение = ДанныеСтроки.Код;
		КонецЕсли;
		ОповеститьОВыборе(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаВыбораЗначенияИзСпискаНаСервере(ТНВЭД, Наименование)
	
	Результат = ИнтеграцияЗЕРНО.ПолучитьДанныеСопоставленногоКлассификатораТНВЭД(ТНВЭД, Наименование);
	Возврат Результат;
	
КонецФункции

#Область ЗагруженныеКодыТНВЭД

&НаСервере
Функция ТекстЗапросаСписокТНВЭД()
	
	ТекстЗапроса = ИнтеграцияЗЕРНО.ОпределитьТекстЗапросаКлассификатораТНВЭД();
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблица.Ссылка             КАК Ссылка,
	|	ВременнаяТаблица.Код                КАК Код,
	|	ВЫРАЗИТЬ(ВременнаяТаблица.НаименованиеПолное КАК СТРОКА(255)) КАК НаименованиеПолное,
	|	КлассификаторНСИЗЕРНО.ВидПродукции  КАК ВидПродукции,
	|	1                                   КАК Сопоставлено
	|
	|ИЗ
	|	РегистрСведений.ВидыСельскохозяйственныхКультурЗЕРНО КАК ВидыСельскохозяйственныхКультурЗЕРНО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО ВременнаяТаблица.Код = ВидыСельскохозяйственныхКультурЗЕРНО.КодТНВЭД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторНСИЗЕРНО КАК КлассификаторНСИЗЕРНО
	|		ПО ВидыСельскохозяйственныхКультурЗЕРНО.ОКПД2 = КлассификаторНСИЗЕРНО.Идентификатор
	|		И КлассификаторНСИЗЕРНО.ВидКлассификатора = ЗНАЧЕНИЕ(Перечисление.ВидыКлассификаторовЗЕРНО.ОКПД2)
	|
	|ГДЕ
	|	(КлассификаторНСИЗЕРНО.ВидПродукции = &ВидПродукции Или &БезОтбораПоВидуПродукции)
	|	И (ВидыСельскохозяйственныхКультурЗЕРНО.ОКПД2 = &ОКПД2 Или &БезОтбораОКПД2)
	|	И (ВидыСельскохозяйственныхКультурЗЕРНО.ДействуетПо >= &Дата
	|		ИЛИ ВидыСельскохозяйственныхКультурЗЕРНО.ДействуетПо = ДатаВремя(1,1,1))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблица.Ссылка,
	|	ВременнаяТаблица.Код,
	|	ВЫРАЗИТЬ(ВременнаяТаблица.НаименованиеПолное КАК СТРОКА(255)),
	|	КлассификаторНСИЗЕРНО.ВидПродукции";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокТНВЭД()
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = ТекстЗапросаСписокТНВЭД();
	
	Запрос.УстановитьПараметр("ВидПродукции",            ВидПродукции);
	Запрос.УстановитьПараметр("БезОтбораПоВидуПродукции", Не ЗначениеЗаполнено(ВидПродукции));
	
	Запрос.УстановитьПараметр("ОКПД2",          ОКПД2);
	Запрос.УстановитьПараметр("БезОтбораОКПД2", Не ЗначениеЗаполнено(ОКПД2));
	Запрос.УстановитьПараметр("Дата",          ТекущаяДатаСеанса());
	
	Запрос.Текст = ТекстЗапроса;
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область КлассификаторТНВЭДЗерно

&НаСервере
Процедура ЗаполнитьСписокЗЕРНО()
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = ТекстЗапросаСписокЗЕРНО();
	
	Запрос.УстановитьПараметр("ВидПродукции",            ВидПродукции);
	Запрос.УстановитьПараметр("БезОтбораПоВидуПродукции", Не ЗначениеЗаполнено(ВидПродукции));
	
	Запрос.УстановитьПараметр("ОКПД2",          ОКПД2);
	Запрос.УстановитьПараметр("БезОтбораОКПД2", Не ЗначениеЗаполнено(ОКПД2));
	Запрос.УстановитьПараметр("Дата",          ТекущаяДатаСеанса());
	
	Запрос.Текст = ТекстЗапроса;
	СписокЗЕРНО.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаСписокЗЕРНО()
	
	ТекстЗапроса = ИнтеграцияЗЕРНО.ОпределитьТекстЗапросаКлассификатораТНВЭД();
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ЕСТЬNull(
	|		ВЫРАЗИТЬ(ВременнаяТаблица.НаименованиеПолное КАК СТРОКА(255)),
	|		ВЫРАЗИТЬ(ВидыСельскохозяйственныхКультурЗЕРНО.ТНВЭДНаименование КАК СТРОКА(255))) КАК НаименованиеПолное,
	|	КлассификаторНСИЗЕРНО.ВидПродукции  КАК ВидПродукции,
	|	ВидыСельскохозяйственныхКультурЗЕРНО.КодТНВЭД КАК Код,
	|	//%ПолеОтбораОКПД2% КАК ОКПД2,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ВременнаяТаблица.Ссылка ЕСТЬ NULL
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ) КАК Сопоставлено
	|
	|ИЗ
	|	РегистрСведений.ВидыСельскохозяйственныхКультурЗЕРНО КАК ВидыСельскохозяйственныхКультурЗЕРНО
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО ВременнаяТаблица.Код = ВидыСельскохозяйственныхКультурЗЕРНО.КодТНВЭД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторНСИЗЕРНО КАК КлассификаторНСИЗЕРНО
	|		ПО ВидыСельскохозяйственныхКультурЗЕРНО.ОКПД2 = КлассификаторНСИЗЕРНО.Идентификатор
	|			И КлассификаторНСИЗЕРНО.ВидКлассификатора = ЗНАЧЕНИЕ(Перечисление.ВидыКлассификаторовЗЕРНО.ОКПД2)
	|
	|ГДЕ
	|	(КлассификаторНСИЗЕРНО.ВидПродукции = &ВидПродукции Или &БезОтбораПоВидуПродукции)
	|	И (ВидыСельскохозяйственныхКультурЗЕРНО.ОКПД2 = &ОКПД2 Или &БезОтбораОКПД2)
	|	И (ВидыСельскохозяйственныхКультурЗЕРНО.ДействуетПо >= &Дата
	|		ИЛИ ВидыСельскохозяйственныхКультурЗЕРНО.ДействуетПо = ДатаВремя(1,1,1))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВидыСельскохозяйственныхКультурЗЕРНО.КодТНВЭД,
	|	ЕСТЬNull(
	|		ВЫРАЗИТЬ(ВременнаяТаблица.НаименованиеПолное КАК СТРОКА(255)),
	|		ВЫРАЗИТЬ(ВидыСельскохозяйственныхКультурЗЕРНО.ТНВЭДНаименование КАК СТРОКА(255))),
	|	КлассификаторНСИЗЕРНО.ВидПродукции,
	|	//%ПолеОтбораОКПД2%
	|";
	
	Если ЗначениеЗаполнено(ОКПД2) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%ПолеОтбораОКПД2%", "ВидыСельскохозяйственныхКультурЗЕРНО.ОКПД2");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%ПолеОтбораОКПД2%", """""");
	КонецЕсли;
		
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура УстановитьТекущуюСтроку(ЗначениеОтбора)
	
	Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
		Отбор = Новый Структура("Код", ЗначениеОтбора);
		НайденныеСтроки = Список.НайтиСтроки(Отбор);
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НайденныеСтроки.Количество() Тогда
		ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
		Элементы.Список.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
	Отбор = Новый Структура("Код", ЗначениеОтбора);
	НайденныеСтроки = СписокЗЕРНО.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() Тогда
		ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
		Элементы.СписокЗЕРНО.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.СписокЗЕРНО.Обновить();
	
КонецПроцедуры

#КонецОбласти