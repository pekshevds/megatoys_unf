#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ИмяОбъектаОбработки = ОбработкаОбъект.Метаданные().ПолноеИмя();
	
	ПоддерживаетсяРегистрацияСистемыВзаимодействияНаСервере = ИнтеграцияССистемойВзаимодействия.ПоддерживаетсяРегистрацияСистемыВзаимодействияНаСервере();
	УстановитьПривилегированныйРежим(Истина);
	ДоступноПодключениеКСистемеВзаимодействияВМоделиСервиса = ИнтеграцияССистемойВзаимодействия.ДоступноПодключениеКСистемеВзаимодействияВМоделиСервиса();
	ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса = ИнтеграцияССистемойВзаимодействия.ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	СпособыРегистрации = Новый Массив;
	СпособыРегистрации.Добавить(СпособРегистрацииБезСервиса());
	Если ПоддерживаетсяРегистрацияСистемыВзаимодействияНаСервере Тогда
		Если Не ДоступноПодключениеКСистемеВзаимодействияВМоделиСервиса Тогда
			СпособыРегистрации.Добавить(СпособРегистрацииЧерезСервис());
			ПрочитатьДанныеДляУправленияИзХранилища();
		ИначеЕсли ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса Тогда
			СпособыРегистрации.Добавить(СпособРегистрацииЧерезСервисВОблаке());
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СпособРегистрации.СписокВыбора.Очистить();
	Для Каждого Способ Из СпособыРегистрации Цикл
		Элементы.СпособРегистрации.СписокВыбора.Добавить(Способ.Значение, Способ.Наименование);
	КонецЦикла;
	
	СпособРегистрации = СпособыРегистрации[0].Значение;
	
	Если СпособыРегистрации.Количество() = 1 Тогда
		Элементы.СпособРегистрации.Видимость = Ложь;
	КонецЕсли;
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Имя = "" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("РегистрацияИнформационнойБазыСистемыВзаимодействия", Метаданные) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	АдресСервера = "wss://1cdialog.com:443";
	ИмяБазы = Метаданные.Синоним;
	Если ИмяБазы = "" Тогда
		ИмяБазы = Метаданные.КраткаяИнформация;
	КонецЕсли;
	
	БазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не БазаЗарегистрирована Тогда
		ОткрытьСтраницуРегистрации();
	Иначе
		ПерейтиКСтраницеПереходов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособРегистрацииПриИзменении(Элемент)
	
	ПриИзмененииСпособаРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяБазыПриИзменении(Элемент)
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура КодРегистрацииПриИзменении(Элемент)
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяБазыИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляУправленияПриИзменении(Элемент)
	
	РасшифрованныеДанныеДляУправления = РасшифроватьДанныеДляУправленияНаСервере(ДанныеДляУправления);
	Если Не РасшифрованныеДанныеДляУправления.Расшифровано Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Введенные данные не верны: %1'"), 
			РасшифрованныеДанныеДляУправления.ТекстСообщения);
		Сообщить(ТекстСообщения);
	Иначе
		АдресПубликацииСервисаУправления = РасшифрованныеДанныеДляУправления.Данные.АдресПубликацииСервисаУправления;
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресПубликацииСервисаУправления);
		АдресМенеджераСервиса = СтруктураURI.Хост;
		КодУправления = РасшифрованныеДанныеДляУправления.Данные.КодУправления;
	КонецЕсли;
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыАбонентаПриИзменении(Элемент)
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура КодРегистрацииИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыАбонентаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаСопоставления

&НаКлиенте
Процедура ТаблицаСопоставленияПользовательСервисаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НачальноеЗначение = Неопределено;
	
	СписокПользователей = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы Из ПользователиСервиса Цикл
		
		ЕстьСопоставление = Ложь;
		Для Каждого СтрокаСопоставления Из ТаблицаСопоставления Цикл
			
			Если СтрокаСопоставления.ПользовательСервиса = СтрокаТаблицы.ИмяПользователя
				И ЗначениеЗаполнено(СтрокаСопоставления.ПользовательИБ) Тогда
				ЕстьСопоставление = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьСопоставление Тогда
			Продолжить;
		КонецЕсли;
		
		СписокПользователей.Добавить(СтрокаТаблицы, СтрокаТаблицы.Наименование);
		
	КонецЦикла;
	
	Оповещение = Новый ОписаниеОповещения("ВыборПользователяСервиса", ЭтотОбъект);
	ПоказатьВыборИзСписка(Оповещение, СписокПользователей, Элемент, НачальноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСопоставленияПользовательСервисаОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.ТаблицаСопоставления.ТекущиеДанные.КлючСопоставления = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСвязиПриложений

&НаКлиенте
Процедура СвязиПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РедактироватьСвязь();
	
КонецПроцедуры

&НаКлиенте
Процедура СвязиПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	РедактироватьСвязь();
	
КонецПроцедуры

&НаКлиенте
Процедура СвязиПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ИмяФормыСвязи = СтрШаблон("%1.Форма.ФормаСвязиПриложений", ИмяОбъектаОбработки);
	ФормаСвязи = ПолучитьФорму(ИмяФормыСвязи);
	ФормаСвязи.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ФормаСвязиПриложенийЗакрыта", ЭтотОбъект);
	ФормаСвязи.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СвязиПриложенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОО = Новый ОписаниеОповещения("ПодтверждениеРазрываСвязи", ЭтотОбъект);
	
	ПоказатьВопрос(ОО, НСтр("ru = 'Отменить совместное использование?'"), 
	             РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСвязямПриложений(Команда)
	
	Заголовок = НСтр("ru = 'Совместное использование приложений системы взаимодействия'");
	ЗаполнитьСвязиПриложений();
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСвязиПриложений;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНазад(Команда)
	
	ОтключитьОбработчикОжидания("ПроверитьВыделенныеСтроки");
	ПерейтиКСтраницеПереходов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПользователей(Команда)
	
	ЗаполнитьПользователей();

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСпискуПользователей(Команда)
	
	Заголовок = НСтр("ru = 'Пользователи системы взаимодействия'");
	ЗаполнитьПользователей();
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПользователи;
	ПодключитьОбработчикОжидания("ПроверитьВыделенныеСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РазблокироватьПользователя(Команда)
	
	МассивПользователей = Новый Массив;
	
	ВыбранныеСтроки = Элементы.ТаблицаПользователей.ВыделенныеСтроки;
	Для Каждого ИдентификаторВыбраннойСтроки Из ВыбранныеСтроки Цикл
		Строка = ТаблицаПользователей.НайтиПоИдентификатору(ИдентификаторВыбраннойСтроки);
		Если Не Строка.ТекущийПользователь И Строка.ЭтоПользовательСистемыВзаимодействия <> Неопределено И Строка.Заблокирован Тогда
			МассивПользователей.Добавить(Строка.ИдентификаторПользователяСистемыВзаимодействия);
		КонецЕсли;
	КонецЦикла;
	
	БлокировкаПользователяНаСервере(МассивПользователей, Ложь);
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьПользователя(Команда)
	
	МассивПользователей = Новый Массив;
	
	ВыбранныеСтроки = Элементы.ТаблицаПользователей.ВыделенныеСтроки;
	Для Каждого ИдентификаторВыбраннойСтроки Из ВыбранныеСтроки Цикл
		Строка = ТаблицаПользователей.НайтиПоИдентификатору(ИдентификаторВыбраннойСтроки);
		Если Не Строка.ТекущийПользователь И Строка.ИдентификаторПользователяСистемыВзаимодействия <> Неопределено И Не Строка.Заблокирован Тогда
			МассивПользователей.Добавить(Строка.ИдентификаторПользователяСистемыВзаимодействия);
		КонецЕсли;
	КонецЦикла;
	
	БлокировкаПользователяНаСервере(МассивПользователей, Истина);
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРегистрацию(Команда)
	
	ИмяФормыОтменыРегистрации = СтрШаблон("%1.Форма.ФормаОтменыРегистрации", ИмяОбъектаОбработки);
	ФормаОтменыРегистрации = ПолучитьФорму(ИмяФормыОтменыРегистрации);
	ФормаОтменыРегистрации.Инициализировать(ИспользуетсяИнтеграцияССистемойВзаимодействияВМоделиСервиса);
	ФормаОтменыРегистрации.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ФормаОтменыРегистрацииЗакрыта", ЭтотОбъект);
	ФормаОтменыРегистрации.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуСопоставленияПользователей(Команда)
	
	Заголовок = НСтр("ru = 'Сопоставление пользователей сервиса'", "ru");
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСопоставлениеПользователей;
	
КонецПроцедуры

&НаКлиенте
Процедура Зарегистрировать(Команда)
	
	Если СпособРегистрации = СпособРегистрацииБезСервиса().Значение Тогда
		
		ПараметрыРегистрации = Новый ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия();
		ПараметрыРегистрации.АдресСервера = АдресСервера;
		ПараметрыРегистрации.АдресЭлектроннойПочты = АдресЭлектроннойПочтыАбонента;
		ПараметрыРегистрации.ИмяИнформационнойБазы = ИмяБазы;
		ПараметрыРегистрации.КодАктивации = СокрЛП(КодРегистрации);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("АктивацияЗавершена", ЭтаФорма, , "ОшибкаАктивации", ЭтаФорма);
		
		СистемаВзаимодействия.НачатьРегистрациюИнформационнойБазы(ОписаниеОповещения, ПараметрыРегистрации);
		
		ЭтаФорма.Доступность = Ложь;
		
	ИначеЕсли СпособРегистрации = СпособРегистрацииЧерезСервис().Значение Тогда
		
		РезультатРегистрации = ЗарегистрироватьЧерезСервисНаСервере();
		Если РезультатРегистрации <> Неопределено Тогда
			Если РезультатРегистрации.Успешно Тогда
				Сообщить(НСтр("ru = 'Регистрация успешно выполнена'"));
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось зарегистрировать базу по причине: %1'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, РезультатРегистрации.ТекстСообщения);
				Сообщить(ТекстСообщения);
			КонецЕсли;
		Иначе
			Сообщить(НСтр("ru = 'Укажите необходимые данные'"));
		КонецЕсли;
		
		ОбновитьИнтерфейс();
		
		БазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
		Если БазаЗарегистрирована Тогда
			СохранитьДанныеДляУправления();
			ПерейтиКСтраницеПереходов();
		КонецЕсли;
		
	ИначеЕсли СпособРегистрации = СпособРегистрацииЧерезСервисВОблаке().Значение Тогда
		
		РезультатРегистрации = ВыполнитьРегистрациюБазыПриПомощиТокена();
		
		Если РезультатРегистрации <> Неопределено Тогда
			Если РезультатРегистрации.РегистрацияВыполнена Тогда
				Сообщить(НСтр("ru = 'Регистрация успешно выполнена'"));
				ОбновитьИнтерфейс();
				БазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
				ПерейтиКСтраницеПереходов();
			Иначе
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Не удалось зарегистрировтаь базу по причине: %1'"), 
					РезультатРегистрации.ТекстСообщения);
				Сообщить(ТекстСообщения);
			КонецЕсли;
		Иначе
			Сообщить(НСтр("ru = 'Укажите необходимые данные'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИнформациюОПользователяхСервиса(Команда)
	
	ПолучитьИнформациюОПользователяхСервисаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиДанныеДляУправления(Команда)
	
	ИмяФормыВводаДанныхДляУправления = СтрШаблон("%1.Форма.ФормаВводаДанныхДляУправления", ИмяОбъектаОбработки);
	ФормаВводаДанныхДляУправления = ПолучитьФорму(ИмяФормыВводаДанныхДляУправления);
	ФормаВводаДанныхДляУправления.Инициализировать(ДанныеДляУправления);
	ФормаВводаДанныхДляУправления.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ФормаВводаДанныхДляУправленияЗакрыта", ЭтотОбъект);
	ФормаВводаДанныхДляУправления.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьСопоставлениеСПользователямиСервиса(Команда)
	
	СохранитьСопоставлениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодРегистрации(Команда)
	
	ПараметрыРегистрации = Новый ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия();
	ПараметрыРегистрации.АдресСервера = АдресСервера;
	ПараметрыРегистрации.АдресЭлектроннойПочты = АдресЭлектроннойПочтыАбонента;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьКодРегистрацииЗавершение", ЭтаФорма, , "ПолучитьКодРегистрацииОшибка", ЭтаФорма);
	
	СистемаВзаимодействия.НачатьРегистрациюИнформационнойБазы(ОписаниеОповещения, ПараметрыРегистрации);
	
	ЭтаФорма.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СправкаПоОбработке(Команда)
	
	ОткрытьСправкуФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьПереходов()
	
	Элементы.ПерейтиКСвязямПриложений.Видимость = БазаЗарегистрирована;
	Элементы.ПерейтиКСпискуПользователей.Видимость = БазаЗарегистрирована;
	Элементы.ОтменитьРегистрацию.Видимость = БазаЗарегистрирована;
	Элементы.ПерейтиНаСтраницуСопоставленияПользователей.Видимость = БазаЗарегистрирована И ЗначениеЗаполнено(ДанныеДляУправления);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвязиПриложений()
	
	ОбъектСистемыВзаимодействия = ИнтеграцияССистемойВзаимодействия.ОбъектСистемыВзаимодействия();

	СвязиПриложений.Очистить();
	
	ЭлементыСовместногоИспользования = ОбъектСистемыВзаимодействия.ПолучитьСовместноеИспользованиеПриложенийАбонента();
	Для Каждого ЭлементСовместногоИспользования Из ЭлементыСовместногоИспользования Цикл
		
		Связь = СвязиПриложений.Добавить();
		
		А = 1;
		Для Каждого ИдентификаторПриложения Из ЭлементСовместногоИспользования.Приложения Цикл
			Если А = 1 Тогда
				Связь.ИдентификаторПриложения1 = ИдентификаторПриложения;
				А = 2;
			Иначе
				Связь.ИдентификаторПриложения2 = ИдентификаторПриложения;
				Прервать;
			КонецЕсли;
		КонецЦикла;
			
		Связь.Приложение1 = ОбъектСистемыВзаимодействия.ПолучитьПриложение(
			Связь.ИдентификаторПриложения1).Наименование;
		Связь.Приложение2 = ОбъектСистемыВзаимодействия.ПолучитьПриложение(
			Связь.ИдентификаторПриложения2).Наименование;
		
		Связь.СопоставлениеПользователей = ЭлементСовместногоИспользования.СопоставлениеПользователей;
		Если Связь.СопоставлениеПользователей = "Name" Или Связь.СопоставлениеПользователей = "Имя" Тогда
			Связь.СопоставлениеПользователей = "NAME";
			Связь.ПредставлениеСопоставленияПользователей = НСтр("ru = 'По имени'");
		ИначеЕсли Связь.СопоставлениеПользователей = "FullName" Или Связь.СопоставлениеПользователей = "ПолноеИмя" Тогда
			Связь.СопоставлениеПользователей = "FULLNAME";
			Связь.ПредставлениеСопоставленияПользователей = НСтр("ru = 'По полному имени'");
		ИначеЕсли Связь.СопоставлениеПользователей = "MatchingKey" Или Связь.СопоставлениеПользователей = "КлючСопоставления" Тогда
			Связь.СопоставлениеПользователей = "MATCHINGKEY";
			Связь.ПредставлениеСопоставленияПользователей = НСтр("ru = 'По ключу соответствия'");
		КонецЕсли;
			
		Связь.СопоставлениеКонтекстныхОбсуждений = ЭлементСовместногоИспользования.СопоставлениеКонтекстовОбсуждений;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыделенныеСтроки()
	
	УстановитьДоступностьКоманд();
	ПодключитьОбработчикОжидания("ПроверитьВыделенныеСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтраницеПереходов()
	
	УстановитьВидимостьПереходов();
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.Переходы;
	Заголовок = НСтр("ru = 'Управление системой взаимодействия'");

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	ЕстьЗаблокированные = Ложь;
	ЕстьРазблокированные = Ложь;
	
	ВыбранныеСтроки = Элементы.ТаблицаПользователей.ВыделенныеСтроки;
	Для Каждого ИдентификаторВыбраннойСтроки Из ВыбранныеСтроки Цикл
		Строка = ТаблицаПользователей.НайтиПоИдентификатору(ИдентификаторВыбраннойСтроки);
		Если Строка.ТекущийПользователь Тогда
			Продолжить;
		КонецЕсли;
		Если Строка.ИдентификаторПользователяСистемыВзаимодействия <> Неопределено Тогда
			Если Строка.Заблокирован Тогда
				ЕстьЗаблокированные = Истина;
			Иначе
				ЕстьРазблокированные = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ТаблицаПользователейРазблокироватьПользователя.Доступность = ЕстьЗаблокированные;
	Элементы.ПользователиКонтекстноеМенюРазблокироватьПользователя.Доступность = ЕстьЗаблокированные;
	Элементы.ТаблицаПользователейЗаблокироватьПользователя.Доступность = ЕстьРазблокированные;
	Элементы.ПользователиКонтекстноеМенюЗаблокироватьПользователя.Доступность = ЕстьРазблокированные;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСвязь()
	
	Если Элементы.СвязиПриложений.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФормыСвязи = СтрШаблон("%1.Форма.ФормаСвязиПриложений", ИмяОбъектаОбработки);
	ФормаСвязи = ПолучитьФорму(ИмяФормыСвязи);
	ФормаСвязи.Инициализировать(Элементы.СвязиПриложений.ТекущиеДанные);
	ФормаСвязи.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ФормаСвязиПриложенийЗакрыта", ЭтотОбъект);
	ФормаСвязи.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаСвязиПриложенийЗакрыта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ЗаполнитьСвязиПриложений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеРазрываСвязи(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ТекДанные = Элементы.СвязиПриложений.ТекущиеДанные;
		РазорватьСвязьНаСервере(ТекДанные.ИдентификаторПриложения1, ТекДанные.ИдентификаторПриложения2);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазорватьСвязьНаСервере(ИдентификаторПриложения1, ИдентификаторПриложения2)
	
	ОбъектСистемыВзаимодействия = ИнтеграцияССистемойВзаимодействия.ОбъектСистемыВзаимодействия();
	ИдентификаторыПриложений = Новый(ИнтеграцияССистемойВзаимодействия.ТипКоллекцияИдентификаторовПриложений()); // КоллекцияИдентификаторовПриложенийСистемыВзаимодействия
	ИдентификаторыПриложений.Добавить(ИдентификаторПриложения1);
	ИдентификаторыПриложений.Добавить(ИдентификаторПриложения2);
	ОбъектСистемыВзаимодействия.ОтменитьСовместноеИспользованиеПриложенийАбонента(ИдентификаторыПриложений);
	ЗаполнитьСвязиПриложений();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПользователей()
	
	Перем СоответствиеПользователей;
	Перем ИдентификаторТекущегоПользователя;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторТекущегоПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	
	СоответствиеПользователей = Новый Соответствие;
	
	ТаблицаПользователей.Очистить();
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		Строка = ТаблицаПользователей.Добавить();
		Строка.ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
		Строка.ИмяПользователя = ПользовательИБ.Имя;
		Строка.ПолноеИмя = ПользовательИБ.ПолноеИмя;
		Строка.ЭтоПользовательИБ = Истина;
		Строка.ТекущийПользователь = ПользовательИБ.УникальныйИдентификатор = ИдентификаторТекущегоПользователя;
		
		СоответствиеПользователей.Вставить(ПользовательИБ.УникальныйИдентификатор, Строка.ПолучитьИдентификатор());
		
	КонецЦикла;
	
	ОбъектСистемыВзаимодействия = ИнтеграцияССистемойВзаимодействия.ОбъектСистемыВзаимодействия();
	ПользователиСВ = ОбъектСистемыВзаимодействия.ПолучитьПользователей();
	Для Каждого ПользовательСВ Из ПользователиСВ Цикл
		
		ИдентификаторПользователяИБ = ПользовательСВ.ИдентификаторПользователяИнформационнойБазы;
		Если ИдентификаторПользователяИБ <> Неопределено Тогда
			
			ИдентификаторСтроки = СоответствиеПользователей.Получить(ИдентификаторПользователяИБ);
			Если ИдентификаторСтроки = Неопределено Тогда
				Строка = ТаблицаПользователей.Добавить();
				Строка.ИмяПользователя = ПользовательСВ.Имя;
				Строка.ПолноеИмя = ПользовательСВ.ПолноеИмя;
			Иначе
				Строка = ТаблицаПользователей.НайтиПоИдентификатору(ИдентификаторСтроки);
			КонецЕсли;
				
			Строка.ЭтоПользовательСистемыВзаимодействия = Истина;
			Строка.ИдентификаторПользователяСистемыВзаимодействия = ПользовательСВ.Идентификатор;
			Строка.Заблокирован = ПользовательСВ.Заблокирован;
			
		КонецЕсли;

	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура БлокировкаПользователяНаСервере(МассивПользователей, ЭтоБлокировка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ИдентификаторПользователя Из МассивПользователей Цикл
		Пользователь = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователя);
		Пользователь.Заблокирован = ЭтоБлокировка;
		Пользователь.Записать();
		
		Отбор = Новый Структура("ИдентификаторПользователяСистемыВзаимодействия", Пользователь.Идентификатор);
		Строки = ТаблицаПользователей.НайтиСтроки(Отбор);
		Если Строки.Количество() = 1 Тогда
			Строки[0].Заблокирован = Пользователь.Заблокирован;
		КонецЕсли;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьРегистрациюНаСервере()
	
	БазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(
		"ДанныеДляУправленияСистемойВзаимодействия", 
		"ДанныеДляУправленияСистемойВзаимодействия");
	ДанныеДляУправления = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаОтменыРегистрацииЗакрыта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = 1 Тогда
		ОтменитьРегистрациюНаСервере();
		ДанныеДляУправления = "";
		АдресМенеджераСервиса = "";
		КодУправления = "";
		ОткрытьСтраницуРегистрации();
	Иначе
		ПерейтиКСтраницеПереходов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтраницуРегистрации()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРегистрации;
	
	ПриИзмененииСпособаРегистрации();
	
КонецПроцедуры

// Выполнить регистрацию базы при помощи токена.
// @skip-warning ПустойМетод - особенность реализации. Переопределен в расширении.
// 
// Возвращаемое значение:
//  Структура:
//   * РегистрацияВыполнена - Булево
//   * ТекстСообщения - Строка
&НаСервере
Функция ВыполнитьРегистрациюБазыПриПомощиТокена()
	
КонецФункции

&НаКлиенте
Процедура АктивацияЗавершена(Результат, ТекстСообщения, ДополнительныеПараметры) Экспорт

	ОписаниеОповещения = Новый ОписаниеОповещения("АктивацияЗавершенаПредупреждение", ЭтаФорма);
	ПоказатьПредупреждение(ОписаниеОповещения, НСтр("ru = 'Приложение зарегистрировано'"));
	
КонецПроцедуры

&НаКлиенте
Процедура АктивацияЗавершенаПредупреждение(ДополнительныеПараметры) Экспорт
	
	ЭтаФорма.Доступность = Истина;
	ОбновитьИнтерфейс();
	БазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	Если БазаЗарегистрирована Тогда
		ПерейтиКСтраницеПереходов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкаАктивации(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт

	СтандартнаяОбработка = Ложь;
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);

	ЭтаФорма.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеДляУправления()
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище("ДанныеДляУправленияСистемойВзаимодействия", ДанныеДляУправления, "ДанныеДляУправленияСистемойВзаимодействия");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ЗарегистрироватьЧерезСервисНаСервере()
	
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КодУправления) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяБазы) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРегистрации = ИнтеграцияССистемойВзаимодействия.ЗарегистрироватьБазуЧерезСервис(АдресПубликацииСервисаУправления, КодУправления, ИмяБазы);
	
	ПользователиСервиса.Очистить();
	
	Если РезультатРегистрации.Успешно Тогда
		Если РезультатРегистрации.ДанныеРезультата <> Неопределено Тогда
			Для Каждого Стр Из РезультатРегистрации.ДанныеРезультата.ДанныеПользователей Цикл
				НовСтр = ПользователиСервиса.Добавить();
				НовСтр.ИмяПользователя = Стр.UserName;
				НовСтр.КлючСопоставления = Стр.UserID;
				НовСтр.Наименование = Стр.UserName;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТаблицуСопоставления();
	
	Возврат РезультатРегистрации;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СпособРегистрацииЧерезСервисВОблаке()
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", "ЧерезСервисВОблаке");
	Результат.Вставить("Наименование", НСтр("ru = 'Через сервис Фреш'"));
	Результат.Вставить("Подсказка", НСтр("ru = 'Будет доступно совместное использование обсуждений в локальной базе и приложениях в сервисе Фреш'"));
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СпособРегистрацииЧерезСервис()
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", "ЧерезСервис");
	Результат.Вставить("Наименование", НСтр("ru = 'Через сервис Фреш'"));
	Результат.Вставить("Подсказка", НСтр("ru = 'Будет доступно совместное использование обсуждений в локальной базе и приложениях в сервисе Фреш'"));
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СпособРегистрацииБезСервиса()
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", "БезСервиса");
	Результат.Вставить("Наименование", НСтр("ru = 'Стандартный способ'"));
	Результат.Вставить("Подсказка", "");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииСпособаРегистрации()
	
	СпособыРегистрации = Новый Массив;
	СпособыРегистрации.Добавить(СпособРегистрацииЧерезСервис());
	СпособыРегистрации.Добавить(СпособРегистрацииЧерезСервисВОблаке());
	СпособыРегистрации.Добавить(СпособРегистрацииБезСервиса());
	
	Для Каждого Способ Из СпособыРегистрации Цикл
		
		Если СпособРегистрации = Способ.Значение Тогда
			Элементы.СпособРегистрации.Подсказка = Способ.Подсказка;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ДанныеДляУправления.Видимость = (СпособРегистрации = СпособРегистрацииЧерезСервис().Значение);
	Элементы.АдресЭлектроннойПочтыАбонента.Видимость = (СпособРегистрации = СпособРегистрацииБезСервиса().Значение);
	Элементы.ИмяБазы.Видимость = (СпособРегистрации <> СпособРегистрацииЧерезСервисВОблаке().Значение);
	Элементы.ГруппаЗарегистрировать.Видимость = (СпособРегистрации = СпособРегистрацииБезСервиса().Значение);
	
	УстановитьДоступностьКнопокРегистрации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСопоставления()
	
	ТаблицаСопоставления.Очистить();
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей(); // Массив Из ПользовательИнформационнойБазы
	
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		
		НовСтр = ТаблицаСопоставления.Добавить();
		НовСтр.ПользовательИБ = ПользовательИБ.Имя;
		ПользовательСВ = ПользовательСистемыВзаимодействияПоПользователюИБ(ПользовательИБ);
		Если ПользовательСВ <> Неопределено Тогда
			НовСтр.КлючСопоставления = ПользовательСВ.КлючСопоставления;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Стр Из ПользователиСервиса Цикл
		
		Для Каждого СтрокаСопоставления Из ТаблицаСопоставления Цикл
			
			Если СтрокаСопоставления.КлючСопоставления = Стр.КлючСопоставления Тогда
				СтрокаСопоставления.ПользовательСервиса = Стр.ИмяПользователя;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьИнформациюОПользователяхСервисаНаСервере()
	
	ИнформацияОПользователях = ИнтеграцияССистемойВзаимодействия.ПолучитьДанныеОПользователяхСервиса(АдресПубликацииСервисаУправления, КодУправления);
	
	ПользователиСервиса.Очистить();
	
	Если ИнформацияОПользователях.Успешно
		И ИнформацияОПользователях.ДанныеРезультата <> Неопределено
		И ИнформацияОПользователях.ДанныеРезультата.Свойство("ДанныеПользователей") Тогда
		
		Для Каждого Стр Из ИнформацияОПользователях.ДанныеРезультата.ДанныеПользователей Цикл
			НовСтр = ПользователиСервиса.Добавить();
			НовСтр.ИмяПользователя = Стр.UserName;
			НовСтр.КлючСопоставления = Стр.UserID;
			НовСтр.Наименование = Стр.UserName;
		КонецЦикла;
		
		ЗаполнитьТаблицуСопоставления();
		
	Иначе
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось получить информацию о пользователях сервиса по причине: %1'"), 
			ИнформацияОПользователях.ТекстСообщения);
		Сообщить(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПользовательСистемыВзаимодействияПоПользователюИБ(ПользовательИБ)
	
	УникальныйИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
	
	// такой способ предалагется в статье на ИТС
	Попытка
		ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(УникальныйИдентификаторПользователя);
		Возврат СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСВ);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура ПерезаполнитьТаблицуСопоставленияПослеРедактирования()
	
	СопоставленныеПользователиСервиса = Новый Массив;
	
	Для Каждого Стр Из ТаблицаСопоставления Цикл
		Если ЗначениеЗаполнено(Стр.ПользовательИБ)
			И ЗначениеЗаполнено(Стр.ПользовательСервиса) Тогда
			СопоставленныеПользователиСервиса.Добавить(Стр.ПользовательСервиса);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СопоставленныйПользовательСервиса Из СопоставленныеПользователиСервиса Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ПользовательИБ", "");
		ПараметрыОтбора.Вставить("ПользовательСервиса", СопоставленныйПользовательСервиса);
		СтрокиДляУдаления = ТаблицаСопоставления.НайтиСтроки(ПараметрыОтбора);
		Для Каждого СтрокаДляУдаления Из СтрокиДляУдаления Цикл
			ТаблицаСопоставления.Удалить(СтрокаДляУдаления);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСопоставлениеНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Стр Из ТаблицаСопоставления Цикл
		
		Если Не ЗначениеЗаполнено(Стр.ПользовательИБ) Тогда
			Продолжить;
		КонецЕсли;
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Стр.ПользовательИБ);
		УникальныйИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		
		ИдентификаторПользователяСВ = Неопределено;
		
		// такой способ предалагется в статье на ИТС
		Попытка
			ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(УникальныйИдентификаторПользователя);
		Исключение
		КонецПопытки;
		
		НовыйКлючСопоставления = КлючСопоставленияПользователяСервиса(Стр.ПользовательСервиса);
		ЗаписатьПользователя = Ложь;
		
		Если ИдентификаторПользователяСВ = Неопределено Тогда
			ПользовательСВ = СистемаВзаимодействия.СоздатьПользователя(ПользовательИБ);
			ЗаписатьПользователя = Истина;
		Иначе
			ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСВ);
			Если ПользовательСВ.КлючСопоставления <> НовыйКлючСопоставления Тогда
				ЗаписатьПользователя = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗаписатьПользователя Тогда
			ПользовательСВ.КлючСопоставления = НовыйКлючСопоставления;
			ПользовательСВ.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция КлючСопоставленияПользователяСервиса(ПользовательСервиса = "")
	
	Если Не ЗначениеЗаполнено(ПользовательСервиса) Тогда
		Возврат "";
	КонецЕсли;
	
	Для Каждого Стр Из ПользователиСервиса Цикл
		
		Если Стр.ИмяПользователя = ПользовательСервиса Тогда
			Возврат Стр.КлючСопоставления;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Процедура ФормаВводаДанныхДляУправленияЗакрыта(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		РасшифрованныеДанныеДляУправления = РасшифроватьДанныеДляУправленияНаСервере(Результат);
		Если Не РасшифрованныеДанныеДляУправления.Расшифровано Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Введенные данные не верны: %1'"), 
				РасшифрованныеДанныеДляУправления.ТекстСообщения);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Иначе
			ДанныеДляУправления = Результат;
			АдресПубликацииСервисаУправления = РасшифрованныеДанныеДляУправления.Данные.АдресПубликацииСервисаУправления;
			СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресПубликацииСервисаУправления);
			АдресМенеджераСервиса = СтруктураURI.Хост;
			КодУправления = РасшифрованныеДанныеДляУправления.Данные.КодУправления;
			СохранитьДанныеДляУправления();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РасшифроватьДанныеДляУправленияНаСервере(Данные)
	
	Возврат ИнтеграцияССистемойВзаимодействия.РасшифроватьДанныеДляУправления(Данные);
	
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеДляУправленияИзХранилища()
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеИзХранилища = ИнтеграцияССистемойВзаимодействия.ДанныеДляУправленияСистемойВзаимодействия();
	Если ЗначениеЗаполнено(ДанныеИзХранилища) Тогда
		
		ДанныеДляУправления = ДанныеИзХранилища;
		
		РасшифрованныеДанныеДляУправления = РасшифроватьДанныеДляУправленияНаСервере(ДанныеДляУправления);
		Если РасшифрованныеДанныеДляУправления.Расшифровано Тогда
			АдресПубликацииСервисаУправления = РасшифрованныеДанныеДляУправления.Данные.АдресПубликацииСервисаУправления;
			СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресПубликацииСервисаУправления);
			АдресМенеджераСервиса = СтруктураURI.Хост;
			КодУправления = РасшифрованныеДанныеДляУправления.Данные.КодУправления;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодРегистрацииЗавершение(Результат, ТекстСообщения, ДополнительныеПараметры) Экспорт

	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьКодРегистрацииЗавершениеПредупреждение", ЭтаФорма);
	ПоказатьПредупреждение(ОписаниеОповещения, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодРегистрацииЗавершениеПредупреждение(ДополнительныеПараметры) Экспорт
	
	ЭтаФорма.Доступность = Истина;
	ТекущийЭлемент = Элементы.КодРегистрации;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодРегистрацииОшибка(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
	ЭтаФорма.Доступность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопокРегистрации()
	
	Если СпособРегистрации = СпособРегистрацииЧерезСервисВОблаке().Значение Тогда
		Элементы.Зарегистрировать.Доступность = Истина;
	ИначеЕсли СпособРегистрации = СпособРегистрацииЧерезСервис().Значение Тогда
		Элементы.Зарегистрировать.Доступность = Не ПустаяСтрока(ДанныеДляУправления) 
			И Не ПустаяСтрока(ИмяБазы) 
			И Не ПустаяСтрока(АдресМенеджераСервиса);
	ИначеЕсли СпособРегистрации = СпособРегистрацииБезСервиса().Значение Тогда
		Элементы.Зарегистрировать.Доступность = Не ПустаяСтрока(АдресЭлектроннойПочтыАбонента) 
			И Не ПустаяСтрока(ИмяБазы) 
			И Не ПустаяСтрока(КодРегистрации);
	КонецЕсли;
	
	Элементы.ПолучитьКодРегистрации.Доступность = Не ПустаяСтрока(АдресЭлектроннойПочтыАбонента) 
		И Не ПустаяСтрока(ИмяБазы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПользователяСервиса(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ТекущиеДанныеСопоставления = Элементы.ТаблицаСопоставления.ТекущиеДанные;
		ТекущиеДанныеСопоставления.ПользовательСервиса = ВыбранныйЭлемент.Значение.ИмяПользователя;
		ТекущиеДанныеСопоставления.КлючСопоставления = ВыбранныйЭлемент.Значение.КлючСопоставления;
	КонецЕсли;
	
	ПерезаполнитьТаблицуСопоставленияПослеРедактирования();
	
КонецПроцедуры

#КонецОбласти