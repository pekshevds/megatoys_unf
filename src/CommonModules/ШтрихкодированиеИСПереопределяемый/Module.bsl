#Область ПрограммныйИнтерфейс

// Выделяет из переданного массива штрихкодов упаковок элементы, в составе которых (на любом уровне вложенности, 
//   в т.ч. частично) находится продукция требуемого вида.
//
// Параметры:
//   ШтрихкодыУпаковок - Массив Из СправочникСсылка.ШтрихкодыУпаковокТоваров - проверяемые элементы.
//   ВидыПродукцииИС - Массив Из ПеречислениеСсылка.ВидыПродукцииИС, ПеречислениеСсылка.ВидыПродукцииИС, Неопределено -
//                     Вид отбираемой продукции.
Процедура ВыделитьШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС) Экспорт
	
	ИнтеграцияМОТПУНФ.ВыделитьШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС);
	
КонецПроцедуры

// Заполняет соответствие штрихкодов данными: Номенклатура, Храктеристика, МаркируемаяПродукция, Коэффициент.
// 
// Параметры:
//  Штрихкоды            - Соответствие - Список штрихкодов.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
Процедура ЗаполнитьИнформациюПоШтрихкодам(Штрихкоды, КэшированныеЗначения) Экспорт
	
	ИнтеграцияМОТПУНФ.ЗаполнитьИнформациюПоШтрихкодам(Штрихкоды, КэшированныеЗначения);
	
КонецПроцедуры

// В процедуре нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа, в которой происходит обработка,
//   ДанныеШтрихкодов - Массив - полученные штрихкоды,
//   ПараметрыЗаполнения - (см. ИнтеграцияИС.ПараметрыЗаполненияТабличнойЧастиТовары).
//   СтруктураДействий - Структура - подготовленные данные.
//
Процедура ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий) Экспорт
	
	ИнтеграцияМОТПУНФ.ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий);
	
КонецПроцедуры

// В процедуре нужно реализовать обработку штрихкодов.
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма для которой будут обработаны введенные штрихкоды.
//   ДанныеДляОбработки - Структура - структура параметров обработки штрихкодов.
//                                    и заполняется данными из формы.
//   КэшированныеЗначения - Структура - кэш формы.
Процедура ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	ИнтеграцияМОТПУНФ.ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов из ТСД.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ОбработатьДанныеИзТСД(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	ИнтеграцияМОТПУНФ.ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение таблицы ДанныеПоEAN на основании заполненной колонки ШтрихкодEAN.
//   Ожидаемое поведение:
//    Если для строки информации по штрихкоду выставляется флаг "ТребуетсяОбработкаШтрихкода", строка информации должна
//    быть уникальной для этого штрихкода.
//
// Параметры:
//  ДанныеПоШтрихкодамEAN - ТаблицаЗначений - передается с обязательной колонкой ШтрихкодEAN, возвращает:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - Характеристика.
//   * Серия - ОпределяемыйТип.СерияНоменклатуры - Серия.
//   * Упаковка - ОпределяемыйТип.Упаковка - Упаковка.
//   * ШтрихкодEAN - Строка - Штрихкод.
//   * ПредставлениеНоменклатуры - Строка - Представление номенклатуры.
//   * ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
//   * ВидУпаковкиИС - ПеречислениеСсылка.ВидыУпаковокИС - вид упаковки (из коэффициента регистра ОписаниеGTINИС)
//   * МаркируемаяПродукция - Булево - Истина, если продукция является маркируемой.
//   * Количество - Число - количество товара в весовом штрихкоде EAN или коэффициенте упаковки
//   * ТребуетсяОбработкаШтрихкода - Булево - Истина если штрихкод не следует обрабатывать библиотекой
//   * ДанныеШтрихкода - Структура,Неопределено - Результат получения данных по штрихкоду (для обработки вне библиотеки)
//
Процедура ПриЗаполненииИнформацииПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN) Экспорт
	
	ИнтеграцияМОТПУНФ.ПриЗаполненииИнформацииПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN);
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение таблицы "ОстаткиМаркируемойПродукции" (по данным информационной базы).
//   На основании данных таблицы будет происходить контроль остатков, если в параметрах сканирования свойство
//   "ОперацияКонтроляАкцизныхМарок" будет заполнено значением "Продажа" или "Возврат", а прочий контроль выключен
//     (сейчас это продажа продукции ИС МП с выключенным контролем статусов).
// Первая операция контролю не подлежит (ранее не участвовавший в товародвижении КМ можно и продать, и вернуть).
// Отсутствие переопределения соответствует отсутствию контроля.
// 
// Параметры:
//  ОстаткиМаркируемойПродукции - См. ШтрихкодированиеИС.ИнициализацияТаблицыПроверкиОстатков.
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
Процедура ПриОпределенииОстатковМаркируемойПродукции(ОстаткиМаркируемойПродукции, ПараметрыСканирования) Экспорт
	
	ИнтеграцияМОТПУНФ.ПриОпределенииОстатковМаркируемойПродукции(ОстаткиМаркируемойПродукции, ПараметрыСканирования);
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение колонки таблицы значений штрихкодами, соответствующми номенклатуре и характеристике.
//
// Параметры:
//  ДанныеПоШтрихкодам - ТаблицаЗначений - содержит колонки:
//   * Номенклатура   - ОпределяемыйТип.Номенклатура               - входящий.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - входящий.
//   * Штрихкод       - Строка                                     - исходящий.
//  ИмяКолонкиЗаполнения - Строка - Имя колонки таблицы значений, которую требуется заполнить значением штрихкода.
Процедура ЗаполнитьШтрихкоды(ДанныеПоШтрихкодам, ИмяКолонкиЗаполнения = "Штрихкод") Экспорт
	
	ИнтеграцияМОТПУНФ.ЗаполнитьШтрихкоды(ДанныеПоШтрихкодам);
	
КонецПроцедуры

// В процедуре нужно реализовать заполнение массива ШтрихкодыУпаковок из данных документа.
// 
// Параметры:
//  Документ - ДокументСсылка - проверяемый документ.
//  ШтрихкодыУпаковок - Массив - Список штрихкодов.
Процедура ЗаполнитьШтрихкодыУпаковокДокумента(Документ, ШтрихкодыУпаковок) Экспорт
	
	ИнтеграцияМОТПУНФ.ЗаполнитьШтрихкодыУпаковокДокумента(Документ, ШтрихкодыУпаковок);
	
КонецПроцедуры

// В процедуре нужно реализовать заполнение таблицы данных данными документа основания.
// 
// Параметры:
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
//  ТаблицаДанных - ТаблицаЗначений - Данные из документа основания.
Процедура СформироватьДанныеДокументаОснования(ПараметрыСканирования, ТаблицаДанных) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать обработку данных штрихкода для общей формы. результат обработки штрихкода следует
// вернуть в параметре РезультатОбработки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Общая форма.
//  ДанныеШтрихкода - См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода.
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
//  ВложенныеШтрихкоды - (См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода).
//  РезультатОбработки - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Процедура ОбработатьДанныеШтрихкодаДляОбщейФормы(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды, РезультатОбработки) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В этой процедуре при необходимости следует реализовать дополнительные проверки на ошибки данных по штрихкодам.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, для которой выполняется обработка штрихкодов.
//  ДанныеПоШтрихкодам - (См. ШтрихкодированиеИС.ИнициализацияДанныхПоШтрихкодам). 
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
//  ЕстьОшибки - Булево - Истина, если выявлена ошибка.
Процедура ПриПроверкеДанныхПоШтрихкодам(ДанныеПоШтрихкодам, ПараметрыСканирования, ЕстьОшибки) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В данной процедуре требуется переопределить текст запроса, определяющий свойства маркируемой продукции.
//   Номенклатура для запроса лежит во временной таблице с именем по-умолчанию "ДанныеШтрихкодовУпаковок" 
//   Ожидаемые колонки временной таблицы "ДанныеШтрихкодовУпаковок":
//    * Номенклатура   - ОпределяемыйТип.Номенклатура.
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры.
//   Ожидаемые действия:
//   * Создание временной таблицы "СвойстваМаркируемойПродукции" с колонками:
//     ** Номенклатура         - ОпределяемыйТип.Номенклатура - из источника.
//     ** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - из источника.
//     ** МаркируемаяПродукция - Булево - признак маркируемой продукции.
//     ** ВидПродукции         - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции.
//   * Поле "Номенклатура" желательно индексировать.
// Параметры:
//  ТекстЗапросаСвойстваМаркируемойПродукции - Строка - Переопределяемый текст запроса.
//  ТаблицаИсточник - Строка - имя временной таблицы запроса-источника данных.
Процедура ПриОпределенииТекстаЗапросаСвойствМаркируемойПродукции(ТекстЗапросаСвойстваМаркируемойПродукции, ТаблицаИсточник) Экспорт
	
	ИнтеграцияИСУНФ.ПриОпределенииТекстаЗапросаСвойствМаркируемойПродукции(ТекстЗапросаСвойстваМаркируемойПродукции);
	
КонецПроцедуры

