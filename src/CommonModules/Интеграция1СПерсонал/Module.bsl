
#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.РегламентныеЗадания

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменСПриложением1СПерсонал;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользуетсяПриложение1СПерсонал;
	Настройка.ДоступноВАвтономномРабочемМесте = Ложь;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.РегламентныеЗадания

// СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов.
//
Процедура ПриПолученииСпискаШаблоновОчередиЗаданий(Шаблоны) Экспорт
	
	Шаблоны.Добавить(Метаданные.РегламентныеЗадания.ОбменСПриложением1СПерсонал.Имя);
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОбменСПриложением1СПерсонал.ИмяМетода);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий

#Область ОпределениеДоступностиДанных

Функция ДоступноИзменениеИспользованияИнтеграции() Экспорт

	Возврат ПравоДоступа("Изменение", Метаданные.Константы.ИспользоватьИнтеграциюСПриложением1СПерсонал);

КонецФункции


#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Обмен

// Обработчик регламентного задания ОбменСПриложением1СПерсонал
//
Процедура ОбменСПриложением1СПерсонал() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбменСПриложением1СПерсонал);
	Если ИнтеграцияУправлениеПерсоналомОбмен.ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗаданияОбмен()) Тогда
		Возврат;
	КонецЕсли;
	
	Приложение = Перечисления.ПриложенияДляИнтеграции.УправлениеПерсоналом;
	БылиОшибки = ИнтеграцияУправлениеПерсоналомОбмен.ВыполнитьОбмен(Приложение, Ложь);
	
	Если БылиОшибки Тогда
		ВызватьИсключение НСтр("ru = 'Обмен с приложением 1С:Персонал завершен с ошибками.'");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик фонового задания обмена с приложением.
Процедура ВыполнитьОбменФоновоеЗадание(Параметры, АдресХранилища) Экспорт

	Результат = Новый Структура("БылиОшибки,ПодготовитьДанныеДляТехПоддержки,ДатаНачала,ДатаОкончания", Ложь);
	Результат.ПодготовитьДанныеДляТехПоддержки = Параметры.ПодготовитьДанныеДляТехПоддержки;
	Результат.ДатаНачала = ТекущаяДатаСеанса();
	
	// Привилегированный режим устанавливается для публикации всех данных,
	// не зависимо от ограничений доступа для пользователя, который инициировал обмен.
	УстановитьПривилегированныйРежим(Истина);
	
	Приложение = Перечисления.ПриложенияДляИнтеграции.УправлениеПерсоналом;
	Результат.БылиОшибки = ИнтеграцияУправлениеПерсоналомОбмен.ВыполнитьОбмен(Приложение, Результат.ПодготовитьДанныеДляТехПоддержки);
	
	Результат.ДатаОкончания = ТекущаяДатаСеанса();
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

// Выполняет проверку наличия активных фоновых заданий:
// - регламентное задание ОбменСПриложением1СПерсонал
// - обмен, запущенный пользователем интерактивно
//
Функция ЕстьАктивныеФоновыеЗаданияОбмен() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомОбмен.ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗаданияОбмен())
		Или ИнтеграцияУправлениеПерсоналомОбмен.ЕстьАктивныеФоновыеЗадания(КлючРегламентногоЗаданияОбмен());
	
КонецФункции

Функция КлючФоновогоЗаданияОбмен() Экспорт

	Возврат "ФоновоеЗаданиеОбмен1СПерсонал";

КонецФункции

Функция КлючРегламентногоЗаданияОбмен() Экспорт

	Возврат Метаданные.РегламентныеЗадания.ОбменСПриложением1СПерсонал.Ключ;

КонецФункции

#КонецОбласти

#Область ПравилаВыгрузки

Процедура ЗаписатьОбъектыПриСохраненииПравилВыгрузки(ОбъектыДляРегистрации) Экспорт
	
	Приложение = Перечисления.ПриложенияДляИнтеграции.УправлениеПерсоналом;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПравилаВыгрузкиУправлениеПерсоналом");
		ЭлементБлокировки.УстановитьЗначение("Приложение", Приложение);
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БудущиеСобытияУправлениеПерсоналом");
		ЭлементБлокировки.УстановитьЗначение("Приложение", Приложение);
		Блокировка.Добавить("РегистрСведений.ВыгружаемыеОбъекты1СПерсонал");
		Блокировка.Добавить("РегистрСведений.ИзмененияДляОбмена1СПерсонал");
		Блокировка.Заблокировать(); 
		
		НаборЗаписей = РегистрыСведений.ПравилаВыгрузкиУправлениеПерсоналом.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Приложение.Установить(Приложение);
		НаборЗаписей.Загрузить(ОбъектыДляРегистрации.НовыеПравила);
		НаборЗаписей.Записать();
		
		НаборЗаписей = РегистрыСведений.ВыгружаемыеОбъекты1СПерсонал.СоздатьНаборЗаписей();
		Для каждого СтрокаТЗ Из ОбъектыДляРегистрации.ВыгружаемыеОбъекты Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),СтрокаТЗ);
		КонецЦикла;
		НаборЗаписей.Записать();
		
		НаборЗаписей = РегистрыСведений.ИзмененияДляОбмена1СПерсонал.СоздатьНаборЗаписей();
		Для каждого СтрокаТЗ Из ОбъектыДляРегистрации.ИзмененияДляОбмена Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),СтрокаТЗ);
		КонецЦикла;
		НаборЗаписей.Записать();
		
		Если ЗначениеЗаполнено(ОбъектыДляРегистрации.БудущиеСобытия) Тогда
			НаборЗаписей = РегистрыСведений.БудущиеСобытияУправлениеПерсоналом.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Приложение.Установить(Приложение);
			Для каждого СтрокаТЗ Из ОбъектыДляРегистрации.БудущиеСобытия Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),СтрокаТЗ);
			КонецЦикла;
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ШаблонОписания = НСтр("ru = 'Ошибка записи правил.
			|%1'");
		ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Комментарий = СтрШаблон(ШаблонОписания, ПодробноеПредставлениеОшибки);
		ИмяСобытия = ИнтеграцияУправлениеПерсоналом.ИменаСобытийЖР(Приложение).ПрочиеСобытия;
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, Комментарий);
		// Исключение обрабатывает вызывающий метод.
		ВызватьИсключение
	КонецПопытки;
	
	ИнтеграцияУправлениеПерсоналом.ПроверитьЗаполнениеОбъектов(Приложение);

КонецПроцедуры

// Формирует таблицы с данными для регистрации в регистрах, обслуживающих
// обмен с приложением. 
// Вызывается при обработке изменений кадровых событий.
//
// Параметры:
// 		ДанныеДляРегистрации - Структура
// 			* ФизическиеЛица - ТаблицаЗначений
// 					* ФизическоеЛицо
// 					* Выгружается - Булево
// 					* ОкончаниеВыгрузки - Дата
// 			* Сотрудники - ТаблицаЗначений
// 					* Сотрудник
// 					* УсловноВыгружается
// 					* Удалить - Булево
// 			* ПрочиеОбъекты - ТаблицаЗначений
// 					* Ссылка
// 					* ТипОбъекта
//
// Возвращаемое значение:
// 		Структура
// 			* ВыгружаемыеОбъекты  - ТаблицаЗначений
// 					* Выгружается - Булево
// 					* колонки соответсвующие структуре регистра ВыгружаемыеОбъекты1СПерсонал
// 			* ИзмененияДляОбмена  - ТаблицаЗначений
// 					* колонки соответсвующие структуре регистра ИзмененияДляОбмена1СПерсонал
//
Функция ОбъектыДляРегистрацииОбмена(ДанныеДляРегистрации) Экспорт
	
	ФизическиеЛица 	= ДанныеДляРегистрации.ФизическиеЛица;
	Сотрудники 		= ДанныеДляРегистрации.Сотрудники;
	ПрочиеОбъекты 	= ДанныеДляРегистрации.ПрочиеОбъекты;
	
	ВыгружаемыеОбъекты = НоваяТаблицаВыгружаемыеОбъекты();
	ИзмененияДляОбмена = НоваяТаблицаИзмененияДляОбмена();
	
	// Обработка Физических лиц.
	// Вычисляем ссылки, которые еще не зарегистрированы в ВыгружаемыеОбъекты1СПерсонал
	// и если Выгружается = Ложь, ссылки, которые зарегистрированы в ВыгружаемыеОбъекты1СПерсонал.
	// Вычиляем ссылки, не зарегистрированные в ИзмененияДляОбмена1СПерсонал.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц  = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВыгружаемыеФизическиеЛица", ФизическиеЛица);
	Запрос.УстановитьПараметр("ТипОбъекта", Перечисления.ТипыОбъектовИнтеграцияУпралениеПерсоналом.ФизическоеЛицо);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Таблица.Удалить КАК Удалить
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	&ВыгружаемыеФизическиеЛица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.ФизическоеЛицо КАК Ссылка,
	|	Таблица.Удалить КАК Удалить,
	|	ЛОЖЬ КАК УсловноВыгружается
	|ИЗ
	|	ВТФизическиеЛица КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
	|		ПО Таблица.ФизическоеЛицо = ВыгружаемыеОбъекты.Ссылка
	|ГДЕ
	|	НЕ Таблица.Удалить
	|	И ВыгружаемыеОбъекты.УсловноВыгружается ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.ФизическоеЛицо,
	|	Таблица.Удалить,
	|	ЛОЖЬ
	|ИЗ
	|	ВТФизическиеЛица КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
	|		ПО Таблица.ФизическоеЛицо = ВыгружаемыеОбъекты.Ссылка
	|ГДЕ
	|	Таблица.Удалить
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.ФизическоеЛицо КАК Ссылка,
	|	&ТипОбъекта КАК ТипОбъекта,
	|	ЛОЖЬ КАК ВыгружатьУдаление
	|ИЗ
	|	ВТФизическиеЛица КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДляОбмена1СПерсонал КАК Изменения
	|		ПО Таблица.ФизическоеЛицо = Изменения.Ссылка
	|			И (Изменения.ТипОбъекта = &ТипОбъекта)
	|ГДЕ
	|	НЕ Таблица.Удалить
	|	И Изменения.ВерсияДанных ЕСТЬ NULL";
	РезультатЗапроса = Запрос.ВыполнитьПакет(); 
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапроса[1].Выгрузить(), ВыгружаемыеОбъекты);
	ДополнитьТаблицуИзмененияДляОбмена(РезультатЗапроса[2].Выгрузить(), ИзмененияДляОбмена);
	
	// Обработка Сотрудников.
	// Вычисляем ссылки, которые еще не зарегистрированы в ВыгружаемыеОбъекты1СПерсонал.
	// Вычиляем ссылки, не зарегистрированные в ИзмененияДляОбмена1СПерсонал.
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("ТипОбъекта", Перечисления.ТипыОбъектовИнтеграцияУпралениеПерсоналом.Сотрудник);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Сотрудник КАК Ссылка,
	|	Таблица.УсловноВыгружается КАК УсловноВыгружается,
	|	Таблица.Удалить КАК Удалить
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&Сотрудники КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	Таблица.УсловноВыгружается КАК УсловноВыгружается
	|ИЗ
	|	ВТСотрудники КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
	|		ПО Таблица.Ссылка = ВыгружаемыеОбъекты.Ссылка
	|ГДЕ
	|	ВыгружаемыеОбъекты.УсловноВыгружается ЕСТЬ NULL
	|	И НЕ Таблица.Удалить
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	&ТипОбъекта КАК ТипОбъекта,
	|	Таблица.Удалить КАК ВыгружатьУдаление
	|ИЗ
	|	ВТСотрудники КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДляОбмена1СПерсонал КАК Изменения
	|		ПО Таблица.Ссылка = Изменения.Ссылка
	|			И (&ТипОбъекта = Изменения.ТипОбъекта)
	|ГДЕ
	|	Изменения.ВерсияДанных ЕСТЬ NULL";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапроса[1].Выгрузить(), ВыгружаемыеОбъекты);
	ДополнитьТаблицуИзмененияДляОбмена(РезультатЗапроса[2].Выгрузить(), ИзмененияДляОбмена);
	
	// Обработка прочих объектов.
	// Вычисляем ссылки, которые еще не зарегистрированы в ВыгружаемыеОбъекты1СПерсонал.
	// Вычиляем ссылки, не зарегистрированные в ИзмененияДляОбмена1СПерсонал.
	Запрос.УстановитьПараметр("ПрочиеОбъекты", ПрочиеОбъекты);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	Таблица.ТипОбъекта КАК ТипОбъекта
	|ПОМЕСТИТЬ ВТПрочиеОбъекты
	|ИЗ
	|	&ПрочиеОбъекты КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Ссылка КАК Ссылка,
	|	ЛОЖЬ КАК УсловноВыгружается
	|ИЗ
	|	ВТПрочиеОбъекты КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
	|		ПО Таблица.Ссылка = ВыгружаемыеОбъекты.Ссылка
	|ГДЕ
	|	ВыгружаемыеОбъекты.УсловноВыгружается ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	Таблица.ТипОбъекта КАК ТипОбъекта,
	|	ЛОЖЬ КАК ВыгружатьУдаление
	|ИЗ
	|	ВТПрочиеОбъекты КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияДляОбмена1СПерсонал КАК Изменения
	|		ПО Таблица.Ссылка = Изменения.Ссылка
	|			И Таблица.ТипОбъекта = Изменения.ТипОбъекта
	|ГДЕ
	|	Изменения.ВерсияДанных ЕСТЬ NULL";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапроса[1].Выгрузить(), ВыгружаемыеОбъекты);
	ДополнитьТаблицуИзмененияДляОбмена(РезультатЗапроса[2].Выгрузить(), ИзмененияДляОбмена);
	
	ОбъектыДляРегистрации = Новый Структура;
	ОбъектыДляРегистрации.Вставить("ВыгружаемыеОбъекты", ВыгружаемыеОбъекты);
	ОбъектыДляРегистрации.Вставить("ИзмененияДляОбмена", ИзмененияДляОбмена);
	
	Возврат ОбъектыДляРегистрации;

КонецФункции

Функция ОбъектВыгружается(Ссылка) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыгружаемыеОбъекты.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
	|ГДЕ
	|	ВыгружаемыеОбъекты.Ссылка = &Ссылка";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Область Версионирование

Процедура ЗаполнитьВерсииDTO(Версии) Экспорт

	Версии.Добавить("2.0");

КонецПроцедуры

Процедура ЗаполнитьВерсииAPI(Версии) Экспорт

	Версии.Добавить("2.0");

КонецПроцедуры

Процедура УстановитьНовуюВерсиюDTO(ТекущаяВерсияDTO, НоваяВерсияDTO) Экспорт

	РегистрыСведений.НастройкиПодключения1СПерсонал.УстановитьВерсиюDTO(НоваяВерсияDTO);
	ВыполнитьДействияПриПереходеНаВерсиюDTO(ТекущаяВерсияDTO, НоваяВерсияDTO);

КонецПроцедуры

Процедура УстановитьНовуюВерсиюAPI(ТекущаяВерсияAPI, НоваяВерсияAPI) Экспорт

	РегистрыСведений.НастройкиПодключения1СПерсонал.УстановитьВерсиюAPI(НоваяВерсияAPI);
	ВыполнитьДействияПриПереходеНаВерсиюAPI(ТекущаяВерсияAPI, НоваяВерсияAPI);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСменыВерсииDTOИлиAPI

Процедура ВыполнитьДействияПриПереходеНаВерсиюDTO(ТекущаяВерсияDTO, НоваяВерсияDTO)

	

КонецПроцедуры

Процедура ВыполнитьДействияПриПереходеНаВерсиюAPI(ТекущаяВерсияAPI, НоваяВерсияAPI)

	

КонецПроцедуры

#КонецОбласти

#Область ОтключениеПриложения

Процедура ОчиститьДанныеПриОтключенииПриложения() Экспорт
	
	Константы.ИспользуетсяПриложение1СПерсонал.Установить(Ложь);
	РегистрыСведений.НастройкиПодключения1СПерсонал.СоздатьНаборЗаписей().Записать();
	РегистрыСведений.ВыгружаемыеОбъекты1СПерсонал.СоздатьНаборЗаписей().Записать();
	РегистрыСведений.ИзмененияДляОбмена1СПерсонал.СоздатьНаборЗаписей().Записать();

КонецПроцедуры

#КонецОбласти

#Область ИзменениеНастроекПодключения

Процедура СохранитьНовыеНастройкиПодключения(АдресПриложения) Экспорт

	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиПодключения1СПерсонал");
	Блокировка.Заблокировать();
	
	Настройки = РегистрыСведений.НастройкиПодключения1СПерсонал.Настройки();
	Настройки.АдресПриложения 	= АдресПриложения;
	МенеджерЗаписи = РегистрыСведений.НастройкиПодключения1СПерсонал.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Настройки);
	МенеджерЗаписи.Записать();

КонецПроцедуры

#КонецОбласти

#Область КонструкторыОбъектов

Функция НоваяТаблицаВыгружаемыеОбъекты() Экспорт

	Таблица = ОбщегоНазначенияБЗК.ТаблицаЗначенийПоИмениРегистраСведений("ВыгружаемыеОбъекты1СПерсонал");
	Таблица.Колонки.Добавить("Удалить", Новый ОписаниеТипов("Булево"));
	
	Возврат Таблица;
	
КонецФункции

Функция НоваяТаблицаИзмененияДляОбмена() Экспорт

	Таблица = ОбщегоНазначенияБЗК.ТаблицаЗначенийПоИмениРегистраСведений("ИзмененияДляОбмена1СПерсонал");
	Таблица.Колонки.Добавить("Удалить", Новый ОписаниеТипов("Булево"));
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область Прочие

Процедура ЗаполнитьНастройкиПодключения(НастройкиПодключения) Экспорт
	
	Настройки = РегистрыСведений.НастройкиПодключения1СПерсонал.Настройки();
	НастройкиПодключения.АдресПриложения 	= СокрЛП(Настройки.АдресПриложения);
	НастройкиПодключения.ВерсияDTO 			= СокрЛП(Настройки.ВерсияDTO);
	НастройкиПодключения.ВерсияAPI 			= СокрЛП(Настройки.ВерсияAPI);

КонецПроцедуры

Процедура ДополнитьТаблицуИзмененияДляОбмена(ТаблицаИсточник, ИзмененияДляОбмена)
	
	Для Каждого СтрокаТЗ Из ТаблицаИсточник Цикл
		НоваяСтрока = ИзмененияДляОбмена.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
		НоваяСтрока.ВерсияДанных = Строка(Новый УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьБлокировкуРегистрацияОбъектовДляОбмена(Блокировка, ОбъектыДляРегистрации) Экспорт
	
	ВыгружаемыеОбъекты = Неопределено;
	ОбъектыДляРегистрации.Свойство("ВыгружаемыеОбъекты", ВыгружаемыеОбъекты);
	Если ЗначениеЗаполнено(ВыгружаемыеОбъекты) Тогда
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ВыгружаемыеОбъекты1СПерсонал");
		ЭлементБлокировки.ИсточникДанных = ВыгружаемыеОбъекты;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
	КонецЕсли;
	
	ИзмененияДляОбмена = Неопределено;
	ОбъектыДляРегистрации.Свойство("ИзмененияДляОбмена", ИзмененияДляОбмена);
	Если ЗначениеЗаполнено(ИзмененияДляОбмена) Тогда
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИзмененияДляОбмена1СПерсонал");
		ЭлементБлокировки.ИсточникДанных = ИзмененияДляОбмена;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТипОбъекта", "ТипОбъекта");
	КонецЕсли;

КонецПроцедуры

Процедура ЗаписатьОбъектыДляОбмена(ОбъектыДляРегистрации) Экспорт

	ВыгружаемыеОбъекты = Неопределено;
	ОбъектыДляРегистрации.Свойство("ВыгружаемыеОбъекты", ВыгружаемыеОбъекты);
	Если ЗначениеЗаполнено(ВыгружаемыеОбъекты) Тогда
		Для каждого СтрокаТЗ Из ВыгружаемыеОбъекты Цикл 
			МенеджерЗаписи = РегистрыСведений.ВыгружаемыеОбъекты1СПерсонал.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаТЗ);
			Если СтрокаТЗ.Удалить Тогда
				МенеджерЗаписи.Удалить();
			Иначе
				МенеджерЗаписи.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ИзмененияДляОбмена = Неопределено;
	ОбъектыДляРегистрации.Свойство("ИзмененияДляОбмена", ИзмененияДляОбмена);
	Если ЗначениеЗаполнено(ИзмененияДляОбмена) Тогда
		Для каждого СтрокаТЗ Из ИзмененияДляОбмена Цикл 
			МенеджерЗаписи = РегистрыСведений.ИзмененияДляОбмена1СПерсонал.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаТЗ);
			МенеджерЗаписи.Записать();
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти










