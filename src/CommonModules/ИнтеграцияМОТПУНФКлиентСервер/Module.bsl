#Область ШтрихкодированиеИСКлиентСерверПереопределяемый

// В процедуре нужно реализовать возможность работы с видами продукции, с которыми предполагается работа объектов.
// (См. ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуВидовПродукцииИС).
Процедура ВключитьПоддержкуВидовПродукцииИС(Контекст, ПараметрыСканирования, ВидПродукции) Экспорт
	
	Если ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЧекККМ") Тогда
		ЗаполнитьПараметрыСканированияЧекККМ(Контекст, ПараметрыСканирования, ВидПродукции, Ложь);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЧекККМВозврат") Тогда
		ЗаполнитьПараметрыСканированияЧекККМВозврат(Контекст, ПараметрыСканирования, ВидПродукции, Ложь);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.РасходнаяНакладная") Тогда
		ЗаполнитьПараметрыСканированияРасходнаяНакладная(Контекст, ПараметрыСканирования, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ПриходнаяНакладная") Тогда
		ЗаполнитьПараметрыСканированияПриходнаяНакладная(Контекст, ПараметрыСканирования, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ОперацияПоПлатежнымКартам") Тогда
		ЗаполнитьПараметрыСканированияОперацияПоПлатежнымКартам(Контекст, ПараметрыСканирования, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ПоступлениеВКассу")
		ИЛИ ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ПоступлениеНаСчет") Тогда
		ЗаполнитьПараметрыСканированияПоступлениеДС(Контекст, ПараметрыСканирования, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.РасходИзКассы")
		ИЛИ ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.РасходСоСчета") Тогда
		ЗаполнитьПараметрыСканированияРасходДС(Контекст, ПараметрыСканирования, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.КорректировкаРеализации") Тогда
		ЗаполнитьПараметрыСканированияКорректировкаРеализации(ПараметрыСканирования, Контекст, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ПередачаТоваровМеждуОрганизациями") Тогда
		ЗаполнитьПараметрыСканированияПередачаТоваровМеждуОрганизациями(ПараметрыСканирования, Контекст, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ОтчетОПереработке") Тогда
		ЗаполнитьПараметрыСканированияОтчетОПереработке(ПараметрыСканирования, Контекст, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ОтчетПереработчика") Тогда
		ЗаполнитьПараметрыСканированияОтчетПереработчика(ПараметрыСканирования, Контекст, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЗаказПокупателя") Тогда
		ЗаполнитьПараметрыСканированияЗаказПокупателя(ПараметрыСканирования, Контекст, ВидПродукции);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Обработка.ПодборРеализация")
		ИЛИ ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Обработка.ПодборПоступление") Тогда
		ЗаполнитьПараметрыСканированияПодбор(Контекст, ПараметрыСканирования, ВидПродукции);
	КонецЕсли;
	
	ПараметрыСканирования.ДопустимыеВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПустаяСсылка"));
	
	ПараметрыСканирования.Вставить("КонтрольРасхожденийСДокументомОснованием", Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейсСлужебный

Процедура ЭтоДокументПриобретения(Контекст, ЭтоПриобретение) Экспорт
	
	ТипКонтекста = ТипЗнч(Контекст);
	
	Если ИнтеграцияИСМПУНФКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ПриходнаяНакладная")
		Или ИнтеграцияИСМПУНФКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ПриемкаТоваровИСМП") Тогда
			ЭтоПриобретение = Истина;
	ИначеЕсли ТипКонтекста = Тип("УправляемаяФорма")
		И СтрНачинаетсяС(Контекст.ИмяФормы, "ОбщаяФорма.ПроверкаЗаполненияДокументов")
		И ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
			ЭтоПриобретение = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоДокументРеализации(Контекст) Экспорт
	
	ЭтоПриобретение	= Ложь;
	ТипКонтекста	= ТипЗнч(Контекст);
	
	Если ТипКонтекста = Тип("УправляемаяФорма") Тогда
		Если СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.РасходнаяНакладная") Тогда
			ЭтоПриобретение = Истина;
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "ОбщаяФорма.ПроверкаЗаполненияДокументов") Тогда
			Если ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
				ЭтоПриобретение = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипКонтекста = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
		ЭтоПриобретение = Истина;
	КонецЕсли;
	
	Возврат ЭтоПриобретение;
	
КонецФункции

Процедура ЭтоЧекККМ(Контекст, ЭтоЧек) Экспорт
	
	ТипКонтекста = ТипЗнч(Контекст);
	
	Если ТипКонтекста = Тип("УправляемаяФорма") Тогда
		Если СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ЧекККМ.") Тогда
			ЭтоЧек = Истина;
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "ОбщаяФорма.ПроверкаЗаполненияДокументов") Тогда
			Если ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ЧекККМ") Тогда
				ЭтоЧек = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипКонтекста = Тип("ДокументСсылка.ЧекККМ") Тогда 
		ЭтоЧек = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЭтоЧекККМВозврат(Контекст, ЭтоЧекВозврат) Экспорт
	
	ТипКонтекста = ТипЗнч(Контекст);
	
	Если ТипКонтекста = Тип("УправляемаяФорма") Тогда
		Если СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ЧекККМВозврат") Тогда
			ЭтоЧекВозврат = Истина;
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "ОбщаяФорма.ПроверкаЗаполненияДокументов") Тогда
			Если ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда
				ЭтоЧекВозврат = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипКонтекста = Тип("ДокументСсылка.ЧекККМВозврат") Тогда 
		ЭтоЧекВозврат = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру параметров обработки штрихкодов.
//
// Возвращаемое значение:
//  Структура - Параметры обработки штрихкодов.
//
Функция ПараметрыОбработкиШтрихкодов() Экспорт
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Штрихкоды",                                      Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСДобавленнымиСтроками",         Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСИзмененнымиСтроками",          Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСоСтрокамиИзУпаковочныхЛистов", Неопределено);
	ПараметрыОбработки.Вставить("ПараметрыУказанияСерий",                 Неопределено);
	ПараметрыОбработки.Вставить("ДействияСНеизвестнымиШтрихкодами",       "ЗарегистрироватьПеренестиВДокумент");
	ПараметрыОбработки.Вставить("ИмяКолонкиКоличество",                   "КоличествоУпаковок");
	ПараметрыОбработки.Вставить("НеИспользоватьУпаковки",                 Ложь);
	ПараметрыОбработки.Вставить("ИмяТЧ",                                  "Товары");
	ПараметрыОбработки.Вставить("ИзменятьКоличество",                     Истина);
	ПараметрыОбработки.Вставить("БлокироватьДанныеФормы",                 Истина);
	ПараметрыОбработки.Вставить("ТолькоТовары",                           Ложь);
	ПараметрыОбработки.Вставить("ТолькоТоварыИРабота",                    Ложь);
	ПараметрыОбработки.Вставить("ТолькоУслуги",                           Ложь);
	ПараметрыОбработки.Вставить("ТолькоТара",                             Ложь);
	ПараметрыОбработки.Вставить("ТолькоНеПодакцизныйТовар",               Ложь);
	ПараметрыОбработки.Вставить("НеизвестныеШтрихкоды",                   Новый Массив);
	ПараметрыОбработки.Вставить("ОтложенныеТовары",                       Новый Массив);
	ПараметрыОбработки.Вставить("ПараметрыПроверкиАссортимента",          Неопределено);
	ПараметрыОбработки.Вставить("РассчитыватьНаборы",                     Ложь);
	ПараметрыОбработки.Вставить("УчитыватьУпаковочныеЛисты",              Ложь);
	ПараметрыОбработки.Вставить("ОтработатьИзменениеУпаковочныхЛистов",   Ложь);
	ПараметрыОбработки.Вставить("ШтрихкодыВТЧ",                           Ложь);
	ПараметрыОбработки.Вставить("МаркируемаяПродукцияВТЧ",                Ложь);
	ПараметрыОбработки.Вставить("УвеличиватьКоличествоВСтрокахССериями",  Истина);
	ПараметрыОбработки.Вставить("ТекущийУпаковочныйЛист",                 Неопределено);
	ПараметрыОбработки.Вставить("ЗаполнятьНазначения",                    Ложь);
	ПараметрыОбработки.Вставить("ЗагрузкаИзТСД",                          Ложь);
	
	// Возвращаемые параметры
	ПараметрыОбработки.Вставить("МассивСтрокССериями",          Новый Массив);
	ПараметрыОбработки.Вставить("МассивСтрокСАкцизнымиМарками", Новый Массив);
	ПараметрыОбработки.Вставить("ТекущаяСтрока",       Неопределено);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПараметрыСканированияЧекККМ(Контекст, ПараметрыСканирования, ВидПродукции, ПроверкаКоличества = Неопределено)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область ПоддержкаАлкогольнойПродукции
	
	Если ШтрихкодированиеЕГАИСКлиентСервер.ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
		
		ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
		ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
		ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Продажа";
		ПараметрыСканирования.ОрганизацияЕГАИС              = ИнтеграцияЕГАИСУНФВызовСервера.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(
															  ИсточникДанных.Организация,
															  ИсточникДанных.СтруктурнаяЕдиница);
		ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
		
		Если ПроверкаКоличества = Истина Тогда
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		Иначе
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СтавкаНДС");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Продавец");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПоддержкаИСМП
	
	Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничнойПродажи(ПараметрыСканирования, ВидПродукции) Тогда
		ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	Реквизиты = Новый Структура;
	Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсточникДанных, "Организация") Тогда
			Реквизиты.Вставить("Организация", ИсточникДанных.Организация);
		КонецЕсли;
		
		Реквизиты.Вставить("Склад", ИсточникДанных.СтруктурнаяЕдиница);
	КонецЕсли;
	Реквизиты.Вставить("ДатаДокумента", ИсточникДанных.Дата);
	
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, Реквизиты);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЧекККМВозврат(Контекст, ПараметрыСканирования, ВидПродукции, ПроверкаКоличества = Неопределено)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область ПоддержкаАлкогольнойПродукции
	
	Если ШтрихкодированиеЕГАИСКлиентСервер.ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
		
		ПараметрыСканирования.КонтрольАкцизныхМарок              = Истина;
		ПараметрыСканирования.Операция                           = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
		ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок      = "Возврат";
		ПараметрыСканирования.СоздаватьШтрихкодУпаковки          = Истина;
		ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки = Истина;
		ПараметрыСканирования.ОрганизацияЕГАИС                   = ИнтеграцияЕГАИСУНФВызовСервера.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(
			ИсточникДанных.Организация,
			ИсточникДанных.СтруктурнаяЕдиница);
		
		Если ПроверкаКоличества = Истина Тогда
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		Иначе
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СтавкаНДС");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Продавец");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПоддержкаИСМП
	
	Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничногоВозврата(ПараметрыСканирования, ВидПродукции) Тогда
		ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	ПараметрыСканирования.Организация = ИсточникДанных.Организация;
	ПараметрыСканирования.Склад       = ИсточникДанных.СтруктурнаяЕдиница;
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияРасходнаяНакладная(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаИСМП
	
	ВидОперации = ИнтеграцияИСМПСлужебныйКлиентСервер.ЗначениеСвойстваКонтекста(Контекст, "ВидОперации");
	Контрагент = ИнтеграцияИСМПСлужебныйКлиентСервер.ЗначениеСвойстваКонтекста(Контекст, "Контрагент");
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю") 
		И ЗначениеЗаполнено(Контрагент) И ИнтеграцияИСМПУНФВызовСервера.ЭтоРозничныйКлиент(Контрагент) Тогда
		
		Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничнойПродажи(ПараметрыСканирования, ВидПродукции) Тогда
			ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
			ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
		КонецЕсли;
		
	Иначе
		
		ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаОптовойОтгрузки(ПараметрыСканирования, ВидПродукции);
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ДатаДокумента", ИсточникДанных.Дата);
	
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, Реквизиты);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПриходнаяНакладная(Контекст, ПараметрыСканирования, ВидПродукции, ПроверкаКоличества = Неопределено)
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидОперации = ИнтеграцияИСМПСлужебныйКлиентСервер.ЗначениеСвойстваКонтекста(Контекст, "ВидОперации");
	ЭтоВозврат = ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя");
	
	#Область ПоддержкаАлкогольнойПродукции
	
	Если ЭтоВозврат И ШтрихкодированиеЕГАИСКлиентСервер.ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
		
		ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
		ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
		ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Возврат";
		ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
		
		Если ПроверкаКоличества = Истина Тогда
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		Иначе
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СтавкаНДС");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Продавец");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПоддержкаИСМП
	
	Если ЭтоВозврат Тогда
		
		Контрагент = ИнтеграцияИСМПСлужебныйКлиентСервер.ЗначениеСвойстваКонтекста(Контекст, "Контрагент");
		
		Если ЗначениеЗаполнено(Контрагент) И ИнтеграцияИСМПУНФВызовСервера.ЭтоРозничныйКлиент(Контрагент) Тогда
			Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничногоВозврата(ПараметрыСканирования, ВидПродукции) Тогда
				ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
				ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);	
			КонецЕсли;
		Иначе
			ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаОптовогоВозврата(ПараметрыСканирования, ВидПродукции);
		КонецЕсли;
	Иначе
		ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаЗакупки(ПараметрыСканирования, ВидПродукции);
	КонецЕсли;
	
	#КонецОбласти

КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияОперацияПоПлатежнымКартам(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	ЗаполненыПараметрыИСМП = Ложь;
	Если ИсточникДанных.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя") Тогда
		Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничнойПродажи(ПараметрыСканирования, ВидПродукции) Тогда
			ЗаполненыПараметрыИСМП = Истина;
		КонецЕсли;
	ИначеЕсли ИсточникДанных.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЭквайринга.ВозвратОплатыПокупателю") Тогда
		Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничногоВозврата(ПараметрыСканирования, ВидПродукции) Тогда
			ЗаполненыПараметрыИСМП = Истина;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ЗаполненыПараметрыИСМП Тогда
		ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	Реквизиты = Новый Структура("ДатаДокумента", ИсточникДанных.Дата);
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, Реквизиты);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПоступлениеДС(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничнойПродажи(ПараметрыСканирования, ВидПродукции) Тогда
		ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	Реквизиты = Новый Структура("ДатаДокумента", ИсточникДанных.Дата);
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, Реквизиты);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияРасходДС(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничногоВозврата(ПараметрыСканирования, ВидПродукции) Тогда
		ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	Реквизиты = Новый Структура("ДатаДокумента", ИсточникДанных.Дата);
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, Реквизиты);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияКорректировкаРеализации(ПараметрыСканирования, Контекст, ВидПродукции)
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	Контрагент = ИнтеграцияИСМПСлужебныйКлиентСервер.ЗначениеСвойстваКонтекста(Контекст, "Контрагент");
	Если ЗначениеЗаполнено(Контрагент) И ИнтеграцияИСМПУНФВызовСервера.ЭтоРозничныйКлиент(Контрагент) Тогда
		
		Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничнойПродажи(ПараметрыСканирования, ВидПродукции) Тогда
			ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		КонецЕсли;
		
	Иначе
		
		ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаОптовойОтгрузки(ПараметрыСканирования, ВидПродукции);
		
	КонецЕсли;
	
	НастройкиИСМП = Новый Структура;
	НастройкиИСМП.Вставить("КонтролироватьОкончаниеСрокаГодности", Ложь);
	НастройкиИСМП.Вставить("ЗапрашиватьДанныеСервисаИСМП",         Ложь);
	НастройкиИСМП.Вставить("ДопустимыПроверкиСеройЗоныМОТП",       Ложь);
	
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, НастройкиИСМП);

	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПередачаТоваровМеждуОрганизациями(ПараметрыСканирования, Контекст, ВидПродукции)
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаОптовойОтгрузки(ПараметрыСканирования, ВидПродукции);
	
	НастройкиИСМП = Новый Структура;
	НастройкиИСМП.Вставить("КонтролироватьОкончаниеСрокаГодности", Ложь);
	НастройкиИСМП.Вставить("ЗапрашиватьДанныеСервисаИСМП",         Ложь);
	НастройкиИСМП.Вставить("ДопустимыПроверкиСеройЗоныМОТП",       Ложь);
	
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, НастройкиИСМП);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияОтчетОПереработке(ПараметрыСканирования, Контекст, ВидПродукции)
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаОптовойОтгрузки(ПараметрыСканирования, ВидПродукции);
	
	НастройкиИСМП = Новый Структура;
	НастройкиИСМП.Вставить("КонтролироватьОкончаниеСрокаГодности", Ложь);
	НастройкиИСМП.Вставить("ЗапрашиватьДанныеСервисаИСМП",         Ложь);
	НастройкиИСМП.Вставить("ДопустимыПроверкиСеройЗоныМОТП",       Ложь);
	
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, НастройкиИСМП);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияОтчетПереработчика(ПараметрыСканирования, Контекст, ВидПродукции)
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаПродукцииИСМП
	
	ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаЗакупки(ПараметрыСканирования, ВидПродукции);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЗаказПокупателя(ПараметрыСканирования, Контекст, ВидПродукции)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область Метаданные
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки = "ШтрихкодУпаковки";
	
	#КонецОбласти
	
	#Область ПоддержкаИСМП
	
	Если ШтрихкодированиеИСМПКлиентСервер.ЗаполнитьПараметрыСканированияДокументаРозничнойПродажи(ПараметрыСканирования, ВидПродукции) Тогда
		ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст);
		ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст);
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ОбщиеПараметры
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ДатаДокумента", ИсточникДанных.Дата);
	
	ЗаполнитьЗначенияСвойств(ПараметрыСканирования, Реквизиты);
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПодбор(Контекст, ПараметрыСканирования, ВидПродукции, ПроверкаКоличества = Неопределено)
	
	ИсточникДанных = Контекст.ВладелецФормы.Объект;
	
	ЭтоВозврат = Ложь;
	Если ТипЗнч(ИсточникДанных.Ссылка) = Тип("ДокументСсылка.ЧекККМВозврат")
		ИЛИ (ТипЗнч(ИсточникДанных.Ссылка) = Тип("ДокументСсылка.ПриходнаяНакладная") 
		И ИсточникДанных.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя")) Тогда
		ЭтоВозврат = Истина;
	КонецЕсли;
	
	#Область ПоддержкаАлкогольнойПродукции
	Если ШтрихкодированиеЕГАИСКлиентСервер.ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		Если ЭтоВозврат Тогда
			
			ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
			ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
			
			ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
			ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
			ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Возврат";
			ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
			
		Иначе
			
			ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
			ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
			
			ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
			ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
			ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Продажа";
			ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
			
		КонецЕсли;
		
		ПараметрыСканирования.ОрганизацияЕГАИС = ИнтеграцияЕГАИСУНФВызовСервера.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(
												ИсточникДанных.Организация,
												ИсточникДанных.СтруктурнаяЕдиница);
		
		Если ПроверкаКоличества = Истина Тогда
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		Иначе
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СтавкаНДС");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Продавец");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПоддержкаТабачнойПродукции
	
	Если ШтрихкодированиеМОТПКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
	
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
		ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
		КонтрольСтатусов = ИнтеграцияИСМПКлиентСерверПовтИсп.КонтролироватьСтатусыКодовМаркировкиВРознице();
		ПараметрыСканирования.ЗапрашиватьСтатусыИСМП                     = КонтрольСтатусов;
		ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП   = КонтрольСтатусов;
		ПараметрыСканирования.Организация                                = ИсточникДанных.Организация;
		ПараметрыСканирования.Склад                                      = ИсточникДанных.СтруктурнаяЕдиница;
		
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыККТФФД12(ПараметрыСканирования, Контекст)
	
	ИдентификаторУстройства = Неопределено;
	ПараметрыКассыККМ       = Неопределено;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ФискальныйРегистратор")
		И ЗначениеЗаполнено(Контекст.ФискальныйРегистратор) Тогда
		ИдентификаторУстройства = Контекст.ФискальныйРегистратор;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "КассаККМ") Тогда
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(Контекст.КассаККМ);
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ПараметрыКассыККМ") Тогда
		ПараметрыКассыККМ = Контекст.ПараметрыКассыККМ;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст.Объект, "КассаККМ") Тогда
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(Контекст.Объект.КассаККМ);
	КонецЕсли;
	
	Если ИдентификаторУстройства = Неопределено
		И НЕ ПараметрыКассыККМ = Неопределено Тогда
		ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
	КонецЕсли;
	
	Если НЕ ИдентификаторУстройства = Неопределено Тогда
		
		Если МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства) Тогда
			ПараметрыСканирования.ТребуетсяПроверкаСредствамиККТ = Истина;
			ПараметрыСканирования.ККТФФД12ИСМП                   = ИдентификаторУстройства;
		КонецЕсли;
		
		ПараметрыСканирования.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
		
	КонецЕсли;
	
	Если ПараметрыСканирования.ТребуетсяПроверкаСредствамиККТ Тогда
		ПараметрыСканирования.ТребоватьПолныйКодМаркировкиИСМП = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРеквизитовЧастичногоВыбытия(ПараметрыСканирования, Контекст)
	
	ПараметрыСканирования.ИмяКолонкиЧастичноеВыбытиеКоличество     = "ЧастичноеВыбытиеКоличество";
	ПараметрыСканирования.ИмяКолонкиЧастичноеВыбытиеВариантУчета   = "ЧастичноеВыбытиеВариантУчета";
	ПараметрыСканирования.ИмяКолонкиЧастичноеВыбытиеНоменклатура   = "ЧастичноеВыбытиеНоменклатура";
	ПараметрыСканирования.ИмяКолонкиЧастичноеВыбытиеХарактеристика = "ЧастичноеВыбытиеХарактеристика";
	
КонецПроцедуры

#КонецОбласти