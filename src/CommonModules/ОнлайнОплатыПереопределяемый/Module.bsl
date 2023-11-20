///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОнлайнОплаты".
// ОбщийМодуль.ОнлайнОплатыПереопределяемый.
//
// Переопределяемые серверные процедуры настройки интеграции с онлайн оплатами:
//  - определение дополнительных аналитик учета;
//  - события создания формы настройки онлайн оплаты и редактирования дополнительных аналитик учета;
//  - определение объектов выступающих в роли Основания платежа,заполнение соответствий 
//      и проверка заполненности реквизитов;
//  - определение имени, реквизитов и признака единичной записи справочника Организации;
//  - определение событий при загрузке операций онлайн оплат;
//  - проверка использования и определение шаблонов сообщений.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаСПодсистемой

// В процедуре задается описание дополнительных реквизитов настройки онлайн оплаты,
// например, Подразделение, Банковский счет и т.д.
// Значения реквизитов будут доступны в качестве свойств структуры, описывающей операцию Онлайн оплаты.
//
// Параметры:
//  ДополнительныеНастройки - ТаблицаЗначений - таблица дополнительных настроек с колонками:
//    * Настройка - Строка - уникальное имя настройки. Должно соответствовать требованиям именования ключей структуры.
//    * Представление - Строка - пользовательское представление настройки.
//    * ТипЗначения - ОписаниеТипов - описание типов значений настройки. Допустимые типы: ЛюбаяСсылка, Число(20,4), 
//        Строка(300), Булево, Дата (Дата + Время).
//
//@skip-warning
Процедура ПриОпределенииДополнительныхНастроекОнлайнОплаты(ДополнительныеНастройки) Экспорт
	
	ОнлайнОплатыУНФ.ПриОпределенииДополнительныхНастроекОнлайнОплаты(ДополнительныеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФормами

// Выполняется при создании формы элемента онлайн оплаты. Позволяет изменить форму 
// и определить дополнительные настройки, которые требуется сохранить в информационной базе.
//
// Для добавленных элементов можно устанавливать следующие действия:
//   * ПриИзменении - Подключаемый_ЭлементПриИзменении.
//   * НачалоВыбора - Подключаемый_ЭлементНачалоВыбора.
//   * ОбработкаВыбора - Подключаемый_ЭлементОбработкаВыбора.
//   * Нажатие - Подключаемый_ЭлементНажатие.
// Для добавленных команд следует устанавливать действие "Подключаемый_ДействиеКоманды".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма настроек онлайн оплаты.
//  Группа - ГруппаФормы - группа формы, на которой следует располагать добавляемые элементы.
//  Префикс - Строка - префикс имен для новых реквизитов, команд и элементов формы.
//  ДополнительныеНастройки - Структура - имена реквизитов, содержащих значения дополнительных настроек (для изменения).
//    * Ключ - идентификатор настройки. См. ОнлайнОплатыПереопределяемый.ПриОпределенииДополнительныхНастроекОнлайнОплаты
//    * Значение - имя реквизита формы со значением настройки.
//
//@skip-warning
Процедура ПриСозданииФормыОнлайнОплаты(Форма, Группа, Префикс, ДополнительныеНастройки) Экспорт
	
	ОнлайнОплатыУНФ.ПриСозданииФормыОнлайнОплаты(Форма, Группа, Префикс, ДополнительныеНастройки);

КонецПроцедуры

// Выполняется перед переходом на страницу редактирования дополнительных настроек в форме настроек онлайн оплаты.
// Позволяет проинициализировать реквизиты дополнительных настроек и/или пропустить страницу редактирования.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода:
//    * Форма - ФормаКлиентскогоПриложения - форма настроек Онлайн оплаты.
//    * Префикс - Строка - префикс имен добавленных реквизитов, команд и элементов формы.
//    * НоваяНастройка - Булево - признак редактирования новой настройки.
//    * Организация - ОпределяемыТип.Организация - организация, для которой производится настройка.
//    * СДоговором - Булево - признак варианта использования сервиса "С договором". Если Ложь, то "Без договора".
//  Отказ - Булево - если установить Истина, то страница редактирования дополнительных настроек будет пропущена.
//
//@skip-warning
Процедура ПередНачаломРедактированияДополнительныхНастроекОнлайнОплаты(Контекст, Отказ = Ложь) Экспорт
	
	ОнлайнОплатыУНФ.ПередНачаломРедактированияДополнительныхНастроекОнлайнОплаты(Контекст, Отказ);
	
КонецПроцедуры

// Выполняется перед закрытием страницы редактирования дополнительных настроек в форме настроек онлайн оплаты.
// Позволяет изменить значения реквизитов дополнительных настроек 
// и/или отказаться от перехода со страницы редактирования.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода:
//    * Форма - ФормаКлиентскогоПриложения - форма настроек Онлайн оплаты.
//    * Префикс - Строка - префикс имен добавленных реквизитов, команд и элементов формы.
//    * НоваяНастройка - Булево - признак редактирования новой настройки.
//    * Организация - ОпределяемыТип.Организация - организация, для которой производится настройка.
//    * СДоговором - Булево - признак варианта использования сервиса "С договором". Если Ложь, то "Без договора".
//  Отказ - Булево - если установить Истина, то страница редактирования дополнительных настроек не будет закрыта.
//
//@skip-warning
Процедура ПередОкончаниемРедактированияДополнительныхНастроекОнлайнОплат(Контекст, Отказ = Ложь) Экспорт
	
	ОнлайнОплатыУНФ.ПередОкончаниемРедактированияДополнительныхНастроекОнлайнОплат(Контекст, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСПрикладнымРешением

// Определяет соответствие имен реквизитов оснований платежа через онлайн оплату, в случае их отличия от общепринятых.
// Для каждого основания платежа требуется вставить строку вида:
// СоответствиеРеквизитов.Вставить(<ПолноеИмяМетаданных>.<ОбщепринятоеИмяРеквизита>,<ИмяРеквизитаВПрикладномРешении>);
// Требуется установить соответствие для следующих общепринятых реквизитов: "Организация".
// 
// Параметры:
//  СоответствиеРеквизитов - Соответствие - путь к реквизитам оснований платежа.
//    * Ключ - Строка - полный путь к реквизиту с использованием общепринятого имени.
//    * Значение - Строка - имя реквизита в прикладном решении.
//
//@skip-warning
Процедура СоответствиеРеквизитовОснованийПлатежа(СоответствиеРеквизитов) Экспорт 
	
КонецПроцедуры

// Определяет объекты, которые могут выступать в качестве оснований платежа через онлайн оплату.
//
// Параметры:
//  ОснованияПлатежа - Массив - имена объектов метаданных (строка) оснований платежа через Онлайн оплату.
//
//@skip-warning
Процедура ПриОпределенииОснованийПлатежа(ОснованияПлатежа) Экспорт
	
	ОнлайнОплатыУНФ.ПриОпределенииОснованийПлатежа(ОснованияПлатежа);
	
КонецПроцедуры

// Проверяет основание платежа на возможность формирования ссылки на оплату через онлайн оплату.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого формируется платежная ссылка.
//  Отказ - Булево - признак отказа от формирования ссылки.Если установить значение Истина,
//    то ссылка не будет сформирована (обновлена).
//
//@skip-warning
Процедура ПриПроверкеЗаполненияОснованияПлатежа(Знач ОснованиеПлатежа, Отказ) Экспорт
	
	ОнлайнОплатыУНФ.ПриПроверкеЗаполненияОснованияПлатежа(ОснованиеПлатежа, Отказ);
	
КонецПроцедуры

// Заполняет значения реквизитов организации по данным информационной базы.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, значения реквизитов которой нужно заполнить.
//  Реквизиты - Структура - значения реквизитов:
//    * ИНН - Строка - ИНН организации.
//    * КПП - Строка - КПП организации.
//    * Резидент - Булево - признак того, что организация является резидентом.
//    * ЭтоЮрЛицо - Булево - признак того, что организация является юридическим лицом.
//
//@skip-warning
Процедура ЗаполнитьРеквизитыОрганизации(Знач Организация, Реквизиты) Экспорт

    ОнлайнОплатыУНФ.ЗаполнитьРеквизитыОрганизации(Организация, Реквизиты);
	
КонецПроцедуры

// Определяет использование нескольких организаций в базе.
//
// Параметры:
//  Результат - Структура - результат выполнения запроса:
//    * ОднаОрганизация - Булево - Истина, если в базе используется одна организация;
//    * Организация - СправочникСсылка._ДемоОрганизации - ссылка на организацию, если она единственная в базе;
//
//@skip-warning
Процедура ИспользуетсяОднаОрганизация(Результат) Экспорт

	ОнлайнОплатыУНФ.ИспользуетсяОднаОрганизация(Результат);
	
КонецПроцедуры

// Определяет имя прикладного справочника организаций.
//
// Параметры:
//  ИмяПрикладногоСправочника - Строка - Имя справочника организаций.
//
//@skip-warning
Процедура ИмяПрикладногоСправочникаОрганизации(ИмяПрикладногоСправочника) Экспорт
	
	ОнлайнОплатыУНФ.ИмяПрикладногоСправочникаОрганизации(ИмяПрикладногоСправочника);
	
КонецПроцедуры

// Заполняет данные по основанию платежа, необходимые для формирование ссылки на оплату через онлайн оплаты.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, данные которого нужно заполнить.
//  ДанныеОснованияПлатежа - Структура - данные основания платежа:
//    * Идентификатор - Строка - уникальный идентификатор основание платежа 
//        (идентификатора платежа при получении операций оплаты/возврата).
//    * Номер - Строка - номер основание платежа.
//    * Сумма - Число - сумма к оплате.
//    * Валюта - Строка - код валюты по классификатору валют.
//    * НазначениеПлатежа - Строка - назначение платежа.
//    * БанковскийСчет - Структура - банковский счет для зачисления оплаты:
//        ** БанкБИК - Строка - БИК банка.
//        ** БанкНаименование - Строка - наименование банка.
//        ** БанкКоррСчет - Строка - корр. счет банка.
//        ** НомерСчета - Строка - номер расчетного счета.
//    * Продавец - Структура - данные продавца:
//        ** УчетнаяПолитика - Число - код учетной политики продавца: 1 - ОСН, 2 - УСН (доходы), 
//             3 - УСН (доходы минус расходы), 4 - продажа облагается ЕНВД,
//             5 - единый сельскохозяйственный налог, 6 - патентная СН.
//        ** ИНН - Строка - ИНН продавца.
//        ** КПП - Строка - КПП продавца.
//        ** Наименование - Строка - наименование продавца.
//        ** Телефон - Строка - контактный телефон продавца.
//        ** ЭлектроннаяПочта - Строка - контактный адрес электронной почты продавца.
//        ** ФактическийАдрес - Строка - фактический адрес продавца.
//        ** ЮридическийАдрес - Строка - юридический адрес продавца.
//    * Покупатель - Структура - данные покупателя:
//        ** Идентификатор - Строка - уникальный идентификатор покупателя.
//        ** Наименование - Строка - для юрлица - название организации, для ИП и физического лица - ФИО. 
//             Если у физлица отсутствует ИНН, в этом же параметре передаются паспортные данные. Не более 256 символов.
//        ** КонтактныеДанныеЧека - Строка - номер телефона или адрес электронной почты для отправки чека.
//             Может быть переопределен в форме формирования платежной ссылки.
//        ** ИНН - Строка - ИНН покупателя (10 или 12 цифр). Если у физического лица отсутствует ИНН, 
//             необходимо передать паспортные данные в параметре Покупатель.Наименование.
//    * Номенклатура - ТаблицаЗначений - номенклатура к оплате. Колонки:
//        ** НомерСтроки - Число - номер строки по порядку.
//        ** Наименование - Строка - наименование товара/услуги.
//        ** НаименованиеПолное - Строка - полное наименование товара/услуги.
//        ** Характеристика - Строка - характеристика номенклатуры.
//        ** Количество - Число - количество позиций.
//        ** Цена - Число - цена за единицу.
//        ** СтавкаНДС - Строка - представление ставки НДС.
//        ** СтавкаНДСКод - Число - код ставки НДС. 
//             до 31.12.2018 действуют следующие коды ставок НДС: 1 - без НДС, 2 - 0%, 3 - 10%, 4 - 18%,
//                5 - 10/110, 6 - 18/118.
//             с  01.01.2019 действуют следующие коды ставок НДС: 1 - без НДС, 2 - 0%, 3 - 10%, 4 - 20%,
//                5 - 10/110, 6 - 20/120.
//        ** Валюта - Строка - представление валюты строки.
//        ** Артикул - Строка - артикул номенклатуры.
//        ** ЕдиницаИзмерения - Строка - представление единицы измерения.
//        ** ВидНоменклатуры - Строка - вид номенклатуры.
//        ** Родитель - Строка - группа номенклатуры.
//        ** Сумма - Число - сумма строки.
//        ** ПредметРасчета - Число - признак предмета расчета (категория товара для налоговой инспекции).
//             Возможные значения:
//               1 - товар;
//               2 - подакцизный товар;
//               3 - работа;
//               4 - услуга;
//               5 - ставка в азартной игре;
//               6 - выигрыш в азартной игре;
//               7 - лотерейный билет;
//               8 - выигрыш в лотерею;
//               9 - результаты интеллектуальной деятельности;
//               10 - платеж;
//               11 - агентское вознаграждение;
//               12 - несколько вариантов;
//               13 - другое.
//        ** КодТовара - Строка -  уникальный номер, который присваивается экземпляру товара при маркировке.
//             Формат: число в шестнадцатеричном представлении с пробелами. Максимальная длина - 32 байта.
//             Пример: 00 00 00 01 00 21 FA 41 00 23 05 41 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 AB 00.
//        ** КодСтраныПроисхожденияТовара - Строка - Код страны происхождения товара по общероссийскому классификатору
//              стран мира (ОК (МК (ИСО 3166) 004-97) 025-2001). Пример: RU.
//        ** НомерТаможеннойДекларации - Строка - номер таможенной декларации.
//        ** СуммаАкциза - Число - сумма акциза товара с учетом копеек (с точностью до 2 символов после точки).
//    * Штрихкоды - ТаблицаЗначений - штрихкоды номенклатуры. Колонки:
//        ** НомерСтроки - Число - номер строки номенклатуры, к которой относится штрихкод.
//        ** Штрихкод - Строка - штрихкод номенклатуры.
//
//@skip-warning
Процедура ЗаполнитьДанныеОснованияПлатежа(Знач ОснованиеПлатежа, ДанныеОснованияПлатежа) Экспорт
	
	ОнлайнОплатыУНФ.ЗаполнитьДанныеОснованияПлатежа(ОснованиеПлатежа, ДанныеОснованияПлатежа);

КонецПроцедуры

// Заполняет контактную информацию покупателя для выбора в форме формирования платежной ссылки.
// Используется для отправки чека при оплате.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, контактную информацию которого нужно заполнить.
//  КонтактнаяИнформация - Структура - контакты покупателя для отправки чека:
//    * Телефоны - Массив из строк - телефоны покупателя.
//    * ЭлектроннаяПочта - Массив из строк - адреса электронной почты покупателя.
//
//@skip-warning
Процедура ЗаполнитьКонтактнуюИнформациюОснованияПлатежа(Знач ОснованиеПлатежа, КонтактнаяИнформация) Экспорт
	
	ОнлайнОплатыУНФ.ЗаполнитьКонтактнуюИнформациюОснованияПлатежа(ОснованиеПлатежа, КонтактнаяИнформация)
	
КонецПроцедуры

// Заполняет список получателей сообщения с платежной ссылкой.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого получена платежная ссылка.
//  ВариантОтправки - Строка - способ отправки ссылки. "ЭлектроннаяПочта" - по электронной почте, "Телефон" - по SMS.
//  Получатели - СписокЗначений - адреса электронной почты или номера телефонов получателей (строка).
//
//@skip-warning
Процедура ПриФормированииСпискаПолучателейСообщения(Знач ОснованиеПлатежа, Знач ВариантОтправки, Получатели) Экспорт
	
	ОнлайнОплатыУНФ.ПриФормированииСпискаПолучателейСообщения(ОснованиеПлатежа, ВариантОтправки, Получатели);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаССервисом

// Выполняется при загрузке операций по онлайн оплате.
// Позволяет отразить полученные операции в учете.
//
// Параметры:
//  Операции - Структура - операции полученные из сервиса по соответствующей настройке.
//    См. ОнлайнОплаты.ОперацииОнлайнОплат (элемент возвращаемого массива).
//  Результат - Произвольный - произвольный результат загрузки операций.
//    См. ОнлайнОплаты.ЗагрузитьОперацииОнлайнОплат (возвращаемое значение)
//  Отказ - Булево - признак отказа от загрузки. Если установить значение Истина,
//    то статус обмена по данной настройке не будет обновлен.
//
//@skip-warning
Процедура ПриЗагрузкеОперацийПоОнлайнОплате(Знач Операции, Результат, Отказ) Экспорт
	
	ОнлайнОплатыУНФ.ПриЗагрузкеОперацийПоОнлайнОплате(Операции, Результат, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Включает использование шаблонов сообщений для интеграции с онлайн оплатами.
//
// Параметры:
//  Используется - Булево - признак использования шаблонов сообщений.
//
//@skip-warning
Процедура ПроверитьИспользованиеШаблоновСообщенийОнлайнОплат(Используется) Экспорт
	
	ОнлайнОплатыУНФ.ПроверитьИспользованиеШаблоновСообщенийОнлайнОплат(Используется);
	
КонецПроцедуры


// Определяет параметры отправки сообщений с использованием шаблонов Онлайн оплат.
//
// Параметры:
//  ПараметрыОтправкиСообщений - Структура - описание параметров отправки сообщений:
//    * ПараметрыОтправкиПисем - Структура - описание параметров отправки электронных писем:
//       ** ОтправлятьПисьмаВФорматеHTML - Булево, Неопределено - признак отправки электронных писем в формате HTML.
//          Если свойство не задано, в дальнейшем при наличии подсистемы "Взаимодействия" будет получено значение
//          функциональной опции "ОтправлятьПисьмаВФорматеHTML", либо Ложь при ее отсутствии.
//
Процедура ПриОпределенииПараметровОтправкиСообщенийОнлайнОплат(ПараметрыОтправкиСообщений) Экспорт
	
	
	
КонецПроцедуры

// Описывает предопределенные шаблоны писем,
// с помощью которых можно будет выставлять счета для оплаты через онлайн оплаты.
// Эти шаблоны будут доступны для создания из основной формы настроек и использоваться
// в форме формирования платежной ссылки Онлайн оплаты.
//
// Параметры:
//  Шаблоны - Массив - Массив структур данных, описывающих предопределенные шаблоны сообщения.
//    * ПолноеИмяТипаНазначения - Строка - Полное имя объекта метаданных, на основании которого по данному шаблону 
//        будут создаваться письма.
//    * Текст - Строка - Текст, который будет использоваться в качестве шаблона письма в формате HTML.
//    * Тема - Строка - Текст, который будет использоваться в качестве шаблона темы письма.
//    * Наименование - Строка - Текст, наименование шаблона письма.
//
//@skip-warning
Процедура ПредопределенныеШаблоныСообщенийОнлайнОплат(Шаблоны) Экспорт 

	ОнлайнОплатыУНФ.ПредопределенныеШаблоныСообщенийОнлайнОплат(Шаблоны)
	
КонецПроцедуры

// Описывает предопределенные шаблоны писем по типу,
// с помощью которых можно будет выставлять счета для оплаты через онлайн оплаты.
// Эти шаблоны будут доступны для создания из основной формы настроек и использоваться
// в форме формирования платежной ссылки Онлайн оплаты.
//
// Параметры:
//  Шаблоны - Массив - Массив структур данных, описывающих предопределенные шаблоны сообщения.
//    * ПолноеИмяТипаНазначения - Строка - Полное имя объекта метаданных, на основании которого по данному шаблону
//        будут создаваться письма.
//    * Текст - Строка - Текст, который будет использоваться в качестве шаблона письма в формате HTML.
//    * Тема - Строка - Текст, который будет использоваться в качестве шаблона темы письма.
//    * Наименование - Строка - Текст, наименование шаблона письма.
//    * Тип - Строка - Тип шаблона. Возможные значения:"Почта" или "SMS".
//
//@skip-warning
Процедура ПредопределенныеШаблоныСообщенийОнлайнОплатПоТипам(Шаблоны) Экспорт 
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
