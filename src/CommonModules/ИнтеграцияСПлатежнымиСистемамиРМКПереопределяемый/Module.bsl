
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ОтменитьОперациюВФоне с сохранение результата во временном хранилище
// Отменяет все выполняемые действия с операций платежной системой на форме
//
// Параметры:
//  РезультатОперации - Структура - см. ИнтеграцияСПлатежнымиСистемами.ОтменитьЗаказНаОплату.
//
//  ДокументОплаты - ОпределяемыйТип.ДокументОплатыБИП - документ, который отражает
//                    продажу в информационной базе;
//  Интеграция - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка интеграции с платежной системой;
//  НастройкиТорговойТочки - Структура - информация о доступных операциях:
//    *ОтменаЗаказа - Булево - признак доступности отмены не оплаченного
//                    заказа в платежной системе. Для выполнения операции
//                    следует использовать метод ИнтеграцияСПлатежнымиСистемами.ОтменитьЗаказНаОплату;
//    *ОтменаОплаты - Булево - признак доступности отмены оплаченного
//                    заказа (отмена транзакции) в платежной системе. Для выполнения операции
//                    следует использовать метод ИнтеграцияСПлатежнымиСистемами.ОтменитьОплату;
//    *СрокЖизниQRКода - Булево - признак доступности установки максимального
//                       срока действия QR-кода;
//    *ПлатежнаяСсылка - Булево - признак доступности использования платежной ссылки
//                       для выполнения оплаты;
//    *ВыборПлатежнойСистемыВозврата - Булево - признак доступности возврата оплаты
//                                     в платежную систему отличную от исходной. Для
//                                     получения списка доступных платежных систем следует 
//                                     использовать метод ИнтеграцияСПлатежнымиСистемами.ПлатежныеСистемыВозврата;
//    *Идентификатор - Строка - строковый идентификатор платежной системы или участника СБП;
//    *СинонимСистемы - Строка - синоним платежной системы для печати.
//    
//  ИдентификаторЗаданияФормированияQRКода - УникальныйИдентификатор - идентификатор 
//  																   длительной операции по формированию qr-кода
//  ИдентификаторЗаданияПроверкиСтатуса - УникальныйИдентификатор    - идентификатор 
//  															       длительной операции по проверки статуса оплаты
//  ИдентификаторЗаданияВозврата - УникальныйИдентификатор           - идентификатор 
//  														           длительной операции по проверке статуса возврата
//
Процедура ОтменитьОперацию(РезультатОперации, ДокументОплаты, Интеграция, НастройкиТорговойТочки, ИдентификаторЗаданияФормированияQRКода, ИдентификаторЗаданияПроверкиСтатуса, ИдентификаторЗаданияВозврата) Экспорт
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемамиУНФ.ОтменитьОперацию(
		ДокументОплаты,
		Интеграция,
		НастройкиТорговойТочки,
		ИдентификаторЗаданияФормированияQRКода,
		ИдентификаторЗаданияПроверкиСтатуса,
		ИдентификаторЗаданияВозврата);
	
КонецПроцедуры

#КонецОбласти

// Процедура настраивает форму помощника кассового места
// Параметры:
//  Форма - форма нового РМК
//  КассаККМ - ОпределяемыйТип.КассаККМРМК - настраиваемая касса
//
Процедура НастроитьФормуПомощникаПодключенияСБП(Форма, КассаККМ) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.НастроитьФормуПомощникаПодключенияСБП(Форма, КассаККМ);
	
КонецПроцедуры

// Процедура заполняет доступные права для текущего пользователя.
// Параметры:
//  Форма - форма нового РМК
//
Процедура ЗаполнитьТаблицуРолейПользователя(Форма) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.ЗаполнитьТаблицуРолейПользователя(Форма);
	
КонецПроцедуры

// Определяет доступность операций для торговой точки. В сценариях оплаты
// различных платежных систем существуют отличия, поэтому ряд операций могут
// быть запрещены для выполнения. Метод следует использовать для настройки
// элементов форм оплаты и возвратов и получение общих настроек интеграции.
//
// Параметры:
//  НастройкиИнтеграции - Структура - информация о доступных операциях:
//    *ОтменаЗаказа - Булево - признак доступности отмены не оплаченного
//                    заказа в платежной системе. Для выполнения операции
//                    следует использовать метод ИнтеграцияСПлатежнымиСистемами.ОтменитьЗаказНаОплату;
//    *ОтменаОплаты - Булево - признак доступности отмены оплаченного
//                    заказа (отмена транзакции) в платежной системе. Для выполнения операции
//                    следует использовать метод ИнтеграцияСПлатежнымиСистемами.ОтменитьОплату;
//    *СрокЖизниQRКода - Булево - признак доступности установки максимального
//                       срока действия QR-кода;
//    *ПлатежнаяСсылка - Булево - признак доступности использования платежной ссылки
//                       для выполнения оплаты;
//    *ВыборПлатежнойСистемыВозврата - Булево - признак доступности возврата оплаты
//                                     в платежную систему отличную от исходной. Для
//                                     получения списка доступных платежных систем следует 
//                                     использовать метод ИнтеграцияСПлатежнымиСистемами.ПлатежныеСистемыВозврата;
//    *Идентификатор - Строка - строковый идентификатор платежной системы или участника СБП;
//    *СинонимСистемы - Строка - синоним платежной системы для печати.
//    
//  Интеграция - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка выполнения операции платежной системы.
//
//
Процедура ЗаполнитьНастройкиТорговойТочки(НастройкиИнтеграции, Интеграция) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.ЗаполнитьНастройкиТорговойТочки(НастройкиИнтеграции, Интеграция);
	
КонецПроцедуры

// Формирование изображения идентификатора оплаты (QR-кода).
//
// Параметры: 
//  СтруктураQRКода - Структура - информация о QR-коде:
//    *ИдентификаторQRКода - Строка - строковый идентификатор QRКода;
//    *КартинкаQRКода - Base64 - картинка QR-кода
//    *ДанныеQRКода - Строка - адрес хранилища данных QR-кода.
//  ТорговаяТочка - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка интеграции с платежной системой;
//  QRКод - Строка - идентификатор оплаты, полученный см.
//                   ИнтеграцияСПлатежнымиСистемами.ИдентификаторОплаты;
//  УникальныйИдентификатор - УникальныйИдентификатор - идентификатор для установки поля данные qr-кода;
//
Процедура СформироватьДанныеQRКода(СтруктураQRКода, ТорговаяТочка, QRКод, УникальныйИдентификатор) Экспорт
	
	СтруктураQRКода = ИнтеграцияСПлатежнымиСистемамиУНФ.СформироватьДанныеQRКода(
		ТорговаяТочка,
		QRКод,
		УникальныйИдентификатор);
		
КонецПроцедуры

// Формирование строку, в которое добавляются все необходимые идентификаторы
// платежных систем для выполнения возврата оплаты.
//
// Параметры:
//  ИдентификаторОплаты - Строка - набор идентификаторов операции оплаты, которые должны быть переданы при возврате.
//
//  Интеграция - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка интеграции с платежной системой;
//  ДокументОплаты - ОпределяемыйТип.ДокументОперацииБИП - документ, который отражает
//                   оплату в информационной базе.
//
Процедура ЗаполнитьИдентификаторыОперацииОплаты(ИдентификаторОплаты, Интеграция, ДокументОплаты) Экспорт
	
	ИдентификаторОплаты = ИнтеграцияСПлатежнымиСистемамиУНФ.ИдентификаторыОперацииОплаты(Интеграция, ДокументОплаты);
	
КонецПроцедуры

// Формирование QR-кода для оплаты в платежной системе.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура ИдентификаторОплатыВПлатежнойСистеме(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.ИдентификаторОплатыВПлатежнойСистеме(ПараметрыПроцедуры, АдресРезультата);
	
КонецПроцедуры

// Определяет статус оплаты в платежной системе.
//
// Параметры:
//  ДокументОплаты - ОпределяемыйТип.ДокументОплатыБИП - документ, который отражает
//                    продажу в информационной базе;
//
// Возвращаемое значение:
//  Структура - см. ИнтеграцияСПлатежнымиСистемами.ОтменитьЗаказНаОплату.
//
Процедура СтатусОплатыВПлатежнойСистеме(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.СтатусОплатыВПлатежнойСистеме(ПараметрыПроцедуры, АдресРезультата);
	
КонецПроцедуры

// Формирование возврата оплаты в платежной системе.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура ВозвратОплаты(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.ВозвратОплаты(ПараметрыПроцедуры, АдресРезультата);
	
КонецПроцедуры

// Производит получение статуса возврата по документу.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура СтатусВозвратОплаты(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.СтатусВозвратОплаты(ПараметрыПроцедуры, АдресРезультата);
	
КонецПроцедуры

// Подтверждает возврат в платежной системе.
//
// Параметры:
//  РезультатОперации - Структура - см. ИнтеграцияСПлатежнымиСистемами.ПодтвердитьВозврат.
//
//  ДокументВозврата - ОпределяемыйТип.ДокументОперацииБИП - документ, который отражает
//                   оплату в информационной базе;
//  Интеграция - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка выполнения операции платежной системы.
//
Процедура ПодтвердитьВозврат(РезультатОперации, ДокументВозврата, Интеграция) Экспорт
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемамиУНФ.ПодтвердитьВозврат(ДокументВозврата, Интеграция);
	
КонецПроцедуры

// Возвращает структуру пустой ссылки на документ оплаты
//
// Параметры:
//  СтруктураНовойСсылки - Структура - информация о QR-коде:
//    *ЧекККМВОбработке - ДокументСсылка - пустая ссылка на документ чекККМ.
//    *НовыйЧек - Булево - признак, что это новая ссылка
//
//  СсылкаНаВозврат - булево - признак, что нужно вернуть ссылку на документ возврата
//
Процедура ЗаполнитьСсылкуНовогоЧекаККМ(СтруктураНовойСсылки, СсылкаНаВозврат = Ложь) Экспорт
	
	СтруктураНовойСсылки = ИнтеграцияСПлатежнымиСистемамиУНФ.ПолучитьСсылкуНовогоЧекаККМ(СсылкаНаВозврат);
	
КонецПроцедуры

// Возвращает структуру чека оплаты для автоматического выполнения возврата
//
// Параметры:
//  ПараметрыВозврата - Структура - информация о QR-коде:
//    *ИдентификаторОплаты - строка - идентификатор оплаты
//    *ВидОплатыВозврата - ОпределяемыйТип.ВидОплатыРМК - на вид оплаты возврата
//    *Организация - ОпределяемыйТип.ОрганизацияРМК - организация возврата
//    *ИдентификаторПС - строка - идентификатор платежной системы
//
//  ДокументОплаты - пустая ссылка на документ чекККМ.
//  
Процедура ЗаполнитьПараметрыДокументаОплаты(ПараметрыВозврата, ДокументОплаты) Экспорт
	
	ПараметрыВозврата = ИнтеграцияСПлатежнымиСистемамиУНФ.ПолучитьПараметрыДокументаОплаты(ДокументОплаты);
	
КонецПроцедуры

// Отменяет все выполняемые действия с операций платежной системой на форме
//
// Параметры:
//  ПараметрыОтмены - Структура - параметры выполнения длительной операции;
//  	*ДокументОплаты - ОпределяемыйТип.ДокументОплатыБИП - документ, который отражает
//                    продажу в информационной базе;
//  	*Интеграция - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка интеграции с платежной системой;
//  	*НастройкиТорговойТочки - Структура - информация о доступных операциях:
//  	*ИдентификаторЗаданияФормированияQRКода - УникальныйИдентификатор - идентификатор 
//  																   длительной операции по формированию qr-кода
//  	*ИдентификаторЗаданияПроверкиСтатуса - УникальныйИдентификатор    - идентификатор 
//  															       длительной операции по проверки статуса оплаты
//  	*ИдентификаторЗаданияВозврата - УникальныйИдентификатор           - идентификатор 
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура ОтменитьОперациюВФоне(ПараметрыОтмены, АдресРезультата) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.ОтменитьОперациюВФоне(ПараметрыОтмены, АдресРезультата);
	
КонецПроцедуры

// Заполняет текст запроса для получения подключенных настроек интеграция в регистре "Соответствие настроек интеграции"
//
// Параметры:
//  Запрос - запрос - запрос на получения данных настроек
//  ИдентификаторПлатежнойСистемы - строка - отбор по идентификатору платежной системы
//
Процедура ЗаполнитьТекстЗапросаНастройкиИнтеграции(Запрос, ИдентификаторПлатежнойСистемы = Неопределено) Экспорт
	
	Запрос.Текст = ИнтеграцияСПлатежнымиСистемамиУНФ.ТекстЗапросаНастройкиИнтеграции(ИдентификаторПлатежнойСистемы);
	
КонецПроцедуры

#КонецОбласти
