
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.БанковскийСчет) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru='Открытие формы сохранение данных по платежкам невозможно без указание параметра банковского счета'");
	КонецЕсли;
	Если Параметры.СписокПлатежек.Количество() = 0 Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru='Не выбрано ни одного платежного поручения. Выгрузка не будет выполнена'");
	КонецЕсли;
	
	Объект.БанковскийСчет = Параметры.БанковскийСчет;
	СписокПлатежек.ЗагрузитьЗначения(Параметры.СписокПлатежек.ВыгрузитьЗначения());
	
	// Заполним настройки.
	ЗагрузитьНастройкиФормы();
	
	Если НЕ ЗначениеЗаполнено(Объект.Кодировка) Тогда
		Объект.Кодировка = "Windows";
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ВерсияФормата) Тогда
		Объект.ВерсияФормата = "1.02";
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.СтатьяДДСВходящий) Тогда
		Объект.СтатьяДДСВходящий = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.СтатьяДДСИсходящий) Тогда
		Объект.СтатьяДДСИсходящий = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ФайлВыгрузки) Тогда
		Объект.ФайлВыгрузки = "1c_to_kl.txt";
	КонецЕсли;
	
	// Заполним ТЧ Выгрузка.
	ЗаполнитьВыгрузка();
	
КонецПроцедуры

// Процедура заполняет таблицу для выгрузки.
//
&НаСервере
Процедура ЗаполнитьВыгрузка()
	
	Объект.Организация = Объект.БанковскийСчет.Владелец;
	
	Запрос = Новый Запрос;
	Запрос.Текст = Обработки.КлиентБанкУНФ.ПолучитьТекстЗапросаПоЗаполнениюТабличнойЧастиВыгрузка(Истина);
	
	Запрос.УстановитьПараметр("Ссылки", СписокПлатежек);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Выгрузка.Колонки.Добавить("ОписаниеОшибокПодТЧ", Новый ОписаниеТипов("Строка"));
	
	КоличествоОтмеченныхСтрок = 0;
	Для каждого СтрокаДокумента Из Выгрузка Цикл
		Обработки.КлиентБанкУНФ.ПроверитьНаКорректностьИПустоеЗначениеЭкспорта(СтрокаДокумента, ЭтотОбъект);
		СтрокаДокумента.Выгружать = ПустаяСтрока(СтрокаДокумента.ОписаниеОшибок);
		СтрокаДокумента.НазначениеПлатежа = СокрЛП(СтрокаДокумента.НазначениеПлатежа);
		СтрокаДокумента.НомерКартинки = ?(ПустаяСтрока(СтрокаДокумента.ОписаниеОшибок), -1, 1);
		ЗаполнитьСуммыВыделеныхНаСервере(СтрокаДокумента);
		КоличествоОтмеченныхСтрок = КоличествоОтмеченныхСтрок + ?(СтрокаДокумента.Выгружать, 1, 0);
		Если Не ПустаяСтрока(СтрокаДокумента.ОписаниеОшибок) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон(НСтр("ru = 'Замечания по документу %1:
											 |%2'"), СтрокаДокумента.Документ, СокрЛП(СтрокаДокумента.ОписаниеОшибок));
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;
	
	Объект.Выгрузка.Загрузить(Выгрузка);
	
КонецПроцедуры // ЗаполнитьВыгрузка()

// Заполнение суммы отмеченныых.
//
&НаСервере
Процедура ЗаполнитьСуммыВыделеныхНаСервере(ТекСтрока)
	
	ТекСтрока.СуммаДокументаВыделено = ?(ТекСтрока.Выгружать, ТекСтрока.СуммаДокумента, 0);
	
КонецПроцедуры

// Загружает настройки формы.
// Если загрузка настроек осуществляется при изменении реквизита формы,
// например, для новой организации, то обязательно проверить подлючено ли 
// расширение для работы с файлами.
//
// Признаком отсутствия подключения будит информация в реквизитах объекта обработки:
// ФайлВыгрузки, ФайлЗагрузки
//
&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/" + ПолучитьНавигационнуюСсылку(Объект.БанковскийСчет), "ВыгрузкаВСбербанк");
	Если Настройки = Неопределено Тогда
		Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/БанковскийСчетНеУказан", "ВыгрузкаВСбербанк");
	КонецЕсли;
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Объект.Программа = Настройки.Получить("Программа");
	Объект.Кодировка = Настройки.Получить("Кодировка");
	Объект.ВерсияФормата = Настройки.Получить("ВерсияФормата");
	Объект.ФайлВыгрузки = Настройки.Получить("ФайлВыгрузки");
	Объект.ФайлЗагрузки = Настройки.Получить("ФайлЗагрузки");
	Объект.СтатьяДДСИсходящий = Настройки.Получить("СтатьяДДСИсходящий");
	Объект.СтатьяДДСВходящий = Настройки.Получить("СтатьяДДСВходящий");
	Объект.ПроводитьЗагружаемые = Настройки.Получить("ПроводитьЗагружаемые");
	Если Настройки.Получить("ЗаполнятьДолгиАвтоматически") = Неопределено Тогда
		Объект.ЗаполнятьДолгиАвтоматически = Истина;
	Иначе
		Объект.ЗаполнятьДолгиАвтоматически = Настройки.Получить("ЗаполнятьДолгиАвтоматически");
	КонецЕсли;
	Объект.Кодировка = Настройки.Получить("Кодировка");
	Если НЕ ЗначениеЗаполнено(Объект.Кодировка) Тогда
		Объект.Кодировка = "Windows";
	КонецЕсли;
	Объект.ВерсияФормата = Настройки.Получить("ВерсияФормата");
	Если НЕ ЗначениеЗаполнено(Объект.ВерсияФормата) Тогда
		Объект.ВерсияФормата = "1.02";
	КонецЕсли;
	Если Настройки.Получить("АвтоматическиПодставлятьДокументы") = Неопределено Тогда
		Объект.АвтоматическиПодставлятьДокументы = Истина;
	Иначе
		Объект.АвтоматическиПодставлятьДокументы = Настройки.Получить("АвтоматическиПодставлятьДокументы");
	КонецЕсли;
	Если Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке") = Неопределено Тогда
		Объект.НеУдалятьДокументыКоторыхНетВВыписке = Ложь;
	Иначе
		Объект.НеУдалятьДокументыКоторыхНетВВыписке = Настройки.Получить("НеУдалятьДокументыКоторыхНетВВыписке");
	КонецЕсли;
	Если Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов") = Неопределено Тогда
		Объект.АнализироватьИсториюВыбораЗначенийРеквизитов = Истина;
	Иначе
		Объект.АнализироватьИсториюВыбораЗначенийРеквизитов = Настройки.Получить("АнализироватьИсториюВыбораЗначенийРеквизитов");
	КонецЕсли;
	Если Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком") = Неопределено Тогда
		Объект.КонтролироватьБезопасностьОбменаСБанком = Истина;
	Иначе
		Объект.КонтролироватьБезопасностьОбменаСБанком = Настройки.Получить("КонтролироватьБезопасностьОбменаСБанком");
	КонецЕсли;
	Если Настройки.Получить("СпособЗачета") = Неопределено Тогда
		Объект.СпособЗачета = Неопределено;
	Иначе
		Объект.СпособЗачета = Настройки.Получить("СпособЗачета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыгрузитьВыполнить();
	Отказ = Истина;
	
КонецПроцедуры

// Процедура - обработчик команды Выгрузить.
//
&НаКлиенте
Процедура ВыгрузитьВыполнить()
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнениеРеквизитовФормы() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Выгрузка.Количество() > 0 Тогда
		
		ЕстьОтмеченныеСтроки = Ложь;
		Для Каждого ТекущаяСтрока Из Объект.Выгрузка Цикл
			Если ТекущаяСтрока.Выгружать Тогда
				ЕстьОтмеченныеСтроки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьОтмеченныеСтроки Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Платежные поручения не будут выгружены. Нужно устранить замечания и повторить выгрузку.'");
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		
		АдресТекстаНаСервере = "";
		ПотокВыгрузки = ВыгрузитьДанныеВФайл(АдресТекстаНаСервере);
		СохранитьФайлВыгрузки(ПотокВыгрузки);
		ПодготовитьПротоколИСохранитьРезультаты(АдресТекстаНаСервере);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,
			НСтр("ru = 'Список документов для выгрузки пуст.
				 |Проверьте правильность указанного банковского счета и периода выгрузки.'"));
		
	КонецЕсли;
	
КонецПроцедуры // ВыгрузитьВыполнить()

// Функция проверяет правильность заполнения реквизитов формы.
//
&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитовФормы(ПрямойОбменСБанками = Ложь)
	
	Отказ = Ложь;
	
	// Проверка заполненности реквизитов.
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена организация в карточке банковского счета.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Организация", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'Устраните замечания и нажмите кнопку еще раз'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

// Процедура выгружает данные в файл.
//
&НаСервере
Функция ВыгрузитьДанныеВФайл(АдресТекстаНаСервере = "")
	
	ПотокВыгрузки = РеквизитФормыВЗначение("Объект").Выгрузить(РасширениеРаботыСФайламиПодключено, УникальныйИдентификатор, АдресТекстаНаСервере);
	
	Возврат ПотокВыгрузки;
	
КонецФункции // ВыгрузитьДанныеВФайл()

// Функция сохраняет файл выгрузки.
//
&НаКлиенте
Процедура СохранитьФайлВыгрузки(ПотокВыгрузки)
	
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
	
	Попытка
		
		ВыгружатьИнтерактивно = Объект.ФайлВыгрузки = "1c_to_kl.txt" ИЛИ ЭтоВебКлиент;
		Результат = ПолучитьФайл(ПотокВыгрузки, Объект.ФайлВыгрузки, ВыгружатьИнтерактивно);
		
		// Отметим те документы которые успешно выгрузились.
		Если Результат <> Неопределено Тогда
			Если Результат Тогда
				Для каждого СтрокаСекции Из Объект.Выгрузка Цикл
					Если СтрокаСекции.Готовность = - 2 Тогда
						СтрокаСекции.Готовность = - 1;
					КонецЕсли;
				КонецЦикла;
				Если ВыгружатьИнтерактивно Тогда
					ТекстСообщения = НСтр("ru = 'Данные успешно выгружены в файл.'");
				Иначе
					ТекстСообщения = НСтр("ru = 'Данные успешно выгружены в файл '") + Объект.ФайлВыгрузки + ".";
				КонецЕсли;
			Иначе
				ТекстСообщения = НСтр("ru = 'Операция отменена'");
			КонецЕсли;
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	Исключение
		
		ТекстСообщения = НСтр("ru = 'Не удалось записать данные в файл. Возможно, диск защищен от записи.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		
	КонецПопытки
	
КонецПроцедуры // СохранитьФайлВыгрузки()

#Область ПротоколВыгрузки

&НаСервере
Функция ВывестиПротокол()
	
	// вывод в макет
	
	СтруктураПараметров = Новый Структура(
		"НазваниеОрганизации, ОписаниеПериода, ДатаСеанса",
		Объект.Организация,
		ПредставлениеПериода(Объект.НачПериода, КонецДня(Объект.КонПериода)),
		ТекущаяДатаСеанса());
	
	Протокол.Очистить();
	
	Макет = Обработки.КлиентБанкУНФ.ПолучитьМакет("ПротоколСохранения");
	
	ОбластьЗаголовка = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовка.Параметры.Заполнить(СтруктураПараметров);
	
	Протокол.Вывести(ОбластьЗаголовка);
	
	Область = Макет.ПолучитьОбласть("Строка");
	НомерПП = 1;
	
	НайденныеСтроки = Объект.Выгрузка.НайтиСтроки(Новый Структура("Выгружать", Истина));
	
	Для Каждого СтрокаПротокола Из НайденныеСтроки Цикл
		
		Область.Параметры.Заполнить(СтрокаПротокола);
		Область.Параметры.Сумма = СтрокаПротокола.СуммаДокумента;
		Область.Параметры["НомерПП"] = НомерПП;
		Протокол.Вывести(Область);
		НомерПП = НомерПП + 1;
			
	КонецЦикла;
	
	Возврат НайденныеСтроки.Количество();
	
КонецФункции

&НаСервере
Процедура ПодготовитьПротоколИСохранитьРезультаты(АдресТекстаНаСервере)
	
	КоличествоВыведенныхДокументов = ВывестиПротокол();
	
	// Сохраняем историю
	Запись = РегистрыСведений.ИсторияРаботыСКлиентомБанка.СоздатьМенеджерЗаписи();
	Запись.Период = ТекущаяДатаСеанса();
	Запись.Организация = Объект.Организация;
	Запись.БанковскийСчет = Объект.БанковскийСчет;
	Запись.Загрузка = Ложь;
	
	Запись.КоличествоДокументовВВыписке = КоличествоВыведенныхДокументов;
	Запись.Кодировка = Объект.Кодировка;
	
	Запись.ИсходныйФайл = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресТекстаНаСервере),
		Новый СжатиеДанных(5));
	
	Запись.ПротоколЗагрузки = Новый ХранилищеЗначения(Протокол, Новый СжатиеДанных(5));
		
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти