
#Область ПрограммныйИнтерфейс

Функция ДанныеРегистрации(Регистрация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = ШаблонДанныхОПредставителе();
	
	Если НЕ ЗначениеЗаполнено(Регистрация)
		ИЛИ ТипЗнч(Регистрация) <> Тип("СправочникСсылка.РегистрацииВНалоговомОргане") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	РегистрацияВИФНС.Ссылка КАК Ссылка,
			|	ЕСТЬNULL(ТЧПодписанты.ДокументПредставителя, РегистрацияВИФНС.ДокументПредставителя) КАК ДокументПредставителя,
			|	ЕСТЬNULL(ТЧПодписанты.Представитель, РегистрацияВИФНС.Представитель) КАК Представитель,
			|	ЕСТЬNULL(ТЧПодписанты.УполномоченноеЛицоПредставителя, РегистрацияВИФНС.УполномоченноеЛицоПредставителя) КАК УполномоченноеЛицоПредставителя,
			|	ЕСТЬNULL(ТЧПодписанты.Доверенность, РегистрацияВИФНС.Доверенность) КАК Доверенность,
			|	РегистрацияВИФНС.Код КАК Код,
			|	РегистрацияВИФНС.КПП КАК КПП,
			|	РегистрацияВИФНС.Наименование КАК Наименование
			|ИЗ
			|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацияВИФНС
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане.Подписанты КАК ТЧПодписанты
			|		ПО (ТЧПодписанты.Ссылка = РегистрацияВИФНС.Ссылка)
			|			И (ТЧПодписанты.Пользователь = &ТекущийПользователь)
			|ГДЕ
			|	РегистрацияВИФНС.Ссылка = &Регистрация");
		
	Запрос.УстановитьПараметр("Регистрация", Регистрация);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	Организация = Регистрация.Владелец;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		ОчиститьПредставителяДляРуководителяВМультирежиме(Регистрация, Результат);
		Результат.ЕстьДанные = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

Функция Доверенность(Регистрация) Экспорт
	
	Возврат ДанныеРегистрации(Регистрация).Доверенность;
	
КонецФункции

Функция ДокументПредставителя(Регистрация) Экспорт
	
	Возврат ДанныеРегистрации(Регистрация).ДокументПредставителя;
	
КонецФункции

Функция Представитель(Регистрация) Экспорт
	
	Возврат ДанныеРегистрации(Регистрация).Представитель;
	
КонецФункции

Функция НовыйСведенияОПредставителях() Экспорт
	
	ПустышкаТаблицы = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка().Подписанты.Выгрузить();
	
	СведенияОПредставителях = НовыйСведенияОПредставителяхСтруктура();
	СведенияОПредставителях.Вставить("Владелец",   Справочники.Организации.ПустаяСсылка());
	СведенияОПредставителях.Вставить("Подписанты", ПустышкаТаблицы);
	
	Возврат СведенияОПредставителях;
	
КонецФункции

Функция ОписаниеПредставителей(СведенияОПредставителях) Экспорт
	
	КоличествоПодписантов = СведенияОПредставителях.Подписанты.Количество();
	
	Если ЗначениеЗаполнено(СведенияОПредставителях.Представитель) 
		ИЛИ ЗначениеЗаполнено(СведенияОПредставителях.УполномоченноеЛицоПредставителя) Тогда 
		
		Представление = РегистрацияВНОКлиентСервер.ПредставлениеПодписанта(СведенияОПредставителях);
		
	ИначеЕсли КоличествоПодписантов > 0 Тогда
		
		Шаблон = НСтр("ru = 'Несколько подписантов (%1)'");
		Представление = СтрШаблон(Шаблон, Строка(КоличествоПодписантов));
		
	Иначе
		
		Представление = НСтр("ru = 'Руководитель'");
		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция СведенияОПодписантахПоРегистрации(Источник) Экспорт
	
	СведенияОПредставителях = НовыйСведенияОПредставителях();
	
	СписокСвойств = СписокСвойствПодписантов(Источник, СведенияОПредставителях);
	
	ЗаполнитьЗначенияСвойств(СведенияОПредставителях, Источник, СписокСвойств);
	
	Для Каждого СтрокаПодписанты Из Источник.Подписанты Цикл
		ЗаполнитьЗначенияСвойств(СведенияОПредставителях.Подписанты.Добавить(), СтрокаПодписанты);
	КонецЦикла;
	
	Возврат СведенияОПредставителях;
	
КонецФункции

Процедура ЗаполнитьСведенияОПодписантахВРегистрации(Приемник, СведенияОПредставителях) Экспорт
	
	СписокСвойств = СписокСвойствПодписантов(Приемник, СведенияОПредставителях);
	
	ЗаполнитьЗначенияСвойств(Приемник, СведенияОПредставителях, СписокСвойств);
	Приемник.Подписанты.Очистить();
	Для Каждого СтрокаПодписанты Из СведенияОПредставителях.Подписанты Цикл
		ЗаполнитьЗначенияСвойств(Приемник.Подписанты.Добавить(), СтрокаПодписанты);
	КонецЦикла;
	
КонецПроцедуры

Функция СписокСвойствПодписантов(Источник1, Источник2)
	
	СписокСвойств = РегистрацияВНОКлиентСервер.НовыйСведенияОПредставителяхСтрока();
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Источник1, "Владелец")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Источник2, "Владелец") Тогда 
		СписокСвойств = СписокСвойств  + ", Владелец";
	КонецЕсли;

	Возврат СписокСвойств;
	
КонецФункции

Процедура ПеренестиПодписантаИзШапкиВТаблицу(Форма, Объект) Экспорт
	
	ПеренестиПредставителяВТаблицу = 
		Форма.ПредыдущийВидПодписанта = 1
		И ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.ФизическиеЛица");
		
	Если ПеренестиПредставителяВТаблицу Тогда
		
		Пользователь = Мультирежим.ПользовательПоФизЛицуИзСправочникаПользователи(Объект.Представитель);
		НоваяСтрока = Форма.Подписанты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Объект);
		НоваяСтрока.Пользователь = Пользователь;
		РегистрацияВНОКлиентСервер.ЗаполнитьПредставлениеПодписанта(НоваяСтрока);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализацияПодписантовПриСозданииНаСервере(Форма, Объект) Экспорт
	
	Если Объект.Подписанты.Количество() > 0 Тогда
		Форма.ОтчетностьПодписываетПредставитель = 2;
	Иначе
		Форма.ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(Объект.Представитель), 1, 0);
	КонецЕсли;
	Форма.ПредыдущийВидПодписанта = Форма.ОтчетностьПодписываетПредставитель;
	
	Форма.ТекущийПользователь = Пользователи.ТекущийПользователь();

	// Внимание!!! Подписанты берутся из записанного объекта
	Для каждого Строка Из Объект.Подписанты Цикл
		
		Если Форма = Объект Тогда
			РегистрацияВНОКлиентСервер.ЗаполнитьПредставлениеПодписанта(Строка);
		Иначе
			НоваяСтрока = Форма.Подписанты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			РегистрацияВНОКлиентСервер.ЗаполнитьПредставлениеПодписанта(НоваяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	Форма.Подписанты.Сортировать("Пользователь Возр");
	
КонецПроцедуры

Процедура СохранитьПодписантовИзФормыВОбъект(Форма, Объект) Экспорт
	
	Если Форма.ОтчетностьПодписываетПредставитель = 2 Тогда
		
		Объект.Подписанты.Очистить();
		
		Для каждого Подписант Из Форма.Подписанты Цикл
			НоваяСтрока = Объект.Подписанты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Подписант);
		КонецЦикла;
		
		РегистрацияВНОКлиентСервер.ОчиститьПредставителя(Объект);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоФизическоеЛицо(Объект) Экспорт
	
	Если Объект.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено
		И Объект.Владелец.Метаданные().Реквизиты.Найти("ОбособленноеПодразделение") <> Неопределено Тогда 
		
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
		ЭтоФизическоеЛицо = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
		Возврат ЭтоФизическоеЛицо;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ИзменитьПредставлениеПодписантаРуководителя(Форма, Объект) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если ЭтоФизическоеЛицо(Объект) Тогда
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Индивидуальный предприниматель'");
		
	Иначе
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Руководитель'");
		
	Конецесли;
	
КонецПроцедуры

Функция ПодписантыУказаныКорректно(Форма, Объект, Отказ = Ложь) Экспорт
	
	ВсеПустые = 
		Форма.ОтчетностьПодписываетПредставитель = 2 
		И Форма.Подписанты.Количество() = 0;
	
	Если ВсеПустые Тогда
		
		ТекстОшибки = НСтр("ru = 'Добавьте хотя бы одного подписанта'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Подписанты",,Отказ);
		Возврат Ложь;
			
	КонецЕсли;
	
	Если Форма.ОтчетностьПодписываетПредставитель = 1
		И НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		
		ТекстСообщения = НСтр("ru = 'Заполните сведения о представителе'"); 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ПредставлениеПредставителя",,Отказ);
	
	КонецЕсли;
	
	Для каждого Строка Из Форма.Подписанты Цикл
		Если Не ЗначениеЗаполнено(Строка.Пользователь) Тогда
			
			ТекстСообщения = НСтр("ru = 'Заполните поле Пользователь у подписанта %1'"); 
			ТекстСообщения = СтрШаблон(ТекстСообщения,  Строка.ПредставлениеПодписанта); 
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Подписанты",,Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
	ПользователиИзТаблицы = Форма.Подписанты.Выгрузить().ВыгрузитьКолонку("Пользователь");
	УникальныеПользователиИзТаблицы = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ПользователиИзТаблицы);
	ЕстьДубли = ПользователиИзТаблицы.Количество() <> УникальныеПользователиИзТаблицы.Количество();
	
	Если ЕстьДубли Тогда
		
		УникальныеЗначения = Новый Соответствие;
		
		Для Каждого Пользователь Из ПользователиИзТаблицы Цикл
			Если УникальныеЗначения[Пользователь] = Неопределено Тогда
				УникальныеЗначения.Вставить(Пользователь, Истина);
			Иначе
				ТекстСообщения = НСтр("ru = 'Пользователь %1 указан более одного раза'"); 
				ТекстСообщения = СтрШаблон(ТекстСообщения, Пользователь); 
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Подписанты",,Отказ);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

Процедура ПередЗаписьюРегистрацииНаСервере(Форма, Объект) Экспорт
	
	Если Форма.ОтчетностьПодписываетПредставитель = 0 Тогда
		РегистрацияВНОКлиентСервер.ОчиститьПредставителя(Объект);
	КонецЕсли;

	Если Форма.ОтчетностьПодписываетПредставитель <> 2 Тогда
		Объект.Подписанты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйСведенияОПредставителяхСтруктура() Экспорт
	
	СведенияОПредставителях = Новый Структура();
	СведенияОПредставителях.Вставить("Представитель", Неопределено);
	СведенияОПредставителях.Вставить("Доверенность", Неопределено);
	СведенияОПредставителях.Вставить("ДокументПредставителя", "");
	СведенияОПредставителях.Вставить("УполномоченноеЛицоПредставителя", "");
	
	Возврат СведенияОПредставителях;
	
КонецФункции

Функция ШаблонДанныхОПредставителе() Экспорт
	
	Результат = НовыйСведенияОПредставителяхСтруктура();
	Результат.Вставить("Код", "");
	Результат.Вставить("КПП", "");
	Результат.Вставить("ЕстьДанные", Ложь);
	Результат.Вставить("Наименование", "");
	
	Возврат Результат;
		
КонецФункции

Функция ДоверенностьДолжнаБытьОбязательно(Регистрация) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Регистрация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Организация = Регистрация.Владелец;
	
	ЭтоМультирежим = Мультирежим.ЭтоМультиРежимПоОрганизации(Организация);
	
	Если НЕ ЭтоМультирежим Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Руководитель = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Организация);
	Если НЕ ЗначениеЗаполнено(Руководитель) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекущееФизЛицо = Мультирежим.ФизЛицоПоПользователюИзСправочникаПользователи();
	
	ДолжнаБытьОбязательно = ТекущееФизЛицо <> Руководитель;

	Возврат ДолжнаБытьОбязательно;
	
КонецФункции

Процедура СообщитьОбОшибкеОтсутствияДоверенности(Регистрация) Экспорт
	
	Организация = Регистрация.Владелец;
	
	ТекущееФизЛицо = Мультирежим.ФизЛицоПоПользователюИзСправочникаПользователи();
	Руководитель = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Организация);
	
	Ошибка = НСтр("ru = 'В справочнике ""Регистрации в налоговом органе"" для ИФНС ""%1"" не указана доверенность на физ. лицо %2 на право отправки отчетности по организации ""%3"" вместо руководителя %4'");
	Ошибка = СтрШаблон(Ошибка, Регистрация, ТекущееФизЛицо, Организация, Руководитель);
	
	ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(Ошибка);

КонецПроцедуры

Функция НетОбязательнойДоверенности(Регистрация) Экспорт
	
	ДанныеРегистрации = ДанныеРегистрации(Регистрация);
	
	Если ДоверенностьДолжнаБытьОбязательно(Регистрация)
		И НЕ ЗначениеЗаполнено(ДанныеРегистрации.Доверенность) Тогда
		
		ТекущееФизЛицо = Мультирежим.ФизЛицоПоПользователюИзСправочникаПользователи();
		
		Если ТекущееФизЛицо <> ДанныеРегистрации.Представитель Тогда 
			СообщитьОбОшибкеОтсутствияДоверенности(Регистрация);
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ОчиститьПредставителяДляРуководителяВМультирежиме(Регистрация, Результат) Экспорт
	
	Организация = Регистрация.Владелец;
	
	ЭтоМультирежим = Мультирежим.ЭтоМультиРежимПоОрганизации(Организация);
	Если ЭтоМультирежим Тогда
		
		Руководитель   = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Организация);
		ТекущееФизЛицо = Мультирежим.ФизЛицоПоПользователюИзСправочникаПользователи();
		
		Если ЗначениеЗаполнено(Руководитель) 
			И Руководитель = ТекущееФизЛицо Тогда
		
			РегистрацияВНОКлиентСервер.ОчиститьПредставителя(Результат);
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецФункции


#КонецОбласти