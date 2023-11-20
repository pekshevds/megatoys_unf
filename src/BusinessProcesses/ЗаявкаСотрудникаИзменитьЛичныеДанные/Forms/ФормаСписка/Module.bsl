#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
		ПоказыватьЗавершенныеЗадания = Истина;
	КонецЕсли;
	
	ПоИсполнителю = Пользователи.ТекущийПользователь();
	
	УстановитьОтбор();
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеБизнесПроцессов(Список.УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьОтборСписка(Настройки);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗавершенныеЗаданияПриИзменении(Элемент)
	УстановитьОтбор();
	Элементы.Список.Обновить();	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоказыватьЗавершенныеЗадания", ПоказыватьЗавершенныеЗадания);
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	УстановитьОтборСписка(ПараметрыОтбора);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка(ПараметрыОтбора)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Завершен", Ложь,,,
		Не ПараметрыОтбора["ПоказыватьЗавершенныеЗадания"]);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Автор", ПараметрыОтбора["ПоАвтору"],,,
		Не ПараметрыОтбора["ПоАвтору"].Пустая());
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Исполнитель", ПараметрыОтбора["ПоИсполнителю"],,,
		Не ПараметрыОтбора["ПоИсполнителю"].Пустая());	
КонецПроцедуры

#КонецОбласти
