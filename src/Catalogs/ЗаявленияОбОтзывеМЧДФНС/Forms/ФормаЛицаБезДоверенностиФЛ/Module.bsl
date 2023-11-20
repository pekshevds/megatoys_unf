
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	Если СтруктураДанных.Свойство("ТолькоПросмотрФормы") И СтруктураДанных.ТолькоПросмотрФормы Тогда
		Элементы.ЛицоБезДовФЛ_ФИО.ТолькоПросмотр 			= Истина;
		Элементы.ЛицоБезДовФЛ_Должность.ТолькоПросмотр 		= Истина;
		Элементы.ЛицоБезДовФЛ_Телефон.ТолькоПросмотр 		= Истина;
		Элементы.ФормаКнопкаСохранить.Доступность 			= Ложь;
	КонецЕсли;
	
	Если СтруктураДанных <> Неопределено Тогда
		ЛицоБезДовФЛ_Фамилия 		= СтруктураДанных.ЛицоБезДовФЛ_Фамилия;
		ЛицоБезДовФЛ_Имя 			= СтруктураДанных.ЛицоБезДовФЛ_Имя;
		ЛицоБезДовФЛ_Отчество 		= СтруктураДанных.ЛицоБезДовФЛ_Отчество;
		ЛицоБезДовФЛ_ФИО 			= СтруктураДанных.ЛицоБезДовФЛ_ФИО;
		
		ЛицоБезДовФЛ_Должность 		= СтруктураДанных.ЛицоБезДовФЛ_Должность;
		ЛицоБезДовФЛ_Телефон 		= СтруктураДанных.ЛицоБезДовФЛ_Телефон;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЛицоБезДовФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФормаВводаФИО = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВводаФИО");
	
	ФормаВводаФИО.Фамилия 	= ЛицоБезДовФЛ_Фамилия;
	ФормаВводаФИО.Имя 		= ЛицоБезДовФЛ_Имя;
	ФормаВводаФИО.Отчество 	= ЛицоБезДовФЛ_Отчество;
	
	ФормаВводаФИО.ОписаниеОповещенияОЗакрытии =
		Новый ОписаниеОповещения("ЛицоБезДовФЛ_ФИОНачалоВыбораЗавершение", ЭтотОбъект);
	ФормаВводаФИО.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВводаФИО.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЛицоБезДовФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ЛицоБезДовФЛ_Фамилия 	= "";
	ЛицоБезДовФЛ_Имя 		= "";
	ЛицоБезДовФЛ_Отчество 	= "";
	
	ЛицоБезДовФЛ_ФИО = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Фамилия", 		ЛицоБезДовФЛ_Фамилия);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Имя", 			ЛицоБезДовФЛ_Имя);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Отчество", 		ЛицоБезДовФЛ_Отчество);
	
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Должность", 		ЛицоБезДовФЛ_Должность);
	СтруктураДанных.Вставить("ЛицоБезДовФЛ_Телефон", 		ЛицоБезДовФЛ_Телефон);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(ЛицоБезДовФЛ_Фамилия) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана фамилия.'"),,
			"ЛицоБезДовФЛ_ФИО",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЛицоБезДовФЛ_Имя) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано имя.'"),,
			"ЛицоБезДовФЛ_ФИО",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура ЛицоБезДовФЛ_ФИОНачалоВыбораЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатРедактирования) Тогда
		Возврат;
	КонецЕсли;
	
	ЛицоБезДовФЛ_Фамилия 	= РезультатРедактирования.Фамилия;
	ЛицоБезДовФЛ_Имя 		= РезультатРедактирования.Имя;
	ЛицоБезДовФЛ_Отчество 	= РезультатРедактирования.Отчество;
	
	ЛицоБезДовФЛ_ФИО = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеФИО(РезультатРедактирования);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
