
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ИдентификаторПечатнойФормы() Экспорт
	
	Возврат "МХ3";
	
КонецФункции

Функция КлючПараметровПечати() Экспорт
	
	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_МХ3";
	
КонецФункции

Функция ПолныйПутьКМакету() Экспорт
	
	Возврат "Обработка.ПечатьМХ3.ПФ_MXL_МХ3";
	
КонецФункции

Функция ПредставлениеПФ() Экспорт
	
	Возврат НСтр("ru ='МХ-3 (Акт о возврате запасов сданных на хранение)'");
	
КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;
	
	Макет				= УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент	= ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати		= Новый Структура;
	ЕстьТЧЗапасы		= (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаЗапасы") <> Неопределено);
	
	Для каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало,
			ДанныеПечати);
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеОбъекта.Организация,
			ДанныеОбъекта.ДатаДокумента, , );
		СведенияОбКонтрагенте = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеОбъекта.Контрагент,
			ДанныеОбъекта.ДатаДокумента, , );
		
		// Заголовок
		ОбластьЗаголовок = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Заголовок", "", Ошибки);
		Если ОбластьЗаголовок <> Неопределено Тогда
			
			ДанныеПечати.Вставить("НомерДокумента", ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(
				ДанныеОбъекта.ДатаДокумента, ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс));
			ДанныеПечати.Вставить("ДатаДокумента", Формат(ДанныеОбъекта.ДатаДокумента, "ДЛФ=D"));
			ДанныеПечати.Вставить("ВидОперацииМХ3", ДанныеОбъекта.ВидОперацииМХ3);
			ДанныеПечати.Вставить("ПредставлениеОрганизации", ПечатьДокументовУНФ.ОписаниеОрганизации(
				СведенияОбОрганизации, "ПолноеНаименование,ЮридическийАдрес,Телефоны,Факс"));
			ДанныеПечати.Вставить("ПредставлениеПодразделения", ДанныеОбъекта.ПредставлениеПодразделения);
			ДанныеПечати.Вставить("ПредставлениеСклада", ДанныеОбъекта.ПредставлениеСклада);
			ДанныеПечати.Вставить("СрокХранения", ДанныеОбъекта.СрокХранения);
			ДанныеПечати.Вставить("ПредставлениеКонтрагента", ПечатьДокументовУНФ.ОписаниеОрганизации(
				СведенияОбКонтрагенте, "ПолноеНаименование,ЮридическийАдрес,Телефоны,Факс"));
			ДанныеПечати.Вставить("РасшифровкаПодписиКонтрагента", ДанныеОбъекта.РасшифровкаПодписиКонтрагента);
			ДанныеПечати.Вставить("ДоговорНомер", ДанныеОбъекта.ДоговорНомер);
			ДанныеПечати.Вставить("ДоговорДата", ДанныеОбъекта.ДоговорДата);
			ДанныеПечати.Вставить("ОрганизацияПоОКПО", ДанныеОбъекта.ОрганизацияПоОКПО);
			ДанныеПечати.Вставить("ВидДеятельностиПоОКДП", ДанныеОбъекта.ВидДеятельностиПоОКДП);
			ДанныеПечати.Вставить("КонтрагентПоОКПО", ДанныеОбъекта.КонтрагентПоОКПО);
			
			ОбластьЗаголовок.Параметры.Заполнить(ДанныеПечати);
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок,
				ДанныеОбъекта.Ссылка);
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);
			
		КонецЕсли;
		
		// Табличная часть
		НомерСтраницы = 1;
		
		ОбластьШапкаТаблицы = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ШапкаТаблицы", "", Ошибки);
		Если ОбластьШапкаТаблицы <> Неопределено Тогда
			
			ДанныеПечати.Вставить("НомерСтраницы", НСтр("ru ='Страница '") + НомерСтраницы);
			
			ОбластьШапкаТаблицы.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			
		КонецЕсли;
		
		Итоги = Новый Структура;
		Итоги.Вставить("НомерСтроки", 0);
		Итоги.Вставить("КоличествоПоСтранице", 0);
		Итоги.Вставить("КоличествоПоАкту", 0);
		Итоги.Вставить("СуммаПоСтранице", 0);
		Итоги.Вставить("СуммаПоАкту", 0);
		Итоги.Вставить("ОсталосьВывестиСтрок", 0);
		
		ОбластиМакета = Новый Структура;
		ОбластиМакета.Вставить("ОбластьСтрока", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Строка", "",
			Ошибки));
		ОбластиМакета.Вставить("ОбластьИтогиПоСтранице", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(
			Макет, "ИтогоПоСтранице", "", Ошибки));
		ОбластиМакета.Вставить("ОбластьМакетаВсего", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Всего", "",
			Ошибки));
		ОбластиМакета.Вставить("ОбластьШапкаТаблицы", ОбластьШапкаТаблицы);
		
		Если ОбластиМакета.ОбластьСтрока <> Неопределено Тогда
			
			Если ЕстьТЧЗапасы Тогда
				
				ПараметрыПроверки = Новый Структура;
				ПараметрыПроверки.Вставить("ОбластиМакета", ОбластиМакета);
				ПараметрыПроверки.Вставить("Итоги", Итоги);
				ПараметрыПроверки.Вставить("НомерСтраницы", НомерСтраницы);
				
				ПараметрыНоменклатуры = Новый Структура;
				Итоги.ОсталосьВывестиСтрок = КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта);
				
				Для каждого СтрокаТабличнойЧасти Из ДанныеОбъекта.ТаблицаЗапасы Цикл
					
					Если СтрокаТабличнойЧасти.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда
						
						Продолжить;
						
					КонецЕсли;
					
					Итоги.ОсталосьВывестиСтрок = Итоги.ОсталосьВывестиСтрок - 1;
					
					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати,
						ПараметрыНоменклатуры, Итоги, ДанныеОбъекта);
					
					ОбластиМакета.ОбластьСтрока.Параметры.Заполнить(ДанныеПечати);
					
					НачалиНовуюСтраницу = СтрокаПоместиласьНаСтранице(ТабличныйДокумент, ПараметрыПроверки);
					
					Если НачалиНовуюСтраницу Тогда
						Итоги.СуммаПоСтранице = 0;
						Итоги.КоличествоПоСтранице = 0;
					КонецЕсли;
					ОбновитьИтоги(Итоги, СтрокаТабличнойЧасти);

					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьСтрока);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Итого по странице
		Если ОбластиМакета.ОбластьИтогиПоСтранице <> Неопределено Тогда
			
			ДанныеПечати.Вставить("КоличествоПоСтранице", Итоги.КоличествоПоСтранице);
			ДанныеПечати.Вставить("СуммаПоСтранице", ПечатьДокументовУНФ.ФорматСумм(Итоги.СуммаПоСтранице));
			
			ОбластиМакета.ОбластьИтогиПоСтранице.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьИтогиПоСтранице);
			
		КонецЕсли;
		
		// Всего
		Если ОбластиМакета.ОбластьМакетаВсего <> Неопределено Тогда
			
			ДанныеПечати.Вставить("КоличествоПоАкту", Итоги.КоличествоПоАкту);
			ДанныеПечати.Вставить("СуммаПоАкту", ПечатьДокументовУНФ.ФорматСумм(Итоги.СуммаПоАкту));
			
			ОбластиМакета.ОбластьМакетаВсего.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаВсего);
			
		КонецЕсли;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Таблица услуг (заголовок и шапка таблицы)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ШапкаТаблицыУслуг", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ОбластьМакета.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// Таблица услуг (пустые строки)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "СтрокаУслуг", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			Для Итератор = 1 По 5 Цикл
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;
			
		КонецЕсли;
		
		// Таблица услуг (всего)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ВсегоУслуг", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// Таблица услуг (Детализация хранения)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ДетализацияХранения", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ОбластьМакета.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		//Подписи
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Подписи", , Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ОбластьМакета.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеОбъекта.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтрокаПоместиласьНаСтранице(ТабличныйДокумент, ПараметрыПроверки)
	
	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьСтрока);
	МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьИтогиПоСтранице);
	
	Если ПараметрыПроверки.Итоги.ОсталосьВывестиСтрок = 0 Тогда
		
		МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаВсего);
		
	КонецЕсли;
	
	НужноНачатьНовуюСтраницу = Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей);
	
	Если НужноНачатьНовуюСтраницу Тогда
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("СуммаПоСтранице", ПечатьДокументовУНФ.ФорматСумм(
			ПараметрыПроверки.Итоги.СуммаПоСтранице));
		ДанныеПечати.Вставить("КоличествоПоСтранице", ПараметрыПроверки.Итоги.КоличествоПоСтранице);
		
		ПараметрыПроверки.ОбластиМакета.ОбластьИтогиПоСтранице.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ПараметрыПроверки.ОбластиМакета.ОбластьИтогиПоСтранице);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ПараметрыПроверки.НомерСтраницы = ПараметрыПроверки.НомерСтраницы + 1;
		ДанныеПечати.Вставить("НомерСтраницы", НСтр("ru ='Страница '") + ПараметрыПроверки.НомерСтраницы);
		
		ПараметрыПроверки.ОбластиМакета.ОбластьШапкаТаблицы.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ПараметрыПроверки.ОбластиМакета.ОбластьШапкаТаблицы);
		
	КонецЕсли;
	
	Возврат НужноНачатьНовуюСтраницу;
	
КонецФункции

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, Итоги,
	ДанныеОбъекта)

	ДанныеПечати.Очистить();

	Итоги.НомерСтроки = Итоги.НомерСтроки + 1;
	ДанныеПечати.Вставить("НомерСтроки", Итоги.НомерСтроки);

	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("Содержание", СтрокаТабличнойЧасти.Содержание);
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеПартии", СтрокаТабличнойЧасти.Партия);
	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(
		ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(
		СтрокаТабличнойЧасти));

	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	ДанныеПечати.Вставить("ПредставлениеХарактеристики", ПечатьДокументовУНФ.СтрокаПредставленияХарактеристики(
		ПараметрыНоменклатуры));

	ДанныеПечати.Вставить("Количество", СтрокаТабличнойЧасти.КоличествоПоКоэффициенту);
	ДанныеПечати.Вставить("ЕдиницаИзмерения", СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Наименование",
		СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Наименование);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Код", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Код);

	СуммаКПечати = ?(ДанныеОбъекта.СуммаВключаетНДС, СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте,
		СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте - СтрокаТабличнойЧасти.СуммаНДСВНациональнойВалюте);
	ДанныеПечати.Вставить("Цена", ПечатьДокументовУНФ.ФорматСумм(Окр(СуммаКПечати
																 / СтрокаТабличнойЧасти.КоличествоПоКоэффициенту, 2)));
	ДанныеПечати.Вставить("Сумма", ПечатьДокументовУНФ.ФорматСумм(
		СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте));

КонецПроцедуры

Процедура ОбновитьИтоги(Итоги, СтрокаТабличнойЧасти)

	Итоги.СуммаПоСтранице = Итоги.СуммаПоСтранице + СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте;
	Итоги.СуммаПоАкту = Итоги.СуммаПоАкту + СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте;
	Итоги.КоличествоПоСтранице = Итоги.КоличествоПоСтранице + СтрокаТабличнойЧасти.КоличествоПоКоэффициенту;
	Итоги.КоличествоПоАкту = Итоги.КоличествоПоАкту + СтрокаТабличнойЧасти.КоличествоПоКоэффициенту;

КонецПроцедуры

Функция КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта)
	
	КоличествоРезультирующихСтрок = 0;
	
	Для каждого СтрокаТаблицы Из ДанныеОбъекта.ТаблицаЗапасы Цикл
		
		Если СтрокаТаблицы.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + 1;
		
	КонецЦикла;
	
	Возврат КоличествоРезультирующихСтрок;
	
КонецФункции

#КонецОбласти

#КонецЕсли