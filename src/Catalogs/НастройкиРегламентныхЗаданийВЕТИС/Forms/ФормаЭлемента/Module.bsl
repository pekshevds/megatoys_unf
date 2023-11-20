
#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущийХС;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		УстановитьНаименование = Ложь;
		Если Параметры.ЗначенияЗаполнения.Свойство("ХозяйствующийСубъект") Тогда
			Объект.ХозяйствующийСубъект = Параметры.ЗначенияЗаполнения.ХозяйствующийСубъект;
			УстановитьНаименование = Истина;
		КонецЕсли;
		Если Параметры.ЗначенияЗаполнения.Свойство("Предприятия") Тогда
			Объект.Предприятия.Очистить();
			Строка = Объект.Предприятия.Добавить();
			Для Каждого Предприятие Из Параметры.ЗначенияЗаполнения.Предприятия Цикл
				Строка.Предприятие = Предприятие;
			КонецЦикла;
			УстановитьНаименование = Истина;
		КонецЕсли;
		
		ПриСозданииЧтенииНаСервере();
		
		Если УстановитьНаименование Тогда
			УстановитьНаименование(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущийХС = Объект.ХозяйствующийСубъект;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание",    Расписание);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Использование", РегламентноеЗаданиеИспользуется);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйствующийСубъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("НастроеноПодключение", Истина);
		
	ОткрытьФорму("Справочник.ХозяйствующиеСубъектыВЕТИС.ФормаСписка",
		ПараметрыОткрытия,
		Элемент,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйствующийСубъектПриИзменении(Элемент)
	
	Если Объект.Предприятия.Количество() > 0
		И Объект.ХозяйствующийСубъект <> ТекущийХС Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросПриИзмененииХозяйствующегоСубъекта", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'При изменении хозяйствующего субъекта предприятия будут очищены. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	ИначеЕсли Объект.ХозяйствующийСубъект <> ТекущийХС Тогда
		ПриИзмененииХозяйствующегоСубъекта();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ХозяйствующийСубъект) Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("ТекущаяНастройкаОбмена", Объект.Ссылка);
		ПараметрыОткрытияФормы.Вставить("ХозяйствующийСубъект",   Объект.ХозяйствующийСубъект);
		ПараметрыОткрытияФормы.Вставить("ВыбранныеПредприятия",   Новый Массив);
		Для Каждого Строка Из Объект.Предприятия Цикл
			ПараметрыОткрытияФормы.ВыбранныеПредприятия.Добавить(Строка.Предприятие);
		КонецЦикла;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораОрганизацийВЕТИС", ЭтотОбъект);
		
		ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийВЕТИС.Форма.ФормаВыбораПредприятий",
			ПараметрыОткрытияФормы,
			ЭтотОбъект,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ДиалогРасписания.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ПолучитьРасписаниеРегламентногоЗадания();
	УстановитьПредприятияСтрокой(ЭтотОбъект);
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьРасписаниеРегламентногоЗадания()
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Расписание.ВремяНачала = '00010101220000';
		Расписание.ПериодПовтораДней = 1;
		
	Иначе
		
		УстановитьПривилегированныйРежим(Истина);
		Задание = РегламентныеЗаданияСервер.Задание(Объект.РегламентноеЗадание);
		Если Задание <> Неопределено Тогда
			Расписание = Задание.Расписание;
			РегламентноеЗаданиеИспользуется = Задание.Использование;
		КонецЕсли;
		
	КонецЕсли;
	
	РасписаниеСтрокой = Строка(Расписание);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(НовоеРасписание, ДополнительныеПараметры) Экспорт
	
	Если НовоеРасписание <> Неопределено Тогда
		Расписание = НовоеРасписание;
		РасписаниеСтрокой = Строка(Расписание);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредприятияСтрокой(Форма)
	
	КоличествоПредприятий = Форма.Объект.Предприятия.Количество();
	Если КоличествоПредприятий = 0 Тогда
		Форма.ПредприятияСтрокой = ПоВсемПредприятиямПредставление();
	Иначе
		ПредприятиеПредставление = ПредприятиеПредставление(Форма.Объект.Предприятия[0].Предприятие);
		Если КоличествоПредприятий = 1 Тогда
			Форма.ПредприятияСтрокой = ПредприятиеПредставление;
		Иначе
			Если СтрДлина(ПредприятиеПредставление) > 30 Тогда
				ПредприятиеПредставление = СтрШаблон("%1...", Лев(ПредприятиеПредставление, 25));
			КонецЕсли;
			Форма.ПредприятияСтрокой = СтрШаблон(НСтр("ru = '%1 ( + еще %2 )'"),
				ПредприятиеПредставление,
				КоличествоПредприятий - 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредприятиеПредставление(Предприятие)
	
	Если ЗначениеЗаполнено(Предприятие) Тогда
		Возврат Строка(Предприятие);
	Иначе
		Возврат НСтр("ru = '<Без предприятия>'");
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПоВсемПредприятиямПредставление()
	
	Возврат НСтр("ru = 'по всем предприятиям, не имеющим индивидуальной настройки'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНаименование(Форма)
	
	Если ЗначениеЗаполнено(Форма.Объект.ХозяйствующийСубъект) Тогда
		ХозяйствующийСубъектПредставление = Строка(Форма.Объект.ХозяйствующийСубъект);
		Если СтрДлина(ХозяйствующийСубъектПредставление) > 30 Тогда
			ХозяйствующийСубъектПредставление = СтрШаблон("%1...", Лев(ХозяйствующийСубъектПредставление, 25));
		КонецЕсли;
		Форма.Объект.Наименование = СтрШаблон(НСтр("ru = 'Обмен с ВЕТИС: %1, %2'"),
			ХозяйствующийСубъектПредставление,
			Форма.ПредприятияСтрокой);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросПриИзмененииХозяйствующегоСубъекта(ОтветНаВопрос, ДополнительныеПараметры) Экспорт

	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПриИзмененииХозяйствующегоСубъекта();
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Объект.ХозяйствующийСубъект = ТекущийХС;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииХозяйствующегоСубъекта()
	
	Если Объект.Предприятия.Количество() > 0 Тогда
		Объект.Предприятия.Очистить();
		УстановитьПредприятияСтрокой(ЭтотОбъект);
		УстановитьНаименование(ЭтотОбъект);
	Иначе
		УстановитьНаименование(ЭтотОбъект);
	КонецЕсли;
	
	ТекущийХС = Объект.ХозяйствующийСубъект;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОрганизацийВЕТИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.Предприятия.Очистить();
		Для Каждого Предприятие Из Результат Цикл
			Строка = Объект.Предприятия.Добавить();
			Строка.Предприятие = Предприятие;
		КонецЦикла;
		УстановитьПредприятияСтрокой(ЭтотОбъект);
		УстановитьНаименование(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
