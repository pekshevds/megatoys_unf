#Область ШтрихкодированиеИСМППереопределяемый

// См. ШтрихкодированиеИСМППереопределяемый.ЗаполнитьПроверяемыеGTIN()
//
Процедура ЗаполнитьПроверяемыеGTIN(ТаблицаПроверки, ПроверяемыеGTIN, СоответствиеGTIN, ИспользоватьХарактеристику) Экспорт
	
	СоответствиеGTIN = ИнтеграцияИСУНФ.GTINМаркированныхТоваров(ТаблицаПроверки, ИспользоватьХарактеристику);
	Для Каждого КлючИЗначение Из СоответствиеGTIN Цикл
		ПроверяемыеGTIN.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти