#Область СлужебныеПроцедурыИФункции

Функция ТипыОбъектовСоСтороннимиПечатнымиФормами() Экспорт
	
	ТипыОбъектов = Новый Массив;
	ТипыОбъектов.Добавить(Тип("ДокументСсылка.Увольнение"));
	
	Возврат ТипыОбъектов;
	
КонецФункции

Процедура ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек) Экспорт
	
	Настройка = ОписанияНастроек.Добавить();
	Настройка.ИдентификаторПечатнойФормы = Документы.СогласиеНаПрисоединениеККЭДО.ИдентификаторКомандыПечатиЗаявления();
	Настройка.СодержимоеДокумента = Перечисления.СодержимоеДокументов.НеСодержитЗарплаты;
	Настройка.БлокировкаСУсловием = Ложь;
	
	ЭлектронныеТрудовыеКнижки.ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек);
	УчетНДФЛДокументы.ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек);
	КадровыйУчет.ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек);
	УчетПособийСоциальногоСтрахования.ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ЗарплатаКадрыДляНебольшихОрганизаций") Тогда
		МодульЗарплатаКадрыДляНебольшихОрганизаций = ОбщегоНазначения.ОбщийМодуль("ЗарплатаКадрыДляНебольшихОрганизаций");
		МодульЗарплатаКадрыДляНебольшихОрганизаций.ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
