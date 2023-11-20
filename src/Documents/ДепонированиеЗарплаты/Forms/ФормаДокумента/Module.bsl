
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ДепонированиеЗарплатыФормыВнутренний.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
			ЭтотОбъект,
			ТекущийОбъект,
			ПараметрыЗаписи);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить(ВзаиморасчетыССотрудникамиКлиент.ИмяСобытияИзмененияОплатыВедомости());
	Оповестить("Запись_ДепонированиеЗарплаты", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
    ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	УстановитьДоступностьЭлементов(ЭтотОбъект);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗаполнитьДанныеФормыПоОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьПриИзменении(Элемент) 
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	УстановитьДоступностьЭлементов(ЭтотОбъект);
	УстановитьПараметрыВыбораФизическогоЛица(ЭтотОбъект);
КонецПроцедуры

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДепоненты

&НаКлиенте
Процедура ДепонентыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ДепонентыПриОкончанииРедактированияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДепонентыПослеУдаления(Элемент)
	ДепонентыПослеУдаленияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДепонентыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		ВыбранныеФизЛица = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ВыбранныеФизЛица = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВыбранноеЗначение)
	КонецЕсли;
	
	Для Каждого ФизическоеЛицо Из ВыбранныеФизЛица Цикл
		Если Объект.Депоненты.НайтиСтроки(Новый Структура("ФизическоеЛицо", ФизическоеЛицо)).Количество() = 0 Тогда
			Объект.Депоненты.Добавить().ФизическоеЛицо = ФизическоеЛицо;
		КонецЕсли	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОчиститьСообщения();
	
	ПроверяемыеСвойства = Новый Структура;
	ПроверяемыеСвойства.Вставить("Организация", НСтр("ru='Не выбрана организация'"));
	ПроверяемыеСвойства.Вставить("Ведомость",   НСтр("ru='Не указана ведомость'"));
	
	Если ЗарплатаКадрыКлиент.СвойстваЗаполнены(Объект, ПроверяемыеСвойства) Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)

	ОчиститьСообщения();
	
	ПроверяемыеСвойства = Новый Структура;
	ПроверяемыеСвойства.Вставить("Ведомость", НСтр("ru='Не указана ведомость'"));
	
	Если ЗарплатаКадрыКлиент.СвойстваЗаполнены(Объект, ПроверяемыеСвойства) Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		Отбор = Новый Структура("Ссылка", ФизическиеЛицаВедомости(Объект.Ссылка, Объект.Ведомость));
		ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
		
		КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(
			Элементы.Депоненты, 
			Объект.Организация,
			АдресСпискаПодобранныхФизлиц(),,
			ПараметрыОткрытияФормы);
			
	КонецЕсли;	
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
			Команда,
			ЭтотОбъект,
			Объект);
	КонецЕсли;
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// АПК:78-выкл Экспорт необходим для вызова из переопределяемого поведения 

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения() Экспорт
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере() Экспорт
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	УстановитьДоступностьЭлементов(ЭтотОбъект);
	УстановитьПараметрыВыбораФизическогоЛица(ЭтотОбъект);

КонецПроцедуры

// АПК:78-вкл

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ЗаполнитьДанныеФормыПоОрганизации();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()

	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	ОрганизацияВыбрана	= ЗначениеЗаполнено(Форма.Объект.Организация);
	ВедомостьВыбрана	= ЗначениеЗаполнено(Форма.Объект.Ведомость);

	Форма.Элементы.Ведомость.Доступность       = ОрганизацияВыбрана;
	Форма.Элементы.ДепонентыГруппа.Доступность = ВедомостьВыбрана;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ТекущийОбъект  = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.Ведомость);
	ЗначениеВРеквизитФормы(ТекущийОбъект , "Объект");
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораФизическогоЛица(Форма)
	
	ПараметрыВыбора = 
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			Новый ПараметрВыбора(
				"Отбор.Ссылка", 
				ФизическиеЛицаВедомости(Форма.Объект.Ссылка, Форма.Объект.Ведомость)));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ДепонентыФизическоеЛицо", 
		"ПараметрыВыбора", 
		Новый ФиксированныйМассив(ПараметрыВыбора));

КонецПроцедуры
	
&НаСервереБезКонтекста
Функция ФизическиеЛицаВедомости(Ссылка, Ведомость)
	
	Если Не ЗначениеЗаполнено(Ведомость) Тогда
		Возврат Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	// Невыплаченные строки ведомости.
	ДанныеВедомости = 
		ВзаиморасчетыССотрудниками.ДанныеВедомостейДляОплатыДокументом(
			Ссылка, 
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ведомость),, 
			Ложь);
	ДанныеВедомости.Свернуть("ФизическоеЛицо");
	
	Возврат Новый ФиксированныйМассив(ДанныеВедомости.ВыгрузитьКолонку("ФизическоеЛицо"))
	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхФизлиц() Экспорт
	Возврат 
		ПоместитьВоВременноеХранилище(
			Объект.Депоненты.Выгрузить(,"ФизическоеЛицо").ВыгрузитьКолонку("ФизическоеЛицо"), 
			УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ДепонентыПриОкончанииРедактированияНаСервере()
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ДепонентыПослеУдаленияНаСервере()
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

// АПК:78-выкл Экспорт необходим для вызовов из внешнего механизма

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Депоненты");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация", НСтр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Ведомость",   НСтр("ru = 'ведомости'")));
	Возврат Массив
КонецФункции

// АПК:78-вкл

#КонецОбласти

#КонецОбласти
