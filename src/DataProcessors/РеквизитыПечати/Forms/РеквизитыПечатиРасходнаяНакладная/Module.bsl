#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

&НаКлиенте
Перем ПодтвержденоЗакрытиеФормы; // Для подтверждения закрытия формы пользователем

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();

	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	ИменаРеквизитов = 
		"Организация, БанковскийСчет, ВалютаДокумента, СтруктурнаяЕдиница, ОснованиеПечатиСсылка, ОснованиеПечати,
		|ПодписьРуководителя, ПодписьГлавногоБухгалтера, ПодписьКладовщика, КонтактноеЛицоПодписант,
		|Грузоотправитель, Грузополучатель, АдресДоставки, АдресДоставкиЗначение,
		|УсловияГарантийногоТалона, УсловияСчетаЗаказа,
		|ТекстУсловийГарантийногоТалона, ТекстУсловийСчетаЗаказа,
		|НомерСчетаНаОплату,
		|ДоверенностьВыдана, ДоверенностьДата, ДоверенностьЛицо, ДоверенностьНомер,
		|ОрганизацияОплачиваетПеревозку, Перевозчик, БанковскийСчетПеревозчика, СрокДоставки, Водитель, Автомобиль, Прицеп,
		|Контрагент, Договор, БанковскийСчетКонтрагента, ДокументОснование, Заказ";
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, ИменаРеквизитов);

	УстановитьВидФормы();
	ЗаголовокФормы();
	ЗаполнитьАдресДоставки();
	ЗаполнитьОснованияПечати(Параметры);
	ЗаполнитьПараметрыВыбораБанковскогоСчета();
	ЗаполнитьПодсказкиПодписей();
	УстановитьКартинкиКнопок();
	
	ГрузоотправительОнЖе = Параметры.ГрузоотправительОнЖе;
	ГрузополучательОнЖе = Параметры.ГрузополучательОнЖе;
	УстановитьОтображениеГрузоперевозки();	

	ДоступностьКомандФормы();
	
	РаботаСФормойДокумента.НастроитьВидимостьГруппыИнформации(ЭтотОбъект, "ГруппаИнформацияПоНовымРеквизитам",
						"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", "ФормыОбработкиРеквизитыПечати");	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьЗаголовокСвернутойГруппы();
	
	МассивИзмененныхРеквизитов = Новый Массив;

	ПодтвержденоЗакрытиеФормы = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ ЗавершениеРаботы И НЕ ПодтвержденоЗакрытиеФормы Тогда
		
		Отказ = Истина;
        ОписаниеОповещенияОЗавершении    = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);                
        ТекстВопроса        = НСтр("ru = 'Выполненные изменения будут отменены. Продолжить?'");                
        ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет); 		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
    
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ПодтвержденоЗакрытиеФормы = Истина;
               
    Закрыть();
    
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОснованиеПечатиСсылкаПриИзменении(Элемент)
	
	КонтекстПечати.ОснованиеПечати = Элементы.ОснованиеПечатиСсылка.ТекстРедактирования;
	ИзменитьЗаголовокСвернутойГруппы();
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечати");
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечатиСсылка");
	
	Элементы.ОснованиеПечати.Заголовок = НСтр("ru='Текст основания'");	
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПечатиПриИзменении(Элемент)
	
	ИзменитьЗаголовокСвернутойГруппы();

	ТекстПоУмолчанию = ТекстОснованияПоУмолчанию(КонтекстПечати.ОснованиеПечатиСсылка);
	Если КонтекстПечати.ОснованиеПечати = ТекстПоУмолчанию Тогда
		Элементы.ОснованиеПечати.Заголовок = НСтр("ru='Текст основания'");
	Иначе
		Элементы.ОснованиеПечати.Заголовок = НСтр("ru='Измененный текст'");
	КонецЕсли;
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьРуководителяПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьГлавногоБухгалтераПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();

КонецПроцедуры

&НаКлиенте
Процедура ПодписьКладовщикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();

КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоПодписантПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительОнЖеПриИзменении(Элемент)

	Элементы.Грузоотправитель.Видимость = НЕ ГрузоотправительОнЖе;
	Элементы.ГрузоотправительОрганизация.Видимость = ГрузоотправительОнЖе;
	
	Если ГрузоотправительОнЖе Тогда
		КонтекстПечати.Грузоотправитель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;

	ЗафиксироватьИзменениеЗначенияРеквизита("Грузоотправитель");

КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОнЖеПриИзменении(Элемент)

	Элементы.Грузополучатель.Видимость = НЕ ГрузополучательОнЖе;
	Элементы.ГрузополучательКонтрагент.Видимость = ГрузополучательОнЖе;

	Если ГрузополучательОнЖе Тогда
		КонтекстПечати.Грузополучатель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;

	ЗафиксироватьИзменениеЗначенияРеквизита("Грузополучатель");	

КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставки");
	
	ЗаполнитьАдресДоставки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);

	ПриИзмененииПредставленияАдреса(
	Элемент.ТекстРедактирования,
	КонтекстПечати["АдресДоставкиЗначение"]);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФормуВыбораАдресаИОбработатьРезультат(
		Элемент,
		КонтекстПечати,
		"АдресДоставки",
		СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПолучателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	КонтекстПечати.АдресДоставки = ВыбранноеЗначение.АдресДоставки;
	КонтекстПечати.АдресДоставкиЗначение = ВыбранноеЗначение.АдресДоставкиЗначение;
	КонтекстПечати.АдресДоставкиЗначенияПолей = ВыбранноеЗначение.АдресДоставкиЗначенияПолей;

	ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставки");
	ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставкиЗначение");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьНомерПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьДатаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьВыданаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьЛицоПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетКонтрагентаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияСчетаЗаказаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	КонтекстПечати.ТекстУсловийСчетаЗаказа = 
		ПолучитьТекстУсловийШаблона(КонтекстПечати.УсловияСчетаЗаказа);
	Элементы.ГруппаТекстУсловийСчета.Видимость = НЕ КонтекстПечати.УсловияСчетаЗаказа.Пустая();
	Элементы.ТекстУсловийСчетаЗаказа.Заголовок = НСтр("ru='Текст условий счета'");
	Элементы.ТекстУсловийСчетаЗаказа.Вид = ВидПоляФормы.ПолеНадписи;	
	
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияГарантийногоТалонаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	КонтекстПечати.ТекстУсловийГарантийногоТалона = 
		ПолучитьТекстУсловийШаблона(КонтекстПечати.УсловияГарантийногоТалона);
	Элементы.ГруппаТекстУсловийГарантийногоТалона.Видимость = НЕ КонтекстПечати.УсловияГарантийногоТалона.Пустая();
	Элементы.ТекстУсловийГарантийногоТалона.Заголовок = НСтр("ru='Текст условий гарантийного талона'");
	Элементы.ТекстУсловийГарантийногоТалона.Вид = ВидПоляФормы.ПолеНадписи;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстУсловийСчетаЗаказаПриИзменении(Элемент)

	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);

КонецПроцедуры

&НаКлиенте
Процедура ТекстУсловийГарантийногоТалонаПриИзменении(Элемент)

	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);

КонецПроцедуры

&НаКлиенте
Процедура НомерСчетаНаОплатуПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОплачиваетПеревозкуПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПеревозчикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДоставкиПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВодительПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеАвтомобиля(ВыбранноеЗначение);
	
	Если ЗначениеЗаполнено(КонтекстПечати.Прицеп) Тогда
		ЗафиксироватьИзменениеЗначенияРеквизита(Элементы.Прицеп.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрицепПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияПоНовойСхемеЗакрытьНажатие(Элемент)

	Элементы.ГруппаИнформацияПоНовымРеквизитам.Видимость = Ложь;	
	СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкуПечатиНомераСчета(Команда)
	
	СохранитьНастройкуПечатиНомераСчетаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьУсловияСчета(Команда)

	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ТекстУсловий", КонтекстПечати.ТекстУсловийСчетаЗаказа);
	ДопПараметры.Вставить("Условия", КонтекстПечати.УсловияСчетаЗаказа);	
	ДопПараметры.Вставить("Заголовок", НСтр("ru='Условия счета на оплату'"));
	ДопПараметры.Вставить("ИмяРеквизитаУсловий", "ТекстУсловийСчетаЗаказа");
	Оповещение = Новый ОписаниеОповещения("ПослеВводаТекстаУсловий", ЭтотОбъект, ДопПараметры);	
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РедакторУсловий", ДопПараметры, ЭтотОбъект, , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьУсловияГарантийногоТалона(Команда)

	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ТекстУсловий", КонтекстПечати.ТекстУсловийГарантийногоТалона);
	ДопПараметры.Вставить("Условия", КонтекстПечати.УсловияГарантийногоТалона);	
	ДопПараметры.Вставить("Заголовок", НСтр("ru='Условия гарантийного талона'"));
	ДопПараметры.Вставить("ИмяРеквизитаУсловий", "ТекстУсловийГарантийногоТалона");
	Оповещение = Новый ОписаниеОповещения("ПослеВводаТекстаУсловий", ЭтотОбъект, ДопПараметры);	
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РедакторУсловий", ДопПараметры, ЭтотОбъект, , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура();
	ПредыдущиеЗначения.Вставить("ПодписьРуководителя");
	ПредыдущиеЗначения.Вставить("ПодписьГлавногоБухгалтера");
	ПредыдущиеЗначения.Вставить("ПодписьКладовщика");
	ПредыдущиеЗначения.Вставить("КонтактноеЛицоПодписант");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьРуководителяНажатие(Команда)
	
    ЗаписатьНастройкуПользователя("ПодписьРуководителя", КонтекстПечати.ПодписьРуководителя);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьГлавногоБухгалтераНажатие(Команда)

	ЗаписатьНастройкуПользователя("ПодписьГлавногоБухгалтера", КонтекстПечати.ПодписьГлавногоБухгалтера);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьКладовщикаНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("ПодписьМОЛ", КонтекстПечати.ПодписьКладовщика);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВариантОплатыПеревозкиНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("ОрганизацияОплачиваетПеревозку", КонтекстПечати.ОрганизацияОплачиваетПеревозку);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьУсловияСчетаЗаказаНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("УсловияСчетаЗаказа", КонтекстПечати.УсловияСчетаЗаказа);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьУсловияГарантийногоТалонаНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("УсловияГарантии", КонтекстПечати.УсловияГарантийногоТалона);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкуПечатиНомераСчетаНажатие(Команда)
	
	СохранитьНастройкуПечатиНомераСчетаНаСервере();
	
	СтрокаЗаголовка = НСтр("ru='Сохранение настроек'");
	СтрокаТекста = НСтр("ru='Значение сохранено'");
		
	ПоказатьОповещениеПользователя(СтрокаЗаголовка, , СтрокаТекста, БиблиотекаКартинок.СохранитьФайл,
		СтатусОповещенияПользователя.Важное);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПеревозчикНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("ОсновнойПеревозчик", КонтекстПечати.Перевозчик);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВодительНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("ОсновнойВодитель", КонтекстПечати.Водитель);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьАвтомобильНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("ОсновнойАвтомобиль", КонтекстПечати.Автомобиль);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаголовокФормы()
	
	Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКомандФормы()
	
	Если НЕ ПравоДоступа("Изменение", КонтекстПечати.Ссылка.Метаданные()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ФормаВосстановитьПодписиПоУмолчанию", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ОснованиеПечати", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗаголовокСвернутойГруппы()
	
	ШаблонЗаголовка = НСтр("ru ='Основание печати: %1'");
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, КонтекстПечати.ОснованиеПечати);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОснованиеПечати", 
		"ЗаголовокСвернутогоОтображения", ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	
	ДополнитьРеквизитыТекстамиУсловий(ИзмененныеРеквизиты);
	
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	
	ПараметрыЗакрытия.Вставить("ГрузоотправительОнЖе", ГрузоотправительОнЖе);
	ПараметрыЗакрытия.Вставить("ГрузополучательОнЖе", ГрузополучательОнЖе);
	
	ПодтвержденоЗакрытиеФормы = Истина;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораАдресаДоставки(ЭлементАдреса, Владелец, ВидыКИ, МожноИзменитьПоле)
	
	МассивВладельцев = Новый Массив;
	МассивВладельцев.Добавить(Владелец);
	
	Адреса = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивВладельцев,
		,
		ВидыКИ,
		ТекущаяДатаСеанса());
	Адреса.Сортировать("Вид Возр");
	
	Для Каждого Адрес Из Адреса Цикл
		
		ЭлементАдреса.СписокВыбора.Добавить(Адрес.Представление);
		
		Если МожноИзменитьПоле
			И ПустаяСтрока(КонтекстПечати.АдресДоставки) Тогда
			
			КонтекстПечати.АдресДоставки = Адрес.Представление;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресДоставки(ОчиститьПоле = Ложь)
	
	Если ОчиститьПоле Тогда
		
		КонтекстПечати.АдресДоставки = "";
		
	КонецЕсли;
	
	Элементы.АдресДоставки.СписокВыбора.Очистить();
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента);
	
	ИсточникАдресовДоставки = ?(ЗначениеЗаполнено(КонтекстПечати.Грузополучатель), КонтекстПечати.Грузополучатель, КонтекстПечати.Контрагент);
	ЗаполнитьСписокВыбораАдресаДоставки(Элементы.АдресДоставки, ИсточникАдресовДоставки, ВидыКИ, ОчиститьПоле);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораАдресаИОбработатьРезультат(Элемент, Объект, ИмяРеквизитаАдресаДоставки, СтандартнаяОбработка = Ложь)
	
	СтандартнаяОбработка = Ложь;
	
	АдресПредставление = Объект[ИмяРеквизитаАдресаДоставки];
	АдресЗначение = Объект[ИмяРеквизитаАдресаДоставки + "Значение"];
	
	// Откроем диалог редактирования КИ
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации",
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента"));
	ПараметрыОткрытия.Вставить("Значение", АдресЗначение);
	ПараметрыОткрытия.Вставить("Представление", АдресПредставление);
	ПараметрыОткрытия.Вставить("Комментарий", Объект.ДополнительнаяИнформацияПоДоставке);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаАдресаДоставки", ИмяРеквизитаАдресаДоставки);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение", 
		ЭтотОбъект, ДополнительныеПараметры);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ИмяРеквизитаАдресаДоставки = ДополнительныеПараметры.ИмяРеквизитаАдресаДоставки;
		
	Если ТипЗнч(Результат) = Тип("Структура") Тогда // КИ введена
		
		// Перенесем данные в форму
		КонтекстПечати[ИмяРеквизитаАдресаДоставки + "Значение"] = Результат.Значение;
		КонтекстПечати[ИмяРеквизитаАдресаДоставки] = Результат.Представление;
		КонтекстПечати.ДополнительнаяИнформацияПоДоставке = Результат.Комментарий;

		ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставки");
		ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставкиЗначение");
		
		Модифицированность = Истина;
		ОбновитьОтображениеДанных();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОснованияПечати(Параметры)
	
	СписокВыбораЭлемента = Элементы.ОснованиеПечатиСсылка.СписокВыбора;
	
	Если ЗначениеЗаполнено(КонтекстПечати.Договор) Тогда
		
		СписокВыбораЭлемента.Добавить(КонтекстПечати.Договор, ПечатьДокументовУНФ.ПредставлениеОснованияПечати(КонтекстПечати.Договор));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтекстПечати.Заказ)
		И ТипЗнч(КонтекстПечати.Заказ) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		СписокВыбораЭлемента.Добавить(КонтекстПечати.Заказ, ПечатьДокументовУНФ.ПредставлениеОснованияПечати(КонтекстПечати.Заказ));
		
	КонецЕсли;
	
	Если Параметры.Свойство("НаборОснований")
		И Параметры.НаборОснований.Количество() > 0 Тогда
		
		Для каждого СтрокаМассива Из Параметры.НаборОснований Цикл
			
			СписокВыбораЭлемента.Добавить(СтрокаМассива, ПечатьДокументовУНФ.ПредставлениеОснованияПечати(СтрокаМассива));
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	ДокументОбъект = ДанныеФормыВЗначение(КонтекстПечати, Тип("ДокументОбъект.РасходнаяНакладная"));
	Обработки.РеквизитыПечати.ПодписиПоУмолчанию(ДокументОбъект);
	ЗначениеВДанныеФормы(ДокументОбъект, КонтекстПечати);
	
	КонтекстПечати.КонтактноеЛицоПодписант = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Контрагент, "КонтактноеЛицоПодписант");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВыбораБанковскогоСчета()
	
	Обработки.РеквизитыПечати.ЗаполнитьПараметрыВыбораБанковскогоСчетаОрганизации(Элементы.БанковскийСчет, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПечатиНомераСчетаНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ПравилоЗаполненияНомераСчетаНаОплату.Установить(КонтекстПечати.НомерСчетаНаОплату);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеАвтомобиля(Автомобиль)
	
	ДанныеПрицепа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Автомобиль, "ОсновнойПрицеп");
	
	Если ЗначениеЗаполнено(ДанныеПрицепа) Тогда
		КонтекстПечати.Прицеп	= ДанныеПрицепа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуПользователя(НазваниеНастройки, ЗначениеНастройки)
	
	ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки);	
	
	СтрокаЗаголовка = НСтр("ru='Сохранение настроек пользователя'");
	ШаблонСообщения = НСтр("ru='Значение сохранено для использования в новых документах %1 %2'");
	
	ПараметрОрганизация = "";
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		
		НаименованиеОрганизации = УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(
			КонтекстПечати.Организация, "Наименование");
		ПараметрОрганизация = СтрШаблон(НСтр("ru='по организации %1'"), НаименованиеОрганизации);
		
	КонецЕсли;
	
	ПараметрПользователь = СтрШаблон(НСтр("ru='пользователем %1'"), ПользователиКлиент.АвторизованныйПользователь());
	
	СтрокаТекста = СтрШаблон(ШаблонСообщения, ПараметрОрганизация, ПараметрПользователь);
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	
	ПоказатьОповещениеПользователя(СтрокаЗаголовка, , СтрокаТекста, КартинкаСохранения,
		СтатусОповещенияПользователя.Важное);
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки)

	РегистрыСведений.НастройкиПользователей.Установить(ЗначениеНастройки, НазваниеНастройки, ,
		КонтекстПечати.Организация);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриИзмененииПредставленияАдреса(Представление, АдресЗначение)
	
	Если ЗначениеЗаполнено(Представление) Тогда
		АдресЗначение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Представление, Перечисления.ТипыКонтактнойИнформации.Адрес);
	Иначе
		АдресЗначение = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодсказкиПодписей() 
	
	Если КонтекстПечати.ПодписьГлавногоБухгалтера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Организация, "ПодписьГлавногоБухгалтера") Тогда
		Элементы.ПодписьГлавногоБухгалтера.Подсказка = НСтр("ru = 'Подпись из реквизитов организации'");		
	Иначе
		Элементы.ПодписьГлавногоБухгалтера.Подсказка = НСтр("ru = 'Подпись из настроек пользователя'");
	КонецЕсли;

	Если КонтекстПечати.ПодписьРуководителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Организация, "ПодписьРуководителя") Тогда
		Элементы.ПодписьРуководителя.Подсказка = НСтр("ru = 'Подпись из реквизитов организации'");		
	Иначе
		Элементы.ПодписьРуководителя.Подсказка = НСтр("ru = 'Подпись из настроек пользователя'");
	КонецЕсли;
	
	Если КонтекстПечати.ПодписьКладовщика = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.СтруктурнаяЕдиница, "ПодписьМОЛ") Тогда
		Элементы.ПодписьКладовщика.Подсказка = НСтр("ru = 'Подпись из реквизитов структурной единицы'");		
	Иначе
		Элементы.ПодписьКладовщика.Подсказка = НСтр("ru = 'Подпись из настроек пользователя'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкиКнопок()
	
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	Элементы.СохранитьПодписьРуководителя.Картинка = КартинкаСохранения;
	Элементы.СохранитьПодписьГлавногоБухгалтера.Картинка = КартинкаСохранения;
	Элементы.СохранитьПодписьКладовщика.Картинка = КартинкаСохранения;
	Элементы.СохранитьУсловияГарантийногоТалона.Картинка = КартинкаСохранения;
	Элементы.СохранитьУсловияСчетаЗаказа.Картинка = КартинкаСохранения;
	Элементы.СохранитьВариантОплатыПеревозки.Картинка = КартинкаСохранения;
	Элементы.СохранитьПеревозчик.Картинка = КартинкаСохранения;
	Элементы.СохранитьВодитель.Картинка = КартинкаСохранения;
	Элементы.СохранитьАвтомобиль.Картинка = КартинкаСохранения;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидФормы()
	
	Если Параметры.Свойство("РазвернутьГруппы") И Параметры.РазвернутьГруппы <> "" Тогда
		СписокГрупп = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Параметры.РазвернутьГруппы);
		Для каждого ЭлементФормы Из Элементы Цикл
			Если ЭлементФормы.Вид = ВидГруппыФормы.ОбычнаяГруппа Тогда
				Если СписокГрупп.Найти(ЭлементФормы.Имя) <> Неопределено Тогда
					ЭлементФормы.Показать();
				Иначе
					ЭлементФормы.Скрыть();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийЭлемент") Тогда
		
		ТекущийЭлемент = Элементы[Параметры.ТекущийЭлемент];

	КонецЕсли;

	ТекстПоУмолчанию = ТекстОснованияПоУмолчанию(КонтекстПечати.ОснованиеПечатиСсылка);
	
	Если КонтекстПечати.ОснованиеПечати <> ТекстПоУмолчанию Тогда
		Элементы.ОснованиеПечати.Заголовок = НСтр("ru='Измененный текст'");
	КонецЕсли;

	Элементы.ГруппаТекстУсловийСчета.Видимость = НЕ КонтекстПечати.УсловияСчетаЗаказа.Пустая();
	Элементы.ГруппаТекстУсловийГарантийногоТалона.Видимость = НЕ КонтекстПечати.УсловияГарантийногоТалона.Пустая();
	
	Если НЕ ПустаяСтрока(КонтекстПечати.ТекстУсловийСчетаЗаказа) Тогда
		УстановитьВидПолеВвода("ТекстУсловийСчетаЗаказа");
	Иначе		
		КонтекстПечати.ТекстУсловийСчетаЗаказа = ПолучитьТекстУсловийШаблона(КонтекстПечати.УсловияСчетаЗаказа);
	КонецЕсли;	

	Если НЕ ПустаяСтрока(КонтекстПечати.ТекстУсловийГарантийногоТалона) Тогда
		УстановитьВидПолеВвода("ТекстУсловийГарантийногоТалона");
	Иначе
		КонтекстПечати.ТекстУсловийГарантийногоТалона =
			ПолучитьТекстУсловийШаблона(КонтекстПечати.УсловияГарантийногоТалона);
	КонецЕсли;		
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеГрузоперевозки()

	Элементы.Грузоотправитель.Видимость = НЕ ГрузоотправительОнЖе;
	Элементы.ГрузоотправительОрганизация.Видимость = ГрузоотправительОнЖе;
	
	Элементы.Грузополучатель.Видимость = НЕ ГрузополучательОнЖе;
	Элементы.ГрузополучательКонтрагент.Видимость = ГрузополучательОнЖе;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме()

	РаботаСФормойДокумента.СохранитьВидимостьГруппыИнформации(ИмяФормы,
			"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", Ложь, "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаТекстаУсловий(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ЗафиксироватьИзменениеЗначенияРеквизита(ДополнительныеПараметры.ИмяРеквизитаУсловий);		
		НастроитьПоляУсловий(ДополнительныеПараметры.ИмяРеквизитаУсловий, ДополнительныеПараметры.Условия,
			Результат);
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура НастроитьПоляУсловий(ИмяРеквизита, Условия, ТекстУсловий)

	ТекстУсловийШаблона = ПолучитьТекстУсловийШаблона(Условия);
	ИмяРеквизитаУсловий = ИмяРеквизита;
	КонтекстПечати[ИмяРеквизитаУсловий] = ТекстУсловий;		
	Если ТекстУсловийШаблона <> ТекстУсловий Тогда
		УстановитьВидПолеВвода(ИмяРеквизитаУсловий);
	Иначе
		УстановитьВидПолеНадписи(ИмяРеквизитаУсловий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидПолеВвода(ИмяРеквизитаУсловий)
	
	Элемент = Элементы[ИмяРеквизитаУсловий];
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.МногострочныйРежим = Истина;
	Элемент.Высота = 1;
	Элемент.Заголовок = НСтр("ru='Измененный текст условий'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидПолеНадписи(ИмяРеквизитаУсловий)
	
	Элемент = Элементы[ИмяРеквизитаУсловий];
	Элемент.Вид = ВидПоляФормы.ПолеНадписи;
	Если ИмяРеквизитаУсловий = "ТекстУсловийСчетаЗаказа" Тогда
		ТекстЗаголовка = НСтр("ru='Текст условий счета'");
	ИначеЕсли ИмяРеквизитаУсловий = "ТекстУсловийГарантийногоТалона" Тогда
		ТекстЗаголовка = НСтр("ru='Текст условий гарантийного талона'");
	КонецЕсли;
	Элемент.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстУсловийШаблона(Условия)
	
	ТекстУсловий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Условия, "ТекстУсловий");
	Возврат ТекстУсловий;
	
КонецФункции

&НаСервере
Процедура ДополнитьРеквизитыТекстамиУсловий(ИзмененныеРеквизиты)
	
	Если КонтекстПечати.ТекстУсловийСчетаЗаказа <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		КонтекстПечати.УсловияСчетаЗаказа, "ТекстУсловий") Тогда
			ИзмененныеРеквизиты.Вставить("ТекстУсловийСчетаЗаказа", 
			КонтекстПечати.ТекстУсловийСчетаЗаказа);
	Иначе
		ИзмененныеРеквизиты.Вставить("ТекстУсловийСчетаЗаказа", "");			
	КонецЕсли;	

	Если КонтекстПечати.ТекстУсловийГарантийногоТалона <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		КонтекстПечати.УсловияГарантийногоТалона, "ТекстУсловий") Тогда
			ИзмененныеРеквизиты.Вставить("ТекстУсловийГарантийногоТалона", 
			КонтекстПечати.ТекстУсловийГарантийногоТалона);
	Иначе
		ИзмененныеРеквизиты.Вставить("ТекстУсловийГарантийногоТалона", "");			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОснованияПоУмолчанию(ОснованиеПечатиСсылка)
	
	ТекстПоУмолчанию = "";
	Если ЗначениеЗаполнено(ОснованиеПечатиСсылка) Тогда 
		Если ТипЗнч(ОснованиеПечатиСсылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ТекстПоУмолчанию = НСтр("ru='Договор:'") + " ";	
		КонецЕсли;
		ТекстПоУмолчанию = ТекстПоУмолчанию + Строка(ОснованиеПечатиСсылка);
	КонецЕсли;

	Возврат ТекстПоУмолчанию;
			
КонецФункции

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, КонтекстПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, КонтекстПечати);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
