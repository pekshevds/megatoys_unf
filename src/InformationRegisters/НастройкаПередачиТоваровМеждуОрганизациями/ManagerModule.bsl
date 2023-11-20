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
	|	ЗначениеРазрешено(ОрганизацияВладелец)
	|	ИЛИ ЗначениеРазрешено(ОрганизацияПродавец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

Функция ПолучитьНастройкиТоваровМеждуОрганизациями(Владелец, Продавец) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкаПередачиТоваровМеждуОрганизациями.ОрганизацияВладелец КАК ОрганизацияВладелец,
	|	НастройкаПередачиТоваровМеждуОрганизациями.ОрганизацияПродавец КАК ОрганизацияПродавец,
	|	НастройкаПередачиТоваровМеждуОрганизациями.Контрагент КАК Контрагент,
	|	НастройкаПередачиТоваровМеждуОрганизациями.СпособПередачиТоваров КАК СпособПередачиТоваров,
	|	НастройкаПередачиТоваровМеждуОрганизациями.Валюта КАК Валюта,
	|	НастройкаПередачиТоваровМеждуОрганизациями.Договор КАК Договор,
	|	НастройкаПередачиТоваровМеждуОрганизациями.ВидЦены КАК ВидЦены
	|ИЗ
	|	РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК НастройкаПередачиТоваровМеждуОрганизациями
	|ГДЕ
	|	НастройкаПередачиТоваровМеждуОрганизациями.ОрганизацияВладелец = &ОрганизацияВладелец
	|	И НастройкаПередачиТоваровМеждуОрганизациями.ОрганизацияПродавец = &ОрганизацияПродавец";
	Запрос.УстановитьПараметр("ОрганизацияВладелец", Владелец);
	Запрос.УстановитьПараметр("ОрганизацияПродавец", Продавец);
	
	Возврат Запрос.Выполнить().Выбрать().Следующий();
	
КонецФункции

// Проверка наличия незакрытых резервов передачи товаров для указанных организаций
//
// Параметры:
//  ОрганизацияВладелец	 - СправочникСсылка.Организации	 - Организация-владелец товаров
//  ОрганизацияПродавец	 - СправочникСсылка.Организации	 - Организация продажи
// 
// Возвращаемое значение:
//  Булево - Признак наличия остатка резервов
//
Функция ЕстьНезакрытыеРезервы(ОрганизацияВладелец, ОрганизацияПродавец) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияВладелец", ОрганизацияВладелец);
	Запрос.УстановитьПараметр("ОрганизацияПродавец", ОрганизацияПродавец);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РезервыТоваровОрганизацийОстатки.Организация КАК Организация
	|ИЗ
	|	РегистрНакопления.РезервыТоваровОрганизаций.Остатки КАК РезервыТоваровОрганизацийОстатки
	|ГДЕ
	|	РезервыТоваровОрганизацийОстатки.Организация = &ОрганизацияВладелец
	|	И РезервыТоваровОрганизацийОстатки.КоличествоОстаток <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РезервыТоваровОрганизацийОстатки.Организация
	|ИЗ
	|	РегистрНакопления.РезервыТоваровОрганизаций.Остатки КАК РезервыТоваровОрганизацийОстатки
	|ГДЕ
	|	РезервыТоваровОрганизацийОстатки.Организация = &ОрганизацияПродавец
	|	И РезервыТоваровОрганизацийОстатки.КоличествоОстаток <> 0";
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецОбласти


#КонецЕсли
