#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ЗначениеВСтрокуСЭДОXML(Значение) Экспорт
	Если Значение = ТК_351_7 Тогда
		Возврат ТК_351_7_ЗначениеXML();
	ИначеЕсли Значение = ФЗ_79_СТ_53_1 Тогда
		Возврат ФЗ_79_СТ_53_1_ЗначениеXML();
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

Функция ЗначениеИзСтрокиСЭДОXML(ЗначениеXML) Экспорт
	Если ЗначениеXML = ТК_351_7_ЗначениеXML() Тогда
		Возврат ТК_351_7;
	ИначеЕсли ЗначениеXML = ФЗ_79_СТ_53_1_ЗначениеXML() Тогда
		Возврат ФЗ_79_СТ_53_1;
	ИначеЕсли СтрНайти(ЗначениеXML, "351") > 0 Тогда
		Возврат ТК_351_7;
	ИначеЕсли СтрНайти(ЗначениеXML, "53") > 0 Или СтрНайти(ЗначениеXML, "79") > 0 Тогда
		Возврат ФЗ_79_СТ_53_1;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
КонецФункции

Функция ТК_351_7_ЗначениеXML()
	// АПК:1297-выкл Не локализуется, т.к. является частью регламентированной отчетности, применяемой в РФ.
	Возврат "Период приостановления действия трудового договора в соответствии со статьей 351.7 ТК РФ";
	// АПК:1297-вкл
КонецФункции

Функция ФЗ_79_СТ_53_1_ЗначениеXML()
	// АПК:1297-выкл Не локализуется, т.к. является частью регламентированной отчетности, применяемой в РФ.
	Возврат "Период приостановления прохождения гос. гражданской службы (ст. 53.1 ФЗ от 27.07.04 года N 79-ФЗ)";
	// АПК:1297-вкл
КонецФункции

#КонецОбласти

#КонецЕсли