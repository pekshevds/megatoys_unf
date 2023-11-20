////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис криптографии (служебный)".
//  
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

Процедура Зашифровать(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Результат = СервисКриптографии.Зашифровать(
		Параметры.Данные,
		Параметры.Получатели, 
		Параметры.ТипШифрования, 
		Параметры.ПараметрыШифрования);
		
	Если Параметры.ВернутьРезультатКакАдресВоВременномХранилище  Тогда
		Если ТипЗнч(Результат) = Тип("Массив") Тогда 
			Для Индекс = 0 По Результат.ВГраница() Цикл
				Если ЭтоАдресВременногоХранилища(Результат[Индекс]) Тогда //Сервер вернет адреса, необходимо переложить
					ЗашифрованныеДанные = ПолучитьИзВременногоХранилища(Результат[Индекс]);
					УдалитьИзВременногоХранилища(Результат[Индекс]);
					Результат[Индекс] = ЗашифрованныеДанные;
				КонецЕсли;
				Результат[Индекс] = ПоместитьВоВременноеХранилище(Результат[Индекс], Параметры.АдресаФайловРезультата[Индекс]);
			КонецЦикла;
		ИначеЕсли ТипЗнч(Результат) <> Тип("Структура") Тогда 
			Результат = ПоместитьВоВременноеХранилище(Результат, Параметры.АдресаФайловРезультата[0]);			
		КонецЕсли;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ЗашифроватьБлок(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Результат = СервисКриптографии.ЗашифроватьБлок(
		Параметры.Данные,
		Параметры.Получатель);
		
	Если Параметры.ВернутьРезультатКакАдресВоВременномХранилище  Тогда
		Результат = ПоместитьВоВременноеХранилище(Результат, Параметры.АдресФайлаРезультата);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура Расшифровать(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Если Параметры.Свойство("МаркерыБезопасности") Тогда 
		УстановитьМаркерыБезопасности(Параметры.МаркерыБезопасности);
	КонецЕсли;

	Результат = СервисКриптографии.Расшифровать(
		Параметры.ЗашифрованныеДанные,
		Параметры.Сертификат, 
		Параметры.ТипШифрования, 
		Параметры.ПараметрыШифрования);
		
	Если Параметры.ВернутьРезультатКакАдресВоВременномХранилище  Тогда
		Если ТипЗнч(Результат) <> Тип("Структура") Тогда 
			Результат = ПоместитьВоВременноеХранилище(Результат, Параметры.АдресаФайловРезультата[0]);			
		КонецЕсли;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		
КонецПроцедуры

Процедура РасшифроватьБлок(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Если Параметры.Свойство("МаркерыБезопасности") Тогда 
		УстановитьМаркерыБезопасности(Параметры.МаркерыБезопасности);
	КонецЕсли;

	Результат = СервисКриптографии.РасшифроватьБлок(
		Параметры.ЗашифрованныеДанные,
		Параметры.Получатель, 
		Параметры.КлючеваяИнформация, 
		Параметры.ПараметрыШифрования);
		
	Если Параметры.ВернутьРезультатКакАдресВоВременномХранилище  Тогда
		Если ТипЗнч(Результат) <> Тип("Структура") Тогда 
			Результат = ПоместитьВоВременноеХранилище(Результат, Параметры.АдресФайлаРезультата);			
		КонецЕсли;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		
КонецПроцедуры

Процедура Подписать(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Если Параметры.Свойство("МаркерыБезопасности") Тогда 
		УстановитьМаркерыБезопасности(Параметры.МаркерыБезопасности);
	КонецЕсли;
	
	Результат = СервисКриптографии.Подписать(
		Параметры.Данные,
		Параметры.Подписант, 
		Параметры.ТипПодписи, 
		Параметры.ПараметрыПодписания);
		
	Если Параметры.ВернутьРезультатКакАдресВоВременномХранилище  Тогда
		Если ТипЗнч(Результат) = Тип("Массив") Тогда 
			Для Индекс = 0 По Результат.ВГраница() Цикл
				Если ЭтоАдресВременногоХранилища(Результат[Индекс]) Тогда //Сервер вернет адреса, необходимо переложить
					ПодписанныеДанные = ПолучитьИзВременногоХранилища(Результат[Индекс]);
					УдалитьИзВременногоХранилища(Результат[Индекс]);
				Иначе
					ПодписанныеДанные = Результат[Индекс];
				КонецЕсли;
				Результат[Индекс] = ПоместитьВоВременноеХранилище(ПодписанныеДанные, Параметры.АдресаФайловРезультата[Индекс]);
			КонецЦикла;
		ИначеЕсли ТипЗнч(Результат) <> Тип("Структура") Тогда 
			Результат = ПоместитьВоВременноеХранилище(Результат, Параметры.АдресаФайловРезультата[0]);
		КонецЕсли;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьПодпись(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Результат = СервисКриптографии.ПроверитьПодпись(
		Параметры.Подпись, 
		Параметры.Данные, 
		Параметры.ТипПодписи, 
		Параметры.ПараметрыПодписания);
		
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьСертификат(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Результат = СервисКриптографии.ПроверитьСертификат(Параметры.Сертификат);
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьСертификатСПараметрами(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Результат = СервисКриптографии.ПроверитьСертификатСПараметрами(Параметры.Сертификат, Параметры.ПараметрыПроверки);
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьСвойстваСертификата(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	СвойстваСертификата = СервисКриптографии.ПолучитьСвойстваСертификата(Параметры.Сертификат);
	ПоместитьВоВременноеХранилище(СвойстваСертификата, АдресРезультата);	
	
КонецПроцедуры

Процедура ПолучитьНастройкиПолученияВременныхПаролей(Параметры, АдресРезультата) Экспорт
	
	ПоместитьВоВременноеХранилище(
		СервисКриптографии.ПолучитьНастройкиПолученияВременныхПаролей(Параметры.ИдентификаторСертификата), АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьВременныйПароль(Параметры, АдресРезультата) Экспорт
	
	ИдентификаторСессии = Неопределено;	
	Если Параметры.Свойство("ИдентификаторСессии") Тогда 
		ИдентификаторСессии = Параметры.ИдентификаторСессии;
	КонецЕсли;
	
	Результат = СервисКриптографии.ПолучитьВременныйПароль(
		Параметры.ИдентификаторСертификата,
		Параметры.ПовторнаяОтправка,
		Параметры.Тип,
		ИдентификаторСессии);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьСвойстваКриптосообщения(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	СвойстваКриптосообщения = СервисКриптографии.ПолучитьСвойстваКриптосообщения(Параметры.Криптосообщение, Параметры.ТолькоКлючевыеСвойства);
	ПоместитьВоВременноеХранилище(Новый ФиксированнаяСтруктура(СвойстваКриптосообщения), АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьСеансовыйКлюч(Параметры, АдресРезультата) Экспорт
	
	ИдентификаторСессии = Неопределено;	
	Если Параметры.Свойство("ИдентификаторСессии") Тогда 
		ИдентификаторСессии = Параметры.ИдентификаторСессии;
	КонецЕсли;
	
	Попытка
		Результат = ПолучитьСеансовыеКлючи(Параметры.ИдентификаторСертификата, Параметры.ВременныйПароль, ИдентификаторСессии);
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	Исключение
		Параметры.ВременныйПароль = ?(СтрДлина(Параметры.ВременныйПароль) = 6, 999999, Параметры.ВременныйПароль);
		ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытияАутентификация(), ИнформацияОбОшибке(), Параметры);
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ПолучитьСертификатыИзПодписи(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	СертификатыИзПодписи = СервисКриптографии.ПолучитьСертификатыИзПодписи(Параметры.Подпись);
	ПоместитьВоВременноеХранилище(СертификатыИзПодписи, АдресРезультата);
		
КонецПроцедуры

Процедура ХешированиеДанных(Параметры, АдресРезультата, АдресДополнительногоРезультата = Неопределено) Экспорт
	
	Результат = СервисКриптографии.ХешированиеДанных(
		Параметры.Данные, 
		Параметры.АлгоритмХеширования, 
		Параметры.ПараметрыХеширования);

	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		
КонецПроцедуры

// Вычислить идентификатор сертификата
// 
// Параметры: 
//  СерийныйНомер - Строка
//  Издатель - СписокЗначений из Строка
// 
// Возвращаемое значение: 
//  Строка - Вычислить идентификатор сертификата
Функция ВычислитьИдентификаторСертификата(СерийныйНомер, Издатель) Экспорт
	
	Возврат СервисКриптографии.ВычислитьИдентификаторСертификата(СерийныйНомер, Издатель);
	
КонецФункции

// Выполнить в фоне
// 
// Параметры: 
//  ИмяПроцедуры - Строка
//  ПараметрыПроцедуры - Массив Из Произвольный
// 
// Возвращаемое значение: см. ДлительныеОперации.ВыполнитьВФоне
Функция ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Вызов API сервиса криптографии'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Если ПараметрыПроцедуры.Свойство("ВернутьРезультатКакАдресВоВременномХранилище")
		И ПараметрыПроцедуры.ВернутьРезультатКакАдресВоВременномХранилище Тогда
		ПараметрыВыполнения.ДополнительныйРезультат = Истина;
	КонецЕсли;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения); 

КонецФункции

Процедура ПодтвердитьВременныйПароль(ИдентификаторСертификата, ВременныйПароль) Экспорт

	Результат = ПолучитьСеансовыеКлючи(ИдентификаторСертификата, ВременныйПароль);

	// Запоминаем полученные маркеры безопасности.
	УстановитьПривилегированныйРежим(Истина);
	СохранитьМаркерыБезопасности(Результат);
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

// Имя настройки длительного маркер безопасности сертификата.
// 
// Параметры:
//  ИдентификаторСертификата - Строка
// 
// Возвращаемое значение:
//  Строка
Функция ИмяНастройкиДлительногоМаркерБезопасностиСертификата(ИдентификаторСертификата) Экспорт

	Возврат "ТехнологияСервиса.ЭлектроннаяПодписьВМоделиСервиса." + ИдентификаторСертификата;

КонецФункции

Процедура СохранитьМаркерыБезопасности(НовыеМаркерыБезопасности) Экспорт
	
	// Вызывающая функция должна установить привилегированный режим.
	
	// Маркер безопасности на текущий сеанс сохраняем в параметрах сеанса.
	МаркерыБезопасности = Новый Соответствие;
	Для Каждого ЭлементСоответствия Из ПараметрыСеанса.МаркерыБезопасности Цикл
		МаркерыБезопасности.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение);
	КонецЦикла;
	
	МаркерыБезопасности[НовыеМаркерыБезопасности.ИдентификаторСертификата] = НовыеМаркерыБезопасности.МаркерБезопасности;
	
	ПараметрыСеанса.МаркерыБезопасности = Новый ФиксированноеСоответствие(МаркерыБезопасности);		
	
	// Длительный маркер безопасности сохраняем в безопасное хранилище паролей.
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		ИмяНастройкиДлительногоМаркерБезопасностиСертификата(НовыеМаркерыБезопасности.ИдентификаторСертификата),
		НовыеМаркерыБезопасности.ДлительныйМаркерБезопасности,
		"ДлительныйМаркерБезопасности");
	
КонецПроцедуры

// Извлечь двоичные данные при необходимости
// 
// Параметры: 
//  Параметр - Массив из Строка
//           - ФиксированныйМассив из Строка
// 
// Возвращаемое значение: 
//  Массив из ДвоичныеДанные
Функция ИзвлечьДвоичныеДанныеПриНеобходимости(Параметр) Экспорт
	
	ИзвлеченныеДанные = Новый Массив;
	Если ТипЗнч(Параметр) = Тип("Массив") ИЛИ ТипЗнч(Параметр) = Тип("ФиксированныйМассив") Тогда
		Для Индекс = 0 По Параметр.ВГраница() Цикл
			ИзвлеченныеДанные.Добавить(ИзвлечьДвоичныеДанныеИзВременногоХранилищаПриНеобходимости(Параметр[Индекс]));
		КонецЦикла;
	Иначе
		ИзвлеченныеДанные = ИзвлечьДвоичныеДанныеИзВременногоХранилищаПриНеобходимости(Параметр);
	КонецЕсли;
	
	Возврат ИзвлеченныеДанные;
	
КонецФункции

// Двоичные данные в Base64 при необходимости
// 
// Параметры: 
//  Параметр - ДвоичныеДанные
// 
// Возвращаемое значение: 
//  Строка - Base64-строка
Функция ДвоичныеДанныеВBase64ПриНеобходимости(Знач Параметр) Экспорт
	Если ТипЗнч(Параметр) = Тип("ДвоичныеДанные") Тогда
		Возврат Base64Строка(Параметр);
	КонецЕсли;
	Возврат Параметр;
КонецФункции

// Вернуть результат как адрес во временном хранилище
// 
// Параметры: 
//  Параметр - Массив из Строка, Строка - параметр.
// 
// Возвращаемое значение: 
//  Булево
Функция ВернутьРезультатКакАдресВоВременномХранилище(Знач Параметр) Экспорт
	
	Если ТипЗнч(Параметр) = Тип("Массив") Тогда
		Параметр = Параметр[0];
	КонецЕсли;
	
	ВернутьКакАдрес = Ложь;
	Если ТипЗнч(Параметр) = Тип("Строка") И ЭтоАдресВременногоХранилища(Параметр) Тогда
		ВернутьКакАдрес = Истина;
	КонецЕсли;
	
	Возврат ВернутьКакАдрес;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
// 	Сертификат - Структура - обязательные поля:
// 	 * Идентификатор - Строка - идентификатор сертификата.
// 	 
// Возвращаемое значение:
// 	 Строка - идентификатор сертификата.
Функция Идентификатор(Знач Сертификат) Экспорт
	
	Возврат Сертификат.Идентификатор;

КонецФункции

Функция ПолучитьИменаСвойствДляВосстановления(Метод)
	
	СвойстваДляПреобразования = Новый Массив;
	Если СтрРазделить("crypto/hash", ",").Найти(Метод) <> Неопределено Тогда
		СвойстваДляПреобразования.Добавить("data");
	ИначеЕсли Метод = "crypto/certificate" Тогда
		СвойстваДляПреобразования.Добавить("public_key");
		СвойстваДляПреобразования.Добавить("thumbprint");
		СвойстваДляПреобразования.Добавить("serial_number");
	ИначеЕсли Метод = "crypto/crypto_message" Тогда
		СвойстваДляПреобразования.Добавить("certificates");
		СвойстваДляПреобразования.Добавить("serial_number");
	КонецЕсли;
	
	Возврат СвойстваДляПреобразования;
	
КонецФункции

// Параметры: 
//	Метод - Строка - Метод
//	ПараметрыМетода - Структура - Параметры метода:
//	 * certificate_id - Строка
//	 * password - Строка
//	Заголовки - Соответствие из КлючИЗначение
// 
// Возвращаемое значение: 
//	Произвольный
//
Функция ВыполнитьМетодКриптосервиса(Метод, ПараметрыМетода, Заголовки = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	АдресСервиса = Константы.АдресКриптосервиса.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыСоединения = МенеджерСервисаКриптографии.ПолучитьПараметрыСоединения(АдресСервиса);
	Соединение = ЭлектроннаяПодписьВМоделиСервиса.СоединениеССерверомИнтернета(ПараметрыСоединения);
	
	ЗагрузитьДанныеДляОбработкиНаСервер(Соединение, ПараметрыМетода);
	
	Результат = ВыполнитьМетодСервиса(Соединение, Метод, ПараметрыМетода, Заголовки);
	
	СкачатьРезультатОбработкиССервера(Соединение, Результат);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьДанныеДляОбработкиНаСервер(Соединение, ПараметрыМетода)
	
	Для Каждого Параметр Из ПараметрыМетода Цикл
		Если ТипЗнч(Параметр.Значение) = Тип("ДвоичныеДанные") Тогда
			ПараметрыМетода.Вставить(Параметр.Ключ, ОтправитьФайлНаСервер(Соединение, Параметр.Значение)); 
		ИначеЕсли ТипЗнч(Параметр.Значение) = Тип("Массив") Тогда
			Для Индекс = 0 По Параметр.Значение.ВГраница() Цикл
				Параметр.Значение[Индекс] = ОтправитьФайлНаСервер(Соединение, Параметр.Значение[Индекс]);				
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Параметры: 
//	Соединение - HTTPСоединение
//	Метод - Строка - Метод
//	ПараметрыМетода - см. ВыполнитьМетодКриптосервиса.ПараметрыМетода 
//  ДополнительныеЗаголовки - Соответствие из КлючИЗначение
// 
// Возвращаемое значение: 
//	Произвольный
//
Функция ВыполнитьМетодСервиса(Соединение, Метод, ПараметрыМетода, ДополнительныеЗаголовки = Неопределено)
		
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Если ЗначениеЗаполнено(ДополнительныеЗаголовки) Тогда 
		Для Каждого Заголовок Из ДополнительныеЗаголовки Цикл 
			Заголовки.Вставить(Заголовок.Ключ, Заголовок.Значение);
		КонецЦикла;
	КонецЕсли;
		
	ПараметрыМетода.Вставить("client", НаименованиеКлиента());
	Запрос = Новый HTTPЗапрос(АдресРесурса(Метод), Заголовки);
	Запрос.УстановитьТелоИзСтроки(
		ЭлектроннаяПодписьВМоделиСервиса.СтруктураВJSON(ПараметрыМетода),,
		ИспользованиеByteOrderMark.НеИспользовать);
	
	Ответ = ВызватьHTTPМетод(Соединение, "POST", Запрос);
	
	Если Ответ.КодСостояния <> 200 И Ответ.КодСостояния <> 400 Тогда
		ЗаписатьОшибочныйОтветОтСервисаВЖурналРегистрации(Запрос.АдресРесурса, Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
		
	ПараметрыПреобразования = Новый Структура;
	Если Ответ.КодСостояния = 200 Тогда
		ПараметрыПреобразования.Вставить("ИменаСвойствДляВосстановления", ПолучитьИменаСвойствДляВосстановления(Метод));
	КонецЕсли;
			
	Результат = ЭлектроннаяПодписьВМоделиСервиса.JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку(), ПараметрыПреобразования);
	
	Если Результат.status = "success" Тогда		
		Возврат Результат.data;
	ИначеЕсли Результат.status = "fail" Тогда
		ВызватьИсключение(Результат.data);
	КонецЕсли;

КонецФункции

Процедура СкачатьРезультатОбработкиССервера(Соединение, Параметры)
	
	Если ТипЗнч(Параметры) = Тип("Массив") Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл
			Если ТипЗнч(Параметры[Индекс]) = Тип("Строка") И СтрНайти(Параметры[Индекс], "out_") Тогда
				Параметры[Индекс] = ПолучитьФайлССервера(Соединение, Параметры[Индекс]);
			Иначе
				СкачатьРезультатОбработкиССервера(Соединение, Параметры[Индекс]);
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры) = Тип("Структура") Тогда
		Для Каждого Параметр Из Параметры Цикл
			Если ТипЗнч(Параметр.Значение) = Тип("Строка") И СтрНайти(Параметр.Значение, "out_") Тогда
				Параметры.Вставить(Параметр.Ключ, ПолучитьФайлССервера(Соединение, Параметр.Значение));
			Иначе
				СкачатьРезультатОбработкиССервера(Соединение, Параметр.Значение);
			КонецЕсли;
		КонецЦикла; 
	ИначеЕсли ТипЗнч(Параметры) = Тип("Строка") И СтрНайти(Параметры, "out_") Тогда
		Параметры = ПолучитьФайлССервера(Соединение, Параметры);
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗаписатьОшибочныйОтветОтСервисаВЖурналРегистрации(АдресРесурса, ОтветСервера)
	
	// @skip-check module-nstr-camelcase - ошибка проверки
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Электронная подпись в модели сервиса.Сервис криптографии.Выполнение запроса'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Ошибка,,,
		КомментарийПоИсключению(ОтветСервера, Новый Структура("АдресРесурса", АдресРесурса)));	 
	
	ЭлектроннаяПодписьВМоделиСервиса.ВызватьСтандартноеИсключение();
	
КонецПроцедуры

Функция ОтправитьФайлНаСервер(Соединение, Файл)
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/octet-stream");
	Запрос = Новый HTTPЗапрос("/upload", Заголовки);
	Запрос.УстановитьТелоИзДвоичныхДанных(Файл);
	
	Ответ = ВызватьHTTPМетод(Соединение, "PUT", Запрос);
	
	Если Ответ.КодСостояния <> 201 Тогда
		ЗаписатьОшибочныйОтветОтСервисаВЖурналРегистрации(Запрос.АдресРесурса, Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияБТС.ЗаголовокHTTP(Ответ, "X-New-Name");

	Возврат ИмяФайла;
	
КонецФункции

Функция ПолучитьФайлССервера(Соединение, ИмяФайла)
		
	Заголовки = Новый Соответствие;
	Запрос = Новый HTTPЗапрос("/download/" + ИмяФайла, Заголовки);
	
	Ответ = ВызватьHTTPМетод(Соединение, "GET", Запрос);
	
	Если Ответ.КодСостояния <> 200 Тогда
		ЗаписатьОшибочныйОтветОтСервисаВЖурналРегистрации(Запрос.АдресРесурса, Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
	
	Файл = Ответ.ПолучитьТелоКакДвоичныеДанные();

	Возврат Файл;
	
КонецФункции

Функция ВызватьHTTPМетод(Соединение, МетодHTTP, Запрос)
	
	Попытка		
		Ответ = Соединение.ВызватьHTTPМетод(МетодHTTP, Запрос);
	Исключение
		// @skip-check module-nstr-camelcase - ошибка проверки
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Сервис криптографии.Выполнение запроса'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			КомментарийПоИсключению(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Новый Структура("АдресРесурса", Запрос.АдресРесурса)));	 
		
		ЭлектроннаяПодписьВМоделиСервиса.ВызватьСтандартноеИсключение();
	КонецПопытки;

	Возврат Ответ;
	
КонецФункции

Функция ВерсияПрограммногоИнтерфейса()
	
	Возврат "v3.1";
	
КонецФункции

Функция АдресРесурса(Метод)
	
	Возврат СтрШаблон("/api/%1/%2", ВерсияПрограммногоИнтерфейса(), Метод);
	
КонецФункции

Функция НаименованиеКлиента()
	
	Возврат СтрШаблон("%1 (%2):%3", Метаданные.Имя, Метаданные.Версия, Формат(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧГ="));
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытия, ИнформацияОбОшибке, Параметры) Экспорт
	
	Комментарий = КомментарийПоИсключению(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке), Параметры);
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, Комментарий);
	
КонецПроцедуры

Функция КомментарийПоИсключению(ПредставлениеОшибки, Параметры)
	
	ШаблонЗаписи = 
	"Параметры:
	|%1
	|
	|ПредставлениеОшибки:
	|%2";
	
	Возврат СтрШаблон(
		ШаблонЗаписи, 
		ЭлектроннаяПодписьВМоделиСервиса.СтруктураВJSON(Параметры, Новый Структура("ЗаменятьДвоичныеДанные", Истина)),
		СокрЛП(ПредставлениеОшибки));
		
КонецФункции

Процедура УстановитьМаркерыБезопасности(МаркерыБезопасности)
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСеанса.МаркерыБезопасности = МаркерыБезопасности;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ПолучитьСеансовыеКлючи(ИдентификаторСертификата, ВременныйПароль, ИдентификаторСессии = Неопределено)

	Попытка
		ПараметрыМетода = Новый Структура;
		ПараметрыМетода.Вставить("certificate_id", ИдентификаторСертификата);
		ПараметрыМетода.Вставить("password",       ВременныйПароль);
		
		Если ЗначениеЗаполнено(ИдентификаторСессии) Тогда 
			Заголовки = Новый Соответствие;
			Заголовки.Вставить("X-Auth-Session", ИдентификаторСессии);
		Иначе
			Заголовки = Неопределено;
		КонецЕсли;
		
		МаркерыБезопасности = ВыполнитьМетодКриптосервиса("crypto/all_security_tokens", ПараметрыМетода, Заголовки);
		
		Результат = Новый Структура;
		Результат.Вставить("МаркерБезопасности",           МаркерыБезопасности.security_token);
		Результат.Вставить("ДлительныйМаркерБезопасности", МаркерыБезопасности.long_security_token);
		Результат.Вставить("ИдентификаторСертификата",     ИдентификаторСертификата);						
		
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПараметрыМетода.password = ?(СтрДлина(ПараметрыМетода.password) = 6, 999999, ПараметрыМетода.password);
		ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытияАутентификация(), ИнформацияОбОшибке, ПараметрыМетода);
		
		// Преобразуем текст исключения в код ошибки.
		ТекстИсключения = ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке);
		Если СтрНайти(ТекстИсключения, "Invalid password") Тогда
			ТекстОшибки = "УказанНеверныйПароль";
		ИначеЕсли СтрНайти(ТекстИсключения, "MaxAttemptsInputPasswordExceededError") Тогда
			ТекстОшибки = "ПревышенЛимитПопытокВводаПароля";
		ИначеЕсли СтрНайти(ТекстИсключения, "PasswordExpiredError") Тогда
			ТекстОшибки = "СрокДействияПароляИстек";
		Иначе 
			ТекстОшибки = ТекстИсключения;
		КонецЕсли;		
		
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;

	Возврат Результат;

КонецФункции

Функция ИзвлечьДвоичныеДанныеИзВременногоХранилищаПриНеобходимости(Параметр)
	
	Если ТипЗнч(Параметр) = Тип("Строка") И ЭтоАдресВременногоХранилища(Параметр) Тогда
		Возврат ПолучитьИзВременногоХранилища(Параметр);
	Иначе
		Возврат Параметр;
	КонецЕсли;
	
КонецФункции

// Выполняет сортировку идентификаторов сертификатов по дате действия и принадлежности к базе
//
// Параметры:
//	ИдентификаторыСертификатов - Массив Из Строка - содержит идентификаторы сертификатов.
//
// Возвращаемое значение:
//  Массив Из Строка
//
Функция ОпределитьПорядокСертификатов(ИдентификаторыСертификатов) Экспорт
	
	Результат = Новый Массив;
	
	Если ИдентификаторыСертификатов.Количество() < 2 Тогда
		Возврат ИдентификаторыСертификатов;
	КонецЕсли;
	
	ТаблицаИдентификаторов = Новый ТаблицаЗначений;
	ТаблицаИдентификаторов.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(40))); 
	
	Для Каждого СтрокаМассива Из ИдентификаторыСертификатов Цикл
		НоваяСтрока = ТаблицаИдентификаторов.Добавить();
		НоваяСтрока.Идентификатор = СтрокаМассива;
	КонецЦикла;	
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаИдентификаторов.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ВсеИдентификаторы
	|ИЗ
	|	&ТаблицаИдентификаторов КАК ТаблицаИдентификаторов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВсеИдентификаторы.Идентификатор КАК Идентификатор,
	|	ВЫБОР
	|		КОГДА НЕ ХранилищеСертификатов.ДатаНачала ЕСТЬ NULL
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Приоритет,
	|	ХранилищеСертификатов.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	ВсеИдентификаторы КАК ВсеИдентификаторы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ХранилищеСертификатов КАК ХранилищеСертификатов
	|		ПО ВсеИдентификаторы.Идентификатор = ХранилищеСертификатов.Идентификатор
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет УБЫВ,
	|	ДатаОкончания УБЫВ";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаИдентификаторов", ТаблицаИдентификаторов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		Если Результат.Найти(Выборка.Идентификатор) = Неопределено Тогда
			Результат.Добавить(Выборка.Идентификатор);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#Область ИменаСобытий

Функция ИмяСобытияАутентификация()
	
	// @skip-check module-nstr-camelcase - ошибка проверки
	Возврат НСтр("ru = 'Сервис криптографии.Аутентификация'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#КонецОбласти