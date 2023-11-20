#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПерсонифицированныйУчетКлиентСервер.ЭтоФормаЕФС1(Год(ОтчетныйПериод)) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяФайлаДляПФР) Тогда
		ИмяФайлаДляПФР = ПерсонифицированныйУчет.ИмяФайлаЕФС1(Организация, Дата);
	Иначе		
		УИДИзИмениФайла = Прав(ИмяФайлаДляПФР, 36);
		Если Не СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(УИДИзИмениФайла) Тогда
			УИДИзИмениФайла = Строка(Новый УникальныйИдентификатор);	
		КонецЕсли;	
		ИмяФайлаДляПФР = ПерсонифицированныйУчет.ИмяФайлаЕФС1(Организация, Дата, УИДИзИмениФайла);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = Неопределено;
	ЕстьВзносыРаботодателя = ПолучитьДанныеДляПроведения(ДанныеДляПроведения);
	
	Если ЕстьВзносыРаботодателя Тогда
		
		// Учет начислений
		// Заполним описание данных для проведения в учете начисленной зарплаты.
		ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
		ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
		ДанныеДляПроведенияУчетЗарплаты.Организация 			= Организация;
		ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= НачалоМесяца(ДатаИсполненияПлатежногоПоручения);
		ДанныеДляПроведенияУчетЗарплаты.ПланируемаяДатаВыплаты	= ДатаИсполненияПлатежногоПоручения;
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисления(ДанныеДляПроведенияУчетЗарплаты, Отказ, Неопределено, ДанныеДляПроведения.Доходы);
		
		// НДФЛ
		УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, Организация, ДатаИсполненияПлатежногоПоручения, ДанныеДляПроведения.ДоходыНДФЛ);
		
		// Страховые взносы
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВДПоЕжемесячнойДоле(Организация, НачалоМесяца(ДатаИсполненияПлатежногоПоручения), ДанныеДляПроведения.МенеджерВременныхТаблиц);
		СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, Организация, ДатаИсполненияПлатежногоПоручения, ДанныеДляПроведения.МенеджерВременныхТаблиц, , Ложь);
		
		Для каждого СтрокаДвижений Из Движения.СведенияОДоходахСтраховыеВзносы Цикл
			СтрокаДвижений.Начисление = Перечисления.ВидыОсобыхНачисленийИУдержаний.ДСВРаботодателя
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт 
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);

	ПроверяемыеРеквизитыСотрудника = Новый Массив;
	ПроверяемыеРеквизитыСотрудника.Добавить("Сотрудники.СтраховойНомерПФР");
	
	НеПроверяемыеРеквизиты = Новый Массив;
		
	НаименованиеОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	
	ВыборкаСотрудникиДляПроверки = СформироватьЗапросПоСотрудникамДляПроверки().Выбрать();
	
	Пока ВыборкаСотрудникиДляПроверки.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Сотрудник) Тогда
			
			Если Не ВыборкаСотрудникиДляПроверки.СотрудникРаботаетВОрганизации Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2: не работает в организации %3.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование, НаименованиеОрганизации);     
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			Если ВыборкаСотрудникиДляПроверки.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %2 была введена в документе ранее.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			ПерсонифицированныйУчет.ПроверитьФИОСотрудника(ВыборкаСотрудникиДляПроверки, Отказ);			
			ФизическиеЛицаЗарплатаКадры.ПроверитьПерсональныеДанныеСотрудника(Ссылка, ВыборкаСотрудникиДляПроверки, ПроверяемыеРеквизитыСотрудника, НеПроверяемыеРеквизиты, Дата, Истина, Отказ);
			
			Если (Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ВзносыРаботника)) И (Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ВзносыРаботодателя))  Тогда 
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2: не заполнена информация о взносах'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ВзносыРаботника",,Отказ);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует движения по регистрам подсистемы.
//	 
// Параметры:
//		Движения - коллекция движений регистратора.
//		Отказ - признак отказа от заполнения движений.
//		Организация - СправочникСсылка.Организации - должно быть непустым значением.
//		ПериодРегистрации - дата -
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - содержит временные таблицы ВТНачисления и
//		                                                    ВТНачисленияСДаннымиЕНВД поля таблицы ВТНачисления.
//				Сотрудник
//				Подразделение
//				Начисление
//				ДатаНачала 
//				СуммаДохода
//				СуммаВычетаВзносы
//     	         и, возможно, другими - см. описание метода СформироватьВТНачисленияСДаннымиУчета()
//      	поля таблицы ВТНачисленияСДаннымиЕНВД
//				Сотрудник
//				Начисление
//				Подразделение
//				ДатаНачала
//				ДоляЕНВД - число от 0 до 1.
//	
//		ПроверятьЕНВД - булево -
//		Записывать - булево - признак того, надо ли записывать движения сразу, или они будут записаны позже.
//
Процедура СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, Организация, ПериодРегистрации, МенеджерВременныхТаблиц, ПроверятьЕНВД = Ложь, Записывать = Ложь) Экспорт
	
	УчетСтраховыхВзносов.СформироватьВТКадровыхДанных(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);
	УчетСтраховыхВзносов.СформироватьВТСДаннымиУчета(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);
	УчетСтраховыхВзносовБазовый.СформироватьВТНачисленияСДаннымиУчета(Организация, ПериодРегистрации, МенеджерВременныхТаблиц);
	
	СведенияОДоходахСтраховыеВзносы = УчетСтраховыхВзносов.СведенияОДоходахСУчетомЕНВД(МенеджерВременныхТаблиц);
	УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, Организация, ПериодРегистрации, СведенияОДоходахСтраховыеВзносы, Записывать);
	
КонецПроцедуры

Функция  СформироватьЗапросПоСотрудникамДляПроверки()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.Фамилия,
	|	ТаблицаСотрудники.Имя,
	|	ТаблицаСотрудники.СтраховойНомерПФР,
	|	ТаблицаСотрудники.ВзносыРаботника,
	|	ТаблицаСотрудники.ВзносыРаботодателя,
	|	ТаблицаСотрудники.НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК ТаблицаСотрудники";
	
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, НачалоМесяца(ОтчетныйПериод), ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СотрудникиДокумента.ВзносыРаботника,
	|	СотрудникиДокумента.ВзносыРаботодателя,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	ДублиСтрок.НомерСтроки КАК КонфликтующаяСтрока,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	|			И СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо";
	
	Возврат Запрос.Выполнить()
	
КонецФункции

Функция ПолучитьДанныеДляПроведения(ДанныеДляПроведения)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаАктуальности", ДатаИсполненияПлатежногоПоручения);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДСВ_3Сотрудники.Ссылка КАК Регистратор,
	|	РеестрДСВ_3Сотрудники.НомерСтроки,
	|	РеестрДСВ_3Сотрудники.Сотрудник КАК ФизическоеЛицо,
	|	РеестрДСВ_3Сотрудники.Ссылка.ДатаИсполненияПлатежногоПоручения КАК ДатаПолученияДохода,
	|	ВидыДоходовНДФЛ.Ссылка КАК КодДохода,
	|	РеестрДСВ_3Сотрудники.ВзносыРаботодателя КАК СуммаДохода,
	|	ВидыДоходовНДФЛ.ВычетПоУмолчанию КАК КодВычета
	|ПОМЕСТИТЬ ВТСведенияОДоходахПоНДФЛ
	|ИЗ
	|	Документ.РеестрДСВ_3.Сотрудники КАК РеестрДСВ_3Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыДоходовНДФЛ КАК ВидыДоходовНДФЛ
	|		ПО (ВидыДоходовНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.Код1211))
	|ГДЕ
	|	РеестрДСВ_3Сотрудники.Ссылка = &Ссылка
	|	И РеестрДСВ_3Сотрудники.ВзносыРаботодателя <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияОДоходахПоНДФЛ.Регистратор,
	|	СведенияОДоходахПоНДФЛ.НомерСтроки,
	|	СведенияОДоходахПоНДФЛ.ФизическоеЛицо,
	|	СведенияОДоходахПоНДФЛ.КодДохода,
	|	СведенияОДоходахПоНДФЛ.СуммаДохода КАК Сумма,
	|	СведенияОДоходахПоНДФЛ.КодВычета,
	|	0 КАК КоличествоДетей
	|ПОМЕСТИТЬ ВТНачисления
	|ИЗ
	|	ВТСведенияОДоходахПоНДФЛ КАК СведенияОДоходахПоНДФЛ";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат[0].Количество = 0 Тогда
		Возврат Ложь
	КонецЕсли;
	
	КадровыйУчет.СоздатьВТОсновныеСотрудникиФизическихЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, Сотрудники.ВыгрузитьКолонку("Сотрудник"), Организация, ДатаИсполненияПлатежногоПоручения);
	УчетНДФЛ.СоздатьВТВычетыКДоходамФизическихЛиц(Ссылка, Организация, ДатаИсполненияПлатежногоПоручения, Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	&ДатаАктуальности КАК Период
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	ВТОсновныеСотрудникиФизическихЛиц КАК Сотрудники"; 
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудники");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Ложь, "Подразделение");
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОДоходахПоНДФЛ.ФизическоеЛицо,
	|	ЕСТЬNULL(Сотрудники.Сотрудник, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)) КАК Сотрудник,
	|	СведенияОДоходахПоНДФЛ.ДатаПолученияДохода,
	|	СведенияОДоходахПоНДФЛ.КодДохода,
	|	СведенияОДоходахПоНДФЛ.СуммаДохода,
	|	СведенияОДоходахПоНДФЛ.КодВычета,
	|	ЕСТЬNULL(Вычеты.СуммаВычета, 0) КАК СуммаВычета,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Подразделение, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)) КАК Подразделение,
	|	КадровыеДанныеСотрудников.Подразделение КАК Территория
	|ПОМЕСТИТЬ ВТДоходыСВычетами
	|ИЗ
	|	ВТСведенияОДоходахПоНДФЛ КАК СведенияОДоходахПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОсновныеСотрудникиФизическихЛиц КАК Сотрудники
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|			ПО Сотрудники.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|		ПО СведенияОДоходахПоНДФЛ.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВычетыКДоходамФизическихЛиц КАК Вычеты
	|		ПО СведенияОДоходахПоНДФЛ.Регистратор = Вычеты.Регистратор
	|			И СведенияОДоходахПоНДФЛ.НомерСтроки = Вычеты.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТНачисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТКадровыеДанныеСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСведенияОДоходахПоНДФЛ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТОсновныеСотрудникиФизическихЛиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВычетыКДоходамФизическихЛиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоходыСВычетами.Сотрудник,
	|	ДоходыСВычетами.Подразделение,
	|	ДоходыСВычетами.Подразделение КАК ПодразделениеОрганизации,
	|	ДоходыСВычетами.Территория КАК ТерриторияВыполненияРаботВОрганизации,
	|	ЗНАЧЕНИЕ(Справочник.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом) КАК Начисление,
	|	ДоходыСВычетами.ДатаПолученияДохода КАК ДатаНачала,
	|	ДоходыСВычетами.ДатаПолученияДохода КАК ДатаОкончания,
	|	ДоходыСВычетами.СуммаДохода - ДоходыСВычетами.СуммаВычета КАК СуммаДохода,
	|	0 КАК СуммаВычетаВзносы,
	|	НЕОПРЕДЕЛЕНО КАК УсловияТруда
	|ПОМЕСТИТЬ ВТНачисления
	|ИЗ
	|	ВТДоходыСВычетами КАК ДоходыСВычетами
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоходыСВычетами.ФизическоеЛицо,
	|	ДоходыСВычетами.Сотрудник,
	|	ДоходыСВычетами.ДатаПолученияДохода,
	|	ДоходыСВычетами.КодДохода,
	|	ДоходыСВычетами.СуммаДохода,
	|	ДоходыСВычетами.КодВычета,
	|	ДоходыСВычетами.СуммаВычета,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ДСВРаботодателя) КАК Начисление,
	|	ДоходыСВычетами.Подразделение,
	|	ДоходыСВычетами.Подразделение КАК ПодразделениеСотрудника
	|ИЗ
	|	ВТДоходыСВычетами КАК ДоходыСВычетами
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоходыСВычетами.ФизическоеЛицо,
	|	ДоходыСВычетами.Сотрудник,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ДСВРаботодателя) КАК Начисление,
	|	ДоходыСВычетами.СуммаДохода КАК Сумма,
	|	ДоходыСВычетами.Подразделение
	|ИЗ
	|	ВТДоходыСВычетами КАК ДоходыСВычетами
	|ГДЕ
	|	ДоходыСВычетами.Сотрудник <> ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)";
	
	Результаты = Запрос.ВыполнитьПакет();
	ВсегоЗапросов = Результаты.Количество();
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	ДанныеДляПроведения.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	ДанныеДляПроведения.Вставить("ДоходыНДФЛ",Результаты[ВсегоЗапросов - 2].Выгрузить());
	ДанныеДляПроведения.Вставить("Доходы",Результаты[ВсегоЗапросов - 1].Выгрузить());
	
	Возврат Истина;
	
КонецФункции

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат КонецМесяца(ОтчетныйПериод);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли