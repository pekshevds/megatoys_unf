
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, 
		Ложь, 
		Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = "Список";
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	
	// УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список, , ,
		Новый Структура("ОтборПериод", "ДатаПоследнегоФормирования"));
	// Конец УНФ.ОтборыСписка

	ПрочитатьИерархию();
	
	Список.Параметры.УстановитьЗначениеПараметра("НеСформирован", НСтр("ru = 'Не сформирован'"));
	Список.Параметры.УстановитьЗначениеПараметра("УспешноСформирован", НСтр("ru = 'Сформирован успешно'")); 
	Список.Параметры.УстановитьЗначениеПараметра("КомандаСформировать", НСтр("ru = 'Сформировать'"));
	Список.Параметры.УстановитьЗначениеПараметра("КомандаСоставСегмента", НСтр("ru = 'Состав сегмента'"));
	
	ЗаполнитьСписокВыбораЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СегментНоменклатурыГруппа" Тогда
		НоваяГруппа = Неопределено;
		Если ТипЗнч(Параметр) = Тип("Массив") И Параметр.Количество() <> 0 Тогда
			НоваяГруппа = Параметр[0];
		ИначеЕсли ЗначениеЗаполнено(Параметр) Тогда
			НоваяГруппа = Параметр;
		Иначе
			НоваяГруппа = Неопределено;
		КонецЕсли;
		
		ПрочитатьИерархию(НоваяГруппа);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СвернутьОтборыНажатие(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазвернутьОтборыНажатие(Элемент)
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "КомандаФормированияСегмента" Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыделенныйСегмент = Элементы.Список.ТекущиеДанные.Ссылка;
		РезультатФоновогоЗадания = ФоновоеЗаданиеЗапустить();
		
		Если РезультатФоновогоЗадания = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		Если РезультатФоновогоЗадания.Статус = "Ошибка" Тогда
			ПоказатьОшибкиФормирования(РезультатФоновогоЗадания);
		ИначеЕсли РезультатФоновогоЗадания.Статус <> "Выполняется" Тогда 
			ОперацииПослеФормирования();
		Иначе
			Обработчик = Новый ОписаниеОповещения("ФоновоеЗаданиеВыполнено", ЭтотОбъект, Истина);
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
			ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Сегмент формируется...'");
			ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатФоновогоЗадания, Обработчик, ПараметрыОжидания);
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = "КомандаСоставСегмента" Тогда
		
	СтандартнаяОбработка = Ложь;
		ВыделенныйСегмент = Элементы.Список.ТекущиеДанные.Ссылка;
		ПараметрыИОтборОтчета = Новый Структура("СегментНоменклатуры", ВыделенныйСегмент);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("КлючВарианта", "СоставСегментаНоменклатуры");
		ПараметрыФормы.Вставить("Отбор", ПараметрыИОтборОтчета);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
		
		ОткрытьФорму("Отчет.СоставСегмента.Форма", ПараметрыФормы, , Истина);
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусФормированияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтатусФормирования", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборИерархия

&НаКлиенте
Процедура ИерархияИзменить(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) <> Тип("СправочникСсылка.СегментыНоменклатуры")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) Тогда
		
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияСоздатьГруппу(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	Если ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
		ЗначенияЗаполнения.Вставить("Родитель", Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СегментыНоменклатуры.ФормаГруппы",
		Новый Структура("ЗначенияЗаполнения, ЭтоГруппа", ЗначенияЗаполнения, Истина),
		Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияСкопировать(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) <> Тип("СправочникСсылка.СегментыНоменклатуры")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) Тогда
		
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СегментыНоменклатуры.ФормаГруппы",
		Новый Структура("ЗначениеКопирования, ЭтоГруппа", Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов, Истина),
		Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияУстановитьПометкуУдаления(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) <> Тип("СправочникСсылка.СегментыНоменклатуры")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) Тогда
		
		Возврат;
	КонецЕсли;
	
	ПометкаУдаления = ИзменитьПометкуУдаленияГруппыСервер(Элементы.ОтборИерархия.ТекущиеДанные.ПолучитьИдентификатор());
	
	ТекстОповещения = СтрШаблон(НСтр("ru='Пометка удаления %1'"),
		?(ПометкаУдаления, НСтр("ru='установлена'"), НСтр("ru='снята'")));
		
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов),
		Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов,
		БиблиотекаКартинок.Информация32);
		
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияВключаяВложенные(Команда)
	
	Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка = 
		Не Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка;
	УстановитьОтборПоИерархии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборПоИерархии(ЭтотОбъект);
	
	#Если МобильныйКлиент Тогда
		НастроитьПанельОтборовМобильныйКлиент();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);
	Если СтрокаИерархии = Неопределено
		Или СтрокаИерархии.ГруппаСегментов = "Все"
		Или СтрокаИерархии.ГруппаСегментов = "БезГруппы" Тогда
		
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Значение = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаИерархии.ГруппаСегментов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Строка = Неопределено Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Строка);
	Если СтрокаИерархии = Неопределено Или СтрокаИерархии.ГруппаСегментов = "Все" Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.ДопустимыеДействия	= ДопустимыеДействияПеретаскивания.Перемещение;
	ПараметрыПеретаскивания.Действие			= ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив")
		Или ПараметрыПеретаскивания.Значение.Количество() = 0
		Или ТипЗнч(ПараметрыПеретаскивания.Значение[0]) <> Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Строка);
	Если СтрокаИерархии = Неопределено Или СтрокаИерархии.ГруппаСегментов = "Все" Тогда
		Возврат;
	КонецЕсли;
	
	НоваяГруппа = ?(СтрокаИерархии.ГруппаСегментов = "БезГруппы", 
		ПредопределенноеЗначение("Справочник.СегментыНоменклатуры.ПустаяСсылка"), 
		СтрокаИерархии.ГруппаСегментов);
	ИерархияПеретаскиваниеСервер(ПараметрыПеретаскивания.Значение, НоваяГруппа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "ДатаПоследнегоФормирования");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьПанельОтборовМобильныйКлиент()
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСОтборами.НастроитьПанельОтборовМобильныйКлиент(ЭтотОбъект, , , 
		"ОтборСтатусФормирования,ОтборИерархияТекущая");
	
КонецПроцедуры

#Область Иерархия

&НаСервере
Процедура ПрочитатьИерархию(ГруппаТекущейСтроки = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА Сегменты.ПометкаУдаления
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ИндексПиктограммы,
		|	Сегменты.Ссылка КАК ГруппаСегментов,
		|	ПРЕДСТАВЛЕНИЕ(Сегменты.Ссылка) КАК ПредставлениеГруппы
		|ИЗ
		|	Справочник.СегментыНоменклатуры КАК Сегменты
		|ГДЕ
		|	Сегменты.ЭтоГруппа = ИСТИНА
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сегменты.Ссылка ИЕРАРХИЯ
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(Дерево, "ОтборИерархия");
	
	ИдентификаторСтроки = Неопределено;
	Если ГруппаТекущейСтроки <> Неопределено Тогда
		ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(ОтборИерархия, ГруппаТекущейСтроки);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		Элементы.ОтборИерархия.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
	ЭлементыКоллекции = ОтборИерархия.ПолучитьЭлементы();
	
	СтрокаДерева = ЭлементыКоллекции.Вставить(0);
	СтрокаДерева.ИндексПиктограммы = -1;
	СтрокаДерева.ГруппаСегментов = "Все";
	СтрокаДерева.ПредставлениеГруппы = НСтр("ru='<Все группы>'");
	
	СтрокаДерева = ЭлементыКоллекции.Добавить();
	СтрокаДерева.ИндексПиктограммы = -1;
	СтрокаДерева.ГруппаСегментов = "БезГруппы";
	СтрокаДерева.ПредставлениеГруппы = НСтр("ru='<Нет группы>'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИерархии(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоОтборПоГруппе = ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов) = Тип("СправочникСсылка.СегментыНоменклатуры");
	
	Элементы.ОтборИерархияКонтекстноеМенюИерархияИзменить.Доступность					= ЭтоОтборПоГруппе;
	Элементы.ОтборИерархияКонтекстноеМенюИерархияСкопировать.Доступность				= ЭтоОтборПоГруппе;
	Элементы.ОтборИерархияКонтекстноеМенюИерархияУстановитьПометкуУдаления.Доступность	= ЭтоОтборПоГруппе;
	
	ПравоеЗначение	= Неопределено;
	Сравнение		= ВидСравненияКомпоновкиДанных.Равно;
	Использование	= Истина;
	
	Если ЭтоОтборПоГруппе Тогда
		
		Если Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка Тогда
			Сравнение = ВидСравненияКомпоновкиДанных.ВИерархии;
		КонецЕсли;
		ПравоеЗначение = Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов;
		
	ИначеЕсли Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов = "Все" Тогда
		
		Использование = Ложь;
		
	ИначеЕсли Элементы.ОтборИерархия.ТекущиеДанные.ГруппаСегментов = "БезГруппы" Тогда
		
		ПравоеЗначение = ПредопределенноеЗначение("Справочник.СегментыНоменклатуры.ПустаяСсылка");
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Родитель",
		ПравоеЗначение,
		Сравнение,
		,
		Использование);
	
	Форма.ОтборИерархияТекущая = ПравоеЗначение;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьПометкуУдаления(Сегмент)
	
	СегментОбъект = Сегмент.ПолучитьОбъект();
	СегментОбъект.УстановитьПометкуУдаления(Не СегментОбъект.ПометкаУдаления, Истина);
	
	Возврат СегментОбъект.ПометкаУдаления;
	
КонецФункции

&НаСервере
Функция ИзменитьПометкуУдаленияГруппыСервер(ИдентификаторТекущейСтроки)
	
	ТекущаяСтрокаДерева = ОтборИерархия.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	ПометкаУдаления = ИзменитьПометкуУдаления(ТекущаяСтрокаДерева.ГруппаСегментов);
	ИзменитьПиктограммуРекурсивно(ТекущаяСтрокаДерева, ПометкаУдаления);
	
	Возврат ПометкаУдаления;
	
КонецФункции

&НаСервере
Процедура ИзменитьПиктограммуРекурсивно(СтрокаДерева, ПометкаУдаления)
	
	СтрокаДерева.ИндексПиктограммы = ?(ПометкаУдаления, 1, 0);
	
	СтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
	Для Каждого СтрокаПодчиненная Из СтрокиДерева Цикл
		ИзменитьПиктограммуРекурсивно(СтрокаПодчиненная, ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИерархияПеретаскиваниеСервер(МассивСегментов, НоваяГруппа)
	
	УстановитьНовуюГруппуСегментов(МассивСегментов, НоваяГруппа);
	
	Если МассивСегментов[0].ЭтоГруппа Тогда
		
		ПрочитатьИерархию();
		
		ИдентификаторСтроки = 0;
		ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля(
			"ГруппаСегментов",
			ИдентификаторСтроки,
			ОтборИерархия.ПолучитьЭлементы(),
			МассивСегментов[0],
			Ложь);
		Элементы.ОтборИерархия.ТекущаяСтрока = ИдентификаторСтроки;
		
	Иначе
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьНовуюГруппуСегментов(МассивСегментов, НоваяГруппа)
	
	Для Каждого Сегмент Из МассивСегментов Цикл
		СегментОбъект = Сегмент.ПолучитьОбъект();
		СегментОбъект.Заблокировать();
		СегментОбъект.Родитель = НоваяГруппа;
		СегментОбъект.Записать();
		СегментОбъект.Разблокировать();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторСтрокиДереваПоЗначению(Коллекция, ИскомоеЗначение)
	
	КоллекцияЭлементов = Коллекция.ПолучитьЭлементы();
	
	Для каждого Элемент Из КоллекцияЭлементов Цикл
		
		Если Элемент.ГруппаСегментов = ИскомоеЗначение Тогда
			Возврат Элемент.ПолучитьИдентификатор();
		КонецЕсли;
		
		Идентификатор = ИдентификаторСтрокиДереваПоЗначению(Элемент, ИскомоеЗначение);
		
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПоказатьОшибкиФормирования(Знач ДанныеОшибки)
	
	Если ТипЗнч(ДанныеОшибки) = Тип("Структура") Тогда
		КраткоеПредставлениеОшибки = ДанныеОшибки.КраткоеПредставлениеОшибки;
		ПодробноеПредставлениеОшибки = ДанныеОшибки.ПодробноеПредставлениеОшибки;
	Иначе
		КраткоеПредставлениеОшибки = ДанныеОшибки;
		ПодробноеПредставлениеОшибки = "";
	КонецЕсли;
	
	Если ПустаяСтрока(ПодробноеПредставлениеОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ИмяСобытия = НСтр("ru = 'Формирование сегмента номенклатуры'",
		ОбщегоНазначения.КодОсновногоЯзыка());
		
	ЗаписьЖурналаРегистрации(ИмяСобытия, Уровень, , ВыделенныйСегмент,
			ПодробноеПредставлениеОшибки);
			
	ВызватьИсключение ПодробноеПредставлениеОшибки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, 
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораЭлементов()
	
	Элементы.ОтборСтатусФормирования.СписокВыбора.Очистить();
	Элементы.ОтборСтатусФормирования.СписокВыбора.Добавить(НСтр("ru = 'Не сформирован'"),
		НСтр("ru = 'Не сформирован'"));
	Элементы.ОтборСтатусФормирования.СписокВыбора.Добавить(НСтр("ru = 'Сформирован успешно'"),
		НСтр("ru = 'Сформирован успешно'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ФоновоеЗаданиеВыполнено(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
			
	ОперацииПослеФормирования();
	
КонецПроцедуры

&НаСервере
Функция ФоновоеЗаданиеЗапустить()
	
	Попытка
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.ЗапуститьВФоне = Истина;
		
		ПараметрыФормированияСегмента = Новый Структура;
		
		ПараметрыФормированияСегмента.Вставить("Сегмент", ВыделенныйСегмент);	
		
		РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(
			"РаботаССегментами.СформироватьСоставСегментаВФоне", ПараметрыФормированияСегмента,
			ПараметрыВыполнения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат РезультатФоновогоЗадания;
	
КонецФункции

&НаКлиенте
Процедура ОперацииПослеФормирования() 
	
	РассчитатьКоличествоНоменклатурыВСегменте();
	СтрокаШаблон = НСтр("ru = 'Сегмент успешно сформирован. Подобрано по правилам: %1, добавлено вручную: %2'");
	ТекстСтроки  = СтрШаблон(СтрокаШаблон, КоличествоНоменклатурыПоПравилам, КоличествоНоменклатурыВручную);
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСтроки);	

КонецПроцедуры

&НаСервере
Процедура РассчитатьКоличествоНоменклатурыВСегменте()
	КоличествоНоменклатурыВручную = СоставСегментаВручную().Количество();
	КоличествоНоменклатурыПоПравилам = СоставСегментаПоПравилам().Количество();
КонецПроцедуры

&НаСервере
Функция СоставСегментаПоПравилам()
	Возврат Справочники.СегментыНоменклатуры.ПолучитьСоставСегмента(ВыделенныйСегмент, 
		Перечисления.СпособыДобавленияВСегмент.ПоПравилам);
КонецФункции

&НаСервере
Функция СоставСегментаВручную()
	Возврат Справочники.СегментыНоменклатуры.ПолучитьСоставСегмента(ВыделенныйСегмент, 
		Перечисления.СпособыДобавленияВСегмент.Вручную);
КонецФункции

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, 
	ВыбранноеЗначение, ПредставлениеЗначения = "")
	
	Если ПредставлениеЗначения = "" Тогда
		ПредставлениеЗначения = Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, 
		ИмяПоляОтбораСписка,
		ГруппаРодительМетки,
		ВыбранноеЗначение,
		ПредставлениеЗначения);
		
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка,,Истина);
	
КонецПроцедуры

#КонецОбласти
