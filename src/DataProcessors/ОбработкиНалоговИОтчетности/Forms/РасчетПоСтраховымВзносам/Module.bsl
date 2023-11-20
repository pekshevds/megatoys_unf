#Область ОписаниеПеременных

&НаКлиенте
Перем ШиринаКнопкиОтправить;

&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#КонецОбласти


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Если ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		Иначе
			Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Организация = Справочники.Организации.ПредопределеннаяОрганизация();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СобытиеКалендаря) Тогда
		Объект.СобытиеКалендаря = Параметры.СобытиеКалендаря;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СостояниеСобытия) Тогда
		Если ЗначениеЗаполнено(Параметры.СостояниеСобытия) Тогда
			Объект.СостояниеСобытия = Параметры.СостояниеСобытия;
		Иначе
			Объект.СостояниеСобытия = КалендарьОтчетности.ПолучитьСостояниеСобытияКалендаря(
				Объект.Организация,
				Объект.СобытиеКалендаря);
			
		КонецЕсли;
	КонецЕсли;
	
	
	Если НЕ ЗначениеЗаполнено(ДокументОтчетности) Тогда
		Если ЗначениеЗаполнено(Параметры.ДокументОтчетности) Тогда
			ДокументОтчетности = Параметры.ДокументОтчетности;
		Иначе
			ДокументОтчетности = РегламентированнаяОтчетностьУСН.ПолучитьДокументРегламентированнойОтчетностиПоСобытиюКалендаря(Объект.Организация, Объект.СобытиеКалендаря);
		КонецЕсли;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ДоступнаОтправкаРегламентированногоОтчета() Тогда
		ТекущийСпособСдачи = 1;
	Иначе
		Элементы.ОтправитьОтчетностьЧерезИнтернетВыбор.Видимость = Ложь;
		ТекущийСпособСдачи = 2;
	КонецЕсли;
	
	ПереключитьСпособСдачи(ТекущийСпособСдачи);
	
	// Обработка ситуации, если статус отправки "отправлен", то проверяем, нет ли каких-нибудь изменений
	Если Объект.СостояниеСобытия = Перечисления.СостоянияСобытийКалендаря.ПолучитьПодтверждение Тогда
		
		РегламентированнаяОтчетностьУСН.ОбновитьСтатусыОтправленныхОтчетов();
		
		Объект.СостояниеСобытия = КалендарьОтчетности.ПолучитьСостояниеСобытияКалендаря(
				Объект.Организация,
				Объект.СобытиеКалендаря);
	КонецЕсли;
	
	ДатаСменыСостояния = КалендарьОтчетности.ПолучитьДатуСменыСостояния(Объект.Организация, Объект.СобытиеКалендаря);
	
	Заголовок = Объект.СобытиеКалендаря.Наименование;
	
	УстановитьПривилегированныйРежим(Истина);
	РежимИспользованияИБ = Константы.РежимИспользованияИнформационнойБазы.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ИспользуетсяДКО = Истина;
	
	Если РежимИспользованияИБ = Перечисления.РежимыИспользованияИнформационнойБазы.Демонстрационный Тогда
		Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Отправить (в демо не доступно)'");
		Элементы.ОтправитьВКонтролирующийОрган.Доступность = Ложь
	Иначе
		
		ПроверитьВозможностьОтправки();
		
	КонецЕсли;
	
	ДатыСобытия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СобытиеКалендаря, "ДатаНачалаДокументов,ДатаОкончанияДокументов");
	
	ПериодЗадачиПредставление = ПредставлениеПериода(
		ДатыСобытия.ДатаНачалаДокументов,
		КонецДня(ДатыСобытия.ДатаОкончанияДокументов),
		"ФП=Истина");
		
	Элементы.ДекорацияОтступ18.Видимость = Элементы.ЗапроситьНаличиеОтвета.Видимость;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьТекущуюЗакладку(ЭтаФорма, Объект);
	УстановитьЗаголовокФормыПоТекущейСтранице();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеПолученияКонтекста", ЭтаФорма);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПослеПолученияКонтекста(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПрикрепленаДоверенность" И Параметр = Объект.Организация Тогда
		Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Идет проверка доверенности'");
	ИначеЕсли ИмяСобытия = "ИзмененаЗаявкаЭДО" Тогда
		Если Параметр.Организация = Объект.Организация Тогда
			Если Параметр.ЕстьАктуальнаяЗаявка Тогда
				Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Отправить'");
				Элементы.ОтправитьВКонтролирующийОрган.Доступность = Истина;
				Элементы.ОформитьЗаявку.Видимость = Ложь;
			Иначе
				Элементы.ОтправитьВКонтролирующийОрган.Доступность = Ложь;
				Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Отправить (нет заявки)'");
				Элементы.ОформитьЗаявку.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ИзмененаТекущаяОрганизация" Тогда
		Если Окно.Основное Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/navigationpoint/НалогиИОтчетность");
		Иначе
			Закрыть();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ИзменениеСостоянияСобытияКалендаря" Тогда
		Если Параметр = Объект.СобытиеКалендаря
				И Источник <> ЭтаФорма
				И Окно<> Неопределено
				И Не Окно.Основное Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "СозданоЗаявлениеНаПодключениеКЭДОСКО" Тогда
		ПроверитьВозможностьОтправки();
	КонецЕсли;
	
КонецПроцедуры



///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОтправитьОтчетностьЧерезИнтернетВыбор(Команда)
	
	Если ТекущийСпособСдачи = 2 Тогда
		ПереключитьСпособСдачи(1);
	Иначе
		ШиринаКнопкиОтправить = 5;
		ПодключитьОбработчикОжидания("АнимацияОтправить", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодатьОтчетностьСамостоятельно(Команда)
	
	Если ТекущийСпособСдачи = 1 Тогда
		ПереключитьСпособСдачи(2);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлВыгрузки(Команда)
	
	РегламентированнаяОтчетностьУСНКлиент.СохранитьФайлВыгрузкиОтчетности(ДокументОтчетности);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьДекларацию(Команда)
	
	РегламентированнаяОтчетностьУСНКлиент.РаспечататьМашиночитаемыйРегламентированныйОтчет(ДокументОтчетности);
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиСдачи(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьПротоколОтправки(ДокументОтчетности);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьЗаявку(Команда)
	
	ОткрытьФорму("Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.МастерФормированияЗаявкиНаПодключениеУпрощенное",
		Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	ВыбранныеОрганизации = Новый Массив(1);
	ВыбранныеОрганизации[0] = Объект.Организация;	
	
	
	Если ВыбранныеОрганизации.Количество() = 0 Тогда
		ПоказатьПредупреждение(,"Учетная запись не выбрана.");
		Возврат;
	ИначеЕсли ВыбранныеОрганизации.Количество() = 1 Тогда
		ТекстВопроса = НСтр("ru='Информация будет запрошена по всем отчетам, ожидающим подтверждения'");
	Иначе
		ТекстВопроса = "Произвести обмен сообщениями по выбранным учетным записям?";
	КонецЕсли;
	
	ПоказатьПредупреждение(,ТекстВопроса);
	
	
	// получаем массив учетных записей по массиву организаций
	ВыбранныеУчетныеЗаписи = ПолучитьМассивУчетныхЗаписей(ВыбранныеОрганизации);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОбменаПоУчетнойЗаписиЗавершение", ЭтаФорма);
	
	// последовательно для каждой учетной записи производим обмен
	Для Каждого ВыбраннаяУчетнаяЗапись Из ВыбранныеУчетныеЗаписи Цикл
		КонтекстЭДОКлиент.ОсуществитьОбменПоУчетнойЗаписи(ОписаниеОповещения, ВыбраннаяУчетнаяЗапись);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбменаПоУчетнойЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
		ПроверитьСтатусОтчета();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусОтчета()
	
	РегламентированнаяОтчетностьУСН.ОбновитьСтатусыОтправленныхОтчетов();
	
	Объект.СостояниеСобытия = КалендарьОтчетности.ПолучитьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря);
	
	УстановитьТекущуюЗакладку(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивУчетныхЗаписей(ВыбранныеОрганизации)
	
	// получаем массив учетных записей по массиву организаций
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДО.УчетныеЗаписиПоОрганизациям(ВыбранныеОрганизации);
	
КонецФункции

&НаКлиенте
Процедура ИсторияОбмена(Команда)
	ПоказатьЗначение(,ПолучитьЦиклОбмена(ДокументОтчетности));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЦиклОбмена(Док) 
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЦиклыОбмена.Ссылка
	|ИЗ
	|	Справочник.ЦиклыОбмена КАК ЦиклыОбмена
	|ГДЕ
	|	ЦиклыОбмена.Предмет = &ДокРО
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЦиклыОбмена.ДатаСоздания УБЫВ");
	Запрос.УстановитьПараметр("ДокРО", Док);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции






// -----------------------------------------------------------------------------
// События переходов

&НаКлиенте
Процедура ПереходЗаполнение(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Заполнить");
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		Объект.СостояниеСобытия,
		"");
	
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	ПараметрыФормы = Новый Структура("Организация,СобытиеКалендаря", Объект.Организация,Объект.СобытиеКалендаря);
	
	КалендарьОтчетностиКлиент.ОткрытьФормуНачалаЗаполнения(ЭтаФорма,ПараметрыФормы);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходКОтчетуРСВ(Элемент)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Отправить");
	
	ЗафиксироватьПереходкОтправке(Объект.Организация, Объект.СобытиеКалендаря, Объект.СостояниеСобытия);
	
	ДатаСменыСостояния = ТекущаяДата();
	
	Элементы.СтраницаДекларация.ТекущаяСтраница = Элементы.РасчетПоСтраховымВзносам;
	Элементы.ПереходВыполнил.КнопкаПоУмолчанию = Истина;
	Элементы.Далее.КнопкаПоУмолчанию = Ложь;
	УстановитьЗаголовокФормыПоТекущейСтранице();
	
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗафиксироватьПереходкОтправке(Организация, Событие, Состояние)
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Организация,
		Событие,
		Состояние,
		"");
	
	
	ЗаписьКалендаря = Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьЗаписьКалендаря(Организация, Событие);
	Если ЗаписьКалендаря <> Неопределено Тогда
		ОбъектЗаписьКалендаря = ЗаписьКалендаря.ПолучитьОбъект();
		ОбъектЗаписьКалендаря.Завершено = Ложь;
		ОбъектЗаписьКалендаря.Записать();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПереходВыполнил(Команда)
	
	оп = Новый ОписаниеОповещения("ОповещениеДекларацияПринята", ЭтотОбъект);
	ПоказатьВопрос(оп, НСтр("ru='ИФНС приняла Расчет по страховым взносам?'"), РежимДиалогаВопрос.ДаНет);
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеДекларацияПринята(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Завершено");
	
		КалендарьОтчетности.ЗавершитьСобытиеКалендаряОтчетности(
			Объект.Организация,
			Объект.СобытиеКалендаря,
			"");
		
	ДатаСменыСостояния = ТекущаяДата();	
	
	Элементы.СтраницаДекларация.ТекущаяСтраница = Элементы.ЗадачаВыполнена;
	УстановитьЗаголовокФормыПоТекущейСтранице();
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.ЗаписиКалендаряПодготовкиОтчетности"));
	Оповестить("Запись_ЗаписиКалендаряПодготовкиОтчетности");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРСВ(Команда)
	
	ПоказатьЗначение(,ДокументОтчетности);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьОтчетность(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОЗаполнении",
		ЭтаФорма);
	
	ПоказатьВопрос(ОписаниеОповещения,
		НСтр("ru='Вы подтверждаете, что Расчет по страховым взносам заполнен полностью и корректно?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОЗаполнении(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	// регистрируем заявку на отправку
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтправкаВКонтролирующийОрганПослеОтправки", ЭтаФорма);
	
	Если ИспользуетсяДКО Тогда
		КонтекстЭДОКлиент.ОтправкаРегламентированногоОтчетаВФНС(ДокументОтчетности, ОписаниеОповещения);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаВКонтролирующийОрганПослеОтправки(РезультатОтправки, ДополнительныеПараметры) Экспорт
	
	Если РезультатОтправки Тогда
		ОтправитьОтчетностьНаСервере();
		Элементы.СтраницаДекларация.ТекущаяСтраница = Элементы.ЗадачаОжидатьПодтверждения;
		УстановитьЗаголовокФормыПоТекущейСтранице();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПодтверждениеОтправки(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	// регистрируем заявку на отправку
	
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтправкаВКонтролирующийОрганПослеОтправки", ЭтаФорма);
	
	Если ИспользуетсяДКО Тогда
		КонтекстЭДОКлиент.ОтправкаРегламентированногоОтчетаВФНС(ДокументОтчетности, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ДекорацияЗаявлениеОтправленоОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОбновитьСтатус" Тогда
		оп = Новый ОписаниеОповещения("ОбновлениеСтатусаЗавершение", ЭтаФорма);
		КонтекстЭДОКлиент.ОбновитьСтатусыЗаявленийАбонентов_ИзФормыСписка(, ЭтаФорма.УникальныйИдентификатор, оп,Объект.Организация);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиКСпискуЗаявлений" Тогда
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуСпискаЗаявленийНаПодключение(Объект.Организация);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеСтатусаЗавершение(Результат, ДопПараметры) Экспорт
	ПроверитьВозможностьОтправки();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Завершено");
	
		КалендарьОтчетности.ЗавершитьСобытиеКалендаряОтчетности(
			Объект.Организация,
			Объект.СобытиеКалендаря,
			"");
		
	ДатаСменыСостояния = ТекущаяДата();
	
	Элементы.СтраницаДекларация.ТекущаяСтраница = Элементы.ЗадачаВыполнена;
	УстановитьЗаголовокФормыПоТекущейСтранице();
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.ЗаписиКалендаряПодготовкиОтчетности"));
	Оповестить("Запись_ЗаписиКалендаряПодготовкиОтчетности");
КонецПроцедуры


// Конец событий переходов
// -----------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ПроверитьВозможностьОтправки()
	
	Если НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "УчетнаяЗаписьОбмена")) Тогда
		// Возможно заявление отправлено, но еще не одобрено
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявлениеАбонентаСпецоператораСвязи.Ссылка
		|ИЗ
		|	Документ.ЗаявлениеАбонентаСпецоператораСвязи КАК ЗаявлениеАбонентаСпецоператораСвязи
		|ГДЕ
		|	НЕ ЗаявлениеАбонентаСпецоператораСвязи.ПометкаУдаления
		|	И ЗаявлениеАбонентаСпецоператораСвязи.Организация = &Организация
		|	И ЗаявлениеАбонентаСпецоператораСвязи.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено)";
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Если Запрос.Выполнить().Пустой() Тогда
			Элементы.ОтправитьВКонтролирующийОрган.Доступность = Ложь;
			Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Отправить (нет заявки)'");
			Элементы.ОформитьЗаявку.Видимость = Истина;
			Элементы.ДекорацияЗаявлениеОтправлено.Видимость = Ложь;
		Иначе
			
			Элементы.ОтправитьВКонтролирующийОрган.Доступность = Ложь;
			Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Отправить (нет заявки)'");
			Элементы.ОформитьЗаявку.Видимость = Ложь;
			Элементы.ДекорацияЗаявлениеОтправлено.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтправитьВКонтролирующийОрган.Заголовок = НСтр("ru='Отправить'");
		Элементы.ОтправитьВКонтролирующийОрган.Доступность = Истина;
		Элементы.ОформитьЗаявку.Видимость = Ложь;
		Элементы.ДекорацияЗаявлениеОтправлено.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ОтправитьОтчетностьНаСервере()
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.ПолучитьПодтверждение");
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		Объект.СостояниеСобытия,
		ДокументОтчетности);
		
	ДатаСменыСостояния = ТекущаяДатаСеанса();
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокФормыПоТекущейСтранице()
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.СтраницаДекларация.ТекущаяСтраница.Заголовок, ПериодЗадачиПредставление);
	РегламентированнаяОтчетностьУСНКлиентСервер.УстановитьЗаголовокФормыЗадачи(ЭтаФорма, Объект.Организация);
	
КонецПроцедуры


// 1 - через представителя; 2 - самостоятельно
&НаСервере
Процедура ПереключитьСпособСдачи(СпособСдачи)
	
	Если НЕ РегламентированнаяОтчетностьПереопределяемый.ДоступнаОтправкаРегламентированногоОтчета() Тогда
		СпособСдачи = 2;
	КонецЕсли;
	
	Если СпособСдачи = 1 Тогда
		Элементы.ГруппаПодачиЧерезИнтернетОписание.Видимость = Истина;
		Элементы.ГруппаПодачиСамостоятельноОписание.Видимость = Ложь;
		Элементы.ОтправитьОтчетностьЧерезИнтернетВыбор.Шрифт = Новый Шрифт(Элементы.ОтправитьОтчетностьЧерезИнтернетВыбор.Шрифт,,,Истина);
		Элементы.ПодатьОтчетностьСамостоятельно.Шрифт = Новый Шрифт(Элементы.ПодатьОтчетностьСамостоятельно.Шрифт,,,Ложь);
	Иначе
		Элементы.ГруппаПодачиЧерезИнтернетОписание.Видимость = Ложь;
		Элементы.ГруппаПодачиСамостоятельноОписание.Видимость = Истина;
		Элементы.ОтправитьОтчетностьЧерезИнтернетВыбор.Шрифт = Новый Шрифт(Элементы.ОтправитьОтчетностьЧерезИнтернетВыбор.Шрифт,,,Ложь);
		Элементы.ПодатьОтчетностьСамостоятельно.Шрифт = Новый Шрифт(Элементы.ПодатьОтчетностьСамостоятельно.Шрифт,,,Истина);
	КонецЕсли;
	
	Если ТекущийСпособСдачи = СпособСдачи Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийСпособСдачи = СпособСдачи;
	

КонецПроцедуры

&НаКлиенте
Процедура АнимацияОтправить()
	
	Если ШиринаКнопкиОтправить <= 25 Тогда
		Элементы.ОтправитьВКонтролирующийОрган.Ширина = ШиринаКнопкиОтправить;
		ПодключитьОбработчикОжидания("АнимацияОтправить", 0.2, Истина);
		ШиринаКнопкиОтправить = ШиринаКнопкиОтправить + 5;
	КонецЕсли;
	
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюЗакладку(ЭтаФорма, Объект)
		
	Если Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.ОтчетНеСдан") Тогда
		
		ЭтаФорма.Элементы.СтраницаДекларация.ТекущаяСтраница = ЭтаФорма.Элементы.ЗадачаОзнакомиться;
		
	ИначеЕсли Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Распечатать")
		ИЛИ Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Отправить")
		ИЛИ Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Ознакомиться") Тогда
		
		ЭтаФорма.Элементы.СтраницаДекларация.ТекущаяСтраница = ЭтаФорма.Элементы.РасчетПоСтраховымВзносам;
		ЭтаФорма.Элементы.ПереходВыполнил.КнопкаПоУмолчанию = Истина;
		ЭтаФорма.Элементы.Далее.КнопкаПоУмолчанию = Ложь;
		
		
	ИначеЕсли Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Завершить") Тогда
		
		ЭтаФорма.Элементы.СтраницаДекларация.ТекущаяСтраница = ЭтаФорма.Элементы.ЗадачаПроверена;
		ЭтаФорма.Элементы.ПереходВыполнил.КнопкаПоУмолчанию = Ложь;
		ЭтаФорма.Элементы.Далее.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Завершено") Тогда
		
		ЭтаФорма.Элементы.СтраницаДекларация.ТекущаяСтраница = ЭтаФорма.Элементы.ЗадачаВыполнена;
		
	ИначеЕсли Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.ПолучитьПодтверждение") Тогда
		
		ЭтаФорма.Элементы.СтраницаДекларация.ТекущаяСтраница = ЭтаФорма.Элементы.ЗадачаОжидатьПодтверждения;
		
	Иначе
		
		ЭтаФорма.Элементы.СтраницаДекларация.ТекущаяСтраница = ЭтаФорма.Элементы.РасчетПоСтраховымВзносам;
		ЭтаФорма.Элементы.ПереходВыполнил.КнопкаПоУмолчанию = Истина;
		ЭтаФорма.Элементы.Далее.КнопкаПоУмолчанию = Ложь;
		
	КонецЕсли;

	
КонецПроцедуры


#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, "ФНС");
КонецПроцедуры

#КонецОбласти

