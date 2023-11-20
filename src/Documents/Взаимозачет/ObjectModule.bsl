#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Процедура заполнения документа на основании сверки взаиморасчетов
//
Процедура ЗаполнитьПоСверкеВзаиморасчетов(ДокументСверкаВзаиморасчетов) Экспорт
	
	ДокументОснование 	= ДокументСверкаВзаиморасчетов;
	Организация			= ДокументСверкаВзаиморасчетов.Организация;
	Для каждого СтрокаДоговораКонтрагента Из ДокументСверкаВзаиморасчетов.ДоговорыКонтрагентов Цикл
		
		Если СтрокаДоговораКонтрагента.Отметка Тогда
			
			ДоговорКонтрагента = СтрокаДоговораКонтрагента.Договор;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		
		Если ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоров.СПокупателем 
			ИЛИ ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоров.СКомиссионером Тогда
			
			ВидОперации			= Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПокупателя;
			КонтрагентИсточник	= ДокументСверкаВзаиморасчетов.Контрагент;
			
		ИначеЕсли ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоров.СПоставщиком 
			ИЛИ ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоров.СКомитентом Тогда
			
			ВидОперации			= Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПоставщику;
			Контрагент			= ДокументСверкаВзаиморасчетов.Контрагент;
			
		КонецЕсли;
		
		СальдоПоДаннымОрганизации	= ДокументСверкаВзаиморасчетов.ДанныеОрганизации.Итог("СуммаДолгКонтрагента") - ДокументСверкаВзаиморасчетов.ДанныеОрганизации.Итог("СуммаДолгОрганизации");
		СальдоПоДаннымКонтрагента	= ДокументСверкаВзаиморасчетов.ДанныеКонтрагента.Итог("СуммаДолгОрганизации") - ДокументСверкаВзаиморасчетов.ДанныеКонтрагента.Итог("СуммаДолгКонтрагента");
		Расхождение					= СальдоПоДаннымОрганизации - СальдоПоДаннымКонтрагента;
		
		Корреспонденция = ?(Расхождение < 0, ПланыСчетов.Управленческий.ПрочиеДоходы, ПланыСчетов.Управленческий.ПрочиеРасходы);
		
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьПоСверкеВзаиморасчетов()

// Процедура заполнения документа на основании поступления на счет
//
Процедура ЗаполнитьПоПоступлениюНаСчет(ДокументПоступлениеНаСчет, ИндексСтрокиРасшифровки) Экспорт
	
	// Основной сценарий: все документы оформлены в валюте и валюта расчетов по всем договорам - и с покупателем и с
	// агентом - рубли! Если будут оформлять документы в валюте, то курс и кратность для валют расчетов будут получены на
	//           дату текущего документа.
	// Курс и кратность валюты учета также получаем на дату документа (не зависит от того, в какой валюте ведутся расчеты).
	
	Дебитор.Очистить();
	Кредитор.Очистить();
	
	Дата = ДокументПоступлениеНаСчет.Дата;
	ДокументОснование 	= ДокументПоступлениеНаСчет;
	Организация			= ДокументПоступлениеНаСчет.Организация;
	ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПрочийВзаимозачет;
	ВидПрочегоВзаимозачета = Перечисления.ВидыПрочегоВзаимозачета.ДолгПокупателяИДолгПрочемуКонтрагенту;
	КорреспонденцияПрочиеРасчеты = ДокументПоступлениеНаСчет.Корреспонденция;
	
	// Заполним информацию о прочем контрагенте.
	Контрагент = ДокументПоступлениеНаСчет.Контрагент;
	НоваяСтрокаКредитор = Кредитор.Добавить();
	
	Если ДокументПоступлениеНаСчет.РасшифровкаПлатежа.Количество() > 0 Тогда
		НоваяСтрокаКредитор.Договор = ДокументПоступлениеНаСчет.РасшифровкаПлатежа[0].Договор;
	КонецЕсли;
	НоваяСтрокаКредитор.Документ = ДокументПоступлениеНаСчет;
	
	Если ИндексСтрокиРасшифровки >= ДокументПоступлениеНаСчет.РасшифровкаПлатежаОтАгента.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаСДанными = ДокументПоступлениеНаСчет.РасшифровкаПлатежаОтАгента[ИндексСтрокиРасшифровки];
	
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	ВалютаПоступленияНаСчет = ДокументПоступлениеНаСчет.ВалютаДенежныхСредств;
	ВалютаРасчетовКредитор = НоваяСтрокаКредитор.Договор.ВалютаРасчетов;
	
	КурсИКратностьВалютаРасчетовКредитор = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаРасчетовКредитор));
	НоваяСтрокаКредитор.Курс = КурсИКратностьВалютаРасчетовКредитор.Курс;
	НоваяСтрокаКредитор.Кратность = КурсИКратностьВалютаРасчетовКредитор.Кратность;
	
	// Заполним суммы для ТЧ Кредитор.
	Если ВалютаУчета = ВалютаПоступленияНаСчет Тогда
		НоваяСтрокаКредитор.СуммаУчета = СтрокаСДанными.ПолученоОтКлиента;
	Иначе
		// Курс и кратность валюты учета всегда получаем на дату документа.
		КурсИКратностьВалютаУчета = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаУчета));
		КурсИКратностьВалютаПоступленияНаСчет = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаПоступленияНаСчет));
		НоваяСтрокаКредитор.СуммаУчета = СтрокаСДанными.ПолученоОтКлиента * КурсИКратностьВалютаПоступленияНаСчет.Курс * КурсИКратностьВалютаУчета.Кратность
			/ ?(КурсИКратностьВалютаПоступленияНаСчет.Кратность * КурсИКратностьВалютаУчета.Курс = 0,
				1,
				КурсИКратностьВалютаПоступленияНаСчет.Кратность * КурсИКратностьВалютаУчета.Курс);
	КонецЕсли;
	
	Если ВалютаРасчетовКредитор = ВалютаПоступленияНаСчет Тогда
		НоваяСтрокаКредитор.СуммаРасчетов = СтрокаСДанными.ПолученоОтКлиента;
	Иначе
		КурсИКратностьВалютаПоступленияНаСчет = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаПоступленияНаСчет));
		НоваяСтрокаКредитор.СуммаРасчетов = СтрокаСДанными.ПолученоОтКлиента * КурсИКратностьВалютаПоступленияНаСчет.Курс * КурсИКратностьВалютаРасчетовКредитор.Кратность
			/ ?(КурсИКратностьВалютаПоступленияНаСчет.Кратность * КурсИКратностьВалютаРасчетовКредитор.Курс = 0,
				1,
				КурсИКратностьВалютаПоступленияНаСчет.Кратность * КурсИКратностьВалютаРасчетовКредитор.Курс);
	КонецЕсли;
	
	// Заполним информацию о покупателе.
	КонтрагентИсточник = СтрокаСДанными.Документ.Контрагент;
	
	НоваяСтрокаДебитор = Дебитор.Добавить();
	НоваяСтрокаДебитор.Договор = СтрокаСДанными.Документ.Договор;
	НоваяСтрокаДебитор.Документ = СтрокаСДанными.Документ;
	НоваяСтрокаДебитор.Заказ = СтрокаСДанными.Заказ;
	НоваяСтрокаДебитор.СчетНаОплату = СтрокаСДанными.СчетНаОплату;
	
	ВалютаРасчетов = НоваяСтрокаДебитор.Договор.ВалютаРасчетов;
	
	КурсИКратностьВалютаРасчетов = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаРасчетов));
	НоваяСтрокаДебитор.Курс = КурсИКратностьВалютаРасчетов.Курс;
	НоваяСтрокаДебитор.Кратность = КурсИКратностьВалютаРасчетов.Кратность;
	
	// Заполним суммы для ТЧ Дебитор.
	НоваяСтрокаДебитор.СуммаУчета = НоваяСтрокаКредитор.СуммаУчета;
	
	Если ВалютаРасчетов = ВалютаПоступленияНаСчет Тогда
		НоваяСтрокаДебитор.СуммаРасчетов = СтрокаСДанными.ПолученоОтКлиента;
	Иначе
		КурсИКратностьВалютаПоступленияНаСчет = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаПоступленияНаСчет));
		НоваяСтрокаДебитор.СуммаРасчетов = СтрокаСДанными.ПолученоОтКлиента * КурсИКратностьВалютаПоступленияНаСчет.Курс * КурсИКратностьВалютаРасчетов.Кратность
			/ ?(КурсИКратностьВалютаПоступленияНаСчет.Кратность * КурсИКратностьВалютаРасчетов.Курс = 0, 1, КурсИКратностьВалютаПоступленияНаСчет.Кратность * КурсИКратностьВалютаРасчетов.Курс);
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьПоСверкеВзаиморасчетов()

Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения.Свойство("Ссылка") Тогда
		Если ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.ПоступлениеНаСчет") Тогда
			
			ЗаполнитьПоПоступлениюНаСчет(ДанныеЗаполнения.Ссылка, ДанныеЗаполнения.ИндексСтрокиРасшифровки);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументРасчетов) Тогда
		ДокументРасчетов = Неопределено;
	КонецЕсли;
	
	Для каждого ТекСтрока Из Дебитор Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Документ) Тогда
			ТекСтрока.Документ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекСтрока Из Кредитор Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Документ) Тогда
			ТекСтрока.Документ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Заказ) Тогда
		Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПереуступкаДолгаПокупателя Тогда
			Заказ = Документы.ЗаказПокупателя.ПустаяСсылка();
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПереуступкаДолгаПоставщику Тогда
			Заказ = Документы.ЗаказПоставщику.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.Взаимозачет
		ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПокупателя
		ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПокупателя
		ИЛИ (ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПрочийВзаимозачет
			И ВидПрочегоВзаимозачета = Перечисления.ВидыПрочегоВзаимозачета.ДолгПокупателяИДолгПрочемуКонтрагенту) Тогда
		СуммаРасчетов = Дебитор.Итог("СуммаРасчетов");
		СуммаУчета = Дебитор.Итог("СуммаУчета");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПоставщику
		ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПоставщику
		ИЛИ (ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПрочийВзаимозачет
			И ВидПрочегоВзаимозачета = Перечисления.ВидыПрочегоВзаимозачета.ДолгПрочегоКонтрагентаИДолгПередПоставщиком) Тогда
		СуммаРасчетов = Кредитор.Итог("СуммаРасчетов");
		СуммаУчета = Кредитор.Итог("СуммаУчета");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПрочегоКонтрагента Тогда
		СуммаРасчетов = ПрочиеРасчеты.Итог("СуммаРасчетов");
		СуммаУчета = ПрочиеРасчеты.Итог("СуммаУчета");
		Если Не ПолучитьФункциональнуюОпцию("ОтображатьСчетаУчета") Тогда
			Для Каждого СтрокаТЧ Из ПрочиеРасчеты Цикл
				Если Не ЗначениеЗаполнено(СтрокаТЧ.СчетУчета) Тогда
					СтрокаТЧ.СчетУчета = ПланыСчетов.Управленческий.РасчетыСРазнымиДебиторамиИКредиторами;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.Взаимозачет
		ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПокупателя
		ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПоставщику Тогда
		
		ДебиторСуммаУчета = Дебитор.Итог("СуммаУчета");
		КредиторСуммаУчета = Кредитор.Итог("СуммаУчета");
		
		Если ДебиторСуммаУчета <> КредиторСуммаУчета Тогда
			Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПокупателя
				ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПоставщику Тогда
				ТекстСообщения = НСтр("ru = 'Сумма учета табличной части ""Авансы"", не равна сумме учета по табличной части ""Долги"".'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Сумма учета табличной части ""Расчеты с покупателем"", не равна сумме учета по табличной части ""Расчеты с поставщиком"".'");
			КонецЕсли;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дебитор[0].СуммаУчета", , Отказ);
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаРасчетов");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаУчета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Корреспонденция");
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Договор");
			Для каждого СтрокаТЧ Из Дебитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(КонтрагентИсточник);
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Документ");
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Договор");
			Для каждого СтрокаТЧ Из Кредитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Документ");
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидПрочегоВзаимозачета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КорреспонденцияПрочиеРасчеты");
		
		Если ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПокупателя
			ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ЗачетАвансовПоставщику Тогда
			
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Контрагент");
			
			Для Каждого ТекущаяСтрока Из Дебитор Цикл
				Если Не ТекущаяСтрока.ПризнакАванса Тогда
					ТекстСообщения = НСтр(
						"ru = 'В табличной части ""Авансы"" можно указать только строки с установленным флагом ""Аванс"".'");
					КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Дебитор",
						ТекущаяСтрока.НомерСтроки, "ПризнакАванса");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого ТекущаяСтрока Из Кредитор Цикл
				Если ТекущаяСтрока.ПризнакАванса Тогда
					ТекстСообщения = НСтр(
						"ru = 'В табличной части ""Долги"" можно указать только строки со сброшенным флагом ""Аванс"".'");
					КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Дебитор",
						ТекущаяСтрока.НомерСтроки, "ПризнакАванса");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПереуступкаДолгаПокупателя Тогда
		
		ДебиторСуммаУчета = Дебитор.Итог("СуммаУчета");
		
		Если ДебиторСуммаУчета <> СуммаУчета Тогда
			ТекстСообщения = НСтр("ru = 'Сумма учета, не равна сумме учета табличной части ""Расчеты с покупателем"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СуммаУчета", , Отказ);
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Корреспонденция");
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Договор");
			Для каждого СтрокаТЧ Из Дебитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(КонтрагентИсточник);
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Документ");
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
			Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Документ");
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидПрочегоВзаимозачета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КорреспонденцияПрочиеРасчеты");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПереуступкаДолгаПоставщику Тогда
		
		КредиторСуммаУчета = Кредитор.Итог("СуммаУчета");
		
		Если КредиторСуммаУчета <> СуммаУчета Тогда
			ТекстСообщения = НСтр("ru = 'Сумма учета, не равна сумме учета табличной части ""Расчеты с поставщиком"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СуммаУчета", , Отказ);
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Корреспонденция");
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Договор");
			Для каждого СтрокаТЧ Из Кредитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(КонтрагентИсточник);
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Документ");
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
			Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Документ");
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидПрочегоВзаимозачета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КорреспонденцияПрочиеРасчеты");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПокупателя Тогда
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Контрагент");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаРасчетов");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаУчета");
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Договор");
			Для каждого СтрокаТЧ Из Дебитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(КонтрагентИсточник);
			КонецЦикла;
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Документ");
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидПрочегоВзаимозачета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КорреспонденцияПрочиеРасчеты");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПоставщику Тогда
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КонтрагентИсточник");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаРасчетов");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаУчета");
		
		Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Договор");
			Для каждого СтрокаТЧ Из Кредитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
			КонецЦикла;
		КонецЕсли;
			
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Документ");
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидПрочегоВзаимозачета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КорреспонденцияПрочиеРасчеты");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.ПрочийВзаимозачет Тогда
		
		ДебиторСуммаУчета = Дебитор.Итог("СуммаУчета");
		КредиторСуммаУчета = Кредитор.Итог("СуммаУчета");
		
		Если ДебиторСуммаУчета <> КредиторСуммаУчета Тогда
			Если ВидПрочегоВзаимозачета = Перечисления.ВидыПрочегоВзаимозачета.ДолгПокупателяИДолгПрочемуКонтрагенту Тогда
				ТекстСообщения = НСтр("ru = 'Сумма учета табличной части ""Расчеты с покупателем"", не равна сумме учета по табличной части ""Расчеты с прочим контрагентом""!'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Сумма учета табличной части ""Расчеты с прочим контрагентом"", не равна сумме учета по табличной части ""Расчеты с поставщиком""!'");
			КонецЕсли;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дебитор[0].СуммаУчета", , Отказ);
		КонецЕсли;
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаРасчетов");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаУчета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Корреспонденция");
		
		Если НЕ КонтрагентИсточник.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Договор");
			Для каждого СтрокаТЧ Из Дебитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(КонтрагентИсточник);
			КонецЦикла;
		КонецЕсли;
		
		Если ВидПрочегоВзаимозачета <> Перечисления.ВидыПрочегоВзаимозачета.ДолгПокупателяИДолгПрочемуКонтрагенту
			ИЛИ НЕ КонтрагентИсточник.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Документ");
		КонецЕсли;
		
		Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Договор");
			Для каждого СтрокаТЧ Из Кредитор Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
			КонецЦикла;
		КонецЕсли;
		
		Если ВидПрочегоВзаимозачета <> Перечисления.ВидыПрочегоВзаимозачета.ДолгПрочегоКонтрагентаИДолгПередПоставщиком
			ИЛИ НЕ Контрагент.ВестиРасчетыПоДокументам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Документ");
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВзаимозачет.КорректировкаДолгаПрочегоКонтрагента Тогда
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КонтрагентИсточник");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаРасчетов");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаУчета");
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Дебитор.Документ");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кредитор.Документ");
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидПрочегоВзаимозачета");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КорреспонденцияПрочиеРасчеты");
		
		Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ПрочиеРасчеты.Договор");
			Для каждого СтрокаТЧ Из ПрочиеРасчеты Цикл
				СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.Взаимозачет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПокупателями", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПоставщиками", ТаблицыДляДвижений, Движения, Отказ);
	ПрочиеРасчетыУНФ.ОтразитьРасчетыСПрочимиКонтрагентами(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаСчетовИЗаказов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыОтложенные", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыКассовыйМетод", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыНераспределенные", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыКассовыйМетодЭквайринг", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаДокументов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗакупкиДляКУДиР", ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.Взаимозачет.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.Взаимозачет.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события ОбработкаЗаполнения объекта
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.СверкаВзаиморасчетов")] = "ЗаполнитьПоСверкеВзаиморасчетов";
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	УчитыватьВНУ = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли