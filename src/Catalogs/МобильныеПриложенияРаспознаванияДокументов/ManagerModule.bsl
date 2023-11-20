#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Ответственный)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура АктуализироватьДанные() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого МобильноеПриложение Из РаспознаваниеДокументовКоннекторСлужебный.ПодключенныеМобильныеПриложения() Цикл
		
		Ссылка = Справочники.МобильныеПриложенияРаспознаванияДокументов.НайтиПоКоду(МобильноеПриложение.Идентификатор);
		Если Ссылка.Пустая() Тогда
			
			Объект = Справочники.МобильныеПриложенияРаспознаванияДокументов.СоздатьЭлемент();
			Объект.Код = МобильноеПриложение.Идентификатор;
			Объект.Наименование = МобильноеПриложение.Имя;
			Объект.Ответственный = Пользователи.ТекущийПользователь();
			Объект.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ПолучитьСписок() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МобильныеПриложенияРаспознаванияДокументов.Ссылка КАК Ссылка,
		|	МобильныеПриложенияРаспознаванияДокументов.Код КАК Идентификатор,
		|	МобильныеПриложенияРаспознаванияДокументов.Наименование КАК Имя,
		|	МобильныеПриложенияРаспознаванияДокументов.Ответственный КАК Ответственный,
		|	МобильныеПриложенияРаспознаванияДокументов.Отключено КАК Отключено
		|ИЗ
		|	Справочник.МобильныеПриложенияРаспознаванияДокументов КАК МобильныеПриложенияРаспознаванияДокументов";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Таблица.Колонки.Добавить("ДатаПоследнейАктивности");
	
	Подключенные = РаспознаваниеДокументовКоннекторСлужебный.ПодключенныеМобильныеПриложения();
	
	Для Каждого Строка Из Таблица Цикл
		
		СтрокаПодключенного = Подключенные.Найти(Строка.Идентификатор, "Идентификатор");
		Если СтрокаПодключенного <> Неопределено Тогда
			Строка.ДатаПоследнейАктивности = СтрокаПодключенного.ДатаПоследнейАктивности;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ЕстьАктивныеМобильныеПриложения() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МобильныеПриложенияРаспознаванияДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.МобильныеПриложенияРаспознаванияДокументов КАК МобильныеПриложенияРаспознаванияДокументов
	|ГДЕ
	|	НЕ МобильныеПриложенияРаспознаванияДокументов.Отключено";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура УстановитьПризнакОтключенВсемМобильнымПриложениям() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МобильныеПриложенияРаспознаванияДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.МобильныеПриложенияРаспознаванияДокументов КАК МобильныеПриложенияРаспознаванияДокументов
	|ГДЕ
	|	НЕ МобильныеПриложенияРаспознаванияДокументов.Отключено";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НашОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НашОбъект.Отключено = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НашОбъект);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
