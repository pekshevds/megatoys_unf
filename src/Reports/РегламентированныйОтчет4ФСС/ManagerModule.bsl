#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Год(НаДату) >= 2010 Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСС;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв4";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минздравсоцразвития РФ от 06.11.2009 N 871н (в редакции приказа Минздравсоцразвития РФ от 21.12.2010 № 1147н).";
	НоваяФорма.РедакцияФормы      = "от 21.12.2010 № 1147н.";
	НоваяФорма.ДатаНачалоДействия = '2010-12-01';
	НоваяФорма.ДатаКонецДействия  = '2010-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение №1 к Приказу Минздравсоцразвития России от 12.03.2012 № 216н.";
	НоваяФорма.РедакцияФормы      = "от 12.03.2012 № 216н.";
	НоваяФорма.ДатаНачалоДействия = '2012-01-01';
	НоваяФорма.ДатаКонецДействия  = '2013-05-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Минздравсоцразвития России от 28.02.2011 № 156н.";
	НоваяФорма.РедакцияФормы      = "от 28.02.2011 № 156н.";
	НоваяФорма.ДатаНачалоДействия = '2011-01-01';
	НоваяФорма.ДатаКонецДействия  = '2012-03-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв3";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Минздравсоцразвития России от 12.03.2012 № 216н (в редакции приказа Минтруда России от 31.08.2012 № 152н).";
	НоваяФорма.РедакцияФормы      = "от 31.08.2012 № 152н.";
	НоваяФорма.ДатаНачалоДействия = '2012-09-01';
	НоваяФорма.ДатаКонецДействия  = '2013-05-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв2";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Минтруда России от 19.03.2013 № 107н.";
	НоваяФорма.РедакцияФормы      = "от 19.03.2013 № 107н.";
	НоваяФорма.ДатаНачалоДействия = '2013-06-01';
	НоваяФорма.ДатаКонецДействия  = '2013-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Минтруда России от 19.03.2013 № 107н (в редакции приказа Минтруда от 11.02.2014 № 94н).";
	НоваяФорма.РедакцияФормы      = "от 11.02.2014 № 94н.";
	НоваяФорма.ДатаНачалоДействия = '2014-01-01';
	НоваяФорма.ДатаКонецДействия  = '2014-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФСС РФ от 26.02.2015 № 59.";
	НоваяФорма.РедакцияФормы      = "от 26.02.2015 № 59.";
	НоваяФорма.ДатаНачалоДействия = '2015-01-01';
	НоваяФорма.ДатаКонецДействия  = '2015-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФСС РФ от 26.02.2015 № 59 (в редакции приказа ФСС РФ от 25.02.2016 № 54).";
	НоваяФорма.РедакцияФормы      = "от 25.02.2016 № 54.";
	НоваяФорма.ДатаНачалоДействия = '2016-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-06-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв3";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФСС РФ от 26.02.2015 № 59 (в редакции приказа ФСС РФ от 04.07.2016 № 260).";
	НоваяФорма.РедакцияФормы      = "от 04.07.2016 № 260.";
	НоваяФорма.ДатаНачалоДействия = '2016-07-01';
	НоваяФорма.ДатаКонецДействия  = '2016-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФСС РФ от 26.09.2016 № 381.";
	НоваяФорма.РедакцияФормы      = "от 26.09.2016 № 381.";
	НоваяФорма.ДатаНачалоДействия = '2017-01-01';
	НоваяФорма.ДатаКонецДействия  = '2017-08-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв3";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФСС РФ от 26.09.2016 № 381 (в редакции приказа ФСС РФ от 07.06.2017 № 275).";
	НоваяФорма.РедакцияФормы      = "от 07.06.2017 № 275.";
	НоваяФорма.ДатаНачалоДействия = '2017-09-01';
	НоваяФорма.ДатаКонецДействия  = '2022-03-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022Кв2";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФСС РФ от 14.03.2022 № 80.";
	НоваяФорма.РедакцияФормы      = "от 14.03.2022 № 80.";
	НоваяФорма.ДатаНачалоДействия = '2022-04-01';
	НоваяФорма.ДатаКонецДействия  = '2022-12-31';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2012Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2012Кв3"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2013Кв2"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2014Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв3" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел I (таблица 1)
		// 019 - сумма
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел1_1") Тогда
			
			НалогКУплате = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел1_1;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			КодСтрокиСумма = "П000010019003";
			
			Сумма = ТаблицаДанныхРеглОтчета.Добавить();
			Сумма.Период = Период;
			Сумма.Сумма  = НалогКУплате[КодСтрокиСумма];
			
		КонецЕсли;
		
	ИначеЕсли ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2017Кв1"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2017Кв3" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Сумма по строке 019 таблицы 2.
		//
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаТаблица2") Тогда
			
			НалогКУплате = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТаблица2;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			КодСтрокиСумма = "П000020019003";
			
			Сумма = ТаблицаДанныхРеглОтчета.Добавить();
			Сумма.Период = Период;
			Сумма.Сумма  = НалогКУплате[КодСтрокиСумма];
			
		КонецЕсли;
		
	ИначеЕсли ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2022Кв2" Тогда
		
		Возврат ТаблицаДанныхРеглОтчета;
		
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20101201 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2010-12-21', "1147н", "ФормаОтчета2010Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20101201, "0.1");
	
	Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2011-02-28', "156н", "ФормаОтчета2011Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20110101, "0.3");
	
	Форма20120301 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2012-03-12', "216н", "ФормаОтчета2012Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120301, "0.4");
	
	Форма20120701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2012-08-31', "152н", "ФормаОтчета2012Кв3");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120701, "0.5");
	
	Форма20130601 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2013-03-19', "107н", "ФормаОтчета2013Кв2");
	ОпределитьФорматВДеревеФормИФорматов(Форма20130601, "0.5");
	
	ФормаОтчета2014Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2014-02-11', "94н", "ФормаОтчета2014Кв1");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2014Кв1, "0.6");
	
	ФормаОтчета2015Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2015-02-26', "59", "ФормаОтчета2015Кв1");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2015Кв1, "0.7");
	
	ФормаОтчета2016Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2016-02-25', "54", "ФормаОтчета2016Кв1");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2016Кв1, "0.8");
	
	ФормаОтчета2016Кв3 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2016-07-04', "260", "ФормаОтчета2016Кв3");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2016Кв3, "0.9");
	
	ФормаОтчета2017Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2016-09-26', "381", "ФормаОтчета2017Кв1");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2017Кв1, "0.92");
	
	ФормаОтчета2017Кв3 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2017-06-07', "275", "ФормаОтчета2017Кв3");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2017Кв3, "0.93");
	
	ФормаОтчета2022Кв2 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159999", '2022-03-14', "80", "ФормаОтчета2022Кв2");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2022Кв2, "0.94");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "",
			ИмяОбъекта = "", ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли