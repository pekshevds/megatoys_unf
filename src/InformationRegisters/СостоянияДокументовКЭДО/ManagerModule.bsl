#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Объект)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьСостоянияДокументовКЭДО(ДокументыКЭДО) Экспорт
	
	ДанныеДляРасчета = ДанныеДляРасчетаСостоянийДокументовКЭДО(ДокументыКЭДО);
	Для Каждого ДанныеДокумента Из ДанныеДляРасчета Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДокументыКЭДОКПересчетуСостояний");
			ЭлементБлокировки.УстановитьЗначение("Объект", ДанныеДокумента.Ключ);
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияДокументовКЭДО");
			ЭлементБлокировки.УстановитьЗначение("Объект", ДанныеДокумента.Ключ);
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.СостоянияДокументовКЭДО.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Объект.Установить(ДанныеДокумента.Ключ);
			
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьСостояниеДокументаКЭДО(Запись, ДанныеДокумента.Значение);
			Запись.Объект = ДанныеДокумента.Ключ;
			
			НаборЗаписей.Записать();
			
			НаборЗаписей = РегистрыСведений.ДокументыКЭДОКПересчетуСостояний.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Объект.Установить(ДанныеДокумента.Ключ);
			НаборЗаписей.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			Ошибка = ИнформацияОбОшибке();
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСостояния(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ДокументКадровогоЭДО.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовКЭДО КАК СостоянияДокументовКЭДО
		|		ПО ДокументКадровогоЭДО.Ссылка = СостоянияДокументовКЭДО.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыКЭДОКПересчетуСостояний КАК ДокументыКЭДОКПересчетуСостояний
		|		ПО ДокументКадровогоЭДО.Ссылка = ДокументыКЭДОКПересчетуСостояний.Объект
		|ГДЕ
		|	НЕ ДокументКадровогоЭДО.Ссылка В (&МассивОбновленных)
		|	И СостоянияДокументовКЭДО.Объект ЕСТЬ NULL
		|	И ДокументыКЭДОКПересчетуСостояний.Объект ЕСТЬ NULL";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	ДокументыКЗаполнениюСостояний = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ДокументыКЗаполнениюСостояний.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	ДанныеДляРасчета = ДанныеДляРасчетаСостоянийДокументовКЭДО(ДокументыКЗаполнениюСостояний);
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		
		МассивОбновленных.Добавить(Выборка.Ссылка);
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрСведений.СостоянияДокументовКЭДО", "Объект", Выборка.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеДокумента = ДанныеДляРасчета.Получить(Выборка.Ссылка);
		Если ДанныеДокумента <> Неопределено Тогда
			
			НаборЗаписей = РегистрыСведений.СостоянияДокументовКЭДО.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Объект.Установить(Выборка.Ссылка);
			
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьСостояниеДокументаКЭДО(Запись, ДанныеДокумента);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеДляРасчетаСостоянийДокументовКЭДО(ДокументыКЭДО)
	
	ДанныеДляРасчетаСостояний = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументыКЭДО", ДокументыКЭДО);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументКадровогоЭДО.Ссылка КАК Ссылка,
		|	ДокументКадровогоЭДО.ЭлектронныйДокумент КАК ЭлектронныйДокумент,
		|	ДокументКадровогоЭДО.Расширение КАК Расширение,
		|	ДокументКадровогоЭДО.Внешний КАК Внешний
		|ПОМЕСТИТЬ ВТДанныеДокументовКЭДО
		|ИЗ
		|	Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
		|ГДЕ
		|	ДокументКадровогоЭДО.Ссылка В(&ДокументыКЭДО)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокументовКЭДО.Ссылка КАК Ссылка,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ) КАК ОжидаетПодписания,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Ознакомиться)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ) КАК ТребуетВнимания
		|ПОМЕСТИТЬ ВТЗапланированныеДействия
		|ИЗ
		|	РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокументовКЭДО КАК ДанныеДокументовКЭДО
		|		ПО ТаблицаРегистра.ПрисоединенныйФайл = ДанныеДокументовКЭДО.ЭлектронныйДокумент
		|ГДЕ
		|	ТаблицаРегистра.Действие В (ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать), ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Ознакомиться))
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДокументовКЭДО.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПодписиДокументовКЭДО.Объект КАК Объект,
		|	ПодписиДокументовКЭДО.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПодписиДокументовКЭДО.Отпечаток КАК Отпечаток,
		|	ПодписиДокументовКЭДО.ДатаПодписи КАК ДатаПодписи,
		|	ПодписиДокументовКЭДО.РезультатСогласования КАК РезультатСогласования
		|ПОМЕСТИТЬ ВТПодписи
		|ИЗ
		|	РегистрСведений.ПодписиДокументовКЭДО КАК ПодписиДокументовКЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокументовКЭДО КАК ДанныеДокументовКЭДО
		|		ПО ПодписиДокументовКЭДО.Объект = ДанныеДокументовКЭДО.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументКадровогоЭДОВнешниеПодписанты.Ссылка КАК Ссылка,
		|	ДокументКадровогоЭДОВнешниеПодписанты.ФизическоеЛицо КАК ФизическоеЛицо,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ПодписанныеОбъектыПользователей.ПодписанныйОбъект ЕСТЬ NULL
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ) КАК ЕстьПодписи
		|ПОМЕСТИТЬ ВТПодписанты
		|ИЗ
		|	Документ.ДокументКадровогоЭДО.ВнешниеПодписанты КАК ДокументКадровогоЭДОВнешниеПодписанты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокументовКЭДО КАК ДанныеДокументовКЭДО
		|		ПО ДокументКадровогоЭДОВнешниеПодписанты.Ссылка = ДанныеДокументовКЭДО.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодписанныеОбъектыПользователей КАК ПодписанныеОбъектыПользователей
		|		ПО (ДанныеДокументовКЭДО.ЭлектронныйДокумент = ПодписанныеОбъектыПользователей.ПодписанныйОбъект)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДокументКадровогоЭДОВнешниеПодписанты.Ссылка,
		|	ДокументКадровогоЭДОВнешниеПодписанты.ФизическоеЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокументовКЭДО.Ссылка КАК Объект,
		|	ДанныеДокументовКЭДО.Расширение КАК Расширение,
		|	ДанныеДокументовКЭДО.Внешний КАК Внешний,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Подписанты.ФизическоеЛицо) КАК КоличествоПодписантов,
		|	СУММА(ВЫБОР
		|			КОГДА ЕСТЬNULL(Подписи.РезультатСогласования, ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.ПустаяСсылка)) = ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.Отклонено)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоОтказов,
		|	СУММА(ВЫБОР
		|			КОГДА ЕСТЬNULL(Подписи.РезультатСогласования, ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.Отклонено)
		|				ТОГДА ВЫБОР
		|						КОГДА ЕСТЬNULL(Подписи.Отпечаток, """") <> """"
		|							ТОГДА 1
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоУНЭПУКЭП,
		|	СУММА(ВЫБОР
		|			КОГДА ЕСТЬNULL(Подписи.РезультатСогласования, ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.Отклонено)
		|				ТОГДА ВЫБОР
		|						КОГДА ЕСТЬNULL(Подписи.Отпечаток, НЕОПРЕДЕЛЕНО) = """"
		|							ТОГДА 1
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоБезУНЭПУКЭП,
		|	СУММА(ВЫБОР
		|			КОГДА ЕСТЬNULL(Подписи.РезультатСогласования, ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.РезультатыСогласованияБЗК.Отклонено)
		|				ТОГДА ВЫБОР
		|						КОГДА Подписи.ФизическоеЛицо ЕСТЬ NULL
		|							ТОГДА 1
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоНеОзнакомленных,
		|	ЕСТЬNULL(Подписанты.ЕстьПодписи, ЛОЖЬ) КАК ЕстьПодписи,
		|	ЕСТЬNULL(ЗапланированныеДействия.ОжидаетПодписания, ЛОЖЬ) КАК ОжидаетПодписания,
		|	ЕСТЬNULL(ЗапланированныеДействия.ТребуетВнимания, ЛОЖЬ) КАК ТребуетВнимания,
		|	ЕСТЬNULL(ЭлектронныеПодписи.КоличествоПодписей, 0) КАК ОбщееКоличествоУНЭПУКЭП,
		|	ЕСТЬNULL(ПодписанныеПечатныеФормы.ЭтоПечатнаяФорма, ЛОЖЬ) КАК ЭтоПечатнаяФорма
		|ИЗ
		|	ВТДанныеДокументовКЭДО КАК ДанныеДокументовКЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПодписанты КАК Подписанты
		|		ПО ДанныеДокументовКЭДО.Ссылка = Подписанты.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПодписи КАК Подписи
		|		ПО ДанныеДокументовКЭДО.Ссылка = Подписи.Объект
		|			И (Подписанты.ФизическоеЛицо = Подписи.ФизическоеЛицо)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗапланированныеДействия КАК ЗапланированныеДействия
		|		ПО ДанныеДокументовКЭДО.Ссылка = ЗапланированныеДействия.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ПодписанныеПечатныеФормы.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
		|			МАКСИМУМ(ИСТИНА) КАК ЭтоПечатнаяФорма
		|		ИЗ
		|			ВТДанныеДокументовКЭДО КАК ДанныеДокументовКЭДО
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеПечатныеФормы
		|				ПО ДанныеДокументовКЭДО.ЭлектронныйДокумент = ПодписанныеПечатныеФормы.ПрисоединенныйФайл
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ПодписанныеПечатныеФормы.ПрисоединенныйФайл) КАК ПодписанныеПечатныеФормы
		|		ПО ДанныеДокументовКЭДО.ЭлектронныйДокумент = ПодписанныеПечатныеФормы.ПрисоединенныйФайл
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ЭлектронныеПодписи.ПодписанныйОбъект КАК ПодписанныйОбъект,
		|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЭлектронныеПодписи.ПорядковыйНомер) КАК КоличествоПодписей
		|		ИЗ
		|			ВТДанныеДокументовКЭДО КАК ДанныеДокументовКЭДО
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЭлектронныеПодписи КАК ЭлектронныеПодписи
		|				ПО ДанныеДокументовКЭДО.ЭлектронныйДокумент = ЭлектронныеПодписи.ПодписанныйОбъект
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ЭлектронныеПодписи.ПодписанныйОбъект) КАК ЭлектронныеПодписи
		|		ПО ДанныеДокументовКЭДО.ЭлектронныйДокумент = ЭлектронныеПодписи.ПодписанныйОбъект
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДокументовКЭДО.Ссылка,
		|	ДанныеДокументовКЭДО.Расширение,
		|	ДанныеДокументовКЭДО.Внешний,
		|	Подписанты.ЕстьПодписи,
		|	ЗапланированныеДействия.ОжидаетПодписания,
		|	ЗапланированныеДействия.ТребуетВнимания,
		|	ЭлектронныеПодписи.КоличествоПодписей,
		|	ПодписанныеПечатныеФормы.ЭтоПечатнаяФорма";
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеСостояний = ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);
	Для Каждого Данныеобъекта Из ДанныеСостояний Цикл
		ДанныеДляРасчетаСостояний.Вставить(Данныеобъекта.Объект, Данныеобъекта);
	КонецЦикла;
	
	Возврат ДанныеДляРасчетаСостояний
	
КонецФункции

Процедура ЗаполнитьСостояниеДокументаКЭДО(Запись, ДанныеДокумента)
	
	ЗаполнитьЗначенияСвойств(Запись, ДанныеДокумента);
	
	СостояниеПодписей = "";
	Запись.КоличествоПодписейОтветственныхЛиц = Макс(ДанныеДокумента.ОбщееКоличествоУНЭПУКЭП - ДанныеДокумента.КоличествоУНЭПУКЭП, 0);
	Если Запись.КоличествоОтказов > 0 Тогда
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Отклонено (%1)'"),
			Запись.КоличествоОтказов);
	ИначеЕсли Запись.КоличествоНеОзнакомленных > 0
		И Запись.КоличествоУНЭПУКЭП = 0
		И Запись.КоличествоПЭП = 0 Тогда
		
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Не подписано (%1)'"),
			Запись.КоличествоНеОзнакомленных);
	ИначеЕсли Запись.КоличествоУНЭПУКЭП > 0
		И Запись.КоличествоПЭП = 0
		И Запись.КоличествоНеОзнакомленных = 0 Тогда
		
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Подписано ЭП (%1)'"),
			Запись.КоличествоУНЭПУКЭП);
	ИначеЕсли Запись.КоличествоПЭП > 0
		И Запись.КоличествоУНЭПУКЭП = 0
		И Запись.КоличествоНеОзнакомленных = 0 Тогда
		
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Требуется собственноручная подпись (%1)'"),
			Запись.КоличествоПЭП);
	ИначеЕсли Запись.КоличествоУНЭПУКЭП > 0
		И Запись.КоличествоПЭП > 0
		И Запись.КоличествоНеОзнакомленных = 0 Тогда
		
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Подписано ЭП (%1), требуется собственноручная подпись (%2)'"),
			Запись.КоличествоУНЭПУКЭП,
			Запись.КоличествоПЭП);
	ИначеЕсли Запись.КоличествоУНЭПУКЭП > 0
		И Запись.КоличествоНеОзнакомленных > 0
		И Запись.КоличествоПЭП = 0 Тогда
		
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Подписано ЭП (%1), не подписано (%2)'"),
			Запись.КоличествоУНЭПУКЭП,
			Запись.КоличествоНеОзнакомленных);
	ИначеЕсли Запись.КоличествоПЭП > 0
		И Запись.КоличествоНеОзнакомленных > 0
		И Запись.КоличествоУНЭПУКЭП = 0 Тогда
		
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Требуется собственноручная подпись (%1), не подписано (%2)'"),
			Запись.КоличествоПЭП,
			Запись.КоличествоНеОзнакомленных);
	ИначеЕсли Запись.КоличествоУНЭПУКЭП = 0
		И Запись.КоличествоПЭП = 0
		И Запись.КоличествоНеОзнакомленных = 0 Тогда
		
		СостояниеПодписей = НСтр("ru = 'Подписи не требуются'");
	Иначе
		СостояниеПодписей = СтрШаблон(
			НСтр("ru = 'Подписано ЭП (%1), требуется собственноручная подпись (%2), не подписано (%3)'"),
			Запись.КоличествоУНЭПУКЭП,
			Запись.КоличествоПЭП,
			Запись.КоличествоНеОзнакомленных);
	КонецЕсли;
	Если Запись.КоличествоПодписантов = 1 Тогда
		Запись.СостояниеПодписей = СтрЗаменить(СостояниеПодписей, " (1)", "");
	Иначе
		Запись.СостояниеПодписей = СостояниеПодписей;
	КонецЕсли;
	Если ДанныеДокумента.ОбщееКоличествоУНЭПУКЭП > 0 Тогда
		Если ДанныеДокумента.ЭтоПечатнаяФорма Тогда
			Если ДанныеДокумента.Внешний Тогда
				Запись.ЕстьВерсияДляПечати = КадровыйЭДОКлиентСервер.ЭтоРасширениеФайлаСПредставлением(ДанныеДокумента.Расширение);
			Иначе
				Запись.ЕстьВерсияДляПечати = Не КадровыйЭДОКлиентСервер.ЭтоРасширениеJSONДокумента(ДанныеДокумента.Расширение);
			КонецЕсли;
		Иначе
			Запись.ЕстьВерсияДляПечати = КадровыйЭДОКлиентСервер.ЭтоРасширениеФайлаСПредставлением(ДанныеДокумента.Расширение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли



