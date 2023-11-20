#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СтраницаПечати = "СтраницаТовары" Тогда
		Если ПечатьИзДокумента Тогда
			МассивНепроверяемыхРеквизитов.Добавить("МагазинДляЦен");
			МассивНепроверяемыхРеквизитов.Добавить("ВидЦены");
		Иначе
			Если Истина  Тогда
				МассивНепроверяемыхРеквизитов.Добавить("МагазинДляЦен");
			Иначе
				МассивНепроверяемыхРеквизитов.Добавить("ВидЦены");
			КонецЕсли;
		КонецЕсли;
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЦенника");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЦенников");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЭтикеток");
		
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Сертификат");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.НомерСертификата");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Организация");
		
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.Карта");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.Организация");
		
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.Карта");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.Организация");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
		Если НажатаПечать Тогда
			ПроверитьЗаполнениеШаблоновЦенниковИЭтикеток(Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Организация) Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не заполнен отбор по организации'"));
		КонецЕсли;
		
	ИначеЕсли СтраницаПечати = "СтраницаПодарочныеСертификаты" Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидЦены");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеныНазначенныеДействующие");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеныНаДату");
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЦенника");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЦенников");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЭтикеток");
		
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.Карта");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.Организация");
		
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.Карта");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.Организация");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	ИначеЕсли СтраницаПечати = "СтраницаДисконтныеКарты" Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидЦены");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеныНазначенныеДействующие");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеныНаДату");
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЦенника");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЦенников");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЭтикеток");
		
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Сертификат");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.НомерСертификата");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Организация");
		
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.Карта");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныеКарты.Организация");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	ИначеЕсли СтраницаПечати = "СтраницаРегистрационныеКарты" Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидЦены");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеныНазначенныеДействующие");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеныНаДату");
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЦенника");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЦенников");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоЭтикеток");
		
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Сертификат");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.НомерСертификата");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Организация");
		
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.Карта");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.ШаблонЭтикетки");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.КоличествоЭтикеток");
		МассивНепроверяемыхРеквизитов.Добавить("ДисконтныеКарты.Организация");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеШаблоновЦенниковИЭтикеток(Отказ)

	ПроверятьЦенники = (Режим = "ПечатьЦенниковИЭтикеток") ИЛИ (Режим = "ПечатьЦенников");
	ПроверятьЭтикетки = (Режим = "ПечатьЦенниковИЭтикеток") ИЛИ (Режим = "ПечатьЭтикеток");
	
	ШаблонСообщенияЦенники  = НСтр("ru='Не заполнена колонка ""Шаблон ценника"" в строке %НомерСтроки%.'");
	ШаблонСообщенияЭтикетки = НСтр("ru='Не заполнена колонка ""Шаблон этикетки"" в строке %НомерСтроки%.'");
	
	ШаблонСообщенияЦенникиКоличество  = НСтр("ru='Не заполнена колонка ""Количество ценников"" в строке %НомерСтроки%.'");
	ШаблонСообщенияЭтикеткиКоличество = НСтр("ru='Не заполнена колонка ""Количество этикеток"" в строке %НомерСтроки%.'");
	
	СтрокиВыбран = Товары.НайтиСтроки(Новый Структура("Выбран", Истина));
	
	Для каждого СтрокаТаблицы Из СтрокиВыбран Цикл
	
		Если ПроверятьЦенники И НЕ ЗначениеЗаполнено(СтрокаТаблицы.ШаблонЦенника) Тогда
			
			Отказ = Истина;
			ТекстСообщения = СтрЗаменить(ШаблонСообщенияЦенники, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТаблицы.НомерСтроки, "ШаблонЦенника");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,Поле,"Объект", Отказ);
			
		КонецЕсли;
		
		Если ПроверятьЦенники И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КоличествоЦенников) Тогда
			
			Отказ = Истина;
			ТекстСообщения = СтрЗаменить(ШаблонСообщенияЦенникиКоличество, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТаблицы.НомерСтроки, "КоличествоЦенников");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,Поле,"Объект", Отказ);
			
		КонецЕсли;
		
		Если ПроверятьЭтикетки И НЕ ЗначениеЗаполнено(СтрокаТаблицы.ШаблонЭтикетки) Тогда
			
			Отказ = Истина;
			ТекстСообщения = СтрЗаменить(ШаблонСообщенияЭтикетки, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТаблицы.НомерСтроки, "ШаблонЭтикетки");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,Поле,"Объект", Отказ);
			
		КонецЕсли;
			
		Если ПроверятьЭтикетки И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КоличествоЭтикеток) Тогда
			
			Отказ = Истина;
			ТекстСообщения = СтрЗаменить(ШаблонСообщенияЭтикеткиКоличество, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТаблицы.НомерСтроки, "КоличествоЭтикеток");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,Поле,"Объект", Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли