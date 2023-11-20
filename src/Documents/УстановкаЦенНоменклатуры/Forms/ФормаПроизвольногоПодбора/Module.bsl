#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("АктивныеЗадания", Новый Массив);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"Характеристика", "Видимость", ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики"));
	
	Если Параметры.Свойство("ПоказыватьНедействительныеХарактеристики") Тогда
		ПоказыватьНедействительныеХарактеристики = Параметры.ПоказыватьНедействительныеХарактеристики;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнициализироватьСхемуКомпоновкиПриОткрытии();
	ЗагрузитьНастройкиФормы();
	ИнициализироватьКомпоновщикНастроекНаФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		
		СохраняемыеНастройки = Новый Структура;
		СохраняемыеНастройки.Вставить("ТекущаяСхемаКомпоновки", ТекущаяСхемаКомпоновки);
		
		КлючНастроек = "ТекущаяСхемаКомпоновкиФормыПодбораПоОтбору";
		СохранитьНастройкиФормы(СохраняемыеНастройки, КлючНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТекущаяСхемаКомпоновкиПриИзменении(Элемент)
	
	ОбработатьВыборСхемыКомпоновкиНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастроекНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриИзменении(Элемент)
	
	ОбновитьКорзину();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастроекНастройкиПараметрыДанных

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПараметрыДанныхПриИзменении(Элемент)
	
	ОбновитьКорзину();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	АдресВременногоХранилища = Новый УникальныйИдентификатор;
	Закрыть(Новый Структура("ВыборПроизведен, АдресВременногоХранилища", Истина, ПоместитьКорзинуВоВременноеХранилище(АдресВременногоХранилища)));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьВыборСхемыКомпоновкиНаСервере()
	
	ИнициализироватьКомпоновщикНастроекНаФорме();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроекНаФорме()
	
	Если НЕ КэшЗначений.АдресаСхемКомпоновки.Свойство(ЭтотОбъект.ТекущаяСхемаКомпоновки) Тогда
		ЭтотОбъект.ТекущаяСхемаКомпоновки = "ПодборСКД_Остатки";
	КонецЕсли;
	
	СхемаКомпоновки = ПолучитьИзВременногоХранилища(КэшЗначений.АдресаСхемКомпоновки[ЭтотОбъект.ТекущаяСхемаКомпоновки]);
	АдресСхемыКомпоновки = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновки);
	
	КомпоновщикНастроек.Инициализировать(Источник);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	ЕстьДоступныеНастройки = Ложь;
	Для каждого Параметр Из СхемаКомпоновки.Параметры Цикл
		Если НЕ Параметр.ОграничениеИспользования Тогда
			ЕстьДоступныеНастройки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				"ГруппаНастройки", "Видимость", ЕстьДоступныеНастройки);
	КэшЗначений.Вставить("ЕстьДоступныеНастройки", ЕстьДоступныеНастройки);

КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	СхемаКомпоновки = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновки);
	
	Если СхемаКомпоновки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиКомпоновщика = КомпоновщикНастроек.ПолучитьНастройки();
	
	СформироватьСтруктуруВыводаНастроекКомпоновки(НастройкиКомпоновщика);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновки, 
		НастройкиКомпоновщика, , ,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ИзменитьРеквизитыИДобавитьЭлементыКорзиныПоПолямСтруктуры();
	
	Корзина.Очистить();
	Таблица = РеквизитФормыВЗначение("Корзина");
	
	ПроцессорВыводаРезультатаКомпоновкиДанных = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВыводаРезультатаКомпоновкиДанных.УстановитьОбъект(Таблица);
	ПроцессорВыводаРезультатаКомпоновкиДанных.Вывести(ПроцессорКомпоновкиДанных);
	
	МассивКолонок = Новый Массив;
	Для каждого Колонка Из Таблица.Колонки Цикл
		МассивКолонок.Добавить(Колонка.Имя);
	КонецЦикла;
	Таблица.Свернуть(СтрСоединить(МассивКолонок, ","));
	
	ЗначениеВРеквизитФормы(Таблица, "Корзина");
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтруктуруВыводаНастроекКомпоновки(НастройкиКомпоновщика)
	
	ОбязательныеПоляСтруктуры = Новый Массив;
	ОбязательныеПоляСтруктуры.Добавить("Номенклатура");
	ОбязательныеПоляСтруктуры.Добавить("Характеристика");
	
	ГруппировкаДетали = НастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаДетали.Использование = Истина;
	
	ДополнительныеПоляСтруктуры = Новый Соответствие;
	ЗаполнитьПоляПоДеревуОтбора(НастройкиКомпоновщика.Отбор, ГруппировкаДетали.Отбор, НастройкиКомпоновщика.ДоступныеПоляОтбора, 
		ДополнительныеПоляСтруктуры, ОбязательныеПоляСтруктуры);
	
	Для каждого Поле Из ОбязательныеПоляСтруктуры Цикл
		ПолеГруппировки = ГруппировкаДетали.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЦикла;
	
	Для каждого Поле Из ДополнительныеПоляСтруктуры Цикл
		ПолеГруппировки = ГруппировкаДетали.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(Поле.Значение.Путь);
		ПолеГруппировки.Заголовок = Поле.Значение.Заголовок;
	КонецЦикла;
	
	КэшЗначений.Вставить("ОбязательныеПоляКорзины", ОбязательныеПоляСтруктуры);
	КэшЗначений.Вставить("ДополнительныеПоляКорзины", ДополнительныеПоляСтруктуры);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРеквизитыИДобавитьЭлементыКорзиныПоПолямСтруктуры()
	
	ДобавляемыеРеквизиты = Новый Массив;
	УдаляемыеРеквизиты = Новый Массив;
	УдаляемыеЭлементы = Новый Массив;
	ОбязательныеПоляКорзины = КэшЗначений.ОбязательныеПоляКорзины;
	ДополнительныеПоляКорзины = КэшЗначений.ДополнительныеПоляКорзины;
	
	Для каждого Поле Из Элементы.Корзина.ПодчиненныеЭлементы Цикл
		Если ОбязательныеПоляКорзины.Найти(Поле.Имя) = Неопределено Тогда
			УдаляемыеРеквизиты.Добавить(Поле.ПутьКДанным);
			УдаляемыеЭлементы.Добавить(Поле);
		КонецЕсли;
	КонецЦикла;
	
	ИзменитьРеквизиты(, УдаляемыеРеквизиты);
	
	МаксимальныйИндекс = УдаляемыеЭлементы.Количество() - 1;
	Пока МаксимальныйИндекс >= 0 Цикл
		Элементы.Удалить(УдаляемыеЭлементы.Получить(МаксимальныйИндекс));
		МаксимальныйИндекс = МаксимальныйИндекс - 1;
	КонецЦикла;
	
	Для каждого Поле Из ДополнительныеПоляКорзины Цикл
		НовыйРеквизит = Новый РеквизитФормы(Поле.Ключ, Поле.Значение.Тип, "Корзина");
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для каждого Поле Из ДополнительныеПоляКорзины Цикл
		Элемент = Элементы.Добавить(Поле.Ключ, Тип("ПолеФормы"), Элементы.Корзина);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "Корзина." + Поле.Ключ;
		Элемент.ТолькоПросмотр = Истина;
		Элемент.Заголовок = Поле.Значение.Заголовок;
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьПоляПоДеревуОтбора(Отбор, ГруппировкаДеталиОтбор, ДоступныеПоляОтбора, ДополнительныеПоляСтруктуры, ОбязательныеПоляСтруктуры)
	
	Для каждого ЭлементОтбора Из Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда

			Если ЭлементОтбора.Использование Тогда
					
				ОтборГруппировки = ГруппировкаДеталиОтбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
				ЗаполнитьЗначенияСвойств(ОтборГруппировки, ЭлементОтбора);
				ЗаполнитьПоляПоДеревуОтбора(ЭлементОтбора, ОтборГруппировки, ДоступныеПоляОтбора, 
					ДополнительныеПоляСтруктуры, ОбязательныеПоляСтруктуры);
					
			КонецЕсли;
				
		Иначе
			Если ЭлементОтбора.Использование Тогда
				
				ОтборГруппировки = ГруппировкаДеталиОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ЗаполнитьЗначенияСвойств(ОтборГруппировки, ЭлементОтбора);
				ЭлементОтбора.Использование = Ложь;
				
				Поле = Строка(ЭлементОтбора.ЛевоеЗначение);
				ДоступноеПоле = ДоступныеПоляОтбора.Элементы.Найти(Поле);
				Если ОбязательныеПоляСтруктуры.Найти(Поле) = Неопределено Тогда
					
					Если ДоступноеПоле <> Неопределено Тогда
						Заголовок = ДоступноеПоле.Заголовок;
						Тип = ДоступноеПоле.ТипЗначения;
					Иначе
						Заголовок = Поле;
						Тип = Новый ОписаниеТипов("Строка");
					КонецЕсли;
					СтруктураПоля = Новый Структура;
					СтруктураПоля.Вставить("Заголовок", Заголовок);
					СтруктураПоля.Вставить("Тип", Тип);
					СтруктураПоля.Вставить("Путь", Строка(ЭлементОтбора.ЛевоеЗначение));
					КлючПоля = СтрЗаменить(Поле, ".", "");
					КлючПоля = СтрЗаменить(КлючПоля, "[", "_");
					КлючПоля = СтрЗаменить(КлючПоля, "]", "_");
					КлючПоля = СтрЗаменить(КлючПоля, "(", "_");
					КлючПоля = СтрЗаменить(КлючПоля, ")", "_");
					КлючПоля = СтрЗаменить(КлючПоля, " ", "");

					ДополнительныеПоляСтруктуры.Вставить(КлючПоля, СтруктураПоля);
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокДоступныхСхемКомпоновки()
	
	МакетыПодборов = Новый Соответствие;
	МакетыДокумента = Метаданные.Документы.УстановкаЦенНоменклатуры.Макеты;
	Для каждого МакетДокумента Из МакетыДокумента Цикл
		Если СтрНайти(МакетДокумента.Имя, "ПодборСКД_") <> 0 Тогда
			
			МакетыПодборов.Вставить(МакетДокумента.Имя, МакетДокумента.Синоним);
			
		КонецЕсли;
	КонецЦикла;
	Возврат МакетыПодборов;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьСхемуКомпоновкиПриОткрытии()
	
	СписокДоступныхСхем = ПолучитьСписокДоступныхСхемКомпоновки();
	АдресаСхемКомпоновки = Новый Структура;

	Для каждого ДоступнаяСхема Из СписокДоступныхСхем Цикл
		
		Элементы.ТекущаяСхемаКомпоновки.СписокВыбора.Добавить(ДоступнаяСхема.Ключ, ДоступнаяСхема.Значение);
		
		СхемаКомпоновки = Документы.УстановкаЦенНоменклатуры.ПолучитьМакет(ДоступнаяСхема.Ключ);
		АдресаСхемКомпоновки.Вставить(ДоступнаяСхема.Ключ, ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор));
		
	КонецЦикла;

	Если СписокДоступныхСхем.Количество() = 1 Тогда

		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ТекущаяСхемаКомпоновки", "Видимость", Ложь);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ТекущаяСхемаКомпоновки", "Видимость", Истина);
		
	КонецЕсли;
	
	КэшЗначений.Вставить("АдресаСхемКомпоновки", АдресаСхемКомпоновки);
	
КонецПроцедуры

// Сохраняет настройки формы по имени формы
//
// Параметры:
// 	- СохраняемыеНастройки - Структура сохраняемых настроек
//
&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормы(СохраняемыеНастройки, КлючНастроек)

	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"Документ.УстановкаЦенНоменклатуры.ФормаПроизвольногоПодбора",
		КлючНастроек, СохраняемыеНастройки);
	
КонецПроцедуры

// Получает настройки формы и загружает их в реквизиты
// Если настройки не были сохранены ранее, то будут загружены настройки по умолчанию
// из процедуры ПолучитьНастройкиФормыПоУмолчанию()
//
&НаКлиенте
Процедура ЗагрузитьНастройкиФормы()
	
	ЗагружаемыеНастройкиПоУмолчанию = ПолучитьНастройкиФормыПоУмолчанию();
	КлючНастроек 					= "ТекущаяСхемаКомпоновкиФормыПодбораПоОтбору";
	ЗагружаемыеНастройки 			= ПолучитьНастройкиФормы(ЗагружаемыеНастройкиПоУмолчанию, КлючНастроек);
	
	ЭтотОбъект.ТекущаяСхемаКомпоновки = ЗагружаемыеНастройки.ТекущаяСхемаКомпоновки;
	
КонецПроцедуры

// Возвращает настройки формы по умолчанию
// 
// Возвращаемое значение:
// - Структура настроек формы
//
&НаКлиенте
Функция ПолучитьНастройкиФормыПоУмолчанию()
	
	ЗагружаемыеНастройкиПоУмолчанию = Новый Структура;
	ЗагружаемыеНастройкиПоУмолчанию.Вставить("ТекущаяСхемаКомпоновки", "ПодборСКД_Остатки");
	Возврат ЗагружаемыеНастройкиПоУмолчанию;
	
КонецФункции

// Возвращает сохраненные настройки формы или настройки по умолчанию
//
// Параметры:
//  - ЗагружаемыеНастройки - структура настроек по умолчанию
// 
// Возвращаемое значение:
// - Структура настроек формы, если они были сохранены ранее, либо структура настроек по умолчанию
//
&НаСервереБезКонтекста
Функция ПолучитьНастройкиФормы(ЗагружаемыеНастройки, КлючНастроек)
		
	Возврат ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
		"Документ.УстановкаЦенНоменклатуры.ФормаПроизвольногоПодбора",
		КлючНастроек, ЗагружаемыеНастройки);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКорзину()
	
	Элементы.ГруппаИнформация.Видимость = Ложь;
	Элементы.Корзина.Видимость = Ложь;
	Элементы.ГруппаОжидание.Видимость = Истина;
	
	ПодключитьОбработчикОжидания("ИзменениеПараметровОтборовКомпоновщика", 2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаданиеОбновленияКорзины()
	
	РезультатНачалаЗаполненияКорзины = НачатьЗаполнениеКорзины();
	ДлительнаяОперация = РезультатНачалаЗаполненияКорзины.ДлительнаяОперация;
	ИдентификаторЗаданияЗаполнения = ДлительнаяОперация.ИдентификаторЗадания;
	
	ДополнительныеПараметрыРезультата = Новый Структура("ИдентификаторЗаданияЗаполнения, АдресНастроекКомпоновщика", 
		ИдентификаторЗаданияЗаполнения, РезультатНачалаЗаполненияКорзины.АдресНастроекКомпоновщика);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьЗаполнениеКорзины", ЭтотОбъект, ДополнительныеПараметрыРезультата);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьЗаполнениеКорзины()
	
	Для каждого ИдентификаторЗадания Из КэшЗначений.АктивныеЗадания Цикл
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЦикла;
	КэшЗначений.АктивныеЗадания = Новый Массив;

	НастройкиКомпоновщика = КомпоновщикНастроек.ПолучитьНастройки();
	
	СхемаКомпоновки = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновки);
	
	СформироватьСтруктуруВыводаНастроекКомпоновки(НастройкиКомпоновщика);
	
	Таблица = РеквизитФормыВЗначение("Корзина");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("СхемаКомпоновки", СхемаКомпоновки);
	ПараметрыПроцедуры.Вставить("НастройкиКомпоновщика", НастройкиКомпоновщика);
	ПараметрыПроцедуры.Вставить("Корзина", Таблица);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, 
		"Документы.УстановкаЦенНоменклатуры.ЗаполнитьКорзинуФормыПроизвольногоПодбора", ПараметрыПроцедуры);
	
	КэшЗначений.АктивныеЗадания.Добавить(ДлительнаяОперация.ИдентификаторЗадания);
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("АдресНастроекКомпоновщика", 
		ПоместитьВоВременноеХранилище(НастройкиКомпоновщика, УникальныйИдентификатор));
	СтруктураРезультата.Вставить("ДлительнаяОперация", ДлительнаяОперация);
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьЗаполнениеКорзины(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено 
		И ЭтоАдресВременногоХранилища(Результат.АдресРезультата) 
		И Результат.Статус = "Выполнено" 
		И ДополнительныеПараметры.ИдентификаторЗаданияЗаполнения = ИдентификаторЗаданияЗаполнения Тогда
		
		ОбработатьЗаполнениеКорзиныНаСервере(Результат, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьЗаполнениеКорзиныНаСервере(Результат, ДополнительныеПараметры)
	
	НастройкиКомпоновщика = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.АдресНастроекКомпоновщика);
	
	ИзменитьРеквизитыИДобавитьЭлементыКорзиныПоПолямСтруктуры();
	
	ЗначениеВРеквизитФормы(ПолучитьИзВременногоХранилища(Результат.АдресРезультата), "Корзина");
	Элементы.Корзина.Видимость = Истина;
	Элементы.ГруппаОжидание.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеПараметровОтборовКомпоновщика()
	
	ОтключитьОбработчикОжидания("ИзменениеПараметровОтборовКомпоновщика");
	ВыполнитьЗаданиеОбновленияКорзины();
	
КонецПроцедуры

&НаСервере
Функция ПоместитьКорзинуВоВременноеХранилище(АдресВременногоХранилища)
	
	Таблица = РеквизитФормыВЗначение("Корзина");
	Возврат Документы.УстановкаЦенНоменклатуры.ПолучитьНоменклатуруИзПроизвольнойФормы(Таблица,
		ПоказыватьНедействительныеХарактеристики, АдресВременногоХранилища);
	
КонецФункции
	
#КонецОбласти
