
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает значения параметров сеанса, относящихся к подключаемому оборудованию.
//
// Параметры:
//  ИмяПараметра - Строка - имя устанавливаемого параметра.
//  УстановленныеПараметры - Структура - коллекция ранее установленных параметров
//
Процедура УстановитьПараметрыСеансаПодключаемогоОборудования(ИмяПараметра, УстановленныеПараметры) Экспорт

	Если ИмяПараметра = "РабочееМестоКлиента" Тогда
		
		// Если с идентификатором клиента текущего сеанса связано одно рабочее место,
		// то его сразу и запишем в параметры сеанса.
		ТекущееРМ			= Справочники.РабочиеМеста.ПустаяСсылка();
		СистемнаяИнформация	= Новый СистемнаяИнформация();
		
		ИдентификаторРабочегоМеста = МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста();
		
		СписокРМ = МенеджерОборудованияВызовСервера.НайтиРабочиеМестаПоИдентификатору(ВРег(ИдентификаторРабочегоМеста));
		
		Если СписокРМ.Количество() = 0 Тогда
			
			Параметры = Новый Структура();
			Параметры.Вставить("ИмяКомпьютера");
			Параметры.Вставить("ИдентификаторКлиента");
			
			#Если Не ВебКлиент Тогда
				Параметры.ИмяКомпьютера = ИмяКомпьютера();
			#КонецЕсли
			
			Параметры.ИдентификаторКлиента = МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста();
			ТекущееРМ = МенеджерОборудованияВызовСервера.СоздатьРабочееМестоКлиента(Параметры);
		Иначе
			ТекущееРМ = СписокРМ[0];
		КонецЕсли;
		
		МенеджерОборудованияВызовСервера.УстановитьРабочееМестоКлиента(ТекущееРМ);
		УстановитьТекущееРабочееМестоКассамККМ();
		
		Если ТипЗнч(УстановленныеПараметры) = Тип("Структура") Тогда
			УстановленныеПараметры.Вставить("РабочееМестоКлиента");
		Иначе
			УстановленныеПараметры.Добавить("РабочееМестоКлиента");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет рабочие места касс ККМ, отличные от текущего рабочего места 
//
Процедура УстановитьТекущееРабочееМестоКассамККМ() Экспорт
	ОбщегоНазначенияРМКПереопределяемый.УстановитьТекущееРабочееМестоКассамККМ();
КонецПроцедуры

// Переопределяет формируемый шаблон чека.
//
// Параметры:
//  ОбщиеПараметры - Структура - см.ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека().
//  ДополнительныйТекст - Строка - дополнительный текст шаблона чека.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//  ТипОборудования - Строка - типы оборудования строкой.
//
// Возвращаемое Значение:
//  Булево
Функция СформироватьШаблонЧека(ОбщиеПараметры, ДополнительныйТекст, СтандартнаяОбработка, ТипОборудования = "") Экспорт

	Если ОбщиеПараметры.Свойство("ШаблонЧека")
		И ОбщиеПараметры.Свойство("КассаККМ")
		И ЗначениеЗаполнено(ОбщиеПараметры.ШаблонЧека)
		И ЗначениеЗаполнено(ОбщиеПараметры.КассаККМ) Тогда
		
		ШаблонЧека = ПолучитьСтруктуруШаблонаЧека(ОбщиеПараметры, ДополнительныйТекст, ТипОборудования);
		Если ШаблонЧека <> Неопределено Тогда
			
			СтандартнаяОбработка = Ложь;
			Возврат ШаблонЧека;
			
		КонецЕсли;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает структуру шаблона чека.
//
// Параметры:
//  ПараметрыШаблонаЧека - Структура - исходные данные для формирования структуры чека.
//  ДополнительныйТекст - Строка.
//  ТипОборудования - Строка.
//
// Возвращаемое значение:
//  НовыеПараметрыЧека - Структура, Неопределено - структура шаблона чека.
//
Функция ПолучитьСтруктуруШаблонаЧека(ПараметрыШаблонаЧека, ДополнительныйТекст = "", ТипОборудования = "") Экспорт
	
	ХранилищеШаблона = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыШаблонаЧека.ШаблонЧека, "Шаблон");
	СтруктураХранилища = ХранилищеШаблона.Получить();
	
	Если СтруктураХранилища = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыеПараметрыЧека = Новый Структура;
	
	Для Каждого ВходящийПараметр Из ПараметрыШаблонаЧека Цикл
		
		Если ВходящийПараметр.Ключ = "ПозицииЧека" Тогда
			НовыеПараметрыЧека.Вставить("ПозицииЧека", Новый Массив);
		Иначе
			НовыеПараметрыЧека.Вставить(ВходящийПараметр.Ключ, ВходящийПараметр.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	НовыйТипШаблона = Ложь;
	СКД = Неопределено;
	
	Если НЕ ЗначениеЗаполнено(ТипОборудования) Тогда
		ТипОборудования = "ККТ";
	КонецЕсли;
	
	Если ТипОборудования = "ККТ"
		ИЛИ ТипОборудования = "ПринтерЧеков" Тогда
			ИнициализироватьПараметрыШаблона(ПараметрыШаблонаЧека, НовыйТипШаблона, СКД);
	КонецЕсли;
	
	Если НовыйТипШаблона Тогда
		
		Если СКД = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ТаблицаДанных = ПечатьФискальныхЧековРМК.ТаблицаСКД(СКД, ПараметрыШаблонаЧека.ДокументОснование);
		ШаблонДерево = СтруктураХранилища.Шаблон;
		КоличествоСтрокТабличнойЧасти = 0;
		
		Для Каждого СтрокаДерева Из ШаблонДерево.Строки Цикл
			
			Если СтрокаДерева.ИмяКолонки = "ФискальныйДокумент" Тогда
				
				Для Каждого СтрокаЧека Из СтрокаДерева.Строки Цикл
					
					Если СтрокаЧека.ИмяКолонки = "СоставЧека" Тогда
						
						Для Каждого СтрокаОсновногоРаздела Из СтрокаЧека.Строки Цикл
							ПечатьФискальныхЧековРМК.ОбработатьСоставЧека(НовыеПараметрыЧека, СтрокаОсновногоРаздела,
								ТаблицаДанных, ПараметрыШаблонаЧека.ПозицииЧека);
						КонецЦикла;
						
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли СтрокаДерева.ИмяКолонки = "НефискальныйДокумент" Тогда
				
				НовыйНефискальныйДокумент = Новый Структура;
				НовыйНефискальныйДокумент.Вставить("ПозицииЧека", Новый Массив);
				НовыйНефискальныйДокумент.Вставить("ДокументОснование", НовыеПараметрыЧека.ДокументОснование);
				
				Для Каждого СтрокаЧека Из СтрокаДерева.Строки Цикл
					
					Если СтрокаЧека.ИмяКолонки = "СоставЧека" 
						ИЛИ СтрокаЧека.ИмяКолонки = "Промокоды" Тогда
						
						Для Каждого СтрокаОсновногоРаздела Из СтрокаЧека.Строки Цикл
							ПечатьФискальныхЧековРМК.ОбработатьСоставЧека(НовыйНефискальныйДокумент,
								СтрокаОсновногоРаздела, ТаблицаДанных, ПараметрыШаблонаЧека.ПозицииЧека);
						КонецЦикла;
							
					КонецЕсли;
												
				КонецЦикла;
					
				Если НовыйНефискальныйДокумент.ПозицииЧека.Количество() > 0 Тогда
					НовыеПараметрыЧека.НефискальныеДокументы.Добавить(НовыйНефискальныйДокумент.ПозицииЧека);
				КонецЕсли;
								
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		СтруктураШаблонаЧека = Новый Структура;
		СтруктураШаблонаЧека.Вставить("Шапка", Новый Массив);
		СтруктураШаблонаЧека.Вставить("МассивТекстаСтрокиШапки", Новый Массив);
		СтруктураШаблонаЧека.Вставить("МассивТекстаСтрокиПодвал", Новый Массив);
		СтруктураШаблонаЧека.Вставить("Подвал", Новый Массив);
		СтруктураШаблонаЧека.Вставить("ОднаФискальнаяСтрока", Ложь);
		СтруктураШаблонаЧека.Вставить("ФискальнаяСтрокаБезПечати", Ложь);
		
		ТаблицаИсходная_Количество = ПараметрыШаблонаЧека.ПозицииЧека.Количество();
		
		Для Итератор = 0 По ТаблицаИсходная_Количество - 1 Цикл
			
			СтруктураШаблонаЧека.МассивТекстаСтрокиШапки.Добавить(Новый Массив);
			СтруктураШаблонаЧека.МассивТекстаСтрокиПодвал.Добавить(Новый Массив);
			
		КонецЦикла;
		
		СтруктураШаблонаЧека.ФискальнаяСтрокаБезПечати = Истина;

		МассивТекстаСтрокиШапки = Новый Массив;
		МассивТекстаСтрокиПодвал = Новый Массив;
		
		ПараметрыМакета = Новый Структура;
		ПараметрыМакета.Вставить("СхемаКомпоновкиДанных", Неопределено);
		ПараметрыМакета.Вставить("КомпоновщикМакета", Неопределено);
		ПараметрыМакета.Вставить("КэшМакетов", Неопределено);
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПараметрыШаблонаЧека.ДокументОснование);
		Шаблон = МенеджерОбъекта.МакетФискальногоЧека(ПараметрыШаблонаЧека.ДокументОснование,
			СтруктураХранилища.Шаблон, СтруктураХранилища.ШиринаЧека, ПараметрыМакета);
		СтруктураХранилища.Вставить("Шаблон", Шаблон);
		СтруктураХранилища.Вставить("СоставнойМассив", Новый Массив);
		
		СтруктураШаблонаЧека.Вставить("Шапка", ПечатьФискальныхЧековРМК.НапечататьСтроки(СтруктураХранилища, "Шапка"));
		
		Для Итератор = 0 По ТаблицаИсходная_Количество - 1 Цикл
			
			МассивСтрокиШапки = ПечатьФискальныхЧековРМК.НапечататьСтроки(СтруктураХранилища,
				СтрШаблон("ТелоШапка_%1", Итератор));
			МассивТекстаСтрокиШапки.Добавить(МассивСтрокиШапки);
			МассивСтрокиПодвал = ПечатьФискальныхЧековРМК.НапечататьСтроки(СтруктураХранилища,
				СтрШаблон("ТелоПодвал_%1", Итератор));
			МассивТекстаСтрокиПодвал.Добавить(МассивСтрокиПодвал);
			
		КонецЦикла;
		
		СтруктураШаблонаЧека.Вставить("Подвал", ПечатьФискальныхЧековРМК.НапечататьСтроки(СтруктураХранилища, "Подвал"));
		СтруктураШаблонаЧека.Вставить("МассивТекстаСтрокиШапки", МассивТекстаСтрокиШапки);
		СтруктураШаблонаЧека.Вставить("МассивТекстаСтрокиПодвал", МассивТекстаСтрокиПодвал);
		СтруктураШаблонаЧека.ОднаФискальнаяСтрока = СтруктураХранилища.ОднаФискальнаяСтрока;
	
		// Печатаем строки чека   
			
		МассивТекстаСтрокиШапки		= СтруктураШаблонаЧека.МассивТекстаСтрокиШапки;
		МассивТекстаСтрокиПодвал	= СтруктураШаблонаЧека.МассивТекстаСтрокиПодвал;
		МассивШапкаЧека				= СтруктураШаблонаЧека.Шапка;
		МассивПодвалЧека			= СтруктураШаблонаЧека.Подвал;
		ОднаФискальнаяСтрока		= СтруктураШаблонаЧека.ОднаФискальнаяСтрока;
		ФискальнаяСтрокаБезПечати	= СтруктураШаблонаЧека.ФискальнаяСтрокаБезПечати;
		
		ИтогПоЧеку = 0;
		ПроцентСкидки = 0;
		НомерСекции = 0;
		
		// Печать шапки чека.
		Для Каждого СтрокаШапки Из МассивШапкаЧека Цикл
			
			ДополнитьПараметрыЧека(НовыеПараметрыЧека, СтрокаШапки);
			НовыеПараметрыЧека.Вставить("ПечатьКлише", Ложь);
			
		КонецЦикла;
		
		// Товарный состав
		Для ИндексМассива = 0 По ТаблицаИсходная_Количество - 1 Цикл
			
			СтрокаИсходная = ПараметрыШаблонаЧека.ПозицииЧека[ИндексМассива];
			
			Если СтрокаИсходная.Свойство("ФискальнаяСтрока") Тогда
			
				// Печать шапки строки.
				Для Каждого СтрокаШапки Из МассивТекстаСтрокиШапки[ИндексМассива] Цикл
					ДополнитьПараметрыЧека(НовыеПараметрыЧека, СтрокаШапки);
				КонецЦикла;
				
				Если ОднаФискальнаяСтрока Тогда
					
					Сумма = ?(СтрокаИсходная.Свойство("Сумма"), СтрокаИсходная.Сумма, 0);
					ИтогПоЧеку = ИтогПоЧеку + Сумма;
					
				Иначе
					
					Если ФискальнаяСтрокаБезПечати Тогда
						Наименование = "";
					Иначе
						Наименование  = ?(СтрокаИсходная.Свойство("Наименование") , СтрокаИсходная.Наименование, "");
					КонецЕсли;
					
					Количество		= ?(СтрокаИсходная.Свойство("Количество"), СтрокаИсходная.Количество, 1);
					Цена			= ?(СтрокаИсходная.Свойство("Цена"), СтрокаИсходная.Цена, 0);
					Сумма			= ?(СтрокаИсходная.Свойство("Сумма"), СтрокаИсходная.Сумма, 0);
					НомерСекции		= ?(СтрокаИсходная.Свойство("НомерСекции"), СтрокаИсходная.НомерСекции , 0);
					СтавкаНДС		= ?(СтрокаИсходная.Свойство("СтавкаНДС"), СтрокаИсходная.СтавкаНДС, 0);
					
					СтрокаПозицииЧека = Новый Структура;
					СтрокаПозицииЧека.Вставить("ФискальнаяСтрока");
					СтрокаПозицииЧека.Вставить("Наименование", Наименование);
					СтрокаПозицииЧека.Вставить("Количество", Количество);
					СтрокаПозицииЧека.Вставить("Цена", Цена);
					СтрокаПозицииЧека.Вставить("Сумма", Сумма);
					СтрокаПозицииЧека.Вставить("НомерСекции", НомерСекции);
					СтрокаПозицииЧека.Вставить("СтавкаНДС", СтавкаНДС);
					
					НовыеПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
					
				КонецЕсли;
				
				// Печать подвала строки.
				Для Каждого СтрокаПодвала Из МассивТекстаСтрокиПодвал[ИндексМассива] Цикл
					ДополнитьПараметрыЧека(НовыеПараметрыЧека, СтрокаПодвала);
				КонецЦикла;
				
			Иначе
				
				СтрокаПозицииЧека = Новый Структура;
				Для Каждого ПолеИсходное Из СтрокаИсходная Цикл
					СтрокаПозицииЧека.Вставить(ПолеИсходное.Ключ, ПолеИсходное.Значение);
				КонецЦикла;
				НовыеПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
				
			КонецЕсли;
			
		КонецЦикла;
			
		// если одна фискальная строка в чеке.
		Если ОднаФискальнаяСтрока Тогда
			
			СтрокаПозицииЧека = Новый Структура;
			СтрокаПозицииЧека.Вставить("ФискальнаяСтрока");
			СтрокаПозицииЧека.Вставить("Наименование", НСтр("ru='Всего:'"));
			СтрокаПозицииЧека.Вставить("Количество", 1);
			СтрокаПозицииЧека.Вставить("Цена", ИтогПоЧеку);
			СтрокаПозицииЧека.Вставить("Сумма", ИтогПоЧеку);
			СтрокаПозицииЧека.Вставить("НомерСекции", НомерСекции);
			СтрокаПозицииЧека.Вставить("СтавкаНДС", 0);
			НовыеПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
			
		КонецЕсли;
		
		// Печать подвала чека.
		Для Каждого СтрокаПодвала Из МассивПодвалЧека Цикл
			ДополнитьПараметрыЧека(НовыеПараметрыЧека, СтрокаПодвала);
		КонецЦикла;
		
		Если НЕ ПустаяСтрока(ДополнительныйТекст) Тогда
			ДополнитьПараметрыЧека(НовыеПараметрыЧека, ДополнительныйТекст);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НовыеПараметрыЧека;
	
КонецФункции

// Определяет рабочее место и необходимость актуализации рабочего места по идентификатору 
//
// Параметры:
//  ИдентификаторРабочегоМеста - Строка - исходные данные для определения результата
//	ИмяКомпьютераРабочегоМеста - Строка - исходные данные для создания нового рабочего места, при необходимости
//
// Возвращаемое значение:
//  Результат - Структура - результат проверки
//		*АктуальноеРабочееМесто - СправочникСсылка.РабочиеМеста
//		*ЗаменитьРабочееМесто - Булево
//
Функция АктуальноеРабочееМестоПользователя(ИдентификаторРабочегоМеста, ИмяКомпьютераРабочегоМеста) Экспорт

	Результат = Новый Структура();
	АктуальноеРабочееМесто = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.РабочиеМеста.ПустаяСсылка");
	ЗаменитьРабочееМесто = Ложь;
	
	Если ЗначениеЗаполнено(ИдентификаторРабочегоМеста)Тогда
	
		МассивРабочихМест = МенеджерОборудованияВызовСервера.НайтиРабочиеМестаПоИдентификатору(ИдентификаторРабочегоМеста);
		Если МассивРабочихМест.Количество() = 0 Тогда
			
			Параметры = Новый Структура();
			Параметры.Вставить("ИмяКомпьютера", ИмяКомпьютераРабочегоМеста);
			Параметры.Вставить("ИдентификаторКлиента", ИдентификаторРабочегоМеста);
			
			РабочееМесто = МенеджерОборудованияВызовСервера.СоздатьРабочееМестоКлиента(Параметры);
			
		Иначе
			РабочееМесто = МассивРабочихМест[0];
		КонецЕсли;
			
		ЗаменитьРабочееМесто = РабочееМесто <> МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		
		Если ЗаменитьРабочееМесто Тогда
			АктуальноеРабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		КонецЕсли;
	
	КонецЕсли;
	
	Результат.Вставить("АктуальноеРабочееМесто",АктуальноеРабочееМесто);
	Результат.Вставить("ЗаменитьРабочееМесто", ЗаменитьРабочееМесто);

	Возврат Результат
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьПараметрыЧека(ПараметрыЧека, ДанныеДляДополнения)
	ПечатьФискальныхЧековРМК.ДополнитьПараметрыЧека(ПараметрыЧека, ДанныеДляДополнения);
КонецПроцедуры

Процедура ИнициализироватьПараметрыШаблона(ПараметрыШаблонаЧека, НовыйТипШаблона, СКД)

	СКД = ПараметрыШаблонаЧека.ШаблонЧека.СхемаКомпоновкиДанных.Получить();
	НовыйТипШаблона = Истина;

КонецПроцедуры
	
#КонецОбласти