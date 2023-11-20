#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		РежимВыгрузкиПриНеобходимости    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РучнойОбмен = Истина;
	Иначе
		РучнойОбмен = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоВидамДокументов И ВидыДокументов.Количество() <> 0 Тогда
		ВидыДокументов.Очистить();
	ИначеЕсли ВидыДокументов.Количество() = 0 И ИспользоватьОтборПоВидамДокументов Тогда
		ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоНоменклатуре И Номенклатура.Количество() <> 0 Тогда
		Номенклатура.Очистить();
	ИначеЕсли Номенклатура.Количество() = 0 И ИспользоватьОтборПоНоменклатуре Тогда
		ИспользоватьОтборПоНоменклатуре = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РежимВыгрузкиКартинокНоменклатуры) Тогда
		РежимВыгрузкиКартинокНоменклатуры = Перечисления.РежимВыгрузкиКартинокНоменклатуры.ТолькоОсновнаяКартинка;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОбобщенныйСклад) Тогда
		ОбобщенныйСклад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВерсияФорматаОбмена) Тогда
		ВерсияФорматаОбмена = "1.6";
	КонецЕсли;
	
	Если ВариантНастройки = "ВебВитрина"
		ИЛИ ВариантНастройки = "ОбменРТ" Тогда
		ПереноситьКатегорииКакВидыНоменклатуры = Истина;
		ПереноситьЗаказыКакСчетаНаОплату = Истина;
	КонецЕсли;
	
	Если ВариантНастройки = "КабинетКлиента" Тогда
		ПереноситьКатегорииКакВидыНоменклатуры = Истина;
		ВыгружатьДополнительныеРеквизиты = Истина;
		ВыгружатьКартинкиНоменклатуры = Истина;
		РежимВыгрузкиКартинокНоменклатуры = Перечисления.РежимВыгрузкиКартинокНоменклатуры.ВсеКартинки;
		СжиматьВыгружаемыеИзображения = Истина;
	КонецЕсли;
	
	Если ВариантНастройки = "ОбменУТ11"
		ИЛИ ВариантНастройки = "ОбменРТ30"
		ИЛИ ВариантНастройки = "ОбменУНФРТ30" Тогда
		ПереноситьКатегорииКакВидыНоменклатуры = Истина;
		ПереноситьЗаказыКакСчетаНаОплату = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Попытка
		ОбменДаннымиXDTOСервер.ПропускатьОбъектыСОшибкамиПроверкиПоСхеме(Ссылка, ПропускатьНекорректныеОбъектыПриВыгрузке);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях") Тогда
		РеквизитОбобщенныйСклад = ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад");
		Если РеквизитОбобщенныйСклад <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(РеквизитОбобщенныйСклад);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	// настройка отборов
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДата());
	ИспользоватьОтборПоОрганизациям = Ложь;
	ИспользоватьОтборПоВидамДокументов = Ложь;
	РучнойОбмен = Ложь;
	АвтоматическиЗачитыватьАвансы = Ложь;
	ОбобщенныйСклад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	ПропускатьНекорректныеОбъектыПриВыгрузке = Истина;
	ПереноситьКатегорииКакВидыНоменклатуры = Истина;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли