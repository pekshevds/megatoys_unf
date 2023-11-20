#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТЧ = Этапы.Найти(Справочники.ЭтапыПроизводства.ЗавершениеПроизводства, "Этап");
	Если СтрокаТЧ = Неопределено Тогда
		СтрокаТЧ = Этапы.Добавить();
		СтрокаТЧ.Этап = Справочники.ЭтапыПроизводства.ЗавершениеПроизводства;
	Иначе
		Этапы.Сдвинуть(СтрокаТЧ, Этапы.Количество() - СтрокаТЧ.НомерСтроки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Если Этапы.Количество()=0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'Не выбрано ни одного этапа'"),
		ЭтотОбъект,
		"Этапы",
		,
		Отказ);
	КонецЕсли; 
	
	// Проверка удаления выполняемых ранее этапов
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Этапы", Этапы.ВыгрузитьКолонку("Этап"));
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЭтапыПроизводстваОбороты.Этап КАК Этап
		|ИЗ
		|	РегистрНакопления.ЭтапыПроизводства.Обороты(
		|			,
		|			,
		|			,
		|			Спецификация.ВидПроизводства = &Ссылка
		|				И Этап <> ЗНАЧЕНИЕ(Справочник.ЭтапыПроизводства.ЗавершениеПроизводства)
		|				И НЕ Этап В (&Этапы)) КАК ЭтапыПроизводстваОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭтапыПроизводстваОбороты.Этап";
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			ПредставлениеЭтапов = "";
			Пока Выборка.Следующий() Цикл
				ПредставлениеЭтапов = ПредставлениеЭтапов + ?(ПустаяСтрока(ПредставлениеЭтапов), "", ", ") + Строка(Выборка.Этап);	
			КонецЦикла;
			ТекстОшибки = СтрШаблон(НСтр("ru = 'По виду производства ранее %1 %2. Удаление %3 невозможно.'"),
			?(Выборка.Количество()=1, НСтр("ru = 'выполнялся этап'"), НСтр("ru = 'выполнялись этапы:'")),
			ПредставлениеЭтапов,
			?(Выборка.Количество()=1, НСтр("ru = 'этого этапа'"), НСтр("ru = 'этих этапов'")));
			ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Этапы",
			,
			Отказ);
		КонецЕсли; 
	КонецЕсли; 
	
	// Дублирование этапов
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Этапы", Этапы.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Этапы.НомерСтроки КАК НомерСтроки,
	|	Этапы.Этап КАК Этап,
	|	1 КАК Количество
	|ПОМЕСТИТЬ Этапы
	|ИЗ
	|	&Этапы КАК Этапы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Этапы.Этап КАК Этап,
	|	МАКСИМУМ(Этапы.НомерСтроки) КАК НомерСтроки,
	|	СУММА(Этапы.Количество) КАК Количество
	|ИЗ
	|	Этапы КАК Этапы
	|
	|СГРУППИРОВАТЬ ПО
	|	Этапы.Этап
	|
	|ИМЕЮЩИЕ
	|	СУММА(Этапы.Количество) > 1";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбщегоНазначения.СообщитьПользователю(
		СтрШаблон(НСтр("ru = 'Дублирование этапов производства: %1'"), Выборка.Этап),
		ЭтотОбъект,
		ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Этапы", Выборка.НомерСтроки, "Этап"),
		,
		Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 	
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли