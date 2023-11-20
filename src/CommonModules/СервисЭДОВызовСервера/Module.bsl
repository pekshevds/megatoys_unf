#Область СлужебныйПрограммныйИнтерфейс

// См. СервисЭДО.ДанныеДляРегистрационногоПакета1СЭДО
Функция ДанныеДляРегистрационногоПакета1СЭДО(ПараметрыРегистрации) Экспорт
	
	Возврат СервисЭДО.ДанныеДляРегистрационногоПакета1СЭДО(ПараметрыРегистрации);
	
КонецФункции

// Запуск длительной операции отправки заявления на регистрацию в сервисе 1С:ЭДО.
//
// Параметры:
// ДанныеПакета - см. СервисЭДО.ДанныеДляРегистрационногоПакета1СЭДО
// КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
//
// Возвращаемое значение:
//  см. ДлительныеОперации.ВыполнитьФункцию
Функция НачатьОтправкуЗаявлениеНаРегистрациюВСервис1СЭДО(ДанныеПакета, КонтекстДиагностики) Экспорт
	
	Если ДанныеПакета.Свойство("ИдентификаторЗадания")
			И ДанныеПакета.ИдентификаторЗадания <> Неопределено Тогда
		ИнтеграцияБСПБЭДВызовСервера.ОтменитьВыполнениеЗадания(ДанныеПакета.ИдентификаторЗадания);
	КонецЕсли;
	
	ИмяФункции = "СервисЭДО.ОтправитьРегистрационныйПакет1СЭДО";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Отправка данных учетной записи в сервис 1С:ЭДО'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяФункции, ДанныеПакета, КонтекстДиагностики,
		Неопределено);
	
КонецФункции

// Запуск длительной операции для проверки состояния регистрации на сервере 1С-ЭДО.
//
// Параметры:
// ИдентификаторыЗаявок - Массив из Строка
// ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы
// Возвращаемое значение:
//  см. ДлительныеОперации.ВыполнитьФункцию
Функция НачатьПолучениеСостоянияРегистрацииВСервисе1СЭДО(ИдентификаторыЗаявок, ИдентификаторФормы) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение результата регистрации в сервисе 1С:ЭДО'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"СервисЭДО.ПолучитьСостояниеРегистрацииВСервисе1СЭДО", ИдентификаторыЗаявок);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. СервисЭДО.Авторизоваться
// 
// Параметры:
// 	КлючСинхронизации - см. СинхронизацияЭДОКлиентСервер.НовыйКлючСинхронизации
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 	ДанныеСертификата - ДвоичныеДанные
// 	ПараметрыАвторизации - Структура - см. СервисЭДО.Авторизоваться.ПараметрыАвторизации
// Возвращаемое значение:
// 	см. СервисЭДО.Авторизоваться
Функция Авторизоваться(КлючСинхронизации, КонтекстДиагностики, ДанныеСертификата = Неопределено,
	ПараметрыАвторизации = Неопределено) Экспорт
	
	Возврат СервисЭДО.Авторизоваться(КлючСинхронизации, КонтекстДиагностики, ДанныеСертификата, ПараметрыАвторизации);
	
КонецФункции

// Запуск длительной операции получения параметров уведомления из сервиса 1С-ЭДО.
//
// Параметры:
// КлючСинхронизации - см. СинхронизацияЭДОКлиентСервер.НовыйКлючСинхронизации
// ИдентификаторФормы - УникальныйИдентификатор
//
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция НачатьПолучениеПараметровУведомлений(КлючСинхронизации,
	ИдентификаторФормы = Неопределено) Экспорт
	
	ИмяФункции = "СервисЭДО.ПолучитьПараметрыУведомлений";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение настроек уведомлений в сервисе 1С-ЭДО'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяФункции,
		КлючСинхронизации);
	
КонецФункции

// Запуск длительной операции отправки параметров уведомления в сервис 1С-ЭДО.
//
// Параметры:
// ПараметрыУведомлений - см. СервисЭДОКлиентСервер.НовыеПараметрыУведомлений
// КлючСинхронизации - см. СинхронизацияЭДОКлиентСервер.НовыйКлючСинхронизации
// ИдентификаторФормы - УникальныйИдентификатор
//
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция НачатьОбновлениеПараметровУведомлений(Знач ПараметрыУведомлений, КлючСинхронизации,
 	ИдентификаторФормы = Неопределено) Экспорт
	
	ИмяПроцедуры = "СервисЭДО.ОбновитьПараметрыУведомлений";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление настроек уведомлений в сервисе 1С-ЭДО'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяПроцедуры, ПараметрыУведомлений,
		КлючСинхронизации);
	
КонецФункции

#КонецОбласти