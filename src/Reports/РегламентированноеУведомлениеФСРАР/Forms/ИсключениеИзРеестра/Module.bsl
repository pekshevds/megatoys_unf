
#Область ОбработчикиСобытийФормы

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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	
	Параметры.Свойство("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ВидУведомления", ВидУведомления);
	НужноОповещатьОСоздании = Ложь;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Организация = Объект.Организация;
	Иначе
		Организация = Параметры.Организация;
		Параметры.Свойство("Организация", Объект.Организация);
	КонецЕсли;
	
	ЭтотОбъект.Заголовок = ВидУведомления;
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		Объект.ВидУведомления = ВидУведомления;
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтрРазделить(ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтотОбъект);
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	СформироватьМакетНаСервере();
	ЗагрузитьДанные();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.НаименованиеЭтапа.Заголовок = "В работе";
	Иначе
		Статус = РегламентированнаяОтчетность.СохраненныйСтатусОтправкиУведомления(Объект.Ссылка);
		Если Статус <> Неопределено Тогда
			Элементы.НаименованиеЭтапа.Заголовок
			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1'"), Статус);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтотОбъект, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ЗагрузитьДанные()
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьТитульный();
		
		Если Параметры.Свойство("ЗначениеКопирования")
			И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда 
			
			СтруктураПараметров = Параметры.ЗначениеКопирования.ДанныеУведомления.Получить();
			Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
				Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
					И Обл.СодержитЗначение = Истина Тогда 
					
					СтруктураПараметров.Титульный.Свойство(Обл.Имя, Обл.Значение);
					ДанныеСтраницы.Вставить(Обл.Имя, Обл.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение = Истина Тогда 
			
			СтруктураПараметров.Титульный.Свойство(Обл.Имя, Обл.Значение);
			ДанныеСтраницы.Вставить(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = ВидУведомления;
		Объект.Организация = Организация;
		Объект.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение = Истина Тогда 
			
			ДанныеСтраницы[Обл.Имя] = Обл.Значение;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура("Титульный, ИмяЭкраннойФормы", ДанныеСтраницы, ИмяЭкраннойФормы);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТитульный_ИсключениеИзРеестраПроизводителейПива()
	ДП = ?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса());
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		СтрокаСведений = "НаимЮЛПол";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
		ПредставлениеОрганизации(СведенияОбОрганизации.НаимЮЛПол, 65);
	Иначе 
		СтрокаСведений = "ФИО";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
		ПредставлениеОрганизации(СведенияОбОрганизации.ФИО, 65);
	КонецЕсли;
	
	ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение = Объект.ДатаПодписи;
КонецПроцедуры

&НаСервере
Процедура ПредставлениеОрганизации(ИсходноеЗначение, Дл)
	Пока СтрНайти(ИсходноеЗначение, "  ") > 0 Цикл 
		ИсходноеЗначение = СтрЗаменить(ИсходноеЗначение, "  ", " ");
	КонецЦикла;
	
	НаимОрг1 = "";
	НаимОрг2 = "";
	
	Пока Истина Цикл
		ИсходноеЗначение = СокрЛП(ИсходноеЗначение);
		Если СтрДлина(ИсходноеЗначение) = 0 Тогда 
			Прервать;
		КонецЕсли;
		ИндексПробела = СтрНайти(ИсходноеЗначение, " ");
		Если ИндексПробела = 0 Тогда
			СловоДляВывода = ИсходноеЗначение;
		Иначе
			СловоДляВывода = Лев(ИсходноеЗначение, ИндексПробела - 1);
		КонецЕсли;
		
		Если СтрДлина(НаимОрг1) + СтрДлина(СловоДляВывода) <= Дл Тогда 
			НаимОрг1 = НаимОрг1 + " " + СловоДляВывода;
			ИсходноеЗначение = Сред(ИсходноеЗначение, СтрДлина(СловоДляВывода) + 1);
		Иначе
			НаимОрг2 = ИсходноеЗначение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПредставлениеУведомления.Области["НаимОрг1"].Значение = НаимОрг1;
	ПредставлениеУведомления.Области["НаимОрг2"].Значение = НаимОрг2;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТитульный()
	Если Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИсключениеИзРеестраПроизводителейПива Тогда
		ЗаполнитьТитульный_ИсключениеИзРеестраПроизводителейПива();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяЭкраннойФормы()
	Если ЗначениеЗаполнено(ИмяЭкраннойФормы) Тогда 
		Возврат ИмяЭкраннойФормы;
	Иначе
		Возврат СоответствиеИменЭкраннойФормы()[ВидУведомления];
	КонецЕсли;
КонецФункции

&НаСервере
Функция СоответствиеИменЭкраннойФормы()
	Результат = Новый Соответствие;
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИсключениеИзРеестраПроизводителейПива, "Форма_ИсключениеИзРеестраПроизводителейПива");
	Возврат Результат;
КонецФункции

&НаСервере
Процедура СформироватьМакетНаСервере()
	ДанныеСтраницы = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
		СтруктураПараметров.Свойство("ИмяЭкраннойФормы", ИмяЭкраннойФормы);
	КонецЕсли;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, ПолучитьИмяЭкраннойФормы());
	Область = Макет.ПолучитьОбласть("Титульный");
	ПредставлениеУведомления.Очистить();
	ПредставлениеУведомления.Вывести(Область);
	ПредставлениеУведомления.ВыделенныеОбласти.Очистить();
	ТекущийЭлемент = Элементы.ПредставлениеУведомления;
	Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Область(1,1,1,1);
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение = Истина Тогда 
			
			ДанныеСтраницы.Вставить(Обл.Имя);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	ДанныеСтраницы[Область.Имя] = Область.Значение;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если Область.СодержитЗначение = Истина
		И ТипЗнч(Область.Значение) = Тип("Булево") Тогда 
	
		СтандартнаяОбработка = Ложь;
		Область.Значение = Не Область.Значение;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеСтатусаНажатие(Элемент)
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПустаяСсылка"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, "Открыть", Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти