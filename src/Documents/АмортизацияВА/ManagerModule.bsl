#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Период",		   СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	Запрос.УстановитьПараметр("МоментВремени", КонецМесяца(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	Запрос.УстановитьПараметр("Организация",   СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("НачалоГода",	   НачалоГода(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	Запрос.УстановитьПараметр("КонецПериода",  КонецМесяца(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	Запрос.УстановитьПараметр("Ссылка",	       ДокументСсылкаАмортизацияВА);
	Запрос.УстановитьПараметр("Сообщение1",	   НСтр("ru = 'амортизация в этом месяце уже начислялась!'"));
	Запрос.УстановитьПараметр("Сообщение2",	   НСтр("ru = 'не указан способ начисления амортизации!'"));
	Запрос.УстановитьПараметр("Сообщение3",	   НСтр("ru = 'стоимость равна 0!'"));
	Запрос.УстановитьПараметр("Сообщение4",	   НСтр("ru = 'срок использования равен 0!'"));
	Запрос.УстановитьПараметр("Сообщение5",	   НСтр("ru = 'объем продукции работ для вычисления амортизации не заполнен!'"));
	Запрос.УстановитьПараметр("Сообщение6",	   НСтр("ru = 'первоначальная стоимость равна 0!'"));
	
	
	// Установка исключительной блокировки контролируемых остатков денежных средств.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Организация КАК Организация";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ВнеоборотныеАктивы");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ВыработкаВнеоборотныхАктивов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыВнеоборотныхАктивов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияВнеоборотныхАктивов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	
	Блокировка.Заблокировать();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокАмортизируемыхВА.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ПРЕДСТАВЛЕНИЕ(СписокАмортизируемыхВА.ВнеоборотныйАктив) КАК ВнеоборотныйАктивПредставление,
	|	СписокАмортизируемыхВА.ВнеоборотныйАктив.Код КАК Код,
	|	СписокАмортизируемыхВА.НачалоНачислятьАмортизацию КАК НачалоНачислятьАмортизацию,
	|	СписокАмортизируемыхВА.КонецНачислятьАмортизацию КАК КонецНачислятьАмортизацию,
	|	СписокАмортизируемыхВА.КонецНачислятьВТекущемМесяце КАК КонецНачислятьВТекущемМесяце,
	|	ЕСТЬNULL(СтоимостьВА.АмортизацияКонечныйОстаток, 0) КАК АмортизацияКонечныйОстаток,
	|	ЕСТЬNULL(СтоимостьВА.АмортизацияОборот, 0) КАК АмортизацияОборот,
	|	ЕСТЬNULL(СтоимостьВА.СтоимостьКонечныйОстаток, 0) КАК БалансоваяСтоимость,
	|	ЕСТЬNULL(СтоимостьВА.СтоимостьНачальныйОстаток, 0) КАК СтоимостьНачальныйОстаток,
	|	ЕСТЬNULL(АмортизацияОстаткиИОбороты.СтоимостьНачальныйОстаток, 0) - ЕСТЬNULL(АмортизацияОстаткиИОбороты.АмортизацияНачальныйОстаток, 0) КАК СтоимостьНаНачалоГода,
	|	ЕСТЬNULL(СписокАмортизируемыхВА.ВнеоборотныйАктив.СпособАмортизации, 0) КАК СпособНачисленияАмортизации,
	|	ЕСТЬNULL(СписокАмортизируемыхВА.ВнеоборотныйАктив.НачальнаяСтоимость, 0) КАК ПервоначальнаяСтоимость,
	|	ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце, 0) КАК ПрименитьВТекущемМесяце,
	|	ПараметрыАмортизацииСрезПоследних.Период КАК Период,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.СрокИспользованияДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.СрокИспользованияДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК СрокИспользованияДляВычисленияАмортизации,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.СтоимостьДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.СтоимостьДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК СтоимостьДляВычисленияАмортизации,
	|	ЕСТЬNULL(ИзменениеПризнакаАмортизации.ИзменениеНачисленияАмортизации, ЛОЖЬ) КАК ИзменениеНачисленияАмортизации,
	|	ЕСТЬNULL(ИзменениеПризнакаАмортизации.НачислятьВТекМесяце, ЛОЖЬ) КАК НачислятьВТекМесяце,
	|	ЕСТЬNULL(ВыработкаВнеоборотногоАктиваОбороты.КоличествоОборот, 0) КАК ОбъемВыработки,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.ОбъемПродукцииРаботДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.ОбъемПродукцииРаботДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ПараметрыАмортизацииСрезПоследних.Проект
	|		ИНАЧЕ ПараметрыАмортизацииСрезПоследнихНачалоМесяца.Проект
	|	КОНЕЦ КАК Проект
	|ПОМЕСТИТЬ ВременнаяТаблицаДляРасчетаАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		СрезПервых.НачислятьАмортизацию КАК НачалоНачислятьАмортизацию,
	|		СрезПоследних.НачислятьАмортизацию КАК КонецНачислятьАмортизацию,
	|		СрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК КонецНачислятьВТекущемМесяце,
	|		СрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|	ИЗ
	|		(ВЫБРАТЬ
	|			СостояниеВнеоборотногоАктиваСрезПервых.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПервых.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|			СостояниеВнеоборотногоАктиваСрезПервых.НачислятьАмортизациюВТекущемМесяце КАК НачислятьАмортизациюВТекущемМесяце,
	|			СостояниеВнеоборотногоАктиваСрезПервых.Период КАК Период
	|		ИЗ
	|			РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПервых) КАК СрезПервых
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК НачислятьАмортизациюВТекущемМесяце,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.Период КАК Период
	|			ИЗ
	|				РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(&КонецПериода, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПоследних) КАК СрезПоследних
	|			ПО СрезПервых.ВнеоборотныйАктив = СрезПоследних.ВнеоборотныйАктив) КАК СписокАмортизируемыхВА
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.ОстаткиИОбороты(&НачалоГода, , , , Организация = &Организация) КАК АмортизацияОстаткиИОбороты
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = АмортизацияОстаткиИОбороты.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , Организация = &Организация) КАК СтоимостьВА
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = СтоимостьВА.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(&КонецПериода, Организация = &Организация) КАК ПараметрыАмортизацииСрезПоследних
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ПараметрыАмортизацииСрезПоследних.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК ПараметрыАмортизацииСрезПоследнихНачалоМесяца
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ПараметрыАмортизацииСрезПоследнихНачалоМесяца.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИСТИНА) КАК ИзменениеНачисленияАмортизации,
	|			СостояниеВнеоборотногоАктива.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК НачислятьВТекМесяце
	|		ИЗ
	|			РегистрСведений.СостоянияВнеоборотныхАктивов КАК СостояниеВнеоборотногоАктива
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(&КонецПериода, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|				ПО СостояниеВнеоборотногоАктива.ВнеоборотныйАктив = СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив
	|		ГДЕ
	|			СостояниеВнеоборотногоАктива.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|			И СостояниеВнеоборотногоАктива.Организация = &Организация
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СостояниеВнеоборотногоАктива.ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце) КАК ИзменениеПризнакаАмортизации
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ИзменениеПризнакаАмортизации.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВыработкаВнеоборотныхАктивов.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК ВыработкаВнеоборотногоАктиваОбороты
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ВыработкаВнеоборотногоАктиваОбороты.ВнеоборотныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Период КАК Период,
	|	Таблица.Продолжить КАК Продолжить,
	|	Таблица.СообщениеОбОшибкеНачисленияАмортизации КАК СообщениеОбОшибкеНачисленияАмортизации,
	|	Таблица.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	Таблица.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|	Таблица.Код КАК Код,
	|	Таблица.АмортизацияКонечныйОстаток КАК АмортизацияКонечныйОстаток,
	|	Таблица.БалансоваяСтоимость КАК БалансоваяСтоимость,
	|	Таблица.ВсегоОсталосьСписать КАК ВсегоОсталосьСписать,
	|	0 КАК Стоимость,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА Таблица.СуммаАмортизации < Таблица.ВсегоОсталосьСписать
	|					ТОГДА Таблица.СуммаАмортизации
	|				ИНАЧЕ Таблица.ВсегоОсталосьСписать
	|			КОНЕЦ > 0
	|			ТОГДА ВЫБОР
	|					КОГДА Таблица.СуммаАмортизации < Таблица.ВсегоОсталосьСписать
	|						ТОГДА Таблица.СуммаАмортизации
	|					ИНАЧЕ Таблица.ВсегоОсталосьСписать
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Амортизация,
	|	Таблица.Проект КАК Проект1
	|ПОМЕСТИТЬ ТаблицаРасчетаАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА Таблица.ИзменениеНачисленияАмортизации <> ЛОЖЬ
	|						И Таблица.НачислятьВТекМесяце = ЛОЖЬ
	|					ИЛИ Таблица.КонецНачислятьАмортизацию = ЛОЖЬ
	|					ИЛИ Таблица.КонецНачислятьВТекущемМесяце = ЛОЖЬ
	|						И Таблица.НачалоНачислятьАмортизацию = ЛОЖЬ
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ КАК Продолжить,
	|		ВЫБОР
	|			КОГДА Таблица.АмортизацияОборот <> 0
	|				ТОГДА &Сообщение1
	|			КОГДА Таблица.СпособНачисленияАмортизации = 0
	|				ТОГДА &Сообщение2
	|			КОГДА Таблица.СтоимостьДляВычисленияАмортизации = 0
	|				ТОГДА &Сообщение3
	|			КОГДА Таблица.СрокИспользованияДляВычисленияАмортизации = 0
	|					И Таблица.СпособНачисленияАмортизации <> ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции)
	|				ТОГДА &Сообщение4
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции)
	|					И Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации = 0
	|				ТОГДА &Сообщение5
	|			КОГДА Таблица.ПервоначальнаяСтоимость = 0
	|				ТОГДА &Сообщение6
	|			ИНАЧЕ НЕОПРЕДЕЛЕНО
	|		КОНЕЦ КАК СообщениеОбОшибкеНачисленияАмортизации,
	|		ВЫБОР
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.Линейный)
	|				ТОГДА Таблица.СтоимостьДляВычисленияАмортизации / ВЫБОР
	|						КОГДА Таблица.СрокИспользованияДляВычисленияАмортизации = 0
	|							ТОГДА 1
	|						ИНАЧЕ Таблица.СрокИспользованияДляВычисленияАмортизации
	|					КОНЕЦ
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции)
	|				ТОГДА Таблица.СтоимостьДляВычисленияАмортизации * Таблица.ОбъемВыработки / ВЫБОР
	|						КОГДА Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации = 0
	|							ТОГДА 1
	|						ИНАЧЕ Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СуммаАмортизации,
	|		Таблица.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		Таблица.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|		Таблица.Код КАК Код,
	|		Таблица.АмортизацияКонечныйОстаток КАК АмортизацияКонечныйОстаток,
	|		Таблица.БалансоваяСтоимость КАК БалансоваяСтоимость,
	|		Таблица.БалансоваяСтоимость - Таблица.АмортизацияКонечныйОстаток КАК ВсегоОсталосьСписать,
	|		Таблица.Проект КАК Проект
	|	ИЗ
	|		ВременнаяТаблицаДляРасчетаАмортизации КАК Таблица) КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВременнаяТаблицаДляРасчетаАмортизации";
	
	Запрос.ВыполнитьПакет();
	
	СформироватьТаблицаВнеоборотныеАктивы(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаЗапасы(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДоходыИРасходы(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаОшибкиЗакрытияМесяца(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаУправленческий(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаЗапасы(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("МоментВремени", КонецМесяца(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.СчетУчетаАмортизации КАК СчетУчета,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика КАК Характеристика,
	|	ТаблицаДокумента.Партия КАК Партия,
	|	ТаблицаДокумента.Заказ КАК Заказ,
	|	ТаблицаДокумента.Амортизация КАК Сумма,
	|	ИСТИНА КАК ФиксированнаяСтоимость,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет) КАК ВидДвиженияУправленческий,
	|	&НачислениеАмортизации КАК СодержаниеПроводки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаДокумента.Период КАК Период,
	|		&Организация КАК Организация,
	|		ПараметрыВнеоборотныхАктивовСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат КАК СчетУчетаАмортизации,
	|		ПараметрыВнеоборотныхАктивовСрезПоследних.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|		ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		ТаблицаДокумента.ВнеоборотныйАктив.СчетУчета КАК СчетУчета,
	|		ТаблицаДокумента.ВнеоборотныйАктив.СчетАмортизации КАК СчетАмортизации,
	|		ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	|		ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
	|		ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка) КАК Партия,
	|		НЕОПРЕДЕЛЕНО КАК Заказ,
	|		ТаблицаДокумента.Стоимость КАК Стоимость,
	|		ТаблицаДокумента.Амортизация КАК Амортизация
	|	ИЗ
	|		ТаблицаРасчетаАмортизации КАК ТаблицаДокумента
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(&МоментВремени, ) КАК ПараметрыВнеоборотныхАктивовСрезПоследних
	|			ПО (&Организация = ПараметрыВнеоборотныхАктивовСрезПоследних.Организация)
	|				И ТаблицаДокумента.ВнеоборотныйАктив = ПараметрыВнеоборотныхАктивовСрезПоследних.ВнеоборотныйАктив
	|	ГДЕ
	|		ТаблицаДокумента.Продолжить
	|		И ТаблицаДокумента.Амортизация <> 0
	|		И ТаблицаДокумента.СообщениеОбОшибкеНачисленияАмортизации = НЕОПРЕДЕЛЕНО
	|		И (ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.НезавершенноеПроизводство)
	|				ИЛИ ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.КосвенныеЗатраты))) КАК ТаблицаДокумента";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасы", РезультатЗапроса.Выгрузить());
			
КонецПроцедуры // СформироватьТаблицаЗапасы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДоходыИРасходы(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("МоментВремени", КонецМесяца(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат КАК СчетУчета,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК Аналитика,
	|	НЕОПРЕДЕЛЕНО КАК Заказ,
	|	ТаблицаДокумента.Амортизация КАК СуммаРасходов,
	|	ТаблицаДокумента.Амортизация КАК Сумма,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет) КАК ВидДвиженияУправленческий,
	|	&НачислениеАмортизации КАК СодержаниеПроводки,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.Проект КАК Проект
	|ИЗ
	|	ТаблицаРасчетаАмортизации КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(&МоментВремени, ) КАК ПараметрыВнеоборотныхАктивовСрезПоследних
	|		ПО (&Организация = ПараметрыВнеоборотныхАктивовСрезПоследних.Организация)
	|			И ТаблицаДокумента.ВнеоборотныйАктив = ПараметрыВнеоборотныхАктивовСрезПоследних.ВнеоборотныйАктив
	|ГДЕ
	|	ТаблицаДокумента.Продолжить
	|	И ТаблицаДокумента.Амортизация <> 0
	|	И ТаблицаДокумента.СообщениеОбОшибкеНачисленияАмортизации = НЕОПРЕДЕЛЕНО
	|	И (ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Расходы)
	|			ИЛИ ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы))";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВнеоборотныеАктивы(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаДокумента.Стоимость КАК Стоимость,
	|	ТаблицаДокумента.Амортизация КАК Амортизация,
	|	ТаблицаДокумента.Амортизация КАК Сумма,
	|	ТаблицаДокумента.ВнеоборотныйАктив.СчетАмортизации КАК СчетУчета,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Кредит) КАК ВидДвиженияУправленческий,
	|	&НачислениеАмортизации КАК СодержаниеПроводки
	|ИЗ
	|	ТаблицаРасчетаАмортизации КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Продолжить
	|	И ТаблицаДокумента.СообщениеОбОшибкеНачисленияАмортизации = НЕОПРЕДЕЛЕНО
	|	И ТаблицаДокумента.Амортизация > 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВнеоборотныеАктивы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаВнеоборотныеАктивы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОшибкиЗакрытияМесяца(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("АмортизацияРавнаНулю", НСтр("ru = 'рассчитанная амортизация равна 0!'"));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Период КАК Период,
	|	ТаблицаСообщенийНачисленияАмортизации.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|	ТаблицаСообщенийНачисленияАмортизации.Код КАК Код,
	|	ТаблицаСообщенийНачисленияАмортизации.СообщениеОбОшибкеНачисленияАмортизации КАК СообщениеОбОшибкеНачисленияАмортизации,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(255)) КАК ОписаниеОшибки,
	|	""НачислениеАмортизации"" КАК ВидОперации
	|ИЗ
	|	ТаблицаРасчетаАмортизации КАК ТаблицаСообщенийНачисленияАмортизации
	|ГДЕ
	|	ТаблицаСообщенийНачисленияАмортизации.Продолжить
	|	И ТаблицаСообщенийНачисленияАмортизации.СообщениеОбОшибкеНачисленияАмортизации <> НЕОПРЕДЕЛЕНО
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Организация,
	|	&Период,
	|	ТаблицаСообщенийНачисленияАмортизации.ВнеоборотныйАктивПредставление,
	|	ТаблицаСообщенийНачисленияАмортизации.Код,
	|	&АмортизацияРавнаНулю,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(255)),
	|	""НачислениеАмортизации""
	|ИЗ
	|	ТаблицаРасчетаАмортизации КАК ТаблицаСообщенийНачисленияАмортизации
	|ГДЕ
	|	ТаблицаСообщенийНачисленияАмортизации.Продолжить
	|	И ТаблицаСообщенийНачисленияАмортизации.СообщениеОбОшибкеНачисленияАмортизации = НЕОПРЕДЕЛЕНО
	|	И ТаблицаСообщенийНачисленияАмортизации.Амортизация = 0
	|	И ТаблицаСообщенийНачисленияАмортизации.ВсегоОсталосьСписать <> 0";
	
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Для каждого ТекСтрока Из ТаблицаРезультата Цикл
		ТекстОшибки = НСтр("ru = 'Для имущества %ВнеоборотныйАктивПредставление% (%Код%) %СообщениеОбОшибкеНачисленияАмортизации%.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ВнеоборотныйАктивПредставление%", СокрЛП(ТекСтрока.ВнеоборотныйАктивПредставление));
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Код%", СокрЛП(ТекСтрока.Код));
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%СообщениеОбОшибкеНачисленияАмортизации%", СокрЛП(ТекСтрока.СообщениеОбОшибкеНачисленияАмортизации));
		ТекСтрока.ОписаниеОшибки = ТекстОшибки;
	КонецЦикла;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОшибкиЗакрытияМесяца", ТаблицаРезультата);
	
КонецПроцедуры // СформироватьТаблицаСообщенийНачисленияАмортизации()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаУправленческий(ДокументСсылкаАмортизацияВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("МоментВремени", КонецМесяца(СтруктураДополнительныеСвойства.ДляПроведения.Дата));
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
		
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Период КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	0 КАК СуммаВалДт,
	|	ТаблицаДокумента.ВнеоборотныйАктив.СчетАмортизации КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	0 КАК СуммаВалКт,
	|	ТаблицаДокумента.Амортизация КАК Сумма,
	|	ВЫРАЗИТЬ(&НачислениеАмортизации КАК СТРОКА(100)) КАК Содержание
	|ИЗ
	|	ТаблицаРасчетаАмортизации КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(&МоментВремени, ) КАК ПараметрыВнеоборотныхАктивовСрезПоследних
	|		ПО (&Организация = ПараметрыВнеоборотныхАктивовСрезПоследних.Организация)
	|			И ТаблицаДокумента.ВнеоборотныйАктив = ПараметрыВнеоборотныхАктивовСрезПоследних.ВнеоборотныйАктив
	|ГДЕ
	|	ТаблицаДокумента.Продолжить
	|	И ТаблицаДокумента.СообщениеОбОшибкеНачисленияАмортизации = НЕОПРЕДЕЛЕНО
	|	И ТаблицаДокумента.Амортизация > 0";

	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаУправленческий()

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли