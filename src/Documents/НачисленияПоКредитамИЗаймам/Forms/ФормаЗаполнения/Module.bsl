
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	АдресНачисленийВХранилище = Параметры.АдресНачисленийВХранилище;
	ВидОперации = Параметры.ВидОперации;
	ДатаНачала = Параметры.ДатаНачала;
	ДатаОкончания = Параметры.ДатаОкончания;
	Регистратор = Параметры.Регистратор;
	
	УстановитьПараметрыВыбораДоговора();
	
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам Тогда
		Элементы.Сотрудник.Видимость = Ложь;
	Иначе
		Элементы.Контрагент.Видимость = Ложь;
	КонецЕсли;
	
	НовыйМассив = Новый Массив();
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный);
		Элементы.ЗаполнятьПоДоговорамСПогашениемИзЗаработнойПлаты.Видимость = Ложь;
	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику);
		Элементы.ЗаполнятьПоДоговорамСПогашениемИзЗаработнойПлаты.Видимость = Истина;
	КонецЕсли;
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ДоговорКредитаЗайма.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	УстановитьПараметрыВыбораДоговора();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)

	НачисленияСервер();
	
	Структура = Новый Структура("АдресНачисленийВХранилище", АдресНачисленийВХранилище);
	ОповеститьОВыборе(Структура);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция УстановитьПараметрыВыбораДоговора()

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Организация));
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный));
		Если НЕ Контрагент.Пустая() Тогда
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Контрагент));
		КонецЕсли;
	Иначе
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику));
		Если НЕ Сотрудник.Пустая() Тогда
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Сотрудник", Сотрудник));
		КонецЕсли;
	КонецЕсли;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления",Ложь));
	
	Элементы.ДоговорКредитаЗайма.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервере
Функция ТекстЗапросаПоНачислениям()
	
	Возврат 
	"ВЫБРАТЬ
	|	ГрафикПогашенияКредитовИЗаймов.Период КАК Период,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма КАК ДоговорКредитаЗайма,
	|	СУММА(ГрафикПогашенияКредитовИЗаймов.СуммаПроцентов) КАК СуммаПроцентов,
	|	СУММА(ГрафикПогашенияКредитовИЗаймов.СуммаКомиссии) КАК СуммаКомиссии,
	|	ВЫБОР
	|		КОГДА ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКредитаИЗайма.КредитПолученный)
	|			ТОГДА ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Контрагент
	|		ИНАЧЕ ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Сотрудник
	|	КОНЕЦ КАК Контрагент,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Организация КАК Организация,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВидДоговора КАК ВидДоговора,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВалютаРасчетов КАК ВалютаРасчетов,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Проект КАК Проект
	|ПОМЕСТИТЬ ТекущиеНачисления
	|ИЗ
	|	РегистрСведений.ГрафикПогашенияКредитовИЗаймов КАК ГрафикПогашенияКредитовИЗаймов
	|ГДЕ
	|	ГрафикПогашенияКредитовИЗаймов.Активность
	|	И ГрафикПогашенияКредитовИЗаймов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Организация = &Организация
	|	И ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВидДоговора = &ВидДоговора
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикПогашенияКредитовИЗаймов.Период,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма,
	|	ВЫБОР
	|		КОГДА ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКредитаИЗайма.КредитПолученный)
	|			ТОГДА ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Контрагент
	|		ИНАЧЕ ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Сотрудник
	|	КОНЕЦ,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВидДоговора,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.Организация,
	|	ГрафикПогашенияКредитовИЗаймов.ДоговорКредитаЗайма.ВалютаРасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыПоКредитамИЗаймам.Период КАК Период,
	|	РасчетыПоКредитамИЗаймам.ВидДоговора КАК ВидДоговора,
	|	РасчетыПоКредитамИЗаймам.Контрагент КАК Контрагент,
	|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма КАК ДоговорКредитаЗайма,
	|	РасчетыПоКредитамИЗаймам.Организация КАК Организация,
	|	СУММА(РасчетыПоКредитамИЗаймам.ПроцентыВал) КАК ПроцентыВал,
	|	СУММА(РасчетыПоКредитамИЗаймам.КомиссияВал) КАК КомиссияВал,
	|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма.ВалютаРасчетов КАК ВалютаРасчетов,
	|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма.Проект КАК Проект
	|ПОМЕСТИТЬ ПредыдущиеНачисления
	|ИЗ
	|	РегистрНакопления.РасчетыПоКредитамИЗаймам КАК РасчетыПоКредитамИЗаймам
	|ГДЕ
	|	РасчетыПоКредитамИЗаймам.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И РасчетыПоКредитамИЗаймам.Регистратор <> &Регистратор
	|	И РасчетыПоКредитамИЗаймам.ВидДоговора = &ВидДоговора
	|	И РасчетыПоКредитамИЗаймам.Организация = &Организация
	|	И РасчетыПоКредитамИЗаймам.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма,
	|	РасчетыПоКредитамИЗаймам.Период,
	|	РасчетыПоКредитамИЗаймам.ВидДоговора,
	|	РасчетыПоКредитамИЗаймам.Организация,
	|	РасчетыПоКредитамИЗаймам.Контрагент,
	|	РасчетыПоКредитамИЗаймам.ДоговорКредитаЗайма.ВалютаРасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеНачисления.Период КАК Дата,
	|	ТекущиеНачисления.ДоговорКредитаЗайма КАК ДоговорКредитаЗайма,
	|	ТекущиеНачисления.СуммаПроцентов КАК СуммаПроцентов,
	|	ТекущиеНачисления.СуммаКомиссии КАК СуммаКомиссии,
	|	ВЫРАЗИТЬ(ТекущиеНачисления.Контрагент КАК Справочник.Контрагенты) КАК Контрагент,
	|	ВЫРАЗИТЬ(ТекущиеНачисления.Контрагент КАК Справочник.Сотрудники) КАК Сотрудник,
	|	ТекущиеНачисления.Организация КАК Организация,
	|	ТекущиеНачисления.ВидДоговора КАК ВидДоговора,
	|	ТекущиеНачисления.ВалютаРасчетов КАК ВалютаРасчетов,
	|	0 КАК Сумма,
	|	ТекущиеНачисления.ДоговорКредитаЗайма.ПогашатьИзЗаработнойПлаты КАК ПогашатьИзЗаработнойПлаты,
	|	ТекущиеНачисления.Проект КАК Проект
	|ИЗ
	|	ТекущиеНачисления КАК ТекущиеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПредыдущиеНачисления КАК ПредыдущиеНачисления
	|		ПО ТекущиеНачисления.Период = ПредыдущиеНачисления.Период
	|			И ТекущиеНачисления.ДоговорКредитаЗайма = ПредыдущиеНачисления.ДоговорКредитаЗайма
	|			И ТекущиеНачисления.Контрагент = ПредыдущиеНачисления.ВидДоговора
	|			И ТекущиеНачисления.ВалютаРасчетов = ПредыдущиеНачисления.ВалютаРасчетов
	|ГДЕ
	|	ПредыдущиеНачисления.Период ЕСТЬ NULL
	|{ГДЕ
	|	(ВЫРАЗИТЬ(ТекущиеНачисления.Контрагент КАК Справочник.Контрагенты)).* КАК Контрагент,
	|	(ВЫРАЗИТЬ(ТекущиеНачисления.Контрагент КАК Справочник.Сотрудники)).* КАК Сотрудник,
	|	ТекущиеНачисления.ДоговорКредитаЗайма.*,
	|	ТекущиеНачисления.ДоговорКредитаЗайма.ПогашатьИзЗаработнойПлаты КАК ПогашатьИзЗаработнойПлаты}
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	ДоговорКредитаЗайма
	|АВТОУПОРЯДОЧИВАНИЕ";
	
КонецФункции

&НаСервере
Процедура НачисленияСервер()
	
	// получим таблицу начислений по графику
	ПостроительЗапроса = Новый ПостроительЗапроса(ТекстЗапросаПоНачислениям());
	ПостроительЗапроса.Параметры.Вставить("ДатаНачала", ДатаНачала);
	ПостроительЗапроса.Параметры.Вставить("ДатаОкончания", ДатаОкончания);
	ПостроительЗапроса.Параметры.Вставить("Организация", Организация);
	ПостроительЗапроса.Параметры.Вставить("Регистратор", Регистратор);
	
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам Тогда
		ПостроительЗапроса.Параметры.Вставить("ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный);
	Иначе
		ПостроительЗапроса.Параметры.Вставить("ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("Контрагент");
		НовыйОтбор.Установить(Контрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("Сотрудник");
		НовыйОтбор.Установить(Сотрудник);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКредитаЗайма) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("ДоговорКредитаЗайма");
		НовыйОтбор.Установить(ДоговорКредитаЗайма);
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоЗаймамСотрудникам И 
		Не ЗаполнятьПоДоговорамСПогашениемИзЗаработнойПлаты Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("ПогашатьИзЗаработнойПлаты");
		НовыйОтбор.Установить(Ложь);
	КонецЕсли;
	
	ПостроительЗапроса.Выполнить();
	НачисленияГрафика = ПостроительЗапроса.Результат.Выгрузить();
	Начисления = НачисленияГрафика.СкопироватьКолонки();
	Начисления.Колонки.Добавить("ТипСуммы", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСуммГрафикаКредитовИЗаймов"));
	
	Для каждого ТекущееНачисление Из НачисленияГрафика Цикл
	
		Если ТекущееНачисление.СуммаПроцентов <> 0 Тогда
			НоваяСтрокаНачисления = Начисления.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНачисления, ТекущееНачисление);
			НоваяСтрокаНачисления.Сумма = ТекущееНачисление.СуммаПроцентов;
			НоваяСтрокаНачисления.ТипСуммы = Перечисления.ТипыСуммГрафикаКредитовИЗаймов.Проценты;
		КонецЕсли;
		
		Если ТекущееНачисление.СуммаКомиссии <> 0 Тогда
			НоваяСтрокаНачисления = Начисления.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНачисления, ТекущееНачисление);
			НоваяСтрокаНачисления.Сумма = ТекущееНачисление.СуммаКомиссии;
			НоваяСтрокаНачисления.ТипСуммы = Перечисления.ТипыСуммГрафикаКредитовИЗаймов.Комиссия;
		КонецЕсли;

	КонецЦикла;
	
	АдресНачисленийВХранилище = ПоместитьВоВременноеХранилище(Начисления, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
