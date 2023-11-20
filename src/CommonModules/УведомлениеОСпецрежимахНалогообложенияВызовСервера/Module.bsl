#Область ПрограммныйИнтерфейс

// Возвращает значение реквизита "ВидУведомления" документа "Уведомление о спецрежимах налогообложения".
//
// Параметр:
//  Ссылка - ДокументСсылка.УведомлениеОСпецрежимахНалогообложения - ссылка на документ "Уведомление о спецрежимах налогообложения".
//
// Возвращаемое значение: ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения.
//
Функция ВидУведомления(Ссылка) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВидУведомления");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРегионы(Регионы) Экспорт 
	РегламентированнаяОтчетность.ЗаполнитьРегионы(Регионы);
КонецПроцедуры

Функция ВидыУведомленийДляИП() Экспорт
	Возврат УведомлениеОСпецрежимахНалогообложенияПовтИсп.ВидыУведомленийДляИП();
КонецФункции

Функция ВидыУведомленийДляОрганизации() Экспорт 
	Возврат УведомлениеОСпецрежимахНалогообложенияПовтИсп.ВидыУведомленийДляОрганизации();
КонецФункции

Функция ПечатьУведомленияБРО(УведомлениеДляПечати) Экспорт
	СписокПечатаемыхЛистов = Отчеты[ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УведомлениеДляПечати, "ИмяОтчета")].
		СформироватьСписокЛистов(УведомлениеДляПечати.ПолучитьОбъект());
	УведомлениеОСпецрежимахНалогообложения.ПроставлениеКоличестваСтраниц(СписокПечатаемыхЛистов);
	Возврат СписокПечатаемыхЛистов;
КонецФункции

Функция ПечатьВБудущихВерсиях(УведомлениеДляПечати) Экспорт
	СписокПечатаемыхЛистов = УведомлениеОСпецрежимахНалогообложения.ПечатьВСледующихВерсиях(УведомлениеДляПечати);
	УведомлениеОСпецрежимахНалогообложения.ПроставлениеКоличестваСтраниц(СписокПечатаемыхЛистов);
	Возврат СписокПечатаемыхЛистов;
КонецФункции

Функция ПолучитьПараметрыЗагружаемогоXML(ИмяФормы) Экспорт 
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".");
	ФорматФормы = Отчеты[Разложение[1]].ПолучитьТаблицуПримененияФорматов().НайтиСтроки(Новый Структура("ИмяФормы", Разложение[3]))[0];
	Возврат Новый Структура("КНД, ВерсФорм", ФорматФормы.КНД, ФорматФормы.ВерсияФормата);
КонецФункции

Функция ДанныеОтветаНаТребование(ОтветНаТребованиеДокументов) Экспорт
	
	Возврат УведомлениеОСпецрежимахНалогообложения.ДанныеОтветаНаТребование(ОтветНаТребованиеДокументов);
	
КонецФункции

Функция ДанныеФайла(ПрисоединенныйФайл) Экспорт 
	Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл);
КонецФункции

Функция РеквизитЭлементаСправочника(Элемент, Реквизит) Экспорт 
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Элемент, Реквизит);
КонецФункции

Функция СпискиКБКИзМакета() Экспорт
	СписокКБК = Новый СписокЗначений;
	Макет = ПолучитьОбщийМакет("КодыКБК");
	СписокКодов = Макет.Область("СписокКодов");
	
	Для Инд = СписокКодов.Верх По СписокКодов.Низ Цикл 
		СписокКБК.Добавить(Макет.Область(Инд, 1, Инд, 1).Текст, Макет.Область(Инд, 2, Инд, 2).Текст);
	КонецЦикла;
	Возврат СписокКБК;
КонецФункции

#КонецОбласти