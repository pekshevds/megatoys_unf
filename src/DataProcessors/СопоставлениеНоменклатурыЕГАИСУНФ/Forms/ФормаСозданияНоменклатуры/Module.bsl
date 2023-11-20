
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСпискаАлкогольнойПродукции = "";
	Параметры.Свойство("АдресСпискаАлкогольнойПродукции", АдресСпискаАлкогольнойПродукции);
	
	МассивЭлементов = ПолучитьИзВременногоХранилища(АдресСпискаАлкогольнойПродукции);
	Если ТипЗнч(МассивЭлементов) <> Тип("Массив") Тогда
		ВызватьИсключение НСтр("ru = 'В форму создания номенклатуры переданы некорректные параметры.'");
	КонецЕсли;
	
	СоответствиеНоменклатуры = ПолучитьСоответствиеНоменклатуры(МассивЭлементов);
	
	Для каждого АлкогольнаяПродукция Из МассивЭлементов Цикл
	
		Если СоответствиеНоменклатуры.Получить(АлкогольнаяПродукция) = Неопределено Тогда
			СписокАлкогольнойПродукции.Добавить(АлкогольнаяПродукция);
		КонецЕсли;
	
	КонецЦикла;
	
	Если СписокАлкогольнойПродукции.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТекстПроизводителя();
	
	Если Параметры.Свойство("УникальныйИдентификаторФормыВладельца") Тогда
	
		УникальныйИдентификаторФормыВладельца = Параметры.УникальныйИдентификаторФормыВладельца;
	
	КонецЕсли;
	
	ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.шт;
	ВидСтавкиНДС = Перечисления.ВидыСтавокНДС.Общая;
	
	Элементы.ВидСтавкиНДС.РежимВыбораИзСписка = Истина;
	Элементы.ВидСтавкиНДС.СписокВыбора.Очистить();
	СоответствиеСтавок = Справочники.СтавкиНДС.СоответствиеСтавокНДС(ТекущаяДатаСеанса());
	Для Каждого ЗначениеСоответствия Из СоответствиеСтавок Цикл
		Если ЗначениеЗаполнено(ЗначениеСоответствия.Значение) Тогда
			Элементы.ВидСтавкиНДС.СписокВыбора.Добавить(ЗначениеСоответствия.Ключ,
			Строка(ЗначениеСоответствия.Значение));
		КонецЕсли;
	КонецЦикла;
	
	ЗаголовокКоманды = НСтр("ru = 'Создать номенклатуру (%КоличествоЭлементов%)'");
	Элементы.ФормаСоздатьНоменклатуру.Заголовок = СтрЗаменить(ЗаголовокКоманды, "%КоличествоЭлементов%", СписокАлкогольнойПродукции.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаборЕдиницИзмеренияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(НаборЕдиницИзмерения) Тогда
		НаборЕдиницИзмеренияПриИзмененииНаСервере();
	КонецЕсли;
	
	Элементы.ЕдиницаИзмерения.ТолькоПросмотр = ЗначениеЗаполнено(НаборЕдиницИзмерения);
	
КонецПроцедуры

&НаСервере
Процедура НаборЕдиницИзмеренияПриИзмененииНаСервере()
	ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НаборЕдиницИзмерения, "ЕдиницаИзмерения");
КонецПроцедуры

&НаКлиенте
Процедура ТекстПроизводительНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьФормуПроизводителя", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Если НЕ ЗначениеЗаполнено(Производитель) Тогда
		ПараметрыФормы.Вставить("Отбор", Новый Структура);
		ПараметрыФормы.Отбор.Вставить("Ссылка", ПроизводительЕГАИС);
		
		ОткрытьФорму("Справочник.КлассификаторОрганизацийЕГАИС.ФормаСписка", ПараметрыФормы,,,,, ОбработчикОповещения, Режим);
	Иначе
		ПараметрыФормы.Вставить("Ключ", ПроизводительЕГАИС);
		ОткрытьФорму("Справочник.КлассификаторОрганизацийЕГАИС.ФормаОбъекта", ПараметрыФормы,,,,, ОбработчикОповещения, Режим);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСозданияНоменклатуры = Новый Структура;
	ПараметрыСозданияНоменклатуры.Вставить("Родитель",              Родитель);
	ПараметрыСозданияНоменклатуры.Вставить("КатегорияНоменклатуры", КатегорияНоменклатуры);
	ПараметрыСозданияНоменклатуры.Вставить("НаборЕдиницИзмерения",  НаборЕдиницИзмерения);
	ПараметрыСозданияНоменклатуры.Вставить("ЕдиницаИзмерения",      ЕдиницаИзмерения);
	ПараметрыСозданияНоменклатуры.Вставить("ВидСтавкиНДС",          ВидСтавкиНДС);
	ПараметрыСозданияНоменклатуры.Вставить("СтранаПроисхождения",   СтранаПроисхождения);
	ПараметрыСозданияНоменклатуры.Вставить("МассивЭлементов",       СписокАлкогольнойПродукции.ВыгрузитьЗначения());
	ПараметрыСозданияНоменклатуры.Вставить("ТипНоменклатуры",       ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	ПараметрыСозданияНоменклатуры.Вставить("УникальныйИдентификаторФормыВладельца"     , УникальныйИдентификаторФормыВладельца);
	
	Закрыть(ПараметрыСозданияНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеОткрытьФормуПроизводителя(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьТекстПроизводителя();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСоответствиеНоменклатуры(МассивАлкогольнойПродукции)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивАлкогольнойПродукции", МассивАлкогольнойПродукции);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|ГДЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция В(&МассивАлкогольнойПродукции)";
	
	СоответствиеНоменклатуры = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеНоменклатуры.Вставить(Выборка.АлкогольнаяПродукция, Выборка.Номенклатура);
	КонецЦикла;
	
	Возврат СоответствиеНоменклатуры;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТекстПроизводителя()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокАлкогольнойПродукции", СписокАлкогольнойПродукции);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Производитель КАК Производитель
	|ИЗ
	|	Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|ГДЕ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка В(&СписокАлкогольнойПродукции)";
	
	Результат = Запрос.Выполнить();
	
	МассивПроизводителей = Новый Массив;
	МассивПроизводителей = Результат.Выгрузить().ВыгрузитьКолонку("Производитель");
	
	Если МассивПроизводителей.Количество() > 1 ИЛИ МассивПроизводителей.Количество() = 0 Тогда
		ТекстПроизводитель = "";
		Производитель = Справочники.Контрагенты.ПустаяСсылка();
	Иначе
		ПроизводительЕГАИС = МассивПроизводителей[0];
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка,
		|	КлассификаторОрганизацийЕГАИС.Контрагент КАК Контрагент,
		|	КлассификаторОрганизацийЕГАИС.Контрагент.Наименование КАК Наименование
		|ИЗ
		|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
		|ГДЕ
		|	КлассификаторОрганизацийЕГАИС.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ПроизводительЕГАИС);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Производитель = Выборка.Контрагент;
		Иначе
			Производитель = Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Производитель) Тогда
			ТекстПроизводитель = НСтр("ru = 'Производитель:'") + " " + Выборка.Наименование
		Иначе
			ТекстПроизводитель = НСтр("ru = 'Ввести соответствие для производителя'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КатегорияНоменклатурыПриИзмененииНаСервере()
	
	ДанныеКатегории = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КатегорияНоменклатуры,
		"ЕдиницаИзмерения, ВидСтавкиНДС, СтранаПроисхождения");
	
	Для Каждого РеквизитКатегории Из ДанныеКатегории Цикл
		Если ЗначениеЗаполнено(РеквизитКатегории.Значение) Тогда
			ЭтотОбъект[РеквизитКатегории.Ключ] = РеквизитКатегории.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КатегорияНоменклатурыПриИзменении(Элемент)
	Если ЗначениеЗаполнено(КатегорияНоменклатуры) Тогда
		КатегорияНоменклатурыПриИзмененииНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
