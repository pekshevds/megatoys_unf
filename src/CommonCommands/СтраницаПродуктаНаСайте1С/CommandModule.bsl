#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	
	Если ПараметрыРаботыКлиента.ЭтоРозница Тогда
		АдресСтраницы = "https://v8.1c.ru/retail/";
	Иначе
		АдресСтраницы = "https://v8.1c.ru/small.biz/";
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

#КонецОбласти
