#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Задача") Тогда
		Задача = Параметры.Задача;
		ЗадачаID = Параметры.ЗадачаID;
		ЗадачаТип = Параметры.ЗадачаТип;
	КонецЕсли;
	
	Если Параметры.Свойство("ИспользоватьИнтеграциюДО3") Тогда
		ИспользоватьИнтеграциюДО2 = Ложь;
		ИспользоватьИнтеграциюДО3 = Истина;
	Иначе
		ИспользоватьИнтеграциюДО2 = Истина;
		ИспользоватьИнтеграциюДО3 = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("КомуНачалоВыбораЗавершение", ЭтотОбъект);
	Если ИспользоватьИнтеграциюДО3 Тогда
		ИмяФормыВыбора = "Обработка.ИнтеграцияС1СДокументооборот3.Форма.АдреснаяКнига";
	Иначе
		ИмяФормыВыбора = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса";
	КонецЕсли;
	ОткрытьФорму(ИмяФормыВыбора,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КомуНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Исполнитель);
	Результат.Свойство("ИсполнительID", ИсполнительID);
	Результат.Свойство("ИсполнительТип", ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип",ДополнительныйОбъектАдресацииТип);
	
	ОбновитьПолеКому();
	
КонецПроцедуры

&НаКлиенте
Процедура КомуАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			?(ИспользоватьИнтеграциюДО3, "DMEmployee", "DMUser"),
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомуОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ОчиститьИсполнителей();
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			?(ИспользоватьИнтеграциюДО3, "DMEmployee", "DMUser"),
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Исполнитель",
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка,
				ЭтотОбъект,,,
				Ложь);
			ОбновитьПолеКому();
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомуОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОчиститьИсполнителей();
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Исполнитель",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект,,,
		Ложь);
	ОбновитьПолеКому();
	
КонецПроцедуры

&НаКлиенте
Процедура КомуОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьИсполнителей();
	ОбновитьПолеКому();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перенаправить(Команда)
	
	Если Не ЗначениеЗаполнено(Исполнитель) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указан исполнитель задачи.'"),, "Кому");
		Возврат;
	КонецЕсли;
	
	Результат = ПеренаправитьЗадачу();
	Если Результат.Успешно Тогда
		ПараметрыОповещения = Новый Структура("ID, Тип, ИмяОперации", ЗадачаID, ЗадачаТип, "Перенаправить");
		Оповестить("Документооборот_ДействиеНадЗадачей", ПараметрыОповещения);
		Если Открыта() Тогда
			Закрыть(Истина);
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, Результат.ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьПолеКому()
	
	МассивСтрок = Новый Массив;
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		МассивСтрок.Добавить(Исполнитель);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда
		МассивСтрок.Добавить(ОсновнойОбъектАдресации);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда
		МассивСтрок.Добавить(ДополнительныйОбъектАдресации);
	КонецЕсли;
	
	Кому = СтрСоединить(МассивСтрок, ", ");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсполнителей()
	
	Исполнитель = "";
	ИсполнительID = "";
	ИсполнительТип = "";
	
	ОсновнойОбъектАдресации = "";
	ОсновнойОбъектАдресацииID = "";
	ОсновнойОбъектАдресацииТип = "";
	
	ДополнительныйОбъектАдресации = "";
	ДополнительныйОбъектАдресацииID = "";
	ДополнительныйОбъектАдресацииТип = "";
	
КонецПроцедуры

&НаСервере
Функция ПеренаправитьЗадачу()
	
	Результат = Новый Структура("Успешно, ТекстОшибки", Истина, "");
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMRedirectTasksRequest");
	СписокЗадач = Запрос.tasks; // СписокXDTO
	
	Запрос.Comment = Комментарий;
	
	ЗадачаXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		?(ИспользоватьИнтеграциюДО3, "DMTaskAction", "DMObject"));
	ЗадачаXDTO.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ЗадачаID,
		ЗадачаТип);
	ЗадачаXDTO.name = Задача;
	СписокЗадач.Добавить(ЗадачаXDTO);
	
	ДанныеИсполнитель = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		ИсполнительID,
		ИсполнительТип,
		Исполнитель);
	ДанныеОсновнойОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		ОсновнойОбъектАдресацииID,
		ОсновнойОбъектАдресацииТип,
		ОсновнойОбъектАдресации);
	ДанныеДополнительныйОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		ДополнительныйОбъектАдресацииID,
		ДополнительныйОбъектАдресацииТип,
		ДополнительныйОбъектАдресации);
	
	Запрос.performer = ИнтеграцияС1СДокументооборотБазоваяФункциональность.УчастникЗадач(
		Прокси,
		ДанныеИсполнитель,
		ДанныеОсновнойОбъект,
		ДанныеДополнительныйОбъект);
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, Ответ, "DMError") Тогда
		Результат.Успешно = Ложь;
		ТекстОшибкиМассив = СтрРазделить(Ответ.description, "{");
		Результат.ТекстОшибки = СокрЛП(ТекстОшибкиМассив[0]);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти