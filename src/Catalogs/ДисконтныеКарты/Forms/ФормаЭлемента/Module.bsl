#Область ОписаниеПеременных

&НаКлиенте
Перем ДанныеСчитывателя; // Кэш данных считывателя магнитной карты

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

#Область КонтрольДублей

// Функция проверяет наличие в ИБ дисконтных карт с таким же кодом (штриховым или магнитным) как в переданных данных
//
// Параметры:
//  Данные - Структура - данные по дисконтной карте, для которой проверяется наличие дублей
//
&НаСервереБезКонтекста
Функция ПолучитьКоличествоДублейСервер(Данные)
	
	Возврат Справочники.ДисконтныеКарты.ПроверитьДублиСправочникаДисконтныеКартыПоКодам(Данные).Количество();
	
КонецФункции

// Процедура вызывается после закрытия формы Справочник.ДисконтныеКарты.Форма.ФормаВыбораДублей.
//
&НаКлиенте
Процедура ОбработатьЗакрытиеФормыСпискаДублей(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	ПроверитьДублиДисконтныхКарт(ЭтаФорма);
КонецПроцедуры	

// Процедура открытия вспомогательной формы сравнения дублированных контрагентов.
// 
&НаКлиенте
Процедура ОбработатьСитуациюВыбораДубля(Элемент)
		
	ПараметрыПередачи = Новый Структура;
	
	ПараметрыПередачи.Вставить("КодКартыШтрихкод", СокрЛП(Объект.КодКартыШтрихкод));
	ПараметрыПередачи.Вставить("КодКартыМагнитный", СокрЛП(Объект.КодКартыМагнитный));
	ПараметрыПередачи.Вставить("Владелец", Объект.Владелец);
	ПараметрыПередачи.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ЧтоВыполнитьПослеЗакрытия = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыСпискаДублей", ЭтаФорма);
	
	ОткрытьФорму("Справочник.ДисконтныеКарты.Форма.ФормаВыбораДублей", 
				  ПараметрыПередачи, 
				  Элемент,
				  ,
				  ,
				  ,
				  ЧтоВыполнитьПослеЗакрытия,
				  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Процедура управляет информационными надписями о наличии дублей дисконтных карт.
// 
&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьДублиДисконтныхКарт(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	КоличествоЭлементовДублей = 0;
	
	Данные = Новый Структура;
	Данные.Вставить("Ссылка", Объект.Ссылка);
	Данные.Вставить("Владелец", Объект.Владелец);
	Данные.Вставить("КодКартыШтрихкод", Объект.КодКартыШтрихкод);
	Данные.Вставить("КодКартыМагнитный", Объект.КодКартыМагнитный);
	
	КоличествоЭлементовДублей = ПолучитьКоличествоДублейСервер(Данные);
	
	Если КоличествоЭлементовДублей > 0 Тогда
		
		СтруктураПараметровСообщенияОДублях = Новый Структура;
		
		Если КоличествоЭлементовДублей = 1 Тогда
			
			СтруктураПараметровСообщенияОДублях.Вставить("КоличествоЭлементовДублей", НСтр("ru = 'одна'"));
			СтруктураПараметровСообщенияОДублях.Вставить("Склонение", НСтр("ru = 'карта'"));
			
		ИначеЕсли КоличествоЭлементовДублей < 5 Тогда
			
			СтруктураПараметровСообщенияОДублях.Вставить("КоличествоЭлементовДублей", КоличествоЭлементовДублей);
			СтруктураПараметровСообщенияОДублях.Вставить("Склонение", НСтр("ru = 'карты'"));
			
		Иначе
			
			СтруктураПараметровСообщенияОДублях.Вставить("КоличествоЭлементовДублей", КоличествоЭлементовДублей);
			СтруктураПараметровСообщенияОДублях.Вставить("Склонение", НСтр("ru = 'карт'"));
			
		КонецЕсли;	
		
		ТекстНадписиОДублях = НСтр("ru = 'С таким кодом есть [КоличествоЭлементовДублей] [Склонение]'");
		
		Элементы.ПоказатьДубли.Заголовок = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстНадписиОДублях,
			СтруктураПараметровСообщенияОДублях);
		Форма.СтруктураДляПроверкиКодов.ЕстьДубли = Истина;
		
	Иначе
		
		Форма.СтруктураДляПроверкиКодов.ЕстьДубли = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииДляУправленияВнешнимВидомФормы

// Процедура управляет видимостью элементов формы в зависимости от наличия дублей.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	СтруктураПроверки = Форма.СтруктураДляПроверкиКодов;
	
	Если СтруктураПроверки.ЕстьДубли Тогда
		Если Не Элементы.ГруппаДубли.Видимость Тогда
			Элементы.ГруппаДубли.Видимость = Истина;
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаДубли.Видимость Тогда
		Элементы.ГруппаДубли.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		Элементы.ИнформацияПроцентСкидкиПоДисконтнойКарте.Видимость = СтарыйМеханизмСкидок(Объект.Владелец);
	Иначе
		Элементы.ИнформацияПроцентСкидкиПоДисконтнойКарте.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
// 	ВидДисконтнойКарты - СправочникСсылка.ВидыДисконтныхКарт
// Возвращаемое значение:
// 	Булево
&НаСервереБезКонтекста
Функция СтарыйМеханизмСкидок(Знач ВидДисконтнойКарты)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДисконтнойКарты, "СтарыйМеханизмСкидок");
КонецФункции

// Процедура управляет видимостью элементов формы в зависимости от вида карты.
//
&НаСервере
Процедура НастройкаВидимостиЭлементовПоВидуКарты()
	
	Если Не Объект.Владелец.Пустая() Тогда
		Именная = Объект.Владелец.ЭтоИменнаяКарта;
		ТипКарты = Объект.Владелец.ТипКарты;
	Иначе
		Именная = Ложь;
		ТипКарты = Перечисления.ТипыКарт.ПустаяСсылка();
	КонецЕсли;
	
	Элементы.ВладелецКарты.АвтоОтметкаНезаполненного = Именная;
	
	Элементы.ВладелецКарты.Видимость = Именная;
	Элементы.ЭтоИменнаяКарта.Видимость = Именная;
	
	Элементы.КодКартыМагнитный.Видимость = (ТипКарты = Перечисления.ТипыКарт.Магнитная
	                                        Или ТипКарты = Перечисления.ТипыКарт.Смешанная);
	Элементы.КодКарты.Видимость = (ТипКарты = Перечисления.ТипыКарт.Штриховая
	                                        Или ТипКарты = Перечисления.ТипыКарт.Смешанная);
											
	Если ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда
		Элементы.СкопироватьМКвШК.Видимость = Истина;
		Элементы.СкопироватьШКвМК.Видимость = Истина;
	Иначе
		Элементы.СкопироватьМКвШК.Видимость = Ложь;
		Элементы.СкопироватьШКвМК.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Функция возвращает ссылку на дисконтную карту, если в ИБ зарегистрирована только одна не помеченная на удаление
// дисконтная карта
//
&НаСервере
Функция ПолучитьВидДисконтнойКартыПоУмолчанию()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыДисконтныхКарт.Ссылка
		|ИЗ
		|	Справочник.ВидыДисконтныхКарт КАК ВидыДисконтныхКарт
		|ГДЕ
		|	НЕ ВидыДисконтныхКарт.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗВидовДисконтныхКарт = РезультатЗапроса.Выгрузить();
	
	Если ТЗВидовДисконтныхКарт.Количество() = 1 Тогда
		Возврат ТЗВидовДисконтныхКарт[0].Ссылка;
	Иначе
		Возврат Справочники.ВидыДисконтныхКарт.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода,СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование

КонецПроцедуры

// Процедура - обработчик события ПослеЗаписи.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОЗаписиНового(Объект.Ссылка);
	Оповестить("ПослеЗаписи_ДисконтнаяКарта", Объект.Комментарий, Объект.Ссылка);
	
КонецПроцедуры

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ИнформацияУпрВалюта = Константы.ВалютаУчета.Получить();
	
	Если Объект.Ссылка.Пустая() Тогда
		ИнформацияСуммаПродажПоДисконтнойКарте = 0;
		ИнформацияПроцентСкидкиПоДисконтнойКарте = 0;
		
		// Если в базе только один вид дисконтной карты, то заполним его автоматически.
		Если Объект.Владелец.Пустая() Тогда
			Объект.Владелец = ПолучитьВидДисконтнойКартыПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьИнформациюПоДисконтнойКарте();
	
	НастройкаВидимостиЭлементовПоВидуКарты();
	
	СтруктураДляПроверкиКодов = Новый Структура;
	
	СтруктураДляПроверкиКодов.Вставить("ЕстьДубли", Ложь);
	
	ПроверитьДублиДисконтныхКарт(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование	
	
	// Мобильный клиент
	НастроитьФормуМобильныйКлиент();
	
КонецПроцедуры

// В процедуре заполняется информация о % скидки и сумме продаж по дисконтной карте.
//
&НаСервере
Процедура ЗаполнитьИнформациюПоДисконтнойКарте()

	ДополнительныеПараметры = Новый Структура("ПолучатьСуммуПродаж, Сумма, ПредставлениеПериода", Истина, 0, "");
	ПроцентСкидкиПоДисконтнойКарте = ДисконтныеКартыУНФСервер.ВычислитьПроцентСкидкиПоДисконтнойКарте(
		ТекущаяДатаСеанса(), Объект, ДополнительныеПараметры);
	ИнформацияСуммаПродажПоДисконтнойКарте = ДополнительныеПараметры.Сумма;
	ИнформацияПроцентСкидкиПоДисконтнойКарте = ПроцентСкидкиПоДисконтнойКарте;
	Если ЗначениеЗаполнено(ДополнительныеПараметры.ПредставлениеПериода) Тогда
		Элементы.СуммаПродажПоДисконтнойКарте.Заголовок = СтрШаблон(НСтр("ru = 'Сумма продаж (%1)'"),
			ДополнительныеПараметры.ПредставлениеПериода);
	Иначе
		Элементы.СуммаПродажПоДисконтнойКарте.Заголовок = НСтр("ru = 'Сумма продаж'");
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Объект.Владелец.Пустая() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Перед считыванием дисконтной карты, выберите вид'"), ,
			"Объект.Владелец");
		Возврат;
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(ДисконтныеКартыУНФКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
			ТекущийЭлемент = Элементы.КодКарты;
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			// Обработка ситуации, когда считыватель магнитных карт имитирует нажатие клавиши "Enter" после считывания магнитной карты.
			ТекДата = ОбщегоНазначенияКлиент.ДатаСеанса();
			
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
			ТекущийЭлемент = Элементы.КодКартыМагнитный;
			
			// Обработка ситуации, когда считыватель магнитных карт имитирует нажатие клавиши "Enter" после считывания магнитной карты.
			// Символ перевода строки можно обрезать с помощью настроек подключаемого оборудования для считывателя магнитных карт.
			Пока (ОбщегоНазначенияКлиент.ДатаСеанса() - ТекДата) < 1 Цикл
			КонецЦикла;
		КонецЕсли;
		
		Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец,
			Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
		
		ПроверитьДублиДисконтныхКарт(ЭтаФорма);
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриИзменении элемента ВидДисконтнойКарты.
//
&НаКлиенте
Процедура ВидДисконтнойКартыПриИзменении(Элемент)
	
	НастройкаВидимостиЭлементовПоВидуКарты();
	Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	ПроверитьДублиДисконтныхКарт(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	ЗаполнитьИнформациюПоДисконтнойКарте();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ВладелецКарты.
//
&НаКлиенте
Процедура ВладелецКартыПриИзменении(Элемент)
	
	Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента КодКарты (штрихкод).
//
&НаКлиенте
Процедура КодКартыПриИзменении(Элемент)
	
	Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
	ПроверитьДублиДисконтныхКарт(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события Нажатие элемента ПоказатьДубли.
//
&НаКлиенте
Процедура ПоказатьДублиНажатие(Элемент)
	ОбработатьСитуациюВыбораДубля(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента КодКартыМагнитный.
//
&НаКлиенте
Процедура КодКартыМагнитныйПриИзменении(Элемент)
	
	Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
	ПроверитьДублиДисконтныхКарт(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

// Процедура обрабатывает данные штрихкода, которые передаются из обработки оповещения формы.
//
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ОбработатьПолученныйКодНаКлиенте(МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"), Ложь);
	
КонецПроцедуры

// Процедура обрабатывает данные со считывателя магнитных карт, которые передаются из обработки оповещения формы.
//
&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	ДанныеСчитывателя = Данные;
	ОбработатьПолученныйКодНаКлиенте(ДанныеСчитывателя, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"), Истина);
	
КонецПроцедуры

// Функция проверяет магнитный код на соответствие шаблону и возвращает список ДК, магнитный код или штрихкод.
//
&НаСервере
Функция ОбработатьПолученныйКодНаСервере(Данные, ТипКодаКарты, Предобработка, ЕстьНайденныеКарты = Ложь, ЕстьШаблон = Ложь)
	
	ЕстьНайденныеКарты = Ложь;
	
	Если Не Объект.Владелец.Пустая() И Не Объект.Владелец.ШаблонДисконтнойКарты.Пустая() Тогда
		ЕстьШаблон = Истина;
	Иначе
		ЕстьШаблон = Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипКода = ТипКодаКарты;
	Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
		// При вызове функции параметр "Предобработка" будем устанавливать в значение Ложь, чтобы не использовались шаблоны
		// магнитных карт. В качестве кода карты будет использоваться строка, полученная конкатенацией строк со всех магнитных дорожек.
		// В большинстве дисконтных карт используется только одна дорожка, на которой записан только номер карты в формате ";КодКарты?".
		Если Предобработка Тогда
			ТекКодКарты = Данные[0]; // Данные 3х дорожек магнитной карты. На данный момент не используется. Можно использовать если карта не найдена.
			                        // В случае, когда карта не соответствует ни одному шаблону, то будет выдано предупреждение,
			                        // но кнопка "Готова" в форме нажата не будет.
			ДисконтныеКарты = ДисконтныеКартыУНФВызовСервера.НайтиВидыДисконтныхКартПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода, Объект.Владелец);
			
			Возврат ДисконтныеКарты;
		Иначе
			Если ТипЗнч(Данные) = Тип("Массив") Тогда
				ТекКодКарты = Данные[0];
			Иначе
				ТекКодКарты = Данные;
			КонецЕсли;
			ДисконтныеКартыУНФВызовСервера.ПодготовитьКодКартыПоНастройкамПоУмолчанию(ТекКодКарты);
			
			Возврат ТекКодКарты;
		КонецЕсли;
	Иначе
		Возврат Данные;
	КонецЕсли;
		
КонецФункции

// Функция проверяет магнитный код на соответствие шаблону и устанавливает магнитный код или штрихкод элемента справочника.
//
&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиенте(Данные, ПолученныйТипКода, Предобработка)
	
	Перем ЕстьНайденныеКарты, ЕстьШаблон;
	
	Результат = ОбработатьПолученныйКодНаСервере(Данные, ПолученныйТипКода, Предобработка, ЕстьНайденныеКарты, ЕстьШаблон);
	Если ПолученныйТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
		Если ТипЗнч(Результат) = Тип("Строка") Тогда
			Объект.КодКартыМагнитный = Результат;
		Иначе
			Если Результат.Количество() = 1 Тогда
				Объект.КодКартыМагнитный = Результат.Получить(0).Значение;
			ИначеЕсли Результат.Количество() = 0 Тогда
				Если ЕстьШаблон Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(
						НСтр("ru = 'Код карты не соответствует шаблону для выбранного вида дисконтных карт.'"));
				Иначе
					ОбщегоНазначенияКлиент.СообщитьПользователю(
						НСтр("ru = 'Код карты не соответствует ни одному из шаблонов магнитных карт.'"));
				КонецЕсли;
			Иначе
				ВыбранноеЗначение = Результат.ВыбратьЭлемент(НСтр("ru = 'Выбор кода магнитной карты'"));
				Если ВыбранноеЗначение <> Неопределено Тогда
					Объект.МагнитныйКод = ВыбранноеЗначение.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Объект.КодКартыШтрихкод = Результат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды СкопироватьШКвМК формы.
//
&НаКлиенте
Процедура СкопироватьШКвМК(Команда)
	
	Объект.КодКартыМагнитный = Объект.КодКартыШтрихкод;
	Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец,
		Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

// Процедура - обработчик команды СкопироватьМКвШК формы.
//
&НаКлиенте
Процедура СкопироватьМКвШК(Команда)
	
	Объект.КодКартыШтрихкод = Объект.КодКартыМагнитный;
	Объект.Наименование = ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец,
		Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура НастроитьФормуМобильныйКлиент()
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
