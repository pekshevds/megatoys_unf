#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьИнформациюПоДействующемуДокументуСогласияОПредоставленииИнформации(Организация, УникальныйИдентификатор, ОписаниеЗавершения = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Организация",             Организация);
	ПараметрыВыполнения.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ОбновитьИнформациюПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(ПараметрыВыполнения, ОписаниеЗавершения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьИнформациюПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(ПараметрыВыполнения, ОписаниеЗавершения)
	
	Результат = СогласиеОПредоставленииИнформацииГИСМТВызовСервера.ОбновитьИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформации(ПараметрыВыполнения);
	
	ОбработатьРезультатОбновленияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформации(Результат, ПараметрыВыполнения, ОписаниеЗавершения);
	
КонецПроцедуры

Процедура ОбработатьРезультатОбновленияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформации(Результат, ПараметрыВыполнения, ОписаниеЗавершения)
	
	Если Результат.ДлительнаяОперация = Неопределено Тогда
		
		Если Результат.ТребуетсяОбновлениеКлючаСессии Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
			ДополнительныеПараметры.Вставить("ОписаниеЗавершения",  ОписаниеЗавершения);
			ДополнительныеПараметры.Вставить("Организация",         Результат.Организация);
			
			ЗапроситьКлючСессииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(Результат.Организация, ДополнительныеПараметры);
			
			Возврат;
		КонецЕсли;
		
		Если ОписаниеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОписаниеЗавершения, Результат);
		КонецЕсли;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Получение информации по действующему документу ""Согласие о предоставлении информации""'");
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ТекстСообщения             = ТекстСообщения;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания       = Истина;
		ПараметрыОжидания.ВыводитьСообщения          = Истина;
		
		Если Результат.Ожидать <> Неопределено Тогда
			ПараметрыОжидания.Интервал = Результат.Ожидать;
		КонецЕсли;
		
		ПараметрыЗавершенияДлительнойОперации = Новый Структура;
		ПараметрыЗавершенияДлительнойОперации.Вставить("ПараметрыВыполнения",     ПараметрыВыполнения);
		ПараметрыЗавершенияДлительнойОперации.Вставить("ОповещениеПриЗавершении", ОписаниеЗавершения);
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			Результат.ДлительнаяОперация,
			Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперацииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение", ЭтотОбъект, ПараметрыЗавершенияДлительнойОперации),
			ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапроситьКлючСессииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(Организация, ДополнительныеПараметры)
	
	ОповещениеПриЗапросеКлючаСессии = Новый ОписаниеОповещения(
		"ПослеПолученияКлючаСессииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ИнтерфейсАвторизацииИСМПКлиент.ЗапроситьКлючСессии(
		ИнтерфейсМОТПКлиентСервер.ПараметрыЗапросаКлючаСессии(Организация),
		ОповещениеПриЗапросеКлючаСессии);
	
КонецПроцедуры

Процедура ПослеПолученияКлючаСессииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ОтказОтАвторизации = Ложь;
	ОшибкаАвторизации  = Ложь;
	
	Если ТипЗнч(Результат) <> Тип("Соответствие") Тогда
		
		ОтказОтАвторизации = Истина;
		
	Иначе
		
		РезультатАвторизации = Результат[ДополнительныеПараметры.Организация];
		
		Если РезультатАвторизации = Неопределено Тогда
			ОшибкаАвторизации = Истина;
			ТекстОшибки = НСтр("ru = 'Произошла ошибка при авторизации в ИС МП.'");
		ИначеЕсли РезультатАвторизации <> Истина Тогда
			ОшибкаАвторизации = Истина;
			ТекстОшибки = РезультатАвторизации;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОтказОтАвторизации Тогда
		
		//ЗакрытьФорму();
		
	ИначеЕсли ОшибкаАвторизации Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		
	Иначе
		
		ОбновитьИнформациюПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(
			ДополнительныеПараметры.ПараметрыВыполнения,
			ДополнительныеПараметры.ОписаниеЗавершения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗавершенияДлительнойОперацииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(Результат, ДополнительныеПараметрыДлительнойОперации) Экспорт
	
	Если Результат = Неопределено Тогда // отменено пользователем
		Если ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		
		Возврат;
		
	ИначеЕсли Результат.Статус <> "Выполнено" Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РезультатПолученияИнформацииПоДействующемуДокументуСогласия = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	ПараметрыВыполнения = ДополнительныеПараметрыДлительнойОперации.ПараметрыВыполнения;
	ОписаниеЗавершения  = ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении;
	
	Если РезультатПолученияИнформацииПоДействующемуДокументуСогласия.ТребуетсяОбновлениеКлючаСессии Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
		ДополнительныеПараметры.Вставить("ОписаниеЗавершения",  ОписаниеЗавершения);
		ДополнительныеПараметры.Вставить("Организация",         РезультатПолученияИнформацииПоДействующемуДокументуСогласия.Организация);
		
		ЗапроситьКлючСессииДляПолученияИнформацииПоДействующемуДокументуСогласияОПредоставленииИнформацииПродолжение(
			РезультатПолученияИнформацииПоДействующемуДокументуСогласия.Организация, ДополнительныеПараметры);
		
	КонецЕсли;
	
	Если ОписаниеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеЗавершения, РезультатПолученияИнформацииПоДействующемуДокументуСогласия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти