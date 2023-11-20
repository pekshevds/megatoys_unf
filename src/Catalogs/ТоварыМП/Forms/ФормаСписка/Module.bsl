
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилсяЗаказ"
		ИЛИ ИмяСобытия = "ИзменилосьКоличествоТовара"
		ИЛИ ИмяСобытия = "ПрошелОбмен" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = "Список";
	КонецЕсли;
	
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		КоманднаяПанель.Видимость = Истина;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ДекорацияСинхронизация.Видимость = Ложь;
	Элементы.ДекорацияНетСоединения.Видимость = Ложь;
	
	#Если МобильноеПриложениеКлиент Тогда
		
		Если НЕ ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СоединениеСЦБУстановленоМП") Тогда
			Оповестить("ПрошелОбмен");
			Возврат;
		КонецЕсли;
		
		ОжиданиеВыполненияОбмена();
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	#Если МобильноеПриложениеКлиент Тогда
		ОтключитьОбработчикОжидания("ОжиданиеВыполненияОбмена");
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПоШтрихкоду(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		ОбщегоНазначенияМПКлиент.ОтсканироватьШтрихкод(Новый ОписаниеОповещения("ОбработатьШтрихкод", ЭтаФорма), ЭтаФорма);
	#Иначе
		ПоискПоШтрихкоду();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьФильтр(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	УстановитьОтборПоШтрихкоду("");
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке("https://sbm.1c.ru/about/razdel-tovary/spisok-tovarov/");
	// АПК:534-вкл
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоискПоШтрихкоду()
	
	ТекШтрихкод = "";
	
	ОбработкаЗавершения = Новый ОписаниеОповещения(
		"ПоискПоШтрихкодуЗавершение",
		ЭтотОбъект,
		Новый Структура("ТекШтрихкод", ТекШтрихкод));
	
	ПоказатьВводЗначения(ОбработкаЗавершения, ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ТекШтрихкод = ?(Результат = Неопределено, ДополнительныеПараметры.ТекШтрихкод, Результат);
	
	Если НЕ ПустаяСтрока(ТекШтрихкод) Тогда
		УстановитьОтборПоШтрихкоду(ТекШтрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкод(Штрихкод, Результат, Сообщение = "", ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат Тогда
		#Если МобильноеПриложениеКлиент Тогда
			СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
		#КонецЕсли
		УстановитьОтборПоШтрихкоду(Штрихкод)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученШтрихкод(Штрихкод) Экспорт
	
	ОбработатьШтрихкод(Штрихкод, Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоШтрихкоду(Штрихкод)
	
	Если ПустаяСтрока(СокрЛП(Штрихкод)) Тогда
		ОбщегоНазначенияМПСервер.ДобавитьОтбор(
		Список.Отбор,
		"Штрихкод",
		Штрихкод,
		ВидСравненияКомпоновкиДанных.Равно,
		Ложь);
	Иначе
		ОбщегоНазначенияМПСервер.ДобавитьОтбор(
		Список.Отбор,
		"Штрихкод",
		Штрихкод,
		ВидСравненияКомпоновкиДанных.Равно,
		Истина);
		
	КонецЕсли;
	
	Элементы.ФормаОтменитьФильтр.Доступность = ЗначениеЗаполнено(Штрихкод);
	
КонецПроцедуры

#КонецОбласти

#Область Синхронизация

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления()
	
	Оповестить("ПрошелОбмен");
	
	#Если МобильноеПриложениеКлиент Тогда
		Если Элементы.ДекорацияСинхронизация.Видимость Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СоединениеСЦБУстановленоМП") Тогда
			Возврат;
		КонецЕсли;
		
		Если ИнформацияОбИнтернетСоединении.ПолучитьТипСоединения() = ТипИнтернетСоединения.НетСоединения Тогда
			Элементы.ДекорацияНетСоединения.Видимость = Истина;
			ПодключитьОбработчикОжидания("ОтключитьОповещениеОбОтсутствииИнтернета", 3, Истина);
			Возврат;
		КонецЕсли;
		
		Элементы.ДекорацияСинхронизация.Видимость = Истина;
		
		ОбщегоНазначенияМПВызовСервера.УстановитьЗначениеКонстанты("СинхронизацияВыполняется", Истина);
		ОбщегоНазначенияМПВызовСервера.УстановитьЗначениеКонстанты("НачатьСинхронизацию", Истина);
		
		ПодключитьОбработчикОжидания("ОжиданиеВыполненияОбмена", 0.1, Истина);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОжиданиеВыполненияОбмена()
	
	#Если МобильноеПриложениеКлиент Тогда
		
		ОбменВыполняется = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СинхронизацияВыполняется");
		Если ОбменВыполняется Тогда
			Элементы.ДекорацияСинхронизация.Видимость = Истина;
			ПодключитьОбработчикОжидания("ОжиданиеВыполненияОбмена", 3, Истина);
		ИначеЕсли Элементы.ДекорацияСинхронизация.Видимость Тогда
			Элементы.ДекорацияСинхронизация.Видимость = Ложь;
			
			Если ИнформацияОбИнтернетСоединении.ПолучитьТипСоединения() = ТипИнтернетСоединения.НетСоединения Тогда
				Элементы.ДекорацияНетСоединения.Видимость = Истина;
				ПодключитьОбработчикОжидания("ОтключитьОповещениеОбОтсутствииИнтернета", 3, Истина);
				Возврат;
			КонецЕсли;
			Оповестить("ПрошелОбмен");
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОповещениеОбОтсутствииИнтернета()
	
	#Если МобильноеПриложениеКлиент Тогда
		Элементы.ДекорацияНетСоединения.Видимость = Ложь;
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

