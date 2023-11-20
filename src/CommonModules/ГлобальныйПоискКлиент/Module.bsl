
#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	Если НЕ ДоступноИспользование() Тогда
		Возврат;
	КонецЕсли;
	УстановитьПланГлобальногоПоиска();
	
КонецПроцедуры

// См. обработчик ПриГлобальномПоиске модуля клиентского приложения.
//
Процедура ПриГлобальномПоиске(СтрокаПоиска, ПланПоиска) Экспорт
	
	ПроверитьДобавитьПоискКонвертацияВалют(СтрокаПоиска, ПланПоиска);
	ПроверитьДобавитьПоискИНН(СтрокаПоиска, ПланПоиска);
	ПроверитьДобавитьПоискПоШтрихкодуПечатнойФормы(СтрокаПоиска, ПланПоиска);
	
КонецПроцедуры

// См. обработчик ПриВыбореРезультатаГлобальногоПоиска модуля клиентского приложения.
//
Процедура ПриВыбореРезультатаГлобальногоПоиска(ЭлементРезультата, СтандартнаяОбработка) Экспорт
	
	Если ЭлементРезультата.ВидПоиска = "ВыполнитьПоискКонтрагентовПоИНН" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", Новый Структура("ТекстЗаполнения",
			ЭлементРезультата.Значение));
	ИначеЕсли ЭлементРезультата.ВидПоиска = "ВыполнитьКонвертациюСуммыВВалюте" Тогда
		СтандартнаяОбработка = Ложь;
		ГлобальныйПоискМенеджер().НачатьПоиск(ЭлементРезультата.Значение);
	ИначеЕсли ЭлементРезультата.ВидПоиска = "ВыполнитьПолнотекстовыйПоискКонтактов" Тогда
		ОбработатьВыборРезультатаГлобальногоПоиска(ЭлементРезультата, СтандартнаяОбработка);
	КонецЕсли;
	
	ВидПоискаСтрокой = "";
	Если ЭлементРезультата.ВидПоиска <> Неопределено Тогда
		ВидПоискаСтрокой = Строка(ЭлементРезультата.ВидПоиска);
	КонецЕсли;
	ГлобальныйПоискВызовСервера.ПриВыбореРезультатаГлобальногоПоиска(ВидПоискаСтрокой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Сценарий_ВыполнитьПолнотекстовыйПоискКонтактов

Процедура ОбработатьВыборРезультатаГлобальногоПоиска(ЭлементРезультата, СтандартнаяОбработка)
	
	Если ТипЗнч(ЭлементРезультата.Значение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	КонтактнаяИнформация = Неопределено;
	ЭлементРезультата.Значение.Свойство("КонтактнаяИнформация", КонтактнаяИнформация);
	
	Если КонтактнаяИнформация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если КонтактнаяИнформация.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		КонтактнаяИнформацияУНФКлиент.ПозвонитьПоТелефону(
			КонтактнаяИнформация.Представление, КонтактнаяИнформация.Владелец);
	ИначеЕсли КонтактнаяИнформация.Тип = ПредопределенноеЗначение(
		"Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		УправлениеКонтактнойИнформациейКлиент.СоздатьЭлектронноеПисьмо(
			"", КонтактнаяИнформация.Представление, КонтактнаяИнформация.Тип, КонтактнаяИнформация.Владелец);
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СовместимостьВерсийПлатформы

// Глобальный поиск доступен начиная с версии платформы 8.3.15
// Для обхода ошибок проверки конфигурации и ошибок выполнения используется метод Вычислить.

Функция ДоступноИспользование()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТекущаяВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	НеобходимаяВерсияПлатформы = "8.3.15.1";
	
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ТекущаяВерсияПлатформы, НеобходимаяВерсияПлатформы) >= 0;
	
КонецФункции

Функция ГлобальныйПоискМенеджер()
	
	Возврат Вычислить("ГлобальныйПоиск");
	
КонецФункции

Функция НовыйПланГлобальногоПоиска()
	
	Возврат Вычислить("Новый ПланГлобальногоПоиска");
	
КонецФункции

Функция СтандартныйВидГлобальногоПоиска()
	
	Возврат Вычислить("СтандартныйВидГлобальногоПоиска");
	
КонецФункции

#КонецОбласти

Процедура УстановитьПланГлобальногоПоиска()
	
	ПроверенныеПоискомМетаданные = Новый Массив;
	ПланПоиска = НовыйПланГлобальногоПоиска();
	
	ДобавитьСтандартныеВидыПоиска(ПланПоиска);
	ДобавитьПоискКонтактов(ПланПоиска, ПроверенныеПоискомМетаданные);
	ДобавитьПолнотекстовыйПоиск(ПланПоиска, ПроверенныеПоискомМетаданные);
	
	ГлобальныйПоискМенеджер().УстановитьПлан(ПланПоиска);
	
КонецПроцедуры

Процедура ДобавитьСтандартныеВидыПоиска(ПланПоиска)
	
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["Выражение"], 10);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["НавигационнаяСсылка"], 10);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["ИзбранноеРаботыПользователя"], 20);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["ИсторияРаботыПользователя"], 30);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["ГлобальныеСтандартныеКоманды"], 40);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["ВсеФункции"], 50);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["МенюФункций"], 60);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["ОбсужденияСистемыВзаимодействия"], 70);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["СообщенияСистемыВзаимодействия"], 80);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["Данные"], 90);
	ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["Справка"], 100);
	
КонецПроцедуры

Процедура ДобавитьПоискКонтактов(ПланПоиска, ИспользуемыеМетаданные)
	
	ИспользуемыеМетаданные.Добавить("Справочник.Лиды");
	ИспользуемыеМетаданные.Добавить("Справочник.КонтактыЛидов");
	ИспользуемыеМетаданные.Добавить("Справочник.КонтактныеЛица");
	ИспользуемыеМетаданные.Добавить("Справочник.Контрагенты");
	
	Если ПланПоиска.Найти("ВыполнитьПолнотекстовыйПоискКонтактов", "ГлобальныйПоискСервер") <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПорядокПоиска = 75;
	Фоновый = НЕ ОбщегоНазначенияКлиент.РежимОтладки();
	ПланПоиска.Добавить("ВыполнитьПолнотекстовыйПоискКонтактов", "ГлобальныйПоискСервер", Истина, Фоновый, ПорядокПоиска);
	
КонецПроцедуры

Процедура ДобавитьПолнотекстовыйПоиск(ПланПоиска, ИспользуемыеМетаданные)
	
	ИспользоватьСтандартныйВидПоиска = ИспользуемыеМетаданные.Количество() = 0;
	
	ПланПоиска.Удалить(СтандартныйВидГлобальногоПоиска()["Данные"]);
	ПланПоиска.Удалить("ВыполнитьПолнотекстовыйПоиск", "ГлобальныйПоискСервер");
	
	ПорядокПоиска = 90;
	Если ИспользоватьСтандартныйВидПоиска Тогда
		ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска()["Данные"], ПорядокПоиска);
	Иначе
		Фоновый = НЕ ОбщегоНазначенияКлиент.РежимОтладки();
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("МетаданныеИсключения", ИспользуемыеМетаданные);
		ПланПоиска.Добавить("ВыполнитьПолнотекстовыйПоиск", "ГлобальныйПоискСервер", Истина, Фоновый, ПорядокПоиска,
			ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДобавитьПоискКонвертацияВалют(Знач СтрокаПоиска, ПланПоиска)
	
	СтрокаПоиска = НРег(СтрокаПоиска);
	СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
	СловаПоиска = СтрРазделить(СтрокаПоиска, " ", Ложь);
	
	Если СловаПоиска.Количество() <> 2 Тогда
		Возврат;
	КонецЕсли;
	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СловаПоиска[0]) Тогда
		ЧислоСтрокой = СловаПоиска[0];
		ВалютаСтрокой = СловаПоиска[1];
	ИначеЕсли СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СловаПоиска[1]) Тогда
		ЧислоСтрокой = СловаПоиска[1];
		ВалютаСтрокой = СловаПоиска[0];
	Иначе
		ЧислоСтрокой = Неопределено;
		ВалютаСтрокой = Неопределено;
	КонецЕсли;
	
	Если ЧислоСтрокой = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодходящаяВалюта = ГлобальныйПоискВызовСервера.НайтиВалютуПоСтроке(ВалютаСтрокой);
	
	Если ПодходящаяВалюта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Сумма", СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ЧислоСтрокой));
	ДополнительныеПараметры.Вставить("Валюта", ПодходящаяВалюта);
	
	ПланПоиска.Добавить("ВыполнитьКонвертациюСуммыВВалюте", "ГлобальныйПоискСервер", Истина, Ложь, 1,
		ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПроверитьДобавитьПоискИНН(Знач СтрокаПоиска, ПланПоиска)
	
	СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
	ЭтоЮрЛицо = Ложь;
	ЭтоИП = Ложь;
	
	Если РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(СтрокаПоиска, Истина, "") Тогда
		ЭтоЮрЛицо = Истина;
	КонецЕсли;
	
	Если НЕ ЭтоЮрЛицо И РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(СтрокаПоиска, Ложь, "") Тогда
		ЭтоИП = Истина;
	КонецЕсли;
	
	Если НЕ ЭтоИП И НЕ ЭтоЮрЛицо Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИНН", СтрокаПоиска);
	ДополнительныеПараметры.Вставить("ЭтоЮрЛицо", ЭтоЮрЛицо);
	
	ПланПоиска.Добавить("ВыполнитьПоискКонтрагентовПоИНН", "ГлобальныйПоискСервер", Истина, Ложь, 1,
		ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПроверитьДобавитьПоискПоШтрихкодуПечатнойФормы(Знач СтрокаПоиска, ПланПоиска)
	
	СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
	Если Не ШтрихкодированиеПечатныхФормКлиент.СтрокаПохожаНаШтрихкодПечатнойФормы(СтрокаПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	Фоновый = Не ОбщегоНазначенияКлиент.РежимОтладки();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДанныеШтрихкода", СтрокаПоиска);
	
	ПланПоиска.Добавить("ВыполнитьПоискПоШтрихкодуПечатнойФормы", "ГлобальныйПоискСервер", Истина, Фоновый, 1,
		ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти
