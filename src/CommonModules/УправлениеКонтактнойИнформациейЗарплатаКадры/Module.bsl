
#Область ПрограммныйИнтерфейс

// Возвращает юридический и фактический адреса указанной организации.
//
// Параметры:
//  Организации      - Массив из СправочникСсылка.Организации
//                   - СправочникСсылка.Организации
//  ДатаАктуальности - Дата
//
// Возвращаемое значение:
//  Соответствие: 
//     * Ключ 		- СправочникСсылка.Организации
//     * Значение 	- Соответствие:
//        ** Ключ - СправочникСсылка.ВидыКонтактнойИнформации
//        ** Значение - Структура:
//            *** Представление - Строка - Представление адреса
//            *** Город         - Строка - представление города (населенного пункта) в виде <сокращение>.<наименование>
//            *** ЗначенияПолей - Строка - XML, соответствующий XDTO пакету  Адрес.
//
Функция АдресаОрганизаций(Организации, Знач ДатаАктуальности = '00010101') Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие;
	
	Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ТипСправочникСсылкаОрганизации = Тип("СправочникСсылка.Организации");
	
	// Определение соответствия видов контактной информации в зависимости от 
	// типа объекта, содержащего контактную информацию.
	СоответствиеАдресовОрганизаций = Новый Соответствие;
	
	СоответствиеВидов = Новый Соответствие;
	СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	
	СоответствиеАдресовОрганизаций.Вставить(ТипСправочникСсылкаОрганизации, СоответствиеВидов);
	
	ЗарплатаКадрыПереопределяемый.ДополнитьСоответствиеАдресовОрганизаций(СоответствиеАдресовОрганизаций);
	
	// Деление организаций по типу объекта, содержащего контактную информацию.
	КоллекцияПоТипам = Новый Соответствие;
			
	Если ТипЗнч(Организации) = ТипСправочникСсылкаОрганизации Тогда
		КоллекцияПоТипам.Вставить(ТипСправочникСсылкаОрганизации, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организации));
	Иначе
		КоллекцияПоТипам.Вставить(ТипСправочникСсылкаОрганизации, Организации);
	КонецЕсли;
	
	ЗарплатаКадрыПереопределяемый.ОпределитьТипыВладельцевАдресовОрганизаций(КоллекцияПоТипам);
	
	// Получение адресов
	Для каждого КоллекцияПоТипу Из КоллекцияПоТипам Цикл
		
		Если КоллекцияПоТипу.Ключ = Тип("СправочникСсылка.Организации") Тогда
			МассивСсылок = КоллекцияПоТипу.Значение;
			СоответствиеВидовКИ = СоответствиеАдресовОрганизаций.Получить(ТипСправочникСсылкаОрганизации);
		Иначе
			МассивСсылок = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияПоТипу.Значение, "Ключ");
			СоответствиеВидовКИ = СоответствиеАдресовОрганизаций.Получить(КоллекцияПоТипу.Ключ);
		КонецЕсли;
		
		ВидыАдресов = ОбщегоНазначения.ВыгрузитьКолонку(СоответствиеВидовКИ, "Ключ");
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		УправлениеКонтактнойИнформацией.СоздатьВТКонтактнаяИнформация(Запрос.МенеджерВременныхТаблиц, МассивСсылок, , ВидыАдресов, ДатаАктуальности);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	КонтактнаяИнформация.Объект КАК Объект,
			|	КонтактнаяИнформация.Вид,
			|	КонтактнаяИнформация.Представление,
			|	КонтактнаяИнформация.ЗначенияПолей
			|ИЗ
			|	ВТКонтактнаяИнформация КАК КонтактнаяИнформация
			|ИТОГИ ПО
			|	Объект";
			
		ВыборкаОрганизаций = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОрганизаций.Следующий() Цикл
			
			СоответствиеАдресовОрганизации = Новый Соответствие;
			ВыборкаПоВидам = ВыборкаОрганизаций.Выбрать();
			Пока ВыборкаПоВидам.Следующий() Цикл
				
				СтруктураАдреса = СтруктураПустогоАдресаОрганизации();
				ЗаполнитьЗначенияСвойств(СтруктураАдреса, ВыборкаПоВидам);
				
				АдресСтруктура = ЗарплатаКадры.СтруктураАдресаИзXML(
					ВыборкаПоВидам.ЗначенияПолей, ВыборкаПоВидам.Вид);
					
				Сокращение = "";
				Если АдресСтруктура.Свойство("Город") И НЕ ПустаяСтрока(АдресСтруктура.Город) Тогда
					СтруктураАдреса.Город = АдресСтруктура.Город;
					АдресСтруктура.Свойство("ГородСокращение", Сокращение);
				ИначеЕсли АдресСтруктура.Свойство("НаселенныйПункт") И НЕ ПустаяСтрока(АдресСтруктура.НаселенныйПункт) Тогда
					СтруктураАдреса.Город = АдресСтруктура.НаселенныйПункт;
					АдресСтруктура.Свойство("НаселенныйПунктСокращение", Сокращение);
				ИначеЕсли АдресСтруктура.Свойство("Регион") И НЕ ПустаяСтрока(АдресСтруктура.Регион) Тогда
					СтруктураАдреса.Город = АдресСтруктура.Регион;
					АдресСтруктура.Свойство("РегионСокращение", Сокращение);
				КонецЕсли; 
				
				Если НЕ ПустаяСтрока(СтруктураАдреса.Город) И НЕ ПустаяСтрока(Сокращение) Тогда
					СтруктураАдреса.Город = Сокращение + ". " + Лев(СтруктураАдреса.Город, СтрДлина(СтруктураАдреса.Город) - СтрДлина(Сокращение) - 1);
				КонецЕсли; 
				
				ВидАдреса = СоответствиеВидовКИ.Получить(ВыборкаПоВидам.Вид);
				СоответствиеАдресовОрганизации.Вставить(ВидАдреса, СтруктураАдреса);
				
			КонецЦикла; 
			
			Если КоллекцияПоТипу.Ключ = Тип("СправочникСсылка.Организации") Тогда
				СсылкаНаОрганизацию = ВыборкаОрганизаций.Объект;
			Иначе
				СсылкаНаОрганизацию = КоллекцияПоТипу.Значение.Получить(ВыборкаОрганизаций.Объект);
			КонецЕсли;
			ВозвращаемоеЗначение.Вставить(СсылкаНаОрганизацию, СоответствиеАдресовОрганизации);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает структура адреса, поставляемую методом АдресаОрганизаций, по
// переданным параметрам Организации и виду адреса.
//
// Параметры:
//		АдресаОрганизаций - Соответствие - см. АдресаОрганизаций.
//		Организация       - СправочникСсылка.Организации
//		ВидАдреса         - СправочникСсылка.ВидыКонтактнойИнформации
//
// Возвращаемое значение:
//  Структура:
//     * Представление - Строка - Представление адреса
//     * Город         - Строка - представление города (населенного пункта) в виде <сокращение>.<наименование>
//     * ЗначенияПолей - Строка - XML, соответствующий XDTO пакету  Адрес.
//
Функция АдресОрганизации(АдресаОрганизаций, Организация, ВидАдреса) Экспорт
	
	АдресОрганизации = СтруктураПустогоАдресаОрганизации();
	
	АдресаОрганизации = АдресаОрганизаций.Получить(Организация);
	Если АдресаОрганизации <> Неопределено Тогда
		Адрес = АдресаОрганизации.Получить(ВидАдреса);
		Если Адрес <> Неопределено Тогда
				АдресОрганизации = Адрес;
		КонецЕсли; 
	КонецЕсли; 
		
	Возврат АдресОрганизации;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать КонтактнаяИнформацияБЗК.ПриСозданииНаСервере.
//   Обработчик для события формы ПриСозданииНаСервере, вызывается после вызова соответствующего метода подсистемы
//   УправлениеКонтактнойИнформации. Дополняет элементы отображения полей ввода адресов, полями
//   отображающими результаты проверки адресов на корректность.
//
// Параметры:
//    Форма - ФормаКлиентскогоПриложения - Форма объекта-владельца, предназначенная для вывода контактной 
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	КонтактнаяИнформацияБЗК.ПриСозданииНаСервере(Форма);
КонецПроцедуры

// Устарела. Следует использовать КонтактнаяИнформацияБЗК.ОбновитьКонтактнуюИнформацию.
//   Добавляет (удаляет) поле ввода или комментарий на форму.
//
Процедура ОбновитьКонтактнуюИнформацию(Форма, Результат, ЗависимостиВидовАдресов = Неопределено) Экспорт
	КонтактнаяИнформацияБЗК.ОбновитьКонтактнуюИнформацию(Форма, Результат, ЗависимостиВидовАдресов);
КонецПроцедуры

// Устарела. Следует использовать КонтактнаяИнформацияБЗК.ОбновитьПолеВводаАдреса или ОбновитьПолеВводаТелефона.
//   Обновляет представление и отображение поля ввода контактной информации.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Обновляемая форма.
//   ИмяПоляВводаПредставления - Строка - Имя поля ввода, связанного с реквизитом формы,
//       в котором хранится представление контактной информации.
//       Пример: "ПредставлениеАдресаОрганизации".
//   ЗначениеКонтактнойИнформации - Строка - Значение контактной информации в XML или JSON.
//   ТипКонтактнойИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации - Адрес или Телефон.
//
Процедура ОбновитьПолеВводаКонтактнойИнформации(Форма, ИмяПоляВводаПредставления, ЗначениеКонтактнойИнформации, ТипКонтактнойИнформации) Экспорт
	КонтактнаяИнформацияБЗК.ОбновитьПолеВводаКонтактнойИнформации(
		Форма,
		ИмяПоляВводаПредставления,
		ЗначениеКонтактнойИнформации,
		ТипКонтактнойИнформации);
КонецПроцедуры

// Устарела. Следует использовать КонтактнаяИнформацияБЗК.СтруктураТелефона.
//   Возвращает сведения о телефоне.
//
// Параметры:
//   ЗначениеТелефона - Строка - Значение контактной информации типа "Телефон" в формате JSON.
//
// Возвращаемое значение:
//   Структура - См. УправлениеКонтактнойИнформацией.СведенияОТелефоне.
//
Функция СтруктураТелефона(ЗначениеТелефона) Экспорт
	Возврат КонтактнаяИнформацияБЗК.СтруктураТелефона(ЗначениеТелефона);
КонецФункции

// Устарела. Следует использовать КонтактнаяИнформацияБЗК.ПредставлениеТелефона.
//   Возвращает представление телефона.
//
// Параметры:
//   ЗначениеТелефона  - Строка    - Значение контактной информации типа "Телефон" (строка json или xml).
//                     - Структура - Результат функции УправлениеКонтактнойИнформациейЗарплатаКадры.СтруктураТелефона.
//   ОграничениеДлины  - Число     - Ограничение длины телефона.
//   ДляПечатиПоБуквам - Булево    - Если Истина то будет сформировано представление для функции
//                                   ПрямыеВыплатыПособийСоциальногоСтрахования.ВывестиТелефонПоБуквам.
//
// Возвращаемое значение:
//   Строка - Удобочитаемое представление телефона, например: "+7 123 456-78-90".
//
Функция ПредставлениеТелефона(ЗначениеТелефона, ОграничениеДлины, ДляПечатиПоБуквам = Ложь) Экспорт
	Возврат КонтактнаяИнформацияБЗК.ПредставлениеТелефона(ЗначениеТелефона, ОграничениеДлины, ДляПечатиПоБуквам);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураПустогоАдресаОрганизации()
	
	Возврат Новый Структура("Представление,Город,ЗначенияПолей", "", "", "");
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать КонтактнаяИнформацияБЗК.УстановитьОтображениеПоляАдреса.
Процедура УстановитьОтображениеПоляАдреса(Адрес, СписокПолей, Элемент, Форма, ВидАдреса, АдресныйКлассификаторЗагружен = Неопределено, ПроверенныеАдреса = Неопределено, Комментарий = "") Экспорт
	КонтактнаяИнформацияБЗК.УстановитьОтображениеПоляАдреса(Адрес, СписокПолей, Элемент, Форма, ВидАдреса, АдресныйКлассификаторЗагружен, ПроверенныеАдреса, Комментарий);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
