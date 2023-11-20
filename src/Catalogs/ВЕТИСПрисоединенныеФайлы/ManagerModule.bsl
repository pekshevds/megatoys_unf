#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Возвращает краткое описание последнего сообщения обмена указанного типа (Передано, ВОчереди, СОшибкой, Любое)
//   по документу. Если такого сообщения нет, возвращает Неопределено.
//
// Параметры:
//   ДокументСсылка         - ОпределяемыйТип.ДокументыИСМП - документ для получения описания
//   ТипПоследнегоСообщения - Строка                        - тип сообщения из фиксированного списка
// Возвращаемое значение:
//   Структура - реквизиты сообщения:
//   * ВладелецФайла - ОпределяемыйТип.ДокументыВЕТИС            - владелец файла
//   * Операция      - ПеречислениеСсылка.ВидыОперацийВЕТИС      - операция обмена
//   * ТипСообщения  - ПеречислениеСсылка.ТипыЗапросовИС         - тип сообщения (исходящий, входящий)
//   * Сообщение     - СправочникСсылка.ВЕТИСПрисоединенныеФайлы - ссылка на сообщение
//                   - Неопределено - сообщение не найдено
//
Функция ПоследнееСообщение(ДокументСсылка, ТипПоследнегоСообщения = "Передано") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЕТИСПрисоединенныеФайлы.Ссылка        КАК Ссылка,
	|	ВЕТИСПрисоединенныеФайлы.ТипСообщения  КАК ТипСообщения,
	|	ВЕТИСПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайла,
	|	ВЕТИСПрисоединенныеФайлы.ФорматОбмена  КАК ФорматОбмена,
	|	ВЕТИСПрисоединенныеФайлы.ДатаСоздания  КАК ДатаСоздания,
	|	ВЕТИСПрисоединенныеФайлы.Операция      КАК Операция,
	|	ВЫРАЗИТЬ(ВЕТИСПрисоединенныеФайлы.Описание КАК Строка(512)) КАК Описание,
	|	ОтветыНаПередачуДанных.Ссылка          КАК СообщениеОтвета,
	|	ОтветыНаПередачуДанных.ДатаСоздания    КАК ДатаСозданияОтвета
	|ПОМЕСТИТЬ втСообщенияПредварительно
	|ИЗ
	|	Справочник.ВЕТИСПрисоединенныеФайлы КАК ВЕТИСПрисоединенныеФайлы
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВЕТИСПрисоединенныеФайлы КАК ОтветыНаПередачуДанных
	|		ПО ВЕТИСПрисоединенныеФайлы.Ссылка = ОтветыНаПередачуДанных.СообщениеОснование
	|		И (ВЕТИСПрисоединенныеФайлы.Операция = ОтветыНаПередачуДанных.Операция)
	|		И (ОтветыНаПередачуДанных.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий))
	|ГДЕ
	|	ВЕТИСПрисоединенныеФайлы.Документ = &Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СообщенияПредварительно.Ссылка КАК Ссылка,
	|	МИНИМУМ(СообщенияПредварительно.ДатаСозданияОтвета) КАК ДатаПервогоОтвета,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СообщенияПредварительно.СообщениеОтвета) КАК КоличествоОтветов
	|ПОМЕСТИТЬ втСведенияОбОтветах
	|ИЗ
	|	втСообщенияПредварительно КАК СообщенияПредварительно
	|СГРУППИРОВАТЬ ПО
	|	СообщенияПредварительно.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СообщенияПредварительно.Ссылка          КАК Ссылка,
	|	СообщенияПредварительно.ТипСообщения    КАК ТипСообщения,
	|	СообщенияПредварительно.ВладелецФайла   КАК ВладелецФайла,
	|	СообщенияПредварительно.ФорматОбмена    КАК ФорматОбмена,
	|	СообщенияПредварительно.ДатаСоздания    КАК ДатаСоздания,
	|	СообщенияПредварительно.Операция        КАК Операция,
	|	СообщенияПредварительно.Описание        КАК Описание,
	|	СообщенияПредварительно.СообщениеОтвета КАК СообщениеОтвета,
	|	ВЫБОР
	|		КОГДА СведенияОбОтветах.ДатаПервогоОтвета ЕСТЬ NULL
	|			ТОГДА СообщенияПредварительно.ДатаСоздания
	|		КОГДА СведенияОбОтветах.ДатаПервогоОтвета = СообщенияПредварительно.ДатаСозданияОтвета
	|			ТОГДА СообщенияПредварительно.ДатаСоздания
	|		ИНАЧЕ СообщенияПредварительно.ДатаСозданияОтвета
	|	КОНЕЦ                                   КАК ДатаОтправки,
	|	ВЫБОР
	|		КОГДА СведенияОбОтветах.КоличествоОтветов ЕСТЬ NULL
	|			ТОГДА 0
	|		ИНАЧЕ СведенияОбОтветах.КоличествоОтветов
	|	КОНЕЦ                                   КАК КоличествоЗапросов
	|ПОМЕСТИТЬ втСообщения
	|ИЗ
	|	втСообщенияПредварительно КАК СообщенияПредварительно
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСведенияОбОтветах КАК СведенияОбОтветах
	|		ПО СообщенияПредварительно.Ссылка = СведенияОбОтветах.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сообщения.Ссылка             КАК Сообщение,
	|	Сообщения.ТипСообщения       КАК ТипСообщения,
	|	Сообщения.ВладелецФайла      КАК ХозяйствующийСубъект,
	|	Сообщения.ФорматОбмена       КАК ФорматОбмена,
	|	Сообщения.ДатаСоздания       КАК ДатаСоздания,
	|	Сообщения.Операция           КАК Операция,
	|	Сообщения.Описание           КАК Описание,
	|	Сообщения.ДатаОтправки       КАК ДатаОтправки,
	|	Сообщения.КоличествоЗапросов КАК КоличествоЗапросов
	|ИЗ
	|	втСообщения КАК Сообщения
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьСообщенийВЕТИС КАК ОчередьСообщенийВЕТИС
	|		ПО Сообщения.Ссылка = ОчередьСообщенийВЕТИС.Сообщение
	|ГДЕ
	|	&Условие
	|УПОРЯДОЧИТЬ ПО
	|	Сообщения.ДатаОтправки УБЫВ,
	|	ВЫБОР
	|		КОГДА Сообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ УБЫВ
	|");
	
	Запрос.УстановитьПараметр("Документ", ДокументСсылка);
	
	Если ТипПоследнегоСообщения = "Передано" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", "
			|ВЫБОР КОГДА Сообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
			|	И Сообщения.СообщениеОтвета ЕСТЬ NULL ТОГДА
			|	ЛОЖЬ
			|ИНАЧЕ
			|	ИСТИНА
			|КОНЕЦ
			|");
	ИначеЕсли ТипПоследнегоСообщения = "ВОчереди" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", "
			|ВЫБОР КОГДА ОчередьСообщенийВЕТИС.Сообщение ЕСТЬ NULL ТОГДА
			|	ЛОЖЬ
			|ИНАЧЕ
			|	ИСТИНА
			|КОНЕЦ
			|");
	ИначеЕсли ТипПоследнегоСообщения = "СОшибкой" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", "
			|ВЫБОР
			|	КОГДА Сообщения.Описание = """"
			|		ТОГДА ЛОЖЬ
			|	ИНАЧЕ ИСТИНА
			|КОНЕЦ
			|");
	ИначеЕсли ТипПоследнегоСообщения = "Любое" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", "ИСТИНА");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Сообщение");
	ВозвращаемоеЗначение.Вставить("ТипСообщения");
	ВозвращаемоеЗначение.Вставить("ХозяйствующийСубъект");
	ВозвращаемоеЗначение.Вставить("ФорматОбмена");
	ВозвращаемоеЗначение.Вставить("ДатаСоздания");
	ВозвращаемоеЗначение.Вставить("Операция");
	ВозвращаемоеЗначение.Вставить("Описание");
	ВозвращаемоеЗначение.Вставить("ДатаОтправки");
	ВозвращаемоеЗначение.Вставить("КоличествоЗапросов");
	
	ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, Выборка);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли