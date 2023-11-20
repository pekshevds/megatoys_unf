
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда
		Объект.ВалютаДенежныхСредств = Константы.НациональнаяВалюта.Получить();
	КонецЕсли;
	
	Если Параметры.ПараметрыВыбора.Свойство("СтруктурнаяЕдиница")
		И ЗначениеЗаполнено(Параметры.ПараметрыВыбора.СтруктурнаяЕдиница) Тогда
		Объект.СтруктурнаяЕдиница = Параметры.ПараметрыВыбора.СтруктурнаяЕдиница;
	КонецЕсли;
	
	ИспользоватьПодключаемоеОборудование = Константы.ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.Получить();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И НЕ Параметры.ЗначенияЗаполнения.Свойство("Владелец")
	   И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			Объект.Владелец = ЗначениеНастройки;
		Иначе
			Объект.Владелец = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		Если НЕ ИспользоватьПодключаемоеОборудование Тогда
			Объект.ИспользоватьБезПодключенияОборудования = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ТипКассыПриИзмененииНаСервере();
	
	Если Объект.ИспользоватьБезПодключенияОборудования
	И НЕ Константы.ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.Получить() Тогда
		Элементы.ИспользоватьБезПодключенияОборудования.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	Элементы.ИсточникФИОКассираВЧеке.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	
	ИспользоватьОбменСПодключаемымОборудованием = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline");
	
	Если ИспользоватьОбменСПодключаемымОборудованием Тогда
		Элементы.ТипКассы.СписокВыбора.Добавить(Перечисления.ТипыКассККМ.ККМOffline);
		Элементы.ТипКассы.СписокВыбора.Добавить(Перечисления.ТипыКассККМ.СервисОборудования);
	КонецЕсли;
	
	Элементы.Владелец.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	УстановитьВидимостьДопСвойств();
	
	Элементы.РеквизитыККТ.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	Элементы.ГруппаПечать.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	
	ФОУчетПоНесколькимСкладам = ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам");
	Элементы.ГруппаОткрытьКарточкуСклада.Видимость = НЕ ФОУчетПоНесколькимСкладам;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если НЕ Объект.ОфлайнОборудование.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ОФД Тогда
		Элементы.ЗагрузитьДанныеОПродажах.Видимость = Ложь;
	КонецЕсли;
	
	// Переход с предыдущих версий
	Если Объект.ИсточникФИОКассираВЧеке.Пустая() Тогда
		Объект.ИсточникФИОКассираВЧеке = Перечисления.ИсточникиФИОКассираВЧекеККМ.Автор;
	КонецЕсли;
	// Конец Переход с предыдущих версий

	ПересчитатьФормуНаСервере();	
    НастроитьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАвтоНаименование();
	ЗаполнитьEmail();
	ЗаполнитьSMS();
	НастроитьВидимостьЭлементовАвтоинкассации();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьСчетаКассыККМ" Тогда
		Объект.СчетУчета = Параметр.СчетУчета;
		Модифицированность = Истина;
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	НужноОбновитьЗначения = Ложь;
	ПараметрыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(Объект.Ссылка);
	Если Объект.СоздаватьВыемку <> ПараметрыККМ.СоздаватьВыемку Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	Если Объект.СоздаватьПоступлениеВКассу <> ПараметрыККМ.СоздаватьПоступлениеВКассу Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	Если Объект.МинимальныйОстатокВКассеККМ <> ПараметрыККМ.МинимальныйОстатокВКассеККМ Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	Если Объект.КассаДляРозничнойВыручки <> ПараметрыККМ.КассаДляРозничнойВыручки Тогда
		НужноОбновитьЗначения = Истина;
	КонецЕсли;
	
	Если НужноОбновитьЗначения Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипКассыПриИзменении(Элемент)
	
	ТипКассыПриИзмененииНаСервере();
	СформироватьАвтоНаименование();
	НастроитьВидимостьЭлементовАвтоинкассации();
	
КонецПроцедуры // ТипКассыПриИзменении()

&НаКлиенте
Процедура ПодключаемоеОборудованиеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", Новый Структура("Ключ", Объект.ПодключаемоеОборудование));
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБезПодключенияОборудованияПриИзменении(Элемент)
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	Элементы.ИсточникФИОКассираВЧеке.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	УстановитьВидимостьДопСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	ПересчитатьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьВыемкуПриИзменении(Элемент)
	
	НастроитьВидимостьЭлементовАвтоинкассации();

	НастроитьФорму(ЭтотОбъект, "ГруппаАвтоинкассация");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьПоступлениеВКассуПриИзменении(Элемент)
	
	НастроитьВидимостьЭлементовАвтоинкассации();
	Если Объект.СоздаватьПоступлениеВКассу И Объект.КассаДляРозничнойВыручки.Пустая() Тогда
		Объект.КассаДляРозничнойВыручки = ЗаполнитьКассуДляВыручкиПоУмолчанию();
	КонецЕсли;

	НастроитьФорму(ЭтотОбъект, "ГруппаАвтоинкассация");

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКассовыйQRКодСБППриИзменении(Элемент)

	ПродолжениеНастройки = Новый ОписаниеОповещения(
		"ИспользоватьКассовыйQRКодСБППриИзмененииЗавершение", 
		ЭтотОбъект,
		Новый Структура("Элемент, ЭлементИмя", Элемент, Элемент.Имя));
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) 
		И ИспользоватьКассовыйQRКодСБП Тогда
		
		ПоказатьВопрос(
			ПродолжениеНастройки, 
			НСтр("ru='Для настройки кассового QR-кода необходимо записать объект.
				|Продолжить?'"), 
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ПродолжениеНастройки, КодВозвратаДиалога.Да);
	КонецЕсли;		
		
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКассовыйQRКодСБППриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	ИспользоватьКассовыйQRКодСБППараметр = ИспользоватьКассовыйQRКодСБП;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Если Не Записать() Тогда
			ИспользоватьКассовыйQRКодСБППараметр = Ложь;
		КонецЕсли;
		
	Иначе
		ИспользоватьКассовыйQRКодСБППараметр = Ложь;
	КонецЕсли;

	Если ИспользоватьКассовыйQRКодСБППараметр Тогда
		ПересчитатьФормуНаСервере();
	КонецЕсли;
	
	ИспользоватьКассовыйQRКодСБП = ИспользоватьКассовыйQRКодСБППараметр;
	
	ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ОбработкаЭлементаФормыПомощника(
		ЭтотОбъект, 
		ДополнительныеПараметры.Элемент, 
		ДополнительныеПараметры.ЭлементИмя);

	НастроитьФорму(ЭтотОбъект, "ГруппаНастройкиСБП");
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОплатыКассовойСсылкиСБППриИзменении(Элемент)
	
	ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ОбработкаЭлементаФормыПомощника(
		ЭтотОбъект, 
		Элемент, 
		Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ПересчитатьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НеПечататьБумажныйЧекПриИзменении(Элемент)
	
	НастроитьФорму(ЭтотОбъект, Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЧекаПродажиПриИзменении(Элемент)
	
	НастроитьФорму(ЭтотОбъект, Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЧекаВозвратаПриИзменении(Элемент)
	
	НастроитьФорму(ЭтотОбъект, Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвторизациюПоОтветственномуПриИзменении(Элемент)
	
	НастроитьФорму(ЭтотОбъект, Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключаемоеОборудованиеПриИзменении(Элемент)
	ПодключаемоеОборудованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура EmailПриИзменении(Элемент)
	
	Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С = Email = "ИзПриложения";
    НастроитьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура SMSПриИзменении(Элемент)
	
	Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С = SMS = "ИзПриложения";
    НастроитьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИспользоватьКассовыйQRКодСБПОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ОбработкаЭлементаФормыПомощника(
		ЭтотОбъект, 
		Элемент, 
		НавигационнаяСсылкаФорматированнойСтроки, 
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КассаДляРозничнойВыручкиПриИзменении(Элемент)
	
	НастроитьФорму(ЭтотОбъект, "ГруппаАвтоинкассация");
	
КонецПроцедуры

&НаКлиенте
Процедура МинимальныйОстатокВКассеККМПриИзменении(Элемент)
	
	НастроитьФорму(ЭтотОбъект, "ГруппаАвтоинкассация");
	
КонецПроцедуры

&НаКлиенте
Процедура ОфлайнОборудованиеПриИзменении(Элемент)
	
	ОфлайнОборудованиеПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСклады(Команда)
	
	ПараметрыФормы = Новый Структура("Ключ", ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ОсновнойСклад"));
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКассовыеСсылки(Команда)
	
	ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ОбработкаЭлементаФормыПомощника(
		ЭтотОбъект, 
		Команда, 
		Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключить(Команда)
	
	ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ОбработкаЭлементаФормыПомощника(
		ЭтотОбъект, 
		Команда, 
		Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеОФД(Команда)
	

		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыОФДЗагрузкаОтчетовЗавершение",
			ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(Объект.ОфлайнОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует наименование банковского счета.
//
&НаКлиенте
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования = "" + Объект.ТипКассы + " (" + Объект.СтруктурнаяЕдиница + ")";
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Возврат СтрокаНаименования;

КонецФункции

&НаСервере
Процедура СброситьОборудованиеИПризнакиККТ()
	
	Объект.ПодключаемоеОборудование = Неопределено;
	Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С = Ложь;
	Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С = Ложь;
	Email = "ЧерезОФД";
	SMS = "ЧерезОФД";
	
КонецПроцедуры

&НаСервере
Процедура ТипКассыПриИзмененииНаСервере()
	
	Если Объект.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Истина;
		Элементы.ПодключаемоеОборудование.Видимость = Истина;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Истина;
		Элементы.ОфлайнОборудование.Видимость = Ложь;
		
		ПараметрыВыбораПодключаемогоОборудования = Новый Массив;
		
		Значения = Новый Массив;
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ФискальныйРегистратор"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККТ"));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ТипОборудования", Значения));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.УстройствоИспользуется", Истина));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		
		Элементы.ПодключаемоеОборудование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПодключаемогоОборудования);
		
		Если Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор
			И Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			СброситьОборудованиеИПризнакиККТ();
		КонецЕсли;
		
		Элементы.СтруктурнаяЕдиница.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		
	ИначеЕсли Объект.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Ложь;
		Элементы.ОфлайнОборудование.Видимость = Истина;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь;
		
		ПараметрыВыбораПодключаемогоОборудования = Новый Массив;
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ТипОборудования", Перечисления.ТипыОфлайнОборудования.ККМ));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		
		Элементы.ОфлайнОборудование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПодключаемогоОборудования);
		
		Если Объект.ПодключаемоеОборудование.ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.УдалитьККМОфлайн Тогда
			СброситьОборудованиеИПризнакиККТ();
		КонецЕсли; 
		
		Элементы.СтруктурнаяЕдиница.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		
	ИначеЕсли Объект.ТипКассы = Перечисления.ТипыКассККМ.СервисОборудования Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Истина;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь;
		
		ПараметрыВыбораПодключаемогоОборудования = Новый Массив;
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.УстройствоИспользуется", Истина));
		ПараметрыВыбораПодключаемогоОборудования.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		
		Элементы.ПодключаемоеОборудование.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПодключаемогоОборудования);
		
		СброситьОборудованиеИПризнакиККТ();
		
	ИначеЕсли Объект.ТипКассы = Перечисления.ТипыКассККМ.ККМED Тогда
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Ложь;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь; 
		Элементы.ОфлайнОборудование.Видимость = Ложь;
		
	Иначе
		
		Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Ложь;
		Элементы.ПодключаемоеОборудование.Видимость = Ложь;
		Элементы.ИсточникФИОКассираВЧеке.Видимость = Ложь;
		Элементы.ОфлайнОборудование.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьВидимостьДопСвойств();
	
КонецПроцедуры // ТипКассыПриИзмененииНаСервере()

&НаКлиенте
Процедура НастроитьВидимостьЭлементовАвтоинкассации()
	
	ЭтоФискальныйРегистратор = (Объект.ТипКассы = ПредопределенноеЗначение("Перечисление.ТипыКассККМ.ФискальныйРегистратор"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАвтоинкассация", "Видимость", ЭтоФискальныйРегистратор);
	
	Если Не ЭтоФискальныйРегистратор Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "МинимальныйОстатокВКассеККМ", "Доступность", Объект.СоздаватьВыемку);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПВК", "Доступность", Объект.СоздаватьВыемку);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КассаДляРозничнойВыручки", "Доступность", Объект.СоздаватьПоступлениеВКассу);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КассаДляРозничнойВыручки", "ОтметкаНезаполненного", Объект.СоздаватьПоступлениеВКассу);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьКассуДляВыручкиПоУмолчанию()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	Кассы.Ссылка КАК Касса
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	НЕ Кассы.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Касса;
	Иначе
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Оповещение = Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение",
			ЭтотОбъект);
		ОткрытьФорму("Справочник.КассыККМ.Форма.РазрешитьРедактирование", , , , , , Оповещение);
	КонецЕсли;
	
КонецПроцедуры // Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта()

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат,Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПодключаемоеОборудованиеПриИзмененииНаСервере()
	
	Объект.СерийныйНомер = Объект.ПодключаемоеОборудование.СерийныйНомер;
	Объект.ТипОборудования = Объект.ПодключаемоеОборудование.ТипОборудования;
	
	УстановитьВидимостьДопСвойств();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДопСвойств()
	
	Если Объект.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор Тогда
		Если Объект.ПодключаемоеОборудование.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			Элементы.РеквизитыККТ.Видимость = Истина;
			Элементы.ГруппаПечать.Видимость = Истина;
		ИначеЕсли Объект.ПодключаемоеОборудование.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков Тогда
			Элементы.РеквизитыККТ.Видимость = Ложь;
			Элементы.ГруппаПечать.Видимость = Истина;
		Иначе
			Элементы.РеквизитыККТ.Видимость = Ложь;
			Элементы.ГруппаПечать.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.РеквизитыККТ.Видимость = Ложь;
		Элементы.ГруппаПечать.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ИспользоватьБезПодключенияОборудования Тогда
		Элементы.РеквизитыККТ.Видимость = Ложь;
		Элементы.ГруппаПечать.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ТипКассы)
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.ККМED
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline
		Или Объект.ТипКассы = Перечисления.ТипыКассККМ.СервисОборудования Тогда
			Элементы.ИспользоватьАвторизациюПоОтветственному.Видимость 	= Ложь;        
			Элементы.ГруппаНастройкиСБП.Видимость						= Ложь;
		Иначе
			Элементы.ИспользоватьАвторизациюПоОтветственному.Видимость = Истина;
			Элементы.ГруппаНастройкиСБП.Видимость					   = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьEmail()
	
	Если Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С Тогда
		Email = "ИзПриложения";
	Иначе
		Email = "ЧерезОФД";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьSMS()
	
	Если Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С Тогда
		SMS = "ИзПриложения";
	Иначе
		SMS = "ЧерезОФД";
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПересчитатьФормуНаСервере()
	
	ИнтеграцияСПлатежнымиСистемамиУНФ.НастроитьФормуПомощникаПодключенияСБП(
			ЭтотОбъект, 
			Объект.Ссылка,
			Объект.Владелец,
			Объект.СтруктурнаяЕдиница);

КонецПроцедуры

// Процедура устанавливает заголовок свернутого отображения для группы, по шаблону:
// <заголовок группы (как задан в конфигураторе)> : <динамический параметр 1>, <динамический параметр 2>
//
// Параметры:
//  Форма					 - Форма	 - текущая форма
//  НазваниеГруппы			 - Строка	 - имя группы формы, для которой устанавливается заголовок
//  ДинамическиеПараметры	 - Массив из Строка - массив частей заголовка.
//
&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФорму(Форма, ИмяГруппы = Неопределено)
	
	Если ИмяГруппы = "ГруппаАвтоинкассация"
		ИЛИ ИмяГруппы = Неопределено Тогда
		
		ДинамическиеПараметры = Новый Массив;
		
		Если Форма.Объект.СоздаватьВыемку Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='Создавать выемку при закрытии смены'"));
		КонецЕсли;

		Если Форма.Объект.СоздаватьПоступлениеВКассу Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='Создавать поступление в кассу при закрытии смены'"));
		КонецЕсли;
		
        УстановитьЗаголовокСвернутогоОтображения(Форма, Форма.Элементы.ГруппаАвтоинкассация.Имя, ДинамическиеПараметры);
		
	КонецЕсли;		
		
	Если ИмяГруппы = "ГруппаПечать"
		ИЛИ ИмяГруппы = Неопределено Тогда
		
		ДинамическиеПараметры = Новый Массив;
		
		Если Форма.Объект.НеПечататьБумажныйЧек Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='Не печатать бумажный чек'"));
		КонецЕсли;

		ДинамическиеПараметры.Добавить(Форма.Объект.ШаблонЧекаПродажи);
		ДинамическиеПараметры.Добавить(Форма.Объект.ШаблонЧекаВозврата);
		
        УстановитьЗаголовокСвернутогоОтображения(Форма, Форма.Элементы.ГруппаПечать.Имя, ДинамическиеПараметры);
		
	КонецЕсли;		
		
	Если ИмяГруппы = "ГруппаАвторизация"
		ИЛИ ИмяГруппы = Неопределено Тогда
		
		ДинамическиеПараметры = Новый Массив;
		
		Если Форма.Объект.ИспользоватьАвторизациюПоОтветственному Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='Использовать в РМК авторизацию по ответственному'"));
		КонецЕсли;

        УстановитьЗаголовокСвернутогоОтображения(Форма, Форма.Элементы.ГруппаАвторизация.Имя, ДинамическиеПараметры);
		
	КонецЕсли;		
		
	Если ИмяГруппы = "РеквизитыККТ"
		ИЛИ ИмяГруппы = Неопределено Тогда
		
		ДинамическиеПараметры = Новый Массив;
		
		Если Форма.Объект.ЭлектронныйЧекSMSПередаютсяПрограммой1С Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='по SMS из приложения'"));
		КонецЕсли;

		Если Форма.Объект.ЭлектронныйЧекEmailПередаютсяПрограммой1С Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='по Email из приложения'"));
		КонецЕсли;

		УстановитьЗаголовокСвернутогоОтображения(Форма, Форма.Элементы.РеквизитыККТ.Имя, ДинамическиеПараметры);
		
	КонецЕсли;		
		
	Если ИмяГруппы = "ГруппаНастройкиСБП"
		ИЛИ ИмяГруппы = Неопределено Тогда
		
		ДинамическиеПараметры = Новый Массив;
		
		Если Форма.ИспользоватьКассовыйQRКодСБП Тогда
			ДинамическиеПараметры.Добавить(НСтр("ru='Использовать кассовый QR-код СБП'"));
		КонецЕсли;

        УстановитьЗаголовокСвернутогоОтображения(Форма, Форма.Элементы.ГруппаНастройкиСБП.Имя, ДинамическиеПараметры);
		
	КонецЕсли;		
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокСвернутогоОтображения(Форма, НазваниеГруппы, ДинамическиеПараметры)

	МассивПараметров = Новый Массив;	
	
	Для Каждого Параметр Из ДинамическиеПараметры Цикл
		
		Если ЗначениеЗаполнено(Параметр) Тогда
			МассивПараметров.Добавить(Параметр);
		КонецЕсли;
		
	КонецЦикла;
	
	Форма.Элементы[НазваниеГруппы].ЗаголовокСвернутогоОтображения = Форма.Элементы[НазваниеГруппы].Заголовок 
		+ ?(МассивПараметров.Количество(), ": " + СтрСоединить(МассивПараметров, ", "), "");

КонецПроцедуры

&НаКлиенте
Процедура КассыОФДЗагрузкаОтчетовЗавершение(Результат, Параметры) Экспорт
	
	Если НЕ ТипЗнч(Результат) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Неопределено;
	ЕстьНесопоставленныеТовары = Результат.Свойство("НесопоставленныеТоварыОФД") И Результат.НесопоставленныеТоварыОФД.Количество() > 0;
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ОписаниеОшибки") Тогда
		
		Если НЕ ЕстьНесопоставленныеТовары Тогда
			ПоказатьПредупреждение(Неопределено, Результат.ОписаниеОшибки, 10);
		Иначе
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьНесопоставленныеТовары Тогда
		
		ОповещениеОСопоставлении = Новый ОписаниеОповещения(
			"СопоставлениеТоваровОФДЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
			
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НесопоставленныеТоварыОФД", Результат.НесопоставленныеТоварыОФД);
		ПараметрыФормы.Вставить("СопоставлениеПослеЗагрузки", Истина);
			
		ОткрытьФорму("РегистрСведений.СопоставлениеНоменклатурыОФД.Форма.ФормаСопоставленияТоваров", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОСопоставлении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставлениеТоваровОФДЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") И
		Результат.Свойство("СопоставлениеВыполнено") И 
		Результат.СопоставлениеВыполнено Тогда
		
		Если Параметры.Свойство("ОписаниеОшибки") Тогда
			ПоказатьПредупреждение(Неопределено, Параметры.ОписаниеОшибки, 10);
		КонецЕсли;
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыОФДЗагрузкаОтчетовЗавершение",
			ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(Объект.ОфлайнОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОфлайнОборудованиеПриИзмененииНаСервере()
	
	Если Объект.ОфлайнОборудование.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ОФД Тогда
		Элементы.ЗагрузитьДанныеОПродажах.Видимость = Истина;
	Иначе
		Элементы.ЗагрузитьДанныеОПродажах.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
