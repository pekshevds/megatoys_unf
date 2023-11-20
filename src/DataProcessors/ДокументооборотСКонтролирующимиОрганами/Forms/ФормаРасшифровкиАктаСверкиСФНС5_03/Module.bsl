
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазобратьПараметры(Параметры);
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	XDTO = КонтекстЭДОСервер.XDTOАктаСверки(Параметры.АдресФайла);
	
	Результат = ТекущиеДанныеАкта(XDTO);
	
	ТекущийАкт = Результат.ТекущийАкт;
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Данные для расшифровки отсутствуют'");
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	МакетАкта = КонтекстЭДОСервер.ПолучитьМакет("РасшифровкаАктаСверкиСФНС_5_03_" + ВидПлатежа);

	ОбластьШапка = МакетАкта.ПолучитьОбласть("Шапка");
	КонтекстЭДОСервер.ЗаполнитьОрганизацииВШапкеАктаСверки(ОбластьШапка, XDTO, Результат.АктСвер);
	
	ОбластьШапка.Параметры.КБК   = КБК;
	ОбластьШапка.Параметры.ОКТМО = ОКТМО;
	
	НалогиПоКБК = Обработки.ДокументооборотСКонтролирующимиОрганами.ПолучитьМакет("КБК");
	КолонкаКБК = НалогиПоКБК.Область("КБК"); // область таблицы с КБК
	
	НаименованиеКраткое = "";
	НаименованиеПолное  = "";
	КонтекстЭДОСервер.ПолучитьНаименованиеНалога(КБК, НалогиПоКБК, КолонкаКБК, НаименованиеКраткое, НаименованиеПолное);
	
	ОбластьШапка.Параметры.НаименованиеНалога = НаименованиеКраткое;
	ОбластьШапка.Параметры.НаименованиеПолное = НаименованиеПолное;
	
	ТабДок.Вывести(ОбластьШапка);
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	Для НомерСтроки = 11 По МакетАкта.ВысотаТаблицы Цикл
		
		УровеньГруппировки = Число(МакетАкта.Область(НомерСтроки, 5).Текст);
		Узел = МакетАкта.Область(НомерСтроки, 6).Текст;
		Поле = МакетАкта.Область(НомерСтроки, 7).Текст;
		
		ТекущаяСтрокаНаПечать = МакетАкта.ПолучитьОбласть(НомерСтроки, 1, НомерСтроки, 4);
		
		Платеж = ДанНО(ТекущийАкт[Узел], Поле);
		
		Если Платеж <> 0 Тогда
			ТекущаяСтрокаНаПечать.Параметры.Платеж = ДанНО(ТекущийАкт[Узел], Поле);
			ТабДок.Вывести(ТекущаяСтрокаНаПечать, УровеньГруппировки,, Истина);
		КонецЕсли;
			
	КонецЦикла;
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

&НаСервере
Функция ДанНО(Узел, Поле)
	
	Если ЗначениеЗаполнено(Поле) Тогда
	
		Если ЕстьСвойствоXDTO(Узел, Поле) Тогда
			Возврат ЧислоФНС(Узел[Поле].ДанНО);
		Иначе
			Возврат 0;
		КонецЕсли;
		
	Иначе
		
		Возврат ЧислоФНС(Узел.ДанНО);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ТекущиеДанныеАкта(XDTO)
	
	АктыСверки = СписокИзXDTO(XDTO.Документ, "АктСвер");
	Для Каждого АктСвер Из АктыСверки Цикл
		
		Если АктСвер.НомерАкт <> НомерАкт Тогда
			Продолжить;
		КонецЕсли;
		
		СодАкт = СписокИзXDTO(АктСвер, "СодАкт");
		Для Каждого ТекущийСодАкт Из СодАкт Цикл
			
			ТекущийАкт = ТекущийСодАкт[ВидПлатежа];
			
			Если ТекущийАкт.КБК = КБК И ТекущийАкт.ОКТМО = ОКТМО Тогда
				
				Результат = Новый Структура();
				Результат.Вставить("АктСвер", АктСвер);
				Результат.Вставить("ТекущийАкт", ТекущийАкт);
				
				Возврат Результат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура РазобратьПараметры(Параметры)
	
	Подстроки = СтрРазделить(Параметры.Расшифровка, "_");
	
	НомерАкт = Подстроки[0];
	ВидПлатежа = Подстроки[1];
	КБК = Подстроки[2];
	ОКТМО = Подстроки[3];
	
КонецПроцедуры

&НаСервере
Функция ЧислоФНС(Строка)
	
	Результат = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка);
	
	Если Результат = Неопределено Тогда
		Ошибка = НСтр("ru = 'Произошла ошибка при преобразовании строки суммы (%1) в число.'");
		Ошибка = СтрШаблон(Ошибка, Строка);
		Сообщить(Ошибка);
		Возврат 0;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокИзXDTO(Узел, Поле) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.СписокИзXDTO(Узел, Поле); 
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьСвойствоXDTO(Узел, Поле) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.ЕстьСвойствоXDTO(Узел, Поле); 
	
КонецФункции

&НаСервереБезКонтекста
Функция СвойствоXDTO(Узел, Поле) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.СвойствоXDTO(Узел, Поле);
	
КонецФункции

