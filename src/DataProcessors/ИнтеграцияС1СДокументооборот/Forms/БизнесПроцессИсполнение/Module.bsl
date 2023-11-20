#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступнаМультипредметность = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.0.3.1");
	Элементы.СтраницыМультипредметность.ТекущаяСтраница = ?(ДоступнаМультипредметность, 
		Элементы.СтраницаДоступнаМультипредметность,
		Элементы.СтраницаНедоступнаМультипредметность);
	
	ТипПроцессаXDTO = "DMBusinessProcessPerformance";
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(ТипПроцессаXDTO, Параметры);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
	Если Параметры.Свойство("Шаблон") Тогда
		ШаблонID = Параметры.Шаблон.ID;
		ШаблонТип = Параметры.Шаблон.type;
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
	Элементы.ВариантИсполнения.ТолькоПросмотр = ТолькоПросмотр;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнительнаяОбработкаФормыБизнесПроцесса(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	
	Элементы.ВариантИсполнения.СписокВыбора.Очистить();
	Элементы.ВариантИсполнения.СписокВыбора.Добавить("Параллельно", НСтр("ru='Всем сразу'")); //@NON-NLS-1
	Элементы.ВариантИсполнения.СписокВыбора.Добавить("Последовательно", НСтр("ru='По очереди'")); //@NON-NLS-1
	Элементы.ВариантИсполнения.СписокВыбора.Добавить("Смешанно", НСтр("ru='Смешанно'")); //@NON-NLS-1
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьШаг(Исполнители);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменен" И Параметр = Элементы.ПредметПредставление Тогда
		Предмет = Источник.Представление;
		
	ИначеЕсли ИмяСобытия = "Документооборот_ВыбратьЗначениеИзВыпадающегоСпискаЗавершение" И Источник = ЭтотОбъект Тогда
		Если Параметр.Реквизит = "ПорядокИсполнения" Тогда
			ЗаполнитьШаг(Исполнители);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.ID = ID Тогда
			ПеречитатьПроцесс();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГлавнаяЗадачаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ГлавнаяЗадачаТип, ГлавнаяЗадачаID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка("DMBusinessProcessImportance", "Важность", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Важность", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Важность", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантИсполненияПереключательПриИзменении(Элемент)
	ОбработатьВыборВариантаИсполнения();
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Автор", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПроверяющийНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",,
		ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте 
Процедура ПроверяющийНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Проверяющий);
	Результат.Свойство("ИсполнительID", ПроверяющийID);
	Результат.Свойство("ИсполнительТип", ПроверяющийТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ОсновнойОбъектАдресацииПроверяющего);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииПроверяющегоID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииПроверяющегоТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресацииПроверяющего);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииПроверяющегоID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип",ДополнительныйОбъектАдресацииПроверяющегоТип);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
		"Проверяющий",
		"ОбъектАдресацииПроверяющего",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("КонтролерНачалоВыбораЗавершение", ЭтотОбъект);
		
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",,
		ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Контролер);
	Результат.Свойство("ИсполнительID", КонтролерID);
	Результат.Свойство("ИсполнительТип", КонтролерТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации",ОсновнойОбъектАдресацииКонтролера);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииКонтролераID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииКонтролераТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресацииКонтролера);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииКонтролераID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ДополнительныйОбъектАдресацииКонтролераТип);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
		"Контролер",
		"ОбъектАдресацииКонтролера",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание,
		СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
		СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			Если Элемент = Элементы.Проверяющий Тогда
				ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
					"Проверяющий",
					"ОбъектАдресацииПроверяющего",
					ДанныеВыбора[0].Значение,
					СтандартнаяОбработка,
					ЭтотОбъект);
			ИначеЕсли Элемент = Элементы.Контролер Тогда
				ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
					"Контролер",
					"ОбъектАдресацииКонтролера",
					ДанныеВыбора[0].Значение,
					СтандартнаяОбработка,
					ЭтотОбъект);
			Иначе
				ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(
					Элемент.Родитель.Родитель,
					ДанныеВыбора[0].Значение,
					СтандартнаяОбработка,
					ЭтотОбъект);
			КонецЕсли;
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(Элемент.Родитель.Родитель, ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДатаПриИзменении(Элемент)
	
	Если Срок = НачалоДня(Срок) Тогда
		Срок = КонецДня(Срок);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсполнители

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ИсполнителиИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",,
		ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	
	Результат.Свойство("Исполнитель", ТекущиеДанные.Исполнитель);
	Результат.Свойство("ИсполнительID", ТекущиеДанные.ИсполнительID);
	Результат.Свойство("ИсполнительТип", ТекущиеДанные.ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ТекущиеДанные.ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ТекущиеДанные.ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ТекущиеДанные.ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ТекущиеДанные.ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ТекущиеДанные.ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ТекущиеДанные.ДополнительныйОбъектАдресацииТип);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Исполнители.ТекущиеДанные <> Неопределено Тогда
		НомерСтроки = Исполнители.Индекс(Элементы.Исполнители.ТекущиеДанные) + 1;
		
		Элементы.ИсполнителиОтветственныйИсполнитель.Пометка = Элементы.Исполнители.ТекущиеДанные.Ответственный;
		Элементы.ИсполнителиОтветственныйИсполнитель.Доступность = 
			НомерСтроки = 1 
			И Исполнители.Количество() > 1
			И Не Стартован;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокПриИзменении(Элемент)
	
	Если Элементы.Исполнители.ТекущиеДанные.Срок = НачалоДня(Элементы.Исполнители.ТекущиеДанные.Срок) Тогда
		Элементы.Исполнители.ТекущиеДанные.Срок = КонецДня(Элементы.Исполнители.ТекущиеДанные.Срок);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокИсполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMTaskExecutionOrder",
		"ПорядокИсполнения",
		ЭтотОбъект,,
		Истина,
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокИсполненияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMTaskExecutionOrder", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокИсполненияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMTaskExecutionOrder", ДанныеВыбора, Текст, СтандартнаяОбработка);
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ПорядокИсполнения",
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка,
				ЭтотОбъект,
				Истина,
				Элемент);
			СтандартнаяОбработка = Истина;
			ЗаполнитьШаг(Исполнители);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокИсполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ПорядокИсполнения",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект,
		Истина,
		Элемент);
	ЗаполнитьШаг(Исполнители);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьБизнесПроцесс(Команда)
	
	РезультатЗаписи = ЗаписатьОбъект();
	
	Если РезультатЗаписи Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
		Заголовок = Представление;
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Бизнес-процесс ""%1"" сохранен.'"), Представление));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	
	Если РезультатЗапуска Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Истина);
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс ""%Наименование%"" успешно запущен.'");
		ТекстСостояния = СтрЗаменить(ТекстСостояния,"%Наименование%", Представление);
		Состояние(ТекстСостояния);
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.НачатьВыборШаблонаБизнесПроцесса(Оповещение, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйИсполнитель(Команда)
	
	Если Элементы.Исполнители.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ответственный = Элементы.Исполнители.ТекущиеДанные.Ответственный;
	Для Каждого СтрокаТаблицы Из Исполнители Цикл
		СтрокаТаблицы.Ответственный = Ложь;
	КонецЦикла;
	
	Элементы.Исполнители.ТекущиеДанные.Ответственный = Не Ответственный;
	Элементы.ИсполнителиОтветственныйИсполнитель.Пометка = Элементы.Исполнители.ТекущиеДанные.Ответственный;
	
КонецПроцедуры

 &НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ИндексТекущегоЭлементаКоллекции = Исполнители.Индекс(
		Элементы.Исполнители.ТекущиеДанные);
	КоличествоЭлементовКоллекции = Исполнители.Количество();
	Если ИндексТекущегоЭлементаКоллекции < КоличествоЭлементовКоллекции - 1 Тогда
		Исполнители.Сдвинуть(ИндексТекущегоЭлементаКоллекции, 1);
	КонецЕсли;
	Модифицированность = Истина;
	ЗаполнитьШаг(Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	ИндексТекущегоЭлементаКоллекции = Исполнители.Индекс(
		Элементы.Исполнители.ТекущиеДанные);
	Если ИндексТекущегоЭлементаКоллекции > 0  Тогда
		Исполнители.Сдвинуть(ИндексТекущегоЭлементаКоллекции, -1);
	КонецЕсли;
	Модифицированность = Истина;
	ЗаполнитьШаг(Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ОстановитьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрерватьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПродолжитьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПоШаблонуЗавершение(РезультатВыбораШаблона, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(РезультатВыбораШаблона) = Тип("Структура") Тогда
		ЗаполнитьКарточкуПоШаблону(РезультатВыбораШаблона);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	// условия маршрутизации
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
		Элементы.ВариантИсполнения.Видимость = Истина;
		Если ВариантИсполненияID <> "Смешанно" Тогда //@NON-NLS-1
			Элементы.ИсполнителиШаг.Видимость = Ложь;
			Элементы.ИсполнителиПорядокИсполнения.Видимость = Ложь;
		Иначе
			Элементы.ИсполнителиШаг.Видимость = Истина;
			Элементы.ИсполнителиПорядокИсполнения.Видимость = Истина;
		КонецЕсли;
		
		Если ВариантИсполненияID <> "Параллельно" Тогда //@NON-NLS-1
			Элементы.ИсполнителиВверх.Видимость = Истина;
			Элементы.ИсполнителиВниз.Видимость = Истина;
		Иначе
			Элементы.ИсполнителиВверх.Видимость = Ложь;
			Элементы.ИсполнителиВниз.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ВариантИсполнения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(
		ЭтотОбъект,
		ДанныеШаблона);
	ЗаполнитьФормуИзОбъектаXDTO(РезультатЗаполнения.object);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO)
	
	Если ОбъектXDTO.Установлено("objectID") Тогда
		ID = ОбъектXDTO.objectID.ID;
		Тип = ОбъектXDTO.objectID.type;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.УстановитьНавигационнуюСсылку(
		ЭтотОбъект,
		ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьСтандартнуюШапкуБизнесПроцесса(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьВидимостьКомандИзмененияСостоянияПроцесса(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьКонтролераВФорме(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьПроверяющегоВФорме(ЭтотОбъект, ОбъектXDTO);
	
	// условия маршрутизации
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			ЭтотОбъект,
			ОбъектXDTO.performanceType,
			"ВариантИсполнения");
	КонецЕсли;
	
	Исполнители.Очистить();
	
	Для Каждого Исполнитель Из ОбъектXDTO.performers Цикл
		НоваяСтрока = Исполнители.Добавить();
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьИсполнителяВФорме(НоваяСтрока, Исполнитель);
		НоваяСтрока.Срок = Исполнитель.personalDueDate;
		НоваяСтрока.ОписаниеПоручения = Исполнитель.personalDescription;
		НоваяСтрока.НаименованиеПоручения = Исполнитель.personalTaskName;
		НоваяСтрока.Ответственный = Исполнитель.responsible;
		// условия маршрутизации
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
				НоваяСтрока, Исполнитель.performanceOrder, "ПорядокИсполнения")
		КонецЕсли;
	КонецЦикла;
	
	Элементы.Исполнители.ПодчиненныеЭлементы.ИсполнителиВремя.Видимость = ОбъектXDTO.dueTimeEnabled;
	Элементы.ИсполнителиОтветственныйИсполнитель.Доступность = Не ТолькоПросмотр;
	
	Если ОбъектXDTO.Установлено("project") Тогда
		ПроектЗадача = ОбъектXDTO.project.name;
	КонецЕсли;
	
	// Возможно, изменение процесса запрещено его шаблоном.
	ЗапрещеноИзменение = Ложь;
	Если ОбъектXDTO.Свойства().Получить("blockedByTemplate") <> Неопределено Тогда
		ЗапрещеноИзменение = ОбъектXDTO.blockedByTemplate;
	КонецЕсли;
	Элементы.Контролер.ТолькоПросмотр = Элементы.Контролер.ТолькоПросмотр
		Или (ЗначениеЗаполнено(КонтролерID) И ЗапрещеноИзменение);
	Элементы.Проверяющий.ТолькоПросмотр = Элементы.Проверяющий.ТолькоПросмотр
		Или (ЗначениеЗаполнено(ПроверяющийID) И ЗапрещеноИзменение);
	Элементы.СрокДата.ТолькоПросмотр = Элементы.СрокДата.ТолькоПросмотр
		Или (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
	Элементы.СрокВремя.ТолькоПросмотр = Элементы.СрокВремя.ТолькоПросмотр
		Или (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
	Если Исполнители.Количество() > 0 И ЗапрещеноИзменение Тогда
		Элементы.Исполнители.ТолькоПросмотр = Истина;
		Элементы.ИсполнителиВверх.Доступность = Ложь;
		Элементы.ИсполнителиВниз.Доступность = Ложь;
		Элементы.ИсполнителиОтветственныйИсполнитель.Доступность = Ложь;
		Элементы.ВариантИсполнения.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаг(Таблица)
	
	Для Каждого Строка Из Таблица Цикл
		Строка.Шаг = 0;
	КонецЦикла;
	
	КоличествоСтрок = Таблица.Количество();
	Для Инд = 0 По КоличествоСтрок - 1 Цикл
		Строка = Таблица[Инд];
		Если Не ЗначениеЗаполнено(Строка.ПорядокИсполненияID) Тогда
			Прервать;
		КонецЕсли;
		
		Если Строка.Ответственный Тогда
			Продолжить;
		КонецЕсли;
		
		Если Инд = 0 Тогда
			Строка.Шаг = 1;
			Продолжить;
		КонецЕсли;
		
		Если Не Таблица[Инд-1].Ответственный Тогда
			ПредыдущаяСтрока = Таблица[Инд-1];
		Иначе
			Если Инд > 1 Тогда
				ПредыдущаяСтрока = Таблица[Инд-2];
			Иначе
				ПредыдущаяСтрока = Таблица[Инд-1];
			КонецЕсли;
		КонецЕсли;
		Если Строка.ПорядокИсполненияID = "ВместеСПредыдущим" Тогда //@NON-NLS-1
			Строка.Шаг = ПредыдущаяСтрока.Шаг;
			Если ПредыдущаяСтрока.Ответственный И Инд = 1 Тогда
				Строка.Шаг = 1;
			КонецЕсли;
		ИначеЕсли Строка.ПорядокИсполненияID = "ПослеПредыдущего" Тогда //@NON-NLS-1
			Строка.Шаг = ПредыдущаяСтрока.Шаг + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВариантаИсполнения()
	
	Если ВариантИсполненияID <> "Смешанно" Тогда //@NON-NLS-1
		Элементы.ИсполнителиШаг.Видимость = Ложь;
		Элементы.ИсполнителиПорядокИсполнения.Видимость = Ложь;
	Иначе
		Элементы.ИсполнителиШаг.Видимость = Истина;
		Элементы.ИсполнителиПорядокИсполнения.Видимость = Истина;
	КонецЕсли;
	
	Если ВариантИсполненияID <> "Параллельно" Тогда //@NON-NLS-1
		Элементы.ИсполнителиВверх.Видимость = Ложь;
		Элементы.ИсполнителиВниз.Видимость = Ложь;
	Иначе
		Элементы.ИсполнителиВверх.Видимость = Истина;
		Элементы.ИсполнителиВниз.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСсылкуБизнесПроцесса(ОбъектXDTO)
	
	ID = ОбъектXDTO.objectID.ID;
	Если ОбъектXDTO.objectID.Свойства().Получить("presentation") <> Неопределено Тогда
		Представление = ОбъектXDTO.objectID.presentation;
	Иначе
		Представление = ОбъектXDTO.name;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ID) Тогда
		РезультатЗаписи = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаписатьОбъект(Прокси, ОбъектXDTO);
	Иначе
		РезультатСоздания = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьНовыйОбъект(Прокси, ОбъектXDTO);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Если РезультатЗаписи <> Неопределено Тогда // запрос на запись возвращает список
		ОбъектXDTO = Результат.objects[0];
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьПредметыВФорме(ЭтотОбъект, ОбъектXDTO);
	Иначе // запрос на создание возвращает сам объект
		ОбъектXDTO = Результат.object;
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	
	РезультатЗапуска = ИнтеграцияС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, ОбъектXDTO);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, РезультатЗапуска);
	
	УстановитьСсылкуБизнесПроцесса(РезультатЗапуска.businessProcess);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
	
	ОбъектXDTO = Обработки.ИнтеграцияС1СДокументооборот.ПодготовитьШапкуБизнесПроцесса(
		Прокси,
		"DMBusinessProcessPerformance",
		ЭтотОбъект);
	ИсполнителиПроцесса = ОбъектXDTO.performers; // СписокXDTO
	
	// Контролер.
	ДанныеКонтролер = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		КонтролерID,
		КонтролерТип,
		Контролер);
	ДанныеОсновнойОбъектАдресацииКонтролера =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			ОсновнойОбъектАдресацииКонтролераID,
			ОсновнойОбъектАдресацииКонтролераТип,
			ОсновнойОбъектАдресацииКонтролера);
	ДанныеДополнительныйОбъектАдресацииКонтролера =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			ДополнительныйОбъектАдресацииКонтролераID,
			ДополнительныйОбъектАдресацииКонтролераТип,
			ДополнительныйОбъектАдресацииКонтролера);
	
	ОбъектXDTO.controller = ИнтеграцияС1СДокументооборот.УчастникЗадач(
		Прокси,
		ДанныеКонтролер,
		ДанныеОсновнойОбъектАдресацииКонтролера,
		ДанныеДополнительныйОбъектАдресацииКонтролера);
	
	// Проверяющий.
	ДанныеПроверяющий = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		ПроверяющийID,
		ПроверяющийТип,
		Проверяющий);
	ДанныеОсновнойОбъектАдресацииПроверяющего =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			ОсновнойОбъектАдресацииПроверяющегоID,
			ОсновнойОбъектАдресацииПроверяющегоТип,
			ОсновнойОбъектАдресацииПроверяющего);
	ДанныеДополнительныйОбъектАдресацииПроверяющего =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			ДополнительныйОбъектАдресацииПроверяющегоID,
			ДополнительныйОбъектАдресацииПроверяющегоТип,
			ДополнительныйОбъектАдресацииПроверяющего);
	
	ОбъектXDTO.verifier = ИнтеграцияС1СДокументооборот.УчастникЗадач(
		Прокси,
		ДанныеПроверяющий,
		ДанныеОсновнойОбъектАдресацииПроверяющего,
		ДанныеДополнительныйОбъектАдресацииПроверяющего);
	
	Для Каждого Строка Из Исполнители Цикл
		
		ДанныеИсполнитель = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			Строка.ИсполнительID,
			Строка.ИсполнительТип,
			Строка.Исполнитель);
		ДанныеОсновнойОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			Строка.ОсновнойОбъектАдресацииID,
			Строка.ОсновнойОбъектАдресацииТип,
			Строка.ОсновнойОбъектАдресации);
		ДанныеДополнительныйОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			Строка.ДополнительныйОбъектАдресацииID,
			Строка.ДополнительныйОбъектАдресацииТип,
			Строка.ДополнительныйОбъектАдресации);
		
		Исполнитель = ИнтеграцияС1СДокументооборот.УчастникПроцессаИсполнение(
			Прокси,
			ДанныеИсполнитель,
			ДанныеОсновнойОбъект,
			ДанныеДополнительныйОбъект);
		Исполнитель.personalDueDate = Строка.Срок;
		Исполнитель.personalDescription = Строка.ОписаниеПоручения;
		Исполнитель.personalTaskName = Строка.НаименованиеПоручения;
		Исполнитель.responsible = Строка.Ответственный;
		
		// Условия маршрутизации
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
				Прокси,
				Строка,
				"ПорядокИсполнения",
				Исполнитель.performanceOrder,
				"DMTaskExecutionOrder");
		КонецЕсли;
		
		ИсполнителиПроцесса.Добавить(Исполнитель);
		
	КонецЦикла;
	
	// Условия маршрутизации
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси,
			ЭтотОбъект,
			"ВариантИсполнения",
			ОбъектXDTO.performanceType,
			"DMBusinessProcessRoutingType");
	КонецЕсли;
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъект() Экспорт
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПрограммноДобавленнуюКоманду(Команда)
	
	// Вызовем обработчик команды, которая добавлена программно при создании формы на сервере.
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентПереопределяемый.ВыполнитьПрограммноДобавленнуюКоманду(Команда, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметОсновной(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Основной", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметВспомогательный(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Вспомогательный", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет(Команда)
	
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Предметы.Удалить(ТекущиеДанные);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметЗавершение(ДобавленныеПредметы, ПараметрыОбработчика) Экспорт
	
	Если ДобавленныеПредметы = Неопределено Или ДобавленныеПредметы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ОписаниеПредмета Из ДобавленныеПредметы Цикл
		СтрокаПредмета = Предметы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПредмета, ОписаниеПредмета);
		СтрокаПредмета.Картинка = ИнтеграцияС1СДокументооборотКлиентСервер.НомерКартинкиПоРолиПредмета(
			СтрокаПредмета.РольПредмета);
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет()
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
		
	Иначе
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
		ПараметрыОповещения.Вставить("Предмет", ТекущиеДанные.Предмет);
		ПараметрыОповещения.Вставить("ПредметID", ТекущиеДанные.ПредметID);
		ПараметрыОповещения.Вставить("ПредметТип", ТекущиеДанные.ПредметТип);
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ТекущиеДанные.ПредметТип, ТекущиеДанные.ПредметID);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьПроцесс()
	
	ПараметрыПолучения = Новый Структура("ID, type", ID, Тип);
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(Тип, ПараметрыПолучения);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
КонецПроцедуры

#КонецОбласти