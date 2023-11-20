#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьДанныеФормы();
	
	СписокЭлементов = Новый Структура;
	СписокЭлементов.Вставить("ПодтверждениеПароль", "ПодтверждениеПароль");
	СписокЭлементов.Вставить("ГруппаПодтвержденияОписание", "ГруппаПодтвержденияОписание");
	СписокЭлементов.Вставить("ГруппаПодтвержденияВыбор", "ГруппаПодтвержденияВыбор");
	
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("ЕстьРазделители", Ложь);
	ПараметрыОперации.Вставить("КонвертироватьИмена", Ложь);
	ПараметрыОперации.Вставить("ИменаЭлементовФормы", СписокЭлементов);
	
	МодульСервисКриптографииDSSПодтверждениеСервер = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSПодтверждениеСервер");
	МодульСервисКриптографииDSSПодтверждениеСервер.ПодготовитьГруппуПодтверждения(ЭтотОбъект, "Аутентификация",
			"ГруппаПодтверждения",
			"ГруппаКонтейнерПервый",
			"ГруппаАнимации",
			"ГруппаКомандыПодтверждения",
			ПараметрыОперации);
	
	ПодготовитьНачальнуюФорму();

	Элементы.ПодтверждениеПароль.ПодсказкаВвода = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПрограммноеЗакрытие = Ложь;
	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриОткрытии(ЭтотОбъект, Ложь, Истина);
	
	ЭлементФормы = Элементы.Найти("ПодтверждениеСпособПодтверждения");
	Если ЭлементФормы <> Неопределено Тогда
		ЭлементФормы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ПрограммноеЗакрытие Тогда
		ЗакрытьФорму(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("ПодтверждениеВыполнитьОсновнуюОперацию") И Источник = УникальныйИдентификатор Тогда
		Если Параметр.Выполнено Тогда
			Если СоздатьУчетнуюЗаписьОблачнойПодписи() Тогда
				ЗакрытьФорму(УчетнаяЗаписьОблачнойПодписи);
			КонецЕсли;
		Иначе
			Элементы.ГруппаАнимации.Видимость = Ложь;
			Элементы.ГруппаПодтвержденияОписание.Видимость = Ложь;
		КонецЕсли;
		Элементы.Восстановить.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СерверОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработкаКоманды(Команда)
	
	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеОбработкаКоманды(ЭтотОбъект, Команда, Неопределено, "");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеОбработкаНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодтверждениеПриИзменении(Элемент)

	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеПриИзменении(ЭтотОбъект, Элемент, Неопределено, "");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработчикОжидания()
	
	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеОбработкаОжидания(ЭтотОбъект, Неопределено, "");

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодтверждениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	МодульСервисКриптографииDSSПодтверждениеКлиент.ПодтверждениеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Восстановить(Команда)
	
	Если НЕ ПроверкаВыбранныхНастроек() Тогда
		Возврат;
	КонецЕсли;
	
	МодульСервисКриптографииDSSПодтверждениеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSПодтверждениеКлиент");
	Если МодульСервисКриптографииDSSПодтверждениеКлиент.ПроверитьЗапущенныйЦиклПодтверждения(ЭтотОбъект) Тогда 
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Обнаружено, что операция подтверждения не окончена.'"));
	Иначе
		ДополнитьНастройкиПользователя();
		МодульСервисКриптографииDSSПодтверждениеКлиент.ВыполнитьНачальнуюОперациюСервиса(ЭтотОбъект, Неопределено, "");
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьНачальнуюФорму()
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("ТипПодтверждения", "Аутентификация");
	
	ЭтотОбъект.НастройкиПользователя.Пароль = ПарольЛогина;
	МодульСервисКриптографииDSSПодтверждениеСервер = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSПодтверждениеСервер");
	МодульСервисКриптографииDSSПодтверждениеСервер.ДополнитьПроизвольноеПодтверждение(ЭтотОбъект,
			НСтр("ru = 'Подтверждение учетной записи'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			"Первичный_ДвухФакторная", 
			"",
			ЛогинВосстановления,
			ПараметрыОперации);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанныеФормы()
	
	ЛогинВосстановления = Параметры.Логин;
	СерверОблачнойПодписи = Параметры.СерверОблачнойПодписи;
	
	СписокВыбора = Элементы.Сервер.СписокВыбора;
	СписокВыбора.Очистить();
	
	Для Каждого СтрокаМассива Из Параметры.СписокСерверов Цикл
		НоваяСтрока = ТаблицаСервисов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаМассива);
		СписокВыбора.Добавить(НоваяСтрока.ВнутреннийИдентификатор, НоваяСтрока.Представление);
	КонецЦикла;
		
	Если ТаблицаСервисов.Количество() = 1 Тогда
		 СерверОблачнойПодписи = ТаблицаСервисов[0].ВнутреннийИдентификатор;
		 Элементы.Сервер.ТолькоПросмотр = Истина;
	КонецЕсли;

	Если Параметры.ПервичноеЗаявление Тогда
		Элементы.ГруппаКоманды.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Лево;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(РезультатВыполнения)
	
	ПрограммноеЗакрытие = Истина;
	Закрыть(РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаВыбранныхНастроек()
	
	Результат = ПроверкаВыбранныхНастроекСервере();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеСервиса(ВнутреннийИдентификатор)
	
	МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
	НашлиСтроки = ТаблицаСервисов.НайтиСтроки(Новый Структура("ВнутреннийИдентификатор", ВнутреннийИдентификатор));
	
	Если НашлиСтроки.Количество() <> 1 Тогда
		ДанныеСервера = Новый(МодульСервисКриптографииDSSКлиентСервер.ПолучитьТипОблачнойПодписи());
	ИначеЕсли ЗначениеЗаполнено(НашлиСтроки[0].Ссылка) Тогда
		ДанныеСервера = НашлиСтроки[0].Ссылка;
	Иначе
		ДанныеСервера = НашлиСтроки[0].ДанныеСервиса;
	КонецЕсли;
	
	Возврат ДанныеСервера;
	
КонецФункции

&НаСервере
Процедура ДополнитьНастройкиПользователя()
	
	МодульСервисКриптографииDSSСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебныйВызовСервера");
	МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
	МодульСервисКриптографииDSSПодтверждениеСервер = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSПодтверждениеСервер");
	
	ЭтотОбъект.НастройкиПользователя = МодульСервисКриптографииDSS.НастройкиПользователяПоУмолчанию();
	ПодготовитьНачальнуюФорму();
	
	ДанныеСервера = ПолучитьДанныеСервиса(СерверОблачнойПодписи);
	МодульСервисКриптографииDSSПодтверждениеСервер.ДополнитьНастройкиПользователя(ЭтотОбъект, ДанныеСервера, ЛогинВосстановления);
	МодульСервисКриптографииDSSСлужебныйВызовСервера.СброситьПараметрыСеансаУчетнойЗаписи(ЭтотОбъект.НастройкиПользователя);
	
КонецПроцедуры	

&НаСервере
Функция ПроверкаВыбранныхНастроекСервере()
	
	ВсеОшибки = Неопределено;
	
	Если НЕ ЗначениеЗаполнено(ЛогинВосстановления) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ВсеОшибки, "Объект.ЛогинВосстановления", "Не указан логин");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СерверОблачнойПодписи) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ВсеОшибки, "Объект.СерверОблачнойПодписи", "Не указан сервер ЭП");
	КонецЕсли;
	
	МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
	ВсеУчетныеЗаписи = МодульСервисКриптографииDSS.ПолучитьВсеУчетныеЗаписи();
	СтрокаПоиска = Новый Структура("Логин, ВнутреннийИдентификатор", ЛогинВосстановления, СерверОблачнойПодписи);
	НашлиСтроки = ВсеУчетныеЗаписи.НайтиСтроки(СтрокаПоиска);
	
	Если НашлиСтроки.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ВсеОшибки, "Объект.СерверОблачнойПодписи", "Такая учетная запись уже зарегистрирова в этой базе");
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ВсеОшибки);
	Результат = ВсеОшибки = Неопределено ИЛИ ВсеОшибки.СписокОшибок.Количество() = 0;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СоздатьУчетнуюЗаписьОблачнойПодписи()
	
	ДанныеСервера = ПолучитьДанныеСервиса(СерверОблачнойПодписи);
	МодульОбмена = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	УчетнаяЗаписьОблачнойПодписи = МодульОбмена.СоздатьУчетнуюЗаписьОблачнойПодписи(ДанныеСервера, ЛогинВосстановления, "", Истина);
	Результат = ЗначениеЗаполнено(УчетнаяЗаписьОблачнойПодписи);
	
	Если ЗначениеЗаполнено(УчетнаяЗаписьОблачнойПодписи) Тогда
		
		Попытка
			МодульСервисКриптографииDSSСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебныйВызовСервера");
			МодульСервисКриптографииDSSСлужебныйВызовСервера.СброситьПараметрыСеансаУчетнойЗаписи(УчетнаяЗаписьОблачнойПодписи);
		Исключение
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Электронный документооборот с контролирующими органами. Восстановление облачной учетной записи.'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
