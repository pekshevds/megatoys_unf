
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Вызывается при работе в модели сервиса для получения сведений о предопределенных вариантах отчета.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Имя           - Строка - имя варианта отчета; например, "Основной";
//    * Представление - Строка - имя варианта отчета; например, НСтр("ru = 'Динамика изменений файлов'").
//
Функция ВариантыНастроек() Экспорт 
	
	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "Ведомость", 
		НСтр("ru = 'Деньги (упр. вал.)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Остатки", 
		НСтр("ru = 'Остатки денег (упр. вал.)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Анализ движений", 
		НСтр("ru = 'Движение денег (упр. вал.)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ВедомостьВВалюте", 
		НСтр("ru = 'Деньги'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ОстаткиВВалюте", 
		НСтр("ru = 'Остатки денег'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Анализ движений в валюте", 
		НСтр("ru = 'Движение денег'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ДинамикаПоступленияДенежныхСредств", 
		НСтр("ru = 'Динамика поступления денег'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ДинамикаРасходаДенежныхСредств", 
		НСтр("ru = 'Динамика расхода денег'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "Ведомость");
	Вариант.Описание = НСтр("ru = 'Ведомость движения денежных средств с детализацией по кассам и банковским счетам за указанный период.'");
	Вариант.ФункциональныеОпции.Добавить("УчетВалютныхОпераций");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "Остатки");
	Вариант.Описание = НСтр("ru = 'Отчет показывает остатки денежных средств на счетах и в кассах на указанную дату.'");
	Вариант.ФункциональныеОпции.Добавить("УчетВалютныхОпераций");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "Анализ движений");
	Вариант.Описание = НСтр("ru = 'Отчет показывает движение денежных средств с детализацией по статьям за выбранный период времени.'");
	Вариант.ФункциональныеОпции.Добавить("УчетВалютныхОпераций");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "ВедомостьВВалюте");
	Вариант.Описание = НСтр("ru = 'Ведомость движения денежных средств с детализацией по кассам и банковским счетам за указанный период в валюте денежных средств.'");
	Вариант.Размещение.Вставить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы());
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "Важный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "ОстаткиВВалюте");
	Вариант.Описание = НСтр("ru = 'Отчет показывает остатки денежных средств на счетах и в кассах на указанную дату в валюте денежных средств.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "Важный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "Анализ движений в валюте");
	Вариант.Описание = НСтр("ru = 'Отчет показывает движение денежных средств с детализацией по статьям за выбранный период времени в валюте денежных средств.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "Важный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "ДинамикаПоступленияДенежныхСредств");
	Вариант.Описание = НСтр("ru = 'Отчет показывает динамику поступления денежных средств с детализацией по статьям за выбранный период времени в валюте учета.'");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДенежныеСредства, "ДинамикаРасходаДенежныхСредств");
	Вариант.Описание = НСтр("ru = 'Отчет показывает динамику расхода денежных средств с детализацией по статьям за выбранный период времени в валюте учета.'");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли