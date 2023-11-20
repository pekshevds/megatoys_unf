#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗапись();
	Элементы.ГруппаДанныеВычета.Доступность = запись.Применяется;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрименяетсяПриИзменении(Элемент)
	
	Элементы.ГруппаДанныеВычета.Доступность = запись.Применяется;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьЗапись();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьЗапись();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
&НаСервере
Процедура ЗаполнитьЗапись()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛСоциальныеВычетыСрезПоследних.Период,
	|	НДФЛСоциальныеВычетыСрезПоследних.Сотрудник,
	|	НДФЛСоциальныеВычетыСрезПоследних.КодВычета,
	|	НДФЛСоциальныеВычетыСрезПоследних.Применяется,
	|	НДФЛСоциальныеВычетыСрезПоследних.СуммаРасходов,
	|	НДФЛСоциальныеВычетыСрезПоследних.КодИФНС,
	|	НДФЛСоциальныеВычетыСрезПоследних.НомерУведомления,
	|	НДФЛСоциальныеВычетыСрезПоследних.ДатаУведомления,
	|	НДФЛСоциальныеВычетыСрезПоследних.Представление
	|ИЗ
	|	РегистрСведений.НДФЛСоциальныеВычеты.СрезПоследних КАК НДФЛСоциальныеВычетыСрезПоследних
	|ГДЕ
	|	НДФЛСоциальныеВычетыСрезПоследних.Сотрудник = &Сотрудник";
	Запрос.УстановитьПараметр("Сотрудник", Параметры.Сотрудник);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
	Иначе
		Запись.Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

// Процедура сохраняет запись в регистр сведений ДокументыФизическихЛиц
&НаСервере
Процедура СохранитьЗапись()
	
	МенеджерЗаписи = РегистрыСведений.НДФЛСоциальныеВычеты.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
	МенеджерЗаписи.Записать();
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти

