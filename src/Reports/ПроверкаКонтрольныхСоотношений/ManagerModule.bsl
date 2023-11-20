
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СформироватьТаблицуРезультата() Экспорт 
	
	ТаблицаРезультата = Новый ТаблицаЗначений;
	
	ТаблицаРезультата.Колонки.Добавить("Раздел");
	ТаблицаРезультата.Колонки.Добавить("Приоритет");
	
	ТаблицаРезультата.Колонки.Добавить("НомерЭлемента");
	ТаблицаРезультата.Колонки.Добавить("НомерКС");
	
	ТаблицаРезультата.Колонки.Добавить("Описание");
	ТаблицаРезультата.Колонки.Добавить("Детализация");
	ТаблицаРезультата.Колонки.Добавить("Нарушение");
	ТаблицаРезультата.Колонки.Добавить("Основание");
	ТаблицаРезультата.Колонки.Добавить("Рекомендации");
	
	ТаблицаРезультата.Колонки.Добавить("ДопСведения");
	ТаблицаРезультата.Колонки.Добавить("Комментарий");
	
	ТаблицаРезультата.Колонки.Добавить("ЭтоОшибка");
	
	ТаблицаРезультата.Индексы.Добавить("НомерЭлемента");
	
	Возврат ТаблицаРезультата;
	
КонецФункции

Функция СформироватьТаблицуРасшифровки() Экспорт
	
	ТаблицаРасшифровки = Новый ТаблицаЗначений;
	
	ТаблицаРасшифровки.Колонки.Добавить("НомерЭлемента");
	
	ТаблицаРасшифровки.Колонки.Добавить("СсылкаНаОтчет");
	ТаблицаРасшифровки.Колонки.Добавить("ИмяРаздела");
	ТаблицаРасшифровки.Колонки.Добавить("ИмяПоказателя");
	ТаблицаРасшифровки.Колонки.Добавить("НомерСтраницы"); 
	
	ТаблицаРасшифровки.Колонки.Добавить("ПредставлениеПоказателя");
	ТаблицаРасшифровки.Колонки.Добавить("ЗначениеПоказателя");
	
	ТаблицаРасшифровки.Индексы.Добавить("НомерЭлемента");
	
	Возврат ТаблицаРасшифровки;
	
КонецФункции

Функция СформироватьТаблицуОписаний() Экспорт
	
	ТаблицаОписаний = Новый ТаблицаЗначений;
	
	ТаблицаОписаний.Колонки.Добавить("НомерЭлемента");
	ТаблицаОписаний.Колонки.Добавить("НомерКС");
	
	ТаблицаОписаний.Колонки.Добавить("Раздел");
	ТаблицаОписаний.Колонки.Добавить("Приоритет");
	ТаблицаОписаний.Колонки.Добавить("Описание");
	ТаблицаОписаний.Колонки.Добавить("Нарушение");
	ТаблицаОписаний.Колонки.Добавить("Основание");
	ТаблицаОписаний.Колонки.Добавить("Рекомендации");
	ТаблицаОписаний.Колонки.Добавить("ШаблонДетализации");
	
	ТаблицаОписаний.Колонки.Добавить("Условие");
	ТаблицаОписаний.Колонки.Добавить("ДляДокументации");
	ТаблицаОписаний.Колонки.Добавить("Комментарий");
	
	Возврат ТаблицаОписаний;
	
КонецФункции

#КонецОбласти

#КонецЕсли