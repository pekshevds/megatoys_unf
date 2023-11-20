#Область СлужебныеПроцедурыИФункции

// Процедура настраивает видимость гиперссылки для открытия списка напоминаний.
//
&НаСервере
Процедура УстановитьВидимостьГиперссылкиЕстьНапоминанияНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НапоминанияПользователя.Источник
		|ИЗ
		|	РегистрСведений.НапоминанияПользователя КАК НапоминанияПользователя
		|ГДЕ
		|	НапоминанияПользователя.Источник = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Элементы.ПоДоговоруКредитаИЗаймаЕстьНапоминания.Видимость = Истина;
	Иначе
		Элементы.ПоДоговоруКредитаИЗаймаЕстьНапоминания.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры // УстановитьВидимостьГиперссылкиЕстьНапоминанияНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресГрафикПлатежейИНачисленийВХранилище = Параметры.АдресГрафикПлатежейИНачисленийВХранилище;
	ИдентификаторФормыДокумента = Параметры.ИдентификаторФормыДокумента;
	Регистратор = Параметры.Регистратор;
	Пользователь = Пользователи.ТекущийПользователь();
	БанкКонтрагент = Параметры.БанкКонтрагент;
	
	УстановитьВидимостьГиперссылкиЕстьНапоминанияНаСервере();
	
	// МобильныйКлиент
	МобильныйКлиентУНФ.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	МобильныйКлиентУНФ.НастроитьВспомогательнуюФормуМобильныйКлиент(ЭтотОбъект);
	// Конец МобильныйКлиент

КонецПроцедуры

// Процедура - обработчик события ПриОткрытии формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Время = '00010101000000' Тогда
		Время = '00010101100000';
	КонецЕсли;
	Если ПереключательДеньНачисления = 0 Тогда
		ПереключательДеньНачисления = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды Создать формы.
//
&НаКлиенте
Процедура Создать(Команда)

	Если Пользователь.Пустая() Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Выберите пользователя!'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Время) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Установите время напоминания!'"));
		Возврат;
	КонецЕсли;
	
	СоздатьСервер();
	
КонецПроцедуры

// Процедура - обработчик команды Создать формы. Серверная часть.
//
&НаСервере
Процедура СоздатьСервер()
	
	// получим таблицу начислений по графику
	ГрафикИзХранилища = ПолучитьИзВременногоХранилища(АдресГрафикПлатежейИНачисленийВХранилище);
	
	Если ГрафикИзХранилища.Количество() > 0 Тогда
		Набор = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
		Набор.Отбор.Пользователь.Установить(Пользователь);
		Набор.Отбор.Источник.Установить(Регистратор);
		
		Для Каждого СтрокаГрафика Из ГрафикИзХранилища Цикл
			
			Запись = Набор.Добавить();
			// Измерения
			Если ПереключательДеньНачисления = 1 Тогда
				ДатаВремяНапоминания = НачалоДня(НачалоДня(СтрокаГрафика.Период)-1) + Час(Время) * 3600 + Минута(Время) * 60 + Секунда(Время);
			Иначе
				ДатаВремяНапоминания = СтрокаГрафика.Период + Час(Время) * 3600 + Минута(Время) * 60 + Секунда(Время);
			КонецЕсли;
			Запись.Пользователь = Пользователь;
			Запись.ВремяСобытия = ДатаВремяНапоминания;
			Запись.Источник = Регистратор;
			// Ресурсы
			Запись.СрокНапоминания = ДатаВремяНапоминания;
			// Реквизиты
			Запись.Описание = "Платеж по кредиту = "+СтрокаГрафика.СуммаПлатежа+
				" (осн. долг = "+СтрокаГрафика.СуммаОсновногоДолга+";Сумма % "+СтрокаГрафика.СуммаПроцентов+"; комиссия "+СтрокаГрафика.СуммаКомиссии+
				") в банке "+БанкКонтрагент.Наименование+"."; 
			Запись.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
			Запись.ИнтервалВремениНапоминания = 3600;
			Запись.ПредставлениеИсточника = ""+Регистратор;
			
		КонецЦикла;
		
		Набор.Записать(Истина);
		
		Элементы.ПоДоговоруКредитаИЗаймаЕстьНапоминания.Заголовок = НСтр("ru = 'Напоминания по договору кредита (займа)'");
		Элементы.ПоДоговоруКредитаИЗаймаЕстьНапоминания.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события Нажатие элемента ПоДоговоруКредитаИЗаймаЕстьНапоминания.
&НаКлиенте
Процедура ПоОбъектуЕстьНапоминанияНажатие(Элемент)
	
	ПараметрыОткрытияФормы = Новый Структура("Отбор", Новый Структура("Источник", Регистратор));
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.ФормаСписка", ПараметрыОткрытияФормы);
	
КонецПроцедуры

#КонецОбласти
