#Область ПрограммныйИнтерфейс

// Начинает фоновое выполнение загрузки операций.
//
// Параметры:
//  ВыводитьОкноОжидания - Булево - признак необходисти интерфейсно выводить состояние загрузки.
//
Процедура НачатьЗагрузкуОпераций(ВыводитьОкноОжидания = Ложь) Экспорт
	
	ПараметрыЗагрузки = НовыйПараметрыЗагрузки();
	ПараметрыЗагрузки.ПоказыватьОповещениеПользователя = ВыводитьОкноОжидания;
	
	ДлительнаяОперация = ОнлайнОплатыУНФВызовСервера.НачатьЗагрузкуОпераций(ПараметрыЗагрузки);
	
	ОповещениеПослеЗагрузки = Новый ОписаниеОповещения("ЗагрузитьОперацииЗавершение", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Загрузка операций по ЮKassa'");
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеПослеЗагрузки, ПараметрыОжидания);
	
КонецПроцедуры

// Обработчик оповещения завершения загрузки операций.
//
// Параметры:
// 	Результат - Структура - Результат выполнения фонового задания.
// 	ДопПараметры - Структура - Дополнительные параметры.
//
Процедура ЗагрузитьОперацииЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Сообщения") Тогда 
		Для Каждого Сообщение Из Результат.Сообщения Цикл 
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		Если Не ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
			Возврат;
		КонецЕсли;
		
		СчетчикЗагруженныхДокументов = 0;
		СчетчикНезагруженныхДокументов = 0;
		ПоказыватьОповещениеПользователя = Истина;
		
		РезультатЗагрузки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатЗагрузки <> Неопределено Тогда
			РезультатЗагрузкиОпераций = РезультатЗагрузки.РезультатЗагрузкиОпераций;
			Для каждого ЭлементРезультата Из РезультатЗагрузкиОпераций Цикл
				СчетчикЗагруженныхДокументов = СчетчикЗагруженныхДокументов + ЭлементРезультата.Значение.КоличествоЗагруженныхОпераций;
				СчетчикНезагруженныхДокументов = СчетчикНезагруженныхДокументов + ЭлементРезультата.Значение.КоличествоНезагруженныхОпераций;
			КонецЦикла;
			ПоказыватьОповещениеПользователя = РезультатЗагрузки.ПоказыватьОповещениеПользователя;
		КонецЕсли;
		
		Если ПоказыватьОповещениеПользователя ИЛИ СчетчикЗагруженныхДокументов > 0 Тогда
			
			ТекстСообщения = ?(СчетчикЗагруженныхДокументов, НСтр("ru = 'Загружено из ЮKassa: %1'")
			, НСтр("ru = 'Новых операций по ЮKassa нет'"));
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения, СчетчикЗагруженныхДокументов);
			
			ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка завершена'"),
				"e1cib/list/Документ.ОперацияПоПлатежнымКартам",
				ТекстСообщения);
				
			Если СчетчикЗагруженныхДокументов Тогда
				Оповестить("ОнлайнОплата_ЗагруженыДокументы", СчетчикЗагруженныхДокументов);
			КонецЕсли;
				
		КонецЕсли;
		
		Если СчетчикЗагруженныхДокументов Тогда 
			ОповеститьОбИзменении(Тип("ДокументСсылка.ОперацияПоПлатежнымКартам"));
		КонецЕсли;
		
		Если ПоказыватьОповещениеПользователя И СчетчикНезагруженныхДокументов > 0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не загружено операций по ЮKassa: %1. Подробности в журнале регистрации.'"),
				СчетчикНезагруженныхДокументов));
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		ПоказатьПредупреждение(,Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует пустую структуру параметров загрузки операций.
// См. НачатьЗагрузкуОпераций()
//
Функция НовыйПараметрыЗагрузки() Экспорт
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Период", Неопределено);
	ПараметрыЗагрузки.Вставить("Организация", Неопределено);
	ПараметрыЗагрузки.Вставить("СДоговором", Неопределено);
	ПараметрыЗагрузки.Вставить("ПоказыватьОповещениеПользователя", Истина);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

// Обработчик оповещения о загрузке операций в формах списков.
//
// Параметры:
// 	Список - ТаблицаФормы - Список, который требуется обновить после загрузки операций.
// 	ИмяСобытия - Строка - Идентификатор события
// 	Параметр - Произвольный - Параметр события
// 	Источник - Произвольный - Источник события
//
Процедура ОбработкаОповещения_ФормаСписка(Список, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ОнлайнОплата_ЗагруженыДокументы" Тогда
		Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
