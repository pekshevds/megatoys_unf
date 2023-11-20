
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОК(Команда)
	
	КоллекцияИНН = Новый Массив;
	
	Для каждого Стр Из ТаблицаИНН Цикл
		
		ИНН = СокрЛП(Стр.ИНН);
		Если ЗначениеЗаполнено(ИНН) Тогда
			КоллекцияИНН.Добавить(ИНН);
		КонецЕсли;
		
	КонецЦикла;
	
	Закрыть(СтрСоединить(КоллекцияИНН, ", "));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КоллекцияИНН = СтрРазделить(Параметры.ИНН, ", ", Ложь);
	
	Для Каждого ИНН Из КоллекцияИНН Цикл
		
		НовСтр = ТаблицаИНН.Добавить();
		НовСтр.ИНН = ИНН;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	МассивСтрокТабл = ТаблицаИНН.НайтиСтроки(Новый Структура("ИНН", Элементы.ТаблицаИНН.ТекущиеДанные.ИНН));
	ТекСтрокаТабл   = МассивСтрокТабл[МассивСтрокТабл.Количество() - 1];
	ТекИНН          = ТекСтрокаТабл.ИНН;
	ТекИННДлина     = СтрДлина(СокрЛП(ТекИНН));
	
	Если ТекИННДлина <> 0 И ТекИННДлина <> 10 И ТекИННДлина <> 12 Тогда
		
		ТекСтрокаТабл.ИНН = "";
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='ИНН должен состоять из 10 или 12 цифр. Значение очищено'");
		Сообщение.Сообщить();
		
	ИначеЕсли ТаблицаИНН.НайтиСтроки(Новый Структура("ИНН", ТекИНН)).Количество() > 1 Тогда
		
		ТекСтрокаТабл.ИНН = "";
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон(НСтр("ru='ИНН %1 уже введен. Значение очищено'"), СокрЛП(ТекИНН));
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти