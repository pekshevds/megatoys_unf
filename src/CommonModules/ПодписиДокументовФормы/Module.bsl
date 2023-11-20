
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриСозданииНаСервере(Форма, ОписаниеПодписей = Неопределено, ОписаниеФормы = Неопределено) Экспорт
	
	СоздатьДополнительныеРеквизитыФормыПодписейДокументов(Форма);
	ЗаполнитьДополнительныеРеквизитыФормыПодписейДокументов(Форма, ОписаниеПодписей);
	
	ОрганизацииДокумента = МассивОрганизацийОбъекта(Форма);
	Для каждого ИмяРеквизитаОрганизация Из ОрганизацииДокумента Цикл
		Если ОписаниеФормы = Неопределено Тогда
			ОписаниеФормыОбъекта = ПодписиДокументовКлиентСервер.ОписаниеФормыОбъектаДляОрганизацииПоУмолчанию();
		Иначе
			ОписаниеФормыОбъекта = ОписаниеФормы.Получить(ИмяРеквизитаОрганизация);
		КонецЕсли;
			
		СоздатьЭлементыПодписейДокументов(Форма, ОписаниеФормыОбъекта);
		ЗаполнитьВторичныеРеквизитыФормыПодписейДокументов(Форма, ОписаниеФормыОбъекта);
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьПодписиПоОрганизации(Форма, ОписаниеФормы = Неопределено, ИмяРеквизитаОрганизация = "Организация") Экспорт

	Если Не ПодписиДокументовКлиентСервер.СозданыРеквизитыПодписей(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОписаниеФормы = Неопределено Тогда
		ОписаниеФормыПоОрганизации = ПодписиДокументовКлиентСервер.ОписаниеФормыОбъектаДляОрганизацииПоУмолчанию();
	Иначе
		ОписаниеФормыПоОрганизации = ОписаниеФормы.Получить(ИмяРеквизитаОрганизация);
	КонецЕсли;
	
	ЗаполнитьПодписиДокументаВФорме(Форма, ОписаниеФормыПоОрганизации);
	
	ЗаполнитьВторичныеРеквизитыФормыПодписейДокументов(Форма, ОписаниеФормыПоОрганизации);

КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	ОписаниеФормыОбъекта = ПодписиДокументовКлиентСервер.ОписаниеФормыОбъектаДляОрганизацииПоУмолчанию();
	
	ОбъектСсылка = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + "Ссылка");
	ОрганизацииДокумента = МассивОрганизацийОбъекта(Форма);
	
	Для каждого ИмяРеквизитаОрганизация Из ОрганизацииДокумента Цикл
		ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация = ИмяРеквизитаОрганизация;
		
		СохранитьСоставПодписантовОрганизацииВНастройках(Форма, ОписаниеФормыОбъекта);
	КонецЦикла;
	
КонецПроцедуры

// АПК:581-выкл используется в расширенной версии библиотеки.

Процедура СоздатьДополнительныеРеквизитыФормыПодписейДокументов(Форма) Экспорт

	МассивРеквизитов = Новый Массив;
	
	// Описание реквизитов.
	
	// Сохраненные подписанты при открытии формы.
	РеквизитСведенияОбОтветственныхРаботниках = Новый РеквизитФормы("СведенияОбОтветственныхРаботниках", Новый ОписаниеТипов());
	МассивРеквизитов.Добавить(РеквизитСведенияОбОтветственныхРаботниках);
	
	// запоминаем право пользователя на изменение полномочий.
	РеквизитЕстьПравоИзмененияОснованийПолномочий = Новый РеквизитФормы("ЕстьПравоИзмененияОснованийПолномочий", Новый ОписаниеТипов("Булево"));
	МассивРеквизитов.Добавить(РеквизитЕстьПравоИзмененияОснованийПолномочий);
	
	// Использование оснований подписи, см. ПодписиДокументов.ИспользоватьОснованияПолномочий().
	РеквизитИспользоватьОснованияПолномочийПодписейДокументов = Новый РеквизитФормы("ИспользоватьОснованияПолномочийПодписейДокументов", Новый ОписаниеТипов("Булево"));
	МассивРеквизитов.Добавить(РеквизитИспользоватьОснованияПолномочийПодписейДокументов);
	
	// Описание структуру подписантов.
	РеквизитОписаниеПодписейДокумента = Новый РеквизитФормы("ОписаниеПодписейДокумента", Новый ОписаниеТипов());
	МассивРеквизитов.Добавить(РеквизитОписаниеПодписейДокумента);
	
	// Роли подписантов и действия при сохранении в пользовательские настройки
	РеквизитСменаПодписантов = Новый РеквизитФормы("СменаПодписантов", Новый ОписаниеТипов());
	МассивРеквизитов.Добавить(РеквизитСменаПодписантов);
	
	// Создание реквизитов.
	
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ИзменитьРеквизитыФормы(Форма, МассивРеквизитов, МассивИменРеквизитовФормы);
	
КонецПроцедуры

Процедура СоздатьЭлементПодписиВФорме(Форма, ОписаниеФормыОбъекта, ОписаниеПодписанта, ЭлементГруппа) Экспорт

	ИмяЭлемента = ПодписиДокументовКлиентСервер.ИмяЭлементаФормыПоРолиПодписанта(ОписаниеПодписанта.РольПодписанта, ОписаниеПодписанта.Организация);
	Если Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = Форма.Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"), ЭлементГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеПодписанта.ФизическоеЛицо;
	
	Элемент.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	Элемент.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Ввести основание подписи'");
	Элемент.РасширеннаяПодсказка.АвтоМаксимальнаяШирина = Ложь;
	
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПодписиДокументовЭлементПриИзменении");
	
	Если Форма.ЕстьПравоИзмененияОснованийПолномочий Тогда
		Элемент.РасширеннаяПодсказка.Гиперссылка = Истина;
		Элемент.РасширеннаяПодсказка.УстановитьДействие("Нажатие", "Подключаемый_ПодписиДокументовЭлементНажатие");
	КонецЕсли; 
	
	// СвязиПараметровВыбора
	СвязьПараметра = Новый СвязьПараметраВыбора(
		"Организация",
		ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеПодписанта.Организация,
		РежимИзмененияСвязанногоЗначения.Очищать);
		
	Элемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СвязьПараметра));
		
	// ПараметрыВыбора
	НовыйПараметрВыбора = Новый ПараметрВыбора("РазделительИсторииВыбора_" + ОписаниеПодписанта.РольПодписанта, "");
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НовыйПараметрВыбора));

КонецПроцедуры

// АПК:581-вкл

Функция ОписаниеПодписейПоСсылке(ОбъектСсылка, ОписаниеПодписейДокумента = Неопределено) Экспорт
	
	Если ОписаниеПодписейДокумента = Неопределено Тогда
		ОписаниеПодписейДокумента = ПодписиДокументов.ТаблицаОписанийПодписейОбъекта(ОбъектСсылка);
	КонецЕсли;
	
	УдалитьРолиРеквизитовНедоступныхПоФункциональнымОпциям(ОбъектСсылка, ОписаниеПодписейДокумента);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ОписаниеПодписейДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДополнительныеРеквизитыФормыПодписейДокументов(Форма, ОписаниеПодписей)

	// ИспользоватьОснованияПолномочийПодписейДокументов
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
		Форма,
		"ИспользоватьОснованияПолномочийПодписейДокументов",
		ПодписиДокументов.ИспользоватьОснованияПолномочий());
		
	// ЕстьПравоИзмененияОснованийПолномочий
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
		Форма,
		"ЕстьПравоИзмененияОснованийПолномочий",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ОснованияПолномочийОтветственныхЛиц));
		
	// ОписаниеПодписейДокумента	
	ЗаполнитьОписаниеПодписейДокумента(Форма, ОписаниеПодписей);
	
КонецПроцедуры

Процедура ЗаполнитьОписаниеПодписейДокумента(Форма, ОписаниеПодписейДокумента, ПрефиксФормыОбъект = "Объект")
	
	ОбъектСсылка = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ПрефиксФормыОбъект + "." + "Ссылка");
	
	МассивСтруктурОписаний = ОписаниеПодписейПоСсылке(ОбъектСсылка, ОписаниеПодписейДокумента);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
		Форма,
		"ОписаниеПодписейДокумента",
		Новый ФиксированныйМассив(МассивСтруктурОписаний));

КонецПроцедуры

Процедура СоздатьЭлементыПодписейДокументов(Форма, ОписаниеФормыОбъекта)
	
	ОписаниеПодписейДокумента = ПодписиДокументовКлиентСервер.МассивОписанийИменРеквизитовДляОрганизации(
		Форма, ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация);
		
	УстановитьСвойстваПосадочнойГруппе(Форма, ОписаниеФормыОбъекта);
		
	СоздатьГруппыКолонок(Форма, ОписаниеФормыОбъекта);
		
	СчетчикЭлементов = 1;
		
	Для каждого ОписаниеПодписанта Из ОписаниеПодписейДокумента Цикл
		СоздатьИПоместитьЭлементПодписиВФорме(Форма, ОписаниеФормыОбъекта, ОписаниеПодписанта, СчетчикЭлементов);
		СчетчикЭлементов = СчетчикЭлементов + 1;
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьСвойстваПосадочнойГруппе(Форма, ОписаниеФормыОбъекта)

	ПосадочнаяГруппа = Форма.Элементы.Найти(ОписаниеФормыОбъекта.ИмяПосадочнойГруппы);
	Если ПосадочнаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПосадочнаяГруппа.Заголовок = НСтр("ru = 'Подписи'");
	ПосадочнаяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ПосадочнаяГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
	ПосадочнаяГруппа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.ГиперссылкаЗаголовка;

КонецПроцедуры

Процедура СоздатьГруппыКолонок(Форма, ОписаниеФормыОбъекта)
	
	ПосадочнаяГруппа = Форма.Элементы.Найти(ОписаниеФормыОбъекта.ИмяПосадочнойГруппы);
	Если ПосадочнаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЛеваяКолонкаГруппаИмя = ОписаниеФормыОбъекта.ИмяПосадочнойГруппы + "Левая";
	ПраваяКолонкаГруппаИмя = ОписаниеФормыОбъекта.ИмяПосадочнойГруппы + "Правая";
	
	Если Форма.Элементы.Найти(ЛеваяКолонкаГруппаИмя) = Неопределено Тогда
		ЭлементГруппа = Форма.Элементы.Вставить(ЛеваяКолонкаГруппаИмя, Тип("ГруппаФормы"), ПосадочнаяГруппа);
		ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ЭлементГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ЭлементГруппа.ОтображатьЗаголовок = Ложь;
		ЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	Если Форма.Элементы.Найти(ПраваяКолонкаГруппаИмя) = Неопределено Тогда
		ЭлементГруппа = Форма.Элементы.Вставить(ПраваяКолонкаГруппаИмя, Тип("ГруппаФормы"), ПосадочнаяГруппа);
		ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ЭлементГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ЭлементГруппа.ОтображатьЗаголовок = Ложь;
		ЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьИПоместитьЭлементПодписиВФорме(Форма, ОписаниеФормыОбъекта, ОписаниеПодписанта, СчетчикЭлементов)

	Если Цел(СчетчикЭлементов/2) = (СчетчикЭлементов/2) Тогда
		ЭлементГруппа = Форма.Элементы.Найти(ОписаниеФормыОбъекта.ИмяПосадочнойГруппы + "Правая");
	Иначе	
		ЭлементГруппа = Форма.Элементы.Найти(ОписаниеФормыОбъекта.ИмяПосадочнойГруппы + "Левая");
	КонецЕсли;
	
	Если ЭлементГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьЭлементПодписиВФорме(Форма, ОписаниеФормыОбъекта, ОписаниеПодписанта, ЭлементГруппа);
	
КонецПроцедуры

// Процедура заполняет реквизиты подписантов в документе.
//
Процедура ЗаполнитьПодписиДокументаВФорме(Форма, ОписаниеФормыОбъекта) 
	
	// Получаем Организацию, которая используется как владелец всех реквизитов подписантов
	Организация = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация);
		
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	// Получаем описание реквизитов документа, участвующих в подписях
	ОписаниеПолейПодписантов = ПодписиДокументовКлиентСервер.СоответствиеОписанийПодписейДокументаДляОрганизации(Форма, ОписаниеФормыОбъекта, Ложь);
	
	// Получаем дату, на которую необходимо получить сведения
	ДатаСведений = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + "Дата");
		
	ОбъектСсылка = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + "Ссылка");
	ВидДокумента = ТипЗнч(ОбъектСсылка);
	
	// По описанию реквизитов получаем их значения
	СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхДокументов(ОписаниеПолейПодписантов, Организация, ДатаСведений, ВидДокумента);
	
	// Заполняем форму полученными значениями
	Для каждого ОписаниеРеквизитовПодписанта Из ОписаниеПолейПодписантов Цикл // Цикл по ролям подписантов
		ОчиститьРеквизитыПодписанта(Форма, ОписаниеФормыОбъекта, ОписаниеРеквизитовПодписанта.Значение);
		Для каждого ЗначениеРеквизитаПодписанта Из ОписаниеРеквизитовПодписанта.Значение Цикл // Цикл по реквизитам роли (ФизическоеЛицо, ОписаниеПолномочий, Должность)
			ЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СведенияОПодписях, ЗначениеРеквизитаПодписанта.Значение);
			Если ЗначениеРеквизита = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				Форма,
				ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ЗначениеРеквизитаПодписанта.Значение,
				ЗначениеРеквизита);
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры

Функция МассивОрганизацийОбъекта(Форма)

	МассивОрганизаций = Новый Массив;
	
	МассивОписаний = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "ОписаниеПодписейДокумента");
	Для каждого СтруктураОписания Из МассивОписаний Цикл
		Если МассивОрганизаций.Найти(СтруктураОписания.Организация) = Неопределено Тогда
			МассивОрганизаций.Добавить(СтруктураОписания.Организация);
		КонецЕсли;
	КонецЦикла; 
	
	Возврат МассивОрганизаций;
	
КонецФункции

Процедура ОчиститьРеквизитыПодписанта(Форма, ОписаниеФормыОбъекта, ОписаниеРеквизитов)

	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
		Форма,
		ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеРеквизитов.ФизическоеЛицо,
		ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
		Форма,
		ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеРеквизитов.Должность,
		ПредопределенноеЗначение("Справочник.Должности.ПустаяСсылка"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
		Форма,
		ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеРеквизитов.ОснованиеПодписи,
		"");

КонецПроцедуры

Процедура ЗаполнитьВторичныеРеквизитыФормыПодписейДокументов(Форма, ОписаниеФормыОбъекта)

	ПодписиДокументовКлиентСервер.ЗапомнитьПодписиДокументовВФорме(Форма, ОписаниеФормыОбъекта);
	
	ПодписиДокументовКлиентСервер.УстановитьПредставлениеПодписей(Форма, ОписаниеФормыОбъекта);
	ПодписиДокументовКлиентСервер.УстановитьЗаголовокГруппеПодписей(Форма, ОписаниеФормыОбъекта);

КонецПроцедуры

