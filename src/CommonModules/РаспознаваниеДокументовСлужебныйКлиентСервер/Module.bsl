#Область СлужебныйПрограммныйИнтерфейс

#Область Переопределяемый

// Для быстрой подмены адреса сведений на сайте сервиса.
// Исп. в расширении.
//
// Возвращаемое значение:
//   Строка
//
Функция АдресСведенияСайт() Экспорт
	
	Возврат "https://ocr.1c.ai";
	
КонецФункции

// Для быстрой подмены адреса сведений на Портале 1С:ИТС.
// Исп. в расширении.
//
// Возвращаемое значение:
//   Строка
//
Функция АдресСведенияПорталИТС() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
#Иначе
	РазделениеВключено = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено;
#КонецЕсли
	
	Если РазделениеВключено Тогда
		Возврат "https://ocr.1c.ai/purchase-fresh";
	Иначе
		Возврат "https://ocr.1c.ai/purchase";
	КонецЕсли;
	
КонецФункции

// Для быстрой подмены адреса личного кабинета.
// Исп. в расширении.
//
// Возвращаемое значение:
//   Строка
//
Функция АдресЛичногоКабинета() Экспорт
	
	Возврат АдресСведенияПорталИТС();
	
КонецФункции

#КонецОбласти

#Область ПодключениеСервисовСопровождения

Функция ИдентификаторСервиса() Экспорт
	
	Возврат "1C-Document-Recognition";
	
КонецФункции

#КонецОбласти

#Область МодельРаспознанногоДокумента

// Описание реквизита модели распознанного документа.
// Если не найден - при указании СоздаватьЕслиНеНайдено = Истина будет добавлен с пустым значением.
//
Функция РеквизитДокумента(Объект, ИмяРеквизита, СоздаватьЕслиНеНайдено = Истина) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяРеквизита", ИмяРеквизита);
	НайденныеСтроки = Объект.РеквизитыДокумента.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0];
	КонецЕсли;
	
	Если Не СоздаватьЕслиНеНайдено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	НоваяСтрока = Объект.РеквизитыДокумента.Добавить();
	НоваяСтрока.ИмяРеквизита = ИмяРеквизита;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Значение реквизита модели распознанного документа.
// Если не найден - не будет добавлен и будет возвращено значение по умолчанию.
//
Функция ЗначениеРеквизитаДокумента(Объект, ИмяРеквизита, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Реквизит = РеквизитДокумента(Объект, ИмяРеквизита, Ложь);
	
	Если Реквизит = Неопределено Или Не ЗначениеЗаполнено(Реквизит.Значение) Тогда 
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат Реквизит.Значение;
	
КонецФункции

// Устанавливает значение реквизита модели распознанного документа.
// Если не найден - будет добавлен с указанным значением.
//
Процедура УстановитьЗначениеРеквизитаДокумента(Объект, ИмяРеквизита, Значение) Экспорт
	
	Реквизит = РеквизитДокумента(Объект, ИмяРеквизита);
	Реквизит.Значение = Значение;
	
КонецПроцедуры

Функция РеквизитТаблицыДокумента(Объект, НомерСтрокиТЧ, ИмяРеквизита, СоздаватьЕслиНеНайдено = Истина) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("НомерСтрокиТЧ", НомерСтрокиТЧ);
	Отбор.Вставить("ИмяРеквизита", ИмяРеквизита);
	НайденныеСтроки = Объект.РеквизитыТабличныхЧастей.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0];
	КонецЕсли;
	
	Если Не СоздаватьЕслиНеНайдено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	НоваяСтрока = Объект.РеквизитыТабличныхЧастей.Добавить();
	НоваяСтрока.НомерСтрокиТЧ = НомерСтрокиТЧ;
	НоваяСтрока.ИмяРеквизита = ИмяРеквизита;
	
	Возврат НоваяСтрока;
	
КонецФункции

Процедура УстановитьЗначениеРеквизитаТаблицыДокумента(Объект, НомерСтрокиТЧ, ИмяРеквизита, Значение) Экспорт
	
	Реквизит = РеквизитТаблицыДокумента(Объект, НомерСтрокиТЧ, ИмяРеквизита);
	Реквизит.Значение = Значение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаТабличныхЧастей

Процедура ПриИзмененииКолонки(Объект, СтрокаТаблицы, ИмяРеквизита, ВыбранноеЗначение) Экспорт
	
	СуммаВключаетНДС = ЗначениеРеквизитаДокумента(Объект, "СуммаВключаетНДС", Ложь);
	ВидСкидки = ЗначениеРеквизитаДокумента(Объект, "ВидСкидки", ВидыСкидок().НеПредоставлена);
	
	Если ИмяРеквизита = "Номенклатура" Тогда
		ПриИзмененииНоменклатура(СтрокаТаблицы, ВыбранноеЗначение);
	ИначеЕсли ИмяРеквизита = "СуммаНДС" Тогда
		ПриИзмененииСуммаНДС(СтрокаТаблицы, СуммаВключаетНДС);
	ИначеЕсли ИмяРеквизита = "Количество" ИЛИ ИмяРеквизита = "Цена" Тогда
		Если ДоступноИзменитьЗначение(СтрокаТаблицы, "Сумма") Тогда
			ЗначениеПустогоКоличества = 1;
			Количество = ?(СтрокаТаблицы.Количество = 0, ЗначениеПустогоКоличества, СтрокаТаблицы.Количество);
			СуммаСкидки = ?(ВидСкидки = ВидыСкидок().НаОтдельныеПозиции, СтрокаТаблицы.СуммаСкидки, 0);
			СтрокаТаблицы.Сумма = СтрокаТаблицы.Цена * Количество - СуммаСкидки;
			ПриИзмененииСумма(СтрокаТаблицы, СуммаВключаетНДС);
		КонецЕсли;
	ИначеЕсли ИмяРеквизита = "Сумма" Тогда
		Если ДоступноИзменитьЗначение(СтрокаТаблицы, "Цена") Тогда
			ЗначениеПустогоКоличества = 1;
			Сумма = ?(ВидСкидки = ВидыСкидок().НаОтдельныеПозиции, СтрокаТаблицы.Сумма + СтрокаТаблицы.СуммаСкидки, СтрокаТаблицы.Сумма);
			Количество = ?(СтрокаТаблицы.Количество = 0, ЗначениеПустогоКоличества, СтрокаТаблицы.Количество);
			СтрокаТаблицы.Цена = Окр(Сумма / Количество, 2);
			ПриИзмененииСумма(СтрокаТаблицы, СуммаВключаетНДС);
		КонецЕсли;
	ИначеЕсли ИмяРеквизита = "СтавкаНДС" Тогда
		ПриИзмененииСтавкаНДС(СтрокаТаблицы, СуммаВключаетНДС);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииСумма(СтрокаТаблицы, СуммаВключаетНДС) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, "СуммаНДС")
		И ДоступноИзменитьЗначение(СтрокаТаблицы, "СуммаНДС") Тогда
		
		СтрокаТаблицы.СуммаНДС = РассчитатьСуммуНДС(СтрокаТаблицы.Сумма, СуммаВключаетНДС,
			ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, "Всего")
		И ДоступноИзменитьЗначение(СтрокаТаблицы, "Всего") Тогда
		
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииСтавкаНДС(СтрокаТаблицы, СуммаВключаетНДС, ПрименяютсяСтавки4и2 = Ложь) Экспорт
	
	Если ДоступноИзменитьЗначение(СтрокаТаблицы, "СуммаНДС") Тогда 
		СтрокаТаблицы.СуммаНДС = РассчитатьСуммуНДС(СтрокаТаблицы.Сумма, СуммаВключаетНДС,
			ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, "Всего")
		И ДоступноИзменитьЗначение(СтрокаТаблицы, "Всего") Тогда
		
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииСуммаНДС(СтрокаТаблицы, СуммаВключаетНДС) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, "Всего")
		И ДоступноИзменитьЗначение(СтрокаТаблицы, "Всего") Тогда
		
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбщегоНазначения

// Заменяет в шаблоне строки имена параметров на их значения. Параметры в строке выделяются с двух сторон квадратными
// скобками.
//
// Параметры:
//  ШаблонСтроки - Строка, ФорматированнаяСтрока - строка, в которую необходимо вставить значения.
//  Параметры    - Структура - подставляемые значения параметров, где ключ - имя параметра без спецсимволов,
//                             значение - вставляемое значение.
//
// Возвращаемое значение:
//  Строка - строка со вставленными значениями.
//
// Пример:
//  Значения = Новый Структура("Фамилия,Имя", "Пупкин", "Вася");
//  Результат = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку("Здравствуй, [Имя] [Фамилия].", Значения);
//  - возвращает: "Здравствуй, Вася Пупкин".
//
Функция ВставитьПараметрыВСтроку(Знач ШаблонСтроки, Знач Параметры) Экспорт
	
	Если ТипЗнч(ШаблонСтроки) = Тип("Строка") Тогда
		
		Результат = ШаблонСтроки;
		Для Каждого Параметр Из Параметры Цикл
			Результат = СтрЗаменить(Результат, "[" + Параметр.Ключ + "]", Параметр.Значение);
		КонецЦикла;
		Возврат Результат;
		
	ИначеЕсли ТипЗнч(ШаблонСтроки) = Тип("ФорматированнаяСтрока") Тогда
		
		ФорматированныйДокумент = Новый ФорматированныйДокумент;
		ФорматированныйДокумент.УстановитьФорматированнуюСтроку(ШаблонСтроки);
		
		НаборСтрок = Новый Массив;
		
		ЗаполнитьНаборСтрокФорматированногоДокумента(НаборСтрок, Параметры, ФорматированныйДокумент.ПолучитьЭлементы());
		
#Если ВебКлиент Тогда
		Возврат Новый ФорматированнаяСтрока(НаборСтрок);
#Иначе
		Возврат ФорматированныйДокумент.ПолучитьФорматированнуюСтроку();
#КонецЕсли
		
	Иначе
		ВызватьИсключение НСтр("ru = 'Не поддерживаемый тип параметра ШаблонСтроки'");
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьНаборСтрокФорматированногоДокумента(НаборСтрок, Параметры, Элементы)
	
	Для Каждого Фрагмент Из Элементы Цикл
		
#Если ВебКлиент Тогда
		ТекущийШрифт  = Неопределено;
		ТекущийЦвет   = Неопределено;
		ТекущийФон    = Неопределено;
		ТекущаяСсылка = Неопределено;
		
		Если ТипЗнч(Фрагмент) = Тип("ТекстФорматированногоДокумента") Тогда
			
			ТелоСтроки = ВставитьПараметрыВСтроку(Фрагмент.Текст, Параметры);
			
			Фрагмент.Текст = ТелоСтроки;
			
			Если Фрагмент.Шрифт <> Новый Шрифт Тогда
				ТекущийШрифт = Фрагмент.Шрифт;
			КонецЕсли;
			
			Если Фрагмент.ЦветТекста <> Новый Цвет Тогда
				ТекущийЦвет = Фрагмент.ЦветТекста;
			КонецЕсли;
			
			Если Фрагмент.ЦветФона <> Новый Цвет Тогда
				ТекущийФон = Фрагмент.ЦветФона;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Фрагмент.НавигационнаяСсылка) Тогда
				ТекущаяСсылка = Фрагмент.НавигационнаяСсылка;
			КонецЕсли;
			
			НаборСтрок.Добавить(
				Новый ФорматированнаяСтрока(ТелоСтроки, ТекущийШрифт, ТекущийЦвет, ТекущийФон, ТекущаяСсылка)
			);
			
		ИначеЕсли ТипЗнч(Фрагмент) = Тип("КартинкаФорматированногоДокумента") Тогда
			
			НаборСтрок.Добавить(Новый ФорматированнаяСтрока(Фрагмент.Картинка));
			
		ИначеЕсли ТипЗнч(Фрагмент) = Тип("ПереводСтрокиФорматированногоДокумента") Тогда
			
			НаборСтрок.Добавить(Символы.ПС);
			
		ИначеЕсли ТипЗнч(Фрагмент) = Тип("ПараграфФорматированногоДокумента") Тогда
			
			НаборСтрок.Добавить(Символы.ПС);
			ЗаполнитьНаборСтрокФорматированногоДокумента(НаборСтрок, Параметры, Фрагмент.Элементы);
			
		КонецЕсли;
#Иначе
		Если ТипЗнч(Фрагмент) = Тип("ТекстФорматированногоДокумента") Тогда
			Фрагмент.Текст = ВставитьПараметрыВСтроку(Фрагмент.Текст, Параметры);
		КонецЕсли;
#КонецЕсли
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область УчетНДС

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Сумма            - Число - сумма от которой надо рассчитывать налоги;
//  СуммаВключаетНДС - Булево - признак включения НДС в сумму ("внутри" или "сверху");
//  СтавкаНДС        - Число - процентная ставка НДС.
//
// Возвращаемое значение:
//  Число - полученная сумма НДС.
//
Функция РассчитатьСуммуНДС(Сумма, СуммаВключаетНДС, СтавкаНДС) Экспорт

	Если СуммаВключаетНДС Тогда
		СуммаБезНДС = 100 * Сумма / (100 + СтавкаНДС);
		СуммаНДС = Сумма - СуммаБезНДС;
	Иначе
		СуммаБезНДС = Сумма;
	КонецЕсли;

	Если НЕ СуммаВключаетНДС Тогда
		СуммаНДС = СуммаБезНДС * СтавкаНДС / 100;
	КонецЕсли;
	
	Возврат Окр(СуммаНДС, 2);

КонецФункции // РассчитатьСуммуНДС()

Функция ПолучитьСтавкуНДС(СтавкаНДС) 
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	СтавкаНДСЧислом = РаспознаваниеДокументовСлужебныйВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтавкаНДС);
#Иначе
	СтавкаНДСЧислом = РаспознаваниеДокументовСлужебныйКлиентПовтИсп.ПолучитьСтавкуНДС(СтавкаНДС);
#КонецЕсли
	
	Возврат СтавкаНДСЧислом;
	
КонецФункции

#КонецОбласти

#Область СвойстваЯчеекТаблицы

Функция КлючСвойстваЯчеекТаблицы(ИмяРеквизита, НомерСтрокиТЧ) Экспорт
	
	Возврат ИмяРеквизита + "_" + Формат(НомерСтрокиТЧ, "ЧГ=");
	
КонецФункции

Функция НаборДанныхСтрокиТаблицы(СвойстваЯчеекТаблицы, НомерСтрокиТЧ) Экспорт
	
	Результат = Новый Массив;
	
	Суффикс = "_" + Формат(НомерСтрокиТЧ, "ЧГ=");
	
	Для Каждого Свойства Из СвойстваЯчеекТаблицы Цикл
		
		Если СтрЗаканчиваетсяНа(Свойства.Ключ, Суффикс) Тогда
			Результат.Добавить(Свойства.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаТабличныхЧастей

Процедура ПриИзмененииНоменклатура(СтрокаТаблицы, ВыбранноеЗначение)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		СтрокаТаблицы.Услуга = РаспознаваниеДокументовСлужебныйВызовСервера.ЭтоНоменклатураУслуга(ВыбранноеЗначение);
		Если Не СтрокаТаблицы.Услуга Тогда
			СтрокаТаблицы.Содержание = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ДоступноИзменитьЗначение(СтрокаТаблицы, ИмяРеквизита)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, ИмяРеквизита + "ЗаполненоВручную") Тогда
		Возврат Не СтрокаТаблицы[ИмяРеквизита + "ЗаполненоВручную"];
	КонецЕсли;
	
	Возврат Истина; // Если нет колонки признака заполнения вручную, то менять можно всегда.
	
КонецФункции

#КонецОбласти

#Область ПроблемныеРеквизиты

Функция ГраницаУверенныхЗначений() Экспорт
	Возврат 80;
КонецФункции

Функция ГраницаПроблемныхЗначений() Экспорт
	Возврат 50;
КонецФункции

Процедура ПересчитатьПроблемныеРеквизитыТаблицыДокумента(Форма, СтрокаТаблицы) Экспорт
	
	ДанныеШапки = Новый Структура; // Необходимые для проверки таблицы
	ДанныеШапки.Вставить("ИтогоСуммаСкидки", 0);
	ДанныеШапки.Вставить("ИтогоСумма", 0);
	ДанныеШапки.Вставить("ИтогоСуммаНДС", 0);
	ДанныеШапки.Вставить("ИтогоВсего", 0);
	ДанныеШапки.Вставить("СуммаВключаетНДС", ЗначениеРеквизитаДокумента(Форма.Объект, "СуммаВключаетНДС", Ложь));
	ДанныеШапки.Вставить("ВидСкидки", ЗначениеРеквизитаДокумента(Форма.Объект, "ВидСкидки", ВидыСкидок().НеПредоставлена));
	
	ЗаполнитьЗначенияСвойств(ДанныеШапки, Форма);
	
	ПроблемныеРеквизиты = Новый Соответствие;
	
	СсылочныеРеквизиты = Новый Массив;
	СсылочныеРеквизиты.Добавить("Номенклатура");
	СсылочныеРеквизиты.Добавить("СтавкаНДС");
	Для Каждого ИмяРеквизита Из СсылочныеРеквизиты Цикл
		Если Не ЗначениеЗаполнено(СтрокаТаблицы[ИмяРеквизита]) Тогда
			ТекстПодсказки = ПодсказкаНеНайденЭлементПоРаспознаннойСтроке();
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, ИмяРеквизита, СтрокаТаблицы.НомерСтроки, "", ТекстПодсказки);
		ИначеЕсли Не СтрокаТаблицы[ИмяРеквизита + "ЗаполненоВручную"] Тогда
			Ключ = КлючСвойстваЯчеекТаблицы(ИмяРеквизита, СтрокаТаблицы.НомерСтроки);
			Свойства = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Форма.СвойстваЯчеекТаблицы, Ключ);
			
			Если ЗначениеЗаполнено(Свойства) И Свойства.УверенностьНайденногоЗначения < ГраницаУверенныхЗначений() Тогда
				ТекстПодсказки = ПодсказкаВозможнаОшибкаСопоставленияРаспознаннойСтроки();
				ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, ИмяРеквизита, СтрокаТаблицы.НомерСтроки, "", ТекстПодсказки);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение для чисел в таблице
	ДобавитьОшибкиКоличествоЦенаСумма(ПроблемныеРеквизиты, ДанныеШапки, Форма.ТаблицаДокумента, СтрокаТаблицы);
	ДобавитьОшибкиСуммаСуммаНДСВсего(ПроблемныеРеквизиты, ДанныеШапки, Форма.ТаблицаДокумента, СтрокаТаблицы);
	
	// Проверка итогов таблицы
	ТекстПодсказки = ПодсказкаЗначениеИтогаВПодвалеНеСовпадает();
	
	Если ЕстьОшибкаВЗначенииИтогаПоТаблице(Форма.ТаблицаДокумента, "СуммаСкидки", ДанныеШапки) Тогда
		ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "ИтогоСуммаСкидки", 0, "", ТекстПодсказки);
	КонецЕсли;
	
	Если ЕстьОшибкаВЗначенииИтогаПоТаблице(Форма.ТаблицаДокумента, "Сумма", ДанныеШапки) Тогда
		ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "ИтогоСумма", 0, "", ТекстПодсказки);
	КонецЕсли;
	
	Если ЕстьОшибкаВЗначенииИтогаПоТаблице(Форма.ТаблицаДокумента, "СуммаНДС", ДанныеШапки) Тогда
		ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "ИтогоСуммаНДС", 0, "", ТекстПодсказки);
	КонецЕсли;
	
	Если ЕстьОшибкаВЗначенииИтогаПоТаблице(Форма.ТаблицаДокумента, "Всего", ДанныеШапки) Тогда
		ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "ИтогоВсего", 0, "", ТекстПодсказки);
	КонецЕсли;
	
	// Удалим решенные проблемные элементы по строке
	ИндексПроблемы = Форма.ПроблемныеЭлементы.Количество();
	Пока ИндексПроблемы > 0 Цикл
		ИндексПроблемы = ИндексПроблемы - 1;
		СтрокаПроблемы = Форма.ПроблемныеЭлементы[ИндексПроблемы];
		
		УдалитьПроблему = Ложь;
		
		Если СтрокаПроблемы.ИмяРеквизита = "ИтогоСуммаСкидки"
			Или СтрокаПроблемы.ИмяРеквизита = "ИтогоСумма"
			Или СтрокаПроблемы.ИмяРеквизита = "ИтогоСуммаНДС"
			Или СтрокаПроблемы.ИмяРеквизита = "ИтогоВсего" Тогда
			
			// Удаляем проблему по проверке итогов
			УдалитьПроблему = Истина;
		КонецЕсли;
		
		Если СтрокаПроблемы.НомерСтроки = СтрокаТаблицы.НомерСтроки Тогда
			
			// Проблема относится к редактируемой строке, остальные пропускаем.
			УдалитьПроблему = Истина;
			
			Если СтрокаПроблемы.ИмяРеквизита = "Номенклатура"
				И Не СтрокаТаблицы.НоменклатураЗаполненоВручную Тогда
				// Проблема не решена, поле не заполнено.
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Если УдалитьПроблему Тогда
			
			Ключ = СтрокаПроблемы.ИмяРеквизита + "_" + Формат(СтрокаПроблемы.НомерСтроки, "ЧГ=") + "_" + СтрокаПроблемы.ГруппаОшибки;
			
			Если ПроблемныеРеквизиты.Получить(Ключ) = Неопределено Тогда
				// В новой таблице нет старой проблемы
				Если СтрокаПроблемы.НомерСтроки = 0 Тогда
					УстановитьЦветПоляПоУмолчанию(Форма, СтрокаПроблемы.ИмяРеквизита);
				Иначе
					ОтключитьУсловноеОформление(Форма, "ТаблицаДокумента", СтрокаПроблемы);
				КонецЕсли;
				Форма.ПроблемныеЭлементы.Удалить(СтрокаПроблемы);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавим новые проблемные элементы
	Для Каждого СтрокаПроблемы Из ПроблемныеРеквизиты Цикл
		Отбор = Новый Структура("ИмяРеквизита, НомерСтроки, ГруппаОшибки");
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаПроблемы.Значение);
		
		Если Форма.ПроблемныеЭлементы.НайтиСтроки(Отбор).Количество() = 0 Тогда
			// В старой таблице нет новой проблемы
			Если СтрокаПроблемы.Значение.НомерСтроки = 0 Тогда
				УстановитьЦветИДобавитьВПроблемные(Форма, СтрокаПроблемы.Значение);
			Иначе
				ДобавитьВУсловноеОформлениеИВПроблемные(Форма, "ТаблицаДокумента", СтрокаПроблемы.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПроблемыНаФорме = Новый Соответствие; // Только те реквизиты, что видит пользователь и без учета ГруппаОшибки
	Для Каждого Строка Из Форма.ПроблемныеЭлементы Цикл
		ПроблемыНаФорме.Вставить(Строка.ИмяРеквизита + "_" + Формат(Строка.НомерСтроки, "ЧГ="));
	КонецЦикла;
	
	Форма.ОсталосьОшибок = ПроблемыНаФорме.Количество();
	
КонецПроцедуры

Функция ПодсказкаНеНайденДоговорСКонтрагентом() Экспорт
	
	Возврат НСтр("ru = 'Не найден основной договор с выбранным контрагентом'");
	
КонецФункции

Функция ПодсказкаТребуетсяВыбрать() Экспорт
	
	Возврат НСтр("ru = 'Требуется выбрать'");
	
КонецФункции

Функция ПодсказкаВозможнаОшибкаРаспознавания() Экспорт
	
	Возврат НСтр("ru = 'Возможна ошибка распознавания'");
	
КонецФункции

Функция ПодсказкаВозможнаОшибкаСопоставленияРаспознаннойСтроки() Экспорт
	
	Возврат НСтр("ru = 'Возможна ошибка сопоставления распознанной строки'");
	
КонецФункции

Функция ПодсказкаНеНайденЭлементПоРаспознаннойСтроке() Экспорт
	
	Возврат НСтр("ru = 'В базе не найден элемент соответствующий распознанной строке'");
	
КонецФункции

Функция ПодсказкаЗначениеИтогаВПодвалеНеСовпадает() Экспорт
	
	Возврат НСтр("ru = 'Значение итога в подвале не совпадает с суммой по колонке'");
	
КонецФункции

#Область ПроблемныеРеквизитыНаФорме

Процедура ДобавитьВУсловноеОформлениеИВПроблемные(Форма, ИмяТаблицы, СтрокаПроблемы) Экспорт
	
	СтрокиТаблицы = Форма[ИмяТаблицы].НайтиСтроки(Новый Структура("НомерСтроки", СтрокаПроблемы.НомерСтроки));
	Если СтрокиТаблицы.Количество() = 1 Тогда
		СтрокиТаблицы[0][СтрокаПроблемы.ИмяРеквизита + "ТекстОшибки"] = СтрокаПроблемы.ТекстПодсказки;
	Иначе
		Возврат;
	КонецЕсли;
	
	СтрокаОшибки = Форма.ПроблемныеЭлементы.Добавить();
	СтрокаОшибки.ИмяРеквизита = СтрокаПроблемы.ИмяРеквизита;
	СтрокаОшибки.НомерСтроки = СтрокаПроблемы.НомерСтроки;
	СтрокаОшибки.ГруппаОшибки = СтрокаПроблемы.ГруппаОшибки;
	СтрокаОшибки.ТекстПодсказки = СтрокаПроблемы.ТекстПодсказки;
	
КонецПроцедуры

Процедура ОтключитьУсловноеОформление(Форма, ИмяТаблицы, СтрокаПроблемы) Экспорт
	
	СтрокиТаблицы = Форма[ИмяТаблицы].НайтиСтроки(Новый Структура("НомерСтроки", СтрокаПроблемы.НомерСтроки));
	Если СтрокиТаблицы.Количество() = 1 Тогда
		СтрокиТаблицы[0][СтрокаПроблемы.ИмяРеквизита + "ТекстОшибки"] = "";
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЦветИДобавитьВПроблемные(Форма, СтрокаПроблемы) Экспорт
	
	Если СтрокаПроблемы.ИмяРеквизита = "ИтогоСуммаСкидки"
		Или СтрокаПроблемы.ИмяРеквизита = "ИтогоСумма"
		Или СтрокаПроблемы.ИмяРеквизита = "ИтогоСуммаНДС"
		Или СтрокаПроблемы.ИмяРеквизита = "ИтогоВсего" Тогда
		
		ИмяРеквизитаНаФорме = СтрокаПроблемы.ИмяРеквизита + "Красный";
		Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, ИмяРеквизитаНаФорме) Тогда
			Возврат;
		КонецЕсли;
		
		ИзменяемыйЭлемент = Форма.Элементы[ИмяРеквизитаНаФорме];
		ИзменяемыйЭлемент.Подсказка = СтрокаПроблемы.ТекстПодсказки;
		ИзменяемыйЭлемент.Родитель.Родитель.ТекущаяСтраница = ИзменяемыйЭлемент.Родитель;
	Иначе
		
		Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, СтрокаПроблемы.ИмяРеквизита) Тогда
			Возврат;
		КонецЕсли;
		
		ИзменяемыйЭлемент = Форма.Элементы[СтрокаПроблемы.ИмяРеквизита];
		ИзменяемыйЭлемент.Родитель.ЦветФона = Новый Цвет(251, 212, 212);
		ИзменяемыйЭлемент.Подсказка = СтрокаПроблемы.ТекстПодсказки;
	КонецЕсли;
	
	СтрокаОшибки = Форма.ПроблемныеЭлементы.Добавить();
	СтрокаОшибки.ИмяРеквизита = СтрокаПроблемы.ИмяРеквизита;
	СтрокаОшибки.ТекстПодсказки = СтрокаПроблемы.ТекстПодсказки;
	
КонецПроцедуры

Процедура УстановитьЦветПоляПоУмолчанию(Форма, ИмяЭлемента) Экспорт
	
	Если ИмяЭлемента = "ИтогоСуммаСкидки"
		Или ИмяЭлемента = "ИтогоСумма"
		Или ИмяЭлемента = "ИтогоСуммаНДС"
		Или ИмяЭлемента = "ИтогоВсего" Тогда
		
		СтраницаЭлемента = Форма.Элементы[ИмяЭлемента + "Белый"].Родитель;
		СтраницаЭлемента.Родитель.ТекущаяСтраница = СтраницаЭлемента;
	Иначе
		ИзменяемыйЭлемент = Форма.Элементы[ИмяЭлемента];
		ИзменяемыйЭлемент.Родитель.ЦветФона = Новый Цвет();
		ИзменяемыйЭлемент.Подсказка = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ДобавитьОшибкиКоличествоЦенаСумма(ПроблемныеРеквизиты, ДанныеШапки, ТаблицаДокумента, СтрокаТаблицы)
	
	Если ДанныеШапки.ВидСкидки = ВидыСкидок().НаОтдельныеПозиции Тогда
		
		Если СтрокаТаблицы.Количество <> 0
			И Окр(СтрокаТаблицы.Количество * СтрокаТаблицы.Цена, 2) <> СтрокаТаблицы.Сумма + СтрокаТаблицы.СуммаСкидки
			И Окр((СтрокаТаблицы.Сумма + СтрокаТаблицы.СуммаСкидки) / СтрокаТаблицы.Количество, 2) <> СтрокаТаблицы.Цена Тогда
			
			ТекстПодсказки = НСтр("ru = 'Количество * Цена - Скидка не совпадает с Сумма'");
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "Количество", СтрокаТаблицы.НомерСтроки, "Количество", ТекстПодсказки);
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "Цена", СтрокаТаблицы.НомерСтроки, "Количество", ТекстПодсказки);
			
		КонецЕсли;
		
	Иначе
	
		Если СтрокаТаблицы.Количество <> 0
			И Окр(СтрокаТаблицы.Количество * СтрокаТаблицы.Цена, 2) <> СтрокаТаблицы.Сумма
			И Окр(СтрокаТаблицы.Сумма / СтрокаТаблицы.Количество, 2) <> СтрокаТаблицы.Цена Тогда
			
			ТекстПодсказки = НСтр("ru = 'Количество * Цена не совпадает с Сумма'");
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "Количество", СтрокаТаблицы.НомерСтроки, "Количество", ТекстПодсказки);
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "Цена", СтрокаТаблицы.НомерСтроки, "Количество", ТекстПодсказки);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОшибкиСуммаСуммаНДСВсего(ПроблемныеРеквизиты, ДанныеШапки, ТаблицаДокумента, СтрокаТаблицы)
	
	Если НЕ ЗначенияСуммаСуммаНДСВсегоСовпадают(СтрокаТаблицы, ДанныеШапки.СуммаВключаетНДС) Тогда
		ТекстПодсказки = НСтр("ru = 'Сумма + Сумма НДС не совпадает с Всего'");
		
		Если НЕ СуммаИтогоПоКолонкеСовпадает(ТаблицаДокумента, "Сумма", ДанныеШапки.ИтогоСумма) Тогда
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "Сумма", СтрокаТаблицы.НомерСтроки, "Всего", ТекстПодсказки);
		КонецЕсли;
		
		Если НЕ СуммаИтогоПоКолонкеСовпадает(ТаблицаДокумента, "СуммаНДС", ДанныеШапки.ИтогоСуммаНДС) Тогда
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "СуммаНДС", СтрокаТаблицы.НомерСтроки, "Всего", ТекстПодсказки);
		КонецЕсли;
		
		Если НЕ СуммаИтогоПоКолонкеСовпадает(ТаблицаДокумента, "Всего", ДанныеШапки.ИтогоВсего) Тогда
			ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, "Всего", СтрокаТаблицы.НомерСтроки, "Всего", ТекстПодсказки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПроблемныйЭлемент(ПроблемныеРеквизиты, ИмяРеквизита, НомерСтроки = 0, ГруппаОшибки = "", ТекстПодсказки = "")
	
	Строка = Новый Структура("ИмяРеквизита, НомерСтроки, ГруппаОшибки, ТекстПодсказки");
	Строка.ИмяРеквизита = ИмяРеквизита;
	Строка.НомерСтроки = НомерСтроки;
	Строка.ГруппаОшибки = ГруппаОшибки;
	Строка.ТекстПодсказки = ТекстПодсказки;
	
	Ключ = ИмяРеквизита + "_" + Формат(НомерСтроки, "ЧГ=") + "_" + ГруппаОшибки;
	
	ПроблемныеРеквизиты.Вставить(Ключ, Строка);
	
КонецПроцедуры

Функция СуммаИтогоПоКолонкеСовпадает(КоллекцияЗаписей, ИмяКолонкиСравнения, ЗначениеДляСравнения)
	
	Возврат КоллекцияЗаписей.Итог(ИмяКолонкиСравнения) = ЗначениеДляСравнения;
	
КонецФункции

Функция ЗначенияСуммаСуммаНДСВсегоСовпадают(ПроверяемаяЗапись, СуммаВключаетНДС)
	
	Если СуммаВключаетНДС Тогда
		СтавкаНДС = ПолучитьСтавкуНДС(ПроверяемаяЗапись.СтавкаНДС);
		СуммаНДС = РассчитатьСуммуНДС(ПроверяемаяЗапись.Сумма, Истина, СтавкаНДС);
		НДСОкругленный = Окр(СуммаНДС, 2);
		
		Возврат ПроверяемаяЗапись.Сумма = ПроверяемаяЗапись.Всего И ПроверяемаяЗапись.СуммаНДС = НДСОкругленный;
	Иначе
		Возврат ПроверяемаяЗапись.Сумма + ПроверяемаяЗапись.СуммаНДС = ПроверяемаяЗапись.Всего;
	КонецЕсли;
	
КонецФункции

Функция ЕстьОшибкаВЗначенииИтогаПоТаблице(ТаблицаДокумента, ИмяКолонки, ДанныеШапки)
	
	ЗначениеИтого = ДанныеШапки["Итого" + ИмяКолонки];
	
	// Предназначена для проверки полей (ИмяКолонки =) ИтогоСумма, ИтогоСуммаНДС, ИтогоВсего, ИтогоСуммаСкидки
	
	Если ИмяКолонки = "СуммаСкидки" Тогда
		
		Если ДанныеШапки.ВидСкидки = ВидыСкидок().НаОтдельныеПозиции Тогда
			Возврат (ТаблицаДокумента.Итог(ИмяКолонки) <> ЗначениеИтого);
		КонецЕсли;
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ДанныеШапки.ВидСкидки = ВидыСкидок().ПоДокументуВЦелом Тогда
		ЗначениеИтого = ЗначениеИтого + ДанныеШапки.ИтогоСуммаСкидки;
		
		Если ИмяКолонки = "СуммаНДС" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеИтого = 0 Тогда
		Если ИмяКолонки = "СуммаНДС" Тогда
			Если ТаблицаДокумента.Итог("Сумма") = 0
				Или ТаблицаДокумента.Итог("Всего") = 0 Тогда
				
				Возврат Истина;
			КонецЕсли;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат (ТаблицаДокумента.Итог(ИмяКолонки) <> ЗначениеИтого);
	
КонецФункции

#КонецОбласти

#Область НечеткийПоиск

Функция ПолучитьСписокДляВыбораПользователем(РаспознанныйТекст, Варианты = Неопределено, КартинкаСоздание = 1) Экспорт 
	
	СписокДляВыбора = Новый СписокЗначений;
	
	Если КартинкаСоздание = 1 Тогда
		ТекстРаспознано = НСтр("ru = 'Создать: '");
		Картинка = БиблиотекаКартинок.ДобавитьЭлементСписка;
	Иначе
		ТекстРаспознано = НСтр("ru = 'Распознано: '");
		Если КартинкаСоздание = 2 Тогда 
			Картинка = БиблиотекаКартинок.Заменить;
		Иначе
			Картинка = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ТекстРаспознано = Новый ФорматированнаяСтрока(ТекстРаспознано, Новый Шрифт(,,,Истина));
	СписокДляВыбора.Добавить(РаспознанныйТекст, Новый ФорматированнаяСтрока(
		ТекстРаспознано, """", РаспознанныйТекст, """"), Ложь, Картинка);
	
	Если Варианты = Неопределено Тогда
		Возврат СписокДляВыбора;
	КонецЕсли;
	
	Для Каждого Вариант Из Варианты Цикл
		ПараметрыВыбора = Новый Структура;
		ПараметрыВыбора.Вставить("Значение", Вариант.Значение);
		ПараметрыВыбора.Вставить("Уверенность", Вариант.Уверенность);
		
		ПредставлениеЗначения = Строка(Вариант.Значение);
		
		ЕстьДополнительноеЗначение = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Вариант, "ДополнительноеЗначение");
		
		Если ЕстьДополнительноеЗначение
			И ЗначениеЗаполнено(Вариант.ДополнительноеЗначение) Тогда
			
			ПредставлениеЗначения = ПредставлениеЗначения + " (" + Строка(Вариант.ДополнительноеЗначение) + ")";
		КонецЕсли;
		
		Уверенность = Новый ФорматированнаяСтрока("(" + НСтр("ru = 'увер. '") + Вариант.Уверенность + "%)", Новый Шрифт(,,,Истина));
		ПредставлениеЗначения = Новый ФорматированнаяСтрока(ПредставлениеЗначения, " ", Уверенность);
		СписокДляВыбора.Добавить(ПараметрыВыбора, ПредставлениеЗначения);
	КонецЦикла;
	
	Возврат СписокДляВыбора;
	
КонецФункции

#КонецОбласти

#Область РаспознанныйДокумент

Функция ПолучитьНаборКоординат(Данные = Неопределено) Экспорт
	
	КоординатыКартинки = Новый Массив(4);
	
	ТипДанных = ТипЗнч(Данные);
	Если ТипДанных = Тип("Структура") И Данные.Свойство("Координаты") Тогда
		КоординатыКартинки[0] = Данные.Координаты[0];
		КоординатыКартинки[1] = Данные.Координаты[1];
		КоординатыКартинки[2] = Данные.Координаты[2];
		КоординатыКартинки[3] = Данные.Координаты[3];
	ИначеЕсли ТипДанных = Тип("ДанныеФормыЭлементКоллекции") Или (Данные <> Неопределено
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "КоординатаX0")) Тогда
		
		КоординатыКартинки[0] = Данные.КоординатаX0;
		КоординатыКартинки[1] = Данные.КоординатаY0;
		КоординатыКартинки[2] = Данные.КоординатаX1;
		КоординатыКартинки[3] = Данные.КоординатаY1;
	Иначе
		КоординатыКартинки[0] = 0;
		КоординатыКартинки[1] = 0;
		КоординатыКартинки[2] = 0;
		КоординатыКартинки[3] = 0;
	КонецЕсли;
	
	Возврат КоординатыКартинки;
	
КонецФункции

Функция НаборДанныхСозданияЭлемента(НаборДанных) Экспорт
	
	Строка = Новый Структура;
	Строка.Вставить("ИмяРеквизита");
	Строка.Вставить("НомерСтроки");
	Строка.Вставить("РаспознанныйТекст");
	Строка.Вставить("АдресКартинки");
	Строка.Вставить("СтрокВИзображении");
	Строка.Вставить("Координаты");
	Строка.Вставить("Значение");
	
	Результат = Новый Соответствие;
	Для Каждого СтрокаНабора Из НаборДанных Цикл
		
		ЗаполнитьЗначенияСвойств(Строка, СтрокаНабора);
		Строка.Координаты = ПолучитьНаборКоординат(СтрокаНабора);
		Результат.Вставить(Строка.ИмяРеквизита, Новый ФиксированнаяСтруктура(Строка));
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция ВариантОбработкиПоТипуИНаправлению(ТипДокумента, Направление) Экспорт
	
	Если ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.УПД")
		Или ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.ТОРГ12")
		Или ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.АктОбОказанииУслуг")
		Или ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетФактура") Тогда
		
		Если Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Входящий") Тогда
			ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.ПоступлениеТоваров");
		Иначе
			ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.РеализацияТоваров");
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетНаОплату") Тогда
		
		Если Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Входящий") Тогда
			ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуПоставщика");
		Иначе
			ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуКлиента");
		КонецЕсли;
		
	Иначе
		ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.ПустаяСсылка");
	КонецЕсли;
	
	Возврат ВариантОбработки;
	
КонецФункции

#КонецОбласти

Функция ПолучитьОбратноеСоответствие(СоответствиеИсточник) Экспорт
	
	СоответствиеРезультат = Новый Соответствие;
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		СоответствиеРезультат.Вставить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат СоответствиеРезультат;
	
КонецФункции

#Область ВидСкидки

Функция ВидыСкидок() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НеПредоставлена", 0);
	Результат.Вставить("НаОтдельныеПозиции", 1);
	Результат.Вставить("ПоДокументуВЦелом", 2);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

Функция ИменаРеквизитовКонтрагентИОрганизация(ДанныеДокумента) Экспорт
	
	// Ключи - Контрагент, Организация
	// Значения - сначала имена реквизитов для поиска, затем фактические значения
	Результат = Новый Структура;
	
	Если ДанныеДокумента.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетНаОплату")
		Или ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеДокумента, "ВариантОбработки")
		    И (ДанныеДокумента.ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуКлиента")
		       Или ДанныеДокумента.ВариантОбработки = ПредопределенноеЗначение("Перечисление.ВариантыОбработкиЗаданияРаспознавания.СчетНаОплатуПоставщика")) Тогда
		
		Если ДанныеДокумента.Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Исходящий") Тогда
			Результат.Вставить("Контрагент", "Покупатель");
			Результат.Вставить("Организация", "Исполнитель");
		Иначе
			Результат.Вставить("Контрагент", "Продавец");
			Результат.Вставить("Организация", "ПокупательОрганизация");
		КонецЕсли;
		
	Иначе
		
		Если ДанныеДокумента.Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Исходящий") Тогда
			Результат.Вставить("Контрагент", "Покупатель");
			Результат.Вставить("Организация", "ПродавецОрганизация");
		Иначе
			Результат.Вставить("Контрагент", "Продавец");
			Результат.Вставить("Организация", "ПокупательОрганизация");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОпределитьЮридическоеФизическоеЛицо(ИНН) Экспорт
	
	ЭтоФизЛицо = (СтрДлина(ИНН) > 10);
	
	Возврат ?(ЭтоФизЛицо,
		ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо"),
		ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"));
	
КонецФункции

#КонецОбласти