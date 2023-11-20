&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидНастроек = Параметры.ВидНастроек;
	
	ТекстЗапроса = "";
	
	Если НЕ ЗначениеЗаполнено(ВидНастроек) Тогда
		
		Если ДокументооборотСКОКлиентСервер.ПодсистемаЦБСуществует() Тогда
			ЗаголовокФормы = НСтр("ru = 'Настройки обмена с ФНС, Росстатом, ПФР и Банком России'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Настройки обмена с ФНС, Росстатом и ПФР'");
		КонецЕсли;
		ЭтаФорма.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(ЗаголовокФормы, Истина);
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления ИЛИ Организации.УчетнаяЗаписьОбмена.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА Организации.ВидОбменаСКонтролирующимиОрганами = ЗНАЧЕНИЕ(Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате)

		               |			ТОГДА &ВУниверсальномФормате
		               |		ИНАЧЕ ВЫБОР
		               |				КОГДА Организации.ВидОбменаСКонтролирующимиОрганами = ЗНАЧЕНИЕ(Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменЧерезСпринтер)

		               |					ТОГДА &Спринтер
		               |				ИНАЧЕ &НеИспользуется
		               |			КОНЕЦ
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации";
		
		СписокНастроек.ТекстЗапроса = ТекстЗапроса;
		
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("ВУниверсальномФормате", 	НСтр("ru = 'Обмен в универсальном формате'"));
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("Спринтер", 				НСтр("ru = 'Обмен посредством ПК ""Спринтер""'"));    
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("НеИспользуется", 			НСтр("ru = 'Не используется'"));
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС") Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Настройки обмена с ФСС'");
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаФСС.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА &Используется
		               |		ИНАЧЕ &НеИспользуется
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФСС КАК НастройкиОбменаФСС
		               |		ПО (НастройкиОбменаФСС.Организация = Организации.Ссылка
		               |			И (НастройкиОбменаФСС.Пользователь ЕСТЬ NULL
		               |			ИЛИ НастройкиОбменаФСС.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)))";
		
		СписокНастроек.ТекстЗапроса = ТекстЗапроса;
		
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("НеИспользуется", 			НСтр("ru = 'Не используется'"));
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("Используется",			НСтр("ru = 'Используется'"));
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР") Тогда
					   
		ЭтаФорма.Заголовок = НСтр("ru = 'Настройки обмена с ФСРАР'");
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаФСРАР.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА &Используется
		               |		ИНАЧЕ &НеИспользуется
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФСРАР КАК НастройкиОбменаФСРАР
		               |		ПО (НастройкиОбменаФСРАР.Организация = Организации.Ссылка
		               |			И (НастройкиОбменаФСРАР.Пользователь ЕСТЬ NULL
		               |			ИЛИ НастройкиОбменаФСРАР.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)))";
		
		СписокНастроек.ТекстЗапроса = ТекстЗапроса;
		
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("НеИспользуется", 			НСтр("ru = 'Не используется'"));
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("Используется",			НСтр("ru = 'Используется'"));
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН") Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Настройки обмена с РПН'");
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаРПН.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА &Используется
		               |		ИНАЧЕ &НеИспользуется
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаРПН КАК НастройкиОбменаРПН
		               |		ПО (НастройкиОбменаРПН.Организация = Организации.Ссылка
		               |			И (НастройкиОбменаРПН.Пользователь ЕСТЬ NULL
		               |			ИЛИ НастройкиОбменаРПН.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)))";
		
		СписокНастроек.ТекстЗапроса = ТекстЗапроса;
		
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("НеИспользуется", 			НСтр("ru = 'Не используется'"));
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("Используется",			НСтр("ru = 'Используется'"));
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС") Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Настройки обмена с ФТС'");
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВЫБОР
		               |		КОГДА Организации.ПометкаУдаления
		               |			ТОГДА 4
		               |		ИНАЧЕ 3
		               |	КОНЕЦ КАК ПометкаУдаления,
		               |	Организации.Ссылка КАК Организация,
		               |	ВЫБОР
		               |		КОГДА ЕСТЬNULL(НастройкиОбменаФТС.ИспользоватьОбмен, ЛОЖЬ)
		               |			ТОГДА &Используется
		               |		ИНАЧЕ &НеИспользуется
		               |	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФТС КАК НастройкиОбменаФТС
		               |		ПО (НастройкиОбменаФТС.Организация = Организации.Ссылка
		               |			И (НастройкиОбменаФТС.Пользователь ЕСТЬ NULL
		               |			ИЛИ НастройкиОбменаФТС.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)))";
		
		СписокНастроек.ТекстЗапроса = ТекстЗапроса;
		
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("НеИспользуется", 			НСтр("ru = 'Не используется'"));
		СписокНастроек.Параметры.УстановитьЗначениеПараметра("Используется",			НСтр("ru = 'Используется'"));
		
	КонецЕсли;
	
	СписокНастроек.ДинамическоеСчитываниеДанных = Истина;
	СписокНастроек.ОсновнаяТаблица 				= "Справочник.Организации";
	
	Элементы.СписокНастроекОрганизацияУчетнаяЗаписьОбмена.Видимость = 
		ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеНастроекЭДООрганизации" Тогда
		Элементы.СписокНастроек.Обновить();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокНастроекПередНачаломИзменения(Элемент, Отказ)
	
	ОткрытьФормуНастройки();
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ОткрытьФормуНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьНастройку(Команда)
	
	ОткрытьФормуНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройки()
	
	ТекущиеДанные = Элементы.СписокНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите организацию'"));
		Возврат;
	КонецЕсли;
	
	Организация = ТекущиеДанные.Организация;
	
	Если НЕ ЗначениеЗаполнено(ВидНастроек) Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФНСиПФРиРосстатомиЦБ(Организация);
					   
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСС(Организация);
	   
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСРАР(Организация);
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсРПН(Организация);
		
	ИначеЕсли ВидНастроек = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС") Тогда
		
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФТС(Организация);
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти



