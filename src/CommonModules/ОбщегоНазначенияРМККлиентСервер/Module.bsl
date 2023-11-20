
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщиеМетоды

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Объект        - ДанныеФормыКоллекция;
//  ТекущаяСтрока - Структура - строка табличной части товаров для обработки.
//
Процедура РассчитатьСуммуНДС(Объект, ТекущаяСтрока) Экспорт
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.РассчитатьСуммуНДС(Объект, ТекущаяСтрока);
КонецПроцедуры

// Рассчитывает сумму документа с учетом НДС.
//
// Параметры:
//  Объект - ДанныеФормыКоллекция.
//
Процедура СуммаДокумента(Объект) Экспорт
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
	
	Если Не Объект.ЦенаВключаетНДС Тогда
		Объект.СуммаДокумента = Объект.СуммаДокумента + Объект.Товары.Итог("СуммаНДС");
	КонецЕсли;
	
КонецПроцедуры

// Пересчитывает сумму в строке табличной части.
//
// Параметры:
//  Объект - ДанныеФормыКоллекция.
//  ТекущаяСтрока - Структура - строка табличной части товаров для обработки.
//  СкидкиРассчитаны - Булево.
//  ИспользоватьАвтоскидки - Булево.
//
Процедура ПересчитатьСуммуВСтроке(Объект, ТекущаяСтрока, СкидкиРассчитаны = Ложь,
	ИспользоватьАвтоскидки = Ложь) Экспорт
	
	ТекущаяСтрока.СуммаБезСкидки = ТекущаяСтрока.Цена * ТекущаяСтрока.КоличествоУпаковок;
	
	СуммаТекущейСкидки = 0;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ПроцентСкидкиНаценки) Тогда
		
		ОсноваДляРасчетаСкидки = ТекущаяСтрока.СуммаБезСкидки;
		
		ТекущаяСтрока.СуммаСкидкиНаценки = (ОсноваДляРасчетаСкидки * ТекущаяСтрока.ПроцентСкидкиНаценки) / 100 + ТекущаяСтрока.СуммаОкругленияВПользуПокупателя;
		Если ТекущаяСтрока.Подарок Тогда
			СуммаТекущейСкидки  = СуммаТекущейСкидки + ТекущаяСтрока.СуммаСкидкиНаценки;
		Иначе
			СуммаТекущейСкидки = СуммаТекущейСкидки + ТекущаяСтрока.СуммаСкидкиНаценки + ТекущаяСтрока.СуммаАвтоматическойСкидки;
		КонецЕсли;
		Объект.ТекущийТоварСуммаСкидки = СуммаТекущейСкидки;
		
	ИначеЕсли ((ЗначениеЗаполнено(ТекущаяСтрока.СуммаСкидкиНаценки)
		Или ЗначениеЗаполнено(ТекущаяСтрока.СуммаАвтоматическойСкидки))
		И Не ЗначениеЗаполнено(ТекущаяСтрока.ПроцентСкидкиНаценки)) ИЛИ ЗначениеЗаполнено(ТекущаяСтрока.СуммаОкругленияВПользуПокупателя) Тогда
		
		ТекущаяСтрока.СуммаСкидкиНаценки = ТекущаяСтрока.СуммаСкидкиНаценки + ТекущаяСтрока.СуммаОкругленияВПользуПокупателя;
		СуммаТекущейСкидки = СуммаТекущейСкидки + ТекущаяСтрока.СуммаСкидкиНаценки + ТекущаяСтрока.СуммаАвтоматическойСкидки;
		Объект.ТекущийТоварСуммаСкидки = СуммаТекущейСкидки;
		
	КонецЕсли;
	
	ТекущаяСтрока.СуммаСкидокОбщая = СуммаТекущейСкидки + ТекущаяСтрока.СуммаСкидкиОплатыБонусом;
	
	ТекущаяСтрока.ПроцентСкидкиОбщий = ?(ТекущаяСтрока.СуммаБезСкидки = 0, 0, ТекущаяСтрока.СуммаСкидокОбщая/ТекущаяСтрока.СуммаБезСкидки) * 100;
		
	Если НЕ ТекущаяСтрока.ПроцентСкидкиОбщий = 0 Тогда
		ТекущаяСтрока.КартинкаПроцентов = БиблиотекаКартинок.SaleBlack;
	КонецЕсли;

	ТекущаяСтрока.ОтображаетсяСкидкаПроцентом = ЗначениеЗаполнено(ТекущаяСтрока.ПроцентСкидкиНаценки);
	ТекущаяСтрока.ОтображаетсяСкидкаСуммой =
		НЕ ТекущаяСтрока.ОтображаетсяСкидкаПроцентом И ЗначениеЗаполнено(ТекущаяСтрока.СуммаСкидкиНаценки);
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Количество * ТекущаяСтрока.Цена - ТекущаяСтрока.СуммаСкидокОбщая;
	
	УстановитьНомерКартинкиСтрокиТовара(ТекущаяСтрока);
	
КонецПроцедуры

// Возвращает текущее время, выраженное в секундах, прошедшее с начала суток
// Параметры:
//  Дата - ДатаВремя - дата, относительно которой вычисляется время
//
// Возвращаемое значение:
//  Результат - Число - количество секунд, прошедших с начала дня на момент Дата.
Функция ВремяИзДатыВСекундах(Дата) Экспорт
	Возврат Дата - НачалоДня(Дата);
КонецФункции

// Устанавливает значение свойства элемента формы, если находит элемент на форме
//
// Параметры:
//  ЭлементыФормы - ВсеЭлементыФормы - элементы формы, среди которых содержится искомый элемент.
//  ИмяЭлемента   - Строка - имя искомого элемента.
//  ИмяСвойства   - Строка - имя свойства, для которого будет устанавливаться значение.
//  Значение      - Произвольный - значение, которое будет установлено
//  УстанавливатьДляПодчиненных - Булево - установить аналогичное свойство для подчиненных элементов искомого элемента.
//
Процедура УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства,
	Значение, УстанавливатьДляПодчиненных = Ложь) Экспорт
	
	Элемент = ЭлементыФормы.Найти(ИмяЭлемента);
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НРег(ИмяСвойства) = НРег("ТолькоПросмотр")
	И ТипЗнч(Элемент) = Тип("КнопкаФормы") Тогда
	
		ИмяСвойстваЭлемента	= "Доступность";
		ЗначениеСвойства	= НЕ Значение;
		
	Иначе
		
		ИмяСвойстваЭлемента	= ИмяСвойства;
		ЗначениеСвойства	= Значение;
		
	КонецЕсли;
	
	Если НРег(ИмяСвойства) = НРег("РасширеннаяПодсказка") Тогда
		Элемент.РасширеннаяПодсказка.Заголовок = Значение;
	Иначе
		
		Если Элемент[ИмяСвойстваЭлемента] <> ЗначениеСвойства Тогда
			Элемент[ИмяСвойстваЭлемента] = ЗначениеСвойства;
		КонецЕсли;
		
	КонецЕсли;
	
	ТипыЭлементовФормыСПодчиненнымиЭлементами =
		Новый ОписаниеТипов("ФормаКлиентскогоПриложения, ГруппаФормы, ТаблицаФормы");
	
	Если УстанавливатьДляПодчиненных И ТипыЭлементовФормыСПодчиненнымиЭлементами.СодержитТип(ТипЗнч(Элемент)) Тогда
		
		ПодчиненныеЭлементы = Элемент.ПодчиненныеЭлементы;
		
		Для Каждого ПодчиненныйЭлемент Из ПодчиненныеЭлементы Цикл
			УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ПодчиненныйЭлемент.Имя, ИмяСвойства, Значение, Истина);
		КонецЦикла;
		
 	КонецЕсли;
 	
КонецПроцедуры

// Возвращает цифры номера телефона
//
// Параметры:
//   НомерТелефона - Строка - номер телефона для обработки
//
// Возвращаемое значение:
//   Результат - номер телефона, состоящий только из цифр, или  пустая строка
//
Функция ПодготовитьНомерТелефона(НомерТелефона) Экспорт
	
	Результат = "";
	
	Если НЕ ПустаяСтрока(НомерТелефона) Тогда 
		
		НомерНеСодержитПробелов = Истина;
		НужнаПостобработкаНомера = НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерТелефона,,
			НомерНеСодержитПробелов);
		
		Если НужнаПостобработкаНомера Тогда 
			
			ДлинаСтроки = СтрДлина(НомерТелефона);
			
			СтрокаСимволовЦифр = "1234567890";
			
			Результат = "";
			
			Для Индекс = 1 По ДлинаСтроки Цикл
				
				Символ = Сред(НомерТелефона, Индекс, 1);
				
				Если Найти(СтрокаСимволовЦифр, Символ) > 0 Тогда
					Результат = СтрШаблон("%1%2", Результат, Символ);
				Иначе
					Продолжить;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе 
			Результат = НомерТелефона;
		КонецЕсли;
		
		Если СтрДлина(Результат) <> 11 Тогда
			Результат = "";
		КонецЕсли;

		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// По переданной странице устанавливает ее в качестве текущей, блокирует доступность неактивных страниц
//
// Параметры:
//  Страница - ГруппаФормы - Страница которую необходимо установить в качестве текущей.
//
Процедура УстановитьТекущуюСтраницу(Страница) Экспорт
	
	Страница.Родитель.ТекущаяСтраница = Страница;
	
	СтраницыГруппы = Страница.Родитель.ПодчиненныеЭлементы;
	
	Для Каждого СтраницаГруппы Из СтраницыГруппы Цикл
		
		СтраницаГруппы.Доступность = (СтраницаГруппы = Страница);
		Если СтраницаГруппы.Имя = "СтраницаПодтверждениеВозраста"
			ИЛИ СтраницаГруппы.Имя = "СтраницаПодтверждениеВозрастаПервая"
			ИЛИ СтраницаГруппы.Имя = "СтраницаПодтверждениеВозрастаПовторная"
			ИЛИ СтраницаГруппы.Имя = "СтраницаПравоДанныеПокупателя" Тогда
				СтраницаГруппы.Видимость = (СтраницаГруппы = Страница);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Страница.Родитель.Имя = "Страницы" И ТипЗнч(Страница.Родитель.Родитель) = Тип("ФормаКлиентскогоПриложения")
		И ИнтерфейсРМКСлужебныйКлиентСервер.ИспользоватьСлои(Страница.Родитель.Родитель) Тогда
		
		Элементы = Страница.Родитель.Родитель.Элементы;
		Если Страница.Имя = "СтраницаПоискТовара" Тогда
			Элементы.ГруппаУправления.ТекущаяСтраница = Элементы.ГруппаСтраницаПоискТоваров;
		Иначе
			СтраницаКоманднойПанели = ?(Элементы.ГруппаОперации.Видимость,
									Элементы.ГруппаСтраницаОперации,
									Элементы.ГруппаКомандаДекорация);
			Если Не Элементы.ГруппаУправления.ТекущаяСтраница = СтраницаКоманднойПанели Тогда
				Элементы.ГруппаУправления.ТекущаяСтраница = СтраницаКоманднойПанели;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие реквизита или свойства у произвольного объекта без обращения к метаданным.
