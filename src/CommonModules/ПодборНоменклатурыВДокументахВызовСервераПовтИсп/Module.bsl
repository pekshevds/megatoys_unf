
#Область ПрограммныйИнтерфейс

// Возвращает список выбора структурных единиц для формы подбора
//
Функция ЗаполнитьСписокВыбораСтруктурныхЕдиниц(СтруктураТипов, СтруктураПараметров) Экспорт
	
	МассивТиповСтруктурнойЕдиницы = Новый Массив;
	
	Для Каждого СтрокаТипа Из СтруктураТипов Цикл;
		МассивТиповСтруктурнойЕдиницы.Добавить(СтрокаТипа.Значение);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипСтруктурнойЕдиницы", МассивТиповСтруктурнойЕдиницы);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиницаДокумент", СтруктураПараметров.СтруктурнаяЕдиницаДокумент);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиницаПолучатель", СтруктураПараметров.СтруктурнаяЕдиницаПолучатель);
	
	Запрос.УстановитьПараметр("ИзДокумента", НСтр("ru = '(из документа)'"));
	Запрос.УстановитьПараметр("Отправитель", НСтр("ru = '(отправитель)'"));
	Запрос.УстановитьПараметр("Получатель", НСтр("ru = '(получатель)'"));
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктурныеЕдиницы.Ссылка КАК Значение,
	|	ВЫБОР
	|		КОГДА &СтруктурнаяЕдиницаПолучатель = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ &СтруктурнаяЕдиницаДокумент = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|							И СтруктурныеЕдиницы.Ссылка = &СтруктурнаяЕдиницаДокумент
	|						ТОГДА СтруктурныеЕдиницы.Наименование + "" "" + &ИзДокумента
	|					ИНАЧЕ СтруктурныеЕдиницы.Наименование
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА НЕ &СтруктурнаяЕдиницаДокумент = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|						И СтруктурныеЕдиницы.Ссылка = &СтруктурнаяЕдиницаДокумент
	|					ТОГДА СтруктурныеЕдиницы.Наименование + "" "" + &Отправитель
	|				КОГДА НЕ &СтруктурнаяЕдиницаПолучатель = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|						И СтруктурныеЕдиницы.Ссылка = &СтруктурнаяЕдиницаПолучатель
	|					ТОГДА СтруктурныеЕдиницы.Наименование + "" "" + &Получатель
	|				ИНАЧЕ СтруктурныеЕдиницы.Наименование
	|			КОНЕЦ
	|	КОНЕЦ КАК Представление,
	|	ВЫБОР
	|		КОГДА &СтруктурнаяЕдиницаПолучатель = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ &СтруктурнаяЕдиницаДокумент = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|							И СтруктурныеЕдиницы.Ссылка = &СтруктурнаяЕдиницаДокумент
	|						ТОГДА 0
	|					ИНАЧЕ 1
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА НЕ &СтруктурнаяЕдиницаДокумент = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|						И СтруктурныеЕдиницы.Ссылка = &СтруктурнаяЕдиницаДокумент
	|					ТОГДА 0
	|				КОГДА НЕ &СтруктурнаяЕдиницаПолучатель = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|						И СтруктурныеЕдиницы.Ссылка = &СтруктурнаяЕдиницаПолучатель
	|					ТОГДА 1
	|				ИНАЧЕ 2
	|			КОНЕЦ
	|	КОНЕЦ КАК Порядок,
	|	СтруктурныеЕдиницы.Наименование КАК Наименование
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы В(&ТипСтруктурнойЕдиницы)
	|	И НЕ СтруктурныеЕдиницы.ПометкаУдаления
	|	И НЕ СтруктурныеЕдиницы.Недействителен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокСтруктурныхЕдиниц = Новый СписокЗначений;
	
	Если Выборка.Количество() > 20 Тогда
		Возврат СписокСтруктурныхЕдиниц;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		СписокСтруктурныхЕдиниц.Добавить(Выборка.Значение, Выборка.Представление);
	КонецЦикла;
	
	Возврат СписокСтруктурныхЕдиниц;
	
КонецФункции

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает ставку НДС по переданной организации
//
Функция ПолучитьСтавкуНДСОрганизации(Организация, Период = Неопределено) Экспорт
	
	Возврат Справочники.СтавкиНДС.СтавкаНДС(Организация.ВидСтавкиНДСПоУмолчанию, Период);
	
КонецФункции // ПолучитьСтавкуНДСОрганизации()

#КонецОбласти 

