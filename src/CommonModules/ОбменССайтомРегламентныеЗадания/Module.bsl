#Область ПрограммныйИнтерфейс

// Создает новое задание очереди заданий.
//
// Параметры
//  КодУзла - Строка - Код узла плана обмена
//  НаименованиеУзла - Строка - Наименование узла плана обмена
//  Расписание - РасписаниеРегламентногоЗадания - Расписание.
//
// Возвращаемое значение: УникальныйИдентификатор.
//
Функция СоздатьНовоеЗадание(КодУзла, НаименованиеУзла, Расписание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = Новый Массив;
	Параметры.Добавить(КодУзла);
	
	ПараметрыЗадания = Новый Структура();
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("ИмяМетода" ,Метаданные.РегламентныеЗадания.ОбменССайтом.ИмяМетода);
	ПараметрыЗадания.Вставить("Параметры" ,Параметры);
	ПараметрыЗадания.Вставить("Расписание",Расписание);
	ПараметрыЗадания.Вставить("Метаданные",Метаданные.РегламентныеЗадания.ОбменССайтом);
	
	Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	ИдентификаторРегламентногоЗадания = РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
	
	Возврат ИдентификаторРегламентногоЗадания;
	
КонецФункции

// Возвращает идентификатор задания очереди (для сохранения в данных информационной базы).
//
// Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
// Возвращаемое значение: УникальныйИдентификатор.
//
Функция ПолучитьИдентификаторЗадания(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
	
КонецФункции

// Устанавливает параметры регламентного задания или задания очереди заданий.
//
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных,
//  Использование - булево, флаг использования регламентного задания,
//  КодУзла - Строка - Код узла плана обмена
//  НаименованиеУзла - Строка - Наименование узла плана обмена
//  Расписание - РасписаниеРегламентногоЗадания.
//
Процедура УстановитьПараметрыЗадания(Задание, Использование, КодУзла, НаименованиеУзла, Расписание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = Новый Массив;
	Параметры.Добавить(КодУзла);
	
	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		
		Задание.Использование = Истина;
		Задание.Ключ = Строка(Новый УникальныйИдентификатор);
		Задание.Наименование = НаименованиеУзла;
		Задание.Параметры = Параметры;
		Задание.Расписание = Расписание;
		Задание.Записать();
		
	Иначе
		
		Если Задание = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания = Новый Структура();
		ПараметрыЗадания.Вставить("Использование", Использование);
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ОбменССайтом.ИмяМетода);
		ПараметрыЗадания.Вставить("Параметры", Параметры);
		ПараметрыЗадания.Вставить("Ключ", Метаданные.РегламентныеЗадания.ОбменССайтом.Ключ);
		ПараметрыЗадания.Вставить("Расписание", Расписание);
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания); 
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает параметры задания очереди заданий.
//
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
// Возвращаемое значение: Структура, описания ключей - см. описание возвращаемого значения
//  для функции ОчередьЗаданий.ПолучитьЗадания().
//
Функция ПолучитьПараметрыЗадания(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗаданияСервер.ПараметрРегламентногоЗадания(Задание, "Идентификатор", "00000000-0000-0000-0000-000000000000");
	
КонецФункции

// Выполняет поиск задания очереди по идентификатору (предположительно, сохраненному в данных
// информационной базы).
//
// Параметры: Идентификатор - УникальныйИдентификатор.
//
// Возвращаемое значение: РегламентноеЗадание.
//
Функция НайтиЗадание(Знач Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		Задание = РегламентныеЗаданияСервер.Задание(Идентификатор);
		Возврат Задание;
		
	Иначе
		
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Возврат Задание;
		
	КонецЕсли;
	
КонецФункции

// Удаляет регламентное задание или задание очереди заданий.
//
// Параметры:
//   Задание - РегламентноеЗадание, СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
Процедура УдалитьЗадание(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентныеЗаданияСервер.УдалитьЗадание(Задание);
	
КонецПроцедуры

#КонецОбласти
