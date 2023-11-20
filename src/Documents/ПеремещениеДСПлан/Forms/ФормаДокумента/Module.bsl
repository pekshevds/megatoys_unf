
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Валюта = Объект.ВалютаДокумента;
	
	ДатаДокумента = Объект.Дата;
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	Элементы.СтатусУтвержденияДокумента.ТолькоПросмотр = НЕ ФормыДокументовДеньги.РазрешеноМенятьСтатусОплаты();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ФормаДокументПеремещениеДСПланПеремещениеДС", "Видимость",
		Не РегистрыСведений.ПрименениеПереводовВПути.ИспользуютсяПереводыВПути());
		
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
			
	// МобильныйКлиент
	МобильныйКлиентУНФ.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	// Конец МобильныйКлиент
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриЧтенииНаСервере()

&НаКлиенте
// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Дата", Объект.Дата);
	Оповестить("ИзменениеДанныхПлатежногоКалендаря", ПараметрыОповещения,Объект.Ссылка);
	
КонецПроцедуры // ПослеЗаписи()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//Обсуждения
	ОбсужденияУНФ.ПослеЗаписиНаСервере(ТекущийОбъект);	
	// Конец Обсуждения
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВалютаДокумента.
//
&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	Если Валюта <> Объект.ВалютаДокумента Тогда
		
		СтруктураДанные = ПолучитьДанныеВалютаДокументаПриИзменении(
			Объект.Организация,
			Валюта,
			Объект.БанковскийСчет,
			Объект.ВалютаДокумента,
			Объект.СуммаДокумента,
			Объект.Дата);
		
		Объект.БанковскийСчет = СтруктураДанные.БанковскийСчет;
		
		Если Объект.СуммаДокумента <> 0 Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			ПоказатьВопрос(Новый ОписаниеОповещения("ВалютаДокументаПриИзмененииЗавершение", ЭтотОбъект,
				Новый Структура("СтруктураДанные", СтруктураДанные)), НСтр(
				"ru = 'Изменилась валюта документа. Пересчитать сумму документа?'"), Режим);
			Возврат;
		КонецЕсли;
		ВалютаДокументаПриИзмененииФрагмент();
		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтруктураДанные = ДополнительныеПараметры.СтруктураДанные;
    
    
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.СуммаДокумента = СтруктураДанные.Сумма;
    КонецЕсли;
    
    ВалютаДокументаПриИзмененииФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзмененииФрагмент()
    
    Валюта = Объект.ВалютаДокумента;

КонецПроцедуры // ВалютаДокументаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ТипДенежныхСредств.
//
Процедура ТипДенежныхСредствПриИзменении(Элемент)
	
	УстановитьТекущуюСтраницу();
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры // ТипДенежныхСредствПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ТипДенежныхСредствПолучатель.
//
Процедура ТипДенежныхСредствПолучательПриИзменении(Элемент)
	
	УстановитьТекущуюСтраницуПолучателя();
	
КонецПроцедуры // ТипДенежныхСредствПолучательПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДанныеДляИзмененияДаты = ДокументыУНФКлиент.ДанныеДляИзмененияДаты(ЭтотОбъект, Объект);
	Если ДанныеДляИзмененияДаты.ДатаНеМенялась Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты);
		
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Касса.
//
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	УстановитьВалютуПоУмолчаниюПриИзмененииКассы(Объект.Касса);
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры // КассаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода БанковскийСчет.
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КассаПолучатель.
//
&НаКлиенте
Процедура КассаПолучательПриИзменении(Элемент)
	
	УстановитьВалютуПоУмолчаниюПриИзмененииКассы(Объект.КассаПолучатель);
	
КонецПроцедуры // КассаПолучательПриИзменении()

// Процедура устанавливает валюту по умолчанию.
//
&НаКлиенте
Процедура УстановитьВалютуПоУмолчаниюПриИзмененииКассы(Касса)
	
	Объект.ВалютаДокумента = ?(
		ЗначениеЗаполнено(Объект.ВалютаДокумента),
		Объект.ВалютаДокумента,
		ПолучитьВалютуПоУмолчаниюКассыНаСервере(Касса));
	
КонецПроцедуры // УстановитьВалютуПоУмолчаниюПриИзмененииКассы()

// Процедура получает валюту кассы по умолчанию.
//
&НаСервереБезКонтекста
Функция ПолучитьВалютуПоУмолчаниюКассыНаСервере(Касса)
	
	Возврат Касса.ВалютаПоУмолчанию;
	
КонецФункции // ПолучитьВалютуПоУмолчаниюКассыНаСервере()

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет соответствие валюты денежных средств банковского счета и валюты документа,
// в случае несоответствия определяется банковский счет (касса) по умолчанию.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация документа
//	Валюта - СправочникСсылка.Валюты - Валюта документа
//	БанковскийСчет - СправочникСсылка.БанковскиеСчета - Банковский счет документа
//	Касса - СправочникСсылка.Кассы - Касса документа
//
&НаСервереБезКонтекста
Функция ПолучитьБанковскийСчет(Организация, Валюта)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Организации.БанковскийСчетПоУмолчанию.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|			ТОГДА Организации.БанковскийСчетПоУмолчанию
	|		КОГДА (НЕ БанковскиеСчета.БанковскийСчет ЕСТЬ NULL )
	|			ТОГДА БанковскиеСчета.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчет
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			БанковскиеСчета.Ссылка КАК БанковскийСчет
	|		ИЗ
	|			Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ГДЕ
	|		 БанковскиеСчета.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|			И БанковскиеСчета.Владелец = &Организация) КАК БанковскиеСчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Организации.Ссылка = &Организация");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", Валюта);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.БанковскийСчет;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьБанковскийСчет()

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ДокументыУНФ.ОрганизацияПриИзменении(ЭтотОбъект, Объект);
	Объект.БанковскийСчет = ПолучитьБанковскийСчет(Объект.Организация, Объект.ВалютаДокумента);
	ВалютаИКассаПоУмолчанию = Справочники.Организации.ВалютаИКассаПоУмолчанию(Объект, Объект.ВалютаДокумента,
		"ВалютаДокумента");
	Если ЗначениеЗаполнено(ВалютаИКассаПоУмолчанию) Тогда
		Если (Объект.Касса = Объект.КассаПолучатель) Тогда
			Объект.КассаПолучатель = ВалютаИКассаПоУмолчанию.Касса;
		КонецЕсли;
		Объект.Касса = ВалютаИКассаПоУмолчанию.Касса;
		Объект.ВалютаДокумента = ВалютаИКассаПоУмолчанию.ВалютаДокумента;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет данные с сервера для процедуры ВалютаДокументаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеВалютаДокументаПриИзменении(Организация, Валюта, БанковскийСчет, НоваяВалюта, СуммаДокумента, Дата)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("БанковскийСчет", ПолучитьБанковскийСчет(Организация, НоваяВалюта));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА КурсыВалют.Кратность <> 0
	|				И (НЕ КурсыВалют.Кратность ЕСТЬ NULL )
	|				И НовыеКурсыВалют.Курс <> 0
	|				И (НЕ НовыеКурсыВалют.Курс ЕСТЬ NULL )
	|			ТОГДА &СуммаДокумента * (КурсыВалют.Курс * НовыеКурсыВалют.Кратность) / (КурсыВалют.Кратность * НовыеКурсыВалют.Курс)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыВалют
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &НоваяВалюта) КАК НовыеКурсыВалют
	|		ПО (ИСТИНА)");
	 
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("НоваяВалюта", НоваяВалюта);
	Запрос.УстановитьПараметр("СуммаДокумента", СуммаДокумента);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураДанные.Вставить("Сумма", Выборка.Сумма);
	Иначе
		СтруктураДанные.Вставить("Сумма", 0);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеВалютаДокументаПриИзменении()

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты)
	
	ДокументыУНФ.ДатаПриИзменении(ДанныеДляИзмененияДаты, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	УстановитьТекущуюСтраницу();
	УстановитьТекущуюСтраницуПолучателя();
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры

// Устанавливает текущую страницу для типа денежных средств.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операции
//
&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда
		
		Элементы.БанковскийСчет.Доступность = Истина;
		Элементы.БанковскийСчет.Видимость 	= Истина;
		Элементы.Касса.Видимость 			= Ложь;
		
	ИначеЕсли Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		
		Элементы.Касса.Доступность 			= Истина;
		Элементы.БанковскийСчет.Видимость 	= Ложь;
		Элементы.Касса.Видимость 			= Истина;
		
	Иначе
		
		Элементы.БанковскийСчет.Доступность = Ложь;
		Элементы.Касса.Доступность 			= Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьТекущуюСтраницу()

&НаКлиенте
// Устанавливает текущую страницу для типа денежных средств.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операции
//
Процедура УстановитьТекущуюСтраницуПолучателя()
	
	Если Объект.ТипДенежныхСредствПолучатель = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда
		
		Элементы.БанковскийСчетПолучатель.Доступность 	= Истина;
		Элементы.БанковскийСчетПолучатель.Видимость 	= Истина;
		Элементы.КассаПолучатель.Видимость 				= Ложь;
		
	ИначеЕсли Объект.ТипДенежныхСредствПолучатель = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		
		Элементы.КассаПолучатель.Доступность 			= Истина;
		Элементы.БанковскийСчетПолучатель.Видимость 	= Ложь;
		Элементы.КассаПолучатель.Видимость 				= Истина;
		
	Иначе
		
		Элементы.БанковскийСчетПолучатель.Доступность 	= Ложь;
		Элементы.КассаПолучатель.Доступность 			= Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьТекущуюСтраницуПолучателя()

// Процедура устанавливает доступность флага резервирования в зависимости от выбранного способа оплаты.
//
&НаКлиенте
Процедура УстановитьДоступностьРезервирования()
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипДенежныхСредств)
		ИЛИ Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") И НЕ ЗначениеЗаполнено(Объект.БанковскийСчет) 
		ИЛИ Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") И НЕ ЗначениеЗаполнено(Объект.Касса) Тогда
		Объект.РезервироватьДенежныеСредства = Ложь;
		Элементы.РезервироватьДенежныеСредства.Доступность = Ложь;
	Иначе
		Элементы.РезервироватьДенежныеСредства.Доступность = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеОбъектов

&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтаФорма);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

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

#КонецОбласти