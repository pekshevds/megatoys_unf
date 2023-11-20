
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
		НСтр("ru = 'Доходы и расходы по статьям (по отгрузке)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ДоходыИРасходыПоЗаказам", 
		НСтр("ru = 'Доходы и расходы по заказам покупателей (по отгрузке)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ДинамикаДоходовИРасходов", 
		НСтр("ru = 'Динамика доходов и расходов (по отгрузке)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ДоходыИРасходыПоПроектам", 
		НСтр("ru = 'Доходы и расходы по проектам'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДоходыИРасходы, "Ведомость");
	Вариант.Описание = НСтр("ru = 'Отчет содержит данные о доходах и расходах (по отгрузке).'");
	Вариант.Размещение.Вставить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы());
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Компания.Подсистемы.Компания, "Важный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДоходыИРасходы, "ДоходыИРасходыПоЗаказам");
	Вариант.Описание = НСтр("ru = 'Отчет содержит данные о доходах и расходах по заказам покупателей(по отгрузке).'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Компания.Подсистемы.Компания, "Важный");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДоходыИРасходы, "ДинамикаДоходовИРасходов");
	Вариант.Описание = НСтр("ru = 'Динамика изменения доходов, расходов, прибыли (по отгрузке) за указанный период.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Компания.Подсистемы.Компания, "Важный");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ДоходыИРасходы, "ДоходыИРасходыПоПроектам");
	Вариант.Описание = НСтр("ru = 'Отчет содержит данные о доходах и расходах в разрезе проектов'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Компания.Подсистемы.Компания, "Важный");
	Вариант.ФункциональныеОпции.Добавить("УчетПоПроектам");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли