#Область ОписаниеПеременных

&НаКлиенте
Перем ЭтоНоваяСтрока;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	КонтекстныйВызов = Параметры.КонтекстныйВызов; 
	
	Если Параметры.Ключ.Пустая() Тогда
		Если Не ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Если КонтекстныйВызов Тогда
				Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов;
				Объект.Организация = Параметры.Организация;
				ПараметрыАвтозаполнения = "КонтекстныйВызов, АдресХранилищаТаблицыНалоги, ПериодСобытия, ЗаписьКалендаря";
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыАвтозаполнения);
				ЗаполнитьТаблицуНалоги();
			КонецЕсли;
		КонецЕсли;
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	#Область СтандартныеПодсистемы

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ПодменюПечать;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	#КонецОбласти
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПоказыватьСчетаУчетаВДокументах = Истина;

	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() Тогда
		ОбновитьИтоги();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("Период",      Объект.Дата);
	
	Оповестить("Запись_ОперацияПоЕдиномуНалоговомуСчету", ПараметрыОповещения, ЭтотОбъект);
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ОперацияПоЕдиномуНалоговомуСчету.Форма.ФормаРедактированияСтроки" Тогда
		ОбработкаВыбораАналитикиУчетаНаКлиенте(ВыбранноеЗначение);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Свойство("КлючСтроки") Тогда
			Модифицированность = Истина;
			Если ВыбранноеЗначение.Свойство("АдресТаблицыНалоговыйАгентНДСВХранилище") Тогда
				ОбработкаВыбораНалоговыйАгентНДС(ВыбранноеЗначение);
				ОбновитьИтоги();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиНалоги

&НаКлиенте
Процедура НалогиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНоваяСтрока = НоваяСтрока;
	
	Если НоваяСтрока ИЛИ Копирование Тогда
		Если НоваяСтрока И Не Копирование Тогда
			ТекущиеДанные.РегистрацияВНалоговомОргане = РегистрацияВНалоговомОргане;
			
			ПараметрыСтроки = ОписаниеСтрокиДокумента();
			ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекущиеДанные);
			РегистрацияВНалоговомОрганеПриИзмененииНаСервере(ПараметрыСтроки);
			ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПараметрыСтроки);
		ИначеЕсли Копирование Тогда
			Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) <> Неопределено Тогда
				ТекущиеДанные.Сумма = 0;
			КонецЕсли;
		КонецЕсли;
		ТекущиеДанные.КлючСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	ТекущийСчетУчета = ТекущиеДанные.СчетУчета;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиНалогПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСтроки = ОписаниеСтрокиДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекущиеДанные);
	НалогПриИзмененииНаСервере(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиСчетУчетаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) = Неопределено
		Или ТекущийСчетУчета <> ТекущиеДанные.СчетУчета Тогда
		НалоговыйАгентНДСОчистить(ЭтотОбъект, ТекущиеДанные.КлючСтроки);
		Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) <> Неопределено Тогда
			ТекущиеДанные.Сумма = 0;
		КонецЕсли;
	Иначе
		ТекущиеДанные.Сумма = НалоговыйАгентНДСРассчитать(ЭтотОбъект, ТекущиеДанные.КлючСтроки);
	КонецЕсли;
	ТекущийСчетУчета = ТекущиеДанные.СчетУчета;
	
	ПараметрыСтроки = ОписаниеСтрокиДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекущиеДанные);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиРегистрацияВНалоговомОрганеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСтроки = ОписаниеСтрокиДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекущиеДанные);
	РегистрацияВНалоговомОрганеПриИзмененииНаСервере(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиАналитикаУчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбраннаяСтрока = Элементы.Налоги.ТекущаяСтрока;
	ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "Налоги");
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиСуммаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов") Тогда
		Если ТекущиеДанные <> Неопределено
			И СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) <> Неопределено Тогда
			ОткрытьФормуРедактированияАгентскогоНДС(ТекущиеДанные, "Налоги");
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования И НоваяСтрока Тогда
		// Закроем форму редактирования строки, т.к. пользователь отменяет ввод
		Оповестить("ФормаРедактированияСтроки_Закрыть", Неопределено, ЭтотОбъект);
	КонецЕсли;
	
	ЭтоНоваяСтрока = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.Налоги.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоНоваяСтрока Тогда
		ТекущаяКолонкаТаблицы = Элементы.Налоги.ТекущийЭлемент;
		Если ТекущаяКолонкаТаблицы.Имя = "НалогиАналитикаУчета"
			И НЕ Элементы.Налоги.ТекущиеДанные.АналитикаУчетаЗаполнена Тогда
			ВыбраннаяСтрока = Элементы.Налоги.ТекущаяСтрока;
			ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "Налоги");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "НалогиАналитикаУчета" Тогда
		ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "Налоги");
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	Если Поле.Имя = "НалогиСумма" Тогда
		Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов") Тогда
			ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
			Если ТекущиеДанные <> Неопределено
				И СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) <> Неопределено Тогда
				ОткрытьФормуРедактированияАгентскогоНДС(ВыбраннаяСтрока, "Налоги");
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НалоговыйАгентНДСОчистить(ЭтотОбъект, ТекущиеДанные.КлючСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиВидНалогаНДСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиВидНалогаНДСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Налоги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.СчетУчета = ТекущиеДанные.ВидНалогаНДС;
	
	Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) = Неопределено
		Или ТекущийСчетУчета <> ТекущиеДанные.СчетУчета Тогда
		НалоговыйАгентНДСОчистить(ЭтотОбъект, ТекущиеДанные.КлючСтроки);
		Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ТекущиеДанные.СчетУчета) <> Неопределено Тогда
			ТекущиеДанные.Сумма = 0;
		КонецЕсли;
	Иначе
		ТекущиеДанные.Сумма = НалоговыйАгентНДСРассчитать(ЭтотОбъект, ТекущиеДанные.НомерСтроки);
	КонецЕсли;
	ТекущийСчетУчета = ТекущиеДанные.СчетУчета;
	
	ОбновитьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиПриИзменении(Элемент)
	
	ОбновитьИтоги();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиСанкции

&НаКлиенте
Процедура СанкцииАналитикаУчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ВыбраннаяСтрока = Элементы.Санкции.ТекущаяСтрока;
	ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "Санкции");
	
КонецПроцедуры

&НаКлиенте
Процедура СанкцииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования И НоваяСтрока Тогда
		// Закроем форму редактирования строки, т.к. пользователь отменяет ввод
		Оповестить("ФормаРедактированияСтроки_Закрыть", Неопределено, ЭтотОбъект);
	КонецЕсли;
	
	ЭтоНоваяСтрока = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СанкцииПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.Санкции.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоНоваяСтрока Тогда
		ТекущаяКолонкаТаблицы = Элементы.Санкции.ТекущийЭлемент;
		Если ТекущаяКолонкаТаблицы.Имя = "СанкцииАналитикаУчета"
			И НЕ Элементы.Санкции.ТекущиеДанные.АналитикаУчетаЗаполнена Тогда
			ВыбраннаяСтрока = Элементы.Санкции.ТекущаяСтрока;
			ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "Санкции");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СанкцииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Санкции.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНоваяСтрока = НоваяСтрока;
	
	Если НЕ НоваяСтрока ИЛИ Копирование Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СанкцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СанкцииАналитикаУчета" Тогда
		ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "Санкции");
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СанкцииПриИзменении(Элемент)
	
	ОбновитьИтоги();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиЕдиныйСчет

&НаКлиенте
Процедура ЕдиныйСчетАналитикаУчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ВыбраннаяСтрока = Элементы.Санкции.ТекущаяСтрока;
	ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "ЕдиныйСчет");
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиныйСчетПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования И НоваяСтрока Тогда
		// Закроем форму редактирования строки, т.к. пользователь отменяет ввод
		Оповестить("ФормаРедактированияСтроки_Закрыть", Неопределено, ЭтотОбъект);
	КонецЕсли;
	
	ЭтоНоваяСтрока = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиныйСчетПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.ЕдиныйСчет.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоНоваяСтрока Тогда
		ТекущаяКолонкаТаблицы = Элементы.ЕдиныйСчет.ТекущийЭлемент;
		Если ТекущаяКолонкаТаблицы.Имя = "ЕдиныйСчетАналитикаУчета"
			И НЕ Элементы.ЕдиныйСчет.ТекущиеДанные.АналитикаУчетаЗаполнена Тогда
			ВыбраннаяСтрока = Элементы.ЕдиныйСчет.ТекущаяСтрока;
			ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "ЕдиныйСчет");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиныйСчетПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ЕдиныйСчет.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНоваяСтрока = НоваяСтрока;
	
	Если НЕ НоваяСтрока ИЛИ Копирование Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиныйСчетВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ЕдиныйСчетАналитикаУчета" Тогда
		ОткрытьФормуРедактированияАналитикиУчета(ВыбраннаяСтрока, "ЕдиныйСчет");
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиныйСчетПриИзменении(Элемент)
	
	ОбновитьИтоги();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	СписокНалоговДляЗаполнения = Новый СписокЗначений;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстПредупреждения = НСтр("ru='Для заполнения документа необходимо выбрать организацию.'");
		Заголовок = НСтр("ru = 'Ошибка заполнения'");
		ПоказатьПредупреждение(, ТекстПредупреждения, , Заголовок);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Период",      Объект.Дата);
	ПараметрыФормы.Вставить("ВидОперации", Объект.ВидОперации);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьНалогиЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ОперацияПоЕдиномуНалоговомуСчету.Форма.ФормаСпискаВыбораНалогов",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

Процедура УстановитьЗаголовокФормы() Экспорт
	
	ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Операция по ЕНС: %1'"), Объект.ВидОперации);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2'"), Объект.Номер, Объект.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru = ' (создание)'");
	КонецЕсли;
	
	Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ПолучитьРеквизитыОрганизации();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьСостояниеДокумента();
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов
		Или Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов Тогда
		ИмяТаблицы = "Налоги";
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеПенейШтрафов
		Или Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.ПогашениеПенейШтрафов Тогда
		ИмяТаблицы = "Санкции";
	Иначе
		ИмяТаблицы = "ЕдиныйСчет";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНалоги()
	
	Если ЗначениеЗаполнено(АдресХранилищаТаблицыНалоги) Тогда
		ТаблицыЗаполнения = ПолучитьИзВременногоХранилища(АдресХранилищаТаблицыНалоги);
		Если ЗначениеЗаполнено(ТаблицыЗаполнения.ТаблицаНалоги) Тогда
			Объект.Налоги.Загрузить(ТаблицыЗаполнения.ТаблицаНалоги);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеСтрокиДокумента()
	
	ОписаниеСтроки = Новый Структура("НомерСтроки, Налог, КодБК, СчетУчета, КлючСтроки,
		|ВидПлатежа, РегистрацияВНалоговомОргане,
		|КодПоОКТМО, Сумма, СрокУплаты,
		|РедактироватьВидПлатежа,
		|УчитыватьВНУ, Подразделение,
		|АналитикаУчета, АналитикаУчетаЗаполнена,
		|ПоказыватьСчетУчета, ВидНалогаНДС");
	
	Возврат ОписаниеСтроки;
	
КонецФункции

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	ПолучитьРеквизитыОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ПолучитьРеквизитыОрганизации();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРеквизитыОрганизации()
	
	РегистрацияВНалоговомОргане = "";
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		РегистрацияВНалоговомОргане = Объект.Организация.РегистрацияВНалоговомОргане;
	КонецЕсли;
	
	ЭтоЮрЛицо = Истина;
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЭтоЮрЛицо = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(Объект.Организация);
	КонецЕсли;
	
	СистемаНалогообложенияОрганизации = РегистрыСведений.СистемыНалогообложенияОрганизаций.ОпределитьСистемуНалогообложенияОрганизации(Объект.Организация, Объект.Дата);
	
	ПрименяетсяУСНДоходыМинусРасходы = СистемаНалогообложенияОрганизации.ОбъектНалогообложения = Перечисления.ВидыОбъектовНалогообложения.ДоходыМинусРасходы 
		И СистемаНалогообложенияОрганизации.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
	
КонецПроцедуры

&НаСервере
Процедура НалогПриИзмененииНаСервере(ПараметрыСтроки)
	
	Если ЗначениеЗаполнено(ПараметрыСтроки.Налог) Тогда
		ПараметрыСтроки.КодБК          = Справочники.ВидыНалогов.КБК(ПараметрыСтроки.Налог, , Объект.Дата);
		ПараметрыСтроки.СчетУчета      = ПараметрыСтроки.Налог.СчетУчета;
		
		ВидНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыСтроки.Налог, "ВидНалога");
		
	КонецЕсли;
	
	Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ПараметрыСтроки.СчетУчета) = Неопределено
		Или ТекущийСчетУчета <> ПараметрыСтроки.СчетУчета Тогда 
		НалоговыйАгентНДСОчистить(ЭтотОбъект, ПараметрыСтроки.КлючСтроки);
		Если СписокСчетовАгентскогоНДС.НайтиПоЗначению(ПараметрыСтроки.СчетУчета) <> Неопределено Тогда
			ПараметрыСтроки.Сумма = 0;
		КонецЕсли;
	Иначе
		ПараметрыСтроки.Сумма = НалоговыйАгентНДСРассчитать(ЭтотОбъект, ПараметрыСтроки.КлючСтроки);
	КонецЕсли;
	ТекущийСчетУчета = ПараметрыСтроки.СчетУчета;
	
	Если ПараметрыСтроки.Налог = Налог_НДС Тогда
		ПараметрыСтроки.ВидНалогаНДС = ПараметрыСтроки.СчетУчета;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РегистрацияВНалоговомОрганеПриИзмененииНаСервере(ПараметрыСтроки)
	
	Если ЗначениеЗаполнено(ПараметрыСтроки.РегистрацияВНалоговомОргане) Тогда
		ПараметрыСтроки.КодПоОКТМО =
			РегламентированнаяОтчетностьУСН.КодТерритории(ПараметрыСтроки.РегистрацияВНалоговомОргане);
		КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияАналитикиУчета(ВыбранноеЗначение, ИмяТаблицы)

	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ДанныеСтроки = Объект[ИмяТаблицы].НайтиПоИдентификатору(ВыбранноеЗначение);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	ПараметрыФормы.Вставить("Дата",           Объект.Дата);
	ПараметрыФормы.Вставить("Организация",    Объект.Организация);
	
	ПараметрыФормы.Вставить("Подразделение",  ДанныеСтроки.Подразделение);
	ПараметрыФормы.Вставить("УчитыватьВНУ",  ДанныеСтроки.УчитыватьВНУ);
	
	ОткрытьФорму("Документ.ОперацияПоЕдиномуНалоговомуСчету.Форма.ФормаРедактированияСтроки", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияАгентскогоНДС(ВыбранноеЗначение, ИмяТаблицы)

	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ДанныеСтроки = Объект[ИмяТаблицы].НайтиПоИдентификатору(ВыбранноеЗначение);
	
	Если (ЗначениеЗаполнено(ДанныеСтроки.СрокУплаты) И ДанныеСтроки.СрокУплаты < Объект.Дата)
		Или Не ЗначениеЗаполнено(ДанныеСтроки.СрокУплаты) Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Некорректно заполнена колонка ""Срок уплаты"" в строке %1 списка ""Налоги"":
			| - срок уплаты должен быть указан и быть больше даты документа'"),
			ДанныеСтроки.НомерСтроки);
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Налоги", ДанныеСтроки.НомерСтроки, "СрокУплаты"),
			"Объект");
		РазблокироватьДанныеФормыДляРедактирования();
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	ПараметрыФормы.Вставить("Период",         ДанныеСтроки.СрокУплаты);
	ПараметрыФормы.Вставить("Организация",    Объект.Организация);
	ПараметрыФормы.Вставить("СчетУчета",      ДанныеСтроки.СчетУчета);
	ПараметрыФормы.Вставить("ДокументСсылка", Объект.Ссылка);
	ПараметрыФормы.Вставить("КлючСтроки",     ДанныеСтроки.КлючСтроки);
	ПараметрыФормы.Вставить("АдресТаблицыНалоговыйАгентНДСВХранилище", АдресТаблицыНалоговыйАгентНДС(ДанныеСтроки.КлючСтроки));
	
	ОткрытьФорму("ОбщаяФорма.ПодборДокументовНалоговогоАгента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция АдресТаблицыНалоговыйАгентНДС(КлючСтроки)
	
	ТаблицаНалоговыйАгентНДС = Объект.НалоговыйАгентНДС.Выгрузить(Новый Структура("КлючСтроки", КлючСтроки));
	Возврат ПоместитьВоВременноеХранилище(ТаблицаНалоговыйАгентНДС, Новый УникальныйИдентификатор());
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораНалоговыйАгентНДС(ВыбранноеЗначение)
	
	ТаблицаНалоговыйАгентНДС = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТаблицыНалоговыйАгентНДСВХранилище);
	МассивСтрок = Объект.НалоговыйАгентНДС.НайтиСтроки(Новый Структура("КлючСтроки", ВыбранноеЗначение.КлючСтроки));
	Для Каждого Строка Из МассивСтрок Цикл
		Объект.НалоговыйАгентНДС.Удалить(Строка);
	КонецЦикла;
	
	ИтогСуммаЗаписей     = ТаблицаНалоговыйАгентНДС.Итог("Сумма");
	//Если Объект.Дата >= НастройкиУчетаКлиентСервер.ДатаПереходаНаЕдиныйНалоговыйПлатеж() Тогда
		ИтогСуммаУведомления = ИтогСуммаЗаписей;
	//Иначе
		//ИтогСуммаУведомления = Окр(ИтогСуммаЗаписей, 0, РежимОкругления.Окр15как10);
	//КонецЕсли;
	Разница = ИтогСуммаЗаписей - ИтогСуммаУведомления;
	
	ТаблицаНалоговыйАгентНДС.Сортировать("Сумма");
	Для Каждого СтрокаТаблицы Из ТаблицаНалоговыйАгентНДС Цикл
		СуммаСтроки = СтрокаТаблицы.Сумма;
		Если Разница <> 0 Тогда
			СуммаСтроки = Макс(0, СуммаСтроки - Разница);
			Разница = Разница - (СтрокаТаблицы.Сумма - СуммаСтроки);
		КонецЕсли;
		СтрокаТаблицы.Сумма = СуммаСтроки;
	КонецЦикла;
	
	ТаблицаНалоговыйАгентНДС.Сортировать("Контрагент, Договор, ДокументРасчетов, Сумма");
	
	Для Каждого СтрокаТаблицы Из ТаблицаНалоговыйАгентНДС Цикл
		Если СтрокаТаблицы.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Объект.НалоговыйАгентНДС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.КлючСтроки = ВыбранноеЗначение.КлючСтроки;
	КонецЦикла;
	
	СтрокиТаблицы = Объект.Налоги.НайтиСтроки(Новый Структура("КлючСтроки", ВыбранноеЗначение.КлючСтроки));
	СтрокиТаблицы[0].Сумма = ИтогСуммаУведомления;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НалоговыйАгентНДСОчистить(Форма, КлючСтроки)
	
	ТаблицаНалоговыйАгентНДС = Форма.Объект.НалоговыйАгентНДС;
	
	МассивСтрок = ТаблицаНалоговыйАгентНДС.НайтиСтроки(Новый Структура("КлючСтроки", КлючСтроки));
	Для Каждого СтрокаМассива Из МассивСтрок Цикл
		ТаблицаНалоговыйАгентНДС.Удалить(СтрокаМассива);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НалоговыйАгентНДСРассчитать(Форма, КлючСтроки)
	
	ТаблицаНалоговыйАгентНДС = Форма.Объект.НалоговыйАгентНДС;
	
	СуммаСтроки = 0;
	
	МассивСтрок = ТаблицаНалоговыйАгентНДС.НайтиСтроки(Новый Структура("КлючСтроки", КлючСтроки));
	Для Каждого СтрокаМассива Из МассивСтрок Цикл
		СуммаСтроки = СуммаСтроки + СтрокаМассива.Сумма;
	КонецЦикла;
	
	Возврат СуммаСтроки;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораАналитикиУчетаНаКлиенте(ЗначенияВыбранныеВФормеАналитикиУчета)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов")
		Или Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов") Тогда
		ИмяТаблицы = "Налоги";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеПенейШтрафов")
		Или Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.ПогашениеПенейШтрафов") Тогда
		ИмяТаблицы = "Санкции";
	Иначе
		ИмяТаблицы = "ЕдиныйСчет";
	КонецЕсли;
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	ПараметрыСтроки = ОписаниеСтрокиДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекущиеДанные);
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ЗначенияВыбранныеВФормеАналитикиУчета);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПараметрыСтроки);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтоги()
	
	Объект.СуммаДокумента = Объект.Налоги.Итог("Сумма")
		+ Объект.Санкции.Итог("Сумма")
		+ Объект.ЕдиныйСчет.Итог("Сумма");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"ГруппаНалоги",
		"Видимость",
		Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов")
		Или Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"НалогиПлатежныйДокумент",
		"Видимость",
		Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"НалогиСчетУчета",
		"Видимость",
		Форма.ПоказыватьСчетаУчетаВДокументах);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"НалогиВидНалогаНДС",
		"Видимость",
		Не Форма.ПоказыватьСчетаУчетаВДокументах);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"ГруппаСанкции",
		"Видимость",
		Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеПенейШтрафов")
		Или Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.ПогашениеПенейШтрафов"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"СанкцииПлатежныйДокумент",
		"Видимость",
		Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.ПогашениеПенейШтрафов"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"НалогиАналитикаУчета",
		"Видимость",
		Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"ГруппаЕдиныйСчет",
		"Видимость",
		Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.КорректировкаСчета"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"ГруппаИтоги",
		"Видимость",
		Форма.Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЕдиномуНалоговомуСчету.КорректировкаСчета"));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов Тогда
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НалогиСумма");
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.Налоги.СчетУчета", ВидСравненияКомпоновкиДанных.ВСписке, СписокСчетовАгентскогоНДС);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,,Истина));
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		
	КонецЕсли;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов
		Или Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов Тогда
		
		Если Не ПоказыватьСчетаУчетаВДокументах Тогда
			ЭлементУО = УсловноеОформление.Элементы.Добавить();
			КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НалогиВидНалогаНДС");
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
				"Объект.Налоги.Налог", ВидСравненияКомпоновкиДанных.НеРавно, Налог_НДС);
			ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
			
			Для Каждого ОписаниеСчета Из СписокОписанийСчетовНДС Цикл
				ЭлементУО = УсловноеОформление.Элементы.Добавить();
				КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НалогиВидНалогаНДС");
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
					"Объект.Налоги.ВидНалогаНДС", ВидСравненияКомпоновкиДанных.Равно, ОписаниеСчета.Значение);
				ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", ОписаниеСчета.Представление);
			КонецЦикла;
		КонецЕсли;
	
	КонецЕсли;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.КорректировкаСчета Тогда
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЕдиныйСчетПлатежныйДокумент");
		
		ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"Объект.ЕдиныйСчет.ВидДвижения", ВидСравненияКомпоновкиДанных.Равно, Ложь);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"Объект.ЕдиныйСчет.ПлатежныйДокумент", ВидСравненияКомпоновкиДанных.НеЗаполнено);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Авто>'"));
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЕдиныйСчетПлатежныйДокумент");
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.ЕдиныйСчет.ВидДвижения", ВидСравненияКомпоновкиДанных.Равно, Истина);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ПрослеживаемостьПереопределяемый.УстановитьСостояниеДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНалогиЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено
		Или РезультатВыбора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокНалоговДляЗаполнения = РезультатВыбора;
	ВопросЗаполнитьДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьДокумент()
	
	ЕстьДанные = Объект.Налоги.Количество() > 0
		ИЛИ Объект.Санкции.Количество() > 0
		ИЛИ Объект.НалоговыйАгентНДС.Количество() > 0
		ИЛИ Объект.ЕдиныйСчет.Количество() > 0;
		
	Если ЕстьДанные Тогда
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличные части будут очищены. Заполнить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьДокументЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьДокументПоОстаткамРасчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьДокументЗавершение(Результат, ИмяТабЧасти) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьДокументПоОстаткамРасчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументПоОстаткамРасчетов()
	
	Объект.Налоги.Очистить();
	Объект.Санкции.Очистить();
	Объект.НалоговыйАгентНДС.Очистить();
	Объект.ЕдиныйСчет.Очистить();
	
	ПараметрыДокумента = Новый Структура();
	ПараметрыДокумента.Вставить("Организация",         Объект.Организация);
	ПараметрыДокумента.Вставить("Дата",                Объект.Дата);
	ПараметрыДокумента.Вставить("ВидОперации",         Объект.ВидОперации);
	ПараметрыДокумента.Вставить("СписокНалогов",       СписокНалоговДляЗаполнения);
	
	// не поддерживается
	ТабицыОстатков = Новый ТаблицаЗначений;
		
	Для Каждого ДанныеТаблицы Из ТабицыОстатков Цикл
		ИмяТаблицы = СтрЗаменить(ДанныеТаблицы.Ключ, "Таблица", "");
		Для Каждого СтрокаТаблицы Из ДанныеТаблицы.Значение Цикл
			НоваяСтрока = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		КонецЦикла;
	КонецЦикла;
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоНоваяСтрока = Ложь;

#КонецОбласти
