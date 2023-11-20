#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Процедура заполнения документа на основании заказа покупателя.
//
// Параметры:
//	ДанныеЗаполнения - Структура, ДокументСсылка.ЗаказПокупателя
//	
Процедура ЗаполнитьПоЗаказуПокупателя(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения = Документы.ЗаказПокупателя.ПустаяСсылка() Тогда Возврат КонецЕсли;
	
	// Заполнение шапки.
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, 
			Новый Структура("Организация, Контрагент, Договор, ВалютаДокумента, Курс, Кратность"));
			
	ЗначенияРеквизитов.Вставить("ЗаказНарядВозврат");
	Документы.ЗаказПокупателя.ПроверитьВозможностьВводаНаОснованииЗаказаПокупателя(ДанныеЗаполнения, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Контрагент, Договор, ВалютаДокумента, Курс, Кратность");
	ДокументОснование = ДанныеЗаполнения;
	
	НеУчитыватьЗаказы = Договор.НеУчитыватьЗаказыПриПередачеНаКомиссию;
	
	Если НеУчитыватьЗаказы Тогда
		ВызватьИсключение НСтр("ru = 'По договору не ведется учет заказов при передачу на комиссию. Ввод на основании не возможен'");
	КонецЕсли;
	
	Если НЕ ВалютаДокумента = Константы.НациональнаяВалюта.Получить() Тогда
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()), Новый Структура("Валюта", Договор.ВалютаРасчетов));
		Курс = СтруктураПоВалюте.Курс;
		Кратность = СтруктураПоВалюте.Кратность;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Договор) Тогда
		ВидЦенКонтрагента = Договор.ВидЦенКонтрагента;
	КонецЕсли;
	
	// Заполнение табличной части.
	Запасы.Очистить();
	ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя;
	ЗаполнитьПоЗаказуПокупателяНаПродажу(ДанныеЗаполнения);
	
КонецПроцедуры // ЗаполнитьПоЗаказПокупателя()

// Процедура заполнения документа на основании заказа покупателя.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоЗаказуПокупателяНаПродажу(ДанныеЗаполнения)
	
	ПараметрыОтбора = Новый Структура("НомерВариантаКП", ДанныеЗаполнения.ОсновнойВариантКП);
	СтрокиДляДобавления = ДанныеЗаполнения.Запасы.НайтиСтроки(ПараметрыОтбора);
	
	ЗаказВТабличнойЧасти = ?(ПоложениеЗаказа = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти, Истина, Ложь);
	
	ДополнительныеПараметры = Новый Структура("Заказ", ДанныеЗаполнения);
	ТаблицаОстатков = РаботаСКомиссионерамиКомитентамиСервер.ТаблицаОстатковТоваровУКомиссионера(ЭтотОбъект, ДополнительныеПараметры,,, Ложь);
	
	ПараметрыПоиска = Новый Структура("Номенклатура, Характеристика, Партия");
	
	Для Каждого СтрокаЗаказа Из СтрокиДляДобавления Цикл
		
		ПараметрыПоиска.Номенклатура = СтрокаЗаказа.Номенклатура;
		ПараметрыПоиска.Характеристика = СтрокаЗаказа.Характеристика;
		ПараметрыПоиска.Партия = СтрокаЗаказа.Партия;

		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(ПараметрыПоиска);
		
		Если Не НайденныеСтроки.Количество() Тогда Продолжить КонецЕсли;
		
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗаказа);
		
		Если ЗаказВТабличнойЧасти Тогда
			НоваяСтрока.Заказ = ДанныеЗаполнения;
		КонецЕсли;
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			Если НайденнаяСтрока.Количество = 0 Тогда Продолжить КонецЕсли;
			
			Если НоваяСтрока.Количество >= НайденнаяСтрока.Количество Тогда
				НоваяСтрока.Количество = НайденнаяСтрока.Количество;
				НоваяСтрока.СуммаСтарая = НайденнаяСтрока.СуммаРасчетов;
				ТаблицаОстатков.Удалить(НайденнаяСтрока);
			Иначе
				ЦенаСтарая = Окр(НайденнаяСтрока.СуммаРасчетов / НайденнаяСтрока.Количество, 2, РежимОкругления.Окр15как20);
				НоваяСтрока.СуммаСтарая = Окр(ЦенаСтарая * НоваяСтрока.Количество, 2, РежимОкругления.Окр15как20);
				НайденнаяСтрока.Количество = НайденнаяСтрока.Количество - НоваяСтрока.Количество;
				НайденнаяСтрока.СуммаРасчетов = НайденнаяСтрока.СуммаРасчетов - НоваяСтрока.СуммаСтарая;
				
				Если НайденнаяСтрока.СуммаРасчетов <= 0.01 Тогда 
					НоваяСтрока.СуммаСтарая = НоваяСтрока.СуммаСтарая + НайденнаяСтрока.СуммаРасчетов;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если НоваяСтрока.Количество = 0 Тогда Запасы.Удалить(НоваяСтрока) КонецЕсли;
		
		НоваяСтрока.Цена = 0;
		НоваяСтрока.Сумма = 0;

	КонецЦикла;
	
	ПерезаполнитьЦеныТабличнойЧастиПоВидуЦен();
	
КонецПроцедуры // ЗаполнитьПоЗаказПокупателяНаПродажу()

// Процедура заполнения документа на основании заказа покупателя.
//
// Параметры:
//	ДанныеЗаполнения - Структура, ДокументСсылка.ЗаказПокупателя
//	
Процедура ЗаполнитьПоРасходнаяНакладная(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения = Документы.ЗаказПокупателя.ПустаяСсылка() Тогда Возврат КонецЕсли;
	
	// Заполнение шапки.
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, 
			Новый Структура("Организация, Контрагент, Договор, ВалютаДокумента, Курс, Кратность, Заказ"));
			
	Документы.ЗаказПокупателя.ПроверитьВозможностьВводаНаОснованииЗаказаПокупателя(ДанныеЗаполнения, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Контрагент, Договор, ВалютаДокумента, Курс, Кратность, Заказ");
	ДокументОснование = ДанныеЗаполнения;
	
	Если НЕ ВалютаДокумента = Константы.НациональнаяВалюта.Получить() Тогда
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()), Новый Структура("Валюта", Договор.ВалютаРасчетов));
		Курс = СтруктураПоВалюте.Курс;
		Кратность = СтруктураПоВалюте.Кратность;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Договор) Тогда
		ВидЦенКонтрагента = Договор.ВидЦенКонтрагента;
	КонецЕсли;
	
	ЗаказВШапке = ДанныеЗаполнения.ПоложениеЗаказаПокупателя;
	
	Если ПоложениеЗаказа = ЗаказВШапке Тогда
		 Заказ = ДанныеЗаполнения.Заказ;
	 КонецЕсли;
	
	// Заполнение табличной части.
	Запасы.Очистить();
	
	ТаблицаОстатков = РаботаСКомиссионерамиКомитентамиСервер.ТаблицаОстатковТоваровУКомиссионера(ЭтотОбъект, ,,, Ложь);
	ПараметрыПоиска = Новый Структура("Номенклатура, Характеристика, Партия, ЗаказПокупателя");
	
	НеУчитыватьЗаказы = Договор.НеУчитыватьЗаказыПриПередачеНаКомиссию;
	
	Если НеУчитыватьЗаказы Тогда
		Заказ = Неопределено;
	КонецЕсли;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Запасы Цикл
		
		ПараметрыПоиска.Номенклатура = СтрокаТабличнойЧасти.Номенклатура;
		ПараметрыПоиска.Характеристика = СтрокаТабличнойЧасти.Характеристика;
		ПараметрыПоиска.Партия = СтрокаТабличнойЧасти.Партия;
		
		Если НеУчитыватьЗаказы Тогда
			ПараметрыПоиска.ЗаказПокупателя = Документы.ЗаказПокупателя.ПустаяСсылка();
		Иначе
			ПараметрыПоиска.ЗаказПокупателя = СтрокаТабличнойЧасти.Заказ;
		КонецЕсли;

		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(ПараметрыПоиска);
		
		Если Не НайденныеСтроки.Количество() Тогда Продолжить КонецЕсли;
		
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		
		НоваяСтрока.Заказ = ?(НеУчитыватьЗаказы, Неопределено, СтрокаТабличнойЧасти.Заказ);
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			Если НайденнаяСтрока.Количество = 0 Тогда Продолжить КонецЕсли;
			
			Если НоваяСтрока.Количество >= НайденнаяСтрока.Количество Тогда
				НоваяСтрока.Количество = НайденнаяСтрока.Количество;
				НоваяСтрока.СуммаСтарая = НайденнаяСтрока.СуммаРасчетов;
				ТаблицаОстатков.Удалить(НайденнаяСтрока);
			Иначе
				ЦенаСтарая = Окр(НайденнаяСтрока.СуммаРасчетов / НайденнаяСтрока.Количество, 2, РежимОкругления.Окр15как20);
				НоваяСтрока.СуммаСтарая = Окр(ЦенаСтарая * НоваяСтрока.Количество, 2, РежимОкругления.Окр15как20);
				НайденнаяСтрока.Количество = НайденнаяСтрока.Количество - НоваяСтрока.Количество;
				НайденнаяСтрока.СуммаРасчетов = НайденнаяСтрока.СуммаРасчетов - НоваяСтрока.СуммаСтарая;
				
				Если НайденнаяСтрока.СуммаРасчетов <= 0.01 Тогда 
					НоваяСтрока.СуммаСтарая = НоваяСтрока.СуммаСтарая + НайденнаяСтрока.СуммаРасчетов;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если НоваяСтрока.Количество = 0 Тогда Запасы.Удалить(НоваяСтрока) КонецЕсли;
		
		НоваяСтрока.Цена = 0;
		НоваяСтрока.Сумма = 0;
		
	КонецЦикла;
	
	ПерезаполнитьЦеныТабличнойЧастиПоВидуЦен();
	
КонецПроцедуры // ЗаполнитьПоЗаказПокупателя()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	УправлениеНебольшойФирмойЭлектронныеДокументыСервер.ОчиститьДатуНомерВходящегоДокумента(ЭтотОбъект);
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПокупателя")] = "ЗаполнитьПоЗаказуПокупателя";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходнаяНакладная")] = "ЗаполнитьПоРасходнаяНакладная";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда Возврат КонецЕсли;
	
	СуммаДокумента = Запасы.Итог("Сумма");
	СуммаОтклонений = Запасы.Итог("Отклонение");
	СуммаСтарая = Запасы.Итог("СуммаСтарая");
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПереоценкаТоваровНаКомиссии.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыПереданные", ДополнительныеСвойства.ТаблицыДляДвижений, Движения,
		Отказ);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ПереоценкаТоваровНаКомиссии.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ПереоценкаТоваровНаКомиссии.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);

КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПерезаполнитьЦеныТабличнойЧастиПоВидуЦен()
	
	СтруктураДанных = Новый Структура;
	ТабличнаяЧастьДокумента = Новый Массив;

	СтруктураДанных.Вставить("Дата",				Дата);
	СтруктураДанных.Вставить("Организация",			Организация);
	СтруктураДанных.Вставить("ВидЦен",				ВидЦен);
	СтруктураДанных.Вставить("ВалютаДокумента",		ВалютаДокумента);
	
	Для каждого СтрокаТЧ Из Запасы Цикл
		
		СтрокаТЧ.Цена = 0;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
			Продолжить;
		КонецЕсли; 
		
		СтрокаТабличнойЧасти = Новый Структура();
		СтрокаТабличнойЧасти.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		СтрокаТабличнойЧасти.Вставить("Характеристика", СтрокаТЧ.Характеристика);
		
		СтрокаТабличнойЧасти.Вставить("ЕдиницаИзмерения", СтрокаТЧ.ЕдиницаИзмерения);
		СтрокаТабличнойЧасти.Вставить("Цена", 0);  
		
		ЦенообразованиеКлиентСервер.ДополнитьСтруктуруДанныхНоменклатурыПолямиЦенообразования(ЭтотОбъект, СтрокаТЧ, СтрокаТабличнойЧасти);
		
		ТабличнаяЧастьДокумента.Добавить(СтрокаТабличнойЧасти);
		
	КонецЦикла;
		
	ЦенообразованиеСервер.ПолучитьЦеныТабличнойЧастиПоВидуЦен(СтруктураДанных, ТабличнаяЧастьДокумента);
		
	Для каждого СтрокаТЧ Из ТабличнаяЧастьДокумента Цикл

		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		СтруктураПоиска.Вставить("Характеристика", СтрокаТЧ.Характеристика);
		
		СтруктураПоиска.Вставить("ЕдиницаИзмерения", СтрокаТЧ.ЕдиницаИзмерения);
		
		РезультатПоиска = Запасы.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаРезультат Из РезультатПоиска Цикл
			СтрокаРезультат.Цена = СтрокаТЧ.Цена;
			РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаРезультат);
			
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры

Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, РассчитатьЦену = Ложь)
	
	Если Не РассчитатьЦену Тогда
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
	Иначе
		КоличествоСтроки = СтрокаТабличнойЧасти.Количество;
		СтрокаТабличнойЧасти.Цена = ?(КоличествоСтроки=0, 0, СтрокаТабличнойЧасти.Сумма / КоличествоСтроки);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли