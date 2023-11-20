#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Установить настройку пользователя.
// 
// Параметры:
//  ЗначениеНастройки  - Произвольный - Значение настройки
//  ИмяНастройки - Строка - Имя настройки
//  Пользователь - СправочникСсылка.Пользователи, Неопределено - Пользователь
//  Организация - СправочникСсылка.Организации - для настроек, хранимых в разрезе организаций
//
Процедура Установить(ЗначениеНастройки, ИмяНастройки, Пользователь = Неопределено, Знач Организация = Неопределено) Экспорт

	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = Справочники.Организации.ПустаяСсылка();		
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();

	НаборЗаписей.Отбор.Пользователь.Использование = Истина;
	НаборЗаписей.Отбор.Пользователь.Значение = Пользователь;
	НаборЗаписей.Отбор.Настройка.Использование = Истина;
	НаборЗаписей.Отбор.Настройка.Значение = ПланыВидовХарактеристик.НастройкиПользователей[ИмяНастройки];
	НаборЗаписей.Отбор.Организация.Значение = Организация;
	НаборЗаписей.Отбор.Организация.Использование = Истина;
	

	Запись = НаборЗаписей.Добавить();

	Запись.Пользователь = Пользователь;
	Запись.Настройка = ПланыВидовХарактеристик.НастройкиПользователей[ИмяНастройки];
	Запись.Значение = ПланыВидовХарактеристик.НастройкиПользователей[ИмяНастройки].ТипЗначения.ПривестиЗначение(
		ЗначениеНастройки);
	Запись.Организация = Организация;
	
	НаборЗаписей.Записать();

	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

#КонецОбласти

#КонецЕсли