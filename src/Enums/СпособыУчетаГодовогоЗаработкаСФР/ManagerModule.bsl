Функция СтрокаXML(Значение) Экспорт
	Если Значение = ВсеСтрахователи Тогда
		Возврат "amountForAllInsurers";
	ИначеЕсли Значение = ТекущийСтрахователь Тогда
		Возврат "amountForCurrentInsurer";
	ИначеЕсли Значение = ВсеСтрахователиЗаТекущийПериодРаботы Тогда
		Возврат "amountForCurrentAndPrevOtherInsurers";
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

Функция ЗначениеИзXML(КодСФР) Экспорт
	Если СтрСравнить(КодСФР, "amountForAllInsurers") = 0 Тогда
		Возврат ВсеСтрахователи;
	ИначеЕсли СтрСравнить(КодСФР, "amountForCurrentInsurer") = 0 Тогда
		Возврат ТекущийСтрахователь;
	ИначеЕсли СтрСравнить(КодСФР, "amountForCurrentAndPrevOtherInsurers") = 0 Тогда
		Возврат ВсеСтрахователиЗаТекущийПериодРаботы;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
КонецФункции