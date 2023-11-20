#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипСведений = Перечисления.ТипыСведенийСЗВ_КОРР.Отменяющая Тогда
		Если Не ПерсонифицированныйУчетКлиентСервер.ЭтоФормаЕФС1(Год(КорректируемыйПериод)) Тогда 
			ЗаписиОСтаже.Очистить();
		КонецЕсли;
		СведенияОЗаработке.Очистить();
		СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Очистить();
		КорректирующиеСведения.Очистить();
		СведенияОбУплаченныхВзносах.Очистить();
	КонецЕсли;	
	
	Если ТипСведений <> Перечисления.ТипыСведенийСЗВ_КОРР.Особая Тогда 
		НачисленныеУплаченныеВзносы.Очистить();
		УплаченныеВзносыРасшифровка.Очистить();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяФайлаДляПФР) Тогда
		ИмяФайлаДляПФР = Документы.ДанныеОКорректировкеСведенийЗастрахованныхЛицСЗВ_КОРР.ИмяФайла(Организация, Дата, , Год(КорректируемыйПериод));
	Иначе		
		УИДИзИмениФайла = Прав(ИмяФайлаДляПФР, 36);
		Если Не СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(УИДИзИмениФайла) Тогда
			УИДИзИмениФайла = Строка(Новый УникальныйИдентификатор);	
		КонецЕсли;	
		ИмяФайлаДляПФР = Документы.ДанныеОКорректировкеСведенийЗастрахованныхЛицСЗВ_КОРР.ИмяФайла(Организация, Дата, УИДИзИмениФайла, Год(КорректируемыйПериод));
	КонецЕсли;
	
	АктуальныйФорматФайла = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ УчетСтраховыхВзносов.ОрганизацияОтчитываетсяПоВзносамСамостоятельно(Организация, ОтчетныйПериод) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Организация не отчитывается самостоятельно'"), ЭтотОбъект, , , Отказ);
	КонецЕсли;
	
	ОкончаниеПериода = КонецДня(ОкончаниеКорректируемогоПериода);
	
	Если ТипСведений <> Перечисления.ТипыСведенийСЗВ_КОРР.Отменяющая Тогда 
		ПерсонифицированныйУчет.ПроверитьДанныеСотрудников(Сотрудники, КорректируемыйПериод, ОкончаниеПериода, ЗаписиОСтаже, Отказ);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеПроверятьДанныеОрганизации") Тогда
		
		ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);
		
		Если Не ЗначениеЗаполнено(РегистрационныйНомерПФРвКорректируемыйПериод) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен регистрационный номер ПФР в корректируемый период.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.РегистрационныйНомерПФРвКорректируемыйПериод", , Отказ);
		ИначеЕсли Не ПерсонифицированныйУчет.ПроверитьРегистрационныйНомерПФР(РегистрационныйНомерПФРвКорректируемыйПериод) Тогда
			ТекстСообщения = НСтр("ru = 'Неверно заполнен регистрационный номер ПФР в корректируемый период.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.РегистрационныйНомерПФРвКорректируемыйПериод", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ИННвКорректируемыйПериод) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнен ИНН в корректируемый период'"), , "Объект.ИННвКорректируемыйПериод", ,Отказ);
		ИначеЕсли Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИННвКорректируемыйПериод, ЗарплатаКадры.ЭтоЮридическоеЛицо(Организация), "") Или СтрЗаменить(ИННвКорректируемыйПериод, "0", "") = "" Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Неверно указан ИНН в корректируемый период'"), , "Объект.ИННвКорректируемыйПериод", ,Отказ);
		КонецЕсли;
		
		Если ЗарплатаКадры.ЭтоЮридическоеЛицо(Организация) Тогда
			Если Не ЗначениеЗаполнено(КППвКорректируемыйПериод) Тогда
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнен код по КПП в корректируемый период'"), , "Объект.КППвКорректируемыйПериод", ,Отказ);
			ИначеЕсли Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(КППвКорректируемыйПериод, "") Или СтрЗаменить(КППвКорректируемыйПериод, "0", "") = "" Тогда
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Неверно указан код по КПП в корректируемый период'"), , "Объект.КППвКорректируемыйПериод", ,Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КорректируемыйПериод) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан корректируемый отчетный период.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.КорректируемыйПериод", , Отказ);
	ИначеЕсли ОтчетныйПериод < КорректируемыйПериод Тогда
		ТекстСообщения = НСтр("ru = 'Корректируемый период не может быть позже отчетного.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.КорректируемыйПериод", , Отказ);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	АктуальныйФорматФайла = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТСТаблицамиОбъекта(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("ЗаписиОСтаже", ЗаписиОСтаже);
	Запрос.УстановитьПараметр("СведенияОЗаработке", СведенияОЗаработке);
	Запрос.УстановитьПараметр("СведенияОЗаработкеНаВредныхИТяжелыхРаботах", СведенияОЗаработкеНаВредныхИТяжелыхРаботах);
	Запрос.УстановитьПараметр("КорректирующиеСведения", КорректирующиеСведения);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сотрудники.НомерСтроки,
	|	Сотрудники.Сотрудник,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.СтраховойНомерПФР
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&Сотрудники КАК Сотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Ссылка,
	|	ЗаписиОСтаже.НомерСтроки,
	|	ЗаписиОСтаже.Сотрудник,
	|	ЗаписиОСтаже.НомерОсновнойЗаписи,
	|	ЗаписиОСтаже.НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.КодПозицииСписка,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТретийПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТерриториальныеУсловия,
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий
	|ПОМЕСТИТЬ ВТТаблицаСтажа
	|ИЗ
	|	&ЗаписиОСтаже КАК ЗаписиОСтаже
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиОСтаже.Сотрудник,
	|	ЗаписиОСтаже.НомерСтроки,
	|	ЗаписиОСтаже.НомерОсновнойЗаписи,
	|	ЗаписиОСтаже.НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗаписиОСтаже.ТерриториальныеУсловия,
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.КодПозицииСписка,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТретийПараметрВыслугиЛет,
	|	СотрудникиНомераСтрок.НомерСтроки КАК НомерСтрокиСотрудник
	|ПОМЕСТИТЬ ВТЗаписиОСтаже
	|ИЗ
	|	ВТТаблицаСтажа КАК ЗаписиОСтаже
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудники КАК СотрудникиНомераСтрок
	|		ПО ЗаписиОСтаже.Сотрудник = СотрудникиНомераСтрок.Сотрудник";
	
	Запрос.Выполнить();
	
КонецПроцедуры	

Функция СформироватьЗапросПоСотрудникамДляПроверкиЗаполнения(МенеджерВременныхТаблиц)
	
	ПериодДанных = КорректируемыйПериод;
		
	НеоплачиваемыеЗначенияТретьегоПараметра = Новый Массив;
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.АДМИНИСТР);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ДЕТИ);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.УЧОТПУСК);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ДЛДЕТИ);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ДЛОТПУСК);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ВРНЕТРУД);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ДЕКРЕТ);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ЧАЭС);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.НЕОПЛ);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.НЕОПЛДОГ);
    НеоплачиваемыеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.НЕОПЛАВТ);
	
	ИсключительныеОснованияВыслугиЛет = Новый Массив;
	ИсключительныеОснованияВыслугиЛет.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_11ВП);
	ИсключительныеОснованияВыслугиЛет.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_11ГР);
	ИсключительныеОснованияВыслугиЛет.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_14);
	
	ИсключительныеЗначенияТретьегоПараметра = Новый Массив;
	ИсключительныеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ВРНЕТРУД);
	ИсключительныеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ДЕКРЕТ);
	ИсключительныеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ДЛОТПУСК);
	ИсключительныеЗначенияТретьегоПараметра.Добавить(Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.ВАХТА);
	
	ПрочиеПроверяемыеКоды = Новый Массив;
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_2);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_3);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_4);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_5);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_6);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_7);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_8);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_9);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_10);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_ОС);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОсобыеУсловияТрудаПФР.Ст27_ПЖ);
	
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_11ВП);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_11ГР);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_12);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_СП);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.САМОЛЕТ);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.СПЕЦАВ);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.СПАСАВ);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.УЧЛЕТ);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.ВЫСШПИЛ);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.НОРМАПР);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.НОРМСП);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.РЕАКТИВН);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.ЛЕТРАБ);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_14);
	ПрочиеПроверяемыеКоды.Добавить(Справочники.ОснованияДосрочногоНазначенияПенсии.Ст27_15);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ПериодДанных", ПериодДанных);
	Запрос.УстановитьПараметр("Ст27_1", Справочники.ОсобыеУсловияТрудаПФР.Ст27_1);
	Запрос.УстановитьПараметр("Ст27_2", Справочники.ОсобыеУсловияТрудаПФР.Ст27_2);
	Запрос.УстановитьПараметр("КодПозицииСпискаСт27_2", Справочники.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.НайтиПоКоду("23307000-17541"));
	Запрос.УстановитьПараметр("НеоплачиваемыеЗначенияТретьегоПараметра", НеоплачиваемыеЗначенияТретьегоПараметра);
	Запрос.УстановитьПараметр("ИсключительныеЗначенияТретьегоПараметра", ИсключительныеЗначенияТретьегоПараметра);
	Запрос.УстановитьПараметр("ИсключительныеОснованияВыслугиЛет", ИсключительныеОснованияВыслугиЛет);
	Запрос.УстановитьПараметр("ПрочиеПроверяемыеКоды", ПрочиеПроверяемыеКоды);
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, ОтчетныйПериод, ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТСотрудники.Сотрудник,
	|	МИНИМУМ(ВТСотрудники.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудникиНомераСтрок
	|ИЗ
	|	ВТСотрудники КАК ВТСотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСотрудники.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЗаписиОСтаже.НомерОсновнойЗаписи) КАК КоличествоЗаписей,
	|	СУММА(ВЫБОР
	|			КОГДА ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа ЕСТЬ NULL
	|				ТОГДА 0
	|			КОГДА ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&НеоплачиваемыеЗначенияТретьегоПараметра)
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК КоличествоОплачиваемыхСтрок,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) = МЕСЯЦ(&ПериодДанных)
	|					И ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_1
	|					И НЕ(ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|					И НЕ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ИсключительныеОснованияВыслугиЛет)
	|					И НЕ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК Ст27_1ВПервомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) = МЕСЯЦ(&ПериодДанных)
	|					И ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_1
	|					И (ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ИсключительныеОснованияВыслугиЛет)
	|						ИЛИ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|						ИЛИ ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеПроверятьСт27_1ВПервомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) = МЕСЯЦ(&ПериодДанных)
	|					И ОсновныеЗаписиОстаже.ОсобыеУсловияТруда <> &Ст27_1
	|					И НЕ(ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|					И (ЗаписиОСтаже.ОсобыеУсловияТруда В (&ПрочиеПроверяемыеКоды)
	|						ИЛИ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ПрочиеПроверяемыеКоды))
	|					И НЕ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ОстальныеКодыВПервомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) = МЕСЯЦ(&ПериодДанных)
	|					И ОсновныеЗаписиОстаже.ОсобыеУсловияТруда <> &Ст27_1
	|					И (ЗаписиОСтаже.ОсобыеУсловияТруда В (&ПрочиеПроверяемыеКоды)
	|						ИЛИ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ПрочиеПроверяемыеКоды))
	|					И (ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|						ИЛИ ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеПроверятьОстальныеКодыВПервомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) <= МЕСЯЦ(&ПериодДанных) + 1
	|					И МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) >= МЕСЯЦ(&ПериодДанных) + 1
	|					И ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_1
	|					И НЕ(ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|					И НЕ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ИсключительныеОснованияВыслугиЛет)
	|					И НЕ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК Ст27_1ВоВторомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) <= МЕСЯЦ(&ПериодДанных) + 1
	|					И МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) >= МЕСЯЦ(&ПериодДанных) + 1
	|					И ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_1
	|					И (ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ИсключительныеОснованияВыслугиЛет)
	|						ИЛИ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|						ИЛИ ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеПроверятьСт27_1ВоВторомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) <= МЕСЯЦ(&ПериодДанных) + 1
	|					И МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) >= МЕСЯЦ(&ПериодДанных) + 1
	|					И ОсновныеЗаписиОстаже.ОсобыеУсловияТруда <> &Ст27_1
	|					И НЕ(ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|					И (ЗаписиОСтаже.ОсобыеУсловияТруда В (&ПрочиеПроверяемыеКоды)
	|						ИЛИ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ПрочиеПроверяемыеКоды))
	|					И НЕ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ОстальныеКодыВоВторомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаНачалаПериода) <= МЕСЯЦ(&ПериодДанных) + 1
	|					И МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) >= МЕСЯЦ(&ПериодДанных) + 1
	|					И ОсновныеЗаписиОстаже.ОсобыеУсловияТруда <> &Ст27_1
	|					И (ЗаписиОСтаже.ОсобыеУсловияТруда В (&ПрочиеПроверяемыеКоды)
	|						ИЛИ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ПрочиеПроверяемыеКоды))
	|					И (ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|						ИЛИ ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеПроверятьОстальныеКодыВоВторомМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) = МЕСЯЦ(&ПериодДанных) + 2
	|					И ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_1
	|					И НЕ(ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|					И НЕ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ИсключительныеОснованияВыслугиЛет)
	|					И НЕ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК Ст27_1ВТретьемМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) = МЕСЯЦ(&ПериодДанных) + 2
	|					И ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_1
	|					И (ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ИсключительныеОснованияВыслугиЛет)
	|						ИЛИ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|						ИЛИ ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеПроверятьСт27_1ВТретьемМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) = МЕСЯЦ(&ПериодДанных) + 2
	|					И ОсновныеЗаписиОстаже.ОсобыеУсловияТруда <> &Ст27_1
	|					И НЕ(ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|					И (ЗаписиОСтаже.ОсобыеУсловияТруда В (&ПрочиеПроверяемыеКоды)
	|						ИЛИ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ПрочиеПроверяемыеКоды))
	|					И НЕ ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ОстальныеКодыВТретьемМесяце,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА МЕСЯЦ(ОсновныеЗаписиОстаже.ДатаОкончанияПериода) = МЕСЯЦ(&ПериодДанных) + 2
	|					И ОсновныеЗаписиОстаже.ОсобыеУсловияТруда <> &Ст27_1
	|					И (ЗаписиОСтаже.ОсобыеУсловияТруда В (&ПрочиеПроверяемыеКоды)
	|						ИЛИ ЗаписиОСтаже.ОснованиеВыслугиЛет В (&ПрочиеПроверяемыеКоды))
	|					И (ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа В (&ИсключительныеЗначенияТретьегоПараметра)
	|						ИЛИ ЗаписиОСтаже.ОсобыеУсловияТруда = &Ст27_2
	|							И ЗаписиОСтаже.КодПозицииСписка = &КодПозицииСпискаСт27_2)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеПроверятьОстальныеКодыВТретьемМесяце,
	|	ЗаписиОСтаже.Сотрудник
	|ПОМЕСТИТЬ ВТПараметрыСтажа
	|ИЗ
	|	ВТЗаписиОСтаже КАК ЗаписиОСтаже
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаписиОСтаже КАК ОсновныеЗаписиОстаже
	|		ПО ЗаписиОСтаже.Сотрудник = ОсновныеЗаписиОстаже.Сотрудник
	|			И ЗаписиОСтаже.НомерОсновнойЗаписи = ОсновныеЗаписиОстаже.НомерОсновнойЗаписи
	|			И (ОсновныеЗаписиОстаже.НомерДополнительнойЗаписи = 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиОСтаже.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК КонфликтующаяСтрока,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	МИНИМУМ(ДублиСтрокСтраховыеНомера.НомерСтроки) КАК КонфликтующаяСтрокаСтраховойНомер
	|ПОМЕСТИТЬ ВТСотрудникиДокумента
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|			И СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрокСтраховыеНомера
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрокСтраховыеНомера.НомерСтроки
	|			И СотрудникиДокумента.СтраховойНомерПФР = ДублиСтрокСтраховыеНомера.СтраховойНомерПФР
	|			И СотрудникиДокумента.Сотрудник <> ДублиСтрокСтраховыеНомера.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.СотрудникНаименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	СотрудникиДокумента.СотрудникРаботаетВОрганизации,
	|	СотрудникиДокумента.КонфликтующаяСтрока,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.КонфликтующаяСтрокаСтраховойНомер,
	|	"""" КАК АдресДляИнформирования,
	|	ЕСТЬNULL(ПараметрыСтажа.КоличествоЗаписей, 0) КАК КоличествоЗаписей,
	|	ЕСТЬNULL(ПараметрыСтажа.КоличествоОплачиваемыхСтрок, 0) КАК КоличествоОплачиваемыхСтрок,
	|	ЕСТЬNULL(ПараметрыСтажа.Ст27_1ВПервомМесяце, ЛОЖЬ) КАК Ст27_1ВПервомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.НеПроверятьСт27_1ВПервомМесяце, ЛОЖЬ) КАК НеПроверятьСт27_1ВПервомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.ОстальныеКодыВПервомМесяце, ЛОЖЬ) КАК ОстальныеКодыВПервомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.НеПроверятьОстальныеКодыВПервомМесяце, ЛОЖЬ) КАК НеПроверятьОстальныеКодыВПервомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.Ст27_1ВоВторомМесяце, ЛОЖЬ) КАК Ст27_1ВоВторомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.НеПроверятьСт27_1ВоВторомМесяце, ЛОЖЬ) КАК НеПроверятьСт27_1ВоВторомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.ОстальныеКодыВоВторомМесяце, ЛОЖЬ) КАК ОстальныеКодыВоВторомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.НеПроверятьОстальныеКодыВоВторомМесяце, ЛОЖЬ) КАК НеПроверятьОстальныеКодыВоВторомМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.Ст27_1ВТретьемМесяце, ЛОЖЬ) КАК Ст27_1ВТретьемМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.НеПроверятьСт27_1ВТретьемМесяце, ЛОЖЬ) КАК НеПроверятьСт27_1ВТретьемМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.ОстальныеКодыВТретьемМесяце, ЛОЖЬ) КАК ОстальныеКодыВТретьемМесяце,
	|	ЕСТЬNULL(ПараметрыСтажа.НеПроверятьОстальныеКодыВТретьемМесяце, ЛОЖЬ) КАК НеПроверятьОстальныеКодыВТретьемМесяце
	|ИЗ
	|	ВТСотрудникиДокумента КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПараметрыСтажа КАК ПараметрыСтажа
	|		ПО СотрудникиДокумента.Сотрудник = ПараметрыСтажа.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиСотрудник";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ = Ложь) Экспорт 
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	Ошибки = Новый Массив;
	
	ПроверитьДанныеШапкиДокумента(Ошибки, Отказ);
	
	ЗапросПоСтрокамДокумента = Неопределено;
	
	ПравилаПроверкиДанныхЗЛ = ПерсонифицированныйУчет.ДокументыСЗВПравилаПроверкиДанныхЗЛ(Ложь);
	
	ПроверяемыйПериод = КорректируемыйПериод;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТСТаблицамиОбъекта(МенеджерВременныхТаблиц);
	
	ВыборкаПоСтрокамДокумента = СформироватьЗапросПоСотрудникамДляПроверкиЗаполнения(МенеджерВременныхТаблиц).Выбрать();

	Пока ВыборкаПоСтрокамДокумента.СледующийПоЗначениюПоля("НомерСтрокиСотрудник") Цикл
		
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда 
			
			Если ВыборкаПоСтрокамДокумента.КонфликтующаяСтрока <> Null Тогда  
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %1 была введена в документе ранее.'"), ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				
				ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияСпискаСотрудников(
					Ошибки, 
					Ссылка, 
					ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник,
					ТекстОшибки,
					"Сотрудник",
					Отказ);
																							
			ИначеЕсли ВыборкаПоСтрокамДокумента.КонфликтующаяСтрокаСтраховойНомер <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: информация о сотруднике с таким же страховым номером была введена в документе ранее.'"), ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				
				ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияСпискаСотрудников(
					Ошибки, 
					Ссылка, 
					ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник,
					ТекстОшибки,
					"СтраховойНомерПФР",
					Отказ);
			КонецЕсли;	
			
			ДанныеЗастрахованногоЛица = ПерсонифицированныйУчет.ДокументыСЗВДанныеЗастрахованногоЛица(ВыборкаПоСтрокамДокумента);
			
			ПерсонифицированныйУчет.ПроверитьДанныеЗастрахованногоЛица(
				ДанныеЗастрахованногоЛица, 
				ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник, 
				ПравилаПроверкиДанныхЗЛ, 
				Ошибки, 
				Ссылка,
				Отказ);
				
		КонецЕсли;
		
	КонецЦикла;	
	
	Если КорректируемыйПериод >= '20140101' Тогда 
		ПроверяемыйПериод = КорректируемыйПериод;
		ПерсонифицированныйУчет.ПроверитьЗаписиОСтаже(МенеджерВременныхТаблиц, Ссылка, ПроверяемыйПериод, Отказ, Ложь, Истина, Истина, КонецДня(ОкончаниеКорректируемогоПериода));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДанныеШапкиДокумента(Ошибки, Отказ = Ложь)
	
	Если Не ЗначениеЗаполнено(Руководитель) Тогда
		ТекстОшибки = НСтр("ru = 'Не указан руководитель.'");
		ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстОшибки, , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДолжностьРуководителя) Тогда
		ТекстОшибки = НСтр("ru = 'Не указана должность руководителя.'");
		ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстОшибки, , Отказ);
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли