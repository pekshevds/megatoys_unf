
#Область ПрограммныйИнтерфейс

// Процедура выполняет общий код команды документ основание надпись обработка навигационной ссылки
//
// Параметры:
//  Форма									 - Форма	 - Форма денежного документа
//  Элемент									 - ЭлементФормы	 - Элемент с гиперссылкой
//  НавигационнаяСсылкаФорматированнойСтроки - Строка	 - Вид навигационной ссылки
//  СтандартнаяОбработка					 - Булево	 - Стандартная обработка
//
Процедура ДокументОснованиеНадписьОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "удалить" Тогда
		
		Форма.Объект.ДокументОснование = Неопределено;
		Форма.Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Неопределено);
		Форма.Модифицированность = Истина;
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "заполнить" Тогда
		
		ЗаполнитьПоОснованиюНачало(Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "выбрать" Тогда
		
		// Выбрать основание
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборТипаОснованияЗавершение", Форма);
		ДополнительныеПараметры = Новый Структура;
		Если ФормыДокументовДеньгиКлиентСервер.ЭтоПоступлениеВКассу(Форма) Тогда
			ДополнительныеПараметры.Вставить("НовыйМеханизмИнкассации", Форма.Объект.НовыйМеханизмИнкассации);
			ДополнительныеПараметры.Вставить("КассаККМ", Форма.Объект.КассаККМ);
		КонецЕсли;
		
		СписокОснований = ФормыДокументовДеньгиВызовСервера.ПолучитьСписокДляВыбораДокументаОснования(Форма.ИмяФормы, Форма.Объект.ВидОперации, ДополнительныеПараметры);
		
		Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, СписокОснований, Элемент);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "открыть" Тогда
		
		РаботаСФормойДокументаКлиент.ОткрытьФормуДокументаПоСсылке(Форма.Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет общий код команды заполнить по основанию
//
// Параметры:
//  Форма	 - Форма	 - Форма денежного документа
//
Процедура ЗаполнитьПоОснованиюНачало(Форма) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", Форма);
	ПоказатьВопрос(
		ОписаниеОповещения, 
		НСтр("ru = 'Заполнить документ по выбранному основанию?'"), 
		РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

// Процедура выполняет общий код команды шапка табличная часть
//
// Параметры:
//  Форма	 - Форма	 - Форма денежного документа
//
Процедура ШапкаТабличнаяЧасть(Форма) Экспорт
	
	Объект = Форма.Объект;
	ПараметрыДиалога = Новый Структура;
	ПараметрыФормы = Новый Структура;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКартам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.ВозвратОплатыНаПлатежныеКарты") Тогда
		
		ПараметрыФормы.Вставить("ПоложениеНастроекНалоговогоУчета", Объект.ПоложениеНастроекНалоговогоУчета);
		ПараметрыФормы.Вставить("ПоложениеЭквайринговогоТерминала", Объект.ПоложениеЭквайринговогоТерминала);
		ПараметрыФормы.Вставить("ДоговорЭквайринга", 				Форма.ДоговорЭквайринга);
		
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ПоложениеСтатьи", Объект.ПоложениеСтатьи);
	ПараметрыФормы.Вставить("ПоложениеПроекта", Объект.ПоложениеПроекта);
	ПараметрыФормы.Вставить("ПоложениеПодразделения", Объект.ПоложениеПодразделения);
	
	// Для данных видов операций пока не поддерживается переключение положения статьи
	Если    Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКартам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.ВозвратОплатыНаПлатежныеКарты")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.ВозвратПродажиВКредит")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.Зарплата")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходИзКассы.Зарплата")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежноеПоручение.Зарплата")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежноеПоручение.ПеречислениеНалога") Тогда
		
		ПараметрыФормы.Удалить("ПоложениеСтатьи");
		
	КонецЕсли;
	
	// Для данных видов операций пока не поддерживается переключение положения подразделения
	Если    Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.РасчетыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеВКассу.РасчетыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.РасчетыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходИзКассы.РасчетыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ВозвратЗаймаСотрудником")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеВКассу.ВозвратЗаймаСотрудником")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежноеПоручение.РасчетыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежноеПоручение.ПеречислениеНалога") Тогда
		
		ПараметрыФормы.Удалить("ПоложениеПодразделения");
		ПараметрыФормы.Удалить("ПоложениеПроекта");
		
	КонецЕсли;
	
	ФормыДокументовДеньгиВызовСервера.ЗаполнитьПараметрыДиалогаШапкаТабличнаяЧасть(ПараметрыФормы, ПараметрыДиалога);
	
	ОткрытьФорму(
	"ОбщаяФорма.ШапкаТабличнаяЧасть",
	ПараметрыДиалога,,,,,
	Новый ОписаниеОповещения("ШапкаТабличнаяЧастьЗавершение", Форма));
	
