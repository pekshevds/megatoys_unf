
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьОтчетОбОперациях(ПараметрыОтчета, Контейнер) Экспорт
	
	Если ПараметрыОтчета.Свойство("ДатаНачалаРасширенногоПериодаОтчета") Тогда
		НачалоПериодаОтчета = ПараметрыОтчета.ДатаНачалаРасширенногоПериодаОтчета;
	Иначе
		НачалоПериодаОтчета = ПараметрыОтчета.мДатаНачалаПериодаОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", 
		Новый ФиксированныйМассив(ПрослеживаемостьПереопределяемый.ВсяОрганизация(ПараметрыОтчета.Организация)));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоКвартала(НачалоПериодаОтчета));
	Запрос.УстановитьПараметр("КонецПериода", НачалоКвартала(ПараметрыОтчета.мДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("ДатаПодписи", КонецДня(Макс(ПараметрыОтчета.ДатаПодписи, ПараметрыОтчета.мДатаКонцаПериодаОтчета)));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.ДокументОперации КАК ДокументОперации,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.ДатаДокумента КАК ДатаОперации,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.КодОперации КАК КодОперации,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.КодОперации.Наименование КАК КодОперацииНаименование,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.ТипДокументаВПрослеживаемости КАК ТипДокументаВПрослеживаемости,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.НомерДокумента КАК НомерДокумента,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.ДатаДокумента КАК ДатаДокумента,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.Контрагент КАК Контрагент,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.Номенклатура КАК Номенклатура,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.Количество КАК Количество,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.СуммаБезНДС КАК СуммаБезНДС,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.РНПТ КАК РНПТ,
	|	ОперацииСПрослеживаемымиТоварамиСрезПоследних.КоличествоПрослеживаемости КАК КоличествоПрослеживаемости,
	|	ТипыДокументов.Код КАК КодТипаДокументаВПрослеживаемости
	|ПОМЕСТИТЬ ВТ_ПрослеживаемыеОперацииПредварительная
	|ИЗ
	|	РегистрСведений.ОперацииСПрослеживаемымиТоварами.СрезПоследних(
	|			&ДатаПодписи,
	|			Организация В (&Организация)
	|				И ОтражениеВОтчетности = ЗНАЧЕНИЕ(Перечисление.ПорядокОтраженияВОтчетностиПоПрослеживаемости.ОтчетОбОперациях)
	|				И ПериодОперации >= &НачалоПериода
	|				И ПериодОперации <= &КонецПериода) КАК ОперацииСПрослеживаемымиТоварамиСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыДокументов КАК ТипыДокументов
	|		ПО ОперацииСПрослеживаемымиТоварамиСрезПоследних.ТипДокументаВПрослеживаемости = ТипыДокументов.Ссылка
	|ГДЕ
	|	(ОперацииСПрослеживаемымиТоварамиСрезПоследних.Количество <> 0
	|			ИЛИ ОперацииСПрослеживаемымиТоварамиСрезПоследних.КоличествоПрослеживаемости <> 0
	|			ИЛИ ОперацииСПрослеживаемымиТоварамиСрезПоследних.СуммаБезНДС <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ПрослеживаемыеОперацииПредварительная.Контрагент КАК Ссылка,
	|	ВТ_ПрослеживаемыеОперацииПредварительная.ДатаДокумента КАК ДатаСведений
	|ПОМЕСТИТЬ СсылкиНаДаты
	|ИЗ
	|	ВТ_ПрослеживаемыеОперацииПредварительная КАК ВТ_ПрослеживаемыеОперацииПредварительная
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ПрослеживаемыеОперацииПредварительная.Номенклатура КАК НоменклатураСсылка
	|ПОМЕСТИТЬ НоменклатураОпераций
	|ИЗ
	|	ВТ_ПрослеживаемыеОперацииПредварительная КАК ВТ_ПрослеживаемыеОперацииПредварительная
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВТ_ПрослеживаемыеОперацииПредварительная.Номенклатура";
	
	Запрос.Выполнить();
	
	ПрослеживаемостьПереопределяемый.ДополнительныеСведенияДляОтчетаОбОперациях(МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрослеживаемыеОперации.ДокументОперации КАК ДокументОперации,
	|	ПрослеживаемыеОперации.ДатаОперации КАК ДатаОперации,
	|	ПрослеживаемыеОперации.КодОперации КАК КодОперации,
	|	ПрослеживаемыеОперации.КодОперацииНаименование КАК КодОперацииНаименование,
	|	ПрослеживаемыеОперации.КодТипаДокументаВПрослеживаемости КАК КодТипаДокументаВПрослеживаемости,
	|	ПрослеживаемыеОперации.НомерДокумента КАК НомерДокумента,
	|	ПрослеживаемыеОперации.ДатаДокумента КАК ДатаДокумента,
	|	ПрослеживаемыеОперации.Контрагент КАК Контрагент,
	|	СУММА(ПрослеживаемыеОперации.СуммаБезНДС) КАК СуммаБезНДС,
	|	ПрослеживаемыеОперации.РНПТ КАК РНПТ,
	|	СУММА(ПрослеживаемыеОперации.КоличествоПрослеживаемости) КАК КоличествоПрослеживаемости,
	|	СведенияОСсылкахНаДаты.Наименование КАК НаименованиеКонтрагента,
	|	СведенияОСсылкахНаДаты.ИНН КАК ИНН,
	|	СведенияОСсылкахНаДаты.КПП КАК КПП,
	|	СведенияОНоменклатуре.ЕдиницаИзмеренияПрослеживаемости КАК ЕдиницаИзмеренияПрослеживаемости
	|ИЗ
	|	ВТ_ПрослеживаемыеОперацииПредварительная КАК ПрослеживаемыеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ СведенияОСсылкахНаДаты КАК СведенияОСсылкахНаДаты
	|		ПО ПрослеживаемыеОперации.Контрагент = СведенияОСсылкахНаДаты.Ссылка
	|			И ПрослеживаемыеОперации.ДатаДокумента = СведенияОСсылкахНаДаты.ДатаСведений
	|		ЛЕВОЕ СОЕДИНЕНИЕ СведенияОНоменклатуре КАК СведенияОНоменклатуре
	|		ПО ПрослеживаемыеОперации.Номенклатура = СведенияОНоменклатуре.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрослеживаемыеОперации.ДатаДокумента,
	|	ПрослеживаемыеОперации.ДатаОперации,
	|	ПрослеживаемыеОперации.НомерДокумента,
	|	ПрослеживаемыеОперации.РНПТ,
	|	ПрослеживаемыеОперации.Контрагент,
	|	ПрослеживаемыеОперации.КодТипаДокументаВПрослеживаемости,
	|	ПрослеживаемыеОперации.ДокументОперации,
	|	ПрослеживаемыеОперации.КодОперации,
	|	ПрослеживаемыеОперации.КодОперацииНаименование,
	|	СведенияОСсылкахНаДаты.КПП,
	|	СведенияОСсылкахНаДаты.Наименование,
	|	СведенияОСсылкахНаДаты.ИНН,
	|	СведенияОНоменклатуре.ЕдиницаИзмеренияПрослеживаемости
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументОперации
	|ИТОГИ
	|	МАКСИМУМ(ДатаОперации),
	|	МАКСИМУМ(КодОперацииНаименование),
	|	МАКСИМУМ(КодТипаДокументаВПрослеживаемости),
	|	МАКСИМУМ(НомерДокумента),
	|	МАКСИМУМ(ДатаДокумента),
	|	МАКСИМУМ(НаименованиеКонтрагента),
	|	МАКСИМУМ(ИНН),
	|	МАКСИМУМ(КПП)
	|ПО
	|	ДокументОперации,
	|	КодОперации,
	|	Контрагент
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ПрослеживаемостьПереопределяемый.ПредупреждениеОбОтсутствииДанныхВОтчете(ПараметрыОтчета);
	КонецЕсли;
	
	Если Не Результат.Пустой() Тогда
		
		Реестр = Контейнер.Реестр;
		Реестр.Строки.Очистить();
		НоваяСтраница = Реестр.Строки.Добавить();
		
		НоваяСтраница.Данные = Новый Структура("СтоимостьИтого", 0);
		НоваяСтраница.ДанныеМногострочныхЧастей = Новый Структура("П10000", ДеревоЗначенийОтчетОбОперациях());
		Сч = 1;
		
		ВыборкаДокументОперации = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаДокументОперации.Следующий() Цикл
			ВыборкаКодОперации = ВыборкаДокументОперации.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКодОперации.Следующий() Цикл
				ВыборкаКонтрагент = ВыборкаКодОперации.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаКонтрагент.Следующий() Цикл
					
					Если Сч > ПараметрыОтчета.МаксКолСтрокНаСтранице Тогда
						
						НоваяСтраница = Реестр.Строки.Добавить();
						НоваяСтраница.Данные = Новый Структура("СтоимостьИтого", 0);
						НоваяСтраница.ДанныеМногострочныхЧастей = Новый Структура("П10000", ДеревоЗначенийОтчетОбОперациях());
						
						Сч = 1;
						
					КонецЕсли;
					
					НоваяСтрокаОперации = НоваяСтраница.ДанныеМногострочныхЧастей.П10000.Строки.Добавить();
					СтруктураДанныхОперации = Новый Структура;
					СтруктураДанныхОперации.Вставить("П1000001", 0);
					СтруктураДанныхОперации.Вставить("П1000002", ВыборкаКонтрагент.ДатаОперации);
					СтруктураДанныхОперации.Вставить("П1000003", ВыборкаКонтрагент.КодОперации);
					СтруктураДанныхОперации.Вставить("П1000004", ВыборкаКонтрагент.КодТипаДокументаВПрослеживаемости);
					СтруктураДанныхОперации.Вставить("П1000005", ВыборкаКонтрагент.НомерДокумента);
					СтруктураДанныхОперации.Вставить("П1000006", ВыборкаКонтрагент.ДатаДокумента);
					СтруктураДанныхОперации.Вставить("П1000007", ВыборкаКонтрагент.НаименованиеКонтрагента);
					СтруктураДанныхОперации.Вставить("П1000008", ВыборкаКонтрагент.ИНН);
					СтруктураДанныхОперации.Вставить("П1000009", ВыборкаКонтрагент.КПП);
					
					НоваяСтрокаОперации.Данные = СтруктураДанныхОперации;
					НоваяСтрокаОперации.ДанныеМногострочныхЧастей = Новый Структура("П11000", ДеревоЗначенийОтчетОбОперациях());
					
					ВыборкаРНПТ = ВыборкаКонтрагент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаРНПТ.Следующий() Цикл
						НовыйРНПТ = НоваяСтрокаОперации.ДанныеМногострочныхЧастей.П11000.Строки.Добавить();
						НовыйРНПТ.Данные = Новый Структура("П1100010, П1100011, П1100012, П1100013", 
						ВыборкаРНПТ.РНПТ, ВыборкаРНПТ.ЕдиницаИзмеренияПрослеживаемости,
						ВыборкаРНПТ.КоличествоПрослеживаемости, ВыборкаРНПТ.СуммаБезНДС);
					КонецЦикла;
					
					Сч = Сч + 1;
					
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьСведенияОПоказателяхОтчетаОбОперациях(ПоказателиОтчета) Экспорт
	
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000001", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000002", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000003", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000008", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000004", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000005", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000006", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000007", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000008", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1000009", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1100010", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1100011", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1100012", Истина, Ложь);
	РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П1100013", Истина, Ложь);
	
КонецПроцедуры

Функция ДеревоЗначенийОтчетОбОперациях()
	
	НовоеДеревоЗначений = Новый ДеревоЗначений();
	НовоеДеревоЗначений.Колонки.Добавить("Данные");
	НовоеДеревоЗначений.Колонки.Добавить("ДанныеМногострочныхЧастей");
	НовоеДеревоЗначений.Колонки.Добавить("АдресТабличногоДокумента");
	
	Возврат НовоеДеревоЗначений;
	
КонецФункции

Процедура ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности(ТаблицаОписания) Экспорт
	
	ОписаниеОбъекта = ТаблицаОписания.Добавить();
	ОписаниеОбъекта.Наименование = НСтр("ru='Уведомление об остатках прослеживаемых товаров'");
	ОписаниеОбъекта.ТипОбъекта = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров");
	ОписаниеОбъекта.ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФНС;
	ОписаниеОбъекта.ГруппаВДереве = "Налоговая отчетность";
	ОписаниеОбъекта.ВидДокумента = Перечисления.СтраницыЖурналаОтчетность.Отчеты;
	ОписаниеОбъекта.НеОтправляетсяВКонтролирующийОрган = Ложь;
	ОписаниеОбъекта.ЯвляетсяАктуальным = Истина;
	ОписаниеОбъекта.ИмяОсновногоМакетаДляПечати = "";
	
	ОписаниеОбъекта = ТаблицаОписания.Добавить();
	ОписаниеОбъекта.Наименование = НСтр("ru='Уведомление о ввозе прослеживаемых товаров'");
	ОписаниеОбъекта.ТипОбъекта = Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров");
	ОписаниеОбъекта.ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФНС;
	ОписаниеОбъекта.ГруппаВДереве = "Налоговая отчетность";
	ОписаниеОбъекта.ВидДокумента = Перечисления.СтраницыЖурналаОтчетность.Отчеты;
	ОписаниеОбъекта.НеОтправляетсяВКонтролирующийОрган = Ложь;
	ОписаниеОбъекта.ЯвляетсяАктуальным = Истина;
	ОписаниеОбъекта.ИмяОсновногоМакетаДляПечати = "";
	
	ОписаниеОбъекта = ТаблицаОписания.Добавить();
	ОписаниеОбъекта.Наименование = НСтр("ru='Уведомление о перемещении прослеживаемых товаров'");
	ОписаниеОбъекта.ТипОбъекта = Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров");
	ОписаниеОбъекта.ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФНС;
	ОписаниеОбъекта.ГруппаВДереве = "Налоговая отчетность";
	ОписаниеОбъекта.ВидДокумента = Перечисления.СтраницыЖурналаОтчетность.Отчеты;
	ОписаниеОбъекта.НеОтправляетсяВКонтролирующийОрган = Ложь;
	ОписаниеОбъекта.ЯвляетсяАктуальным = Истина;
	ОписаниеОбъекта.ИмяОсновногоМакетаДляПечати = "";
	
КонецПроцедуры

// Процедура переопределяет свойства объекта, с которыми он будет отображен в форме Отчетность
// Параметры:
//  СвойстваОбъектов  - ТаблицаЗначений - Таблица, содержащая в себе описания ссылок, переданных в закладке Ссылка таблицы
//		Каждая колонка таблицы соотвествует свойству объекта.
//		Таблица содержит следующие колонки:
//			- ДатаСоздания - Дата - Дата создания объекта
//			- Наименование - Строка - Наименование объекта, с которым он будет отображаться в форме Отчетность
//			- КодКонтролирующегоОргана - Строка - Код контролирующего органа, в который отправляется отчетности по ТКС
//			- ДатаНачала - Дата - Дата начала периода. Пустая, если дата начала периода отсуствует
//			- ДатаОкончания - Дата - Дата окончания периода. Пустая, если дата окончания периода отсуствует 
//			- ВариантОтчета - Строка(3) - Корректировочный номер (0 - Первичный)
//			- ПометкаУдаления - Булево - Истина, если объект помечен на удаление 
//			- Организация - СправочникСсылка.Организации - Организация, которой принадлежит объект
//			- Комментарий - Строка - Комментарий из объекта
Процедура ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность(СвойстваОбъектов) Экспорт
	
	МассивУведомленийОбОстатках   = Новый Массив();
	МассивУведомленийОВвозе       = Новый Массив();
	МассивУведомленийОПеремещении = Новый Массив();
	Для Каждого СвойстваОбъекта Из СвойстваОбъектов Цикл
		Если ТипЗнч(СвойстваОбъекта.Ссылка) = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров") Тогда
			МассивУведомленийОбОстатках.Добавить(СвойстваОбъекта.Ссылка);
		ИначеЕсли  ТипЗнч(СвойстваОбъекта.Ссылка) = Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров") Тогда
			МассивУведомленийОВвозе.Добавить(СвойстваОбъекта.Ссылка);
		ИначеЕсли  ТипЗнч(СвойстваОбъекта.Ссылка) = Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров") Тогда
			МассивУведомленийОПеремещении.Добавить(СвойстваОбъекта.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивУведомленийОбОстатках.Количество() > 0 Тогда
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("МассивУведомлений", МассивУведомленийОбОстатках);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	УведомлениеОбОстаткахПрослеживаемыхТоваров.Ссылка КАК Ссылка,
		|	УведомлениеОбОстаткахПрослеживаемыхТоваров.Дата КАК ДатаСоздания,
		|	УведомлениеОбОстаткахПрослеживаемыхТоваров.Организация КАК Организация,
		|	УведомлениеОбОстаткахПрослеживаемыхТоваров.НомерКорректировки КАК НомерКорректировки,
		|	НАЧАЛОПЕРИОДА(УведомлениеОбОстаткахПрослеживаемыхТоваров.Дата, МЕСЯЦ) КАК ДатаНачала,
		|	КОНЕЦПЕРИОДА(УведомлениеОбОстаткахПрослеживаемыхТоваров.Дата, МЕСЯЦ) КАК ДатаОкончания,
		|	УведомлениеОбОстаткахПрослеживаемыхТоваров.ПометкаУдаления КАК ПометкаУдаления,
		|	ЕСТЬNULL(УведомлениеОбОстаткахПрослеживаемыхТоваров.Организация.РегистрацияВНалоговомОргане.Код, """") КАК КодКонтролирующегоОргана
		|ИЗ
		|	Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров КАК УведомлениеОбОстаткахПрослеживаемыхТоваров
		|ГДЕ
		|	УведомлениеОбОстаткахПрослеживаемыхТоваров.Ссылка В(&МассивУведомлений)";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокиОбъектов = СвойстваОбъектов.НайтиСтроки(Новый Структура("Ссылка", Выборка.Ссылка));
			Для Каждого СтрокаОбъекта Из СтрокиОбъектов Цикл
				ЗаполнитьЗначенияСвойств(СтрокаОбъекта, Выборка);
				Если Выборка.НомерКорректировки = 0 Тогда
					СтрокаОбъекта.Наименование = НСтр("ru = 'Уведомление об остатках прослеживаемых товаров'");
				Иначе
					СтрокаОбъекта.Наименование = НСтр("ru = 'Корректировочное уведомление об остатках прослеживаемых товаров'");
				КонецЕсли;
					
				СтрокаОбъекта.ВариантОтчета = Формат(Выборка.НомерКорректировки, "ЧЦ=3; ЧГ=0");
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если МассивУведомленийОВвозе.Количество() > 0 Тогда
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("МассивУведомлений", МассивУведомленийОВвозе);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	УведомлениеОВвозеПрослеживаемыхТоваров.Ссылка КАК Ссылка,
		|	УведомлениеОВвозеПрослеживаемыхТоваров.Дата КАК ДатаСоздания,
		|	УведомлениеОВвозеПрослеживаемыхТоваров.Организация КАК Организация,
		|	УведомлениеОВвозеПрослеживаемыхТоваров.НомерКорректировки КАК НомерКорректировки,
		|	НАЧАЛОПЕРИОДА(УведомлениеОВвозеПрослеживаемыхТоваров.Дата, МЕСЯЦ) КАК ДатаНачала,
		|	КОНЕЦПЕРИОДА(УведомлениеОВвозеПрослеживаемыхТоваров.Дата, МЕСЯЦ) КАК ДатаОкончания,
		|	УведомлениеОВвозеПрослеживаемыхТоваров.ПометкаУдаления КАК ПометкаУдаления,
		|	ЕСТЬNULL(УведомлениеОВвозеПрослеживаемыхТоваров.Организация.РегистрацияВНалоговомОргане.Код, """") КАК КодКонтролирующегоОргана
		|ИЗ
		|	Документ.УведомлениеОВвозеПрослеживаемыхТоваров КАК УведомлениеОВвозеПрослеживаемыхТоваров
		|ГДЕ
		|	УведомлениеОВвозеПрослеживаемыхТоваров.Ссылка В(&МассивУведомлений)";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокиОбъектов = СвойстваОбъектов.НайтиСтроки(Новый Структура("Ссылка", Выборка.Ссылка));
			Для Каждого СтрокаОбъекта Из СтрокиОбъектов Цикл
				ЗаполнитьЗначенияСвойств(СтрокаОбъекта, Выборка);
				
				Если Выборка.НомерКорректировки = 0 Тогда
					СтрокаОбъекта.Наименование = НСтр("ru = 'Уведомление о ввозе прослеживаемых товаров'");
				Иначе
					СтрокаОбъекта.Наименование = НСтр("ru = 'Корректировочное уведомление о ввозе прослеживаемых товаров'");
				КонецЕсли;
				
				СтрокаОбъекта.ВариантОтчета = Формат(Выборка.НомерКорректировки, "ЧЦ=3; ЧГ=0");
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если МассивУведомленийОПеремещении.Количество() > 0 Тогда
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("МассивУведомлений", МассивУведомленийОПеремещении);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка КАК Ссылка,
		|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Дата КАК ДатаСоздания,
		|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Организация КАК Организация,
		|	УведомлениеОПеремещенииПрослеживаемыхТоваров.НомерКорректировки КАК НомерКорректировки,
		|	НАЧАЛОПЕРИОДА(УведомлениеОПеремещенииПрослеживаемыхТоваров.Дата, МЕСЯЦ) КАК ДатаНачала,
		|	КОНЕЦПЕРИОДА(УведомлениеОПеремещенииПрослеживаемыхТоваров.Дата, МЕСЯЦ) КАК ДатаОкончания,
		|	УведомлениеОПеремещенииПрослеживаемыхТоваров.ПометкаУдаления КАК ПометкаУдаления,
		|	ЕСТЬNULL(УведомлениеОПеремещенииПрослеживаемыхТоваров.Организация.РегистрацияВНалоговомОргане.Код, """") КАК КодКонтролирующегоОргана
		|ИЗ
		|	Документ.УведомлениеОПеремещенииПрослеживаемыхТоваров КАК УведомлениеОПеремещенииПрослеживаемыхТоваров
		|ГДЕ
		|	УведомлениеОПеремещенииПрослеживаемыхТоваров.Ссылка В(&МассивУведомлений)";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокиОбъектов = СвойстваОбъектов.НайтиСтроки(Новый Структура("Ссылка", Выборка.Ссылка));
			Для Каждого СтрокаОбъекта Из СтрокиОбъектов Цикл
				ЗаполнитьЗначенияСвойств(СтрокаОбъекта, Выборка);
				
				Если Выборка.НомерКорректировки = 0 Тогда
					СтрокаОбъекта.Наименование = НСтр("ru = 'Уведомление о перемещении прослеживаемых товаров'");
				Иначе
					СтрокаОбъекта.Наименование = НСтр("ru = 'Корректировочное уведомление о перемещении прослеживаемых товаров'");
				КонецЕсли;
					
				СтрокаОбъекта.ВариантОтчета = Формат(Выборка.НомерКорректировки, "ЧЦ=3; ЧГ=0");
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры

#Область ЗаполнениеДанныхРегламентированногоОтчетаУведомлений

// Функция создает структуру по указанному шаблону
//
// Параметры:
//  ШаблонСтруктураДанных - Структура - структура, копию, которой нужно создать
//
// Возвращамое значение:
// Структура - скопировананя структура
//
Функция НоваяСтруктура(ШаблонСтруктураДанных) Экспорт
	
		СтруктураДанных = Новый Структура;
		Для Каждого ИмяПоказателя Из ШаблонСтруктураДанных Цикл
			СтруктураДанных.Вставить(ИмяПоказателя.Ключ, ИмяПоказателя.Значение);
		КонецЦикла;
	
		Возврат СтруктураДанных;
	
КонецФункции

// Процедура очищает значения структуры
// 
// Параметры:
//   Показатели - Структура - структура, данные которой будут очищены
//
Процедура ОчиститьЗначенияПоказателей(Показатели) Экспорт
	
	Для Каждого КлючИЗначение Из Показатели Цикл
		Если ТипЗнч(Показатели[КлючИЗначение.Ключ]) = Тип("Число") Тогда
			Показатели.Вставить(КлючИЗначение.Ключ, 0);
		ИначеЕсли ТипЗнч(Показатели[КлючИЗначение.Ключ]) = Тип("Дата") Тогда
			Показатели.Вставить(КлючИЗначение.Ключ, Дата(1,1,1));
		ИначеЕсли ТипЗнч(Показатели[КлючИЗначение.Ключ]) = Тип("Булево") Тогда
			Показатели.Вставить(КлючИЗначение.Ключ, Ложь);
		Иначе
			Показатели.Вставить(КлючИЗначение.Ключ, "");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти