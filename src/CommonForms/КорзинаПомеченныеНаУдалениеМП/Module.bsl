#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Функция ЭтоСправочник(Ссылка)
	
	Если Метаданные.Справочники.Содержит(Метаданные.НайтиПоТипу(ТипЗнч(Ссылка))) Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЭтоДокумент(Ссылка)
	
	Если Метаданные.Документы.Содержит(Метаданные.НайтиПоТипу(ТипЗнч(Ссылка))) Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыделитьЭлементы(Выделение)
	
	Для Каждого Элемент Из ЭтаФорма.ПомеченныеНаУдаление Цикл 
		Элемент.Выбран = Выделение;
		ОбновитьСтатусы(Элемент);
	КонецЦикла;
	
	Элементы.СнятьВыделение.Видимость = Выделение;
	Элементы.ВыделитьВсе.Видимость = НЕ Выделение;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатусОбъекта(ЕстьСвязанныеОбъекты)
	
	Если ЕстьСвязанныеОбъекты Тогда 
		Возврат Перечисления.СостоянияОбъектовВКорзинеМП.НельзяУдалить;
	Иначе 
		Возврат Перечисления.СостоянияОбъектовВКорзинеМП.КУдалению;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеОбъекта(Ссылка)
	
	ПредставлениеОбъекта = Новый Структура("Представление, Дополнение", "", "");
	
	Если ЭтоСправочник(Ссылка) Тогда 
		ПредставлениеОбъекта.Представление = Ссылка.Наименование;
		ПредставлениеОбъекта.Дополнение = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним;
	ИначеЕсли ЭтоДокумент(Ссылка) Тогда 
		
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказМП") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Покупатель;
			ПредставлениеОбъекта.Представление = 
				Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним +
				НСтр("ru=' №';en=' No.'") + ПолучитьПредставлениеНомера(Ссылка.Номер) + 
				НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходДенегМП") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Контрагент;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходТовараМП") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Поставщик;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РасходДенегМП") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Контрагент;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РасходТовараМП") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Ссылка.Покупатель;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЧекККММП")
			ИЛИ ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЧекККМВозвратМП")
			ИЛИ ТипЗнч(Ссылка) = Тип("ДокументСсылка.ОтчетОРозничныхПродажахМП")Тогда 
			
			ПредставлениеОбъекта.Дополнение = НСтр("ru='Розничный покупатель'");
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПроизводствоМП") Тогда 
			
			ПредставлениеОбъекта.Дополнение = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним;
			ПредставлениеОбъекта.Представление = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Синоним + НСтр("ru=' от ';en=' of '") + Формат(Ссылка.Дата, "ДЛФ=Д");
			
		Иначе
			
			ПредставлениеОбъекта.Представление = НСтр("ru='Служебный документ';en='Service document'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПредставлениеОбъекта;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеНомера(Знач НомерОбъекта)

	// Удаляем все символы, не являющиеся цифрами.
	СтрокаЦифровыхСимволов = "0123456789";
	Номер = "";
	Для Индекс = 1 По СтрДлина(НомерОбъекта) Цикл
		Символ = Сред(НомерОбъекта, Индекс, 1);
		Если Найти(СтрокаЦифровыхСимволов, Символ) > 0 Тогда
			Номер = Номер + Символ;
		КонецЕсли;
	КонецЦикла;
	
	// Удаляем незначащие нули.
	Пока Лев(Номер, 1)= "0" Цикл
		Номер = Сред(Номер, 2);
	КонецЦикла;
	
	Возврат Номер;
	
КонецФункции

&НаСервере
Процедура ПолучитьПомеченныеНаУдаление()
	
	УстановитьПривилегированныйРежим(Истина);
	ПомеченныеНаУдалениеМассив = НайтиПомеченныеНаУдаление();
	Для Каждого ПомеченныйНаУдаление Из ПомеченныеНаУдалениеМассив Цикл 
		
		Строки = ЭтаФорма.ПомеченныеНаУдаление.НайтиСтроки(Новый Структура("Ссылка", ПомеченныйНаУдаление.Ссылка));
		Если Строки.Количество() <> 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ЭтаФорма.ПомеченныеНаУдаление.Добавить();
		НоваяСтрока.Ссылка = ПомеченныйНаУдаление.Ссылка;
		ПредставлениеОбъекта = ПолучитьПредставлениеОбъекта(ПомеченныйНаУдаление.Ссылка);
		НоваяСтрока.Представление = ПредставлениеОбъекта.Представление;
		НоваяСтрока.Дополнение = ПредставлениеОбъекта.Дополнение;
		НоваяСтрока.Выбран = Ложь;
		
		Ссылки = Новый Массив;
		Ссылки.Добавить(ПомеченныйНаУдаление.Ссылка);
		СвязанныеОбъекты = НайтиПоСсылкам(Ссылки);
		Для Каждого СвязанныйОбъект Из СвязанныеОбъекты Цикл 
			Если ЭтоСправочник(СвязанныйОбъект.Данные) Или ЭтоДокумент(СвязанныйОбъект.Данные) Тогда 
				НовыйСвязанныйОбъект = НоваяСтрока.СвязанныеОбъекты.Добавить();
				НовыйСвязанныйОбъект.Ссылка = СвязанныйОбъект.Данные;
			КонецЕсли;
		КонецЦикла;
		
		УстановитьСтатусОбъекта(НоваяСтрока);
		
	КонецЦикла;
	
	ОбновитьСписок(ПомеченныеНаУдалениеМассив);
	
	ЭтаФорма.ПомеченныеНаУдаление.Сортировать("Представление Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусы(ВыбранныйОбъект)
	
	Если ВыбранныйОбъект.Выбран Тогда 
		ПотенциальныйСтатус = ПредопределенноеЗначение("Перечисление.СостоянияОбъектовВКорзинеМП.КУдалению");
	Иначе 
		ПотенциальныйСтатус = ПредопределенноеЗначение("Перечисление.СостоянияОбъектовВКорзинеМП.НельзяУдалить");
	КонецЕсли;
	
	Для Каждого Объект Из ПомеченныеНаУдаление Цикл 
			Если Объект.Ссылка = ВыбранныйОбъект.Ссылка Тогда 
				Продолжить;
			КонецЕсли;
			
			Если Объект.Статус = ПотенциальныйСтатус Тогда 
				Продолжить;
			КонецЕсли;
			
			СвязанныеОбъекты = Объект.СвязанныеОбъекты.НайтиСтроки(Новый Структура("Ссылка", ВыбранныйОбъект.Ссылка));
			Если СвязанныеОбъекты.Количество() <> 0 Тогда 
				Объект.Статус = ПотенциальныйСтатус;
			КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолноеИмяОбъекта(Ссылка)
	
	Возврат Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).ПолноеИмя();
	
КонецФункции

&НаСервере
Процедура ОбновитьСписок(ПомеченныеНаУдалениеМассив = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПомеченныеНаУдалениеМассив = Неопределено Тогда 
		ПомеченныеНаУдалениеМассив = НайтиПомеченныеНаУдаление();
	КонецЕсли;
	Итератор = 0;
	Пока Итератор < ЭтаФорма.ПомеченныеНаУдаление.Количество() Цикл 
		Если ПомеченныеНаУдалениеМассив.Найти(ЭтаФорма.ПомеченныеНаУдаление[Итератор].Ссылка) = Неопределено Тогда 
			ЭтаФорма.ПомеченныеНаУдаление.Удалить(Итератор);
		Иначе 
			УстановитьСтатусОбъекта(ЭтаФорма.ПомеченныеНаУдаление[Итератор]);
			Итератор = Итератор + 1;
		КонецЕсли;
	КонецЦикла;
	
	УстановитьВидимостьПомеченныеНаУдаление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусОбъекта(Объект)
	
	Объект.Статус = ?(Объект.СвязанныеОбъекты.Количество() = 0, ПолучитьСтатусОбъекта(Ложь), ПолучитьСтатусОбъекта(Истина));
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьВыбранныеОбъектыНаСервере(Результат)
	
	ВосстановленоОбъектов = 0;
	Итератор = 0;
	Пока Итератор < ЭтаФорма.ПомеченныеНаУдаление.Количество() Цикл 
		Объект = ЭтаФорма.ПомеченныеНаУдаление[Итератор];
		Если Объект.Выбран Тогда 
			ПолученныйОбъект = Объект.Ссылка.ПолучитьОбъект();
			ПолученныйОбъект.ПометкаУдаления = Ложь;
			ПолученныйОбъект.ДополнительныеСвойства.Вставить("ЗапретитьОперацииСоСвязаннымиДокументами", Истина);
			ПолученныйОбъект.ДополнительныеСвойства.Вставить("ЗапретитьПовторныйЗапускОбмена", Истина);
			ПолученныйОбъект.Записать();
			
			Идентификатор = Объект.ПолучитьИдентификатор();
			ЭтаФорма.ПомеченныеНаУдаление.Удалить(ПомеченныеНаУдаление.НайтиПоИдентификатору(Идентификатор));
			ВосстановленоОбъектов = ВосстановленоОбъектов + 1;
		Иначе 
			Итератор = Итератор + 1;
		КонецЕсли;
	КонецЦикла;
	
	Результат.Восстановлено = ВосстановленоОбъектов;
	УстановитьВидимостьПомеченныеНаУдаление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПомеченныеНаУдаление()
	
	Элементы.ДекорацияПустаяКорзина.Видимость = ПомеченныеНаУдаление.Количество() = 0;
	Элементы.ПомеченныеНаУдаление.Видимость = НЕ Элементы.ДекорацияПустаяКорзина.Видимость;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВыбранныеОбъектыНаСервере(Результат)
	
	УдаленоОбъектов = 0;
	НеУдаленоОбъектов = 0;
	Итератор = 0;
	Пока Итератор < ЭтаФорма.ПомеченныеНаУдаление.Количество() Цикл 
		Объект = ЭтаФорма.ПомеченныеНаУдаление[Итератор];
		Если Объект.Выбран И Объект.Статус = Перечисления.СостоянияОбъектовВКорзинеМП.КУдалению Тогда 
			УдалитьОбъект(Объект);
			
			Идентификатор = Объект.ПолучитьИдентификатор();
			ЭтаФорма.ПомеченныеНаУдаление.Удалить(ПомеченныеНаУдаление.НайтиПоИдентификатору(Идентификатор));
			УдаленоОбъектов = УдаленоОбъектов + 1;
		ИначеЕсли Объект.Выбран И Объект.Статус = Перечисления.СостоянияОбъектовВКорзинеМП.НельзяУдалить Тогда 
			НеУдаленоОбъектов = НеУдаленоОбъектов + 1;
			Итератор = Итератор + 1;
		Иначе 
			Итератор = Итератор + 1;
		КонецЕсли;
	КонецЦикла;
	
	Результат.Удалено = УдаленоОбъектов;
	Результат.НеУдалено = НеУдаленоОбъектов;
	УстановитьВидимостьПомеченныеНаУдаление();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьОбъект(Объект)
	
	УстановитьПривилегированныйРежим(Истина);
	ПолученныйОбъект = Объект.Ссылка.ПолучитьОбъект();
	ПолученныйОбъект.Удалить();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики

	УстановитьПривилегированныйРежим(Истина);
	ПолучитьПомеченныеНаУдаление();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КорзинаПросмотрСвязанныхОбъектовЗакрытие" Тогда 
		ПолучитьПомеченныеНаУдаление();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ВыделитьЭлементы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ВыделитьЭлементы(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьВыбранныеОбъекты(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	Результат = Новый Структура("Восстановлено", 0);
	
	ВыбранныеОбъекты = ЭтаФорма.ПомеченныеНаУдаление.НайтиСтроки(Новый Структура("Выбран", Истина));
	Если ВыбранныеОбъекты.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='Выбранные объекты будут восстановлены."
		"Продолжить?';en='The selected objects will be restored."
		"Do you Want To Continue?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("ВосстановитьВыбранныеОбъектыЗавершение", ЭтотОбъект, Новый Структура("Результат", Результат)), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьВыбранныеОбъектыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Результат = ДополнительныеПараметры.Результат;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	ВосстановитьВыбранныеОбъектыНаСервере(Результат);
	
	СообщениеПользователю = "Восстановлено объектов: " + Результат.Восстановлено;
	Оповестить("ДействиеСКорзиной");
	ПоказатьПредупреждение(Неопределено, НСтр("ru='" + СообщениеПользователю + "'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());

КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыбранныеОбъекты(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	Результат = Новый Структура("Удалено, НеУдалено", 0, 0);
	
	ВыбранныеОбъекты = ЭтаФорма.ПомеченныеНаУдаление.НайтиСтроки(Новый Структура("Выбран", Истина));
	Если ВыбранныеОбъекты.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='Выбранные объекты будут навсегда удалены."
		"Продолжить?';en='The selected items will be permanently deleted."
		"Do you Want To Continue?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УдалитьВыбранныеОбъектыЗавершение", ЭтотОбъект, Новый Структура("Результат", Результат)), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыбранныеОбъектыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Результат = ДополнительныеПараметры.Результат;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	УдалитьВыбранныеОбъектыНаСервере(Результат);
	
	СообщениеУдалено = "Удалено объектов:" + Результат.Удалено;
	СообщениеНеУдалено = "Удаление не выполнено: " + Результат.НеУдалено;
	
	Если Результат.НеУдалено = 0 Тогда 
		СообщениеПользователю = СообщениеУдалено;
	Иначе
		СообщениеПользователю = СообщениеУдалено + "
		|" + СообщениеНеУдалено;
	КонецЕсли;
	
	Оповестить("ДействиеСКорзиной");
	ПоказатьПредупреждение(, НСтр("ru='" + СообщениеПользователю + "'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПомеченныеНаУдалениеПриИзменении(Элемент)
	
	ОбновитьСтатусы(Элемент.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомеченныеНаУдалениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныйОбъект = Элемент.ТекущиеДанные;
	
	Если ВыбранныйОбъект.Статус = ПредопределенноеЗначение("Перечисление.СостоянияОбъектовВКорзинеМП.КУдалению") Тогда 
		Форма = ПолучитьФорму(ПолноеИмяОбъекта(ВыбранныйОбъект.Ссылка) + ".ФормаОбъекта", Новый Структура("Ключ", ВыбранныйОбъект.Ссылка));
		//Форма.ОткрытьМодально();
		//ОткрытьФорму(ПолноеИмяОбъекта(ВыбранныйОбъект.Ссылка) + ".ФормаОбъекта", Новый Структура("Ключ", ВыбранныйОбъект.Ссылка),,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		Форма.Открыть();
		ОбновитьСписок();
	Иначе 
		Строки = ЭтаФорма.ПомеченныеНаУдаление.НайтиСтроки(Новый Структура("Ссылка", ВыбранныйОбъект.Ссылка));
		ПараметрыОткрытия = Новый Структура();
		ПараметрыОткрытия.Вставить("Объект", Строки[0].Ссылка);
		ПараметрыОткрытия.Вставить("Представление", Строки[0].Представление);
		ПараметрыОткрытия.Вставить("Дополнение", Строки[0].Дополнение);
		ПараметрыОткрытия.Вставить("СвязанныеОбъекты", Строки[0].СвязанныеОбъекты);
		
		Форма = ПолучитьФорму("ОбщаяФорма.КорзинаПросмотрСвязанныхОбъектовМП", ПараметрыОткрытия);
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

#КонецОбласти
