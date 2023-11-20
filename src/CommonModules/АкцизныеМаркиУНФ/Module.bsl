#Область ПрограммныйИнтерфейс

// Проверяет соответствие переданных кода маркировки и номенклатуры
//
// Параметры:
//  КодМаркировки	- Строка - код маркировки для проверки 
//  Номенклатура	- СправочникСсылка.Номенклатура - номенклатура для проверки 
//  ЕдиницаИзмерения - СправочникСсылка.ЕдиницыИзмерения - единица измерения номенклатуры 
// 
// Возвращаемое значение:
//  Булево - Истина, если соответствие найдено; Ложь, если соответствие не найдено
//
Функция КодМаркировкиСоответствуетНоменклатуре(КодМаркировки, Номенклатура, ЕдиницаИзмерения) Экспорт
		
	РезультатПроверки = Ложь;
	
	ДанныеМаркировки = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара(КодМаркировки);
	Если ДанныеМаркировки.Разобран Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Штрихкоды.Штрихкод КАК Штрихкод,
		|	Штрихкоды.Номенклатура КАК Номенклатура,
		|	Штрихкоды.Характеристика КАК Характеристика,
		|	Штрихкоды.Партия КАК Партия,
		|	Штрихкоды.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Штрихкод = &EAN
		|	И Штрихкоды.Номенклатура = &Номенклатура
		|	И Штрихкоды.ЕдиницаИзмерения = &ЕдиницаИзмерения";
		Запрос.УстановитьПараметр("EAN", ДанныеМаркировки.EAN);
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.УстановитьПараметр("ЕдиницаИзмерения", ?(ЗначениеЗаполнено(ЕдиницаИзмерения) И ТипЗнч(ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения"), ЕдиницаИзмерения, Справочники.ЕдиницыИзмерения.ПустаяСсылка()));
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			РезультатПроверки = Истина;
		Иначе
			ТекстСообщения = НСтр("ru = 'Считанный код маркировки %1 не соответствует выбранной номенклатуре %2.'");
			ПредставлениеНоменклатуры = Строка(Номенклатура) + ?(ЗначениеЗаполнено(ЕдиницаИзмерения), "[" + Строка(ЕдиницаИзмерения) + "]", "");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодМаркировки, ПредставлениеНоменклатуры);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Считанный код маркировки %1 не соответствует формату'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодМаркировки);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат РезультатПроверки;

КонецФункции

#КонецОбласти