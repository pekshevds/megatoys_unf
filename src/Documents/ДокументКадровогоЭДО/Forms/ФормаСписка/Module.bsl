#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КомандыФормыГруппа;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник'"));
	
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ВидОснования",
		Новый ОписаниеТипов(), НСтр("ru = 'Вид основания'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	ЗапрещенныеРасширения = РаботаСФайламиСлужебный.СписокЗапрещенныхРасширений();
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	ПоказыватьРеквизитыПериодаИПубликации = Ложь;
	Если Параметры.РасчетныеЛисты Тогда
		
		СкрытьПодменюВыбораВидаСписка();
		ПоказыватьРеквизитыПериодаИПубликации = Истина;
		Заголовок = НСтр("ru = 'Документы кадрового ЭДО (расчетные листки)'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "КатегорияДокумента", Перечисления.КатегорииДокументовКадровогоЭДО.РасчетныйЛисток, ВидСравненияКомпоновкиДанных.Равно, ,
			Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ИначеЕсли Параметры.ДокументыНаПодпись Тогда
		СкрытьПодменюВыбораВидаСписка();
		УстановитьВидСписка(ЭтотОбъект, Команды.НаПодпись);
	Иначе
		УстановитьВидСписка(ЭтотОбъект, Команды.ВсеДокументы);
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СодержимоеДокументов", КадровыйЭДО.ДоступныеСодержанияДокументовПользователя(Пользователи.ТекущийПользователь()), Истина);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Период",
		"Видимость",
		ПоказыватьРеквизитыПериодаИПубликации);
	
	НайденныеПараметры = ЭтотОбъект.ПараметрыКритерияОтбора.НайтиСтроки(Новый Структура("ИмяПараметра", "ВидОснования"));
	Если НайденныеПараметры.Количество() > 0 Тогда
		Элемент = Элементы.Найти(НайденныеПараметры[0].ИмяЭлементаФормыПараметра);
		Если Элемент <> Неопределено Тогда
			Элемент.РежимВыбораИзСписка = Истина;
			Элемент.ВыбиратьТип = Ложь;
			Элемент.КнопкаОчистки = Истина;
			Элемент.СписокВыбора.Очистить();
			Элемент.СписокВыбора.Добавить(Перечисления.КатегорииДокументовКадровогоЭДО.РасчетныйЛисток,
				Строка(Перечисления.КатегорииДокументовКадровогоЭДО.РасчетныйЛисток));
			Элемент.СписокВыбора.Добавить(Перечисления.КатегорииДокументовКадровогоЭДО.ЗаявлениеСотрудника,
				Строка(Перечисления.КатегорииДокументовКадровогоЭДО.ЗаявлениеСотрудника));
			Для Каждого ТипСПечатнымиФормами Из Метаданные.ОпределяемыеТипы.ОбъектСПечатнымиФормами.Тип.Типы() Цикл
				Если ТипСПечатнымиФормами = Тип("ДокументСсылка.ДокументКадровогоЭДО") Тогда
					Элемент.СписокВыбора.Добавить(ТипСПечатнымиФормами, НСтр("ru = 'Внешний документ'"));
				Иначе
					Элемент.СписокВыбора.Добавить(ТипСПечатнымиФормами, Строка(ТипСПечатнымиФормами));
				КонецЕсли;
			КонецЦикла;
			Элемент.СписокВыбора.СортироватьПоПредставлению();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекущийИсполнитель", Пользователи.ТекущийПользователь());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновленыДанныеДокументовКЭДО" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
	Если СтрНачинаетсяС(Элемент.Имя, "ВидОснования_") Тогда
		
		НайденныеПараметры = ЭтотОбъект.ПараметрыКритерияОтбора.НайтиСтроки(Новый Структура("ИмяПараметра", "ВидОснования"));
		Если НайденныеПараметры.Количество() > 0 Тогда
			
			Использование = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтотОбъект, НайденныеПараметры[0].ИмяРеквизитаФормыПараметраИспользование);
			
			ВидОснования = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтотОбъект, НайденныеПараметры[0].ИмяРеквизитаФормыПараметра);
			
			Если ВидОснования = Неопределено Тогда
				ВидОснования = Тип("Строка");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список, "Внешний", Истина,
				Использование И ВидОснования = Тип("ДокументСсылка.ДокументКадровогоЭДО"));
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список, "ВидОснованияКатегория", ВидОснования,
				Использование И ТипЗнч(ВидОснования) = Тип("ПеречислениеСсылка.КатегорииДокументовКадровогоЭДО"));
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список, "ВидОснованияДокумент", ВидОснования,
				Использование И ТипЗнч(ВидОснования) <> Тип("ПеречислениеСсылка.КатегорииДокументовКадровогоЭДО"));
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаСкопировать",
		"Доступность",
		Элемент.ТекущиеДанные <> Неопределено И Элемент.ТекущиеДанные.Внешний);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ВсеДокументы(Команда)
	
	УстановитьВидСписка(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НаПодпись(Команда)
	
	УстановитьВидСписка(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписанные(Команда)
	
	УстановитьВидСписка(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаСервере
Процедура СкрытьПодменюВыбораВидаСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидСпискаПодменю",
		"Видимость",
		Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидСписка(УправляемаяФорма, Команда)
	
	Элементы = УправляемаяФорма.Элементы;
	Команды = УправляемаяФорма.Команды;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		УправляемаяФорма.Список, "Исполнители", УправляемаяФорма.ТекущийПользователь,
		Команда = Команды.НаПодпись);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		УправляемаяФорма.Список, "Подписанты", УправляемаяФорма.ТекущийПользователь,
		Команда = Команды.Подписанные);
	
	Если Команда = Команды.ВсеДокументы Тогда
		УправляемаяФорма.Заголовок = НСтр("ru = 'Документы кадрового ЭДО'");
		УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, Элементы.ВсеДокументы);
	ИначеЕсли Команда = Команды.НаПодпись Тогда
		УправляемаяФорма.Заголовок = НСтр("ru = 'Документы кадрового ЭДО (на подпись мне)'");
		УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, Элементы.НаПодпись);
	ИначеЕсли Команда = Команды.Подписанные Тогда
		УправляемаяФорма.Заголовок = НСтр("ru = 'Документы кадрового ЭДО (подписанные мною)'");
		УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, Элементы.Подписанные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Список.ЭлектронныйДокумент");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ПравоеЗначение	= Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Список.ОснованиеДокумента"));
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЭлектронныйДокумент");
	ОформляемоеПоле.Использование = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, ВыбранныйВидСписка)
	
	Элементы = УправляемаяФорма.Элементы;
	Для Каждого ПодчиненныйЭлемент Из Элементы.ВидСпискаПодменю.ПодчиненныеЭлементы Цикл
		ПодчиненныйЭлемент.Пометка = ПодчиненныйЭлемент = ВыбранныйВидСписка;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
