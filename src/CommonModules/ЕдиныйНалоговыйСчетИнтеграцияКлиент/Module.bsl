////////////////////////////////////////////////////////////////////////////////
// ЕдиныйНалоговыйСчетИнтеграцияКлиент:
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область АвторизацияEnsIntegration

Процедура ЗапроситьПодтверждениеРегистрацииEnsIntegration(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыЗапроса = Новый Структура("Организация, СертификатПодписи, КлючДоступа, ПодписанныйКлюч, НомерМашиночитаемойДоверенности, ОповещениеПослеПодтвержденияРегистрацииEnsIntegration");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ПараметрыПолученияДанных);
	ПолучитьПодтверждениеРегистрацииEnsIntegration(ПараметрыЗапроса)
	
КонецПроцедуры

Процедура ПолучитьПодтверждениеРегистрацииEnsIntegration(Параметры)
	
	ПараметрыВыполнения = Новый Структура("Организация, СертификатПодписи, КлючДоступа, ПодписанныйКлюч, НомерМашиночитаемойДоверенности");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ПолучитьПодтверждениеРегистрацииEnsIntegration(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеПодтвержденияРегистрацииEnsIntegration = Новый ОписаниеОповещения(
		"ПослеПодтвержденияРегистрацииEnsIntegration", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПодтвержденияРегистрацииEnsIntegration, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеПодтвержденияРегистрацииEnsIntegration(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПодтвержденияРегистрацииEnsIntegration, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПодтвержденияРегистрацииEnsIntegration, Новый Структура("Выполнено", Истина));
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Подключение к сервису ЛК ЕНС.'");
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПодтвержденияРегистрацииEnsIntegration, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

Процедура АвторизоватьсяНаСервисеEnsIntegration(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыЗапроса = Новый Структура("Организация, СертификатПодписи, НомерМашиночитаемойДоверенности, ОповещениеПослеАвторизацииНаСервисеEnsIntegration");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ПараметрыПолученияДанных);
	ПолучитьТокенАвторизацииEnsIntegration(ПараметрыЗапроса)
	
КонецПроцедуры

Процедура ПолучитьТокенАвторизацииEnsIntegration(Параметры)
	
	ПараметрыВыполнения = Новый Структура("Организация, СертификатПодписи, НомерМашиночитаемойДоверенности, ОповещениеПослеАвторизацииНаСервисеEnsIntegration");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	Параметры.Вставить("ОповещениеПослеАвторизацииНаСервисеEnsIntegration", Параметры.ОповещениеПослеАвторизацииНаСервисеEnsIntegration);
	ОповещениеПослеАутентификации = Новый ОписаниеОповещения(
			"ПолучитьДанныеПослеАвторизацииНаСервисеEnsIntegration", ЕдиныйНалоговыйСчетИнтеграцияКлиент, Параметры);
	ВыполнитьАутентификациюEnsIntegration(ОповещениеПослеАутентификации, ПараметрыВыполнения, Истина);
	
КонецПроцедуры

Процедура ВыполнитьАутентификациюEnsIntegration(
	Оповещение,
	ПараметрыВыполнения,
	ВыводитьОкноОжидания = Ложь) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПослеАутентификации",   Оповещение);
	ДополнительныеПараметры.Вставить("Организация",                     ПараметрыВыполнения.Организация);
	ДополнительныеПараметры.Вставить("СертификатПодписи",               ПараметрыВыполнения.СертификатПодписи);
	ДополнительныеПараметры.Вставить("НомерМашиночитаемойДоверенности", ПараметрыВыполнения.НомерМашиночитаемойДоверенности);
	ДополнительныеПараметры.Вставить("ВыводитьОкноОжидания",            ВыводитьОкноОжидания);
	ДополнительныеПараметры.Вставить("ОповещениеПослеАвторизацииНаСервисеEnsIntegration",
		ПараметрыВыполнения.ОповещениеПослеАвторизацииНаСервисеEnsIntegration);
	
	Если ЗначениеЗаполнено(Оповещение.ДополнительныеПараметры)
		И Оповещение.ДополнительныеПараметры.Свойство("ФормаВладелец") Тогда
		ДополнительныеПараметры.Вставить("ФормаВладелец", Оповещение.ДополнительныеПараметры.ФормаВладелец);
	КонецЕсли;
	
	Если ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		ПродолжитьПодключениеКСеврисуEnsIntegration(Истина, ДополнительныеПараметры);
	Иначе
		ОповещениеОПодключении = Новый ОписаниеОповещения(
			"ПродолжитьПодключениеКСеврисуEnsIntegration", ЭтотОбъект, ДополнительныеПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОповещениеОПодключении, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПродолжитьПодключениеКСеврисуEnsIntegration(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
		Возврат;
	КонецЕсли;
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	ДополнительныеПараметры.Вставить("АдресРезультата", АдресРезультата);
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация",                     ДополнительныеПараметры.Организация);
	Параметры.Вставить("СертификатПодписи",               ДополнительныеПараметры.СертификатПодписи);
	Параметры.Вставить("НомерМашиночитаемойДоверенности", ДополнительныеПараметры.НомерМашиночитаемойДоверенности);
	Параметры.Вставить("АдресРезультата",                 АдресРезультата);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияПолученияИдентификатораЗапросаАвторизацииEnsIntegration(Параметры);
	
	Если ДополнительныеПараметры.Свойство("ФормаВладелец")
		И ТипЗнч(ДополнительныеПараметры.ФормаВладелец) = Тип("ФормаКлиентскогоПриложения") Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ДополнительныеПараметры.ФормаВладелец);
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	КонецЕсли;
	
	ПараметрыОжидания.ВыводитьОкноОжидания = ДополнительныеПараметры.ВыводитьОкноОжидания;
	ПослеПолучениеИдентификатораЗапросаАвторизацииEnsIntegration = Новый ОписаниеОповещения(
		"ПослеПолучениеИдентификатораЗапросаАвторизацииEnsIntegration", ЭтотОбъект, ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПолучениеИдентификатораЗапросаАвторизацииEnsIntegration, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеПолучениеИдентификатораЗапросаАвторизацииEnsIntegration(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатПодключения = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресРезультата);
		
		ТребуетсяПодтверждениеУчетнойЗаписи = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатПодключения, "ТребуетсяПодтверждениеУчетнойЗаписи", Ложь);
		
		Если ТребуетсяПодтверждениеУчетнойЗаписи Тогда
			ПослеНеПолучениеСсылкиНаАутентификациюEnsIntegration(Результат, ДополнительныеПараметры);
		Иначе
			
			АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
			ДополнительныеПараметры.Вставить("АдресРезультата", АдресРезультата);
			
			Параметры = Новый Структура;
			Параметры.Вставить("Организация",                     ДополнительныеПараметры.Организация);
			Параметры.Вставить("ИдентификаторЗапросаАвторизации", РезультатПодключения.ИдентификаторЗапросаАвторизации);
			Параметры.Вставить("Тикет",                           РезультатПодключения.Тикет);
			Параметры.Вставить("АдресРезультата",                 АдресРезультата);
			Параметры.Вставить("ПараметрыСессии",                 ПоместитьВоВременноеХранилище("", Новый УникальныйИдентификатор()));
			РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияПолученияСсылкиНаАутентификациюEnsIntegration(Параметры);
			
			Если ДополнительныеПараметры.Свойство("ФормаВладелец")
				И ТипЗнч(ДополнительныеПараметры.ФормаВладелец) = Тип("ФормаКлиентскогоПриложения") Тогда
				ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ДополнительныеПараметры.ФормаВладелец);
			Иначе
				ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
			КонецЕсли;
			
			ПараметрыОжидания.ВыводитьОкноОжидания = ДополнительныеПараметры.ВыводитьОкноОжидания;
			ПослеПолучениеСсылкиНаАутентификациюEnsIntegration = Новый ОписаниеОповещения(
				"ПослеПолучениеСсылкиНаАутентификациюEnsIntegration", ЭтотОбъект, ДополнительныеПараметры);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(
				РезультатВыполнения, ПослеПолучениеСсылкиНаАутентификациюEnsIntegration, ПараметрыОжидания);
		КонецЕсли;
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Подключение к сервису ens-itegration.'");
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

Процедура ПослеПолучениеСсылкиНаАутентификациюEnsIntegration(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатПодключения = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатПодключения.ТекстОшибки) Тогда // Ошибка
			ВидОперации = НСтр("ru = 'Подключение к сервису ens-itegration.'");
			ОбработатьИнформационноеСообщение(ВидОперации, РезультатПодключения.ТекстОшибки, ,
				ДополнительныеПараметры.Организация);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
			Возврат;
		КонецЕсли;
		
		ПараметрыСессии = ПолучитьИзВременногоХранилища(РезультатПодключения.ПараметрыСессии);
		Если ЗначениеЗаполнено(ПараметрыСессии) Тогда
			ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.СохранитьСессиюОбменаНаСервере(
				ДополнительныеПараметры.Организация, ПараметрыСессии);
		КонецЕсли;
		РезультатПодключения.ПараметрыСессии = ПоместитьВоВременноеХранилище("", Новый УникальныйИдентификатор());
		
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено",            Истина);
		РезультатВыполнения.Вставить("РезультатАвторизации", РезультатПодключения);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, РезультатВыполнения);
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Подключение к сервису ens-itegration.'");
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

Процедура ПослеНеПолучениеСсылкиНаАутентификациюEnsIntegration(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатПодключения = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатПодключения.ТекстОшибки) Тогда // Ошибка
			ВидОперации = НСтр("ru = 'Подключение к сервису ens-itegration.'");
			ОбработатьИнформационноеСообщение(ВидОперации, РезультатПодключения.ТекстОшибки, ,
				ДополнительныеПараметры.Организация);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
			Возврат;
		КонецЕсли;
		
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено",                           Истина);
		РезультатВыполнения.Вставить("ТребуетсяПодтверждениеУчетнойЗаписи", РезультатПодключения.ТребуетсяПодтверждениеУчетнойЗаписи);
		РезультатВыполнения.Вставить("РезультатАвторизации",                Новый Структура("КлючДоступа", РезультатПодключения.ИдентификаторЗапросаПодтверждения));
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, РезультатВыполнения);
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Подключение к сервису ens-itegration.'");
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАутентификации, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

