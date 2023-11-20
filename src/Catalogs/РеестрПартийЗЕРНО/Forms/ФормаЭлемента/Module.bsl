#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриСозданииЧтенииНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЕдиницаИзмеренияКилограмм = ИнтеграцияИСКлиентСерверПовтИсп.ЕдиницаИзмеренияКилограмм();
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект,
		"ДеревоПартийХарактеристика",
		"Элементы.ДеревоПартий.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект,
		"ДеревоПартийСерия",
		"Элементы.ДеревоПартий.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(
		ЭтотОбъект,
		"ДеревоПартийСерия",
		"Элементы.ДеревоПартий.ТекущиеДанные.Характеристика");
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект, "Характеристика", "Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект, "Серия", "Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(
		ЭтотОбъект, "Серия", "Номенклатура");
		
	ИспользоватьСерииНоменклатуры          = ИнтеграцияИС.СерииИспользуются();
	ИспользоватьХарактеристикиНоменклатуры = ИнтеграцияИС.ХарактеристикиИспользуются();
	
	Если Не ИспользоватьХарактеристикиНоменклатуры Тогда
		Элементы.ДеревоПартийХарактеристика.Видимость = Ложь;
		Элементы.Характеристика.Видимость             = Ложь;
	КонецЕсли;
	
	Если Не ИспользоватьСерииНоменклатуры Тогда
		Элементы.ДеревоПартийСерия.Видимость = Ложь;
		Элементы.Серия.Видимость             = Ложь;
	КонецЕсли;
	
	СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Характеристика");
	СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Серия");
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриСозданииЧтенииНаСервере();
	
	РазблокироватьДанныеФормыДляРедактирования();
	
	СобытияФормИСПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы())
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен") И Параметр.ОбъектИзменен Тогда
			
			Прочитать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы())
	 И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Прочитать();
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СоответствиеПартийЗЕРНО"
		И Параметр = Объект.Ссылка Тогда
		ЗаполнитьСопоставлениеСНоменклатурой();
		НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "Сопоставление");
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	МассивНепроверяемыхРеквизитов.Добавить("Серия");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СобытияФормИСПереопределяемый.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий, ЭтотОбъект);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОКПДПриИзменении(Элемент)
	
	Объект.ОКПД2 = ОКПД2;
	// Очистить свойства при изменении ОКПД2
	Объект.ПотребительскиеСвойства.Очистить();
	Если ЗначениеЗаполнено(Объект.ОКПД2) Тогда
		
		ОбновитьПотребительскиеСвойстваНаСервере = ПотребительскиеСвойстваПоДаннымКеша();
		
		Если ОбновитьПотребительскиеСвойстваНаСервере Тогда
			ОбновитьПотребительскиеСвойстваНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеПартии = Новый Структура;
	ДанныеПартии.Вставить("ОКПД2", Объект.ОКПД2);
	
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуПодбораОКПД2(ЭтотОбъект, ДанныеПартии, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПДАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВидыПродукцииЗЕРНО = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
	СобытияФормЗЕРНОКлиент.ОКПД2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, ВидыПродукцииЗЕРНО);
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПДОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВидыПродукцииЗЕРНО = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
	СобытияФормЗерноКлиент.ОКПД2ОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, ВидыПродукцииЗЕРНО);
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.ОКПД2 = ВыбранноеЗначение.Код;
	ВыбранноеЗначение = ВыбранноеЗначение.Код;
	ОКПД2 = Объект.ОКПД2;
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеПартии = Новый Структура;
	ДанныеПартии.Вставить("ОКПД2", Объект.ОКПД2);
	ДанныеПартии.Вставить("КодТНВЭД", Объект.КодТНВЭД);
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуПодбораТНВЭД(ЭтотОбъект, ДанныеПартии, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаДеревоПартий
		И Объект.ПредшествующиеПартии.Количество()
		И ДеревоПартий.ПолучитьЭлементы().Количество() = 0 Тогда
		
		ЗаполнитьДеревоПартий();
		
		Для Каждого СтрокаДерева Из ДеревоПартий.ПолучитьЭлементы() Цикл
			Элементы.ДеревоПартий.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставлениеПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВыбратьСопоставление" Тогда
		СтандартнаяОбработка = Ложь;
		
		СписокИнтерактивногоВыбора = Новый СписокЗначений();
		Для Каждого СтрокаТаблицы Из Сопоставление Цикл
			СписокИнтерактивногоВыбора.Добавить(СтрокаТаблицы.НомерСтроки, СтрокаТаблицы.ПредставлениеНоменклатуры);
		КонецЦикла;
		
		ВыборСопоставленияЗавершение = Новый ОписаниеОповещения("ВыборСопоставленияЗавершение", ЭтотОбъект);
		
		ПоказатьВыборИзСписка(
			ВыборСопоставленияЗавершение,
			СписокИнтерактивногоВыбора,
			Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(Элемент, ВидПродукции, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
		Элемент, ЭтотОбъект, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,, Элемент.ТекстРедактирования, СтандартнаяОбработка, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	НоменклатураПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	ХарактеристикаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СерияПриИзменении(Элемент)
	СерияПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПотребительскиеСвойства

&НаКлиенте
Процедура ПотребительскиеСвойстваПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.ПотребительскиеСвойства.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ПотребительскиеСвойстваЗначение Тогда
		ТекущиеДанные = Элементы.ПотребительскиеСвойства.ТекущиеДанные;
		ИнтеграцияЗЕРНОКлиент.НастроитьТипЗначенияПотребительскогоСвойства(
			ЭтотОбъект,
			Элемент.ТекущийЭлемент,
			ТекущиеДанные.ПотребительскоеСвойство,
			ТекущиеДанные.Значение,
			Объект.ОКПД2);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПартий

&НаКлиенте
Процедура ДеревоПартийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = ДеревоПартий.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если Поле = Элементы.ДеревоПартийПартия Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ДанныеСтроки.Партия);
	ИначеЕсли Поле = Элементы.ДеревоПартийНоменклатура Тогда
		Если ЗначениеЗаполнено(ДанныеСтроки.Номенклатура) Тогда
			ПоказатьЗначение(, ДанныеСтроки.Номенклатура);
		ИначеЕсли ЗначениеЗаполнено(ДанныеСтроки.Представление) Тогда
			ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуСопоставленнойНоменклатурыПоПартии(ДанныеСтроки.Партия, ЭтотОбъект);
		КонецЕсли;
	ИначеЕсли Поле = Элементы.ДеревоПартийХарактеристика Тогда
		ПоказатьЗначение(, ДанныеСтроки.Характеристика);
	ИначеЕсли Поле = Элементы.ДеревоПартийСерия Тогда
		ПоказатьЗначение(, ДанныеСтроки.Серия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьЧерезБраузер(Команда)
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторФГИС)Тогда 
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
			ИнтеграцияЗЕРНОКлиентСервер.ПутьКСерверуСИнформациейОПартии(Объект.ИдентификаторФГИС, ВидПродукции));
	Иначе 
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Идентификатор Партии не заполнен!'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьПартии(Команда)
	
	ЗапросСДИЗЗавершение = Новый ОписаниеОповещения("Подключаемый_ЗапросПартийЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытияФормы = ИнтеграцияЗЕРНОСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаСправочника();
	ПараметрыОткрытияФормы.ВидЗапроса     = 1;
	ПараметрыОткрытияФормы.ТипЗапроса     = "Партии";
	ПараметрыОткрытияФормы.СсылкаНаОбъект = Объект.Ссылка;
	ПараметрыОткрытияФормы.Идентификатор  = Объект.Идентификатор;
	
	ПараметрыЗапросаПартии = ПараметрыЗапросаПартии(Объект.ВладелецПартии);
	Если ЗначениеЗаполнено(ПараметрыЗапросаПартии.Организация) Тогда
		ПараметрыОткрытияФормы.Организация = ПараметрыЗапросаПартии.Организация;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		ПараметрыОткрытияФормы.ВидПродукции = ВидПродукции;
	КонецЕсли;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуЗапросаСправочника(ПараметрыОткрытияФормы, ЭтотОбъект, ЗапросСДИЗЗавершение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВидПродукциии()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КлассификаторНСИЗЕРНО.Ссылка КАК Ссылка,
	|	КлассификаторНСИЗЕРНО.ВидПродукции
	|ИЗ
	|	Справочник.КлассификаторНСИЗЕРНО КАК КлассификаторНСИЗЕРНО
	|ГДЕ
	|	КлассификаторНСИЗЕРНО.Идентификатор = &Идентификатор";
	
	Запрос.УстановитьПараметр("Идентификатор", Объект.ОКПД2);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВидПродукции = Выборка.ВидПродукции;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыЗапросаПартии(ВладелецПартии)
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Организация");
	ВозвращаемоеЗначение.Вставить("Подразделение");
	
	ДанныеСопоставления = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.ОрганизацииКонтрагентыПоКлючам(ВладелецПартии)[ВладелецПартии];
	Если ДанныеСопоставления <> Неопределено Тогда
		ВозвращаемоеЗначение.Организация   = ДанныеСопоставления.Организация;
		ВозвращаемоеЗначение.Подразделение = ДанныеСопоставления.Подразделение;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ЗапросПартийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Прочитать();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект,
		"ДеревоПартийХарактеристика",
		"ДеревоПартий.ХарактеристикиИспользуются");
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект,
		"ДеревоПартийСерия",
		"ДеревоПартий.СтатусУказанияСерий",
		"ДеревоПартий.ТипНоменклатуры");
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются"); 
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект, "Серия", "СтатусУказанияСерий", "ТипНоменклатуры");
		
	СобытияФормЗЕРНО.УстановитьУсловноеОформлениеПотребительскогоСвойства(ЭтотОбъект);
	СобытияФормЗЕРНО.УстановитьУсловноеОформлениеПотребительскогоСвойстваДиапазон(ЭтотОбъект);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПартийНоменклатура.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоПартий.Представление");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      Новый ПолеКомпоновкиДанных("ДеревоПартий.Представление"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Справочники.РеестрПартийЗЕРНО);
	
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(ЭтотОбъект, РегистрыСведений.СоответствиеПартийЗЕРНО);
	
	ЗаполнитьДоступныеЦелиИспользования(ЭтотОбъект);
	ЗаполнитьНазначениеПартии(ЭтотОбъект);
	ЗаполнитьГодУрожая(ЭтотОбъект);
	ЗаполнитьВидПродукциии();
	
	Если ЗначениеЗаполнено(Объект.ОКПД2) Тогда
		
		ТаблицаОКПД2 = ИнтеграцияЗЕРНО.НаименованияКодовОКПД2ПоТабличнойЧасти(Объект.ОКПД2);
		ДанныеОКПД2 = ТаблицаОКПД2.Найти(Объект.ОКПД2);
		Если ДанныеОКПД2 <> Неопределено Тогда
			ОКПД2 = ИнтеграцияЗЕРНОКлиентСервер.ПредставлениеОКПД2(
				ДанныеОКПД2.Наименование, ДанныеОКПД2.Идентификатор);
		КонецЕсли;
		
		ИнициализироватьТип = Объект.Ссылка.Пустая() Или Модифицированность;
		ИнтеграцияЗЕРНО.ИнициализироватьСлужебныеРеквизитыПотребительскихСвойств(
			ЭтотОбъект, Объект.ОКПД2, ИнициализироватьТип);
		
	КонецЕсли;
	
	ЗаполнитьСопоставлениеСНоменклатурой(Ложь);
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		СобытияФормИСКлиентСерверПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(
			ЭтотОбъект, ВидПродукции, "Номенклатура");
	Иначе
		СобытияФормИСКлиентСерверПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(
			ЭтотОбъект, ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции(), "Номенклатура");
	КонецЕсли;
	
	Если Объект.ПредшествующиеПартии.Количество()
		И ДеревоПартий.ПолучитьЭлементы().Количество() Тогда
		ЗаполнитьДеревоПартий();
	КонецЕсли;
	
	СоздатьКэшПотребительскихСвойств();
	ЗаполнитьСвязанныеСДИЗ();
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДоступныеЦелиИспользования(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ЦельИспользования.СписокВыбора.Очистить();
	Элементы.ЦельИспользования.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииКормовые"));
	Элементы.ЦельИспользования.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииПищевые"));
	Элементы.ЦельИспользования.СписокВыбора.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПартий()
	
	ДеревоПартий.ПолучитьЭлементы().Очистить();
	Если Объект.ПредшествующиеПартии.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПостроения = Справочники.РеестрПартийЗЕРНО.ПараметрыПостроенияДереваПартий();
	ПараметрыПостроения.ИсходныеПартии.Добавить(Объект.Ссылка);
	
	ДанныеДереваПартий                    = Справочники.РеестрПартийЗЕРНО.ДеревоПартий(ПараметрыПостроения);
	СоответствиеСтрокДереваПоНоменклатуре = Новый Соответствие();
	КешированныеЗначения                  = Неопределено;
	
	Для Каждого СтрокаДерева Из ДанныеДереваПартий.Строки Цикл
		ЗаполнитьСтрокуДереваРекурсивно(
			СтрокаДерева,
			ДеревоПартий,
			СоответствиеСтрокДереваПоНоменклатуре,
			КешированныеЗначения);
	КонецЦикла;
	
	ЗаполнитьСлужебныеРеквизитыДереваЗначенийПоНоменкалутре(СоответствиеСтрокДереваПоНоменклатуре);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуДереваРекурсивно(УзелИсточник, УзелПриемник, СоответствиеСтрокДереваПоНоменклатуре, КешированныеЗначения)
	
	ПозицииДляПересчетаКоличества = Новый Массив;
	Для Каждого СтрокаДерева Из УзелИсточник.Строки Цикл
		
		НоваяСтрока = УзелПриемник.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДерева,, "Количество");
		НоваяСтрока.КоличествоЗЕРНО = СтрокаДерева.Количество;
		
		КоличествоСтрокСопоставления = СтрокаДерева.Сопоставления.Количество();
		Если КоличествоСтрокСопоставления = 1 Тогда
			Для Каждого СтрокаСопоставления Из СтрокаДерева.Сопоставления Цикл
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСопоставления, "Номенклатура,Характеристика,Серия,СтатусУказанияСерий");
				Прервать;
			КонецЦикла;
		ИначеЕсли КоличествоСтрокСопоставления > 1 Тогда
			ПараметрыФормированияНадписи = ИнтеграцияЗЕРНОКлиентСервер.ПараметрыПредставленияТабличнойЧасти("Номенклатура");
			ПараметрыФормированияНадписи.Пустая = "";
			НоваяСтрока.Представление = ИнтеграцияЗЕРНОКлиентСервер.СформироватьНадписьПоДаннымТабличнойЧасти(
				СтрокаДерева.Сопоставления,
				ПараметрыФормированияНадписи);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
			МассивСтрок = СоответствиеСтрокДереваПоНоменклатуре[НоваяСтрока.Номенклатура];
			Если МассивСтрок = Неопределено Тогда
				МассивСтрок = Новый Массив();
				СоответствиеСтрокДереваПоНоменклатуре[НоваяСтрока.Номенклатура] = МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(НоваяСтрока);
			ПозицииДляПересчетаКоличества.Добавить(НоваяСтрока);
		КонецЕсли;
		
		ЗаполнитьСтрокуДереваРекурсивно(
			СтрокаДерева,
			НоваяСтрока,
			СоответствиеСтрокДереваПоНоменклатуре,
			КешированныеЗначения);
		
	КонецЦикла;
	
	ИнтеграцияЗЕРНОПереопределяемый.ЗаполнитьКоличествоПоКоличествуЗЕРНО(ПозицииДляПересчетаКоличества);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНазначениеПартии(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.НазначениеПартии.СписокВыбора.Очистить();
	Элементы.НазначениеПартии.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииВывозСТерриторииРФ"));
	Элементы.НазначениеПартии.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииВвозНаТерриториюРФ"));
	Элементы.НазначениеПартии.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииПереработка"));
	Элементы.НазначениеПартии.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииХранениеОбработка"));
	
	Элементы.НазначениеПартии.СписокВыбора.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьГодУрожая(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГодУрожая.СписокВыбора.Очистить();
	ТекущийГод = Год(ТекущаяДата());
	Для ЗначениеВыбора = ТекущийГод - 12 По ТекущийГод Цикл
		Элементы.ГодУрожая.СписокВыбора.Добавить(ЗначениеВыбора, Формат(ЗначениеВыбора, "ЧЦ=4; ЧГ=;"));
	КонецЦикла;
	
	Элементы.ГодУрожая.СписокВыбора.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Инициализация       = ПустаяСтрока(СписокРеквизитов);
	ЭтоНовый            = Объект.Ссылка.Пустая();
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если Инициализация Тогда
		
		Элементы.РезультатИсследования.Видимость = ЗначениеЗаполнено(Объект.РезультатИсследования) Или ЭтоНовый;
		Элементы.Элеватор.Видимость              = ЗначениеЗаполнено(Объект.Элеватор) Или ЭтоНовый;
		Элементы.ГодУрожая.Видимость             = ЗначениеЗаполнено(Объект.ГодУрожая) Или ЭтоНовый;
		Элементы.КодТНВЭД.Видимость              = ЗначениеЗаполнено(Объект.КодТНВЭД) Или ЭтоНовый;
		Элементы.ЦельИспользования.Видимость     = ЗначениеЗаполнено(Объект.ЦельИспользования) Или ЭтоНовый;
		Элементы.Производитель.Видимость         = ЗначениеЗаполнено(Объект.Производитель) Или ЭтоНовый;
		Элементы.ДатаИзготовления.Видимость      = ЗначениеЗаполнено(Объект.ДатаИзготовления) Или ЭтоНовый;
		Элементы.ОткрытьЧерезБраузер.Видимость   = ЗначениеЗаполнено(Объект.ИдентификаторФГИС);
		Элементы.ДеревоПартий.Видимость          = Объект.ПредшествующиеПартии.Количество();
		
		Элементы.Идентификатор.ТолькоПросмотр           = (Не ЭтоНовый);
		Элементы.Дата.ТолькоПросмотр                    = (Не ЭтоНовый);
		Элементы.ВладелецПартии.ТолькоПросмотр          = (Не ЭтоНовый);
		Элементы.Производитель.ТолькоПросмотр           = (Не ЭтоНовый);
		Элементы.НазначениеПартии.ТолькоПросмотр        = (Не ЭтоНовый);
		Элементы.ЦельИспользования.ТолькоПросмотр       = (Не ЭтоНовый);
		Элементы.ГодУрожая.ТолькоПросмотр               = (Не ЭтоНовый);
		Элементы.ДатаИзготовления.ТолькоПросмотр        = (Не ЭтоНовый);
		Элементы.Элеватор.ТолькоПросмотр                = (Не ЭтоНовый);
		Элементы.ТребуетсяЗагрузка.Доступность          = ЭтоНовый;
		Элементы.ОКПД2.ТолькоПросмотр                   = (Не ЭтоНовый);
		Элементы.КодТНВЭД.ТолькоПросмотр                = (Не ЭтоНовый);
		Элементы.Местоположение.ТолькоПросмотр          = (Не ЭтоНовый);
		Элементы.Количество.ТолькоПросмотр              = (Не ЭтоНовый);
		Элементы.КоличествоНачальное.ТолькоПросмотр     = (Не ЭтоНовый);
		Элементы.РезультатИсследования.ТолькоПросмотр   = (Не ЭтоНовый);
		Элементы.ПотребительскиеСвойства.ТолькоПросмотр = (Не ЭтоНовый);
		
		Элементы.НадписьСДИЗ.Видимость = ЗначениеЗаполнено(Форма.НадписьСДИЗ);
		
		ЭтоЭкспорт = Объект.НазначениеПартии = ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииВывозСТерриторииРФ");
		Элементы.ГруппаСтранаНазначения.Видимость = ЭтоЭкспорт;
		Если ЭтоЭкспорт Тогда
			
			Элементы.СтранаНазначения.Видимость = ЗначениеЗаполнено(Объект.СтранаНазначения) Или ЭтоНовый;
			Элементы.КодСтраныНазначения.Видимость = Не ЗначениеЗаполнено(Объект.СтранаНазначения) И Не ЭтоНовый;
			
			Элементы.СтранаНазначения.ТолькоПросмотр    = (Не ЭтоНовый);
			Элементы.КодСтраныНазначения.ТолькоПросмотр = (Не ЭтоНовый);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("Сопоставление") Тогда
		Элементы.СопоставлениеПредставление.Видимость = Форма.ОтображатьГиперссылкуСопоставлений;
		Элементы.Номенклатура.Доступность = (Не ЭтоНовый);
	КонецЕсли;
	
КонецПроцедуры

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СопоставлениеСНоменклатурой

&НаКлиенте
Процедура ВыборСопоставленияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("НомерСтроки", ВыбранныйЭлемент.Значение);
	Для Каждого СтрокаТаблицы Из Сопоставление.НайтиСтроки(СтруктураПоиска) Цикл
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтрокаТаблицы);
		Прервать;
	КонецЦикла;
	
	ОчиститьСообщения();
	ВыборСопоставленияНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СопоставлениеМожноЗаписать(ВыводитьТекстОшибки = Ложь, ПроверятьСерию = Ложь)
	
	ВозвращаемоеЗначение = Истина;
	Если ПроверятьСерию
		И ИнтеграцияИСКлиентСервер.НеобходимоУказатьСерию(СтатусУказанияСерий)
		И Не ЗначениеЗаполнено(Серия) Тогда
		ВозвращаемоеЗначение = Ложь;
		Если ВыводитьТекстОшибки Тогда
			ИнтеграцияИС.СообщитьПользователюВФорму(
				УникальныйИдентификатор,
				НСтр("ru = 'Поле ""Серия"" не заполнено'"),,
				"Серия");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Номенклатура)
		И ХарактеристикиИспользуются
		И Не ЗначениеЗаполнено(Характеристика) Тогда
		ВозвращаемоеЗначение = Ложь;
		Если ВыводитьТекстОшибки Тогда
			ИнтеграцияИС.СообщитьПользователюВФорму(
				УникальныйИдентификатор,
				НСтр("ru = 'Поле ""Характеристика"" не заполнено'"),,
				"Характеристика");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	
	Характеристика = Неопределено;
	Серия          = Неопределено;
	
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();
	
	СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Серия");
	
	Если СопоставлениеМожноЗаписать() Тогда
		ЗаписатьСопоставление();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ХарактеристикаПриИзмененииНаСервере()
	
	Серия = Неопределено;
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();
	СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Характеристика");
	
	Если СопоставлениеМожноЗаписать() Тогда
		ЗаписатьСопоставление();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СерияПриИзмененииНаСервере()
	
	ЗаполнитьСлужебныеРеквизитыНоменклатуры();
	
	Если СопоставлениеМожноЗаписать() Тогда
		ЗаписатьСопоставление();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыборСопоставленияНаСервере()
	
	Если СопоставлениеМожноЗаписать(Истина) Тогда
		ЗаписатьСопоставление();
	Иначе
		ЗаполнитьСопоставлениеСНоменклатурой();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСопоставление()
	
	НачатьТранзакцию();
	
	Блокировка = Новый БлокировкаДанных();
	
	ЭлементБлокировки = Блокировка.Добавить(Метаданные.РегистрыСведений.СоответствиеПартийЗЕРНО.ПолноеИмя());
	ЭлементБлокировки.УстановитьЗначение("Партия", Объект.Ссылка);
	
	НаборЗаписей = РегистрыСведений.СоответствиеПартийЗЕРНО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Партия.Установить(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		СтрокаНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаНабора, ЭтотОбъект);
		СтрокаНабора.Партия = Объект.Ссылка;
	КонецЕсли;
	
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		Блокировка.Заблокировать();
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки = НСтр("ru = 'При записи соответствия номенклатуры ЗЕРНО произошла ошибка:'")
			+ Символы.ПС + "%1";
		
		ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(ТекстОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке())));
		
		ИнтеграцияЗЕРНОСлужебный.ЗаписатьОшибкуВЖурналРегистрации(
			СтрШаблон(ТекстОшибки, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		
	КонецПопытки;
	
	ЗаполнитьСопоставлениеСНоменклатурой();
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "Сопоставление");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСопоставлениеСНоменклатурой(ПрименятьУсловноеОформление = Истина)
	
	Сопоставление.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СоответствиеПартийЗЕРНО.Номенклатура        КАК Номенклатура,
		|	СоответствиеПартийЗЕРНО.Характеристика      КАК Характеристика,
		|	СоответствиеПартийЗЕРНО.Серия               КАК Серия,
		|	СоответствиеПартийЗЕРНО.Партия              КАК Партия,
		|	СоответствиеПартийЗЕРНО.СтатусУказанияСерий КАК СтатусУказанияСерий,
		|	ЛОЖЬ                                        КАК ХарактеристикиИспользуются,
		|	СоответствиеПартийЗЕРНО.Порядок             КАК Порядок,
		|	1                                           КАК Счетчик
		|ИЗ
		|	РегистрСведений.СоответствиеПартийЗЕРНО КАК СоответствиеПартийЗЕРНО
		|ГДЕ
		|	СоответствиеПартийЗЕРНО.Партия = &Партия
		|	И &Партия <> ЗНАЧЕНИЕ(Справочник.РеестрПартийЗЕРНО.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия Убыв";
	
	Запрос.УстановитьПараметр("Партия", Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Сопоставление.Загрузить(ТаблицаДанных);
	НомерСтроки = 1;
	Для Каждого СтрокаТаблицы Из Сопоставление Цикл
		СтрокаТаблицы.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
		СтрокаТаблицы.ПредставлениеНоменклатуры = ИнтеграцияИС.ПредставлениеНоменклатуры(
			СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика,, СтрокаТаблицы.Серия);
	КонецЦикла;
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Сопоставление);
	
	ТаблицаДанных.Свернуть("Номенклатура,Характеристика","Счетчик");
	
	ОтображатьГиперссылкуСопоставлений = (Сопоставление.Количество() > 0);
	
	Если ТаблицаДанных.Количество() = 1 Тогда
		ВариантовСерий = ТаблицаДанных[0].Счетчик - 1;
		Если ВариантовСерий < 2 Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Сопоставление[0]); //по серии
			ОтображатьГиперссылкуСопоставлений = Ложь;
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Сопоставление[ВариантовСерий]); //без серии
		КонецЕсли;
	Иначе
		Номенклатура               = Неопределено;
		Характеристика             = Неопределено;
		Серия                      = Неопределено;
		СтатусУказанияСерий        = 0;
		ХарактеристикиИспользуются = Ложь;
		ТипНоменклатуры            = Неопределено;
	КонецЕсли;
	
	Если ПрименятьУсловноеОформление Тогда
		СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Характеристика");
		СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Серия");
	КонецЕсли;
	
	Если ОтображатьГиперссылкуСопоставлений Тогда
		ПараметрыФормированияНадписи = ИнтеграцияЗЕРНОКлиентСервер.ПараметрыПредставленияТабличнойЧасти("ПредставлениеНоменклатуры");
		ПараметрыФормированияНадписи.Пустая = "";
		СопоставлениеПредставление = Новый ФорматированнаяСтрока(
			ИнтеграцияЗЕРНОКлиентСервер.СформироватьНадписьПоДаннымТабличнойЧасти(
				Сопоставление,
				ПараметрыФормированияНадписи),,
				ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС,,
			"ВыбратьСопоставление");
	Иначе
		СопоставлениеПредставление = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыНоменклатуры()
	
	ВременнаяТаблица = Сопоставление.Выгрузить(Новый Массив());
	НоваяСтрока = ВременнаяТаблица.Добавить();
	НоваяСтрока.НомерСтроки    = 1;
	НоваяСтрока.Номенклатура   = Номенклатура;
	НоваяСтрока.Характеристика = Характеристика;
	НоваяСтрока.Серия          = Серия;
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, ВременнаяТаблица);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(НоваяСтрока, ПараметрыУказанияСерий);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВременнаяТаблица[0]);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыДереваЗначенийПоНоменкалутре(СоответствиеСтрокДереваПоНоменклатуре)
	
	ТаблицаТовары = Новый ТаблицаЗначений();
	ТаблицаТовары.Колонки.Добавить("НомерСтроки",                ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаТовары.Колонки.Добавить("Номенклатура",               Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаТовары.Колонки.Добавить("ХарактеристикиИспользуются", Новый ОписаниеТипов("Булево"));
	ТаблицаТовары.Колонки.Добавить("ЕдиницаИзмерения",           Метаданные.ОпределяемыеТипы.Упаковка.Тип);
	ТаблицаТовары.Колонки.Добавить("ТипНоменклатуры",            Метаданные.ОпределяемыеТипы.ТипНоменклатуры.Тип);
	
	Для Каждого КлючИЗначение Из СоответствиеСтрокДереваПоНоменклатуре Цикл
		НоваяСтрока = ТаблицаТовары.Добавить();
		НоваяСтрока.Номенклатура = КлючИЗначение.Ключ;
		НоваяСтрока.НомерСтроки  = ТаблицаТовары.Количество();
	КонецЦикла;
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, ТаблицаТовары);
	
	Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
		СтрокиДерева = СоответствиеСтрокДереваПоНоменклатуре[СтрокаТаблицы.Номенклатура];
		Если СтрокиДерева = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			СтрокаДерева.ХарактеристикиИспользуются = СтрокаТаблицы.ХарактеристикиИспользуются;
			СтрокаДерева.ТипНоменклатуры            = СтрокаТаблицы.ТипНоменклатуры;
			СтрокаДерева.ЕдиницаИзмерения           = СтрокаТаблицы.ЕдиницаИзмерения;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Прочитать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвязанныеСДИЗ()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СДИЗЗЕРНО.Ссылка КАК СДИЗ,
		|	СДИЗЗЕРНО.ДатаОформления КАК ДатаОформления
		|ИЗ
		|	Справочник.СДИЗЗЕРНО КАК СДИЗЗЕРНО
		|ГДЕ
		|	СДИЗЗЕРНО.Партия = &Партия
		|	И &Партия <> ЗНАЧЕНИЕ(Справочник.РеестрПартийЗЕРНО.ПустаяСсылка)
		|	ИЛИ СДИЗЗЕРНО.НомерПартии = &НомерПартии
		|	И &НомерПартии <> """"
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОформления УБЫВ";
	
	Запрос.УстановитьПараметр("НомерПартии", Объект.Идентификатор);
	Запрос.УстановитьПараметр("Партия",      Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДанныеСтроки = Новый Массив();
	
	ВыводитьСтрок      = 2;
	ТекущийНомерСтроки = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ДанныеСтроки.Количество() Тогда
			ДанныеСтроки.Добавить(" ");
		КонецЕсли;
		Если ТекущийНомерСтроки >= ВыводитьСтрок Тогда
			ДанныеСтроки.Добавить(СтрШаблон(НСтр("ru = '(+ еще %1...)'"), ВыборкаДетальныеЗаписи.Количество() - ВыводитьСтрок));
			Прервать;
		КонецЕсли;
		ДанныеСтроки.Добавить(
			Новый ФорматированнаяСтрока(
				Строка(ВыборкаДетальныеЗаписи.СДИЗ),,,,
				ПолучитьНавигационнуюСсылку(ВыборкаДетальныеЗаписи.СДИЗ)));
		ТекущийНомерСтроки = ТекущийНомерСтроки + 1;
	КонецЦикла;
	
	НадписьСДИЗ = Новый ФорматированнаяСтрока(ДанныеСтроки);
	
КонецПроцедуры

#Область ПотребительскиеСвойства

&НаСервере
Процедура СоздатьКэшПотребительскихСвойств()
	
	КодыОКДП2 = Новый Массив;
	Если ЗначениеЗаполнено(Объект.ОКПД2) Тогда
		КодыОКДП2.Добавить(Объект.ОКПД2);
	КонецЕсли;
	
	Если КодыОКДП2.Количество() Тогда
		ПотребительскиеСвойства = ИнтеграцияЗЕРНО.ПотребительскиеСвойстваПродукцииПоДаннымОКПД2(КодыОКДП2, Объект.НазначениеПартии);
		ИнтеграцияЗЕРНО.ОбновитьКэшПотребительскихСвойств(ЭтотОбъект, ПотребительскиеСвойства, КодыОКДП2);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПотребительскиеСвойстваПоДаннымКеша()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ОКПД2", Объект.ОКПД2);
	ПотребительскиеСвойства = КэшПотребительскихСвойств.НайтиСтроки(ПараметрыОтбора);
	Если ПотребительскиеСвойства.Количество() Тогда
		Для Каждого Строка Из ПотребительскиеСвойства Цикл
			НоваяСтрока = Объект.ПотребительскиеСвойства.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьПотребительскиеСвойстваНаСервере()
	
	ПотребительскиеСвойства = ИнтеграцияЗЕРНО.ПотребительскиеСвойстваПродукцииПоДаннымОКПД2(Объект.ОКПД2, Объект.НазначениеПартии);
	Если ПотребительскиеСвойства <> Неопределено Тогда
		
		ИнтеграцияЗЕРНО.ОбновитьКэшПотребительскихСвойств(ЭтотОбъект, ПотребительскиеСвойства, Объект.ОКПД2);
		
		Для Каждого СтрокаПотребительскогоСвойства Из ПотребительскиеСвойства Цикл
			НоваяСтрока = Объект.ПотребительскиеСвойства.Добавить();
			ИнтеграцияЗЕРНОКлиентСервер.ЗаполнитьСтрокуПотребительскогоСвойства(ЭтотОбъект, НоваяСтрока, СтрокаПотребительскогоСвойства);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
