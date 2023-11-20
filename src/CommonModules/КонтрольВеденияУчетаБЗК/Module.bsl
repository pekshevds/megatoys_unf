#Область СлужебныйПрограммныйИнтерфейс

// Доопределяет КонтрольВеденияУчета.ПриСозданииНаСервереФормыСписка, меняя значение
// КартинкаЗначений на коллекцию пиктограмм
// Для выводимой слева колонки с проблемой устанавливает значение ФиксацияВТаблице такое же
// как и у следующей колонки.
//
Процедура ПриСозданииНаСервереФормыСписка(Форма, ИменаСписков, ДополнительныеСвойства = Неопределено) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
	
	МодульКонтрольВеденияУчета.ПриСозданииНаСервереФормыСписка(Форма, ИменаСписков, ДополнительныеСвойства);
	
	Если Не МодульКонтрольВеденияУчета.ПодсистемаДоступна() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПоляИндикатораПроблем = Неопределено;
	Если ДополнительныеСвойства <> Неопределено Тогда
		ДополнительныеСвойства.Свойство("ИмяПоляИндикатораПроблем", ИмяПоляИндикатораПроблем);
	КонецЕсли;
	
	СписокИмен = СтрРазделить(ИменаСписков, ",");
	Для Каждого ИмяСписка Из СписокИмен Цикл
		
		ТаблицаФормы = Форма.Элементы.Найти(СокрЛП(ИмяСписка));
		Если ТаблицаФормы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущийСписок   = Форма[ТаблицаФормы.ПутьКДанным];
		ОсновнаяТаблица = ТекущийСписок.ОсновнаяТаблица;
		Если Не ЗначениеЗаполнено(ОсновнаяТаблица) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыКолонкиИндикации = Новый Структура;
		
		МодульКонтрольВеденияУчетаСлужебный = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчетаСлужебный");
		МодульКонтрольВеденияУчетаПереопределяемый = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчетаПереопределяемый");
		
		МодульКонтрольВеденияУчетаСлужебный.ПриОпределенииПараметровКолонкиИндикации(ПараметрыКолонкиИндикации, ОсновнаяТаблица);
		МодульКонтрольВеденияУчетаПереопределяемый.ПриОпределенииПараметровКолонкиИндикации(ПараметрыКолонкиИндикации, ОсновнаяТаблица);
		
		Если ИмяПоляИндикатораПроблем = Неопределено Тогда
			ИмяКолонки = "ИндикаторОшибки_" + ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Форма.ИмяФормы + ПолучитьРазделительПути() + ИмяСписка);
		Иначе
			ИмяКолонки = ИмяПоляИндикатораПроблем;
		КонецЕсли;
		
		КолонкаИндикаторОшибки = Форма.Элементы.Найти(ИмяКолонки);
		Если КолонкаИндикаторОшибки <> Неопределено Тогда
			
			КолонкаИндикаторОшибки.КартинкаЗначений = БиблиотекаКартинок["КоллекцияВажностейПроблем"];
			Если Не ПараметрыКолонкиИндикации.ВыводитьПоследней Тогда
				
				ТаблицаФормы = КолонкаИндикаторОшибки.Родитель;
				Если ТаблицаФормы <> Неопределено Тогда
					
					Если ТаблицаФормы.ПодчиненныеЭлементы.Количество() > 1 Тогда
						КолонкаИндикаторОшибки.ФиксацияВТаблице = ТаблицаФормы.ПодчиненныеЭлементы[1].ФиксацияВТаблице;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Переопределяет работу КонтрольВеденияУчета.ПриЧтенииНаСервере, заменяя единственное сообщение
// о наличии проблем на несколько детальных.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
	
	МодульКонтрольВеденияУчета.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
	Если Не МодульКонтрольВеденияУчета.ПодсистемаДоступна() Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыУправляемойФормы = Форма.Элементы;
	СсылкаНаОбъект = ТекущийОбъект.Ссылка;
	
	КлючУникальностиИмен = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(СсылкаНаОбъект.Метаданные().ПолноеИмя()
		+ ПолучитьРазделительПути() + Форма.ИмяФормы);
	
	ДекорацияГруппа = ЭлементыУправляемойФормы.Найти("ГруппаИндикатораОшибки_" + КлючУникальностиИмен);
	Если ДекорацияГруппа <> Неопределено Тогда
		
		Пока ДекорацияГруппа.ПодчиненныеЭлементы.Количество() > 0 Цикл
			ЭлементыУправляемойФормы.Удалить(ДекорацияГруппа.ПодчиненныеЭлементы[0]);
		КонецЦикла;
		
		ДобавляемыеРеквизитыФормы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			Новый РеквизитФормы("ОбработчикиИсправленияПроблем", Новый ОписаниеТипов()));
		
		МассивИменРеквизитовФормы = Новый Массив;
		ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы);
		ЗарплатаКадры.ИзменитьРеквизитыФормы(Форма, ДобавляемыеРеквизитыФормы, МассивИменРеквизитовФормы);
		
		ОбработчикиИсправленияПроблем = Новый Соответствие;
		
		ТаблицаПроблем = ПроблемыОбъекта(СсылкаНаОбъект);
		МодульКонтрольВеденияУчетаСлужебныйПовтИсп = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйПовтИсп");
		ПроверкиВеденияУчета = МодульКонтрольВеденияУчетаСлужебныйПовтИсп.ПроверкиВеденияУчета();
		
		Для НомерПроблемы = 1 По ТаблицаПроблем.Количество() Цикл
			
			ИменаЭлементовФормыПоПроблемы = Новый Структура;
			ИменаЭлементовФормыПоПроблемы.Вставить("ИмяГруппы", ДекорацияГруппа.Имя + "_" + НомерПроблемы);
			ИменаЭлементовФормыПоПроблемы.Вставить("ИмяКартинки", ИменаЭлементовФормыПоПроблемы.ИмяГруппы + "_Картинка");
			ИменаЭлементовФормыПоПроблемы.Вставить("ИмяНадписи", ИменаЭлементовФормыПоПроблемы.ИмяГруппы + "_Надпись");
			
			Если НомерПроблемы < 3 Или ТаблицаПроблем.Количество() < 4 Тогда
				
				СтрокаПроблемы = ТаблицаПроблем[НомерПроблемы - 1];
				
				СтруктураПоиска = Новый Структура("Идентификатор", СтрокаПроблемы.ПравилоПроверкиИдентификатор);
				СтрокиПроверки = ПроверкиВеденияУчета.Проверки.НайтиСтроки(СтруктураПоиска);
				Если СтрокиПроверки.Количество() > 0 Тогда
					
					ОбработчикПереходаКИсправлению = СтрокиПроверки[0].ОбработчикПереходаКИсправлению;
					
					СтруктураРасшифровки = Новый Структура;
					
					СтруктураРасшифровки.Вставить("Назначение",                     "ИсправитьПроблемы");
					СтруктураРасшифровки.Вставить("ИдентификаторПроверки",          СтрокаПроблемы.ПравилоПроверкиИдентификатор);
					СтруктураРасшифровки.Вставить("ОбработчикПереходаКИсправлению", ОбработчикПереходаКИсправлению);
					СтруктураРасшифровки.Вставить("ВидПроверки",                    СтрокаПроблемы.ВидПроверки);
					
					ОбработчикиИсправленияПроблем.Вставить(ИменаЭлементовФормыПоПроблемы.ИмяНадписи, СтруктураРасшифровки);
					
				КонецЕсли;
				
				РазметитьОписаниеПроблемы(
					ЭлементыУправляемойФормы, ДекорацияГруппа, ИменаЭлементовФормыПоПроблемы,
					СтрокаПроблемы.ВажностьПроблемы, СтрокаПроблемы.УточнениеПроблемы, "");
				
			Иначе
				
				ОставшеесяКоличествоПроблем = ТаблицаПроблем.Количество() - 2;
				
				УточнениеПроблемы = Новый ФорматированнаяСтрока(СтрШаблон(НСтр("ru='Еще проблемы (%1)'"), ОставшеесяКоличествоПроблем), , , , "Основной");
				РазметитьОписаниеПроблемы(ЭлементыУправляемойФормы, ДекорацияГруппа, ИменаЭлементовФормыПоПроблемы,
					Перечисления["ВажностьПроблемыУчета"].ВажнаяИнформация, УточнениеПроблемы, "Подключаемый_ОткрытьОтчетПоПроблемам");
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТаблицаПроблем.Количество() < 4 Тогда
			
			ДекорацияНадпись = ЭлементыУправляемойФормы.Добавить(ДекорацияГруппа.Имя + "_Отчет", Тип("ДекорацияФормы"), ДекорацияГруппа);
			ДекорацияНадпись.Вид                          = ВидДекорацииФормы.Надпись;
			ДекорацияНадпись.Заголовок                    = Новый ФорматированнаяСтрока(НСтр("ru='Отчет по проблемам'"),,,, "Основной");
			ДекорацияНадпись.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Низ;
			ДекорацияНадпись.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОткрытьОтчетПоПроблемам");
			
		КонецЕсли;
		
		Форма.ОбработчикиИсправленияПроблем = Новый ФиксированноеСоответствие(ОбработчикиИсправленияПроблем);
		
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет работу обработчика (КонтрольВеденияУчета.ПриПолученииДанныхНаСервере), устанавливая значениям
// колонок с проблемами порядок самой "страшной" проблемы, учитывает, что ключи динамического списка могут быть
// более разнообразными чем одно поле (но записи при этом остаются уникальными в пределах одного из реквизитов
// ключа).
//
Процедура ПриПолученииДанныхНаСервере(Настройки, Строки, ИмяКлючевогоПоля = "Ссылка", ДополнительныеСвойства = Неопределено) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
	
	ИмяПроцедуры = "КонтрольВеденияУчета.ПриПолученииДанныхНаСервере";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Настройки", Настройки, Тип("НастройкиКомпоновкиДанных"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Строки", Строки, Тип("СтрокиДинамическогоСписка"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ИмяКлючевогоПоля", ИмяКлючевогоПоля, Тип("Строка"));
	Если ДополнительныеСвойства <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ДополнительныеСвойства", ДополнительныеСвойства, Тип("Структура"));
	КонецЕсли;
	
	Если Не МодульКонтрольВеденияУчета.ПодсистемаДоступна() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойстваКомпоновщика = Настройки.ДополнительныеСвойства;
	Если ДополнительныеСвойстваКомпоновщика.Свойство("КолонкаИндикатора") Тогда
		
		КолонкаИндикатора = Настройки.ДополнительныеСвойства.КолонкаИндикатора;
		
		Если ИмяКлючевогоПоля = "Ссылка" Тогда
			ЗначенияКлючей = Строки.ПолучитьКлючи();
			КлючСсылка = Истина;
		Иначе
			НачальныеКлючи = Строки.ПолучитьКлючи();
			КлючСсылка = ОбщегоНазначения.ЭтоСсылка(Тип(НачальныеКлючи[0]));
			ЗначенияКлючей     = Новый Массив;
			Для Каждого НачальныйКлюч Из НачальныеКлючи Цикл
				ЗначенияКлючей.Добавить(НачальныйКлюч[ИмяКлючевогоПоля]);
			КонецЦикла;
		КонецЕсли;
		
		ПроблемныеОбъекты = ПроблемныеОбъекты(ЗначенияКлючей);
		
		Для Каждого КлючСтроки Из ЗначенияКлючей Цикл
			
			Если КлючСсылка Тогда
				СписокСтрок = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Строки[КлючСтроки]);
			Иначе
				
				СписокСтрок = Новый Массив;
				Для Каждого СтрокаСписка Из Строки Цикл
					
					Если СтрокаСписка.Ключ[ИмяКлючевогоПоля] = КлючСтроки Тогда
						СписокСтрок.Добавить(СтрокаСписка.Значение);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Если СписокСтрок.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого СтрокаСписка Из СписокСтрок Цикл
				
				Если Не СтрокаСписка.Данные.Свойство(КолонкаИндикатора) Тогда
					Продолжить;
				КонецЕсли;
				
				ТекстЯчейки = СтрокаСписка.Оформление.Получить(КолонкаИндикатора).НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Текст"));
				
				ВажностьПроблемы = ПроблемныеОбъекты.Получить(КлючСтроки);
				Если ВажностьПроблемы = Неопределено Тогда
					СтрокаСписка.Данные[КолонкаИндикатора] = 0;
					Если ТекстЯчейки <> Неопределено Тогда
						ТекстЯчейки.Значение = 0;
					КонецЕсли;
				Иначе
					СтрокаСписка.Данные[КолонкаИндикатора] = ВажностьПроблемы + 1;
					Если ТекстЯчейки <> Неопределено Тогда
						ТекстЯчейки.Значение = 1;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// После записи очищает список проблем у первой из проблем делает уточнение "Ожидает проверки"
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	ПеревестиВРежимОжиданияПроверки = Истина;
	
	МетаданныеОбъекта = ТекущийОбъект.Метаданные();
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		
		Если МетаданныеОбъекта.Проведение <> Метаданные.СвойстваОбъектов.Проведение.Запретить Тогда
			
			Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
				ПеревестиВРежимОжиданияПроверки = Ложь;
			ИначеЕсли Не ТекущийОбъект.Проведен И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
				ПеревестиВРежимОжиданияПроверки = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПеревестиВРежимОжиданияПроверки Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Набор = РегистрыСведений["РезультатыПроверкиУчета"].СоздатьНаборЗаписей();
		Набор.Отбор.ПроблемныйОбъект.Установить(ТекущийОбъект.Ссылка);
		Набор.Отбор.ИгнорироватьПроблему.Установить(Ложь);
		Набор.Прочитать();
		
		Если Набор.Количество() > 0 Тогда
			
			ТаблицаНабора = Набор.Выгрузить();
			ТаблицаНабора[0].УточнениеПроблемы = НСтр("ru='Ожидает проверки ...'");
			ТаблицаНабора[0].ВажностьПроблемы = Перечисления["ВажностьПроблемыУчета"].Информация;
			
			Набор.Загрузить(ТаблицаНабора.Скопировать(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТаблицаНабора[0])));
			Набор.Записать();
			
			ПриЧтенииНаСервере(Форма, ТекущийОбъект);
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// См. КонтрольВеденияУчета.ЗаписатьПроблему
Процедура ЗаписатьПроблему(Проблема, ПараметрыПроверки = Неопределено) Экспорт
	
	МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
	Попытка
		МодульКонтрольВеденияУчета.ЗаписатьПроблему(Проблема, ПараметрыПроверки);
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Контроль ведения учета'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Служебный метод, возвращает соответствие проблемный объект - минимальный порядок важности
//
Функция ПроблемныеОбъекты(КлючиСтрок)
	
	ТекущийПользовательПолноправный = Пользователи.ЭтоПолноправныйПользователь();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РезультатыПроверкиУчета.ПроблемныйОбъект КАК ПроблемныйОбъект,
	|	ЕСТЬNULL(МИНИМУМ(РезультатыПроверкиУчета.ВажностьПроблемы.Порядок), 0) КАК ВажностьПроблемыПорядок
	|ИЗ
	|	РегистрСведений.РезультатыПроверкиУчета КАК РезультатыПроверкиУчета
	|ГДЕ
	|	РезультатыПроверкиУчета.ПроблемныйОбъект В(&СписокОбъектов)
	|	И НЕ РезультатыПроверкиУчета.ИгнорироватьПроблему
	|
	|СГРУППИРОВАТЬ ПО
	|	РезультатыПроверкиУчета.ПроблемныйОбъект");
	Запрос.УстановитьПараметр("СписокОбъектов", КлючиСтрок);
	
	Если Не ТекущийПользовательПолноправный Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ПроблемныеОбъекты = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПроблемныеОбъекты.Вставить(Выборка.ПроблемныйОбъект, Выборка.ВажностьПроблемыПорядок);
	КонецЦикла;
	
	Если Не ТекущийПользовательПолноправный Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ПроблемныеОбъекты;
	
КонецФункции

Функция ПроблемыОбъекта(ПроблемныйОбъект)
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("КонтрольВеденияУчета.КоличествоПроблемПоОбъекту", "ПроблемныйОбъект",
		ПроблемныйОбъект, ОбщегоНазначения.ОписаниеТипаВсеСсылки());
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РезультатыПроверкиУчета.УточнениеПроблемы КАК УточнениеПроблемы,
		|	РезультатыПроверкиУчета.ВажностьПроблемы КАК ВажностьПроблемы,
		|	РезультатыПроверкиУчета.Выявлено КАК Выявлено,
		|	РезультатыПроверкиУчета.Ответственный КАК Ответственный,
		|	РезультатыПроверкиУчета.ВидПроверки КАК ВидПроверки,
		|	РезультатыПроверкиУчета.ПравилоПроверки КАК ПравилоПроверки,
		|	РезультатыПроверкиУчета.ПравилоПроверки.Идентификатор КАК ПравилоПроверкиИдентификатор
		|ИЗ
		|	РегистрСведений.РезультатыПроверкиУчета КАК РезультатыПроверкиУчета
		|ГДЕ
		|	РезультатыПроверкиУчета.ПроблемныйОбъект = &ПроблемныйОбъект
		|	И НЕ РезультатыПроверкиУчета.ИгнорироватьПроблему
		|
		|УПОРЯДОЧИТЬ ПО
		|	РезультатыПроверкиУчета.ВажностьПроблемы.Порядок,
		|	Выявлено";
	
	Запрос.УстановитьПараметр("ПроблемныйОбъект", ПроблемныйОбъект);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса;
	
КонецФункции

Процедура РазметитьОписаниеПроблемы(ЭлементыУправляемойФормы, ДекорацияГруппа, ИменаЭлементовФормыПоПроблемы, ВажностьПроблемы, УточнениеПроблемы, ОбработчикПереходаКИсправлению)
	
	ГруппаИндикатораОшибки = ЭлементыУправляемойФормы.Добавить(ИменаЭлементовФормыПоПроблемы.ИмяГруппы, Тип("ГруппаФормы"), ДекорацияГруппа);
	ГруппаИндикатораОшибки.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаИндикатораОшибки.ОтображатьЗаголовок      = Ложь;
	ГруппаИндикатораОшибки.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаИндикатораОшибки.РастягиватьПоГоризонтали = Истина;
	ГруппаИндикатораОшибки.ЦветФона                 = ЦветаСтиля.ФонУправляющегоПоля;
	
	Если ВажностьПроблемы = Перечисления["ВажностьПроблемыУчета"].Ошибка Тогда
		КартинкаИндикатораПроблем = БиблиотекаКартинок["Ошибка32"];
	ИначеЕсли ВажностьПроблемы = Перечисления["ВажностьПроблемыУчета"].Предупреждение Тогда
		КартинкаИндикатораПроблем = БиблиотекаКартинок["Предупреждение32"];
	ИначеЕсли ВажностьПроблемы = Перечисления["ВажностьПроблемыУчета"].ВажнаяИнформация Тогда
		КартинкаИндикатораПроблем = БиблиотекаКартинок["ВажнаяИнформация32"];
	ИначеЕсли ВажностьПроблемы = Перечисления["ВажностьПроблемыУчета"].ПолезныйСовет Тогда
		КартинкаИндикатораПроблем = БиблиотекаКартинок["ПолезныйСовет32"];
	Иначе
		КартинкаИндикатораПроблем = БиблиотекаКартинок["Информация32"];
	КонецЕсли;
	
	КартинкаИндикаторОшибки = ЭлементыУправляемойФормы.Добавить(ИменаЭлементовФормыПоПроблемы.ИмяКартинки, Тип("ДекорацияФормы"), ГруппаИндикатораОшибки);
	КартинкаИндикаторОшибки.Вид            = ВидДекорацииФормы.Картинка;
	КартинкаИндикаторОшибки.Картинка       = КартинкаИндикатораПроблем;
	КартинкаИндикаторОшибки.РазмерКартинки = РазмерКартинки.РеальныйРазмер;
	
	ДекорацияНадпись = ЭлементыУправляемойФормы.Добавить(ИменаЭлементовФормыПоПроблемы.ИмяНадписи, Тип("ДекорацияФормы"), ГруппаИндикатораОшибки);
	ДекорацияНадпись.Вид                   = ВидДекорацииФормы.Надпись;
	ДекорацияНадпись.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Центр;
	
	Если ЗначениеЗаполнено(ОбработчикПереходаКИсправлению) Тогда
		
		ДекорацияНадпись.Заголовок = Новый ФорматированнаяСтрока(УточнениеПроблемы, Символы.ПС,
			Новый ФорматированнаяСтрока(НСтр("ru='Исправить'") , , , , "Основной"));
		
		ДекорацияНадпись.УстановитьДействие("ОбработкаНавигационнойСсылки", ОбработчикПереходаКИсправлению);
		
	Иначе
		ДекорацияНадпись.Заголовок = УточнениеПроблемы;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПроверку(ИдентификаторПравилаПроверки, ПроверяемыеОбъекты) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	МодульКонтрольВеденияУчета = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчета");
	ПравилоПроверки = МодульКонтрольВеденияУчета.ПроверкаПоИдентификатору(ИдентификаторПравилаПроверки);
	Если Не ЗначениеЗаполнено(ПравилоПроверки) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыПроверки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПравилоПроверки, "ЭтоГруппа,Использование");
	Если РеквизитыПроверки.ЭтоГруппа Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Родитель", ПравилоПроверки);
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ПравилаПроверкиУчета.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ПравилаПроверкиУчета КАК ПравилаПроверкиУчета
			|ГДЕ
			|	НЕ ПравилаПроверкиУчета.ЭтоГруппа
			|	И ПравилаПроверкиУчета.Родитель В ИЕРАРХИИ(&Родитель)
			|	И ПравилаПроверкиУчета.Использование";
		ПравилаПроверки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Если Не РеквизитыПроверки.Использование Тогда
			Возврат;
		КонецЕсли;
		ПравилаПроверки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПравилоПроверки);
	КонецЕсли;
	
	Для Каждого ПравилоПроверки Из ПравилаПроверки Цикл
		МодульКонтрольВеденияУчета.ВыполнитьПроверку(ПравилоПроверки, , ПроверяемыеОбъекты);
	КонецЦикла;
	
КонецПроцедуры

Функция КоличествоПроблемПоОбъекту(ПроблемныйОбъект, ИдентификаторыИсключаемыхПравилГруппы = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("КонтрольВеденияУчета.КоличествоПроблемПоОбъекту", "ПроблемныйОбъект",
		ПроблемныйОбъект, ОбщегоНазначения.ОписаниеТипаВсеСсылки());
	
	Если ТипЗнч(ИдентификаторыИсключаемыхПравилГруппы) = Тип("Массив") Тогда
		ИсключаемыеИдентифкаторы = ИдентификаторыИсключаемыхПравилГруппы;
	ИначеЕсли ТипЗнч(ИдентификаторыИсключаемыхПравилГруппы) = Тип("Строка") Тогда
		ИсключаемыеИдентифкаторы = СтрРазделить(ИдентификаторыИсключаемыхПравилГруппы, ",", Ложь);
	Иначе
		ИсключаемыеИдентифкаторы = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	РегистрСведений.РезультатыПроверкиУчета КАК РезультатыПроверкиУчета
	|ГДЕ
	|	РезультатыПроверкиУчета.ПроблемныйОбъект = &ПроблемныйОбъект
	|	И Не РезультатыПроверкиУчета.ПравилоПроверки.Идентификатор В (&ИсключаемыеИдентифкаторы)
	|	И НЕ РезультатыПроверкиУчета.ИгнорироватьПроблему");
	Запрос.УстановитьПараметр("ПроблемныйОбъект", ПроблемныйОбъект);
	Запрос.УстановитьПараметр("ИсключаемыеИдентифкаторы", ИсключаемыеИдентифкаторы);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	Возврат ?(Результат.Следующий(), Результат.Количество, 0); 
	
КонецФункции

#КонецОбласти
