////////////////////////////////////////////////////////////////////////////////
//
// Серверные процедуры и функции регламентированных отчетов общего назначения 
// с кешируемым результатом на время сеанса.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьСертификатыНаСервере(Json) Экспорт
	
	Сертификаты = Новый Массив;
	СвойстваСертификатов = ОбщегоНазначенияЭДКОСлужебныйВызовСервера.JsonВСтруктура(Json); // FIX: , "valid_from, valid_to");
	Для Каждого СвойстваСертификата Из СвойстваСертификатов Цикл
		Сертификат = Новый Структура;
		Сертификат.Вставить("Наименование", КриптографияЭДКОСлужебныйВызовСервера.ПолучитьНаименованиеСертификата(СвойстваСертификата.subject));
		Сертификат.Вставить("Версия", СвойстваСертификата.version);
		Сертификат.Вставить("СерийныйНомер", СвойстваСертификата.serial_number);
		Сертификат.Вставить("ПоставщикСтруктура", Новый ФиксированнаяСтруктура(КриптографияЭДКОСлужебныйВызовСервера.ПреобразоватьМассивOIDВСтруктуру(СвойстваСертификата.issuer)));
		Сертификат.Вставить("ВладелецСтруктура", Новый ФиксированнаяСтруктура(КриптографияЭДКОСлужебныйВызовСервера.ПреобразоватьМассивOIDВСтруктуру(СвойстваСертификата.subject)));
		Сертификат.Вставить("Поставщик", КриптографияЭДКОСлужебныйВызовСервера.ПреобразоватьСтруктуруВСтроку(Сертификат.ПоставщикСтруктура));
		Сертификат.Вставить("Владелец", КриптографияЭДКОСлужебныйВызовСервера.ПреобразоватьСтруктуруВСтроку(Сертификат.ВладелецСтруктура));
		Сертификат.Вставить("Отпечаток", СтрЗаменить(СвойстваСертификата.thumbprint, " ", ""));
		Сертификат.Вставить("ИспользоватьДляПодписи", СвойстваСертификата.sign_allowed);
		Сертификат.Вставить("ИспользоватьДляШифрования", СвойстваСертификата.crypt_allowed);
		
		// FIX: 
		Сертификат.Вставить("ДействителенС", МестноеВремя(XMLЗначение(Тип("Дата"), СтрЗаменить(СвойстваСертификата.valid_from, ".", "-")), ЧасовойПоясСеанса()));
		Сертификат.Вставить("ДействителенПо", МестноеВремя(XMLЗначение(Тип("Дата"), СтрЗаменить(СвойстваСертификата.valid_to, ".", "-")), ЧасовойПоясСеанса()));
				
		Сертификат.Вставить("Хранилище", Новый Структура("Хранилище, ЭтоЛокальноеХранилище", ВРег(СвойстваСертификата.storage), Истина));
		
		Сертификаты.Добавить(Сертификат);
	КонецЦикла;
	
	Возврат Сертификаты;
	
КонецФункции

#КонецОбласти