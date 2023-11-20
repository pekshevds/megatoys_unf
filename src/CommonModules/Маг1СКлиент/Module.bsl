///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Маг1С"
// ОбщийМодуль.Маг1СКлиент
//
// Все клиентские процедуры и функции для работы с mag1c
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик команды запуска процедуры проверки наличия и установки расширения mag1c
// Можно использовать в командах, создаваемых в конфигурации
//
Процедура ОткрытьФормуМастераУстановитьРасширение() Экспорт
	ПараметрыБазы = Маг1СВызовСервера.ПараметрыБазы();
	
	Если ПараметрыБазы.УжеУстановлено Тогда
		ОткрытьФормуМастера();
		ОбновитьИнтерфейс();
		Возврат;
	КонецЕсли;
	
	Если ПараметрыБазы.РазделениеВключено Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиент.ФорматированнаяСтрока(НСтр("ru = 'Для работы с сервисом веб-витрин mag1c необходимо установить расширение mag1c из <a href=""e1cib/app/Обработка.КаталогРасширений"">каталога расширений</a>.'"));
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
		
	ВерсияПлатформыПодходит = ВерсияПлатформыПоддерживаетОбновлениеРасширений();
	
	Если Не ВерсияПлатформыПодходит.ВерсияПодходит Тогда
		ТекстПредупреждения = НСтр("ru = 'Для работы с веб-витриной необходимо обновить версию платформы 1С:Предприятие до версии %РекомендуемаяВерсия% или старше.'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения,
											"%РекомендуемаяВерсия%",
											ВерсияПлатформыПодходит.РекомендуемаяВерсия);
			
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыБазы.АутентификацияИППВыполнена Тогда
		УстановитьРасширениеКлиент();	
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьРасширениеКлиент",
													  ЭтотОбъект);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения);											  
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы() Экспорт
	Если СтрНайти(ПараметрЗапуска, "RunMag1cWizard") <> 0 Тогда
		ОткрытьФормуМастера();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуМастера()
	МодульМаг1СИнтеграцияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("Маг1СИнтеграцияСлужебныйКлиент");
	МодульМаг1СИнтеграцияСлужебныйКлиент.ОбработкаКомандыОткрытьФормуПолученияИнформацииПоПрофилю();	
КонецПроцедуры

Функция ВерсияПлатформыПоддерживаетОбновлениеРасширений()
	
	Результат = Новый Структура("ВерсияПодходит, РекомендуемаяВерсия", Истина, "");
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	
	ЧастиВерсии = СтрРазделить(ВерсияПлатформы, ".");
	
	Если Число(ЧастиВерсии[2]) >= 17 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Число(ЧастиВерсии[2]) < 15 Тогда
		Результат.ВерсияПодходит      = Ложь;
		Результат.РекомендуемаяВерсия = "8.3.17.1851";
		Возврат Результат;
	КонецЕсли;
	
	Если Число(ЧастиВерсии[2]) = 15 Тогда
		Если Число(ЧастиВерсии[3]) >= 1859 Тогда
			Возврат Результат;
		Иначе
			Результат.ВерсияПодходит      = Ложь;
			Результат.РекомендуемаяВерсия = "8.3.15.2107";
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	
	Если Число(ЧастиВерсии[2]) = 16 Тогда
		Если Число(ЧастиВерсии[3]) >= 1167 Тогда
			Возврат Результат;
		Иначе
			Результат.ВерсияПодходит      = Ложь;
			Результат.РекомендуемаяВерсия = "8.3.16.1814";
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьРасширениеКлиент(Результат = Истина, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Маг1СВызовСервера.УстановитьРасширение() Тогда
		ТекстПредупреждения = НСтр("ru = 'При установке расширения для работы с сервисом mag1c произошли ошибки. Подробности - в журнале регистрации.'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Для продолжения настройки подключения к сервису mag1c необходимо перезапустить программу.'");
	
	КнопкиВопроса = Новый СписокЗначений;
	КнопкиВопроса.Добавить("Перезапустить", "Перезапустить");
	КнопкиВопроса.Добавить("Отмена", "Отмена");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОПерезапуске", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиВопроса); 
	
КонецПроцедуры

Процедура ОтветНаВопросОПерезапуске(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> "Перезапустить" Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершитьРаботуСистемы(Истина, Истина, "/C RunMag1cWizard");
КонецПроцедуры

#КонецОбласти
