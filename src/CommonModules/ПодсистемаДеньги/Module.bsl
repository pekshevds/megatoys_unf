
#Область ПрограммныйИнтерфейс

// См. ОбновлениеИнформационнойБазыУНФ.ОбновлениеРозницыДоУНФ
Процедура ОбновлениеРозницыДоУНФ() Экспорт
	
	УстановитьКонстантыОбновленияРозницыДоУНФ();
	ЗаполнитьДанныеПриПереходеСРозницы();
	
КонецПроцедуры

// Процедура выполняет первоначальное заполнение данных подсистемы и включение функциональности при первом запуске приложения
//
Процедура ПриПервомЗапуске() Экспорт
	
	УстановитьКонстантыНачальногоЗаполнения();
	ПервоначальноеЗаполнениеОбъектовПодсистемы();
	
КонецПроцедуры

// Процедура выполняет первоначальное заполнение данных подсистемы
//
Процедура ПервоначальноеЗаполнениеОбъектовПодсистемы() Экспорт
	
	// Заполнение курсов валюты.
	РаботаСКурсамиВалют.ПроверитьКорректностьКурсаНа01_01_1980(Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения());
	
КонецПроцедуры

// Процедура выполняет первоначальное включение функциональности подсистемы
//
Процедура УстановитьКонстантыНачальногоЗаполнения() Экспорт
	
	РежимЗапускаУНФ = Константы.ТекущийРежимЗапускаУНФ.Получить();
	ЭтоРозница 		= ВозможностиПриложения.ЭтоРозница();
	ЭтоУНФ 			= ВозможностиПриложения.ЭтоУНФ();
	
	ЭтоНастольноеПриложениеУНФ = ЭтоУНФ И РежимЗапускаУНФ = Перечисления.РежимыЗапускаУНФ.НастольноеПриложение;

	// Использование нового КБ.
	Константы.ИспользоватьТолькоНовыйКБ.Установить(Истина);
	
	Если ЭтоУНФ Тогда
		
		Константы.СпособЗачетаПредоплатыПоУмолчанию.Установить(Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную);
		Константы.СпособРазнесенияОплатыПоУмолчанию.Установить(Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную);
		
		Константы.ЗачитыватьАвансыДолгиАвтоматически.Установить(Перечисления.ДаНет.Нет);
		Константы.ВалютаУчета.Установить(Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения());
		Константы.НациональнаяВалюта.Установить(Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения());
		Константы.ЧастотаРасчетаКурсовыхРазниц.Установить(Перечисления.ЧастотаРасчетаКурсовыхРазниц.ТолькоПриЗакрытииПериода);
		// Установка значения служебной константы для регистра ДвиженияДенежныхСредств
		Константы.РегистрДвиженияДенежныхСредствЗаполнен.Установить(Истина);
		Константы.ВестиРасчетыПоДоговорам.Установить(Истина);
		Константы.ВестиРасчетыПоДокументам.Установить(Истина);
		Константы.ВестиРасчетыПоЗаказам.Установить(Истина);
		Константы.ВестиУчетОплатыПоСчетам.Установить(Истина);
	
		Если ЭтоНастольноеПриложениеУНФ Тогда
			Константы.ИспользоватьБанковскиеСчета.Установить(Истина);
			Константы.ОтображатьДокументыПоБанку.Установить(Истина); 
			Константы.ИспользоватьБанкИКассу.Установить(Истина);
			Константы.ИспользоватьПодсистемуДеньги.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоРозница Тогда
		
		Константы.СпособЗачетаПредоплатыПоУмолчанию.Установить(Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную);
		Константы.СпособРазнесенияОплатыПоУмолчанию.Установить(Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную);
		
		Константы.ЗачитыватьАвансыДолгиАвтоматически.Установить(Перечисления.ДаНет.Нет);
		Константы.ВалютаУчета.Установить(Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения());
		Константы.НациональнаяВалюта.Установить(Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения());
		Константы.ЧастотаРасчетаКурсовыхРазниц.Установить(Перечисления.ЧастотаРасчетаКурсовыхРазниц.ТолькоПриЗакрытииПериода);
		Константы.ФункциональнаяОпцияКассовыйМетодУчетаДоходовИРасходов.Установить(Истина);
		
		Константы.ИспользоватьБанковскиеСчета.Установить(Истина);
		Константы.ОтображатьДокументыПоБанку.Установить(Истина); 
		Константы.ИспользоватьБанкИКассу.Установить(Истина);
		Константы.ИспользоватьПодсистемуДеньги.Установить(Истина);
		// Установка значения служебной константы для регистра ДвиженияДенежныхСредств
		Константы.РегистрДвиженияДенежныхСредствЗаполнен.Установить(Истина);
		
		Константы.ВестиРасчетыПоДоговорам.Установить(Истина);
		Константы.ВестиРасчетыПоДокументам.Установить(Истина);
		Константы.ВестиРасчетыПоЗаказам.Установить(Истина);
		Константы.ВестиУчетОплатыПоСчетам.Установить(Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьКонстантыОбновленияРозницыДоУНФ() 
	Возврат;
КонецПроцедуры

Процедура ЗаполнитьДанныеПриПереходеСРозницы()
	Возврат;
КонецПроцедуры

#КонецОбласти
