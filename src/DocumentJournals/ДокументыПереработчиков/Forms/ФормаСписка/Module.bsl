#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение,
	ПредставлениеЗначения = "")

	Если ПредставлениеЗначения = "" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли;

	ИмяСписка = ИмяСпискаСервер();

	ИмяТчМеток = ИмяТчДанныхМетокСервер();

	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение,
		ПредставлениеЗначения, , , ИмяТчМеток);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ЭтотОбъект[ИмяСписка], ИмяПоляОтбораСписка, , , ИмяТчМеток);

КонецПроцедуры

&НаКлиенте
Процедура РазвернутьОтборы()
	ИмяГруппы = ПолучитьИмяГруппыПанели();
	НовоеЗначениеВидимость = Не Элементы[ИмяГруппы].Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость,
		СтруктураИменЭлементовПанелиОтборов());
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы,
		ДополнительныеПараметры);

КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)

	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;

	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы,
		ДополнительныеПараметры);

КонецПроцедуры


//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаЖурнал" Тогда
		СмещениеНаименованияМетки = 1;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаЗаказов" Тогда
		СмещениеНаименованияМетки = 2;
	Иначе
		СмещениеНаименованияМетки = 3;
	КонецЕсли;

	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + СмещениеНаименованияМетки);
	УдалитьМеткуОтбора(МеткаИД);

КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	ИмяМетки = СтрЗаменить(Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя, "Страница", "");
	ИмяСписка = ИмяСпискаСервер();
	ИмяПравойПанели = ИмяПанелиМетокОтбора();
	ИмяТЧДанныеОтборов = "ДанныеОтборов" + ИмяМетки;

	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ЭтотОбъект[ИмяСписка], МеткаИД, ИмяСписка,
		ИмяТчДанныхМетокСервер(), , ИмяПравойПанели, , ИмяТЧДанныеОтборов);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	ИмяМетки = СтрЗаменить(ЭтаФорма.ТекущийЭлемент.Имя, "НастроитьОтборы", "");

	ИмяРеквизитаСписка = "Список" + ИмяМетки;
	ИмяТЧДанныеМеток = "ДанныеМеток" + ИмяМетки;
	ИмяТЧДанныеОтборов = "ДанныеОтборов" + ИмяМетки;
	ИмяГруппыОтборов = "ГруппаОтборы" + ИмяМетки;
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию" + ИмяМетки;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);

	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(
		ДополнительныеПараметры), ДополнительныеПараметры);

КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)

	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);

КонецФункции

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)

	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя);

КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)

	ПоискМетки = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	Если СтрЗаканчиваетсяНа(ПоискМетки, "ОтчетПереработчика") Тогда
		ИмяРеквизитаСписка = "СписокОтчетПереработчика";
		ИмяТЧДанныеМеток = "ДанныеМетокОтчетПереработчика";
		ИмяТЧДанныеОтборов = "ДанныеОтборовОтчетПереработчика";
	ИначеЕсли СтрЗаканчиваетсяНа(ПоискМетки, "Заказов") Тогда
		ИмяРеквизитаСписка = "СписокЗаказов";
		ИмяТЧДанныеМеток = "ДанныеМетокЗаказов";
		ИмяТЧДанныеОтборов = "ДанныеОтборовЗаказов";
	ИначеЕсли СтрЗаканчиваетсяНа(ПоискМетки, "РасходнаяНакладная") Тогда
		ИмяРеквизитаСписка = "СписокРасходнаяНакладная";
		ИмяТЧДанныеМеток = "ДанныеМетокРасходнаяНакладная";
		ИмяТЧДанныеОтборов = "ДанныеОтборовРасходнаяНакладная";
	Иначе
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	КонецЕсли;

	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя, ИмяРеквизитаСписка,
		ИмяТЧДанныеМеток, ИмяТЧДанныеОтборов);

КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)

	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя);

КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)

	ПоискМетки = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	Если СтрЗаканчиваетсяНа(ПоискМетки, "ОтчетПереработчика") Тогда
		ИмяРеквизитаСписка = "СписокОтчетПереработчика";
		ИмяТЧДанныеМеток = "ДанныеМетокОтчетПереработчика";
		ИмяТЧДанныеОтборов = "ДанныеОтборовОтчетПереработчика";
	ИначеЕсли СтрЗаканчиваетсяНа(ПоискМетки, "Заказов") Тогда
		ИмяРеквизитаСписка = "СписокЗаказов";
		ИмяТЧДанныеМеток = "ДанныеМетокЗаказов";
		ИмяТЧДанныеОтборов = "ДанныеОтборовЗаказов";
	ИначеЕсли СтрЗаканчиваетсяНа(ПоискМетки, "РасходнаяНакладная") Тогда
		ИмяРеквизитаСписка = "СписокРасходнаяНакладная";
		ИмяТЧДанныеМеток = "ДанныеМетокРасходнаяНакладная";
		ИмяТЧДанныеОтборов = "ДанныеОтборовРасходнаяНакладная";
	Иначе
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	КонецЕсли;

	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя, ИмяРеквизитаСписка, ИмяТЧДанныеМеток,
		ИмяТЧДанныеОтборов);

КонецПроцедуры
&НаКлиенте
Процедура СброситьВсеОтборы(Команда)

	ИмяМетки = СтрЗаменить(ЭтаФорма.ТекущийЭлемент.Имя, "СброситьВсеОтборы", "");
	ИмяРеквизитаСписка = "Список" + ИмяМетки;
	ИмяТЧДанныеМеток = "ДанныеМеток" + ИмяМетки;
	ИмяТЧДанныеОтборов = "ДанныеОтборов" + ИмяМетки;

	СтруктураИменПредставленияПериода = СтруктураИменПредставленияПериода();

	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, ИмяРеквизитаСписка, "Дата",
		СтруктураИменПредставленияПериода);
	СброситьВсеМеткиОтбораНаСервере(ИмяРеквизитаСписка, ИмяТЧДанныеМеток, СтруктураИменПредставленияПериода,
		ИмяТЧДанныеОтборов);
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере(ИмяРеквизитаСписка, ИмяТЧДанныеМеток, СтруктураИменПредставленияПериода,
	ИмяТЧДанныеОтборов)
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, ЭтаФорма[ИмяРеквизитаСписка], , ИмяРеквизитаСписка,
		ИмяТЧДанныеМеток, СтруктураИменПредставленияПериода, ИмяТЧДанныеОтборов);
КонецПроцедуры
&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаСервере
Функция ИмяТчДанныхМетокСервер()

	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	//
	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда
		Возврат "ДанныеМетокОтчетПереработчика"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЗаказов" Тогда
		Возврат "ДанныеМетокЗаказов"
	ИначеЕсли
	ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат "ДанныеМетокРасходнаяНакладная"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЖурнал" Тогда
		Возврат "ДанныеМеток"
	КонецЕсли
	;

	Возврат "";

КонецФункции

&НаСервере
Функция ИмяПанелиМетокОтбора()
	//
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	//
	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда
		Возврат "СтраницаОтчетПереработчикаПраваяПанель"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЗаказов" Тогда
		Возврат "СтраницаЗаказовПраваяПанель"
	ИначеЕсли
	ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат "СтраницаРасходнаяНакладнаяПраваяПанель"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЖурнал" Тогда
		Возврат "ПраваяПанель"
	КонецЕсли
	;

	Возврат "";

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()

	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		СписокЗаказов.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПокупателей.ПолноеИмя());

КонецПроцедуры
&НаКлиенте
Функция ПолучитьИмяГруппыПанели()

	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда
		Возврат "СтраницаОтчетПереработчикаФильтрыНастройкиДопИнфо"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЗаказов" Тогда
		Возврат "СтраницаЗаказовФильтрыНастройкиДопИнфо"
	ИначеЕсли
	ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат "СтраницаРасходнаяНакладнаяФильтрыНастройкиДопИнфо"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЖурнал" Тогда
		Возврат "ФильтрыНастройкиИДопИнфо"
	КонецЕсли
	;

	Возврат "";

КонецФункции

&НаКлиенте
Функция ИмяСписка()

	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда
		Возврат "СписокОтчетПереработчика"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЗаказов" Тогда
		Возврат "СписокЗаказов"
	ИначеЕсли
	ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат "СписокРасходнаяНакладная"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЖурнал" Тогда
		Возврат "Список"
	КонецЕсли
	;

	Возврат "";

КонецФункции

&НаСервере
Функция ИмяСпискаСервер()

	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда
		Возврат "СписокОтчетПереработчика"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЗаказов" Тогда
		Возврат "СписокЗаказов"
	ИначеЕсли
	ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат "СписокРасходнаяНакладная"
	ИначеЕсли
	ИмяСтраницы = "СтраницаЖурнал" Тогда
		Возврат "Список"
	КонецЕсли
	;

	Возврат "";

КонецФункции

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазвернутьОтборыНажатие(Элемент)
	РазвернутьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("ДокументОснование", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьПодменюПодсистемыПечати();
	
	// КомандыПечатиЗаказов
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СтраницаЗаказовПодменюКоммерческоеПредложение", "Видимость", ОбщегоНазначенияУНФ.ЭтоУНФ());
	// Конец КомандыПечатиЗаказов
	
		
	// УНФ.ОтборыСписка
	ОпределитьПорядокПредопределенныхОтборовНаСервере();
	ВосстановитьОтборыСписковПриСозданииНаСервере();

	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		СписокЗаказов.КомпоновщикНастроек.Настройки.УсловноеОформление);

	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	СписокЗаказов.Параметры.УстановитьЗначениеПараметра("АктуальнаяДатаСеанса", НачалоДня(ТекущаяДатаСеанса()));

	УстановитьФорматДатыСписковПриСозданииНаСервере();
	УстановитьПанелиКонтактнойИнформацииПриСозданииНаСервере();

КонецПроцедуры



&НаСервере
Процедура УстановитьПанелиКонтактнойИнформацииПриСозданииНаСервере() 
	// УНФ.ПанельКонтактнойИнформации                   
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформацияОтчетПереработчика",
		"СписокОтчетПереработчикаКонтекстноеМеню");
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформацияЗаказов",
		"СписокЗаказовКонтекстноеМеню");
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформацияЖурнал",
		"СписокКонтекстноеМеню");
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформацияРасходнаяНакладная",
		"СписокРасходнаяНакладнаяКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации 
КонецПроцедуры

&НаСервере
Процедура УстановитьФорматДатыСписковПриСозданииНаСервере()

	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокЗаказов);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокОтчетПереработчика);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокРасходнаяНакладная);

КонецПроцедуры

&НаСервере
Процедура УстановитьПодменюПодсистемыПечати()

	УстановитьПодменюПодсистемыПечатиЖурнала();

	Массив = Новый Массив;
	Массив.Добавить(Тип("ДокументСсылка.ОтчетПереработчика"));

	ТипИсточника = Новый ОписаниеТипов(Массив);

	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();

	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКомандыСтраницаОтчетПереработчика;
	ПараметрыРазмещения.ПрефиксГрупп = "ОтчетПереработчика";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);

	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ОтчетПереработчикаПодменюПечать);

	Массив.Очистить();
	Массив.Добавить(Тип("ДокументСсылка.РасходнаяНакладная"));

	ТипИсточника = Новый ОписаниеТипов(Массив);

	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКомандыСтраницаРасходнаяНакладная;
	ПараметрыРазмещения.ПрефиксГрупп = "СтраницаРасходнаяНакладная";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);

	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.СтраницаРасходнаяНакладнаяПодменюПечать);
	
	Элементы.Переместить(Элементы.СтраницаРасходнаяНакладнаяПодменюПечатьФаксимиле,Элементы.СтраницаРасходнаяНакладнаяПодменюПечать);
	
	Массив.Очистить();
	Массив.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));

	ТипИсточника = Новый ОписаниеТипов(Массив);

	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКомандыСтраницаЗаказов;
	ПараметрыРазмещения.ПрефиксГрупп = "Заказов";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);

	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ЗаказовПодменюПечать);

КонецПроцедуры
&НаСервере
Процедура УстановитьПодменюПодсистемыПечатиЖурнала()

	Массив = Новый Массив;
	Массив.Добавить(Тип("ДокументСсылка.РасходнаяНакладная"));

	ТипИсточника = Новый ОписаниеТипов(Массив);

	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();

	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПараметрыРазмещения.ПрефиксГрупп = "ПН";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);

	Массив.Очистить();
	Массив.Добавить(Тип("ДокументСсылка.ОтчетПереработчика"));

	ТипИсточника = Новый ОписаниеТипов(Массив);

	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПараметрыРазмещения.ПрефиксГрупп = "ООП";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);

	Массив.Очистить();
	Массив.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));

	ТипИсточника = Новый ОписаниеТипов(Массив);

	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПараметрыРазмещения.ПрефиксГрупп = "ЗП";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);

	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПНПодменюПечать);
КонецПроцедуры

&НаСервере
Процедура ВосстановитьОтборыСписковПриСозданииНаСервере()

	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список, "Список");

	СтруктураИменЭлементов = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель, ОтборПериод, ПредставлениеПериода");

	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаОтчетПереработчикаФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаОтчетПереработчикаДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаОтчетПереработчикаПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодОтчетПереработчика";
	СтруктураИменЭлементов.ПредставлениеПериода = "ПредставлениеПериодаОтчетПереработчика";

	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, СписокОтчетПереработчика, "СписокОтчетПереработчика",
		СтруктураИменЭлементов, , , , "ДанныеМетокОтчетПереработчика", , "ДанныеОтборовОтчетПереработчика",
		"ГруппаОтборыОтчетПереработчика");

	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаЗаказовФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаЗаказовДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаЗаказовПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодЗаказов";
	СтруктураИменЭлементов.ПредставлениеПериода = "ПредставлениеПериодаЗаказов";

	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, СписокЗаказов, "СписокЗаказов", СтруктураИменЭлементов, , ,
		, "ДанныеМетокЗаказов", , "ДанныеОтборовЗаказов", "ГруппаОтборыЗаказов");

	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаРасходнаяНакладнаяФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаРасходнаяНакладнаяДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаРасходнаяНакладнаяПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодРасходнаяНакладная";
	СтруктураИменЭлементов.ПредставлениеПериода = "ПредставлениеПериодаРасходнаяНакладная";

	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, СписокРасходнаяНакладная, "СписокРасходнаяНакладная",
		СтруктураИменЭлементов, , , , "ДанныеМетокРасходнаяНакладная", , "ДанныеОтборовРасходнаяНакладная",
		"ГруппаОтборыРасходнаяНакладная");

КонецПроцедуры

Процедура ОпределитьПорядокПредопределенныхОтборовНаСервере()

	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект, "ГруппаОтборыОтчетПереработчика",
		"ПредопределенныеОтборыПоУмолчаниюОтчетПереработчика");
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект, "ГруппаОтборыЗаказПокупателю",
		"ПредопределенныеОтборыПоУмолчаниюЗаказов");
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект, "ГруппаОтборыРасходнаяНакладная",
		"ПредопределенныеОтборыПоУмолчаниюРасходнаяНакладная");

КонецПроцедуры
&НаКлиенте
Процедура СвернутьОтборыНажатие(Элемент)
	СвернутьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура СвернутьОтборы()
	ИмяГруппы = ПолучитьИмяГруппыПанели();
	НовоеЗначениеВидимость = Не Элементы[ИмяГруппы].Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость,
		СтруктураИменЭлементовПанелиОтборов());
КонецПроцедуры

&НаКлиенте
Функция СтруктураИменЭлементовПанелиОтборов()

	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	СтруктураИменПолей = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель");

	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда

		СтруктураИменПолей.ФильтрыНастройкиИДопИнфо = "СтраницаОтчетПереработчикаФильтрыНастройкиДопИнфо";
		СтруктураИменПолей.ДекорацияРазвернутьОтборы = "СтраницаОтчетПереработчикаДекорацияРазвернутьОтборы";
		СтруктураИменПолей.ПраваяПанель = "СтраницаОтчетПереработчикаПраваяПанель";

		Возврат СтруктураИменПолей;

	ИначеЕсли ИмяСтраницы = "СтраницаЗаказов" Тогда

		СтруктураИменПолей.ФильтрыНастройкиИДопИнфо = "СтраницаЗаказовФильтрыНастройкиДопИнфо";
		СтруктураИменПолей.ДекорацияРазвернутьОтборы = "СтраницаЗаказовДекорацияРазвернутьОтборы";
		СтруктураИменПолей.ПраваяПанель = "СтраницаЗаказовПраваяПанель";

		Возврат СтруктураИменПолей;

	ИначеЕсли ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда

		СтруктураИменПолей.ФильтрыНастройкиИДопИнфо = "СтраницаРасходнаяНакладнаяФильтрыНастройкиДопИнфо";
		СтруктураИменПолей.ДекорацияРазвернутьОтборы = "СтраницаРасходнаяНакладнаяДекорацияРазвернутьОтборы";
		СтруктураИменПолей.ПраваяПанель = "СтраницаРасходнаяНакладнаяПраваяПанель";

		Возврат СтруктураИменПолей;

	ИначеЕсли ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда

		СтруктураИменПолей.ФильтрыНастройкиИДопИнфо = "СтраницаРасходнаяНакладнаяФильтрыНастройкиДопИнфо";
		СтруктураИменПолей.ДекорацияРазвернутьОтборы = "СтраницаРасходнаяНакладнаяДекорацияРазвернутьОтборы";
		СтруктураИменПолей.ПраваяПанель = "СтраницаРасходнаяНакладнаяПраваяПанель";

		Возврат СтруктураИменПолей;

	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда

		Возврат Неопределено;

	КонецЕсли;

	Возврат СтруктураИменПолей;

КонецФункции

&НаКлиенте
Функция СтруктураИменПредставленияПериода()

	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;

	Если ИмяСтраницы = "СтраницаОтчетПереработчика" Тогда
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериодОтчетПереработчика",
			"ПредставлениеПериодаОтчетПереработчика");
	ИначеЕсли ИмяСтраницы = "СтраницаЗаказов" Тогда
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериодЗаказов",
			"ПредставлениеПериодаЗаказов");
	ИначеЕсли ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериодРасходнаяНакладная",
			"ПредставлениеПериодаРасходнаяНакладная");
	ИначеЕсли ИмяСтраницы = "СтраницаРасходнаяНакладная" Тогда
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериодРасходнаяНакладная",
			"ПредставлениеПериодаРасходнаяНакладная");
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериод", "ПредставлениеПериода");
	КонецЕсли;

	Возврат Новый Структура("ОтборПериод, ПредставлениеПериода");

КонецФункции

&НаКлиенте
Процедура СписокОтчетПереработчикаПриАктивизацииСтроки(Элемент)
	КонтактнаяИнформацияПанельУНФКлиент.ПриАктивизацииДинамическогоСписка(ЭтотОбъект, Элемент, ТекущийКонтрагент,
		"Контрагент");

КонецПроцедуры
#КонецОбласти

#Область ПанельКонтактнойИнформации

&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()

	ОбновитьПанельКонтактнойИнформации();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПанельКонтактнойИнформации()

	ДанныеПанелиКИ = ДанныеПанелиКонтактнойИнформации(ТекущийКонтрагент);
	КонтактнаяИнформацияПанельУНФКлиент.ЗаполнитьДанныеПанелиКИ(ЭтотОбъект, ДанныеПанелиКИ);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПанелиКонтактнойИнформации(Контрагент)

	Возврат КонтактнаяИнформацияПанельУНФ.ДанныеПанелиКонтактнойИнформации(Контрагент);

КонецФункции

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока,
		Поле, СтандартнаяОбработка);

КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)

	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);

КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)

	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийКонтрагент);

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СтраницаОтчетПереработчикаПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	ПолучитьПредставлениеПериода(СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СтраницаЗаказПокупателяПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	ПолучитьПредставлениеПериода(СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СтраницаРасходнаяНакладнаяПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	ПолучитьПредставлениеПериода(СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	ПолучитьПредставлениеПериода(СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПредставлениеПериода(СтандартнаяОбработка)
	ИмяСписка = ИмяСпискаСервер();
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, ИмяСписка, "Дата",
		СтруктураИменПредставленияПериода());
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаказовПриАктивизацииСтроки(Элемент)
	КонтактнаяИнформацияПанельУНФКлиент.ПриАктивизацииДинамическогоСписка(ЭтотОбъект, Элемент, ТекущийКонтрагент,
		"Контрагент");
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ИмяТекущегоСписка = ИмяСписка();
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы[ИмяТекущегоСписка]);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ИмяТекущегоСписка = ИмяСпискаСервер();
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы[ИмяТекущегоСписка], Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ИмяТекущегоСписка = ИмяСписка();
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы[ИмяТекущегоСписка]);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Если Копирование Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;

	Отказ = Истина;

	СтруктураПараметров = Новый Структура;
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Контрагент");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");

	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);

	ВидОперации = Неопределено;

	Если ИмяФормыСтрока = "ЗаказПоставщику" Тогда
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПоставщику.ЗаказНаПереработку");
	ИначеЕсли ИмяФормыСтрока = "РасходнаяНакладная" Тогда
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаВПереработку");
	КонецЕсли;

	СтруктураПараметров.Вставить("ВидОперации", ВидОперации);

	ОткрытьФорму("Документ." + ИмяФормыСтрока + ".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",
		СтруктураПараметров));
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти