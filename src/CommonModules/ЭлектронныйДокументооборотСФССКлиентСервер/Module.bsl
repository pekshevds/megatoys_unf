#Область ПрограммныйИнтерфейс

// Возвращает параметры для отправки сообщения в СЭДО.
// Реквизиты РегистрационныйНомерФСС и СвойстваДляОбмена заполняются автоматически при вызове с сервера,
// при вызове с клиента эти реквизиты нужно заполнять самостоятельно.
//
// Параметры:
//   ТипСообщения                 - Число     - тип сообщения СЭДО из спецификации типов документов,
//   СодержимоеИлиАдресСообщения  - Строка    - текст выгрузки сообщения СЭДО по спецификации типов документов или
//                                - Строка    - адрес во временном хранилище, по которому содержится строка или двоичные
//                                              данные в кодировке utf-8 текста выгрузки сообщения СЭДО по спецификации
//                                              типов документов
//   Организация                  - СправочникСсылка.Организации - организация отправитель,
//   ОписаниеОшибки               - Строка    - шаблон текста сообщения, возвращаемого в ключе "ОписаниеОшибки"
//                                              результата оповещения обратного вызова при неудаче отправки,
//                                              с подстановкой текста ошибки вместо %1, например:
//                                              НСтр("ru = 'Не удалось подписать организацию на оповещения об изменении состояний ЭЛН сотрудников.'") + Символы.ПС + "%1",
//   РегистрационныйНомерФСС      - Строка    - регистрационный номер ФСС (дополнительный код ФСС в случае филиала),
//                                              при пустом значении подставляется из организации если метод вызывается с сервера.
//   ТипВзаимодействия            - Число     - Для отпрвки от имени страхователя передается значение 2, для отправки МЧД 3.
//                                              Если значение не заполнено, то тип определяется по типу сообщения.
//   СвойстваДляОбмена            - Структура - при значении Неопределено заполняется автоматически при вызове с сервера, при типе
//                                              взаимодействия 3 (МЧД) можно передать структуру с реквизитами
//                                              "ОГРН", "ИНН", "КПП", "СНИЛС"
// Возвращаемое значение:
//   Структура - переданные параметры отправки сообщения (незаполненные могут вычисляться) для передачи в процедуру
//               "ЭлектронныйДокументооборотСФССКлиент.ОтправитьСообщениеСЭДО", параметр "ПараметрыСообщения".
//
Функция ПараметрыОтправитьСообщениеСЭДО(
		ТипСообщения = 0,
		СодержимоеИлиАдресСообщения = "",
		Организация = Неопределено,
		ОписаниеОшибки = "",
		РегистрационныйНомерФСС = "",
		ТипВзаимодействия = Неопределено,
		СвойстваДляОбмена = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипСообщения", 					ТипСообщения);
	Результат.Вставить("СодержимоеИлиАдресСообщения", 	СодержимоеИлиАдресСообщения);
	Результат.Вставить("Организация", 					Организация);
	Результат.Вставить("ОписаниеОшибки", 				ОписаниеОшибки);
	Результат.Вставить("РегистрационныйНомерФСС", 		РегистрационныйНомерФСС);
	Результат.Вставить("ТипВзаимодействия", 			ТипВзаимодействия);
	Результат.Вставить("СвойстваДляОбмена", 			СвойстваДляОбмена);
	
	Если НЕ ЗначениеЗаполнено(Результат.РегистрационныйНомерФСС) И Результат.СвойстваДляОбмена <> Неопределено
		И Результат.СвойстваДляОбмена.Свойство("РегистрационныйНомерФСС") Тогда
		
		Результат.РегистрационныйНомерФСС = Результат.СвойстваДляОбмена.РегистрационныйНомерФСС;
	КонецЕсли;
	
	Если Результат.ТипВзаимодействия = Неопределено Тогда
		Результат.ТипВзаимодействия = ДокументооборотСФССКлиентСервер.ТипВзаимодействияСЭДО(ТипСообщения);
	КонецЕсли;
	
	ЭтоТипВзаимодействияОрганизацияСЭДО = (Результат.ТипВзаимодействия =
		ДокументооборотСФССКлиентСервер.ТипВзаимодействияОрганизацияСЭДО());
		
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ЗначениеЗаполнено(Результат.Организация) И (НЕ ЗначениеЗаполнено(Результат.РегистрационныйНомерФСС)
		ИЛИ ЭтоТипВзаимодействияОрганизацияСЭДО И Результат.СвойстваДляОбмена = Неопределено) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		ПолучитьОГРН 			= ЭтоТипВзаимодействияОрганизацияСЭДО;
		ПолучитьИННКППиСНИЛС 	= ЭтоТипВзаимодействияОрганизацияСЭДО;
		Результат.СвойстваДляОбмена = КонтекстЭДО.СвойстваОрганизацииДляОбмена(
			Результат.Организация, ,
			ПолучитьОГРН, ,
			ПолучитьИННКППиСНИЛС);
		УстановитьПривилегированныйРежим(Ложь);
		Результат.РегистрационныйНомерФСС = ?(ЗначениеЗаполнено(Результат.СвойстваДляОбмена.РегистрационныйНомерФСС),
			СокрЛП(Результат.СвойстваДляОбмена.РегистрационныйНомерФСС), Неопределено);
	КонецЕсли;
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыСохраненияЗапросаСЭДОФСС(Организация, Операция) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Организация", 			Организация);
	Результат.Вставить("ОписаниеОшибки", 		"");
	Результат.Вставить("АдресЗапросаSOAP", 		Неопределено);
	Результат.Вставить("АдресОтветаSOAP", 		Неопределено);
	Результат.Вставить("Операция", 				Операция);
	Результат.Вставить("АдресРесурса", 			"");
	Результат.Вставить("АдресСервера", 			"");
	Результат.Вставить("КодСостояния", 			200);
	Результат.Вставить("Дата", 					Неопределено);
	Результат.Вставить("УдалятьИзХранилища", 	Ложь);
	Результат.Вставить("ТипСообщенияСЭДО", 		0);
	Результат.Вставить("ТипВзаимодействияСЭДО", 0);
	Результат.Вставить("ИдентификаторФСС", 		"");
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьДлинуРегистрационныйНомерФСС(
	СвойстваОрганизации,
	РегистрационныйНомерФСС,
	Отправка = Истина,
	Результат) Экспорт
	
	Если СтрДлина(РегистрационныйНомерФСС) < 10 Тогда
		// Ошибка длины дополнительного кода СФР.
		Шаблон = НСтр("ru='При %1 сообщения СЭДО ФСС произошла ошибка:
			|%2'");
		Если НЕ СвойстваОрганизации = Неопределено
			И СвойстваОрганизации.Свойство("ЭтоДополнительныйКодФСС")
			И СвойстваОрганизации.ЭтоДополнительныйКодФСС Тогда
			
			ОписаниеОшибки = СтрШаблон(Шаблон,
				?(Отправка, "отправке", "получении"),
				НСтр("ru='Указан недопустимый дополнительный код обособленного подразделения страхователя %1. Текущая длина номера %2, минимальная длина 10 символов.'"));
		Иначе
			ОписаниеОшибки = СтрШаблон(Шаблон,
				?(Отправка, "отправке", "получении"),
				НСтр("ru='Указан недопустимый регистрационый номер страхователя %1. Текущая длина номера %2, минимальная длина 10 символов.'"));
		КонецЕсли;
		ОписаниеОшибки = СтрШаблон(ОписаниеОшибки, РегистрационныйНомерФСС, СтрДлина(РегистрационныйНомерФСС));
		
		ШаблонДляЖурналаРегистрации = НСтр("ru = 'Электронный документооборот с контролирующими органами. %1'");
		Если Отправка Тогда
			ОписаниеОшибкиДляЖурналаРегистрации =
				СтрШаблон(ШаблонДляЖурналаРегистрации, "Отправка данных в СЭДО ФСС");
		Иначе
			ОписаниеОшибкиДляЖурналаРегистрации =
				СтрШаблон(ШаблонДляЖурналаРегистрации, "Получение сообщения СЭДО ФСС");
		КонецЕсли;
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(
				ОписаниеОшибкиДляЖурналаРегистрации,
				УровеньЖурналаРегистрации.Ошибка, , ,
				ОписаниеОшибки);
		#Иначе
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				ОписаниеОшибкиДляЖурналаРегистрации,
				"Ошибка",
				ОписаниеОшибки, ,
				Истина);
		#КонецЕсли
			
		Результат.Выполнено			= Ложь;
		Результат.ОписаниеОшибки	= ОписаниеОшибки;
		
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции

#КонецОбласти