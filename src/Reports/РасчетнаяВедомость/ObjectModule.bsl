#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["Основной"].Вставить("Теги", НСТР("ru = 'Зарплата'"));
	НастройкиВариантов["Основной"].Вставить("ИмяМакетаОбразца", "ОбразецОсновной");
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли