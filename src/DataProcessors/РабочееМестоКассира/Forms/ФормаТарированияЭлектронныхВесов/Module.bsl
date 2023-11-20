
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ЕстьСвойство(Параметры, "ВесТары") Тогда
		ВесТары = Параметры.ВесТары;
	КонецЕсли;
	
	Если ЕстьСвойство(Параметры, "ЭлектронныеВесыЗаняты") Тогда
		ЭлектронныеВесыЗаняты = Параметры.ЭлектронныеВесыЗаняты;
	КонецЕсли;
	
	Если ЕстьСвойство(Параметры, "ТаблицаЭлектронныхВесов") Тогда
		Для Каждого ВесыДляТарирования Из Параметры.ТаблицаЭлектронныхВесов Цикл
			Элементы.ТекущиеЭлектронныеВесы.СписокВыбора.Добавить(ВесыДляТарирования.ЭлектронныеВесы);
			НовыеЭлектронныеВесы = ТаблицаЭлектронныхВесов.Добавить();
			НовыеЭлектронныеВесы.ЭлектронныеВесы = ВесыДляТарирования.ЭлектронныеВесы;
		КонецЦикла;
	КонецЕсли;
	
	ТекущиеЭлектронныеВесы = ТаблицаЭлектронныхВесов[0].ЭлектронныеВесы;
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЭлектронныхВесов) Тогда
		
		Отказ = Истина;
		Возврат; 

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	ДанныеВесаТары = Новый Структура("ЭлектронныеВесыЗаняты", ЭлектронныеВесыЗаняты);
	Закрыть(ДанныеВесаТары);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВес(Команда)
	ПолучитьТекущийВес();
КонецПроцедуры

&НаКлиенте
Процедура СброситьВесТары(Команда)
	ТарироватьВесомТовараНаВесах();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВесИзФормы(Команда)
	ТарироватьЗаданнымВесом();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаРезультатаТарированияВесов(Результат, ПараметрыТарирования) Экспорт
	
	ЭлектронныеВесыЗаняты = Ложь;
	
	Если ЕстьСвойство(Результат, "Результат")
		И Результат.Результат Тогда
		
		ДанныеВесаТары = Новый Структура("ВесТары,ЭлектронныеВесыЗаняты", ВесТары, ЭлектронныеВесыЗаняты);
		
		ЭтоСбросЗначения = Ложь;
		
		Оповестить("ТарированиеВесов", ДанныеВесаТары, "ФормаТарированияВесов");
		
		Если ПараметрыТарирования.Свойство("ЭтоСбросЗначения", ЭтоСбросЗначения)
			И НЕ ЭтоСбросЗначения Тогда
			Закрыть();
		КонецЕсли;
		
	Иначе
		
		ТекстПредупреждения = НСтр("ru = 'При тарировании весов возникла ошибка. Пожалуйста, повторите попытку.'");
		
		Если ЕстьСвойство(Результат, "ОписаниеОшибки")
			И ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
			
			ТекстПредупреждения = Результат.ОписаниеОшибки;
		КонецЕсли;
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТекущийВес()
	
	ЭлектронныеВесыЗаняты = Истина;
	ПараметрыОперации = Новый Структура();
	ОповещениеЗавершенияВзвешивания = Новый ОписаниеОповещения("ПолучитьВесСЭлектронныхВесовЗавершение",
		ЭтотОбъект);
	ОборудованиеВесовоеОборудованиеКлиент.НачатьПолученияВесаСЭлектронныхВесов(ОповещениеЗавершенияВзвешивания,
		УникальныйИдентификатор, ТекущиеЭлектронныеВесы, ПараметрыОперации);

	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесСЭлектронныхВесовЗавершение(Результат, ПараметрыВзвешивания) Экспорт
	
	ЭлектронныеВесыЗаняты = Ложь;
	
	Если ЕстьСвойство(Результат, "Результат")
		И ЕстьСвойство(Результат, "Вес")
		И Результат.Результат Тогда
		
		ВесТары = Результат.Вес;
		
	Иначе
		
		ТекстПредупреждения = НСтр("ru = 'При взвешивании товара произошла ошибка. Пожалуйста, повторите попытку.'");
		
		Если НЕ (Результат = Неопределено ИЛИ ПустаяСтрока(Результат.ОписаниеОшибки)) Тогда
			ТекстПредупреждения = Результат.ОписаниеОшибки;
		КонецЕсли;
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТарироватьВесы(ЗначениеВесаТары, ЭтоСбросЗначения = Ложь)
	
	ЭлектронныеВесыЗаняты = Истина;
	
	ПараметрыТарирования = Новый Структура("ЭтоСбросЗначения", ЭтоСбросЗначения);
	ОповещениеОбОкончанииУстановкиВесаТары = Новый ОписаниеОповещения("ОбработкаРезультатаТарированияВесов",
		ЭтотОбъект,
		ПараметрыТарирования);
	
	ПараметрыОперации = ОборудованиеВесовоеОборудованиеКлиентСервер.ПараметрыОперацииЭлектронныеВесы(ЗначениеВесаТары);
	ОборудованиеВесовоеОборудованиеКлиент.НачатьУстановкуВесаТарыЭлектронныхВесов(ОповещениеОбОкончанииУстановкиВесаТары,
		УникальныйИдентификатор,
		ТекущиеЭлектронныеВесы,
		ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ТарироватьВесомТовараНаВесах()
	
	Если НЕ ЭлектронныеВесыЗаняты Тогда
		
		ВесТары = 0;
		ЗначениеВесаТарыДляВесов = Неопределено;
		ЭтоСбросЗначения = Истина;
		ТарироватьВесы(ЗначениеВесаТарыДляВесов, ЭтоСбросЗначения);
		
	Иначе
		
		ТекстПредупреждения = НСтр("ru = 'Ошибка тарирования весов.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТарироватьЗаданнымВесом()
	
	Если НЕ ЭлектронныеВесыЗаняты И ВесТары > 0 Тогда
		ТарироватьВесы(ВесТары);
	Иначе
		
		ТекстПредупреждения = НСтр("ru = 'Укажите отличный от нуля вес тары для тарирования весов.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьСвойство(Объект, ИмяРеквизита)
	Возврат ОбщегоНазначенияРМККлиентСервер.ЕстьСвойство(Объект, ИмяРеквизита);
КонецФункции

#КонецОбласти