Процедура ПолучитьДанныеПослеАвторизацииНаСервисеEnsIntegration(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеАвторизацииНаСервисеEnsIntegration, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область Авторизация

Процедура ЗапроситьТокенАвторизацииНаСервисеФНС(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыЗапроса = Новый Структура("Организация, РезультатАвторизацииEnsIntegration, СертификатПодписи, КлючДоступа, ПодписанныйКлюч, ИспользуетсяДоверенностьНаПолучениеДанных, НомерМашиночитаемойДоверенности, ОповещениеПослеВыполненияЗадания");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ПараметрыПолученияДанных);
	ПолучитьТокенАвторизацииНаСервисеФНС(ПараметрыЗапроса)
	
КонецПроцедуры

Процедура ПолучитьТокенАвторизацииНаСервисеФНС(Параметры)
	
	ПараметрыВыполнения = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	Параметры.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("ПараметрыСессии", ПоместитьВоВременноеХранилище("", Новый УникальныйИдентификатор()));

	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияПолученияТокенаАвторизацииНаСервереФНС(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеПолученияТокенаАвторизацииНаСервисеФНС = Новый ОписаниеОповещения(
		"ПослеПолученияТокенаАвторизацииНаСервисеФНС", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПолученияТокенаАвторизацииНаСервисеФНС, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеПолученияТокенаАвторизацииНаСервисеФНС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатПодключения = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресРезультата);
		
		ПараметрыСессии = ПолучитьИзВременногоХранилища(РезультатПодключения.ПараметрыСессии);
		Если ЗначениеЗаполнено(ПараметрыСессии) Тогда
			ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.СохранитьСессиюОбменаНаСервере(
				ДополнительныеПараметры.Организация, ПараметрыСессии);
		КонецЕсли;
		РезультатПодключения.ПараметрыСессии = ПоместитьВоВременноеХранилище("", Новый УникальныйИдентификатор());
		
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено",            Истина);
		РезультатВыполнения.Вставить("РезультатАвторизации", РезультатПодключения);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполнения);
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Подключение к сервису ЛК ЕНС.'");
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПолучениеДанных

Процедура ПолучитьДанныеЕдиногоНалоговогоСчета(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыЗапроса = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ПараметрыЗапроса.Вставить("ОповещениеПослеВыполненияЗадания");
	ПараметрыЗапроса.Вставить("ОповещениеПрерывания");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ПараметрыПолученияДанных);
	ОтправитьЗапросНаПолучениеДанныхСервисаЕНС(ПараметрыЗапроса)
	
КонецПроцедуры

Процедура ОтправитьЗапросНаПолучениеДанныхСервисаЕНС(Параметры)
	
	ПараметрыВыполнения = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	Параметры.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("АдресРезультата", АдресРезультата);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияОтправкиЗапросаНаПолучениеДанныхСервисаЕНС(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеПолученияОтветаНаЗапросОтСервисаЕНС = Новый ОписаниеОповещения(
		"ПослеПолученияОтветаНаЗапросОтСервисаЕНС", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПолученияОтветаНаЗапросОтСервисаЕНС, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ОтправитьЗапросНаПолучениеСтатусаЗаданияНаСервисеЕНС(Параметры) Экспорт
	
	ПараметрыВыполнения = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	Параметры.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("АдресРезультата", АдресРезультата);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияНаПолучениеСтатусаЗаданияНаСервисеЕНС(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеПолученияОтветаНаЗапросОтСервисаЕНС = Новый ОписаниеОповещения(
		"ПослеПолученияОтветаНаЗапросОтСервисаЕНС", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПолученияОтветаНаЗапросОтСервисаЕНС, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ОтправитьЗапросНаЗагрузкуПодготовленныхДанныхСервисаЕНС(Параметры)
	
	ПараметрыВыполнения = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	Параметры.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("АдресРезультата", АдресРезультата);
	
	Параметры.Вставить("ПутьКДанным", Параметры.ПутьКДанным);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияНаЗагрузкуПодготовленныхДанныхСервисаЕНС(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеПолученияОтветаНаЗапросОтСервисаЕНС = Новый ОписаниеОповещения(
		"ПослеПолученияОтветаНаЗапросОтСервисаЕНС", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПолученияОтветаНаЗапросОтСервисаЕНС, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеПолученияОтветаНаЗапросОтСервисаЕНС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		
		// Запрос к сервису выполняется в несколько этапов
		//  1. Непосредственно отправка запроса. В ответ приходит ИД задания на сервере
		//  2. Опрос сервера по ранее полученному ИД задания. До тех пор пока не получим ответ, что задание выполнено
		//  3. Получение результата выполнения запроса по ссылке
		
		РезультатВыполнения = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресРезультата);
		
		Если РезультатВыполнения.Свойство("ОтветСервиса") Тогда
			ОтветСервиса = РезультатВыполнения.ОтветСервиса.data;
			Если ТипЗнч(ОтветСервиса) = Тип("Структура") Тогда
				Если ОтветСервиса.Свойство("path") Тогда // Задание выполнено, подготовлен файл для загрузки
					ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Выполнения метода: %1
						|Ответ сервиса: %2'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода, ОтветСервиса.path);
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Имя метода: %1; путь: %2; время: %3'"),
						РезультатВыполнения.ИмяМетода, ОтветСервиса.path, ТекущаяДата());
					ОбработатьИнформационноеСообщение(ВидОперации, ТекстСообщения, , ДополнительныеПараметры.Организация, Ложь);
					ДополнительныеПараметры.Вставить("ПутьКДанным", ОтветСервиса.path);
					ДополнительныеПараметры.Вставить("ИмяМетода",   РезультатВыполнения.ИмяМетода);
					ОтправитьЗапросНаЗагрузкуПодготовленныхДанныхСервисаЕНС(ДополнительныеПараметры);
				ИначеЕсли ОтветСервиса.Свойство("status") Тогда //Задание не выполняется, требуется понять надо ли продолжать его ждать
					ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Выполнения метода: %1
						|Ответ сервиса: %2'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода, ОтветСервиса.status);
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Имя метода: %1; статус: %2; время: %3'"),
						РезультатВыполнения.ИмяМетода, ВРег(ОтветСервиса.status), ТекущаяДата());
					ОбработатьИнформационноеСообщение(ВидОперации, ТекстСообщения, , ДополнительныеПараметры.Организация, Ложь);
					Если ВРег(ОтветСервиса.status) = "NEW"
						Или ВРег(ОтветСервиса.status) = "PROCESSOR_DATA_PROCESS"
						Или ВРег(ОтветСервиса.status) = "PROCESSOR_DATA_COMPLETED"
						Или ВРег(ОтветСервиса.status) = "EXPORT_DATA_PROCESS"
						Или ВРег(ОтветСервиса.status) = "EXPORT_DATA_COMPLETED"
						Или ВРег(ОтветСервиса.status) = "CRYPT_DATA_SEND_PROCESS"
						Или ВРег(ОтветСервиса.status) = "CRYPT_DATA_SEND_COMPLETED"
						Или ВРег(ОтветСервиса.status) = "CRYPT_DATA_RECEIVE_PROCESS"
						Или ВРег(ОтветСервиса.status) = "CRYPT_DATA_RECEIVE_COMPLETED"
						Или ВРег(ОтветСервиса.status) = "READY_FOR_TRANSPORT"
						Или ВРег(ОтветСервиса.status) = "TRANSFER_DATA_TO_STORE_PROCESS" Тогда // Запрос выполняется, требуется преспросить сервис еще раз
						ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПрерывания, ДополнительныеПараметры);
					ИначеЕсли ВРег(ОтветСервиса.status) = "COMPLETED"
						Или ВРег(ОтветСервиса.status) = "TRANSFER_DATA_TO_STORE_COMPLETED" Тогда // Запрос выполнен
						ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПрерывания, ДополнительныеПараметры);
					ИначеЕсли ВРег(ОтветСервиса.status) = "PROCESSOR_DATA_NOT_COMPLETED" Тогда // Требуется повторная авторизация
						РезультатВыполненияЗапроса = СтруктураОтветаРезультатаЗапроса();
						РезультатВыполненияЗапроса.Вставить("Выполнено",                 Истина);
						РезультатВыполненияЗапроса.Вставить("ТребуетсяАвторизацияПоКЭП", Истина);
						РезультатВыполненияЗапроса.Вставить("РезультатАвторизации",      РезультатВыполнения.РезультатАвторизации);
						РезультатВыполненияЗапроса.Вставить("ИмяМетода",                 РезультатВыполнения.ИмяМетода);
						РезультатВыполненияЗапроса.Вставить("АдресРезультата",           ДополнительныеПараметры.АдресРезультата);
						ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполненияЗапроса);
					ИначеЕсли ВРег(ОтветСервиса.status) = "EXPORT_DATA_EMPTY_RESULT" Тогда // Данных нет
						ПрекратитьОбновление = РезультатВыполнения.ИмяМетода = "СальдоЕНС";
						РезультатВыполненияЗапроса = СтруктураОтветаРезультатаЗапроса();
						РезультатВыполненияЗапроса.Вставить("Выполнено",                 Истина);
						РезультатВыполненияЗапроса.Вставить("ПрекратитьОбновление",      ПрекратитьОбновление);
						РезультатВыполненияЗапроса.Вставить("ИмяМетода",                 РезультатВыполнения.ИмяМетода);
						РезультатВыполненияЗапроса.Вставить("АдресРезультата",           ДополнительныеПараметры.АдресРезультата);
						Если ПрекратитьОбновление Тогда
							ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.УстановитьДатыПоследнегоОбновления(ДополнительныеПараметры.Организация,
								ДополнительныеПараметры.ТекущаяДата)
						Иначе
							ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.УстановитьДатуПоследнегоОбновления(ДополнительныеПараметры.Организация,
								ДополнительныеПараметры.ТекущаяДата,
								,
								,
								РезультатВыполнения.ИмяМетода);
						КонецЕсли;
						ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполненияЗапроса);
					ИначеЕсли СтрНайти(ВРег(ОтветСервиса.status), "ERROR") <> 0 Тогда // Ошибка на стороне сервиса
						РезультатВыполненияЗапроса = СтруктураОтветаРезультатаЗапроса();
						РезультатВыполненияЗапроса.Вставить("Выполнено",           Истина);
						РезультатВыполненияЗапроса.Вставить("ФайлПолучен",         Ложь);
						РезультатВыполненияЗапроса.Вставить("ИмяМетода",           РезультатВыполнения.ИмяМетода);
						РезультатВыполненияЗапроса.Вставить("АдресРезультата",     ДополнительныеПараметры.АдресРезультата);
						ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Ошибка выполнения метода: %1
						|Ответ сервиса: %2'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода, ОтветСервиса.status);
						ОбработатьИнформационноеСообщение(ВидОперации, ОтветСервиса.status, ОтветСервиса.errorMessage,
							ДополнительныеПараметры.Организация);
						ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполненияЗапроса);
					Иначе // ошибка
						ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Ошибка выполнения метода: %1
						|Ответ сервиса: %2'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода, ОтветСервиса.status);
						ОбработатьИнформационноеСообщение(ВидОперации, ОтветСервиса.status, ОтветСервиса.status,
							ДополнительныеПараметры.Организация);
						ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
					КонецЕсли;
				Иначе // ошибка
					ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Ответ сервиса не распознан. Ошибка выполнения метода: %1
					|Ответ сервиса: %2'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода, ОтветСервиса.status);
					ОбработатьИнформационноеСообщение(ВидОперации, ОтветСервиса.status, ОтветСервиса.status,
						ДополнительныеПараметры.Организация);
					ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(ОтветСервиса) Тогда
				// получили иднтификатор задания и его надо опрашивать
				ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ОтветСервиса);
				ОтправитьЗапросНаПолучениеСтатусаЗаданияНаСервисеЕНС(ДополнительныеПараметры);
			Иначе // ошибка
				ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Ответ сервиса не распознан. Ошибка выполнения метода: %1
				|Ответ сервиса: %2'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода, РезультатВыполнения.ОтветСервиса.error);
				ОбработатьИнформационноеСообщение(ВидОперации, РезультатВыполнения.ОтветСервиса.message, РезультатВыполнения.ОтветСервиса.error,
					ДополнительныеПараметры.Организация);
				ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
			КонецЕсли;
		ИначеЕсли РезультатВыполнения.Свойство("ФайлПолучен") Тогда
			ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Выполнения метода: %1'"),
				ДополнительныеПараметры.ОписаниеМетода.ИмяМетода);
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Имя метода: %1; загрузка: данные из файла; время: %2'"),
				РезультатВыполнения.ИмяМетода, ТекущаяДата());
			ОбработатьИнформационноеСообщение(ВидОперации, ТекстСообщения, , ДополнительныеПараметры.Организация, Ложь);
			РезультатВыполненияЗапроса = СтруктураОтветаРезультатаЗапроса();
			РезультатВыполненияЗапроса.Вставить("Выполнено",       Истина);
			РезультатВыполненияЗапроса.Вставить("ФайлПолучен",     Истина);
			РезультатВыполненияЗапроса.Вставить("ИмяМетода",       РезультатВыполнения.ИмяМетода);
			РезультатВыполненияЗапроса.Вставить("АдресРезультата", ДополнительныеПараметры.АдресРезультата);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполненияЗапроса);
		ИначеЕсли РезультатВыполнения.Свойство("ОбработкаНеТребуется") Тогда
			ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Выполнения метода: %1'"),
				ДополнительныеПараметры.ОписаниеМетода.ИмяМетода);
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Имя метода: %1; обработка: не требуется; время: %2'"),
				РезультатВыполнения.ИмяМетода, ТекущаяДата());
			ОбработатьИнформационноеСообщение(ВидОперации, ТекстСообщения, , ДополнительныеПараметры.Организация, Ложь);
			РезультатВыполненияЗапроса = СтруктураОтветаРезультатаЗапроса();
			РезультатВыполненияЗапроса.Вставить("Выполнено",       Истина);
			РезультатВыполненияЗапроса.Вставить("ФайлПолучен",     Ложь);
			РезультатВыполненияЗапроса.Вставить("ИмяМетода",       РезультатВыполнения.ИмяМетода);
			РезультатВыполненияЗапроса.Вставить("АдресРезультата", ДополнительныеПараметры.АдресРезультата);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполненияЗапроса);
		КонецЕсли;
		
	Иначе // Ошибка
		ВидОперации = СтрШаблон(НСтр("ru = 'Запрос к сервису ЛК ЕНС. Ошибка выполнения метода: %1'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода);
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

Процедура ЗагрузитьДанныеЕдиногоНалоговогоСчета(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыЗапроса = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ПараметрыЗапроса.Вставить("ОповещениеПослеВыполненияЗадания");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ПараметрыПолученияДанных);
	ПриступитьКЗагрузкеДанныхИзФайлаОтветаСервисаЕНС(ПараметрыЗапроса)
	
КонецПроцедуры

Процедура ПриступитьКЗагрузкеДанныхИзФайлаОтветаСервисаЕНС(Параметры)
	
	ПараметрыВыполнения = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	Параметры.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("АдресРезультата", АдресРезультата);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияЗагрузкаДанныхИзФайлаОтветаСервисаЕНС(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеЗагрузкиДанныхИзФайлаОтветаСервисаЕНС = Новый ОписаниеОповещения(
		"ПослеЗагрузкиДанныхИзФайлаОтветаСервисаЕНС", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеЗагрузкиДанныхИзФайлаОтветаСервисаЕНС, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеЗагрузкиДанныхИзФайлаОтветаСервисаЕНС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		
		РезультатЗагрузки = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресРезультата);
		Если Не РезультатЗагрузки.Ошибка Тогда
			РезультатВыполнения = СтруктураОтветаРезультатаЗапроса();
			РезультатВыполнения.Вставить("Выполнено",            Истина);
			РезультатВыполнения.Вставить("ОбновитьСправочники",  РезультатЗагрузки.ОбновитьСправочники);
			РезультатВыполнения.Вставить("ПрекратитьОбновление", РезультатЗагрузки.ПрекратитьОбновление);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, РезультатВыполнения);
		Иначе
			ВидОперации = СтрШаблон(НСтр("ru = 'Загрузка данных из файла-ответа сервиса ЛК ЕНС. Ошибка выполнения метода: %1
			|Формат файла не поддерживается'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода);
			ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
				ДополнительныеПараметры.Организация);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
		КонецЕсли;
		
	Иначе // Ошибка
		ВидОперации = СтрШаблон(НСтр("ru = 'Загрузка данных из файла-ответа сервиса ЛК ЕНС. Ошибка выполнения метода: %1'"), ДополнительныеПараметры.ОписаниеМетода.ИмяМетода);
		ОбработатьИнформационноеСообщение(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			ДополнительныеПараметры.Организация);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыполненияЗадания, Новый Структура("Выполнено", Ложь));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПолучениеСправочников

Процедура ПолучитьДанныеСправочников(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыЗапроса = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ПараметрыЗапроса.Вставить("ОповещениеПослеВыполненияЗадания");
	ПараметрыЗапроса.Вставить("ИспользоватьОтбор");
	ПараметрыЗапроса.Вставить("ОповещениеПрерывания");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ПараметрыПолученияДанных);
	ОтправитьЗапросНаПолучениеСправочников(ПараметрыЗапроса)
	
КонецПроцедуры

Процедура ОтправитьЗапросНаПолучениеСправочников(Параметры)
	
	ПараметрыВыполнения = ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.СтруктураПараметровВыполненияЗапроса();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор());
	Параметры.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыполнения.Вставить("АдресРезультата", АдресРезультата);
	
	РезультатВыполнения = ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ЗапускЗаданияОтправкиЗапросаНаПолучениеСправочников(ПараметрыВыполнения);
	
	ПараметрыОжидания = ПолучитьПараметрыОжидания(Параметры);
	
	ПослеПолученияОтветаНаЗапросОтСервисаЕНС = Новый ОписаниеОповещения(
		"ПослеПолученияОтветаНаЗапросОтСервисаЕНС", ЭтотОбъект, Параметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения, ПослеПолученияОтветаНаЗапросОтСервисаЕНС, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти


#Область ДляЗаполненияЗаявлений

Процедура СоздатьСогласиеНаРаскрытиеНалоговойТайны(Форма) Экспорт
	
	ПараметрыУведомления = Новый Структура;
	ПараметрыУведомления.Вставить("Организация",    Форма.Объект.Организация);
	ПараметрыУведомления.Вставить("ВидУведомления", ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны"));
	ПараметрыУведомления.Вставить("Данные",         Новый Структура("ДанныеПомощника", ДанныеСогласияНаРаскрытиеНалоговойТайны(Форма.Объект.Организация)));
	ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.ФормаОбъекта",
		ПараметрыУведомления,
		Форма.ЭтотОбъект,
		Форма.УникальныйИдентификатор);
	
КонецПроцедуры

Функция ДанныеСогласияНаРаскрытиеНалоговойТайны(Организация) Экспорт
	
	// Титульный
	ДанныеТитульногоЛиста = Новый Структура;
	ДанныеТитульногоЛиста.Вставить("ПризДок",       "1");
	ДанныеТитульногоЛиста.Вставить("ПризРаскрСвед", "2");
	ДанныеТитульногоЛиста.Вставить("ДатаНачПер",    "2022");
	ДанныеТитульногоЛиста.Вставить("ДатаНачСогл",   ТекущаяДата());
	
	// Лист002
	ДанныеЛиста02 = Новый Структура;
	ДанныеЛиста02.Вставить("ИННЮЛ",    "7729510210");
	ДанныеЛиста02.Вставить("НаимОрг",  "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ""НАУЧНО-ПРОИЗВОДСТВЕННЫЙ ЦЕНТР ""1С""");
	ДанныеЛиста02.Вставить("КодКомпл", "21001");
	
	ПараметрыЗаявления = Новый Структура;
	ПараметрыЗаявления.Вставить("Организация", Организация);
	ПараметрыЗаявления.Вставить("Титульная",   ДанныеТитульногоЛиста);
	ПараметрыЗаявления.Вставить("Лист002",     ДанныеЛиста02);
	
	Возврат ПараметрыЗаявления;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыОжидания(Параметры)
	
	Если Параметры.Свойство("ФормаВладелец")
		И ТипЗнч(Параметры.ФормаВладелец) = Тип("ФормаКлиентскогоПриложения") Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Параметры.ФормаВладелец);
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	КонецЕсли;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Возврат ПараметрыОжидания;
	
КонецФункции

Функция СтруктураОтветаРезультатаЗапроса()
	
	РезультатВыполненияЗапроса = Новый Структура;
	РезультатВыполненияЗапроса.Вставить("Выполнено",                 Ложь);
	РезультатВыполненияЗапроса.Вставить("ФайлПолучен",               Ложь);
	РезультатВыполненияЗапроса.Вставить("ИмяМетода",                 "");
	РезультатВыполненияЗапроса.Вставить("АдресРезультата",           "");
	РезультатВыполненияЗапроса.Вставить("ОбновитьСправочники",       Ложь);
	РезультатВыполненияЗапроса.Вставить("ПрекратитьОбновление",      Ложь);
	РезультатВыполненияЗапроса.Вставить("ТребуетсяАвторизацияПоКЭП", Ложь);
	РезультатВыполненияЗапроса.Вставить("РезультатАвторизации",      Неопределено);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

Процедура ОбработатьИнформационноеСообщение(ВидОперации, Знач ПодробныйТекстСообщения, Знач ТекстСообщения = "",
		СсылкаНаОбъект = Неопределено, ЭтоОшибка = Истина) Экспорт
	
	Если ЗначениеЗаполнено(ПодробныйТекстСообщения) Тогда
		ПодробныйТекстСообщения = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(ПодробныйТекстСообщения);
	Иначе
		ПодробныйТекстСообщения = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(ТекстСообщения);
	Иначе
		ТекстСообщения = "";
	КонецЕсли;
	
	Если ЭтоОшибка И ДеталиОшибкиВыведены(ТекстСообщения) Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ОбработатьИнформационноеСообщение(ВидОперации,
		"ЕдиныйНалоговыйСчетИнтеграция", ПодробныйТекстСообщения, ТекстСообщения, СсылкаНаОбъект, ЭтоОшибка);
	
КонецПроцедуры

Функция ДеталиОшибкиВыведены(ПодробноеПредставлениеОшибки)
	
	Результат = СтрЗаканчиваетсяНа(ПодробноеПредставлениеОшибки,
		ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.ТекстСлужебногоМаркераВЖР());
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
