#Область ПрограммныйИнтерфейс

// По таблице с колонками Номенклатура и Характеристика формирует массив GTIN 
//   и соответствие конкретных кодов GTIN номенклатуре/характеристике
// 
// Параметры:
//   ТаблицаПроверки  - ТаблицаЗначений - входящий, проверяемые даннные с колонками
//    * Номенклатура   - ОпределяемыйТип.Номенклатура
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры
//   ПроверяемыеGTIN  - Массив          - исходящий, все GTIN привязанные к одной из строк таблицы
//   СоответствиеGTIN - Соответствие    - исходящий, пара (GTIN - (Номенклатура,Характеристика,Упаковка,Коэффициент))
//   ИспользоватьХарактеристику - Булево - Признак необходимости использования характеристики.
Процедура ЗаполнитьПроверяемыеGTIN(ТаблицаПроверки, ПроверяемыеGTIN, СоответствиеGTIN, ИспользоватьХарактеристику = Истина) Экспорт
	
	ШтрихкодированиеИСМПУНФ.ЗаполнитьПроверяемыеGTIN(ТаблицаПроверки, ПроверяемыеGTIN, СоответствиеGTIN, ИспользоватьХарактеристику);
	
КонецПроцедуры

#КонецОбласти