Процедура СохранитьСоставПодписантовОрганизацииВНастройках(Форма, ОписаниеФормыОбъекта)
	
	СменаПодписантовВФорме = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "СменаПодписантов");
	Если СменаПодписантовВФорме = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СменаПодписантов = СменаПодписантовВФорме.Получить(ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация);
	
	Организация = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация);
		
	ОбъектСсылка = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + "Ссылка");
	ВидДокумента = ТипЗнч(ОбъектСсылка);
	
	ОписаниеПолейПодписантов = ПодписиДокументовКлиентСервер.СоответствиеОписанийПодписейДокументаДляОрганизации(Форма, ОписаниеФормыОбъекта);
	
	Для Каждого КлючИЗначение Из СменаПодписантов Цикл
		
		ПоляПодписанта = ОписаниеПолейПодписантов.Получить(КлючИЗначение.Ключ);
		ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПоляПодписанта.ФизическоеЛицо);
		Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		Если КлючИЗначение.Значение = ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ЗапоминатьДляВсехДокументов Тогда
			
			СтруктураНастроекПоВидам = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкиПользователя", "ПодписиПоВидамДокументов", Новый Соответствие);
			НастройкиПоОрганизацииПоВидам = СтруктураНастроекПоВидам.Получить(Организация);
			
			Если НастройкиПоОрганизацииПоВидам <> Неопределено Тогда
				
				НастройкиПоОрганизацииПоВидам.Удалить(КлючИЗначение.Ключ);
				
				Если НастройкиПоОрганизацииПоВидам.Количество() = 0 Тогда
					СтруктураНастроекПоВидам.Удалить(Организация);
				Иначе
					СтруктураНастроекПоВидам.Вставить(Организация, НастройкиПоОрганизацииПоВидам);
				КонецЕсли;
				
				Если СтруктураНастроекПоВидам.Количество() = 0 Тогда
					ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(
						"НастройкиПользователя", "ПодписиПоВидамДокументов", ИмяПользователя());
				Иначе
					ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
						"НастройкиПользователя", "ПодписиПоВидамДокументов", СтруктураНастроекПоВидам);
				КонецЕсли;
				
			КонецЕсли;
			
			СтруктураНастроек = ПодписиДокументов.НастройкиПодписейДокументовПользователя();
			Если ТипЗнч(СтруктураНастроек) = Тип("Соответствие") Тогда
				НастройкиПоОрганизации = СтруктураНастроек.Получить(Организация);
			Иначе
				СтруктураНастроек = Новый Соответствие;
				НастройкиПоОрганизации = Неопределено;
			КонецЕсли;
			
			Если НастройкиПоОрганизации = Неопределено Тогда
				НастройкиПоОрганизации = Новый Структура;
			КонецЕсли;
			
			НастройкиПоОрганизации.Вставить(КлючИЗначение.Ключ, ФизическоеЛицо);
			СтруктураНастроек.Вставить(Организация, НастройкиПоОрганизации);
			
			СохранитьНастройкиПодписейДокументовПользователя(СтруктураНастроек);
			
		ИначеЕсли КлючИЗначение.Значение = ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ЗапоминатьПоВидамДокументов Тогда
			
			СтруктураНастроекПоВидам = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкиПользователя", "ПодписиПоВидамДокументов", Новый Соответствие);
			НастройкиПоОрганизации = СтруктураНастроекПоВидам.Получить(Организация);
			
			Если НастройкиПоОрганизации = Неопределено Тогда
				НастройкиПоОрганизации = Новый Соответствие;
				НастройкиПоРолям = Новый Соответствие;
			Иначе
				НастройкиПоРолям = НастройкиПоОрганизации.Получить(КлючИЗначение.Ключ);
				Если НастройкиПоРолям = Неопределено Тогда
					НастройкиПоРолям = Новый Соответствие;
				КонецЕсли;
			КонецЕсли;
			
			НастройкиПоРолям.Вставить(ВидДокумента, ФизическоеЛицо);
			НастройкиПоОрганизации.Вставить(КлючИЗначение.Ключ, НастройкиПоРолям);
			
			СтруктураНастроекПоВидам.Вставить(Организация, НастройкиПоОрганизации);
			
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
				"НастройкиПользователя", "ПодписиПоВидамДокументов", СтруктураНастроекПоВидам);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "СменаПодписантов", Неопределено);
	
КонецПроцедуры

Процедура СохранитьНастройкиПодписейДокументовПользователя(СтруктураНастроек)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкиПользователя", "ПодписиДокументов", СтруктураНастроек);

КонецПроцедуры

Процедура УдалитьРолиРеквизитовНедоступныхПоФункциональнымОпциям(ОбъектСсылка, ОписаниеПодписей)

	УдаляемыеРоли = Новый Массив;
	РеквизитыОбъекта = ОбъектСсылка.Метаданные().Реквизиты;
	
	Для каждого ОписаниеПодписи Из ОписаниеПодписей Цикл
		РеквизитФизическоеЛицо = ОписаниеПодписи.ФизическоеЛицо;
		
		Если НЕ ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(РеквизитыОбъекта.Найти(РеквизитФизическоеЛицо)) Тогда
			УдаляемыеРоли.Добавить(ОписаниеПодписи);
		КонецЕсли;
	КонецЦикла; 
	
	Для каждого УдаляемаяРоль Из УдаляемыеРоли Цикл
		ОписаниеПодписей.Удалить(УдаляемаяРоль);
	КонецЦикла; 

КонецПроцедуры

#КонецОбласти
