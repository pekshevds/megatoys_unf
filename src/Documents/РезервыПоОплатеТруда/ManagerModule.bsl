#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.РезервыПоОплатеТруда;
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	Для Каждого ОписаниеЗаполнения Из ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц Цикл
		ОписаниеЗаполнения.ВключатьВКраткийСостав = Истина;
	КонецЦикла;
	
	Возврат ОписаниеСостава;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеПодписейДокумента() Экспорт 

	ОписаниеПодписей = ПодписиДокументов.ОписаниеТаблицыПодписей();

	ОписаниеПодписиИсполнитель = ПодписиДокументов.ОписаниеРеквизитовПодписанта();
	ОписаниеПодписиИсполнитель.ФизическоеЛицо   = "Исполнитель";
	ОписаниеПодписиИсполнитель.Должность        = "ДолжностьИсполнителя";
	ОписаниеПодписиИсполнитель.ОснованиеПодписи = "ОснованиеПодписиИсполнителя";

	ПереопределяемыеИмена = Новый Соответствие;
	ПереопределяемыеИмена.Вставить("Исполнитель", ОписаниеПодписиИсполнитель);

	ПодписиДокументов.ДобавитьОписаниеПодписейОрганизации(
		ОписаниеПодписей,
		"Исполнитель",
		ПереопределяемыеИмена);

	Возврат ОписаниеПодписей;

КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаДокумента"
		И ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаДокумента";
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаДокумента";
	КонецЕсли;
	
КонецПроцедуры

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеОценочныхОбязательствЗарплатаКадры,ЧтениеОценочныхОбязательствЗарплатаКадры", , Ложь) Тогда
		Если ПолучитьФункциональнуюОпцию("РасчетЗарплатыДляНебольшихОрганизаций") Тогда
			
			СписокОперацийСКомандамиПечати = Новый СписокЗначений;
			СписокОперацийСКомандамиПечати.Добавить(Перечисления.ВидыОперацийРезервовПоОплатеТруда.Начисление);
			СписокОперацийСКомандамиПечати.Добавить(Перечисления.ВидыОперацийРезервовПоОплатеТруда.Инвентаризация);
			
			КомандаПечати = КомандыПечати.Добавить();
			КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
			КомандаПечати.МенеджерПечати = "Документ.РезервыПоОплатеТруда";
			КомандаПечати.Идентификатор = "ПФ_MXL_СправкаРасчетРезервовПоОплатеТруда";
			КомандаПечати.Представление = НСтр("ru = 'Справка-расчет'");
			КомандаПечати.Порядок = 20;
			КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
			КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "ВидОперации", СписокОперацийСКомандамиПечати, ВидСравненияКомпоновкиДанных.ВСписке);
			
			КомандаПечати = КомандыПечати.Добавить();
			КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
			КомандаПечати.МенеджерПечати = "Документ.РезервыПоОплатеТруда";
			КомандаПечати.Идентификатор = "ПФ_MXL_СправкаРасчетРезервовПоОплатеТрудаНУ";
			КомандаПечати.Представление = НСтр("ru = 'Справка-расчет (налоговый учет)'");
			КомандаПечати.Порядок = 30;
			КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
			КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "ВидОперации", СписокОперацийСКомандамиПечати, ВидСравненияКомпоновкиДанных.ВСписке);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Сформировать печатные формы
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	РезервыПоОплатеТруда.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

#КонецОбласти

Функция ТребуетсяУтверждениеДокументаБухгалтером(Организация = Неопределено) Экспорт
	
	// Подтверждение требуется, если используется обмен с бухгалтерией.
	
	// ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3")
		И Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		Возврат Модуль.ОбменИспользуется(Организация);
		
	КонецЕсли;
	// Конец ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	
	Возврат Ложь;
	
КонецФункции

Процедура ПодготовитьДанныеДляОтраженияВУчете(ДокументСсылка, ДанныеДляОтражения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РезервыПоОплатеТруда.Организация КАК Организация,
	|	РезервыПоОплатеТруда.ВидОперации КАК ВидОперации,
	|	РезервыПоОплатеТруда.Резерв КАК Резерв,
	|	РезервыПоОплатеТруда.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_ОписаниеДокумента
	|ИЗ
	|	Документ.РезервыПоОплатеТруда КАК РезервыПоОплатеТруда
	|ГДЕ
	|	РезервыПоОплатеТруда.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОписаниеДокумента.Организация КАК Организация,
	|	ВТ_ОписаниеДокумента.ВидОперации КАК ВидОперации,
	|	ВТ_ОписаниеДокумента.Резерв КАК Резерв,
	|	ВТ_ОписаниеДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	ВТ_ОписаниеДокумента КАК ВТ_ОписаниеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОценочныеОбязательстваПоСотрудникам.*,
	|	ВТ_ОписаниеДокумента.Резерв КАК Резерв
	|ИЗ
	|	Документ.РезервыПоОплатеТруда.ОценочныеОбязательстваПоСотрудникам КАК ОценочныеОбязательстваПоСотрудникам
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОписаниеДокумента КАК ВТ_ОписаниеДокумента
	|		ПО ОценочныеОбязательстваПоСотрудникам.Ссылка = ВТ_ОписаниеДокумента.Ссылка
	|ГДЕ
	|	ОценочныеОбязательстваПоСотрудникам.Ссылка В
	|		(ВЫБРАТЬ
	|			ВТ_ОписаниеДокумента.Ссылка
	|		ИЗ
	|			ВТ_ОписаниеДокумента)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОценочныеОбязательства.*,
	|	ВТ_ОписаниеДокумента.Резерв КАК Резерв
	|ИЗ
	|	Документ.РезервыПоОплатеТруда.ОценочныеОбязательства КАК ОценочныеОбязательства
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОписаниеДокумента КАК ВТ_ОписаниеДокумента
	|		ПО ОценочныеОбязательства.Ссылка = ВТ_ОписаниеДокумента.Ссылка
	|ГДЕ
	|	ОценочныеОбязательства.Ссылка В
	|		(ВЫБРАТЬ
	|			ВТ_ОписаниеДокумента.Ссылка
	|		ИЗ
	|			ВТ_ОписаниеДокумента)";
	
	Результат = Запрос.ВыполнитьПакет();
	
	ОписаниеДокумента                   = Результат[1].Выгрузить();
	ОценочныеОбязательстваПоСотрудникам = Результат[2].Выгрузить();
	ОценочныеОбязательства              = Результат[3].Выгрузить();
	
	ДанныеДляОтражения.ВидОперации                         = ОписаниеДокумента[0].ВидОперации;
	ДанныеДляОтражения.ОценочныеОбязательстваПоСотрудникам = ОценочныеОбязательстваПоСотрудникам;
	ДанныеДляОтражения.ОценочныеОбязательства              = ОценочныеОбязательства;
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезервыПоОплатеТруда.ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
	
КонецПроцедуры

Процедура ВыполнитьПроведение(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДокументОбъект = ЗарплатаКадры.ДесериализоватьОбъектИзДвоичныхДанных(СтруктураПараметров.ДанныеДокумента);
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	ПоместитьВоВременноеХранилище(ЗарплатаКадры.СериализоватьОбъектВДвоичныеДанные(ДокументОбъект), АдресХранилища);
	
КонецПроцедуры

Процедура ОбновитьОтражениеВУчете(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервыПоОплатеТруда.ОбновитьОтражениеВУчете(ЭтотОбъект);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект, ИмяТаблицы", Истина, ЭтотОбъект, "ОценочныеОбязательства");
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

#КонецОбласти

#КонецЕсли