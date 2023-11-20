#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоПапок(ДеревоПапок.ПолучитьЭлементы(), ""); // корневые папки
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПапок

&НаКлиенте
Процедура ДеревоПапокПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = ДеревоПапок.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоПапок.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбратьВыполнить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьКарточкуВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьВыполнить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПапок(ВеткаДерева, ИдентификаторПапки)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetSubFoldersRequest");
	
	Запрос.folder = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ИдентификаторПапки,
		"DMInternalDocumentFolder");
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	ВеткаДерева.Очистить();
	
	Для Каждого ПапкаXDTO Из Ответ.folders Цикл
		Лист = ВеткаДерева.Добавить();
		Лист.ID = ПапкаXDTO.objectID.ID;
		Лист.Наименование = ПапкаXDTO.name;
		Лист.ИндексКартинки = 0;
		Лист.ПодпапкиСчитаны = Ложь;
		
		Лист.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДокументов()
	
	СписокДокументов.Очистить();
	
	ДокументыXDTO = ИнтеграцияС1СДокументооборотВызовСервера.ДокументыПоВладельцу(ИдентификаторТекущейПапки, ИмяТекущейПапки, "DMInternalDocumentFolder");
	
	Для Каждого СведенияОДокументе Из ДокументыXDTO.documents Цикл
		НоваяСтрока = СписокДокументов.Добавить();
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(НоваяСтрока,СведенияОДокументе,"Документ");
		НоваяСтрока.ПодписанЭП = СведенияОДокументе.signatures.Количество() > 0;
		Если СведенияОДокументе.Установлено("author") Тогда
			НоваяСтрока.Автор = СведенияОДокументе.author.name;
		КонецЕсли;
		НоваяСтрока.ИндексКартинки = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексКартинкиЭлементаСправочника();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	Если Элементы.СписокДокументов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(Элементы.СписокДокументов.ТекущиеДанные.ДокументТип,Элементы.СписокДокументов.ТекущиеДанные.ДокументID);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = ДеревоПапок.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПапок(Лист.ПолучитьЭлементы(), Лист.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Данные = Элементы.ДеревоПапок.ТекущиеДанные;
	
	Если Данные.ID <> ИдентификаторТекущейПапки Тогда
		ИдентификаторТекущейПапки = Данные.ID;
		ИмяТекущейПапки = Данные.Наименование;
		ОбновитьСписокДокументов();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если Элементы.СписокДокументов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = Новый Структура;
	ДанныеВыбора.Вставить("РеквизитID",Элементы.СписокДокументов.ТекущиеДанные.ДокументID);
	ДанныеВыбора.Вставить("РеквизитТип",Элементы.СписокДокументов.ТекущиеДанные.ДокументТип);
	ДанныеВыбора.Вставить("РеквизитПредставление",Элементы.СписокДокументов.ТекущиеДанные.Документ);
	
	Закрыть(ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти
