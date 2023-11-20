#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ВладелецКалендаря = ДанныеЗаполнения;
		Пользователь = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(ВладелецКалендаря);
		Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Наименование");
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ДозаполнитьПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// АПК:75-выкл ключевые поля должны заполняться в режиме ОбменДанными.Загрузка
	ЗаполнитьКлюч();
	
	ДополнительныеСвойства.Вставить("ИзмененаОтметкаСинхронизироватьСGoogle", Ложь);
	ДополнительныеСвойства.Вставить("ИзмененаОтметкаСинхронизироватьСDAV", Ложь);
	ДополнительныеСвойства.Вставить("ИзмененоНаименованиеКалендаряСотрудника", Ложь);

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	// АПК:75-вкл
	
	Если Не ЭтотОбъект.ЭтоНовый() Тогда
		НастройкаСинхронизации = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.НайтиПоКалендарюСотрудника(ЭтотОбъект.Ссылка);
		Если НастройкаСинхронизации <> Неопределено И Не ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("ВнешнийКалендарь", НастройкаСинхронизации);
			ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСDAV = НастройкаСинхронизации.Статус <> ДополнительныеСвойства.СинхронизацияСВнешнимиКалендарем;
		КонецЕсли;
		
	КонецЕсли;
	
	КоличествоЭлементовКоллекции = Доступ.Количество();
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		Если Доступ[Индекс].Сотрудник = ВладелецКалендаря Тогда
			Доступ.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Если ПометкаУдаления Тогда
		СинхронизироватьСGoogle = Ложь;
		ДополнительныеСвойства.Удалить("ВнешнийКалендарь");
		ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСDAV = Истина;
		Если НастройкаСинхронизации <> Неопределено Тогда
			МенеджерЗаписи = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.УчетнаяЗаписьВнешнегоКалендаря = НастройкаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря;
			МенеджерЗаписи.КодВнешнегоКалендаря = НастройкаСинхронизации.КодВнешнегоКалендаря;
			МенеджерЗаписи.Прочитать();
			Если МенеджерЗаписи.Выбран() Тогда
				МенеджерЗаписи.Статус = Ложь;
				МенеджерЗаписи.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСGoogle = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СинхронизироватьСGoogle") <> СинхронизироватьСGoogle;
	
	Если ДополнительныеСвойства.Свойство("ВнешнийКалендарь")
		И (Не ДополнительныеСвойства.Свойство("ИзмененоНаименованиеВнешнегоКалендаря")
		ИЛИ Не ДополнительныеСвойства.ИзмененоНаименованиеВнешнегоКалендаря) Тогда
		
		ДополнительныеСвойства.ИзмененоНаименованиеКалендаряСотрудника = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Наименование") <> Наименование;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.КолонкиКалендарейСотрудников.ПроверитьСоздатьПервуюКолонкуКалендаря(Ссылка);
	
	ОбновитьНастройкиСинхронизацииСВнешнимиКалендарями();
	Если ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСGoogle
		ИЛИ ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСDAV
		Тогда
		
		Если СинхронизироватьСGoogle Тогда
			ДобавитьАктуальныеЗаписиВОчередьНаОтправкуВGoogle();
		Иначе
			ОчиститьОчередьНаОтправкуВGoogle();
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("СинхронизацияСВнешнимиКалендарем")
			И ДополнительныеСвойства.Свойство("ВнешнийСервисНовый")
			И ДополнительныеСвойства.Свойство("ВнешнийСервисПодключенный")
			И ДополнительныеСвойства.СинхронизацияСВнешнимиКалендарем
			И ДополнительныеСвойства.ВнешнийСервисНовый <> "Google"
			И ДополнительныеСвойства.ВнешнийСервисПодключенный <> "Google"
			Тогда
			ДобавитьАктуальныеЗаписиВОчередьНаОтправкуВВнешнийСервис();
		Иначе
			ОчиститьОчередьНаОтправкуВВнешнийСервис(Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.ИзмененоНаименованиеКалендаряСотрудника Тогда
		ДобавитьЗаписьКалендаряВВнешнийСервис();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДозаполнитьПоУмолчанию()
	
	Если Не ЗначениеЗаполнено(ВладелецКалендаря) Тогда
		
		СотрудникиПользователя = РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя();
		
		Если СотрудникиПользователя.Количество() > 0 Тогда
			ВладелецКалендаря = СотрудникиПользователя[0];
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКлюч()
	
	Если ЗначениеЗаполнено(id) Тогда
		key = ОбменСGoogle.КлючИзИдентификатора(
		id,
		ТипЗнч(ЭтотОбъект));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		СсылкаНаОбъект = Ссылка;
	Иначе
		СсылкаНаОбъект = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			СсылкаНаОбъект = Справочники.КалендариСотрудников.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНаОбъект);
		КонецЕсли;
	КонецЕсли;
	
	key = ОбменСGoogle.КлючИзИдентификатора(
	СтрЗаменить(СсылкаНаОбъект.УникальныйИдентификатор(), "-", ""),
	ТипЗнч(ЭтотОбъект));
	
КонецПроцедуры

Процедура ДобавитьАктуальныеЗаписиВОчередьНаОтправкуВGoogle()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаписиКалендаряСотрудника.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаряСотрудника
	|ГДЕ
	|	ЗаписиКалендаряСотрудника.Календарь = &Календарь
	|	И НЕ ЗаписиКалендаряСотрудника.ПометкаУдаления
	|	И ЗаписиКалендаряСотрудника.Начало >= &Период
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачаСотрудника.Ссылка
	|ИЗ
	|	Документ.ЗадачаСотрудника КАК ЗадачаСотрудника
	|ГДЕ
	|	ЗадачаСотрудника.Календарь = &Календарь
	|	И НЕ ЗадачаСотрудника.ПометкаУдаления
	|	И ЗадачаСотрудника.ДатаНачала >= &Период");
	
	Запрос.УстановитьПараметр("Календарь", Ссылка);
	Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДатаСеанса()));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	УзелДляКалендаряGoogle = ПланыОбмена.ОбменСGoogleCalendar.УзелДляКалендаряGoogle(Ссылка);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзелДляКалендаряGoogle, Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьОчередьНаОтправкуВGoogle()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбменСGoogleCalendar.Ссылка
	|ИЗ
	|	ПланОбмена.ОбменСGoogleCalendar КАК ОбменСGoogleCalendar
	|ГДЕ
	|	НЕ ОбменСGoogleCalendar.ЭтотУзел
	|	И ОбменСGoogleCalendar.КалендарьСотрудника = &КалендарьСотрудника");
	Запрос.УстановитьПараметр("КалендарьСотрудника", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.Ссылка);
	
КонецПроцедуры

Процедура ДобавитьАктуальныеЗаписиВОчередьНаОтправкуВВнешнийСервис()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
	|	ЗаписиКалендаряСотрудника.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВсеИзменения
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаряСотрудника
	|ГДЕ
	|	ЗаписиКалендаряСотрудника.Календарь = &Календарь
	|	И НЕ ЗаписиКалендаряСотрудника.ПометкаУдаления
	|	И ЗаписиКалендаряСотрудника.Начало >= &ДатаНачала
	|	И ЗаписиКалендаряСотрудника.Окончание <= &ДатаОкончания
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачаСотрудника.Ссылка
	|ИЗ
	|	Документ.ЗадачаСотрудника КАК ЗадачаСотрудника
	|ГДЕ
	|	ЗадачаСотрудника.Календарь = &Календарь
	|	И НЕ ЗадачаСотрудника.ПометкаУдаления
	|	И ЗадачаСотрудника.ДатаНачала >= &ДатаНачала
	|	И ЗадачаСотрудника.ДатаОкончания <= &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеИзменения.Ссылка КАК Ссылка,
	|	ДанныеСобытийВнешнихКалендарей.ОтпечатокОбъекта
	|ИЗ
	|	ВсеИзменения КАК ВсеИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеСобытийВнешнихКалендарей КАК ДанныеСобытийВнешнихКалендарей
	|		ПО ВсеИзменения.Ссылка = ДанныеСобытийВнешнихКалендарей.Источник
	|ГДЕ
	|	ДанныеСобытийВнешнихКалендарей.ОтпечатокОбъекта = """"");
	Запрос.УстановитьПараметр("Календарь", Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ТекущаяДатаСеанса()) - 2592000);
	Запрос.УстановитьПараметр("ДатаОкончания", НачалоДня(ТекущаяДатаСеанса()) + 2592000);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	УзелДляКалендаряDAV = ПланыОбмена.ОбменСКалендарямиDAV.УзелДляВнешнегоКалендаря(Ссылка);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбменСВнешнимиКалендарями.ЗарегистрироватьСобытиеВНовыйПланОбмена(Выборка.Ссылка, ЭтотОбъект.ДополнительныеСвойства.ВнешнийКалендарь.КодВнешнегоКалендаря);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьОчередьНаОтправкуВВнешнийСервис(Календарь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаписиКалендаряСотрудникаИзменения.Узел КАК Узел,
	|	ЗаписиКалендаряСотрудникаИзменения.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника.Изменения КАК ЗаписиКалендаряСотрудникаИзменения
	|ГДЕ
	|	ЗаписиКалендаряСотрудникаИзменения.Узел <> &ЭтотУзел
	|	И ЗаписиКалендаряСотрудникаИзменения.Узел ССЫЛКА ПланОбмена.ОбменСКалендарямиDAV
	|	И ЗаписиКалендаряСотрудникаИзменения.Ссылка.Календарь = &Календарь
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачаСотрудникаИзменения.Узел,
	|	ЗадачаСотрудникаИзменения.Ссылка
	|ИЗ
	|	Документ.ЗадачаСотрудника.Изменения КАК ЗадачаСотрудникаИзменения
	|ГДЕ
	|	ЗадачаСотрудникаИзменения.Узел <> &ЭтотУзел
	|	И ЗадачаСотрудникаИзменения.Узел ССЫЛКА ПланОбмена.ОбменСКалендарямиDAV
	|	И ЗадачаСотрудникаИзменения.Ссылка.Календарь = &Календарь");
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменСКалендарямиDAV.ЭтотУзел());
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.Узел, Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЗаписьКалендаряВВнешнийСервис()
	
	УзелДляКалендаряDAV = ПланыОбмена.ОбменСКалендарямиDAV.УзелДляВнешнегоКалендаря(Ссылка);
	ПланыОбмена.ЗарегистрироватьИзменения(УзелДляКалендаряDAV, Ссылка);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаСинхронизации = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.НайтиПоКалендарюСотрудника(ЭтотОбъект.Ссылка);
	Если Не НастройкаСинхронизации = Неопределено Тогда
		МенеджерЗаписиНастройкаСинхронизации = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.СоздатьМенеджерЗаписи();
		МенеджерЗаписиНастройкаСинхронизации.КодВнешнегоКалендаря = НастройкаСинхронизации.КодВнешнегоКалендаря;
		МенеджерЗаписиНастройкаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря = НастройкаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря;
		МенеджерЗаписиНастройкаСинхронизации.Удалить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьНастройкиСинхронизацииСВнешнимиКалендарями()
	
	Если ДополнительныеСвойства.Свойство("ВнешнийСервисНовый") И ДополнительныеСвойства.Свойство("ВнешнийСервисПодключенный") Тогда
		Если ЗначениеЗаполнено(ДополнительныеСвойства.ВнешнийСервисНовый) Тогда // Новая синхронизация
			Если ДополнительныеСвойства.СинхронизацияСВнешнимиКалендарем Тогда
				Если ДополнительныеСвойства.ВнешнийСервисНовый <> "Google" Тогда
					УчетнаяЗаписьВнешнегоКалендаря = Справочники.УчетныеЗаписиВнешнихКалендарей.НайтиПоНаименованию(ДополнительныеСвойства.ВнешнийСервисНовый);
					ОбменСВнешнимиКалендарями.СоздатьНовыйКалендарьDAV(УчетнаяЗаписьВнешнегоКалендаря, ЭтотОбъект);
					НастройкаСинхронизации = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.НайтиПоКалендарюСотрудника(ЭтотОбъект.Ссылка);
					Если НастройкаСинхронизации <> Неопределено Тогда
						ДополнительныеСвойства.Вставить("ВнешнийКалендарь", НастройкаСинхронизации);
						ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСDAV = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(ДополнительныеСвойства.ВнешнийСервисПодключенный) Тогда // Изменение ранее настроенной синхронизации, обновление только статуса
			Если ДополнительныеСвойства.ВнешнийСервисПодключенный <> "Google" Тогда
				НастройкаСинхронизации = ДополнительныеСвойства.ВнешнийКалендарь;
				Если НастройкаСинхронизации <> Неопределено Тогда
					МенеджерЗаписи = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.СоздатьМенеджерЗаписи();
					МенеджерЗаписи.КодВнешнегоКалендаря = НастройкаСинхронизации.КодВнешнегоКалендаря;
					МенеджерЗаписи.УчетнаяЗаписьВнешнегоКалендаря = НастройкаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря;
					МенеджерЗаписи.Прочитать();
					Если МенеджерЗаписи.Статус <> ДополнительныеСвойства.СинхронизацияСВнешнимиКалендарем Тогда
						МенеджерЗаписи.Статус = ДополнительныеСвойства.СинхронизацияСВнешнимиКалендарем;
						МенеджерЗаписи.Записать();
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли