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
	|	ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

// Возвращает один из действующих проектов по переданному договору
//
// Параметры:
//   Договор - СправочникСсылка.ДоговорыКонтрагентов - Договор, по которому необходимо найти проект
//
Функция ПолучитьПроектПоДоговору(Договор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Проекты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Проекты КАК Проекты
		|ГДЕ
		|	Проекты.Договор = &Договор
		|	И (Проекты.ДатаНачала <= &ТекущаяДата
		|			ИЛИ Проекты.ДатаНачала = &ПустаяДата)
		|	И (Проекты.ДатаОкончания >= &ТекущаяДата
		|			ИЛИ Проекты.ДатаОкончания = &ПустаяДата)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Проекты.ДатаНачала";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	
	ВыборкаПроектов = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаПроектов.Следующий() Тогда
		Возврат ВыборкаПроектов.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.Проекты.ПустаяСсылка();

КонецФункции

// Возвращает таблицу значений с доходами и расходами по статьям за указанный период
//
// Параметры:
//  Проект			 - СправочникСсылка.Проекты	 - Проект, по которому будут собираться доходы и расходы
//  НачальнаяДата	 - Дата						 - Дата, с которой начинается поиск доходов и расходов
//  КонечнаяДата	 - Дата						 - Дата, до которой осуществляется поиск.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица значений с колонками Статья, Доход, Расход, Период. 
//
Функция ПолучитьДоходыИРасходыПоПроекту(Проект, НачальнаяДата, КонечнаяДата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоходыИРасходыОбороты.СчетУчета КАК Статья,
	|	ДоходыИРасходыОбороты.СуммаДоходовОборот КАК Доход,
	|	ДоходыИРасходыОбороты.СуммаРасходовОборот КАК Расход,
	|	ДоходыИРасходыОбороты.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ДоходыИРасходы.Обороты(&НачальнаяДата, &КонечнаяДата, Месяц, Проект = &Проект) КАК ДоходыИРасходыОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДоходыИРасходыОбороты.Период";
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("НачальнаяДата", НачальнаяДата);
	Запрос.УстановитьПараметр("КонечнаяДата", КонецДня(КонечнаяДата));
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
	
КонецФункции


// Заполняет реквизит "Проект" в переданном документе из данных, переданных в параметрах
//
// Параметры:
//  ДанныеЗаполнения - 	 - ДокументСсылка, Структура - Документ, из которого берется реквизит "Проект"
//  ДокументОбъект	 - 	 - ДокументОбъект 			 - Документ, в котором будет заполнен реквизит "Проект"
//
Процедура ЗаполнитьПроектВДокументе(ДанныеЗаполнения, ДокументОбъект) Экспорт
	
	Если НЕ ОбщегоНазначения.ЕстьРеквизитОбъекта("Проект", ДокументОбъект.Метаданные()) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектЗаполнения = Неопределено;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		МетаданныеОбъекта = ДанныеЗаполнения.Метаданные();
		ОбъектЗаполнения = ДанныеЗаполнения;
	Иначе
		Для Каждого Элемент Из ДанныеЗаполнения Цикл
			Если НЕ ОбщегоНазначения.ЗначениеСсылочногоТипа(Элемент.Значение) Тогда
				Продолжить;
			КонецЕсли;
			Если ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(Элемент.Значение.Метаданные()) Тогда
				ОбъектЗаполнения = Элемент.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ОбъектЗаполнения = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		МетаданныеОбъекта = ОбъектЗаполнения.Метаданные();
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Проект", МетаданныеОбъекта) Тогда
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПоложениеПроекта", МетаданныеОбъекта) Тогда
			Если ОбъектЗаполнения.ПоложениеПроекта = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
				Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПоложениеПроекта", ДокументОбъект.Метаданные()) Тогда
					ДокументОбъект.ПоложениеПроекта = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
				КонецЕсли;
				ДокументОбъект.Проект = ПроектИзТабличнойЧасти(ОбъектЗаполнения);
			Иначе
				ДокументОбъект.Проект = ОбъектЗаполнения.Проект;
			КонецЕсли;
		Иначе
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПоложениеПроекта", ДокументОбъект.Метаданные()) Тогда
				ДокументОбъект.ПоложениеПроекта = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
			КонецЕсли;
			ДокументОбъект.Проект = ОбъектЗаполнения.Проект;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает первое найденное значение реквизита "Проект" в строке табличной части документа
//
// Параметры:
//  ДанныеЗаполнения - 	ДокументСсылка - Документ, в котором осуществляется поиск реквизита "Проект" в табличной части
// 
// Возвращаемое значение:
//  СправочникСсылка.Проекты, Неопределено - Ссылка на объект справочника "Проект". Если проект не был найден,
//                                           возвращает Неопределено
//
Функция ПроектИзТабличнойЧасти(ДанныеЗаполнения)
	
	ОбъектМетаданных = ДанныеЗаполнения.Метаданные();
	НайденнаяТаблица = Неопределено;
	ТабличныеЧасти = ОбъектМетаданных.ТабличныеЧасти;
	Для Каждого Таблица Из ТабличныеЧасти Цикл
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Проект", Таблица) Тогда
			НайденнаяТаблица = Таблица;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НайденнаяТаблица = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаСПроектом = ДанныеЗаполнения[НайденнаяТаблица.Имя];
	
	Если ТаблицаСПроектом.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТаблицаСПроектом[0].Проект;
	
КонецФункции

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли