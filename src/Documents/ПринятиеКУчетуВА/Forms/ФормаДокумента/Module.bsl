
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаДокумента = Объект.Дата;
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Компания = Константы.УчетПоКомпании.Компания(Объект.Организация);
	
	Элементы.Ячейка.Видимость = НЕ Объект.СтруктурнаяЕдиница.ОрдерныйСклад;
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделение");
	ОсновноеПодразделение = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура",Объект.Номенклатура);
	СтруктураДанные.Вставить("Характеристика",Объект.Характеристика);
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	ИспользоватьХарактеристики = СтруктураДанные.ИспользоватьХарактеристики;
	ПроверятьЗаполнениеХарактеристики = СтруктураДанные.ПроверятьЗаполнениеХарактеристики;
	
	//Партии
	ИспользоватьПартии = СтруктураДанные.ИспользоватьПартии;
	ПроверятьЗаполнениеПартий = СтруктураДанные.ПроверятьЗаполнениеПартий;
	// Конец Партии
	
	УстановитьУсловноеОформлениеФормы();
	
	МобильныйКлиентУНФ.НастроитьФормуОбъектаМобильныйКлиент(Элементы, "ВнеоборотныеАктивы");
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УчетОстатковПоСкладскимОрдерам = УчетОстатковВРазрезеСкладскихОрдеров();
	КонецЕсли;
	ПриИзмененииВидаУчетаСклада(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура",Объект.Номенклатура);
	СтруктураДанные.Вставить("Характеристика",Объект.Характеристика);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	ПроверятьЗаполнениеХарактеристики = СтруктураДанные.ПроверятьЗаполнениеХарактеристики;
	ИспользоватьХарактеристики = СтруктураДанные.ИспользоватьХарактеристики;
	
	УчетОстатковПоСкладскимОрдерам = УчетОстатковВРазрезеСкладскихОрдеров();
	ПриИзмененииВидаУчетаСклада(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	Оповестить("ОбновлениеСостоянийВнеоборотныхАктивов");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	ДанныеДляИзмененияДаты = ДокументыУНФКлиент.ДанныеДляИзмененияДаты(ЭтотОбъект, Объект);
	Если ДанныеДляИзмененияДаты.ДатаНеМенялась Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты);
	
КонецПроцедуры

// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура",Объект.Номенклатура);
	СтруктураДанные.Вставить("Характеристика",Объект.Характеристика);
	
	СтатусПартии = Новый СписокЗначений;
	СтатусПартии.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПартий.СобственныеЗапасы"));
	
	СтруктураДанные.Вставить("СтатусПартии", СтатусПартии);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	Объект.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	
	Элементы.Характеристика.Доступность = СтруктураДанные.ИспользоватьХарактеристики;
	
	Если ЗначениеЗаполнено(Объект.Характеристика) И Не СтруктураДанные.ИспользоватьХарактеристики
		Тогда
		Объект.Характеристика = Неопределено;
	КонецЕсли;
	
	Объект.Характеристика = СтруктураДанные.Характеристика;
	ПроверятьЗаполнениеХарактеристики = СтруктураДанные.ПроверятьЗаполнениеХарактеристики;
	ИспользоватьХарактеристики = СтруктураДанные.ИспользоватьХарактеристики;
	
	//Партии
	ИспользоватьПартии = СтруктураДанные.ИспользоватьПартии;
	ПроверятьЗаполнениеПартий = СтруктураДанные.ПроверятьЗаполнениеПартий;
	
	Элементы.Партия.Доступность = СтруктураДанные.ИспользоватьПартии;
	
	Если СтруктураДанные.ИспользоватьПартии
		Тогда
		Объект.Партия = СтруктураДанные.Партия;
	Иначе
		Объект.Партия = Неопределено;
	КонецЕсли;
	// Конец Партии
	
КонецПроцедуры // НоменклатураПриИзменении()

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	УстановитьВидимостьЯчейки("Ячейка", Объект.СтруктурнаяЕдиница);
	
	Объект.ДокументПоступления = Неопределено;
	УчетОстатковПоСкладскимОрдерам = УчетОстатковВРазрезеСкладскихОрдеров();
	ПриИзмененииВидаУчетаСклада(ЭтотОбъект);
	
КонецПроцедуры // СтруктурнаяЕдиницаПриИзменении()

&НаКлиенте
Процедура ДокументПоступленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураОткрытия = Новый Структура;
	СтруктураОткрытия.Вставить("Организация", Объект.Организация);
	СтруктураОткрытия.Вставить("ТолькоПоДокументам", Истина);
	СтруктураОткрытия.Вставить("СтруктурнаяЕдиница", Объект.СтруктурнаяЕдиница);
	СтруктураОткрытия.Вставить("ТолькоПоОрдерам", Истина);
	СтруктураОткрытия.Вставить("КПоступлению", Ложь);
	
	ОткрытьФорму("ОбщаяФорма.ПодборПоОстаткамТоваровКПоступлениюРеализации", СтруктураОткрытия, Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВнеоборотныеАктивы

&НаКлиенте
Процедура ВнеоборотныеАктивыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
 
		СтрокаТабличнойЧасти = Элементы.ВнеоборотныеАктивы.ТекущиеДанные;
		СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновноеПодразделение;
		
	КонецЕсли;
	
КонецПроцедуры // ВнеоборотныеАктивыПриНачалеРедактирования()

&НаКлиенте
Процедура ВнеоборотныеАктивыОбъемПродукцииРаботДляВычисленияАмортизацииПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ВнеоборотныеАктивы.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеВнеоборотныйАктив(СтрокаТабличнойЧасти.ВнеоборотныйАктив);
	
	Если НЕ СтруктураДанные.СпособАмортизацииПропорциональноОбъемуПродукции Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru = '""Объем продукции (работ) для исчисления амортизации"" не может быть заполнен для указанного способа начисления амортизации!'"));
		СтрокаТабличнойЧасти.ОбъемПродукцииРаботДляВычисленияАмортизации = 0;
	КонецЕсли;
	
КонецПроцедуры // ВнеоборотныеАктивыОбъемПродукцииРаботДляВычисленияАмортизацииПриИзменении()

&НаКлиенте
Процедура ВнеоборотныеАктивыСрокИспользованияДляВычисленияАмортизацииПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ВнеоборотныеАктивы.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеВнеоборотныйАктив(СтрокаТабличнойЧасти.ВнеоборотныйАктив);
	
	Если СтруктураДанные.СпособАмортизацииПропорциональноОбъемуПродукции Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru = '""Срок использования для вычисления амортизации"" не может быть заполнен для указанного способа начисления амортизации!'"));
		СтрокаТабличнойЧасти.СрокИспользованияДляВычисленияАмортизации = 0;
	КонецЕсли;
	
КонецПроцедуры // ВнеоборотныеАктивыСрокИспользованияДляВычисленияАмортизацииПриИзменении()

&НаКлиенте
Процедура ВнеоборотныеАктивыВнеоборотныйАктивПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ВнеоборотныеАктивы.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеВнеоборотныйАктив(СтрокаТабличнойЧасти.ВнеоборотныйАктив);
	
	Если СтруктураДанные.СпособАмортизацииПропорциональноОбъемуПродукции Тогда
		СтрокаТабличнойЧасти.СрокИспользованияДляВычисленияАмортизации = 0;
	Иначе
		СтрокаТабличнойЧасти.ОбъемПродукцииРаботДляВычисленияАмортизации = 0;
	КонецЕсли;
	
КонецПроцедуры // ВнеоборотныеАктивыВнеоборотныйАктивПриИзменении()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВидаУчетаСклада(Форма)
	
	Если ЗначениеЗаполнено(Форма.Объект.СтруктурнаяЕдиница) Тогда
		Форма.Элементы.ДокументПоступления.Видимость = Форма.УчетОстатковПоСкладскимОрдерам;
	Иначе
		Форма.Элементы.ДокументПоступления.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УчетОстатковВРазрезеСкладскихОрдеров()
	Возврат СкладскойУчетСервер.УчетОстатковВРазрезеСкладскихОрдеров(Объект.СтруктурнаяЕдиница, Ложь);
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформление.Элементы.Очистить();
	
	
	ИмяПоляПроверятьЗаполнениеХарактеристики = "ПроверятьЗаполнениеХарактеристики";
	ИмяПоляИспользоватьХарактеристики = "ИспользоватьХарактеристики";
	ИмяПоляХарактеристики = "Характеристика";
	
	НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяПоляИспользоватьХарактеристики, Ложь, ВидСравненияКомпоновкиДанных.Равно);
	
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляХарактеристики);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", НСтр("ru = '<Не используется>'"));
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ТолькоПросмотр", Истина);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти);
	
	НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяПоляПроверятьЗаполнениеХарактеристики, Истина, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляХарактеристики);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ОтметкаНезаполненного", Истина);
	
	НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор,"Объект.Характеристика", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка(), ВидСравненияКомпоновкиДанных.НеРавно);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляХарактеристики);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ОтметкаНезаполненного", Ложь);
	
	ИмяПоляПроверятьЗаполнениеПартии = "ПроверятьЗаполнениеПартий";
	ИмяПоляИспользоватьПартии = "ИспользоватьПартии";
	ИмяПоляПартии = "Партия";
	
	НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяПоляИспользоватьПартии, Ложь, ВидСравненияКомпоновкиДанных.Равно);
	
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляПартии);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", НСтр("ru = '<Не используется>'"));
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ТолькоПросмотр", Истина);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти);
	
	НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяПоляПроверятьЗаполнениеПартии, Истина, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляПартии);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ОтметкаНезаполненного", Истина);
	
	НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор,"Объект.Партия", Справочники.ПартииНоменклатуры.ПустаяСсылка(), ВидСравненияКомпоновкиДанных.НеРавно);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляПартии);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ОтметкаНезаполненного", Ложь);

	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЯчейки(ИмяЯчейки, Склад)
	
	Элементы[ИмяЯчейки].Видимость = НЕ Склад.ОрдерныйСклад;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты)
	
	ДокументыУНФ.ДатаПриИзменении(ДанныеДляИзмененияДаты, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ДокументыУНФ.ОрганизацияПриИзменении(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	СтруктураДанные.Вставить("ИспользоватьХарактеристики", СтруктураДанные.Номенклатура.ИспользоватьХарактеристики);
	СтруктураДанные.Вставить("ПроверятьЗаполнениеХарактеристики", СтруктураДанные.Номенклатура.ПроверятьЗаполнениеХарактеристики);
	
	Если ЗначениеЗаполнено(СтруктураДанные.Номенклатура) И СтруктураДанные.Номенклатура.ИспользоватьХарактеристики
		Тогда
		ЗначенияПоУмолчанию = НоменклатураВДокументахСервер.ЗначенияНоменклатурыПоУмолчанию(СтруктураДанные.Номенклатура);
		
		Если Не ЗначенияПоУмолчанию = Неопределено
			Тогда
			ХарактеристикаПоУмолчанию = ЗначенияПоУмолчанию;
		КонецЕсли;
		
		Если НЕ СтруктураДанные.Свойство("Характеристика") Тогда
			СтруктураДанные.Вставить("Характеристика",ХарактеристикаПоУмолчанию);
		Иначе
			СтруктураДанные.Характеристика = ?(ЗначениеЗаполнено(СтруктураДанные.Характеристика), СтруктураДанные.Характеристика, ХарактеристикаПоУмолчанию);
		КонецЕсли;
	КонецЕсли; 
	
	//Партии
	СтруктураДанные.Вставить("ИспользоватьПартии",Ложь);
	СтруктураДанные.Вставить("ПроверятьЗаполнениеПартий",Ложь);
	
	Если НЕ СтруктураДанные.Свойство("Партия") Тогда
		СтруктураДанные.Вставить("Партия", Неопределено);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураДанные.Номенклатура) И СтруктураДанные.Номенклатура.ИспользоватьПартии
		Тогда
		
		Если СтруктураДанные.Свойство("СтатусПартии")
			Тогда
			ЗначенияПартииПоУмолчанию = НоменклатураВДокументахСервер.ЗначенияПартийНоменклатурыПоУмолчанию(СтруктураДанные.Номенклатура,СтруктураДанные.СтатусПартии);
		Иначе
			Если Не СтруктураДанные.Свойство("ВидОперации")
				Тогда
				ВидОперации = Неопределено
			Иначе
				ВидОперации = СтруктураДанные.ВидОперации
			КонецЕсли;
			
			СтатусПартии = НоменклатураВДокументахСервер.СоответствиеВидаОперацииИлиХозОперацииСтатусуПартии(, ВидОперации);
			ЗначенияПартииПоУмолчанию = НоменклатураВДокументахСервер.ЗначенияПартийНоменклатурыПоУмолчанию(СтруктураДанные.Номенклатура,СтатусПартии);
		КонецЕсли;
		
		ПартияПоУмолчанию = Справочники.ПартииНоменклатуры.ПустаяСсылка();
		
		Если Не ЗначенияПартииПоУмолчанию = Неопределено
			Тогда
			ПартияПоУмолчанию = ЗначенияПартииПоУмолчанию;
		КонецЕсли;
		
		СтруктураДанные.Партия = ?(ЗначениеЗаполнено(СтруктураДанные.Партия), СтруктураДанные.Партия, ПартияПоУмолчанию);
		
		СтруктураДанные.ПроверятьЗаполнениеПартий = СтруктураДанные.Номенклатура.ПроверятьЗаполнениеПартий;
		СтруктураДанные.ИспользоватьПартии = Истина;
		
	КонецЕсли;
	// Конец Партии
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьДанныеВнеоборотныйАктив(ВнеоборотныйАктив)
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить("СпособАмортизацииПропорциональноОбъемуПродукции", ВнеоборотныйАктив.СпособАмортизации = Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеВнеоборотныйАктив()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
