#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РазыменоватьИзмеренияИзДокумента();
	
КонецПроцедуры // ПередЗаписью()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РазыменоватьИзмеренияИзДокумента()
	
	КонтрагентыДокументов = Новый Соответствие;
	ПроектыДокументов = Новый Соответствие;
	
	ИзмерениеКонтрагентБылоЗаполнено = Истина;
	ИзмерениеПроектБылоЗаполнено = Истина;
	
	Для Каждого Движение Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Движение.Документ) Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Движение.Документ) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			Продолжить;
		КонецЕсли;
		МетаданныеДокумента = Движение.Документ.Метаданные();
		ИмяСобытияЖР = НСтр("ru='Проведение.Продажи'", ОбщегоНазначения.КодОсновногоЯзыка());
		Если Не ЗначениеЗаполнено(Движение.Контрагент) Тогда
			Контрагент = РазыменоватьКонтрагентаИзДокумента(МетаданныеДокумента, Движение.Документ, КонтрагентыДокументов);
			Если ЗначениеЗаполнено(Контрагент) Тогда
				Движение.Контрагент = Контрагент;
				ИзмерениеКонтрагентБылоЗаполнено = Ложь;
			КонецЕсли;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Движение.Проект) Тогда
			Проект = РазыменоватьПроектИзДокумента(МетаданныеДокумента, Движение.Документ, ПроектыДокументов);
			Если ЗначениеЗаполнено(Проект) Тогда
				Движение.Проект = Проект;
				ИзмерениеПроектБылоЗаполнено = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ИзмерениеКонтрагентБылоЗаполнено Тогда
		Комментарий = НСтр("ru='Измерение ""Контрагент"" не было заранее заполнено при проведении и было разыменовано'");
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Предупреждение, ЭтотОбъект.Метаданные(), Отбор.Регистратор.Значение, Комментарий);
	КонецЕсли;
	
	Если Не ИзмерениеПроектБылоЗаполнено Тогда
		Комментарий = НСтр("ru='Измерение ""Проект"" не было заранее заполнено при проведении и было разыменовано'");
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Предупреждение, ЭтотОбъект.Метаданные(), Отбор.Регистратор.Значение, Комментарий);
	КонецЕсли;
	
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Функция РазыменоватьКонтрагентаИзДокумента(МетаданныеДокумента, Документ, КонтрагентыДокументов)
	
	Если МетаданныеДокумента.Реквизиты.Найти("Контрагент") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Контрагент = КонтрагентыДокументов.Получить(Документ);
	Если Контрагент <> Неопределено Тогда
		Возврат Контрагент;
	КонецЕсли;
	
	Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Контрагент");
	КонтрагентыДокументов.Вставить(Документ, Контрагент);
	Возврат Контрагент;
	
КонецФункции

Функция РазыменоватьПроектИзДокумента(МетаданныеДокумента, Документ, ПроектыДокументов)
	
	Если МетаданныеДокумента.Реквизиты.Найти("Проект") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Проект = ПроектыДокументов.Получить(Документ);
	Если Проект <> Неопределено Тогда
		Возврат Проект;
	КонецЕсли;
	
	Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Проект");
	ПроектыДокументов.Вставить(Документ, Проект);
	Возврат Проект;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли