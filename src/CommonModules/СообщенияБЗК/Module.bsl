#Область СлужебныйПрограммныйИнтерфейс

// АПК:299-выкл Использование методов служебного API не контролируется
// АПК:558-выкл Кандидаты в публичный программный интерфейс.
// АПК:559-выкл Кандидаты в публичный программный интерфейс.
// АПК:581-выкл Кандидаты в публичный программный интерфейс.

#Область СозданиеСообщенийПользователю

// Сообщает об ошибке заполнения в реквизите объекта и включает флажок Отказ.
//
// Параметры:
//   Отказ        - Булево        - Флажок отказа, который включается в данной процедуре.
//   Объект       - ЛюбаяСсылка,
//                  ЛюбойОбъект   - Объект, в котором обнаружена ошибка.
//   Текст        - Строка        - Текст ошибки.
//   ИмяРеквизита - Строка        - Имя реквизита, в котором обнаружена ошибка.
//
Процедура СообщитьОбОшибкеВОбъекте(Отказ, Объект, Текст, ИмяРеквизита = "") Экспорт
	Отказ = Истина;
	СообщитьОПроблеме(Текст, Объект, ИмяРеквизита);
КонецПроцедуры

// Сообщает об ошибке заполнения в реквизите объекта и включает флажок Отказ.
//
// Параметры:
//   Отказ        - Булево                 - Флажок отказа, который включается в данной процедуре.
//   Объект       - ЛюбаяСсылка,
//                  ЛюбойОбъект            - Объект, в котором обнаружена ошибка.
//   ИмяТаблицы   - Строка                 - Имя табличной части.
//   Строка       - Строка табличной части - Строка табличной части.
//   ИмяРеквизита - Строка                 - Имя реквизита строки табличной части.
//   Текст        - Строка                 - Текст ошибки. Если не указан, то будет сформирован стандартный текст ошибки.
//
Процедура СообщитьОбОшибкеВСтрокеТаблицы(Отказ, Объект, ИмяТаблицы, Строка, ИмяРеквизита, Текст) Экспорт
	Отказ = Истина;
	ПутьКРеквизиту = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТаблицы, Строка.НомерСтроки, ИмяРеквизита);
	СообщитьОПроблеме(Текст, Объект, ПутьКРеквизиту);
КонецПроцедуры

// Выводит сообщение предупреждающее о проблеме связанной с указанным полем объекта.
//
// Параметры:
//   Текст  - Строка                   - Текст сообщения.
//   Объект - ЛюбаяСсылка, ЛюбойОбъект - Объект, в котором обнаружена проблема.
//   Поле   - Строка                   - Полное имя реквизита, в котором обнаружена проблема.
//
Процедура СообщитьОПроблеме(Текст, Объект = Неопределено, Поле = "") Экспорт
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Поле = Поле;
	
	Если Объект <> Неопределено Тогда
		ТипДанныхXML = XMLТипЗнч(Объект);
		Если СериализацияБЗК.ЭтоТипОбъекта(ТипДанныхXML) Тогда
			Сообщение.УстановитьДанные(Объект);
		ИначеЕсли СериализацияБЗК.ЭтоТипСсылки(ТипДанныхXML) Тогда
			Сообщение.КлючДанных = Объект;
		КонецЕсли;
	КонецЕсли;
	
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти

#Область РаботаСоСпискомСообщенийПользователю

// Возвращает количество сообщений, которые еще не были выведены пользователю.
//
// Возвращаемое значение:
//   Число
//
Функция КоличествоСообщенийПользователю() Экспорт
	Возврат ПолучитьСообщенияПользователю(Ложь).Количество();
КонецФункции

// Сокращает число сообщений до указанного количества. Оставляет первые N сообщений, удаляя сообщения с конца стека.
//
// Параметры:
//   Количество - Число - Количество сообщений которое должно остаться чтобы быть выведено пользователю.
//       См. СообщенияБЗК.КоличествоСообщенийПользователю().
//
Процедура СократитьЧислоСообщений(Количество, ТекстыСообщений = Неопределено) Экспорт
	Если КоличествоСообщенийПользователю() <= Количество Тогда
		Возврат;
	КонецЕсли;
	Сообщения = ПолучитьСообщенияПользователю(Истина);
	Для Индекс = 0 По Количество - 1 Цикл
		Сообщения[Индекс].Сообщить();
	КонецЦикла;
	Если ТекстыСообщений <> Неопределено Тогда
		Для Индекс = Количество По Сообщения.ВГраница() Цикл
			ТекстыСообщений.Добавить(Сообщения[Индекс].Текст);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

// АПК:581-вкл
// АПК:559-вкл
// АПК:558-вкл
// АПК:299-вкл

#КонецОбласти
