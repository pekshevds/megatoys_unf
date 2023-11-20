
#Область ПрограммныйИнтерфейс

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
// 	Типы - См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.СвойстваЗаданий);
	
КонецПроцедуры

// Возвращает идентификатор хранилища в виде строки.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Строка - идентификатор хранилища. 
//
Функция ИдентификаторХранилища() Экспорт
КонецФункции

#КонецОбласти 
