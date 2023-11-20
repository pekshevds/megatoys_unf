////////////////////////////////////////////////////////////////////////////////
//
// Серверные процедуры и функции регламентированных отчетов ФСРАР общего назначения 
// с кешируемым результатом на время вызова.
//  
////////////////////////////////////////////////////////////////////////////////

// Формирует структуру адресных сведений отчета из XML или JSON представления или
// стандартного представления адресной информации. 
//
// Параметры:
// 		Адрес						- Строка. XML представление или стандартное представление адресной информации.
//		ПроверитьАдрес				- Булево. По умолчанию Истина. Признак необходимости проверки корректности
//									адреса в соответствии с адресным классификатором.
// Возвращаемое значение:
// 		Структура, со свойствами:
//			* КодСтраны
//			* Страна
//			* Индекс
//			* КодРегиона
//			* Регион
//			* Район
//			* Город
//			* НаселенныйПункт
//			* Улица
//			* Дом
//			* Корпус
//			* Литера
//			* Квартира
//			* ПредставлениеАдреса
//			* АдресXML				- XML представление адреса подсистемы УправлениеКонтактнойИнформацией
//			* АдресJSON				- JSON представление адреса подсистемы УправлениеКонтактнойИнформацией
//
// Дополнительно присутствуют свойства, определяемые в РаботаСАдресамиКлиентСервер.ПоляАдреса().
//
Функция СтруктураАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(знач Адрес, 
					ПроверитьАдрес = Истина) Экспорт

	АдресВФорматеОтчета = РегламентированнаяОтчетностьАЛКО.ПолучитьПустуюСтруктуруАдреса();
	
	Если НЕ ТипЗнч(Адрес) = Тип("Строка") Тогда	
		ВызватьИсключение "В РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON()
						|передана в параметре Адрес не строка.";	
	КонецЕсли; 

	Если НЕ ТипЗнч(ПроверитьАдрес) = Тип("Булево") Тогда
		ПроверитьАдрес = Истина;
	КонецЕсли; 
	
	АдресXML = "";
	АдресJSON = "";
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Адрес) Тогда
		АдресXML = Адрес;
		АдресJSON = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(АдресXML, 
								Перечисления.ТипыКонтактнойИнформации.Адрес);				
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(Адрес) Тогда
		АдресJSON = Адрес;
		АдресXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(АдресJSON, , 
								Перечисления.ТипыКонтактнойИнформации.Адрес);		
	Иначе
	// Если адрес пуст - возвращаем пустую структуру.
		Если ПустаяСтрока(СтрЗаменить(Адрес, ",", "")) Тогда
			Возврат АдресВФорматеОтчета;
		КонецЕсли;

		Если СтрНайти(Адрес, "Страна=") > 0 Тогда
		// Старый формат хранения полей адреса.
			АдресXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Адрес, , Перечисления.ТипыКонтактнойИнформации.Адрес);
			АдресJSON = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(Адрес, Перечисления.ТипыКонтактнойИнформации.Адрес);			
		Иначе
			Адрес = СтрЗаменить(Адрес, ".", "");
			АдресXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Адрес, Перечисления.ТипыКонтактнойИнформации.Адрес);
			АдресJSON = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Адрес, Перечисления.ТипыКонтактнойИнформации.Адрес);			
		КонецЕсли;

	КонецЕсли;
	
	ВерсияБСПЧислом = Неопределено;
	ИмяОбщегоМодуляРаботаСАдресами = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяОбщегоМодуляРаботаСАдресами(ВерсияБСПЧислом);

	Попытка
		ОбщийМодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль(ИмяОбщегоМодуляРаботаСАдресами);
	Исключение

		ТекстСообщения = НСтр("ru='Не найден общий модуль "
			+ ИмяОбщегоМодуляРаботаСАдресами + "!'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);

		Возврат Неопределено;

	КонецПопытки;

	АдресJSONилиXML = ?(ПустаяСтрока(АдресJSON), АдресXML, АдресJSON); 
			
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КодыКЛАДР", ПроверитьАдрес);
	ДополнительныеПараметры.Вставить("КодыАдреса", ПроверитьАдрес);
	ДополнительныеПараметры.Вставить("ПроверитьАдрес", ПроверитьАдрес);
	ДополнительныеПараметры.Вставить("НаименованиеВключаетСокращение", Истина);
	
	СокращенияОбъектовАдресацииАдресаРФ = РегламентированнаяОтчетностьАЛКО.СокращенияОбъектовАдресацииАдресаРФ();
	
	СтруктураАдресаСМассивами = ОбщийМодульРаботаСАдресами.СведенияОбАдресе(АдресJSONилиXML, ДополнительныеПараметры);
	
	ПроверенАдрес =  СтруктураАдресаСМассивами.Свойство("РезультатПроверкиАдреса") 
			И (НЕ СтруктураАдресаСМассивами.РезультатПроверкиАдреса = "Отказ");
	
	СтруктураАдресаСМассивами.Вставить("ПроверенАдрес", ПроверенАдрес);
	Если ПроверенАдрес Тогда
		СтруктураАдресаСМассивами.Вставить("ДатаПроверки", ТекущаяУниверсальнаяДатаВМиллисекундах());	
	КонецЕсли; 
	
	СтруктураАдресаСМассивами.Вставить("АдресXML", АдресXML);
	СтруктураАдресаСМассивами.Вставить("АдресJSON", АдресJSON);
	СтруктураАдресаСМассивами.Вставить("ПредставлениеАдреса", СтруктураАдресаСМассивами.Представление);
	СтруктураАдресаСМассивами.Вставить("Адрес", СтруктураАдресаСМассивами.Представление);
	
	СтруктураАдресаСМассивами.Вставить("ЕстьXML", ЗначениеЗаполнено(АдресXML));
	СтруктураАдресаСМассивами.Вставить("ЕстьJSON",  ЗначениеЗаполнено(АдресJSON));
		
	СтрокаДома = "";
	Если СтруктураАдресаСМассивами.Свойство("Здание") Тогда

		Если СтруктураАдресаСМассивами.Здание.Количество() > 0 Тогда
			
			ТипЗданияСокр = "";
			
			Если ЗначениеЗаполнено(СтруктураАдресаСМассивами.Здание.ТипЗдания) Тогда
				
				ТипЗданияСокр = 
					СокращенияОбъектовАдресацииАдресаРФ.Получить(НРег(Строка(СтруктураАдресаСМассивами.Здание.ТипЗдания)));
					
				ТипЗданияСокр = ?(ТипЗданияСокр = Неопределено, 
									НРег(Строка(СтруктураАдресаСМассивами.Здание.ТипЗдания)),
									ТипЗданияСокр); 
			
			КонецЕсли; 
			
			НомерДома = Строка(СтруктураАдресаСМассивами.Здание.Номер);
						 
			СтрокаДома = СтрокаДома
						+ ?(ЗначениеЗаполнено(ТипЗданияСокр), ТипЗданияСокр + " ", "") 
						+ НомерДома;
		КонецЕсли;

	КонецЕсли;

	СтруктураАдресаСМассивами.Вставить("Дом", СтрокаДома);

	СтрокаКорпуса = "";
	СтрокаЛитера = "";
	Если СтруктураАдресаСМассивами.Свойство("Корпуса") Тогда

		МассивКорпусов = СтруктураАдресаСМассивами.Корпуса;
		КолвоЭлементовКорпусов = 0;

		Для Каждого ЭлМассива Из МассивКорпусов Цикл

			Если СтрНайти(НРег(СокрЛП(ЭлМассива.ТипКорпуса)), НРег("Литер")) > 0 Тогда				
				СтрокаЛитера = "" + Строка(ЭлМассива.Номер)
			Иначе
				
				КолвоЭлементовКорпусов = КолвоЭлементовКорпусов + 1;
				
				ТипКорпусаСокр = "";
			
				Если ЗначениеЗаполнено(ЭлМассива.ТипКорпуса) Тогда
					
					ТипКорпусаСокр = 
						СокращенияОбъектовАдресацииАдресаРФ.Получить(НРег(Строка(ЭлМассива.ТипКорпуса)));
						
					ТипКорпусаСокр = ?(ТипКорпусаСокр = Неопределено, 
										НРег(Строка(ЭлМассива.ТипКорпуса)),
										ТипКорпусаСокр); 
				
				КонецЕсли;

				ТекКорпус = ?(ЗначениеЗаполнено(ТипКорпусаСокр), ТипКорпусаСокр	+ " ", "") 
							+ Строка(ЭлМассива.Номер);
				СтрокаКорпуса = СтрокаКорпуса + ?(СтрокаКорпуса = "", "", ", ")	+ ТекКорпус;
				
			КонецЕсли;

		КонецЦикла;

		Если ЗначениеЗаполнено(СтрокаЛитера) Тогда
			СтрокаЛитера = "лит. " + СтрокаЛитера;
		КонецЕсли;

	КонецЕсли;

	СтруктураАдресаСМассивами.Вставить("Корпус", СтрокаКорпуса);
	СтруктураАдресаСМассивами.Вставить("Литера", СтрокаЛитера);

	СтрокаКвартира = "";
	КолвоЭлементовПомещений = 0;

	Если СтруктураАдресаСМассивами.Свойство("Помещения") Тогда

		МассивПомещений = СтруктураАдресаСМассивами.Помещения;

		Для Каждого ЭлМассива Из МассивПомещений Цикл

			КолвоЭлементовПомещений = КолвоЭлементовПомещений + 1;
			
			ТипПомещенияСокр = "";
			
			Если ЗначениеЗаполнено(ЭлМассива.ТипПомещения) Тогда
				
				ТипПомещенияСокр = 
					СокращенияОбъектовАдресацииАдресаРФ.Получить(НРег(Строка(ЭлМассива.ТипПомещения)));
					
				ТипПомещенияСокр = ?(ТипПомещенияСокр = Неопределено, 
									НРег(Строка(ЭлМассива.ТипПомещения)),
									ТипПомещенияСокр); 
			
			КонецЕсли;
			
			ТекПомещение = ?(ЗначениеЗаполнено(ТипПомещенияСокр), ТипПомещенияСокр	+ " ", "") 
							+ Строка(ЭлМассива.Номер);
			СтрокаКвартира = СтрокаКвартира + ?(СтрокаКвартира = "", "", ", ") + ТекПомещение;

		КонецЦикла;

	КонецЕсли;
	
	СтруктураАдресаСМассивами.Вставить("Квартира", СтрокаКвартира);
		
	РегламентированнаяОтчетностьАЛКОКлиентСервер.ОбъединитьСтруктурыИлиСоответствия(АдресВФорматеОтчета, СтруктураАдресаСМассивами);
		
	АдресВФорматеОтчета = РегламентированнаяОтчетностьАЛКО.СтруктураАдресаВыгрузкиИзСтруктурыАдреса(АдресВФорматеОтчета);

	Возврат АдресВФорматеОтчета;

КонецФункции

Функция ОбработкаСохраненияАдресаКонтрагента(Контрагент = Неопределено, 
												ПолеСтруктурыАдреса,  
												ДатаАдреса = Неопределено,
												ПроверятьАдрес = Истина) Экспорт
												
	Представление = Неопределено;
	СтруктураАдреса = Неопределено;
	
	Если ЗначениеЗаполнено(Контрагент) И (НЕ ЗначениеЗаполнено(ПолеСтруктурыАдреса)) Тогда
		// Пустое поле - значит надо определить по контрагенту.
		СписокВидовКонтактнойИнформации = Новый СписокЗначений;
		СписокВидовКонтактнойИнформации.Добавить("ЮрАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ФактАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ПочтовыйАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ЮрАдресОрганизации");
		СписокВидовКонтактнойИнформации.Добавить("АдресПоПропискеФизическиеЛица");
		СписокВидовКонтактнойИнформации.Добавить("АдресМестаПроживанияФизическиеЛица");
		
		ПолеСтруктурыАдреса = РегламентированнаяОтчетностьАЛКО.АдресОбъектаВСтрокуСтруктурыХранения(
										Контрагент, 
										Представление, 
										СписокВидовКонтактнойИнформации, 
										Истина, 
										ДатаАдреса, ,
										ПроверятьАдрес);									
	КонецЕсли;
	
	РегламентированнаяОтчетностьАЛКО.ОбработкаСохраненияАдреса(
								ПолеСтруктурыАдреса, 
								Представление, 
								СтруктураАдреса, 
								ПроверятьАдрес);
								
	Результат = Новый Структура;
	Результат.Вставить("ПолеСтруктурыАдреса", 	ПолеСтруктурыАдреса);
	Результат.Вставить("Представление", 		Представление);
	Результат.Вставить("СтруктураАдреса", 		СтруктураАдреса);
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураАдресаИзСтрокиСтруктурыХранения(ПолеСтруктурыАдреса) Экспорт

	Если НЕ ТипЗнч(ПолеСтруктурыАдреса) = Тип("Строка") Тогда
		ПолеСтруктурыАдреса = "";	
	КонецЕсли;
	
	ПолеСтруктурыАдреса = СокрЛП(ПолеСтруктурыАдреса);
	
	Если ЗначениеЗаполнено(ПолеСтруктурыАдреса) Тогда
	
		ВариантСтрокиАдреса = РегламентированнаяОтчетностьАЛКО.ВариантКонтактнойИнформацииАЛКО(ПолеСтруктурыАдреса);
		
		Если ВариантСтрокиАдреса.ЭтоСтруктураАдреса Тогда
		
			Префикс = РегламентированнаяОтчетностьАЛКО.ПрефиксСтрокиСтруктурыХраненияАдреса();
			ДлинаПрефикса = СтрДлина(Префикс);
			
			СтрокаВнутрСтруктурыАдреса = Сред(ПолеСтруктурыАдреса, ДлинаПрефикса + 1);
			
			СтруктураАдреса = ЗначениеИзСтрокиВнутр(СтрокаВнутрСтруктурыАдреса);
			
		ИначеЕсли ВариантСтрокиАдреса.ЭтоXML ИЛИ ВариантСтрокиАдреса.ЭтоJSON Тогда
			
			СтруктураАдреса = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(
										ПолеСтруктурыАдреса, Истина);
		Иначе
			ПолеСтруктурыАдреса = "";
			СтруктураАдреса = РегламентированнаяОтчетностьАЛКО.ПолучитьПустуюСтруктуруАдреса();
		КонецЕсли; 
		
	Иначе
		СтруктураАдреса = РегламентированнаяОтчетностьАЛКО.ПолучитьПустуюСтруктуруАдреса();
	КонецЕсли; 

	Возврат СтруктураАдреса;
	
КонецФункции


