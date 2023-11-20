#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;  
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КарточкаУчетаСтраховыхВзносовВЦелом");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Рекомендованная ПФ РФ и ФСС РФ Карточка учета страховых взносов.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КарточкаУчетаСтраховыхВзносовПоФилиалам");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Рекомендованная ПФ РФ и ФСС РФ Карточка учета страховых взносов отдельно по головной организации и ее филиалам.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КарточкаУчетаПоСтраховымВзносамПодробнее") Тогда
		
		ПечатаемыйДокумент = Неопределено;
		ПараметрыПечати.Свойство("ПечатаемыйДокумент", ПечатаемыйДокумент);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"КарточкаУчетаПоСтраховымВзносамПодробнее",
			НСтр("ru = 'Карточка учета страховых взносов'"), // АПК:1297 Не локализуется, регламентированная форма РФ
			ПечатаемыйДокумент);
						
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КарточкаУчетаПоСтраховымВзносам") Тогда
		
		// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"КарточкаУчетаПоСтраховымВзносам",
						НСтр("ru = 'Карточка учета страховых взносов'"), // АПК:1297 Не локализуется, регламентированная форма РФ
						ПечатьКарточки(МассивОбъектов, ОбъектыПечати), ,);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати) 
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ОтчетКарточкаУчетаПоСтраховымВзносам = Отчеты.КарточкаУчетаПоСтраховымВзносам.Создать();
	Отбор = ОтчетКарточкаУчетаПоСтраховымВзносам.КомпоновщикНастроек.Настройки.Отбор;
	Отбор.Элементы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Сотрудники.ФизическоеЛицо
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Ссылка В(&МассивОбъектов)";
		
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	МассивФизическихЛиц = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ФизическоеЛицо", ВидСравненияКомпоновкиДанных.ВСписке, МассивФизическихЛиц);
	ОтчетКарточкаУчетаПоСтраховымВзносам.СкомпоноватьРезультат(ДокументРезультат);
	
	Возврат ДокументРезультат;	
	
КонецФункции

#КонецОбласти

#КонецЕсли