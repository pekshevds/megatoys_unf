#Область ПрограммныйИнтерфейс

// Конструктор дополнительных параметров
//
// Возвращаемое значение:
//  Структура - позволяет задать дополнительные параметры:
//    * Заголовки - Соответствие
//    * Таймаут - Число - время ожидания осуществляемого соединения и операций, в секундах.
//                Значение по умолчанию - 30 сек.
//    * Данные - Строка, ДвоичныеДанные - произвольные данные, которые необходимо отправить в запросе.
//    * Json - Структура, Соответствие - Данные, которые должны быть сериализованы в json и помещены в тело запроса.
//    * МаксимальноеКоличествоПовторов - Число - количество повторных попыток соединения/отправки запроса.
//        Между попытками выполняется задержка.
//        Если код состояния один из 413, 429, 503 и в ответе есть заголовок Retry-After,
//        то время задержки формируется из значения этого заголовка, иначе задержка берется равной Таймаут.
//        Значение по умолчанию: 0 - повторы не выполняются.
//
Функция НовыеПараметры() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Заголовки", Новый Соответствие);
	Результат.Вставить("Таймаут", 30);
	Результат.Вставить("Данные", Неопределено);
	Результат.Вставить("Json", Неопределено);
	Результат.Вставить("МаксимальноеКоличествоПовторов", 0);
	
	Возврат Результат;
	
КонецФункции

// Пакет ответа результата вызова метода HTTP.
//
// Возвращаемое значение:
//   Структура:
//   * Метод - Строка - имя HTTP-метода запроса
//   * URL - Строка - итоговый URL, по которому был выполнен запрос.
//   * КодСостояния - Число - Код состояния ответа..
//   * Заголовки - Соответствие - Заголовки ответа.
//   * Тело - ДвоичныеДанные - Тело ответа.
//   * Кодировка - Строка - код кодировки ответа.
//   * ВремяВыполнения - Число - время выполнения запроса в миллисекундах.
//   * Ошибки - Массив Из Строка - Список ошибок возникших в ходе выполнения запроса.
//
Функция НовыйОтвет() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Метод", "GET");
	Результат.Вставить("URL", "");
	Результат.Вставить("КодСостояния", 600); // Ошибка запроса к серверу (>500)
	Результат.Вставить("Заголовки", Новый Массив);
	Результат.Вставить("Тело", Base64Значение(""));
	Результат.Вставить("Кодировка", "utf-8");
	Результат.Вставить("ВремяВыполнения", Неопределено);
	Результат.Вставить("Ошибки", Новый Массив);
	
	Возврат Результат;
	
КонецФункции

// Отправляет данные на указанный адрес для обработки с использованием указанного HTTP-метода.
//
// Параметры:
//   Метод - Строка - имя HTTP-метода для запроса.
//   URL - Строка - URL ресурса, к которому будет отправлен запрос.
//   ДополнительныеПараметры - См. РаспознаваниеДокументовHTTP.НовыеПараметры
//
// Возвращаемое значение:
//   См. РаспознаваниеДокументовHTTP.НовыйОтвет
//
Функция ВызватьМетод(Метод, URL, ДополнительныеПараметры = Неопределено) Экспорт
	
	Параметры = НовыеПараметры();
	ЗаполнитьЗначенияСвойств(Параметры, ДополнительныеПараметры);
	
	КомандаСервиса = НоваяКомандаСервиса(Параметры);
	КомандаСервиса.URL = URL;
	КомандаСервиса.Метод = Метод;
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

// Отправляет GET запрос
//
// Параметры:
//   URL - Строка - URL ресурса, к которому будет отправлен запрос.
//   ПараметрыЗапроса - Структура, Соответствие - параметры, которые будут отправлены в URL (часть после ?).
//   ДополнительныеПараметры - См. РаспознаваниеДокументовHTTP.НовыеПараметры
//
// Возвращаемое значение:
//   См. РаспознаваниеДокументовHTTP.НовыйОтвет.
//
Функция Get(URL, ПараметрыЗапроса = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыЗапроса) И СтрНайти(URL, "?") Тогда
		ВызватьИсключение НСтр("ru = 'Не реализовано. Поддерживается только URL без ?'");
	КонецЕсли;
	
	Возврат ВызватьМетод("GET", URL + ПараметрыЗапросаСтрокой(ПараметрыЗапроса), ДополнительныеПараметры);
	
КонецФункции

// Отправляет POST запрос
//
// Параметры:
//   URL - Строка - URL ресурса, к которому будет отправлен запрос.
//   Данные - Структура, Соответствие, Строка, ДвоичныеДанные - см. описание ДополнительныеПараметры.Данные.
//   ДополнительныеПараметры - См. РаспознаваниеДокументовHTTP.НовыеПараметры
//
// Возвращаемое значение:
//   См. РаспознаваниеДокументовHTTP.НовыйОтвет.
//
Функция Post(URL, Данные = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Данные) = Тип("Структура") Или ТипЗнч(Данные) = Тип("Соответствие") Тогда
		ВызватьИсключение НСтр("ru = 'Не реализовано'");
	КонецЕсли;
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		Данные = ПолучитьДвоичныеДанныеИзСтроки(Данные);
	КонецЕсли;
	
	Параметры = НовыеПараметры();
	ЗаполнитьЗначенияСвойств(Параметры, ДополнительныеПараметры);
	
	Если ЗначениеЗаполнено(Данные) Тогда
		Параметры.Данные = Данные;
	КонецЕсли;
	
	Возврат ВызватьМетод("POST", URL, Параметры);
	
КонецФункции

// Отправляет PUT запрос
//
// Параметры:
//   URL - Строка - URL ресурса, к которому будет отправлен запрос.
//   Данные - Структура, Соответствие, Строка, ДвоичныеДанные - см. описание ДополнительныеПараметры.Данные.
//   ДополнительныеПараметры - См. РаспознаваниеДокументовHTTP.НовыеПараметры
//
// Возвращаемое значение:
//   См. РаспознаваниеДокументовHTTP.НовыйОтвет.
//
Функция Put(URL, Данные = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Данные) = Тип("Структура") Или ТипЗнч(Данные) = Тип("Соответствие") Тогда
		ВызватьИсключение НСтр("ru = 'Не реализовано'");
	КонецЕсли;
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		Данные = ПолучитьДвоичныеДанныеИзСтроки(Данные);
	КонецЕсли;
	
	Параметры = НовыеПараметры();
	ЗаполнитьЗначенияСвойств(Параметры, ДополнительныеПараметры);
	
	Если ЗначениеЗаполнено(Данные) Тогда
		Параметры.Данные = Данные;
	КонецЕсли;
	
	Возврат ВызватьМетод("PUT", URL, ДополнительныеПараметры);
	
КонецФункции

// Отправляет DELETE запрос
//
// Параметры:
//   URL - Строка - URL ресурса, к которому будет отправлен запрос.
//   Данные - Структура, Соответствие, Строка, ДвоичныеДанные - см. описание ДополнительныеПараметры.Данные.
//   ДополнительныеПараметры - См. РаспознаваниеДокументовHTTP.НовыеПараметры
//
// Возвращаемое значение:
//   См. РаспознаваниеДокументовHTTP.НовыйОтвет.
//
Функция Delete(URL, Данные = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Данные) = Тип("Структура") Или ТипЗнч(Данные) = Тип("Соответствие") Тогда
		ВызватьИсключение НСтр("ru = 'Не реализовано'");
	КонецЕсли;
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		Данные = ПолучитьДвоичныеДанныеИзСтроки(Данные);
	КонецЕсли;
	
	Параметры = НовыеПараметры();
	ЗаполнитьЗначенияСвойств(Параметры, ДополнительныеПараметры);
	
	Если ЗначениеЗаполнено(Данные) Тогда
		Параметры.Данные = Данные;
	КонецЕсли;
	
	Возврат ВызватьМетод("DELETE", URL, ДополнительныеПараметры);
	
КонецФункции

// Возвращает ответ сервера в виде текста.
//
// Параметры:
//   Ответ - РаспознаваниеДокументовHTTP.НовыйОтвет.
//   Кодировка - Строка, КодировкаТекста - определяет кодировку текста.
//     Если значение не задано, то кодировка извлекается из Ответ.Кодировка.
//
// Возвращаемое значение:
//   Строка - ответ сервера в виде текста.
//
Функция КакТекст(Ответ, Кодировка = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = Ответ.Кодировка;
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(РаспаковатьОтвет(Ответ).ОткрытьПотокДляЧтения(), Кодировка);
	Текст = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Если Текст = Неопределено Тогда
		Текст = "";
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

// Возвращает ответ сервера в виде текста.
//
// Параметры:
//   Ответ - РаспознаваниеДокументовHTTP.НовыйОтвет.
//
// Возвращаемое значение:
//   ДвоичныеДанные - ответ сервера в виде двоичных данных.
//
Функция КакДвоичныеДанные(Ответ) Экспорт
	
	Возврат РаспаковатьОтвет(Ответ);
	
КонецФункции

// Возвращает ответ сервера в виде десериализованного значения JSON.
//
// Параметры:
//   Ответ - РаспознаваниеДокументовHTTP.НовыйОтвет.
//
// Возвращаемое значение:
//   Соответствие - ответ сервера в виде десериализованного значения JSON.
//
Функция КакJson(Ответ) Экспорт
	
	Попытка
		Возврат JsonВОбъект(РаспаковатьОтвет(Ответ), Ответ.Кодировка);
	Исключение
		ВызватьИсключение КакИсключение(Ответ, СтрШаблон(
			НСтр("ru = 'Ошибка при десериализации ответа сервера:
			           |%1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		));
	КонецПопытки;
	
КонецФункции

// Возвращает ответ сервера в виде текста предназначенного для использования в ВызватьИсключение.
//
// Параметры:
//   Ответ - РаспознаваниеДокументовHTTP.НовыйОтвет.
//   ТекстДляПользователя - Строка - Текст пояснения причины для пользователя.
//
// Возвращаемое значение:
//   Строка - ответ сервера в виде текста исключения.
//
Функция КакИсключение(Ответ, Знач ТекстДляПользователя = Неопределено) Экспорт
	
	ТекстИсключения = СтрШаблон(
		НСтр("ru = 'При выполнении запроса произошла ошибка:
		           |%1 %2
		           |%3
		           |Ответ сервера:
		           |%4'"),
		Ответ.Метод,
		Ответ.URL,
		ПредставлениеКодаСостоянияHTTP(Ответ.КодСостояния),
		ФрагментТекста(КакТекст(Ответ))
	);
	
	Если Ответ.Ошибки.Количество() Тогда
		ТекстИсключения = ТекстИсключения + Символы.ПС + Символы.ПС
			+ СтрСоединить(Ответ.Ошибки, Символы.ПС + Символы.ПС);
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстДляПользователя) Тогда
		ТекстИсключения = ТекстДляПользователя + Символы.ПС + Символы.ПС + ТекстИсключения;
		
		ЗаписьЖурналаРегистрации( // Сохраняем стек в ЖР
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстИсключения
		);
		
		Возврат ТекстДляПользователя; // Скрываем стек
	КонецЕсли;
	
	Возврат ТекстИсключения; // Уточнений нет, показываем пользователю как есть
	
КонецФункции

// Структура именованных кодов состояний HTTP.
//
// Возвращаемое значение:
//   Структура - именованные коды состояний HTTP.
//
Функция КодыСостоянияHTTP() Экспорт
	
	Возврат РаспознаваниеДокументовHTTPПовтИсп.КодыСостоянияHTTP();
	
КонецФункции

// Возвращает текстовое представление переданного кода состояния HTTP.
//
// Параметры:
//   КодСостояния - Число - код состояния HTTP, для которого нужно получить текстовое представление.
//
// Возвращаемое значение:
//   Строка - текстовое представление кода состояния HTTP.
//
Функция ПредставлениеКодаСостоянияHTTP(КодСостояния) Экспорт
	
	Возврат РаспознаваниеДокументовHTTPПовтИсп.ПредставлениеКодаСостоянияHTTP(КодСостояния);
	
КонецФункции

// Преобразование Объекта в JSON.
//
// Параметры:
//   Объект - Произвольный - данные, которые необходимо преобразовать в JSON.
//
// Возвращаемое значение:
//   Строка - объект в формате JSON.
//
Функция ОбъектВJson(Объект) Экспорт
	
	НастройкиСериализации = Новый НастройкиСериализацииJSON;
	НастройкиСериализации.ФорматСериализацииДаты =  ФорматДатыJSON.ISO;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДата;
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	
	ЗаписатьJSON(ЗаписьJSON, Объект, НастройкиСериализации);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

// Преобразование JSON в Объект.
//
// Параметры:
//   Json - Поток, ДвоичныеДанные, Строка - данные в формате JSON.
//   Кодировка - Строка - кодировка текста JSON. Значение по умолчанию - utf-8.
//
// Возвращаемое значение:
//   Произвольный - значение, десериализованное из JSON.
//
Функция JsonВОбъект(Json, Кодировка = "utf-8") Экспорт
	
	ПрочитатьВСоответствие = Истина;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	Если ТипЗнч(Json) = Тип("ДвоичныеДанные") Тогда
		ЧтениеJSON.ОткрытьПоток(Json.ОткрытьПотокДляЧтения(), Кодировка);
	ИначеЕсли ТипЗнч(Json) = Тип("Строка") Тогда
		ЧтениеJSON.УстановитьСтроку(Json);
	Иначе
		ЧтениеJSON.ОткрытьПоток(Json, Кодировка);
	КонецЕсли;
	Объект = ПрочитатьJSON(
		ЧтениеJSON,
		ПрочитатьВСоответствие
	);
	ЧтениеJSON.Закрыть();
	
	Возврат Объект;
	
КонецФункции

// Приостанавливает работу программы на указанное количество секунд.
//
Процедура Приостановить(Секунд) Экспорт
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	ФайловаяСистема.ЗапуститьПрограмму("timeout " + Секунд, ПараметрыЗапускаПрограммы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РаспаковатьОтвет(Ответ)
	
	Возврат Ответ.Тело;
	
КонецФункции

Функция ФрагментТекста(Текст, МаксимальнаяДлинаТекста = 1000)
	
	Если СтрДлина(Текст) <= МаксимальнаяДлинаТекста Тогда
		ФрагментТекста = Текст;
	Иначе
		ПоловинаМаксимальнойДлиныТекста = МаксимальнаяДлинаТекста / 2;
		ФрагментТекста = Лев(Текст, ПоловинаМаксимальнойДлиныТекста);
		ФрагментТекста = ФрагментТекста + Символы.ПС + "..." + Символы.ПС;
		ФрагментТекста = ФрагментТекста + Прав(Текст, ПоловинаМаксимальнойДлиныТекста);
	КонецЕсли;
	
	Если НайтиНедопустимыеСимволыXML(ФрагментТекста) Тогда
		ФрагментТекста = "<... unprinted data ...>"
	КонецЕсли;
	
	Возврат МаскированныйРезультат(ФрагментТекста);
	
КонецФункции

Функция МаскированныйРезультат(Данные) Экспорт
	
	Данные = ВырезатьМаскированныйФрагмент(Данные, """login""");
	Данные = ВырезатьМаскированныйФрагмент(Данные, """password""");
	Данные = ВырезатьМаскированныйФрагмент(Данные, """client_id""");
	Данные = ВырезатьМаскированныйФрагмент(Данные, """ticket""");
	
	Возврат Данные;
	
КонецФункции

Функция ВырезатьМаскированныйФрагмент(Данные, Фрагмент)
	
	НачальнаяПозиция = СтрНайти(Данные, Фрагмент); // >>"<<key": "value"
	
	Если НачальнаяПозиция > 0 Тогда 
		
		НачальнаяПозиция = СтрНайти(Данные, """", , НачальнаяПозиция + 1); // "key>>"<<: "value"
		НачальнаяПозиция = СтрНайти(Данные, """", , НачальнаяПозиция + 1); // "key": >>"<<value"
		
		НовыеДанные = Лев(Данные, НачальнаяПозиция) + "********";
		
		КонечнаяПозиция = СтрНайти(Данные, """", , НачальнаяПозиция + 1); // "key": "value>>"<<
		
		// Частный случай поиска экранированных кавычек, что в json соответствует обычной кавычке.
		Пока Сред(Данные, КонечнаяПозиция - 1, 1) = "\" Цикл // "key": "value1>>\<<"value2"
			КонечнаяПозиция = СтрНайти(Данные, """", , КонечнаяПозиция + 1); // "key": "value1\"value2>>"<<
		КонецЦикла;
		
		Если КонечнаяПозиция > 0 Тогда
			НовыеДанные = НовыеДанные + Сред(Данные, КонечнаяПозиция);
		КонецЕсли;
		
		Данные = НовыеДанные;
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция НоваяКомандаСервиса(Параметры)
	
	Результат = Новый Структура;
	Результат.Вставить("URL", "");
	Результат.Вставить("Метод", "GET");
	Результат.Вставить("НачалоВыполнения", 0);
	Результат.Вставить("ОсталосьПопыток", Параметры.МаксимальноеКоличествоПовторов);
	Результат.Вставить("Параметры", Параметры);
	Результат.Вставить("Ошибки", Новый Массив);
	
	Возврат Результат;
	
КонецФункции

Функция ВыполнитьКомандуСервиса(КомандаСервиса)
	
	Если Не ЗначениеЗаполнено(КомандаСервиса.НачалоВыполнения) Тогда
		КомандаСервиса.НачалоВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонецЕсли;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(КомандаСервиса.URL);
	
	ПортОбычногоСоединения = 80;
	ПортЗащищенногоСоединения = 443;
	
	Если СтруктураURI.Порт = Неопределено Тогда
		Если СтруктураURI.Схема = "https" Тогда
			СтруктураURI.Порт = ПортЗащищенногоСоединения;
		Иначе
			СтруктураURI.Порт = ПортОбычногоСоединения;
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураURI.Порт = ПортЗащищенногоСоединения Тогда
		ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(, Новый СертификатыУдостоверяющихЦентровОС);
	Иначе
		ЗащищенноеСоединение = Неопределено;
	КонецЕсли;
	
	HTTPСоединение = Новый HTTPСоединение(
		СтруктураURI.Хост,
		СтруктураURI.Порт, , , ,
		КомандаСервиса.Параметры.Таймаут,
		ЗащищенноеСоединение
	);
	HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	
	Если ЗначениеЗаполнено(КомандаСервиса.Параметры.Данные) Или ЗначениеЗаполнено(КомандаСервиса.Параметры.Json) Тогда
		Если ТипЗнч(КомандаСервиса.Параметры.Данные) = Тип("ДвоичныеДанные") Тогда
			HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(КомандаСервиса.Параметры.Данные);
			Если КомандаСервиса.Параметры.Заголовки.Получить("Content-Type") = Неопределено Тогда
				КомандаСервиса.Параметры.Заголовки.Вставить("Content-Type", "application/octet-stream");
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(КомандаСервиса.Параметры.Json) Тогда
				КомандаСервиса.Параметры.Данные = ОбъектВJson(КомандаСервиса.Параметры.Json);
				КомандаСервиса.Параметры.Заголовки.Вставить("Content-Type", "application/json");
				КомандаСервиса.Параметры.Заголовки.Вставить("Charset", "utf-8");
			КонецЕсли;
			
			HTTPЗапрос.УстановитьТелоИзСтроки(
				КомандаСервиса.Параметры.Данные,
				КодировкаТекста.UTF8,
				ИспользованиеByteOrderMark.НеИспользовать
			);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из КомандаСервиса.Параметры.Заголовки Цикл
		HTTPЗапрос.Заголовки.Вставить(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);
	КонецЦикла;
	
	Ответ = НовыйОтвет();
	Ответ.Метод = КомандаСервиса.Метод;
	Ответ.URL = КомандаСервиса.URL;
	
	Попытка
		Результат = HTTPСоединение.ВызватьHTTPМетод(КомандаСервиса.Метод, HTTPЗапрос);
	Исключение
		// Запрос не дошел до HTTP-Сервера
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'При выполнении запроса произошла сетевая ошибка:
			           |%1 %2
			           |Описание ошибки:
			           |%3'"),
			КомандаСервиса.Метод,
			КомандаСервиса.URL,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		
		КомандаСервиса.Ошибки.Добавить(ТекстОшибки);
		
		Если КомандаСервиса.ОсталосьПопыток >= 0 Тогда
			Приостановить(КомандаСервиса.Параметры.Таймаут);
			КомандаСервиса.ОсталосьПопыток = КомандаСервиса.ОсталосьПопыток - 1;
			Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
		КонецЕсли;
		
		Ответ.Ошибки = КомандаСервиса.Ошибки;
		
		Возврат Ответ;
		
	КонецПопытки;
	
	Если Результат.КодСостояния >= КодыСостоянияHTTP().ВнутренняяОшибкаСервера_500 Тогда
		
		ТекстОшибки = КакИсключение(
			Ответ,
			СтрШаблон(НСтр("ru = 'Осталось попыток: %1'"), КомандаСервиса.ОсталосьПопыток)
		);
		
		КомандаСервиса.Ошибки.Добавить(ТекстОшибки);
		
		Если КомандаСервиса.ОсталосьПопыток >= 0 Тогда
			Приостановить(КомандаСервиса.Параметры.Таймаут);
			КомандаСервиса.ОсталосьПопыток = КомандаСервиса.ОсталосьПопыток - 1;
			Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
		КонецЕсли;
		
		Ответ.Ошибки = КомандаСервиса.Ошибки;
		
		Возврат Ответ;
		
	КонецЕсли;
	
	Ответ.КодСостояния = Результат.КодСостояния;
	Ответ.Заголовки = Результат.Заголовки;
	Ответ.Тело = Результат.ПолучитьТелоКакДвоичныеДанные();
	
	МиллисекундВСекунде = 1000;
	Длительность = (ТекущаяУниверсальнаяДатаВМиллисекундах() - КомандаСервиса.НачалоВыполнения) / МиллисекундВСекунде;
	Ответ.ВремяВыполнения = Длительность;
	
	Возврат Ответ;
	
КонецФункции

Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'РаспознаваниеДокументов.HTTP'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ПараметрыЗапросаСтрокой(ПараметрыЗапроса)
	
	Если ПараметрыЗапроса = Неопределено Или ПараметрыЗапроса.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Результат = Новый Массив;
	
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		Результат.Добавить(Параметр.Ключ + "=" + Параметр.Значение);
	КонецЦикла;
	
	Возврат "?" + СтрСоединить(Результат, "&");
	
КонецФункции

#КонецОбласти