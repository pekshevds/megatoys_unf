
#Область ПрограммныйИнтерфейс

#Область ЭлектронныеВесы

// Получает вес с электронных весов.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьПолученияВесаСЭлектронныхВесов(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	КонтекстОперации.Вставить("ИдентификаторКлиента"   , ИдентификаторКлиента);   
	КонтекстОперации.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
	КонтекстОперации.Вставить("ПараметрыОперации"      , ПараметрыОперации);
	КонтекстОперации.Вставить("ДополнительныеПараметры", ДополнительныеПараметры); 
	КонтекстОперации.Вставить("ПодготовитьДанные"      , Ложь); 
	КонтекстОперации.Вставить("ОбработатьДанные"       , Ложь); 
	КонтекстОперации.Вставить("Команда"  , "GetWeight"); 
	КонтекстОперации.Вставить("Результат", Истина);
	
	Если ИдентификаторУстройства = Неопределено Или  ПустаяСтрока(ИдентификаторУстройства) Тогда
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ЭлектронныеВесы");       
		
		Оповещение = Новый ОписаниеОповещения("НачатьОперациюНаЭлектронныхВесахЗавершение", ЭтотОбъект, КонтекстОперации);
		МенеджерОборудованияКлиент.ВыбратьУстройство(Оповещение, ПоддерживаемыеТипыВО,
			НСтр("ru='Выберите электронные весы'"),
			НСтр("ru='Электронные весы не подключены.'"), 
			НСтр("ru='Электронные весы не выбраны.'"));
	Иначе
		НачатьОперациюНаЭлектронныхВесахЗавершение(КонтекстОперации, КонтекстОперации);
	КонецЕсли
	
КонецПроцедуры

// Начать установку веса тары электронных весов.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьУстановкуВесаТарыЭлектронныхВесов(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	КонтекстОперации.Вставить("ИдентификаторКлиента"   , ИдентификаторКлиента);   
	КонтекстОперации.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
	КонтекстОперации.Вставить("ПараметрыОперации"      , ПараметрыОперации);
	КонтекстОперации.Вставить("ДополнительныеПараметры", ДополнительныеПараметры); 
	КонтекстОперации.Вставить("ПодготовитьДанные"      , Ложь); 
	КонтекстОперации.Вставить("ОбработатьДанные"       , Ложь); 
	КонтекстОперации.Вставить("Команда"  , "Calibrate"); 
	КонтекстОперации.Вставить("Результат", Истина);
	
	Если ИдентификаторУстройства = Неопределено Или  ПустаяСтрока(ИдентификаторУстройства) Тогда
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ЭлектронныеВесы");       
		
		Оповещение = Новый ОписаниеОповещения("НачатьОперациюНаЭлектронныхВесахЗавершение", ЭтотОбъект, КонтекстОперации);
		МенеджерОборудованияКлиент.ВыбратьУстройство(Оповещение, ПоддерживаемыеТипыВО,
			НСтр("ru='Выберите электронные весы'"),
			НСтр("ru='Электронные весы не подключены.'"), 
			НСтр("ru='Электронные весы не выбраны.'"));
	Иначе
		НачатьОперациюНаЭлектронныхВесахЗавершение(КонтекстОперации, КонтекстОперации);
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти 

#Область ВесыСПечатьюЭтикеток

// Начать выгрузку данных в весы с печатью этикеток.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьВыгрузкуДанныеВВесыСПечатьюЭтикеток(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	КонтекстОперации.Вставить("ИдентификаторКлиента"   , ИдентификаторКлиента);   
	КонтекстОперации.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
	КонтекстОперации.Вставить("ПараметрыОперации"      , ПараметрыОперации);
	КонтекстОперации.Вставить("ДополнительныеПараметры", ДополнительныеПараметры); 
	КонтекстОперации.Вставить("ПодготовитьДанные"      , Истина); 
	КонтекстОперации.Вставить("ОбработатьДанные"       , Ложь); 
	КонтекстОперации.Вставить("Команда"  , "UploadGoods"); 
	КонтекстОперации.Вставить("Результат", Истина);
	
	Если ИдентификаторУстройства = Неопределено Или ПустаяСтрока(ИдентификаторУстройства) Тогда
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ВесыСПечатьюЭтикеток");       
		
		Оповещение = Новый ОписаниеОповещения("НачатьОперациюНаЭлектронныхВесахЗавершение", ЭтотОбъект, КонтекстОперации);
		МенеджерОборудованияКлиент.ВыбратьУстройство(Оповещение, ПоддерживаемыеТипыВО,
			НСтр("ru='Выберите весы с печатью этикеток'"),
			НСтр("ru='Весы с печатью этикеток не подключены.'"), 
			НСтр("ru='Весы с печатью этикеток не выбраны.'"));
	Иначе
		НачатьОперациюНаЭлектронныхВесахЗавершение(КонтекстОперации, КонтекстОперации);
	КонецЕсли

КонецПроцедуры

// Начать очистку данных в весах с печатью этикеток.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьОчисткуТоваровВВесахСПечатьюЭтикеток(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	КонтекстОперации.Вставить("ИдентификаторКлиента"   , ИдентификаторКлиента);   
	КонтекстОперации.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
	КонтекстОперации.Вставить("ПараметрыОперации"      , ПараметрыОперации);
	КонтекстОперации.Вставить("ДополнительныеПараметры", ДополнительныеПараметры); 
	КонтекстОперации.Вставить("ПодготовитьДанные"      , Ложь); 
	КонтекстОперации.Вставить("ОбработатьДанные"       , Ложь); 
	КонтекстОперации.Вставить("Команда"  , "ClearBase"); 
	КонтекстОперации.Вставить("Результат", Истина);
	
	Если ИдентификаторУстройства = Неопределено Или ПустаяСтрока(ИдентификаторУстройства) Тогда
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ВесыСПечатьюЭтикеток");       
		
		Оповещение = Новый ОписаниеОповещения("НачатьОперациюНаЭлектронныхВесахЗавершение", ЭтотОбъект, КонтекстОперации);
		МенеджерОборудованияКлиент.ВыбратьУстройство(Оповещение, ПоддерживаемыеТипыВО,
			НСтр("ru='Выберите весы с печатью этикеток'"),
			НСтр("ru='Весы с печатью этикеток не подключены.'"), 
			НСтр("ru='Весы с печатью этикеток не выбраны.'"));
	Иначе
		НачатьОперациюНаЭлектронныхВесахЗавершение(КонтекстОперации, КонтекстОперации);
	КонецЕсли
	
КонецПроцедуры

// Начать выгрузку изображений товаров в весы с печатью этикеток.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьВыгрузкуИзображенийТоваровВВесыСПечатьюЭтикеток(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства, ПараметрыОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	КонтекстОперации.Вставить("ИдентификаторКлиента"   , ИдентификаторКлиента);   
	КонтекстОперации.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
	КонтекстОперации.Вставить("ПараметрыОперации"      , ПараметрыОперации);
	КонтекстОперации.Вставить("ДополнительныеПараметры", ДополнительныеПараметры); 
	КонтекстОперации.Вставить("ПодготовитьДанные"      , Истина); 
	КонтекстОперации.Вставить("ОбработатьДанные"       , Ложь); 
	КонтекстОперации.Вставить("Команда"  , "UploadProductImages"); 
	КонтекстОперации.Вставить("Результат", Истина);
	
	Если ИдентификаторУстройства = Неопределено Или ПустаяСтрока(ИдентификаторУстройства) Тогда
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ВесыСПечатьюЭтикеток");       
		
		Оповещение = Новый ОписаниеОповещения("НачатьОперациюНаЭлектронныхВесахЗавершение", ЭтотОбъект, КонтекстОперации);
		МенеджерОборудованияКлиент.ВыбратьУстройство(Оповещение, ПоддерживаемыеТипыВО,
			НСтр("ru='Выберите весы с печатью этикеток'"),
			НСтр("ru='Весы с печатью этикеток не подключены.'"), 
			НСтр("ru='Весы с печатью этикеток не выбраны.'"));
	Иначе
		НачатьОперациюНаЭлектронныхВесахЗавершение(КонтекстОперации, КонтекстОперации);
	КонецЕсли

КонецПроцедуры

#КонецОбласти 

#КонецОбласти  

#Область СлужебныеПроцедурыИФункции

Процедура НачатьОперациюНаЭлектронныхВесахЗавершение(РезультатВыбора, КонтекстОперации) Экспорт
	
	Если РезультатВыбора.Результат Тогда 
		ПараметрыВыполнениеКоманды = МенеджерОборудованияКлиентСервер.ПараметрыВыполнениеКоманды(КонтекстОперации.Команда, ОборудованиеВесовоеОборудованиеВызовСервера,
		КонтекстОперации.ДополнительныеПараметры, КонтекстОперации.ПодготовитьДанные, КонтекстОперации.ОбработатьДанные);
		МенеджерОборудованияКлиент.НачатьВыполнениеКоманды(КонтекстОперации.ОповещениеПриЗавершении, КонтекстОперации.ИдентификаторКлиента, 
			РезультатВыбора.ИдентификаторУстройства, КонтекстОперации.ПараметрыОперации, ПараметрыВыполнениеКоманды);
	Иначе
		ВыполнитьОбработкуОповещения(КонтекстОперации.ОповещениеПриЗавершении, РезультатВыбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти  
