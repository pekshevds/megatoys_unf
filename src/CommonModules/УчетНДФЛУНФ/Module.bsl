// Процедура рассчитывает срок уплаты для строк удержанного налога.
//
// Параметры:
//		КоллекцияСтрокДвижений - набор записей регистра РасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ или его аналога, 
//                           либо иная коллекция строк регистра, либо таблица значений с соответствующими колонками
//		Организация - СправочникСсылка.Организации - должно быть непустым значением, если ПереноситьНаРабочийДень = Истина.
//      ПереноситьНаРабочийДень - булево -
//
Процедура ПроставитьКрайнийСрокУплаты(КоллекцияСтрокДвижений, Организация = Неопределено, Знач ПереноситьНаРабочийДень = Истина) Экспорт
	
	ДатаЗакона263ФЗ = ДатаЗакона263ФЗ();
	
	УчитыватьОсобыеНерабочиеДни = Ложь;
	СтрокиСОтрицательнымиДоходами = Новый Массив;
	ДатыУдержанияНалога = Новый Массив;
	СтрокиКОбработке = Новый Массив;
	ПоследниеРабочиеДниРазныхЛет = Новый Соответствие;
	Для Каждого СтрокаНабора Из КоллекцияСтрокДвижений Цикл
		Если СтрокаНабора.ВариантУдержания = Перечисления.ВариантыУдержанияНДФЛ.Удержано И Не ЗначениеЗаполнено(СтрокаНабора.КрайнийСрокУплаты) Тогда
			ДатаУдержанияНалога = СтрокаНабора.Период;
			ДвадцатьВосьмоеЧислоМесяцаУдержанияНалога = НачалоМесяца(ДатаУдержанияНалога) + 27 * 86400;
			ДвадцатьВосьмоеЧислоСледующегоМесяца = ДобавитьМесяц(ДвадцатьВосьмоеЧислоМесяцаУдержанияНалога, 1);
			
			Если День(ДатаУдержанияНалога) < 23 Тогда
				СрокУплаты = ДвадцатьВосьмоеЧислоМесяцаУдержанияНалога;
			ИначеЕсли Месяц(ДатаУдержанияНалога) = 12 Тогда // в конце декабря - последний рабочий день года
				ПоследнийДеньГода = НачалоДня(КонецГода(ДатаУдержанияНалога));
				ПоследнийРабочийДень = ПоследниеРабочиеДниРазныхЛет[ПоследнийДеньГода];
				Если ПоследнийРабочийДень = Неопределено Тогда
					 ПоследнийРабочийДень = ПоследнийРабочийДеньГода(ПоследнийДеньГода);
					 ПоследниеРабочиеДниРазныхЛет.Вставить(ПоследнийДеньГода, ПоследнийРабочийДень);
				КонецЕсли;
				СрокУплаты = ПоследнийРабочийДень
			Иначе	
				СрокУплаты = ДвадцатьВосьмоеЧислоСледующегоМесяца
			КонецЕсли;
			
			СтрокаНабора.КрайнийСрокУплаты = СрокУплаты;
			//СтрокиКОбработке.Добавить(СтрокаНабора);
			//Если СтрокаНабора.СуммаВыплаченногоДохода < 0 Тогда
			//	СтрокиСОтрицательнымиДоходами.Добавить(СтрокаНабора)
			//КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//Если ЗначениеЗаполнено(СтрокиСОтрицательнымиДоходами) Тогда
	//	Если СтрокиСОтрицательнымиДоходами.Количество() > 3 Или СтрокиКОбработке.Количество() > 100 Тогда
	//		ТаблицаДляПоиска = РегистрыНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	//		Для каждого СтрокаУчета Из СтрокиКОбработке Цикл
	//			ЗаполнитьЗначенияСвойств(ТаблицаДляПоиска.Добавить(), СтрокаУчета);
	//		КонецЦикла;
	//		ТаблицаДляПоиска.Индексы.Добавить("ФизическоеЛицо");
	//		СтруктураПоиска = Новый Структура("ФизическоеЛицо");
	//		Для Каждого СтрокаФизическогоЛица Из СтрокиСОтрицательнымиДоходами Цикл
	//			КрайнийСрокУплаты = '20990101';
	//			СтруктураПоиска.ФизическоеЛицо = СтрокаФизическогоЛица.ФизическоеЛицо;
	//			Для каждого СтрокаУчета Из ТаблицаДляПоиска.НайтиСтроки(СтруктураПоиска) Цикл
	//				Если СтрокаУчета.КрайнийСрокУплаты >= СтрокаФизическогоЛица.МесяцНалоговогоПериода Тогда
	//					КрайнийСрокУплаты = Мин(КрайнийСрокУплаты, СтрокаУчета.КрайнийСрокУплаты) 
	//				КонецЕсли;
	//			КонецЦикла;	
	//			Если КрайнийСрокУплаты < '20990101' Тогда
	//				СтрокаФизическогоЛица.КрайнийСрокУплаты = КрайнийСрокУплаты
	//			КонецЕсли;
	//		КонецЦикла;
	//	Иначе
	//		Для Каждого СтрокаФизическогоЛица Из СтрокиСОтрицательнымиДоходами Цикл
	//			КрайнийСрокУплаты = '20990101';
	//			Для каждого СтрокаУчета Из СтрокиКОбработке Цикл
	//				Если СтрокаУчета.ФизическоеЛицо <> СтрокаФизическогоЛица.ФизическоеЛицо Тогда
	//					Продолжить;
	//				КонецЕсли;
	//				Если СтрокаУчета.КрайнийСрокУплаты >= СтрокаФизическогоЛица.МесяцНалоговогоПериода Тогда
	//					КрайнийСрокУплаты = Мин(КрайнийСрокУплаты, СтрокаУчета.КрайнийСрокУплаты) 
	//				КонецЕсли;
	//			КонецЦикла;	
	//			Если КрайнийСрокУплаты < '20990101' Тогда
	//				СтрокаФизическогоЛица.КрайнийСрокУплаты = КрайнийСрокУплаты
	//			КонецЕсли;
	//		КонецЦикла;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

// Возвращает дату начала действия Федерального закона от 14.07.2022 № 263-ФЗ
//
// Параметры
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаЗакона263ФЗ() Экспорт 

	Возврат '20230101'

КонецФункции 

Функция ПоследнийРабочийДеньГода(ПоследнийДеньГода)
	
	ПроизводственныйКалендарь = КалендарныеГрафики.ОсновнойПроизводственныйКалендарь();
	ПараметрыПолучения = КалендарныеГрафики.ПараметрыПолученияБлижайшихРабочихДат(ПроизводственныйКалендарь);
	ПараметрыПолучения.УчитыватьНерабочиеПериоды = Ложь;
	ПараметрыПолучения.ВызыватьИсключение = Ложь;
	ПараметрыПолучения.ПолучатьПредшествующие = Истина;
	
	РабочиеДни = КалендарныеГрафики.БлижайшиеРабочиеДаты(ПроизводственныйКалендарь, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПоследнийДеньГода), ПараметрыПолучения);
	Если ЗначениеЗаполнено(РабочиеДни) Тогда 
		Возврат РабочиеДни[ПоследнийДеньГода];
	КонецЕсли;
	Возврат ПоследнийДеньГода
	
КонецФункции

// Процедура формирует таблицу с вдижениями для оплаты ваедомости для целей учета НДФЛ.
Процедура СформироватьТаблицаРасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	// Получим данные из текущего документа.
	// Получим данные из ведомостей.
	// Получим данные о других оплатах тех же ведомостей.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(РасходИзКассыВыплатаЗаработнойПлаты.СуммаПлатежа) КАК СуммаПлатежа,
		|	РасходИзКассыВыплатаЗаработнойПлаты.Ведомость КАК Ведомость,
		|	РасходИзКассыВыплатаЗаработнойПлаты.Ссылка.Дата КАК Период
		|ПОМЕСТИТЬ ВТ_СуммыОплатыЭтотДокумент
		|ИЗ
		|	Документ.РасходИзКассы.ВыплатаЗаработнойПлаты КАК РасходИзКассыВыплатаЗаработнойПлаты
		|ГДЕ
		|	РасходИзКассыВыплатаЗаработнойПлаты.Ссылка = &ДокументСсылка
		|	И РасходИзКассыВыплатаЗаработнойПлаты.Ссылка.Дата >= &ДатаНачалаОбязательногоПримененияЕНП
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходИзКассыВыплатаЗаработнойПлаты.Ведомость,
		|	РасходИзКассыВыплатаЗаработнойПлаты.Ссылка.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлатежнаяВедомость.Ссылка КАК Ссылка,
		|	ПлатежнаяВедомость.СуммаДокумента КАК СуммаДокумента
		|ПОМЕСТИТЬ ВТ_СуммыВедомостей
		|ИЗ
		|	ВТ_СуммыОплатыЭтотДокумент КАК ВТ_СуммыОплатыЭтотДокумент
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПлатежнаяВедомость КАК ПлатежнаяВедомость
		|		ПО ВТ_СуммыОплатыЭтотДокумент.Ведомость = ПлатежнаяВедомость.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СуммыВедомостей.Ссылка КАК Ведомость,
		|	ВТ_СуммыОплатыЭтотДокумент.Период КАК Период
		|ПОМЕСТИТЬ ВТ_ВедомостиСПолнойОплатой
		|ИЗ
		|	ВТ_СуммыОплатыЭтотДокумент КАК ВТ_СуммыОплатыЭтотДокумент
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СуммыВедомостей КАК ВТ_СуммыВедомостей
		|		ПО ВТ_СуммыОплатыЭтотДокумент.СуммаПлатежа >= ВТ_СуммыВедомостей.СуммаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СуммыВедомостей.Ссылка КАК Ведомость,
		|	ВТ_СуммыОплатыЭтотДокумент.Период КАК Период
		|ПОМЕСТИТЬ ВТ_ВедомостиСЧастичнойОплатой
		|ИЗ
		|	ВТ_СуммыОплатыЭтотДокумент КАК ВТ_СуммыОплатыЭтотДокумент
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СуммыВедомостей КАК ВТ_СуммыВедомостей
		|		ПО ВТ_СуммыОплатыЭтотДокумент.СуммаПлатежа < ВТ_СуммыВедомостей.СуммаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлатежнаяВедомостьНалогиНаДоходы.Ссылка.Организация КАК Организация,
		|	ПлатежнаяВедомостьНалогиНаДоходы.Ссылка.Организация.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
		|	ПлатежнаяВедомостьНалогиНаДоходы.Сотрудник.Физлицо КАК ФизическоеЛицо,
		|	ПлатежнаяВедомостьНалогиНаДоходы.Сумма КАК Сумма,
		|	ПлатежнаяВедомостьНалогиНаДоходы.СуммаСПревышения КАК СуммаСПревышения,
		|	ПлатежнаяВедомостьНалогиНаДоходы.Ссылка.СтруктурнаяЕдиница КАК Подразделение,
		|	ВТ_ВедомостиСПолнойОплатой.Период КАК Период,
		|	ВТ_ВедомостиСПолнойОплатой.Период КАК МесяцНалоговогоПериода,
		|	&СтавкаНДФЛСКодом2000 КАК СтавкаНалогообложенияРезидента,
		|	ЗНАЧЕНИЕ(Справочник.КодыДоходовНДФЛ.Код2000) КАК КодДохода,
		|	ЗНАЧЕНИЕ(Перечисление.ВариантыУдержанияНДФЛ.Удержано) КАК ВариантУдержания,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК КрайнийСрокУплаты
		|ИЗ
		|	ВТ_ВедомостиСПолнойОплатой КАК ВТ_ВедомостиСПолнойОплатой
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПлатежнаяВедомость.НалогиНаДоходы КАК ПлатежнаяВедомостьНалогиНаДоходы
		|		ПО ВТ_ВедомостиСПолнойОплатой.Ведомость = ПлатежнаяВедомостьНалогиНаДоходы.Ссылка
		|ГДЕ
		|	ПлатежнаяВедомостьНалогиНаДоходы.ВидНачисленияУдержания = ЗНАЧЕНИЕ(Справочник.ВидыНачисленийИУдержаний.НалогНаДоходы)";
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РасходСоСчета") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РасходИзКассы", "Документ.РасходСоСчета");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Запрос.УстановитьПараметр("СтавкаНДФЛСКодом2000", Справочники.КодыДоходовНДФЛ.Код2000.СтавкаНДФЛ);
	Запрос.УстановитьПараметр("ДатаНачалаОбязательногоПримененияЕНП", РегламентированнаяОтчетностьУСН.ДатаОбязательногоПримененияЕНП());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатВедомостиСПолнойОплатой = МассивРезультатов[4].Выгрузить();
	ТаблицаРасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ = РезультатВедомостиСПолнойОплатой;
	
	ПроставитьКрайнийСрокУплаты(ТаблицаРасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ", ТаблицаРасчетыНалогоплательщиковСБюджетомПоНДФЛУНФ);
	
КонецПроцедуры
