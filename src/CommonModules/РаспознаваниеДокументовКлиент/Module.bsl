#Область ПрограммныйИнтерфейс

// Показать добавление файлов.
// 
// Параметры:
//  УникальныйИдентификатор - Строка - Уникальный идентификатор
//  ОповещениеЗавершения - Неопределено - Оповещение завершения
//  ФайлыДокумента - Неопределено - Файлы документа
//
Процедура ПоказатьДобавлениеФайлов(УникальныйИдентификатор, ОповещениеЗавершения = Неопределено, ФайлыДокумента = Неопределено) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	
	Если ФайлыДокумента <> Неопределено Тогда
		ПараметрыОткрытия.Вставить("ФайлыДокумента", ФайлыДокумента);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.РаспознаваниеДокументов.Форма.ОтправитьФайлы", ПараметрыОткрытия, , , , , ОповещениеЗавершения);
	
КонецПроцедуры

// Показать авторизацию.
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - Оповещение о завершении
//  ВладелецФормы - Форма, Неопределено - Владелец формы
//
Процедура ПоказатьАвторизацию(ОповещениеОЗавершении = Неопределено, ВладелецФормы = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ТипАвторизации", "ПоЛогинуПаролю");
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Контекст.Вставить("ВладелецФормы", ВладелецФормы);
	
	Обработчик = Новый ОписаниеОповещения("ПослеАвторизации", РаспознаваниеДокументовСлужебныйКлиент, Контекст);
	ОткрытьФорму("Обработка.РаспознаваниеДокументов.Форма.АвторизациюПоЛогинуПаролю", , ВладелецФормы, , , , Обработчик);
	
КонецПроцедуры

// Показать авторизацию ИТС.
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - Оповещение о завершении
//  ВладелецФормы - Форма, Неопределено - Владелец формы
//  ПроверятьДанныеАутентификацииИТС - Булево, Неопределено - Проверять данные аутентификации ИТС
Процедура ПоказатьАвторизациюИТС(ОповещениеОЗавершении = Неопределено, ВладелецФормы = Неопределено, ПроверятьДанныеАутентификацииИТС = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ТипАвторизации", "ПоТикетуИТС");
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Контекст.Вставить("ВладелецФормы", ВладелецФормы);
	
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		
		// Если фреш - параметры ИТС хранятся в менеджере сервиса
		// всегда сразу переходим к циклу авторизации тикета
		
		РаспознаваниеДокументовСлужебныйКлиент.ПослеАвторизации("РазделениеВключено", Контекст);
		
	Иначе
		
		// Если коробка - то параметры ИТС хранятся в БИП
		// При этом заранее не возможно знать сохраненные данные в базе актуальны или устарели
		// Например, если пользователь портала сменил пароль и не обновил его в базе
		
		Если РаспознаваниеДокументовСлужебныйВызовСервера.КорректныДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
			
			// Если параметры ИТС корректны - сразу переходим к циклу авторизации по тикету
			// Если попытка получения тикета не удалась из-за ошибки пароля - предложим ввести логин и пароль.
			
			РаспознаваниеДокументовСлужебныйКлиент.ПослеАвторизации("АвторизацияКорректна", Контекст);
			
		Иначе
			
			// Если не заполнены - просим заполнить и авторизоваться, а после переходим к циклу с тикетом
			// После авторизации гарантированно данные авторизации заполнены и верны, потому перепроверять из не требуется.
			
			Обработчик = Новый ОписаниеОповещения("ПослеАвторизации", РаспознаваниеДокументовСлужебныйКлиент, Контекст);
			ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Обработчик, ВладелецФормы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Показать ввод промокода.
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - Оповещение о завершении
//  ВладелецФормы - Форма, Неопределено - Владелец формы
Процедура ПоказатьВводПромокода(ОповещениеОЗавершении = Неопределено, ВладелецФормы = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Контекст.Вставить("ВладелецФормы", ВладелецФормы);
	
	Обработчик = Новый ОписаниеОповещения("ПослеВводаПромокода", РаспознаваниеДокументовСлужебныйКлиент, Контекст);
	ОткрытьФорму("Обработка.РаспознаваниеДокументов.Форма.ФормаПромокода", , ВладелецФормы, , , , Обработчик);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеДобавленияФайлов(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.РаспознанныйДокумент.ФормаСписка", , ,
		"Документ.РаспознанныйДокумент.Форма.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти
