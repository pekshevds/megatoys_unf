/////////////////////////////////////////////////////////////////////////////
// Совместная работа подсистем ВетИС и ИСМП.
//   * Если подсистема ВетИС отсутствует, изменений не требуется.
//

#Область ПрограммныйИнтерфейс

#Область ВыборИдентификатораПроисхожденияВЕТИС

// Параметры выбора идентификатора просхождения.
// 
// Параметры:
//  ВидОперацииИСМП - ПеречислениеСсылка.ВидыОперацийИСМП - операция маркировки
// 
// Возвращаемое значение:
//  Структура - Параметры выбора идентификатора просхождения:
// * Номенклатура   - ОпределяемыйТип.Номенклатура - номенклатура (для указания связанной продукции ВЕТИС).
// * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика (для указания связанной продукции ВЕТИС).
// * Серия          - ОпределяемыйТип.СерияНоменклатуры - серия (для указания связанной продукции ВЕТИС).
// * Организация    - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация (для указания связанных объектов ВЕТИС).
// * ХарактеристикиИспользуются - Булево - необходимость указания характеристики для номенклатуры.
// * ТребуетсяУказаниеСерии     - Булево - необходимость указания серии для номенклатуры.
// * Склад                      - Произвольный - влияет на обязательность указания серии.
// * Производство               - Булево - признак выбора идентификатора происхождения для маркировки при производстве.
// * ЭтоКодМаркировкиСоСрокомГодности - Булево - признак кода маркировки (устаревшие коды).
// * СкоропортящаясяПродукция   - Булево - признак кода маркировки (устаревшие коды).
// * ОтчетПроизводственнойЛинии - Булево - признак выбора для режима "Отчет производственной линии" документа Маркировка
// * ОповещениеВыбора - ОписаниеОповещения - оповещение, которое будет выполнено при выборе
Функция ПараметрыВыбораИдентификатораПросхождения(ВидОперацииИСМП) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Номенклатура",                        Неопределено);
	Результат.Вставить("Характеристика",                      Неопределено);
	Результат.Вставить("Серия",                               Неопределено);
	Результат.Вставить("ХарактеристикиИспользуются",          Ложь);
	Результат.Вставить("ТребуетсяУказаниеСерии",              Ложь);
	Результат.Вставить("Склад",                               Неопределено);
	Результат.Вставить("ЭтоКодМаркировкиСоСрокомГодности",    Ложь);
	Результат.Вставить("СкоропортящаясяПродукция",            Ложь);
	Результат.Вставить("Организация",                         Неопределено);
	Результат.Вставить("ОтчетПроизводственнойЛинии",          Ложь);
	Результат.Вставить("ОповещениеВыбора",                    Неопределено);
	
	Если ВидОперацииИСМП = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС")
			Или ВидОперацииИСМП = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля") Тогда
		Результат.Вставить("Производство", Ложь);
	Иначе
		Результат.Вставить("Производство", Истина);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Обработчик выбора произвольного идентификатора происхождения (не из списка выбора)
// 
// Параметры:
//   ИсточникДанных      - см. ПараметрыВыбораИдентификатораПросхождения
//   СтандартнаяОбработка - Булево - признак стандартной обработки события
//
Процедура ОткрытьФормуВыбораИдентификатораПроисхожденияВЕТИС(ИсточникДанных, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияИСМПВЕТИСКлиентПереопределяемый.ОткрытьФормуВыбораИдентификатораПроисхожденияВЕТИС(ИсточникДанных, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Отказ = Ложь;
	
	Если Не ИсточникДанных.ОтчетПроизводственнойЛинии Тогда
		Если Не ЗначениеЗаполнено(ИсточникДанных.Номенклатура) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Номенклатура"" не заполнено.'"),, "Номенклатура",, Отказ);
		КонецЕсли;
		Если ИсточникДанных.ХарактеристикиИспользуются И Не ЗначениеЗаполнено(ИсточникДанных.Характеристика) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Характеристика"" не заполнено.'"),, "Характеристика",, Отказ);
		КонецЕсли;
		Если ИсточникДанных.ТребуетсяУказаниеСерии И ЗначениеЗаполнено(ИсточникДанных.Склад) И Не ЗначениеЗаполнено(ИсточникДанных.Серия) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Серия"" не заполнено.'"),, "Серия",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОповещениеВыбора = ИсточникДанных.ОповещениеВыбора;
	ИсточникДанных.ОповещениеВыбора = Неопределено;
	
	Отбор = Новый Структура;
	МодульВЕТИС = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияВЕТИСКлиент");
	МодульВЕТИС.ДополнитьОтборПоПрикладнымРеквизитам(Отбор, ИсточникДанных);
	
	Если ЗначениеЗаполнено(ИсточникДанных.Номенклатура) Тогда
		
		Если Не Отбор.Свойство("Продукция") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Не найдено сопоставленной продукции ВетИС для позиции номенклатуры %1'"),
					ИсточникДанных.Номенклатура),,
				"Номенклатура",,
				Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.ВетеринарноСопроводительныйДокументВЕТИС.ФормаВыбора", ПараметрыФормы,,,,, ОповещениеВыбора);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти