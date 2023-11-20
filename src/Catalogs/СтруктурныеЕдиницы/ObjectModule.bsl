#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение
	 ИЛИ ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Склад
	 ИЛИ ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "РозничныйВидЦен");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаВРознице");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаНаценки");
	КонецЕсли;
	
	Если ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Розница Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаВРознице");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаНаценки");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПодразделение = (ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение);
	Если НЕ ЭтоПодразделение Тогда
		
		Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
			
			ГоловнаяОрганизация = Неопределено;
			
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(КПП) Тогда
			
			КПП = "";
			
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ЦифровойИндексОбособленногоПодразделения) Тогда
			
			ЦифровойИндексОбособленногоПодразделения = "";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов Тогда
		Если Не Константы.ИспользоватьГруппыМагазины.Получить() Тогда
			Константы.ИспользоватьГруппыМагазины.Установить(Истина);
		КонецЕсли;
	Иначе
		Если НеИспользоватьМагазиныИлиГруппы() Тогда
			Константы.ИспользоватьГруппыМагазины.Установить(Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		
		Если ЗначениеЗаполнено(Родитель.Родитель) 
			И Родитель.Родитель.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов Тогда
			ТекстСообщения = НСтр("ru = 'Группа текущей структурной единицы подчинена группе с типом ""Магазин или группа складов"".
			|Данной группе доступен только один уровень вложенности. Перенесите выбранную группу в другую и повторите попытку.'");
			Родитель = Неопределено;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Родитель",, Отказ);
		ИначеЕсли Родитель.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов
			И ЕстьПодчиненныеЭлементы() Тогда
			ТекстСообщения = НСтр("ru = 'Выбранная группа текущей структурной единицы с типом ""Магазин или группа складов"".
			|Данной группе доступен только один уровень вложенности. У текущей структурной единицы есть подчиненные элементы.
			|Очистите группу у подчиненных элементов и повторите попытку'");
			Родитель = Неопределено;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Родитель",, Отказ);
		КонецЕсли;
		
		Если ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение
			И Родитель.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов Тогда
			ТекстСообщения = НСтр("ru = 'Подразделение не может быть в группе структурной единицы с типом ""Магазин или группа складов"".'");
			Родитель = Неопределено;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Родитель",, Отказ);
		КонецЕсли;
		
		Если ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов
			И Не Родитель.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение Тогда
			ТекстСообщения = НСтр("ru = 'Структурная единица с типом ""Магазин или группа складов"", может быть только в группе с Подразделением.'");
			Родитель = Неопределено;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Родитель",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОрдерныйСклад Тогда
		
		Если Не ЗначениеЗаполнено(ВидУчетаОрдерныхСкладов) Тогда
			ВидУчетаОрдерныхСкладов = Перечисления.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			
			Если Не Отказ И ЗначениеЗаполнено(Ссылка.ВидУчетаОрдерныхСкладов) И Не Ссылка.ВидУчетаОрдерныхСкладов = ВидУчетаОрдерныхСкладов Тогда
				Если Не СкладскойУчетСервер.ИзмненениеВидУчетаДостпуно(Ссылка) Тогда
					ВидУчетаОрдерныхСкладов = Ссылка.ВидУчетаОрдерныхСкладов;
					ТекстСообщения = СтрШаблон(НСтр("ru = 'По складу %1 существуют движения. Изменение вида учета остатков невозможно.'"), Наименование);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ВидУчетаОрдерныхСкладов",, Отказ);
				КонецЕсли;
			КонецЕсли;
			
			Если Не Отказ И Не УчетОстатковПоЯчейкам = Ссылка.УчетОстатковПоЯчейкам Тогда
				Если Не СкладскойУчетСервер.ИзмненениеВидУчетаДостпуно(Ссылка) Тогда
					УчетОстатковПоЯчейкам = Ссылка.УчетОстатковПоЯчейкам;
					ТекстСообщения = СтрШаблон(НСтр("ru = 'По складу %1 существуют движения. Изменение учета остатков по ячейкам невозможно.'"), Наименование);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,, Отказ);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВидУчетаОрдерныхСкладов = Перечисления.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом Тогда
			УчетОстатковПоЯчейкам = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьПодчиненныеЭлементы()
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Ложь
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Родитель", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтруктурныеЕдиницы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.Родитель = &Родитель";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции


Функция НеИспользоватьМагазиныИлиГруппы()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтруктурныеЕдиницы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов)";
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли