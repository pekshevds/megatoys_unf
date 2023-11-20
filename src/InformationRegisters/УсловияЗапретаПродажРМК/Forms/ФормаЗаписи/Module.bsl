
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОсобенностьУчетаПриИзменении(Элемент)
	
	ОсобенностьУчета = Запись.ОсобенностьУчета;
	
	Если ЗначениеЗаполнено(ОсобенностьУчета) Тогда
		
		Запись.ВидНоменклатуры = Неопределено;
		ПереченьВидовНоменклатуры = МассивВидовНоменклатурыПоОсобенностиУчета(ОсобенностьУчета);
		Элементы.ВидНоменклатуры.СписокВыбора.ЗагрузитьЗначения(ПереченьВидовНоменклатуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Запись.ВремяНачала = Запись.ВремяОкончания Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Временной интервал (""Часы"") равен 0 секунд. Пожалуйста, введите корректные данные.'"));
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Организация.АвтоОтметкаНезаполненного = 
		ПустаяСтрока(Запись.ИмяЗапрещающегоДокументаМастерСистемы) И НЕ ЗначениеЗаполнено(Запись.Организация);
			
	Элементы.ДополнительныеДанные.Видимость = НЕ ПустаяСтрока(Запись.ИмяЗапрещающегоДокументаМастерСистемы);
	
	Если НЕ ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Запись.Организация = ОрганизацияПоДаннымКассыТекущегоРабочегоМеста();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ОсобенностьУчета) Тогда
	
		ПереченьВидовНоменклатуры = ОбщегоНазначенияРМК.МассивВидовНоменклатурыПоОсобенностиУчета(Запись.ОсобенностьУчета);
		Элементы.ВидНоменклатуры.СписокВыбора.ЗагрузитьЗначения(ПереченьВидовНоменклатуры);
	
	КонецЕсли;
	
	Доступность = ЗапретРедактированияУсловийОграничений();
	АктуализироватьЗаголовкиИменПолей();
	
	ОбщегоНазначенияРМК.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВремяНачалаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ВремяОкончания)
		И Запись.ВремяНачала > Запись.ВремяОкончания Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Время начала ограничения не может быть позже времени окончания'"));
		Запись.ВремяНачала = Неопределено;
		
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ВремяНачала)
		И Запись.ВремяНачала > Запись.ВремяОкончания Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Время окончания ограничения не может быть раньше времени начала'"));
		Запись.ВремяОкончания = Неопределено;
		
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаДействияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ДатаОкончанияДействия)
		И Запись.ДатаНачалаДействия > Запись.ДатаОкончанияДействия Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Дата начала ограничения не может быть позже даты окончания'"));
		Запись.ДатаНачалаДействия = Неопределено;
		
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияДействияПриИзменении(Элемент)

	Если Запись.ДатаНачалаДействия > Запись.ДатаОкончанияДействия Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Дата окончания ограничения не может быть раньше даты начала'"));
		Запись.ДатаОкончанияДействия = Неопределено;
		
	КонецЕсли
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция МассивВидовНоменклатурыПоОсобенностиУчета(ОсобенностьУчета)
	Возврат ОбщегоНазначенияРМК.МассивВидовНоменклатурыПоОсобенностиУчета(ОсобенностьУчета);
КонецФункции

&НаСервереБезКонтекста
Функция ЗапретРедактированияУсловийОграничений()
	Возврат ОбщегоНазначенияРМК.РазрешеноРедактироватьЗапретыПродаж();
КонецФункции

&НаСервереБезКонтекста
Функция ОрганизацияПоДаннымКассыТекущегоРабочегоМеста()

	Результат = Неопределено;
	
	РабочееМесто = ОбщегоНазначенияРМК.ТекущееРабочееМесто();
	ТорговыйОбъект = ОбщегоНазначенияРМК.ТекущийТорговыйОбъект();
	
	Если ЗначениеЗаполнено(РабочееМесто) И ЗначениеЗаполнено(ТорговыйОбъект) Тогда
		
		Запрос = Новый Запрос;
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("РабочееМесто", РабочееМесто);
		ДополнительныеПараметры.Вставить("ТорговыйОбъект", ТорговыйОбъект);
		
		ОбщегоНазначенияРМКПереопределяемый.СформироватьЗапросДанныеКассыККМ(Запрос,, ДополнительныеПараметры);
		
		Если Не ЗначениеЗаполнено(Запрос.Текст) Тогда
			Возврат Результат;
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() = 1 И  Выборка.Следующий() Тогда
			Результат = Выборка.Организация;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура АктуализироватьЗаголовкиИменПолей()
	
	ЗаголовокОсобенностьУчета = НСтр("ru = 'Особенность учета'");
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ЗаполнитьЗаголовокОсобенностьУчета(ЗаголовокОсобенностьУчета);
	Элементы.ОсобенностьУчета.Заголовок = ЗаголовокОсобенностьУчета;
	
	ЗаголовокВидНоменклатуры = НСтр("ru = 'Вид номенклатуры'");
	ОбщегоНазначенияРМККлиентСерверПереопределяемый.ЗаполнитьЗаголовокВидНоменклатуры(ЗаголовокВидНоменклатуры);
	Элементы.ВидНоменклатуры.Заголовок = ЗаголовокВидНоменклатуры;
	
КонецПроцедуры


#КонецОбласти
