
#Область ПрограммныйИнтерфейс

// Процедура - Объект не найден
//
// Параметры:
//  Штрихкод - Строка - Штрихкод
//  ИскатьПоВсемПоддерживаемымОбъектам - Булево - Искать по всем объектам.
//
Процедура ОбъектНеНайден(Штрихкод, ИскатьПоВсемПоддерживаемымОбъектам = Истина) Экспорт

	ВывестиСообщениеОбъектНеНайден = Истина;

	Если ИскатьПоВсемПоддерживаемымОбъектам Тогда
		Состояние(НСтр("ru = 'Выполняется поиск документа по штрихкоду во всех документах информационной базы..'"));
		ВсеПоддерживаемыеМенеджеры = ШтрихкодированиеПечатныхФормКлиентСервер.ВсеПоддерживаемыеМенеджеры();
		МассивСсылок = ШтрихкодированиеПечатныхФормВызовСервера.СсылкаПоШтрихкодуТабличногоДокумента(Штрихкод,
			ВсеПоддерживаемыеМенеджеры);
		Если МассивСсылок.Количество() > 0 Тогда
			ВывестиСообщениеОбъектНеНайден = Ложь;
			ПоказатьЗначение( , МассивСсылок[0]);
		КонецЕсли;
	КонецЕсли;

	Если ВывестиСообщениеОбъектНеНайден Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Объект со штрихкодом %1 не найден'"),
			Штрихкод));
	КонецЕсли;

КонецПроцедуры

// Функция - Получить ссылку по штрихкоду табличного документа
//
// Параметры:
//  Штрихкод - Строка - Штрихкод
//  Менеджеры - Массив - Менеджеры документов.
// 
// Возвращаемое значение:
//  Массив - Массив ссылок на найденные документы.
//
Функция ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры = Неопределено) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется поиск документа по штрихкоду...'"));
	Возврат ШтрихкодированиеПечатныхФормВызовСервера.СсылкаПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции


// Строка похожа на штрихкод печатной формы
// 
// Параметры:
// 	СтрокаПоиска - Строка - .
// Возвращаемое значение:
// 	Булево - строка похожа на штрихкод печатной формы
Функция СтрокаПохожаНаШтрихкодПечатнойФормы(СтрокаПоиска) Экспорт
	
	Если СтрДлина(СтрокаПоиска) < 29 Тогда
		Возврат Ложь;
	КонецЕсли;

	Если СтрДлина(СтрокаПоиска) > 39 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоиска);
	
КонецФункции

#КонецОбласти
