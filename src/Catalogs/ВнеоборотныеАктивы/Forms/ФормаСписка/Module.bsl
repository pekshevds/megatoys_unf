
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураСостоянияВнеоборотныхАктивов = Новый Структура;
	СтруктураСостоянияВнеоборотныхАктивов.Вставить("ПринятКУчету", Перечисления.СостоянияВнеоборотныхАктивов.ПринятКУчету);
	СтруктураСостоянияВнеоборотныхАктивов.Вставить("СнятСУчета", Перечисления.СостоянияВнеоборотныхАктивов.СнятСУчета);
	
	СтруктураСпособыНачисленияАмортизации = Новый Структура;
	СтруктураСпособыНачисленияАмортизации.Вставить("Линейный", Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.Линейный);
	СтруктураСпособыНачисленияАмортизации.Вставить("ПропорциональноОбъемуПродукции", Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции);
	
	ПериодПоследнегоНачисления = ПолучитьПериодПоследнегоНачисления(Организация);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	Состояние = Настройки.Получить("Состояние");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, , ,
		ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, , ,
		ЗначениеЗаполнено(Состояние));
	
	ПериодПоследнегоНачисления = ПолучитьПериодПоследнегоНачисления(Организация);
	
	НастроитьФормуМобильныйКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновлениеТекстаПериодПоследнегоНачисленияАмортизации" Тогда
		ПериодПоследнегоНачисления = ПолучитьПериодПоследнегоНачисления(Организация);
	ИначеЕсли ИмяСобытия = "ОбновлениеСостоянийВнеоборотныхАктивов" Тогда
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, , ,
		ЗначениеЗаполнено(Организация));
	
	ПериодПоследнегоНачисления = ПолучитьПериодПоследнегоНачисления(Организация);
	
	НастроитьФормуМобильныйКлиент();
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, , ,
		ЗначениеЗаполнено(Состояние));
	
	НастроитьФормуМобильныйКлиент();
	
КонецПроцедуры // СостояниеПриИзменении()

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступность();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // СписокПриАктивизацииСтроки()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьКУчету(Команда)
	
	СписокПараметров = Новый Структура("Основание", Элементы.Список.ТекущаяСтрока);
	
	ОткрытьФорму("Документ.ПринятиеКУчетуВА.ФормаОбъекта", СписокПараметров);
	
КонецПроцедуры // ПринятьКУчету()

&НаКлиенте
Процедура ИзменитьПараметры(Команда)
	
	СписокПараметров = Новый Структура("Основание", Элементы.Список.ТекущаяСтрока);
	
	ОткрытьФорму("Документ.ИзменениеПараметровВА.ФормаОбъекта", СписокПараметров);
	
КонецПроцедуры // ИзменитьПараметры()

&НаКлиенте
Процедура НачислитьАмортизацию(Команда)
	
	СписокПараметров = Новый Структура("Основание", Организация);
	
	ОткрытьФорму("Документ.АмортизацияВА.ФормаОбъекта", СписокПараметров);
	
КонецПроцедуры // НачислитьАмортизацию()

&НаКлиенте
Процедура Продать(Команда)
	
	СписокПараметров = Новый Структура("Основание",  Элементы.Список.ТекущаяСтрока);
	
	ОткрытьФорму("Документ.ПередачаВА.ФормаОбъекта", СписокПараметров);
	
КонецПроцедуры // Продать()

&НаКлиенте
Процедура Списать(Команда)
	
	СписокПараметров = Новый Структура("Основание",  Элементы.Список.ТекущаяСтрока);
	
	ОткрытьФорму("Документ.СписаниеВА.ФормаОбъекта", СписокПараметров);
	
КонецПроцедуры // Списать()

&НаКлиенте
Процедура ВвестиВыработку(Команда)
	
	СписокПараметров = Новый Структура("Основание",  Элементы.Список.ТекущаяСтрока);
	
	ОткрытьФорму("Документ.ВыработкаВА.ФормаОбъекта", СписокПараметров);
	
КонецПроцедуры // ВвестиВыработку()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает доступность элементов формы.
//
&НаКлиенте
Процедура УстановитьДоступность()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ ТекущиеДанные.Свойство("ГруппировкаСтроки")
			  И ЗначениеЗаполнено(ТекущиеДанные.Состояние)
			  И ТекущиеДанные.Состояние = СтруктураСостоянияВнеоборотныхАктивов.ПринятКУчету Тогда
			
			Элементы.СписокИзменитьПараметры.Доступность = Истина;
			Элементы.СписокСписать.Доступность = Истина;
			Элементы.СписокПродать.Доступность = Истина;
			Если ТекущиеДанные.СпособАмортизации = СтруктураСпособыНачисленияАмортизации.ПропорциональноОбъемуПродукции Тогда
				Элементы.СписокВвестиВыработку.Доступность = Истина;
			Иначе
				Элементы.СписокВвестиВыработку.Доступность = Ложь;
			КонецЕсли;
			Элементы.СписокПринятьКУчету.Доступность = Ложь;
			
		ИначеЕсли НЕ ТекущиеДанные.Свойство("ГруппировкаСтроки")
			  И ЗначениеЗаполнено(ТекущиеДанные.Состояние)
			  И ТекущиеДанные.Состояние = СтруктураСостоянияВнеоборотныхАктивов.СнятСУчета Тогда
			
			Элементы.СписокИзменитьПараметры.Доступность = Ложь;
			Элементы.СписокСписать.Доступность = Ложь;
			Элементы.СписокПродать.Доступность = Ложь;
			Элементы.СписокВвестиВыработку.Доступность = Ложь;
			Элементы.СписокПринятьКУчету.Доступность = Ложь;
			
		ИначеЕсли НЕ ТекущиеДанные.Свойство("ГруппировкаСтроки")
			  И ЗначениеЗаполнено(ТекущиеДанные.Состояние)
			  И ТекущиеДанные.Состояние = "Не принят к учету" Тогда
			
			Элементы.СписокИзменитьПараметры.Доступность = Ложь;
			Элементы.СписокСписать.Доступность = Ложь;
			Элементы.СписокПродать.Доступность = Ложь;
			Элементы.СписокВвестиВыработку.Доступность = Ложь;
			Элементы.СписокПринятьКУчету.Доступность = Истина;
			
		Иначе
			
			Элементы.СписокИзменитьПараметры.Доступность = Ложь;
			Элементы.СписокСписать.Доступность = Ложь;
			Элементы.СписокПродать.Доступность = Ложь;
			Элементы.СписокВвестиВыработку.Доступность = Ложь;
			Элементы.СписокПринятьКУчету.Доступность = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьДоступность()

// Функция получает период последнего начисления амортизации.
//
&НаСервереБезКонтекста
Функция ПолучитьПериодПоследнегоНачисления(Знач Организация)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВнеоборотныеАктивы.Период КАК Дата
	|ИЗ
	|	РегистрНакопления.ВнеоборотныеАктивы КАК ВнеоборотныеАктивы
	|ГДЕ
	|	ВнеоборотныеАктивы.Организация = &Организация
	|	И ТИПЗНАЧЕНИЯ(ВнеоборотныеАктивы.Регистратор) = ТИП(Документ.АмортизацияВА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВнеоборотныеАктивы.Период УБЫВ");
	
	Организация = ?(ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"), Организация, Справочники.Организации.ОрганизацияПоУмолчанию());
	
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат СтрШаблон(НСтр("ru='Последнее начисление: %1'"), Формат(Выборка.Дата, "ДЛФ=DD"));
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции // ПолучитьПериодПоследнегоНачисления()

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура НастроитьФормуМобильныйКлиент()
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ГруппаПанели.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
