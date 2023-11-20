
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ЗаполнитьРеквизитыИзПотребителя.
Процедура ЗаполнитьРеквизитыОбъектаДокументооборота(Прокси, ОбъектXDTO, СсылкаНаПотребитель) Экспорт
	
	Если Не ТипЗнч(СсылкаНаПотребитель) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		Если ТипЗнч(ОбъектXDTO) = Тип("ОбъектXDTO")
				И МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, ОбъектXDTO, "DMSubdivision") Тогда
			ИнтеграцияС1СДокументооборотБЗК.ЗаполнитьРуководителяПодразделения(Прокси, ОбъектXDTO, СсылкаНаПотребитель);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнитьСоответствиеТипов.
Процедура ДополнитьСоответствиеТипов(Таблица) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(
			Таблица, "DMSubdivision", Тип("СправочникСсылка.СтруктураПредприятия"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
