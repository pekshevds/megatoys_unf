
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьВесИОбъем();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ИсточникКопирования = Параметры.ЗначениеКопирования;
		НастроитьВесИОбъем(Истина);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.ПараметрыВыбора.Свойство("Владелец") Тогда
			ВладелецЭлемента = Параметры.ПараметрыВыбора.Владелец;
			
			Если ТипЗнч(ВладелецЭлемента) = Тип("СписокЗначений") Тогда
				Если ВладелецЭлемента.Количество() = 1 Тогда
					Объект.Владелец = ВладелецЭлемента[0].Значение;
				ИначеЕсли ВладелецЭлемента.Количество() > 0 Тогда
					Объект.Владелец = ВладелецЭлемента[1].Значение;
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли Параметры.Свойство("СсылкаВладелец") Тогда
			Объект.Владелец = Параметры.СсылкаВладелец;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ЕдиницаИзмеренияВладельца = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ЕдиницаИзмерения");
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПодсказкиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("УказатьВесИОбъемДляЕдиницыТовара", ЗначениеЗаполнено(Вес) ИЛИ ЗначениеЗаполнено(Объем));
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Вес", Вес);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Объем", Объем);
	//+mega
	ТекущийОбъект.ДополнительныеСвойства.Вставить("УказатьВесИОбъемДляЕдиницыТовара", Истина);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("mega_ВесНетто", mega_ВесНетто);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("mega_Длина", mega_Длина);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("mega_Высота", mega_Высота);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("mega_Ширина", mega_Ширина);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("mega_КоличествоНаПоддоне", mega_КоличествоНаПоддоне);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("mega_ВидПоддона", mega_ВидПоддона);
	//-mega
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	НастроитьВесИОбъем();
	
КонецПроцедуры

&НаКлиенте
Процедура ВесПриИзменении(Элемент)
	
	Элементы.ГруппаВесИОбъем.ЗаголовокСвернутогоОтображения = ЗаголовокСвернутойГруппыВесИОбъем(Вес, Объем);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъемПриИзменении(Элемент)
	
	Элементы.ГруппаВесИОбъем.ЗаголовокСвернутогоОтображения = ЗаголовокСвернутойГруппыВесИОбъем(Вес, Объем);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмеренияПоКлассификатору) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбновитьПодсказкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПоКлассификаторуПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		
		Объект.Наименование = СокрЛП(Объект.ЕдиницаИзмеренияПоКлассификатору);
		
	КонецЕсли;
	
	ОбновитьПодсказкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КоэффициентПриИзменении(Элемент)
	
	ОбновитьПодсказкиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьПодсказкиФормы()
	
	ТекстШаблона = НСтр("ru = '1 %1 = %2 %3'");
	
	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмеренияПоКлассификатору) Тогда
		
		ПредставлениеЕдиницыИзмерения = СокрЛП(Объект.ЕдиницаИзмеренияПоКлассификатору);
		
	ИначеЕсли НЕ ПустаяСтрока(Объект.Наименование) Тогда
		
		ПредставлениеЕдиницыИзмерения = СокрЛП(Объект.Наименование);
		
	Иначе
		
		ПредставлениеЕдиницыИзмерения = НСтр("ru = '<ед.изм.>'");
		
	КонецЕсли;
	
	Если Объект.Коэффициент >= 1 Тогда
		
		ЗаголовокДекорации = СтрШаблон(ТекстШаблона, ПредставлениеЕдиницыИзмерения, Объект.Коэффициент, СокрЛП(ЕдиницаИзмеренияВладельца))
			+ Символы.ПС + СтрШаблон(ТекстШаблона, СокрЛП(ЕдиницаИзмеренияВладельца), ОКР((1 / Объект.Коэффициент), 3), ПредставлениеЕдиницыИзмерения);
		
	Иначе
		
		ТекстШаблона = НСтр("ru = '1 %1 = %2 %3'");
		
		Если ЗначениеЗаполнено(Объект.Коэффициент) Тогда
			ЗаголовокДекорации = СтрШаблон(ТекстШаблона, СокрЛП(ПредставлениеЕдиницыИзмерения), ОКР(Объект.Коэффициент, 3), ЕдиницаИзмеренияВладельца)
				+ Символы.ПС + СтрШаблон(ТекстШаблона, СокрЛП(ЕдиницаИзмеренияВладельца), ОКР((1 / Объект.Коэффициент), 3), ПредставлениеЕдиницыИзмерения);
		Иначе
			ЗаголовокДекорации = "";
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Коэффициент", "Подсказка", ЗаголовокДекорации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокСвернутойГруппыВесИОбъем(Знач Вес, Знач Объем)
	
	КомпонентыЗаголовка = Новый Массив;
	Если ЗначениеЗаполнено(Вес) Тогда
		КомпонентыЗаголовка.Добавить(СтрШаблон("Вес: %1 кг", Вес));
	КонецЕсли;
	Если ЗначениеЗаполнено(Объем) Тогда
		КомпонентыЗаголовка.Добавить(СтрШаблон("Объем: %1 м³", Объем));
	КонецЕсли;
	
	Возврат СтрСоединить(КомпонентыЗаголовка, ", ");
	
КонецФункции

&НаСервере
Процедура НастроитьВесИОбъем(ПоИсточникуКопирования = Ложь)
	
	Если ПоИсточникуКопирования Тогда
		ВладелецИсточника = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникКопирования, "Владелец");
		Если ТипЗнч(ВладелецИсточника) <> Тип("СправочникСсылка.Номенклатура") Тогда
			Элементы.ГруппаВесИОбъем.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		ОтборНоменклатура = ВладелецИсточника;
		ОтборЕдиница = ИсточникКопирования;
	Иначе
		Если ТипЗнч(Объект.Владелец) <> Тип("СправочникСсылка.Номенклатура") Тогда
			Элементы.ГруппаВесИОбъем.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Возврат;
		КонецЕсли;
		ОтборНоменклатура = Объект.Владелец;
		ОтборЕдиница = Объект.Ссылка;
	КонецЕсли; 
	Элементы.ГруппаВесИОбъем.Видимость = Истина;
	
	МенеджерЗаписи = РегистрыСведений.ВесИОбъемЕдиницТоваров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Номенклатура = ОтборНоменклатура;
	МенеджерЗаписи.ЕдиницаИзмерения = ОтборЕдиница;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Вес = МенеджерЗаписи.Вес;
		Объем = МенеджерЗаписи.Объем;
		//+mega
		mega_ВесНетто = МенеджерЗаписи.mega_ВесНетто;
		mega_Длина = МенеджерЗаписи.mega_Длина;
		mega_Высота = МенеджерЗаписи.mega_Высота;
		mega_Ширина = МенеджерЗаписи.mega_Ширина;
		mega_КоличествоНаПоддоне = МенеджерЗаписи.mega_КоличествоНаПоддоне;
		mega_ВидПоддона = МенеджерЗаписи.mega_ВидПоддона;
		//-mega
		Элементы.ГруппаВесИОбъем.ЗаголовокСвернутогоОтображения = ЗаголовокСвернутойГруппыВесИОбъем(Вес, Объем);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзменения(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтруктураОтбора = Новый Структура("ВладелецЕдиницыИзмерения", Объект.Ссылка);
		ПараметрыОтбора = Новый Структура("Отбор", СтруктураОтбора);
		ОткрытьФорму("РегистрСведений.ИсторияИзмененийЕдиницИзмерения.ФормаСписка", ПараметрыОтбора, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти