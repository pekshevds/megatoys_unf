
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект, 
		Параметры, 
		"ЛицензияДатаБлокировки, 
		|ЛицензияПросрочена,
		|ЛицензияИстекает,
		|ЛицензияДатаНачала,
		|СертификатДатаОкончания, 
		|СертификатПросрочен, 
		|СсылкаНаОбъект, 
		|СрокДействияКлюча, 
		|СрокДействияКлючаПросрочен,
		|ОрганСтрокой,
		|Организация,
		|ТарифОператораЭДО,
		|ЛицензияДатаОкончания");
		
	ДоопределитьДанные = 
		ЗначениеЗаполнено(СсылкаНаОбъект) 
		И (НЕ ЗначениеЗаполнено(Организация) ИЛИ НЕ ЗначениеЗаполнено(ОрганСтрокой));
	
	Если ДоопределитьДанные Тогда
		КонтекстЭДОСервер        = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		СведенияПоОбъекту        = КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(СсылкаНаОбъект);
		Организация 			 = СведенияПоОбъекту.Организация;
		ВидКонтролирующегоОргана = СведенияПоОбъекту.ВидКонтролирующегоОргана;
		ОрганСтрокой 			 = ВидКонтролирующегоОргана;
	КонецЕсли;
	
	УправлениеФормой();
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПоддерживаетсяВторичноеЗаявление Тогда
		
		ТекущийЭлемент = Элементы.ФормаОтправитьЗаявление;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявление(Команда)
	Закрыть(КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОтправку(Команда)
	Закрыть(КодВозвратаДиалога.Повторить);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	ЭтоМягкоеПредупреждение = 
		ЗначениеЗаполнено(ТарифОператораЭДО)
		И ЛицензияИстекает
		И НЕ ЛицензияПросрочена
		И НЕ СрокДействияКлючаПросрочен
		И НЕ СертификатПросрочен;
		
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
	Если ЭтоМягкоеПредупреждение Тогда
		Заголовок = НСтр("ru = 'Ваша лицензия на тариф ""%1"" истекла'");
		Заголовок = СтрШаблон(Заголовок, Строка(ТарифОператораЭДО));
	Иначе
		Заголовок = КонтекстЭДОСервер.СообщениеОНеподключенномНаправлении_ЗаголовокФормы(
			СсылкаНаОбъект, 
			ОрганСтрокой);
	КонецЕсли;
	
	ПоддерживаетсяВторичноеЗаявление = КонтекстЭДОСервер.ПоддерживаетсяВторичноеЗаявление(Организация);
	
	Элементы.ЧтоДелать.Заголовок = ЧтоДелать();
	
	Элементы.ЛицензияДатаНачала.Видимость = ЭтоМягкоеПредупреждение;
	Элементы.ЛицензияДатаОкончания.Видимость = ЭтоМягкоеПредупреждение ИЛИ ЛицензияПросрочена;
	Элементы.СертификатДатаОкончания.Видимость = СертификатПросрочен;
	Элементы.СрокДействияКлюча.Видимость = СрокДействияКлючаПросрочен;
	
	Если НЕ ПоддерживаетсяВторичноеЗаявление Тогда
		Элементы.ФормаОтправитьЗаявление.Видимость = Ложь;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Элементы.ФормаПродолжитьОтправку.Видимость = ЭтоМягкоеПредупреждение;
	Элементы.ФормаЗакрыть.Видимость = НЕ ЭтоМягкоеПредупреждение;
	
	Если ЭтоМягкоеПредупреждение Тогда
		Элементы.Картинка.Картинка = БиблиотекаКартинок.ВниманиеЖелтоБелое;
	Иначе
		Элементы.Картинка.Картинка = БиблиотекаКартинок.ОшибкаОтправки;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ЧтоДелать()
	
	Возврат Новый ФорматированнаяСтрока(
		Предложение1(), 
		Предложение2(),
		ТекстПроТариф())
		
КонецФункции

&НаСервере
Функция Предложение1()
	
	Если ЭтоМягкоеПредупреждение Тогда
		
		Если ТарифОператораЭДО = Перечисления.ТарифыОператораЭДО.КадровыеРешения Тогда
			Предложение1 = НСтр("ru = 'Чтобы продолжить использование обмена с ФСС и ПФР, необходимо продлить лицензию.'") + Символы.ПС;
		Иначе
			Предложение1 = НСтр("ru = 'Чтобы продолжить использование обмена с ФНС, необходимо продлить лицензию.'") + Символы.ПС;
		КонецЕсли;
		
	Иначе
	
		Параметр1 = ДлительнаяОтправкаКлиентСервер.НазваниеОбъектаВРодительномПадеже(СсылкаНаОбъект);
		
		МассивКонтроля = Новый Массив;
		Если ЛицензияПросрочена Тогда
			Если ЗначениеЗаполнено(ТарифОператораЭДО) Тогда
				
				Представление = НСтр("ru = '""%1""'");
				Представление = СтрШаблон(Представление, Строка(ТарифОператораЭДО));
				
				Если ТарифОператораЭДО = Перечисления.ТарифыОператораЭДО.КадровыеРешения Тогда
					СсылкаНаТариф = Новый ФорматированнаяСтрока(Представление,,,,"https://astral.ru/lp/1%D1%81-kadrovye-resheniya/");
				ИначеЕсли ТарифОператораЭДО = Перечисления.ТарифыОператораЭДО.ПромоЕНС Тогда
					СсылкаНаТариф = Новый ФорматированнаяСтрока(Представление,,,,"https://astral.ru/lp/1c-promo-ens/");
				КонецЕсли;
				
				Строка = Новый ФорматированнаяСтрока(НСтр("ru = 'лицензию на тариф '"), СсылкаНаТариф);
				МассивКонтроля.Добавить(Строка);
			Иначе
				МассивКонтроля.Добавить(НСтр("ru = 'лицензию'"));
			КонецЕсли;
		КонецЕсли;
		
		Если СертификатПросрочен Тогда
			МассивКонтроля.Добавить(НСтр("ru = 'сертификат'"));
		КонецЕсли;
		
		Если СрокДействияКлючаПросрочен Тогда
			Строка = Новый ФорматированнаяСтрока(НСтр("ru = 'ключ myDSS'"),,,,"https://help.astral.ru/v/147062851");
			МассивКонтроля.Добавить(Строка);
		КонецЕсли;
		
		Параметр2 = "";
		Всего = МассивКонтроля.Количество() - 1;
		Для Счетчик = 0 По Всего Цикл
			Если Счетчик <> 0 И Счетчик = Всего Тогда
				Параметр2 = Новый ФорматированнаяСтрока(Параметр2, НСтр("ru = ' и '"));
			ИначеЕсли Счетчик > 0 Тогда
				Параметр2 = Новый ФорматированнаяСтрока(Параметр2, ", ");
			КонецЕсли;	
			Параметр2 = Новый ФорматированнаяСтрока(Параметр2, МассивКонтроля[Счетчик]);
		КонецЦикла;
		
		Предложение1 = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Для отправки '"), 
			Параметр1, 
			НСтр("ru = ' необходимо продлить '"), 
			Параметр2,
			".",
			Символы.ПС);
			
	КонецЕсли;
	
	Возврат Предложение1;
	
КонецФункции

&НаСервере
Функция Предложение2()
	
	Если ПоддерживаетсяВторичноеЗаявление Тогда
		Строка = НСтр("ru = 'Для этого отправьте заявление на продление.'");
	Иначе
		Строка = НСтр("ru = 'Для этого обратитесь к вашему оператору связи.'");
	КонецЕсли;
	
	Возврат Строка + Символы.ПС + Символы.ПС;
	
КонецФункции

&НаСервере
Функция ТекстПроТариф()
	
	Если ЭтоМягкоеПредупреждение Тогда
		
		Строка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подробнее о тарифе читайте '"),
			Новый ФорматированнаяСтрока(НСтр("ru = 'здесь'"),,,,"https://astral.ru/lp/1%D1%81-kadrovye-resheniya/"),
			".",
			Символы.ПС,
			Символы.ПС);

	Иначе
		Строка = "";
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

#КонецОбласти

