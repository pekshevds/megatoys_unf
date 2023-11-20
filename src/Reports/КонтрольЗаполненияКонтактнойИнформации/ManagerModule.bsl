#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
Функция ВариантыНастроек() Экспорт

	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "КонтрольЗаполненияКонтактнойИнформации", НСтр(
		"ru = 'Контроль заполнения контактной информации'")));

	Возврат Результат;

КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.КонтрольЗаполненияКонтактнойИнформации, "КонтрольЗаполненияКонтактнойИнформации");
	Вариант.Описание = НСтр("ru = 'Отчет предназначен для контроля заполненности контактной информации у контрагентов и контактных лиц.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.CRM.Подсистемы.CRMПодраздел, "Важный");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
