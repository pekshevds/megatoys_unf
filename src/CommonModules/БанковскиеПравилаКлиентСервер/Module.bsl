// "Положение о правилах ведения бухгалтерского учета в кредитных организациях, расположенных на территории Российской Федерации"
// (утверждено Банком России 16.07.2012 N 385-П)
// "Положение о плане счетов бухгалтерского учета для кредитных организаций и порядке его применения"
// (утверждено Банком России 27.02.2017 N 579-П)

#Область ПланСчетовКредитныхОрганизаций
// - План счетов бухгалтерского учета в кредитных организациях

// Функция возвращает балансовый счет
//
// Параметры:
//  НомерСчета	 - Строка	 - Номер банковского счета
// 
// Возвращаемое значение:
//  Строка - Балансовый счет
//
Функция БалансовыйСчет(НомерСчета) Экспорт
	
	Возврат Лев(НомерСчета, 5);
	
КонецФункции

// Функция возвращает признак счета расчетов филиала банка с клиентами банка
//
// Параметры:
//  БалансовыйСчет	 - Строка	 - Балансовый счет
// 
// Возвращаемое значение:
//  Булево - Признак счета расчетов филиала банка
//
Функция ЭтоСчетРасчетовФилиалаБанкаСКлиентамиБанка(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30301"  // Внутрибанковские обязательства по переводам клиентов
		Или БалансовыйСчет = "30302"; // Внутрибанковские требования по переводам клиентов
	
КонецФункции

// Функция возвращает признак корреспондентского счета кредитных организаций корреспондентов
//
// Параметры:
//  БалансовыйСчет	 - Строка	 - Балансовый счет
// 
// Возвращаемое значение:
//  Булево - Признак корреспондентского счета кредитных организаций
//
Функция ЭтоКорСчетКредитныхОрганизацийКорреспондентов(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30109"; // Корреспондентские счета кредитных организаций - корреспондентов
	
КонецФункции

// Функция возвращает признак корсчета в кредитной организации корреспонденте
//
// Параметры:
//  БалансовыйСчет	 - Строка	 - Балансовый счет
// 
// Возвращаемое значение:
//  Булево - Признак корсчета в кредитной организации
//
Функция ЭтоКорсчетВКредитнойОрганизацииКорреспонденте(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30110"; // Корреспондентские счета в кредитных организациях - корреспондентах
	
КонецФункции

// Функция возвращает признак корсчета банка нерезидента
//
// Параметры:
//  БалансовыйСчет	 - Строка	 - Балансовый счет
// 
// Возвращаемое значение:
//  Булево - Признак корсчета банка нерезидента
//
Функция ЭтоКорсчетБанкаНерезидента(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30111"; // "Корреспондентские счета банков-нерезидентов"
	
КонецФункции

// Функция возвращает признак счета переводов физическим лицам
//
// Параметры:
//  БалансовыйСчет	 - Строка	 - Балансовый счет
// 
// Возвращаемое значение:
//  Булево - Признак счета переводов физическим лицам
//
Функция ЭтоСчетПереводовФизическимЛицам(БалансовыйСчет) Экспорт
	
	// 40817 - "Физические лица" - "Назначение счета - учет денежных средств физических лиц, не связанных с осуществлением
	//                             ими предпринимательской деятельности"
	// Как правило, лицевые счета открываются физическим лицам.
	// Но могут быть открыты и организациям - для учета средств, направленных на выплаты физическим лицам.
	// 40820 - "Счета физических лиц - нерезидентов"
	
	Возврат БалансовыйСчет = "40817" Или БалансовыйСчет = "40820";
	
КонецФункции

#КонецОбласти

#Область ЛицевыеСчета

Функция ТипНомерСчета() Экспорт
	
	Возврат Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(ДлинаНомераСчета()));
	
КонецФункции

Функция СтрокаСоответствуетФорматуБанковскогоСчета(Строка) Экспорт
	
	Если Не ПроверитьДлинуНомераСчета(Строка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Строка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Проверяем особый случай: алфавитный символ в номере счета
	
	ЗаведомоЦифровыеСимволы = Лев(Строка, 5) + Сред(Строка, 7);
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЗаведомоЦифровыеСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	АлфавитныйСимвол = Сред(Строка, 6, 1);
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(АлфавитныйСимвол) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЦифраШестогоРазряда = СтрНайти(ДопустимыеАлфавитныеСимволыНомераБанковскогоСчета(), АлфавитныйСимвол);
	Возврат ЦифраШестогоРазряда <> Неопределено;
	
КонецФункции

Функция ДопустимыеАлфавитныеСимволыНомераБанковскогоСчета()
	// Символы приведены в порядке, определенном письмом ЦБР от 8 сентября 1997 г. N 515
	// См. также ПроверитьКонтрольныйКлючВНомереБанковскогоСчета()
	Возврат "ABCEHKMPTX";
КонецФункции

Функция ДлинаНомераСчета() Экспорт
	
	Возврат 20;
	
КонецФункции

Функция ПроверитьДлинуНомераСчета(НомерСчета) Экспорт
	
	Возврат СтрДлина(НомерСчета) = ДлинаНомераСчета();
	
КонецФункции

Функция КодРубляВНомереСчета()
	// П. 1.17 Положения
	// По счетам в валюте Российской Федерации используется признак рубля "810".
	
	Возврат "810";
	
КонецФункции

Функция КодВалютыБанковскогоСчета(НомерСчета)
	
	// П. 1.17 Положения
	// При осуществлении операций по счетам в иностранных, клиринговых валютах, а также в драгоценных металлах
	// в лицевом счете в разрядах (6-8), предназначенных для кода валюты, указываются соответствующие коды,
	// предусмотренные Общероссийским классификатором валют (ОКВ).
	
	Возврат Сред(НомерСчета, 6,3);
	
КонецФункции

Функция ЭтоРублевыйСчет(НомерСчета) Экспорт
	
	ЭтоРублевыйСчет = Ложь;
	
	КодВалюты = КодВалютыБанковскогоСчета(НомерСчета);
	
	Если КодВалюты = КодРубляВНомереСчета() Тогда
		ЭтоРублевыйСчет = Истина;
	КонецЕсли;
	
	Возврат ЭтоРублевыйСчет;
	
КонецФункции

// Проверяет допустимо ли производить проверки банковского счета по переданным параметрам.
// Для иностранных банков наличие кода банка необязательно.
//
// Параметры:
//  НомерСчета       - Строка - номер проверяемого счета.
//  КодБанка         - Строка - код банка проверяемого счета.
//  ЯвляетсяБанкомРФ - Булево - признак российского банка.
// 
// Возвращаемое значение:
//  Булево - признак того, что проверки счета допустимы.
//
Функция ПропуститьПроверкуРеквизитовСчета(НомерСчета, КодБанка, ЯвляетсяБанкомРФ) Экспорт
	
	Если ЯвляетсяБанкомРФ Тогда
		ПропуститьПроверку = ПустаяСтрока(НомерСчета) Или ПустаяСтрока(КодБанка);
	Иначе
		ПропуститьПроверку = ПустаяСтрока(НомерСчета);
	КонецЕсли;
	
	Возврат ПропуститьПроверку;
	
КонецФункции

// Проверяет правильность заполнения номера счета и возвращает в параметре текст сообщения.
//
// Параметры:
//  НомерСчета     - Строка - номер проверяемого счета.
//  КодБанка       - Строка - клиринговый код банка для проверяемого счета.
//  ЯвляетсяБанкомРФ      - Булево - признак российского банка.
//  ТекстСообщения - Строка - в параметр передается текст сообщения об ошибке, если проверка не пройдена.
// 
// Возвращаемое значение:
//  Булево - Результат проверки номера счета, если Ложь тогда счет некорректный.
//
Функция НомерСчетаКорректен(НомерСчета, КодБанка, ЯвляетсяБанкомРФ, ТекстСообщения = "") Экспорт
	
	Если ПропуститьПроверкуРеквизитовСчета(НомерСчета, КодБанка, ЯвляетсяБанкомРФ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТекстСообщения = "";
	
	НомерСчетаКорректен = Ложь;
	
	Если ЯвляетсяБанкомРФ Тогда
		
		Если Не ПроверитьДлинуНомераСчета(НомерСчета) Тогда
			ТекстСообщения = НСтр("ru = 'Номер счета должен состоять из 20 цифр'");
		ИначеЕсли Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерСчета) Тогда
			ТекстСообщения = НСтр("ru = 'В номере счета должны быть только цифры'");
		Иначе
			НомерСчетаКорректен = Истина;
		КонецЕсли;
		
	Иначе
		
		Если Не ПроверитьРазрешенныеСимволыСчета(НомерСчета) Тогда
			ТекстСообщения = НСтр("ru = 'Разрешены только буквы от A до Z и цифры'");
		Иначе
			НомерСчетаКорректен = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НомерСчетаКорректен;
	
КонецФункции

#КонецОбласти

// "Положение о Справочнике банковских идентификационных кодов участников расчетов,
// осуществляющих платежи через расчетную сеть Центрального банка Российской Федерации (Банка России),
// и расчетно-кассовых центров Банка России"
// (утверждено Банком России 06.05.2003 N 225-П)

#Область БанковскиеИдентификационныеКоды

Функция ДлинаБИК()
	
	// п. 2.2 Положения 
	Возврат 9;
	
КонецФункции

Функция ПроверитьДлинуБИК(БИК) Экспорт
	
	Возврат СтрДлина(СокрЛП(БИК)) = ДлинаБИК();
	
КонецФункции

Функция ЭтоБИКБанкаРФ(КодБанка) Экспорт
	
	Если Лев(КодБанка, 2) = "04" И ПроверитьДлинуБИК(КодБанка) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти


// ISO 13616
// Financial services - International bank account number (IBAN)

#Область МеждународныеБанковскиеСчета

Функция СтрокаСоответствуетФорматуIBAN(Строка) Экспорт
	
	// IBAN (International bank account number) - международный номер банковского счета
	
	// Структура IBAN определена ISO 13616-1:
	// a) первые две буквы - код страны по ISO 3166-1 (alpha-2)
	// b) затем две цифры - контрольная сумма по алгоритму ISO/IEC 7064 (MOD97-10).
	// c) затем последовательность символов, длина и содержание которой определяется страной, указанной в a)
	// При этом, общая длина IBAN не может превышать 34 символа.
	// При передаче в электронном виде в IBAN не допускаются разделители (пробелы и т.п.)
	
	// Детальная информация, которая надежно позволяет валидировать строку на соответствие стандарту, содержится в IBAN Registry.
	// Однако, здесь определяем в упрощенном порядке:
	// a) первые два символа - латинские буквы, приведенные в IBAN Registry
	// b) вторые два символа - цифры (не проверяем контрольную сумму)
	// c) общая длина от 5 до 34 символов (не проверяем длину на соответствие правилам конкретной страны)
	
	Если ПустаяСтрока(Строка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаСтроки = СтрДлина(Строка);
	Если ДлинаСтроки < 5 Или ДлинаСтроки > МаксимальнаяДлинаМеждународногоНомераСчета() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтранаПрименяетФорматIBAN(КодСтраныIBAN(Строка)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Сред(Строка, 3, 2)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция КодСтраныIBAN(НомерСчетаIBAN)
	
	Возврат Лев(НомерСчетаIBAN, 2);
	
КонецФункции

// Проверяет, применяет ли страна формат IBAN, по данным IBAN REGISTRY Release 78 - August 2017
// www.swift.com/standards/data-standards/iban
//
// Параметры:
//  КодСтраны - Строка - код страны по ISO 3166-1 (alpha-2)
// 
// Возвращаемое значение:
//  Булево - Истина, если страна применяет формат IBAN
//
Функция СтранаПрименяетФорматIBAN(КодСтраны)
	
	Если ПустаяСтрока(КодСтраны) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КодыВсехСтранПрименяющихIBAN = "/AD/AE/AL/AT/AZ/BA/BE/BG/BH/BR/BY/CH/CR/CY/CZ/DE/DK/DO/EE/ES/FI" +
		"/FO/FR/GB/GE/GI/GL/GR/GT/HR/HU/IE/IL/IQ/IS/IT/JO/KW/KZ/LB/LC/LI/LT/LU/LV/MC/MD/ME/MK/MR/MT" +
		"/MU/NL/NO/PK/PL/PS/PT/QA/RO/RS/SA/SC/SE/SI/SK/SM/ST/SV/TL/TN/TR/UA/VG/XK/";
	
	Возврат СтрНайти(КодыВсехСтранПрименяющихIBAN, "/" + КодСтраны + "/") > 0;

КонецФункции

Функция ТипМеждународныйНомерСчета() Экспорт
	
	Возврат Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(МаксимальнаяДлинаМеждународногоНомераСчета()));
	
КонецФункции

Функция МаксимальнаяДлинаМеждународногоНомераСчета() Экспорт
	
	Возврат 34;
	
КонецФункции

// Функция проверяет контрольную сумму в счете IBAN.
// Алгоритм проверки описан в ECBS EBS204 v.3.1. (August 2002), стр 12.
//
// Параметры:
//  IBAN - Строка - номер счета в формате IBAN, который необходимо проверить.
// 
// Возвращаемое значение:
//  Булево - Признак корректности IBAN
//
Функция ПроверитьКонтрольныйКлючIBAN(IBAN) Экспорт
	
	// Предварительный этап. Удаляем лишние пробелы в IBAN т.к. он может быть указан в бумажном формате.
	ПроверяемыйIBAN  = СтрЗаменить(IBAN, " ", "");
	
	// 1. Передвигаем первые 4 символа в правую часть IBAN.
	ПроверяемыйIBAN = Сред(ПроверяемыйIBAN, 5) + Лев(ПроверяемыйIBAN, 4);
	
	// 2. Преобразуем буквы в числа согласно таблице конвертации.
	// 
	// A = 10  G = 16  M = 22  S = 28  Y = 34
	// B = 11  H = 17  N = 23  T = 29  Z = 35
	// C = 12  I = 18  O = 24  U = 30
	// D = 13  J = 19  P = 25  V = 31
	// E = 14  K = 20  Q = 26  W = 32
	// F = 15  L = 21  R = 27  X = 33
	
	БуквыДляКонвертации = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	Для ИндексБуквы = 1 По СтрДлина(БуквыДляКонвертации) Цикл
		
		КонвертируемаяБуква = Сред(БуквыДляКонвертации, ИндексБуквы, 1);
		КонвертируемаяЦифра = ИндексБуквы + 9;
		
		ПроверяемыйIBAN = СтрЗаменить(ПроверяемыйIBAN, КонвертируемаяБуква, КонвертируемаяЦифра);
		
	КонецЦикла;
	
	ОстатокПроверяемыйIBAN = ПроверяемыйIBAN;
	ДлинаПроверяемогоОтрезка = 9;
	ТипЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(ДлинаПроверяемогоОтрезка,0));
	КонтрольнаяЦифра = 0;
	КонтрольнаяЦифраСтрока = "";
	// IBAN требует число длиной до 34 знаков, а веб-клиент поддерживает число длиной до 10 знаков,
	// поэтому разбиваем строку на числа в 9 знаков.
	Пока Не ПустаяСтрока(ОстатокПроверяемыйIBAN) Цикл
		
		ЧислоСимволов = Мин(ДлинаПроверяемогоОтрезка - СтрДлина(КонтрольнаяЦифраСтрока), СтрДлина(ОстатокПроверяемыйIBAN));
		
		ПроверяемыйIBANСтрока = Строка(КонтрольнаяЦифраСтрока) + Сред(ОстатокПроверяемыйIBAN, 1, ЧислоСимволов);
		
		ПроверяемыйIBANЧисло = ТипЧисло.ПривестиЗначение(ПроверяемыйIBANСтрока);
		
		// 3. Применяем Mod 97-10 (ISO 7064).
		// Если остаток равен 1 тогда
		// это признак того, что счет корректный.
		КонтрольнаяЦифра = ПроверяемыйIBANЧисло % 97;
		
		КонтрольнаяЦифраСтрока = Строка(КонтрольнаяЦифра);
		ОстатокПроверяемыйIBAN = Сред(ОстатокПроверяемыйIBAN, ЧислоСимволов +1);
		
	КонецЦикла;
	
	Возврат КонтрольнаяЦифра = 1;
	
КонецФункции

// Функция проверяет код счета на наличие разрешенных символов.
// Источник ISO 20022 и MT103.
//
// Параметры:
//  НомерСчета - Строка - код IBAN.
// 
// Возвращаемое значение:
//  Булево - Признак того, что проверка пройдена.
//
Функция ПроверитьРазрешенныеСимволыСчета(НомерСчета) Экспорт
	
	Возврат ПроверитьБуквенноЦифровыеСимволы(НомерСчета);
	
КонецФункции

#КонецОбласти

// ISO 9362
// SWIFT BIC

#Область SWIFTКоды

// Получает код страны из SWIFT согласно ISO 9362.
//
// Параметры:
//  СВИФТБИК - Строка - код SWIFT BIC.
// 
// Возвращаемое значение:
//  Строка -  Код страны SWIFT.
//
Функция КодСтраныSWIFT(СВИФТБИК) Экспорт
	
	Возврат Сред(СВИФТБИК,5,2);
	
КонецФункции

// Функция проверяет соответствие строки банковскому коду SWIFT.
//
// Параметры:
//  ПроверяемаяСтрока - Строка - строка которую, требуется проверить на соответствие SWIFT коду.
// 
// Возвращаемое значение:
//  Булево - если Истина - строка соответствует формату SWIFT. 
//
Функция СтрокаСоответствуетФорматуSWIFT(ПроверяемаяСтрока) Экспорт
	
	Если ПроверитьДлинуSWIFT(ПроверяемаяСтрока) И ПроверитьРазрешенныеСимволыSWIFT(ПроверяемаяСтрока) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Функция возвращает признак корректности длины SWIFT.
// Согласно ISO 9362 центральные офисы банков имеет длину 8 символов,
// а подразделения банков - 11 символов (3 дополнительных символа для номера филиала)
//
// Параметры:
//  СВИФТБИК - Строка - код SWIFT BIC.
// 
// Возвращаемое значение:
//  Булево -  Признак того, что длина корректная.
//
Функция ПроверитьДлинуSWIFT(СВИФТБИК) Экспорт
	
	ДлинаКода = СтрДлина(СВИФТБИК);
	ДлинаДляЦО = 8; 
	ДлинаДляФилиала = 11;
	
	Возврат ДлинаКода = ДлинаДляЦО Или ДлинаКода = ДлинаДляФилиала;
	
КонецФункции

// Функция проверяет код SWIFT на наличие разрешенных символов.
//  Источник: ISO 9362:2014 - BIC Implementation. Changes and impacts. (стр. 6).
//  Контроль всего кода выполняем на буквенно-цифровые символы, т.к.
//  стандарт не рекомендует выполнять проверки согласно конкретным разрешенным символам в отдельных разрядах SWIFT.
//
// Параметры:
//  СВИФТБИК - Строка - код SWIFT BIC.
// 
// Возвращаемое значение:
//  Булево - Признак того, что проверка пройдена.
//
Функция ПроверитьРазрешенныеСимволыSWIFT(СВИФТБИК) Экспорт
	
	Возврат ПроверитьБуквенноЦифровыеСимволы(СВИФТБИК);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьБуквенноЦифровыеСимволы(СтрокаСимволов)
	
	ПроверитьРазрешенныеСимволы = Истина;
	
	Для ИндексСимвола = 1 По СтрДлина(СтрокаСимволов) Цикл
		
		СимволКода = ВРег(Сред(СтрокаСимволов, ИндексСимвола, 1));
		
		Если СтрНайти("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", СимволКода) = 0 Тогда
			ПроверитьРазрешенныеСимволы = Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПроверитьРазрешенныеСимволы; 
	
КонецФункции

#КонецОбласти
