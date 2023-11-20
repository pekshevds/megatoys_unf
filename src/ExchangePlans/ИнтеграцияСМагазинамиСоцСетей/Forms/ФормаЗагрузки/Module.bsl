
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СсылкаНаУзелОбмена = Параметры.СсылкаНаУзелОбмена;
	
	ОписаниеУзлаОбмена = ПланыОбмена.ИнтеграцияСМагазинамиСоцСетей.ПолучитьОписаниеУзлаОбмена(СсылкаНаУзелОбмена);
	
	ДатаЗагрузкиОстатков = НачалоДня(ТекущаяДатаСеанса());
	ДатаУстановкиЦен = НачалоДня(ТекущаяДатаСеанса());
	Организация = ОписаниеУзлаОбмена.Организация;
	ВидЦеныНоменклатуры = ОписаниеУзлаОбмена.ВидЦеныНоменклатуры;
	ВидЦеныНоменклатурыСтарая = ОписаниеУзлаОбмена.ВидЦеныНоменклатурыСтарая;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьОтображениеНаКлиенте(); 
	
	Элементы.СтраницыТело.ТекущаяСтраница = Элементы.СтраницаНастройка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовЭлементовФормы

&НаКлиенте
Процедура ЗагружатьЦеныПриИзменении(Элемент)
	ОбновитьОтображениеНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьОстаткиПриИзменении(Элемент)
	ОбновитьОтображениеНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьЗагрузку(Команда)
	
	Отказ = Ложь;
	
	Если ЗагружатьЦены И НЕ ЗначениеЗаполнено(ДатаУстановкиЦен) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обязательное поле!",,"ДатаУстановкиЦен",,Отказ);
	КонецЕсли;
	
	Если ЗагружатьЦены И НЕ ЗначениеЗаполнено(ВидЦеныНоменклатуры) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обязательное поле!",,"ВидЦеныНоменклатуры",,Отказ);
	КонецЕсли;
	
	Если ЗагружатьОстатки И НЕ ЗначениеЗаполнено(ДатаЗагрузкиОстатков) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обязательное поле!",,"ДатаЗагрузкиОстатков",,Отказ);
	КонецЕсли;
	
	Если ЗагружатьОстатки И НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обязательное поле!",,"Организация",,Отказ);
	КонецЕсли;
	
	Если ЗагружатьОстатки И НЕ ЗначениеЗаполнено(СкладДляПодстановкиВЗаказыИОстатков) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обязательное поле!",,"Склад",,Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ЗапуститьЗагрузкуВФоне();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтображениеНаКлиенте()
	
	Элементы.СтраницыЦены.ТекущаяСтраница
	= ?(ЗагружатьЦены, Элементы.СтраницаЗагружатьЦены, Элементы.СтраницаНеЗагружатьЦены);
	
	Элементы.СтраницыОстатки.ТекущаяСтраница
	= ?(ЗагружатьОстатки, Элементы.СтраницаЗагружатьОстатки, Элементы.СтраницаНеЗагружатьОстатки);
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьЗагрузкуВФонеСервер() 
	
	ОписаниеУзелОбмена = ПланыОбмена.ИнтеграцияСМагазинамиСоцСетей.ПолучитьОписаниеУзлаОбмена(СсылкаНаУзелОбмена);
	ОписаниеУзелОбмена.Вставить("ИмяСобытия", НаименованиеФоновойЗагрузки());
	
	ОписаниеУзелОбмена.Вставить("ЗагружатьВиртуальныеКаталоги", ЗагружатьВиртуальныеКаталоги);
	
	ОписаниеУзелОбмена.Вставить("ЗагружатьЦены", ЗагружатьЦены);
	ОписаниеУзелОбмена.Вставить("ВидЦеныНоменклатуры", ВидЦеныНоменклатуры);
	ОписаниеУзелОбмена.Вставить("ВидЦеныНоменклатурыСтарая", ВидЦеныНоменклатурыСтарая);
	ОписаниеУзелОбмена.Вставить("ДатаУстановкиЦен", ДатаУстановкиЦен);
	
	ОписаниеУзелОбмена.Вставить("ЗагружатьОстатки", ЗагружатьОстатки);
	ОписаниеУзелОбмена.Вставить("Организация", Организация);
	ОписаниеУзелОбмена.Вставить("СкладДляПодстановкиВЗаказыИОстатков", СкладДляПодстановкиВЗаказыИОстатков);
	ОписаниеУзелОбмена.Вставить("ДатаЗагрузкиОстатков", ДатаЗагрузкиОстатков);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ОписаниеУзелОбмена", ОписаниеУзелОбмена);
	ПараметрыЗадания.Вставить("ПолучатьВсеДанные", Истина);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновойЗагрузки();
	ПараметрыВыполнения.ЗапуститьНеВФоне = Ложь;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Попытка
		Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ПланыОбмена.ИнтеграцияСМагазинамиСоцСетей.ЗагрузитьНоменклатуру",
		ПараметрыЗадания,
		ПараметрыВыполнения);
	Исключение
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьИсключениеНаСервере(ПредставлениеОшибки);
		ВызватьИсключение;
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура ЗаписатьИсключениеНаСервере(Знач ПредставлениеОшибки)
	
	ЗаписьЖурналаРегистрации(НаименованиеФоновойЗагрузки(), УровеньЖурналаРегистрации.Ошибка, , , ПредставлениеОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатВыполненияЗадания(Результат)
	
	Если Результат.Статус = "Выполнено" Тогда
		
		Закрыть(Истина);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		СтрокаЛогЗагрузкиССайта = СтрокаЛогЗагрузкиССайта + ?(СтрокаЛогЗагрузкиССайта="","",Символы.ПС) +
		Результат.КраткоеПредставлениеОшибки + " " + Результат.ПодробноеПредставлениеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		
		Элементы.СтраницыТело.ТекущаяСтраница = Элементы.СтраницаРезультатВыполнения;
		
	ИначеЕсли Результат.Статус = "Отменено" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Отменено пользователем");
		Элементы.СтраницыТело.ТекущаяСтраница = Элементы.СтраницаРезультатВыполнения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьЗагрузкуВФоне()
	
	Элементы.СтраницыТело.ТекущаяСтраница = Элементы.СтраницаХодВыполнения;
	
	ДлительнаяОперация = ЗапуститьЗагрузкуВФонеСервер();
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ОбработатьРезультатВыполненияЗадания(ДлительнаяОперация);
		Возврат;
	КонецЕсли;
	
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ВыполнитьДействиеПрогрессВыполнения", ЭтотОбъект);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ВыполнитьДействиеЗавершение", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = НаименованиеФоновойЗагрузки();
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	ОбработатьРезультатВыполненияЗадания(Результат);
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьДействиеПрогрессВыполнения(Прогресс, ДополнительныеПараметры) Экспорт
	
	Если Прогресс.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Прогресс.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(Прогресс.Прогресс) = Тип("Структура") Тогда
		
		ПроцентПрогресса = Прогресс.Прогресс.Процент;
		СтрокаЛогЗагрузкиССайта = Прогресс.Прогресс.Текст;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НаименованиеФоновойЗагрузки() Экспорт
	
	#Если Клиент Тогда
		КодОсновногоЯзыка = ОбщегоНазначенияКлиент.КодОсновногоЯзыка();
	#Иначе
		КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	#КонецЕсли
	
	Возврат НСтр("ru = 'Интеграция ВКонтакте.Первичная загрузка'", КодОсновногоЯзыка);
	
КонецФункции

#КонецОбласти
