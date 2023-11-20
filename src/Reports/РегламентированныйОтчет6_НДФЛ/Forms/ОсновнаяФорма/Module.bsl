#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСрокПредставленияОтчетности(Форма)
	
	ПоследнийМесяцПериода = Месяц(Форма.мДатаКонцаПериодаОтчета);
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	СтрСрокПредставления = "Не позднее ";
	Если ПоследнийМесяцПериода = 12 Тогда
		ДатаСрокаПредставления = ?(ГодПериода >= 2022, Дата(ГодПериода + 1, 2, 25), Дата(ГодПериода + 1, 3, 1));
		СтрСрокПредставления = СтрСрокПредставления + Формат(ДатаСрокаПредставления,
		"ДФ=""дд ММММ гггг 'года'""") + " (п.2 ст.230 НК РФ)";
	Иначе
		ДатаСрокаПредставления = ?(ГодПериода >= 2023, Дата(ГодПериода, ПоследнийМесяцПериода + 1, 25),
		КонецМесяца(Дата(ГодПериода, ПоследнийМесяцПериода + 1, 1)));
		СтрСрокПредставления = СтрСрокПредставления + Формат(ДатаСрокаПредставления,
		"ДФ=""дд ММММ гггг 'года'""") + " (п.2 ст.230 НК РФ)";
	КонецЕсли;
	Возврат НСтр("ru='" + СтрСрокПредставления + ".'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	СтрПериодОтчета = ПредставлениеПериода(
		НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
			
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		
	КонецЕсли;
	
	Форма.Элементы.ОткрытьФормуОтчета.КнопкаПоУмолчанию = Форма.Элементы.ОткрытьФормуОтчета.Доступность;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	
	Если ГодПериода >= 2021 Тогда
		
		Форма.Элементы.ГруппаСрокПредставленияОтчета.Видимость = Истина;
		Форма.НадписьСрокПредставленияОтчета = ПолучитьСрокПредставленияОтчетности(Форма);
		
		Форма.Элементы.ГруппаКтоСдаетОтчет.Видимость = Истина;
		Форма.НадписьКтоСдаетОтчет = НСтр("ru='Налоговые агенты (п.1 ст.226 НК РФ).'");
		
		Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = Истина;
		
	Иначе
		
		Форма.Элементы.ГруппаСрокПредставленияОтчета.Видимость = Ложь;
		Форма.НадписьКтоСдаетОтчет = "";
		
		Форма.Элементы.ГруппаКтоСдаетОтчет.Видимость = Ложь;
		Форма.НадписьСрокПредставленияОтчета = "";
		
		Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, 3 * Шаг));
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	ПоказатьПериод(Форма);
	
	Форма.ПолучитьНалоговыеОрганы();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	мТаблицаФормОтчета.Сортировать("ДатаНачалоДействия Убыв");
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		Если Год(мДатаКонцаПериодаОтчета) < 2021 Тогда
			мДатаКонцаПериодаОтчета = КонецМесяца('20210331');
		КонецЕсли;
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	мПериодичность = ПеречислениеПериодичностьКвартал;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	ИзменитьПериод(ЭтаФорма, 0);
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость = Ложь;
		
	КонецЕсли;
	
	ПолучитьНалоговыеОрганы();
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ПолеСсылкаИзмененияЗаконодательства = РегламентированнаяОтчетность.ПредставлениеСсылкиИзмененияЗаконодательства();
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
	= РегламентированнаяОтчетность.ОбщаяЧастьСсылкиНаИзмененияЗаконодательства(ИсточникОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	// Поиск в таблице мТаблицаФормОтчета для определения выбранной формы отчета.
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);
	
	Если МассивСтрок.Количество() > 0 Тогда
		
		ВыбраннаяФорма = МассивСтрок[0];
		мВыбраннаяФорма = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(,НСтр("ru='Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"),
			РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
		РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	Если ФормироватьАвтоматически Тогда
		
		ВыбраныНалоговыеОрганы = Ложь;
		
		Для Каждого НалоговыйОрган Из НалоговыеОрганы Цикл
			
			Если НалоговыйОрган.Пометка Тогда
				
				ВыбраныНалоговыеОрганы = Истина;
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если НЕ ВыбраныНалоговыеОрганы Тогда
			
			ПоказатьПредупреждение(, НСтр("ru='Не выбраны налоговые органы'"));
			
			Возврат;
			
		КонецЕсли;
		
		РезультатЗапуска = СформироватьАвтоматическиРеглОтчет();
		
		Если РезультатЗапуска.Статус = "Выполнено" Тогда
			ОбновитьОтчеты();
			Возврат;
		ИначеЕсли РезультатЗапуска.Статус = "Выполняется" Тогда
			ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьЗавершениеАвтоформированияВФоне", ЭтотОбъект);
			ПараметрыОжидания = ПараметрыОжидания();
			ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатЗапуска, ОповещениеОЗавершении, ПараметрыОжидания);
		КонецЕсли;
		
	Иначе
		
		ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
		Возврат;
	КонецЕсли;
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
		+ ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПостфиксСсылки(мДатаКонцаПериодаОтчета);
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(СсылкаИзмененияЗаконодательства);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
	
		Если ИмяСобытия = ЭтаФорма.Заголовок Тогда
		
			ЭтаФорма.Активизировать();
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьАвтоматическиРеглОтчет()
	
	АдресВоВременномХранилищеРезультатаАвтоформирования
		= ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор);
	
	СписокНО = Новый СписокЗначений;
	
	Для Каждого НалоговыйОрган Из НалоговыеОрганы Цикл
		
		Если НалоговыйОрган.Пометка Тогда
			
			СписокНО.Добавить(НалоговыйОрган.Значение,
							  НалоговыйОрган.Представление,
							  НалоговыйОрган.Пометка,
							  НалоговыйОрган.Картинка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НаименованиеЗадания = НСтр("ru = 'Автоматическое формирование форм 6-НДФЛ'");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИмяОтчета", "РегламентированныйОтчет6_НДФЛ");
	ПараметрыПроцедуры.Вставить("Организация", Организация);
	ПараметрыПроцедуры.Вставить("ДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыПроцедуры.Вставить("ДатаКонцаПериодаОтчета", мДатаКонцаПериодаОтчета);
	ПараметрыПроцедуры.Вставить("ИмяФормыОтчета", мВыбраннаяФорма);
	ПараметрыПроцедуры.Вставить("НалоговыеОрганы", СписокНО);
	ПараметрыПроцедуры.Вставить("АдресВоВременномХранилищеРезультатаАвтоформирования",
		АдресВоВременномХранилищеРезультатаАвтоформирования);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;
	
	РезультатЗапуска = ДлительныеОперации.ВыполнитьВФоне(
	"ИнтерфейсыВзаимодействияБРО.СформироватьАвтоматическиРеглОтчетВФоне", ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
	
	Если РезультатЗапуска.Статус = "Ошибка" Тогда
		ВызватьИсключение РезультатЗапуска.ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	Возврат РезультатЗапуска;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьЗавершениеАвтоформированияВФоне(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Статус = "Выполнено" Тогда
			ОбновитьОтчеты();
		ИначеЕсли Результат.Статус = "Ошибка" Тогда
			ВызватьИсключение Результат.ПодробноеПредставлениеОшибки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОжидания()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Отчеты формируются.'");
	
	Возврат ПараметрыОжидания;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОтчеты()
	
	РезультатАвтоформирования = ПолучитьИзВременногоХранилища(АдресВоВременномХранилищеРезультатаАвтоформирования);
	
	Если РезультатАвтоформирования.Количество() > 0 Тогда
		
		Для Каждого ЭлементМассива Из РезультатАвтоформирования Цикл
			
			Сообщение = Новый СообщениеПользователю;
			Если НЕ ЭтаФорма.ВладелецФормы = Неопределено Тогда
				Сообщение.ИдентификаторНазначения = ЭтаФорма.ВладелецФормы.УникальныйИдентификатор;
			КонецЕсли;
			Сообщение.Текст = ЭлементМассива;
			Сообщение.Сообщить();
			
		КонецЦикла;
		
	КонецЕсли;
		
	Если НЕ ЭтаФорма.ВладелецФормы = Неопределено Тогда
		
		Если ЭтаФорма.ВладелецФормы.ИмяФормы = "ОбщаяФорма.РегламентированнаяОтчетность" Тогда
			
			ЭтаФорма.ВладелецФормы.Элементы.Отчеты.Обновить();
			
		ИначеЕсли ЭтаФорма.ВладелецФормы.ИмяФормы = "Обработка.ОбщиеОбъектыРеглОтчетности.Форма.УправлениеОтчетностью" Тогда
			
			ЭтаФорма.ВладелецФормы.Элементы.ЖурналОтчетов.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНалоговыхОрганов(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		
		Для Каждого НалоговыйОрган Из НалоговыеОрганы Цикл
			
			НалоговыйОрган.Пометка = Ложь;
			
		КонецЦикла;
		
		Если РезультатВыбора.Количество() > 0 Тогда
			
			Для Каждого НалоговыйОрган Из РезультатВыбора Цикл
				
				НайденноеЗначение = НалоговыеОрганы.НайтиПоЗначению(НалоговыйОрган);
				
				Если НЕ НайденноеЗначение = Неопределено Тогда
					
					НайденноеЗначение.Пометка = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьАвтоматическиПриИзменении(Элемент)
	
	Элементы.НалоговыеОрганы.Доступность = ФормироватьАвтоматически;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПолучитьНалоговыеОрганы();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНалоговыеОрганы() Экспорт
	
	Элементы.ГруппаНастройки.Видимость = Ложь;
	
	НалоговыеОрганы.Очистить();
	
	МассивНО = Новый Массив;
	
	РегламентированнаяОтчетностьПереопределяемый.ПолучитьНалоговыеОрганы(
		Организация, мДатаКонцаПериодаОтчета, МассивНО, "РегламентированныйОтчет6_НДФЛ");
	
	Для Каждого НалоговыйОрган Из МассивНО Цикл
		
		ДобавленныйНО = НалоговыеОрганы.Добавить(НалоговыйОрган);
		
		ДобавленныйНО.Пометка = Истина;
		
	КонецЦикла;
	
	Если НалоговыеОрганы.Количество() > 1 И Элементы.ОткрытьФормуОтчета.Доступность Тогда
		
		Элементы.ГруппаНастройки.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыеОрганыНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru='Не выбрана организация'"));
		
		Возврат;
		
	КонецЕсли;
	
	МассивНО = Новый Массив;
	
	Для Каждого НалоговыйОрган Из НалоговыеОрганы Цикл
		
		Если НалоговыйОрган.Пометка Тогда
			
			МассивНО.Добавить(НалоговыйОрган.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначенияДляОтбора = Новый Массив;
	ЗначенияДляОтбора.Добавить(Новый Структура("НалоговыеОрганы", МассивНО));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",       Организация);
	ПараметрыФормы.Вставить("ЗначенияДляОтбора", ЗначенияДляОтбора);
	ПараметрыФормы.Вставить("НалоговыеОрганы",   НалоговыеОрганы);
	
	ФормаВыбораНалоговогоОргана = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени(
	"ФормаВыбораНалоговогоОргана", ПараметрыФормы, ЭтаФорма);
	
	Если НЕ ФормаВыбораНалоговогоОргана.ТаблицаНО.Количество() = 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораНалоговыхОрганов", ЭтотОбъект);
		ФормаВыбораНалоговогоОргана.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
		ФормаВыбораНалоговогоОргана.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ФормаВыбораНалоговогоОргана.Открыть();
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru='В справочник ""Регистрации в налоговом органе"" не добавлены налоговые органы'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти