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
//   Элементы   - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	// Виды начислений
	ГруппаНачисление = Элементы.Добавить();
	ГруппаНачисление.Наименование = НСтр("ru='Начисления'");
	ГруппаНачисление.ЭтоГруппа = Истина;
	ГруппаНачисление.Ссылка = Справочники.ВидыНачисленийИУдержаний.ПолучитьСсылку(Новый УникальныйИдентификатор);
	
	ГруппаУдержание = Элементы.Добавить();
	ГруппаУдержание.Наименование = НСтр("ru='Удержания'");
	ГруппаУдержание.ЭтоГруппа = Истина;
	ГруппаУдержание.Ссылка = Справочники.ВидыНачисленийИУдержаний.ПолучитьСсылку(Новый УникальныйИдентификатор);
	
	// Оклад по дням
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Оклад по дням (производственный календарь)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "[ТарифнаяСтавка] * [ОтработаноДней] / [НормаДней]";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
	Элемент.Используется 		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Оклад по часам
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Оклад по часам (производственный календарь)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.КосвенныеЗатраты;
	Элемент.Формула 			= "[ТарифнаяСтавка] * [ОтработаноЧасов] / [НормаЧасов]";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
	Элемент.Используется 		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Оклад по дням Графики
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Оклад по дням (график работы сотрудника)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "[ТарифнаяСтавка] * [ОтработаноДней] / [НормаДнейГрафикСотрудника]";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
	Элемент.Используется 		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Оклад по часам Графики
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Оклад по часам (график работы сотрудника)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.КосвенныеЗатраты;
	Элемент.Формула 			= "[ТарифнаяСтавка] * [ОтработаноЧасов] / [НормаЧасовГрафикСотрудника]";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
	Элемент.Используется 		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Оплата по заданиям
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Оплата по заданиям'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.Формула 			= "[ТарифнаяСтавка] * [ОтработаноЧасовПоЗаданиям]";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
	Элемент.Используется 		= ПолучитьФункциональнуюОпцию("ИспользоватьЗаданияНаРаботу");
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Процент от продаж по ответственному
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Процент от продаж по ответственному'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.Формула 			= "[СуммуПродажПоОтветственному]  / 100 *  [ТарифнаяСтавка]";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
	Элемент.Используется 		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Оплата по сдельным нарядам
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СдельнаяОплата";
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Сдельная оплата (тариф)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.Формула 			= "";
	Элемент.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2010;
	Элемент.Используется		= ОбщегоНазначенияУНФ.ЭтоУНФ();
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ДоговорыГПХ;
	
	// Сдельная оплата процентом
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СдельнаяОплатаПроцент";
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Сдельная оплата (% от суммы)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.Формула 			= "";
	Элемент.КодДоходаНДФЛ 		= Справочники.КодыДоходовНДФЛ.Код2010;
	Элемент.Используется		= ОбщегоНазначенияУНФ.ЭтоУНФ();
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ДоговорыГПХ;
	
	// Фиксированная сумма
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ФиксированнаяСумма";
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Сдельная оплата (фиксированная сумма)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.Формула 			= "[ФиксированнаяСумма]";
	Элемент.КодДоходаНДФЛ 		= Справочники.КодыДоходовНДФЛ.Код2010;
	Элемент.Используется		= ОбщегоНазначенияУНФ.ЭтоУНФ();
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ДоговорыГПХ;
	
	// Отпускные
	Элемент = Элементы.Добавить();
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Отпускные'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "";
	Элемент.КодДоходаНДФЛ 		= Справочники.КодыДоходовНДФЛ.Код2012;
	Элемент.Используется		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Премия продавцам
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПремияЗаПродажи";
	Элемент.Родитель 			= ГруппаНачисление.Ссылка;
	Элемент.Наименование 		= НСтр("ru = 'Премия продавцам за продажи'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.Формула 			= "";
	Элемент.КодДоходаНДФЛ 		= Справочники.КодыДоходовНДФЛ.Код2010;
	Элемент.Используется		= Истина;
	Элемент.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
	
	// Налог на доходы
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НалогНаДоходы";
	Элемент.Родитель 			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Налог на доходы'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула 			= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.НДФЛСотрудники;
	
	// ПФР по суммарному тарифу
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПФРПоСуммарномуТарифу";
	Элемент.Родитель 			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы в ПФР  с 1 января 2014 года'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула 			= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.ПФРСтраховаяСотрудники;
	
	// ПФР накопительная
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПФРНакопительная";
	Элемент.Родитель 			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы в ПФР- накопительная часть(до 2014 года)'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула 			= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.ПФРНакопительнаяСотрудники;
	
	// ПФР страховая
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПФРСтраховая";
	Элемент.Родитель			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы в ПФР- страховая часть(до 2014 года)'");
	Элемент.Тип					= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.ПФРСтраховаяСотрудники;
	
	// ФСС
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ФСС";
	Элемент.Родитель			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы в ФСС (временная нетрудоспособность)'");
	Элемент.Тип					= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.ФСССотрудники;
	
	// ФСС несчастные случаи
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ФССНесчастныеСлучаи";
	Элемент.Родитель			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы в ФСС (несчастные случаи)'");
	Элемент.Тип					= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.ФССТравматизмСотрудники;
	
	// ФФОМС
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ФФОМС";
	Элемент.Родитель			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы в ФФОМС'");
	Элемент.Тип					= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула				= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.ФОМССотрудники;
	
	// Погашение займа из зарплаты
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПогашениеЗаймаИзЗарплаты";
	Элемент.Родитель			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Погашение займа из зарплаты'");
	Элемент.Тип					= Перечисления.ТипыНачисленийИУдержаний.Удержание;
	Элемент.Используется 		= ОбщегоНазначенияУНФ.ЭтоУНФ();
	
	// Погашение проценты по займу
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПроцентыПоЗайму";
	Элемент.Родитель			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Проценты по займу'");
	Элемент.Тип					= Перечисления.ТипыНачисленийИУдержаний.Удержание;
	Элемент.Используется 		= ОбщегоНазначенияУНФ.ЭтоУНФ(); 
	
	// Взносы по единому тарифу
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ВзносыПоЕдиномуТарифу";
	Элемент.Родитель 			= ГруппаУдержание.Ссылка;
	Элемент.Наименование 		= НСтр("ru='Взносы по единому тарифу'");
	Элемент.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Налог;
	Элемент.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
	Элемент.Формула 			= "";
	Элемент.Используется		= Истина;
	Элемент.ВидНалога = Справочники.ВидыНалогов.СтраховыеВзносыЕдиныйТариф;
	
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

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ВидНалога");
	Результат.Добавить("Тип");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

Процедура ДополнитьВидыНачислений() Экспорт
		
		Группа = Справочники.ВидыНачисленийИУдержаний.НайтиПоНаименованию("Начисления");
		
		Если Не ЗначениеЗаполнено(Группа) ИЛИ НЕ Группа.ЭтоГруппа Тогда
			ГруппаНачисление = Справочники.ВидыНачисленийИУдержаний.ПустаяСсылка();
		Иначе
			ГруппаНачисление = Группа;
		КонецЕсли;
		
		НайденныйЭлементСправочника = Справочники.ВидыНачисленийИУдержаний.НайтиПоНаименованию("Оклад по дням (график работы сотрудника)");
		
		Если Не ЗначениеЗаполнено(НайденныйЭлементСправочника) Тогда
			
			// Оклад по дням Графики
			НовоеНачисление 					= Справочники.ВидыНачисленийИУдержаний.СоздатьЭлемент();
			НовоеНачисление.Родитель 			= ГруппаНачисление;
			НовоеНачисление.Наименование 		= "Оклад по дням (график работы сотрудника)";
			НовоеНачисление.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
			НовоеНачисление.СчетЗатрат			= ПланыСчетов.Управленческий.УправленческиеРасходы;
			НовоеНачисление.Формула				= "[ТарифнаяСтавка] * [ОтработаноДней] / [НормаДнейГрафикСотрудника]";
			НовоеНачисление.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
			НовоеНачисление.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
			НовоеНачисление.Записать();
			
		КонецЕсли;
		
		НайденныйЭлементСправочника = Справочники.ВидыНачисленийИУдержаний.НайтиПоНаименованию("Оклад по часам (график работы сотрудника)");
		
		Если Не ЗначениеЗаполнено(НайденныйЭлементСправочника) Тогда
			
			// Оклад по часам Графики
			НовоеНачисление 					= Справочники.ВидыНачисленийИУдержаний.СоздатьЭлемент();
			НовоеНачисление.Родитель 			= ГруппаНачисление;
			НовоеНачисление.Наименование 		= "Оклад по часам (график работы сотрудника)";
			НовоеНачисление.Тип 				= Перечисления.ТипыНачисленийИУдержаний.Начисление;
			НовоеНачисление.СчетЗатрат			= ПланыСчетов.Управленческий.КосвенныеЗатраты;
			НовоеНачисление.Формула 			= "[ТарифнаяСтавка] * [ОтработаноЧасов] / [НормаЧасовГрафикСотрудника]";
			НовоеНачисление.КодДоходаНДФЛ		= Справочники.КодыДоходовНДФЛ.Код2000;
			НовоеНачисление.ВидДоходаПоСтраховымВзносам = Справочники.ВидыДоходовПоСтраховымВзносамУНФ.ОблагаетсяЦеликом;
			НовоеНачисление.Записать();
			
		КонецЕсли
		
КонецПроцедуры

// Процедура - Установить признак использования при обновлении
//
Процедура УстановитьПризнакИспользованияПриОбновлении() Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ВидыНачисленийИУдержаний.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыНачисленийИУдержаний КАК ВидыНачисленийИУдержаний
		|ГДЕ
		|	НЕ ВидыНачисленийИУдержаний.ЭтоГруппа";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ОбъектНачисления = Выборка.Ссылка.ПолучитьОбъект();
			ОбъектНачисления.Заблокировать();
			ОбъектНачисления.Используется = Истина;
			ОбъектНачисления.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		СообщениеОбОшибке = НСтр("ru='Установить признак используется для видов начислений'", 
			ОбщегоНазначения.КодОсновногоЯзыка());
			
		ЗаписьЖурналаРегистрации(СообщениеОбОшибке, УровеньЖурналаРегистрации.Ошибка, , , 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("СобственныйВызов") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Параметры.Вставить("СобственныйВызов");
		Отбор = Новый Структура;
		Отбор.Вставить("Используется", Истина);
		Параметры.Вставить("Отбор", Отбор);
		СтандартныйСписок = ПолучитьДанныеВыбора(Параметры);
		ДанныеВыбора = СтандартныйСписок;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

