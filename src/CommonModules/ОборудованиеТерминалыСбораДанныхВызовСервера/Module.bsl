
#Область СлужебныйПрограммныйИнтерфейс

// Подготовить данные операции.
// 
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения
//  Команда - Строка - Команда
//  ПараметрыОперации - Структура - Параметры операции
// 
// Возвращаемое значение:
//  Структура - Подготовить данные операции:
// * Результат - Булево -
// * ПакетыXML - Массив из ЧтениеXML.
// * ПолнаяВыгрузка - Булево.
// * ТекстОшибки - Строка.
Функция ПодготовитьДанныеОперации(ПараметрыПодключения, Команда, ПараметрыОперации) Экспорт
	
	Если Команда = "UploadDirectory" Тогда
		Если ПараметрыОперации.ТаблицаТоваров.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru='Нет данных для выгрузки.'");
			ДанныеОперации = Новый Структура();
			ДанныеОперации.Вставить("Результат"  , Ложь);
			ДанныеОперации.Вставить("ТекстОшибки", ТекстОшибки);
			Возврат ДанныеОперации;
		КонецЕсли;
		ПолнаяВыгрузка = НЕ ПараметрыОперации.ЧастичнаяВыгрузка; 
		ПакетыДляВыгрузки = ПодготовитьПакетыДляЗагрузкиТСД(ПараметрыОперации.ТаблицаТоваров, 
			РазмерПакетаПоУмолчанию(), ПолнаяВыгрузка);
		ДанныеОперации = ПараметрыОперацииТСД();
		ДанныеОперации.ПакетыXML = ПакетыДляВыгрузки;
		ДанныеОперации.ПолнаяВыгрузка = ПолнаяВыгрузка;
		Возврат ДанныеОперации;
	КонецЕсли;
	
КонецФункции

// Обработать данные операции.
// 
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения.
//  Команда - Строка - Команда.
//  РезультатВыполнения - Булево - Результат выполнения.
//  ДанныеОперации - Структура - Данные операции.
Процедура ОбработатьДанныеОперации(ПараметрыПодключения, Команда, РезультатВыполнения, ДанныеОперации) Экспорт
	
	Если Команда = "DownloadDocument" Тогда
		
		АлкогольнаяПродукция = Ложь;
		Если НЕ ПустаяСтрока(ДанныеОперации.ДанныеЗагрузки) Тогда
			МассивДанных = ТоварыТСД(ДанныеОперации.ДанныеЗагрузки, АлкогольнаяПродукция);
		КонецЕсли;
		
		Если ПустаяСтрока(ДанныеОперации.ДанныеЗагрузки) Или (МассивДанных.Количество() = 0) Тогда
			РезультатВыполнения.Результат = Ложь;
			РезультатВыполнения.ОписаниеОшибки = НСтр("ru='Нет данных для выгрузки.'");
		Иначе
			РезультатВыполнения.Вставить("ТаблицаТоваров", МассивДанных);
			РезультатВыполнения.Вставить("АлкогольнаяПродукция", АлкогольнаяПродукция);
		КонецЕсли;
		
	КонецЕсли;   
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции          

// Заполнить структуру операции ТСД
//
// Возвращаемое значение:
//  Структура.
Функция ПараметрыОперацииТСД()
	
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("Результат", Истина);
	ПараметрыОперации.Вставить("ПакетыXML");
	ПараметрыОперации.Вставить("ПолнаяВыгрузка");
	ПараметрыОперации.Вставить("ТекстОшибки");
	Возврат ПараметрыОперации;
	
КонецФункции 

// Размер пакета в элементах передаваемой информации в драйвер.
//
// Возвращаемое значение:
//  Число
Функция РазмерПакетаПоУмолчанию()
	
	РазмерПакета = 200;
	Возврат РазмерПакета;
	
КонецФункции

// Получить таблицу товаров из XML структуры для ТСД.
// 
// Параметры:
//  ДанныеЗагрузки - Строка - Данные загрузки
//  АлкогольнаяПродукция - Булево - Алкогольная продукция
// 
// Возвращаемое значение:
//  Массив - Товары ТСД
//
Функция ТоварыТСД(ДанныеЗагрузки, АлкогольнаяПродукция)
	
	Результат = Новый Массив();
	
	АлкогольнаяПродукция = Ложь;
	
	Если НЕ ПустаяСтрока(ДанныеЗагрузки) Тогда
		
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(ДанныеЗагрузки);
		ЧтениеXML.ПерейтиКСодержимому();
		
		Если ЧтениеXML.Имя = "Table" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
			Пока ЧтениеXML.Прочитать() Цикл  
				Если ЧтениеXML.Имя = "Record" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					ПозицияДанных = Новый Структура();
					
					Штрихкод = ЧтениеXML.ЗначениеАтрибута("BarCode");
					ШтрихкодBase64 = ЧтениеXML.ЗначениеАтрибута("BarCodeBase64");    
					Если ПустаяСтрока(ШтрихкодBase64) Тогда
						ШтрихкодBase64 = ЧтениеXML.ЗначениеАтрибута("BarcodeBase64");    
					КонецЕсли;
					ШтрихкодУпаковки = ЧтениеXML.ЗначениеАтрибута("ContainerBarCode");
					ШтрихкодУпаковкиBase64 = ЧтениеXML.ЗначениеАтрибута("ContainerBarСodeBase64");
					Если ПустаяСтрока(ШтрихкодУпаковкиBase64) Тогда
						ШтрихкодУпаковкиBase64 = ЧтениеXML.ЗначениеАтрибута("ContainerBarсodeBase64");    
					КонецЕсли;
					
					Если Не ПустаяСтрока(ШтрихкодBase64) Тогда
						Штрихкод = МенеджерОборудованияКлиентСервер.Base64ВШтрихкод(ШтрихкодBase64);   
						Штрихкод = СтрЗаменить(Штрихкод, МенеджерОборудованияМаркировкаКлиентСервер.РазделительGS1(), "")
					Иначе
						ШтрихкодBase64 = МенеджерОборудованияКлиентСервер.ШтрихкодВBase64(Штрихкод);
					КонецЕсли;           
					
					Если Не ПустаяСтрока(ШтрихкодУпаковкиBase64) Тогда
						ШтрихкодУпаковки = МенеджерОборудованияКлиентСервер.Base64ВШтрихкод(ШтрихкодУпаковкиBase64);      
						ШтрихкодУпаковки = СтрЗаменить(ШтрихкодУпаковки, МенеджерОборудованияМаркировкаКлиентСервер.РазделительGS1(), "")
					Иначе            
						Если Не ПустаяСтрока(ШтрихкодУпаковки) Тогда
							ШтрихкодУпаковкиBase64 = МенеджерОборудованияКлиентСервер.Base64ВШтрихкод(ШтрихкодУпаковки);      
						КонецЕсли;
					КонецЕсли;
					
					ПозицияДанных.Вставить("Количество", ЧтениеXML.ЗначениеАтрибута("Quantity"));
					ПозицияДанных.Вставить("Штрихкод"  , Штрихкод);
					ПозицияДанных.Вставить("ШтрихкодBase64", ШтрихкодBase64);
					ПозицияДанных.Вставить("ШтрихкодУпаковки", ШтрихкодУпаковки);
					ПозицияДанных.Вставить("ШтрихкодУпаковкиBase64", ШтрихкодУпаковкиBase64);
					
					// Атрибуты для поддержки интеграции с ЕГАИС.
					ШтрихкодМаркиАлкогольнойПродукции = ЧтениеXML.ЗначениеАтрибута("AlcoholExciseStamp");
					Если Не ПустаяСтрока(ШтрихкодМаркиАлкогольнойПродукции) Тогда
						АлкогольнаяПродукция = Истина;
					КонецЕсли;
						
					ПозицияДанных.Вставить("ШтрихкодМаркиАлкогольнойПродукции", ШтрихкодМаркиАлкогольнойПродукции);
					ПозицияДанных.Вставить("НаименованиеАлкогольнойПродукции" , ЧтениеXML.ЗначениеАтрибута("AlcoholName"));
					ПозицияДанных.Вставить("СерийныйНомерАлкогольнойПродукции", ЧтениеXML.ЗначениеАтрибута("AlcoholSerialNumber"));
					ПозицияДанных.Вставить("КодВидаАлкогольнойПродукции", ЧтениеXML.ЗначениеАтрибута("AlcoholKindCode"));
					ПозицияДанных.Вставить("КодАлкогольнойПродукции"    , ЧтениеXML.ЗначениеАтрибута("AlcoholCode"));
					ПозицияДанных.Вставить("ЕмкостьТары"                , ЧтениеXML.ЗначениеАтрибута("AlcoholContainerSize"));
					ПозицияДанных.Вставить("Крепость"                   , ЧтениеXML.ЗначениеАтрибута("AlcoholStrength"));
					ПозицияДанных.Вставить("ИННПроизводителя"           , ЧтениеXML.ЗначениеАтрибута("VendorINNCode"));
					ПозицияДанных.Вставить("КПППроизводителя"           , ЧтениеXML.ЗначениеАтрибута("VendorKPPCode"));
					Результат.Добавить(ПозицияДанных);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Сформировать таблицу товаров в XML структуре для ТСД.
//
// Параметры:
//   ДанныеЗагрузки - Массив из Структура
//   ПолнаяВыгрузка - Булево 
//   РевизияИнтерфейса - Число
//
// Возвращаемое значение:
//  ЗаписьXML.
Функция СформироватьТаблицуТоваровТСД(ДанныеЗагрузки, ПолнаяВыгрузка, РевизияИнтерфейса = 0) 
	
	ЗаписьXML = Новый ЗаписьXML; 
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Table");
	ЗаписьXML.ЗаписатьАтрибут("FullLoad", XMLСтрока(ПолнаяВыгрузка));
	
	Для Каждого Позиция Из ДанныеЗагрузки  Цикл
		
		НаименованиеНоменклатуры = "";
		Если Позиция.Свойство("Номенклатура") Тогда
			НаименованиеНоменклатуры = Строка(Позиция.Номенклатура);
		КонецЕсли;
		Если ПустаяСтрока(НаименованиеНоменклатуры) И Позиция.Свойство("Наименование") Тогда
			НаименованиеНоменклатуры = Позиция.Наименование;
		КонецЕсли;
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("Record");
		Если РевизияИнтерфейса >= 3003 Тогда
			
			Если Позиция.Свойство("ШтрихкодBase64") И Не ПустаяСтрока(Позиция.ШтрихкодBase64) Тогда
				ШтрихкодBase64 = Позиция.ШтрихкодBase64
			Иначе
				ШтрихкодBase64 = МенеджерОборудованияКлиентСервер.ШтрихкодВBase64(Позиция.Штрихкод)
			КонецЕсли;
			ЗаписьXML.ЗаписатьАтрибут("BarCodeBase64" , XMLСтрока(ШтрихкодBase64));
			
			Если Позиция.Свойство("ШтрихкодУпаковкиBase64") И Не ПустаяСтрока(Позиция.ШтрихкодУпаковкиBase64) Тогда
				ШтрихкодУпаковкиBase64 = Позиция.ШтрихкодУпаковкиBase64
			ИначеЕсли Позиция.Свойство("ШтрихкодУпаковки") И Не ПустаяСтрока(Позиция.ШтрихкодУпаковки) Тогда
				ШтрихкодУпаковкиBase64 = МенеджерОборудованияКлиентСервер.ШтрихкодВBase64(Позиция.ШтрихкодУпаковки);
			КонецЕсли;
			Если Не ПустаяСтрока(ШтрихкодУпаковкиBase64) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("ContainerBarcodeBase64", XMLСтрока(ШтрихкодУпаковкиBase64));
			КонецЕсли; 
			
		Иначе
			ЗаписьXML.ЗаписатьАтрибут("BarCode"         , XMLСтрока(?(Позиция.Свойство("Штрихкод"), Позиция.Штрихкод, "")));
			Если Позиция.Свойство("ШтрихкодУпаковки") И Не ПустаяСтрока(Позиция.ШтрихкодУпаковки) Тогда
				ЗаписьXML.ЗаписатьАтрибут("ContainerBarcode", XMLСтрока(Позиция.Свойство("ШтрихкодУпаковки")));
			КонецЕсли;
		КонецЕсли;
		ЗаписьXML.ЗаписатьАтрибут("Name" , XMLСтрока(НаименованиеНоменклатуры));
		ЗаписьXML.ЗаписатьАтрибут("UnitOfMeasurement"            , XMLСтрока(?(Позиция.Свойство("ЕдиницаИзмерения"), Позиция.ЕдиницаИзмерения, "")));
		ЗаписьXML.ЗаписатьАтрибут("CharacteristicOfNomenclature" , XMLСтрока(?(Позиция.Свойство("ХарактеристикаНоменклатуры"), Позиция.ХарактеристикаНоменклатуры, "")));
		ЗаписьXML.ЗаписатьАтрибут("SeriesOfNomenclature"         , XMLСтрока(?(Позиция.Свойство("СерияНоменклатуры"), Позиция.СерияНоменклатуры, "")));
		ЗаписьXML.ЗаписатьАтрибут("Quality"                      , XMLСтрока(?(Позиция.Свойство("Качество")  , Позиция.Качество, "")));
		ЗаписьXML.ЗаписатьАтрибут("Price"                        , XMLСтрока(?(Позиция.Свойство("Цена")      , Позиция.Цена, 0)));
		ЗаписьXML.ЗаписатьАтрибут("Quantity"                     , XMLСтрока(?(Позиция.Свойство("Количество"), Позиция.Количество, 0)));
		ЗаписьXML.ЗаписатьАтрибут("Article"                      , XMLСтрока(?(Позиция.Свойство("Артикул")   , Позиция.Артикул, "")));
		Алкоголь = ?(Позиция.Свойство("Алкоголь"), Позиция.Алкоголь, Ложь);
		ЗаписьXML.ЗаписатьАтрибут("Alcohol", XMLСтрока(Алкоголь));
		Если Алкоголь = Истина Тогда
			ЗаписьXML.ЗаписатьАтрибут("AlcoholExcisable"     , XMLСтрока(?(Позиция.Свойство("Маркируемый")                , Позиция.Маркируемый, Ложь)));
			ЗаписьXML.ЗаписатьАтрибут("AlcoholKindCode"      , XMLСтрока(?(Позиция.Свойство("КодВидаАлкогольнойПродукции"), Позиция.КодВидаАлкогольнойПродукции, "")));
			ЗаписьXML.ЗаписатьАтрибут("AlcoholCode"          , XMLСтрока(?(Позиция.Свойство("КодАлкогольнойПродукции")    , Позиция.КодАлкогольнойПродукции, "")));
			ЗаписьXML.ЗаписатьАтрибут("AlcoholContainerSize" , XMLСтрока(?(Позиция.Свойство("ЕмкостьТары")                , Позиция.ЕмкостьТары, Неопределено)));
			ЗаписьXML.ЗаписатьАтрибут("AlcoholStrength"      , XMLСтрока(?(Позиция.Свойство("Крепость")                   , Позиция.Крепость, Неопределено)));
			ЗаписьXML.ЗаписатьАтрибут("VendorINNCode"        , XMLСтрока(?(Позиция.Свойство("ИННПроизводителя")           , Позиция.ИННПроизводителя, Неопределено)));
			ЗаписьXML.ЗаписатьАтрибут("VendorKPPCode"        , XMLСтрока(?(Позиция.Свойство("КПППроизводителя")           , Позиция.КПППроизводителя, Неопределено)));
			Если РевизияИнтерфейса >= 3003 Тогда
				Если Позиция.Свойство("ШтрихкодМаркиАлкогольнойПродукцииBase64") И Не ПустаяСтрока(Позиция.ШтрихкодМаркиАлкогольнойПродукцииBase64) Тогда
					ШтрихкодМаркиАлкогольнойПродукцииBase64 = Позиция.ШтрихкодМаркиАлкогольнойПродукцииBase64
				Иначе
					ШтрихкодМаркиАлкогольнойПродукцииBase64 = МенеджерОборудованияКлиентСервер.ШтрихкодВBase64(Позиция.ШтрихкодМаркиАлкогольнойПродукции)
				КонецЕсли;
				ЗаписьXML.ЗаписатьАтрибут("AlcoholExciseStampBase64", XMLСтрока(ШтрихкодМаркиАлкогольнойПродукцииBase64));
			Иначе
				ЗаписьXML.ЗаписатьАтрибут("AlcoholExciseStamp", XMLСтрока(?(Позиция.Свойство("ШтрихкодМаркиАлкогольнойПродукции") , Позиция.ШтрихкодМаркиАлкогольнойПродукции, Неопределено)));
			КонецЕсли;
		КонецЕсли;
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

// Сформировать XML пакеты товаров для загрузки ТСД.
//
// Возвращаемое значение:
//  Массив.
Функция ПодготовитьПакетыДляЗагрузкиТСД(ТаблицаВыгрузки, РазмерПакета, ПолнаяВыгрузка) 
	
	ПакетыДляВыгрузки = Новый Массив();
	МассивТоваров = Новый Массив;
	
	ЗаписьВПакете    = 0;
	ЗаписейВыгружено = 0;
	ЗаписейВсего     = ТаблицаВыгрузки.Количество();
	
	Для Каждого Позиция Из ТаблицаВыгрузки  Цикл
		
		Если ЗаписьВПакете = 0 Тогда
		    МассивТоваров.Очистить();
		КонецЕсли;
		МассивТоваров.Добавить(Позиция);
		
		ЗаписейВыгружено  = ЗаписейВыгружено + 1;
		ЗаписьВПакете = ЗаписьВПакете + 1;
		
		Если (ЗаписьВПакете = РазмерПакета) ИЛИ (ЗаписейВыгружено = ЗаписейВсего) Тогда  
			ДанныеДляВыгрузки = СформироватьТаблицуТоваровТСД(МассивТоваров, ПолнаяВыгрузка);
			ПакетыДляВыгрузки.Добавить(ДанныеДляВыгрузки);
			ЗаписьВПакете = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПакетыДляВыгрузки;
	
КонецФункции

#КонецОбласти

