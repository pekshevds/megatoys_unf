
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
		
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ДанныеПоискаПоШтрихкодуСервер(Штрихкод);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ДанныеПоискаПоШтрихкодуСервер(Штрихкод)
	
	ДанныеШтрихкода = Новый Структура;
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект, ДанныеШтрихкода);
	Возврат ДанныеШтрихкода;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	РаботаСоШтрихкодамиКлиентПереопределяемый.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		Если СтруктураПараметровКлиента.ЗначенияПоиска.Количество() > 0 Тогда
			СтрокаРезультата = СтруктураПараметровКлиента.ЗначенияПоиска[0];
			СсылкаНаОбъект = СтрокаРезультата.Владелец;
			Если НЕ СсылкаНаОбъект = Неопределено Тогда
				ПараметрыФормы = Новый Структура("Ключ", СсылкаНаОбъект);
				ОткрытьФорму(ИмяМетаданных(СсылкаНаОбъект) +".ФормаОбъекта", ПараметрыФормы);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуКлиент(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьТаблицуШаблоновНаСервере()
	
	ТаблицаШаблонов.Очистить();
	
	СтруктураПрефиксов = Новый Структура;
	СтруктураПрефиксов.Вставить("НоменклатураВесовой", "");
	СтруктураПрефиксов.Вставить("НоменклатураФасованный", "");
	СтруктураПрефиксов.Вставить("НоменклатураШтучный", "");
	СтруктураПрефиксов.Вставить("СерийныйНомерСертификата", "");
	СтруктураПрефиксов.Вставить("НоменклатураСИЗ", "");
	
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьПрефиксыШтрихкодовНоменклатуры(СтруктураПрефиксов);
	
	КлючСвязи = 1;
	Для Каждого СтрокаПрефикса Из СтруктураПрефиксов Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаПрефикса.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		Префикс = СтрокаПрефикса.Значение;
		
		НоваяСтрока = ТаблицаШаблонов.Добавить();
		НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов[СтрокаПрефикса.Ключ];
		НоваяСтрока.Шаблон = Префикс + "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
		НоваяСтрока.НачалоДиапазона = Префикс + "00000000000";
		НоваяСтрока.КонецДиапазона =  Префикс + "99999999999";
		НоваяСтрока.ДлинаШтрихкода = 13;
		НоваяСтрока.КлючСвязи = КлючСвязи;
		КлючСвязи = КлючСвязи + 1;
		
	КонецЦикла;
	
	ТаблицаШаблоновРегистрацииНовыхКарт = Новый ТаблицаЗначений;
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьТаблицуШаблоновРегистрацииНовыхКарт(ТаблицаШаблоновРегистрацииНовыхКарт);
	
	Для Каждого СтрокаТаблицы Из ТаблицаШаблоновРегистрацииНовыхКарт Цикл
		
		НоваяСтрока = ТаблицаШаблонов.Добавить();
		НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.Карта;
		НоваяСтрока.ДополнительноеОписание = СтрокаТаблицы.ДополнительноеОписание;
		СтрокаШаблона = "";
		ЛюбойСимвол = "____________________________________________________________________________________________________";
		Для НомерСимвола = 1 По СтрокаТаблицы.ДлинаШтрихкода Цикл
			СимволИзНачалаДиапазона = Сред(СтрокаТаблицы.НачалоДиапазона, НомерСимвола, 1);
			СимволИзКонцаДиапазона = Сред(СтрокаТаблицы.КонецДиапазона, НомерСимвола, 1);
			Если СимволИзНачалаДиапазона = СимволИзКонцаДиапазона Тогда
				СтрокаШаблона = СтрокаШаблона + СимволИзНачалаДиапазона;
			Иначе
				СтрокаШаблона = СтрокаШаблона + Лев(ЛюбойСимвол, СтрокаТаблицы.ДлинаШтрихкода - НомерСимвола + 1);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		НоваяСтрока.Шаблон = СтрокаШаблона;
		НоваяСтрока.НачалоДиапазона = СтрокаТаблицы.НачалоДиапазона;
		НоваяСтрока.КонецДиапазона = СтрокаТаблицы.КонецДиапазона;
		НоваяСтрока.ДлинаШтрихкода = СтрокаТаблицы.ДлинаШтрихкода;
		НоваяСтрока.КлючСвязи = КлючСвязи;
		КлючСвязи = КлючСвязи + 1;
		
	КонецЦикла;
	
	ДополнитьШаблоныКИ();
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьШаблоныКИ()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		
		КлючСвязи = ТаблицаШаблонов.Количество() + 1;
		
		НоваяСтрока = ТаблицаШаблонов.Добавить();
		НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.Телефон;
		НоваяСтрока.НачалоДиапазона = НСтр("ru = '70000000000'");
		НоваяСтрока.КонецДиапазона =  НСтр("ru = '89999999999'");
		НоваяСтрока.Шаблон = НСтр("ru = '[7-8][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'");
		НоваяСтрока.ДлинаШтрихкода = СтрДлина(НоваяСтрока.НачалоДиапазона);
		НоваяСтрока.КлючСвязи = КлючСвязи;
		КлючСвязи = КлючСвязи + 1;
		
		НоваяСтрока = ТаблицаШаблонов.Добавить();
		НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.АдресЭП;
		НоваяСтрока.Шаблон = "%@%.%";
		НоваяСтрока.КлючСвязи = КлючСвязи;
		КлючСвязи = КлючСвязи + 1;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПересеченияШаблоновНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаШаблонов.ДлинаШтрихкода КАК ДлинаШтрихкода,
	|	ТаблицаШаблонов.НачалоДиапазона КАК НачалоДиапазона,
	|	ТаблицаШаблонов.КонецДиапазона КАК КонецДиапазона,
	|	ТаблицаШаблонов.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ Шаблоны
	|ИЗ
	|	&ТаблицаШаблонов КАК ТаблицаШаблонов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Шаблоны1.КлючСвязи КАК КлючСвязи,
	|	Шаблоны2.КлючСвязи КАК КлючСвязиПересечения
	|ИЗ
	|	Шаблоны КАК Шаблоны1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Шаблоны КАК Шаблоны2
	|		ПО Шаблоны1.КлючСвязи <> Шаблоны2.КлючСвязи
	|			И Шаблоны1.ДлинаШтрихкода = Шаблоны2.ДлинаШтрихкода
	|			И (Шаблоны1.НачалоДиапазона >= Шаблоны2.НачалоДиапазона
	|					И Шаблоны1.НачалоДиапазона <= Шаблоны2.КонецДиапазона
	|				ИЛИ Шаблоны1.КонецДиапазона >= Шаблоны2.НачалоДиапазона
	|					И Шаблоны1.КонецДиапазона <= Шаблоны2.КонецДиапазона
	|				ИЛИ Шаблоны1.НачалоДиапазона <= Шаблоны2.НачалоДиапазона
	|					И Шаблоны1.КонецДиапазона >= Шаблоны2.КонецДиапазона)";
	
	Запрос.УстановитьПараметр("ТаблицаШаблонов", ТаблицаШаблонов.Выгрузить());
	
	ТаблицаПересечений = Запрос.Выполнить().Выгрузить();
	ТаблицаПересеченийШаблонов.Загрузить(ТаблицаПересечений);
	МассивКлючейСвязи = ТаблицаПересечений.ВыгрузитьКолонку("КлючСвязи");
	
	Для Каждого СтрокаШаблона Из ТаблицаШаблонов Цикл 
		
		СтрокаШаблона.ЕстьОшибки = НЕ МассивКлючейСвязи.Найти(СтрокаШаблона.КлючСвязи) = Неопределено;
		СтрокаШаблона.ЕстьПересечениеШаблонов = Ложь;
		
	КонецЦикла;
	
	Если МассивКлючейСвязи.Количество() = 0 Тогда
		СтрокаСостояния = НСтр("ru = 'Пересечения диапазонов шаблонов не обнаружены'"); 
	Иначе
		СтрокаСостояния = НСтр("ru = 'Всего пересечений диапазонов шаблонов: '") + (МассивКлючейСвязи.Количество() / 2);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСоответствияШаблонамНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаШаблонов", ТаблицаШаблонов.Выгрузить());
	
	Разделитель =
	"
	|;
	|/////////////////////////////////////////////////////////////
	|";
	
	ТекстыЗапросовПакета = Новый Массив;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ТаблицаШаблонов.КлючСвязи КАК КлючСвязи,
	|	ТаблицаШаблонов.ШаблонШтрихкода КАК ШаблонШтрихкода,
	|	ТаблицаШаблонов.ДополнительноеОписание КАК ДополнительноеОписание,
	|	ТаблицаШаблонов.НачалоДиапазона КАК НачалоДиапазона,
	|	ТаблицаШаблонов.КонецДиапазона КАК КонецДиапазона,
	|	ТаблицаШаблонов.Шаблон КАК Шаблон
	|ПОМЕСТИТЬ ТаблицаШаблонов
	|ИЗ
	|	&ТаблицаШаблонов КАК ТаблицаШаблонов";
	
	ТекстыЗапросовПакета.Добавить(ТекстЗапроса);
	ТекстыЗапросовПакета.Добавить(РаботаСоШтрихкодами.ТекстЗапросаШтрихкодыБазы());
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ТаблицаШаблонов.КлючСвязи КАК КлючСвязи,
	|	Штрихкоды.ШаблонШтрихкода КАК ШаблонШтрихкода,
	|	Штрихкоды.Штрихкод КАК Штрихкод,
	|	Штрихкоды.Владелец КАК Владелец,
	|	Штрихкоды.Характеристика КАК Характеристика,
	|	Штрихкоды.Упаковка КАК Упаковка,
	|	Штрихкоды.Серия КАК Серия,
	|	Штрихкоды.Партия КАК Партия,
	|	ТИПЗНАЧЕНИЯ(Штрихкоды.Владелец) КАК ТипОбъекта
	|ИЗ
	|	ШтрихкодыВсе КАК Штрихкоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаШаблонов КАК ТаблицаШаблонов
	|		ПО &УсловиеПоШаблонам
	|			И Штрихкоды.Штрихкод >= ТаблицаШаблонов.НачалоДиапазона
	|			И (ВЫБОР
	|				КОГДА ТаблицаШаблонов.КонецДиапазона = """"
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ Штрихкоды.Штрихкод <= ТаблицаШаблонов.КонецДиапазона
	|			КОНЕЦ)
	|			И (НЕ ТаблицаШаблонов.ШаблонШтрихкода = Штрихкоды.ШаблонШтрихкода)";
	
	ТекстУсловия = "(ВЫБОР ";
	Для Каждого СтрокаШаблона Из ТаблицаШаблонов Цикл
		
		ТекстУсловия = ТекстУсловия
			+ "
			|	КОГДА ТаблицаШаблонов.КлючСвязи = " + СтрокаШаблона.КлючСвязи + "
			|		ТОГДА Штрихкоды.Штрихкод ПОДОБНО &Шаблон" + СтрокаШаблона.КлючСвязи;
		
		Запрос.УстановитьПараметр("Шаблон" + СтрокаШаблона.КлючСвязи, СтрокаШаблона.Шаблон);
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаШаблона.Шаблон, "[");
		
		Если МассивПодстрок.Количество() > 1 И СтрокаШаблона.ДлинаШтрихкода > 0 Тогда
			
			НомерСимвола = 0;
			ШаблонСимволов = "";
			
			Для Каждого СимволыПодстроки Из МассивПодстрок Цикл
				
				Если Прав(СимволыПодстроки, 1) = "]" Тогда
					НомерСимвола = НомерСимвола + 1;
					ШаблонСимволов = ШаблонСимволов + "_";
					
					НачальноеЧисло = Число(Лев(СимволыПодстроки, 1));
					КонечноеЧисло = Число(Сред(СимволыПодстроки, 3, 1));
					
					МассивСимволовДляСтроки = Новый Массив;
					Для СимволВСтроку = НачальноеЧисло По КонечноеЧисло Цикл
						МассивСимволовДляСтроки.Добавить("""" + Строка(СимволВСтроку) + """");
					КонецЦикла;
					
					СтрокаСимволов = СтрСоединить(МассивСимволовДляСтроки, ", ");
					
					ТекстУсловия = ТекстУсловия
						+ "
						|		И ПОДСТРОКА(Штрихкоды.Штрихкод, " + НомерСимвола + ", 1) В (" + СтрокаСимволов + ")";
					
				Иначе
					
					КоличествоСимволов = СтрДлина(СимволыПодстроки);
					Для НомерСимволаДляСтроки = 1 По КоличествоСимволов Цикл
						СтрокаСимвол = Сред(СимволыПодстроки, НомерСимволаДляСтроки, 1);
						
						НомерСимвола = НомерСимвола + 1;
						ШаблонСимволов = ШаблонСимволов + СтрокаСимвол;
						
						ТекстУсловия = ТекстУсловия
							+ "
							|		И ПОДСТРОКА(Штрихкоды.Штрихкод, " + НомерСимвола + ", 1) = """ + СтрокаСимвол + """";
						
					КонецЦикла;
					
				КонецЕсли;
					
			КонецЦикла;
			
			Запрос.УстановитьПараметр("Шаблон" + СтрокаШаблона.КлючСвязи, ШаблонСимволов);
			
		КонецЕсли;
		
	КонецЦикла;
	ТекстУсловия = ТекстУсловия + " КОНЕЦ)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоШаблонам", ТекстУсловия);
	ТекстыЗапросовПакета.Добавить(ТекстЗапроса);
	ТекстЗапроса = СтрСоединить(ТекстыЗапросовПакета, Разделитель);
	
	Запрос.Текст = ТекстЗапроса;
	РаботаСоШтрихкодамиПереопределяемый.ДополнитьПараметрыЗапросаПоиска(Запрос, ЭтаФорма);
	
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоСтрокВсего = Выборка.Количество();
	МаксимальноеКоличествоСтрокТаблицы = 10000;
	
	ТаблицаОшибок.Очистить();
	КоличествоСтрок = 0;
	Пока Выборка.Следующий() Цикл
		
		КоличествоСтрок = КоличествоСтрок + 1;
		Если КоличествоСтрок > МаксимальноеКоличествоСтрокТаблицы Тогда
			Прервать;
		КонецЕсли;
		
		СтрокаОшибки = ТаблицаОшибок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаОшибки, Выборка);
		
	КонецЦикла;
	
	Для Каждого СтрокаШаблона Из ТаблицаШаблонов Цикл 
		
		Отбор = Новый Структура("КлючСвязи", СтрокаШаблона.КлючСвязи);
		СтрокиОшибокПоШаблону = ТаблицаОшибок.НайтиСтроки(Отбор);
		СтрокаШаблона.ЕстьОшибки = СтрокиОшибокПоШаблону.Количество() > 0;
		СтрокаШаблона.КоличествоОшибок = СтрокиОшибокПоШаблону.Количество();
		СтрокаШаблона.ЕстьПересечениеШаблонов = Ложь;
		
	КонецЦикла;
	
	СтрокаСостояния = НСтр("ru = 'Всего найдено несоответствий шаблонам: '") + КоличествоСтрокВсего;
	Если КоличествоСтрокВсего > МаксимальноеКоличествоСтрокТаблицы Тогда
		СтрокаСостояния = СтрокаСостояния + НСтр("ru = '          Выведено: '") + МаксимальноеКоличествоСтрокТаблицы;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НайтиДублиШтрихкодовНаСервере()
	
	Разделитель =
	"
	|;
	|/////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапросаСравнения = "ВЫБРАТЬ
	|	ШтрихкодыВсе.Штрихкод КАК Штрихкод,
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ПОМЕСТИТЬ КоличествоШтрихов
	|ИЗ
	|	ШтрихкодыВсе КАК ШтрихкодыВсе
	|
	|СГРУППИРОВАТЬ ПО
	|	ШтрихкодыВсе.Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ШтрихкодыВсе.Штрихкод КАК Штрихкод,
	|	ШтрихкодыВсе.Владелец КАК Владелец,
	|	ШтрихкодыВсе.Характеристика КАК Характеристика,
	|	ШтрихкодыВсе.Упаковка КАК Упаковка,
	|	ШтрихкодыВсе.Серия КАК Серия,
	|	ШтрихкодыВсе.Партия КАК Партия,
	|	ШтрихкодыВсе.ШаблонШтрихкода КАК ШаблонШтрихкода,
	|	ТИПЗНАЧЕНИЯ(ШтрихкодыВсе.Владелец) КАК ТипОбъекта
	|ИЗ
	|	ШтрихкодыВсе КАК ШтрихкодыВсе
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КоличествоШтрихов КАК КоличествоШтрихов
	|		ПО ШтрихкодыВсе.Штрихкод = КоличествоШтрихов.Штрихкод
	|			И (КоличествоШтрихов.Количество > 1)";
	
	ТекстыЗапросовПакета = Новый Массив;
	ТекстыЗапросовПакета.Добавить(РаботаСоШтрихкодами.ТекстЗапросаШтрихкодыБазы());
	ТекстыЗапросовПакета.Добавить(ТекстЗапросаСравнения);
	ТекстЗапроса = СтрСоединить(ТекстыЗапросовПакета, Разделитель);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	РаботаСоШтрихкодамиПереопределяемый.ДополнитьПараметрыЗапросаПоиска(Запрос, ЭтаФорма);
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоСтрокВсего = Выборка.Количество();
	МаксимальноеКоличествоСтрокТаблицы = 10000;
	
	ТаблицаОшибок.Очистить();
	КоличествоСтрок = 0;
	Пока Выборка.Следующий() Цикл
		
		КоличествоСтрок = КоличествоСтрок + 1;
		Если КоличествоСтрок > МаксимальноеКоличествоСтрокТаблицы Тогда
			Прервать;
		КонецЕсли;
		
		СтрокаОшибки = ТаблицаОшибок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаОшибки, Выборка);
		
	КонецЦикла;
	
	СтрокаСостояния = НСтр("ru = 'Всего найдено дублей: '") + КоличествоСтрокВсего;
	Если КоличествоСтрокВсего > МаксимальноеКоличествоСтрокТаблицы Тогда
		СтрокаСостояния = СтрокаСостояния + НСтр("ru = '          Выведено: '") + МаксимальноеКоличествоСтрокТаблицы;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТаблицаШаблонов

&НаКлиенте
Процедура ТаблицаШаблоновПриАктивизацииСтроки(Элемент)
	
	Если ЭтоРежимШаблонов Тогда
		
		ОтборСтрок = Новый Структура("КлючСвязи", Элементы.ТаблицаШаблонов.ТекущиеДанные.КлючСвязи);
		
		СтрокиПересеченияШаблонов = ТаблицаПересеченийШаблонов.НайтиСтроки(ОтборСтрок);
		СписокКлючейСвязи = Новый СписокЗначений;
		Для Каждого СтрокаПересечения Из СтрокиПересеченияШаблонов Цикл
			СписокКлючейСвязи.Добавить(СтрокаПересечения.КлючСвязиПересечения);
		КонецЦикла;
		
		Для Каждого СтрокаШаблона Из ТаблицаШаблонов Цикл
			СтрокаШаблона.ЕстьПересечениеШаблонов = Не СписокКлючейСвязи.НайтиПоЗначению(СтрокаШаблона.КлючСвязи) = Неопределено;
		КонецЦикла;
		
	Иначе
		
		Если Не Элементы.ТаблицаШаблонов.ТекущиеДанные = Неопределено Тогда
			Элементы.ТаблицаОшибок.ОтборСтрок = 
				Новый ФиксированнаяСтруктура("КлючСвязи", Элементы.ТаблицаШаблонов.ТекущиеДанные.КлючСвязи);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТаблицаОшибок

&НаКлиенте
Процедура ТаблицаОшибокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяКолонки = СтрЗаменить(Поле.Имя, "ТаблицаОшибок", "");
	Если ИмяКолонки = "Владелец" Или ИмяКолонки = "Характеристика"
		Или ИмяКолонки = "Упаковка" Или ИмяКолонки = "Серия" Или ИмяКолонки = "Партия" Тогда
		СсылкаНаОбъект = Элементы.ТаблицаОшибок.ТекущиеДанные[ИмяКолонки];
		Если Не СсылкаНаОбъект.Пустая() Тогда
			ПараметрыФормы = Новый Структура("Ключ", СсылкаНаОбъект);
			ОткрытьФорму(ИмяМетаданных(СсылкаНаОбъект) +".ФормаОбъекта", ПараметрыФормы);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	РаботаСоШтрихкодамиКлиентПереопределяемый.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПроверитьПересеченияШаблонов(Команда)
	
	ЭтоРежимШаблонов = Истина;
	Элементы.ТаблицаШаблонов.Видимость = Истина;
	Элементы.ТаблицаОшибок.Видимость = Ложь;
	ПроверитьПересеченияШаблоновНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСоответствияШаблонам(Команда)
	
	ЭтоРежимШаблонов = Ложь;
	Элементы.ТаблицаШаблонов.Видимость = Истина;
	Элементы.ТаблицаОшибок.Видимость = Истина;
	ПроверитьСоответствияШаблонамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиДублиШтрихкодов(Команда)
	
	ЭтоРежимШаблонов = Ложь;
	Элементы.ТаблицаШаблонов.Видимость = Ложь;
	Элементы.ТаблицаОшибок.Видимость = Истина;
	НайтиДублиШтрихкодовНаСервере();
	
	Элементы.ТаблицаОшибок.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", 0);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуШаблоновНаСервере();
	
	УстановитьУсловноеОформление();
	
	РаботаСоШтрихкодамиПереопределяемый.НастроитьФормуАнализаШтрихкодов(ЭтотОбъект);
	
	// ПодключаемоеОборудование
	ПараметрыСобытийПО = Новый Структура;
	ПараметрыСобытийПО.Вставить("РегистрацияНовойНоменклатуры", Истина);
	ПараметрыСобытийПО.Вставить("РегистрацияНовойКарты", Истина);
	
	РаботаСоШтрихкодамиПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ТаблицаОшибок.Видимость = Ложь;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		РаботаСоШтрихкодамиКлиентПереопределяемый.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ИмяМетаданных(СсылкаНаОбъект)
	
	Возврат Метаданные.НайтиПоТипу(ТипЗнч(СсылкаНаОбъект)).ПолноеИмя();
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаШаблонов.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаШаблоновЕстьПересечениеШаблонов.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаШаблонов.Имя);	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаШаблоновЕстьОшибки.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоРозовый);
	
КонецПроцедуры

#КонецОбласти
