&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем ДанныеЗаполнения;

&НаКлиенте
Перем ДанныеОрганизации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидКонтролирующегоОргана 	= Параметры.ТипПолучателя;
	Организация 				= Параметры.Организация;
	
	СертификатНедоступенИлиИстек 	= Параметры.СертификатНедоступенИлиИстек;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	УчетнаяЗапись  = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация); 
	ЭтоМультиРежим = Мультирежим.ЭтоМультиРежим(УчетнаяЗапись);
	
	ИндексКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.Индекс(ВидКонтролирующегоОргана);
	ИмяКонтролирующегоОргана = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
		Метаданные.Перечисления.ТипыКонтролирующихОрганов.ЗначенияПеречисления[ИндексКонтролирующегоОргана].Синоним, Истина);
	
	Заголовок = ИмяКонтролирующегоОргана;
	
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПФР Тогда
		КодПолучателя = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			Организация,,
			"КодОрганаПФР").КодОрганаПФР;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС Тогда
		КодПолучателя = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			Организация,,
			"КодПодчиненностиФСС").КодПодчиненностиФСС;
		
	Иначе
		КодПолучателя = "";
	КонецЕсли;
	КодПолучателя = СокрЛП(КодПолучателя);
	
	Элементы.ПодключенноеНаправление.Заголовок = СтрШаблон(
		НСтр("ru = 'Направление %1 уже подключено.'"),
		ИмяКонтролирующегоОргана + ?(КодПолучателя <> "", " " + КодПолучателя, ""));
	
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ЦБ
		И ДокументооборотСКОКлиентСервер.ПодсистемаЦБСуществует() Тогда
		
		ИмяСправочникаМашиночитаемыеДоверенностиЦБ = "МашиночитаемыеДоверенностиЦБ";
		Элементы.ДоверенностьЦБ.ОграничениеТипа =
			Новый ОписаниеТипов("СправочникСсылка." + ИмяСправочникаМашиночитаемыеДоверенностиЦБ);
		Элементы.ДекорацияОтступДоверенностиВерхний.Видимость = Истина;
		Элементы.ДекорацияОтступДоверенностиЧерта.Видимость = Истина;
		Элементы.ДекорацияОтступДоверенностиНижний.Видимость = Истина;
		Элементы.ДоверенностьЦБ.Видимость = Истина;
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	УчетныеЗаписиДокументооборота.ДоверенностьЦБ КАК ДоверенностьЦБ
			|ИЗ
			|	Справочник.УчетныеЗаписиДокументооборота КАК УчетныеЗаписиДокументооборота
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
			|		ПО Организации.УчетнаяЗаписьОбмена = УчетныеЗаписиДокументооборота.Ссылка
			|ГДЕ
			|	Организации.Ссылка = &Организация");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДоверенностьЦБ = Выборка.ДоверенностьЦБ;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.НастроитьНаправление.Видимость = (ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСРАР
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.РПН
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС);
	
	ЗаявлениеНаИзменениеДоступно = НЕ СертификатНедоступенИлиИстек;
	
	Если НЕ ЗаявлениеНаИзменениеДоступно Тогда
		// Направляем в мастер
		Элементы.ОтключитьНаправление.Заголовок = НСтр("ru = 'Подготовить заявление'");
	КонецЕсли;
	
	КонтролирующийОрган = Метаданные.Перечисления.ТипыКонтролирующихОрганов.ЗначенияПеречисления[ИндексКонтролирующегоОргана].Имя;
	КлючСохраненияПоложенияОкна = "Отключить" + КонтролирующийОрган
		+ ?(НЕ ЗаявлениеНаИзменениеДоступно, "Подготовить", "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Успешная отправка заявления. Закрыть форму владельца"
		И Источник = ЗаявлениеАбонента.Ссылка Тогда
		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоверенностьЦБНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Организация", Организация));
	
	ИмяСправочникаМашиночитаемыеДоверенностиЦБ = "МашиночитаемыеДоверенностиЦБ";
	ВходящийКонтекст = Новый Структура("ДоверенностьУжеЗадана", Ложь);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверенностьЦБПослеВыбора", ЭтотОбъект, ВходящийКонтекст);
	ОткрытьФорму(
		"Справочник." + ИмяСправочникаМашиночитаемыеДоверенностиЦБ + ".ФормаВыбора",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьЦБПриИзменении(Элемент)
	
	ВходящийКонтекст = Новый Структура("ДоверенностьУжеЗадана", Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверенностьЦБПослеВыбора", ЭтотОбъект, ВходящийКонтекст);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДоверенностьЦБ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтключитьНаправление(Команда)
	
	Если ЭтоЗаписатьИЗакрыть Тогда
		ЗаписатьМЧД(Организация, ДоверенностьЦБ);
		Закрыть();
		
	ИначеЕсли НЕ СертификатНедоступенИлиИстек И НЕ ЭтоМультиРежим Тогда
		ОтправитьЗаявлениеНаИзменениеВСкрытомРежиме();
		
	Иначе
		Закрыть(ВидКонтролирующегоОргана);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьНаправление(Команда)
	
	Закрыть();
	
	Если ВидКонтролирующегоОргана = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС") Тогда
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСС(Организация);
		
	ИначеЕсли ВидКонтролирующегоОргана = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР") Тогда
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСРАР(Организация);
		
	ИначеЕсли ВидКонтролирующегоОргана = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН") Тогда
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсРПН(Организация);
		
	ИначеЕсли ВидКонтролирующегоОргана = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС") Тогда
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФТС(Организация);
	
	ИначеЕсли ВидКонтролирующегоОргана = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ЦБ") Тогда
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФНСиПФРиРосстатомиЦБ(Организация, ЭтаФорма,, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
	// Заполняем текущие реквизиты организации
	СтруктураРеквизитов = Новый Структура("Организация, ПриОткрытии", Организация, Ложь);
	КонтекстЭДОКлиент.ЗаполнитьДанныеОрганизации(СтруктураРеквизитов);
	ДанныеЗаполнения = КонтекстЭДОКлиент.ДополнитьДанныеОрганизацииДаннымиПоОтветственнымЛицам(СтруктураРеквизитов);
	ДанныеОрганизации = ДанныеЗаполнения.СтруктураДанныхОрганизации;
	
КонецПроцедуры

#Область ОтправкаЗаявления

&НаКлиенте
Процедура ОтправитьЗаявлениеНаИзменениеВСкрытомРежиме()
	
	ДополнительныеПараметры = ДлительнаяОтправкаКлиент.ПараметрыДлительнойОтправкиЗаявления();
	ДополнительныеПараметры.Вставить("Организация", Организация);
	
	Если НЕ ДлительнаяОтправкаКлиент.ПоказатьФормуДлительнойОтправкиЗаявления(ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтправитьЗаявлениеНаИзменение", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтправитьЗаявлениеНаИзменение() Экспорт
	
	УдалосьСоздать = СоздатьНовоеЗаявлениеСНовымНаправлением();
	
	Если НЕ УдалосьСоздать Тогда
		ДлительнаяОтправкаКлиент.ОповеститьОНеудачнойОтправкеЗаявления();
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СообщитьРезультатОтправки",
		ЭтотОбъект);
	
	ИдентификаторАбонента = КонтекстЭДОКлиент.ИдентификаторАбонентаПоОрганизации(Организация);
	
	Контекст = КонтекстЭДОКлиент.ПараметрыПроцедурыСформироватьИОтправитьЗаявление();
	Контекст.ДокументЗаявление 							= ЗаявлениеАбонента;
	Контекст.ИдентификаторАбонента 						= ИдентификаторАбонента;
	Контекст.ВызовИзМастераПодключенияК1СОтчетности 	= Истина;
	Контекст.ВыполняемоеОповещение 						= ОписаниеОповещения;
	Контекст.ФормироватьЗакрытыйКлючИЗапросНаСертификат = Ложь;
	КонтекстЭДОКлиент.СформироватьИОтправитьЗаявление(Контекст);
	
КонецПроцедуры

&НаСервере
Функция СоздатьНовоеЗаявлениеСНовымНаправлением()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	НовыйДокументЗаявление = ОбработкаЗаявленийАбонента.СоздатьЗаявлениеНаИзменениеВСкрытомРежиме(Организация);
	Если НовыйДокументЗаявление = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ УдалосьОтключитьНаправление(НовыйДокументЗаявление) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		НовыйДокументЗаявление.Записать();
	Исключение
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ИнформацияОбОшибке().Описание);
		Возврат Ложь;
	КонецПопытки;
	
	ЗначениеВРеквизитФормы(НовыйДокументЗаявление, "ЗаявлениеАбонента");
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция УдалосьОтключитьНаправление(НовыйДокументЗаявление)
	
	// см.СоздатьЗаявлениеНаИзменениеВСкрытомРежиме_ОпределитьНаправленияСдачиОтчетности
	НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Очистить();
	
	ОбработкаЗаявленийАбонента.СкорректироватьНаправленияСдачиОтчетностиСУчетомПредыдущихЗаявлений(НовыйДокументЗаявление, ВидКонтролирующегоОргана);
	
	ДанныеЗаполнения 	= ОбработкаЗаявленийАбонента.СоздатьЗаявлениеНаИзменениеВСкрытомРежиме_ДанныеЗаполнения(Организация);
	ДанныеОрганизации 	= ДанныеЗаполнения.СтруктураДанныхОрганизации;
	
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПФР
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС Тогда
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВПФР;
		
		ОбработкаЗаявленийАбонента.УдалитьПолучателейКонтролирующегоОргана(НовыйДокументЗаявление, Перечисления.ТипыКонтролирующихОрганов.ПФР);
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВФСС;
		
		ОбработкаЗаявленийАбонента.УдалитьПолучателейКонтролирующегоОргана(НовыйДокументЗаявление, Перечисления.ТипыКонтролирующихОрганов.ФСС);
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСРАР Тогда
		
		НовыйДокументЗаявление.ПодатьЗаявкуНаСертификатДляФСРАР = Ложь;
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВФСРАР;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.РПН Тогда
		
		НовыйДокументЗаявление.ПодатьЗаявкуНаПодключениеРПН = Ложь;
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВРПН;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС Тогда
		
		НовыйДокументЗаявление.ПодатьЗаявкуНаПодключениеФТС = Ложь;
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВФТС;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ЦБ Тогда
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВЦБ;
		
		ОбработкаЗаявленийАбонента.УдалитьПолучателейКонтролирующегоОргана(НовыйДокументЗаявление,
			Перечисления.ТипыКонтролирующихОрганов.ЦБ);
		
	КонецЕсли;
	
	Если НЕ ОбработкаЗаявленийАбонента.ЗаявлениеСодержитМинимальноНеобходимыхПолучателей(НовыйДокументЗаявление) Тогда
		ТекстОшибки = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
			НСтр("ru = 'Среди контролирующих органов, в которые будет сдаваться отчетность, должены быть ФНС или ПФР.'"),
			Истина);
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ТекстОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СообщитьРезультатОтправки(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ТекстОшибки")
		И ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(Результат.ТекстОшибки);
		ДлительнаяОтправкаКлиент.ОповеститьОНеудачнойОтправкеЗаявления();
		
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ОписаниеОшибки")
		И ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(Результат.ОписаниеОшибки);
		ДлительнаяОтправкаКлиент.ОповеститьОНеудачнойОтправкеЗаявления();
		
	Иначе
		
		ТекстПояснения = НСтр("ru = 'Мы уведомим вас о результате обработки заявления.
									|Обычно это занимает 20-30 минут.'");
		ДлительнаяОтправкаКлиент.ОповеститьОбУдачнойОтправкеЗаявления(
			Организация,
			ЗаявлениеАбонента.Ссылка,
			ТекстПояснения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ДоверенностьЦБПослеВыбора(Результат, ВходящийКонтекст) Экспорт
	
	Если ЗначениеЗаполнено(Результат) И НЕ МЧДЦБПодписана(Результат) Тогда
		РезультатыПроверки = ДокументооборотСКОВызовСервера.ПроверитьМЧДЦБ(Результат);
		
		Если РезультатыПроверки.Количество() <> 0 Тогда
			Для каждого РезультатПроверки Из РезультатыПроверки Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатПроверки.ТекстОшибки);
			КонецЦикла;
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Машиночитаемая доверенность должна быть подписана доверителем, исправьте ошибки и подпишите доверенность'"));
			Если ВходящийКонтекст.ДоверенностьУжеЗадана Тогда
				ДоверенностьЦБ = Неопределено;
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ВходящийКонтекст.Вставить("ДоверенностьЦБ", Результат);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДоверенностьЦБПослеВопроса", ЭтотОбъект, ВходящийКонтекст);
		ПоказатьВопрос(
			ОписаниеОповещения,
			НСтр("ru = 'Машиночитаемая доверенность должна быть подписана доверителем. Подписать сейчас?'"),
			РежимДиалогаВопрос.ДаНет,,
			КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
	Если НЕ ВходящийКонтекст.ДоверенностьУжеЗадана Тогда
		ДоверенностьЦБ = Результат;
	КонецЕсли;
	ВключитьРежимЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьЦБПослеВопроса(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Если ВходящийКонтекст.ДоверенностьУжеЗадана Тогда
			ДоверенностьЦБ = Неопределено;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверенностьЦБПослеПодписи", ЭтотОбъект, ВходящийКонтекст);
	ДокументооборотСКОКлиент.ПодписатьМЧДЦБ(ОписаниеОповещения, ВходящийКонтекст.ДоверенностьЦБ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьЦБПослеПодписи(Результат, ВходящийКонтекст) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		Если ВходящийКонтекст.ДоверенностьУжеЗадана Тогда
			ДоверенностьЦБ = Неопределено;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если НЕ ВходящийКонтекст.ДоверенностьУжеЗадана Тогда
		ДоверенностьЦБ = ВходящийКонтекст.ДоверенностьЦБ;
	КонецЕсли;
	ВключитьРежимЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРежимЗаписатьИЗакрыть()
	
	ЭтоЗаписатьИЗакрыть = Истина;
	Элементы.ОтключитьНаправление.Заголовок = НСтр("ru = 'Сохранить'");
	Элементы.ОтключитьНаправление.КнопкаПоУмолчанию = Истина;
	Элементы.ФормаЗакрыть.Заголовок = НСтр("ru = 'Отмена'");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МЧДЦБПодписана(ДоверенностьСсылка)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоверенностьСсылка,
		"ЭлектроннаяПодпись").Получить() <> Неопределено;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьМЧД(Организация, ДоверенностьЦБ)
	
	УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "УчетнаяЗаписьОбмена");
	ОбъектУчетнаяЗапись = УчетнаяЗапись.ПолучитьОбъект();
	ОбъектУчетнаяЗапись.ДоверенностьЦБ = ДоверенностьЦБ;
	ОбъектУчетнаяЗапись.Записать();
	
КонецПроцедуры

#КонецОбласти
