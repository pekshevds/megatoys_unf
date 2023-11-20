#Область ПрограммныйИнтерфейс

// Выполняет фискализацию чека
// 
// Параметры:
//  ПараметрыОперации - Структура
//  Отказ - Булево
//  СтандартнаяОбработка - Булево
Процедура ФискализацияЧекаАвтономныеККТ(ПараметрыОперации, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Выполняет открытие смены
// 
// Параметры:
//  ПараметрыОперации - Структура
//  Отказ - Булево
//  СтандартнаяОбработка - Булево
Процедура ОткрытиеСменыАвтономныеККТ(ПараметрыОперации, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Выполняет закрытие смены
// 
// Параметры:
//  ПараметрыОперации - Структура
//  Отказ - Булево
//  СтандартнаяОбработка - Булево
Процедура ЗакрытиеСменыАвтономныеККТ(ПараметрыОперации, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Выполняет открытие формы вопроса
// 
// Параметры:
//  Отказ - Булево
//  СтандартнаяОбработка - Булево
//  ПараметрыОперации - Структура
//  ДополнительныеПараметры - Структура
Процедура ОткрытьСтандартныйВопросОбработкиАвтономнойККТ(Отказ, СтандартнаяОбработка, ПараметрыОперации, ДополнительныеПараметры = Неопределено) Экспорт
	ОбщегоНазначенияРМККлиент.ОткрытьСтандартныйВопросОбработкиАвтономнойККТ(Отказ, СтандартнаяОбработка, ПараметрыОперации, ДополнительныеПараметры);
КонецПроцедуры
#КонецОбласти