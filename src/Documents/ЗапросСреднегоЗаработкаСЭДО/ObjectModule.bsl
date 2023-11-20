///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	// Второстепенные реквизиты шапки заполняются в функции ОбновитьВторичныеДанные.
	ФиксацияИзменений.Очистить();
	
	// Заполнение ключевых реквизитов шапки, от которых строится учет.
	СНИЛС               = ОбъектКопирования.СНИЛС;
	ФизическоеЛицо      = ОбъектКопирования.ФизическоеЛицо;
	Страхователь        = ОбъектКопирования.Страхователь;
	ГоловнаяОрганизация = ОбъектКопирования.ГоловнаяОрганизация;
	
	// Ссылки сотрудника и организации могут меняться если сотрудник был переведен, или уволен и принят.
	Организация = Неопределено;
	
	// Очистка результатов.
	ОтключитьПроверкиПроведения = Ложь;
	ХранилищеXML                = Неопределено;
	ДатаОтправки                = Неопределено;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если Метаданные().Реквизиты.ДокументОснование.Тип.СодержитТип(ТипЗнч(ДанныеЗаполнения))
		И ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ДокументОснование = ДанныеЗаполнения;
		ЗаполнитьПоДокументуОснованию();
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ФизическоеЛицо = ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "ГоловнаяОрганизация, ФизическоеЛицо");
		ГоловнаяОрганизация = РеквизитыОснования.ГоловнаяОрганизация;
		ФизическоеЛицо      = РеквизитыОснования.ФизическоеЛицо;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ОбновитьВторичныеДанные();
	
	// Учет строится от СНИЛС и страхователя, а ссылки сотрудника и организации могут устареть.
	Организация = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьСНИЛС(Отказ);
	ПроверитьФлажкиИСведенияОбЭЛН(Отказ);
	ПроверитьГоды(Отказ);
	
	// Проверка что на дату нет других действующих сведений.
	Если Не ДополнительныеСвойства.Свойство("КритичныеПроверкиЗаполненияВыполнены") Тогда
		Ошибки = КритичныеОшибкиЗаполнения();
		Для Каждого Ошибка Из Ошибки Цикл
			Отказ = Истина;
			Ошибка.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	// Заполнение недостающих полей.
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата(); // АПК:143 Для фильтрации событий в журнале регистрации требуется дата сервера.
	КонецЕсли;
	
	// Далее - бизнес-логика, выход если она отключена.
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПроведение = (РежимЗаписи = РежимЗаписиДокумента.Проведение
		Или (Проведен И РежимЗаписи = РежимЗаписиДокумента.Запись));
	
	Если Не ПометкаУдаления И Не ДополнительныеСвойства.Свойство("КритичныеПроверкиЗаполненияВыполнены") Тогда
		Ошибки = КритичныеОшибкиЗаполнения();
		Если Ошибки.Количество() > 0 Тогда
			ТекстыОшибок = Новый Массив;
			Для Каждого Ошибка Из Ошибки Цикл
				ТекстыОшибок.Добавить(Ошибка.Текст);
			КонецЦикла;
			ВызватьИсключение СтрСоединить(ТекстыОшибок, Символы.ПС);
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоПроведение Тогда
		ТекстXML = Документы.ЗапросСреднегоЗаработкаСЭДО.ТекстXML(ЭтотОбъект);
	Иначе
		ТекстXML = "";
	КонецЕсли;
	ХранилищеXML = Новый ХранилищеЗначения(ТекстXML, Новый СжатиеДанных(9));
	
	ЗначенияРеквизитовДоЗаписи = ЗначенияРеквизитовДоЗаписи();
	ДополнительныеСвойства.Вставить("ЗначенияРеквизитовДоЗаписи", ЗначенияРеквизитовДоЗаписи);
	
	Если ЗначениеЗаполнено(ДатаОтправки)
		И ЗначениеЗаполнено(ЗначенияРеквизитовДоЗаписи.ФизическоеЛицо)
		И ЗначенияРеквизитовДоЗаписи.ФизическоеЛицо <> ФизическоеЛицо Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимо изменять физическое лицо в отправленном документе.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьПоДокументуОснованию()
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПриемНаРаботу") Тогда
		
		ИменаПолей = "Организация, ФизическоеЛицо";
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, ИменаПолей);
		Страхователь   = СЭДОФСС.СтраховательОрганизации(РеквизитыОснования.Организация);
		ФизическоеЛицо = РеквизитыОснования.ФизическоеЛицо;
		
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.БольничныйЛист") Тогда
		
		ИменаПолей = "Организация, ФизическоеЛицо, НомерЛисткаНетрудоспособности";
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, ИменаПолей);
		Страхователь   = СЭДОФСС.СтраховательОрганизации(РеквизитыОснования.Организация);
		ФизическоеЛицо = РеквизитыОснования.ФизическоеЛицо;
		НомерЛН        = РеквизитыОснования.НомерЛисткаНетрудоспособности;
		
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВходящийЗапросФССДляРасчетаПособия")
		Или ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтветНаЗапросФССДляРасчетаПособия") Тогда
		
		ИменаПолей = "Страхователь, ФизическоеЛицо, НомерЛН";
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, ИменаПолей);
		Страхователь   = РеквизитыОснования.Страхователь;
		ФизическоеЛицо = РеквизитыОснования.ФизическоеЛицо;
		НомерЛН        = РеквизитыОснования.НомерЛН;
		
	Иначе
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументОснование);
		Менеджер.ЗаполнитьЗапросСреднегоЗаработкаСЭДО(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПроверкиЗаполнения

Процедура ПроверитьСНИЛС(Отказ)
	Если Не ЗначениеЗаполнено(СНИЛС) Тогда
		ПроверкиБЗК.ПроверитьЗаполнениеРеквизитаОбъекта(Отказ, ЭтотОбъект, "СНИЛС");
	Иначе
		ТекстОшибки = "";
		Если Не РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(СНИЛС, ТекстОшибки) Тогда
			Текст = НСтр("ru = 'Ошибка в СНИЛС %1: %2'");
			Текст = СтрШаблон(Текст, СНИЛС, ТекстОшибки);
			СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "СНИЛС");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьФлажкиИСведенияОбЭЛН(Отказ)
	Если Не СотрудникПодписалСогласие Тогда
		Текст = НСтр("ru = 'Необходимо чтобы сотрудник подписал согласие на получение сведений СФР о среднем заработке'");
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "СотрудникПодписалСогласие");
	КонецЕсли;
	Если Не ВидДоговораГПХ И Не ВидДоговораТрудовой Тогда
		Текст = НСтр("ru = 'Необходимо выбрать вид договора с застрахованным лицом'");
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ВидДоговораТрудовой");
	КонецЕсли;
	Если РасчетБольничного И Не Числится И Не ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		Текст = НСтр("ru = 'Если сотрудник уволен, то при включенном флажке ЭЛН необходимо указать дату начала нетрудоспособности (либо указать № ЭЛН)'");
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДатаНачалаСобытия");
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьГоды(Отказ)
	ПроверитьГод(Отказ, "РасчетныйГод1");
	ПроверитьГод(Отказ, "РасчетныйГод2");
	ПроверитьГод(Отказ, "ДополнительныйГод1");
	ПроверитьГод(Отказ, "ДополнительныйГод2");
	
	// Проверки годов ориентируются на следующие проверки сервиса:
	// ERR_SAL_0003: В блоке "Сведения о запрашиваемом периоде" обнаружено дублирование годов.
	// ERR_SAL_0005: Года в блоке "Сведения о запрашиваемом периоде" должны быть меньше года направления запроса (текущего года)
	// ERR_SAL_0006: Года в блоке "Два предшествующих года" должны быть без разрыва периода
	// ERR_SAL_0010: Года в блоке "Два предшествующих года" должны предшествовать году начала страхового случая
	// Сортировка годов не обязательна, но так работает "калькулятор" среднего и в целом это логично.
	
	ГодСобытия = ГодСобытия();
	Если РасчетныйГод2 <> ГодСобытия - 1 Тогда
		Текст = СтрШаблон(НСтр("ru = 'Второй год должен предшествовать дате события и быть равным %1'"),
			Формат(ГодСобытия - 1, "ЧГ="));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "РасчетныйГод2");
	КонецЕсли;
	Если РасчетныйГод1 <> РасчетныйГод2 - 1 Тогда
		Текст = СтрШаблон(НСтр("ru = 'Первый год должен предшествовать второму и быть равным %1'"),
			Формат(РасчетныйГод2 - 1, "ЧГ="));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "РасчетныйГод1");
	КонецЕсли;
	
	Если ДополнительныйГод1 = РасчетныйГод1 Или ДополнительныйГод1 = РасчетныйГод2 Тогда
		Текст = СтрШаблон(НСтр("ru = 'Дополнительный год %1 совпадает с расчетным годом'"), Формат(ДополнительныйГод1, "ЧГ="));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДополнительныйГод1");
	КонецЕсли;
	Если ДополнительныйГод2 = РасчетныйГод1 Или ДополнительныйГод2 = РасчетныйГод2 Тогда
		Текст = СтрШаблон(НСтр("ru = 'Дополнительный год %1 совпадает с расчетным годом'"), Формат(ДополнительныйГод2, "ЧГ="));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДополнительныйГод2");
	КонецЕсли;
	Если ДополнительныйГод2 > 0 И ДополнительныйГод2 = ДополнительныйГод1 Тогда
		Текст = СтрШаблон(НСтр("ru = 'Дублирование дополнительного года %1'"), Формат(ДополнительныйГод2, "ЧГ="));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДополнительныйГод2");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьГод(Отказ, ИмяРеквизита)
	ЗначениеРеквизита = ЭтотОбъект[ИмяРеквизита];
	Если ЗначениеРеквизита > 0 И ЗначениеРеквизита < 2019 Тогда
		Текст = СтрШаблон(НСтр("ru = 'Сервис предоставляет данные за период с 2019 года (выбран %1)'"), Формат(ЗначениеРеквизита, "ЧГ="));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, ИмяРеквизита);
	КонецЕсли;
КонецПроцедуры

Функция КритичныеОшибкиЗаполнения() Экспорт
	Ошибки = Новый Массив;
	
	// Если документ подготовлен к отправке, но не отправлен, то проверяется уникальность на дату.
	Если Не ПометкаУдаления И ЗначениеЗаполнено(ГоловнаяОрганизация) И ЗначениеЗаполнено(ФизическоеЛицо) И Не ЗначениеЗаполнено(ДатаОтправки) Тогда
		УстановитьПривилегированныйРежим(Истина);
		Настройки = ЗапросыБЗК.НастройкиЗапросаКТаблице();
		Настройки.УчитыватьRLS = Ложь;
		Настройки.Количество   = 1;
		Настройки.Порядок      = "Дата Убыв";
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "ГоловнаяОрганизация", "=",  ГоловнаяОрганизация);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "ФизическоеЛицо",      "=",  ФизическоеЛицо);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "Дата",                ">=", НачалоДня(Дата));
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "Дата",                "<=", КонецДня(Дата));
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "Ссылка",              "<>", Ссылка);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "ПометкаУдаления",     "=",  Ложь);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "ДатаОтправки",        "=",  '00010101');
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "РасчетныйГод1",       "=",  РасчетныйГод1);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "РасчетныйГод2",       "=",  РасчетныйГод2);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "ДополнительныйГод1",  "=",  ДополнительныйГод1);
		ЗапросыБЗК.ДобавитьОтбор(Настройки.Отбор, "ДополнительныйГод2",  "=",  ДополнительныйГод2);
		Запрос = ЗапросыБЗК.ЗапросКТаблице(Метаданные.Документы.ЗапросСреднегоЗаработкаСЭДО, "Ссылка, Дата", Настройки);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'На %1 уже есть запрос сведений СФР о среднем заработке от %2'");
			Сообщение.Текст = СтрШаблон(Сообщение.Текст, Формат(Дата, "ДЛФ=D"), Формат(Выборка.Дата, "ДЛФ=D"));
			Сообщение.Поле  = "Дата";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Ошибки.Добавить(Сообщение);
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("КритичныеПроверкиЗаполненияВыполнены", Истина);
	
	Возврат Ошибки;
КонецФункции

#КонецОбласти

#Область ПередЗаписью

Функция ЗначенияРеквизитовДоЗаписи()
	ИменаРеквизитов = "Дата, СНИЛС, Страхователь, ГоловнаяОрганизация, ФизическоеЛицо, ДатаОтправки, ПометкаУдаления, Проведен";
	ЭтоНовый = ЭтоНовый();
	Если ЭтоНовый Тогда
		Результат = ОбщегоНазначенияБЗК.ЗначенияСвойств(ЭтотОбъект, ИменаРеквизитов);
	Иначе
		Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	КонецЕсли;
	Результат.Вставить("ЭтоНовый", ЭтоНовый);
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ОбновитьВторичныеДанные(ПараметрыФиксации = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	Если ПараметрыФиксации = Неопределено Тогда
		ПараметрыФиксации = Документы.ЗапросСреднегоЗаработкаСЭДО.ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	Если ЗаполнитьФизическоеЛицо() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьГоловнуюОрганизацию() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьОрганизацию() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьСотрудника(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьСтрахователя(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьДанныеСтрахователя(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьВидДоговора(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьФлажокЧислится(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьКадровыеДанныеФизическогоЛица(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьСведенияОДоговореДляПечати(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьОтветственногоЗаОбработкуПерсональныхДанных(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьДанныеЭЛН(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьРасчетныеГоды(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьДополнительныеГоды(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция ОбъектЗафиксирован() Экспорт
	Возврат Документы.ЗапросСреднегоЗаработкаСЭДО.ОбъектЗафиксирован(ЭтотОбъект);
КонецФункции

Функция ЗаполнитьФизическоеЛицо(ПараметрыФиксации = Неопределено)
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Ложь;
	КонецЕсли;
	Если ЗначениеЗаполнено(СНИЛС) Тогда
		РезультатПоиска = ФизическиеЛицаЗарплатаКадры.ФизическоеЛицоПоСНИЛСИлиФИО(СНИЛС, "", "", "");
		Если ЗначениеЗаполнено(РезультатПоиска.ФизическоеЛицо) Тогда
			ФизическоеЛицо = РезультатПоиска.ФизическоеЛицо;
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция ЗаполнитьГоловнуюОрганизацию(ПараметрыФиксации = Неопределено)
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		Возврат Ложь;
	КонецЕсли;
	Если ЗначениеЗаполнено(Страхователь) Тогда
		ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
		Возврат Истина;
	ИначеЕсли ЗначениеЗаполнено(Организация) Тогда
		ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция ЗаполнитьОрганизацию(ПараметрыФиксации = Неопределено)
	Если ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудника();
	Если ЗначениеЗаполнено(КадровыеДанныеСотрудника.Организация) Тогда
		Организация = КадровыеДанныеСотрудника.Организация;
		Возврат Истина;
	КонецЕсли;
	СведенияОбЭЛН = СведенияОбЭЛН();
	Если СведенияОбЭЛН <> Неопределено
		И ЗначениеЗаполнено(СведенияОбЭЛН.Организация) Тогда
		Организация = СведенияОбЭЛН.Организация;
		Возврат Истина;
	КонецЕсли;
	Если ЗначениеЗаполнено(Страхователь) Тогда
		Организация = Страхователь;
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция ЗаполнитьСотрудника(ПараметрыФиксации)
	Реквизиты = Новый Структура("Сотрудник");
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудника();
	Если ЗначениеЗаполнено(КадровыеДанныеСотрудника.Сотрудник) Тогда
		Реквизиты.Сотрудник = КадровыеДанныеСотрудника.Сотрудник;
	Иначе
		СведенияОбЭЛН = СведенияОбЭЛН();
		Если СведенияОбЭЛН <> Неопределено
			И ЗначениеЗаполнено(СведенияОбЭЛН.Сотрудник) Тогда
			Реквизиты.Сотрудник = СведенияОбЭЛН.Сотрудник;
		КонецЕсли;
	КонецЕсли;
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьСтрахователя(ПараметрыФиксации)
	Реквизиты = Новый Структура("Страхователь");
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитыШапкиЗафиксированы(ЭтотОбъект, Реквизиты) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Реквизиты.Страхователь = СЭДОФСС.СтраховательОрганизации(Организация, Дата);
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьДанныеСтрахователя(ПараметрыФиксации)
	// Головная организация заполняется безусловно, т.к. определяет права.
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
	
	Реквизиты = Новый Структура("СтраховательНаименование, СтраховательНаименованиеДП,
		|НомерСтрахователяФСС, ИНН, КПП, СтраховательЮридическийАдрес");
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ИменаПолей = "НаимЮЛПол, НаимЮЛСокр, НомерСтрахователяФСС, ИННЮЛ, КППЮЛ, ПолныйАдрЮР";
		Сведения = ЗарплатаКадры.СведенияОбОрганизации(Страхователь, ИменаПолей);
		Если ЗначениеЗаполнено(Сведения.НаимЮЛСокр) И СтрДлина(Сведения.НаимЮЛПол) > 150 Тогда
			Реквизиты.СтраховательНаименование = Сведения.НаимЮЛСокр;
		Иначе
			Реквизиты.СтраховательНаименование = Сведения.НаимЮЛПол;
		КонецЕсли;
		Реквизиты.НомерСтрахователяФСС         = Сведения.НомерСтрахователяФСС;
		Реквизиты.ИНН                          = Сведения.ИННЮЛ;
		Реквизиты.КПП                          = Сведения.КППЮЛ;
		Реквизиты.СтраховательЮридическийАдрес = Сведения.ПолныйАдрЮР;
		Реквизиты.СтраховательНаименованиеДП   = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
			Реквизиты.СтраховательНаименование,
			3);
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьВидДоговора(ПараметрыФиксации)
	Реквизиты = Новый Структура("ВидДоговораТрудовой, ВидДоговораГПХ", Ложь, Ложь);
	
	ТекущийДоговорФизлица = ТекущийДоговорФизлица();
	Если ТекущийДоговорФизлица <> Неопределено Тогда
		Реквизиты.ВидДоговораТрудовой = ТекущийДоговорФизлица.Трудовой;
		Реквизиты.ВидДоговораГПХ      = ТекущийДоговорФизлица.ГПХ;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьФлажокЧислится(ПараметрыФиксации)
	Реквизиты = Новый Структура("Числится", ВидДоговораТрудовой Или ВидДоговораГПХ);
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьКадровыеДанныеФизическогоЛица(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Реквизиты = Новый Структура(
	"СотрудникФамилия,
	|СотрудникИмя,
	|СотрудникОтчество,
	|ДатаРождения,
	|Пол,
	|СНИЛС,
	|СотрудникПаспорт,
	|СотрудникАдрес");
	
	КадровыеДанные = КадровыеДанныеФизическогоЛица();
	Если КадровыеДанные.ФизическоеЛицо = ФизическоеЛицо Тогда
		Реквизиты.СотрудникФамилия  = КадровыеДанные.Фамилия;
		Реквизиты.СотрудникИмя      = КадровыеДанные.Имя;
		Реквизиты.СотрудникОтчество = КадровыеДанные.Отчество;
		Реквизиты.ДатаРождения      = КадровыеДанные.ДатаРождения;
		Реквизиты.Пол               = КадровыеДанные.Пол;
		Реквизиты.СНИЛС             = КадровыеДанные.СтраховойНомерПФР;
		Реквизиты.СотрудникПаспорт  = КадровыеДанные.ДокументПредставление;
		Реквизиты.СотрудникАдрес    = КадровыеДанные.АдресПоПропискеПредставление;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьДанныеЭЛН(ПараметрыФиксации)
	Реквизиты = Новый Структура("РасчетБольничного, ДатаНачалаСобытия");
	
	СведенияОбЭЛН = СведенияОбЭЛН();
	Если СведенияОбЭЛН <> Неопределено Тогда
		Реквизиты.РасчетБольничного = Истина;
		Реквизиты.ДатаНачалаСобытия = СведенияОбЭЛН.ДатаНачалаСобытия;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьРасчетныеГоды(ПараметрыФиксации)
	Реквизиты = Новый Структура("РасчетныйГод1, РасчетныйГод2");
	
	ГодСобытия = ГодСобытия();
	Если ЗначениеЗаполнено(ГодСобытия) Тогда
		Реквизиты.РасчетныйГод1 = ГодСобытия - 2;
		Реквизиты.РасчетныйГод2 = ГодСобытия - 1;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьДополнительныеГоды(ПараметрыФиксации)
	Реквизиты = Новый Структура("ДополнительныйГод1, ДополнительныйГод2");
	
	СведенияОбЭЛН = СведенияОбЭЛН();
	Если СведенияОбЭЛН <> Неопределено
		И ЗначениеЗаполнено(СведенияОбЭЛН.Больничный)
		И ЗначениеЗаполнено(РасчетныйГод1) Тогда
		РеквизитыБольничного = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СведенияОбЭЛН.Больничный,
			"ПериодРасчетаСреднегоЗаработкаПервыйГод, ПериодРасчетаСреднегоЗаработкаВторойГод");
		Если РеквизитыБольничного.ПериодРасчетаСреднегоЗаработкаПервыйГод <> РасчетныйГод1
			И РеквизитыБольничного.ПериодРасчетаСреднегоЗаработкаПервыйГод <> РасчетныйГод2 Тогда
			Реквизиты.ДополнительныйГод1 = РеквизитыБольничного.ПериодРасчетаСреднегоЗаработкаПервыйГод;
		КонецЕсли;
		Если РеквизитыБольничного.ПериодРасчетаСреднегоЗаработкаВторойГод <> РасчетныйГод1
			И РеквизитыБольничного.ПериодРасчетаСреднегоЗаработкаВторойГод <> РасчетныйГод2 Тогда
			Реквизиты.ДополнительныйГод2 = РеквизитыБольничного.ПериодРасчетаСреднегоЗаработкаВторойГод;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьСведенияОДоговореДляПечати(ПараметрыФиксации)
	Реквизиты = Новый Структура("ДатаНачалаДоговора, ДатаОкончанияДоговора, ТипДоговораРП", Ложь, Ложь);
	
	ТекущийДоговорФизлица = ТекущийДоговорФизлица();
	Если ТекущийДоговорФизлица <> Неопределено Тогда
		Реквизиты.ДатаНачалаДоговора    = ТекущийДоговорФизлица.Начало;
		Реквизиты.ДатаОкончанияДоговора = ТекущийДоговорФизлица.Окончание;
		Если ТекущийДоговорФизлица.Трудовой Тогда
			Реквизиты.ТипДоговораРП = НСтр("ru = 'трудового договора'");
		ИначеЕсли ТекущийДоговорФизлица.ОказаниеУслуг Тогда
			Реквизиты.ТипДоговораРП = НСтр("ru = 'договора гражданско-правового характера о выполнении работ (об оказании услуг)'");
		ИначеЕсли ТекущийДоговорФизлица.Авторский Тогда
			Реквизиты.ТипДоговораРП = НСтр("ru = 'договора авторского заказа'");
		Иначе
			Реквизиты.ТипДоговораРП = НСтр("ru = 'трудового договора, договора гражданско-правового характера о выполнении работ (об оказании услуг), договора авторского заказа, договора об отчуждении исключительного права на произведения науки, литературы, искусства, издательского лицензионного договора, лицензионного договора о предоставлении права использования произведения науки, литературы, искусства, в том числе договора о передаче полномочий по управлению правами, заключенного с организацией по управлению правами на коллективной основе, на вознаграждение по которым начисляются страховые взносы'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьОтветственногоЗаОбработкуПерсональныхДанных(ПараметрыФиксации)
	Реквизиты = Новый Структура("ОтветственныйФИО, ОтветственныйФИОРП", "", "");
	
	Если ЗначениеЗаполнено(Ответственный) Тогда
		ФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ответственный, "ФизическоеЛицо", Истина);
		Если ЗначениеЗаполнено(ФЛ) Тогда
			ФИО = "";
			ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьФИОФизическогоЛица(ФЛ, ФИО);
			Если ЗначениеЗаполнено(ФИО) Тогда
				Реквизиты.ОтветственныйФИО = ФИО;
				Реквизиты.ОтветственныйФИОРП = СклонениеПредставленийОбъектов.ПросклонятьПредставление(ФИО, 2, ФЛ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

#КонецОбласти

#Область КадровыеДанные

Функция КадровыеДанныеСотрудника(ИспользоватьКэшКадровыхДанныхФизическогоЛица = Истина)
	Если ДополнительныеСвойства.Свойство("СлужебныеКадровыеДанныеСотрудника") Тогда // Служебный кэш, соответствующий страхователю.
		Возврат ДополнительныеСвойства.СлужебныеКадровыеДанныеСотрудника;
	КонецЕсли;
	ИменаПолей = Документы.ЗапросСреднегоЗаработкаСЭДО.ИменаПолейТребуемыхКадровыхДанных();
	Результат = Новый Структура(ИменаПолей);
	Если ЗначениеЗаполнено(ФизическоеЛицо) И ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		КадровыеДанныеОсновногоСотрудника = СЭДОФСС.КадровыеДанныеОсновногоСотрудникаФизическогоЛица(
			ФизическоеЛицо,
			ГоловнаяОрганизация,
			ИменаПолей,
			Страхователь,
			Организация);
		Если КадровыеДанныеОсновногоСотрудника <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Результат, КадровыеДанныеОсновногоСотрудника);
			ДополнительныеСвойства.Вставить("СлужебныеКадровыеДанныеСотрудника", Результат);
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	Если ИспользоватьКэшКадровыхДанныхФизическогоЛица И ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ЗаполнитьЗначенияСвойств(Результат, КадровыеДанныеФизическогоЛица(Ложь));
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция КадровыеДанныеФизическогоЛица(ИспользоватьКэшКадровыхДанныхСотрудника = Истина)
	Если ДополнительныеСвойства.Свойство("СлужебныеКадровыеДанныеФизическогоЛица") Тогда
		Возврат ДополнительныеСвойства.СлужебныеКадровыеДанныеФизическогоЛица;
	КонецЕсли;
	ИменаПолей = Документы.ЗапросСреднегоЗаработкаСЭДО.ИменаПолейТребуемыхКадровыхДанныхФЛ();
	Результат = Новый Структура(ИменаПолей);
	Если ИспользоватьКэшКадровыхДанныхСотрудника Тогда
		КадровыеДанныеСотрудника = КадровыеДанныеСотрудника(Ложь);
		Если КадровыеДанныеСотрудника.ГоловнаяОрганизация = ГоловнаяОрганизация
			И КадровыеДанныеСотрудника.ФизическоеЛицо = ФизическоеЛицо Тогда
			ЗаполнитьЗначенияСвойств(Результат, КадровыеДанныеСотрудника());
			ДополнительныеСвойства.Вставить("СлужебныеКадровыеДанныеФизическогоЛица", Результат);
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		КадровыеДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическогоЛица(
			Истина,
			ФизическоеЛицо,
			ИменаПолей,
			ТекущаяДатаСеанса());
		Если КадровыеДанныеФизическогоЛица <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Результат, КадровыеДанныеФизическогоЛица);
			ДополнительныеСвойства.Вставить("СлужебныеКадровыеДанныеФизическогоЛица", Результат);
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ТекущийДоговорФизлица()
	Если ДополнительныеСвойства.Свойство("ТекущийДоговорФизлица") Тогда // Служебный кэш, соответствующий страхователю.
		Возврат ДополнительныеСвойства.ТекущийДоговорФизлица;
	КонецЕсли;
	Результат = СЭДОФСС.ТекущийДоговорФизлица(ГоловнаяОрганизация, ФизическоеЛицо, ТекущаяДатаСеанса());
	ДополнительныеСвойства.Вставить("ТекущийДоговорФизлица", Результат);
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ЭЛН

Функция СведенияОбЭЛН()
	Если ДополнительныеСвойства.Свойство("СведенияОбЭЛН") Тогда
		Возврат ДополнительныеСвойства.СведенияОбЭЛН;
	КонецЕсли;
	СведенияОбЭЛН = РегистрыСведений.СведенияОбЭЛН.СведенияОбЭЛН(НомерЛН, ГоловнаяОрганизация);
	ДополнительныеСвойства.Вставить("СведенияОбЭЛН", СведенияОбЭЛН);
	Возврат СведенияОбЭЛН;
КонецФункции

Функция ГодСобытия()
	Если РасчетБольничного И Не Числится И ДатаНачалаСобытия > '00010101' И ДатаНачалаСобытия < ТекущаяДатаСеанса() Тогда
		Возврат Год(ДатаНачалаСобытия);
	Иначе
		Возврат Год(ТекущаяДатаСеанса());
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли