
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ПараметрыВыполненияКоманды.Источник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ЗаказПокупателя", ПараметрКоманды);
	ДанныеЗаполнения.Вставить("ПоКалькуляции", Истина);
	
	ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
	ОткрытьФорму("Документ.ЗаказПоставщику.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.ЗаказПоставщикуПоКалькуляции",
		ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти 

