
#Область СлужебныйПрограммныйИнтерфейс

Функция ОписанияРазличийСхемКонфигураций(ДанныеСхемыКонфигурацииВыгрузки, ДанныеСхемыКонфигурацииСервиса) Экспорт
	
	URIПространствИменСхемаКонфигурации = URIПространствИменСхемаКонфигурации();
		
	СхемаКонфигурацииВыгрузки = СхемаXML(ДанныеСхемыКонфигурацииВыгрузки);
	ФабрикаКонфигурацииВыгрузки = ФабрикаПоСхеме(СхемаКонфигурацииВыгрузки);
	ПакетКонфигурацииВыгрузки = ПакетФабрики(ФабрикаКонфигурацииВыгрузки, URIПространствИменСхемаКонфигурации);

	СхемаКонфигурацииСервиса = СхемаXML(ДанныеСхемыКонфигурацииСервиса);
	ФабрикаКонфигурацииСервиса = ФабрикаПоСхеме(СхемаКонфигурацииСервиса);
	ПакетФабрикиКонфигурацииСервиса = ПакетФабрики(ФабрикаКонфигурацииСервиса, URIПространствИменСхемаКонфигурации);


	ВсеИменаТиповОбъектов = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеИменаТиповОбъектов, 
		ИменаТиповОбъектовПакета(ПакетКонфигурацииВыгрузки)); 
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеИменаТиповОбъектов, 
		ИменаТиповОбъектовПакета(ПакетФабрикиКонфигурацииСервиса),
		Истина); 
		
	ОписанияРазличий = Новый Массив;
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO = ИменаБазовыхТиповСравниваемыхТиповXDTO();	
	СтандартныеРеквизитыБазовыхТиповXDTO = СтандартныеРеквизитыБазовыхТиповXDTO();
	СтруктураПоискаСтандартныхРеквизитов = Новый Структура("ИмяСвойства, ИмяБазовогоТипа");
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей = ИменаТиповВладельцевБазовыхТиповТабличныхЧастей();
	
	Для Каждого ИмяТипаОбъекта Из ВсеИменаТиповОбъектов Цикл
		
		ИнформацияОТипеОбъекта = ИнформацияОТипеОбъекта(ИмяТипаОбъекта);
		
		Если ИнформацияОТипеОбъекта = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяБазовогоТипа = ИменаБазовыхТиповСравниваемыхТиповXDTO.Получить(ИнформацияОТипеОбъекта.ИмяТипаXDTO);
		
		Если ИмяБазовогоТипа = Неопределено Тогда
			Продолжить;
		КонецЕсли;
			
	    ИмяТипаВладельцаТабличнойЧасти = ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Получить(ИмяБазовогоТипа);
		ЭтоТабличнаяЧасть = ИмяТипаВладельцаТабличнойЧасти <> Неопределено;
		
		Если ЭтоТабличнаяЧасть Тогда
			ЧастиИмениПрикладногоТипа = СтрРазделить(ИнформацияОТипеОбъекта.ИмяПрикладногоТипа, ".");
			ВГраницаЧастиИмениПрикладногоТипа = ЧастиИмениПрикладногоТипа.ВГраница();
			ЧастиПолногоИмениОбъектаМетаданных = Новый Массив;
			ЧастиПолногоИмениОбъектаМетаданных.Добавить(ИмяТипаВладельцаТабличнойЧасти);
			Для Индекс = 0 По ВГраницаЧастиИмениПрикладногоТипа - 1 Цикл
				ЧастиПолногоИмениОбъектаМетаданных.Добавить(ЧастиИмениПрикладногоТипа[Индекс]);
			КонецЦикла;
			ПолноеИмяОбъектаМетаданных = СтрСоединить(ЧастиПолногоИмениОбъектаМетаданных, ".");			
			
			ИмяТабличнойЧасти = ЧастиИмениПрикладногоТипа[ВГраницаЧастиИмениПрикладногоТипа];
			
		Иначе
			ПолноеИмяОбъектаМетаданных = СтрШаблон("%1.%2", 
				ИмяБазовогоТипа, 
				ИнформацияОТипеОбъекта.ИмяПрикладногоТипа);
			ИмяТабличнойЧасти = Неопределено;
		КонецЕсли;
		
			
		ТипОбъектаКонфигурацииВыгрузки = ФабрикаКонфигурацииВыгрузки.Тип(URIПространствИменСхемаКонфигурации, ИмяТипаОбъекта);
		Если ТипОбъектаКонфигурацииВыгрузки = Неопределено Тогда
			Если Не ЭтоТабличнаяЧасть Тогда
				ОписанияРазличий.Добавить(СтрШаблон(НСтр("ru = 'Объект метаданных ''%1'' отсутствует в конфигурации информационной базы, но присутствует в конфигурации выгрузки'"),
					ПолноеИмяОбъектаМетаданных));
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		ТипОбъектаКонфигурацииСервиса = ФабрикаКонфигурацииСервиса.Тип(URIПространствИменСхемаКонфигурации, ИмяТипаОбъекта);	
		Если ТипОбъектаКонфигурацииСервиса = Неопределено Тогда
			Если Не ЭтоТабличнаяЧасть Тогда
				ОписанияРазличий.Добавить(СтрШаблон(НСтр("ru = 'Объект метаданных ''%1'' отсутствует в конфигурации выгрузки, но присутствует в конфигурации информационной базы'"),
					ПолноеИмяОбъектаМетаданных));		
			КонецЕсли;
			Продолжить;
		КонецЕсли;
				
		ВсеИменаСвойствТипаОбъекта = Новый Массив;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеИменаСвойствТипаОбъекта, 
			ИменаСвойствТипаОбъекта(ТипОбъектаКонфигурацииВыгрузки)); 
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеИменаСвойствТипаОбъекта, 
			ИменаСвойствТипаОбъекта(ТипОбъектаКонфигурацииСервиса),
			Истина); 
			
		СвойстваТипаОбъектаКонфигурацииВыгрузки = ТипОбъектаКонфигурацииВыгрузки.Свойства;
		СвойстваТипаОбъектаКонфигурацииСервиса = ТипОбъектаКонфигурацииСервиса.Свойства;
		
		СтруктураПоискаСтандартныхРеквизитов.ИмяБазовогоТипа = ИмяБазовогоТипа;

		Для Каждого ИмяСвойстваТипаОбъекта Из ВсеИменаСвойствТипаОбъекта Цикл
			
			СтруктураПоискаСтандартныхРеквизитов.ИмяСвойства = ИмяСвойстваТипаОбъекта;

			СтрокиСтандартныхРеквизитов = СтандартныеРеквизитыБазовыхТиповXDTO.НайтиСтроки(СтруктураПоискаСтандартныхРеквизитов);
			
			Если ЗначениеЗаполнено(СтрокиСтандартныхРеквизитов) Тогда
				ИмяРеквизита = СтрокиСтандартныхРеквизитов[0].ИмяСтандартногоРеквизита;
			Иначе
				ИмяРеквизита = ИмяСвойстваТипаОбъекта; 
			КонецЕсли;
										
			СвойствоОбъектаКонфигурацииВыгрузки = СвойстваТипаОбъектаКонфигурацииВыгрузки.Получить(ИмяСвойстваТипаОбъекта);		
			СвойствоОбъектаКонфигурацииСервиса = СвойстваТипаОбъектаКонфигурацииСервиса.Получить(ИмяСвойстваТипаОбъекта);
						
			Если СвойствоОбъектаКонфигурацииВыгрузки = Неопределено Тогда		
				Если ЭтоТипXDTOТабличнойЧасти(СвойствоОбъектаКонфигурацииСервиса.Тип.Имя, ИменаБазовыхТиповСравниваемыхТиповXDTO, ИменаТиповВладельцевБазовыхТиповТабличныхЧастей) Тогда
					ШаблонОписанияРазличия = НСтр("ru = 'Табличная часть ''%1'' объекта метаданных ''%2'' отсутствует в конфигурации информационной базы, но присутствует в конфигурации выгрузки'");	
				Иначе
					ШаблонОписанияРазличия = НСтр("ru = 'Реквизит ''%1'' объекта метаданных ''%2'' отсутствует в конфигурации информационной базы, но присутствует в конфигурации выгрузки'");			
				КонецЕсли;		
				ОписанияРазличий.Добавить(СтрШаблон(ШаблонОписанияРазличия,
					ИмяРеквизита,
					ПолноеИмяОбъектаМетаданных));					
				Продолжить;
			КонецЕсли;
					
			Если СвойствоОбъектаКонфигурацииСервиса = Неопределено Тогда			
				Если ЭтоТипXDTOТабличнойЧасти(СвойствоОбъектаКонфигурацииВыгрузки.Тип.Имя, ИменаБазовыхТиповСравниваемыхТиповXDTO, ИменаТиповВладельцевБазовыхТиповТабличныхЧастей) Тогда
					ШаблонОписанияРазличия = НСтр("ru = 'Табличная часть ''%1'' объекта метаданных ''%2'' отсутствует в конфигурации выгрузки, но присутствует в конфигурации информационной базы'");	
				Иначе
					ШаблонОписанияРазличия = НСтр("ru = 'Реквизит ''%1'' объекта метаданных ''%2'' отсутствует в конфигурации выгрузки, но присутствует в конфигурации информационной базы'");
				КонецЕсли;
				ОписанияРазличий.Добавить(СтрШаблон(ШаблонОписанияРазличия,
					ИмяРеквизита,
					ПолноеИмяОбъектаМетаданных));		
				Продолжить;
			КонецЕсли;
				 
			Если СвойствоОбъектаКонфигурацииВыгрузки.Тип.Имя <> СвойствоОбъектаКонфигурацииСервиса.Тип.Имя Тогда
									
				Если ЭтоТабличнаяЧасть Тогда					
					ОписаниеРазличия = СтрШаблон(НСтр("ru = 'Тип реквизита ''%1'' табличной части ''%2'' объекта метаданных ''%3'' в конфигурации информационной базы отличается от типа в конфигурации выгрузки.'"),
						ИмяРеквизита,
						ИмяТабличнойЧасти,
						ПолноеИмяОбъектаМетаданных);		
				Иначе
					ОписаниеРазличия = СтрШаблон(НСтр("ru = 'Тип реквизита ''%1'' объекта метаданных ''%2'' в конфигурации информационной базы отличается от типа в конфигурации выгрузки.'"),
						ИмяРеквизита,
						ПолноеИмяОбъектаМетаданных);		
				КонецЕсли;
					
				ОписанияРазличий.Добавить(ОписаниеРазличия);
			КонецЕсли;
					
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОписанияРазличий;
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеРеквизиты

Функция СтандартныеРеквизитыБазовыхТиповXDTO()

	СтандартныеРеквизитыБазовыхТипов = Новый ТаблицаЗначений;
	СтандартныеРеквизитыБазовыхТипов.Колонки.Добавить("ИмяСвойства");
	СтандартныеРеквизитыБазовыхТипов.Колонки.Добавить("ИмяБазовогоТипа");
	СтандартныеРеквизитыБазовыхТипов.Колонки.Добавить("ИмяСтандартногоРеквизита");
	
	ДополнитьСтандартнымиРеквизитамиРегистровБухгалтерии(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиРегистровНакопления(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиРегистровРасчета(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиРегистровСведений(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиСправочников(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиПлановВидовХарактеристик(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиПлановСчетов(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиПлановВидовРасчета(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиДокументов(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиЗадач(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиКонстант(СтандартныеРеквизитыБазовыхТипов);
	ДополнитьСтандартнымиРеквизитамиБизнесПроцессов(СтандартныеРеквизитыБазовыхТипов);				
	ДополнитьСтандартнымиРеквизитамиПоследовательностей(СтандартныеРеквизитыБазовыхТипов);	
	
	Возврат СтандартныеРеквизитыБазовыхТипов;
КонецФункции

Процедура ДополнитьСтандартнымиРеквизитамиКонстант(СтандартныеРеквизитыБазовыхТипов)
	ИмяБазовогоТипаКонстанта = ИмяБазовогоТипаКонстанта();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Type",
		ИмяБазовогоТипаКонстанта,
		ИмяСтандартногоРеквизитаТип(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Value",
		ИмяБазовогоТипаКонстанта,
		НСтр("ru = 'Значение'"),
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиСправочников(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаСправочник = ИмяБазовогоТипаСправочник();
	ИмяСтандартногоРеквизитаСсылка = ИмяСтандартногоРеквизитаСсылка();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаСсылка,
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Code",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаКод(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Description",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаНаименование(),
		СтандартныеРеквизитыБазовыхТипов);	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Owner",
		ИмяБазовогоТипаСправочник,
		НСтр("ru = 'Владелец'"),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Parent",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаРодитель(),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"IsFolder",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаЭтоГруппа(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"PredefinedDataName",
		ИмяБазовогоТипаСправочник,
		ИмяСтандартногоРеквизитаИмяПредопределенныхДанных(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ИмяБазовогоТипаСправочникТабличнаяЧасть = ИмяБазовогоТипаСправочникТабличнаяЧасть();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаСправочникТабличнаяЧасть,
		ИмяСтандартногоРеквизитаСсылка,
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиДокументов(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаДокумент = ИмяБазовогоТипаДокумент(); 
	ИмяБазовогоТипаДокументТабличнаяЧасть = ИмяБазовогоТипаДокументТабличнаяЧасть();

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаДокумент,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);	

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Number",
		ИмяБазовогоТипаДокумент,
		ИмяСтандартногоРеквизитаНомер(),
		СтандартныеРеквизитыБазовыхТипов);	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Date",
		ИмяБазовогоТипаДокумент,
		ИмяСтандартногоРеквизитаДата(),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Posted",
		ИмяБазовогоТипаДокумент,
		НСтр("ru = 'Проведен'"),
		СтандартныеРеквизитыБазовыхТипов);	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаДокумент,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);	

					
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаДокументТабличнаяЧасть,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиПоследовательностей(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаПоследовательность = ИмяБазовогоТипаПоследовательность();
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Recorder",
		ИмяБазовогоТипаПоследовательность,
		ИмяСтандартногоРеквизитаРегистратор(),
		СтандартныеРеквизитыБазовыхТипов);
		
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Period",
		ИмяБазовогоТипаПоследовательность,
		ИмяСтандартногоРеквизитаПериод(),
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиПлановВидовХарактеристик(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаПланВидовХарактеристик = ИмяБазовогоТипаПланВидовХарактеристик(); 
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Code",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаКод(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Description",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаНаименование(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"ValueType",
		ИмяБазовогоТипаПланВидовХарактеристик,
		"ТипЗначения",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Parent",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаРодитель(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"IsFolder",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаЭтоГруппа(),
		СтандартныеРеквизитыБазовыхТипов);
				
	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);	
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"PredefinedDataName",
		ИмяБазовогоТипаПланВидовХарактеристик,
		ИмяСтандартногоРеквизитаИмяПредопределенныхДанных(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ИмяБазовогоТипаПланВидовХарактеристикТабличнаяЧасть = ИмяБазовогоТипаПланВидовХарактеристикТабличнаяЧасть();	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаПланВидовХарактеристикТабличнаяЧасть,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);
		
КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиПлановСчетов(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаПланСчетов = ИмяБазовогоТипаПланСчетов(); 
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Code",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаКод(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Description",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаНаименование(),
		СтандартныеРеквизитыБазовыхТипов);	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Order",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаПорядок(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Parent",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаРодитель(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Type",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаВид(),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"OffBalance",
		ИмяБазовогоТипаПланСчетов,
		НСтр("ru = 'Забалансовый'"),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);	
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"PredefinedDataName",
		ИмяБазовогоТипаПланСчетов,
		ИмяСтандартногоРеквизитаИмяПредопределенныхДанных(),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"ExtDimensionType",
		ИмяБазовогоТипаПланСчетов,
		"ВидСубконто",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ИмяБазовогоТипаПланСчетовТабличнаяЧасть = ИмяБазовогоТипаПланСчетовТабличнаяЧасть();

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаПланСчетовТабличнаяЧасть,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиПлановВидовРасчета(СтандартныеРеквизитыБазовыхТипов)
	ИмяБазовогоТипаПланВидовРасчета = ИмяБазовогоТипаПланВидовРасчета(); 

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаПланВидовРасчета,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Code",
		ИмяБазовогоТипаПланВидовРасчета,
		ИмяСтандартногоРеквизитаКод(),
		СтандартныеРеквизитыБазовыхТипов);	
				
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Description",
		ИмяБазовогоТипаПланВидовРасчета,
		ИмяСтандартногоРеквизитаНаименование(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаПланВидовРасчета,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);	
			
	ДополнитьТаблицуСтандартныхРеквизитов(
		"PredefinedDataName",
		ИмяБазовогоТипаПланВидовРасчета,
		ИмяСтандартногоРеквизитаИмяПредопределенныхДанных(),
		СтандартныеРеквизитыБазовыхТипов);	
			
	ДополнитьТаблицуСтандартныхРеквизитов(
		"DisplacingCalculationTypes",
		ИмяБазовогоТипаПланВидовРасчета,
		"ВытесняющиеВидыРасчета",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"LeadingCalculationTypes",
		ИмяБазовогоТипаПланВидовРасчета,
		"ВедущиеВидыРасчета",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"BaseCalculationTypes",
		ИмяБазовогоТипаПланВидовРасчета,
		"БазовыеВидыРасчета",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ИмяБазовогоТипаПланВидовРасчетаТабличнаяЧасть = ИмяБазовогоТипаПланВидовРасчетаТабличнаяЧасть();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаПланВидовРасчетаТабличнаяЧасть,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);	

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиРегистровСведений(СтандартныеРеквизитыБазовыхТипов)
	ИмяБазовогоТипаРегистрСведений = ИмяБазовогоТипаРегистрСведений();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Period",
		ИмяБазовогоТипаРегистрСведений,
		ИмяСтандартногоРеквизитаПериод(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Recorder",
		ИмяБазовогоТипаРегистрСведений,
		ИмяСтандартногоРеквизитаРегистратор(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"LineNumber",
		ИмяБазовогоТипаРегистрСведений,
		ИмяСтандартногоРеквизитаНомерСтроки(),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Active",
		ИмяБазовогоТипаРегистрСведений,
		ИмяСтандартногоРеквизитаАктивность(),
		СтандартныеРеквизитыБазовыхТипов);
		
		
КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиРегистровНакопления(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаРегистрНакопления = ИмяБазовогоТипаРегистрНакопления();

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Period",
		ИмяБазовогоТипаРегистрНакопления,
		ИмяСтандартногоРеквизитаПериод(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Recorder",
		ИмяБазовогоТипаРегистрНакопления,
		ИмяСтандартногоРеквизитаРегистратор(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"LineNumber",
		ИмяБазовогоТипаРегистрНакопления,
		ИмяСтандартногоРеквизитаНомерСтроки(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Active",
		ИмяБазовогоТипаРегистрНакопления,
		ИмяСтандартногоРеквизитаАктивность(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"RecordType",
		ИмяБазовогоТипаРегистрНакопления,
		ИмяСтандартногоРеквизитаВидДвижения(),
		СтандартныеРеквизитыБазовыхТипов);	
		
КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиРегистровБухгалтерии(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаРегистрБухгалтерии = ИмяБазовогоТипаРегистрБухгалтерии();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Period",
		ИмяБазовогоТипаРегистрБухгалтерии,
		ИмяСтандартногоРеквизитаПериод(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Recorder",
		ИмяБазовогоТипаРегистрБухгалтерии,
		ИмяСтандартногоРеквизитаРегистратор(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"LineNumber",
		ИмяБазовогоТипаРегистрБухгалтерии,
		ИмяСтандартногоРеквизитаНомерСтроки(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Active",
		ИмяБазовогоТипаРегистрБухгалтерии,
		ИмяСтандартногоРеквизитаАктивность(),
		СтандартныеРеквизитыБазовыхТипов);
	 
	 ДополнитьТаблицуСтандартныхРеквизитов(
		"Account",
		ИмяБазовогоТипаРегистрБухгалтерии,
		НСтр("ru = 'Счет'"),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"AccountCr",
		ИмяБазовогоТипаРегистрБухгалтерии,
		"СчетКт",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"ExtDimensionsCr",
		ИмяБазовогоТипаРегистрБухгалтерии,
		"СубконтоКт",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"AccountDr",
		ИмяБазовогоТипаРегистрБухгалтерии,
		"СчетДт",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"ExtDimensionsDr",
		ИмяБазовогоТипаРегистрБухгалтерии,
		"СубконтоДт",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"RecordType",
		ИмяБазовогоТипаРегистрБухгалтерии,
		ИмяСтандартногоРеквизитаВидДвижения(),
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиРегистровРасчета(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаРегистрРасчета = ИмяБазовогоТипаРегистрРасчета();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"RegistrationPeriod",
		ИмяБазовогоТипаРегистрРасчета,
		"ПериодРегистрации",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Recorder",
		ИмяБазовогоТипаРегистрРасчета,
		ИмяСтандартногоРеквизитаРегистратор(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"LineNumber",
		ИмяБазовогоТипаРегистрРасчета,
		ИмяСтандартногоРеквизитаНомерСтроки(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"CalculationType",
		ИмяБазовогоТипаРегистрРасчета,
		"ВидРасчета",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"ActionPeriod",
		ИмяБазовогоТипаРегистрРасчета,
		"ПериодДействия",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);	

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Active",
		ИмяБазовогоТипаРегистрРасчета,
		ИмяСтандартногоРеквизитаАктивность(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"ReversingEntry",
		ИмяБазовогоТипаРегистрРасчета,
		НСтр("ru = 'Сторно'"),
		СтандартныеРеквизитыБазовыхТипов);
		
КонецПроцедуры

Процедура ДополнитьСтандартнымиРеквизитамиБизнесПроцессов(СтандартныеРеквизитыБазовыхТипов)
	
	ИмяБазовогоТипаБизнесПроцесс = ИмяБазовогоТипаБизнесПроцесс();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаБизнесПроцесс,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);	
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Number",
		ИмяБазовогоТипаБизнесПроцесс,
		ИмяСтандартногоРеквизитаНомер(),
		СтандартныеРеквизитыБазовыхТипов);	
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Date",
		ИмяБазовогоТипаБизнесПроцесс,
		ИмяСтандартногоРеквизитаДата(),
		СтандартныеРеквизитыБазовыхТипов);
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"HeadTask",
		ИмяБазовогоТипаБизнесПроцесс,
		"ВедущаяЗадача",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаБизнесПроцесс,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);	
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Started",
		ИмяБазовогоТипаБизнесПроцесс,
		НСтр("ru = 'Стартован'"),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Completed",
		ИмяБазовогоТипаБизнесПроцесс,
		НСтр("ru = 'Завершен'"),
		СтандартныеРеквизитыБазовыхТипов);

КонецПроцедуры
	
Процедура ДополнитьСтандартнымиРеквизитамиЗадач(СтандартныеРеквизитыБазовыхТипов)
	ИмяБазовогоТипаЗадача = ИмяБазовогоТипаЗадача(); 

	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаЗадача,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);	
				
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Number",
		ИмяБазовогоТипаЗадача,
		ИмяСтандартногоРеквизитаНомер(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Description",
		ИмяБазовогоТипаЗадача,
		ИмяСтандартногоРеквизитаНаименование(),
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Date",
		ИмяБазовогоТипаЗадача,
		ИмяСтандартногоРеквизитаДата(),
		СтандартныеРеквизитыБазовыхТипов);

	ДополнитьТаблицуСтандартныхРеквизитов(
		"DeletionMark",
		ИмяБазовогоТипаЗадача,
		ИмяСтандартногоРеквизитаПометкаУдаления(),
		СтандартныеРеквизитыБазовыхТипов);	
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"BusinessProcess",
		ИмяБазовогоТипаЗадача,
		"БизнесПроцесс",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);		
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"RoutePoint",
		ИмяБазовогоТипаЗадача,
		"ТочкаМаршрута",	// Не локализуется
		СтандартныеРеквизитыБазовыхТипов);
		
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Executed",
		ИмяБазовогоТипаЗадача,
		НСтр("ru = 'Выполнена'"),
		СтандартныеРеквизитыБазовыхТипов);
	
	ИмяБазовогоТипаЗадачаТабличнаяЧасть = ИмяБазовогоТипаЗадачаТабличнаяЧасть();
	
	ДополнитьТаблицуСтандартныхРеквизитов(
		"Ref",
		ИмяБазовогоТипаЗадачаТабличнаяЧасть,
		ИмяСтандартногоРеквизитаСсылка(),
		СтандартныеРеквизитыБазовыхТипов);	

КонецПроцедуры

Процедура ДополнитьТаблицуСтандартныхРеквизитов(ИмяСвойства, ИмяБазовогоТипа, ИмяСтандартногоРеквизита, ТаблицаСтандартныхРеквизитов)
	
	НоваяСтрока = ТаблицаСтандартныхРеквизитов.Добавить();
	НоваяСтрока.ИмяСвойства = ИмяСвойства;
	НоваяСтрока.ИмяБазовогоТипа = ИмяБазовогоТипа;
	НоваяСтрока.ИмяСтандартногоРеквизита = ИмяСтандартногоРеквизита;
	
КонецПроцедуры

Функция ИмяСтандартногоРеквизитаРегистратор() 
	Возврат "Регистратор";
КонецФункции

Функция ИмяСтандартногоРеквизитаАктивность() 
	Возврат "Активность";
КонецФункции

Функция ИмяСтандартногоРеквизитаПериод() 
	Возврат "Период";
КонецФункции

Функция ИмяСтандартногоРеквизитаВидДвижения() 
	Возврат "ВидДвижения";
КонецФункции

Функция ИмяСтандартногоРеквизитаЭтоГруппа() 
	Возврат "ЭтоГруппа";
КонецФункции

Функция ИмяСтандартногоРеквизитаКод() 
	Возврат "Код";
КонецФункции

Функция ИмяСтандартногоРеквизитаПометкаУдаления() 
	Возврат "ПометкаУдаления";
КонецФункции

Функция ИмяСтандартногоРеквизитаНаименование() 
	Возврат "Наименование";
КонецФункции

Функция ИмяСтандартногоРеквизитаРодитель() 
	Возврат "Родитель";
КонецФункции

Функция ИмяСтандартногоРеквизитаСсылка() 
	Возврат "Ссылка";
КонецФункции

Функция ИмяСтандартногоРеквизитаДата() 
	Возврат "Дата";
КонецФункции

Функция ИмяСтандартногоРеквизитаПорядок() 
	Возврат "Порядок";
КонецФункции

Функция ИмяСтандартногоРеквизитаИмяПредопределенныхДанных() 
	Возврат "ИмяПредопределенныхДанных";
КонецФункции

Функция ИмяСтандартногоРеквизитаТип() 
	Возврат "Тип";
КонецФункции

Функция ИмяСтандартногоРеквизитаНомерСтроки()
	Возврат "НомерСтроки";	
КонецФункции

Функция ИмяСтандартногоРеквизитаВид() 
	Возврат "Вид";
КонецФункции

Функция ИмяСтандартногоРеквизитаНомер() 
	Возврат "Номер";
КонецФункции

#КонецОбласти 

#Область БазовыеТипы

Функция ЭтоБазовыйТипТабличнойЧасти(ИмяБазовогоТипа, ИменаТиповВладельцевБазовыхТиповТабличныхЧастей)
	
	Возврат ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Получить(ИмяБазовогоТипа) <> Неопределено;

КонецФункции

Функция ИмяБазовогоТипаКонстанта()
	Возврат "Константа";	
КонецФункции

Функция ИмяБазовогоТипаСправочник()
	Возврат "Справочник";
КонецФункции

Функция ИмяБазовогоТипаСправочникТабличнаяЧасть()
	Возврат "СправочникТабличнаяЧасть";	
КонецФункции

Функция ИмяБазовогоТипаДокумент()
	Возврат "Документ";
КонецФункции

Функция ИмяБазовогоТипаДокументТабличнаяЧасть()
	Возврат "ДокументТабличнаяЧасть";
КонецФункции

Функция ИмяБазовогоТипаПоследовательность()
	Возврат "Последовательность";
КонецФункции

Функция ИмяБазовогоТипаПланВидовХарактеристик()
	Возврат "ПланВидовХарактеристик";	
КонецФункции

Функция ИмяБазовогоТипаПланВидовХарактеристикТабличнаяЧасть()
	Возврат "ПланВидовХарактеристикТабличнаяЧасть";
КонецФункции

Функция ИмяБазовогоТипаПланСчетов()
	Возврат "ПланСчетов";	
КонецФункции

Функция ИмяБазовогоТипаПланСчетовТабличнаяЧасть()
	Возврат "ПланСчетовТабличнаяЧасть";	
КонецФункции

Функция ИмяБазовогоТипаПланВидовРасчета()
	Возврат "ПланВидовРасчета";
КонецФункции

Функция ИмяБазовогоТипаПланВидовРасчетаТабличнаяЧасть()
	Возврат "ПланВидовРасчетаТабличнаяЧасть";
КонецФункции

Функция ИмяБазовогоТипаРегистрСведений()
	Возврат "РегистрСведений";	
КонецФункции

Функция ИмяБазовогоТипаРегистрНакопления()
	Возврат "РегистрНакопления";	
КонецФункции

Функция ИмяБазовогоТипаРегистрБухгалтерии()
	Возврат "РегистрБухгалтерии";	
КонецФункции

Функция ИмяБазовогоТипаРегистрРасчета()
	Возврат "РегистрРасчета";	
КонецФункции

Функция ИмяБазовогоТипаБизнесПроцесс()
	Возврат "БизнесПроцесс";	
КонецФункции

Функция ИмяБазовогоТипаБизнесПроцессТабличнаяЧасть()
	Возврат "БизнесПроцессТабличнаяЧасть";	
КонецФункции

Функция ИмяБазовогоТипаЗадача()
	Возврат "Задача";	
КонецФункции

Функция ИмяБазовогоТипаЗадачаТабличнаяЧасть()
	Возврат "ЗадачаТабличнаяЧасть";	
КонецФункции

Функция ИмяБазовогоТипаПланОбмена()
	Возврат "ПланОбмена";
КонецФункции

Функция ИмяБазовогоТипаПланОбменаТабличнаяЧасть()
	Возврат "ПланОбменаТабличнаяЧасть";
КонецФункции

Функция ИменаТиповВладельцевБазовыхТиповТабличныхЧастей()
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей = Новый Соответствие;
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаСправочникТабличнаяЧасть(),
		ИмяБазовогоТипаСправочник());
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаДокументТабличнаяЧасть(),
		ИмяБазовогоТипаДокумент());
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаПланВидовХарактеристикТабличнаяЧасть(),
		ИмяБазовогоТипаПланВидовХарактеристик());
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаПланСчетовТабличнаяЧасть(),
		ИмяБазовогоТипаПланСчетов());	
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаПланВидовРасчетаТабличнаяЧасть(),
		ИмяБазовогоТипаПланВидовРасчета());	
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаБизнесПроцессТабличнаяЧасть(),
		ИмяБазовогоТипаБизнесПроцесс());
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаЗадачаТабличнаяЧасть(),
		ИмяБазовогоТипаЗадача());
	ИменаТиповВладельцевБазовыхТиповТабличныхЧастей.Вставить(
		ИмяБазовогоТипаПланОбменаТабличнаяЧасть(),
		ИмяБазовогоТипаПланОбмена());
	Возврат ИменаТиповВладельцевБазовыхТиповТабличныхЧастей; 
КонецФункции

#КонецОбласти  
	
Функция ИменаСвойствТипаОбъекта(ТипОбъекта)
	
	ИменаСвойствТипаОбъекта = Новый Массив;
	
	Для Каждого Свойство Из ТипОбъекта.Свойства Цикл
		ИменаСвойствТипаОбъекта.Добавить(Свойство.Имя);
	КонецЦикла;
	
	Возврат ИменаСвойствТипаОбъекта;
КонецФункции

Функция ИменаТиповОбъектовПакета(Пакет) 
	
	ИменаТиповОбъектовПакета = Новый Массив;
	ТипТипОбъектаXDTO = Тип("ТипОбъектаXDTO");
	
	Для Каждого Тип Из Пакет Цикл
		Если ТипЗнч(Тип) <> ТипТипОбъектаXDTO Тогда
			Продолжить;
		КонецЕсли;
		ИменаТиповОбъектовПакета.Добавить(Тип.Имя);
	КонецЦикла;
	
	Возврат ИменаТиповОбъектовПакета;
КонецФункции

Функция СхемаXML(ДвоичныеДанныеСхемы)
	
	ПотокДляЧтения = ДвоичныеДанныеСхемы.ОткрытьПотокДляЧтения();
	
	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьПоток(ПотокДляЧтения);
	
	Построитель = Новый ПостроительDOM;
	Документ = Построитель.Прочитать(Чтение);
	
	ПотокДляЧтения.Закрыть();
	
	ПостроительСхем = Новый ПостроительСхемXML;	
	
	//@skip-warning
	Возврат ПостроительСхем.СоздатьСхемуXML(Документ);

КонецФункции

Функция ФабрикаПоСхеме(Схема)
	
	НаборСхем = Новый НаборСхемXML;
	НаборСхем.Добавить(Схема);
	
	Возврат Новый ФабрикаXDTO(НаборСхем);

КонецФункции

Функция ПакетФабрики(Фабрика, URIПространстваИмен)
	 Возврат Фабрика.Пакеты.Получить(URIПространстваИмен);
КонецФункции

Функция URIПространствИменСхемаКонфигурации()
	Возврат "http://v8.1c.ru/8.1/data/enterprise/current-config";   
КонецФункции

Функция ЭтоТипXDTOТабличнойЧасти(ИмяТипаXDTO, ИменаБазовыхТиповСравниваемыхТиповXDTO, ИменаТиповВладельцевБазовыхТиповТабличныхЧастей)
	
	ЭтоТипXDTOТабличнойЧасти = Ложь;
	
	ИнформацияОТипеОбъекта = ИнформацияОТипеОбъекта(ИмяТипаXDTO);
	
	Если ИнформацияОТипеОбъекта <> Неопределено Тогда
		
		ИмяБазовогоТипа = ИменаБазовыхТиповСравниваемыхТиповXDTO.Получить(ИнформацияОТипеОбъекта.ИмяТипаXDTO);
		
		Если ИмяБазовогоТипа <> Неопределено Тогда
			ЭтоТипXDTOТабличнойЧасти = ЭтоБазовыйТипТабличнойЧасти(ИмяБазовогоТипа, ИменаТиповВладельцевБазовыхТиповТабличныхЧастей);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЭтоТипXDTOТабличнойЧасти;
	
КонецФункции

Функция ИменаБазовыхТиповСравниваемыхТиповXDTO()
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO = Новый Соответствие();
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("AccountingRegisterRecord", ИмяБазовогоТипаРегистрБухгалтерии());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("AccumulationRegisterRecord", ИмяБазовогоТипаРегистрНакопления());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("BusinessProcessObject", ИмяБазовогоТипаБизнесПроцесс());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("BusinessProcessTabularSectionRow", ИмяБазовогоТипаБизнесПроцессТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("CalculationRegisterRecord", ИмяБазовогоТипаРегистрРасчета());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("CatalogObject", ИмяБазовогоТипаСправочник());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("CatalogTabularSectionRow", ИмяБазовогоТипаСправочникТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ChartOfAccountsObject", ИмяБазовогоТипаПланСчетов());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ChartOfAccountsTabularSectionRow", ИмяБазовогоТипаПланСчетовТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ChartOfCalculationTypesObject", ИмяБазовогоТипаПланВидовРасчета());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ChartOfCalculationTypesTabularSectionRow", ИмяБазовогоТипаПланВидовРасчетаТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ChartOfCharacteristicTypesObject", ИмяБазовогоТипаПланВидовХарактеристик());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ChartOfCharacteristicTypesTabularSectionRow", ИмяБазовогоТипаПланВидовХарактеристикТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ConstantValueManager", ИмяБазовогоТипаКонстанта());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("DocumentObject", ИмяБазовогоТипаДокумент());	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("DocumentTabularSectionRow", ИмяБазовогоТипаДокументТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("InformationRegisterRecord", ИмяБазовогоТипаРегистрСведений());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("SequenceRecord", ИмяБазовогоТипаПоследовательность());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("TaskObject", ИмяБазовогоТипаЗадача());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("TaskTabularSectionRow", ИмяБазовогоТипаЗадачаТабличнаяЧасть());
	
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ExchangePlanObject", ИмяБазовогоТипаПланОбмена());
	ИменаБазовыхТиповСравниваемыхТиповXDTO.Вставить("ExchangePlanTabularSectionRow", ИмяБазовогоТипаПланОбменаТабличнаяЧасть());
	
	Возврат ИменаБазовыхТиповСравниваемыхТиповXDTO;
	
КонецФункции

Функция ИнформацияОТипеОбъекта(ИмяТипаОбъекта)
	
	ЧастиТипаОбъекта = СтрРазделить(ИмяТипаОбъекта, ".");
	
	Если ЧастиТипаОбъекта.Количество() < 2 Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	ЧастиПрикладногоТипа = Новый Массив;
	Для Индекс = 1 По ЧастиТипаОбъекта.ВГраница() Цикл
		ЧастиПрикладногоТипа.Добавить(ЧастиТипаОбъекта[Индекс]);
	КонецЦикла;
		
	Возврат Новый Структура("ИмяТипаXDTO, ИмяПрикладногоТипа",
		ЧастиТипаОбъекта[0],
		СтрСоединить(ЧастиПрикладногоТипа, "."));
		
КонецФункции

#КонецОбласти  