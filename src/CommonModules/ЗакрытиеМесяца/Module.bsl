
#Область ПрограммныйИнтерфейс

// Функция - Возвращает данные первого месяца с неактуальной себестоимостью в заданном периоде по указанным организациям.
//			 Себестоимость считается неактуальной, если не закрыт месяц или есть измененные документы после последнего закрытия.
//
// Параметры:
//  НачалоПериода	 - 	Дата - Начало периода анализа
//  КонецПериода	 - 	Дата - Конец периода анализа
//  Организации		 - 	Массив - Массив проверяемых организаций. Если массив пустой - проверяются все организации
// 
// Возвращаемое значение: Неопределено, Структура
//  Неопределено - Себестоимость актуальна
//	Структура - Структура со свойствами "Организация", "Месяц" - Первый месяц с неактуальной себестоимостью 
//
Функция НеактуальныеДанныеСебестоимостиВПериоде(НачалоПериода, КонецПериода, Организации) Экспорт
	
	Если НачалоПериода > КонецПериода Тогда
		// Анализ не требуется
		Возврат Неопределено;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.УстановитьПараметр("БезОтбораОрганизации", Организации.Количество() = 0);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НАЧАЛОПЕРИОДА(ЗапасыОбороты.Период, МЕСЯЦ) КАК Месяц,
	|	ЗапасыОбороты.Организация КАК Организация
	|ПОМЕСТИТЬ МесяцыСДвижениями
	|ИЗ
	|	РегистрНакопления.Запасы.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Месяц,
	|			&БезОтбораОрганизации
	|				ИЛИ Организация В (&Организации)) КАК ЗапасыОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(ЗапасыОбороты.Период, МЕСЯЦ),
	|	ЗапасыОбороты.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МесяцыСДвижениями.Месяц КАК Месяц,
	|	МесяцыСДвижениями.Организация КАК Организация,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЗакрытиеМесяца.Ссылка ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК НеАктуален
	|ПОМЕСТИТЬ НеактуальныеМесяцы
	|ИЗ
	|	МесяцыСДвижениями КАК МесяцыСДвижениями
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗакрытиеМесяца КАК ЗакрытиеМесяца
	|		ПО (МесяцыСДвижениями.Месяц = НАЧАЛОПЕРИОДА(ЗакрытиеМесяца.Дата, МЕСЯЦ))
	|			И МесяцыСДвижениями.Организация = ЗакрытиеМесяца.Организация
	|			И (ЗакрытиеМесяца.Проведен)
	|			И (ЗакрытиеМесяца.РасчетФактическойСебестоимости)
	|
	|СГРУППИРОВАТЬ ПО
	|	МесяцыСДвижениями.Месяц,
	|	МесяцыСДвижениями.Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МесяцыСДвижениями.Месяц,
	|	МесяцыСДвижениями.Организация,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ИзмененияЗакрытогоМесяца.ИзмененныйДокумент ЕСТЬ NULL
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ)
	|ИЗ
	|	МесяцыСДвижениями КАК МесяцыСДвижениями
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияЗакрытогоМесяца КАК ИзмененияЗакрытогоМесяца
	|		ПО МесяцыСДвижениями.Месяц = ИзмененияЗакрытогоМесяца.Месяц
	|			И МесяцыСДвижениями.Организация = ИзмененияЗакрытогоМесяца.Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	МесяцыСДвижениями.Месяц,
	|	МесяцыСДвижениями.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	НеактуальныеМесяцы.Месяц КАК Месяц,
	|	НеактуальныеМесяцы.Организация КАК Организация,
	|	МАКСИМУМ(НеактуальныеМесяцы.НеАктуален) КАК НеАктуален
	|ИЗ
	|	НеактуальныеМесяцы КАК НеактуальныеМесяцы
	|
	|СГРУППИРОВАТЬ ПО
	|	НеактуальныеМесяцы.Месяц,
	|	НеактуальныеМесяцы.Организация
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(НеактуальныеМесяцы.НеАктуален) = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("Организация", Выборка.Организация);
		СтруктураВозврата.Вставить("Месяц", Выборка.Месяц);
		Возврат СтруктураВозврата;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция - Имя месяца в заданном падеже
//
// Параметры:
//  НомерМесяца	 - 	Число - Номер месяца
//  Падеж		 - 	Число, Строка - Номер по порядку или имя падежа 
// 
// Возвращаемое значение:
//  Строка - Имя месяца в заданном падеже
//
Функция ИмяМесяцаВПадеже(НомерМесяца, Падеж) Экспорт
	
	Если Падеж = 1 ИЛИ ВРег(Лев(Падеж, 1)) = "И" Тогда
		Индекс = 0;
	ИначеЕсли Падеж = 2 ИЛИ ВРег(Лев(Падеж, 1)) = "Р" Тогда
		Индекс = 1;
	ИначеЕсли Падеж = 3 ИЛИ ВРег(Лев(Падеж, 1)) = "Д" Тогда
		Индекс = 2;
	ИначеЕсли Падеж = 4 ИЛИ ВРег(Лев(Падеж, 1)) = "В" Тогда
		Индекс = 3;
	ИначеЕсли Падеж = 5 ИЛИ ВРег(Лев(Падеж, 1)) = "Т" Тогда
		Индекс = 4;
	ИначеЕсли Падеж = 6 ИЛИ ВРег(Лев(Падеж, 1)) = "П" Тогда
		Индекс = 5;
	Иначе
		Возврат "";
	КонецЕсли; 
	СтрокаПадежей = ПадежиМесяца(НомерМесяца);
	Если ПустаяСтрока(СтрокаПадежей) Тогда
		Возврат "";
	КонецЕсли; 
	МассивПадежей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаПадежей, ";");
	Если Индекс + 1 > МассивПадежей.Количество() Тогда
		Возврат "";
	КонецЕсли;
	Возврат МассивПадежей[Индекс];
		
КонецФункции
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - обработчик события ПередЗаписью регистра накопления Запасы для регистрации изменений закрытых периодов 
//
Процедура ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ДополнительныеСвойства = Источник.ДополнительныеСвойства;
	Если Отказ
		ИЛИ Источник.ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Отбор = Источник.Отбор;
	Если ЭтоЧек(Отбор.Регистратор.Значение) Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("Замещение", Замещение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Запасы.Регистратор КАК Регистратор,
	|	Запасы.Период КАК Период,
	|	Запасы.Организация КАК Организация,
	|	Запасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	Запасы.СчетУчета КАК СчетУчета,
	|	Запасы.Номенклатура КАК Номенклатура,
	|	Запасы.Характеристика КАК Характеристика,
	|	Запасы.Партия КАК Партия,
	|	Запасы.ЗаказПокупателя КАК ЗаказПокупателя,
	|	Запасы.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	Запасы.Количество КАК Количество,
	|	Запасы.Сумма КАК Сумма
	|ПОМЕСТИТЬ ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью
	|ИЗ
	|	РегистрНакопления.Запасы КАК Запасы
	|ГДЕ
	|	Запасы.Регистратор = &Регистратор
	|	И &Замещение";
	Запрос.Выполнить();
		
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи регистра накопления Запасы для регистрации изменений закрытых периодов 
//
Процедура ИзмененияЗакрытогоМесяцаЗапасыПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	ДополнительныеСвойства = Источник.ДополнительныеСвойства;
	Если Отказ
		ИЛИ Источник.ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Отбор = Источник.Отбор;
	Если ЭтоЧек(Отбор.Регистратор.Значение) Тогда
		Возврат;
	КонецЕсли; 
	
	ТаблицаДвижений = Источник.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДвижений", ТаблицаДвижений);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДвижений.Регистратор КАК Регистратор,
	|	ТаблицаДвижений.Период КАК Период,
	|	ТаблицаДвижений.Организация КАК Организация,
	|	ТаблицаДвижений.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДвижений.СчетУчета КАК СчетУчета,
	|	ТаблицаДвижений.Номенклатура КАК Номенклатура,
	|	ТаблицаДвижений.Характеристика КАК Характеристика,
	|	ТаблицаДвижений.Партия КАК Партия,
	|	ТаблицаДвижений.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ТаблицаДвижений.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ТаблицаДвижений.Количество КАК Количество,
	|	ТаблицаДвижений.Сумма КАК Сумма
	|ПОМЕСТИТЬ ТаблицаДвижений
	|ИЗ
	|	&ТаблицаДвижений КАК ТаблицаДвижений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДвижений.Регистратор КАК Регистратор,
	|	ТаблицаДвижений.Период КАК Период,
	|	ТаблицаДвижений.Организация КАК Организация,
	|	ТаблицаДвижений.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДвижений.СчетУчета КАК СчетУчета,
	|	ТаблицаДвижений.Номенклатура КАК Номенклатура,
	|	ТаблицаДвижений.Характеристика КАК Характеристика,
	|	ТаблицаДвижений.Партия КАК Партия,
	|	ТаблицаДвижений.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ТаблицаДвижений.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ТаблицаДвижений.Количество КАК Количество,
	|	ТаблицаДвижений.Сумма КАК Сумма
	|ПОМЕСТИТЬ ИзмененияЗапасов
	|ИЗ
	|	ТаблицаДвижений КАК ТаблицаДвижений
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Регистратор,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Период,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Организация,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.СтруктурнаяЕдиница,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.СчетУчета,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Номенклатура,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Характеристика,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Партия,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.ЗаказПокупателя,
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.ЗаказНаПроизводство,
	|	-ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Количество,
	|	-ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью.Сумма
	|ИЗ
	|	ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью КАК ИзмененияЗакрытогоМесяцаЗапасыПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИзмененияЗапасов.Регистратор КАК Регистратор,
	|	ИзмененияЗапасов.Период КАК Период,
	|	ИзмененияЗапасов.Организация КАК Организация,
	|	ИзмененияЗапасов.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ИзмененияЗапасов.СчетУчета КАК СчетУчета,
	|	ИзмененияЗапасов.Номенклатура КАК Номенклатура,
	|	ИзмененияЗапасов.Характеристика КАК Характеристика,
	|	ИзмененияЗапасов.Партия КАК Партия,
	|	ИзмененияЗапасов.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ИзмененияЗапасов.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	СУММА(ИзмененияЗапасов.Количество) КАК Количество,
	|	СУММА(ИзмененияЗапасов.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВсеИзменения
	|ИЗ
	|	ИзмененияЗапасов КАК ИзмененияЗапасов
	|
	|СГРУППИРОВАТЬ ПО
	|	ИзмененияЗапасов.Регистратор,
	|	ИзмененияЗапасов.Период,
	|	ИзмененияЗапасов.Организация,
	|	ИзмененияЗапасов.СтруктурнаяЕдиница,
	|	ИзмененияЗапасов.СчетУчета,
	|	ИзмененияЗапасов.Номенклатура,
	|	ИзмененияЗапасов.Характеристика,
	|	ИзмененияЗапасов.Партия,
	|	ИзмененияЗапасов.ЗаказПокупателя,
	|	ИзмененияЗапасов.ЗаказНаПроизводство
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ИзмененияЗапасов.Количество) <> 0
	|		ИЛИ СУММА(ИзмененияЗапасов.Сумма) <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеИзменения.Организация КАК Организация,
	|	ВсеИзменения.Регистратор КАК ИзмененныйДокумент,
	|	НАЧАЛОПЕРИОДА(ВсеИзменения.Период, МЕСЯЦ) КАК Месяц
	|ПОМЕСТИТЬ ИзмененныеДокументы
	|ИЗ
	|	ВсеИзменения КАК ВсеИзменения
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеИзменения.Организация,
	|	ВсеИзменения.Регистратор,
	|	НАЧАЛОПЕРИОДА(ВсеИзменения.Период, МЕСЯЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИзмененныеДокументы.Организация КАК Организация,
	|	ИзмененныеДокументы.ИзмененныйДокумент КАК ИзмененныйДокумент,
	|	ИзмененныеДокументы.Месяц КАК Месяц
	|ИЗ
	|	ИзмененныеДокументы КАК ИзмененныеДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗакрытиеМесяца КАК ЗакрытиеМесяца
	|		ПО (ЗакрытиеМесяца.Проведен)
	|			И (ЗакрытиеМесяца.РасчетФактическойСебестоимости)
	|			И ИзмененныеДокументы.Организация = ЗакрытиеМесяца.Организация
	|			И (ИзмененныеДокументы.Месяц = НАЧАЛОПЕРИОДА(ЗакрытиеМесяца.Дата, МЕСЯЦ))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияЗакрытогоМесяца КАК ИзмененияЗакрытогоМесяца
	|		ПО ИзмененныеДокументы.Организация = ИзмененияЗакрытогоМесяца.Организация
	|			И ИзмененныеДокументы.ИзмененныйДокумент = ИзмененияЗакрытогоМесяца.ИзмененныйДокумент
	|			И ИзмененныеДокументы.Месяц = ИзмененияЗакрытогоМесяца.Месяц
	|ГДЕ
	|	НЕ ЗакрытиеМесяца.Ссылка ЕСТЬ NULL
	|	И ИзмененияЗакрытогоМесяца.ИзмененныйДокумент ЕСТЬ NULL
	|	И НЕ ИзмененныеДокументы.ИзмененныйДокумент ССЫЛКА Документ.ЗакрытиеМесяца
	|
	|СГРУППИРОВАТЬ ПО
	|	ИзмененныеДокументы.ИзмененныйДокумент,
	|	ИзмененныеДокументы.Месяц,
	|	ИзмененныеДокументы.Организация";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ИзмененияЗакрытогоМесяца.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		Запись.Записать(Истина);
	КонецЦикла; 
	
КонецПроцедуры

Функция ПадежиМесяца(НомерМесяца)
	
	Если НомерМесяца = 1 Тогда
		Возврат НСтр("ru = 'январь;января;январю;январь;январем;январе'");
	ИначеЕсли НомерМесяца = 2 Тогда
		Возврат НСтр("ru = 'февраль;февраля;февралю;февраль;февралем;феврале'");
	ИначеЕсли НомерМесяца = 3 Тогда
		Возврат НСтр("ru = 'март;марта;марту;март;мартом;марте'");
	ИначеЕсли НомерМесяца = 4 Тогда
		Возврат НСтр("ru = 'апрель;апреля;апрелю;апрель;апрелем;апреле'");
	ИначеЕсли НомерМесяца = 5 Тогда
		Возврат НСтр("ru = 'май;мая;маю;май;маем;мае'");
	ИначеЕсли НомерМесяца = 6 Тогда
		Возврат НСтр("ru = 'июнь;июня;июню;июнь;июнем;июне'");
	ИначеЕсли НомерМесяца = 7 Тогда
		Возврат НСтр("ru = 'июль;июля;июлю;июль;июлем;июле'");
	ИначеЕсли НомерМесяца = 8 Тогда
		Возврат НСтр("ru = 'август;августа;августу;август;августом;августе'");
	ИначеЕсли НомерМесяца = 9 Тогда
		Возврат НСтр("ru = 'сентябрь;сентября;сентябрю;сентябрь;сентябрем;сентябре'");
	ИначеЕсли НомерМесяца = 10 Тогда
		Возврат НСтр("ru = 'октябрь;октября;октябрю;октябрь;октябрем;октябре'");
	ИначеЕсли НомерМесяца = 11 Тогда
		Возврат НСтр("ru = 'ноябрь;ноября;ноябрю;ноябрь;ноябрем;ноябре'");
	ИначеЕсли НомерМесяца = 12 Тогда
		Возврат НСтр("ru = 'декабрь;декабря;декабрю;декабрь;декабрем;декабре'");
	Иначе
		Возврат "";
	КонецЕсли; 
	
КонецФункции
 
Функция ЭтоЧек(Регистратор)
	
	Возврат (ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЧекККМ")
		ИЛИ ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЧекККМВозврат"));
	
КонецФункции

#КонецОбласти 


 