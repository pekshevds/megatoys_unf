
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ПараметрыКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ПараметрыКонтактнойИнформации.ИмяЭлементаДляРазмещения = Элементы.КонтактнаяИнформация.Имя;
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ПараметрыКонтактнойИнформации);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиУНФ.ЗаполнитьДополнительныеПараметры(Объект,
		"ДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	НаборСвойств_Справочник_ФизическиеЛица = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_ФизическиеЛица");
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	АвтоподборКонтактов.ПодключитьОбработчикиСобытияАвтоподбор(ЭтотОбъект);
	
	Параметры.Свойство("КлассификаторДляЗаполненияКИ", КлассификаторДляЗаполненияКИ);
	Если ЗначениеЗаполнено(КлассификаторДляЗаполненияКИ)
		И Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьНаименованиеИКонтактнуюИнформацию(КлассификаторДляЗаполненияКИ);
	КонецЕсли;
	
	Если Параметры.ОшибкиЗаполнения Тогда
		ПроверкаДанных.ВывестиСообщенияОбОшибкахЗаполнения("Объект", Параметры.ПереченьОшибок);
	КонецЕсли;
	
	ПолучитьАктуальныйДокументФизическогоЛица();
	
	ОбновитьПоляФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И ЗначениеЗаполнено(КлассификаторДляЗаполненияКИ) Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	ИначеЕсли ИмяСобытия = "ИзменилсяДокументФизЛиц" Тогда
		ПолучитьАктуальныйДокументФизическогоЛица();
	ИначеЕсли ИмяСобытия = "УстановкаОсновногоСчета" И Параметр.Владелец = Объект.Ссылка Тогда
		Объект.БанковскийСчетПоУмолчанию = Параметр.НовыйОсновнойСчет;
		Если НЕ Модифицированность Тогда
			Записать();
		КонецЕсли;
		Оповестить("УстановкаОсновногоСчетаВыполнена");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СправочникФизическиеЛицаЗапись");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиФормыОбъектаСклонения(
		ЭтотОбъект,
		Объект.Наименование,
		ТекущийОбъект.Ссылка,
		ПараметрыСклоненияФИО(ТекущийОбъект));
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	ОбновитьЗаписьИсторииФИО(ТекущийОбъект.Ссылка, ТекущийОбъект.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	Оповестить("Запись_ФизическиеЛица", Объект.Ссылка)
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьПоляФИО();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(
		ЭтотОбъект, Объект.Наименование, ПараметрыСклоненияФИО(Объект));
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	ОбновитьЗаписьИсторииФИО(Объект.Ссылка, Объект.Наименование);
	ОбновитьПоляФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	// УНФ Автоподбор контактов
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ОписаниеОповещения") Тогда
		СтандартнаяОбработка = Ложь;
		ВыполнитьОбработкуОповещения(ВыбранноеЗначение);
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КлассификаторКонтактов") Тогда
		СтандартнаяОбработка = Ложь;
		ЗаполнитьНаименованиеИКонтактнуюИнформацию(ВыбранноеЗначение);
	КонецЕсли;
	// Конец УНФ автоподбор контактов
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АвтоподборКонтактовКлиент.НаименованиеАвтоПодбор(ЭтотОбъект, Элемент.Имя, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(
		ЭтотОбъект, Объект.Наименование, ПараметрыСклоненияФИО(Объект));
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НачатьРедактированиеДокументовФизическогоЛица();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", НаборСвойств_Справочник_ФизическиеЛица);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФИО(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Наименование", Объект.Наименование);
		
		ОписаниеОЗакрытии = Новый ОписаниеОповещения("ОбработатьИзменениеФИО", ЭтотОбъект);
		
		ОткрытьФорму("РегистрСведений.ФИОФизическихЛиц.Форма.ФормаИзмененияФИО", ПараметрыОткрытияФормы, ЭтотОбъект, , , , 
			ОписаниеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Физическое лицо необходимо записать перед изменением'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ОбновитьЗаписьИсторииФИО(СсылкаФизЛицо, Наименование, Период = Неопределено)
	
	Если ЗначениеЗаполнено(СсылкаФизЛицо) Тогда
		
		СтруктураФИО = ПолучитьСтруктуруФИОПоИмени(Наименование);
		
		РегистрыСведений.ФИОФизическихЛиц.ОбновитьПоследнююЗаписьФизЛица(СсылкаФизЛицо, СтруктураФИО, Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтруктуруФИОПоИмени(ПолноеИмя)
	
	Перем ЛокальнаяФамилия, ЛокальноеИмя, ЛокальноеОтчество;
	
	Результат = Новый Структура("Фамилия, Имя, Отчество");
	ЧастиФИО = СтрРазделить(ПолноеИмя, " ");
	Если ЧастиФИО.Количество() > 0 Тогда
		
		ЛокальнаяФамилия = ЧастиФИО[0];
		
		Если ЧастиФИО.Количество() > 1 Тогда
			ЛокальноеИмя = ЧастиФИО[1];
		КонецЕсли;
		
		Если ЧастиФИО.Количество() > 2 Тогда
			
			ЧастиОтчества = Новый Массив;
			Для индекс = 2 По ЧастиФИО.Количество() - 1 Цикл
				ЧастиОтчества.Добавить(ЧастиФИО[индекс]);
			КонецЦикла;
			ЛокальноеОтчество = СтрСоединить(ЧастиОтчества, " ");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат.Фамилия = ЛокальнаяФамилия;
	Результат.Имя = ЛокальноеИмя;
	Результат.Отчество = ЛокальноеОтчество;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьИзменениеФИО(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		МассивФИО = Новый Массив;
		МассивФИО.Добавить(Результат.Фамилия);
		МассивФИО.Добавить(Результат.Имя);
		МассивФИО.Добавить(Результат.Отчество);
		НовоеНаименование = СтрСоединить(МассивФИО, " ");
		ОбновитьЗаписьИсторииФИО(Объект.Ссылка, НовоеНаименование, Результат.Период);
		
		Запись = ПолучитьСтруктуруФИОИзРегистра(Объект.Ссылка);
		МассивФИО = Новый Массив;
		МассивФИО.Добавить(Запись.Фамилия);
		МассивФИО.Добавить(Запись.Имя);
		МассивФИО.Добавить(Запись.Отчество);
		ТекущееНаименование = СтрСоединить(МассивФИО, " ");
		Объект.Наименование = ТекущееНаименование;
		Модифицированность = Истина;
		
		ОбновитьПоляФИО();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПоляФИО(Период = Неопределено)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запись = ПолучитьСтруктуруФИОИзРегистра(Объект.Ссылка);
		Фамилия = Запись.Фамилия;
		Имя = Запись.Имя;
		Отчество = Запись.Отчество;
		МассивЧастей = Новый Массив;
		
		Если ЗначениеЗаполнено(Фамилия) Тогда
			СтрокаФамилия = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru='Фамилия: %1'"), Фамилия);
			МассивЧастей.Добавить(СтрокаФамилия);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Имя) Тогда
			СтрокаИмя = СтроковыеФункции.ФорматированнаяСтрока(" " + НСтр("ru='• Имя: %1'"), Имя);
			МассивЧастей.Добавить(СтрокаИмя);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Отчество) Тогда
			СтрокаОтчество = СтроковыеФункции.ФорматированнаяСтрока(" " + НСтр("ru='• Отчество: %1'"), Отчество);
			МассивЧастей.Добавить(СтрокаОтчество);
		КонецЕсли;
		
		ТекстПодсказки = СтрСоединить(МассивЧастей);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФИОНадпись", 
			"Заголовок", ТекстПодсказки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруФИОИзРегистра(ФизЛицоСсылка, Период = Неопределено)
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Отбор = Новый Структура("ФизическоеЛицо", ФизЛицоСсылка);
	Запись = РегистрыСведений.ФИОФизическихЛиц.ПолучитьПоследнее(Период, Отбор);
	
	Возврат Запись;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНаименованиеИКонтактнуюИнформацию(КлассификаторСсылка)
	
	ДанныеКонтакта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	КлассификаторСсылка,
	"Title, JSON");
	
	Объект.Наименование = ДанныеКонтакта.Title;
	
	Объект.КонтактнаяИнформация.Очистить();
	
	Справочники.КлассификаторКонтактов.ЗаполнитьКонтактнуюИнформациюИзJSON(
	Объект.КонтактнаяИнформация,
	ДанныеКонтакта.JSON,
	ТипЗнч(Объект.Ссылка));
	
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполненияДокументаФизическогоЛица(Результат, Параметры) Экспорт
	
	ПолучитьАктуальныйДокументФизическогоЛица();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыСклоненияФИО(Объект)
	
	Если Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской") Тогда
		ПолФизическогоЛицаЧислом = 1;
	ИначеЕсли Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский") Тогда
		ПолФизическогоЛицаЧислом = 2;
	Иначе
		ПолФизическогоЛицаЧислом = Неопределено;
	КонецЕсли;
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = Истина;
	Если ПолФизическогоЛицаЧислом <> Неопределено Тогда
		ПараметрыСклонения.Пол = ПолФизическогоЛицаЧислом;
	КонецЕсли;
	
	Возврат ПараметрыСклонения;
	
КонецФункции

#Область ДокументыФизическогоЛица

&НаКлиенте
Процедура НачатьРедактированиеДокументовФизическогоЛица()
	
	Продолжение = Новый ОписаниеОповещения("РедактироватьДокументыФизическогоЛица", ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗадатьВопросПередРедактированиемДокументовФизическогоЛица(Продолжение);
	Иначе
		ВыполнитьОбработкуОповещения(Продолжение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросПередРедактированиемДокументовФизическогоЛица(Продолжение)
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Записать'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отмена'"));
	Оповещение = Новый ОписаниеОповещения("ПослеВопросаПередРедактированиемДокументовФизическогоЛица", ЭтотОбъект, Продолжение);
	
	ТекстВопроса = НСтр("ru='Переход к заполнению сведений документов возможен только после записи.
		|Записать?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаПередРедактированиемДокументовФизическогоЛица(Результат, Продолжение) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Записать();
	ВыполнитьОбработкуОповещения(Продолжение);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДокументыФизическогоЛица(Результат, ДополнительныеПараметры) Экспорт
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОповещениеЗаполненияДокументаФизическогоЛица", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФизЛицо", Объект.Ссылка);
	ОткрытьФорму("РегистрСведений.ДокументыФизическихЛиц.Форма.ФормаЗаполненияСведений", ПараметрыФормы,,,,, ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьАктуальныйДокументФизическогоЛица()
	
	Документ = РегистрыСведений.ДокументыФизическихЛиц.ПолучитьПредставлениеДокументаПоФизЛицу(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.НачатьИзменение(ЭтотОбъект, Элемент);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьОчистку(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда.Имя);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьОбработкуНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьОбновлениеКонтактнойИнформации(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьКонтактнуюИнформацию(Результат);
КонецПроцедуры
&НаСервере
Процедура ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

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

// СтандартныеПодсистемы.Свойства
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_РедактироватьСоставСвойств()

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

//@skip-check module-unused-method
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ПоказатьСклонение(
		ЭтотОбъект, Объект.Наименование, ПараметрыСклоненияФИО(Объект));
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти

#КонецОбласти
