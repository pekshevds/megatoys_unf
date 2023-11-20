#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Если Не НачальноеЗаполнениеЭлементовВыполнено() Тогда
		Элемент = Элементы.Добавить();
		Элемент.Наименование = НСтр("ru='Не устроили условия'");
		
		Элемент = Элементы.Добавить();
		Элемент.Наименование = НСтр("ru='Выбрали другую компанию'");
	КонецЕсли;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлемента
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	Объект.УстановитьНовыйКод();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Будет удалена в следующей версии.
//
Процедура ЗаполнитьПоставляемыеПричиныНеуспешногоЗавершенияРаботыСЛидом() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПричиныНеуспешногоЗавершенияРаботыСЛидом.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПричиныНеуспешногоЗавершенияРаботыСЛидом КАК ПричиныНеуспешногоЗавершенияРаботыСЛидом";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		// 1. Причина "Пропала потребность"
		Причина = Справочники.ПричиныНеуспешногоЗавершенияРаботыСЛидом.СоздатьЭлемент();
		Причина.Наименование	= НСтр("ru='Не устроили условия'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Причина);
		
		// 2. Причина "Выбрали других"
		Причина = Справочники.ПричиныНеуспешногоЗавершенияРаботыСЛидом.СоздатьЭлемент();
		Причина.Наименование	= НСтр("ru='Выбрали другую компанию'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Причина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить справочник ""Причины неуспешного завершения работы с лидом"" по умолчанию по причине:
				|%1'"), 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.ПричиныНеуспешногоЗавершенияРаботыСЛидом, , ТекстСообщения);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачальноеЗаполнениеЭлементовВыполнено()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПричиныНеуспешногоЗавершенияРаботыСЛидом.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПричиныНеуспешногоЗавершенияРаботыСЛидом КАК ПричиныНеуспешногоЗавершенияРаботыСЛидом
	|ГДЕ
	|	ПричиныНеуспешногоЗавершенияРаботыСЛидом.Предопределенный = ЛОЖЬ";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
