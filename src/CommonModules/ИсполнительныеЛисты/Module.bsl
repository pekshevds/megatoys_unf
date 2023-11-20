#Область СлужебныйПрограммныйИнтерфейс

Процедура РассчитатьУдержанияПоИсполнительнымЛистам(Объект, Начисления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Период", Объект.МесяцНачисления);
	Запрос.УстановитьПараметр("Организация", ЗарплатаКадры.ГоловнаяОрганизация(Объект.Организация));
	Запрос.УстановитьПараметр("НДФЛ", Объект.НДФЛ.Выгрузить());
	Запрос.УстановитьПараметр("ДоходыНаКоторыеМожетБытьОбращеноВзыскание", Перечисления.ВидыДоходовИсполнительногоПроизводства.Взыскиваемые());
	
	Запрос.УстановитьПараметр("Начисления", Начисления);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	&Организация КАК Организация,
		|	Начисления.Сотрудник КАК Сотрудник,
		|	Начисления.Результат КАК Результат,
		|	Начисления.Начисление КАК Начисление
		|ПОМЕСТИТЬ ВТДанныеНачисленийДокумента
		|ИЗ
		|	&Начисления КАК Начисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НДФЛ.Налог КАК Налог
		|ПОМЕСТИТЬ ВТДанныеНДФДокумента
		|ИЗ
		|	&НДФЛ КАК НДФЛ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.Период КАК Период,
		|	Начисления.Организация КАК Организация,
		|	ВЫРАЗИТЬ(Начисления.Сотрудник КАК Справочник.Сотрудники).ФизическоеЛицо КАК ФизическоеЛицо,
		|	СУММА(Начисления.Результат) КАК Результат,
		|	СУММА(Начисления.РасчетнаяБаза) КАК РасчетнаяБаза,
		|	СУММА(Начисления.РезультатТекущегоДокумента) КАК РезультатТекущегоДокумента
		|ПОМЕСТИТЬ ВТДанныеНачислений
		|ИЗ
		|	(ВЫБРАТЬ
		|		НачисленияДокумента.Период КАК Период,
		|		НачисленияДокумента.Организация КАК Организация,
		|		НачисленияДокумента.Сотрудник КАК Сотрудник,
		|		НачисленияДокумента.Результат КАК Результат,
		|		НачисленияДокумента.Результат КАК РезультатТекущегоДокумента,
		|		ВЫБОР
		|			КОГДА ВЫРАЗИТЬ(НачисленияДокумента.Начисление КАК ПланВидовРасчета.Начисления).ВидДоходаИсполнительногоПроизводства В (&ДоходыНаКоторыеМожетБытьОбращеноВзыскание)
		|				ТОГДА НачисленияДокумента.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ КАК РасчетнаяБаза
		|	ИЗ
		|		ВТДанныеНачисленийДокумента КАК НачисленияДокумента
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		НачисленияУдержанияПоСотрудникам.Период,
		|		ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.Организация КАК Справочник.Организации).ГоловнаяОрганизация,
		|		НачисленияУдержанияПоСотрудникам.Сотрудник,
		|		НачисленияУдержанияПоСотрудникам.Сумма,
		|		0,
		|		ВЫБОР
		|			КОГДА ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание КАК ПланВидовРасчета.Начисления).ВидДоходаИсполнительногоПроизводства В (&ДоходыНаКоторыеМожетБытьОбращеноВзыскание)
		|				ТОГДА НачисленияУдержанияПоСотрудникам.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
		|	ГДЕ
		|		НачисленияУдержанияПоСотрудникам.Регистратор <> &Ссылка
		|		И НачисленияУдержанияПоСотрудникам.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
		|		И НачисленияУдержанияПоСотрудникам.Период = &Период
		|		И ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.Организация КАК Справочник.Организации).ГоловнаяОрганизация = &Организация) КАК Начисления
		|
		|СГРУППИРОВАТЬ ПО
		|	Начисления.Период,
		|	Начисления.Организация,
		|	ВЫРАЗИТЬ(Начисления.Сотрудник КАК Справочник.Сотрудники).ФизическоеЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СУММА(НДФЛ.Налог) КАК Налог
		|ПОМЕСТИТЬ ВТДанныеНДФЛ
		|ИЗ
		|	(ВЫБРАТЬ
		|		НДФЛДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|		НДФЛДокумента.Налог КАК Налог
		|	ИЗ
		|		ВТДанныеНДФДокумента КАК НДФЛДокумента
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		НачисленияУдержанияПоСотрудникам.ФизическоеЛицо,
		|		НачисленияУдержанияПоСотрудникам.Сумма
		|	ИЗ
		|		РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
		|	ГДЕ
		|		НачисленияУдержанияПоСотрудникам.Регистратор <> &Ссылка
		|		И НачисленияУдержанияПоСотрудникам.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
		|		И НачисленияУдержанияПоСотрудникам.НачислениеУдержание = ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ)
		|		И НачисленияУдержанияПоСотрудникам.Период = &Период
		|		И ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.Организация КАК Справочник.Организации).ГоловнаяОрганизация = &Организация) КАК НДФЛ
		|
		|СГРУППИРОВАТЬ ПО
		|	НДФЛ.ФизическоеЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(ДанныеНачислений.Период, МЕСЯЦ) КАК ДатаНачала,
		|	КОНЕЦПЕРИОДА(ДанныеНачислений.Период, МЕСЯЦ) КАК ДатаОкончания,
		|	ДанныеНачислений.Организация КАК Организация,
		|	ДанныеНачислений.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	ВТДанныеНачислений КАК ДанныеНачислений";
		
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистра();
	ПараметрыПостроения.ВключатьЗаписиНаНачалоПериода = Истина;
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ПлановыеУдержания",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТФизическиеЛица",
			"Организация,ФизическоеЛицо"),
		ПараметрыПостроения);
		
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МИНИМУМ(ПлановыеУдержания.Период) КАК Период,
		|	ПлановыеУдержания.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПлановыеУдержания.Удержание КАК Удержание,
		|	ПлановыеУдержания.ДокументОснование КАК ИсполнительныйДокумент,
		|	ЕСТЬNULL(ДанныеНачислений.Результат, 0) КАК Начисления,
		|	ЕСТЬNULL(ДанныеНачислений.РезультатТекущегоДокумента, 0) КАК НачисленияТекущегоДокумента,
		|	ЕСТЬNULL(ДанныеНачислений.РасчетнаяБаза, 0) КАК РасчетнаяБаза,
		|	ЕСТЬNULL(ДанныеНДФЛ.Налог, 0) КАК Налог
		|ПОМЕСТИТЬ ВТУдержания
		|ИЗ
		|	ВТПлановыеУдержания КАК ПлановыеУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеНачислений КАК ДанныеНачислений
		|		ПО ПлановыеУдержания.ФизическоеЛицо = ДанныеНачислений.ФизическоеЛицо
		|			И ПлановыеУдержания.Организация = ДанныеНачислений.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеНДФЛ КАК ДанныеНДФЛ
		|		ПО ПлановыеУдержания.ФизическоеЛицо = ДанныеНДФЛ.ФизическоеЛицо
		|ГДЕ
		|	ПлановыеУдержания.Используется
		|
		|СГРУППИРОВАТЬ ПО
		|	ПлановыеУдержания.ФизическоеЛицо,
		|	ПлановыеУдержания.Удержание,
		|	ПлановыеУдержания.ДокументОснование,
		|	ДанныеНачислений.Результат,
		|	ДанныеНачислений.РезультатТекущегоДокумента,
		|	ДанныеНачислений.РасчетнаяБаза,
		|	ДанныеНДФЛ.Налог";
		
	Запрос.Выполнить();
		
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"УсловияУдержанияПоИсполнительномуДокументу",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТУдержания",
			"ИсполнительныйДокумент"));
		
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Удержания.ФизическоеЛицо КАК Сотрудник,
		|	Удержания.Удержание,
		|	Удержания.ИсполнительныйДокумент КАК ДокументОснование,
		|	Удержания.Начисления,
		|	Удержания.НачисленияТекущегоДокумента,
		|	Удержания.РасчетнаяБаза,
		|	Удержания.Налог,
		|	ВЫРАЗИТЬ(Удержания.Удержание КАК ПланВидовРасчета.Удержания).КатегорияУдержания КАК КатегорияУдержания,
		|	УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.Получатель КАК Контрагент,
		|	УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.СпособРасчета,
		|	УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.Процент,
		|	УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.Сумма,
		|	УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.Числитель,
		|	УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.Знаменатель
		|ИЗ
		|	ВТУдержания КАК Удержания
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТУсловияУдержанияПоИсполнительномуДокументуСрезПоследних КАК УсловияУдержанияПоИсполнительномуДокументуСрезПоследних
		|		ПО Удержания.ФизическоеЛицо = УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.ФизическоеЛицо
		|			И Удержания.ИсполнительныйДокумент = УсловияУдержанияПоИсполнительномуДокументуСрезПоследних.ИсполнительныйДокумент";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.НачисленияТекущегоДокумента = 0
				Или Выборка.РасчетнаяБаза = 0 Тогда
				
				Продолжить;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("Сотрудник,Удержание,Контрагент,КатегорияУдержания,ДокументОснование");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
			
			СтрокиДокумента = Объект.Удержания.НайтиСтроки(СтруктураПоиска);
			Если СтрокиДокумента.Количество() > 0 Тогда
				
				СтрокаУдержаний = СтрокиДокумента[0];
				СтрокаУдержаний.Результат = 0;
				
			Иначе
				
				СтрокаУдержаний = Объект.Удержания.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаУдержаний, Выборка);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.СпособРасчета) Тогда
				
				БазаУдержаний = Выборка.РасчетнаяБаза - Окр(Выборка.Налог * (Выборка.РасчетнаяБаза/Выборка.Начисления), 0);
				Если Выборка.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.ФиксированнойСуммой Тогда
					СтрокаУдержаний.Результат = СтрокаУдержаний.Результат + Выборка.Сумма;
				ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Процентом Тогда
					СтрокаУдержаний.Результат = СтрокаУдержаний.Результат + БазаУдержаний * Выборка.Процент / 100;
				ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Долей Тогда
					
					Если Выборка.Знаменатель <> 0 Тогда
						СтрокаУдержаний.Результат = СтрокаУдержаний.Результат + БазаУдержаний * Выборка.Числитель / Выборка.Знаменатель;
					КонецЕсли;
					
				КонецЕсли;
				
				Если СтрокаУдержаний.Результат > БазаУдержаний Тогда
					СтрокаУдержаний.Результат = БазаУдержаний;
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает суммы, удержанные по исполнительным листам 
// с переданных физических лиц по доходам указанных документов
//
// Параметры:
//   ФизлицаДокументы - ТаблицаЗначений - таблица с колонками:
//     * ФизическоеЛицо    - СправочникСсылка.ФизическиеЛица
//     * ДокументОснование - ДокументСсылка - документ, зарегистрировавший доход 
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * ФизическоеЛицо    - СправочникСсылка.ФизическиеЛица
//     * ДокументОснование - ДокументСсылка
//     * Сумма             - ОпределяемыйТип.ДенежнаяСуммаНеотрицательная
//
Функция УдержанныеСуммыФизическихЛицПоДокументам(ФизлицаДокументы, ОкончательныйРасчет = Ложь, УчитыватьСторно = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизлицаДокументы.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ФизлицаДокументы.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВТФизлицаДокументы
		|ИЗ
		|	&ФизлицаДокументы КАК ФизлицаДокументы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТФизлицаДокументы.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТФизлицаДокументы.ДокументОснование КАК ДокументОснование,
		|	СУММА(ЕСТЬNULL(НачисленияУдержанияПоСотрудникам.Сумма, 0)) КАК Сумма
		|ИЗ
		|	ВТФизлицаДокументы КАК ВТФизлицаДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
		|		ПО ВТФизлицаДокументы.ФизическоеЛицо = НачисленияУдержанияПоСотрудникам.ФизическоеЛицо
		|			И ВТФизлицаДокументы.ДокументОснование = НачисленияУдержанияПоСотрудникам.Регистратор
		|			И (&УсловиеСторно)
		|ГДЕ
		|	ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание КАК ПланВидовРасчета.Удержания).КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТФизлицаДокументы.ФизическоеЛицо,
		|	ВТФизлицаДокументы.ДокументОснование";
	
	Запрос.УстановитьПараметр("ФизлицаДокументы", ФизлицаДокументы);
	Если УчитыватьСторно Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСторно", "ИСТИНА");
	Иначе
		УсловиеСторно = "(НачисленияУдержанияПоСотрудникам.Сторно = ЛОЖЬ)";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСторно", УсловиеСторно);
	КонецЕсли;

	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает суммы, удержанные авансом по исполнительным листам 
// с переданных физических лиц по доходам указанных документов
//
// Параметры:
//   ФизлицаДокументы - ТаблицаЗначений - таблица с колонками:
//     * ФизическоеЛицо    - СправочникСсылка.ФизическиеЛица
//     * ДокументОснование - ДокументСсылка - документ, зарегистрировавший доход 
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * ФизическоеЛицо    - СправочникСсылка.ФизическиеЛица
//     * ДокументОснование - ДокументСсылка
//     * Сумма             - ОпределяемыйТип.ДенежнаяСуммаНеотрицательная
//
Функция УдержанныеСуммыФизическихЛицПоДокументамАвансом(ФизлицаДокументы) Экспорт

	Результат = ФизлицаДокументы.Скопировать();
	Результат.Колонки.Добавить("Сумма", РаботаСКурсамиВалют.ОписаниеТипаДенежногоПоля(ДопустимыйЗнак.Неотрицательный));
	Возврат Результат;
	
КонецФункции

#КонецОбласти

