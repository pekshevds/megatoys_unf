#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьОснованиеПолномочийНаДату(Организация, ФизическоеЛицо, Дата) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОснованияПолномочийОтветственныхЛиц.НомерПоПорядку КАК НомерПоПорядку,
		|	ОснованияПолномочийОтветственныхЛиц.ОснованиеПодписи КАК ОснованиеПодписи,
		|	ОснованияПолномочийОтветственныхЛиц.Должность КАК Должность,
		|	ОснованияПолномочийОтветственныхЛиц.ДатаНачала КАК ДатаНачала,
		|	ОснованияПолномочийОтветственныхЛиц.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|ГДЕ
		|	ОснованияПолномочийОтветственныхЛиц.Организация = &Организация
		|	И ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо = &ФизическоеЛицо
		|	И ОснованияПолномочийОтветственныхЛиц.ДатаНачала <= &Дата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала УБЫВ,
		|	ОснованияПолномочийОтветственныхЛиц.НомерПоПорядку УБЫВ";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Дата", Дата);

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИнформацияОбОсновании = РезультатЗапроса.Выбрать();

	РеквизитыОснованияПодписи = Новый Структура;
	РеквизитыОснованияПодписи.Вставить("НомерПоПорядку");
	РеквизитыОснованияПодписи.Вставить("ОснованиеПодписи");
	РеквизитыОснованияПодписи.Вставить("Должность");
	РеквизитыОснованияПодписи.Вставить("ДатаНачала");
	РеквизитыОснованияПодписи.Вставить("ДатаОкончания");
	
	Если ИнформацияОбОсновании.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыОснованияПодписи, ИнформацияОбОсновании);
	КонецЕсли;

	Возврат ИнформацияОбОсновании;

КонецФункции

Функция ТаблицаПоследнихОснованийПолномочий(Организация, ФизическоеЛицо, МассивИсключаемыхНомеров) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 5
		|	ОснованияПолномочийОтветственныхЛиц.НомерПоПорядку КАК НомерПоПорядку,
		|	ОснованияПолномочийОтветственныхЛиц.Должность КАК Должность,
		|	ОснованияПолномочийОтветственныхЛиц.ОснованиеПодписи КАК ОснованиеПодписи,
		|	ОснованияПолномочийОтветственныхЛиц.ДатаНачала КАК ДатаНачала,
		|	ОснованияПолномочийОтветственныхЛиц.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|ГДЕ
		|	ОснованияПолномочийОтветственныхЛиц.Организация = &Организация
		|	И ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо = &ФизическоеЛицо
		|	И НЕ ОснованияПолномочийОтветственныхЛиц.НомерПоПорядку В (&МассивИсключаемыхНомеров)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала УБЫВ,
		|	ОснованияПолномочийОтветственныхЛиц.НомерПоПорядку УБЫВ";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("МассивИсключаемыхНомеров", МассивИсключаемыхНомеров);

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДолжностиФизическихЛицИзОтветственныхЛиц(ПараметрыОбновления = Неопределено) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.СведенияОбОтветственныхЛицах") Тогда
		МодульСведенияОбОтветственныхЛицах = ОбщегоНазначения.ОбщийМодуль("СведенияОбОтветственныхЛицах");
		МодульСведенияОбОтветственныхЛицах.СоздатьВТУдаленныеДолжностиОтветственныхЛицОрганизаций(МенеджерВременныхТаблиц);
	КонецЕсли;

	Если Не ЗарплатаКадры.ВТСуществует(МенеджерВременныхТаблиц, "ВТУдаленныеДолжностиОтветственныхЛицОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УдаленныеДолжности.Организация КАК Организация,
		|	УдаленныеДолжности.ФизическоеЛицо КАК ФизическоеЛицо,
		|	УдаленныеДолжности.Должность КАК Должность,
		|	"""" КАК ОснованиеПодписи
		|ИЗ
		|	ВТУдаленныеДолжностиОтветственныхЛицОрганизаций КАК УдаленныеДолжности
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|		ПО УдаленныеДолжности.Организация = ОснованияПолномочийОтветственныхЛиц.Организация
		|			И УдаленныеДолжности.ФизическоеЛицо = ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо
		|ГДЕ
		|	ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ОснованияПолномочийОтветственныхЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);

КонецПроцедуры

Функция ФизическиеЛицаОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|ГДЕ
		|	ОснованияПолномочийОтветственныхЛиц.Организация = &Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФизическоеЛицо
		|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Организация", Организация);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
КонецФункции

Функция НомерПоПорядкуВРегистре(Организация, ФизическоеЛицо) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(ОснованияПолномочийОтветственныхЛиц.НомерПоПорядку), 0) + 1  КАК НомерПоПорядку
		|ИЗ
		|	РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|ГДЕ
		|	ОснованияПолномочийОтветственныхЛиц.Организация = &Организация
		|	И ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо = &ФизическоеЛицо";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);

	Возврат Запрос.Выполнить().Выгрузить()[0].НомерПоПорядку;

КонецФункции

#КонецОбласти

#КонецЕсли