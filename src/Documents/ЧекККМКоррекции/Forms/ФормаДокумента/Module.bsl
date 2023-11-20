
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ПробитьЧекВыполнитьЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтотОбъект.Доступность = Истина;
	
	Если РезультатВыполнения.Результат Тогда
		
		Объект.НомерСмены = РезультатВыполнения.НомерСменыККТ;
		Объект.НомерЧека =  РезультатВыполнения.НомерЧекаККТ;
		Объект.ПробитЧек = Истина;

		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Запись);
		Записать(ПараметрыЗаписи);
		ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.ФормаПробитьЧек.Доступность = Ложь;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'При печати чека произошла ошибка:'");
		ТекстСообщения = ТекстСообщения + Символы.ПС + РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСтраныПроихождения (РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения <> Неопределено Тогда
		
		ТекущаяСтрока = Объект.ПозицииЧека.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока.КодСтраныПроисхожденияТовара = КодСтраныПроихождения(РезультатВыполнения);
			Элементы.ПозицииЧека.ЗакончитьРедактированиеСтроки(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодСтраныПроихождения(Страна)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Страна, "Код");
	
КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеККМЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		СписокВыбораСНО = Элементы.СистемаНалогообложения.СписокВыбора;
	
		СтрокаСНО  = РезультатВыполнения.ПараметрыККТ.КодыСистемыНалогообложения;
		МассивКодовСНО  = СтрРазделить(СтрокаСНО, ",");
		
		Для Каждого КодСНО Из МассивКодовСНО Цикл
			
			Попытка
				КодСНОЧисло = Число(КодСНО);
				СписокВыбораСНО.Добавить(ОборудованиеЧекопечатающиеУстройстваКлиентСервер.СистемаНалогообложенияККТПоКоду(КодСНОЧисло));
			Исключение
			КонецПопытки;
			
		КонецЦикла;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Не удалось получить список систем налогообложения поддерживаемых кассой ККМ:'");
		ТекстСообщения = ТекстСообщения + Символы.ПС + РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		Объект.СистемаНалогообложения = ПредопределенноеЗначение("Перечисление.ТипыСистемНалогообложенияККТ.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УправлениеВидимостьюИДоступностьюВсехЭлементов();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		УправлениеВидимостьюИДоступностьюВсехЭлементов();
	КонецЕсли;
	
	ОснованиеНеприменениеККТ 	= "Неприменение ККТ";
	ДокументНедоступен			= "<Документ недоступен>";
	
	ПроверитьДокументыОснованияИРасчетов();
	ЗаполнитьСпискиВыбораЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПоддерживаемыеСНО();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УправлениеВидимостьюИДоступностьюВсехЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Проведен", Объект.Проведен);
	ПараметрыОповещения.Вставить("ПробитЧек", Объект.ПробитЧек);
	
	Оповестить("ЗаписьЧекаКоррекции", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияНеприменениеККТПриИзменении(Элемент)
	
	Объект.КассаККМ = КассаПоУмолчанию(Объект.Организация, Объект.СтруктурнаяЕдиница);
	ЗаполнитьПоддерживаемыеСНО();
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупательПриИзменении(Элемент)
	
	Если ТипЗнч(Объект.Покупатель) <> Тип("Строка") И ЗначениеЗаполнено(Объект.Покупатель) Тогда
		Объект.ПокупательИНН = ИННПокупателя(Объект.Покупатель);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИННПокупателя(Покупатель)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Покупатель, "ИНН");
	
КонецФункции

&НаКлиенте
Процедура ТипКоррекцииПриИзменении(Элемент)
	
	Если Объект.ТипКоррекции = 1 Тогда
		Элементы.НомерПредписания.Видимость = Истина;
	Иначе 
		Элементы.НомерПредписания.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КассаККМПриИзменении(Элемент)
	
	ЗаполнитьПоддерживаемыеСНО();
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтруктурнаяЕдиница) Тогда
		
		Объект.АдресМагазина = АдресМагазина(Объект.СтруктурнаяЕдиница);
		Объект.АдресРасчетов = Объект.АдресМагазина;
		Объект.МестоРасчетов = Строка(Объект.СтруктурнаяЕдиница) + " " + Объект.АдресМагазина;
		
	Иначе 
		
		Объект.АдресМагазина = "";
		Объект.АдресРасчетов = "";
		Объект.МестоРасчетов = "";
		
	КонецЕсли;
	
	Объект.КассаККМ = КассаПоУмолчанию(Объект.Организация, Объект.СтруктурнаяЕдиница);
	ЗаполнитьПоддерживаемыеСНО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Ответственный) Тогда
		
		РеквизитыКассира = РеквизитыОтветственного(Объект.Ответственный);
		
		Объект.Кассир 		= РеквизитыКассира.ИмяКассира;
		Объект.КассирИНН 	= РеквизитыКассира.КассирИНН;
		
	Иначе
		
		Объект.Кассир 		= "";
		Объект.КассирИНН 	= "";
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыОтветственного(Ответственный)
	
	РеквизитыКассира = РозничныеПродажиСервер.ПолучитьРеквизитыКассира(Ответственный);
	
	Возврат РеквизитыКассира;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПозицииЧека

&НаКлиенте
Процедура ПозицииЧекаНаименованиеПредметаРасчетаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПозицииЧека.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено 
		И ТипЗнч(ТекущаяСтрока.НаименованиеПредметаРасчета) = Тип("СправочникСсылка.Номенклатура")
		И ЗначениеЗаполнено(ТекущаяСтрока.НаименованиеПредметаРасчета) Тогда
		
		РеквизитыНоменклатуры = РеквизитыПредметаРасчета(ТекущаяСтрока.НаименованиеПредметаРасчета, Объект.Дата);
		
		ТекущаяСтрока.ЕдиницаИзмерения 	= Строка(РеквизитыНоменклатуры.ЕдиницаИзмерения);
		ТекущаяСтрока.СтавкаНДС 		= РеквизитыНоменклатуры.СтавкаНДС;
		
		ПересчитатьСуммуНДССтроки(ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыПредметаРасчета(НаименованиеПредметаРасчета, ДатаОбработки = Неопределено)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ЕдиницаИзмерения");
	СтруктураРеквизитов.Вставить("ВидСтавкиНДС");
	
	РеквизитыредметаРасчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НаименованиеПредметаРасчета, СтруктураРеквизитов);
	
	Если ЗначениеЗаполнено(РеквизитыредметаРасчета.ВидСтавкиНДС) Тогда
		СтруктураРеквизитов.Вставить("СтавкаНДС", Справочники.СтавкиНДС.СтавкаНДС(РеквизитыредметаРасчета.ВидСтавкиНДС, ?(ЗначениеЗаполнено(ДатаОбработки), ДатаОбработки, ТекущаяДатаСеанса())));
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

&НаКлиенте
Процедура ПозицииЧекаКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПозицииЧека.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПересчитатьСуммуСтроки(ТекущаяСтрока);
		ПересчитатьСуммуНДССтроки(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииЧекаЦенаСоСкидкамиПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПозицииЧека.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПересчитатьСуммуСтроки(ТекущаяСтрока);
		ПересчитатьСуммуНДССтроки(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииЧекаСуммаСоСкидкамиПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПозицииЧека.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущаяСтрока.ЦенаСоСкидками = ?(ТекущаяСтрока.Количество = 0, ТекущаяСтрока.СуммаСоСкидками, ТекущаяСтрока.СуммаСоСкидками / ТекущаяСтрока.Количество);
		ПересчитатьСуммуНДССтроки(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииЧекаСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПозицииЧека.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПересчитатьСуммуНДССтроки(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииЧекаПризнакАгентаПоПредметуРасчетаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПозицииЧека.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ПризнакАгентаПоПредметуРасчета) Тогда
		ТекущаяСтрока.ПлатежныйАгентОперация 			= "";
		ТекущаяСтрока.ПлатежныйАгентТелефон 			= "";
		ТекущаяСтрока.ОператорПоПриемуПлатежейТелефон 	= "";
		ТекущаяСтрока.ОператорПереводаНаименование 		= "";
		ТекущаяСтрока.ОператорПереводаИНН 				= "";
		ТекущаяСтрока.ОператорПереводаАдрес 			= "";
		ТекущаяСтрока.ОператорПереводаТелефон 			= "";
		ТекущаяСтрока.ДанныеПоставщикаНаименование 		= "";
		ТекущаяСтрока.ДанныеПоставщикаИНН 				= "";
		ТекущаяСтрока.ДанныеПоставщикаТелефон 			= "";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПозицииЧекаКодСтраныПроисхожденияТовараНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторСтроки = Элементы.ПозицииЧека.ТекущиеДанные.ПолучитьИдентификатор();
	
	ДополнительныеПараметры = Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки);
	ОбработчикОповещения 	= Новый ОписаниеОповещения("ВыборСтраныПроихождения", ЭтотОбъект, ДополнительныеПараметры);

	ПоказатьВводЗначения(ОбработчикОповещения,,"Выбор страны проихождения товара", Тип("СправочникСсылка.СтраныМира")); 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПробитьЧек(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	Если Объект.ПометкаУдаления Тогда
		ТекстОшибки = НСтр("ru = 'Документ помечен на удаление'");
	ИначеЕсли Объект.Проведен Тогда
		Если Модифицированность Тогда
			ТекстОшибки = НСтр("ru = 'Измененный документ не сохранен'");
		КонецЕсли;
	Иначе
		ТекстОшибки = НСтр("ru = 'Документ не проведен'");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.Доступность = Ложь;
	ИдентификаторУстройства = Неопределено;
	ОбщиеПараметры  = ПодготовитьДанныеДляПробитияЧека(Объект.Ссылка, ИдентификаторУстройства);
	
	Если ОбщиеПараметры <> Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПробитьЧекВыполнитьЗавершение", ЭтотОбъект);
		
		Если Объект.НеприменениеККТ Тогда
			ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьФормированиеЧекаКоррекцииНаФискальномУстройстве(
				Оповещение, 
				ЭтотОбъект.УникальныйИдентификатор, 
				ИдентификаторУстройства,
				ОбщиеПараметры);
		Иначе
			ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьФискализациюЧекаНаФискальномУстройстве(
				Оповещение, 
				ЭтотОбъект.УникальныйИдентификатор, 
				ИдентификаторУстройства,
				ОбщиеПараметры);
		КонецЕсли;
		
	Иначе // печать невозможна
		
		ЭтотОбъект.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеВидимостьюИДоступностьюВсехЭлементов()
	
	Если Объект.ПробитЧек Тогда
		ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.ФормаПробитьЧек.Доступность = Ложь;
	ИначеЕсли Объект.ЭтоСторно Тогда
		ЭтотОбъект.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.НередактируемыеДанныеОшибка.Видимость 	= НЕ Объект.НеприменениеККТ;
	Элементы.ТипРасчетаНеприменениеККТ.Видимость 	= Объект.НеприменениеККТ;
	Элементы.ОрганизацияНеприменениеККТ.Видимость 	= Объект.НеприменениеККТ;
	Элементы.ОснованиеНеприменениеККТ.Видимость 	= Объект.НеприменениеККТ;
	Элементы.ДатаКоррекцииНеприменениеККТ.Видимость = Объект.НеприменениеККТ;
	Элементы.НомерПредписания.Видимость 			= Объект.ТипКоррекции = 1;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьДанныеДляПробитияЧека(ЧекКоррекции, ИдентификаторУстройства)
	
	Возврат Документы.ЧекККМКоррекции.ПодготовитьДанныеДляПробитияЧека(ЧекКоррекции, ИдентификаторУстройства);
	
КонецФункции

&НаКлиенте
Процедура ПересчитатьСуммуСтроки(ТекущаяСтрока)
	ТекущаяСтрока.СуммаСоСкидками = ТекущаяСтрока.Количество * ТекущаяСтрока.ЦенаСоСкидками;
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуНДССтроки(ТекущаяСтрока)
	
	ТекПроцентНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(ТекущаяСтрока.СтавкаНДС) / 100;
	ТекущаяСтрока.СуммаНДС = ТекущаяСтрока.СуммаСоСкидками * ТекПроцентНДС / (ТекПроцентНДС + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
		
	СуммаПродажи = Объект.ПозицииЧека.Итог("СуммаСоСкидками");
	СуммаОплат   = Объект.Оплата.Итог("Сумма");
	
	ТекущаяСтрока = Элементы.Оплата.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущаяСумма  = ТекущаяСтрока.Сумма;
		ОплатаБезТекущейСтроки = СуммаОплат - ТекущаяСумма;
		ОстатокОплаты = СуммаПродажи - ОплатаБезТекущейСтроки;
	КонецЕсли;
	
	Элементы.ОплатаСумма.СписокВыбора.Очистить();
	
	Если ОстатокОплаты > 0 Тогда
		
		Элементы.ОплатаСумма.СписокВыбора.Добавить(ОстатокОплаты, Формат(ОстатокОплаты, "ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=' '; ЧН=; ЧГ=3,0"));
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресМагазина(СтруктурнаяЕдиница)
	
	Возврат ПечатьДокументовУНФ.КонтактнаяИнформация(СтруктурнаяЕдиница, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы"));
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоддерживаемыеСНО()
	
	Элементы.СистемаНалогообложения.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(Объект.КассаККМ) Тогда 
		
		ИдентификаторУстройства = ПолучитьИдентификаторУстройства(Объект.КассаККМ);
		
		Оповещение = Новый ОписаниеОповещения("ПолучитьДанныеККМЗавершение", ЭтотОбъект);
		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьПолучениеПараметровФискальногоУстройства(Оповещение, УникальныйИдентификатор, ИдентификаторУстройства);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторУстройства(КассаККМ)
	
	СтруктураРеквизитов = Новый Структура("ПодключаемоеОборудование");
	РеквизитыКассыККМ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КассаККМ, СтруктураРеквизитов);
	ИдентификаторУстройства 	= РеквизитыКассыККМ.ПодключаемоеОборудование;
	
	Возврат ИдентификаторУстройства;
	
КонецФункции

&НаСервере
Процедура ПроверитьДокументыОснованияИРасчетов()
	
	Если НЕ Объект.НеприменениеККТ Тогда
		
		ДокументОснованиеДоступно 						= ДокументДоступен(Объект.ДокументОснование);
		Элементы.ДокументОснование.Видимость 			= ДокументОснованиеДоступно;
		Элементы.ДокументОснованиеНедоступен.Видимость 	= НЕ ДокументОснованиеДоступно;
		
		ДокументРасчетовДоступно 						= ДокументДоступен(Объект.ДокументРасчетов);
		Элементы.ДокументРасчетов.Видимость 			= ДокументРасчетовДоступно;
		Элементы.ДокументРасчетовНедоступен.Видимость 	= НЕ ДокументРасчетовДоступно;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДокументДоступен(Документ)
	
	Если НЕ Документ.Пустая() Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Ссылка", Истина) = Неопределено Тогда
			Возврат Ложь
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция КассаПоУмолчанию(Организация, СтруктурнаяЕдиница)
	
	Возврат Справочники.КассыККМ.ПолучитьКассуККМПоУмолчанию(Перечисления.ТипыКассККМ.ФискальныйРегистратор);
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ЗаполнитьСпискиВыбораЭлементов()
	
	Элементы.ПозицииЧекаЕдиницаИзмерения.СписокВыбора.Добавить(НСтр("ru = 'Штука'"));
	
	Если ЗначениеЗаполнено(Объект.СистемаНалогообложения) Тогда
		Элементы.СистемаНалогообложения.СписокВыбора.Добавить(Объект.СистемаНалогообложения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
