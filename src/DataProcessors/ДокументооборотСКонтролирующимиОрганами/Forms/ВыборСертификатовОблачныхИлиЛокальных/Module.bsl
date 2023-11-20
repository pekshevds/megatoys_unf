#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Инициализация(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СпозиционироватьсяНаСертификате();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КоманднаяПанельФормыВыбрать(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КоманднаяПанельСертификатыПоказать(Команда = Неопределено)
	
	ПоказатьСертификат()

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыВыбрать(Кнопка)

	Если ЕстьОшибка() Тогда
		ПоказатьПредупреждение(, "Выберите сертификат!");
		Возврат;
	КонецЕсли;
	
	Если НЕ МножественныйВыбор Тогда
		ОставитьОдин();
	КонецЕсли;

	ВернутьСертификаты();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЕстьОшибка()
	
	ЕстьОшибка = Ложь;
	Если МножественныйВыбор Тогда
		ЕстьОшибка = ВыбраныеСтроки().Количество() = 0;
	Иначе
		ЕстьОшибка = Элементы.Сертификаты.ТекущиеДанные = Неопределено;
	КонецЕсли;
	
	Возврат ЕстьОшибка;
	
КонецФункции

&НаКлиенте
Функция ОставитьОдин()
	
	Для каждого Строка Из ВыбраныеСтроки() Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	ТекДанные.Пометка = Истина;
	
КонецФункции

&НаКлиенте
Функция ВыбраныеСтроки()
	
	Отбор = Новый Структура();
	Отбор.Вставить("Пометка", Истина);
	
	Возврат Сертификаты.НайтиСтроки(Отбор);
	
КонецФункции

&НаСервере
Процедура Инициализация(Параметры)
	
	ЗаполнитьТаблицу(Параметры);
	РасставитьФлаги(Параметры);
	
	МножественныйВыбор = Параметры.МножественныйВыбор;
	Элементы.СертификатыПометка.Видимость = МножественныйВыбор;
	
	ПредставлениеПояснения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Пояснение", "");
	Элементы.ДекорацияПояснение.Заголовок = ПредставлениеПояснения;
	Элементы.ГруппаПояснение.Видимость = ЗначениеЗаполнено(ПредставлениеПояснения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицу(Параметры)
	
	Адрес = Параметры.Адрес;
	
	ТаблицаНужныеСертификаты = ПолучитьИзВременногоХранилища(Адрес);
	Для каждого ТекущийСертфикат Из ТаблицаНужныеСертификаты Цикл
		НовыйСертификат = Сертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСертификат, ТекущийСертфикат);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РасставитьФлаги(Параметры)
	
	ПараметрСертификаты = Новый Массив;
	
	Если Параметры.Свойство("Сертификаты") Тогда
		ПараметрСертификаты = Параметры.Сертификаты;
	ИначеЕсли Параметры.Свойство("Отпечаток") Тогда
		ПараметрСертификаты.Добавить(Новый Структура("Отпечаток", Отпечаток));
	КонецЕсли;
	
	Для каждого Сертификат Из ПараметрСертификаты Цикл
		
		Отпечаток = Сертификат.Отпечаток; 
		
		Отбор = Новый Структура();
		Отбор.Вставить("Отпечаток", Отпечаток);
		
		НайденныеСтроки = Сертификаты.НайтиСтроки(Отбор);
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.Пометка = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСертификат()
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите в таблице сертификат для показа.'"));
	Иначе
		СертификатДляПоказа = Новый Структура();
		СертификатДляПоказа.Вставить("СерийныйНомер", ТекДанные.СерийныйНомер);
		СертификатДляПоказа.Вставить("Поставщик", ТекДанные.Поставщик);
		СертификатДляПоказа.Вставить("Отпечаток", ТекДанные.Отпечаток);
		КриптографияЭДКОКлиентСервер.ЗаполнитьМестоХраненияКлюча(ТекДанные.МестоХраненияКлюча, СертификатДляПоказа);
		КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПоказа);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СпозиционироватьсяНаСертификате()
	
	// активизируем начальные значения выбора
	НайденныеСтроки = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", Отпечаток));
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Элементы.Сертификаты.ТекущаяСтрока = НайденнаяСтрока.ПолучитьИдентификатор();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьСертификаты()
	
	ОтмеченныеСертификаты = ВыбраныеСтроки();
	ВыбранныеСертификаты   = Новый Массив;
	Для каждого Сертификат Из ОтмеченныеСертификаты Цикл
		ВыбранныеСертификаты.Добавить(СвойстваСертификата(Сертификат));
	КонецЦикла;
	
	Закрыть(ВыбранныеСертификаты);
	
КонецПроцедуры

&НаКлиенте
Функция СвойстваСертификата(ТекДанные)
	
	СвойстваСертификата = Новый Структура;
	СвойстваСертификата.Вставить("ДействителенС",			ТекДанные.ДействителенС);
	СвойстваСертификата.Вставить("ДействителенПо",			ТекДанные.ДействителенПо);
	СвойстваСертификата.Вставить("Отпечаток",				ТекДанные.Отпечаток);
	СвойстваСертификата.Вставить("Поставщик",				ТекДанные.Поставщик);
	СвойстваСертификата.Вставить("СерийныйНомер",			ТекДанные.СерийныйНомер);
	СвойстваСертификата.Вставить("Владелец",				ТекДанные.Владелец);
	СвойстваСертификата.Вставить("Наименование",			ТекДанные.Наименование);
	СвойстваСертификата.Вставить("ВозможностьПодписи",		ТекДанные.ПригоденДляПодписания);
	СвойстваСертификата.Вставить("ВозможностьШифрования",	ТекДанные.ПригоденДляШифрования);
	СвойстваСертификата.Вставить("ПоставщикСтруктура",		ТекДанные.ПоставщикСтруктура);
	СвойстваСертификата.Вставить("ВладелецСтруктура",		ТекДанные.ВладелецСтруктура);
	СвойстваСертификата.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса",	ТекДанные.ЭтоЭлектроннаяПодписьВМоделиСервиса);
	СвойстваСертификата.Вставить("МестоХраненияКлюча",		ТекДанные.МестоХраненияКлюча);
	
	Возврат СвойстваСертификата;
	
КонецФункции

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	Если МножественныйВыбор Тогда
		Элементы.Сертификаты.ТекущийЭлемент = Элементы.СертификатыПометка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

