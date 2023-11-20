#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда	
		Возврат;		
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	СуммовойУчетВРознице.НомерСтроки КАК НомерСтроки,
	|	СуммовойУчетВРознице.Организация КАК Организация,
	|	СуммовойУчетВРознице.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СуммовойУчетВРознице.Валюта КАК Валюта,
	|	СуммовойУчетВРознице.Сумма КАК СуммаПередЗаписью,
	|	СуммовойУчетВРознице.Сумма КАК СуммаИзменение,
	|	СуммовойУчетВРознице.Сумма КАК СуммаПриЗаписи,
	|	СуммовойУчетВРознице.СуммаВал КАК СуммаВалПередЗаписью,
	|	СуммовойУчетВРознице.СуммаВал КАК СуммаВалИзменение,
	|	СуммовойУчетВРознице.СуммаВал КАК СуммаВалПриЗаписи,
	|	СуммовойУчетВРознице.Себестоимость КАК СебестоимостьПередЗаписью,
	|	СуммовойУчетВРознице.Себестоимость КАК СебестоимостьИзменение,
	|	СуммовойУчетВРознице.Себестоимость КАК СебестоимостьПриЗаписи
	|ПОМЕСТИТЬ ДвиженияСуммовойУчетВРозницеИзменение
	|ИЗ
	|	РегистрНакопления.СуммовойУчетВРознице КАК СуммовойУчетВРознице");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияСуммовойУчетВРозницеИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(СтруктурнаяЕдиница)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли