#Область СлужебныеПроцедурыИФункции

Функция ПубликуемаяСтруктураПредприятия() Экспорт

	Если ИнтеграцияУправлениеПерсоналом.ПубликоватьСтруктуруЮридическихЛиц() Тогда
		Возврат СтруктураПодразделенийОрганизации();
	Иначе
		Возврат СтруктураПредприятия();
	КонецЕсли;

КонецФункции

Функция СтруктураПодразделенийОрганизации()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПодразделенияОрганизаций.Ссылка КАК Подразделение
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	НЕ ПодразделенияОрганизаций.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПодразделенияОрганизаций.Ссылка ИЕРАРХИЯ";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция СтруктураПредприятия() 
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктураПредприятия.Ссылка КАК Подразделение,
	|	СтруктураПредприятия.Родитель КАК ПодразделениеРодитель
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	НЕ СтруктураПредприятия.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтруктураПредприятия.Ссылка ИЕРАРХИЯ";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();	
	
КонецФункции

Функция ТипСтруктураПредприятия() Экспорт
	Возврат Тип("СправочникСсылка.СтруктураПредприятия");	
КонецФункции

Функция СоздаватьПрогулНеявкаПроверкаУсловия() Экспорт
	Возврат Ложь;
КонецФункции	
	
Функция ДокументПредметЗаявкаСотрудникаОтсутствиеПоБолезни(БизнесПроцесс) Экспорт
	Возврат БизнесПроцесс.БольничныйЛист;	
КонецФункции

Функция СоответствиеЗаявкиИТипаЗаявки() Экспорт
	Возврат Новый Соответствие;	
КонецФункции

Функция СоответствиеОтсутствия() Экспорт
	Возврат Новый Соответствие;
КонецФункции

Функция ТипЗаявкаСотрудникаДобровольныеСтраховыеВзносы() Экспорт
	Возврат Тип("Неопределено");
КонецФункции

Функция ТипЗаявкаСотрудникаОтсутствие() Экспорт
	Возврат Тип("Неопределено");
КонецФункции

Функция ТипЗаявкаСотрудникаСправкаСМестаРаботы() Экспорт
	Возврат Тип("Неопределено");
КонецФункции

Функция ТипЗаявкаСотрудникаСправкаОстаткиОтпусков() Экспорт
	Возврат Тип("Неопределено");
КонецФункции

Функция ТаблицаФайловОтветаЗаявокСотрудника(ПубликуемыеЗаявки, ТипДанных) Экспорт

	ТаблицаФайловОтвета = Новый ТаблицаЗначений;
	ТаблицаФайловОтвета.Колонки.Добавить("Заявка");
	ТаблицаФайловОтвета.Колонки.Добавить("ФайлЗаявки");
		
	Возврат ТаблицаФайловОтвета;

КонецФункции

Функция ТипыЗаявокСогласовываемыеРуководителем() Экспорт
	Возврат Новый Массив;	
КонецФункции

Функция РольИсполнителяОтветственныйЗаУдержаниеДСВ() Экспорт
	Возврат Справочники.РолиИсполнителей.ПустаяСсылка();
КонецФункции

Функция МестаПозицийВСтруктуреПредприятия(Позиции) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Позиции", Позиции);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ШтатноеРасписание.Ссылка КАК Позиция,
	|	СтруктураПредприятия.Ссылка КАК Подразделение
	|ИЗ
	|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО ШтатноеРасписание.Подразделение = СтруктураПредприятия.Источник
	|ГДЕ
	|	ШтатноеРасписание.Ссылка В(&Позиции)";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция ДоступнаФункциональнаяОпцияЗаявкаСотрудникаОтсутствиеПоБолезни() Экспорт
	Возврат ПолучитьФункциональнуюОпцию("РасчетЗарплатыДляНебольшихОрганизаций");	
КонецФункции

Функция ТекстЗапросаЗаявкиСотрудникаСПодписаннымФайломОтвета() Экспорт
	
	Возврат "ВЫБРАТЬ
	        |	ЗаявкаСотрудникаСправка2НДФЛ.Ссылка КАК Ссылка
	        |ПОМЕСТИТЬ ВТАктивныеЗаявкиСправка2НДФЛ
	        |ИЗ
	        |	БизнесПроцесс.ЗаявкаСотрудникаСправка2НДФЛ КАК ЗаявкаСотрудникаСправка2НДФЛ
	        |ГДЕ
	        |	НЕ ЗаявкаСотрудникаСправка2НДФЛ.Завершен
	        |	И НЕ ЗаявкаСотрудникаСправка2НДФЛ.Выполнено
	        |	И НЕ ЗаявкаСотрудникаСправка2НДФЛ.ПометкаУдаления
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	СправкаНДФЛПрисоединенныеФайлы.Ссылка КАК СправкаНДФЛ,
	        |	ЗаявкаСотрудникаСправка2НДФЛСправкиНДФЛ.Ссылка КАК Ссылка
	        |ПОМЕСТИТЬ ВТПодписанныеСправкиНДФЛ
	        |ИЗ
	        |	ВТАктивныеЗаявкиСправка2НДФЛ КАК ВТАктивныеЗаявкиСправка2НДФЛ
	        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.ЗаявкаСотрудникаСправка2НДФЛ.СправкиНДФЛ КАК ЗаявкаСотрудникаСправка2НДФЛСправкиНДФЛ
	        |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СправкаНДФЛПрисоединенныеФайлы КАК СправкаНДФЛПрисоединенныеФайлы
	        |			ПО ЗаявкаСотрудникаСправка2НДФЛСправкиНДФЛ.СправкаНДФЛ = СправкаНДФЛПрисоединенныеФайлы.ВладелецФайла
	        |				И (НЕ СправкаНДФЛПрисоединенныеФайлы.ПометкаУдаления)
	        |				И (СправкаНДФЛПрисоединенныеФайлы.ПодписанЭП)
	        |		ПО ВТАктивныеЗаявкиСправка2НДФЛ.Ссылка = ЗаявкаСотрудникаСправка2НДФЛСправкиНДФЛ.Ссылка
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ВТПодписанныеСправкиНДФЛ.СправкаНДФЛ КАК ПрисоединенныйФайл,
	        |	КОЛИЧЕСТВО(ЗапланированныеДействияСФайламиДокументовКЭДО.ПрисоединенныйФайл) КАК КоличествоЗапланированныхДействий,
	        |	ВТПодписанныеСправкиНДФЛ.Ссылка КАК Ссылка,
	        |	ЗадачаИсполнителя.Ссылка КАК Задача
	        |ИЗ
	        |	ВТПодписанныеСправкиНДФЛ КАК ВТПодписанныеСправкиНДФЛ
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ЗапланированныеДействияСФайламиДокументовКЭДО
	        |		ПО ВТПодписанныеСправкиНДФЛ.СправкаНДФЛ = ЗапланированныеДействияСФайламиДокументовКЭДО.ПрисоединенныйФайл
	        |			И (ЗапланированныеДействияСФайламиДокументовКЭДО.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать))
	        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	        |		ПО ВТПодписанныеСправкиНДФЛ.Ссылка = ЗадачаИсполнителя.БизнесПроцесс
	        |ГДЕ
	        |	НЕ ЗадачаИсполнителя.Выполнена
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ВТПодписанныеСправкиНДФЛ.СправкаНДФЛ,
	        |	ВТПодписанныеСправкиНДФЛ.Ссылка,
	        |	ЗадачаИсполнителя.Ссылка
	        |ИТОГИ ПО
	        |	Ссылка";
	
КонецФункции

Функция ВладелецЗаявкаСотрудника(Ссылки) Экспорт
	Возврат Ложь;	
КонецФункции

Функция АктивныеЭтапыЗаявокСотрудников() Экспорт
	Возврат Новый Массив;		
КонецФункции

Функция СоответствиеЭтапаЗаявкиСотрудникаИТипаЗаявки() Экспорт
	Возврат Новый Соответствие;
КонецФункции

Функция СоответствиеЭтапаЗаявкиСотрудникаИТочкиМаршрута() Экспорт
	Возврат Новый Соответствие;	
КонецФункции

Функция ЗаявкаСотрудникаОтсутствиеПоБолезниПервыйЭтап() Экспорт
	Возврат Справочники.ЭтапыЗаявокСотрудников.ОформлениеБольничногоЛиста;	
КонецФункции

#КонецОбласти