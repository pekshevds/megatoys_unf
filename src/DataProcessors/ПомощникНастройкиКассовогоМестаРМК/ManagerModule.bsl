#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует печатные формы объекта.
//
// Параметры:
//  МассивОбъектов - Массив из СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами - ссылки
//                   на объекты которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные параметры печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами печатных областей, куда распечатан объект;
//  ПараметрыВывода - Структура - параметры сформированных табличных документов.
//
Процедура Печать(
		МассивОбъектов,
		ПараметрыПечати,
		КоллекцияПечатныхФорм,
		ОбъектыПечати,
		ПараметрыВывода) Экспорт
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяСсылкаА5Широкий") Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ТипПечати", 1);
		СинонимМакета = НСтр("ru = 'Кассовая ссылка (А5 широкий)'");
		ИдентификаторМакета = "КассоваяСсылкаА5Широкий";
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяСсылкаА5ТолькоЛого") Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ТипПечати", 2);
		СинонимМакета = НСтр("ru = 'Кассовая ссылка (А5 только логотипы)'");
		ИдентификаторМакета = "КассоваяСсылкаА5ТолькоЛого";
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяСсылкаА5Узкий") Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ТипПечати", 3);
		СинонимМакета = НСтр("ru = 'Кассовая ссылка (А5 узкий)'");
		ИдентификаторМакета = "КассоваяСсылкаА5Узкий";
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяСсылкаА5УзкийГоризонтальный") Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ТипПечати", 4);
		СинонимМакета = НСтр("ru = 'Кассовая ссылка (А5 узкий горизонтальный)'");
		ИдентификаторМакета = "КассоваяСсылкаА5УзкийГоризонтальный";
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяСсылкаА6Квадратный") Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ТипПечати", 5);
		СинонимМакета = НСтр("ru = 'Кассовая ссылка (А6 квадратный)'");
		ИдентификаторМакета = "КассоваяСсылкаА6Квадратный";
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяСсылкаА6Круглый") Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ТипПечати", 6);
		СинонимМакета = НСтр("ru = 'Кассовая ссылка (А6 круглый)'");
		ИдентификаторМакета = "КассоваяСсылкаА6Круглый";
		
	КонецЕсли;
	
	Для Каждого КассаСсылка Из МассивОбъектов Цикл

		НастройкаКассыККМ = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ПолучитьНастройкиКассовойСсылкиСБП(КассаСсылка);
		ДанныеКассы		  = НастройкаКассыККМ.СпособыОплаты.Получить(НастройкаКассыККМ.СпособОплатыДляПечати);

		Если ДанныеКассы = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка сохранения настроек печати кассового QR-кода'");
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИдентификаторМакета,
			СинонимМакета,
			ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.СформироватьКарточкуКассовойСсылки(
				ДанныеКассы,
				ПараметрыПечати));
				
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли