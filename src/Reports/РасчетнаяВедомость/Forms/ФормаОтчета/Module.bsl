
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодРегистрации = НачалоМесяца(ТекущаяДата());
	ОтображениеПериодаРегистрации = Формат(ПериодРегистрации, "ДФ='MMMM yyyy'");
	
	Организация = Константы.УчетПоКомпании.Компания(Справочники.Организации.ОрганизацияПоУмолчанию());
	Валюта = Константы.ВалютаУчета.Получить();

	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить() Тогда
		
		Подразделение = Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ДатаКалендаряПриОткрытии = ПериодРегистрации;
	Иначе
		ДатаКалендаряПриОткрытии = ОбщегоНазначенияКлиент.ДатаСеанса();
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаКалендаря", ОбщегоНазначенияУНФКлиент.ПараметрыОткрытияФормыКалендаря(
		ДатаКалендаряПриОткрытии), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УправлениеНебольшойФирмойКлиент.ПриРегулированииПериодаРегистрации(ЭтотОбъект, Направление);
	УправлениеНебольшойФирмойКлиент.ПриИзмененииПериодаРегистрации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПериодРегистрации = ВыбранноеЗначение;
	УправлениеНебольшойФирмойКлиент.ПриИзмененииПериодаРегистрации(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыполнитьЗапрос()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиСрезПоследних.СтруктурнаяЕдиница КАК Подразделение,
	|	НачисленияИУдержания.Сотрудник.Код КАК ТабельныйНомер,
	|	НачисленияИУдержания.Сотрудник КАК Физлицо,
	|	СотрудникиСрезПоследних.Должность КАК Должность,
	|	ВЫБОР
	|		КОГДА НачисленияИУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
	|			ТОГДА НачисленияИУдержания.Размер
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Размер,
	|	ВЫБОР
	|		КОГДА НачисленияИУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Удержание)
	|				ИЛИ НачисленияИУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Налог)
	|			ТОГДА ЕСТЬNULL(НачисленияИУдержания.СуммаВал, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаУдержано,
	|	ВЫБОР
	|		КОГДА НачисленияИУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
	|			ТОГДА ЕСТЬNULL(НачисленияИУдержания.СуммаВал, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаНачислено,
	|	Табель.ДнейОборот КАК ОтработаноДней,
	|	Табель.ЧасовОборот КАК ОтработаноЧасов,
	|	ЕСТЬNULL(ДолгНаКонец.СуммаВалОстаток, 0) КАК СальдоНаКонец,
	|	ЕСТЬNULL(ДолгКВыплате.СуммаВалОстаток, 0) КАК ДолгКВыплате,
	|	ФИОФизЛицСрезПоследних.Фамилия КАК Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя КАК Имя,
	|	ФИОФизЛицСрезПоследних.Отчество КАК Отчество,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия, """") <> """"
	|			ТОГДА ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество
	|		ИНАЧЕ НачисленияИУдержания.Сотрудник.Наименование
	|	КОНЕЦ КАК СотрудникПредставление
	|ИЗ
	|	РегистрНакопления.НачисленияИУдержания КАК НачисленияИУдержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПерсоналом.Остатки(
	|				&ПериодРегистрацииКонец,
	|				Организация = &Организация
	|					И Валюта = &Валюта
	|					И ПериодРегистрации < &ПериодРегистрации
	|					И (СтруктурнаяЕдиница = &Подразделение
	|						ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))) КАК ДолгНаКонец
	|		ПО НачисленияИУдержания.Сотрудник = ДолгНаКонец.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(
	|				&ПериодРегистрацииКонец,
	|				Организация = &Организация
	|					И СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК СотрудникиСрезПоследних
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				ТабельОбороты.ДнейОборот КАК ДнейОборот,
	|				ТабельОбороты.ЧасовОборот КАК ЧасовОборот,
	|				ТабельОбороты.Сотрудник КАК Сотрудник,
	|				ТабельОбороты.Должность КАК Должность
	|			ИЗ
	|				РегистрНакопления.Табель.Обороты(
	|						&ПериодРегистрации,
	|						&ПериодРегистрацииКонец,
	|						Месяц,
	|						Организация = &Организация
	|							И (СтруктурнаяЕдиница = &Подразделение
	|								ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
	|							И ВидВремени = ЗНАЧЕНИЕ(Справочник.ВидыРабочегоВремени.Работа)) КАК ТабельОбороты) КАК Табель
	|			ПО СотрудникиСрезПоследних.Сотрудник = Табель.Сотрудник
	|				И СотрудникиСрезПоследних.Должность = Табель.Должность
	|		ПО НачисленияИУдержания.Сотрудник = СотрудникиСрезПоследних.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&ПериодРегистрацииКонец, ) КАК ФИОФизЛицСрезПоследних
	|		ПО НачисленияИУдержания.Сотрудник.Физлицо = ФИОФизЛицСрезПоследних.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПерсоналом.Остатки(
	|				&ПериодРегистрацииКонец,
	|				Организация = &Организация
	|					И Валюта = &Валюта
	|					И ПериодРегистрации = &ПериодРегистрации
	|					И (СтруктурнаяЕдиница = &Подразделение
	|						ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))) КАК ДолгКВыплате
	|		ПО НачисленияИУдержания.Сотрудник = ДолгКВыплате.Сотрудник
	|ГДЕ
	|	НачисленияИУдержания.Организация = &Организация
	|	И НачисленияИУдержания.ПериодРегистрации = &ПериодРегистрации
	|	И НачисленияИУдержания.Валюта = &Валюта
	|	И (НачисленияИУдержания.СтруктурнаяЕдиница = &Подразделение
	|			ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	СотрудникПредставление,
	|	НачисленияИУдержания.ДатаНачала
	|ИТОГИ
	|	МАКСИМУМ(Подразделение),
	|	МАКСИМУМ(ТабельныйНомер),
	|	МАКСИМУМ(Должность),
	|	СУММА(СуммаУдержано),
	|	СУММА(СуммаНачислено),
	|	МАКСИМУМ(ОтработаноДней),
	|	МАКСИМУМ(ОтработаноЧасов),
	|	МАКСИМУМ(СальдоНаКонец),
	|	МАКСИМУМ(ДолгКВыплате),
	|	МАКСИМУМ(Фамилия),
	|	МАКСИМУМ(Имя),
	|	МАКСИМУМ(Отчество)
	|ПО
	|	Физлицо");
	
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Организация", Организация); 
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	Запрос.УстановитьПараметр("ПериодРегистрацииКонец", КонецМесяца(ПериодРегистрации));
	
	Возврат Запрос.Выполнить();
	
КонецФункции // ВыполнитьЗапрос()

&НаСервере
Процедура СформироватьВыполнить()
	
	Если Константы.ИспользоватьНесколькоОрганизаций.Получить() И НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрана организация.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Отчет, "Организация");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран период регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Отчет, "ПериодРегистрации");
		Возврат;
	КонецЕсли;
	
	Если НЕ Константы.ФункциональнаяУчетВалютныхОпераций.Получить() И НЕ ЗначениеЗаполнено(Валюта) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрана валюта.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Отчет, "Валюта");
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = ВыполнитьЗапрос();
	
	Если РезультатЗапроса.Пустой() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Нет данных для формирования отчета.'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли; 
	
	Макет = Отчеты.РасчетнаяВедомость.ПолучитьМакет("Макет");
	
	ОбластьШапкаДокумента 		= Макет.ПолучитьОбласть("ШапкаДокумента");
	ОбластьШапка 				= Макет.ПолучитьОбласть("Шапка");
	ОбластьДетали 				= Макет.ПолучитьОбласть("Детали");
	ОбластьИтогоПоСтранице 		= Макет.ПолучитьОбласть("ИтогоПоСтранице");
	ОбластьПодвал 				= Макет.ПолучитьОбласть("Подвал");
	
	ТабличныйДокумент.Очистить();
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ОбластьШапкаДокумента.Параметры.Организация = Организация.НаименованиеПолное;
	ОбластьШапкаДокумента.Параметры.Подразделение = Подразделение;
	ОбластьШапкаДокумента.Параметры.ДатаД = ТекущаяДата();
	ОбластьШапкаДокумента.Параметры.ОтчетныйПериодС = ПериодРегистрации;
	ОбластьШапкаДокумента.Параметры.ОтчетныйПериодПо = КонецМесяца(ПериодРегистрации);
	ТабличныйДокумент.Вывести(ОбластьШапкаДокумента);
	
	ОбластьШапка.Параметры.Валюта = Валюта;
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	// Инициализация итогов по странице
	ИтогПоСтраницеДолгЗаОрганизацией = 0;
	ИтогПоСтраницеДолгЗаРаботником	 = 0;
	ИтогПоСтраницеСальдоНаКонец      = 0;
	
	// Инициализация итогов по документу
	ИтогДолгЗаОрганизацией			 = 0;
	ИтогДолгЗаРаботником			 = 0;
	ИтогСальдоНаКонец				 = 0;
	
	НПП = 0;
	ПерваяСтраница = Истина;
	
	ВыборкаФизлицо = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Физлицо");
	Пока ВыборкаФизлицо.Следующий() Цикл
		
		СтавкаСписок = "";
		
		ВыборкаДетали = ВыборкаФизлицо.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			Если ЗначениеЗаполнено(ВыборкаДетали.Размер) Тогда
				СтавкаСписок = СтавкаСписок + ?(ЗначениеЗаполнено(СтавкаСписок), ", ", "") + Формат(ВыборкаДетали.Размер, "ЧДЦ=2");
			КонецЕсли;
		КонецЦикла; 
		
		НПП = НПП + 1;
		ОбластьДетали.Параметры.НомерПП = НПП;
		ОбластьДетали.Параметры.Заполнить(ВыборкаФизлицо);
		ОбластьДетали.Параметры.ТарифнаяСтавка = СтавкаСписок;
		ПредставлениеФизЛицо = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаФизлицо);
		ОбластьДетали.Параметры.ФизЛицо = ?(ЗначениеЗаполнено(ПредставлениеФизЛицо), ПредставлениеФизЛицо, ВыборкаФизлицо.Физлицо);
		ОбластьДетали.Параметры.ТабельныйНомер = СокрЛП(ВыборкаФизлицо.ТабельныйНомер);
		
		Если ВыборкаФизлицо.СальдоНаКонец < 0 Тогда
			ОбластьДетали.Параметры.ДолгЗаОрганизацией = 0;
			ОбластьДетали.Параметры.ДолгЗаРаботником = -1 * ВыборкаФизлицо.СальдоНаКонец;
		Иначе
			ОбластьДетали.Параметры.ДолгЗаОрганизацией = ВыборкаФизлицо.СальдоНаКонец;
			ОбластьДетали.Параметры.ДолгЗаРаботником = 0;
		КонецЕсли;
		
		// Проверим вывод
		СтрокаСПодвалом = Новый Массив;
		Если ПерваяСтраница Тогда
			СтрокаСПодвалом.Добавить(ОбластьШапка); // если первая строка, то должен помещаться заголовок
			ПерваяСтраница = Ложь;
		КонецЕсли;                                                   
		СтрокаСПодвалом.Добавить(ОбластьДетали);
		СтрокаСПодвалом.Добавить(ОбластьИтогоПоСтранице);
		
		Если НЕ ПерваяСтраница И НЕ ТабличныйДокумент.ПроверитьВывод(СтрокаСПодвалом) Тогда
			
			// Выводим итоги по странице
			ОбластьИтогоПоСтранице.Параметры.ИтогПоСтраницеДолгЗаОрганизацией	 = ИтогПоСтраницеДолгЗаОрганизацией;
			ОбластьИтогоПоСтранице.Параметры.ИтогПоСтраницеДолгЗаРаботником		 = ИтогПоСтраницеДолгЗаРаботником;
			ОбластьИтогоПоСтранице.Параметры.ИтогПоСтраницеСальдоНаКонец		 = ИтогПоСтраницеСальдоНаКонец;
			ТабличныйДокумент.Вывести(ОбластьИтогоПоСтранице);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			// Очистим итоги по странице
			ИтогПоСтраницеДолгЗаОрганизацией	 = 0;
			ИтогПоСтраницеДолгЗаРаботником		 = 0;
			ИтогПоСтраницеСальдоНаКонец			 = 0;
			
			// Выведем заголовок таблицы
			ТабличныйДокумент.Вывести(ОбластьШапка);
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьДетали);
		
		// Увеличим итоги
		Если ВыборкаФизлицо.СальдоНаКонец < 0 Тогда
			
			ИтогПоСтраницеДолгЗаРаботником		 = ИтогПоСтраницеДолгЗаРаботником - ВыборкаФизлицо.СальдоНаКонец;
			ИтогПоСтраницеСальдоНаКонец			 = ИтогПоСтраницеСальдоНаКонец      + ВыборкаФизлицо.ДолгКВыплате;
			
			ИтогДолгЗаРаботником				 = ИтогДолгЗаРаботником + ВыборкаФизлицо.СальдоНаКонец;
			ИтогСальдоНаКонец     				 = ИтогСальдоНаКонец      + ВыборкаФизлицо.ДолгКВыплате;
			
		Иначе
			
			ИтогПоСтраницеДолгЗаОрганизацией	 = ИтогПоСтраницеДолгЗаОрганизацией       + ВыборкаФизлицо.СальдоНаКонец;
			ИтогПоСтраницеСальдоНаКонец			 = ИтогПоСтраницеСальдоНаКонец      + ВыборкаФизлицо.ДолгКВыплате;
			
			ИтогДолгЗаОрганизацией      		 = ИтогДолгЗаОрганизацией       + ВыборкаФизлицо.СальдоНаКонец;
			ИтогСальдоНаКонец     				 = ИтогСальдоНаКонец      + ВыборкаФизлицо.ДолгКВыплате;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Выводим итоги по странице
	ОбластьИтогоПоСтранице.Параметры.ИтогПоСтраницеДолгЗаОрганизацией	 = ИтогПоСтраницеДолгЗаОрганизацией;
	ОбластьИтогоПоСтранице.Параметры.ИтогПоСтраницеДолгЗаРаботником		 = ИтогПоСтраницеДолгЗаРаботником;
	ОбластьИтогоПоСтранице.Параметры.ИтогПоСтраницеСальдоНаКонец		 = ИтогПоСтраницеСальдоНаКонец;
	ТабличныйДокумент.Вывести(ОбластьИтогоПоСтранице);
	
	ОбластьПодвал.Параметры.ИтогДолгЗаОрганизацией	 = ИтогДолгЗаОрганизацией;
	ОбластьПодвал.Параметры.ИтогДолгЗаРаботником	 = ИтогДолгЗаРаботником;
	ОбластьПодвал.Параметры.ИтогСальдоНаКонец		 = ИтогСальдоНаКонец;
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
КонецПроцедуры // Сформировать()

#КонецОбласти
