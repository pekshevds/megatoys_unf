#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Массив статусов, в которых проведенный документ требует резервирования исходной партии.
// 
// Параметры:
//  ЕстьВыделеннаяПартия - Булево - Есть выделенная партия
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СтатусыОбработкиОформлениеСДИЗЗЕРНО -- Требует резервирования партии
Функция ТребуетРезервированияПартии(ЕстьВыделеннаяПартия) Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Черновик);
	Результат.Добавить(ОформлениеСДИЗКПередаче);
	Результат.Добавить(ОформлениеСДИЗОбрабатывается);
	Результат.Добавить(ОформлениеСДИЗОшибкаПередачи);
	Результат.Добавить(ФормированиеПартииКПередаче);
	Результат.Добавить(ФормированиеПартииОбрабатывается);
	Результат.Добавить(ФормированиеПартииОшибкаПередачи);
	Результат.Добавить(ПартииСформированы);
	Если ЕстьВыделеннаяПартия Тогда
		Результат.Добавить(ОформлениеСДИЗАннулировано);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Массив статусов, в которых проведенный документ требует списания исходной партии.
// 
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.СтатусыОбработкиОформлениеСДИЗЗЕРНО - Требует списания партии
Функция ТребуетСписанияПартии() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(СДИЗОформлен);
	Результат.Добавить(АннулированиеОформленияСДИЗКПередаче);
	Результат.Добавить(АннулированиеОформленияСДИЗОбрабатывается);
	Результат.Добавить(АннулированиеОформленияСДИЗОшибкаПередачи);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли