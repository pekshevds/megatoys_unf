// Механизм расчета статусов оформления документов ВЕТИС.
//

#Область СлужебныйПрограммныйИнтерфейс

// Позволяет переопределить имена реквизитов документа-основания для документа ВЕТИС.
//
// Параметры:
//  МетаданныеДокументаОснования - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.Основание<Имя
//                                                            документа ВЕТИС>
//  МетаданныеДокументаВЕТИС - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления
//  Реквизиты  - Структура - имена реквизитов:
//   * Ключ  - Строка - служебное имя реквизита в ВЕТИС
//   * Значение - Строка - имя реквизита документа-основания, которое при необходимости надо переопределить
//  Подробнее см. РасчетСтатусовОформленияВЕТИС.СтруктураРеквизитовДляРасчетаСтатусаОформленияДокументовВЕТИС.
Процедура ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаВЕТИС(
			Знач МетаданныеДокументаОснования, Знач МетаданныеДокументаВЕТИС, Реквизиты) Экспорт
	
	ИнтеграцияВЕТИСУНФ.ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаВЕТИС(
		МетаданныеДокументаОснования, МетаданныеДокументаВЕТИС, Реквизиты);
	
КонецПроцедуры

// Позволяет переопределить текст запроса выборки данных из документов-основания для расчета статуса оформления.
// Требования к тексту запроса:
//     Результат запроса обязательно должен содержать следующие поля:
//      * Ссылка - ОпределяемыйТип.Основание<Имя документа ВЕТИС> - ссылка на документ-основание
//      * ЭтоДвижениеПриход - Булево - вид движения ТМЦ (Истина - приход, Ложь - расход)
//      * Номенклатура - ОпределяемыйТип.Номенклатура - номенклатура
//      * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатуры
//      * Серия - ОпределяемыйТип.СерияНоменклатуры - серия номенклатуры
//      * Количество - Число - количество номенклатуры в ее основной единице измерения
//      
//     В результат запроса нужно включать только подконтрольную номенклатуру ВЕТИС
//     Для отбора документов-основания в запросе нужно использовать отбор "В (&МассивДокументов)"
//     Выбранные данные необходимо поместить во временную таблицу (См. РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента).
//
// Параметры:
//  МетаданныеДокументаОснования - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.Основание<Имя
//                                                            документа ВЕТИС>
//  МетаданныеДокументаВЕТИС - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления
//  ТекстЗапроса - Строка - текст запроса выборки данных, который надо переопределить.
//    Если данные из документа выбирать не требуется, то данному параметру надо присвоить значение "" (пустая строка).
//  ДополнительныеПараметрыЗапроса - Структура - дополнительные параметры запроса,
//    требуемые для выполнения запроса конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаВЕТИС(
			Знач МетаданныеДокументаОснования, Знач МетаданныеДокументаВЕТИС, ТекстЗапроса, ДополнительныеПараметрыЗапроса) Экспорт
	
	ИнтеграцияВЕТИСУНФ.ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаВЕТИС(
		МетаданныеДокументаОснования, МетаданныеДокументаВЕТИС, ТекстЗапроса, ДополнительныеПараметрыЗапроса);

	
КонецПроцедуры

#КонецОбласти