// В данной процедуре требуется переопределить сочетание клавиш для команды "Добавить без маркировки" в форме сканирования.
// 
// Параметры:
//  СочетаниеКлавиш - СочетаниеКлавиш - По умолчанию "Ctr + Z".
Процедура ПриОпределенииСочетанияКлавишДобавитьБезМаркировкиВФормеСканирования(СочетаниеКлавиш) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В случае учета серий в данной процедуре необходимо реализовать заполнение таблицы значений "ДанныеТаблицыТовары", 
//   содержащей (как минимум, без учета необходимости учета специфики в прикладных документах) колонки: 
//     "Номенклатура", "Характеристика", "Серия", "Количество".
// Если заданы параметры сканирования, таблицу необходимо положить во временное хранилище, адрес хранилища
//     - в ПараметрыСканирования.ДанныеТаблицыТовары. Иначе просто заполнить ДанныеТаблицыТовары по шаблону.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, для которой происходит обработка штрихкодов.
//  ДанныеТаблицыТовары - См. ШтрихкодированиеИС.ИнициализицияТаблицыДанныхДокумента.
//  ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
//  СтандартнаяОбработка - Булево - признак дальнейшей стандартной обработки события.
Процедура ПриФормированииДанныхТабличнойЧастиТовары(Форма, ДанныеТаблицыТовары, ПараметрыСканирования, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияИСУНФ.ПриФормированииДанныхТабличнойЧастиТовары(Форма,
		ДанныеТаблицыТовары,
		ПараметрыСканирования,
		СтандартнаяОбработка);
	
КонецПроцедуры

// Заполнение данных по штрихкодам упаковок, сохраненных в прикладном документе.
// Используется для заполнения данными частичного выбытия по штрихкодам упаковок.
// 	
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, для которой происходит обработка штрихкодов.
//  ДанныеПоШтрихкодамУпаковок - Соответствие из КлючИЗначение:
//                               * Ключ     - СправочникСсылка.ШтрихкодыУпаковокТоваров - Штрихкод упаковки.
//                               * Значение - см. ШтрихкодированиеИС.НоваяСтруктураДанныхШтрихкодаУпаковкиДанныхДокумента.
//  ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
Процедура ПриФормированииДанныхПоШтрихкодамУпаковокДокумента(Форма, ДанныеПоШтрихкодамУпаковок, ПараметрыСканирования) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") Тогда
		Возврат;
	КонецЕсли;
		
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "АкцизныеМарки")
		И Форма.Объект.АкцизныеМарки.Количество() > 0
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект.АкцизныеМарки[0], "ЧастичноеВыбытиеКоличество") Тогда
		
		Для Каждого СтрокаТаблицы Из Форма.Объект.АкцизныеМарки Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЧастичноеВыбытиеКоличество) Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеСтроки = ШтрихкодированиеИС.НовыйЭлементДополненияВложенныхШтрихкодовУпаковокЧастичноеВыбытие();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТаблицы);
			ДанныеСтроки.Количество = СтрокаТаблицы.ЧастичноеВыбытиеКоличество;
			
			ДанныеПоШтрихкодамУпаковок.Вставить(
				СтрокаТаблицы.АкцизнаяМарка,
				ДанныеСтроки);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "ШтрихкодыУпаковок")
		И Форма.Объект.ШтрихкодыУпаковок.Количество() > 0
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект.ШтрихкодыУпаковок[0], "ЧастичноеВыбытиеКоличество") Тогда
		
		Для Каждого СтрокаТаблицы Из Форма.Объект.ШтрихкодыУпаковок Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЧастичноеВыбытиеКоличество) Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеСтроки = ШтрихкодированиеИС.НовыйЭлементДополненияВложенныхШтрихкодовУпаковокЧастичноеВыбытие();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТаблицы);
			ДанныеСтроки.Количество = СтрокаТаблицы.ЧастичноеВыбытиеКоличество;
			
			ДанныеПоШтрихкодамУпаковок.Вставить(
				СтрокаТаблицы.ШтрихкодУпаковки,
				ДанныеСтроки);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// В данной процедуре необходимо определить модуль для обработки данных штрихкода. Если модуль не будет определен оббработка
// будет выполнена в модуле менеджера. Процедура, в которой будует выполнена обработка должна называться "ОбработатьДанныеШтрихкода"
// с параметрами: "Форма", "ДанныеШтрихкода", "ПараметрыСканирования", "ВложенныеШтрихкоды".
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма объекта.
// 	МодульДляОбработки - Произвольный - Модуль, в котором будет выполнена обработка.
// 	СтандартнаяОбработка - Булево - Если требуется переопределеить модуль для обработки - требуется установить флаг в Ложь.
Процедура ОпределитьМодульДляОбработкиДанныхШтрихкода(Форма, МодульДляОбработки, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры


#КонецОбласти
