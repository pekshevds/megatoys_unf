
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеЕГАИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовЕГАИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовЕГАИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
КонецФункции

// Статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура - дополнительные параметры со свойствами:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  См. ЧекиЕГАИС.СтатусПослеПолученияДанных
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  ДополнительныеПараметры - Неопределено, Структура - дополнительные параметры расчета статуса
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
//  ДополнительныеПараметры - Неопределено, Структура - дополнительные параметры расчета статуса
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры);
	
КонецФункции

// Обновить статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура - со свойствами:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции

// Изменяет и возвращает статус документа ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ ЕГАИС.
//  ПараметрыОбновления - Структура - со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//  ДополнительныеПараметры - Неопределено, Структура - со свойствами:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияЕГАИС - новый статус документа ЕГАИС.
Функция ОбновитьСтатус(ДокументСсылка, ПараметрыОбновления, ДополнительныеПараметры) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатус(ДокументСсылка, ПараметрыОбновления, ДополнительныеПараметры);
	
КонецФункции

// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияЕГАИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Возврат ЧекиЕГАИС.ПоследовательностьОпераций(ДокументСсылка);
	
КонецФункции

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	ЧекиЕГАИС.ПриИзмененииСтатусаЧека(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
	ИнтеграцияЕГАИСПереопределяемый.ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
КонецПроцедуры

#КонецОбласти

#Область Серии

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ИнтеграцияИС.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(Метаданные.Документы.ЧекЕГАИС);
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  см. ИнтеграцияИС.ПараметрыУказанияСерий
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ИнтеграцияИС.ПараметрыУказанияСерий(Метаданные.Документы.ЧекЕГАИС, Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - см. ИнтеграцияИС.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(Метаданные.Документы.ЧекЕГАИС, ПараметрыУказанияСерий);
	
КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПоУмолчанию();
	
КонецФункции

// Возвращает статусы движений.
//
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Статусы.
//
Функция СтатусыДвиженийАкцизныхМарокСвободныйОстаток() Экспорт
	
	Возврат ЧекиЕГАИС.СтатусыДвиженийАкцизныхМарокСвободныйОстаток();
	
КонецФункции

// Возвращает статусы движений.
//
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Статусы.
//
Функция СтатусыДвиженийАкцизныхМарокКоличество() Экспорт
	
	Возврат ЧекиЕГАИС.СтатусыДвиженийАкцизныхМарокКоличество();
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Статусы.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыИнформированияЕГАИС.ОшибкаПередачи);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
// 
// Параметры:
//  ТребуетсяПовторноеОформление - Булево - Требуется повторное оформление
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СтатусыИнформированияЕГАИС -- Статусы.
Функция КонечныеСтатусы(ТребуетсяПовторноеОформление = Истина) Экспорт
	
	Статусы = Новый Массив;
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат ЧекиЕГАИС.ДальнейшееДействиеПоУмолчанию();
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСЕГАИС

// Возвращает массив дальнейших действий по взаимодействию ЕГАИС действий.
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - дальшейшие действия
//
Функция ВсеТребующиеДействия() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ВыполнитеОбмен);
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает массив дальнейших действий ожидания взаимодействий ЕГАИС.
// 
// Возвращаемое значение:
// 	Массив Из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Массив дальшейших действий.
//
Функция ВсеТребующиеОжидания() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОформите() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	 0 КАК КоличествоДокументов
	|";
	ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаЧекЕГАИСОформите(ТекстЗапроса);
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЧекЕГАИС КАК ЧекЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ЧекЕГАИС.Ссылка
	|ГДЕ
	|	ЧекЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ЧекЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеДействия)
	|	И (ЧекЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ЧекЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|";
	ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаЧекЕГАИСОтработайте(ТекстЗапроса);
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЧекЕГАИС КАК ЧекЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ЧекЕГАИС.Ссылка
	|ГДЕ
	|	ЧекЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ЧекЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеОжидания)
	|	И (ЧекЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ЧекЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|";
	ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаЧекЕГАИСОжидайте(ТекстЗапроса);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияЕГАИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Операция ЕГАИС
//  ДополнительныеПараметры - Неопределено, Структура - Дополнительные параметры формирования XML
//
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные Тогда
		
		Возврат ЧекЕГАИСXML(ДокументСсылка);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СканированиеАлкогольнойПродукции

Функция ТаблицаАлкогольнойПродукцииКОпределениюСправок2(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЧекЕГАИСТовары.АлкогольнаяПродукция                  КАК АлкогольнаяПродукция,
	|	ЧекЕГАИСТовары.Номенклатура                          КАК Номенклатура,
	|	ЧекЕГАИСТовары.Характеристика                        КАК Характеристика,
	|	ЧекЕГАИСТовары.Серия                                 КАК Серия,
	|	ЗНАЧЕНИЕ(Справочник.Справки2ЕГАИС.ПустаяСсылка)      КАК Справка2,
	|	СУММА(ЧекЕГАИСТовары.Количество)                     КАК Количество,
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ) КАК Маркируемая
	|ИЗ
	|	Документ.ЧекЕГАИС.Товары КАК ЧекЕГАИСТовары
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО ЧекЕГАИСТовары.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции = ВидыАлкогольнойПродукции.Ссылка
	|
	|ГДЕ
	|	ЧекЕГАИСТовары.Ссылка = &ДокументСсылка
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЧекЕГАИСТовары.Номенклатура,
	|	ЧекЕГАИСТовары.АлкогольнаяПродукция,
	|	ЧекЕГАИСТовары.Характеристика,
	|	ЧекЕГАИСТовары.Серия,
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ)";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ШтрихкодыУпаковок(ДокументСсылка, ЗаполнитьСправки2ИзРегистра = Ложь) Экспорт
	
	Возврат ШтрихкодированиеЕГАИС.ВложенныеШтрихкодыУпаковокПоДокументу(ДокументСсылка, ЗаполнитьСправки2ИзРегистра);
	
КонецФункции

Функция ОбработатьДанныеШтрихкода(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды = Неопределено) Экспорт
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ДанныеШтрихкода.ТипУпаковки) Тогда
		
		Возврат ОбработатьДанныеШтрихкодаЛогистическойУпаковки(Форма, ДанныеШтрихкода, ВложенныеШтрихкоды, ПараметрыСканирования);
		
	ИначеЕсли ДанныеШтрихкода.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
		
		Возврат ОбработатьДанныеШтрихкодаПотребительскойУпаковки(Форма, ДанныеШтрихкода, ПараметрыСканирования);
		
	ИначеЕсли ДанныеШтрихкода.ТипШтрихкода = Перечисления.ТипыШтрихкодов.DataMatrix Тогда
		
		Возврат ОбработатьДанныеШтрихкодаСНомеромИСерией(Форма, ДанныеШтрихкода, ПараметрыСканирования);
		
	ИначеЕсли ДанныеШтрихкода.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская
		И ДанныеШтрихкода.МаркируемаяПродукция <> Истина
		И ДанныеШтрихкода.ЭтоШтрихкодНоменклатуры Тогда
		
		Возврат ОбработатьДанныеШтрихкодаПотребительскойУпаковки(Форма, ДанныеШтрихкода, ПараметрыСканирования);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОбработатьДанныеШтрихкодаПотребительскойУпаковки(Форма, ДанныеШтрихкода, ПараметрыСканирования) Экспорт
	
	Возврат ЧекиЕГАИС.ОбработатьДанныеШтрихкодаПотребительскойУпаковки(Форма, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецФункции

Функция ОбработатьДанныеШтрихкодаЛогистическойУпаковки(Форма, ДанныеШтрихкода, ВложенныеШтрихкоды, ПараметрыСканирования) Экспорт
	
	Возврат ЧекиЕГАИС.ОбработатьДанныеШтрихкодаЛогистическойУпаковки(Форма, ДанныеШтрихкода, ВложенныеШтрихкоды, ПараметрыСканирования);
	
КонецФункции

Функция ОбработатьДанныеШтрихкодаСНомеромИСерией(Форма, ДанныеШтрихкода, ПараметрыСканирования) Экспорт
	
	Возврат ЧекиЕГАИС.ОбработатьДанныеШтрихкодаСНомеромИСерией(Форма, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецФункции

#КонецОбласти

#Область ЗавершениеПроверкиИПодбораМаркируемойПродукции

// Отражает результаты проверки и подбора в документе, из которого была вызвана соответствующая форма.
//
// Параметры:
// 	ПараметрыОкончанияПроверки - См. Обработки.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.ЗафиксироватьРезультатПроверкиИПодбора
Процедура ОтразитьРезультатыПроверкиИПодбора(ПараметрыОкончанияПроверки) Экспорт
	
	ТаблицаНеМаркируемойПродукции = ПараметрыОкончанияПроверки.ТаблицаНеМаркируемойПродукции;
	ДеревоМаркируемойПродукции    = ПараметрыОкончанияПроверки.ДеревоМаркируемойПродукции;
	
	ДокументОбъект = ПараметрыОкончанияПроверки.ПроверяемыйДокумент.ПолучитьОбъект();
	ДокументОбъект.СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.Завершено;
	
	ОчиститьДанныеПередЗаполнением(ДокументОбъект);
	
	ПараметрыЗаполнения = АкцизныеМаркиЕГАИС.ПараметрыЗаполненияТоваровИАкцизныхМарок(ДокументОбъект, Ложь);
	ПараметрыЗаполнения.ЕстьСправка2 = Ложь;
	
	ЧекиЕГАИС.ЗаполнитьТоварыИАкцизныеМарки(
		ДокументОбъект, ДеревоМаркируемойПродукции, ПараметрыЗаполнения);
	
	ЧекиЕГАИС.ЗаполнитьНеМаркируемыеТовары(
		ДокументОбъект, ТаблицаНеМаркируемойПродукции, ПараметрыЗаполнения);
	
	ОбработатьСтрокиТЧ(ДокументОбъект, ПараметрыЗаполнения);
	
	СтруктураПоискаПустыхСтрок = Новый Структура("Количество", 0);
	ПустыеСтроки = ДокументОбъект.Товары.НайтиСтроки(СтруктураПоискаПустыхСтрок);
	
	Для Каждого ПустаяСтрока Из ПустыеСтроки Цикл
		ДокументОбъект.Товары.Удалить(ПустаяСтрока);
	КонецЦикла;
	
	Если ДокументОбъект.Проведен Тогда
		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли;
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
// 
// Параметры:
//  Ограничение Ограничение
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ВЫБОР КОГДА ОрганизацияЕГАИС.Сопоставлено И ОрганизацияЕГАИС.СоответствуетОрганизации Тогда ЗначениеРазрешено(ОрганизацияЕГАИС.Контрагент)
	|	КОГДА ОрганизацияЕГАИС.Сопоставлено И НЕ ОрганизацияЕГАИС.СоответствуетОрганизации Тогда ЗначениеРазрешено(ОрганизацияЕГАИС.ТорговыйОбъект)
	|	ИНАЧЕ ИСТИНА КОНЕЦ ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияЕГАИС

Функция ЧекЕГАИСXML(ДокументСсылка)
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	ЕГАИСПрисоединенныеФайлы.Документ      КАК Ссылка,
		|	КОЛИЧЕСТВО(ЕГАИСПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомер
		|ПОМЕСТИТЬ Версии
		|ИЗ
		|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
		|ГДЕ
		|	ЕГАИСПрисоединенныеФайлы.Документ = &Ссылка
		|	И ЕГАИСПрисоединенныеФайлы.Операция = &Операция
		|	И ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
		|СГРУППИРОВАТЬ ПО
		|	ЕГАИСПрисоединенныеФайлы.Документ
		|;
		|
		|//#РезультатЗапроса#////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Шапка.Номер                           КАК Номер,
		|	Шапка.Дата                            КАК Дата,
		|	ЕСТЬNULL(Версии.ПоследнийНомер, 0)    КАК ПоследнийНомерВерсии,
		|	Шапка.ДокументОснование               КАК ДокументОснование,
		|	Шапка.ВидОперации                     КАК ВидОперации,
		|	Шапка.ОрганизацияЕГАИС                КАК ОрганизацияЕГАИС,
		|	Шапка.ОрганизацияЕГАИС.Код            КАК ИдентификаторФСРАР,
		|	Шапка.ОрганизацияЕГАИС.ФорматОбмена   КАК ФорматОбмена,
		|	Шапка.ОрганизацияЕГАИС.ИНН            КАК ИНН,
		|	Шапка.ОрганизацияЕГАИС.КПП            КАК КПП,
		|	Шапка.ОрганизацияЕГАИС.ТорговыйОбъект КАК ТорговыйОбъект,
		|	Шапка.Ответственный                   КАК Ответственный,
		|	Шапка.НомерСмены                      КАК НомерСмены,
		|	Шапка.НомерЧекаККМ                    КАК НомерЧекаККМ,
		|	Шапка.СерийныйНомерККМ                КАК СерийныйНомерККМ
		|ИЗ
		|	Документ.ЧекЕГАИС КАК Шапка,
		|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
		|		ПО Шапка.Ссылка = Версии.Ссылка
		|ГДЕ
		|	Шапка.Ссылка = &Ссылка
		|",
		"Шапка");
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	Товары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
		|	Товары.Номенклатура         КАК Номенклатура,
		|	Товары.Характеристика       КАК Характеристика,
		|	Товары.Серия                КАК Серия
		|ПОМЕСТИТЬ ВТТовары
		|ИЗ
		|	Документ.ЧекЕГАИС.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка = &Ссылка
		|");
	
	ТекстыЗапроса.Добавить(
		ИнтеграцияЕГАИС.ТекстЗапросаВТКоэффициентыПересчетаВЕдиницыЕГАИС(
			"ВТТовары",
			"ВТКоэффициентыПересчетаВЕдиницыЕГАИС"));
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	Товары.ИдентификаторСтроки              КАК ИдентификаторСтроки,
		|	Товары.НомерСтроки                      КАК НомерСтроки,
		|	Товары.Количество
		|	* ЕСТЬNULL(ЕдиницыЕГАИС.Коэффициент, 1) КАК Количество,
		|	Товары.Цена                             КАК Цена,
		|	Товары.Штрихкод                         КАК Штрихкод,
		|	Товары.АлкогольнаяПродукция             КАК АлкогольнаяПродукция,
		|	Товары.АлкогольнаяПродукция.Объем       КАК Объем
		|ИЗ
		|	Документ.ЧекЕГАИС.Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоэффициентыПересчетаВЕдиницыЕГАИС КАК ЕдиницыЕГАИС
		|		ПО ЕдиницыЕГАИС.АлкогольнаяПродукция = Товары.АлкогольнаяПродукция
		|		 И ЕдиницыЕГАИС.Номенклатура = Товары.Номенклатура
		|		 И ЕдиницыЕГАИС.Характеристика = Товары.Характеристика
		|		 И ЕдиницыЕГАИС.Серия = Товары.Серия
		|ГДЕ
		|	Товары.Ссылка = &Ссылка
		|",
		"Товары");
	
	ПараметрыФормированияТекстаЗапроса = ШтрихкодированиеЕГАИС.ПараметрыФормированияТекстаЗапросаВложенныхШтрихкодов();
	ПараметрыФормированияТекстаЗапроса.ДокументСсылка                  = ДокументСсылка;
	ПараметрыФормированияТекстаЗапроса.ИспользоватьИдентификаторСтроки = Истина;
	ТекстыЗапроса.Добавить(
		ШтрихкодированиеЕГАИС.ТекстЗапросаВложенныхШтрихкодовПоДокументу(ПараметрыФормированияТекстаЗапроса),
		"ВложенныеШтрихкоды");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Перечисления.ВидыДокументовЕГАИС.ЧекККМ);
	Запрос.УстановитьПараметр("ПустыеЗначенияНоменклатуры", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("Номенклатура"));
	РезультатыЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, ТекстыЗапроса);
	
	Возврат ЧекиЕГАИС.ЧекЕГАИСXML(ДокументСсылка, РезультатыЗапроса, МенеджерВременныхТаблиц);
	
КонецФункции

#КонецОбласти

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры);
	
	ИнтеграцияИС.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата              КАК Период,
	|	ДанныеШапки.ОрганизацияЕГАИС  КАК ОрганизацияЕГАИС,
	|	ДанныеШапки.Ссылка            КАК Ссылка,
	|	СтатусыДокументовЕГАИС.Статус КАК СтатусОбработки
	|ИЗ
	|	Документ.ЧекЕГАИС КАК ДанныеШапки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО СтатусыДокументовЕГАИС.Документ = ДанныеШапки.Ссылка
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", Реквизиты.ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("СтатусОбработки",  Реквизиты.СтатусОбработки);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если Не ИнтеграцияИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = "";
	ИнтеграцияЕГАИСПереопределяемый.ПриЗаполненииТекстаЗапросаДвижениеСерийТоваров(ТекстЗапроса, Метаданные.Документы.ЧекЕГАИС.Имя);
	
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
	
	Если НЕ ИнтеграцияИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	&Период                            КАК Период,
	|	ТаблицаАкцизныеМарки.Ссылка        КАК Ссылка,
	|	&ОрганизацияЕГАИС                  КАК ОрганизацияЕГАИС,
	|	ТаблицаАкцизныеМарки.Справка2      КАК Справка2,
	|	Справки2ЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаАкцизныеМарки.АкцизнаяМарка) КАК Количество,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаАкцизныеМарки.АкцизнаяМарка) КАК СвободныйОстаток
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК ТаблицаАкцизныеМарки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	|			ПО Справки2ЕГАИС.Ссылка = ТаблицаАкцизныеМарки.Справка2
	|ГДЕ
	|	ТаблицаАкцизныеМарки.Ссылка = &Ссылка
	|	И &СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияЕГАИС.ПереданВУТМ)
	|	И ТаблицаАкцизныеМарки.Справка2 <> ЗНАЧЕНИЕ(Справочник.Справки2ЕГАИС.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаАкцизныеМарки.Ссылка,
	|	ТаблицаАкцизныеМарки.Справка2,
	|	Справки2ЕГАИС.АлкогольнаяПродукция
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
	КомандаОтчет = Отчеты.АнализРасхожденийПриДвиженииАлкогольнойПродукции.ДобавитьКомандуОтчета(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.Порядок = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//   МассивОбъектов        - Массив          - Массив ссылок на объекты которые нужно распечатать (входящий).
//   ПараметрыПечати       - Структура       - Структура дополнительных параметров печати (входящий).
//   КоллекцияПечатныхФорм - ТаблицаЗначений - Сформированные табличные документы (исходящий).
//   ОбъектыПечати         - Строка          - Имена макетов, перечисленные через запятую (входящий).
//   ПараметрыВывода       - Структура       - Параметры сформированных табличных документов (исходящий).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЧекЕГАИС КАК Таблица
	|ГДЕ
	|	Таблица.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЧекаЕГАИС.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизныеМарки.Ссылка
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК АкцизныеМарки
	|ГДЕ
	|	АкцизныеМарки.КодАкцизнойМарки <> """"
	|	И АкцизныеМарки.АкцизнаяМарка = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ЧекЕГАИС";
	МетаданныеДокумента = Метаданные.Документы.ЧекЕГАИС;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбработкаЗавершена = Истина;
			Если НЕ ЗначениеЗаполнено(ДокументОбъект.ВидОперации) Тогда
				ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийЧекаЕГАИС.РеализацияЮридическомуЛицуСБезналичнойОплатой;
			КонецЕсли;
			Для каждого ТекСтрока Из ДокументОбъект.АкцизныеМарки Цикл
				Если ЗначениеЗаполнено(ТекСтрока.КодАкцизнойМарки) Тогда
					ТекСтрока.АкцизнаяМарка = Справочники.ШтрихкодыУпаковокТоваров.ПолучитьПоЗначениюШтрихкода(ТекСтрока.КодАкцизнойМарки);
					Если НЕ ЗначениеЗаполнено(ТекСтрока.АкцизнаяМарка) Тогда
						ОбработкаЗавершена = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если ОбработкаЗавершена Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
				ЗафиксироватьТранзакцию();
			Иначе
				ОтменитьТранзакцию();
			КонецЕсли;
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеДокумента,
				Выборка.Ссылка,
				ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляГенерацииАкцизныхМарок(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизныеМарки.Ссылка
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК АкцизныеМарки
	|ГДЕ
	|	АкцизныеМарки.КодАкцизнойМарки <> """"
	|	И АкцизныеМарки.АкцизнаяМарка = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюГенерацияАкцизныхМарок(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ЧекЕГАИС";
	МетаданныеДокумента = Метаданные.Документы.ЧекЕГАИС;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		
		Попытка
			
			ОбработкаСсылкиНачата = Ложь;
			ОбработкаСсылкиЗавершена = Ложь;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбработкаСсылкиНачата = Истина;
			
			Для каждого ТекСтрока Из ДокументОбъект.АкцизныеМарки Цикл
				Если ЗначениеЗаполнено(ТекСтрока.КодАкцизнойМарки) И НЕ ЗначениеЗаполнено(ТекСтрока.АкцизнаяМарка) Тогда
					СтрокаТовар = ДокументОбъект.Товары.Найти(ТекСтрока.ИдентификаторСтроки, "ИдентификаторСтроки");
					Если СтрокаТовар = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					
					ШтрихкодированиеЕГАИС.ПолучитьСгенерироватьАкцизнуюМарку(ТекСтрока.КодАкцизнойМарки,
						СтрокаТовар.Номенклатура,
						СтрокаТовар.Характеристика,
						Истина);
				КонецЕсли;
			КонецЦикла;
		
			ОбработкаСсылкиЗавершена = Истина;
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			Если НЕ ОбработкаСсылкиНачата Тогда
				ТекстСообщения = НСтр("ru = 'Не удалось заблокировать документ: %Ссылка% по причине: %Причина%'",
					ОбщегоНазначения.КодОсновногоЯзыка());
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ИначеЕсли НЕ ОбработкаСсылкиЗавершена Тогда
				ТекстСообщения = НСтр("ru = 'Не удалось сгенерировать акцизную марку: %Ключ% по причине: %Причина%'",
					ОбщегоНазначения.КодОсновногоЯзыка());
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ключ%", ТекСтрока.КодАкцизнойМарки);
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Ссылка% по причине: %Причина%'",
					ОбщегоНазначения.КодОсновногоЯзыка());
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			КонецЕсли;
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеДокумента,
				Выборка.Ссылка,
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Возврат;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ЗавершениеПроверкиИПодбораМаркируемойПродукцииСлужебный

Процедура ОчиститьДанныеПередЗаполнением(ДокументОбъект)
	
	ДокументОбъект.АкцизныеМарки.Очистить();
	
	ИменаКолонокДляОчистки = Новый Массив();
	ИменаКолонокДляОчистки.Добавить("Количество");
	ИменаКолонокДляОчистки.Добавить("КоличествоУпаковок");
	
	Для Каждого СтрокаТовары Из ДокументОбъект.Товары Цикл
		Для Каждого ИмяКолонки Из ИменаКолонокДляОчистки Цикл
			СтрокаТовары[ИмяКолонки] = 0;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьСтрокиТЧ(ДокументОбъект, ПараметрыЗаполнения)
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий(ДокументОбъект);
	ПустойСклад = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Склад");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", ПустойСклад, ПараметрыУказанияСерий));
	СтруктураДействий.Вставить("ЗаполнитьАлкогольнуюПродукцию", ПараметрыЗаполнения);
	
	Для Каждого СтрокаТЧ Из ПараметрыЗаполнения.ДобавленныеСтроки Цикл
		
		ИнтеграцияИСПереопределяемый.ОбработатьСтрокуТабличнойЧасти(СтрокаТЧ, СтруктураДействий);
		
	КонецЦикла;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьСумму");
	
	Для Каждого СтрокаТЧ Из ПараметрыЗаполнения.ИзмененныеСтроки Цикл
		
		ИнтеграцияИСПереопределяемый.ОбработатьСтрокуТабличнойЧасти(СтрокаТЧ, СтруктураДействий);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
