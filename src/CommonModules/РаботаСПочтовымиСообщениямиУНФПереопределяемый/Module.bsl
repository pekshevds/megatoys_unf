
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриПолученииНастроекПочтовыхЯщиков(УчетнаяЗапись, ОписаниеПочтовыхЯщиков, ДополнительныеПараметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ДлительныеОперации.СообщитьПрогресс(10, ДополнительныеПараметры.ЗаголовокПрогресса);
	ЗаполнитьОписаниеПочтовыхЯщиковСогласноНастройкамПользователя(УчетнаяЗапись, ОписаниеПочтовыхЯщиков, ДополнительныеПараметры);
	ЗаполнитьПараметрыОтбораIMAP(УчетнаяЗапись, ОписаниеПочтовыхЯщиков, ДополнительныеПараметры);
	ДополнительныеПараметры.Вставить("ОписаниеПочтовыхЯщиков", ОписаниеПочтовыхЯщиков);
	
КонецПроцедуры

Процедура ПриПеремещенииПисемВПочтовыйЯщик(УчетнаяЗапись, ОписаниеПочтовогоЯщика, Идентификаторы, ДополнительныеПараметры) Экспорт
	
	Если Не ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДействияСПисьмами.Событие КАК Событие,
	|	ИдентификаторыСобытий.Идентификатор КАК Идентификатор,
	|	ЕСТЬNULL(ДействияСПисьмами.НовыйПочтовыйЯщик.НаименованиеНаСервере, """") КАК НовыйПочтовыйЯщикНаименованиеНаСервере
	|ИЗ
	|	РегистрСведений.ДействияСПисьмами КАК ДействияСПисьмами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|		ПО ДействияСПисьмами.Событие = ИдентификаторыСобытий.Событие
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СодержимоеПочтовыхЯщиковУчетныхЗаписей КАК СодержимоеПочтовыхЯщиковУчетныхЗаписей
	|		ПО ДействияСПисьмами.Событие = СодержимоеПочтовыхЯщиковУчетныхЗаписей.Событие
	|ГДЕ
	|	ДействияСПисьмами.Событие.УчетнаяЗапись = &УчетнаяЗапись
	|	И ДействияСПисьмами.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСПисьмом.ПеремещениеВПочтовыйЯщик)
	|	И ДействияСПисьмами.СтарыйПочтовыйЯщик = &ПочтовыйЯщик");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ПочтовыйЯщик", ОписаниеПочтовогоЯщика.ПочтовыйЯщикСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСобытий = РезультатЗапроса.Выбрать();
	Пока ДанныеСобытий.Следующий() Цикл
		Если ПустаяСтрока(ДанныеСобытий.НовыйПочтовыйЯщикНаименованиеНаСервере) Тогда
			// Игнорировать перемещение в почтовый ящик, если он заведен некорректно (отсутствует наименование на сервере)
			// или если этот ящик отсутствует, т.к. неизвестно куда перемещать письмо.
			Продолжить;
		КонецЕсли;
		МассивИдентификаторов = Идентификаторы.Получить(ДанныеСобытий.НовыйПочтовыйЯщикНаименованиеНаСервере);
		Если МассивИдентификаторов = Неопределено Тогда
			МассивИдентификаторов = Новый Массив;
		КонецЕсли;
		МассивИдентификаторов.Добавить(ДанныеСобытий.Идентификатор);
		Идентификаторы.Вставить(ДанныеСобытий.НовыйПочтовыйЯщикНаименованиеНаСервере, МассивИдентификаторов);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеПеремещенияПисемВПочтовыйЯщик(УчетнаяЗапись, ОписаниеПочтовогоЯщика, Идентификаторы, ДополнительныеПараметры) Экспорт
	
	Если Не ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.ДействияСПисьмами.ОчиститьПеремещениеПисем(УчетнаяЗапись);
	
КонецПроцедуры

Процедура ПриПолученииФлаговСообщенийНаПочтовомСервере(УчетнаяЗапись, ОписаниеПочтовогоЯщика, МассивИдентификаторовСообщений, ДополнительныеПараметры) Экспорт
	
	Если Не ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МассивИдентификаторовСообщений = ИдентификаторыДляРегламентногоОбновленияФлагов(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики);
	
КонецПроцедуры

Процедура ПослеПолученияФлаговСообщенийНаПочтовомСервере(УчетнаяЗапись, ОписаниеПочтовогоЯщика, МассивИдентификаторовСообщений, ДополнительныеПараметры) Экспорт
	
	ДлительныеОперации.СообщитьПрогресс(30, ДополнительныеПараметры.ЗаголовокПрогресса);
	
КонецПроцедуры

Процедура ПриУстановкеФлаговСообщенийПочтовогоЯщика(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ФлагиСообщений, ДополнительныеПараметры) Экспорт
	
	Если Не ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ФлагиСообщений = ФлагиСообщенийДляВыгрузки(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики);
	
КонецПроцедуры

Процедура ПриУстановкеФлаговСообщенийПочтовогоЯщикаМетодомВыбрать(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ФлагиСообщений, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ФлагиСообщений = ФлагиСообщенийДляВыгрузки(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики);
	
КонецПроцедуры

Процедура ПослеУстановкиФлаговСообщенийПочтовогоЯщика(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ФлагиСообщений, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПослеУстановкиФлаговСообщенийНаПочтовомСервере(УчетнаяЗапись, ОписаниеПочтовогоЯщика, Идентификаторы, ДополнительныеПараметры) Экспорт
	
	НаборЗаписей = РегистрыСведений.ДействияСПисьмами.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяЗапись.Установить(УчетнаяЗапись);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкиПочтовыхЯщиков(УчетнаяЗапись, ПочтовыеЯщикиНаСервереIMAP)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиЗагрузкиПисем.ПочтоваяПапка КАК ПочтоваяПапка,
	|	НастройкиЗагрузкиПисем.ВариантЗагрузки КАК ВариантЗагрузки,
	|	НастройкиЗагрузкиПисем.ВариантСинхронизации КАК ВариантСинхронизации,
	|	НастройкиЗагрузкиПисем.ВариантСостояния КАК ВариантСостояния,
	|	НастройкиЗагрузкиПисем.ОтветственныйДляНовыхПисем КАК ОтветственныйДляНовыхПисем
	|ИЗ
	|	РегистрСведений.НастройкиЗагрузкиПисем КАК НастройкиЗагрузкиПисем
	|ГДЕ
	|	НастройкиЗагрузкиПисем.УчетнаяЗапись = &УчетнаяЗапись
	|	И НастройкиЗагрузкиПисем.ПочтоваяПапка В(&ПочтовыеЯщикиНаСервереIMAP)
	|	И НастройкиЗагрузкиПисем.ВариантЗагрузки <> ЗНАЧЕНИЕ(Перечисление.ВариантыЗагрузкиПисем.НеЗагружать)");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ПочтовыеЯщикиНаСервереIMAP", ПочтовыеЯщикиНаСервереIMAP);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		НастройкиПочтовыхЯщиков = НастройкиПочтовыхЯщиковПоУмолчанию(ПочтовыеЯщикиНаСервереIMAP);
	Иначе
		НастройкиПочтовыхЯщиков = РезультатЗапроса.Выгрузить();
	КонецЕсли;
	
	Возврат НастройкиПочтовыхЯщиков;
	
КонецФункции

Функция НастройкиПочтовыхЯщиковПоУмолчанию(ПочтовыеЯщикиНаСервереIMAP)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПочтоваяПапка", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ВариантЗагрузки", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыЗагрузкиПисем"));
	Результат.Колонки.Добавить("ВариантСинхронизации", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыСинхронизацииПисем"));
	Результат.Колонки.Добавить("ВариантСостояния", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыСостоянияНовыхПисем"));
	Результат.Колонки.Добавить("ОтветственныйДляНовыхПисем", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	ДобавляемаяНастройка = Результат.Добавить();
	ДобавляемаяНастройка.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.ТолькоЗаголовки;
	ДобавляемаяНастройка.ВариантСинхронизации = Перечисления.ВариантыСинхронизацииПисем.НеСинхронизировать;
	
	Для Каждого ТекПочтовыйЯщик Из ПочтовыеЯщикиНаСервереIMAP Цикл
		Если ЭлектроннаяПочтаУНФКлиентСервер.ЭтоЯщикОтправленные(ТекПочтовыйЯщик) Тогда
			ДобавляемаяНастройка = Результат.Добавить();
			ДобавляемаяНастройка.ПочтоваяПапка = ТекПочтовыйЯщик;
			ДобавляемаяНастройка.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.ТолькоЗаголовки;
			ДобавляемаяНастройка.ВариантСинхронизации = Перечисления.ВариантыСинхронизацииПисем.НеСинхронизировать;
			ДобавляемаяНастройка.ВариантСостояния = Перечисления.ВариантыСостоянияНовыхПисем.ЗапланированоИЗавершено;
			ДобавляемаяНастройка.ОтветственныйДляНовыхПисем = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ФлагиСообщенийДляВыгрузки(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ИспользуютсяПочтовыеЯщики)
	ФлагиСообщений = Новый Соответствие;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ФлагиПисем.Событие КАК Событие,
	|	ФлагиПисем.Непрочитанное КАК Непрочитанное,
	|	ФлагиПисем.Помеченное КАК Помеченное,
	|	ИдентификаторыСобытий.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.ДействияСПисьмами КАК ДействияСПисьмами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|		ПО ДействияСПисьмами.Событие = ИдентификаторыСобытий.Событие
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФлагиПисем КАК ФлагиПисем
	|		ПО ДействияСПисьмами.Событие = ФлагиПисем.Событие
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СодержимоеПочтовыхЯщиковУчетныхЗаписей КАК СодержимоеПочтовыхЯщиковУчетныхЗаписей
	|		ПО ДействияСПисьмами.Событие = СодержимоеПочтовыхЯщиковУчетныхЗаписей.Событие
	|ГДЕ
	|	ДействияСПисьмами.Событие.УчетнаяЗапись = &УчетнаяЗапись
	|	И ДействияСПисьмами.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСПисьмом.УстановкаФлага)
	|	И (&ИспользоватьОтборПоПочтовомуЯщику
	|			ИЛИ СодержимоеПочтовыхЯщиковУчетныхЗаписей.ПочтовыйЯщик = &ПочтовыйЯщик)");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ИспользоватьОтборПоПочтовомуЯщику", Не ИспользуютсяПочтовыеЯщики);
	Запрос.УстановитьПараметр("ПочтовыйЯщик", ОписаниеПочтовогоЯщика.ПочтовыйЯщикСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат ФлагиСообщений;
	КонецЕсли;
	
	ДанныеСобытий = РезультатЗапроса.Выбрать();
	Пока ДанныеСобытий.Следующий() Цикл
		ФлагиСообщения = Новый ФлагиИнтернетПочтовогоСообщения;
		ФлагиСообщения.Прочитанное = Не ДанныеСобытий.Непрочитанное;
		ФлагиСообщения.Помеченное = ДанныеСобытий.Помеченное;
		ФлагиСообщений.Вставить(ДанныеСобытий.Идентификатор, ФлагиСообщения);
	КонецЦикла;
	
	Возврат ФлагиСообщений;
	
КонецФункции

Функция ИдентификаторыДляРегламентногоОбновленияФлагов(УчетнаяЗапись, ОписаниеПочтовогоЯщика, ИспользуютсяПочтовыеЯщики)
	Идентификаторы = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ИдентификаторыСобытий.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СодержимоеПочтовыхЯщиковУчетныхЗаписей КАК СодержимоеПочтовыхЯщиковУчетныхЗаписей
	|		ПО ИдентификаторыСобытий.Событие = СодержимоеПочтовыхЯщиковУчетныхЗаписей.Событие
	|ГДЕ
	|	(&ИспользоватьОтборПоПочтовомуЯщику
	|			ИЛИ СодержимоеПочтовыхЯщиковУчетныхЗаписей.ПочтовыйЯщик = &ПочтовыйЯщик)
	|	И ИдентификаторыСобытий.Событие.УчетнаяЗапись = &УчетнаяЗапись
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторыСобытий.Событие.Дата УБЫВ");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ИспользоватьОтборПоПочтовомуЯщику", Не ИспользуютсяПочтовыеЯщики);
	Запрос.УстановитьПараметр("ПочтовыйЯщик", ОписаниеПочтовогоЯщика.ПочтовыйЯщикСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Идентификаторы;
	КонецЕсли;
	
	Идентификаторы = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Идентификатор");
	Возврат Идентификаторы;
	
КонецФункции

Процедура ЗаполнитьОписаниеПочтовыхЯщиковСогласноНастройкамПользователя(УчетнаяЗапись, ОписаниеПочтовыхЯщиков, ДополнительныеПараметры)
	
	ПочтовыеЯщикиНаСервереIMAP = Новый Массив;
	Для каждого ОписаниеПочтовогоЯщика Из ОписаниеПочтовыхЯщиков Цикл
		ПочтовыеЯщикиНаСервереIMAP.Добавить(ОписаниеПочтовогоЯщика.ПочтовыйЯщик);
	КонецЦикла;
	
	НастройкиПочтовыхЯщиков = НастройкиПочтовыхЯщиков(УчетнаяЗапись, ПочтовыеЯщикиНаСервереIMAP);
	Для каждого ОписаниеПочтовогоЯщика Из ОписаниеПочтовыхЯщиков Цикл
		Строки = НастройкиПочтовыхЯщиков.НайтиСтроки(Новый Структура("ПочтоваяПапка", ОписаниеПочтовогоЯщика.ПочтовыйЯщик));
		Если Строки.Количество() = 0 Тогда
			ОписаниеПочтовогоЯщика.Синхронизировать = Ложь;
		Иначе
			Для каждого Строка Из Строки Цикл
				ОписаниеПочтовогоЯщика.Синхронизировать = Строка.ВариантСинхронизации <> Перечисления.ВариантыЗагрузкиПисем.НеЗагружать;
				ОписаниеПочтовогоЯщика.ПолучатьФлагиЗагруженныхСообщений = Истина;
				ОписаниеПочтовогоЯщика.ДополнительныеПараметры.Вставить("ВариантЗагрузки", Строка.ВариантЗагрузки);
				ОписаниеПочтовогоЯщика.ДополнительныеПараметры.Вставить("ВариантСинхронизации", Строка.ВариантСинхронизации);
				ОписаниеПочтовогоЯщика.ДополнительныеПараметры.Вставить("ВариантСостояния", Строка.ВариантСостояния);
				ОписаниеПочтовогоЯщика.ДополнительныеПараметры.Вставить("ОтветственныйДляНовыхПисем", Строка.ОтветственныйДляНовыхПисем);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыОтбораIMAP(УчетнаяЗапись, ОписаниеПочтовыхЯщиков, ДополнительныеПараметры)
	
	ПослеДатыОтправленияОбщий = ПослеДатыОтправления(УчетнаяЗапись, ДополнительныеПараметры.РежимЗагрузки, ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики);
	
	Если Не ДополнительныеПараметры.ИспользуютсяПочтовыеЯщики Тогда
		РанееПолученныеИдентификаторы = РегистрыСведений.ИдентификаторыСобытий.ИдентификаторыПослеДатыОтправления(УчетнаяЗапись, ПослеДатыОтправленияОбщий);
		Для каждого ОписаниеПочтовогоЯщика Из ОписаниеПочтовыхЯщиков Цикл
			ОписаниеПочтовогоЯщика.РанееПолученныеИдентификаторы = РанееПолученныеИдентификаторы;
			ОписаниеПочтовогоЯщика.ПараметрыОтбораIMAP.Вставить("ПослеДатыОтправления", ПослеДатыОтправленияОбщий);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Для каждого ОписаниеПочтовогоЯщика Из ОписаниеПочтовыхЯщиков Цикл
		ЗагруженныеСообщения = РегистрыСведений.ИдентификаторыСобытий.ЗагруженныеСообщения(УчетнаяЗапись, ОписаниеПочтовогоЯщика.ПочтовыйЯщик);
		Если ДополнительныеПараметры.РежимЗагрузки = ЭлектроннаяПочтаУНФКлиентСервер.РежимЗагрузкиПредыдущиеСообщения() Тогда
			ПослеДатыОтправления = ПослеДатыОтправленияОбщий;
		ИначеЕсли ЗначениеЗаполнено(ЗагруженныеСообщения.ПослеДатыОтправления) Тогда
			ПослеДатыОтправления = ЗагруженныеСообщения.ПослеДатыОтправления;
		Иначе
			ПослеДатыОтправления = ПослеДатыОтправленияОбщий;
		КонецЕсли;
		ОписаниеПочтовогоЯщика.РанееПолученныеИдентификаторы = ЗагруженныеСообщения.Идентификаторы;
		ОписаниеПочтовогоЯщика.ПараметрыОтбораIMAP.Вставить("ПослеДатыОтправления", ПослеДатыОтправления);
	КонецЦикла;
	
КонецПроцедуры

Функция ПослеДатыОтправления(УчетнаяЗапись, РежимЗагрузки, ИспользуютсяПочтовыеЯщики)
	
	ДатаОтправления = Неопределено;
	
	Если РежимЗагрузки = ЭлектроннаяПочтаУНФКлиентСервер.РежимЗагрузкиНовыеСообщения() Тогда
		Если ИспользуютсяПочтовыеЯщики Тогда
			ДатаОтправления = ПерваяДатаПисьмаВУчетнойЗаписи(УчетнаяЗапись);
		Иначе
			ДатаОтправления = ПоследняяДатаПисьмаВУчетнойЗаписи(УчетнаяЗапись);
		КонецЕсли;
		Если ЗначениеЗаполнено(ДатаОтправления) Тогда
			// Для компенсации разницы в часовых поясах используем прошедшую дату
			ДатаОтправления = НачалоДня(НачалоДня(ДатаОтправления) - 1);
		КонецЕсли;
	Иначе
		ДатаОтправления = РегистрыСведений.ИнкрементнаяСинхронизацияПочты.ДатаОтправления(УчетнаяЗапись);
		Если ЗначениеЗаполнено(ДатаОтправления) Тогда
			ДатаОтправления = ДобавитьМесяц(НачалоДня(ДатаОтправления), -1);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОтправления) Тогда
		// При первой синхронизации загружаем письма за последний месяц
		ДатаОтправления = ДобавитьМесяц(НачалоДня(ТекущаяДатаСеанса()), -1);
	КонецЕсли;
	
	Если РежимЗагрузки = ЭлектроннаяПочтаУНФКлиентСервер.РежимЗагрузкиПредыдущиеСообщения() Тогда
		РегистрыСведений.ИнкрементнаяСинхронизацияПочты.ЗаписатьДатуОтправления(ДатаОтправления, УчетнаяЗапись);
	КонецЕсли;
	
	Возврат ДатаОтправления;
	
КонецФункции

Функция ПоследняяДатаПисьмаВУчетнойЗаписи(УчетнаяЗапись)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Событие.НачалоСобытия КАК НачалоСобытия
	|ИЗ
	|	Документ.Событие КАК Событие
	|ГДЕ
	|	Событие.УчетнаяЗапись = &УчетнаяЗапись
	|	И Событие.ТипСобытия = ЗНАЧЕНИЕ(Перечисление.ТипыСобытий.ЭлектронноеПисьмо)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачалоСобытия УБЫВ");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Выборка.НачалоСобытия;
	
КонецФункции

Функция ПерваяДатаПисьмаВУчетнойЗаписи(УчетнаяЗапись)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Событие.НачалоСобытия КАК НачалоСобытия
	|ИЗ
	|	Документ.Событие КАК Событие
	|ГДЕ
	|	Событие.УчетнаяЗапись = &УчетнаяЗапись
	|	И Событие.ТипСобытия = ЗНАЧЕНИЕ(Перечисление.ТипыСобытий.ЭлектронноеПисьмо)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачалоСобытия ВОЗР");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Выборка.НачалоСобытия;
	
КонецФункции


#КонецОбласти
