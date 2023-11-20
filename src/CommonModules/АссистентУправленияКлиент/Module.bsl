
#Область ПрограммныйИнтерфейс

// См. процедуру ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы(ПараметрыРаботыКлиента) Экспорт
	
	Подключить();
	
КонецПроцедуры

// См. подключение в ПослеНачалаРаботыСистемы.
// 
Процедура ОбработчикПослеОтправкиСообщения(Сообщение, Обсуждение, ДополнительныеПараметры) Экспорт
	
	Если НЕ АссистентУправленияПовтИсп.Подключен() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ АссистентУправленияКлиентСервер.СообщениеАдресованоАссистенту(Сообщение) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСообщения = НовыйОписаниеСообщенияСВ(Сообщение);
	ОбрабатываемоеСообщение = Неопределено;
	
	АссистентУправленияВызовСервера.ОтветитьНаСообщениеПользователя(ОписаниеСообщения, ОбрабатываемоеСообщение);
	
	Если ОбрабатываемоеСообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПроизвольноеДействиеСообщенияАссистента(ОбрабатываемоеСообщение);
	
КонецПроцедуры

// См. подключение в ПослеНачалаРаботыСистемы.
// 
Процедура ОбработчикДействияСообщенияАссистента(Сообщение, Действие, ДополнительныеПараметры) Экспорт
	
	Если НЕ АссистентУправленияПовтИсп.Подключен() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ АссистентУправленияКлиентСервер.ЭтоСообщениеАссистента(Сообщение) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСообщения = НовыйОписаниеСообщенияСВ(Сообщение);
	ОписаниеСообщения.ВыбранноеДействие = Действие;
	
	ОбработатьДействиеСообщенияАссистента(ОписаниеСообщения);
	
КонецПроцедуры

Процедура Подключить() Экспорт
	
	Если НЕ СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат;
	КонецЕсли;
	
	СистемаВзаимодействия.ПодключитьОбработчикДействияСообщения(Новый ОписаниеОповещения("ОбработчикДействияСообщенияАссистента", АссистентУправленияКлиент));
	СистемаВзаимодействия.ПодключитьОбработчикПослеОтправкиСообщения(Новый ОписаниеОповещения("ОбработчикПослеОтправкиСообщения", АссистентУправленияКлиент));
	
КонецПроцедуры

Процедура ОбработатьДействиеСообщенияАссистента(ОписаниеСообщения) Экспорт
	
	Если ОписаниеСообщения.ВыбранноеДействие = АссистентУправленияКлиентСервер.КодДействияСообщенияОтмена() Тогда
		ОбработатьДействиеОтменаСообщенияАссистента(ОписаниеСообщения);
		Возврат;
	КонецЕсли;
	
	ОбработатьПроизвольноеДействиеСообщенияАссистента(ОписаниеСообщения);
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия <> "АссистентУправления_ОбработчикДействияСообщенияАссистента" Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.Объект.Ссылка <> Источник Тогда
		Возврат;
	КонецЕсли;
	
	Действие = Неопределено;
	Параметр.Свойство("Действие", Действие);
	Параметр.Удалить("Действие");
	Параметр.Вставить("ОписаниеОповещения", Новый ОписаниеОповещения("ПослеОбработкиДействияСообщенияАссистента", АссистентУправленияКлиент, Новый Структура("Сообщение,ОбсуждениеИдентификатор", Параметр.Сообщение, Параметр.Обсуждение)));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьДействиеСообщенияАссистента", Форма, Параметр);
	
	Если НЕ Форма.Модифицированность Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Действие);
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПередВыполнениемДействияСообщенияАссистента", АссистентУправленияКлиент, Новый Структура("Действие,ОписаниеОповещения,Форма", Действие, ОписаниеОповещения, Форма)),
		НСтр("ru='Данные были изменены. Сохранить изменения?'"),
		РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередВыполнениемДействияСообщенияАссистента(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеПараметры.Форма.Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, ДополнительныеПараметры.Действие);
	
КонецПроцедуры

Процедура ОбработатьДействиеОтменаСообщенияАссистента(ОписаниеСообщения)
	
	АссистентУправленияВызовСервера.ОбработатьДействиеОтменаСообщенияАссистента(ОписаниеСообщения);
	
КонецПроцедуры

// Передает управление в форму-источник возникновения события.
// 
Процедура ОбработатьПроизвольноеДействиеСообщенияАссистента(ОписаниеСообщения)
	
	СтандартнаяОбработка = Истина;
	
	АссистентУправленияВызовСервера.ПриОбработкеПроизвольногоДействияСообщенияАссистента(ОписаниеСообщения, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправленияКлиентПереопределяемый.ОбработатьПроизвольноеДействиеСообщенияАссистента(ОписаниеСообщения);
	
	Если ОписаниеСообщения.Предмет = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("АссистентУправления_ОбработчикДействияСообщенияАссистента", ОписаниеСообщения, ОписаниеСообщения.Предмет);
	
КонецПроцедуры

Процедура ПослеОбработкиДействияСообщенияАссистента(Результат, ДополнительныеПараметры) Экспорт
	
	Сообщение = Неопределено;
	Если НЕ ДополнительныеПараметры.Свойство("Сообщение", Сообщение) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСообщения = НовыйОписаниеСообщенияСВ();
	ОписаниеСообщения.СообщениеИдентификатор = ДополнительныеПараметры.Сообщение;
	ОписаниеСообщения.ОбсуждениеИдентификатор = ДополнительныеПараметры.ОбсуждениеИдентификатор;
	
	АссистентУправленияВызовСервера.ПослеОбработкиДействияСообщенияАссистента(ОписаниеСообщения);
	
КонецПроцедуры

Функция НовыйОписаниеСообщенияСВ(Сообщение = Неопределено) Экспорт
	
	ОписаниеСообщенияСВ = АссистентУправленияКлиентСервер.НовыйОписаниеСообщенияСВ();
	
	Если Сообщение = Неопределено Тогда
		Возврат ОписаниеСообщенияСВ;
	КонецЕсли;
	
	ОписаниеСообщенияСВ.СообщениеИдентификатор = Сообщение.Идентификатор;
	ОписаниеСообщенияСВ.ОбсуждениеИдентификатор = Сообщение.Обсуждение;
	ОписаниеСообщенияСВ.Данные = Сообщение.Данные;
	
	Возврат ОписаниеСообщенияСВ;
	
КонецФункции

#КонецОбласти
