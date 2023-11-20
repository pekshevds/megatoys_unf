#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		Товары.Очистить();
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМП.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("Товары.Характеристика");
	НепроверяемыеРеквизиты.Добавить("Товары.НаименованиеПервичногоДокумента");
	НепроверяемыеРеквизиты.Добавить("Товары.НомерПервичногоДокумента");
	НепроверяемыеРеквизиты.Добавить("Товары.ДатаПервичногоДокумента");
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Товары""'");
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		НомерСтроки = Товары.Индекс(СтрокаТовары) + 1;
		
		Если Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации
			Или Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотТовараПриобретавшегосяНеДляПродажи Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаТовары.НомерПервичногоДокумента) Тогда
					
				ТекстСообщения = СтрШаблон(
					ШаблонСообщения,
					НСтр("ru = '№ документа продажи'"),
					НомерСтроки);
				
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					Ссылка,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Объект.Товары", НомерСтроки, "ПредставлениеПервичногоДокумента"),,
					Отказ);
				
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(СтрокаТовары.ДатаПервичногоДокумента) Тогда
				
				ТекстСообщения = СтрШаблон(
					ШаблонСообщения,
					НСтр("ru = 'Дата документа продажи'"),
					НомерСтроки);
				
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					Ссылка,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Объект.Товары", НомерСтроки, "ПредставлениеПервичногоДокумента"),,
					Отказ);
				
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(СтрокаТовары.НаименованиеПервичногоДокумента)
				И (СтрокаТовары.ВидПервичногоДокумента = Перечисления.ВидыПервичныхДокументовИСМП.Прочее
					Или Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотТовараПриобретавшегосяНеДляПродажи) Тогда
				
				ТекстСообщения = СтрШаблон(
					ШаблонСообщения,
					НСтр("ru = 'Наименование документа продажи'"),
					НомерСтроки);
				
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					Ссылка,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Объект.Товары", НомерСтроки, "ПредставлениеПервичногоДокумента"),,
					Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование   = Неопределено;
	ИдентификаторЗаявки = Неопределено;
	Товары.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияВозвратаВОборотИСМП(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли