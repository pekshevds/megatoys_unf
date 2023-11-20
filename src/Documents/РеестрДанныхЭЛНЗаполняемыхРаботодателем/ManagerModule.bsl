#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеРеквизиты = ФиксируемыеРеквизиты();
	ФиксируемыеТЧ = Новый Структура("ДанныеЭЛН", СтрРазделить("Больничный", ",", Ложь));
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты, ФиксируемыеТЧ);
КонецФункции

#КонецОбласти

#Область МногофункциональныеДокументы

// Возвращает метаданные разделов документа.
//
// Возвращаемое значение:
//   Соответствие, Неопределено - Описание разделов документа.
//
Функция ОписаниеРазделовДанных() Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("МногофункциональныеДокументыБЗККлиентСервер");
		ВсеРазделы = Модуль.РазделыДанных();
		
		ОписаниеРазделовДанных = Новый Соответствие();
		
		ОписаниеРаздела = Модуль.НовыйОписаниеРазделаДанных();
		ОписаниеРазделовДанных.Вставить(ВсеРазделы.КадровыеДанные, ОписаниеРаздела);
		ОписаниеРаздела.РеквизитСостояние    = "Проведен";
		ОписаниеРаздела.РеквизитОтветсвенный = "Ответственный";
		
		ОписаниеРаздела = Модуль.НовыйОписаниеРазделаДанных();
		ОписаниеРазделовДанных.Вставить(ВсеРазделы.НачисленнаяЗарплата, ОписаниеРаздела);
		Возврат ОписаниеРазделовДанных;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

// Возвращает значения по которым будут проверяться права на документ.
//
// Параметры:
//   ДокументОбъект - ДокументОбъект, ДанныеФормыСтруктура
//
// Возвращаемое значение:
//   Структура - Значения доступа по которым будут проверяться права на документ
//
Функция ЗначенияДоступа(ДокументОбъект) Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы") Тогда
		МодульМногофункциональныеДокументыБЗК = ОбщегоНазначения.ОбщийМодуль("МногофункциональныеДокументыБЗК");
		Возврат МодульМногофункциональныеДокументыБЗК.ЗначенияДоступаПоСоставуДокумента(
			ДокументОбъект,
			ДокументОбъект.Организация);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область СоставДокументов

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
//
Функция ОписаниеСоставаОбъекта() Экспорт
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта();
	ОписаниеСостава.ЗаполнятьФизическиеЛицаПоСотрудникам           = Ложь;
	ОписаниеСостава.ИспользоватьКраткийСостав                      = Ложь;
	ОписаниеСостава.ЗаполнятьТабличнуюЧастьФизическиеЛицаДокумента = Ложь;
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ДанныеЭЛН",
		Неопределено,
		"Сотрудник");
	
	Возврат ОписаниеСостава;
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты организации.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Организация";
	Шаблон.ОснованиеЗаполнения = "Организация";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РегистрационныйНомерФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДополнительныйКодФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПодчиненностиФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РеестрСоставил", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТелефонСоставителя", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресЭлектроннойПочтыСоставителя", Ложь);
	
	// Кэш строк.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "КэшДанныхЭЛН";
	Шаблон.ОснованиеЗаполнения = "КэшДанныхЭЛН";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СостояниеРеестра", Ложь);
	
	// Роль подписанта Руководитель.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "Руководитель";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Руководитель");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьРуководителя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиРуководителя");
	
	// Роль подписанта ГлавныйБухгалтер.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "ГлавныйБухгалтер";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ГлавныйБухгалтер");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьГлавногоБухгалтера");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиГлавногоБухгалтера");
	
	// Реквизиты табличной части "ДанныеЭЛН".
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.Путь           = "ДанныеЭЛН";
	Шаблон.РеквизитСтроки = Истина;
	
	//   Регистр сведений об ЭЛН.
	Шаблон.ОснованиеЗаполнения = "РегистрСведенийЭЛН";
	Шаблон.ИмяГруппы           = "РегистрСведенийЭЛН";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Исправление", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПричиныИсправления", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОписаниеПричиныИсправления", Ложь);
	
	//   Документ-основание.
	Шаблон.ОснованиеЗаполнения = "Больничный";
	Шаблон.ИмяГруппы           = "СведенияПервичногоДокумента";
	Шаблон.ФиксацияГруппы      = Ложь;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НомерЛисткаНетрудоспособности");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Сотрудник");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "БазаДляРасчетаСреднегоЗаработка");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаАктаН1");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачалаОплаты");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачалаОплатыФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачалаРаботы");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОкончанияОплаты");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОкончанияОплатыФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ПриступитьКРаботеС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СреднийДневнойЗаработок");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажЛет");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажМесяцев");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажДней");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйЛет");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйМесяцев");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйДней");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СуммаОплатыЗаСчетРаботодателя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СуммаОплатыЗаСчетФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "УсловияИсчисленияКод1");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "УсловияИсчисленияКод2");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "УсловияИсчисленияКод3");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФинансированиеФедеральнымБюджетом");
	
	//   Сотрудник.
	Шаблон.ОснованиеЗаполнения = "Сотрудник";
	Шаблон.ИмяГруппы           = "КадровыеДанныеСотрудника";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ВидЗанятости");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИНН");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СНИЛС");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#КонецОбласти



#КонецЕсли