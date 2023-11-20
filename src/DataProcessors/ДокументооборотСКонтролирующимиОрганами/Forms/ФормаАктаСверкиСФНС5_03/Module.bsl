&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресФайла = Параметры.АдресФайла;
	ЗапросИОН  = Параметры.ЗапросИОН;
	Если Не ЗначениеЗаполнено(АдресФайла) Тогда
		Возврат;
	КонецЕсли;
	
	НапечататьАкт();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АктСверкиТаблицаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ФормаРасшифровкиАктаСверкиСФНС5_03",
		Новый Структура("АдресФайла, Расшифровка", АдресФайла, Расшифровка),
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НапечататьАкт()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	XDTO = XDTOАктаСверки(АдресФайла);
	
	АктыСверки = СписокИзXDTO(XDTO.Документ, "АктСвер");
	
	ПерваяИтерация = Истина;
	ЕстьДанные = Ложь;
	Для Каждого АктСвер Из АктыСверки Цикл
		
		Если НЕ ПерваяИтерация Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПерваяИтерация = Ложь;
		
		ЕстьАкт = СформироватьТабДокАктСвер(XDTO, АктСвер);
		Если ЕстьАкт Тогда
			ЕстьДанные = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьДанные Тогда
		ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		КонтекстЭДОСервер.ДобавитьШтампПодписиВРезультатЗапросаИОН(ЗапросИОН, ТабДок, 3, Ложь);
	Иначе
		МакетАкта = КонтекстЭДОСервер.ПолучитьМакет("АктСверкиСФНС5_03");
		Область = МакетАкта.ПолучитьОбласть("ДанныеОтсутствуют");
		ТабДок.Вывести(Область);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция XDTOАктаСверки(АдресХранилища) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.XDTOАктаСверки(АдресХранилища);
	
КонецФункции

&НаСервере
Процедура ВывестиШапку(МакетАкта, XDTO, АктСвер) Экспорт
	
	Шапка = МакетАкта.ПолучитьОбласть("Шапка");
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ЗаполнитьШапкуАктаСверки(Шапка, XDTO, АктСвер);
	
	ТабДок.Вывести(Шапка);

КонецПроцедуры

&НаСервере
Процедура ВывестиШапкуТаблицы(ТабДокАкта, МакетАкта, АктСвер, Префикс) Экспорт
	
	ШапкаТаблицы = МакетАкта.ПолучитьОбласть("ШапкаТаблицы" + Префикс);
	ШапкаТаблицы.Параметры.ДатаНачала = АктСвер.ДатаНачПериод;
	ШапкаТаблицы.Параметры.ДатаОкончания = АктСвер.ДатаКонПериод;
	
	ТабДокАкта.Вывести(ШапкаТаблицы);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабДокАктСвер(XDTO, АктСвер) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	МакетАкта = КонтекстЭДОСервер.ПолучитьМакет("АктСверкиСФНС5_03");
	
	Префикс = "АктПризнЕНП";
	Колонки = ЧисловыеКолонкиТаблицыЕНП();
	Таблица = ЗаполнитьТаблицуИзXDTO(АктСвер, Колонки, Префикс);
	РезультатЕНП = СформироватьТабДокТекущегоАкта(МакетАкта, АктСвер, Таблица, Колонки, Префикс);
	
	Префикс = "АктНеЕНП";
	Колонки = ЧисловыеКолонкиТаблицыНеЕНП();
	Таблица = ЗаполнитьТаблицуИзXDTO(АктСвер, Колонки, Префикс);
	РезультатНеЕНП = СформироватьТабДокТекущегоАкта(МакетАкта, АктСвер, Таблица, Колонки, Префикс);
	
	Если РезультатЕНП.ЕстьДанные ИЛИ РезультатНеЕНП.ЕстьДанные Тогда
		
		ВывестиШапку(МакетАкта, XDTO, АктСвер);
		
		Если РезультатЕНП.ЕстьДанные Тогда
			ТабДок.Вывести(РезультатЕНП.ТабДок);
		КонецЕсли;
		
		Если РезультатНеЕНП.ЕстьДанные Тогда
			ТабДок.Вывести(РезультатНеЕНП.ТабДок);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РезультатЕНП.ЕстьДанные ИЛИ РезультатНеЕНП.ЕстьДанные;
	
КонецФункции

&НаСервере
Функция СтрокаТаблицыЕНП_Всего(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Всего();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	НоваяСтрока.Начислено = ДанНО(ТекущийАкт.Начислено, "НачисленоВсего");
	НоваяСтрока.Уменьшено = ДанНО(ТекущийАкт.Уменьшено, "УменьшеноВсего");
	НоваяСтрока.ПоступилоЕНП = ДанНО(ТекущийАкт, "ПоступЕНП");
	НоваяСтрока.РаспределеноЕНП = ДанНО(ТекущийАкт.РаспрЕНПДекл, "РаспрЕНПДеклВсего");
	НоваяСтрока.Передано = ДанНО(ТекущийАкт, "ПрдСальдоРЮЛ");
	НоваяСтрока.Принято = ДанНО(ТекущийАкт, "ПринСальдоРЮЛ");
	НоваяСтрока.Списано = 
		ДанНО(ТекущийАкт, "СпЗадолжПен")
		+ ДанНО(ТекущийАкт, "СпЗадолжШтр")
		+ ДанНО(ТекущийАкт, "СписЗадолжПр");
	НоваяСтрока.Возвращено = ДанНО(ТекущийАкт.Возвращено, "ВозвращеноВсего");
	НоваяСтрока.Отсроченные = ДанНО(ТекущийАкт, "ОтсрРассрПлат");
	НоваяСтрока.ПриостановленныеПоБанкротству = ДанНО(ТекущийАкт, "ПриостПлатБанкр");
	НоваяСтрока.ПриостановленныеПоСуду = ДанНО(ТекущийАкт, "ПриостПлатРешен");
	
КонецФункции
	
&НаСервере
Функция СтрокаТаблицыЕНП_Налог(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Налог();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	НоваяСтрока.Начислено = ДанНО(ТекущийАкт.Начислено, "Налог");
	НоваяСтрока.Уменьшено = ДанНО(ТекущийАкт.Уменьшено, "Налог");
	НоваяСтрока.РаспределеноЕНП = ДанНО(ТекущийАкт.РаспрЕНПДекл, "Налог");
	НоваяСтрока.Возвращено = ДанНО(ТекущийАкт.Возвращено, "Налог");
		
КонецФункции

&НаСервере
Функция СтрокаТаблицыЕНП_Пеня(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Пеня();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	НоваяСтрока.Начислено = ДанНО(ТекущийАкт.Начислено, "Пени");
	НоваяСтрока.Уменьшено = ДанНО(ТекущийАкт.Уменьшено, "Пени");
	НоваяСтрока.РаспределеноЕНП = ДанНО(ТекущийАкт.РаспрЕНПДекл, "Пени");
	НоваяСтрока.Списано = ДанНО(ТекущийАкт, "СпЗадолжПен");
	НоваяСтрока.Возвращено = ДанНО(ТекущийАкт.Возвращено, "Пени");
		
КонецФункции

&НаСервере
Функция СтрокаТаблицыЕНП_Штрафы(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Штраф();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	НоваяСтрока.Начислено = ДанНО(ТекущийАкт.Начислено, "Штраф");
	НоваяСтрока.Уменьшено = ДанНО(ТекущийАкт.Уменьшено, "Штраф");
	НоваяСтрока.РаспределеноЕНП = ДанНО(ТекущийАкт.РаспрЕНПДекл, "Штраф");
	НоваяСтрока.Списано = ДанНО(ТекущийАкт, "СпЗадолжШтр");
	НоваяСтрока.Возвращено = ДанНО(ТекущийАкт.Возвращено, "Штраф");
	
КонецФункции

&НаСервере
Функция СтрокаТаблицыЕНП_Прочее(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Прочее();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	НоваяСтрока.Начислено = 
		ДанНО(ТекущийАкт.Начислено, "ПроцСт") 
		+ ДанНО(ТекущийАкт.Начислено, "ПроцБанкр");
	НоваяСтрока.Уменьшено = ДанНО(ТекущийАкт.Уменьшено, "ПроцСт");
	НоваяСтрока.РаспределеноЕНП = 
		ДанНО(ТекущийАкт.РаспрЕНПДекл, "Остат") 
		+ ДанНО(ТекущийАкт.РаспрЕНПДекл, "ПроцСт") 
		+ ДанНО(ТекущийАкт.РаспрЕНПДекл, "ПроцБанкр");
	НоваяСтрока.Списано = ДанНО(ТекущийАкт, "СписЗадолжПр");
	НоваяСтрока.Возвращено = 
		ДанНО(ТекущийАкт.Возвращено, "Остат")
		+ ДанНО(ТекущийАкт.Возвращено, "ПроцСт")
		+ ДанНО(ТекущийАкт.Возвращено, "ПроцБанкр");
		
КонецФункции

&НаСервере
Функция ДобавитьОКТМОкКБК(Таблица, Область, ТекДанные) Экспорт
	
	ДобавитьОКТМО = ЕстьНесколькоСтрокПоОдномуКБК(Таблица, ТекДанные.КБК);
	Если ДобавитьОКТМО Тогда
		Область.Параметры.Налог = Область.Параметры.Налог + " " + НСтр("ru = 'по ОКТМО'") + " " + ТекДанные.ОКТМО;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СтрокаСВидом(Таблица, КБК, ОКТМО, Вид) Экспорт
	
	Отбор = Новый Структура();
	Отбор.Вставить("КБК", КБК);
	Отбор.Вставить("ОКТМО", ОКТМО);
	Отбор.Вставить("Вид", Вид);
		
	НайденныеСтроки = Таблица.НайтиСтроки(Отбор);
	Возврат НайденныеСтроки[0];
	
КонецФункции

&НаСервере
Функция ЕстьНесколькоСтрокПоОдномуКБК(Таблица, КБК) Экспорт
	
	Отбор = Новый Структура();
	Отбор.Вставить("КБК", КБК);
	Отбор.Вставить("Вид", Всего());
	
	НайденныеСтроки = Таблица.НайтиСтроки(Отбор);
	Возврат НайденныеСтроки.Количество() > 1;
	
КонецФункции

&НаСервере
Функция ВидыДанных()
	
	Виды = Новый Массив;
	Виды.Добавить(Всего());
	Виды.Добавить(Налог());
	Виды.Добавить(Пеня());
	Виды.Добавить(Штраф());
	Виды.Добавить(Прочее());
	
	Возврат Виды;
	
КонецФункции

&НаСервере
Функция СформироватьТабДокТекущегоАкта(МакетАкта, АктСвер, Таблица, Колонки, Префикс) Экспорт
	
	ЕстьДанные = Ложь;
	
	ПарыКБК_ОКТМО = Таблица.Скопировать();
	ПарыКБК_ОКТМО.Свернуть("КБК, ОКТМО");
	ТабДокАкта = Новый ТабличныйДокумент;
	ТабДокАкта.НачатьАвтогруппировкуСтрок();
	
	ЭтоПерваяСтрока = Истина;
	Для Каждого ТекДанные Из ПарыКБК_ОКТМО Цикл
		
		Для каждого Вид Из ВидыДанных() Цикл
			
			Строка = СтрокаСВидом(
				Таблица, 
				ТекДанные.КБК, 
				ТекДанные.ОКТМО, 
				Вид);
				
			ЭтоСтрокаВсего = Вид = Всего();
				
			Если ВсеНули(Строка, Колонки) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЭтоПерваяСтрока Тогда
				ВывестиШапкуТаблицы(ТабДокАкта, МакетАкта, АктСвер, Префикс);
				ЭтоПерваяСтрока = Ложь;
			КонецЕсли;
			
			ЕстьДанные = Истина;
			
			Область = МакетАкта.ПолучитьОбласть(Вид + Префикс);
			Область.Параметры.Заполнить(Строка);
			
			Если ЭтоСтрокаВсего Тогда
				ДобавитьОКТМОкКБК(Таблица, Область, ТекДанные);
			КонецЕсли;

			Область.Параметры.Расшифровка = АктСвер.НомерАкт + "_" + Префикс + "_" +ТекДанные.КБК + "_" + ТекДанные.ОКТМО;
			
			Если ЭтоСтрокаВсего Тогда 
				ТабДокАкта.Вывести(Область, 1,, Истина);
			Иначе
				ТабДокАкта.Вывести(Область, 2,, Истина);
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЦикла;
	ТабДокАкта.ЗакончитьАвтогруппировкуСтрок();
	
	Если ЕстьДанные Тогда
		СформироватьИтоги(ТабДокАкта, МакетАкта, Таблица, Колонки, Префикс);
	КонецЕсли;
	
	Результат = Новый Структура();
	Результат.Вставить("ЕстьДанные", ЕстьДанные);
	Результат.Вставить("ТабДок", ТабДокАкта);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СформироватьИтоги(ТабДокАкта, МакетАкта, Таблица, Колонки, Префикс)
	
	КБК = Таблица.Скопировать();
	КБК.Свернуть("КБК");

	Если КБК.Количество() > 1 Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Вид", Всего());
		
		КолонкиСуммирования = СтрСоединить(Колонки, ", ");
		
		ТаблицаИтогов = Таблица.Скопировать(Отбор);
		ТаблицаИтогов.Колонки.Добавить("Свертка", Новый ОписаниеТипов("Булево"));
		ТаблицаИтогов.Свернуть("Свертка", КолонкиСуммирования);
		
		Область = МакетАкта.ПолучитьОбласть("Итого" + Префикс);
		Область.Параметры.Заполнить(ТаблицаИтогов[0]);
			
		ТабДокАкта.Вывести(Область);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЧисловыеКолонкиТаблицыНеЕНП()
	
	Колонки = Новый Массив;
	Колонки.Добавить("ЗадолженностьНаНачало");
	Колонки.Добавить("ПереплатаНаНачало");
	Колонки.Добавить("НачисленоЗаПериод");
	Колонки.Добавить("УплаченоЗаПериод");
	Колонки.Добавить("ЗадолженностьНаКонец");
	Колонки.Добавить("ПереплатаНаКонец");
	
	Возврат Колонки;
	
КонецФункции

&НаСервере
Функция ЧисловыеКолонкиТаблицыЕНП()
	
	Колонки = Новый Массив;
	Колонки.Добавить("Начислено");
	Колонки.Добавить("Уменьшено");
	Колонки.Добавить("ПоступилоЕНП");
	Колонки.Добавить("РаспределеноЕНП");
	Колонки.Добавить("Передано");
	Колонки.Добавить("Принято");
	Колонки.Добавить("Списано");
	Колонки.Добавить("Возвращено");
	Колонки.Добавить("Отсроченные");
	Колонки.Добавить("ПриостановленныеПоБанкротству");
	Колонки.Добавить("ПриостановленныеПоСуду");
	
	Возврат Колонки;
	
КонецФункции

&НаСервере
Функция СтроковыеКолонкиТаблиц()
	
	Колонки = Новый Массив;
	Колонки.Добавить("Вид");
	Колонки.Добавить("Налог");
	Колонки.Добавить("ОКТМО");
	Колонки.Добавить("КБК");
	
	Возврат Колонки;
	
КонецФункции

&НаСервере
Функция ШаблонТаблицы(ЧисловыеКолонки)
	
	ТипЧисло  = ОбщегоНазначения.ОписаниеТипаЧисло(17, 2);
	ТипСтрока = Новый ОписаниеТипов("Строка");
	
	Таблица = Новый ТаблицаЗначений;
	
	Колонки = СтроковыеКолонкиТаблиц();
	Для каждого Колонка Из Колонки Цикл
		Таблица.Колонки.Добавить(Колонка, ТипСтрока);
	КонецЦикла;
	
	Колонки = ЧисловыеКолонки;
	Для каждого Колонка Из Колонки Цикл
		Таблица.Колонки.Добавить(Колонка, ТипЧисло);
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

&НаСервере
Функция ДанНО(Узел, Поле)
	
	Если ЕстьСвойствоXDTO(Узел, Поле) Тогда
		Возврат ЧислоФНС(Узел[Поле].ДанНО);
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция Всего()
	
	Возврат НСтр("ru = 'Всего'");
	
КонецФункции

&НаСервере
Функция Налог()
	
	Возврат НСтр("ru = 'Налог'");
	
КонецФункции

&НаСервере
Функция Штраф()
	
	Возврат НСтр("ru = 'Штраф'");
	
КонецФункции

&НаСервере
Функция Пеня()
	
	Возврат НСтр("ru = 'Пеня'");
	
КонецФункции

&НаСервере
Функция Прочее()
	
	Возврат НСтр("ru = 'Прочее'");
	
КонецФункции

&НаСервере
Процедура СтрокаТаблицыНеЕНП_Всего(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Всего();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлНач, "ЗадолжППлНачВсего");
	
	НоваяСтрока.ЗадолженностьНаНачало = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаНачало = Переплата(ЗадолжППл);
	НоваяСтрока.НачисленоЗаПериод = 
		ДанНО(ТекущийАкт.Начислено, "НачисленоВсего")
		- ДанНО(ТекущийАкт.Уменьшено, "УменьшеноВсего")
		- ДанНО(ТекущийАкт, "СпЗадолжНалог")
		- ДанНО(ТекущийАкт, "СпЗадолжПен")
		- ДанНО(ТекущийАкт, "СпЗадолжШтр")
		- ДанНО(ТекущийАкт, "СписЗПр")
		- ДанНО(ТекущийАкт.Возвращено, "ВозвращеноВсего")
		- ДанНО(ТекущийАкт.ПрдСальдо, "ПрдСальдоВсего")
		- ДанНО(ТекущийАкт.ПринСальдо, "ПринСальдоВсего");
		
	НоваяСтрока.УплаченоЗаПериод = ДанНО(ТекущийАкт.Уплачено, "УплаченоВсего");
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлКон, "ЗадолжППлКонВсего");
	
	НоваяСтрока.ЗадолженностьНаКонец = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаКонец = Переплата(ЗадолжППл);
		
КонецПроцедуры

&НаСервере
Функция Задолженность(Число)

	Возврат ?(Число < 0, Число, 0);

КонецФункции

&НаСервере
Функция Переплата(Число)

	Возврат ?(Число > 0, Число, 0);

КонецФункции
 

&НаСервере
Процедура СтрокаТаблицыНеЕНП_Налог(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Налог();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлНач, "НалВсего");
	
	НоваяСтрока.ЗадолженностьНаНачало = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаНачало = Переплата(ЗадолжППл);
	НоваяСтрока.НачисленоЗаПериод = 
		ДанНО(ТекущийАкт.Начислено, "Налог")
		- ДанНО(ТекущийАкт.Уменьшено, "Налог")
		- ДанНО(ТекущийАкт, "СпЗадолжНалог")
		- ДанНО(ТекущийАкт.Возвращено, "Налог")
		- ДанНО(ТекущийАкт.ПрдСальдо, "Налог")
		- ДанНО(ТекущийАкт.ПринСальдо, "Налог");
		
	НоваяСтрока.УплаченоЗаПериод = ДанНО(ТекущийАкт.Уплачено, "НалогВсего");
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлКон, "НалВсего");
	
	НоваяСтрока.ЗадолженностьНаКонец = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаКонец = Задолженность(ЗадолжППл);
	
КонецПроцедуры

&НаСервере
Процедура СтрокаТаблицыНеЕНП_Пеня(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Пеня();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлНач, "ПениВсего");
	
	НоваяСтрока.ЗадолженностьНаНачало = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаНачало = Переплата(ЗадолжППл);
	
	НоваяСтрока.НачисленоЗаПериод = 
		ДанНО(ТекущийАкт.Начислено, "Пени")
		- ДанНО(ТекущийАкт.Уменьшено, "Пени")
		- ДанНО(ТекущийАкт, "СпЗадолжПен")
		- ДанНО(ТекущийАкт.Возвращено, "Пени")
		- ДанНО(ТекущийАкт.ПрдСальдо, "Пени")
		- ДанНО(ТекущийАкт.ПринСальдо, "Пени");
		
	НоваяСтрока.УплаченоЗаПериод = ДанНО(ТекущийАкт.Уплачено, "ПенВсего");
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлКон, "ПениВсего");
	
	НоваяСтрока.ЗадолженностьНаКонец = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаКонец = Переплата(ЗадолжППл);
		
КонецПроцедуры

&НаСервере
Процедура СтрокаТаблицыНеЕНП_Штрафы(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Штраф();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлНач, "ШтрафВсего");
	
	НоваяСтрока.ЗадолженностьНаНачало = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаНачало = Переплата(ЗадолжППл);
	
	НоваяСтрока.НачисленоЗаПериод = 
		ДанНО(ТекущийАкт.Начислено, "Штраф")
		- ДанНО(ТекущийАкт.Уменьшено, "Штраф")
		- ДанНО(ТекущийАкт, "СпЗадолжШтр")
		- ДанНО(ТекущийАкт.Возвращено, "Штраф")
		- ДанНО(ТекущийАкт.ПрдСальдо, "Штрафы")
		- ДанНО(ТекущийАкт.ПринСальдо, "Штрафы");

	НоваяСтрока.УплаченоЗаПериод = ДанНО(ТекущийАкт.Уплачено, "ШтрВсего");
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлКон, "ШтрафВсего");
	
	НоваяСтрока.ЗадолженностьНаКонец = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаКонец = Переплата(ЗадолжППл);
	
КонецПроцедуры

&НаСервере
Процедура СтрокаТаблицыНеЕНП_Прочее(ТекущийАкт, Налог, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Вид = Прочее();
	НоваяСтрока.Налог = Налог;
	НоваяСтрока.КБК = ТекущийАкт.КБК;
	НоваяСтрока.ОКТМО = ТекущийАкт.ОКТМО;
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлНач, "НеупСумВс");
	
	НоваяСтрока.ЗадолженностьНаНачало = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаНачало = Переплата(ЗадолжППл);
	
	НоваяСтрока.НачисленоЗаПериод = 
		ДанНО(ТекущийАкт.Начислено, "ПроцБанкр")
		- ДанНО(ТекущийАкт, "СписЗПр")
		- ДанНО(ТекущийАкт.Возвращено, "ПроцБанкр")
		- ДанНО(ТекущийАкт.Возвращено, "Остат")
		- ДанНО(ТекущийАкт.ПрдСальдо, "НеупСум")
		- ДанНО(ТекущийАкт.ПрдСальдо, "ПроцБанкр")
		- ДанНО(ТекущийАкт.ПринСальдо, "НеупСум")
		- ДанНО(ТекущийАкт.ПринСальдо, "ПроцБанкр");

	НоваяСтрока.УплаченоЗаПериод = ДанНО(ТекущийАкт.Уплачено, "ПрВсего");
	
	ЗадолжППл = ДанНО(ТекущийАкт.ЗадолжППлКон, "НеупСумВс");
	
	НоваяСтрока.ЗадолженностьНаКонец = Задолженность(ЗадолжППл);
	НоваяСтрока.ПереплатаНаКонец = Переплата(ЗадолжППл);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьТаблицуИзXDTO(АктСвер, Колонки, Префикс)
	
	СодАкт = СписокИзXDTO(АктСвер, "СодАкт");
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Таблица = ШаблонТаблицы(Колонки);

	НалогиПоКБК = Обработки.ДокументооборотСКонтролирующимиОрганами.ПолучитьМакет("КБК");
	КолонкаКБК = НалогиПоКБК.Область("КБК"); // область таблицы с КБК
	
	Для Каждого ТекущийСодАкт Из СодАкт Цикл
		
		ТекущийАкт = СвойствоXDTO(ТекущийСодАкт, Префикс);
		Если ТекущийАкт = "" Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущийАкт = ТекущийСодАкт[Префикс];
		
		КБК   = ТекущийАкт.КБК;
		Налог = "";
		КонтекстЭДОСервер.ПолучитьНаименованиеНалога(КБК, НалогиПоКБК, КолонкаКБК, Налог);
		
		Если Префикс = "АктПризнЕНП" Тогда
			СтрокаТаблицыЕНП_Всего(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыЕНП_Налог(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыЕНП_Пеня(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыЕНП_Штрафы(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыЕНП_Прочее(ТекущийАкт, Налог, Таблица);
		Иначе
			СтрокаТаблицыНеЕНП_Всего(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыНеЕНП_Налог(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыНеЕНП_Пеня(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыНеЕНП_Штрафы(ТекущийАкт, Налог, Таблица);
			СтрокаТаблицыНеЕНП_Прочее(ТекущийАкт, Налог, Таблица);
		КонецЕсли;
		
	КонецЦикла;
	
	Таблица.Сортировать("Налог");
	
	Возврат Таблица;

КонецФункции

&НаСервере
Функция ВсеНули(Строка, Колонки)
	
	Для каждого Колонка Из Колонки Цикл
		Если Строка[Колонка] <> 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЧислоФНС(Строка)
	
	Результат = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка);
	
	Если Результат = Неопределено Тогда
		Ошибка = НСтр("ru = 'Произошла ошибка при преобразовании строки суммы (%1) в число.'");
		Ошибка = СтрШаблон(Ошибка, Строка);
		Сообщить(Ошибка);
		Возврат 0;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокИзXDTO(Узел, Поле) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.СписокИзXDTO(Узел, Поле); 
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьСвойствоXDTO(Узел, Поле) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.ЕстьСвойствоXDTO(Узел, Поле); 
	
КонецФункции

&НаСервереБезКонтекста
Функция СвойствоXDTO(Узел, Поле) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.СвойствоXDTO(Узел, Поле);
	
КонецФункции

#КонецОбласти
