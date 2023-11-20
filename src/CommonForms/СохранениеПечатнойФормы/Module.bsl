///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОграниченийФорматовСохранения = СтрРазделить(Параметры.ОграничениеФорматовСохранения, ",", Ложь);
	
	// заполнение списка форматов
	Для Каждого ФорматСохранения Из УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
		Если Не МассивОграниченийФорматовСохранения.Количество()
			ИЛИ МассивОграниченийФорматовСохранения.Найти(ФорматСохранения.Расширение) <> Неопределено Тогда
				
			ВыбранныеФорматыСохранения.Добавить(Строка(ФорматСохранения.ТипФайлаТабличногоДокумента), ФорматСохранения.Представление, Ложь, ФорматСохранения.Картинка);
		КонецЕсли;
	КонецЦикла;
	ВыбранныеФорматыСохранения[0].Пометка = Истина; // По умолчанию выбран только первый формат из списка.
	
	Если ВыбранныеФорматыСохранения.Количество() = 1 Тогда
		Элементы.ГруппаВыборФорматов.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезВыбораФормата");
	ИначеЕсли ВыбранныеФорматыСохранения.Количество() > 1 Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "");
	КонецЕсли;
	
	// Место сохранения по умолчанию.
	ВариантСохранения = "СохранитьВПапку";
	
	// настройка видимости
	ЕстьВозможностьСохранения = Параметры.ОбъектыПечати.Количество() > 0;
	
	ОбъектыПрикрепления = ПолучитьОбъектыДляПрикрепления(Параметры.ОбъектыПечати);
	Если Параметры.ОбъектыПечати.Количество() = 1 Тогда
		ЕстьВозможностьПрисоединения = ОбъектыПрикрепления[0].Пометка;
	ИначеЕсли ЕстьВозможностьСохранения Тогда
		ЕстьВозможностьПрисоединения = Ложь;
		Для Каждого ОбъектДляПрикрепления Из ОбъектыПрикрепления Цикл
			ЕстьВозможностьПрисоединения = ЕстьВозможностьПрисоединения Или ОбъектДляПрикрепления.Пометка;			
		КонецЦикла;
	Иначе
		ЕстьВозможностьПрисоединения = Ложь;
	КонецЕсли;
	
	Если Не ЕстьВозможностьПрисоединения Тогда
		Элементы.ВариантСохранения.СписокВыбора.Удалить(1);
		ВариантСохранения = "СохранитьВПапку";
		Элементы.ВариантСохранения.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ВыборМестаСохраненияФайла.Видимость = Параметры.РасширениеДляРаботыСФайламиПодключено 
		Или ЕстьВозможностьСохранения;
	Элементы.ВариантСохранения.Видимость = ЕстьВозможностьСохранения;
	Если Не ЕстьВозможностьСохранения Тогда
		Элементы.ПапкаДляСохраненияФайлов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	Элементы.ПапкаДляСохраненияФайлов.Видимость = Параметры.РасширениеДляРаботыСФайламиПодключено;
	
	Если Параметры.ОбъектыПечати.Количество() > 1 Тогда
		Элементы.ВариантСохранения.СписокВыбора[1].Представление = НСтр("ru='Присоединить к документам'")
								+ " (" + Формат(Параметры.ОбъектыПечати.Количество(), "ЧДЦ=0;") + ")";
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		Элементы.КнопкаСохранить.Отображение = ОтображениеКнопки.Картинка;
		Элементы.Подписать.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ВыбранныеФорматыСохранения.Количество() <> 1 Тогда
		ФорматыСохраненияИзНастроек = Настройки["ВыбранныеФорматыСохранения"];
		Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
			Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл 
				ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
				Если ФорматИзНастроек <> Неопределено Тогда
					ВыбранныйФормат.Пометка = ФорматИзНастроек.Пометка;
				КонецЕсли;
			КонецЦикла;
			Настройки.Удалить("ВыбранныеФорматыСохранения");
		КонецЕсли;
	Иначе
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
	
	Если Элементы.ВариантСохранения.ТолькоПросмотр Тогда
		Настройки["ВариантСохранения"] = "СохранитьВПапку"; 
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Настройки["Подписать"] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	Если ВыбранныеФорматыСохранения.Количество() = 1 Тогда
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьСтраницуМестаСохранения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантСохраненияПриИзменении(Элемент)
	УстановитьСтраницуМестаСохранения();
	ОчиститьСообщения();
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляСохраненияФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ВыбраннаяПапка = Элемент.ТекстРедактирования;
	ФайловаяСистемаКлиент.ВыбратьКаталог(Новый ОписаниеОповещения("ПапкаДляСохраненияФайловЗавершениеВыбора", ЭтотОбъект), , ВыбраннаяПапка);
	
КонецПроцедуры

// Обработчик завершения выбора каталога сохраненных файлов.
//  См. Синтакс-помощник: ДиалогВыбораФайла.Показать().
//
&НаКлиенте
Процедура ПапкаДляСохраненияФайловЗавершениеВыбора(Папка, ДополнительныеПараметры) Экспорт 
	Если Не ПустаяСтрока(Папка) Тогда 
		ВыбраннаяПапка = Папка;
		ОчиститьСообщения();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Элементы.ПапкаДляСохраненияФайлов.Видимость Тогда
		Если ВариантСохранения = "СохранитьВПапку" И ПустаяСтрока(ВыбраннаяПапка) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите папку.'"),,"ВыбраннаяПапка");
			Возврат;
		КонецЕсли;
	КонецЕсли;
		
	ФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ФорматыСохранения.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Укажите как минимум один из предложенных форматов.'"));
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	РезультатВыбора.Вставить("ФорматыСохранения", ФорматыСохранения);
	РезультатВыбора.Вставить("ВариантСохранения", ВариантСохранения);
	РезультатВыбора.Вставить("ПапкаДляСохранения", ВыбраннаяПапка);
	РезультатВыбора.Вставить("ПереводитьИменаФайловВТранслит", ПереводитьИменаФайловВТранслит);
	РезультатВыбора.Вставить("Подписать", Подписать);
	
	Если ВариантСохранения = "Присоединить" Тогда
		СтрокаОшибки = "";
		ОбъектыДляПрикрепления = Новый Соответствие; 
		Для Каждого ОбъектПрикрепления Из ОбъектыПрикрепления Цикл
			Если Не ОбъектПрикрепления.Пометка Тогда
				СтрокаОшибки = СтрокаОшибки + ОбъектПрикрепления.Значение;
			Иначе
				ОбъектыДляПрикрепления.Вставить(ОбъектПрикрепления.Значение, Истина);
			КонецЕсли;
		КонецЦикла;
		
		РезультатВыбора.Вставить("ОбъектыДляПрикрепления", ОбъектыДляПрикрепления);
		
		Если СтрокаОшибки <> "" Тогда
			ОписаниеОповещенияПродолжениеСохранения = Новый ОписаниеОповещения("ПродолжениеСохранения", ЭтотОбъект, РезультатВыбора);
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Прикрепление не будет выполнено для объектов:
			| %1'"), СтрокаОшибки);
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("Отменить", НСтр("ru = 'Отменить'"));
			Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
			
			ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
			ПараметрыВопроса.Заголовок = НСтр("ru = 'Недостаточно прав для прикрепления'");
			ПараметрыВопроса.БлокироватьВесьИнтерфейс = Истина;
			ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
			
			СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещенияПродолжениеСохранения, ТекстВопроса, Кнопки, ПараметрыВопроса);
		Иначе
			ОповеститьОВыборе(РезультатВыбора);
		КонецЕсли;
	Иначе
		ОповеститьОВыборе(РезультатВыбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтраницуМестаСохранения()
	
	Если Элементы.ПапкаДляСохраненияФайлов.Видимость Тогда
		Элементы.ПапкаДляСохраненияФайлов.Доступность = Не ВариантСохранения = "Присоединить";
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеСохранения(РезультатВопроса, РезультатВыбора) Экспорт
	Если РезультатВопроса.Значение = "Отменить" Тогда
		Закрыть();
	Иначе
		ОповеститьОВыборе(РезультатВыбора);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОбъектыДляПрикрепления(ОбъектыПечати)
	Результат = Новый СписокЗначений;
	МодульУправлениеДоступом = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
	КонецЕсли;
	
	Для Каждого ОбъектПечати Из ОбъектыПечати Цикл
		Результат.Добавить(ОбъектПечати.Значение,,?(МодульУправлениеДоступом <> Неопределено, 
			МодульУправлениеДоступом.ИзменениеРазрешено(ОбъектПечати.Значение), Истина)); 
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