//
// Параметры:
//  Объект       - Произвольный - объект, у которого нужно проверить наличие реквизита или свойства;
//  ИмяРеквизита - Строка       - имя реквизита или свойства.
//
// Возвращаемое значение:
//  Булево - Истина, если есть.
//
Функция ЕстьСвойство(Объект, ИмяРеквизита) Экспорт
	
	ЕстьСвойство = Ложь;
	
	Если Не ((Объект = Неопределено) ИЛИ (ТипЗнч(Объект) = Тип("Булево")))
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Тогда
			ЕстьСвойство = Истина;
	КонецЕсли;
	
	Возврат ЕстьСвойство;
	
КонецФункции

// Возвращает вид отображения переключателя элемента интерфейса, отображающего тип Булево
//
// Возвращаемое значение:
//  Результат - ВидФлажка
//
Функция ВидОтображенияБинарногоПоля() Экспорт
	
	ВидОтображения = ВидФлажка.Флажок;
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ПереопределитьВидОтображенияНастроек(ВидОтображения);
	
	Возврат ВидОтображения;
	
КонецФункции

// Возвращает положение заголовка переключателя элемента интерфейса, отображающего тип Булево
//
// Возвращаемое значение:
//  Результат - ПоложениеЗаголовкаЭлементаФормы
//
Функция ПоложениеЗаголовкаЭлемента() Экспорт
	
	ПоложениеЗаголовкаНастроек = ПоложениеЗаголовкаЭлементаФормы.Право;
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ПереопределитьПоложениеЗаголовкаНастроек(ПоложениеЗаголовкаНастроек);
	
	Возврат ПоложениеЗаголовкаНастроек;
	
КонецФункции

// Возвращает структуру для определения вида операции.
//
// Возвращаемое значение:
//  Структура - структура с параметрами вида операции.
//
Функция ПараметрыВидаОперации() Экспорт
	
	ПараметрыВидаОперации = Новый Структура;
	ПараметрыВидаОперации.Вставить("ЭтоВозврат", Ложь);
	ПараметрыВидаОперации.Вставить("ЭтоСкупка", Ложь);
	ПараметрыВидаОперации.Вставить("ВидОперации", Неопределено);
	
	Возврат ПараметрыВидаОперации;
	
КонецФункции

// Проверяет наличие актуальных запретов продажи по данным кэша запретов 
//
// Параметры:
//  ВидНоменклатуры - ОпределяемыйТип.ВидНоменклатурыРМК - вид номенклатуры, по  которому
//    проверяется наличие запрета продаж на текущий момент.
//  ОсобенностьУчета - ОпределяемыйТип.ОсобенностьУчетаРМК - особенность учета, по которой
//    проверяется наличие запрета продаж на текущий момент.
//  КэшЗапретовПродаж - ДанныеФормыКоллекция - перечень действующих запретов продаж на текущий момент.
//
// Возвращаемое значение:
//  Результат - Структура, либо пустая, либо содержащая запреты продаж:
//		*ВремяНачалаЗапрета - Число - секунды, прошедшие с начала даты начала запрета
//		*ВремяОкончанияЗапрета - Число  - секунды, прошедшие с начала даты окончания запрета
//		*ВидНоменклатуры - ОпределяемыйТип.ВидНоменклатурыРМК - категория, к которой относится запрет.
//
Функция НаличиеЗапретовПродажи(ВидНоменклатуры, ОсобенностьУчета, КэшЗапретовПродаж) Экспорт
	
	Результат = Новый Структура;
	МассивСтрок = Новый Массив;
	
	Для Каждого Строка Из КэшЗапретовПродаж Цикл
		
		Если ЗначениеЗаполнено(Строка.ВидНоменклатуры) И ЗначениеЗаполнено(Строка.ОсобенностьУчета) Тогда
			
			Если ВидНоменклатуры = Строка.ВидНоменклатуры И ОсобенностьУчета = Строка.ОсобенностьУчета Тогда
				МассивСтрок.Добавить(Строка);
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Строка.ВидНоменклатуры) И Не ЗначениеЗаполнено(Строка.ОсобенностьУчета) Тогда
			
			Если ВидНоменклатуры = Строка.ВидНоменклатуры Тогда
				МассивСтрок.Добавить(Строка);
			КонецЕсли;
		
		ИначеЕсли Не ЗначениеЗаполнено(Строка.ВидНоменклатуры) И ЗначениеЗаполнено(Строка.ОсобенностьУчета) Тогда
			
			Если ОсобенностьУчета = Строка.ОсобенностьУчета Тогда
				МассивСтрок.Добавить(Строка);
			КонецЕсли;
		
		ИначеЕсли Не ЗначениеЗаполнено(Строка.ВидНоменклатуры) И Не ЗначениеЗаполнено(Строка.ОсобенностьУчета) Тогда
			
			МассивСтрок.Добавить(Строка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивСтрок.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = УсловияЗапретаПродажиТовара(МассивСтрок, ВидНоменклатуры);
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если сервер запущен на Linux.
//
// Возвращаемое значение:
//  Булево - признак использования Linux сервера.
//
Функция ЭтоLinuxСервер() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	ЭтоLinuxСервер = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
		ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64;
	Возврат ЭтоLinuxСервер;
	
КонецФункции

// Определяет является ли переданная особенность учета пивной продукцией.
//
// Параметры:
//  ОсобенностьУчета - ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК - особенность учета.
//
// Возвращаемое значение:
//  Булево - Истина, если особенность учета является пивной продукцией.
//
Функция ЭтоПивнаяПродукция(ОсобенностьУчета) Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ОпределитьОсобенностьУчетаПивнаяПродукция(ОсобенностьУчета, Результат);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область КомпоновкаДанных

// Удаляет все элементы настройки компоновки данных из объекта.
//
// Параметры:
//  Настройки - НастройкиКомпоновкиДанных,
//		КомпоновщикНастроекКомпоновкиДанных,
//		ПользовательскиеНастройкиКомпоновкиДанных - настройки для удаления и очистки.
//
Процедура ОчиститьНастройкиКомпоновкиДанных(Настройки) Экспорт
	
	Если Настройки = Неопределено Или ТипЗнч(Настройки) <> Тип("НастройкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Параметр Из Настройки.ПараметрыДанных.Элементы Цикл
		
		Параметр.Значение = Неопределено;
		Параметр.Использование = Ложь;
		
	КонецЦикла;
	
	Для каждого Параметр Из Настройки.ПараметрыВывода.Элементы Цикл
		Параметр.Использование = Ложь;
	КонецЦикла;
	
	Настройки.ПользовательскиеПоля.Элементы.Очистить();
	Настройки.Отбор.Элементы.Очистить();
	Настройки.Порядок.Элементы.Очистить();
	Настройки.Выбор.Элементы.Очистить();
	Настройки.Структура.Очистить();
	
КонецПроцедуры

// Копирует настройки компоновки данных.
//
// Параметры:
//  НастройкиПриемник - НастройкиКомпоновкиДанных - настройки приемник.
//  НастройкиИсточник - НастройкиКомпоновкиДанных - настройки источник.
// 
Процедура СкопироватьНастройкиКомпоновкиДанных(НастройкиПриемник, НастройкиИсточник) Экспорт
	
	Если НастройкиИсточник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(НастройкиПриемник) = Тип("НастройкиКомпоновкиДанных") Тогда
		
		Для каждого Параметр Из НастройкиИсточник.ПараметрыДанных.Элементы Цикл
			
			ЗначениеПараметра = НастройкиПриемник.ПараметрыДанных.НайтиЗначениеПараметра(Параметр.Параметр);
			Если ЗначениеПараметра <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ЗначениеПараметра, Параметр);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		
		ЗаполнитьЗначенияСвойств(НастройкиПриемник, НастройкиИсточник);
		СкопироватьНастройкиКомпоновкиДанных(НастройкиПриемник.Настройки, НастройкиИсточник.Настройки);
		Возврат;
		
	КонецЕсли;
	
	// Копирование настроек
	Если ТипЗнч(НастройкиИсточник) = Тип("НастройкиКомпоновкиДанных") Тогда
		
		ЗаполнитьЭлементы(НастройкиПриемник.ПараметрыДанных, НастройкиИсточник.ПараметрыДанных);
		СкопироватьЭлементы(НастройкиПриемник.ПользовательскиеПоля, НастройкиИсточник.ПользовательскиеПоля);
		СкопироватьЭлементы(НастройкиПриемник.Отбор, НастройкиИсточник.Отбор);
		СкопироватьЭлементы(НастройкиПриемник.Порядок, НастройкиИсточник.Порядок);
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаКомпоновкиДанных")
		ИЛИ ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
		ИЛИ ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		
		СкопироватьЭлементы(НастройкиПриемник.ПоляГруппировки, НастройкиИсточник.ПоляГруппировки);
		СкопироватьЭлементы(НастройкиПриемник.Отбор, НастройкиИсточник.Отбор);
		СкопироватьЭлементы(НастройкиПриемник.Порядок, НастройкиИсточник.Порядок);
		ЗаполнитьЗначенияСвойств(НастройкиПриемник, НастройкиИсточник);
		
	КонецЕсли;
	
	СкопироватьЭлементы(НастройкиПриемник.Выбор, НастройкиИсточник.Выбор);
	СкопироватьЭлементы(НастройкиПриемник.УсловноеОформление, НастройкиИсточник.УсловноеОформление);
	ЗаполнитьЭлементы(НастройкиПриемник.ПараметрыВывода, НастройкиИсточник.ПараметрыВывода);
	
	// Копирование структуры
	Если ТипЗнч(НастройкиИсточник) = Тип("НастройкиКомпоновкиДанных")
		ИЛИ ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаКомпоновкиДанных") Тогда
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Структура Цикл
			
			ЭлементСтруктурыПриемник = НастройкиПриемник.Структура.Добавить(ТипЗнч(ЭлементСтруктурыИсточник));
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
		ИЛИ ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Структура Цикл
			
			ЭлементСтруктурыПриемник = НастройкиПриемник.Структура.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		Для Каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Строки Цикл
			
			ЭлементСтруктурыПриемник = НастройкиПриемник.Строки.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
			
		КонецЦикла;
		
		Для Каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Колонки Цикл
			
			ЭлементСтруктурыПриемник = НастройкиПриемник.Колонки.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		Для Каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Серии Цикл
			
			ЭлементСтруктурыПриемник = НастройкиПриемник.Серии.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
			
		КонецЦикла;
		
		Для Каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Точки Цикл
			
			ЭлементСтруктурыПриемник = НастройкиПриемник.Точки.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Копирует элементы из одной коллекции в другую.
//
// Параметры:
//  ПриемникЗначения - ВариантыПользовательскогоПоляВыборКомпоновкиДанных,
//					   УсловноеОформлениеКомпоновкиДанных,
//					   ОформляемыеПоляКомпоновкиДанных,
//					   ЗначенияПараметровДанныхКомпоновкиДанных - настройки компоновщика настроек.
//  ИсточникЗначения - ВариантыПользовательскогоПоляВыборКомпоновкиДанных,
//					   УсловноеОформлениеКомпоновкиДанных,
//					   ОформляемыеПоляКомпоновкиДанных,
//					   ЗначенияПараметровДанныхКомпоновкиДанных - параметр для получения.
//  ПроверятьДоступность - Булево - признак проверки доступности элементов.
//  ОчищатьПриемник - Булево - признак очищения приемника значений.
//
Процедура СкопироватьЭлементы(ПриемникЗначения, ИсточникЗначения, ПроверятьДоступность = Ложь,
	ОчищатьПриемник = Истина) Экспорт
	
	СоздаватьПоТипу = НЕ (ТипЗнч(ИсточникЗначения) = Тип("УсловноеОформлениеКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ВариантыПользовательскогоПоляВыборКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ОформляемыеПоляКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ЗначенияПараметровДанныхКомпоновкиДанных"));
	
	ПриемникЭлементов = ПриемникЗначения.Элементы;
	ИсточникЭлементов = ИсточникЗначения.Элементы;
	
	Если ОчищатьПриемник Тогда
		ПриемникЭлементов.Очистить();
	КонецЕсли;
	
	Для Каждого ЭлементИсточник Из ИсточникЭлементов Цикл
		
		Если ТипЗнч(ЭлементИсточник) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
			
			// Элементы порядка добавляем в начало.
			Индекс = ИсточникЭлементов.Индекс(ЭлементИсточник);
			ЭлементПриемник = ПриемникЭлементов.Вставить(Индекс, ТипЗнч(ЭлементИсточник));
			
		Иначе
			
			ЭлементПриемник = ?(СоздаватьПоТипу,
				ПриемникЭлементов.Добавить(ТипЗнч(ЭлементИсточник)),
				ЭлементПриемник = ПриемникЭлементов.Добавить());
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		
		// В некоторых коллекциях необходимо заполнить другие коллекции.
		Если ТипЗнч(ИсточникЭлементов) = Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных") Тогда
			
			СкопироватьЭлементы(ЭлементПриемник.Поля, ЭлементИсточник.Поля);
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
			ЗаполнитьЭлементы(ЭлементПриемник.Оформление, ЭлементИсточник.Оформление);
			
		ИначеЕсли ТипЗнч(ИсточникЭлементов)	= Тип("КоллекцияВариантовПользовательскогоПоляВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
		КонецЕсли;
		
		// В некоторых элементах коллекции необходимо заполнить другие коллекции.
		Если ТипЗнч(ЭлементИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Варианты, ЭлементИсточник.Варианты);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			
			ЭлементПриемник.УстановитьВыражениеДетальныхЗаписей (ЭлементИсточник.ПолучитьВыражениеДетальныхЗаписей());
			ЭлементПриемник.УстановитьВыражениеИтоговыхЗаписей(ЭлементИсточник.ПолучитьВыражениеИтоговыхЗаписей());
			ЭлементПриемник.УстановитьПредставлениеВыраженияДетальныхЗаписей(
				ЭлементИсточник.ПолучитьПредставлениеВыраженияДетальныхЗаписей());
			ЭлементПриемник.УстановитьПредставлениеВыраженияИтоговыхЗаписей(
				ЭлементИсточник.ПолучитьПредставлениеВыраженияИтоговыхЗаписей());
				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Рекурсивная процедура заполнения элементов.
//
// Параметры:
//  ПриемникЗначения - КоллекцияЗначенийПараметровКомпоновкиДанных
//  ИсточникЗначения - КоллекцияЗначенийПараметровКомпоновкиДанных
//  ПервыйУровень - КоллекцияЗначенийПараметровКомпоновкиДанных
//
Процедура ЗаполнитьЭлементы(ПриемникЗначения, ИсточникЗначения, ПервыйУровень = Неопределено) Экспорт
	
	КоллекцияЗначений = ?(ТипЗнч(ПриемникЗначения) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных"),
		ИсточникЗначения,
		ИсточникЗначения.Элементы);
	
	Для Каждого ЭлементИсточник Из КоллекцияЗначений Цикл
		
		ЭлементПриемник = ?(ПервыйУровень = Неопределено,
			ПриемникЗначения.НайтиЗначениеПараметра(ЭлементИсточник.Параметр),
				ПервыйУровень.НайтиЗначениеПараметра(ЭлементИсточник.Параметр));
		
		Если ЭлементПриемник = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		Если ТипЗнч(ЭлементИсточник) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
			
			Если ЭлементИсточник.ЗначенияВложенныхПараметров.Количество() <> 0 Тогда
				ЗаполнитьЭлементы(ЭлементПриемник.ЗначенияВложенныхПараметров,
					ЭлементИсточник.ЗначенияВложенныхПараметров, ПриемникЗначения);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Интеграция_с_API_Программный_интерфейс

#Область Интеграция_с_API_десериализация_ответов

// Возвращает результат обработки данных из ответа по умолчанию 
//
// Возвращаемое значение:
//  Результат - Структура:
//		*ВыполнениеУспешно - Булево
//		*Комментарий - Строка - дополнительная информация о состоянии выполнения
//
Функция РезультатОбработкиДанныхПоУмолчанию() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ВыполнениеУспешно", Ложь);
	Результат.Вставить("Комментарий", НСтр("ru = ''"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Интеграция_с_API_методы_вызова

// Получает данные из сервера лояльности 
//
// Параметры:
//  НастройкаРабочегоМестаКассира - СправочникСсылка.НастройкиРМК - содержит исходные данные для подключения 
//									к сервису лояльности, признак запрета редактирования условий продаж
//  ТорговыйОбъект - СправочникСсылка.ТорговыйОбъект, Неопределено - торговый объект для отбора перечня ограничений
//
// Возвращаемое значение:
//  Результат - Структура:
//		*ДанныеОтвета - Строка
//		*ЕстьОшибки - Булево
//		*ТекстОшибки - Строка
//
Функция ПолучитьДанныеЗапретовРедактирования(НастройкаРабочегоМестаКассира = Неопределено,
	ТорговыйОбъект = Неопределено) Экспорт
	
	Результат = СерверЛояльностиПолучательДанныхКлиентСервер.РезультатВыполненияЗапросаПоУмолчанию();
	
	// Получить из настроек РМК адрес сервиса, логин и пароль из защищенного хранилища
	ПараметрыПодключенияКСерверуЛояльности =
		ОбщегоНазначенияРМКВызовСервера.ЗначенияПараметровСервераЛояльности(НастройкаРабочегоМестаКассира);
		
	Если СерверЛояльностиПолучательДанныхКлиентСервер.ПараметрыВыполненияЗапросаКорректны(ПараметрыПодключенияКСерверуЛояльности) Тогда

		ЗначенияПараметровМетода = СерверЛояльностиПолучательДанныхКлиентСервер.ПараметрыМетодовБонуснойПодсистемы();
		Если ЗначениеЗаполнено(ТорговыйОбъект) Тогда
			ЗначенияПараметровМетода.Вставить("Store", Строка(ТорговыйОбъект.УникальныйИдентификатор()));
		КонецЕсли;
		
		ПараметрыВыполненияЗапроса = СерверЛояльностиПолучательДанныхКлиентСервер.ПараметрыЗапросаДанныеЗапретовРедактирования(ПараметрыПодключенияКСерверуЛояльности, ЗначенияПараметровМетода);
		Результат = СерверЛояльностиПолучательДанныхКлиентСервер.ВыполнитьЗапросКСерверуЛояльности(ПараметрыВыполненияЗапроса);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обновляет данные запретов продаж
//
// Параметры:
//  НастройкаРабочегоМестаКассира - СправочникСсылка.НастройкиРМК
//  ТорговыйОбъект - СправочникСсылка.ТорговыйОбъект, Неопределено - торговый объект для отбора перечня ограничений
//
// Возвращаемое значение:
//  Результат - Структура:
//		*ПризнакУспешноОбновлен - Булево
//		*КомментарийКОбновлениюПризнака - Строка
//		*ЗапретыПродажУспешноЗагружены - Булево
//		*КомментарийОбновленияЗапретов - Строка
//
Функция ОбновитьДанныеЗапретовРедактирования(НастройкаРабочегоМестаКассира = Неопределено,
	ТорговыйОбъект = Неопределено) Экспорт

	Результат = Новый Структура();
	Результат.Вставить("ПризнакУспешноОбновлен", Ложь);
	Результат.Вставить("КомментарийКОбновлениюПризнака", НСтр("ru = ''"));
	Результат.Вставить("ЗапретыПродажУспешноЗагружены", Ложь);
	Результат.Вставить("КомментарийОбновленияЗапретов", НСтр("ru = ''"));
	
	ДанныеОтветаСервиса = ПолучитьДанныеЗапретовРедактирования(НастройкаРабочегоМестаКассира, ТорговыйОбъект);
	
	Если Не ДанныеОтветаСервиса.ЕстьОшибки Тогда
		
		ДанныеОтвета = Неопределено;
		СтрокаJSON = ДанныеОтветаСервиса.ДанныеОтвета;
		СерверЛояльностиПолучательДанныхКлиентСервер.ОбработатьJSON(СтрокаJSON, ДанныеОтвета);
		
		РезультатОбработки = ОбработатьДанныеЗапретовИзОтвета(ДанныеОтвета, НастройкаРабочегоМестаКассира);
		ЗаполнитьЗначенияСвойств(Результат, РезультатОбработки);

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

// Формирует данные о запрете для последующей передачи в интерфейс
//
// Параметры:
//  ПереченьЗапретов - ТаблицаЗначений - данные запретов, определенных как действующие;
//  ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - категория, к которой относится запрет.
//
// Возвращаемое значение:
//  Результат - Структура:
//		*ВремяНачалаЗапрета - Дата - дата начала запрета
//		*ВремяОкончанияЗапрета - Дата - дата окончания запрета
//		*ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - категория запрета
//		либо пустая структура при отсутствии
//
Функция УсловияЗапретаПродажиТовара(ПереченьЗапретов, ВидНоменклатуры) Экспорт
	
	Результат = Новый Структура();
	
	// АПК:547-выкл. код обусловлен необходимостью вызова ТекущаяДатаСеанса()
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		МоментПроверки = ТекущаяДатаСеанса();
	#Иначе
		МоментПроверки = ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли
	// АПК:547-вкл.
	
	ВремяПроверки = ОбщегоНазначенияРМККлиентСервер.ВремяИзДатыВСекундах(МоментПроверки);
	ТекущийДеньНедели = ДеньНеделиПеречислением(МоментПроверки);
	
	Для Каждого Запрет Из ПереченьЗапретов Цикл
		
		ВремяНачалаЗапрета = ОбщегоНазначенияРМККлиентСервер.ВремяИзДатыВСекундах(Запрет.ВремяНачала);
		ВремяОкончанияЗапрета = ОбщегоНазначенияРМККлиентСервер.ВремяИзДатыВСекундах(Запрет.ВремяОкончания);
		ДеньНеделиЗапрета = Запрет.ДеньНедели;
		
		ЭтоДеньЗапрета = (НЕ ЗначениеЗаполнено(ДеньНеделиЗапрета))
			ИЛИ (ЗначениеЗаполнено(ДеньНеделиЗапрета) И ДеньНеделиЗапрета = ТекущийДеньНедели);
		
		Если ЭтоДеньЗапрета И ВремяПроверки >= ВремяНачалаЗапрета И ВремяПроверки <= ВремяОкончанияЗапрета Тогда
			
			Результат.Вставить("ВремяНачалаЗапрета", ВремяНачалаЗапрета);
			Результат.Вставить("ВремяОкончанияЗапрета", ВремяОкончанияЗапрета);
			Результат.Вставить("ВидНоменклатуры", ВидНоменклатуры);
			
			Возврат Результат;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Поясняющие_надписи_ПрограммныйИнтерфейс

// Возвращает текст подсказки к настройке управления запретами продаж
//
// Возвращаемое значение:
//  ТекстПодсказки - Строка - текст подсказки
//
Функция ТекстПодсказкиНастройкиЗапретовПродаж() Экспорт
	
	ТекстПодсказки = НСтр("ru = 'Ограничение продажи товаров определенного вида по настроенному расписанию.'");
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ЗаполнитьТекстПодсказкиНастройкиЗапретовПродаж(ТекстПодсказки);
	
	Возврат ТекстПодсказки;
	
КонецФункции

// Формирует коллекцию для дополнения сообщения об отсутствующих в программе данных гиперссылками
//
// Возвращаемое значение:
//  Результат - Структура:
//		* ИмяСущности - Строка - имя отсутствующей сущности
//		* ДанныеДополнения - ФорматированнаяСтрока - данные с гиперссылкой на форму списка сущности.
//
Функция ДанныеДополненияПредупреждения() Экспорт

	Результат = Новый Структура();
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ЗаполнитьДанныеДополненияПредупреждения(Результат);
	Возврат Результат;

КонецФункции

#КонецОбласти

// Рассчитывает и устанавливает номер картинки из коллекции картинок "РМКСтатусТовара"
// в зависимости от значений реквизитов строки.
//
// Параметры:
//  СтрокаТовара - Структура - строка табличной части товаров формы РМК для обработки.
//
Процедура УстановитьНомерКартинкиСтрокиТовара(СтрокаТовара) Экспорт

	СтрокаТовара.ИндексКартинки = ВычислитьНомерКартинкиСтатусТовара(СтрокаТовара);

КонецПроцедуры

// Возвращает массив номиналов используемых купюр
//
// Возвращаемое значение:
//  Массив - массив строк - номиналов используемых купюр
//
Функция НоминалыКупюр() Экспорт
	
	СтрокаНоминалов = НСтр("ru = '10,50,100,200,500,1000,2000,5000'");
	Возврат СтрРазделить(СтрокаНоминалов, ",");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Общие_методы_СлужебныеПроцедурыИФункции

// Возвращает день недели по дате 
//
// Параметры:
//  Дата - Дата - дата, по которой определяется значение дня
//
// Возвращаемое значение:
//  Результат - ПеречислениеСсылка.ДниНедели
//
Функция ДеньНеделиПеречислением(Дата)
	
	Результат = Неопределено;
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ЗаполнитьДеньНеделиПеречислением(Результат, Дата);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Интеграция_с_API_служебные

#Область Интеграция_с_API_методы_вызова

Функция ОбработатьДанныеЗапретовИзОтвета(ИсходныеДанные, НастройкиРабочегоМестаКассира = Неопределено)
	Возврат ОбщегоНазначенияРМКВызовСервера.ОбработатьДанныеЗапретовИзОтвета(ИсходныеДанные,
		НастройкиРабочегоМестаКассира);
КонецФункции

#КонецОбласти

#КонецОбласти

Функция ВычислитьНомерКартинкиСтатусТовара(СтрокаТовара)

	// Номер картинки и значение картинки из коллекции "РМКСтатусТовара" в порядке приоритета
	// 12 - Требуется ввод маркировки
	//  0 - Требуется ввод серии
	//  3 - Требуется ввод партии
	// 18 - Не заполнено количество и цена
	// 16 - Не заполнена цена
	// 17 - Не заполнено количество
	// 19 - это агентская услуга
	// 20 - это комиссионный товар
	// 14 - Подарок в составе чека
	// 15 - Подарок вне чека
	//  6 - ЭтоНабор
	// 13 - Маркировка не обязательна
	//  2 - Серия не обязательна
	//  5 - Партия не обязательна
	// 11 - Маркировка введена
	//  1 - Серия введена
	//  4 - Партия введена
	
	ИндексКартинки = -1;
	
	Если СтрокаТовара.НеобходимостьВводаКодаМаркировки И СокрЛП(СтрокаТовара.КодМаркировки) = "" Тогда
		ИндексКартинки = 12;
	ИначеЕсли СтрокаТовара.НеобходимостьВводаСерии И СтрокаТовара.ПроверятьЗаполнениеСерий И Не ЗначениеЗаполнено(СтрокаТовара.Серия) Тогда
		ИндексКартинки = 0;
	ИначеЕсли СтрокаТовара.ИспользоватьПартии И СтрокаТовара.ПроверятьЗаполнениеПартий И Не ЗначениеЗаполнено(СтрокаТовара.Партия) Тогда
		ИндексКартинки = 3;
	ИначеЕсли СтрокаТовара.Цена = 0 И СтрокаТовара.Количество = 0 И Не СтрокаТовара.Подарок Тогда
		ИндексКартинки = 18;
	ИначеЕсли СтрокаТовара.Цена = 0 И Не СтрокаТовара.Подарок Тогда
		ИндексКартинки = 16;
	ИначеЕсли СтрокаТовара.Количество = 0 Тогда
		ИндексКартинки = 17;
	ИначеЕсли ЗначениеЗаполнено(СтрокаТовара.Поставщик) Тогда
		Если СтрокаТовара.ЭтоАгентскаяУслуга Тогда
			ИндексКартинки = 19;
		Иначе
			ИндексКартинки = 20;
		КонецЕсли;
	ИначеЕсли СтрокаТовара.Подарок И СтрокаТовара.ВыводитьПодарокВЧек Тогда
		ИндексКартинки = 14;
	ИначеЕсли СтрокаТовара.Подарок Тогда
		ИндексКартинки = 15;
	ИначеЕсли СтрокаТовара.ЭтоНабор Тогда
		ИндексКартинки = 6;
	ИначеЕсли СтрокаТовара.НеобходимостьВводаСерии И Не ЗначениеЗаполнено(СтрокаТовара.Серия) Тогда
		ИндексКартинки = 2;
	ИначеЕсли СтрокаТовара.ИспользоватьПартии И Не ЗначениеЗаполнено(СтрокаТовара.Партия) Тогда
		ИндексКартинки = 5;
	ИначеЕсли СтрокаТовара.НеобходимостьВводаКодаМаркировки И Не СокрЛП(СтрокаТовара.КодМаркировки) = "" Тогда
		ИндексКартинки = 11;
	ИначеЕсли СтрокаТовара.НеобходимостьВводаСерии И ЗначениеЗаполнено(СтрокаТовара.Серия) Тогда
		ИндексКартинки = 1;
	ИначеЕсли СтрокаТовара.ИспользоватьПартии И ЗначениеЗаполнено(СтрокаТовара.Партия) Тогда
		ИндексКартинки = 4;
	КонецЕсли;
	
	Возврат ИндексКартинки;
	
КонецФункции

#КонецОбласти