КонецПроцедуры

// Процедура выполняет общий код при изменении статьи в документе
//
// Параметры:
//  Форма	 - Форма	 - Форма денежного документа
//
Процедура СтатьяПриИзменении(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Если ЗначениеЗаполнено(Объект.Статья) Тогда
		Объект.УчитыватьВНУ = ФормыДокументовДеньгиВызовСервера.СтатьяУчитываетсяВНУ(Объект.Статья, Объект.Организация, Объект.Дата, Объект.ВидОперации);
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет общий код при изменении кассы в документе
//
// Параметры:
//  Форма	 - Форма	 - Форма денежного документа
//
Процедура КассаПриИзменении(Форма) Экспорт
	
	Объект = Форма.Объект;
	СтруктураДанных = ФормыДокументовДеньгиВызовСервера.ДанныеКассыПриИзменении(Объект.Касса);
	
	ПредыдущаяВалютаДС = Объект.ВалютаДенежныхСредств;
	
	Объект.ВалютаДенежныхСредств = ?(
		ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) И Не РасчетыРаботаСФормамиКлиент.ВсеСуммыРавныНулю(Форма),
		Объект.ВалютаДенежныхСредств,
		СтруктураДанных.ВалютаПоУмолчанию);
	
	Объект.ПодписьКассира = СтруктураДанных.ПодписьКассира;
	
КонецПроцедуры

// Процедура выполняет общий код при изменении документа планирования в документе
//
// Параметры:
//  Форма	 - Форма	 - Форма денежного документа
//  ИмяТЧ	 - Строка	 - Имя табличной части Расшифровка платежа
//
Процедура ДокументПланированияПриИзменении(Форма, ИмяТЧ) Экспорт
	
	ТекущиеДанные = Форма.Элементы[ИмяТЧ].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ДокументПланирования) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоВыплатаЗарплаты = ИмяТЧ = "ВыплатаЗаработнойПлаты";
	
	СтруктураДанных = ФормыДокументовДеньгиВызовСервера.ДанныеДокументаПланирования(
		ТекущиеДанные.ДокументПланирования, Форма.ВестиУчетОплатыПоСчетам,
		Форма.ВестиРасчетыПоДокументам Или ЭтоВыплатаЗарплаты);
	
	Если ЭтоВыплатаЗарплаты Тогда
		ИмяПоляДокумент = "Ведомость";
		СтруктураДанных.Вставить(ИмяПоляДокумент, СтруктураДанных.Документ);
	Иначе	
		ИмяПоляДокумент = "Документ";
	КонецЕсли;
	
	УстановитьЗначениеВСтрокуТекущиеДанные(ТекущиеДанные, СтруктураДанных, "СтатьяДДС");
	
	Если ЗначениеЗаполнено(СтруктураДанных.СчетНаОплату) И Не ЗначениеЗаполнено(ТекущиеДанные.СчетНаОплату) Тогда
		УстановитьЗначениеВСтрокуТекущиеДанные(ТекущиеДанные, СтруктураДанных, "СчетНаОплату");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураДанных[ИмяПоляДокумент]) И Не ЗначениеЗаполнено(ТекущиеДанные[ИмяПоляДокумент]) Тогда
		УстановитьЗначениеВСтрокуТекущиеДанные(ТекущиеДанные, СтруктураДанных, ИмяПоляДокумент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураДанных.Подразделение) И Не ЗначениеЗаполнено(ТекущиеДанные.Подразделение) Тогда
		УстановитьЗначениеВСтрокуТекущиеДанные(ТекущиеДанные, СтруктураДанных, "Подразделение");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗначениеВСтрокуТекущиеДанные(ТекущиеДанные, СтруктураДанных, ИмяСвойства)
	
	Если ТекущиеДанные.Свойство(ИмяСвойства) Тогда
		ТекущиеДанные[ИмяСвойства] = СтруктураДанных[ИмяСвойства];
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
