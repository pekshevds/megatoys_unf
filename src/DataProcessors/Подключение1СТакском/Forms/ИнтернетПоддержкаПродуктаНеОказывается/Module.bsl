///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаКонтента.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	Если Параметры.ПриНачалеРаботыСистемы Тогда
		ЗапускатьПриСтарте = Истина;
	Иначе
		Элементы.ГруппаЗапускатьПриСтарте.Видимость = Ложь;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Строка(ЗапускатьПриСтарте);
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
		Элементы.НадписьСодержанияКонтента.Заголовок
			= НСтр("ru = 'Интернет-поддержка этого программного продукта не оказывается. Обратитесь к партнеру, у которого вы приобрели эту программу.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ПрограммноеЗакрытие Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьСодержанияКонтентаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("Получатель", "webIts");
		ДанныеСообщения.Вставить("Тема",       НСтр("ru = 'Интернет-поддержка. Интернет-поддержка продукта не оказывается.'"));
		ДанныеСообщения.Вставить("Сообщение",  НСтр("ru = 'При подключении Интернет-поддержки отображается сообщение ""Интернет-поддержка продукта не оказывается"".'"));
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьНастройкуЗапускатьПриСтарте(ЗначениеНастройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы",
		ЗначениеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускатьПриСтартеПриИзменении(Элемент)
	
	УстановитьНастройкуЗапускатьПриСтарте(ЗапускатьПриСтарте);
	
КонецПроцедуры

#КонецОбласти