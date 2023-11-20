
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Пользователь = Неопределено;
	КонецЕсли;
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Пользователь.Пустая() Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПользователиВЕТИС.Ссылка) КАК СсылкаПредставление
		|ИЗ
		|	Справочник.ПользователиВЕТИС КАК ПользователиВЕТИС
		|ГДЕ
		|	НЕ ПользователиВЕТИС.ПометкаУдаления
		|	И ПользователиВЕТИС.Пользователь = &Пользователь
		|	И ПользователиВЕТИС.Ссылка <> &ЭтаСсылка
		|");
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
		Запрос.УстановитьПараметр("ЭтаСсылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			ТекстСообщения = СтрШаблон(НСтр("ru='Пользователь ""%1"" уже сопоставлен с пользователем ВетИС ""%2""'"),
			                 Пользователь, Выборка.СсылкаПредставление);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоНовый() Тогда
		Если ЭтоГосударственныйВетеринарныйВрач И ЭтоАдминистраторХозяйствующегоСубъекта() Тогда
			ТекстСообщения = НСтр("ru = 'Пользователь ""%1"" является администратором хозяйствующего субъекта. Администратор хозяйствующего субъекта не может быть государственным ветеринарным врачем.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Наименование);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ЭтоГосударственныйВетеринарныйВрач", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоАдминистраторХозяйствующегоСубъекта()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.НастройкиПодключенияВЕТИС КАК НастройкиПодключенияВЕТИС
	|ГДЕ
	|	НастройкиПодключенияВЕТИС.Администратор = &ПользовательВЕТИС";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПользовательВЕТИС", Ссылка);
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли