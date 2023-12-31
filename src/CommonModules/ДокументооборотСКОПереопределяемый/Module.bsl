////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронный документооборот с контролирующими органами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Срабатывает после записи объекта ДокументРеализацииПолномочийНалоговыхОрганов, когда уже записаны его файлы.
//
// Параметры:
//  Ссылка	 - ДокументСсылка.ДокументРеализацииПолномочийНалоговыхОрганов - Входящее сообщение от ФНС
//  Файлы	 - Массив структур - Массив описания вложений документа - структура 
//       * Адрес - Строка - Адрес во временном хранилище
//       * ИмяФайла - Строка - Имя файла с расширением
//
Процедура ПослеЗаписиДокументаРеализацииПолномочийНалоговыхОрганов(Ссылка, Файлы) Экспорт
	
КонецПроцедуры

// Определяет наличие в конфигурации-потребителе механизма сверки имущественных налогов.
//
// Параметры:
//  РеализованаСверка - Булево - параметр будет установлен в Истина, если в конфигурации предусмотрена сверка
//
Процедура ПроверитьРеализованаСверкаИмущественныхНалогов(РеализованаСверка) Экспорт
	
КонецПроцедуры

// Указывает, поддерживает ли конфигурация тариф Промо ЕНС
//
// Параметры:
//  Поддерживает - Булево - Если конфигурация поддерживает тариф Промо ЕНС, то присваивать Поддерживает = Истина
//
Процедура КонфигурацияПоддерживаетТарифПромоЕНС(Поддерживает) Экспорт
	
КонецПроцедуры

#КонецОбласти