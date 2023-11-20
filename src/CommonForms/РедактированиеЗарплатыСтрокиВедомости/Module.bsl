#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьПараметры();
	ПолучитьЗарплата();

	ВедомостьНаВыплатуЗарплатыФормыВнутренний.РедактированиеЗарплатыСтрокиНастроитьЭлементы(ЭтотОбъект);
	ВидыДоходовИсполнительногоПроизводстваКлиентСервер.НастроитьКолонкуВидДоходаДляВыплатыЗарплаты(
		ЭтотОбъект,
		"Зарплата",
		"ЗарплатаВидДохода",
		"Зарплата.ВидДоходаИсполнительногоПроизводства"
		,
		ДатаВыплаты);
	
	Заголовок = СтрШаблон(НСтр("ru='%1 : зарплата'"), Строка(ФизическоеЛицо));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для ИндексСтроки = 0 По Зарплата.Количество() - 1 Цикл
		
		Если НЕ ЗначениеЗаполнено(Зарплата[ИндексСтроки].Сотрудник) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='Не указан сотрудник'"),, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Зарплата", ИндексСтроки + 1, "Сотрудник"),,
				Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Зарплата[ИндексСтроки].ПериодВзаиморасчетов) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='Не задан период взаиморасчетов'"),, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Зарплата", ИндексСтроки + 1, "ПериодВзаиморасчетовСтрокой"),,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗарплата

&НаКлиенте
Процедура ЗарплатаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, ЭтотОбъект);
		Элемент.ТекущиеДанные.ПериодВзаиморасчетов = ПериодРегистрации;
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Зарплата, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаСотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ СотрудникСоответствуетФизическомуЛицу(ВыбранноеЗначение, ФизическоеЛицо) Тогда
		
		ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Недопустимое значение'"), , 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"Зарплата[%1].Сотрудник", 
				Зарплата.Индекс(Элементы.Зарплата.ТекущиеДанные)));
		
	КонецЕсли	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПериодВзаиморасчетовПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.Зарплата.ТекущиеДанные, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПериодВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, Элементы.Зарплата.ТекущиеДанные, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПериодВзаиморасчетовРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.Зарплата.ТекущиеДанные, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПериодВзаиморасчетовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПериодВзаиморасчетовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьПараметры()
	
	Параметры.Свойство("ИдентификаторСтроки",  ИдентификаторСтроки);
	Параметры.Свойство("ФизическоеЛицо",        ФизическоеЛицо);
	Параметры.Свойство("Организация",           Организация);
	Параметры.Свойство("Подразделение",         Подразделение);
	Параметры.Свойство("ПериодРегистрации",     ПериодРегистрации);
	Параметры.Свойство("ДатаВыплаты",           ДатаВыплаты);
	Параметры.Свойство("СтатьяФинансирования",  СтатьяФинансирования);
	Параметры.Свойство("СтатьяРасходов",        СтатьяРасходов);
	Параметры.Свойство("ВидДоходаИсполнительногоПроизводства", ВидДоходаИсполнительногоПроизводства);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗарплата()
	
	Зарплата.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилищеЗарплатыПоСтроке));
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(
		Зарплата, 
		"ПериодВзаиморасчетов", 
		"ПериодВзаиморасчетовСтрокой");
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СотрудникСоответствуетФизическомуЛицу(Сотрудник, ФизическоеЛицо)
	ФизическоеЛицоСотрудника = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
	Возврат ФизическоеЛицоСотрудника = ФизическоеЛицо
КонецФункции

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатыРедактирования = Новый Структура;
		РезультатыРедактирования.Вставить("Модифицированность", Модифицированность);
		РезультатыРедактирования.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
		РезультатыРедактирования.Вставить("АдресВХранилищеЗарплатыПоСтроке", АдресВХранилищеЗарплатыПоСтроке());
		
		Модифицированность = Ложь;
		Закрыть(РезультатыРедактирования)
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеЗарплатыПоСтроке()
	
	ЗарплатаФизлица = Зарплата.Выгрузить();
	ЗарплатаФизлица.ЗаполнитьЗначения(ИдентификаторСтроки, "ИдентификаторСтроки");
	
	Возврат ПоместитьВоВременноеХранилище(ЗарплатаФизлица, УникальныйИдентификатор);
	
КонецФункции	

#КонецОбласти