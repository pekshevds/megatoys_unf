#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 * ИЗ Справочник.Банки КАК Банки ГДЕ Банки.РучноеИзменение <> 2");
	РезультатВыполненияЗапроса = Запрос.Выполнить();
	
	БанкиОбновлялисьИзКлассификатора = НЕ РезультатВыполненияЗапроса.Пустой();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Вызывается из Справочники.КлассификаторБанков.ФормаВыбора
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать банк из классификатора.
		|Подобрать?'");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЭтоГруппа", Группа);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОпределитьНеобходимостьПодбораБанкаИзКлассификатора", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьНеобходимостьПодбораБанкаИзКлассификатора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = КодВозвратаДиалога.Да Тогда
		
		ПараметрыФормы = Новый Структура("РежимВыбора, ЗакрыватьПриВыборе, МножественныйВыбор", Истина, Истина, Истина);
		ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, ЭтотОбъект);
		
	Иначе
		
		Если ДополнительныеПараметры.ЭтоГруппа Тогда
			
			ОткрытьФорму("Справочник.Банки.ФормаГруппы", Новый Структура("ЭтоГруппа",Истина), ЭтотОбъект);
			
		Иначе
			
			ОткрытьФорму("Справочник.Банки.ФормаОбъекта");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
	ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатора(Команда)
	
	Если НЕ БанкиОбновлялисьИзКлассификатора Тогда
		
		ТекстВопроса = НСтр("ru = 'ВНИМАНИЕ:
		|Произойдет обновление всех банков из классификатора. Если данные банков изменялись вручную, то изменения могут быть утеряны.
		|В дальнейшем, для исключения банка из автоматического обновления, необходимо включить признак ручного изменения (команда ""Изменить"").
		|Продолжить?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбновитьИзКлассификатораЗавершение", ЭтотОбъект), ТекстВопроса,
			РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Нет);
		Возврат;
		
	КонецЕсли;
	
	НачатьОбновлениеИзКлассификатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	НачатьОбновлениеИзКлассификатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьОбновлениеИзКлассификатора()
	
	ДлительнаяОперация = НачатьОбновлениеИзКлассификатораНаСервере();
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатОбновленияКлассификатора", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Обновление справочника ""Банки"" по данным классификатора.'");
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьОбновлениеИзКлассификатораНаСервере()
	Результат = ДлительныеОперации.ВыполнитьПроцедуру( , "БанкиУНФ.СинхронизироватьБанкиСКлассификатором", Новый Массив);
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатОбновленияКлассификатора(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ТекстОповещения = НСтр("ru = 'Банки успешно обновлены из классификатора'");
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление'"), , ТекстОповещения);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
	Иначе
		Возврат;
	КонецЕсли;
	
	Оповестить("ОбновитьПослеДобавления");
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


