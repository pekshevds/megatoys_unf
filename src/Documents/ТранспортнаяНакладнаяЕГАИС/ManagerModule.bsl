#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ТранспортнаяНакладнаяЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеЕГАИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ТранспортнаяНакладная Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.КПередаче);
		
	ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТранспортнойНакладной Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ЗапросНаОтменуПроведенияКПередаче);
		
	Иначе
		ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Если СтатусОбработки = Неопределено Тогда
		СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ПереданоВУТМ;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ТранспортнаяНакладная Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ПереданВУТМ;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеКвитанцииПолученЕГАИС);
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеКвитанцииПроведенЕГАИС);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, СтатусыБазовыйПроцесс);
		
	ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТранспортнойНакладной Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ЗапросНаОтменуПроведенияПереданВУТМ;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеКвитанцииПолученЕГАИС);
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеКвитанцииПроведенЕГАИС);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ЗапросНаОтменуПроведенияОшибка;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения);
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, СтатусыБазовыйПроцесс);
		
	Иначе
		ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура - Структура со свойствами:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
	СтатусыБазовыйПроцесс.Принят           = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ПроведенЕГАИС;
	СтатусыБазовыйПроцесс.Обрабатывается   = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ОбрабатываетсяЕГАИС;
	СтатусыБазовыйПроцесс.ОшибкаПроведения = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ОшибкаПроведенияЕГАИС;
	СтатусыБазовыйПроцесс.Ошибка           = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ОшибкаПередачи;
	СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
	СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется);
	СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения);
	СтатусыБазовыйПроцесс.УведомлениеОРегистрацииДвижения = Ложь;
	
	СтатусыЗапросНаОтменуПроведения = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
	СтатусыЗапросНаОтменуПроведения.Принят           = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.Отменен;
	СтатусыЗапросНаОтменуПроведения.Обрабатывается   = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ЗапросНаОтменуПроведенияОбрабатываетсяЕГАИС;
	СтатусыЗапросНаОтменуПроведения.ОтменаПроведения = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.Отменен;
	СтатусыЗапросНаОтменуПроведения.ОшибкаПроведения = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ЗапросНаОтменуПроведенияОшибка;
	СтатусыЗапросНаОтменуПроведения.Ошибка           = Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ЗапросНаОтменуПроведенияОшибка;
	СтатусыЗапросНаОтменуПроведения.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения);
	СтатусыЗапросНаОтменуПроведения.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	СтатусыЗапросНаОтменуПроведения.УведомлениеОРегистрацииДвижения = Ложь;
	
	ВыполнитьРасчетТекущегоСостояния = Истина;
	Если ДополнительныеПараметры <> Неопределено
		И ДополнительныеПараметры.Свойство("ТекущееСостояние")
		И ДополнительныеПараметры.ТекущееСостояние <> Неопределено Тогда
		ВыполнитьРасчетТекущегоСостояния = ДополнительныеПараметры.ТекущееСостояние;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС Тогда
		
		Статусы = Неопределено;
		Если ДополнительныеПараметры.ОперацияКвитанции = Перечисления.ВидыДокументовЕГАИС.ТранспортнаяНакладная Тогда
			
			Статусы = СтатусыБазовыйПроцесс;
			
		ИначеЕсли ДополнительныеПараметры.ОперацияКвитанции = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТранспортнойНакладной Тогда
			
			Статусы = СтатусыЗапросНаОтменуПроведения;
			
		Иначе
			ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
		КонецЕсли;
		
		Если Статусы <> Неопределено Тогда
			ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыПриПолученииКвитанции(
				ДокументСсылка,
				"КвитанцияПолученЕГАИС", ДополнительныеПараметры.СтатусОбработки,
				Статусы, ВыполнитьРасчетТекущегоСостояния);
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС Тогда
		
		Статусы = Неопределено;
		Если ДополнительныеПараметры.ОперацияКвитанции = Перечисления.ВидыДокументовЕГАИС.ТранспортнаяНакладная Тогда
			
			Статусы = СтатусыБазовыйПроцесс;
			
		ИначеЕсли ДополнительныеПараметры.ОперацияКвитанции = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТранспортнойНакладной Тогда
			
			Статусы = СтатусыЗапросНаОтменуПроведения;
			
		Иначе
			ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
		КонецЕсли;
		
		Если Статусы <> Неопределено Тогда
			ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыПриПолученииКвитанции(
				ДокументСсылка,
				"КвитанцияПроведенЕГАИС", ДополнительныеПараметры.СтатусОбработки,
				Статусы, ВыполнитьРасчетТекущегоСостояния);
		КонецЕсли;
		
	Иначе
		ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура - со свойствами:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Изменяет и возвращает статус документа ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Документ, для которого требуется обновить статус.
//  ПараметрыОбновления - Структура - со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//  ДополнительныеПараметры - Неопределено, Структура - со свойствами:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - новый статус документа ЕГАИС.
Функция ОбновитьСтатус(ДокументСсылка, ПараметрыОбновления, ДополнительныеПараметры) Экспорт
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияЕГАИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица = ИнтеграцияЕГАИС.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящий = Перечисления.ТипыЗапросовИС.Исходящий;
	
	ИнтеграцияЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящий, Перечисления.ВидыДокументовЕГАИС.ТранспортнаяНакладная, ДокументСсылка, Истина, Истина);
	
	ИнтеграцияЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящий, Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТранспортнойНакладной, ДокументСсылка, Истина, Истина);
	
	Возврат Таблица;
	
КонецФункции

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТранспортнаяНакладнаяЕГАИС - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Предыдущий статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиТранспортныхНакладныхЕГАИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.Черновик;
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив - Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ОшибкаПередачи);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
//
// Возвращаемое значение:
//  Массив - Конечные статусы.
//
Функция КонечныеСтатусы(ТребуетсяПовторноеОформление = Истина) Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.Отменен);
	Статусы.Добавить(Перечисления.СтатусыОбработкиТранспортныхНакладныхЕГАИС.ОшибкаПроведенияЕГАИС);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные;
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСЕГАИС

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - дальшейшие действия
//
Функция ВсеТребующиеДействия() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ВыполнитеОбмен);
	
	Возврат МассивДействий;
	
КонецФункции

Функция ВсеТребующиеОжидания() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеКвитанцииПолученЕГАИС);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеКвитанцииПроведенЕГАИС);
	
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
	|	Документ.ТранспортнаяНакладнаяЕГАИС КАК ТранспортнаяНакладнаяЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ТранспортнаяНакладнаяЕГАИС.Ссылка
	|ГДЕ
	|	ТранспортнаяНакладнаяЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ТранспортнаяНакладнаяЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеДействия)
	|	И (ТранспортнаяНакладнаяЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ТранспортнаяНакладнаяЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|";
	ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаВозвратИзРегистра2ЕГАИСОтработайте(ТекстЗапроса);
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
	|	Документ.ТранспортнаяНакладнаяЕГАИС КАК ТранспортнаяНакладнаяЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ТранспортнаяНакладнаяЕГАИС.Ссылка
	|ГДЕ
	|	ТранспортнаяНакладнаяЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ТранспортнаяНакладнаяЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеОжидания)
	|	И (ТранспортнаяНакладнаяЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ТранспортнаяНакладнаяЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|";
	ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаВозвратИзРегистра2ЕГАИСОжидайте(ТекстЗапроса);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияЕГАИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ.
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие ЕГАИС.
//  ДополнительныеПараметры - Произвольный - не используется.
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные Тогда
		
		Возврат ТранспортнаяНакладнаяЕГАИСXML(ДокументСсылка);
		
	ИначеЕсли ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения Тогда
		
		Возврат ОтменаТранспортнойНакладнойЕГАИСXML(ДокументСсылка);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
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

Функция ТранспортнаяНакладнаяЕГАИСXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Операция = Перечисления.ВидыДокументовЕГАИС.ТранспортнаяНакладная;
	
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
		|	Шапка.Номер                        КАК Номер,
		|	Шапка.Дата                         КАК Дата,
		|	ЕСТЬNULL(Версии.ПоследнийНомер, 0) КАК ПоследнийНомерВерсии,
		|	Шапка.Идентификатор                КАК Идентификатор,
		|	Шапка.ДокументОснование            КАК ДокументОснование,
		|	Шапка.ТоварноТранспортнаяНакладная                    КАК ТоварноТранспортнаяНакладная,
		|	Шапка.ТоварноТранспортнаяНакладная.ИдентификаторЕГАИС КАК ТоварноТранспортнаяНакладнаяИдентификатор,
		|	
		|	&Операция                        КАК ВидОперации,
		|	Шапка.НомерТН                    КАК НомерТН,
		|	Шапка.ДатаТН                     КАК ДатаТН,
		|	Шапка.Перевозчик                 КАК Перевозчик,
		|	Шапка.ТипТранспорта              КАК ТипТранспорта,
		|	Шапка.ТоварВПутиПринадлежитГрузополучателю КАК ТоварВПутиПринадлежитГрузополучателю,
		|	Шапка.НомерТранспортногоСредства КАК НомерТранспортногоСредства,
		|	Шапка.Прицеп                     КАК Прицеп,
		|	Шапка.Заказчик                   КАК Заказчик,
		|	Шапка.Водитель                   КАК Водитель,
		|	Шапка.ПунктПогрузки              КАК ПунктПогрузки,
		|	Шапка.ПунктРазгрузки             КАК ПунктРазгрузки,
		|	Шапка.Перенаправление            КАК Перенаправление,
		|	Шапка.Экспедитор                 КАК Экспедитор,
		|	
		|	Шапка.Количество                            КАК Количество,
		|	ВЫРАЗИТЬ(Шапка.Комментарий КАК Строка(200)) КАК Комментарий,
		|	
		|	Шапка.ОрганизацияЕГАИС              КАК ОрганизацияЕГАИС,
		|	Шапка.ОрганизацияЕГАИС.Код          КАК ИдентификаторФСРАР,
		|	Шапка.ОрганизацияЕГАИС.ФорматОбмена КАК ФорматОбмена,
		|	Шапка.Ответственный                 КАК Ответственный
		|ИЗ
		|	Документ.ТранспортнаяНакладнаяЕГАИС КАК Шапка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
		|		ПО Шапка.Ссылка = Версии.Ссылка
		|ГДЕ
		|	Шапка.Ссылка = &Ссылка
		|",
		"Шапка");
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	ТранспортныеНакладные.ДокументОснование                    КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладные.ДокументОснование.ИдентификаторЕГАИС КАК ТранспортнаяНакладнаяИдентификатор
		|ИЗ
		|	Документ.ТранспортнаяНакладнаяЕГАИС.ТранспортныеНакладные КАК ТранспортныеНакладные
		|ГДЕ
		|	ТранспортныеНакладные.Ссылка = &Ссылка
		|",
		"ТранспортныеНакладные");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Операция);
	РезультатыЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, ТекстыЗапроса);
	
	//@skip-warning
	Шапка = РезультатыЗапроса["Шапка"].Выбрать();
	//@skip-warning
	ТранспортныеНакладные = РезультатыЗапроса["ТранспортныеНакладные"].Выгрузить();
	
	Если Не Шапка.Следующий() Тогда
		
		СообщениеXML = ИнтеграцияЕГАИС.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияЕГАИС.ОписаниеОперацииПередачиДанных(
			Операция, ДокументСсылка);
		
		ИнтеграцияЕГАИСКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, НСтр("ru = 'Нет данных для выгрузки.'"));
		
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	ФорматОбмена = ИнтеграцияЕГАИСКлиентСервер.ФорматОбмена(Шапка.ФорматОбмена);
	
	СообщениеXML = ИнтеграцияЕГАИС.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияЕГАИС.ОписаниеОперацииПередачиДанных(
		Операция, ДокументСсылка, НомерВерсии);
	
	ПространствоИмен = Перечисления.ВидыДокументовЕГАИС.ПространствоИмен(Операция, ФорматОбмена);
	ИмяТипа          = Перечисления.ВидыДокументовЕГАИС.ТипЕГАИС(Операция, ФорматОбмена);
	
	Если ПространствоИмен = Неопределено
		Или ИмяТипа = Неопределено Тогда
		ИнтеграцияЕГАИСКлиентСервер.ДобавитьТекстОшибки(
			СообщениеXML,
			СтрШаблон(НСтр("ru = 'Операция не поддерживается в версии формата обмена: %1.'"), ФорматОбмена));
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
	КонецЕсли;
	
	#Область ТранспортнаяНакладная
	
	ДокументXDTO = ИнтеграцияЕГАИС.ОбъектXDTO(ПространствоИмен, "Route");
	
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "NUMBER", СокрЛП(Шапка.НомерТН),  СообщениеXML);
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "Date",   Шапка.ДатаТН,           СообщениеXML);
	
	Если Шапка.ТоварВПутиПринадлежитГрузополучателю Тогда
		ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "Ownership", 1, СообщениеXML);
	Иначе
		ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "Ownership", 0, СообщениеXML);
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(
		ДокументXDTO, "WBRegId", Шапка.ТоварноТранспортнаяНакладнаяИдентификатор, СообщениеXML);
	
	ДокументXDTO.ParentRoutes = ИнтеграцияИС.ОбъектXDTOПоИмениТипа(ДокументXDTO, "ParentRoutes");
	Для Каждого ЭлементДанных Из ТранспортныеНакладные Цикл
		ДокументXDTO.ParentRoutes.RouteId.Добавить(ЭлементДанных.ТранспортнаяНакладнаяИдентификатор);
	КонецЦикла;
	Если ТранспортныеНакладные.Количество() = 0 Тогда
		ДокументXDTO.ParentRoutes.RouteId.Добавить(Шапка.ТоварноТранспортнаяНакладнаяИдентификатор);
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(
		ДокументXDTO, "TRAN_TYPE",
		ИнтеграцияЕГАИС.ТипТранспорта(Шапка.ТипТранспорта, "Route"), СообщениеXML);
	
	ПоляДоставки = Новый Соответствие;
	
	ПоляДоставки.Вставить("TRAN_COMPANY",     "Перевозчик");
	ПоляДоставки.Вставить("TRAN_CAR",         "НомерТранспортногоСредства");
	ПоляДоставки.Вставить("TRAN_TRAILER",     "Прицеп");
	ПоляДоставки.Вставить("TRAN_CUSTOMER",    "Заказчик");
	ПоляДоставки.Вставить("TRAN_DRIVER",      "Водитель");
	ПоляДоставки.Вставить("TRAN_LOADPOINT",   "ПунктПогрузки");
	ПоляДоставки.Вставить("TRAN_UNLOADPOINT", "ПунктРазгрузки");
	ПоляДоставки.Вставить("TRAN_REDIRECT",    "Перенаправление");
	ПоляДоставки.Вставить("TRAN_FORWARDER",   "Экспедитор");
	
	Для Каждого СвойствоДоставкиXDTO Из ДокументXDTO.Свойства() Цикл
		
		ИмяПоляДанных = ПоляДоставки[СвойствоДоставкиXDTO.Имя];
		Если Не ИмяПоляДанных = Неопределено И Не Шапка[ИмяПоляДанных] = Неопределено Тогда
			
			МаксДлина = 0;
			Для Каждого Фасет Из СвойствоДоставкиXDTO.Тип.Фасеты Цикл
				Если Фасет.Вид = ВидФасетаXDTO.МаксДлина Тогда
					МаксДлина = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Фасет.Значение);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если МаксДлина > 0 Тогда
				ЗначениеСвойства = Лев(Шапка[ИмяПоляДанных], МаксДлина);
			Иначе
				ЗначениеСвойства = Шапка[ИмяПоляДанных];
			КонецЕсли;
			
			ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(
				ДокументXDTO, СвойствоДоставкиXDTO.Имя,
				ЗначениеСвойства, СообщениеXML);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "Quantity", Шапка.Количество, СообщениеXML);
	
	#КонецОбласти
	
	ТекстСообщенияXML = ИнтеграцияЕГАИС.ОбъектXDTOВXML(ДокументXDTO, Шапка.ИдентификаторФСРАР, ПространствоИмен, ИмяТипа);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.ТипСообщения      = Перечисления.ТипыЗапросовИС.Исходящий;
	СообщениеXML.ОрганизацияЕГАИС  = Шапка.ОрганизацияЕГАИС;
	СообщениеXML.Операция          = Операция;
	СообщениеXML.ФорматОбмена      = ФорматОбмена;
	СообщениеXML.Документ          = ДокументСсылка;
	СообщениеXML.ДокументОснование = Шапка.ТоварноТранспортнаяНакладная;
	СообщениеXML.Версия            = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция ОтменаТранспортнойНакладнойЕГАИСXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТранспортнойНакладной;
	
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
		|	Шапка.Номер                        КАК Номер,
		|	Шапка.Дата                         КАК Дата,
		|	ЕСТЬNULL(Версии.ПоследнийНомер, 0) КАК ПоследнийНомерВерсии,
		|	Шапка.Идентификатор                КАК Идентификатор,
		|	Шапка.ДокументОснование            КАК ДокументОснование,
		|	Шапка.ТоварноТранспортнаяНакладная                    КАК ТоварноТранспортнаяНакладная,
		|	Шапка.ТоварноТранспортнаяНакладная.ИдентификаторЕГАИС КАК ТоварноТранспортнаяНакладнаяИдентификатор,
		|	
		|	&Операция                        КАК ВидОперации,
		|	Шапка.ИдентификаторЕГАИС         КАК ИдентификаторЕГАИС,
		|	
		|	Шапка.ОрганизацияЕГАИС              КАК ОрганизацияЕГАИС,
		|	Шапка.ОрганизацияЕГАИС.Код          КАК ИдентификаторФСРАР,
		|	Шапка.ОрганизацияЕГАИС.ФорматОбмена КАК ФорматОбмена,
		|	Шапка.Ответственный                 КАК Ответственный
		|ИЗ
		|	Документ.ТранспортнаяНакладнаяЕГАИС КАК Шапка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
		|		ПО Шапка.Ссылка = Версии.Ссылка
		|ГДЕ
		|	Шапка.Ссылка = &Ссылка
		|",
		"Шапка");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Операция);
	РезультатыЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, ТекстыЗапроса);
	
	//@skip-warning
	Шапка = РезультатыЗапроса["Шапка"].Выбрать();
	
	Если Не Шапка.Следующий() Тогда
		
		СообщениеXML = ИнтеграцияЕГАИС.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияЕГАИС.ОписаниеОперацииПередачиДанных(
			Операция, ДокументСсылка);
		
		ИнтеграцияЕГАИСКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, НСтр("ru = 'Нет данных для выгрузки.'"));
		
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	ФорматОбмена = ИнтеграцияЕГАИСКлиентСервер.ФорматОбмена(Шапка.ФорматОбмена);
	
	СообщениеXML = ИнтеграцияЕГАИС.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияЕГАИС.ОписаниеОперацииПередачиДанных(
		Операция, ДокументСсылка, НомерВерсии);
	
	ПространствоИмен = Перечисления.ВидыДокументовЕГАИС.ПространствоИмен(Операция, ФорматОбмена);
	ИмяТипа          = Перечисления.ВидыДокументовЕГАИС.ТипЕГАИС(Операция, ФорматОбмена);
	
	Если ПространствоИмен = Неопределено
		Или ИмяТипа = Неопределено Тогда
		ИнтеграцияЕГАИСКлиентСервер.ДобавитьТекстОшибки(
			СообщениеXML,
			СтрШаблон(НСтр("ru = 'Операция не поддерживается в версии формата обмена: %1.'"), ФорматОбмена));
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
	КонецЕсли;
	
	#Область ОтменаТранспортнойНакладной
	
	ДокументXDTO = ИнтеграцияЕГАИС.ОбъектXDTO(ПространствоИмен, "CancelRoute");
	
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "RouteId", СокрЛП(Шапка.ИдентификаторЕГАИС),  СообщениеXML);
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "Date",    ТекущаяДатаСеанса(),               СообщениеXML);
	
	#КонецОбласти
	
	ТекстСообщенияXML = ИнтеграцияЕГАИС.ОбъектXDTOВXML(ДокументXDTO, Шапка.ИдентификаторФСРАР, ПространствоИмен, ИмяТипа);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.ТипСообщения      = Перечисления.ТипыЗапросовИС.Исходящий;
	СообщениеXML.ОрганизацияЕГАИС  = Шапка.ОрганизацияЕГАИС;
	СообщениеXML.Операция          = Операция;
	СообщениеXML.ФорматОбмена      = ФорматОбмена;
	СообщениеXML.Документ          = ДокументСсылка;
	СообщениеXML.ДокументОснование = Шапка.ТоварноТранспортнаяНакладная;
	СообщениеXML.Версия            = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
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
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
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
	
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли