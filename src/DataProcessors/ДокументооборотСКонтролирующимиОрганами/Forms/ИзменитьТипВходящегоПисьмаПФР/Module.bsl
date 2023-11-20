#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЭДОКлиент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимИзменения = Параметры.РежимИзменения;
	ЗаполнитьТаблицуПисем(Параметры.СписокПисем);
	
	ОформитьФорму();
	
	Если ТаблицаПисем.Количество() = 0 Тогда
		КлючСохраненияПоложенияОкна = "Ошибка";
	ИначеЕсли ТаблицаПисем.Количество() = 1 Тогда
		КлючСохраненияПоложенияОкна = "Один";
	ИначеЕсли ТаблицаПисем.Количество() > 0 Тогда
		КлючСохраненияПоложенияОкна = "Вопрос";
	Иначе
		КлючСохраненияПоложенияОкна = "Пакет";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытии_ПослеПолученияКонтекста", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПисем

&НаКлиенте
Процедура ТаблицаПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.ТаблицаПисем.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, Элементы.ТаблицаПисем.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	ИзменитьПометки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	ИзменитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	Изменено = ИзменитьТипПисем();
	Результат = Неопределено;
	
	Если Изменено <> Неопределено Тогда
		Результат = Новый Структура;
		Результат.Вставить("Ссылки", Изменено);
		Если РежимИзменения = "Рассылка" Тогда
			Результат.Вставить("ИмяРаздела", "ВходящиеРассылка");
		Иначе
			Результат.Вставить("ИмяРаздела", "Входящие");
		КонецЕсли;
		Закрыть();
	КонецЕсли;

	Оповестить("Смена категории отчета", Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытии_ПослеПолученияКонтекста(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если ТаблицаПисем.Количество() = 1 Тогда
		Изменить(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьФорму()
	
	ГруппаСтраницы = Элементы.ГруппаСтраницы;
	ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	ТекстЗаголовка = НСтр("ru = 'Пометить %1 как'") + " " 
					+ ?(РежимИзменения = "Рассылка", НСтр("ru = 'рассылку'"), НСтр("ru = 'письмо'"))
					+ " " + НСтр("ru = 'от ПФР'");
					
	Элементы.ТаблицаПисем.Видимость = Ложь;
	
	Если ТаблицаПисем.Количество() = 0 Тогда
		Элементы.Изменить.Видимость = Ложь;
		ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибка;
		
	ИначеЕсли ТаблицаПисем.Количество() = 1 Тогда
		ТекущееПредставление = "<b>" + ПредставлениеПисьма(ТаблицаПисем[0].Ссылка) + "</b>";
		ТекущееПредставление = СтроковыеФункции.ФорматированнаяСтрока(ТекстЗаголовка + Символы.ПС, ТекущееПредставление);
		Элементы.ДекорацияВопрос.Заголовок = ТекущееПредставление;
		Элементы.Изменить.Видимость = Ложь;
		ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВопрос;
		
	Иначе
		ТекущееПредставление = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru=';%1 элемент;;%1 элемента;%1 элементов;%1 элементов'"),
								Формат(ТаблицаПисем.Количество(), "ЧЦ=5; ЧГ=0"));
		ТекущееПредставление = СтроковыеФункции.ФорматированнаяСтрока(ТекстЗаголовка, ТекущееПредставление);
		Элементы.ДекорацияВопрос.Заголовок = ТекущееПредставление;
		ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВопрос;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометки(ТекущееЗначение)
	
	Для Каждого СтрокаТаблицы Из ТаблицаПисем Цикл
		СтрокаТаблицы.Пометка = ТекущееЗначение;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПисем(МассивПисем)

	ТаблицаПисем.Очистить();
	
	Если НЕ ЗначениеЗаполнено(МассивПисем) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИСТИНА КАК Пометка,
	|	ЖурналОтправокВКонтролирующиеОрганы.Ссылка КАК Ссылка,
	|	ЦО.Ссылка КАК ЦиклОбмена,
	|	ЖурналОтправокВКонтролирующиеОрганы.ДатаСоздания КАК Дата,
	|	ЖурналОтправокВКонтролирующиеОрганы.Наименование КАК Наименование,
	|	ЖурналОтправокВКонтролирующиеОрганы.Организация КАК Организация,
	|	ЖурналОтправокВКонтролирующиеОрганы.КодКонтролирующегоОргана КАК КодКонтролирующегоОргана,
	|	ПОДСТРОКА(ЖурналОтправокВКонтролирующиеОрганы.Комментарий, 1, 200) КАК Комментарий
	|ИЗ
	|	РегистрСведений.ЖурналОтправокВКонтролирующиеОрганы КАК ЖурналОтправокВКонтролирующиеОрганы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЦиклыОбмена КАК ЦО
	|		ПО ЖурналОтправокВКонтролирующиеОрганы.Ссылка = ЦО.Предмет
	|ГДЕ
	|	ЖурналОтправокВКонтролирующиеОрганы.СтраницаЖурнала = ЗНАЧЕНИЕ(Перечисление.СтраницыЖурналаОтчетность.Входящие)
	|	И ЖурналОтправокВКонтролирующиеОрганы.Ссылка В(&СписокПисем)
	|	И ЦО.Тип = &ТипЦикла
	|	И (ЦО.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыЦикловОбмена.РассылкаПФР)
	|			ИЛИ ЦО.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыЦикловОбмена.НеформализованнаяПерепискаПФРВходящие))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Организация";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокПисем", МассивПисем);
	Если РежимИзменения = "Рассылка" Тогда
		Запрос.УстановитьПараметр("ТипЦикла", Перечисления.ТипыЦикловОбмена.НеформализованнаяПерепискаПФРВходящие);
	Иначе
		Запрос.УстановитьПараметр("ТипЦикла", Перечисления.ТипыЦикловОбмена.РассылкаПФР);
	КонецЕсли;
	
	ТаблицаПисем.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеПисьма(ТекущаяСсылка)
	
	ВсеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущаяСсылка, "ДатаСообщения, Отправитель, Получатель, Наименование", Истина);
	
	Результат = НСтр("ru = 'письмо'") + " " + ВсеРеквизиты.Наименование + " "
				+ НСтр("ru = 'от'") + " " + ВсеРеквизиты.Отправитель + " "
				+ НСтр("ru = 'для'") + " " + ВсеРеквизиты.Получатель + " "
				+ НСтр("ru = 'за'") + " " + Формат(ВсеРеквизиты.ДатаСообщения, "ДФ=dd.MM.yy");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИзменитьТипПисем()
	
	МассивСсылок = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ТаблицаПисем Цикл
		
		Если НЕ СтрокаТаблицы.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			МассивСсылок.Добавить(Новый Структура("Организация, Ссылка", СтрокаТаблицы.Организация, СтрокаТаблицы.Ссылка));
			ОбъектЦиклаОбмена = СтрокаТаблицы.ЦиклОбмена.ПолучитьОбъект();
			Если РежимИзменения = "Рассылка" Тогда
				ОбъектЦиклаОбмена.Тип = Перечисления.ТипыЦикловОбмена.РассылкаПФР;
			Иначе
				ОбъектЦиклаОбмена.Тип = Перечисления.ТипыЦикловОбмена.НеформализованнаяПерепискаПФРВходящие;
			КонецЕсли;
			ОбъектЦиклаОбмена.Записать();
		Исключение
			МассивСсылок.Очистить();
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при записи цикла обмена: %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Электронный документооборот с контролирующими органами. Цикл обмена'",
					ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,
				СтрокаТаблицы.ЦиклОбмена,
				ТекстОшибки);
			Сообщить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Прервать;
		КонецПопытки;
	КонецЦикла;
	
	Если МассивСсылок.Количество() = 0 Тогда
		Результат = Неопределено;
	Иначе
		Результат = МассивСсылок;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти