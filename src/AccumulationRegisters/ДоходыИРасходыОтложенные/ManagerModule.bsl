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
	|	ДоходыИРасходыОтложенные.НомерСтроки КАК НомерСтроки,
	|	ДоходыИРасходыОтложенные.Организация КАК Организация,
	|	ДоходыИРасходыОтложенные.Документ КАК Документ,
	|	ДоходыИРасходыОтложенные.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДоходыИРасходыОтложенные.СуммаДоходов КАК СуммаДоходовПередЗаписью,
	|	ДоходыИРасходыОтложенные.СуммаДоходов КАК СуммаДоходовИзменение,
	|	ДоходыИРасходыОтложенные.СуммаДоходов КАК СуммаДоходовПриЗаписи,
	|	ДоходыИРасходыОтложенные.СуммаРасходов КАК СуммаРасходовПередЗаписью,
	|	ДоходыИРасходыОтложенные.СуммаРасходов КАК СуммаРасходовИзменение,
	|	ДоходыИРасходыОтложенные.СуммаРасходов КАК СуммаРасходовлПриЗаписи
	|ПОМЕСТИТЬ ДвиженияДоходыИРасходыОтложенныеИзменение
	|ИЗ
	|	РегистрНакопления.ДоходыИРасходыОтложенные КАК ДоходыИРасходыОтложенные");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияДоходыИРасходыОтложенныеИзменение", Ложь);
	
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
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли