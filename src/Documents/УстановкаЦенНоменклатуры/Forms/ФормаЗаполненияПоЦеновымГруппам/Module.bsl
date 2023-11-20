
#Область СлужебныеПроцедурыФункции

&НаСервере
Функция ПолучитьВыбранныеЦеновыеГруппы()
	
	МассивЦеновыхГрупп	= Новый Массив;
	ДеревоЦеновыхГрупп	= ДанныеФормыВЗначение(ЦеновыеГруппы, Тип("ДеревоЗначений"));
	МассивНайденныхСтрок= ДеревоЦеновыхГрупп.Строки.НайтиСтроки(Новый Структура("Отметка", Истина), Истина);
	Для каждого СтрокаМассива Из МассивНайденныхСтрок Цикл
		
		МассивЦеновыхГрупп.Добавить(СтрокаМассива.ЦеноваяГруппа);
		
	КонецЦикла;
	
	Возврат МассивЦеновыхГрупп;
	
КонецФункции

&НаСервере
Процедура ПолучитьНоменклатуру(АдресВременногоХранилища)
	
	МассивЦеновыхГрупп = ПолучитьВыбранныеЦеновыеГруппы();
	Если МассивЦеновыхГрупп.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДеревоНоменклатуры = Новый ДеревоЗначений;
	
	// 1. Получим СКД
	ИмяСхемыКД = "ПоЦеновымГруппам";
	СхемаКомпоновкиДанных = Документы.УстановкаЦенНоменклатуры.ПолучитьМакет(ИмяСхемыКД);
	
	// 2. создаем настройки для схемы 
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	// 2.1 установим значения параметров
	ПараметрКД = СхемаКомпоновкиДанных.Параметры.Найти("МассивЦеновыхГрупп");
	ПараметрКД.Значение = МассивЦеновыхГрупп;
	
	Если ИспользоватьХарактеристики = 0 Тогда
		
		НастройкиКомпоновкиДанных.Структура[0].Структура[0].Использование = Ложь;
		
	КонецЕсли;
	
	// 3. готовим макет 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// 4. исполняем макет 
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	ПроцессорКомпоновки.Сбросить();
	
	// 5. выводим результат 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ДеревоНоменклатуры);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	СтруктураТаблицДанных = Документы.УстановкаЦенНоменклатуры.РазобратьДеревоНоменклатуры(ДеревоНоменклатуры, ПоказыватьНедействительныеХарактеристики);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(СтруктураТаблицДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтчетСПредварительнымРезультатом(МассивЦеновыхГрупп)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("ИмяСКД", 					"ПоЦеновымГруппам");
	ПараметрыОткрытия.Вставить("МассивЦеновыхГрупп", 		МассивЦеновыхГрупп);
	ПараметрыОткрытия.Вставить("ИспользоватьХарактеристики",ИспользоватьХарактеристики);
	
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ФормаПредварительногоПросмотра", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВХранилищеДанныеТабличнойЧасти(АдресВременногоХранилища)
	
	ПолучитьНоменклатуру(АдресВременногоХранилища);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСтрокиРекурсивно(Строки, ЗначениеОтметки)
	
	Для каждого СтрокаЦеновойГруппы Из Строки Цикл
		
		СтрокаЦеновойГруппы.Отметка = ЗначениеОтметки;
		ОбработатьСтрокиРекурсивно(СтрокаЦеновойГруппы.ПолучитьЭлементы(), ЗначениеОтметки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСообщениеОНеправильномВыборе()
	
	ТекстСообщения = НСтр("ru ='Необходимо отметить ценовые группы'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ЦеновыеГруппы");
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Только номенклатуру(0); Номенклатуру и ее характеристики(1);
	ИспользоватьХарактеристики = ?(Параметры.ХарактеристикиВидны = Истина, 1, 0);
	Если Параметры.Свойство("ПоказыватьНедействительныеХарактеристики") Тогда
		ПоказыватьНедействительныеХарактеристики = Параметры.ПоказыватьНедействительныеХарактеристики;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Отметка,
	|	ЦеновыеГруппы.Ссылка КАК ЦеноваяГруппа
	|ИЗ
	|	Справочник.ЦеновыеГруппы КАК ЦеновыеГруппы
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЦеноваяГруппа ИЕРАРХИЯ");
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), "ЦеновыеГруппы");
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		// Обход ошибки платформы 30163126
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияКартинка", "Ширина", 2);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияКартинка", "Высота", 0);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияРеквизитовФормы

&НаКлиенте
Процедура ЦеновыеГруппыОтметкаПриИзменении(Элемент)
	
	ДанныеТекущейСтроки = Элементы.ЦеновыеГруппы.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		
		Строки = ДанныеТекущейСтроки.ПолучитьЭлементы();
		ОбработатьСтрокиРекурсивно(Строки, ДанныеТекущейСтроки.Отметка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ОК(Команда)
	
	АдресВременногоХранилища = "";
	ЗаписатьВХранилищеДанныеТабличнойЧасти(АдресВременногоХранилища);
	
	Если ПустаяСтрока(АдресВременногоХранилища) Тогда
		
		ВывестиСообщениеОНеправильномВыборе();
		
	Иначе
		
		Закрыть(Новый Структура("ВыборПроизведен, АдресВременногоХранилища", Истина, АдресВременногоХранилища));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	МассивЦеновыхГрупп = ПолучитьВыбранныеЦеновыеГруппы();
	Если МассивЦеновыхГрупп.Количество() > 0 Тогда
		
		ПоказатьОтчетСПредварительнымРезультатом(МассивЦеновыхГрупп);
		
	Иначе
		
		ВывестиСообщениеОНеправильномВыборе();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсеСтроки(Команда)
	
	Строки = ЦеновыеГруппы.ПолучитьЭлементы();
	ОбработатьСтрокиРекурсивно(Строки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкиСоВсехСтрок(Команда)
	
	Строки = ЦеновыеГруппы.ПолучитьЭлементы();
	ОбработатьСтрокиРекурсивно(Строки, Ложь);
	
КонецПроцедуры

#КонецОбласти
