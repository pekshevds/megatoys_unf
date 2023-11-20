#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)
	|	И ЗначениеРазрешено(ГоловнаяОрганизация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// АПК:581-выкл. Методы могут вызываться из расширений.
// АПК:299-выкл. Методы могут вызываться из расширений.
// АПК:326-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// АПК:325-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// Транзакция открывается в методе НачатьЗаписьНабора, закрывается в ЗавершитьЗаписьНабора, отменяется в ОтменитьЗаписьНабора.

// Транзакционный вариант (с управляемой блокировкой) получения набора записей, соответствующего значениям измерений.
//
// Параметры:
//   СНИЛС            - Строка                                   - Значение отбора по соответствующему измерению.
//   ВходящийДокумент - ОпределяемыйТип.ВходящиеДокументыСЭДОФСС - Значение отбора по соответствующему измерению.
//   НомерСтроки      - Число                                    - Значение отбора по соответствующему измерению.
//
// Возвращаемое значение:
//   РегистрСведенийНаборЗаписей.СНИЛСВходящихДокументовСФР - Если удалось установить блокировку
//       и прочитать набор записей. При необходимости, открывает свою локальную транзакцию. Для закрытия транзакции
//       следует использовать одну из терминирующих процедур: ЗавершитьЗаписьНабора, либо ОтменитьЗаписьНабора.
//   Неопределено - Если не удалось установить блокировку и прочитать набор записей.
//       Вызывать процедуры ЗавершитьЗаписьНабора, ОтменитьЗаписьНабора не требуется,
//       поскольку если перед блокировкой функции потребовалось открыть локальную транзакцию,
//       то после неудачной блокировки локальная транзакция была отменена.
//
Функция НачатьЗаписьНабора(Страхователь, ИдентификаторСообщения, СНИЛС) Экспорт
	Если Не ЗначениеЗаполнено(Страхователь)
		И Не ЗначениеЗаполнено(ИдентификаторСообщения)
		И Не ЗначениеЗаполнено(СНИЛС) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПолныеПраваИлиПривилегированныйРежим = Пользователи.ЭтоПолноправныйПользователь();
	Если Не ПолныеПраваИлиПривилегированныйРежим
		И Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СНИЛСВходящихСообщенийСЭДО) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".'"),
			Метаданные.РегистрыСведений.СНИЛСВходящихСообщенийСЭДО.Представление());
	КонецЕсли;
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	ЕстьСтрахователь           = (Страхователь           <> Неопределено);
	ЕстьИдентификаторСообщения = (ИдентификаторСообщения <> Неопределено);
	ЕстьСНИЛС                  = (СНИЛС                  <> Неопределено);
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СНИЛСВходящихСообщенийСЭДО");
		Если ЕстьСНИЛС Тогда
			ЭлементБлокировки.УстановитьЗначение("СНИЛС", СНИЛС);
		КонецЕсли;
		Если ЕстьИдентификаторСообщения Тогда
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторСообщения", ИдентификаторСообщения);
		КонецЕсли;
		Если ЕстьСтрахователь Тогда
			ЭлементБлокировки.УстановитьЗначение("Страхователь", Страхователь);
		КонецЕсли;
		Блокировка.Заблокировать();
		НаборЗаписей = СоздатьНаборЗаписей();
		Если ЕстьСНИЛС Тогда
			НаборЗаписей.Отбор.СНИЛС.Установить(СНИЛС);
		КонецЕсли;
		Если ЕстьИдентификаторСообщения Тогда
			НаборЗаписей.Отбор.ИдентификаторСообщения.Установить(ИдентификаторСообщения);
		КонецЕсли;
		Если ЕстьСтрахователь Тогда
			НаборЗаписей.Отбор.Страхователь.Установить(Страхователь);
		КонецЕсли;
		НаборЗаписей.Прочитать();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЗначенияДоЗаписи", НаборЗаписей.Выгрузить());
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЛокальнаяТранзакция", ЛокальнаяТранзакция);
	Исключение
		Если ЛокальнаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось проиндексировать СНИЛС входящего сообщения СЭДО (Идентификатор сообщения: %1, Страхователь: %2, СНИЛС: %3) по причине: %4'"),
			ИдентификаторСообщения,
			Страхователь,
			СНИЛС,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.СНИЛСВходящихСообщенийСЭДО,
			Страхователь,
			ТекстСообщения);
		НаборЗаписей = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НаборЗаписей;
КонецФункции

// Записывает набор и фиксирует локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.СНИЛСВходящихДокументовСФР
//
Процедура ЗавершитьЗаписьНабора(НаборЗаписей) Экспорт
	Если НаборЗаписей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	НаборЗаписей.Записать(Истина);
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Отменяет запись набора и отменяет локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.СНИЛСВходящихДокументовСФР
//
Процедура ОтменитьЗаписьНабора(НаборЗаписей) Экспорт
	Если НаборЗаписей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Получает первую запись набора. В случае отсутствия - добавляет запись и заполняет значения измерений из отборов.
//
// Параметры:
//   Набор - РегистрСведенийНаборЗаписей.ЗастрахованныеЛицаСЭДО - См. НачатьЗаписьНабора.
//
// Возвращаемое значение:
//   РегистрСведенийЗапись.ЗастрахованныеЛицаСЭДО
//
Функция ЕдинственнаяЗаписьНабора(Набор) Экспорт
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
		Для Каждого ЭлементОтбора Из Набор.Отбор Цикл
			Если ЭлементОтбора.Использование Тогда
				Запись[ЭлементОтбора.Имя] = ЭлементОтбора.Значение;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	Возврат Запись;
КонецФункции

// АПК:326-вкл.
// АПК:325-вкл.
// АПК:299-вкл.
// АПК:581-вкл.

#Область ОбновлениеИнформационнойБазы

// Регистрирует обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления().
//
Процедура ПриРегистрацииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.23.747";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("63807a12-ac79-11ed-8111-4cedfb43b11a");
	Обработчик.Процедура       = "РегистрыСведений.СНИЛСВходящихСообщенийСЭДО.ПроиндексироватьПоДаннымСообщений111";
	Обработчик.Комментарий     = НСтр("ru = 'Индексация сведений о СНИЛС использующихся в СЭДО типа 111 (Сообщения об изменении ЭЛН).'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.23.747";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("63807a14-ac79-11ed-8111-4cedfb43b11a");
	Обработчик.Процедура       = "РегистрыСведений.СНИЛСВходящихСообщенийСЭДО.ПроиндексироватьПоДаннымСообщений100";
	Обработчик.Комментарий     = НСтр("ru = 'Индексация СНИЛС сообщений СЭДО типа 100 (%1).'");
	Обработчик.Комментарий     = СтрШаблон(Обработчик.Комментарий, Метаданные.Документы.ВходящийЗапросФССДляРасчетаПособия.ПредставлениеСписка);
	
КонецПроцедуры

// Индексация сведений о СНИЛС использующихся в СЭДО типа 111 (Сообщения об изменении ЭЛН).
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ПроиндексироватьПоДаннымСообщений111(ПараметрыОбновления = Неопределено) Экспорт
	СЭДОФСС.ПовторноОбработатьВходящиеСообщенияСЭДО(ПараметрыОбновления, 111, Неопределено);
КонецПроцедуры

// Индексация сведений о СНИЛС использующихся в СЭДО типа 100 (Входящий запрос СФР для расчета пособия).
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ПроиндексироватьПоДаннымСообщений100(ПараметрыОбновления = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.ИдентификаторСообщения КАК ИдентификаторСообщения,
	|	100 КАК ТипСообщения,
	|	Документ.Страхователь КАК Страхователь,
	|	Документ.СотрудникСНИЛС КАК СНИЛС,
	|	Документ.Ссылка КАК ВходящийДокумент,
	|	Документ.ДатаСообщения КАК ВходящаяДата,
	|	Документ.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Документ.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Документ.СотрудникФамилия + "" "" + Документ.СотрудникИмя + ВЫБОР
	|		КОГДА Документ.СотрудникОтчество = """"
	|			ТОГДА """"
	|		ИНАЧЕ "" "" + Документ.СотрудникОтчество
	|	КОНЕЦ КАК ФИО
	|ИЗ
	|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СНИЛСВходящихСообщенийСЭДО КАК СНИЛСВходящихСообщенийСЭДО
	|		ПО Документ.Ссылка = СНИЛСВходящихСообщенийСЭДО.ВходящийДокумент
	|ГДЕ
	|	СНИЛСВходящихСообщенийСЭДО.ВходящийДокумент ЕСТЬ NULL
	|	И Документ.СотрудникСНИЛС <> """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторСообщения,
	|	Страхователь,
	|	ВходящийДокумент,
	|	ФизическоеЛицо";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ИдентификаторСообщения") Цикл
		Пока Выборка.СледующийПоЗначениюПоля("Страхователь") Цикл
			Если ЗначениеЗаполнено(Выборка.Страхователь) И ЗначениеЗаполнено(Выборка.ИдентификаторСообщения) Тогда
				Набор = НачатьЗаписьНабора(Выборка.Страхователь, Выборка.ИдентификаторСообщения, Неопределено);
				Если Набор = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Набор.Очистить();
				Пока Выборка.Следующий() Цикл
					Если ЗначениеЗаполнено(Выборка.СНИЛС) Тогда
						ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
					КонецЕсли;
				КонецЦикла;
				ЗавершитьЗаписьНабора(Набор);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ФизическиеЛица

Процедура ПриИзмененииСНИЛСФизическогоЛица(ФизическоеЛицо, НовыйСНИЛС, СтарыйСНИЛС) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗастрахованныеЛицаСЭДО.СНИЛС КАК СНИЛС,
	|	ЗастрахованныеЛицаСЭДО.Страхователь КАК Страхователь,
	|	ЗастрахованныеЛицаСЭДО.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗастрахованныеЛицаСЭДО.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ЗастрахованныеЛицаСЭДО.СНИЛС = &СтарыйСНИЛС КАК ЭтоСтарыйСНИЛС,
	|	ЗастрахованныеЛицаСЭДО.СНИЛС = &НовыйСНИЛС КАК ЭтоНовыйСНИЛС,
	|	ЗастрахованныеЛицаСЭДО.КоличествоВходящихДокументов > 0 КАК ЕстьВходящиеДокументы,
	|	ЗастрахованныеЛицаСЭДО.ДатаОтправки <> ДАТАВРЕМЯ(1, 1, 1) КАК ЕстьОтправленныеСведения,
	|	ЗастрахованныеЛицаСЭДО.Скрыть КАК Скрыть
	|ИЗ
	|	РегистрСведений.СНИЛСВходящихСообщенийСЭДО КАК ЗастрахованныеЛицаСЭДО
	|ГДЕ
	|	(ЗастрахованныеЛицаСЭДО.СНИЛС В (&СтарыйСНИЛС, &НовыйСНИЛС)
	|			ИЛИ ЗастрахованныеЛицаСЭДО.ФизическоеЛицо = &ФизическоеЛицо)";
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("СтарыйСНИЛС",    СтарыйСНИЛС);
	Запрос.УстановитьПараметр("НовыйСНИЛС",     НовыйСНИЛС);
	Если ЗначениеЗаполнено(СтарыйСНИЛС) Тогда
		Набор = НачатьЗаписьНабора(Неопределено, Неопределено, СтарыйСНИЛС);
		Если Набор <> Неопределено Тогда
			ЕстьИзменения = Ложь;
			Для Каждого Запись Из Набор Цикл
				Если Запись.ФизическоеЛицо = ФизическоеЛицо Тогда
					ЕстьИзменения = Истина;
					Запись.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
				КонецЕсли;
			КонецЦикла;
			Если ЕстьИзменения Тогда
				ЗавершитьЗаписьНабора(Набор);
			Иначе
				ОтменитьЗаписьНабора(Набор);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(НовыйСНИЛС) Тогда
		Набор = НачатьЗаписьНабора(Неопределено, Неопределено, НовыйСНИЛС);
		Если Набор <> Неопределено Тогда
			ЕстьИзменения = Ложь;
			Для Каждого Запись Из Набор Цикл
				Если Не ЗначениеЗаполнено(Запись.ФизическоеЛицо) Тогда
					ЕстьИзменения = Истина;
					Запись.ФизическоеЛицо = ФизическоеЛицо;
				КонецЕсли;
			КонецЦикла;
			Если ЕстьИзменения Тогда
				ЗавершитьЗаписьНабора(Набор);
			Иначе
				ОтменитьЗаписьНабора(Набор);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ПослеРасшифровкиСообщенияСЭДО

Процедура ПослеРасшифровкиСообщенияСЭДОСоСНИЛС(Страхователь, ТипСообщения, ИдентификаторСообщения, СНИЛС, Кэш) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Если ТипСообщения = 111 Или ТипСообщения = 4 Или ТипСообщения = 10 Или ТипСообщения = 100 Тогда
		Возврат; // Обработка выполняется при записи документов.
	КонецЕсли;
	Набор = НачатьЗаписьНабора(Страхователь, ИдентификаторСообщения, Неопределено);
	Если Набор <> Неопределено Тогда
		Запись = ЕдинственнаяЗаписьНабора(Набор);
		Запись.ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
		Запись.СНИЛС        = СНИЛС;
		Запись.ТипСообщения = ТипСообщения;
		
		ФизическоеЛицо = Кэш["ФизическоеЛицо"];
		ФИО            = Кэш["ФИО"];
		Если ФИО = Неопределено Тогда
			РезультатПоиска = ФизическиеЛицаЗарплатаКадры.ФизическоеЛицоПоСНИЛСИлиФИО(СНИЛС, "", "", "");
			ФизическоеЛицо = РезультатПоиска.ФизическоеЛицо;
			ФИО            = РезультатПоиска.ФИО;
			Кэш.Вставить("ФизическоеЛицо", ФизическоеЛицо);
			Кэш.Вставить("ФИО",            ФИО);
		КонецЕсли;
		
		Запись.ВходящаяДата   = СЭДОФСС.ДатаСообщения(ИдентификаторСообщения, Кэш);
		Запись.ФизическоеЛицо = ФизическоеЛицо;
		Запись.ФИО            = ФИО;
		
		ЗавершитьЗаписьНабора(Набор);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Документы

Процедура ОбновитьПоДокументу(Ссылка, Страхователь, ИдентификаторСообщения, СНИЛС, ФизическоеЛицо = Неопределено, ВходящаяДата = Неопределено, ФИО = Неопределено, ТипСообщения = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Набор = НачатьЗаписьНабора(Страхователь, ИдентификаторСообщения, Неопределено);
	Если Набор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Набор.Очистить();
	Если ЗначениеЗаполнено(СНИЛС) Тогда
		Запись = Набор.Добавить();
		Запись.СНИЛС                  = СНИЛС;
		Запись.ИдентификаторСообщения = ИдентификаторСообщения;
		Запись.Страхователь           = Страхователь;
		Запись.ВходящийДокумент       = Ссылка;
		Запись.ВходящаяДата           = ВходящаяДата;
		Запись.ГоловнаяОрганизация    = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
		Запись.ФизическоеЛицо         = ФизическоеЛицо;
		Запись.ФИО                    = ФИО;
	КонецЕсли;
	ЗавершитьЗаписьНабора(Набор);
КонецПроцедуры

#КонецОбласти

#Область Регистры

Процедура ОбновитьЗапись(Страхователь, ИдентификаторСообщения, ТипСообщения, СНИЛС, ФизическоеЛицо = Неопределено, ВходящаяДата = Неопределено, ФИО = Неопределено, НомерЛН = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Набор = НачатьЗаписьНабора(Страхователь, ИдентификаторСообщения, СНИЛС);
	Если Набор <> Неопределено Тогда
		Запись = ЕдинственнаяЗаписьНабора(Набор);
		Запись.ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
		Если ФизическоеЛицо <> Неопределено Тогда
			Запись.ФизическоеЛицо = ФизическоеЛицо;
		КонецЕсли;
		Если ВходящаяДата <> Неопределено Тогда
			Запись.ВходящаяДата = ВходящаяДата;
		КонецЕсли;
		Если ФИО <> Неопределено Тогда
			Запись.ФИО = ФИО;
		КонецЕсли;
		Если ТипСообщения <> Неопределено Тогда
			Запись.ТипСообщения = ТипСообщения;
		КонецЕсли;
		Если НомерЛН <> Неопределено Тогда
			Запись.НомерЛН = НомерЛН;
		КонецЕсли;
		ЗавершитьЗаписьНабора(Набор);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#КонецОбласти

#КонецЕсли