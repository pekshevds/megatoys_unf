
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РедактируемыеРеквизиты = Параметры.РедактируемыеРеквизиты;
	ЗаполнитьЗначенияСвойств(Объект, Параметры.Объект, РедактируемыеРеквизиты);
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	СтруктураЗакрытия = Новый Структура("Объект, РедактируемыеРеквизиты, Модифицированность", Объект, РедактируемыеРеквизиты, Модифицированность);
	Закрыть(СтруктураЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбъектНастройкаНалогаПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСтавкаНалогаПриИзменении(Элемент)
	
	Если Объект.СтавкаНалога > 100 Тогда
		Объект.СтавкаНалога = 100;
	КонецЕсли;
	
	УстановитьСтавкуНалогаПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектНалогВСуммеПриИзменении(Элемент)
	
	УстановитьНалогВСуммеПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ОбъектНалогВСумме.Видимость = Ложь;
	Элементы.ОбъектСуммаНалога.Видимость = Ложь;
	Элементы.ОбъектНазваниеНалога.Видимость = Ложь;
	Элементы.ОбъектСтавкаНалога.Видимость = Ложь;
	
	Если Объект.НастройкаНалога = Перечисления.НастройкиНалогаМП.НаВесьДокумент Тогда
		Элементы.ОбъектСтавкаНалога.Видимость = Истина;
		Элементы.ОбъектНазваниеНалога.Видимость = Истина;
		Элементы.ОбъектНалогВСумме.Видимость = Истина;
	ИначеЕсли Объект.НастройкаНалога = Перечисления.НастройкиНалогаМП.Построчно Тогда
		Элементы.ОбъектНалогВСумме.Видимость = Истина;
		Элементы.ОбъектНазваниеНалога.Видимость = Истина;
	КонецЕсли;
	
	Если Элементы.ОбъектНазваниеНалога.Видимость
		И НЕ ЗначениеЗаполнено(Объект.НазваниеНалога) Тогда
		НазваниеНалогаПоУмолчанию = Константы.НазваниеНалогаПоУмолчаниюМП.Получить();
		Если ЗначениеЗаполнено(НазваниеНалогаПоУмолчанию) Тогда
			Объект.НазваниеНалога = НазваниеНалогаПоУмолчанию;
		Иначе
			Объект.НазваниеНалога = НСтр("en = 'Sales Tax'; ru = 'НДС'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтавкуНалогаПоУмолчанию()
	
	Константы.СтавкаНалогаПоУмолчаниюМП.Установить(Объект.СтавкаНалога);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНалогВСуммеПоУмолчанию()
	
	Константы.НалогВСуммеПоУмолчаниюМП.Установить(Объект.НалогВСумме);
	
КонецПроцедуры

#КонецОбласти


