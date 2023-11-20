#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	НеИспользоватьПроекты 		= НЕ ПолучитьФункциональнуюОпцию("УчетПоПроектам");
	НеИспользоватьПодразделения = НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимПодразделениям");
	
	Если НеИспользоватьПроекты ИЛИ НеИспользоватьПодразделения Тогда
		
		Для каждого Запись Из ЭтотОбъект Цикл
			
			Если НеИспользоватьПроекты Тогда
				Запись.Проект = Справочники.Проекты.ПустаяСсылка();
			КонецЕсли;
			
			Если НеИспользоватьПодразделения Тогда
				Запись.Подразделение = Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЕсли;
	
	// Хозяйственная операция
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	// Конец Хозяйственная операция
	
КонецПроцедуры // ПередЗаписью()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли