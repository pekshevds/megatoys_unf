#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если есть включенные задачи по напоминаниям о показателях
//
// Параметры:
//  ЭтоРегулярные	 - Булево - Истина, если нужно узнать о наличии регулярных задач, Ложь - при изменении.
// 
// Возвращаемое значение:
//  Булево - Истина, если есть задачи по заданному виду оповещения.
//
Функция ЕстьЗадачиВРаботе(ЭтоРегулярные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоРаботеСПоказателямиБизнеса КАК ЗадачиАссистентаПоРаботеСПоказателямиБизнеса
	|ГДЕ
	|	НЕ ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ПометкаУдаления
	|	И ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.Используется
	|	И ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ВидОповещения = &ВидОповещения";
	
	Запрос.УстановитьПараметр("ВидОповещения",
	?(ЭтоРегулярные, Перечисления.ВидОповещенияПоПоказателям.Регулярный, Перечисления.ВидОповещенияПоПоказателям.ПриИзменении));
	
	Результат = Запрос.Выполнить();
	Возврат НЕ Результат.Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередНачаломВыполненияЗадач(НовыеЗадачиКВыполнению) Экспорт
	
КонецПроцедуры

Процедура ПередЗаписьюПредметаЗадачи(ПредметОбъект) Экспорт
	
КонецПроцедуры

Процедура ПриЗаписиПредметаЗадачи(ПредметОбъект) Экспорт
	
КонецПроцедуры

Процедура ОбработкаПроведенияПредметаЗадачи(ПредметОбъект) Экспорт
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведенияПредметаЗадачи(ПредметОбъект) Экспорт
	
КонецПроцедуры

Процедура ЗапланироватьЗадачиКВыполнению(НовыеЗадачиКВыполнению, ВыбранныеЗадачиАссистента, ВидОповещения, ПериодичностьОтправки) Экспорт
	
	ВремяОтправленияЗадач = ВремяОтправленияНовыхЗадач(ВидОповещения, ПериодичностьОтправки);
	
	Для каждого ЗадачаАссистента Из ВыбранныеЗадачиАссистента Цикл
		НоваяЗадача = НовыеЗадачиКВыполнению.Добавить();
		НоваяЗадача.Дата = ВремяОтправленияЗадач;
		НоваяЗадача.Задача = ЗадачаАссистента;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПоприветствоватьПользователяПриЗаписиПервыхЗадач(ЗадачиАссистента) Экспорт
	
	Для каждого ЗадачаАссистента Из ЗадачиАссистента Цикл
		ЗадачаОбъект = ЗадачаАссистента.ПолучитьОбъект();
		ЗадачаОбъект.ПоприветствоватьПользователяПередПервымВыполнением();
	КонецЦикла;
	
КонецПроцедуры

Функция ВремяОтправленияЗадач(ВидОповещения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ПериодичностьОтправки = ЗНАЧЕНИЕ(Перечисление.ПериодичностиРасписанийРассылокОтчетов.Ежедневно)
	|			ТОГДА ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ВремяОтправления
	|		КОГДА ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ПериодичностьОтправки = ЗНАЧЕНИЕ(Перечисление.ПериодичностиРасписанийРассылокОтчетов.Еженедельно)
	|			ТОГДА ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ДеньОтправления
	|		КОГДА ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ПериодичностьОтправки = ЗНАЧЕНИЕ(Перечисление.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно)
	|			ТОГДА ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ДатаОтправления
	|	КОНЕЦ КАК ПериодОтправления
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоРаботеСПоказателямиБизнеса КАК ЗадачиАссистентаПоРаботеСПоказателямиБизнеса
	|ГДЕ
	|	ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ВидОповещения = &ВидОповещения";
	
	Запрос.УстановитьПараметр("ВидОповещения", ВидОповещения);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеЗадачи = Результат.Выбрать();
	ДанныеЗадачи.Следующий();
	Возврат ДанныеЗадачи.ПериодОтправления;
	
КонецФункции

Функция ПериодичностьОтправленияЗадач(ВидОповещения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ПериодичностьОтправки КАК ПериодичностьОтправки
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоРаботеСПоказателямиБизнеса КАК ЗадачиАссистентаПоРаботеСПоказателямиБизнеса
	|ГДЕ
	|	ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ВидОповещения = &ВидОповещения";
	
	Запрос.УстановитьПараметр("ВидОповещения", ВидОповещения);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеЗадачи = Результат.Выбрать();
	ДанныеЗадачи.Следующий();
	Возврат ДанныеЗадачи.ПериодичностьОтправки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВремяОтправленияНовыхЗадач(ВидОповещения, ПериодичностьОтправки)

	СекундВЧасе = 3600;
	СекундВСутках = 86400;
	СекундВНеделе = 604800;
	СекундВ12Часах = 43200;
	ВремяОтправленияЗадач = ВремяОтправленияЗадач(ВидОповещения);
	
	Если ПериодичностьОтправки = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежедневно Тогда
		Возврат НачалоДня(ТекущаяДатаСеанса()) + СекундВСутках + ВремяОтправленияЗадач * СекундВЧасе;
	ИначеЕсли ПериодичностьОтправки = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Еженедельно Тогда
		Возврат НачалоНедели(ТекущаяДатаСеанса()) + СекундВНеделе + ВремяОтправленияЗадач * СекундВСутках + СекундВ12Часах;
	ИначеЕсли ПериодичностьОтправки = Перечисления.ПериодичностиРасписанийРассылокОтчетов.Ежемесячно Тогда
		Если ПропускаетсяМесяц(ВремяОтправленияЗадач, СекундВСутках) Тогда
			Возврат НачалоДня(КонецМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), 1))) + СекундВ12Часах;
		Иначе
			Возврат НачалоМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), 1)) + (ВремяОтправленияЗадач - 1) * СекундВСутках + СекундВ12Часах;
		КонецЕсли;
	КонецЕсли;

КонецФункции

Функция ПропускаетсяМесяц(ВремяОтправленияЗадач, СекундВСутках)

	// Проверка на пропуск месяца, когда день отправки превышает число дней в месяце.
	Возврат Месяц(НачалоМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), 1)) + (ВремяОтправленияЗадач - 1) * СекундВСутках) - Месяц(НачалоМесяца(ТекущаяДатаСеанса())) > 1;

КонецФункции

#КонецОбласти

#КонецЕсли