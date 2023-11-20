
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	Если Не РежимОтладки И Параметры.Ключ.Пустая() Тогда
		ТекстСообщения = НСтр("ru = 'Итерактивный ввод запрещен!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Элементы.Шапка.ТолькоПросмотр = Не РежимОтладки;
	
	Если ЗначениеЗаполнено(Объект.ВидДанных) Тогда
		
		ИндексЗначения = Перечисления.ВидыДанныхЛичногоКабинетаЕНС.Индекс(Объект.ВидДанных);
		ИмяЗначения    = Метаданные.Перечисления.ВидыДанныхЛичногоКабинетаЕНС.ЗначенияПеречисления[ИндексЗначения].Имя;
		
		Таблица = Элементы.Добавить(ИмяЗначения, Тип("ТаблицаФормы"), Элементы.ГруппаДанных);
		Таблица.ПутьКДанным = "Объект." + ИмяЗначения;
		Таблица.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Таблица.ИзменятьПорядокСтрок     = Ложь;
		Таблица.ТолькоПросмотр           = Не РежимОтладки;
		Таблица.ИзменятьСоставСтрок      = РежимОтладки;
		
		ОписаниеТаблицы = Объект.Ссылка.Метаданные().ТабличныеЧасти[ИмяЗначения].Реквизиты;
		Для Каждого Колонка Из ОписаниеТаблицы Цикл
			Поле = Элементы.Добавить(ИмяЗначения + Колонка.Имя, Тип("ПолеФормы"), Таблица);
			Поле.Вид = ВидПоляФормы.ПолеВвода;
			Поле.ПутьКДанным = Таблица.ПутьКДанным + "." + Колонка.Имя;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры
