
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	СтруктураЗаполнения = Новый Структура("Основание", ПараметрКоманды);
	ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта", СтруктураЗаполнения);
КонецПроцедуры
