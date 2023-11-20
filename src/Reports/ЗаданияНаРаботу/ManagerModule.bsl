
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
	Результат.Добавить(Новый Структура("Имя, Представление", "Основной", 
		НСтр("ru = 'Задания на работу'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ОсновнойПодробно", 
		НСтр("ru = 'Задания на работу (подробно)'")));		
	Результат.Добавить(Новый Структура("Имя, Представление", "ОтчетЗаказчику", 
		НСтр("ru = 'Отчет заказчику'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗаданияНаРаботу, "Основной");
	Вариант.Описание = НСтр("ru = 'Отчет показывает запланированные и выполненные задания на работу.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Работы.Подсистемы.Задания, "Важный");

	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗаданияНаРаботу, "ОсновнойПодробно");
	Вариант.Описание = НСтр("ru = 'Отчет показывает запланированные и выполненные задания на работу (с описанием).'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Работы.Подсистемы.Задания, "Важный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗаданияНаРаботу, "ОтчетЗаказчику");
	Вариант.Описание = НСтр("ru = 'Отчет предназначен для предоставления сведений заказчику о выполненных заданиях на работу.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Работы.Подсистемы.Задания, "Важный");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли