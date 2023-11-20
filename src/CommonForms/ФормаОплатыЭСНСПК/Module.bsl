#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КассаККМ", КассаККМ);
	Параметры.Свойство("ЭтоВозврат", ЭтоВозврат);
	Параметры.Свойство("СуммаЧека", СуммаЧека);
	Параметры.Свойство("СуммаПК", СуммаПК);
	Параметры.Свойство("ИдентификаторКорзины", ИдентификаторКорзины);
	
	Если ЭтоВозврат Тогда
		Заголовок = НСтр("ru = 'Возврат оплаты электронным сертификатом'");
		Элементы.ГруппаОплатаНеЭСНСПК.Видимость = Ложь;
		Если СуммаПК = 0 ИЛИ НЕ ПредварительноеОдобрениеПолучено Тогда
			Элементы.СуммаПК.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Заголовок = НСтр("ru = 'Оплата электронным сертификатом'");
		Элементы.ГруппаОплатаНеЭСНСПК.Видимость = Истина;
	КонецЕсли;
	
	ТоварныеПозиции = Новый Массив();
	Параметры.Свойство("ТоварныеПозиции", ТоварныеПозиции);
	
	ТоварыФСС.Очистить();
	
	Для Каждого СтрокаТовара Из ТоварныеПозиции Цикл
		ТоварныеСтроки = ТоварыФСС.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовара.Номенклатура));
		Если ТоварныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = ТоварыФСС.Добавить();
			НоваяСтрока.НомерПозиции = НоваяСтрока.ПолучитьИдентификатор();
			НоваяСтрока.НомерПозицииВозврата = 999;
			НоваяСтрока.Артикул = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТовара.Номенклатура, "Код");
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовара);
		Иначе
			НоваяСтрока = ТоварныеСтроки[0];
			НоваяСтрока.Количество = НоваяСтрока.Количество + СтрокаТовара.Количество;
			НоваяСтрока.Сумма = НоваяСтрока.Сумма + СтрокаТовара.Сумма;
			НоваяСтрока.Цена =
				?(НоваяСтрока.Количество = 0, НоваяСтрока.Сумма, Окр(НоваяСтрока.Сумма/НоваяСтрока.Количество, 2));
		КонецЕсли;
	КонецЦикла;
	
	ПредварительноеОдобрениеПолучено = Ложь;
	
	ВывестиПредварительноеОдобрениеНаПечать();
	УстановитьЗаголовкиОплаты(ЭтотОбъект);
	
	УказанИдентификаторКорзины = (ЗначениеЗаполнено(ИдентификаторКорзины) И ЭтоВозврат) ИЛИ Не ЭтоВозврат;
	Элементы.ГруппаКомандыОплаты.Видимость = УказанИдентификаторКорзины;
	Элементы.ГруппаИдентификаторКорзины.Видимость = НЕ УказанИдентификаторКорзины;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			МассивШтрихкодов = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			
			Если МассивШтрихкодов.Количество() > 0 Тогда
				ИдентификаторКорзины = МассивШтрихкодов[0].Штрихкод;
				
				ДанныеШтрихкода = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.РасшифроватьQRКодЧекаККТ(ИдентификаторКорзины);
				Если ДанныеШтрихкода.Расшифрован Тогда
					СтруктураФискальногоПризнака = Новый Структура("НомерФискальногоНакопителя, ФискальныйПризнакЧека, ФискальныйЧекНомер",
															ДанныеШтрихкода.НомерФискальногоНакопителя,
															ДанныеШтрихкода.ФискальныйПризнак,
															ДанныеШтрихкода.НомерФискальногоДокумента);
															
					ПараметрыОперацииНСПК = ПолучитьПараметрыОперацииНСПКНаСервере();
					ЗаполнитьЗначенияСвойств(ПараметрыОперацииНСПК, СтруктураФискальногоПризнака);
					
					ОповещениеМетода = Новый ОписаниеОповещения("ПолучитьИдентификаторКорзиныЗавершение", ЭтотОбъект);
					ЭлектронныеСертификатыНСПККлиент.НачатьПолучениеИдентификатораКорзины(ОповещениеМетода, ПараметрыОперацииНСПК);
					
				Иначе
					ВвестиИдентификаторКорзиныНаКлиенте(Новый Структура("Результат, ИдентификаторКорзины", Истина, ИдентификаторКорзины));
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаПКПриИзменении(Элемент)
	
	СуммаПК = Мин(СуммаПК, СуммаЧека - СуммаЭС);
	СуммаНаличные = СуммаЧека - СуммаЭС - СуммаПК;
	ПроверитьСуммы();
КонецПроцедуры

&НаКлиенте
Процедура СуммаНаличныеПриИзменении(Элемент)
	
	Сдача = -1 *(СуммаЧека - СуммаЭС - СуммаПК - СуммаНаличные);
	ПроверитьСуммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отменить(Команда)
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("Результат", Ложь);
	
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура Оплатить(Команда)
	
	ТоварныеПозиции = Новый Массив();
	ДополнительныеПараметры = Новый Структура();
	
	Если ПредварительноеОдобрениеПолучено Тогда
		СледующаяОперация = "ОплатитьЭлектроннымСертификатом";
		Если ЭтоВозврат Тогда
			СледующаяОперация = "ВернутьЭлектроннымСертификатом";
		КонецЕсли;
	Иначе
		РезультатПроверки = ПроверитьВозможностьОплатыНСПКНаСервере(КассаККМ);
		Если ЗначениеЗаполнено(РезультатПроверки) Тогда
			Элементы.ПроверкаВозможностиОплаты.Заголовок = РезультатПроверки;
			Элементы.ПроверкаВозможностиОплаты.Видимость = Истина;
			Возврат;
		Иначе
			Элементы.ПроверкаВозможностиОплаты.Видимость = Ложь;
		КонецЕсли;
		
		СледующаяОперация = "ПредварительноеОдобрениеИспользования";
		Если ЭтоВозврат Тогда
			СледующаяОперация = "ПредварительноеОдобрениеВозврата";
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("СледующаяОперация", СледующаяОперация);
	
	Если ПредварительноеОдобрениеПолучено Тогда
		
		Если СуммаПК > 0 И Сдача >= 0 Тогда
			
			ЗаголовокПредупреждения = НСтр("ru='Оплата с карты МИР'");
			ШаблонПредупреждения = НСтр("ru='С карты МИР покупателя будет списано'");
			Если ЭтоВозврат Тогда
				ЗаголовокПредупреждения = НСтр("ru='Возврат на карту МИР'");
				ШаблонПредупреждения = НСтр("ru='На карту МИР покупателя будет возвращено'");
			КонецЕсли;
			
			ПараметрыОповещения = Новый Структура("ЭтоВозврат, СледующаяОперация", ЭтоВозврат, СледующаяОперация);
			ОписаниеОповещенияОплаты = Новый ОписаниеОповещения("ВыполнитьОперациюЭлектронныйСертификат", ЭтотОбъект, ПараметрыОповещения);
			ПоказатьВопрос(ОписаниеОповещенияОплаты,
				СтрШаблон(НСтр("ru='%1 %2 рублей. Продолжить?'"), ШаблонПредупреждения, СуммаПК),
			РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, ЗаголовокПредупреждения);
			
		ИначеЕсли Сдача < 0 Тогда
			
			ЗаголовокПредупреждения = НСтр("ru='Оплата электронным сертификатом'");
			ШаблонПредупреждения = НСтр("ru='Доплату необходимо будет произвести отдельной операцией'");
			Если ЭтоВозврат Тогда
				ЗаголовокПредупреждения = НСтр("ru='Возврат электронного сертификата'");
				ШаблонПредупреждения = НСтр("ru='Возврат оставшейся суммы необходимо будет произвести отдельной операцией'");
			КонецЕсли;
			
			ПараметрыОповещения = Новый Структура("ЭтоВозврат, СледующаяОперация", ЭтоВозврат, СледующаяОперация);
			ОписаниеОповещенияОплаты = Новый ОписаниеОповещения("ВыполнитьОперациюЭлектронныйСертификат", ЭтотОбъект, ПараметрыОповещения);
			ПоказатьВопрос(ОписаниеОповещенияОплаты,
				СтрШаблон(НСтр("ru='%1. Продолжить?'"), ШаблонПредупреждения),
					РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, ЗаголовокПредупреждения);
		Иначе
			
			Если ЭтоВозврат Тогда
				ВернутьЭлектронныйСертификат(СледующаяОперация);
			Иначе
				ОплатитьЭлектроннымСертификатом(СледующаяОперация);
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		Для Каждого СтрокаТоваров Из ТоварыФСС Цикл
			ТоварнаяПозиция = Новый Структура();
			ТоварнаяПозиция.Вставить("НомерПозиции", СтрокаТоваров.НомерПозиции);
			ТоварнаяПозиция.Вставить("Артикул", СтрокаТоваров.Артикул);
			ТоварнаяПозиция.Вставить("КодТовараТРУ", СтрокаТоваров.КодТовараТРУ);
			ТоварнаяПозиция.Вставить("Количество", СтрокаТоваров.Количество);
			ТоварнаяПозиция.Вставить("Цена", СтрокаТоваров.Цена);
			ТоварнаяПозиция.Вставить("НомерПозицииВозврата", СтрокаТоваров.НомерПозицииВозврата);
			ТоварныеПозиции.Добавить(ТоварнаяПозиция);
		КонецЦикла;
		ДополнительныеПараметры.Вставить("ТоварныеПозиции", ТоварныеПозиции);
		
		Если ЭтоВозврат Тогда
			ДополнительныеПараметры.Вставить("ИдентификаторКорзины", ИдентификаторКорзины);
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЭТЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОборудованиеПлатежныеСистемыКлиент.НачатьПолучениеПараметровКарты(ОписаниеОповещения, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюЭлектронныйСертификат(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если НЕ (ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.Свойство("ЭтоВозврат")
			И ДополнительныеПараметры.Свойство("СледующаяОперация")) Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатВыполнения = КодВозвратаДиалога.Да Тогда
		
		ЭтоВозврат = ДополнительныеПараметры.ЭтоВозврат;
		СледующаяОперация = ДополнительныеПараметры.СледующаяОперация;
		
		Если ЭтоВозврат Тогда
			ВернутьЭлектронныйСертификат(СледующаяОперация);
		Иначе
			ОплатитьЭлектроннымСертификатом(СледующаяОперация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьИдентификаторКорзины(Команда)
	
	ВвестиИдентификаторКорзиныНаКлиенте(Новый Структура("Результат, ИдентификаторКорзины", Истина, ИдентификаторКорзины));
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьЭлектроннымСертификатом(СледующаяОперация)
	
	ПараметрыОперации = ОборудованиеПлатежныеСистемыКлиентСервер.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции  = "PayElectronicCertificate";
	ПараметрыОперации.ИдентификаторКорзины = ИдентификаторКорзины;
	ПараметрыОперации.СуммаЭлектронногоСертификата = СуммаЭС;
	ПараметрыОперации.СуммаСобственныхСредств = СуммаПК;
	
	ПараметрыОперации.Вставить("СледующаяОперация", СледующаяОперация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЭТЗавершение", ЭтотОбъект, ПараметрыОперации);
	ОборудованиеПлатежныеСистемыКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(
		ОписаниеОповещения,
		УникальныйИдентификатор,
		Неопределено,
		ПараметрыОперации,
		Неопределено,
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьЭлектронныйСертификат(СледующаяОперация)
	
	ПараметрыОперации = ОборудованиеПлатежныеСистемыКлиентСервер.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции  = "ReturnElectronicCertificate";
	ПараметрыОперации.ИдентификаторКорзины = ИдентификаторКорзины;
	ПараметрыОперации.СуммаЭлектронногоСертификата = СуммаЭС;
	ПараметрыОперации.СуммаСобственныхСредств = Макс(СуммаПК, 0);
	
	ПараметрыОперации.Вставить("СледующаяОперация", СледующаяОперация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЭТЗавершение", ЭтотОбъект, ПараметрыОперации);
	ОборудованиеПлатежныеСистемыКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(
		ОписаниеОповещения,
		УникальныйИдентификатор,
		Неопределено,
		ПараметрыОперации,
		Неопределено,
		Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьСуммы()
	
	ОплатаДоступна = СуммаЧека = СуммаНаличные + СуммаПК + СуммаЭС - Сдача;
	
	Элементы.Оплатить.Доступность = ОплатаДоступна;
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВернутьЭСНСПКНЗавершение(ДополнительныеПараметры)
	
	ДополнительныеПараметры.Вставить("Результат", Истина);
	ДополнительныеПараметры.Вставить("Наличными", СуммаНаличные);
	ДополнительныеПараметры.Вставить("Сдача", Сдача);
	
	Закрыть(ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюЭТЗавершение(РезультатВыполнения, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ХешНомерКарты = ?(РезультатВыполнения.Свойство("ХешНомерКарты"), РезультатВыполнения.ХешНомерКарты, "");
		НомерКарты = ?(РезультатВыполнения.Свойство("НомерКарты"), РезультатВыполнения.НомерКарты, "");
		СсылкаНаПлатежныйСчет = ?(РезультатВыполнения.Свойство("СсылкаНаПлатежныйСчет"), РезультатВыполнения.СсылкаНаПлатежныйСчет, "");
		Если НЕ ДополнительныеПараметры = Неопределено И ДополнительныеПараметры.Свойство("СледующаяОперация") Тогда
			Если ДополнительныеПараметры.СледующаяОперация = "ПредварительноеОдобрениеИспользования" Тогда
				СогласоватьЭСНСПК(ДополнительныеПараметры.ТоварныеПозиции, ХешНомерКарты, СсылкаНаПлатежныйСчет);
			ИначеЕсли ДополнительныеПараметры.СледующаяОперация = "ПредварительноеОдобрениеВозврата" Тогда
				СогласоватьВозвратЭСНСПК(ДополнительныеПараметры.ТоварныеПозиции, ХешНомерКарты, СсылкаНаПлатежныйСчет);
			Иначе
				ДополнительныеПараметры.Вставить("ИдентификаторУстройства", РезультатВыполнения.ИдентификаторУстройства);
				ДополнительныеПараметры.Вставить("НомерКарты", РезультатВыполнения.НомерКарты);
				ДополнительныеПараметры.Вставить("НомерЧекаЭТ", РезультатВыполнения.НомерЧекаЭТ);
				ДополнительныеПараметры.Вставить("СсылочныйНомер", РезультатВыполнения.СсылочныйНомер);
				ОплатитьВернутьЭСНСПКНЗавершение(ДополнительныеПараметры);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		ПредварительноеОдобрениеПолучено = Ложь;
		УстановитьЗаголовкиОплаты(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьЭСНСПК(ТоварныеПозиции, ХешНомерКарты, СсылкаНаПлатежныйСчет)
	
	ПараметрыОперацииНСПК = ПолучитьПараметрыОперацииНСПКНаСервере();
	ПараметрыОперацииНСПК.ХешНомерКарты = ХешНомерКарты;
	ПараметрыОперацииНСПК.СсылкаНаПлатежныйСчет = СсылкаНаПлатежныйСчет;
	ПараметрыОперацииНСПК.ТоварныеПозиции = ТоварныеПозиции;
	
	ПредварительноеОдобрениеПолучено = Ложь;
	
	ОповещениеМетода = Новый ОписаниеОповещения("ОбработатьРезультатОперацииНаКлиенте", ЭтотОбъект, ПараметрыОперацииНСПК);
	ЭлектронныеСертификатыНСПККлиент.НачатьПредварительноеОдобрениеИспользования(ОповещениеМетода, ПараметрыОперацииНСПК);
	
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьВозвратЭСНСПК(ТоварныеПозиции, ХешНомерКарты, СсылкаНаПлатежныйСчет)
	
	ПараметрыОперацииНСПК = ПолучитьПараметрыОперацииНСПКНаСервере(Истина);
	ПараметрыОперацииНСПК.ТоварныеПозиции = ТоварныеПозиции;
	ПараметрыОперацииНСПК.ХешНомерКарты = ХешНомерКарты;
	ПараметрыОперацииНСПК.СсылкаНаПлатежныйСчет = СсылкаНаПлатежныйСчет;
	
	ОповещениеМетода = Новый ОписаниеОповещения("ОбработатьПолучениеСоставаКорзиныНаКлиенте", ЭтотОбъект, ПараметрыОперацииНСПК);
	ЭлектронныеСертификатыНСПККлиент.НачатьПолучениеСоставаКорзины(ОповещениеМетода, ПараметрыОперацииНСПК);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПолучениеСоставаКорзиныНаКлиенте(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	РезультатВыполнения.Вставить("ПредыдущаяПокупка", Истина);
	ОбработатьРезультатНаСервере(РезультатВыполнения);
	РезультатВыполнения.Удалить("ПредыдущаяПокупка");
	
	Если НЕ РезультатВыполнения.Результат Тогда
		Возврат;
	КонецЕсли;
	
	ТоварныеПозиции = ДополнительныеПараметры.ТоварныеПозиции;
	
	// Удаление строк, которых не было в оригинальной продаже ЭС.
	СтрокиНеИзВозврата = ТоварыФСС.НайтиСтроки(Новый Структура("НомерПозицииВозврата", 999));
	
	Для каждого СтрокаНеИзВозврата Из СтрокиНеИзВозврата Цикл
		КоличествоТоварныхПозиций = ТоварныеПозиции.Количество();
		Для Индекс = 1 По КоличествоТоварныхПозиций Цикл
			СтрокаТовара = ТоварныеПозиции[КоличествоТоварныхПозиций - Индекс];
			Если СтрокаТовара.Артикул = СтрокаНеИзВозврата.Артикул Тогда
				ТоварныеПозиции.Удалить(КоличествоТоварныхПозиций - Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Заполнение номера позиции в оригинальной продаже ЭС.
	Для каждого СтрокаПодтверждения Из ТоварныеПозиции Цикл
		СтрокаФСС = ТоварыФСС.НайтиПоИдентификатору(СтрокаПодтверждения.НомерПозиции);
		Если НЕ СтрокаФСС = Неопределено Тогда
			СтрокаПодтверждения.НомерПозицииВозврата = СтрокаФСС.НомерПозицииВозврата;
		КонецЕсли;
	КонецЦикла;
	
	ПредварительноеОдобрениеПолучено = Ложь;
	ОповещениеМетода = Новый ОписаниеОповещения("ОбработатьРезультатОперацииНаКлиенте", ЭтотОбъект, ДополнительныеПараметры);
	ЭлектронныеСертификатыНСПККлиент.НачатьПредварительноеОдобрениеВозврата(ОповещениеМетода, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОперацииНСПКНаСервере(ПредыдущаяПокупка = Ложь)
	
	ПараметрыОперации = ЭлектронныеСертификатыНСПК.ПараметрыОперацииНСПК();
	
	Если ПредыдущаяПокупка Тогда
		ЭлектронныеСертификатыНСПКРМКУНФ.ЗаполнитьПараметрыОперацииНСПКПоКассеККМ(ПараметрыОперации, КассаККМ, ИдентификаторКорзины);
	Иначе
		ЭлектронныеСертификатыНСПКРМКУНФ.ЗаполнитьПараметрыОперацииНСПКПоКассеККМ(ПараметрыОперации, КассаККМ);
	КонецЕсли;
	
	Возврат ПараметрыОперации;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатОперацииНаКлиенте(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ПредварительноеОдобрениеПолучено = Истина;
	КонецЕсли;
	ОбработатьРезультатНаСервере(РезультатВыполнения);
	
	Если СуммаПК > 0 И ПредварительноеОдобрениеПолучено Тогда
		Элементы.СуммаЧека.Видимость = Истина;
		Элементы.СуммаПК.Видимость = Истина;
		Если ЭтоВозврат Тогда
			Элементы.СуммаПК.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатНаСервере(РезультатВыполнения);
	
	Если РезультатВыполнения.Результат Тогда
		
		Если РезультатВыполнения.Свойство("ИдентификаторКорзины") И НЕ ПустаяСтрока(РезультатВыполнения.ИдентификаторКорзины) Тогда
			ИдентификаторКорзины = РезультатВыполнения.ИдентификаторКорзины;
		КонецЕсли;
		Если РезультатВыполнения.Свойство("СуммаСертификатами") Тогда
			СуммаЭС = РезультатВыполнения.СуммаСертификатами;
			Если (СуммаПК >= СуммаЧека - СуммаЭС И СуммаЭС > 0) ИЛИ НЕ ЭтоВозврат Тогда
				СуммаПК = СуммаЧека - СуммаЭС;
				Если ЭтоВозврат Тогда
					Элементы.СуммаПК.Доступность = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если РезультатВыполнения.Свойство("ТоварныеПозиции") И РезультатВыполнения.ТоварныеПозиции.Количество() > 0 Тогда
			Для Каждого ТоварнаяПозиция Из РезультатВыполнения.ТоварныеПозиции Цикл
				
				СтрокаТовара = Неопределено;
				
				Если РезультатВыполнения.Свойство("ПредыдущаяПокупка") Тогда
					СтрокиТоваров = ТоварыФСС.НайтиСтроки(Новый Структура("Артикул", ТоварнаяПозиция.Артикул));
					Если СтрокиТоваров.Количество()>0 Тогда
						СтрокаТовара = СтрокиТоваров[0];
					КонецЕсли;
				Иначе
					СтрокаТовара = ТоварыФСС.НайтиПоИдентификатору(ТоварнаяПозиция.НомерПозиции);
				КонецЕсли;
				
				Если СтрокаТовара = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Если РезультатВыполнения.Свойство("ПредыдущаяПокупка") Тогда
					СтрокаТовара.НомерПозицииВозврата = ТоварнаяПозиция.НомерПозиции;
				КонецЕсли;
				
				СтрокаТовара.КоличествоФСС = ТоварнаяПозиция.Количество;
				СтрокаТовара.ЦенаФСС = ТоварнаяПозиция.Цена;
				СтрокаТовара.СуммаФСС = СтрокаТовара.КоличествоФСС*СтрокаТовара.ЦенаФСС;
				
				Если ТоварнаяПозиция.Свойство("Сертификаты") И ТоварнаяПозиция.Сертификаты.Количество() > 0 Тогда
					
					КоличествоПоСертификату = 0;
					СуммаПоСертификату = 0;
					МаксимальнаяЦена = 0;
					Для Каждого Сертификат Из ТоварнаяПозиция.Сертификаты Цикл
						СтрокаСертификата = СтрокаТовара.Сертификаты.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаСертификата, Сертификат);
						КоличествоПоСертификату = КоличествоПоСертификату + СтрокаСертификата.Количество;
						СуммаПоСертификату = СуммаПоСертификату + (СтрокаСертификата.Количество * СтрокаСертификата.Цена);
						МаксимальнаяЦена = Макс(МаксимальнаяЦена, СтрокаСертификата.МаксимальнаяЦена);
					КонецЦикла;
					
					СтрокаТовара.МаксимальнаяЦена = МаксимальнаяЦена;
					СтрокаТовара.КоличествоФСС = КоличествоПоСертификату;
					СтрокаТовара.СуммаФСС = СуммаПоСертификату;
					СтрокаТовара.ЦенаФСС =
						?(КоличествоПоСертификату = 0, СуммаПоСертификату, Окр(СуммаПоСертификату/КоличествоПоСертификату, 2));
				
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ВывестиПредварительноеОдобрениеНаПечать();
		УстановитьЗаголовкиОплаты(ЭтотОбъект);
	Иначе
		ОписаниеОшибки =
			СтрШаблон(НСтр("ru='Ошибка: (%1) %2'"), РезультатВыполнения.КодРезультата, РезультатВыполнения.ОписаниеОшибки); 
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПредварительноеОдобрениеНаПечать()
	
	Таб = Новый ТабличныйДокумент();
	
	Макет = ПолучитьОбщийМакет("ПФ_MXL_ДанныеПроверкиТоваровФСС");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	Если ЭтоВозврат Тогда
		ЗаголовокТаблицы = НСтр("ru = 'Товары к возврату на электронный сертификат'");
	Иначе
		ЗаголовокТаблицы = НСтр("ru = 'Товары к оплате электронным сертификатом'");
	КонецЕсли;
	
	УстановитьПараметр(ОбластьЗаголовок, "ЗаголовокТаблицы", ЗаголовокТаблицы);
	
	Таб.Вывести(ОбластьЗаголовок);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	Таб.Вывести(ОбластьШапка);
	
	СуммаЧекФСС = 0;
	
	Для Каждого СтрокаТоваров Из ТоварыФСС Цикл
		
		ОбластьДанныхСтроки = Макет.ПолучитьОбласть("Строка");
		УстановитьПараметр(
			ОбластьДанныхСтроки,
			"Наименование",
			СтрШаблон("%1, %2", СтрокаТоваров.Артикул, СокрЛП(СтрокаТоваров.Номенклатура)));
		ОбластьДанныхСтроки.Параметры.Заполнить(СтрокаТоваров);
		ОбластьДанныхСтроки.Параметры.КодТРУ = СтрокаТоваров.КодТовараТРУ;
		Таб.Вывести(ОбластьДанныхСтроки);
		
		СуммаЧекФСС = СуммаЧекФСС + СтрокаТоваров.Сумма;
	КонецЦикла;
	
	ОбластПодвалФСС = Макет.ПолучитьОбласть("ПодвалФСС");
	УстановитьПараметр(ОбластПодвалФСС, "Сумма", СуммаЧекФСС);
	УстановитьПараметр(ОбластПодвалФСС, "СуммаФСС", СуммаЭС);
	Таб.Вывести(ОбластПодвалФСС);
	
	Если НЕ ЭтоВозврат Тогда
		
		ОбластПрочиеТовары = Макет.ПолучитьОбласть("ПрочиеТовары");
		УстановитьПараметр(ОбластПрочиеТовары, "Сумма", СуммаЧека - СуммаЧекФСС);
		Таб.Вывести(ОбластПрочиеТовары);
		
		ОбластПодвал = Макет.ПолучитьОбласть("Подвал");
		УстановитьПараметр(ОбластПодвал, "Сумма", СуммаЧека);
		Таб.Вывести(ОбластПодвал);
	КонецЕсли;
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент = Таб;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиОплаты(Форма)
	
	Если Форма.ПредварительноеОдобрениеПолучено Тогда
		Если Форма.ЭтоВозврат Тогда
			ЗаголовокОплаты = НСтр("ru = 'Вернуть'");
			ТекстПодсказки = НСтр("ru = 'Возврат электронного сертификата должен производиться на карту, к которой приписываются электронные сертификаты покупателя.'");
		Иначе
			ЗаголовокОплаты = НСтр("ru = 'Оплатить'");
			ТекстПодсказки = НСтр("ru = 'Доплата к электронному сертификату может производиться собственными средствами с той же карты,"
				"а также наличными.'");
		КонецЕсли;
	Иначе
		ЗаголовокОплаты = НСтр("ru = 'Проверить'");
		Если Форма.ЭтоВозврат Тогда
			ТекстПодсказки = НСтр("ru = 'Перед возвратом необходимо проверить доступную сумму к возврату электронного сертификата.'");
		Иначе
			ТекстПодсказки = НСтр("ru = 'Перед оплатой необходимо проверить доступную сумму к оплате электронного сертификата.'");
		КонецЕсли;
	КонецЕсли;
	Форма.Элементы.Оплатить.Заголовок = ЗаголовокОплаты;
	Форма.Элементы.ГруппаСуммы.РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВозможностьОплатыНСПКНаСервере(КассаККМ)
	
	ЧастиФорматированнойСтроки = Новый Массив;
	
	АдресСтруктурнойЕдиницы = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		КассаККМ.СтруктурнаяЕдиница, Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы, ТекущаяДатаСеанса(), Ложь);
	Если Не ЗначениеЗаполнено(АдресСтруктурнойЕдиницы) Тогда
			ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Необходимо указать адрес '")));
			ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'структурной единицы.'"),,,, ПолучитьНавигационнуюСсылку(КассаККМ.СтруктурнаяЕдиница)));
			ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	ПлатежнаяКартаНСПК = Неопределено;
	ЭлектронныеСертификатыНСПКРМКУНФ.ЗаполнитьВидОплатыПлатежнаяКартаНСПК(ПлатежнаяКартаНСПК);
	ПлатежнаяСистемаНСПК = Неопределено;
	ЭлектронныеСертификатыНСПКРМКУНФ.ЗаполнитьВидОплатыПлатежнаяСистемаНСПК(ПлатежнаяСистемаНСПК);
	
	ТаблицаТерминалы = ПолучитьТаблицуЭквайринговыхТерминаловДляПроверки(КассаККМ);
	Если ТаблицаТерминалы.Количество() = 0 Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Для указанной'") + Символы.НПП));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'кассы ККМ'"),,,, ПолучитьНавигационнуюСсылку(КассаККМ)));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(Символы.НПП + НСтр("ru = 'необходимо создать эквайринговый терминал с подключением оборудования.'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;

	СтруктураОтбора = Новый Структура("ПлатежнаяСистема", Перечисления.ТипыПлатежнойСистемыККТ.СертификатНСПК);
	НайденныеСтроки = ТаблицаТерминалы.НайтиСтроки(СтруктураОтбора);
	Если НайденныеСтроки.Количество() = 0 И ТаблицаТерминалы.Количество() > 0 Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'В доступные виды оплаты'") + Символы.НПП));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'эквайринговых терминалов'"),,,, ПолучитьНавигационнуюСсылку(ТаблицаТерминалы[0].ЭквайринговыйТерминал)));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(Символы.НПП + НСтр("ru = 'необходимо добавить платежную систему Сертификат (ФЗ-491).'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(ЧастиФорматированнойСтроки);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТаблицуЭквайринговыхТерминаловДляПроверки(КассаККМ)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал,
	|	ЭквайринговыеТерминалы.ПлатежнаяСистема КАК ПлатежнаяСистема
	|ИЗ
	|	Справочник.СпособыОплаты.ВидыПлатежныхКарт КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	НЕ ЭквайринговыеТерминалы.Ссылка.ПометкаУдаления
	|	И ЭквайринговыеТерминалы.Ссылка.Касса = &Касса
	|	И ЭквайринговыеТерминалы.Ссылка.ИспользоватьБезПодключенияОборудования = ЛОЖЬ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Касса", КассаККМ);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьИдентификаторКорзиныЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ВвестиИдентификаторКорзиныНаКлиенте(РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиИдентификаторКорзиныНаКлиенте(РезультатВыполнения)
	
	Если НЕ (ТипЗнч(РезультатВыполнения) = Тип("Структура") И РезультатВыполнения.Свойство("Результат")) Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьОшибка = Ложь;
	Если РезультатВыполнения.Результат Тогда
		ИдентификаторКорзины = РезультатВыполнения.ИдентификаторКорзины;
	Иначе
		ЕстьОшибка = Истина;
		ТекстОшибки = НСтр("ru = 'Не удалось получить идентификатор корзины по фискальному признаку чека'");
		ИдентификаторКорзины = НСтр("ru=''");
	КонецЕсли;
	
	Если НЕ ЕстьОшибка И НЕ СтрДлина(ИдентификаторКорзины) = 24 Тогда
		ЕстьОшибка = Истина;
		ТекстОшибки = НСтр("ru = 'Идентификатор корзины должен состоять из 24 символов.'");
	КонецЕсли;
	
	Если ЕстьОшибка Тогда
		Элементы.ПроверкаВозможностиОплаты.Заголовок = ТекстОшибки;
		Элементы.ПроверкаВозможностиОплаты.Видимость = Истина;
	Иначе
		Элементы.ПроверкаВозможностиОплаты.Видимость = Ложь;
		Элементы.ГруппаИдентификаторКорзины.Видимость = Ложь;
		Элементы.ГруппаКомандыОплаты.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти






