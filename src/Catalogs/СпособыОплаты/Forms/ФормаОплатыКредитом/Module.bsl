#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если СуммаОплаты > КОплате Тогда
		ТекстСообщения = НСтр("ru = 'Сумма оплаты не может превышать сумму документа!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СуммаОплаты", "СуммаОплаты");
		Возврат;
	КонецЕсли;
	
	Если СуммаОплаты = 0 И НЕ НеОткрыватьПриЕдинственномДоговоре Тогда
		ПараметрыЗакрытия = Неопределено;
	Иначе
		ЭквайринговыйТерминал = ПолучитьТерминалПоДоговору(Договор);
		Если ЭквайринговыйТерминал = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'По данному договору невозможно определить параметры кредита.
					|Пожалуйста, проверьте настройки договора'"));
			Возврат;
		Иначе
			ПараметрыЗакрытия = Новый Структура("ЭквайринговыйТерминал, ВидПлатежнойКарты, Сумма, СуммаКомиссии, ВидОплаты",
				ЭквайринговыйТерминал,
				ЭквайринговыеОперацииКлиентСервер.ВидПлатежнойКартыДляКредита(),
				СуммаОплаты,
				ПосчитатьКомиссию(СуммаОплаты, ЭквайринговыйТерминал, ЭквайринговыеОперацииКлиентСервер.ВидПлатежнойКартыДляКредита()),
				ПредопределенноеЗначение("Перечисление.ВидыБезналичныхОплат.Кредит"));
		КонецЕсли;
	КонецЕсли;
	
	Если НеОткрыватьПриЕдинственномДоговоре Тогда
		ОписаниеОповещенияОЗакрытии.Модуль.ДобавитьОплатуКредитомЗавершение(ПараметрыЗакрытия, Неопределено);
	Иначе
		Закрыть(ПараметрыЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НеОткрыватьПриЕдинственномДоговоре Тогда
		Отказ = Истина;
		ОК(Команды.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("КОплате") Тогда
		КОплате = Параметры.КОплате;
		СуммаОплаты = КОплате;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Документ") Тогда
		Организация = Параметры.Документ.Организация;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭквайринговыйТерминал") Тогда
		Договор = Параметры.ЭквайринговыйТерминал.Договор;
	КонецЕсли;
	
	Если Параметры.Свойство("Сумма") Тогда
		СуммаОплаты = Параметры.Сумма;
	КонецЕсли;
	
	Элементы.СуммаОплаты.СписокВыбора.Добавить(КОплате, СтрШаблон(НСтр("ru = '%1 (К оплате)'"), КОплате));
	
	ЕдинственныйДоговор = Справочники.ДоговорыКонтрагентов.ЕдинственныйДоговорКредита(Организация);
	Если Не ЕдинственныйДоговор = Неопределено Тогда
		Договор = ЕдинственныйДоговор;
	КонецЕсли;
	
	Если Параметры.Свойство("НеОткрыватьПриЕдинственномДоговоре") И Не ЕдинственныйДоговор = Неопределено Тогда
		НеОткрыватьПриЕдинственномДоговоре = Параметры.НеОткрыватьПриЕдинственномДоговоре;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТерминалПоДоговору(Договор)
	
	МассивТерминалов = ЭквайринговыеОперацииСервер.ПолучитьТерминалыПоДоговору(Договор);
	Если МассивТерминалов.Количество() > 0 Тогда
		Возврат МассивТерминалов[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПосчитатьКомиссию(Сумма, ЭквайринговыйТерминал, ВидПлатежнойКарты)
	
	ТаблицаВидовКарт = Справочники.СпособыОплаты.ВидыПлатежныхКартИПроцентыКомиссии(ЭквайринговыйТерминал);
	НайденныеСтроки = ТаблицаВидовКарт.НайтиСтроки(Новый Структура("ВидПлатежнойКарты", ВидПлатежнойКарты));
	Если НайденныеСтроки.Количество() > 0 Тогда
		СуммаКомиссии = Сумма * НайденныеСтроки[0].ПроцентКомиссии/100;
	Иначе
		СуммаКомиссии = 0;
	КонецЕсли;
	
	Возврат СуммаКомиссии;
	
КонецФункции

#КонецОбласти