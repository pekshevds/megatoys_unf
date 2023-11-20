
#Область СлужебныеПроцедурыИФункции

// Обработчики событий форм документов перс. учета не входящих в квартальную отчетность.

Процедура ОрганизацияПриИзменении(Форма, ЗапрашиваемыеЗначения) Экспорт
	
	Если НЕ ЗапрашиваемыеЗначения.Свойство("Организация") Тогда
		ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	КонецЕсли; 
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(Форма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	Форма.Объект.НомерПачки = 0;
	
КонецПроцедуры	

// Обработчики событий форм документов перс. учета входящих в квартальную отчетность.

Процедура ДокументыКвартальнойОтчетностиПриСозданииНаСервере(Форма, ЗапрашиваемыеЗначенияЗаполнения, ИзменятьДоступностьЭлементов = Истина) Экспорт
		
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		ЗапрашиваемыеЗначенияЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(Форма, ЗапрашиваемыеЗначенияЗаполнения);
		ДокументыКвартальнойОтчетностиПриПолученииДанныхНаСервере(Форма, Форма.Объект, ИзменятьДоступностьЭлементов);
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ДокументыКвартальнойОтчетностиПриЧтенииНаСервере(Форма, ТекущийОбъект, ИзменятьДоступностьЭлементов = Истина) Экспорт
	ДокументыКвартальнойОтчетностиПриПолученииДанныхНаСервере(Форма, ТекущийОбъект, ИзменятьДоступностьЭлементов);	
КонецПроцедуры	

Процедура ДокументыКвартальнойОтчетностиПриПолученииДанныхНаСервере(Форма, Объект, ИзменятьДоступностьЭлементов = Истина)	
	
	КомплектОтправленВПФР = Ложь;
	
	Если Не Форма.Объект.Ссылка.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Форма.Объект.Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(КомплектыСодержащиеДокумент.ТолькоПросмотр) КАК ТолькоПросмотр,
		|	МАКСИМУМ(КомплектыСодержащиеДокумент.Ссылка) КАК Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА КомплектыОтчетностиПерсУчета.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияОтправлены)
		|					ИЛИ КомплектыОтчетностиПерсУчета.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияСкорректированы)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ КАК ТолькоПросмотр,
		|		КомплектыОтчетностиПерсУчета.Ссылка КАК Ссылка
		|	ИЗ
		|		Справочник.КомплектыОтчетностиПерсУчета КАК КомплектыОтчетностиПерсУчета
		|	ГДЕ
		|		КомплектыОтчетностиПерсУчета.ВедомостьУплатыАДВ11 = &Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА КомплектыОтчетностиПерсУчета.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияОтправлены)
		|					ИЛИ КомплектыОтчетностиПерсУчета.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияСкорректированы)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ,
		|		КомплектыОтчетностиПерсУчета.Ссылка
		|	ИЗ
		|		Справочник.КомплектыОтчетностиПерсУчета КАК КомплектыОтчетностиПерсУчета
		|	ГДЕ
		|		КомплектыОтчетностиПерсУчета.ОписьПачекСЗВ = &Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.Ссылка.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияОтправлены)
		|					ИЛИ КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.Ссылка.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияСкорректированы)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ,
		|		КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.Ссылка
		|	ИЗ
		|		Справочник.КомплектыОтчетностиПерсУчета.СписокПачекСЗВ КАК КомплектыОтчетностиПерсУчетаСписокПачекСЗВ
		|	ГДЕ
		|		КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.ПачкаДокументов = &Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА КомплектыОтчетностиПерсУчетаСписокПачекСЗВ6_3.Ссылка.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияОтправлены)
		|					ИЛИ КомплектыОтчетностиПерсУчетаСписокПачекСЗВ6_3.Ссылка.СостояниеКомплекта = ЗНАЧЕНИЕ(Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияСкорректированы)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ,
		|		КомплектыОтчетностиПерсУчетаСписокПачекСЗВ6_3.Ссылка
		|	ИЗ
		|		Справочник.КомплектыОтчетностиПерсУчета.СписокПачекСЗВ6_3 КАК КомплектыОтчетностиПерсУчетаСписокПачекСЗВ6_3
		|	ГДЕ
		|		КомплектыОтчетностиПерсУчетаСписокПачекСЗВ6_3.ПачкаДокументов = &Ссылка) КАК КомплектыСодержащиеДокумент";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			КомплектОтправленВПФР = ?(Выборка.ТолькоПросмотр = Истина, Истина, Ложь);
			Форма.Комплект = Выборка.Ссылка;
			Если Выборка.ТолькоПросмотр = Истина Тогда
				Форма.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;		
	
КонецПроцедуры	

// Общие обработчики событий форм документов перс. учета не входящих в квартальную отчетность  (СЗВ-6-1(2,3), СПВ-1).

Процедура ДокументыСЗВПриСозданииНаСервере(Форма, ОписаниеДокумента) Экспорт
	Если Форма.Параметры.Ключ.Пустая() Тогда	
		Объект = Форма.Объект;
		
		ДокументыСЗВПриПолученииДанныхНаСервере(Форма, ОписаниеДокумента);
		
		Если Не ЗначениеЗаполнено(Объект.КатегорияЗастрахованныхЛиц)
			И Форма.Элементы.КатегорияЗастрахованныхЛиц.СписокВыбора.Количество() > 0 Тогда 
			Объект.КатегорияЗастрахованныхЛиц = Форма.Элементы.КатегорияЗастрахованныхЛиц.СписокВыбора[0].Значение;
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

Процедура ДокументыСЗВУстановитьКатегориюЗастрахованныхЛицЗаПериод(Форма, ОписаниеДокумента) Экспорт 
	Объект = Форма.Объект;
	
	СписокКатегорийЗастрахованныхЛиц = ДокументыСЗВСписокВыбораКатегорийЗЛ(Объект, ОписаниеДокумента);
	
	Если СписокКатегорийЗастрахованныхЛиц.НайтиПоЗначению(Объект.КатегорияЗастрахованныхЛиц) = Неопределено Тогда 
		Объект.КатегорияЗастрахованныхЛиц = СписокКатегорийЗастрахованныхЛиц[0].Значение;
	КонецЕсли;	
	
	Форма.Элементы.КатегорияЗастрахованныхЛиц.СписокВыбора.ЗагрузитьЗначения(СписокКатегорийЗастрахованныхЛиц.ВыгрузитьЗначения());				
КонецПроцедуры	

Процедура ДокументыСЗВДобавитьКонтрольИсправлений(КонтролируемыеПоляРеквизитФормы, РазделыКонтролируемыхПолей = Неопределено) Экспорт
	
	КонтролируемыеПоляВзносыНачисленные = Новый Массив;
	КонтролируемыеПоляВзносыНачисленные.Добавить("НачисленоСтраховая");
	КонтролируемыеПоляВзносыНачисленные.Добавить("НачисленоНакопительная");
	КонтролируемыеПоляВзносыНачисленные.Добавить("ДоНачисленоСтраховая");
	КонтролируемыеПоляВзносыНачисленные.Добавить("ДоНачисленоНакопительная");
	
	КонтролируемыеПоляВзносыУплаченные = Новый Массив;
	КонтролируемыеПоляВзносыУплаченные.Добавить("УплаченоСтраховая");
	КонтролируемыеПоляВзносыУплаченные.Добавить("УплаченоНакопительная");
	КонтролируемыеПоляВзносыУплаченные.Добавить("ДоУплаченоСтраховая");
	КонтролируемыеПоляВзносыУплаченные.Добавить("ДоУплаченоНакопительная");
	
	КонтролируемыеПоляСтаж = Новый Массив;
	КонтролируемыеПоляСтаж.Добавить("НомерОсновнойЗаписи");
	КонтролируемыеПоляСтаж.Добавить("НомерДополнительнойЗаписи");
	КонтролируемыеПоляСтаж.Добавить("ДатаНачалаПериода");
	КонтролируемыеПоляСтаж.Добавить("ДатаОкончанияПериода");
	КонтролируемыеПоляСтаж.Добавить("ОсобыеУсловияТруда");
	КонтролируемыеПоляСтаж.Добавить("КодПозицииСписка");
	КонтролируемыеПоляСтаж.Добавить("ОснованиеИсчисляемогоСтажа");
	КонтролируемыеПоляСтаж.Добавить("ПервыйПараметрИсчисляемогоСтажа");
	КонтролируемыеПоляСтаж.Добавить("ВторойПараметрИсчисляемогоСтажа");
	КонтролируемыеПоляСтаж.Добавить("ТретийПараметрИсчисляемогоСтажа");
	КонтролируемыеПоляСтаж.Добавить("ОснованиеВыслугиЛет");
	КонтролируемыеПоляСтаж.Добавить("ПервыйПараметрВыслугиЛет");
	КонтролируемыеПоляСтаж.Добавить("ВторойПараметрВыслугиЛет");
	КонтролируемыеПоляСтаж.Добавить("ТретийПараметрВыслугиЛет");
	КонтролируемыеПоляСтаж.Добавить("ТерриториальныеУсловия");
	КонтролируемыеПоляСтаж.Добавить("ДатаОкончанияПериода");
	КонтролируемыеПоляСтаж.Добавить("ПараметрТерриториальныхУсловий");
	КонтролируемыеПоляСтаж.Добавить("ЗамещениеГосударственныхМуниципальныхДолжностей");
	КонтролируемыеПоляСтаж.Добавить("НомерРабочегоМеста");
	КонтролируемыеПоляСтаж.Добавить("КлассПодклассУсловийТруда");
	КонтролируемыеПоляСтаж.Добавить("РайонныйКоэффициент");
	
	КонтролируемыеПоляЗаработок = Новый Массив;
	КонтролируемыеПоляЗаработок.Добавить("ОблагаетсяВзносами");
	КонтролируемыеПоляЗаработок.Добавить("Заработок");
	КонтролируемыеПоляЗаработок.Добавить("Месяц");
	КонтролируемыеПоляЗаработок.Добавить("ОблагаетсяВзносамиДоПредельнойВеличины");
	КонтролируемыеПоляЗаработок.Добавить("ОблагаетсяВзносамиСвышеПредельнойВеличины");
	КонтролируемыеПоляЗаработок.Добавить("ОблагаетсяВзносамиЗаЗанятыхНаПодземныхИВредныхРаботах");
	КонтролируемыеПоляЗаработок.Добавить("ОблагаетсяВзносамиЗаЗанятыхНаТяжелыхИПрочихРаботах");
	КонтролируемыеПоляЗаработок.Добавить("КатегорияЗастрахованныхЛиц");
	КонтролируемыеПоляЗаработок.Добавить("ПоДоговорамГПХДоПредельнойВеличины");
	
	КонтролируемыеПоляЗаработокВредный = Новый Массив;
	
	КонтролируемыеПоляЗаработокВредный.Добавить("КлассУсловийТруда");
	КонтролируемыеПоляЗаработокВредный.Добавить("Месяц");
	КонтролируемыеПоляЗаработокВредный.Добавить("ОблагаетсяВзносамиЗаЗанятыхНаПодземныхИВредныхРаботах");
	КонтролируемыеПоляЗаработокВредный.Добавить("ОблагаетсяВзносамиЗаЗанятыхНаТяжелыхИПрочихРаботах");

	КонтролируемыПоля = Новый Структура;
	
	Если РазделыКонтролируемыхПолей = Неопределено
		Или РазделыКонтролируемыхПолей.Найти("НачисленныеВзносы") <> Неопределено Тогда 
		
		ОписаниеКонтролируемыхПолей = Новый Структура("ИмяПоляФиксДанных, КонтролируемыеПоля", "ФиксНачисленныеВзносы", Новый ФиксированныйМассив(КонтролируемыеПоляВзносыНачисленные));
		
		КонтролируемыПоля.Вставить("НачисленныеВзносы", Новый ФиксированнаяСтруктура(ОписаниеКонтролируемыхПолей));
	КонецЕсли;	
	
	Если РазделыКонтролируемыхПолей = Неопределено
		Или РазделыКонтролируемыхПолей.Найти("УплаченныеВзносы") <> Неопределено Тогда
		
		ОписаниеКонтролируемыхПолей = Новый Структура("ИмяПоляФиксДанных, КонтролируемыеПоля", "ФиксУплаченныеВзносы", Новый ФиксированныйМассив(КонтролируемыеПоляВзносыУплаченные));
		
		КонтролируемыПоля.Вставить("УплаченныеВзносы",  Новый ФиксированнаяСтруктура(ОписаниеКонтролируемыхПолей));
	КонецЕсли;	
	
	Если РазделыКонтролируемыхПолей = Неопределено
		Или РазделыКонтролируемыхПолей.Найти("Стаж") <> Неопределено Тогда
		
		ОписаниеКонтролируемыхПолей = Новый Структура("ИмяПоляФиксДанных, КонтролируемыеПоля", "ФиксСтаж", Новый ФиксированныйМассив(КонтролируемыеПоляСтаж));
		
		КонтролируемыПоля.Вставить("Стаж",  Новый ФиксированнаяСтруктура(ОписаниеКонтролируемыхПолей));	
	КонецЕсли;	
	
	Если РазделыКонтролируемыхПолей = Неопределено
		Или РазделыКонтролируемыхПолей.Найти("Заработок") <> Неопределено Тогда
		
		ОписаниеКонтролируемыхПолей = Новый Структура("ИмяПоляФиксДанных, КонтролируемыеПоля", "ФиксЗаработок", Новый ФиксированныйМассив(КонтролируемыеПоляЗаработок));
		
		КонтролируемыПоля.Вставить("Заработок", Новый ФиксированнаяСтруктура(ОписаниеКонтролируемыхПолей));
	КонецЕсли;	
	
	Если РазделыКонтролируемыхПолей = Неопределено
		Или РазделыКонтролируемыхПолей.Найти("ЗаработокВредный") <> Неопределено Тогда
		
		ОписаниеКонтролируемыхПолей = Новый Структура("ИмяПоляФиксДанных, КонтролируемыеПоля", "ФиксЗаработок", Новый ФиксированныйМассив(КонтролируемыеПоляЗаработокВредный));
		
		КонтролируемыПоля.Вставить("ФиксЗаработокВредный", Новый ФиксированнаяСтруктура(ОписаниеКонтролируемыхПолей));
	КонецЕсли;	
			
	КонтролируемыеПоляРеквизитФормы = Новый ФиксированнаяСтруктура(КонтролируемыПоля);

КонецПроцедуры	

Функция ДокументыСЗВСписокВыбораКатегорийЗЛ(Объект, ОписаниеДокумента)
	Если ВРег(ОписаниеДокумента.ВариантОтчетногоПериода) = "КВАРТАЛ"
		И ОписаниеДокумента.ЕстьКорректируемыйПериод Тогда
		
		ОтчетныйПериод = ?(Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, Объект.ОтчетныйПериод, Объект[ОписаниеДокумента.ИмяПоляКорректируемыйПериод]);
		ОкончаниеОтчетногоПериода = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);	
	ИначеЕсли ВРег(ОписаниеДокумента.ВариантОтчетногоПериода) = "КВАРТАЛ" Тогда
		ОтчетныйПериод = Объект.ОтчетныйПериод;
		ОкончаниеОтчетногоПериода = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	Иначе
		ОтчетныйПериод = Дата(Объект.ОтчетныйПериод, 1, 1);
		ОкончаниеОтчетногоПериода = Дата(Объект.ОтчетныйПериод, 12, 31);	
	КонецЕсли;	
	
	КорректирующиеСведения = Не Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ;
	
	Возврат ПерсонифицированныйУчет.КатегорииЗастрахованныхЛицОрганизации(
										Объект.Организация,
										ОтчетныйПериод, 
										ОкончаниеОтчетногоПериода,
										КорректирующиеСведения);
	
КонецФункции

Процедура ДокументыСЗВПриПолученииДанныхНаСервере(Форма, ОписаниеДокумента) Экспорт
	Объект = Форма.Объект;
	
	СписокКатегорийЗастрахованныхЛиц = ДокументыСЗВСписокВыбораКатегорийЗЛ(Объект, ОписаниеДокумента);
	Если ЗначениеЗаполнено(Объект.КатегорияЗастрахованныхЛиц)
		И СписокКатегорийЗастрахованныхЛиц.НайтиПоЗначению(Объект.КатегорияЗастрахованныхЛиц) = Неопределено Тогда
		
		СписокКатегорийЗастрахованныхЛиц.Вставить(0, Объект.КатегорияЗастрахованныхЛиц);
	КонецЕсли;	
	
	Форма.Элементы.КатегорияЗастрахованныхЛиц.СписокВыбора.ЗагрузитьЗначения(СписокКатегорийЗастрахованныхЛиц.ВыгрузитьЗначения());	
КонецПроцедуры

// Общие обработчики событий форм документов перс. учета содержащих сведения о стаже и взносах  (СЗВ-6-1(2,3), СПВ-1).

Процедура УстановитьКраткоеОтображениеКатегорииВТаблицах(Форма, ПутьКДанным, ИмяЭлемента) Экспорт 	
	Для Каждого ОписаниеЗначения Из Метаданные.Перечисления.КатегорииЗастрахованныхЛицДляПФР.ЗначенияПеречисления Цикл
		ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ОписаниеЗначения.Имя + Символы.ПС + ОписаниеЗначения.Синоним);
		
		Отбор = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКДанным);
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Перечисления.КатегорииЗастрахованныхЛицДляПФР[ОписаниеЗначения.Имя];
		
		ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяЭлемента);
	КонецЦикла;		
КонецПроцедуры	

Процедура ДокументыСведенийОВзносахИСтажеПриПолученииДанныхНаСервере(Форма) Экспорт 
	Форма.ПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Форма.Объект.ОтчетныйПериод);
	
	ПерсонифицированныйУчетКлиентСервер.ДокументыСведенийОВзносахИСтажеУстановитьДоступностьЭлементов(Форма);	
	
	Форма.КорректируемыйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Форма.Объект.КорректируемыйПериод);
КонецПроцедуры	

#Область МеханизмОтображенияЗаголовковКолонокТаблицы

Процедура ДобавитьЗаголовкиКПолямТаблицФормы(Форма, ИменаДополняемыхТаблиц, ОписаниеКолонокЗаголовковТаблицФормы) Экспорт
	
	ДобавляемыеРеквизиты = Новый Массив;
		
	Для Каждого ИмяТаблицы Из ИменаДополняемыхТаблиц Цикл
		ОписаниеКолонокЗаголовков = ОписаниеКолонокЗаголовковТаблицФормы[ИмяТаблицы];
		
		Таблица = Форма.Элементы.Найти(ИмяТаблицы);
		
		Если Таблица = Неопределено
			Или ОписаниеКолонокЗаголовков = Неопределено Тогда
			
			Продолжить;
		КонецЕсли;	
		
		ПерсонифицированныйУчетКлиентСервер.ЗаполнитьТекстыЗаголовковКолонокПоУмолчанию(Форма, ОписаниеКолонокЗаголовков);
		
		ПутьКДаннымТаблицы = Таблица.ПутьКДанным;
		Для Каждого ОписаниеЗаголовка Из ОписаниеКолонокЗаголовков Цикл
			КлассификаторСтроки = Новый КвалификаторыСтроки(СтрДлина(ОписаниеЗаголовка.Заголовок) + 1);
			
			ТипЗаголовка = Новый ОписаниеТипов("Строка", , КлассификаторСтроки);
			
			РеквизитЗаголовок = Новый РеквизитФормы(ОписаниеЗаголовка.ПолеТаблицы + "Заголовок", ТипЗаголовка, ПутьКДаннымТаблицы);
			
			ДобавляемыеРеквизиты.Добавить(РеквизитЗаголовок);	
		КонецЦикла;
		
	КонецЦикла;	
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	УсловноеОформлениеВидимостиПолей = Новый Соответствие;
	
	Для Каждого ЭлементОформления Из Форма.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Видимость")).Использование Тогда
			Для Каждого ОформляемоеПоле Из ЭлементОформления.Поля.Элементы Цикл
				Если ОформляемоеПоле.Использование Тогда
					ЭлементыОформленияПоля = УсловноеОформлениеВидимостиПолей.Получить(ОформляемоеПоле.Поле);
					
					Если ЭлементыОформленияПоля = Неопределено Тогда
						ЭлементыОформленияПоля = Новый Массив;
						УсловноеОформлениеВидимостиПолей.Вставить(ОформляемоеПоле.Поле, ЭлементыОформленияПоля);
					КонецЕсли;
					
					ЭлементыОформленияПоля.Добавить(ЭлементОформления);
				КонецЕсли;
			КонецЦикла;		
		КонецЕсли;	
	КонецЦикла;	
	
	Для Каждого ИмяТаблицы Из ИменаДополняемыхТаблиц Цикл
		ОписаниеКолонокЗаголовков = ОписаниеКолонокЗаголовковТаблицФормы[ИмяТаблицы];
		
		Таблица = Форма.Элементы.Найти(ИмяТаблицы);
		
		Если Таблица = Неопределено
			Или ОписаниеКолонокЗаголовков = Неопределено Тогда
			
			Продолжить;
		КонецЕсли;	
		
		ПутьКДаннымТаблицы = Таблица.ПутьКДанным;
		Для Каждого ОписаниеЗаголовка Из ОписаниеКолонокЗаголовков Цикл
			ПолеТаблицы = Форма.Элементы.Найти(ОписаниеЗаголовка.ПолеТаблицы);
			
			ПолеТаблицы.ОтображатьВШапке = Ложь;
			
			Если ПолеТаблицы = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ГруппаЗаголовка = Форма.Элементы.Вставить(ПолеТаблицы.Имя + "ЗаголовокГруппа", Тип("ГруппаФормы"), ПолеТаблицы.Родитель, ПолеТаблицы);
			ГруппаЗаголовка.Вид = ВидГруппыФормы.ГруппаКолонок;
			ГруппаЗаголовка.ОтображатьВШапке = Ложь;
			ГруппаЗаголовка.Группировка = ГруппировкаКолонок.Горизонтальная;
			
			ПолеЗаголовка = Форма.Элементы.Добавить(ПолеТаблицы.Имя + "Заголовок", Тип("ПолеФормы"), ГруппаЗаголовка);
			ПолеЗаголовка.ПутьКДанным = ПутьКДаннымТаблицы + "." + ПолеТаблицы.Имя + "Заголовок";
			ПолеЗаголовка.Вид = ВидПоляФормы.ПолеНадписи;
			ПолеЗаголовка.ТолькоПросмотр = Истина;
			ПолеЗаголовка.ОтображатьВШапке = Ложь;
			ПолеЗаголовка.Шрифт = Новый Шрифт(ПолеТаблицы.Шрифт,,,,Истина);
			ПолеЗаголовка.РастягиватьПоГоризонтали = Ложь;
			
			Если ОписаниеЗаголовка.Ширина = 0 Тогда
				ПолеЗаголовка.Ширина = СтрДлина(ОписаниеЗаголовка.Заголовок) + 1;
			Иначе
				ПолеЗаголовка.Ширина = ОписаниеЗаголовка.Ширина;
			КонецЕсли;	
			
			Форма.Элементы.Переместить(ПолеТаблицы, ГруппаЗаголовка);
			
			ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ПолеТаблицы.Имя);
			
			ЭлементыОформленияПоля = УсловноеОформлениеВидимостиПолей.Получить(ПолеКомпоновки);
			
			Если ЭлементыОформленияПоля <> Неопределено Тогда
				Для Каждого ЭлементОформления Из ЭлементыОформленияПоля Цикл
					ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
					ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ПолеЗаголовка.Имя);
				КонецЦикла;	
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры	

Функция ИмяЭлементаОтображенияЗаголовкаПоляТаблицы(ПолеТаблицы, ОписаниеКолонокЗаголовковТаблицы) Экспорт
	Возврат ПолеТаблицы + "Заголовок";		
КонецФункции	

Процедура УстановитьВидимостьКолонокЗаголовков(Форма, ИмяТаблицы, ОписаниеКолонокЗаголовковТаблицы) Экспорт	
	Для Каждого ОписаниеКолонки Из ОписаниеКолонокЗаголовковТаблицы Цикл
		КолонкаТаблицы = Форма.Элементы.Найти(ОписаниеКолонки.ПолеТаблицы);
		Видимость = ?(КолонкаТаблицы = Неопределено, Ложь, КолонкаТаблицы.Видимость);
		
		КолонкаЗаголовок = Форма.Элементы.Найти(ОписаниеКолонки.ПолеТаблицы + "Заголовок");
		
		Если КолонкаЗаголовок <> Неопределено Тогда
			КолонкаЗаголовок.Видимость = Видимость;
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	

// Механизм отображения ошибок.

Функция ДобавитьЭлементСоответствияДанныхОбъектаДаннымФормы(СоответствиеДанныхОбъектаДаннымФормы, ТипОбъекта, ПутьКДаннымОбъекта, ПутьКДаннымФормы, Владелец = Неопределено, КлючСвязи = Неопределено) Экспорт	
	
	Если ТипЗнч(ТипОбъекта) = Тип("Массив") Тогда
		Для Каждого Тип Из ТипОбъекта Цикл 
			СоответствиеПолей = СоответствиеДанныхОбъектаДаннымФормы.Получить(Тип);
		
			Если СоответствиеПолей = Неопределено Тогда
				СоответствиеПолей = Новый Соответствие;
				СоответствиеДанныхОбъектаДаннымФормы.Вставить(Тип, СоответствиеПолей);	
			КонецЕсли;	
		
			СоответствиеПолей.Вставить(ПутьКДаннымОбъекта, Новый Структура("ПутьКДаннымФормы, Владелец, КлючСвязи", ПутьКДаннымФормы, Владелец, КлючСвязи));
	
		КонецЦикла;		
	Иначе		
		СоответствиеПолей = СоответствиеДанныхОбъектаДаннымФормы.Получить(ТипОбъекта);
		
		Если СоответствиеПолей = Неопределено Тогда
			СоответствиеПолей = Новый Соответствие;
			СоответствиеДанныхОбъектаДаннымФормы.Вставить(ТипОбъекта, СоответствиеПолей);	
		КонецЕсли;	
		
		СоответствиеПолей.Вставить(ПутьКДаннымОбъекта, Новый Структура("ПутьКДаннымФормы, Владелец, КлючСвязи", ПутьКДаннымФормы, Владелец, КлючСвязи));
	КонецЕсли;	
	
КонецФункции	

// Дополнение формы списка квартальной отчетности.

Процедура КвартальнаяОтчетностьПФРДополнитьКомандыФормы(Форма) Экспорт
	ПерсонифицированныйУчетВнутренний.КвартальнаяОтчетностьПФРДополнитьКомандыФормы(Форма);	
КонецПроцедуры	

Процедура КвартальнаяОтчетностьПФРОбновитьДанныеФормы(Форма) Экспорт
	ПерсонифицированныйУчетВнутренний.КвартальнаяОтчетностьПФРОбновитьДанныеФормы(Форма);	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти
