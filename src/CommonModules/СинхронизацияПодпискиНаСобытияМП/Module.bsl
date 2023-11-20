#Область ПрограммныйИнтерфейс

Процедура СинхронизацияПередЗаписьюКартинки(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.СинхронизацияМП.ЭтотУзел().Код <> "001" Тогда
		
		Если Источник.ОбменДанными.Загрузка Тогда
			Если Источник.НомерКартинки <> Источник.Ссылка.НомерКартинки Тогда
				Источник.КартинкаСсылка = Источник.Ссылка.КартинкаСсылка;
				Источник.НужноПолучитьКартинкуССервера = Истина;
			ИначеЕсли Источник.Ссылка.НужноПолучитьКартинкуССервера = Ложь Тогда
				Источник.КартинкаСсылка = Источник.Ссылка.КартинкаСсылка;
				Источник.Картинка = Источник.Ссылка.Картинка;
				Источник.НужноПолучитьКартинкуССервера = Ложь
			ИначеЕсли Источник.Ссылка.НужноПолучитьКартинкуССервера = Истина Тогда
				Источник.НужноПолучитьКартинкуССервера = Истина;
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(Источник.Ссылка) Тогда
			ТекущаяКартинка = ОбщегоНазначенияМПСервер.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "Картинка");
			ТекущаяКартинка = ТекущаяКартинка.Получить();
		Иначе
			ТекущаяКартинка = Неопределено;
		КонецЕсли;
		
		Если ТипЗнч(Источник.Картинка) = Тип("ХранилищеЗначения") И Источник.Картинка.Получить() <> ТекущаяКартинка И Источник.НомерКартинки = Источник.Ссылка.НомерКартинки И Источник.НомерКартинки = Источник.Ссылка.НомерКартинки И Источник.Ссылка.НужноПолучитьКартинкуССервера <> Истина Тогда
			Источник.НомерКартинки = Источник.НомерКартинки + 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СинхронизацияПриКопированииДокумента(Источник, ОбъектКопирования) Экспорт
	
	Если ПланыОбмена.СинхронизацияМП.ЭтотУзел().Код <> "001" Тогда
		Источник.НомерПодтвержден = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура СинхронизацияПриЗаписиДокумента(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.СинхронизацияМП.ЭтотУзел().Код = "001" И Источник.НомерПодтвержден = Ложь Тогда
		Источник.НомерПодтвержден = Истина;
		Источник.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура СинхронизацияПриЗаписиВсехОбъектов(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИдетЗагрузкаНедозаписанныхДанных = Ложь;
	
	Если Источник.ДополнительныеСвойства.Свойство("ИдетЗагрузкаНедозаписанныхДанных", ИдетЗагрузкаНедозаписанныхДанных)И ИдетЗагрузкаНедозаписанныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СообщенияИзДругойВерсииМП.УдалитьСообщениеПоСсылке(Источник.Ссылка);
	
КонецПроцедуры

#КонецОбласти
