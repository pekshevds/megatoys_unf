#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - в зависимости от факта добавления отчета
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.АнализРасхожденийПриДвиженииЗЕРНО) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.АнализРасхожденийПриДвиженииЗЕРНО.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Расхождения при движении продукции ЗЕРНО'");
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ВестиУчетЗернаИПродуктовПереработкиЗЕРНО";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "АнализРасхожденийПриДвиженииПродукцииЗЕРНО");
		КомандаОтчет.ЕстьУсловияВидимости = Истина;
		
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаОтчет, "ДокументОснование",, ВидСравненияКомпоновкиДанных.Заполнено);
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Структура - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); 
// Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	
	НастройкиВарианта.ФункциональныеОпции.Добавить("ВестиУчетЗернаИПродуктовПереработкиЗЕРНО");
	НастройкиВарианта.ВидимостьПоУмолчанию = Истина;
	НастройкиВарианта.Описание = НСтр("ru= 'Выявление и анализ расхождений между документами ЗЕРНО и учетными документами.'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей = НСтр("ru= 'ЗЕРНО'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли