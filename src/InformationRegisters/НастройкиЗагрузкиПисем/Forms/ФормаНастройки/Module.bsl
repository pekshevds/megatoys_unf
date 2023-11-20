
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("УчетнаяЗапись", УчетнаяЗапись);
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ВызватьИсключение НСтр("ru = 'Не указана учетная запись для настройки почтовых ящиков.'");
	КонецЕсли;
	
	ОбновитьПочтовыеЯщикиНаСервере(Неопределено, Истина);
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиЗагрузкиПисем) Тогда
		Элементы.ФормаОбновитьПочтовыеПапки.Доступность = Ложь;
		Элементы.НастройкиЗагрузкиПисем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РежимРаботыСПапкамиПриИзменении(Элемент)
	
	Если РежимРаботыСПапками = "Расширенный" Тогда
		ОбновитьПочтовыеЯщикиНаСервере(Истина);
	Иначе
		ОтключитьПочтовыеПапкиНаСервере();
	КонецЕсли;
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗагрузкиПисемСинхронизироватьПриИзменении(Элемент)
	
	ЗаписатьНастройкуПочтовогоЯщика(Истина, Ложь);
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗагрузкиПисемПриИзмененииОбщий(Элемент)
	
	ИзмененВариантЗагрузки = Элемент.Имя = Элементы.НастройкиЗагрузкиПисемВариантЗагрузки.Имя;
	ЗаписатьНастройкуПочтовогоЯщика(Ложь, ИзмененВариантЗагрузки);
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйЯщикВходящиеПриИзменении(Элемент)
	ИзменитьТипПочтовогоЯщика(ПочтовыйЯщикВходящие, "Входящие");
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйЯщикОтправленныеПриИзменении(Элемент)
	ИзменитьТипПочтовогоЯщика(ПочтовыйЯщикОтправленные, "Отправленные");
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйЯщикЧерновикиПриИзменении(Элемент)
	ИзменитьТипПочтовогоЯщика(ПочтовыйЯщикЧерновики, "Черновики");
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйЯщикСпамПриИзменении(Элемент)
	ИзменитьТипПочтовогоЯщика(ПочтовыйЯщикСпам, "Спам");
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
КонецПроцедуры

&НаКлиенте
Процедура ПочтовыйЯщикУдаленныеПриИзменении(Элемент)
	ИзменитьТипПочтовогоЯщика(ПочтовыйЯщикУдаленные, "Удаленные");
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьПочтовыеПапки(Команда)
	
	ОбновитьПочтовыеЯщикиНаСервере(Неопределено);
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьПочтовыеПапки(Команда)
	
	ОтключитьПочтовыеПапкиНаСервере();
	Оповестить("Запись_ПочтовыеЯщикиУчетныхЗаписей");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция НастройкиСуществуют(Знач УчетнаяЗапись)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиЗагрузкиПисем.УчетнаяЗапись КАК УчетнаяЗапись
	|ИЗ
	|	РегистрСведений.НастройкиЗагрузкиПисем КАК НастройкиЗагрузкиПисем
	|ГДЕ
	|	НастройкиЗагрузкиПисем.УчетнаяЗапись = &УчетнаяЗапись");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуНастроек()
	
	НастройкиЗагрузкиПисем.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиЗагрузкиПисем.ПочтоваяПапка КАК ПочтоваяПапка,
	|	НастройкиЗагрузкиПисем.ВариантЗагрузки КАК ВариантЗагрузки,
	|	НастройкиЗагрузкиПисем.ВариантСинхронизации КАК ВариантСинхронизации,
	|	НастройкиЗагрузкиПисем.ВариантСостояния КАК ВариантСостояния,
	|	НастройкиЗагрузкиПисем.ОтветственныйДляНовыхПисем КАК ОтветственныйДляНовыхПисем,
	|	ВЫБОР
	|		КОГДА НастройкиЗагрузкиПисем.ВариантЗагрузки = ЗНАЧЕНИЕ(перечисление.ВариантыЗагрузкиПисем.ПустаяСсылка)
	|				ИЛИ НастройкиЗагрузкиПисем.ВариантЗагрузки = ЗНАЧЕНИЕ(перечисление.ВариантыЗагрузкиПисем.НеЗагружать)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Синхронизировать
	|ИЗ
	|	РегистрСведений.НастройкиЗагрузкиПисем КАК НастройкиЗагрузкиПисем
	|ГДЕ
	|	НастройкиЗагрузкиПисем.УчетнаяЗапись = &УчетнаяЗапись");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		НастройкиЗагрузкиПисем.Загрузить(РезультатЗапроса.Выгрузить());
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПочтовыеЯщикиУчетныхЗаписей.Ссылка КАК Ссылка,
	|	ПочтовыеЯщикиУчетныхЗаписей.ВидПапки КАК ВидПапки
	|ИЗ
	|	Справочник.ПочтовыеЯщикиУчетныхЗаписей КАК ПочтовыеЯщикиУчетныхЗаписей
	|ГДЕ
	|	ПочтовыеЯщикиУчетныхЗаписей.Владелец = &Владелец
	|	И НЕ ПочтовыеЯщикиУчетныхЗаписей.ПометкаУдаления
	|	И ПочтовыеЯщикиУчетныхЗаписей.ВидПапки <> ЗНАЧЕНИЕ(перечисление.ТипыПочтовыхЯщиков.пустаяссылка)";
	Запрос.УстановитьПараметр("Владелец", УчетнаяЗапись);
	ПочтовыеЯщики = Запрос.Выполнить().Выбрать();
	ПочтовыеЯщикиПоТипам = Новый Соответствие;
	Пока ПочтовыеЯщики.Следующий() Цикл
		ПочтовыеЯщикиПоТипам.Вставить(ПочтовыеЯщики.ВидПапки, ПочтовыеЯщики.Ссылка);
	КонецЦикла;
	ПочтовыйЯщикВходящие = ПочтовыеЯщикиПоТипам.Получить(Перечисления.ТипыПочтовыхЯщиков.Входящие);
	ПочтовыйЯщикОтправленные = ПочтовыеЯщикиПоТипам.Получить(Перечисления.ТипыПочтовыхЯщиков.Отправленные);
	ПочтовыйЯщикЧерновики = ПочтовыеЯщикиПоТипам.Получить(Перечисления.ТипыПочтовыхЯщиков.Черновики);
	ПочтовыйЯщикСпам = ПочтовыеЯщикиПоТипам.Получить(Перечисления.ТипыПочтовыхЯщиков.Спам);
	ПочтовыйЯщикУдаленные = ПочтовыеЯщикиПоТипам.Получить(Перечисления.ТипыПочтовыхЯщиков.Удаленные);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПочтовыеЯщикиНаСервере(Знач ОбновитьСправочникПочтовыхЯщиков, ПриСозданииНаСервере = Ложь)
	
	Если ПриСозданииНаСервере И НастройкиСуществуют(УчетнаяЗапись) Тогда
		ЗаполнитьТаблицуНастроек();
		УправлениеФормой();
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОбновитьСправочникПочтовыхЯщиков) <> Тип("Булево") Тогда
		ИспользуютсяПочтовыеЯщики = ЭлектроннаяПочтаУНФ.ИспользуютсяПочтовыеЯщики(УчетнаяЗапись);
		ОбновитьСправочникПочтовыхЯщиков = ИспользуютсяПочтовыеЯщики;
	КонецЕсли;
	ЭлектроннаяПочтаУНФ.ОбновитьПочтовыеПапки(УчетнаяЗапись, ОбновитьСправочникПочтовыхЯщиков);
	ЗаполнитьТаблицуНастроек();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьПочтовыеПапкиНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПочтовыеЯщикиУчетныхЗаписей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПочтовыеЯщикиУчетныхЗаписей КАК ПочтовыеЯщикиУчетныхЗаписей
	|ГДЕ
	|	ПочтовыеЯщикиУчетныхЗаписей.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", УчетнаяЗапись);
	ПочтовыеЯщики = Запрос.Выполнить().Выбрать();
	Пока ПочтовыеЯщики.Следующий() Цикл
		ПочтовыйЯщик = ПочтовыеЯщики.Ссылка.ПолучитьОбъект();
		ПочтовыйЯщик.УстановитьПометкуУдаления(Истина);
		ПочтовыйЯщик.Записать();
	КонецЦикла;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ИспользуютсяПочтовыеЯщики = ЭлектроннаяПочтаУНФ.ИспользуютсяПочтовыеЯщики(УчетнаяЗапись);
	Если ИспользуютсяПочтовыеЯщики Тогда
		РежимРаботыСПапками = "Расширенный";
	Иначе
		РежимРаботыСПапками = "Упрощенный";
	КонецЕсли;
	
	Элементы.ПростойРежимРаботыСПапками.Видимость = РежимРаботыСПапками = "Упрощенный";
	Элементы.РасширенныйРежимРаботыСПапками.Видимость = РежимРаботыСПапками = "Расширенный";
	Элементы.НастройкаВидовПочтовыхПапок.Видимость = РежимРаботыСПапками = "Расширенный";
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НовоеЗначениеВариантЗагрузки(Синхронизировать, ТекущийВариантЗагрузки)
	
	Если Синхронизировать Тогда
		Если ТекущийВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.НеЗагружать
			Или ТекущийВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.ПустаяСсылка() Тогда
			ВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.ТолькоЗаголовки;
		Иначе
			ВариантЗагрузки = ТекущийВариантЗагрузки;
		КонецЕсли;
	Иначе
		ВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.НеЗагружать;
	КонецЕсли;
	Возврат ВариантЗагрузки;
	
КонецФункции

&НаСервереБезКонтекста
Функция НовоеЗначениеСинхронизировать(ВариантЗагрузки)
	
	Если ВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.НеЗагружать
		Или ВариантЗагрузки = Перечисления.ВариантыЗагрузкиПисем.ПустаяСсылка() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаписатьНастройкуПочтовогоЯщика(ИзмененПризнакСинхронизировать = Ложь, ИзмененВариантЗагрузки = Ложь)
	
	ТекущиеДанные = НастройкиЗагрузкиПисем.НайтиПоИдентификатору(Элементы.НастройкиЗагрузкиПисем.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ИзмененПризнакСинхронизировать Тогда
		ТекущиеДанные.ВариантЗагрузки = НовоеЗначениеВариантЗагрузки(ТекущиеДанные.Синхронизировать, ТекущиеДанные.ВариантЗагрузки);
	ИначеЕсли ИзмененВариантЗагрузки Тогда
		ТекущиеДанные.Синхронизировать = НовоеЗначениеСинхронизировать(ТекущиеДанные.ВариантЗагрузки);
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.НастройкиЗагрузкиПисем.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
	МенеджерЗаписи.ПочтоваяПапка = ТекущиеДанные.ПочтоваяПапка;
	МенеджерЗаписи.ВариантЗагрузки = ТекущиеДанные.ВариантЗагрузки;
	МенеджерЗаписи.ВариантСинхронизации = ТекущиеДанные.ВариантСинхронизации;
	МенеджерЗаписи.ВариантСостояния = ТекущиеДанные.ВариантСостояния;
	МенеджерЗаписи.ОтветственныйДляНовыхПисем = ТекущиеДанные.ОтветственныйДляНовыхПисем;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьТипПочтовогоЯщика(ИзменяемыйПочтовыйЯшик, ИмяТипаПочтовогоЯщика)
	
	ТипПочтовогоЯщика = Перечисления.ТипыПочтовыхЯщиков[ИмяТипаПочтовогоЯщика];
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПочтовыеЯщикиУчетныхЗаписей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПочтовыеЯщикиУчетныхЗаписей КАК ПочтовыеЯщикиУчетныхЗаписей
	|ГДЕ
	|	ПочтовыеЯщикиУчетныхЗаписей.Владелец = &Владелец
	|	И ПочтовыеЯщикиУчетныхЗаписей.ВидПапки = &ВидПапки";
	Запрос.УстановитьПараметр("Владелец", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ВидПапки", ТипПочтовогоЯщика);
	ПочтовыеЯщики = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	Попытка
		Пока ПочтовыеЯщики.Следующий() Цикл
			ПочтовыйЯщик = ПочтовыеЯщики.Ссылка.ПолучитьОбъект();
			ПочтовыйЯщик.Заблокировать();
			ПочтовыйЯщик.ВидПапки = Неопределено;
			ПочтовыйЯщик.Записать();
			ПочтовыйЯщик.Разблокировать();
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ИзменяемыйПочтовыйЯшик) Тогда
			ПочтовыйЯщик = ИзменяемыйПочтовыйЯшик.ПолучитьОбъект();
			ПочтовыйЯщик.Заблокировать();
			ПочтовыйЯщик.ВидПапки = ТипПочтовогоЯщика;
			ПочтовыйЯщик.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти