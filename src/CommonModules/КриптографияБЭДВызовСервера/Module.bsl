
#Область СлужебныйПрограммныйИнтерфейс

// См. КриптографияБЭД.СвойстваСертификатов.
Функция СвойстваСертификатов(Сертификаты) Экспорт
	
	Возврат КриптографияБЭД.СвойстваСертификатов(Сертификаты);
	
КонецФункции

// См. КриптографияБЭД.ПаролиСертификатов
Функция ПаролиСертификатов(Сертификаты) Экспорт
	
	Возврат КриптографияБЭД.ПаролиСертификатов(Сертификаты);
	
КонецФункции

// Возвращает сертификаты из подписи.
// Если на сервере недоступно получение сертификатов, то возвращает пустой массив.
// При возникновении ошибки вызывается исключение.
//
// Параметры:
//  Подпись - ДвоичныеДанные - Подпись, из которой нужно получить сертификаты.
//  Выполнено - Булево - Устанавливается в Истина, если было получение сертификатов.
//
// Возвращаемое значение:
//  Массив из ДвоичныеДанные - Сертификаты, полученные из подписи.
//
Функция ПолучитьСертификатыИзПодписи(Знач Подпись, Знач Выполнено = Ложь) Экспорт
	
	СертификатыКриптографии = КриптографияБЭД.ПолучитьСертификатыИзПодписи(Подпись, Выполнено);
	
	Сертификаты = Новый Массив;
	Для каждого СертификатКриптографии Из СертификатыКриптографии Цикл
		Сертификаты.Добавить(СертификатКриптографии.Выгрузить());
	КонецЦикла;
	
	Возврат Сертификаты;
	
КонецФункции

#КонецОбласти