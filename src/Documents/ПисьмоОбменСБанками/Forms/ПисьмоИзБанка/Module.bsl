
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивФайлов = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Объект.Ссылка, МассивФайлов);
	Для каждого ЭлементКоллекции Из МассивФайлов Цикл
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементКоллекции, "ПометкаУдаления") Тогда
			Продолжить;
		КонецЕсли;
		НовСтрока = ПрисоединенныеФайлыТаблица.Добавить();
		НовСтрока.Ссылка = ЭлементКоллекции;
	КонецЦикла;
		
	ИспользуетсяКриптография = Ложь;
	
	НастройкаОбмена = ОбменСБанкамиСлужебный.НастройкаОбмена(Объект.Организация, Объект.Банк, Ложь);
	Если ЗначениеЗаполнено(НастройкаОбмена) Тогда
		РеквизитыНастройкиОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			НастройкаОбмена, "ИспользуетсяКриптография, ПрограммаБанка");
		ИспользуетсяКриптография = РеквизитыНастройкиОбмена.ИспользуетсяКриптография;
		ПрограммаБанка = РеквизитыНастройкиОбмена.ПрограммаБанка;
		Если ПрограммаБанка = Перечисления.ПрограммыБанка.АсинхронныйОбмен Тогда
			Элементы.ДляВалютногоКонтроля.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Основание) Тогда
		Элементы.Основание.Видимость = Ложь;
	КонецЕсли;

	Элементы.ФормаПоказатьПодписи.Видимость = ИспользуетсяКриптография;
	
	Если Объект.Прочитано Тогда
		Элементы.ФормаПрочитано.Пометка = Истина;
	КонецЕсли;
	
	Если ПрисоединенныеФайлыТаблица.Количество() = 0 Тогда
		Элементы.СохранитьФайлыНаДиск.Доступность = Ложь;
	КонецЕсли;
	
	Если Не ОбменСБанкамиСлужебный.ПравоОбработкиЭД() Тогда
		Элементы.ФормаОтветить.Доступность = Ложь;
		Элементы.ФормаПрочитано.Доступность = Ложь;
		Элементы.ФормаЗаписать.Доступность = Ложь;
	КонецЕсли;
	
	ОформитьСсылкуНаПереписку();
	
	// СтандартныеПодсистемы.Печать
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеОбменСБанками" Тогда
	
		ОформитьСсылкуНаПереписку();
	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПерепискаНажатие(Элемент)

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация", Объект.Организация);
	ПараметрыОткрытия.Вставить("Банк", Объект.Банк);
	ПараметрыОткрытия.Вставить("ИдентификаторПереписки", Объект.ИдентификаторПереписки);
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.Переписка",
		ПараметрыОткрытия, , , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрисоединенныеФайлы

&НаКлиенте
Процедура ПрисоединенныеФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
		РаботаСФайламиКлиент.ОткрытьФормуФайла(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;

	// Обход ошибки проверки конфигурации
	Если Ложь Тогда
		Подключаемый_ВыполнитьКоманду(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИнформациюДляТехническойПоддержки(Команда)
	
	СсылкаНаФайл = Неопределено; ИмяФайла = Неопределено;
	ПолучитьФайлДляТехническойПоддержки(Объект.Ссылка, УникальныйИдентификатор, СсылкаНаФайл, ИмяФайла);
	
	Если СсылкаНаФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, СсылкаНаФайл, ИмяФайла);

КонецПроцедуры

&НаКлиенте
Процедура Прочитано(Команда)
	
	УстановитьПризнакПрочитано();
	Элементы.ФормаПрочитано.Пометка = Не Элементы.ФормаПрочитано.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодписи(Команда)
	
	ПараметрыФормы = Новый Структура("Объект", Объект.Ссылка);
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.Подписи", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Ответить(Команда)
	
	ПараметрыФормы = Новый Структура("ЗначениеЗаполнения", Объект.Ссылка);
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.ПисьмоВБанк", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОформитьСсылкуНаПереписку()
	
	Если НЕ ЗначениеЗаполнено(Объект.ИдентификаторПереписки) Тогда
		Элементы.Переписка.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ПисьмоОбменСБанками.Ссылка) КАК Количество
	|ИЗ
	|	Документ.ПисьмоОбменСБанками КАК ПисьмоОбменСБанками
	|ГДЕ
	|	ПисьмоОбменСБанками.Организация = &Организация
	|	И ПисьмоОбменСБанками.Банк = &Банк
	|	И ПисьмоОбменСБанками.ИдентификаторПереписки = &ИдентификаторПереписки
	|	И ПисьмоОбменСБанками.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбменСБанками.Получен), ЗНАЧЕНИЕ(Перечисление.СтатусыОбменСБанками.Отправлен))";
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Банк", Объект.Банк);
	Запрос.УстановитьПараметр("ИдентификаторПереписки", Объект.ИдентификаторПереписки);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество > 1 Тогда
		ШаблонСсылки = НСтр("ru = 'Переписка (%1)'");
		Элементы.Переписка.Заголовок = СтрШаблон(ШаблонСсылки, Выборка.Количество);
	Иначе
		Элементы.Переписка.Видимость = Ложь;
	КонецЕсли;
		
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакПрочитано()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Прочитано = Не ДокументОбъект.Прочитано;
	ДокументОбъект.Записать();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлыНаДиск(Команда)
	
	МассивСсылок = Новый Массив;
	Для каждого ЭлементКоллекции Из ПрисоединенныеФайлыТаблица Цикл
		МассивСсылок.Добавить(ЭлементКоллекции.Ссылка);
	КонецЦикла;
	
	ПолучаемыеФайлы = ПолучаемыеФайлы(МассивСсылок, УникальныйИдентификатор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения;
	
	ФайловаяСистемаКлиент.СохранитьФайлы(ОписаниеОповещения, ПолучаемыеФайлы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьФайлДляТехническойПоддержки(Знач Письмо, Знач УникальныйИдентификатор, СсылкаНаФайл, ИмяФайла)
	
	СообщениеОбмена = ОбменСБанкамиСлужебный.СообщениеОбменаПоВладельцу(Письмо);
	
	Если Не ЗначениеЗаполнено(СообщениеОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Не найден электронный документ'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанныеФайла = ОбменСБанкамиСлужебный.ДанныеФайлаДляТехническойПоддержки(СообщениеОбмена);
	
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружен присоединенный файл объекта.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СообщениеОбмена);
		Возврат;
	КонецЕсли;
	
	ИмяФайла = Строка(СообщениеОбмена);
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла) + ".zip";
	ИмяФайла = СтроковыеФункции.СтрокаЛатиницей(ИмяФайла);
	
	СсылкаНаФайл = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучаемыеФайлы(Знач МассивСсылок, Знач УникальныйИдентификатор)
	
	МассивВозврата = Новый Массив;
	Для каждого ЭлементКоллекции Из МассивСсылок Цикл
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементКоллекции, УникальныйИдентификатор);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ДанныеФайла.ИмяФайла, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		МассивВозврата.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Возврат МассивВозврата;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


