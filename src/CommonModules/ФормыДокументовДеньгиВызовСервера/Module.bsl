
#Область ПрограммныйИнтерфейс

// Функция возвращает список для выбора документа основания
//
// Параметры:
//  ИмяФормы				 - Строка	 - Имя формы документа
//  ВидОперации				 - Перечисления.ВидыОперацийПоступлениеНаСчет	 - Вид операции
//  ДополнительныеПараметры	 - Структура	 - Дополнительные параметры
// 
// Возвращаемое значение:
//  СписокЗначений - Список документов оснований
//
Функция ПолучитьСписокДляВыбораДокументаОснования(ИмяФормы, ВидОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ФормыДокументовДеньги.ПолучитьСписокДляВыбораДокументаОснования(ИмяФормы, ВидОперации, ДополнительныеПараметры);
	
КонецФункции

// Процедура заполняет параметры диалога "Шапка / табличная часть"
//
// Параметры:
//  ПараметрыФормы	 - Структура	 - Параметры формы
//  ПараметрыДиалога - Структура	 - Параметры диалога
//
Процедура ЗаполнитьПараметрыДиалогаШапкаТабличнаяЧасть(ПараметрыФормы, ПараметрыДиалога) Экспорт
	
	ФормыДокументовДеньги.ЗаполнитьПараметрыДиалогаШапкаТабличнаяЧасть(ПараметрыФормы, ПараметрыДиалога);
	
КонецПроцедуры

// Функция возвращает признак учета стать в налоговом учете
//
// Параметры:
//  Статья		 - СправочникСсылка.СтатьиДвиженияДенежныхСредств	 - Статья ДДС
//  Организация	 - СправочникСсылка.Организации	 - Организация
//  Дата		 - Дата	 - Период
//  ВидОперации	 - Перечисление.ВидыОперацийПоступлениеНаСчет	 - Вид операции документа
// 
// Возвращаемое значение:
//  Булево - Статья учитывается в налоговом учете
//
Функция СтатьяУчитываетсяВНУ(Статья, Организация, Дата, ВидОперации) Экспорт
	
	Возврат РегламентированнаяОтчетностьУСН.НужноУчитыватьВНУ(Статья, ВидОперации, Организация, Дата);
	
КонецФункции

// Функция возвращает данные кассы
//
// Параметры:
//  Касса	 - СправочникСсылка.Кассы	 - Касса для получения данных
// 
// Возвращаемое значение:
//  Структура - Реквизиты кассы
//
Функция ДанныеКассыПриИзменении(Касса) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Касса,"ПодписьКассира,ВалютаПоУмолчанию");
	
КонецФункции

// Функция возвращает реквизиты документа планирования платежа для заполнения в платежный документ
// Параметры:
//  ДокументПланирования	- ДокументСсылка.ПеремещениеДСПлан,ДокументСсылка.РасходДСПлан - Документ планирования платежа
//  ВестиУчетОплатыПоСчетам	 - Булево	 - Признак ведения учета оплаты по счетам
//  ВестиРасчетыПоДокументам - Булево	 - Признак ведения учета оплаты по документам
// 
// Возвращаемое значение:
//  Структура - Реквизиты документа планирования платежа
//
Функция ДанныеДокументаПланирования(ДокументПланирования, ВестиУчетОплатыПоСчетам, ВестиРасчетыПоДокументам) Экспорт
	
	СтруктураДанных = Новый Структура();
	СтруктураДанных.Вставить("СтатьяДДС", Неопределено);
	СтруктураДанных.Вставить("СчетНаОплату", Неопределено);
	СтруктураДанных.Вставить("Документ", Неопределено);
	СтруктураДанных.Вставить("Подразделение", Неопределено);
	
	Если ТипЗнч(ДокументПланирования) = Тип("ДокументСсылка.ПеремещениеДСПлан") Тогда
		// У документа ПеремещениеДСПлан нет реквизита ДокументОснование, можно получить только Статью ДДС
		СтатьяДДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументПланирования, "СтатьяДвиженияДенежныхСредств");
		СтруктураДанных.Вставить("СтатьяДДС", СтатьяДДС);
		Возврат СтруктураДанных;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументПланирования.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ВЫБОР
		|		КОГДА &ВестиУчетОплатыПоСчетам
		|			ТОГДА ВЫРАЗИТЬ(ДокументПланирования.ДокументОснование КАК Документ.СчетНаОплатуПоставщика)
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СчетНаОплату,
		|	ВЫБОР
		|		КОГДА &ВестиРасчетыПоДокументам
		|			ТОГДА ДокументПланирования.ДокументОснование
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК Документ,
		|	ДокументПланирования.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.РасходДСПлан КАК ДокументПланирования
		|ГДЕ
		|	ДокументПланирования.Ссылка = &Ссылка";
	
	Если ТипЗнч(ДокументПланирования) = Тип("ДокументСсылка.ПоступлениеДСПлан") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "РасходДСПлан", "ПоступлениеДСПлан"); 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СчетНаОплатуПоставщика", "СчетНаОплату"); 
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументПланирования);
	Запрос.УстановитьПараметр("ВестиУчетОплатыПоСчетам", ВестиУчетОплатыПоСчетам);
	Запрос.УстановитьПараметр("ВестиРасчетыПоДокументам", ВестиРасчетыПоДокументам);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураДанных.Вставить("СтатьяДДС", Выборка.СтатьяДвиженияДенежныхСредств);
		СтруктураДанных.Вставить("СчетНаОплату", Выборка.СчетНаОплату);
		СтруктураДанных.Вставить("Документ", Выборка.Документ);
		СтруктураДанных.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
		Если ЗначениеЗаполнено(Выборка.ДокументОснование)
			И ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", Выборка.ДокументОснование.Метаданные()) Тогда
			Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.ДокументОснование, "Подразделение"); 
			СтруктураДанных.Вставить("Подразделение", Подразделение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

// Процедура заполняет подразделение в платежном документе из счета на оплату
//
// Параметры:
//  Подразделение	 - СправочникСсылка.СтруктурныеЕдиницы	 - Подразделение
//  СчетНаОплату	 - ДокументСсылка.СчетНаОплату, ДокументСсылка.СчетНаОплатуПоставщика	 - Счет на оплату
//
Процедура ЗаполнитьПодразделениеИзСчетаНаОплату(Подразделение, СчетНаОплату) Экспорт
	
	Если Не ЗначениеЗаполнено(Подразделение) И ЗначениеЗаполнено(СчетНаОплату) Тогда
		Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СчетНаОплату, "Подразделение");
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет подразделение в платежном документе из документа расчетов
//
// Параметры:
//  Подразделение	 - СправочникСсылка.СтруктурныеЕдиницы	 - Подразделение
//  Документ	 - ДокументСсылка.СчетНаОплату, ДокументСсылка.СчетНаОплатуПоставщика	 - Документ расчетов
//
Процедура ЗаполнитьПодразделениеИзДокументаРасчетов(Подразделение, Документ) Экспорт
	
	Если ЗначениеЗаполнено(Документ) И ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", Документ.Метаданные()) Тогда
		Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Подразделение");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти