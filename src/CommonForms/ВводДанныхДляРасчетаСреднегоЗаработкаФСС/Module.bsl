
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.АдресПараметровВХранилище) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	ПараметрыРасчета = ПолучитьИзВременногоХранилища(Параметры.АдресПараметровВХранилище);
	
	РежимПодробногоВводаСреднегоЗаработка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПользователя", "РежимПодробногоВводаСреднегоЗаработкаФСС");
	
	ДатаНачалаСобытия 			= ПараметрыРасчета.ДатаНачалаСобытия;
	Сотрудник 					= ПараметрыРасчета.Сотрудник;
	Организация 				= ПараметрыРасчета.Организация;
	ПричинаНетрудоспособности 	= ПараметрыРасчета.ПричинаНетрудоспособности;
	РайонныйКоэффициентРФНаНачалоСобытия = ПараметрыРасчета.РайонныйКоэффициентРФНаНачалоСобытия;
	
	Если ПричинаНетрудоспособности <> Перечисления.ПричиныНетрудоспособности.ПоБеременностиИРодам Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ДекорацияМесяцы",
			"Высота",
			1);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПервыйГодДни",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Год1Месяц1",
			"ПоложениеЗаголовка",
			ПоложениеЗаголовкаЭлементаФормы.Нет);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ВторойГодДни",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Год2Месяц1",
			"ПоложениеЗаголовка",
			ПоложениеЗаголовкаЭлементаФормы.Нет);
			
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РежимПодробногоВводаСреднегоЗаработка",
		"Видимость",
		Не ТолькоПросмотр);
		
	ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
	
	Год1 = ПараметрыРасчета.ПервыйГод;
	Год2 = ПараметрыРасчета.ВторойГод;
	НастроитьМаксимальноеКоличествоДнейВФевраля(ЭтаФорма);
	
	ЗагрузитьСреднийЗаработокФСС(ПараметрыРасчета.СреднийЗаработокФСС, ПараметрыРасчета.ОтработанноеВремяДляСреднегоФСС);
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();

	СреднийЗаработокИтог = УчетПособийСоциальногоСтрахования.СреднийДневнойЗаработокФСС(ПараметрыРасчета);
	МинимальныйСреднедневнойЗаработок = УчетПособийСоциальногоСтрахования.МинимальныйСреднедневнойЗаработокФСС(ПараметрыРасчета);
	
	УстановитьПодсказкуКРасчетуСреднегоЗаработка();
	
	Если ТолькоПросмотр Тогда
		Заголовок = НСтр("ru = 'Данные для расчета среднего заработка (только просмотр)'");
	Иначе
		Заголовок = НСтр("ru = 'Ввод данных для расчета среднего заработка'"); 
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"OK",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Отмена",
			"Заголовок",
			НСтр("ru='Закрыть'"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Отмена",
			"КнопкаПоУмолчанию",
			Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Год1ПриИзменении(Элемент)
	
	ПриИзмененииРасчетногоГода(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Год1Регулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Год1 = Год1 + Направление;
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	ПриИзмененииРасчетногоГода(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Год2ПриИзменении(Элемент)
	
	ПриИзмененииРасчетногоГода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Год2Регулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Год2 = Год2 + Направление;
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	ПриИзмененииРасчетногоГода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодМесяцПриИзменении(Элемент)
	
	ГодМесяцПриИзмененииНаСервере();
	
	УстановитьПодсказкуКРасчетуСреднегоЗаработка();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПодробногоВводаСреднегоЗаработкаПриИзменении(Элемент)
	
	Если Не РежимПодробногоВводаСреднегоЗаработка Тогда
		СвернутьДанныеДляКраткойФормы(ЭтаФорма);
	КонецЕсли;
	
	УстановитьОтображениеКраткойПодробнойФормыВвода();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	Если НЕ Модифицированность ИЛИ ТолькоПросмотр Тогда
		Закрыть();
	Иначе
		ПодготовитьФормуКПринятиюИзменений(ВладелецФормы.УникальныйИдентификатор);
		Закрыть(АдресВХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьДанныеУчета(Команда)
	
	ДанныеЗаполнены = Ложь;
	Для НомерГода = 1 По 2 Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			Заработок = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца);
				
			ДнейБолезниУходаЗаДетьми = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца);
				
			Если Заработок <> 0 ИЛИ ДнейБолезниУходаЗаДетьми <> 0 Тогда
				ДанныеЗаполнены = Истина;
				Прервать;
			КонецЕсли; 
				
		КонецЦикла;
		
		Если ДанныеЗаполнены Тогда
			Прервать;
		КонецЕсли; 
				
	КонецЦикла;
	
	Если ДанныеЗаполнены Тогда
		
		ТекстВопроса = НСтр("ru='Перед заполнением введенные данные будут очищены.
			|Продолжить?'");
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ПеречитатьДанныеУчетаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	Иначе
		ПеречитатьДанныеУчетаЗавершение(КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПеречитатьДанныеУчетаЗавершение(Знач Результат, Знач Параметры = Неопределено) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоДаннымУчета();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуКПринятиюИзменений(ИдентификаторВладельца)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкиПользователя", "РежимПодробногоВводаСреднегоЗаработкаФСС", РежимПодробногоВводаСреднегоЗаработка);
	АдресВХранилище = АдресПараметровВХранилище(ИдентификаторВладельца);
	
КонецПроцедуры

&НаСервере
Функция АдресПараметровВХранилище(ИдентификаторВладельца)
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Год1);
	РасчетныеГоды.Добавить(Год2);
	
	НомерГода = 1;
	СреднийЗаработокФСС = Новый Массив;
	ОтработанноеВремяДляСреднегоФСС = Новый Массив;
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			Заработок = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца);
				
			ДнейБолезниУходаЗаДетьми = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца);
				
			Если Заработок <> 0 Тогда
					
				ЗаписьСреднего = Новый Структура;
				ЗаписьСреднего.Вставить("ФизическоеЛицо", ФизическоеЛицо);
				ЗаписьСреднего.Вставить("Период", Дата(Год, НомерМесяца, 1));
				ЗаписьСреднего.Вставить("Сумма", Заработок);
				
				СреднийЗаработокФСС.Добавить(ЗаписьСреднего);
				
			КонецЕсли; 
			
			Если ДнейБолезниУходаЗаДетьми <> 0 Тогда
				
				ЗаписьОВремени = Новый Структура;
				ЗаписьОВремени.Вставить("ФизическоеЛицо", ФизическоеЛицо);
				ЗаписьОВремени.Вставить("Период", Дата(Год, НомерМесяца, 1));
				ЗаписьОВремени.Вставить("ДнейБолезниУходаЗаДетьми", ДнейБолезниУходаЗаДетьми);
				
				ОтработанноеВремяДляСреднегоФСС.Добавить(ЗаписьОВремени);
				
			КонецЕсли; 
			
		КонецЦикла;
		
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("СреднийЗаработокФСС", СреднийЗаработокФСС);
	ПараметрыОповещения.Вставить("ОтработанноеВремяДляСреднегоФСС", ОтработанноеВремяДляСреднегоФСС);
	ПараметрыОповещения.Вставить("ПервыйГод", Год1);
	ПараметрыОповещения.Вставить("ВторойГод", Год2);
	ПараметрыОповещения.Вставить("СреднийДневнойЗаработок", СреднийЗаработокИтог);
	ПараметрыОповещения.Вставить("МинимальныйСреднедневнойЗаработок", МинимальныйСреднедневнойЗаработок);
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОповещения, ИдентификаторВладельца);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоДаннымУчета()
	
	Для НомерГода = 1 По 2 Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца, 0);
				
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца, 0);
				
		КонецЦикла;
		
	КонецЦикла;
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Год1);
	РасчетныеГоды.Добавить(Год2);
	
	ДанныеОЗаработке = РасчетЗарплатыДляНебольшихОрганизаций.ДанныеОЗаработкеДляРасчетаСреднегоФСС(
		Сотрудник, Организация, ДатаНачалаСобытия, РасчетныеГоды);
		
	Для каждого СведенияОГоде Из ДанныеОЗаработке Цикл
			
		ИндексГода = РасчетныеГоды.Найти(СведенияОГоде.Ключ);
		Если ИндексГода <> Неопределено Тогда
			
			НомерГода = ИндексГода + 1;
			Для каждого СведенияМесяца Из СведенияОГоде.Значение Цикл
				
				НомерМесяца = СведенияМесяца.Ключ;
				
				Если СведенияМесяца.Значение.Сумма <> 0 Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
						ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца, СведенияМесяца.Значение.Сумма);
				КонецЕсли; 
					
				Если СведенияМесяца.Значение.ДнейБолезниУходаЗаДетьми <> 0 Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
						ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца, СведенияМесяца.Значение.ДнейБолезниУходаЗаДетьми);
				КонецЕсли; 
					
			КонецЦикла;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();

	СреднийЗаработокИтог = УчетПособийСоциальногоСтрахования.СреднийДневнойЗаработокФСС(ПараметрыРасчета);
	МинимальныйСреднедневнойЗаработок = УчетПособийСоциальногоСтрахования.МинимальныйСреднедневнойЗаработокФСС(ПараметрыРасчета);
	
	УстановитьПодсказкуКРасчетуСреднегоЗаработка();
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтаФорма,
		"СреднийЗаработокГруппа",
		"");
		
	СвернутьДанныеДляКраткойФормы(ЭтаФорма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРасчетаСреднегоДневногоЗаработкаФСС()
	
	ПараметрыРасчета = УчетПособийСоциальногоСтрахованияКлиентСервер.ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();
	ПараметрыРасчета.ДатаНачалаСобытия = ДатаНачалаСобытия;
	ПараметрыРасчета.ПериодРасчетаСреднегоЗаработкаНачало = Дата(Год1, 1, 1) ;
	ПараметрыРасчета.ПериодРасчетаСреднегоЗаработкаОкончание = КонецДня(Дата(Год2, 12, 31));
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Год1);
	РасчетныеГоды.Добавить(Год2);

	ПараметрыРасчета.РасчетныеГоды = РасчетныеГоды;
	
	ПараметрыРасчета.НеполныйРасчетныйПериод = УчетПособийСоциальногоСтрахования.ПособиеЗаНеполныйРасчетныйПериод(ФизическоеЛицо, ДатаНачалаСобытия);
	ПараметрыРасчета.ПрименяетсяФЗ_20_2023 	 = УчетПособийСоциальногоСтрахования.ПрименяетсяФЗ_20_2023(ФизическоеЛицо, ДатаНачалаСобытия);
	
	ПараметрыРасчета.ДанныеНачислений = ДанныеОЗаработкеДляРасчетаСреднегоЗаработка();
	ПараметрыРасчета.ДанныеВремени = ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка();
	ПараметрыРасчета.ДанныеСтрахователей = УчетПособийСоциальногоСтрахования.ПустаяТаблицаДанныеСтрахователейСреднийЗаработокФСС();
	ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми = ПричинаНетрудоспособности = Перечисления.ПричиныНетрудоспособности.ПоБеременностиИРодам;
	ПараметрыРасчета.ПрименятьПредельнуюВеличину = ПричинаНетрудоспособности <> Перечисления.ПричиныНетрудоспособности.ТравмаНаПроизводстве
													И ПричинаНетрудоспособности <> Перечисления.ПричиныНетрудоспособности.Профзаболевание; 
	ПараметрыРасчета.ПорядокРасчета = УчетПособийСоциальногоСтрахованияКлиентСервер.ПорядокРасчетаСреднегоЗаработкаФСС(ДатаНачалаСобытия);
	ПараметрыРасчета.РайонныйКоэффициентРФ = РайонныйКоэффициентРФНаНачалоСобытия;
	ПараметрыРасчета.Сотрудник = Сотрудник;
		
	Возврат ПараметрыРасчета;
	
КонецФункции

&НаСервере
Функция ДанныеОЗаработкеДляРасчетаСреднегоЗаработка()
	
	ДанныеОЗаработкеДляРасчетаСреднегоЗаработка = УчетПособийСоциальногоСтрахования.ПустаяТаблицаНачисленийСреднийЗаработокФСС();
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Год1);
	РасчетныеГоды.Добавить(Год2);
	
	ДнейБолезниУходаЗаДетьми = 0;
	
	НомерГода = 1;
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			Период = Дата(Год, НомерМесяца, 1);
			
			СтрокаДанныхОЗаработке = ДанныеОЗаработкеДляРасчетаСреднегоЗаработка.Добавить();
			СтрокаДанныхОЗаработке.ФизическоеЛицо = ФизическоеЛицо;
			СтрокаДанныхОЗаработке.ПорядокРасчета = Перечисления.ПорядокРасчетаСреднегоЗаработкаФСС.Постановление2011;
			СтрокаДанныхОЗаработке.Период = Период;
			
			Сумма = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца);
			СтрокаДанныхОЗаработке.Сумма = Сумма;
			
		КонецЦикла;
		
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
	Возврат ДанныеОЗаработкеДляРасчетаСреднегоЗаработка;
	
КонецФункции

&НаСервере
Функция ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка()
	
	ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка = УчетПособийСоциальногоСтрахования.ПустаяТаблицаОтработанноеВремяСреднийЗаработокФСС();
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Год1);
	РасчетныеГоды.Добавить(Год2);
	
	НомерГода = 1;
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			Период = Дата(Год, НомерМесяца, 1);
			
			СтрокаДанныхОбОтработанномВремени = ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка.Добавить();
			СтрокаДанныхОбОтработанномВремени.ФизическоеЛицо = ФизическоеЛицо;
			СтрокаДанныхОбОтработанномВремени.Период = Период;
			
			ДнейБолезниУходаЗаДетьми = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца);
			СтрокаДанныхОбОтработанномВремени.ДнейБолезниУходаЗаДетьми = ДнейБолезниУходаЗаДетьми;
			
		КонецЦикла;
		
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
	Возврат ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка;
	
КонецФункции

&НаСервере
Процедура УстановитьПодсказкуКРасчетуСреднегоЗаработка()
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Год1);
	РасчетныеГоды.Добавить(Год2);
	
	Итого = 0;
	ИтогоДней = 0;
	НомерГода = 1;
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			Итого = Итого + ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца);
				
			ИтогоДней = ИтогоДней + ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца);

		КонецЦикла;
			
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();
	ДанныеРасчетаСреднего = УчетПособийСоциальногоСтрахованияКлиентСервер.ДанныеРасчетаСреднегоЗаработкаФСС(ПараметрыРасчета);
	КалендарныхДней = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыхДнейВКалендарныхГодахФСС(ПараметрыРасчета, ДанныеРасчетаСреднего);
	
	Если Итого <> 0 Тогда
		
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Среднедневной заработок составил'") + ": %1 / %2 = %3",
			Итого,
			КалендарныхДней,
			Формат(?(КалендарныхДней = 0, 0, Итого/ КалендарныхДней), "ЧДЦ=2"));
			
		ТекстПодсказки = ТекстПодсказки + Символы.ПС + Символы.ПС
		
	Иначе
		ТекстПодсказки = "";
	КонецЕсли;
	
	МРОТ = ЗарплатаКадры.МинимальныйРазмерОплатыТрудаРФ(ДатаНачалаСобытия);
	ТекстПодсказки = ТекстПодсказки
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='На %1 МРОТ'") + ": %2",
			Формат(ДатаНачалаСобытия, "ДЛФ=DD"),
			МРОТ);
	
	Если РайонныйКоэффициентРФНаНачалоСобытия > 1 Тогда
		
		ТекстПодсказки = ТекстПодсказки + Символы.ПС
		+ НСтр("ru='Районный коэффициент'") + ": " + Формат(РайонныйКоэффициентРФНаНачалоСобытия, "ЧДЦ=2");
		
		МРОТ = МРОТ * РайонныйКоэффициентРФНаНачалоСобытия;
		
	КонецЕсли;
	
	Если КалендарныхДней = 0 Тогда
		СреднийМРОТ = 0;
	Иначе
		СреднийМРОТ = МРОТ * 24 / КалендарныхДней;
	КонецЕсли;
	
	ТекстПодсказки = ТекстПодсказки + Символы.ПС
		+ НСтр("ru='Минимальный средний заработок исходя из МРОТ составил'") + ": " + Формат(СреднийМРОТ, "ЧДЦ=2");
		
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтаФорма, "СреднийЗаработокИтог", ТекстПодсказки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСреднийЗаработокФСС(СреднийЗаработокФСС, ОтработанноеВремяДляСреднегоФСС)
	
	ДопустимРежимКраткогоВвода = Истина;
	Для каждого СтрокаСреднегоЗаработкаФСС  Из СреднийЗаработокФСС Цикл
		
		Год = Год(СтрокаСреднегоЗаработкаФСС.Период);
		Если Год = Год1 Тогда
			ИндексГода = 0;
		ИначеЕсли Год = Год2 Тогда
			ИндексГода = 1;
		Иначе
			ИндексГода = Неопределено;
		КонецЕсли;
			
		Если ИндексГода <> Неопределено Тогда
			
			НомерГода = ИндексГода + 1;
			НомерМесяца = Месяц(СтрокаСреднегоЗаработкаФСС.Период);
			
			Если НомерМесяца <> 1 И СтрокаСреднегоЗаработкаФСС.Сумма <> 0 Тогда
				ДопустимРежимКраткогоВвода = Ложь;
			КонецЕсли; 
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "Месяц" + НомерМесяца, СтрокаСреднегоЗаработкаФСС.Сумма);
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Для каждого СтрокаОтработанногоВремени Из ОтработанноеВремяДляСреднегоФСС Цикл
		
		Год = Год(СтрокаОтработанногоВремени.Период);
		Если Год = Год1 Тогда
			ИндексГода = 0;
		ИначеЕсли Год = Год2 Тогда
			ИндексГода = 1;
		Иначе
			ИндексГода = Неопределено;
		КонецЕсли;
			
		Если ИндексГода <> Неопределено Тогда
			
			НомерГода = ИндексГода + 1;
			НомерМесяца = Месяц(СтрокаОтработанногоВремени.Период);
			
			Если НомерМесяца <> 1 И СтрокаОтработанногоВремени.ДнейБолезниУходаЗаДетьми <> 0 Тогда
				ДопустимРежимКраткогоВвода = Ложь;
			КонецЕсли; 
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				ЭтаФорма, "Год" + НомерГода + "ДниУхода" + НомерМесяца, СтрокаОтработанногоВремени.ДнейБолезниУходаЗаДетьми);
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Если Не ДопустимРежимКраткогоВвода Тогда
		РежимПодробногоВводаСреднегоЗаработка = Истина;
	КонецЕсли;
	
	УстановитьОтображениеКраткойПодробнойФормыВвода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРасчетногоГода(ИндексГода)
	
	МаксимальноВозможныйГод = Год(ДатаНачалаСобытия) - 1;
	Если ИндексГода = 0 Тогда
		
		Если Год1 >= Год2 Тогда
			
			Год2 = Мин(МаксимальноВозможныйГод, Год1 + 1);
			
			Если Год2 = МаксимальноВозможныйГод Тогда
				Год1 = Год2 - 1;
			КонецЕсли;
			
		КонецЕсли; 
		
	Иначе
		
		Если Год2 > МаксимальноВозможныйГод Тогда
			Год2 = МаксимальноВозможныйГод;
		КонецЕсли;
		
		Если Год2 <= Год1 Тогда
			
			Если Год1 = 1 Тогда
				Год2 = 2;
			Иначе
				Год1 = Год2 - 1;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НастроитьМаксимальноеКоличествоДнейВФевраля(ЭтаФорма);
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтаФорма,
		"СреднийЗаработокГруппа",
		НСтр("ru='После изменения годов, за которые рассчитывается
			|средний заработок необходимо перезаполнить данные'"));
	
КонецПроцедуры

&НаСервере
Процедура ГодМесяцПриИзмененииНаСервере()
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();
	СреднийЗаработокИтог = УчетПособийСоциальногоСтрахования.СреднийДневнойЗаработокФСС(ПараметрыРасчета);
	МинимальныйСреднедневнойЗаработок = УчетПособийСоциальногоСтрахования.МинимальныйСреднедневнойЗаработокФСС(ПараметрыРасчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьМаксимальноеКоличествоДнейВФевраля(Форма)
	
	КоличествоДней = ЗарплатаКадрыКлиентСервер.КоличествоДнейМесяца(Дата(Форма.Год1,2,1));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Год1ДниУхода2",
		"МаксимальноеЗначение",
		КоличествоДней);
	
	ТекущееКоличество = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Год1ДниУхода2");
	Если ТекущееКоличество > КоличествоДней Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
			Форма, "Год1ДниУхода2", КоличествоДней);
	КонецЕсли;
	
	КоличествоДней = ЗарплатаКадрыКлиентСервер.КоличествоДнейМесяца(Дата(Форма.Год2,2,1));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Год2ДниУхода2",
		"МаксимальноеЗначение",
		КоличествоДней);
	
	ТекущееКоличество = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Год2ДниУхода2");
	Если ТекущееКоличество > КоличествоДней Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
			Форма, "Год2ДниУхода2", КоличествоДней);
	КонецЕсли;
	
	УстановитьКоличествоДнейПервыхМесяцев(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СвернутьДанныеДляКраткойФормы(Форма)
	
	Если Форма.РежимПодробногоВводаСреднегоЗаработка Тогда
		Возврат;
	КонецЕсли; 
	
	Для НомерГода = 1 По 2 Цикл
		
		СуммаПоГоду = 0;
		СуммаДнейПоГоду = 0;
		Для НомерМесяца = 1 По 12 Цикл
			
			СуммаПоГоду = СуммаПоГоду + ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				Форма, "Год" + НомерГода + "Месяц" + НомерМесяца);
				
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				Форма, "Год" + НомерГода + "Месяц" + НомерМесяца, 0);
				
			СуммаДнейПоГоду = СуммаДнейПоГоду + ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
				Форма, "Год" + НомерГода + "ДниУхода" + НомерМесяца);
				
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				Форма, "Год" + НомерГода + "ДниУхода" + НомерМесяца, 0);
				
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
			Форма, "Год" + НомерГода + "Месяц1", СуммаПоГоду);
				
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
			Форма, "Год" + НомерГода + "ДниУхода1", СуммаДнейПоГоду);
				
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеКраткойПодробнойФормыВвода()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Месяцы",
		"Видимость",
		РежимПодробногоВводаСреднегоЗаработка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПервыйГодМесяцыСо2По12",
		"Видимость",
		РежимПодробногоВводаСреднегоЗаработка);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПервыйГодДниСо2По12",
		"Видимость",
		РежимПодробногоВводаСреднегоЗаработка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВторойГодМесяцыСо2По12",
		"Видимость",
		РежимПодробногоВводаСреднегоЗаработка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВторойГодДниСо2По12",
		"Видимость",
		РежимПодробногоВводаСреднегоЗаработка);
	
	УстановитьКоличествоДнейПервыхМесяцев(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКоличествоДнейПервыхМесяцев(Форма)
	
	Если Форма.РежимПодробногоВводаСреднегоЗаработка Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год1ДниУхода1",
			"МаксимальноеЗначение",
			31);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год2ДниУхода1",
			"МаксимальноеЗначение",
			31);
		
	Иначе
		
		КоличествоДней = ДеньГода(Дата(Форма.Год1,12,31));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год1ДниУхода1",
			"МаксимальноеЗначение",
			КоличествоДней);
		
		КоличествоДней = ДеньГода(Дата(Форма.Год2,12,31));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год2ДниУхода1",
			"МаксимальноеЗначение",
			КоличествоДней);
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти