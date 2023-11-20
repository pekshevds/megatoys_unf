&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сейчас = Параметры.Сейчас;
	
	ИспользуетсяОднаОрганизация = РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация();
	
	ЗаполнитьТаблицуТребований();
	
	Если ТаблицаТребований.Количество() = 0 Тогда
		Отказ = Истина;
	Иначе
		УправлениеФормой();
	КонецЕсли;
	
	Если ТаблицаТребований.Количество() > 1 Тогда
		Ширина = 100;
		КлючСохраненияПоложенияОкна = "НесколькоТребований";
	Иначе
		Ширина = 80;
		КлючСохраненияПоложенияОкна = "ОдноТребование";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	// В процедуре ниже ничего не писать - это асинхронный метод!

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УспешноеПодтверждение" Тогда
		
		УдалитьТребованиеИзСписка(Источник);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаТребований

&НаКлиенте
Процедура НадписьПодвалОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТребованияФНСКлиент.ПоказатьИнформациюоСроках();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТребованийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрТребование = ТаблицаТребований.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(,СтрТребование.Требование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НеПоказывать(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВсе(Команда)
	
	Если ТаблицаТребований.Количество() = 1 Тогда
		СтрТребования = ТаблицаТребований[0];
		ПоказатьЗначение(,СтрТребования.Требование);
	Иначе
		Если НЕ ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ФормаОткрыта("ОбщаяФорма.РегламентированнаяОтчетность") Тогда
			ПараметрыФормы = Новый Структура("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Входящие"));
			ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыФормы, , "1С-Отчетность");
		КонецЕсли;
		Оповестить("Показать требующие внимание требования");
	КонецЕсли;
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьТребованиеИзСписка(Требование)
	
	Таблица = РеквизитФормыВЗначение("ТаблицаТребований");
	
	Отбор = Новый Структура();
	Отбор.Вставить("Требование", Требование);
	
	НайденныеСтроки = Таблица.НайтиСтроки(Отбор);
		
	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Таблица.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Таблица, "ТаблицаТребований");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбщиеСведения(НоваяСтрока, КонтекстЭДОСервер, Требование, РасчетСрока)

	Сведения = КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(Требование);
	
	НоваяСтрока.Требование = Требование;
	НоваяСтрока.Организация = Требование.Организация;
	НоваяСтрока.ПредставлениеГосОргана = Сведения.ПредставлениеКонтролирующегоОргана;
	НоваяСтрока.Номер = Требование.НомерДокумента;
	НоваяСтрока.ВидДокумента  = Требование.ВидДокумента;
	НоваяСтрока.Дата  = Требование.ДатаДокумента;
	НоваяСтрока.СрокПредставление = РасчетСрока.ПредставлениеДляТаблицы;
	НоваяСтрока.Приоритет = РасчетСрока.Осталось;
	НоваяСтрока.Просрочено = РасчетСрока.ДобавитьОгонек;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТребований()

	ДобавитьТребующиеПодтверждения();
	ДобавитьТребующиеОтвета();
	
	Если ИспользуетсяОднаОрганизация Тогда
		ТаблицаТребований.Сортировать("Приоритет");
	Иначе
		ТаблицаТребований.Сортировать("Организация, Приоритет");
		СгруппироватьПоОрганизациям();
	КОнецЕсли;

КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоОрганизациям()
	
	Если ИспользуетсяОднаОрганизация Тогда
		Возврат;
	КонецЕсли;
	
	Организация = "";
	й = 0;
	Пока й < ТаблицаТребований.Количество() Цикл
		
		Строка = ТаблицаТребований[й];
		Если Строка.Организация <> Организация Тогда
			НоваяСтрока = ТаблицаТребований.Вставить(й);
			НоваяСтрока.ВидДокумента = Строка.Организация;
			НоваяСтрока.Жирным = Истина;
			Организация = Строка.Организация;
		КонецЕсли;
		
		й = й + 1;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДобавитьТребующиеПодтверждения()

	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	ТребующиеПодтверждения = ТребованияФНС.ТребующиеСкорогоПодтверждения();
	Для каждого Требование Из ТребующиеПодтверждения Цикл
		
		НоваяСтрока = ТаблицаТребований.Добавить();
		
		Состояние = ТребованияФНС.РасширенноеСостояниеПодтвержденияИОтвета(Требование, Сейчас);
		РасчетСрока = ТребованияФНС.ПредставлениеПодтверждения(Состояние, Сейчас);
		
		ЗаполнитьОбщиеСведения(НоваяСтрока, КонтекстЭДОСервер, Требование, РасчетСрока);
	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДобавитьТребующиеОтвета()

	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	ТребующиеОтвета = ТребованияФНС.ТребующиеСкорогоОтвета();
	Для каждого Требование Из ТребующиеОтвета Цикл
		
		НоваяСтрока = ТаблицаТребований.Добавить();
		
		Состояние = ТребованияФНС.РасширенноеСостояниеПодтвержденияИОтвета(Требование, Сейчас);
		РасчетСрока = ТребованияФНС.ПредставлениеОтвета(Состояние, Сейчас);
		
		ЗаполнитьОбщиеСведения(НоваяСтрока, КонтекстЭДОСервер, Требование, РасчетСрока);
	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ОдноТребование = ТаблицаТребований.Количество() = 1;
	
	Если ОдноТребование Тогда
		
		ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Двойной;
		
		Представление = НСтр("ru = 'По документу %1 по организации %2 от %3 %4.'");
		
		Строка = ТаблицаТребований[0];
		Элементы.НадписьШапка.Заголовок = СтрШаблон(
			Представление,
			Строка.Требование,
			Строка.Организация,
			Строка.ПредставлениеГосОргана,
			НРег(Строка.СрокПредставление));
			
		Элементы.ТаблицаТребований.Видимость = Ложь;
		Элементы.Открыть.Заголовок = НСтр("ru = 'Открыть требование'");
		
	Иначе
		
		ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Авто;
		
		Элементы.Открыть.Заголовок = НСтр("ru = 'Перейти к требованиям'");
		Текст = ТребованияФНСКлиентСервер.ТекстДляПанелиТребований(Ложь);
		
		Элементы.НадписьШапка.Заголовок = Строка(Текст);
		УсловноеОформлениеТребований();
		
	КонецЕсли;
	
	Есть = ТребованияФНСВызовСервера.ЕстьТребующиеСкорогоПодтверждения();
	Элементы.ПодтвердитьПрием.Видимость = Есть;
	
КонецПроцедуры

&НаСервере
Процедура УсловноеОформлениеТребований()
	
	ВыделитьЦветом(ЦветаСтиля.ЦветОшибкиОтправкиБРО);
	 
КонецПроцедуры

&НаСервере
Процедура ВыделитьЦветом(Цвет)
	
	ЭлементОформления = ТребованияФНСКлиентСервер.ВыделитьЦветом(ЭтотОбъект, Цвет, "ТаблицаТребований.Цвет", Цвет);
	УсловноеОформление.Элементы.Добавить();
	
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаТребованийСрокПредставление");
	ПолеОформления.Использование = Истина;
	 
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПрием(Команда)
	
	ТребованияФНСКлиент.ПодтвердитьПриемНескольких(Сейчас, КонтекстЭДОКлиент);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

#КонецОбласти

