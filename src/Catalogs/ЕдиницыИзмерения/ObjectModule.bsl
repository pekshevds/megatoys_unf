#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных
Перем КоэффициентПередЗаписью;
Перем ЕдиницаПоКлассификаторуПередЗаписью;
#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ФормироватьПечатныйДокументВПользовательскойЕдинице = Перечисления.ПечатьПользовательскихЕдиницИзмерения.ФормироватьПечатныйДокументВПользовательскойЕдинице;
	Если Константы.ПечатьПользовательскихЕдиницИзмерения.Получить() = ФормироватьПечатныйДокументВПользовательскойЕдинице Тогда
		
		ПроверяемыеРеквизиты.Добавить("ЕдиницаИзмеренияПоКлассификатору");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа 
		И ЗначениеЗаполнено(Владелец)
		И Не ЗначениеЗаполнено(ЕдиницаИзмеренияВладельца) Тогда
		ЕдиницаИзмеренияВладельца = Владелец.ЕдиницаИзмерения;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		КоэффициентПередЗаписью = Ссылка.Коэффициент;
		ЕдиницаПоКлассификаторуПередЗаписью = Ссылка.ЕдиницаИзмеренияПоКлассификатору;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьВесИОбъемЕдиницыТовара();
	
	Если Не ЭтоГруппа Тогда
		ЗаписатьИнформациюОСменеЕдиницыИзмерения(Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьВесИОбъемЕдиницыТовара()
	
	Если Не ДополнительныеСвойства.Свойство("УказатьВесИОбъемДляЕдиницыТовара") Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ВесИОбъемЕдиницТоваров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЕдиницаИзмерения.Установить(Ссылка);
	
	Если ТипЗнч(Владелец) <> Тип("СправочникСсылка.Номенклатура") Тогда
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.УказатьВесИОбъемДляЕдиницыТовара Тогда
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Номенклатура = Владелец;
	Запись.ЕдиницаИзмерения = Ссылка;
	Запись.Вес = ДополнительныеСвойства.Вес;
	Запись.Объем = ДополнительныеСвойства.Объем;
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ЗаписатьИнформациюОСменеЕдиницыИзмерения(Отказ)
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;
	
	Если Не КоэффициентПередЗаписью = Коэффициент
		Или Не ЕдиницаПоКлассификаторуПередЗаписью = ЕдиницаИзмеренияПоКлассификатору Тогда
		
		МенеджерЗаписи = РегистрыСведений.ИсторияИзмененийЕдиницИзмерения.СоздатьМенеджерЗаписи();
	
		МенеджерЗаписи.Период = ТекущаяДатаСеанса();
		МенеджерЗаписи.ВладелецЕдиницыИзмерения = Ссылка;
		МенеджерЗаписи.Пользователь = Пользователи.ТекущийПользователь();
		МенеджерЗаписи.СтараяЕдиницаИзмерения = ЕдиницаПоКлассификаторуПередЗаписью;
		МенеджерЗаписи.НоваяЕдиницаИзмерения = ЕдиницаИзмеренияПоКлассификатору;
		МенеджерЗаписи.КоэффициентДО = КоэффициентПередЗаписью;
		МенеджерЗаписи.КоэффициентПосле = Коэффициент;

		МенеджерЗаписи.Записать()
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли