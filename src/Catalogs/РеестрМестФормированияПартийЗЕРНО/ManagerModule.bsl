
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область Отчеты

// Заполняет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//   Параметры - Структура - Вспомогательные параметры. См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры.
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
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
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
	
	Возврат;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	УправлениеДоступомИСПереопределяемый.ПриЗаполненииОграниченияДоступа(
		Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО, Ограничение);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты) Экспорт
	
	Если ЭлементОчереди.Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросМестФормированияПартий Тогда
		
		РеквизитыИсходящегоСообщения = ЭлементОчереди.РеквизитыИсходящегоСообщения;
		ПараметрыЗапроса             = ЭлементОчереди.РеквизитыИсходящегоСообщения.ПараметрыЗапроса;
		ДанныеДляОбработки           = ИнтеграцияЗЕРНОСлужебный.МассивДанныхПоляXDTO(ПолученныеДанные.Record);
		
		Блокировка = Новый БлокировкаДанных();
		
		Для Каждого КлючИЗначение Из ПараметрыОбмена.ПараметрыПреобразования.БлокируемыеОбъекты Цикл
			
			ЭлементБлокировки = Блокировка.Добавить(КлючИЗначение.Ключ);
			БлокируемыеДанные = КлючИЗначение.Значение;
			
			Если БлокируемыеДанные <> Неопределено Тогда
				Для Каждого Колонка Из БлокируемыеДанные.Колонки Цикл
					ЭлементБлокировки.ИспользоватьИзИсточникаДанных(Колонка.Имя, Колонка.Имя);
				КонецЦикла;
				ЭлементБлокировки.ИсточникДанных = БлокируемыеДанные;
			КонецЕсли;
			
		КонецЦикла;
	
		Попытка
			
			Блокировка.Заблокировать();
			УстановитьПривилегированныйРежим(Истина);
			
			ИнтеграцияЗЕРНОСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена);
			
			Для Каждого СтрокаДанных Из ДанныеДляОбработки Цикл
				СсылкаНаОбъект = ЗагрузитьМестоФормированияПартии(
					СтрокаДанных,
					ЭлементОчереди.Организация,
					ЭлементОчереди.Подразделение,
					ПараметрыОбмена);
				Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
					ИзмененныеОбъекты.Добавить(СсылкаНаОбъект);
				КонецЕсли;
			КонецЦикла;
			
			Если ПолученныеДанные.hasMore Тогда
				
				СообщенияXML = Новый Массив();
				
				НовыеПараметрыФормирования = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыЗапроса);
				НовыеПараметрыФормирования.НомерСтраницы = НовыеПараметрыФормирования.НомерСтраницы + 1;
				
				Если Не ЗначениеЗаполнено(НовыеПараметрыФормирования.Организация) Тогда
					НовыеПараметрыФормирования.Организация = ЭлементОчереди.Организация;
				КонецЕсли;
				
				СообщениеXML = СообщениеЗагрузкиРеестраМестФормированияПартий(НовыеПараметрыФормирования, ПараметрыОбмена);
				СообщениеXML.ЗагружатьДо = РеквизитыИсходящегоСообщения.ЗагружатьДо;
				ИнтеграцияЗЕРНОСлужебный.УстановитьСообщениеОснование(СообщениеXML, РеквизитыИсходящегоСообщения);
				
				СообщенияXML.Добавить(СообщениеXML);
			
				ИнтеграцияЗЕРНОСлужебный.ПодготовитьКПередачеИсходныеСообщения(СообщенияXML, ПараметрыОбмена);
				
			КонецЕсли;
		
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	
	КонецЕсли;
	
КонецПроцедуры

// Сообщение к передаче XML
//
// Параметры:
//  СсылкаНаОбъект          - СправочникСсылка.РеестрМестФормированияПартийЗЕРНО - Ссылка на объект.
//  ДальнейшееДействие      - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЗЕРНО - дальнейшее действие.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры.
// Возвращаемое значение:
//  Массив из см. ИнтеграцияЗЕРНОСлужебный.СтруктураСообщенияXML - Сообщения к передаче.
//
Функция СообщениеКПередачеXML(СсылкаНаОбъект, ДальнейшееДействие, ДополнительныеПараметры) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ПередайтеДанные Тогда
		Возврат СообщенияЗагрузкиРеестраМестФормированияПартий(СсылкаНаОбъект, ДополнительныеПараметры);
	КонецЕсли;
	
КонецФункции

// Сообщения загрузки классификаторов
//
// Параметры:
//  СсылкаНаОбъект          - СправочникСсылка - Ссылка на справочник.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры.
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщенияЗагрузкиРеестраМестФормированияПартий(СсылкаНаОбъект, ДополнительныеПараметры)
	
	СообщенияXML = Новый Массив();
	
	ПараметрыФормирования = ПараметрыФормированияСообщенияXML();
	ПараметрыФормирования.Организация      = ДополнительныеПараметры.ПараметрыОбработкиДокумента.Организация;
	ПараметрыФормирования.Подразделение    = ДополнительныеПараметры.ПараметрыОбработкиДокумента.Подразделение;
	ПараметрыФормирования.ПараметрыЗапроса = ДополнительныеПараметры.ПараметрыОбработкиДокумента.ПараметрыЗапроса;
	
	АбстрактноеСообщениеXML = ИнтеграцияЗЕРНОСлужебный.СтруктураСообщенияXML();
	АбстрактноеСообщениеXML.Операция            = Перечисления.ВидыОперацийЗЕРНО.ЗапросМестФормированияПартийАбстрактнаяОперация;
	АбстрактноеСообщениеXML.ТипСообщения        = Перечисления.ТипыЗапросовИС.Исходящий;
	АбстрактноеСообщениеXML.Версия              = ПараметрыФормирования.НомерВерсии;
	АбстрактноеСообщениеXML.ПараметрыЗапроса    = ПараметрыФормирования;
	АбстрактноеСообщениеXML.Организация         = ПараметрыФормирования.Организация;
	АбстрактноеСообщениеXML.Подразделение       = ПараметрыФормирования.Подразделение;
	
	АбстрактноеСообщениеXML.СсылкаНаОбъект      = ПустаяСсылка();
	АбстрактноеСообщениеXML.ТребуетсяПодписание = Ложь;
	СообщенияXML.Добавить(АбстрактноеСообщениеXML);
	
	НовыеПараметрыФормирования = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыФормирования);
	СообщениеXML = СообщениеЗагрузкиРеестраМестФормированияПартий(НовыеПараметрыФормирования, ДополнительныеПараметры.ПараметрыОбмена);
	СообщениеXML.ЗагружатьДо = АбстрактноеСообщениеXML.Идентификатор;
	ИнтеграцияЗЕРНОСлужебный.УстановитьСообщениеОснование(СообщениеXML, АбстрактноеСообщениеXML);
	АбстрактноеСообщениеXML.ДополнительноеОписание = СообщениеXML.ДополнительноеОписание;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция ПараметрыФормированияСообщенияXML()
	
	ВозвращаемоеЗначение = ИнтеграцияЗЕРНОСлужебный.ПараметрыФормированияСообщенияXML();
	
	ВозвращаемоеЗначение.КоличествоНаСтранице = ИнтеграцияЗЕРНО.ПараметрыОптимизации().КоличествоЭлементовСтраницыОтвета;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция СообщениеЗагрузкиРеестраМестФормированияПартий(ПараметрыФормирования, ПараметрыОбмена)
	
	ИмяСвойстваЗапроса = "RequestGetListPrimaryStoragePlace";
	ПространствоИмен   = ИнтеграцияЗЕРНОСлужебный.ПространствоИменПоИмениПакетаXDTO("zerno_api_grainmonitor");
	Операция           = Перечисления.ВидыОперацийЗЕРНО.ЗапросМестФормированияПартий;
	ПараметрыЗапроса   = ПараметрыФормирования.ПараметрыЗапроса;
	
	ТелоXDTO = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяСвойстваЗапроса);
	
	СообщениеXML = ИнтеграцияЗЕРНОСлужебный.СтруктураСообщенияXML();
	СообщениеXML.Операция         = Операция;
	СообщениеXML.ТипСообщения     = Перечисления.ТипыЗапросовИС.Исходящий;
	СообщениеXML.Версия           = 1;
	СообщениеXML.Идентификатор    = Строка(Новый УникальныйИдентификатор);
	СообщениеXML.ПараметрыЗапроса = ПараметрыФормирования;
	СообщениеXML.СсылкаНаОбъект   = ПустаяСсылка();
	СообщениеXML.Организация      = ПараметрыФормирования.Организация;
	СообщениеXML.Подразделение    = ПараметрыФормирования.Подразделение;
	
	ДанныеОписания = Новый Массив();
	
	Если ПараметрыЗапроса <> Неопределено Тогда
		
		Если ПараметрыЗапроса.Свойство("Интервал") Тогда
			Интервал = ПараметрыЗапроса.Интервал;
			Если ЗначениеЗаполнено(Интервал.НачалоПериода) Тогда
				ИнтеграцияЗЕРНОСлужебный.ЗаполнитьСвойствоXDTO(ТелоXDTO, "recordsModifiedFrom", Интервал.НачалоПериода, СообщениеXML);
				ДанныеОписания.Добавить(
					СтрШаблон(
						НСтр("ru = 'с %1'"),
						Формат(Интервал.НачалоПериода, "ДФ=dd.MM.yyyy;")));
			КонецЕсли;
			Если ЗначениеЗаполнено(Интервал.КонецПериода) Тогда
				ИнтеграцияЗЕРНОСлужебный.ЗаполнитьСвойствоXDTO(ТелоXDTO, "dateTo", Интервал.КонецПериода, СообщениеXML);
				ДанныеОписания.Добавить(
					СтрШаблон(
						НСтр("ru = 'по %1'"),
						Формат(Интервал.КонецПериода, "ДФ=dd.MM.yyyy;")));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	СообщениеXML.ДополнительноеОписание = СтрСоединить(ДанныеОписания, " ");
	
	ИнтеграцияЗЕРНОСлужебный.ЗаполнитьДанныеПостраничногоПросмотра(
		ТелоXDTO,
		СообщениеXML,
		ПараметрыФормирования.НомерСтраницы,
		ПараметрыФормирования.КоличествоНаСтранице);
	СообщениеXML.ТекстСообщенияЗапросXML = ИнтеграцияЗЕРНОСлужебный.ОбъектXDTOВXML(
		ТелоXDTO, ПространствоИмен, ИмяСвойстваЗапроса, ПараметрыОбмена);
	
	Возврат СообщениеXML;
	
КонецФункции

#Область ПоискСсылок

Функция МестоФормированияПартии(Идентификатор, Организация, ПараметрыОбмена) Экспорт
	
	ИмяТаблицы = Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО.ПолноеИмя();
	
	СправочникСсылка = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
	
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
	Иначе
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
		
		ТранзакцияЗафиксирована = Истина;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникСсылка = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
			
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				СправочникСсылка = СоздатьМестоФормированияПартии(Идентификатор);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТранзакцияЗафиксирована = Ложь;
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3'"),
				Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО.Синоним,
				Идентификатор,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3'"),
				Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО.Синоним,
				Идентификатор,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ИнтеграцияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибкиПодробно,
				НСтр("ru = 'Работа с мастами формирования партий'", ОбщегоНазначения.КодОсновногоЯзыка()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		Если ТранзакцияЗафиксирована Тогда
			ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
	
КонецФункции

Функция ЗагрузитьМестоФормированияПартии(ЭлементДанных, Организация, Подразделение, ПараметрыОбмена, СуществующийОбъект = Неопределено, ТребуетсяПоиск = Истина, ДополнительныеРеквизиты = Неопределено) Экспорт
	
	ЗаписьНового       = Ложь;
	МетаданныеЭлемента = Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО;
	Идентификатор      = Формат(ЭлементДанных.id, "ЧГ=0;");
	
	Если СуществующийОбъект = Неопределено Тогда
		
		СуществующийЭлемент = Неопределено;
		Если ТребуетсяПоиск Тогда
			СуществующийЭлемент = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(
				ПараметрыОбмена,
				МетаданныеЭлемента.ПолноеИмя(),
				Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
			СуществующийОбъект = СоздатьЭлемент();
			СуществующийОбъект.Идентификатор = Идентификатор;
			ЗаписьНового = Истина;
		Иначе
			СуществующийОбъект = СуществующийЭлемент.ПолучитьОбъект();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СуществующийОбъект.Заблокировать();
	КонецЕсли;
	
	СуществующийОбъект.Товаропроизводитель = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючОрганизации(ЭлементДанных.Owner, ПараметрыОбмена);
	Если Не ЗначениеЗаполнено(СуществующийОбъект.Товаропроизводитель)
		И ДополнительныеРеквизиты <> Неопределено Тогда
		СуществующийОбъект.Товаропроизводитель = ДополнительныеРеквизиты["Товаропроизводитель"];
	КонецЕсли;
	Если ЭлементДанных.isActive Тогда
		СуществующийОбъект.Статус = Перечисления.СтатусыМестФормированияПартийЗЕРНО.Активно;
	Иначе
		СуществующийОбъект.Статус = Перечисления.СтатусыМестФормированияПартийЗЕРНО.НеАктивно;
	КонецЕсли;
	СуществующийОбъект.Наименование = ЭлементДанных.name;
	СуществующийОбъект.ОКПД2        = ЭлементДанных.Crop;
	СуществующийОбъект.ТребуетсяЗагрузка = Ложь;
	СуществующийОбъект.Записать();
	
	ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, МетаданныеЭлемента.ПолноеИмя(), Идентификатор, СуществующийОбъект.Ссылка);
	
	Возврат СуществующийОбъект.Ссылка;
	
КонецФункции

Функция СоздатьМестоФормированияПартии(Идентификатор)
	
	СправочникОбъект = СоздатьЭлемент();
	СправочникОбъект.Наименование          = НСтр("ru = '<Требуется загрузка>'");
	СправочникОбъект.Идентификатор         = Идентификатор;
	СправочникОбъект.ТребуетсяЗагрузка     = Истина;
	СправочникОбъект.ОбменДанными.Загрузка = Истина;
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
